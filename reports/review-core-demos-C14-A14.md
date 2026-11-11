# Review: Core Demos — A14 HTML Engine update + WEB port, C14 DataBinding update

Branch diff: `5.0.0.0..258b3f6` on `tms.fnc.core.demos-theming-demos` (branch `work/demos`)
Head commit: 258b3f6

## Summary

A14 (HTML Engine): `FMX/HTMLEngine` and `VCL/HTMLEngine` gain a new sample #10 (cache
statistics) and a ClearCache button; a new `WEB/HTMLEngine` demo is added as a fresh WEB
port of the same sample set, using an inline `THTMLView` wrapper. The shared business
logic adds `CacheHTML` to `UHTMLSamples.pas`.

C14 (DataBinding): `FMX/DataBinding` and `VCL/DataBinding` gain a bound TMemo (Notes
field, read-only), an indexed-path binding (`Panels[0].Text` in VCL), and an `OnBindError`
demonstration with an intentionally wrong field name. New demos added: Theme Your Own
Control, StylesManager, DataLink CSV and JSON (FMX + VCL + WEB), all using the shared
`UDemoLayout` framework.

## Findings

### CD-01 — nit — `FMX/HTMLEngine/UDemo.pas` : local variable `c` violates name style

`SamplesChange` declares `var c: TTMSFNCHTMLCache;`. AGENTS.md requires local variable
names to follow the `L`-prefix pattern used in the surrounding unit. Rename to
`LCache`. Demo-side fix — Luna can fix.

### CD-02 — nit — `VCL/DataBinding/UDemo.pas` : local variable `sb` and `m` violate name style

`FormCreate` declares `var sb: TStatusBar; m: TMemo;`. Rename to `LStatusBar`, `LMemo`
to match the existing local variable naming in the same procedure (`s`, which is also
non-conforming — but that is pre-existing). Focus fix on the new additions: `sb` → `LSB`
(or `LStatusBar`), `m` → `LMemo`. Demo-side fix — Luna can fix.

Note: the pre-existing `s`, `p` local names are not in scope for this review.

### CD-03 — nit — `FMX/DataBinding/UDemo.pas` : same `m` and `lbl` variable names

`FormCreate` declares `var m: TMemo; lbl: TLabel;`. Rename `m` → `LMemo`,
`lbl` → `LLabel`. Demo-side fix — Luna can fix.

### CD-04 — minor — `WEB/HTMLEngine/UDemo.pas` : `THTMLView` is a local class duplicate

The WEB demo defines its own `THTMLView` class inline. The FMX and VCL demos also wrap
the HTML engine in a local `THTMLView`. If a future demo needs to reference HTML rendering,
having three copies creates drift. Consider moving it to `UHTMLSamples.pas` as a shared
helper. This is a suggestion, not a blocker; the demo works as-is.

## Trivial demo-side fixes to commit (CD-01, CD-02, CD-03)

Rename local variables in three files. Done in the commit following this review.

## Verdict

**No blockers.** Three naming nits (CD-01 to CD-03) are trivial demo-side fixes done
below. CD-04 is a suggestion for a later pass. The HTML Engine and DataBinding updates
are professionally done, the WEB port is complete, and the new DataLink CSV/JSON and
StylesManager demos are clean.
