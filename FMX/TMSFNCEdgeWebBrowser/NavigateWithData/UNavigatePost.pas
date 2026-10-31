unit UNavigatePost;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser, FMX.TMSFNCEdgeWebBrowser,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Memo.Types, FMX.Edit,
  FMX.ScrollBox, FMX.Memo, System.Rtti, FMX.Grid.Style, FMX.Grid, FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TForm2 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    RequestCaption: TLabel;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    BodyMemo: TMemo;
    NavigateBtn: TButton;
    URIEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    HeaderGrid: TStringGrid;
    Label3: TLabel;
    StringColumn1: TStringColumn;
    StringColumn2: TStringColumn;
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

{$R *.fmx}

procedure TForm2.NavigateBtnClick(Sender: TObject);
var
  headers: TStringList;
  I: Integer;
begin
  headers := TStringList.Create;
  try
    for I := 0 to HeaderGrid.RowCount - 1 do
    begin
      if Trim(HeaderGrid.Cells[0, I]) <> '' then
        headers.AddPair(Trim(HeaderGrid.Cells[0, I]), Trim(HeaderGrid.Cells[1, I]));
    end;
    TMSFNCEdgeWebBrowser1.NavigateWithData(URIEdit.Text, 'POST', BodyMemo.Text, headers);
  finally
    headers.Free;
  end;
end;

procedure TForm2.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  HeaderGrid.Cells[0, 0] := 'Content-Type';
  HeaderGrid.Cells[1, 0] := 'application/x-www-form-urlencoded';

  ReportMemoryLeaksOnShutdown := True;
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
  RequestCaption.FontColor := txt;
  Label1.FontColor := txt;
  Label2.FontColor := txt;
  Label3.FontColor := txt;
  DemoDescription.FontColor := sec;
end;

procedure TForm2.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
