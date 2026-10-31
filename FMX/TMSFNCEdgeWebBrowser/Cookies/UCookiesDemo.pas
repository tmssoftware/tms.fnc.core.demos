unit UCookiesDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCEdgeWebBrowser,
  System.Rtti, FMX.Grid.Style, FMX.StdCtrls, FMX.Grid, FMX.ScrollBox, FMX.Edit,
  FMX.Controls.Presentation, FMX.DateTimeCtrls, FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    CookieCaption: TLabel;
    NameRow: TLayout;
    DomainRow: TLayout;
    PathRow: TLayout;
    ValueRow: TLayout;
    ExpiresRow: TLayout;
    CookiesHint: TLabel;
    AddressBar: TLayout;
    ContentPanel: TLayout;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    NavigateBtn: TButton;
    URIEdit: TEdit;
    AddCookieBtn: TButton;
    CookieGrid: TStringGrid;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
    StringColumn3: TStringColumn;
    StringColumn4: TStringColumn;
    StringColumn5: TStringColumn;
    DeleteAllCookiesBtn: TButton;
    DeleteCookieBtn: TButton;
    DomainEdit: TEdit;
    DomainLbl: TLabel;
    ExpirationDate: TDateEdit;
    ExpirationTime: TTimeEdit;
    GetCookiesBtn: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    NameEdit: TEdit;
    NameLbl: TLabel;
    PathEdit: TEdit;
    PathLbl: TLabel;
    ValueEdit: TEdit;
    Splitter1: TSplitter;
    procedure FormCreate(Sender: TObject);
    procedure NavigateBtnClick(Sender: TObject);
    procedure GetCookiesBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetCookies(Sender: TObject;
      ACookies: array of TTMSFNCWebBrowserCookie);
    procedure TMSFNCEdgeWebBrowser1NavigateComplete(Sender: TObject;
      var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
    procedure AddCookieBtnClick(Sender: TObject);
    procedure DeleteCookieBtnClick(Sender: TObject);
    procedure DeleteAllCookiesBtnClick(Sender: TObject);
    procedure CookieGridSelectCell(Sender: TObject; const ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
    CookieList: array of TTMSFNCWebBrowserCookie;
    procedure FillEdits(AIndex: Integer);
  end;

var
  Form2: TForm2;

implementation

uses
  System.DateUtils;

{$R *.fmx}

procedure TForm2.GetCookiesBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1GetCookies(Sender: TObject; ACookies: array of TTMSFNCWebBrowserCookie);
var
  I, l: Integer;
begin
  l := Length(ACookies);
  CookieGrid.RowCount := l;

  SetLength(CookieList, l);
  for I := 0 to l - 1 do
  begin
    CookieList[I] := ACookies[I];
    CookieGrid.Cells[0, I] := ACookies[I].Name;
    CookieGrid.Cells[1, I] := ACookies[I].Domain;
    CookieGrid.Cells[2, I] := ACookies[I].Path;
    CookieGrid.Cells[3, I] := ACookies[I].Value;
    CookieGrid.Cells[4, I] := DateTimeToStr(ACookies[I].Expires);
  end;

  if l > 0 then
  begin
    CookieGrid.SelectRow(0);
    FillEdits(0);
  end;
end;

procedure TForm2.AddCookieBtnClick(Sender: TObject);
var
  c: TTMSFNCWebBrowserCookie;
begin
  c.Name := NameEdit.Text;
  c.Domain := DomainEdit.Text;
  c.Path := PathEdit.Text;
  c.Expires := ExpirationDate.Date + ExpirationTime.Time;
  c.Value := ValueEdit.Text;
  c.Secure := true;
  c.SameSite := sstLax;

  TMSFNCEdgeWebBrowser1.AddCookie(c);

  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.DeleteAllCookiesBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.DeleteAllCookies;

  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.DeleteCookieBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.DeleteCookie(NameEdit.Text, DomainEdit.Text, PathEdit.Text);

  TThread.Sleep(100);

  TMSFNCEdgeWebBrowser1.GetCookies;
end;

//Other functions
procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  ExpirationDate.Date := Now + 1;
  ExpirationTime.Time := Now.GetTime;
end;

procedure TForm2.CookieGridSelectCell(Sender: TObject; const ACol, ARow: Integer; var CanSelect: Boolean);
begin
  FillEdits(ARow);
end;

procedure TForm2.FillEdits(AIndex: Integer);
begin
  if (Length(CookieList) > AIndex) and (AIndex >= 0) then
  begin
    NameEdit.Text := CookieList[AIndex].Name;
    DomainEdit.Text := CookieList[AIndex].Domain;
    PathEdit.Text := CookieList[AIndex].Path;
    ValueEdit.Text := CookieList[AIndex].Value;
    ExpirationDate.Date := CookieList[AIndex].Expires;
    ExpirationTime.Time := CookieList[AIndex].Expires.GetTime;
  end
  else
  begin
    NameEdit.Text := '';
    DomainEdit.Text := '';
    PathEdit.Text := '';
    ValueEdit.Text := '';
    ExpirationDate.Date := Now + 1;
    ExpirationTime.Time := Now;
  end;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', TMSFNCEdgeWebBrowser1.URL) > 0 then
    URIEdit.Text := TMSFNCEdgeWebBrowser1.URL;
end;

procedure TForm2.NavigateBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(URIEdit.text);
end;

procedure TForm2.TMSFNCEdgeWebBrowser1NavigateComplete(Sender: TObject; var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
begin
  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits, lists and
  memos keep the platform look, which is readable on a light and on a dark form. The page in the
  browser is not themed. }
procedure TForm2.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TAlphaColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := TAlphaColorRec.Black;
    sec := $FF5B6470;
  end;
  DemoTitle.FontColor := txt;
  CookieCaption.FontColor := txt;
  NameLbl.FontColor := txt;
  DomainLbl.FontColor := txt;
  PathLbl.FontColor := txt;
  Label1.FontColor := txt;
  Label2.FontColor := txt;
  Label3.FontColor := txt;
  DemoDescription.FontColor := sec;
  CookiesHint.FontColor := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
