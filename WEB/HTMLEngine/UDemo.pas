unit UDemo;

{ TMS FNC Core - HTML engine demo (WEB).
  THTMLView renders HTML with the CSS engine; sample picker and cache section. }

interface

uses
  SysUtils, Classes, Types, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.StdCtrls, WEBLib.ExtCtrls,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCGraphics,
  WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCTheme, WEBLib.TMSFNCHTMLEngine;

type
  THTMLView = class(TTMSFNCCustomControl)
  private
    FHTML: string;
    procedure SetHTML(const Value: string);
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    property HTML: string read FHTML write SetHTML;
  end;

  TForm1 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    TopPanel: TWebPanel;
    SampleLbl: TWebLabel;
    Samples: TWebComboBox;
    Themes: TWebComboBox;
    ClearCacheBtn: TWebButton;
    StatusLbl: TWebLabel;
    procedure WebFormCreate(Sender: TObject);
    procedure WebFormDestroy(Sender: TObject);
    procedure SamplesChange(Sender: TObject);
    procedure ThemesChange(Sender: TObject);
    procedure ClearCacheBtnClick(Sender: TObject);
  private
    FView: THTMLView;
    procedure ThemeChanged(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

uses
  WEBLib.TMSFNCHTMLEngineCore, UHTMLSamples;

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
  AGraphics.Font.Size := 11;
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

{ TForm1 }

procedure TForm1.WebFormCreate(Sender: TObject);
var
  I: Integer;
begin
  FView := THTMLView.Create(Self);
  FView.Parent := Self;
  FView.Align := alClient;
  FView.HTML := SampleHTML(0);

  for I := 0 to High(SampleNames) do
    Samples.Items.Add(SampleNames[I]);
  Samples.Items.Add('Cache');
  Samples.ItemIndex := 0;

  Themes.ItemIndex := 0;
  TTMSFNCTheme.AddChangeListener(@ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm1.WebFormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(@ThemeChanged);
end;

procedure TForm1.SamplesChange(Sender: TObject);
var
  c: TTMSFNCHTMLCache;
begin
  if Samples.ItemIndex = 10 then
  begin
    c := HTMLCache;
    FView.HTML := CacheHTML(c.Documents.Count, c.Documents.Bytes, c.Documents.Hits, c.Documents.Misses);
  end
  else
    FView.HTML := SampleHTML(Samples.ItemIndex);
end;

procedure TForm1.ThemesChange(Sender: TObject);
begin
  if Themes.ItemIndex >= 0 then
    ThemeManager.Theme := Themes.Items[Themes.ItemIndex];
end;

procedure TForm1.ClearCacheBtnClick(Sender: TObject);
begin
  ClearHTMLCache;
  if Samples.ItemIndex = 10 then
    SamplesChange(nil)
  else
    StatusLbl.Caption := 'HTML cache cleared';
end;

procedure TForm1.ThemeChanged(Sender: TObject);
begin
  if Assigned(FView) then
    FView.Invalidate;
end;

end.
