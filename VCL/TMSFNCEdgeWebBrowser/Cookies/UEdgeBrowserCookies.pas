unit UEdgeBrowserCookies;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCWebBrowser, VCL.TMSFNCEdgeWebBrowser, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Grids, Vcl.ExtCtrls, VCL.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    CookieCaption: TLabel;
    NameRow: TPanel;
    DomainRow: TPanel;
    PathRow: TPanel;
    ValueRow: TPanel;
    ExpiresRow: TPanel;
    CookiesHint: TLabel;
    AddressBar: TPanel;
    ContentPanel: TPanel;
    URLEdit: TEdit;
    NameEdit: TEdit;
    NavigateBtn: TButton;
    CookieGrid: TStringGrid;
    Label1: TLabel;
    AddCookieBtn: TButton;
    DeleteCookieBtn: TButton;
    DeleteAllCookiesBtn: TButton;
    ExpiresDate: TDateTimePicker;
    DomainEdit: TEdit;
    PathEdit: TEdit;
    ValueEdit: TEdit;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    GetCookiesBtn: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Splitter1: TSplitter;
    procedure NavigateBtnClick(Sender: TObject);
    procedure GetCookiesBtnClick(Sender: TObject);
    procedure AddCookieBtnClick(Sender: TObject);
    procedure DeleteCookieBtnClick(Sender: TObject);
    procedure DeleteAllCookiesBtnClick(Sender: TObject);
    procedure CookieGridSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetCookies(Sender: TObject;
      ACookies: array of TTMSFNCWebBrowserCookie);
    procedure TMSFNCEdgeWebBrowser1NavigateComplete(Sender: TObject;
      var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
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

{$R *.dfm}

procedure TForm2.AddCookieBtnClick(Sender: TObject);
var
  c: TTMSFNCWebBrowserCookie;
begin
  c.Name := NameEdit.Text;
  c.Domain := DomainEdit.Text;
  c.Path := PathEdit.Text;
  c.Expires := ExpiresDate.DateTime;
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

procedure TForm2.FillEdits(AIndex: Integer);
begin
  if (Length(CookieList) > AIndex) and (AIndex >= 0) then
  begin
    NameEdit.Text := CookieList[AIndex].Name;
    DomainEdit.Text := CookieList[AIndex].Domain;
    PathEdit.Text := CookieList[AIndex].Path;
    ValueEdit.Text := CookieList[AIndex].Value;
    ExpiresDate.DateTime := CookieList[AIndex].Expires;
  end
  else
  begin
    NameEdit.Text := '';
    DomainEdit.Text := '';
    PathEdit.Text := '';
    ValueEdit.Text := '';
    ExpiresDate.DateTime := Now + 1;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  ExpiresDate.DateTime := Now + 1;
  CookieGrid.Cells[0, 0] := 'Name';
  CookieGrid.Cells[1, 0] := 'Domain';
  CookieGrid.Cells[2, 0] := 'Path';
  CookieGrid.Cells[3, 0] := 'Value';
  CookieGrid.Cells[4, 0] := 'Expires';
end;

procedure TForm2.GetCookiesBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.NavigateBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(URLEdit.Text);
end;

procedure TForm2.TMSFNCEdgeWebBrowser1GetCookies(Sender: TObject; ACookies: array of TTMSFNCWebBrowserCookie);
var
  I, l: Integer;
begin
  l := Length(ACookies);
  CookieGrid.RowCount := l + 1;

  SetLength(CookieList, l);
  for I := 0 to l - 1 do
  begin
    CookieList[I] := ACookies[I];
    CookieGrid.Cells[0, I + 1] := ACookies[I].Name;
    CookieGrid.Cells[1, I + 1] := ACookies[I].Domain;
    CookieGrid.Cells[2, I + 1] := ACookies[I].Path;
    CookieGrid.Cells[3, I + 1] := ACookies[I].Value;
    CookieGrid.Cells[4, I + 1] := DateTimeToStr(ACookies[I].Expires);
  end;

  if l > 0 then
  begin
    CookieGrid.Row := 1;
    FillEdits(0);
  end;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', TMSFNCEdgeWebBrowser1.URL) > 0 then
    URLEdit.Text := TMSFNCEdgeWebBrowser1.URL;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1NavigateComplete(Sender: TObject; var Params: TTMSFNCCustomWebBrowserNavigateCompleteParams);
begin
  TMSFNCEdgeWebBrowser1.GetCookies;
end;

procedure TForm2.CookieGridSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
begin
  FillEdits(ARow - 1);
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
  txt, sec: TColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := clWindowText;
    sec := clGrayText;
  end;
  DemoTitle.Font.Color := txt;
  CookieCaption.Font.Color := txt;
  Label1.Font.Color := txt;
  Label2.Font.Color := txt;
  Label3.Font.Color := txt;
  Label4.Font.Color := txt;
  Label5.Font.Color := txt;
  Label6.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  CookiesHint.Font.Color := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
