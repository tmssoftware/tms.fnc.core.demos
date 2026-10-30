unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, FMX.Forms,
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Memo, FMX.Memo.Types, FMX.ScrollBox,
  FMX.TMSFNCCustomComponent,
  FMX.ListBox, FMX.Layouts, FMX.Graphics, FMX.TMSFNCTheme;

type
  TForm131 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    StepsCaption: TLabel;
    btnRun: TButton;
    lblInfo: TLabel;
    memoText: TMemo;
    procedure btnRunClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    procedure CreatePack(const AFileName, ATitle: string;
      const ASections: array of string);
    function Assemble(const ACover, ABody, ATarget: string): string;
  public
  end;

var
  Form131: TForm131;

implementation

{$R *.fmx}

uses
  FMX.TMSFNCPDFLib, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCUtils, System.IOUtils;

procedure TForm131.CreatePack(const AFileName, ATitle: string;
  const ASections: array of string);
var
  p: TTMSFNCPDFLib;
  I: Integer;
begin
  p := TTMSFNCPDFLib.Create(Self);
  try
    p.Header := '';
    p.Footer := '';
    p.BeginDocument(AFileName);
    for I := 0 to Length(ASections) - 1 do
    begin
      p.NewPage;
      p.Graphics.Font.Name := 'Arial';
      p.Graphics.Font.SizeNoScale := 24;
      p.Graphics.DrawText(ATitle, PointF(60, 90));
      p.Graphics.Font.SizeNoScale := 14;
      p.Graphics.DrawText(ASections[I], PointF(60, 140));
    end;
    p.EndDocument;
  finally
    p.Free;
  end;
end;

function TForm131.Assemble(const ACover, ABody, ATarget: string): string;
var
  p: TTMSFNCPDFLib;
begin
  p := TTMSFNCPDFLib.Create(Self);
  try
    p.OpenDocument(ACover);

    // Everything below happens on the opened document. Nothing is regenerated
    // and nothing outside the pages touched is rewritten.
    // Inserted at the front rather than appended, which leaves the cover
    // last and gives the reorder below something to do.
    p.MergeDocument(ABody, 0);

    // Bring the cover back to the front, turn the page holding a wide table
    // on its side, and drop the draft that was left in by mistake.
    p.MovePage(p.GetPageCount - 1, 0);
    p.RotatePage(2, 90);
    p.DeletePage(p.GetPageCount - 1);

    // Metadata is read and written on the open document, not at generation.
    p.Title := 'Quarterly pack';
    p.Author := 'TMS Software';
    p.Subject := 'Assembled from a cover and a body document';
    p.Keywords.Text := 'quarterly'#13#10'assembled'#13#10'demo';

    // A link annotation added to a page that already exists. The same call
    // works on every platform, including the ones whose PDF backend cannot
    // write an annotation while drawing.
    p.BeginPageEdit(0, pelOverlay);
    try
      p.Graphics.Font.Name := 'Arial';
      p.Graphics.Font.SizeNoScale := 11;
      p.Graphics.Font.Color := gcBlue;
      p.Graphics.AddURL('tmssoftware.com', 'https://www.tmssoftware.com',
        RectF(60, p.PageHeight - 80, 260, p.PageHeight - 60));
      p.EndPageEdit;
    except
      p.CancelPageEdit;
      raise;
    end;

    p.SaveDocument(ATarget);
    Result := p.GetDocumentPageText(0);
    p.CloseDocument;
  finally
    p.Free;
  end;
end;

procedure TForm131.btnRunClick(Sender: TObject);
var
  cover, body, target, extracted: string;
begin
  cover := TPath.Combine(TPath.GetDocumentsPath, 'FNCManip_cover.pdf');
  body := TPath.Combine(TPath.GetDocumentsPath, 'FNCManip_body.pdf');
  target := TPath.Combine(TPath.GetDocumentsPath, 'FNCManip_pack.pdf');

  CreatePack(cover, 'Cover', ['Quarterly operations pack']);
  CreatePack(body, 'Body', ['Revenue by region', 'Wide comparison table',
    'Appendix', 'Draft page to drop']);

  extracted := Assemble(cover, body, target);

  memoText.Lines.Text := extracted;
  lblInfo.Text := 'Written to ' + target;
  TTMSFNCUtils.OpenFile(target);
end;

procedure TForm131.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm131.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm131.ThemeChanged(Sender: TObject);
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
  lblInfo.FontColor := sec;
end;

procedure TForm131.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
