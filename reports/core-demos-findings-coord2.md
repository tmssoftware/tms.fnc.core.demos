# Core Demos - Open Product Findings (Coordinator 2)

Findings observed during A14 and C14 demo work, 2026-11-11.

## HTML Engine

**F-HE-1: `TTMSFNCTheme.KeepValues` has no release counterpart.**
Once the developer calls `KeepValues` (or the form uses `StyleResource`), the theme can no longer
reclaim those properties; a `ReleaseValues` API would make the toggle round-trip. Affects:
StylesManager and Theme Your Own Control demos.

**F-HE-2: `StyleResource` permanently locks values.**
After `TTMSFNCStylesManager.StyleResource` loads a legacy style file the affected controls are
marked as developer-owned and no subsequent theme change colours them, even after switching to a
named theme. No API exists to clear this state without restarting the app.

## DataBinder

**F-DB-1: `TTMSFNCCustomDataLink.AutoSaveChanges` and `FileName` are protected in the base class.**
Only published in the concrete descendants (`TTMSFNCDataLinkCSV`, `TTMSFNCDataLinkJSON`). Code
holding a base-class reference must cast to the concrete type. Worth a note in the DataLink docs.

**F-DB-2: `TTMSFNCDataSet` fires `AfterScroll` during `DisableControls` traversal.**
Standard TDataSet behaviour but a naive "redraw on scroll" handler recurses. Should be noted
in the DataLink demos and docs.

## General

**F-GEN-1: Core demos cannot use `TTMSFNCThemeSelector` (UI Pack control).**
The Core header uses a native combo box. A Core-level theme picker (`TTMSFNCThemePicker`) would
let Core demos match the UI Pack demo visual quality.

**F-GEN-2: `TTMSFNCCustomControl.ConvertClientToScreen` is protected.**
A form that wants to place a `TTMSFNCHint` at an arbitrary control must use unit-level protected
access or compute the screen point itself.
