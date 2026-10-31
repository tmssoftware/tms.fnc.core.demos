unit UNavigateWithData;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCTypes, VCL.TMSFNCUtils,
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, Vcl.StdCtrls, Vcl.Grids,
  VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser, VCL.TMSFNCEdgeWebBrowser, Vcl.ExtCtrls, VCL.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    RequestCaption: TLabel;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    URIEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    HeaderGrid: TStringGrid;
    Label3: TLabel;
    BodyMemo: TMemo;
    NavigateBtn: TButton;
    procedure FormCreate(Sender: TObject);
    procedure NavigateBtnClick(Sender: TObject);
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

procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  HeaderGrid.Cells[0, 0] := 'Name';
  HeaderGrid.Cells[1, 0] := 'Value';
  HeaderGrid.Cells[0, 1] := 'Content-Type';
  HeaderGrid.Cells[1, 1] := 'application/x-www-form-urlencoded';
end;

procedure TForm2.NavigateBtnClick(Sender: TObject);
var
  headers: TStringList;
  I: Integer;
begin
  headers := TStringList.Create;
  try
    for I := 1 to HeaderGrid.RowCount - 1 do
    begin
      if Trim(HeaderGrid.Cells[0, I]) <> '' then
        headers.AddPair(Trim(HeaderGrid.Cells[0, I]), Trim(HeaderGrid.Cells[1, I]));
    end;
    TMSFNCEdgeWebBrowser1.NavigateWithData(URIEdit.Text, 'POST', BodyMemo.Text, headers);
  finally
    headers.Free;
  end;
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
  RequestCaption.Font.Color := txt;
  Label1.Font.Color := txt;
  Label2.Font.Color := txt;
  Label3.Font.Color := txt;
  DemoDescription.Font.Color := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
