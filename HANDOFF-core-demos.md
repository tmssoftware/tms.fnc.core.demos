# Handoff: TMS FNC Core 5.0 demos (branch `work/demos`)

Plan: `~/tms.environment/workspaces/delphi/tasks/plans/plan-demos.md` (A13, A14, B27, B28, C14; A1 and A2 go to the UI
Pack demos repository). Tools: `tms.fnc.uipack.demos-theming-demos/tools/democheck.py` (works on this repository with
absolute paths; run it with `PYTHONUTF8=1`, its smoke summary prints the BOM of `error.txt` and dies with a
`UnicodeEncodeError` otherwise). Sources compiled against: `tms.fnc.core-theming` and `tms.fnc.uipack-theming`.
Branch is `work/demos`; nothing committed yet in this session (gate still running).

## Done

- `Shared Code/Business Logic/Demo Layout/UDemoLayout.pas`: the Core version of the UI Pack layout unit.
- A13 **Theme Your Own Control** (FMX, VCL, WEB): compiled D13+D12 Win32; smoke FMX + VCL ok.
- B28 **DataLink CSV and JSON** (FMX, VCL): compiled D13+D12 Win32; smoke FMX + VCL ok.
- B27 **StylesManager** (FMX, VCL): compiled D13+D12 Win32; smoke FMX + VCL ok.
- A14 **HTML Engine** (FMX, VCL, WEB):
  - `Shared Code/Business Logic/HTML Engine/UHTMLSamples.pas` (new): 10 samples (index 0–9) + cache sample
    at index 10. SampleNames covers: All samples, 4.x markup, CSS styling, Tables, Lists, Floats, Theme
    colours, RTL text (dir="rtl"), Inline image (data: URI PNG), Rowspan. `CacheHTML()` for live cache stats.
  - FMX/HTMLEngine and VCL/HTMLEngine: updated to reference shared UHTMLSamples; added RTL/image/rowspan/cache
    samples; `ClearCacheBtn` added programmatically; tested D13+D12 smoke ok.
  - WEB/HTMLEngine (new): `THTMLView` as `TTMSFNCCustomControl`, same API, Themes combobox, samples from shared
    unit, cache section and clear button; compiled WEB ok.
  - READMEs written for FMX, VCL, WEB HTMLEngine folders.
- C14 **Core DataBinding** (FMX, VCL, WEB):
  - FMX/DataBinding: `TMemo` created programmatically, bound to `Notes` with `ReadOnly := True`,
    `ClearOnInsert := False`; `OnBindError` handler (shows error in `TLabel`); wrong-field binding to
    trigger `OnBindError`; compiled D13+D12 smoke ok.
  - VCL/DataBinding: same as FMX + `TStatusBar` created programmatically with indexed path
    `Panels[0].Text` bound to `Common_Name`; error shown in second status panel; compiled D13+D12 smoke ok.
  - WEB/TMSFNCDataBinding: `TWebMemo` bound to `_Notes` with `ReadOnly := True`; `OnBindError` handler
    (shows in `TWebLabel`); compiled WEB ok.
  - READMEs written for all three DataBinding folders.
- `reports/core-demos-findings-coord2.md`: product findings from A14+C14 work.

## Gate / commit status

Gate (`python -I tools/gate.py --skip harness`) was started but is waiting on the heavy lock (another agent
holds it). It will run when the lock frees. Gate command:
```
cd "E:\Delphi\tms.fnc.uipack-theming\Extras\UnitTesting\TMS FNC Theming"
python -I tools/gate.py --skip harness
```
Read `results/gate-*/summary.json` when done.

**After gate passes**, commit all changes on `work/demos`:
```
cd "E:\Delphi\tms.fnc.core.demos-theming-demos"
git add FMX/DataBinding/ VCL/DataBinding/ WEB/TMSFNCDataBinding/ FMX/HTMLEngine/ VCL/HTMLEngine/ WEB/HTMLEngine/ "Shared Code/Business Logic/HTML Engine/" reports/
git commit -m "Core demos 5.0: HTML Engine (RTL, inline images, rowspan, cache, WEB) + DataBinding (OnBindError, ReadOnly, ClearOnInsert, TMemo, indexed path)"
```

Then run code-review on `work/integration..work/demos`.

## Next (remaining plan items)

4. A1 Theme Studio, A2 Brand Studio in `tms.fnc.uipack.demos-theming-demos` (branch `work/demos`, own folders).
5. README lines per folder are written for HTMLEngine and DataBinding; other demos may still need them.

## Harmony findings

Same as previous HANDOFF; see `reports/core-demos-findings-coord2.md` for full list.

## Pitfalls

- `democheck.py --core` must point to `tms.fnc.core-theming` (the product source), NOT to the demos repo.
  Pass absolute project paths: `democheck.py --core "E:\Delphi\tms.fnc.core-theming" compile "E:\...\Demo.dpr"`.
- `democheck.py` global args (`--core`, `--uipack`) must come BEFORE subcommand, project paths AFTER.
- WEB compiler: no `System.` prefix on `Types`, `SysUtils`, `Classes`; use `Types`, `SysUtils`, `Classes` bare.
  `WEBLib.TMSFNCTypes` needed for `TRectF` in interface section of WEB units.
  Duplicate unit names between interface and implementation uses cause "Duplicate identifier" errors on WEB.
- Event handlers on WEB need `@` prefix: `TTMSFNCTheme.AddChangeListener(@ThemeChanged)`;
  `TMSFNCDataBinder1.OnBindError := @DataBinderBindError`.
- Heavy gate waits on the heavy lock; other background agents may hold it. `heavy.py --status` shows the holder.
- `sed -i` in Git Bash rewrites CRLF files as LF: normalise with Python before committing.
- Double UTF-8 BOM (from Write tool + Python encoding fix): strip with Python and write exactly one BOM.
