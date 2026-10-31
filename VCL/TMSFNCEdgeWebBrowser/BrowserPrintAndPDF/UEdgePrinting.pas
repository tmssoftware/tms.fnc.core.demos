unit UEdgePrinting;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCWebBrowser, VCL.TMSFNCEdgeWebBrowser, Vcl.StdCtrls, Vcl.ExtCtrls, VCL.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    PrintCaption: TLabel;
    PDFCaption: TLabel;
    PDFHint: TLabel;
    AddressBar: TPanel;
    PrintUIBtn: TButton;
    PrintToPDFStreamBtn: TButton;
    PrintBtn: TButton;
    PrintToPDFBtn: TButton;
    NavigateBtn: TButton;
    URLEdit: TEdit;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    procedure NavigateBtnClick(Sender: TObject);
    procedure PrintUIBtnClick(Sender: TObject);
    procedure PrintToPDFStreamBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetPrintPDFStream(Sender: TObject;
      AStream: TMemoryStream);
    procedure PrintToPDFBtnClick(Sender: TObject);
    procedure PrintBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.NavigateBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(URLEdit.Text);
end;

procedure TForm2.PrintBtnClick(Sender: TObject);
var
  ps: TTMSFNCWebBrowserPrintSettings;
begin
  ps := TMSFNCEdgeWebBrowser1.InitialPrintSettings;
  ps.PrintHeaderAndFooter := False;
  ps.Orientation := poLandscape;
  TMSFNCEdgeWebBrowser1.Print(ps);
end;

procedure TForm2.PrintToPDFBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.PrintToPDF(GetCurrentDir + '/test.pdf');
end;

procedure TForm2.PrintToPDFStreamBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.PrintToPDFStream;
end;

procedure TForm2.PrintUIBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.ShowPrintUI;
end;

procedure TForm2.TMSFNCEdgeWebBrowser1GetPrintPDFStream(Sender: TObject; AStream: TMemoryStream);
begin
  if Assigned(AStream) then
    AStream.SaveToFile('PDFStream.pdf');
end;

procedure TForm2.TMSFNCEdgeWebBrowser1Initialized(Sender: TObject);
begin
  if Pos('http', TMSFNCEdgeWebBrowser1.URL) > 0 then
    URLEdit.Text := TMSFNCEdgeWebBrowser1.URL;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
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
  PrintCaption.Font.Color := txt;
  PDFCaption.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  PDFHint.Font.Color := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
