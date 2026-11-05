unit UDemo;

{ TMS FNC Core - HTML engine demo (VCL). Command line: -sample <n> picks a sample,
  -theme "<name>" a theme, -screenshot <file.png> saves the form as an image and closes, -pdf <file.pdf> exports the PDF and closes,
  -hit x,y <file.txt> simulates a mouse move over the view and writes the status text. }

interface

uses
  Winapi.Windows, System.SysUtils, System.Types, System.Classes, Vcl.Graphics, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls,
  Vcl.ExtCtrls, VCL.TMSFNCTypes, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTheme, VCL.TMSFNCHTMLEngine;

type
  THTMLView = class(TTMSFNCCustomControl)
  private
    FHTML: string;
    FOnHit: TNotifyEvent;
    FHitText: string;
    procedure SetHTML(const Value: string);
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    property HTML: string read FHTML write SetHTML;
    property HitText: string read FHitText;
    property OnHit: TNotifyEvent read FOnHit write FOnHit;
  end;

  TfrmHTMLDemo = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    Bar: TPanel;
    SampleLbl: TLabel;
    Samples: TComboBox;
    Themes: TComboBox;
    ExportBtn: TButton;
    StatusLbl: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SamplesChange(Sender: TObject);
    procedure ThemesChange(Sender: TObject);
    procedure ExportClick(Sender: TObject);
  private
    View: THTMLView;
    FShot, FPdf, FHit, FHitOut: string;
    procedure ViewHit(Sender: TObject);
    procedure ThemeChanged(Sender: TObject);
    procedure SaveScreenshot(const AFileName: string);
  end;

var
  frmHTMLDemo: TfrmHTMLDemo;

implementation

{$R *.dfm}

uses
  VCL.TMSFNCHTMLEngineCore, VCL.TMSFNCPDFLib, VCL.TMSFNCUtils, Vcl.Imaging.pngimage, System.IOUtils, UHTMLSamples;

const
  HTMLFontSize = 10;

{ THTMLView }

procedure THTMLView.SetHTML(const Value: string);
begin
  FHTML := Value;
  Invalidate;
end;

procedure THTMLView.Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  doc: TTMSFNCHTMLDocument;
  lay: TTMSFNCHTMLLayout;
  ms: TTMSFNCGraphicsHTMLMeasurer;
  pn: TTMSFNCGraphicsHTMLPainter;
  r: TRectF;
  t: TTMSFNCResolvedTheme;
  st: TTMSFNCHTMLPaintState;
begin
  inherited;
  r := RectF(ARect.Left + 12, ARect.Top + 12, ARect.Right - 12, ARect.Bottom - 12);
  AGraphics.Font.Name := 'Segoe UI';
  AGraphics.Font.Size := HTMLFontSize;
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
    AGraphics.Font.Color := t[ttText]
  else
    AGraphics.Font.Color := gcBlack;
  st := HTMLDefaultPaintState;
  if Assigned(t) then
    st.URLColor := t[ttAccent];
  doc := TTMSFNCHTMLDocument.Parse(FHTML);
  ms := TTMSFNCGraphicsHTMLMeasurer.Create(AGraphics);
  pn := TTMSFNCGraphicsHTMLPainter.Create(AGraphics);
  try
    lay := doc.Layout(ms, AGraphics.Font, HTMLLayoutOptions(r, True));
    try
      lay.Paint(pn, PointF(r.Left, r.Top), st);
    finally
      lay.Release;
    end;
  finally
    pn.Free;
    ms.Free;
    doc.Release;
  end;
end;

procedure THTMLView.MouseMove(Shift: TShiftState; X, Y: Integer);
var
  doc: TTMSFNCHTMLDocument;
  lay: TTMSFNCHTMLLayout;
  ms: TTMSFNCGraphicsHTMLMeasurer;
  g: TTMSFNCGraphics;
  hit: TTMSFNCHTMLHitInfo;
  s: string;
begin
  inherited;
  s := '';
  g := TTMSFNCGraphics.CreateBitmapCanvas(1, 1);
  try
    g.Font.Name := 'Segoe UI';
    g.Font.Size := HTMLFontSize;
    doc := TTMSFNCHTMLDocument.Parse(FHTML);
    ms := TTMSFNCGraphicsHTMLMeasurer.Create(g);
    try
      lay := doc.Layout(ms, g.Font, HTMLLayoutOptions(RectF(12, 12, Width - 12, Height - 12), True));
      try
        hit := lay.HitTest(PointF(X - 12, Y - 12));
        if hit.Hit and (hit.Anchor <> '') then
          begin
            s := 'Link ' + hit.Anchor;
            if hit.Title <> '' then
              s := s + '   title: ' + hit.Title;
          end;
      finally
        lay.Release;
      end;
    finally
      ms.Free;
      doc.Release;
    end;
  finally
    g.Free;
  end;
  if s <> FHitText then
  begin
    FHitText := s;
    if Assigned(FOnHit) then
      FOnHit(Self);
  end;
end;

{ TfrmHTMLDemo }

procedure TfrmHTMLDemo.FormCreate(Sender: TObject);
var
  n: Integer;
  a: string;
begin
  View := THTMLView.Create(Self);
  View.Parent := Self;
  View.Align := alClient;
  View.OnHit := ViewHit;
  View.HTML := SampleHTML(0);
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  n := 1;
  while n < ParamCount do
  begin
    a := ParamStr(n);
    if SameText(a, '-sample') then
    begin
      Samples.ItemIndex := StrToIntDef(ParamStr(n + 1), 0);
      SamplesChange(nil);
    end
    else if SameText(a, '-theme') then
    begin
      Themes.ItemIndex := Themes.Items.IndexOf(ParamStr(n + 1));
      ThemesChange(nil);
    end
    else if SameText(a, '-screenshot') then
      FShot := ParamStr(n + 1)
    else if SameText(a, '-pdf') then
      FPdf := ParamStr(n + 1)
    else if SameText(a, '-hit') then
    begin
      FHit := ParamStr(n + 1);
      FHitOut := ParamStr(n + 2);
    end;
    Inc(n);
  end;
end;

procedure TfrmHTMLDemo.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

procedure TfrmHTMLDemo.FormShow(Sender: TObject);
var
  x, y: Integer;
  s: string;
begin
  if FPdf <> '' then
  begin
    ExportClick(nil);
    Application.Terminate;
    Exit;
  end;
  if FHit <> '' then
  begin
    Application.ProcessMessages;
    // the code path of a mouse move over the view: hit test, status text ('scan' tries a grid of points)
    if FHit = 'scan' then
    begin
      s := 'no link found';
      for y := 0 to 100 do
        for x := 0 to 150 do
        begin
          View.MouseMove([], x * 6, y * 3);
          if View.HitText <> '' then
          begin
            s := Format('%d,%d: ', [x * 6, y * 3]) + StatusLbl.Caption;
            Break;
          end;
        end;
      TFile.WriteAllText(FHitOut, s);
    end
    else
    begin
      View.MouseMove([], StrToInt(Copy(FHit, 1, Pos(',', FHit) - 1)), StrToInt(Copy(FHit, Pos(',', FHit) + 1, MaxInt)));
      TFile.WriteAllText(FHitOut, StatusLbl.Caption);
    end;
    Application.Terminate;
    Exit;
  end;
  if FShot <> '' then
  begin
    Application.ProcessMessages;
    SaveScreenshot(FShot);
    Application.Terminate;
  end;
end;

procedure TfrmHTMLDemo.SaveScreenshot(const AFileName: string);
var
  b: TBitmap;
  p: TPngImage;
begin
  b := GetFormImage;
  p := TPngImage.Create;
  try
    p.Assign(b);
    p.SaveToFile(AFileName);
  finally
    p.Free;
    b.Free;
  end;
end;

procedure TfrmHTMLDemo.SamplesChange(Sender: TObject);
begin
  View.HTML := SampleHTML(Samples.ItemIndex);
end;

procedure TfrmHTMLDemo.ThemesChange(Sender: TObject);
begin
  if Themes.ItemIndex >= 0 then
    ThemeManager.Theme := Themes.Items[Themes.ItemIndex];
end;

procedure TfrmHTMLDemo.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    Color := t[ttWindowBackground];
    Bar.Color := t[ttWindowBackground];
    SampleLbl.Font.Color := t[ttText];
    StatusLbl.Font.Color := t[ttTextSecondary];
  end;
  View.Invalidate;
end;

procedure TfrmHTMLDemo.ViewHit(Sender: TObject);
begin
  if View.HitText <> '' then
    StatusLbl.Caption := View.HitText
  else
    StatusLbl.Caption := 'Hover the link to see its title';
end;

procedure TfrmHTMLDemo.ExportClick(Sender: TObject);
var
  p: TTMSFNCPDFLib;
  fn: string;
begin
  if FPdf <> '' then
    fn := FPdf
  else
    fn := TPath.Combine(TPath.GetTempPath, 'htmlengine-demo.pdf');
  p := TTMSFNCPDFLib.Create(Self);
  try
    p.BeginDocument(fn);
    p.NewPage;
    p.Graphics.Font.Name := 'Arial';
    p.Graphics.Font.Size := 12;
    p.Graphics.DrawHTMLText(SampleHTML(Samples.ItemIndex), RectF(40, 40, p.PageWidth - 40, p.PageHeight - 40), True);
    p.EndDocument;
  finally
    p.Free;
  end;
  StatusLbl.Caption := 'PDF written to ' + fn;
  if (FPdf = '') and not FindCmdLineSwitch('screenshot') then
    TTMSFNCUtils.OpenFile(fn);
end;

end.
