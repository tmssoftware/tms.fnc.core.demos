unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, UMyDataLink,
  System.Rtti, VCL.StdCtrls, Data.DB, TMS.TMSFNCDataSet, Vcl.Grids, Vcl.DBGrids,
  VCL.TMSFNCTheme, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    StepsCaption: TLabel;
    StepsHint: TLabel;
    TMSFNCDataSet1: TTMSFNCDataSet;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    FDataLink: TMyDataLink;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  TMSFNCDataSet1.Active := True;

  for I := 0 to DBGrid1.Columns.Count - 1 do
    DBGrid1.Columns[I].Width := 150;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDataLink.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  FDataLink := TMyDataLink.Create;
  FDataLink.OwnsObjects := True;
  FDataLink.InitSampleData;

  TMSFNCDataSet1.DataObject := FDataLink;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm1.ThemeChanged(Sender: TObject);
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
  StepsCaption.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  StepsHint.Font.Color := sec;
end;

procedure TForm1.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
