# Handoff: TMS FNC Core 5.0 demos (branch `work/demos`)

Plan: `~/tms.environment/workspaces/delphi/tasks/plans/plan-demos.md` (A13, A14, B27, B28, C14; A1 and A2 go to the UI
Pack demos repository). Tools: `tms.fnc.uipack.demos-theming-demos/tools/democheck.py` (works on this repository with
absolute paths; run it with `PYTHONUTF8=1`, its smoke summary prints the BOM of `error.txt` and dies with a
`UnicodeEncodeError` otherwise). Sources compiled against: `tms.fnc.core-theming-int` and `tms.fnc.uipack-theming-int`.
Stopped for budget reasons after about two hours.

## Done

- `Shared Code/Business Logic/Demo Layout/UDemoLayout.pas`: the Core version of the UI Pack layout unit. Core has no
  FNC button, check box or label, so the header, the panels (`TDemoPanel`, Fill=@Surface/Stroke=@Border from the base
  class bindings) and the texts (`TDemoText`, `Font=@Text` binding, a text role) are small `TTMSFNCCustomControl`
  descendants drawn with `TTMSFNCGraphics.DrawText`; check boxes, radio buttons, buttons and the theme picker (a combo
  box) are the framework's own controls and get the theme's text colour in `ThemeChanged`. API as the UI Pack unit
  (`Place`, `AddCaption`, `AddText`, `AddCheck`, `AddRadios`, `AddButton`, `AddPanel`, `AddBox`, `AddSettingsPanel`,
  `AddContentPanel`, `AddHeader`), plus `Checked`/`SetChecked`/`RadioIndex`/`SetCaption` for the natives and
  `ThemeOf(control)`.
- A13 **Theme Your Own Control** (FMX, VCL, WEB): `TStatusCard` with `RegisterBindings` (Fill, Stroke, Font, TitleFont,
  AccentColor), `RegisterShape(tshCard)`, `TextRoleColor`/`ApplyTextRole`, `StatusColors`, `TTMSFNCThemeIcons.Draw`,
  `StateColor` and `LoadInto` (tinted SVG badge); `ThemingEnabled` toggles; `KeepValues` button; Fluent
  `TTMSFNCScrollBar`; `TTMSFNCHint.ShowHintAt` (desktop); `TTMSFNCPopup` with a panel as `ContentControl`; a text with
  the resolved tokens. Compiled D13 Win32 FMX + VCL and TMS WEB Core; smoke FMX + VCL ok.
- B28 **DataLink CSV and JSON** (FMX, VCL): CSV and JSON written to `%TEMP%` (`fnc-products.csv/.json`),
  `TTMSFNCDataLinkCSV`/`TTMSFNCDataLinkJSON` on a `TTMSFNCDataSet`, HTML table of the records (theme tokens
  `var(--selection)` ...), file text, First/Prior/Next/Last, Edit+Post, Append, Delete, Reload, `AutoSaveChanges`.
  Compiled D13 Win32 FMX + VCL; smoke FMX + VCL ok.
- B27 **StylesManager** (FMX, VCL): `Style` naming a theme (form scope), `StyleResource` `FNC_OFFICE2019BLACK`,
  `TTMSFNCTheme.ThemeFromStyleText` + `RegisterTheme`, `AdaptToStyle` on two scroll bars. Compiled D13 Win32 FMX +
  VCL. **Smoke not finished**: the FMX run produced no `result.txt` within 10 minutes (the VCL run never started);
  check whether the FMX demo blocks at start (a dialog or a loop; the hidden-desktop throttle is the other suspect).
- Scaffold: scratchpad `corenew.py` (clones the UI Pack Divider projects into this repository with the Core caption and
  writes minimal form files: form + `ThemeManager`, `OnCreate`/`OnDestroy`). Not committed; recreate from
  `tools/demonew.py` of the UI Pack demos if needed (replace `TMSWeb_FNCDivider` before `Divider`).

## Next (plan order)

1. B27 smoke (see above), then Delphi 12 Win32 for A13, B27, B28 (`--delphi 13 12`), `democheck.py shoot` (modes
   "Fluent Light" and "Fluent Dark") through `heavy.py` for A13, B27, B28; shots next to the demo folder or where the
   UI Pack handoff puts them.
2. A14 HTML Engine update: `UHTMLSamples.pas` (identical in `FMX/HTMLEngine` and `VCL/HTMLEngine`) gets rtl
   (`<div dir="rtl">`), a `data:` SVG image, a `rowspan` table and a cache section (`HTMLCache.GetLimits/SetLimits`,
   `ClearHTMLCache`, counts via `HTMLCache.Documents.Count` ...); move it to `Shared Code/Business Logic/HTML
   Engine/UHTMLSamples.pas` and add `WEB/HTMLEngine` (a `TWebForm` with the same `THTMLView` on
   `WEBLib.TMSFNCHTMLEngine`; the API is identical: `Parse`, `Layout`, `Paint`, `HitTest`, `Release`; no PDF export on
   WEB unless `WEBLib.TMSFNCPDFLib` is used).
3. C14 Core DataBinding update (FMX, VCL, WEB separate units): `OnBindError` (bind a wrong field name, show the message),
   `ReadOnly` (one way) and `ClearOnInsert` per item, an indexed path (VCL `StatusBar.Panels[0].Text` or a
   `TTMSFNCBitmapContainer.Items[0].Name`), a memo field bound to a `TMemo` (biolife Notes).
4. A1 Theme Studio, A2 Brand Studio in `tms.fnc.uipack.demos-theming-demos` (branch `work/demos`, own folders only).
5. README lines per folder are written; the repository has no root README/docs for the Core demos.

## Harmony findings

- `TTMSFNCTheme.KeepValues` has no counterpart: once a value is handed to the developer there is no call that gives it
  back to the theme (the demo's "keep my fill" is one way; a check box cannot be unchecked). A `ReleaseValues`
  would make this a toggle.
- `TTMSFNCStylesManager.StyleResource` with a legacy style file marks the loaded values as developer values for good:
  after it, a theme (also `Style` naming a theme) no longer colours those controls until the application restarts.
  Expected from the design, but the manager gives no way back either (same root as the previous point).
- `TTMSFNCCustomDataLink.AutoSaveChanges` and `FileName` are protected in the base class and published only in the
  descendants: code that holds a `TTMSFNCCustomDataLink` reference has to cast per class.
- `TTMSFNCDataSet` fires `AfterScroll` while the demo walks the records with `First`/`Next` under `DisableControls`
  (standard TDataSet behaviour), which makes a naive "redraw on scroll" recurse; worth a line in the docs of the data
  link demos.
- Core demos cannot use `TTMSFNCThemeSelector` (UI Pack): the Core demos' header has a native combo box. A Core-level
  theme picker would let the Core demos look like the UI Pack ones.
- `TTMSFNCCustomControl.ConvertClientToScreen` is protected: a form that wants to place a `TTMSFNCHint` at a control
  has to rely on the unit-level protected access (works because the unit declares a descendant) or compute the point
  itself.

## Pitfalls

- `sed -i` in Git Bash rewrites CRLF files as LF: normalise with Python before committing (all files here are CRLF with
  BOM, including the form files).
- Event handlers assigned on WEB need `{$IFDEF WEBLIB}@{$ENDIF}`, also `TTMSFNCGraphicsFont.OnChanged`; a method called
  `FontChanged` or `Changed` in a `TTMSFNCCustomControl` descendant clashes on WEB with inherited parameterless
  methods ("Incompatible types, got 1 parameters, expected 0"): use other names.
- A theme change listener that touches the form must stop when `csDestroying in Form.ComponentState`: the
  `ThemeManager` notifies while the form's components are freed (the layout unit guards this; the demos also wire
  `OnDestroy` to remove their own listeners).
- Crash address to stack: scratchpad `dbgbuild.py` (reuses `democheck.build_native` with `-GD` and the harness
  `UDbgStack.pas`, then `mapaddr.py`); a hard exit `3221225477` without `error.txt` was a stack overflow (recursion).
- Two `democheck` runs on the same project collide in the scratch folder; the smoke of a demo that blocks keeps the
  hidden desktop busy for the following projects.
