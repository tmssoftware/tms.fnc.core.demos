unit UMain;

interface

uses
  System.SysUtils, System.Types, System.Classes, System.UITypes,
  System.IOUtils, FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics,
  FMX.Dialogs, FMX.StdCtrls, FMX.Layouts, FMX.Memo, FMX.Objects,
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCPDFLib,
  FMX.ListBox, FMX.TMSFNCTheme;

type
  TPDFDemoAction = (daCreate, daEdit, daInspect, daOpen);

  TMainForm = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    StepsCaption: TLabel;
    StepsHint: TLabel;
    CreateButton: TButton;
    EditButton: TButton;
    InspectButton: TButton;
    OpenButton: TButton;
    LogMemo: TMemo;
    procedure CreateButtonClick(Sender: TObject);
    procedure EditButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
    procedure InspectButtonClick(Sender: TObject);
    procedure OpenButtonClick(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    function DemoFileName(const AName: string): string;
    function SourceFileName: string;
    function EditedFileName: string;
    function ExtractedFileName: string;
    procedure AddLog(const AMessage: string);
    procedure CreateSourceDocument;
    procedure DrawFeaturePage(const APDF: TTMSFNCPDFLib; const ATitle,
      ABody: string; const AAccent: TTMSFNCGraphicsColor; APageIndex: Integer);
    procedure EditSourceDocument;
    procedure InspectDocument(const AFileName: string);
    procedure OpenDocument(const AFileName: string);
    procedure RunAction(const ACaption: string; AAction: TPDFDemoAction);
  end;

var
  MainForm: TMainForm;

implementation

{$R *.fmx}

uses
  FMX.TMSFNCPDFCoreLibBase, FMX.TMSFNCPDFGraphicsLib,
  FMX.TMSFNCUtils;

const
  CSourcePDF = 'PDFCapabilities_Source.pdf';
  CEditedPDF = 'PDFCapabilities_Edited.pdf';
  CExtractedPDF = 'PDFCapabilities_Extracted.pdf';

procedure TMainForm.AddLog(const AMessage: string);
begin
  LogMemo.Lines.Add(FormatDateTime('hh:nn:ss', Now) + '  ' + AMessage);
  LogMemo.GoToTextEnd;
end;

procedure TMainForm.CreateButtonClick(Sender: TObject);
begin
  RunAction('Generate source PDF', daCreate);
end;

procedure TMainForm.CreateSourceDocument;
var
  PDF: TTMSFNCPDFLib;
begin
  PDF := TTMSFNCPDFLib.Create;
  try
    PDF.PageSize := psA4;
    PDF.BeginDocument(SourceFileName);
    PDF.Header := 'TMS FNC PDF capabilities';
    PDF.Footer := 'Generated with TTMSFNCPDFLib';
    PDF.PageNumber := pnFooter;
    PDF.PageNumberFormat := 'Page %d';

    PDF.NewPage;
    DrawFeaturePage(PDF, 'Generate and navigate',
      'Create PDF files or streams, set document metadata, draw with the FNC graphics API, and add web or internal links.', gcTeal, 0);
    PDF.Graphics.AddURL('Open the TMS FNC product page',
      'https://www.tmssoftware.com/site/tmsfnccore.asp',
      RectF(72, 330, 400, 354));
    PDF.Graphics.AddGoTo('Jump to structural page editing', 2, '/Fit',
      RectF(72, 365, 400, 389));

    PDF.NewPage;
    DrawFeaturePage(PDF, 'Read existing PDFs',
      'OpenDocument loads an existing PDF. Metadata, page geometry, decoded content streams, and Unicode page text can then be inspected.', gcNavy, 1);
    PDF.NewPage;
    DrawFeaturePage(PDF, 'Edit existing pages',
      'BeginPageEdit exposes the familiar graphics API. Content can be placed above the page as an overlay or below it as an underlay.', gcPurple, 2);
    PDF.NewPage;
    DrawFeaturePage(PDF, 'Reorganize documents',
      'Pages can be duplicated, moved, rotated, deleted, extracted to a new PDF, or merged from another file or stream.', gcMaroon, 3);
    PDF.EndDocument(False);

    { Reopen to demonstrate metadata editing consistently for every backend. }
    PDF.OpenDocument(SourceFileName);
    PDF.Title := 'TMS FNC PDF capabilities demo';
    PDF.Author := 'TMS Software';
    PDF.Creator := 'TMS FNC Core';
    PDF.Subject := 'PDF generation and structural editing';
    PDF.Keywords.Clear;
    PDF.Keywords.Add('TMS FNC');
    PDF.Keywords.Add('PDF');
    PDF.Keywords.Add('document editing');
    PDF.SaveDocument(SourceFileName);
    AddLog('Created ' + SourceFileName);
  finally
    PDF.Free;
  end;
end;

function TMainForm.DemoFileName(const AName: string): string;
begin
  Result := System.IOUtils.TPath.Combine(
    System.IOUtils.TPath.GetDocumentsPath, AName);
end;

procedure TMainForm.DrawFeaturePage(const APDF: TTMSFNCPDFLib;
  const ATitle, ABody: string; const AAccent: TTMSFNCGraphicsColor;
  APageIndex: Integer);
var
  G: ITMSFNCCustomPDFGraphicsLib;
begin
  G := APDF.Graphics;
  G.Fill.Kind := gfkSolid;
  G.Fill.Color := AAccent;
  G.Stroke.Color := AAccent;
  G.DrawRectangle(RectF(54, 72, 541, 170));
  G.Font.Name := 'Arial';
  G.Font.SizeNoScale := 24;
  G.Font.Color := gcWhite;
  G.Font.Style := [TFontStyle.fsBold];
  G.DrawText(ATitle, RectF(72, 98, 520, 135));
  G.Font.SizeNoScale := 12;
  G.Font.Color := gcDarkgray;
  G.Font.Style := [];
  G.DrawText(ABody, RectF(72, 210, 520, 290));
  G.Font.SizeNoScale := 10;
  G.Font.Color := AAccent;
  G.Font.Style := [TFontStyle.fsBold];
  G.DrawText(Format('Feature page %d', [APageIndex + 1]), PointF(72, 300));
end;

procedure TMainForm.EditButtonClick(Sender: TObject);
begin
  RunAction('Edit and reorganize PDF', daEdit);
end;

function TMainForm.EditedFileName: string;
begin
  Result := DemoFileName(CEditedPDF);
end;

procedure TMainForm.EditSourceDocument;
var
  PDF: TTMSFNCPDFLib;
  Extracted: TMemoryStream;
begin
  if not FileExists(SourceFileName) then
    CreateSourceDocument;
  PDF := TTMSFNCPDFLib.Create;
  try
    PDF.OpenDocument(SourceFileName);
    AddLog(Format('Opened source document (%d pages)', [PDF.GetPageCount]));
    PDF.Title := 'TMS FNC PDF capabilities demo - edited';
    PDF.Author := 'TMS Software';
    PDF.Creator := 'TMS FNC Core PDF capabilities demo';
    PDF.Subject := 'Structural editing, extraction, and merging';
    PDF.Keywords.Add('overlay');

    PDF.BeginPageEdit(0, pelOverlay);
    try
      PDF.Graphics.Fill.Color := gcOrange;
      PDF.Graphics.Stroke.Color := gcDarkorange;
      PDF.Graphics.DrawRectangle(RectF(390, 185, 520, 230));
      PDF.Graphics.Font.Name := 'Arial';
      PDF.Graphics.Font.SizeNoScale := 11;
      PDF.Graphics.Font.Style := [TFontStyle.fsBold];
      PDF.Graphics.Font.Color := gcWhite;
      PDF.Graphics.DrawText('OVERLAY', RectF(420, 200, 500, 220));
      PDF.EndPageEdit;
    except
      PDF.CancelPageEdit;
      raise;
    end;

    PDF.BeginPageEdit(1, pelUnderlay);
    try
      PDF.Graphics.Fill.Color := gcLightyellow;
      PDF.Graphics.Stroke.Color := gcLightyellow;
      PDF.Graphics.DrawRectangle(RectF(48, 195, 547, 305));
      PDF.EndPageEdit;
    except
      PDF.CancelPageEdit;
      raise;
    end;

    PDF.DuplicatePage(1);
    PDF.MovePage(PDF.GetPageCount - 1, 1);
    PDF.RotatePage(2, 90);
    PDF.DeletePage(PDF.GetPageCount - 1);
    AddLog('Applied overlay/underlay and duplicate/move/rotate/delete operations');

    Extracted := PDF.ExtractPages([0, 1]);
    try
      Extracted.SaveToFile(ExtractedFileName);
      Extracted.Position := 0;
      PDF.MergeDocument(Extracted);
    finally
      Extracted.Free;
    end;
    AddLog('Extracted two pages and merged that stream back into the document');
    PDF.SaveDocument(EditedFileName);
    AddLog('Saved ' + EditedFileName);
  finally
    PDF.Free;
  end;
  InspectDocument(EditedFileName);
end;

function TMainForm.ExtractedFileName: string;
begin
  Result := DemoFileName(CExtractedPDF);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  AddLog('Ready. Output folder: ' + System.IOUtils.TPath.GetDocumentsPath);
end;

procedure TMainForm.InspectButtonClick(Sender: TObject);
begin
  RunAction('Inspect result', daInspect);
end;

procedure TMainForm.InspectDocument(const AFileName: string);
var
  PDF: TTMSFNCPDFLib;
  Info: TTMSFNCPDFPageInfo;
  Text: string;
  I: Integer;
begin
  PDF := TTMSFNCPDFLib.Create;
  try
    PDF.OpenDocument(AFileName);
    AddLog('Inspecting ' + ExtractFileName(AFileName));
    AddLog(Format('  Title: %s | Author: %s | Pages: %d',
      [PDF.Title, PDF.Author, PDF.GetPageCount]));
    for I := 0 to PDF.GetPageCount - 1 do
    begin
      Info := PDF.GetDocumentPageInfo(I);
      Text := StringReplace(Trim(PDF.GetDocumentPageText(I)), #10, ' / ', [rfReplaceAll]);
      if Length(Text) > 70 then
        Text := Copy(Text, 1, 67) + '...';
      AddLog(Format('  Page %d: %.0f x %.0f pt, rotation %d - %s',
        [I + 1, Info.Width, Info.Height, Info.Rotation, Text]));
    end;
  finally
    PDF.Free;
  end;
end;

procedure TMainForm.OpenButtonClick(Sender: TObject);
begin
  RunAction('Open PDF', daOpen);
end;

procedure TMainForm.OpenDocument(const AFileName: string);
begin
  TTMSFNCUtils.OpenFile(AFileName);
end;

procedure TMainForm.RunAction(const ACaption: string; AAction: TPDFDemoAction);
var
  FileName: string;
begin
  AddLog(ACaption + '...');
  try
    case AAction of
      daCreate: CreateSourceDocument;
      daEdit: EditSourceDocument;
      daInspect:
        begin
          if FileExists(EditedFileName) then FileName := EditedFileName
          else if FileExists(SourceFileName) then FileName := SourceFileName
          else begin CreateSourceDocument; FileName := SourceFileName; end;
          InspectDocument(FileName);
        end;
      daOpen:
        begin
          if FileExists(EditedFileName) then FileName := EditedFileName
          else if FileExists(SourceFileName) then FileName := SourceFileName
          else begin CreateSourceDocument; FileName := SourceFileName; end;
          OpenDocument(FileName);
        end;
    end;
    AddLog(ACaption + ' completed.');
  except
    on E: Exception do
    begin
      AddLog('ERROR: ' + E.Message);
      Application.ShowException(E);
    end;
  end;
end;

function TMainForm.SourceFileName: string;
begin
  Result := DemoFileName(CSourcePDF);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TMainForm.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TAlphaColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
    { a form without FNC controls is not coloured by the manager: do it here }
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := t[ttWindowBackground];
  end
  else
  begin
    txt := TAlphaColorRec.Black;
    sec := $FF5B6470;
    Fill.Kind := TBrushKind.None;
  end;
  DemoTitle.FontColor := txt;
  StepsCaption.FontColor := txt;
  DemoDescription.FontColor := sec;
  StepsHint.FontColor := sec;
end;

procedure TMainForm.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
