unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, FMX.Forms,
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.Layouts, FMX.ListBox, FMX.Memo, FMX.TMSFNCCustomComponent, FMX.TMSFNCDataBinding,
  System.Rtti, FMX.Grid.Style, FMX.ScrollBox, FMX.Grid, Data.DB,
  Datasnap.DBClient, Data.Bind.Controls, Data.Bind.Components,
  Data.Bind.DBScope, Fmx.Bind.Navigator,
  FMX.TMSFNCTheme;

type
  THTMLPaintBox = class(TPaintBox)
  private
    FHTML: string;
    FTextColor: TAlphaColor;
    procedure SetHTML(const Value: string);
    procedure SetTextColor(const Value: TAlphaColor);
  protected
    procedure Paint; override;
  published
    property HTML: string read FHTML write SetHTML;
    property TextColor: TAlphaColor read FTextColor write SetTextColor;
  end;

  TStringGridEx = class(TStringGrid, ITMSFNCDataBinderGrid, ITMSFNCDataBinderSelection)
  protected
    function DefinePresentationName: string; override;
    procedure DataBeginUpdate;
    procedure DataEndUpdate;
    procedure SetDataColumnCount(AValue: Integer);
    procedure SetDataRowCount(AValue: Integer);
    procedure ClearData;
    function GetDataRowCount: Integer;
    procedure SetDataValue(AColumn, ARow: Integer; AValue: string);
    procedure SetDataHeader(AColumn: Integer; AValue: string);
    procedure DataInsertRow(AInsertPosition: Integer);
    function DataGetItemIndex: Integer;
    procedure DataSetItemIndex(AValue: Integer);
  end;

  TForm130 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    Panel1: TLayout;
    Button1: TButton;
    Button2: TButton;
    TMSFNCDataBinder1: TTMSFNCDataBinder;
    ListBox1: TListBox;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    BindNavigator1: TBindNavigator;
    BindSourceDB1: TBindSourceDB;
    ImageControl1: TImageControl;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    FHTMLBox: THTMLPaintBox;
    FMemo: TMemo;
    FErrorLbl: TLabel;
    procedure ThemeChanged(Sender: TObject);
    procedure DataBinderBindError(Sender: TObject; AItem: TTMSFNCDataBinderItem;
      const AMessage: string);
    { Private declarations }
  public
    { Public declarations }
    procedure DoSelChanged(Sender: TObject);
  end;

var
  Form130: TForm130;

implementation

{$R *.fmx}

uses
  FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.Graphics;

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataBinder1.Active := not TMSFNCDataBinder1.Active;
  if TMSFNCDataBinder1.Active then
    Button1.Text := 'Deactivate'
  else
    Button1.Text := 'Activate';
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataBinder1.StartEditor;
end;

procedure TForm130.DoSelChanged(Sender: TObject);
begin
  TMSFNCDataBinder1.ItemByObject[Sender, ''].NotifySetActiveRecord;
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  s: TStringGridEx;
  p: THTMLPaintBox;
  LMemo: TMemo;
  LLabel: TLabel;
  it: TTMSFNCDataBinderItem;
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  s := TStringGridEx.Create(Self);
  s.Parent := Self;
  s.Name := 'StringGrid1';
  s.Align := TAlignLayout.Client;
  s.Margins.Left := 24;
  s.Margins.Right := 24;
  s.Margins.Bottom := 170;
  s.Margins.Top := ImageControl1.Height + 20;
  s.Options := s.Options + [TGridOption.AlwaysShowSelection, TGridOption.RowSelect];
  s.OnSelChanged := DoSelChanged;

  { TMemo bound read-only to the Notes memo field }
  LMemo := TMemo.Create(Self);
  LMemo.Parent := Self;
  LMemo.Name := 'NotesDisplay';
  LMemo.Align := TAlignLayout.Bottom;
  LMemo.Margins.Left := 24;
  LMemo.Margins.Right := 24;
  LMemo.Margins.Bottom := 24;
  LMemo.Height := 140;
  LMemo.ReadOnly := True;
  LMemo.StyledSettings := LMemo.StyledSettings - [TStyledSetting.Other];
  FMemo := LMemo;

  { Error label for OnBindError feedback }
  LLabel := TLabel.Create(Self);
  LLabel.Parent := Self;
  LLabel.Name := 'ErrorLbl';
  LLabel.Position.X := 24;
  LLabel.Position.Y := Height - 20;
  LLabel.Width := Width - 48;
  LLabel.Text := '';
  LLabel.Anchors := [TAnchorKind.akLeft, TAnchorKind.akBottom, TAnchorKind.akRight];
  FErrorLbl := LLabel;

  p := THTMLPaintBox.Create(Self);
  p.Parent := Self;
  p.Name := 'HTMLPaintBox1';
  p.Position.X := ImageControl1.Position.X + ImageControl1.Width + 20;
  p.Position.Y := ImageControl1.Position.Y;
  p.Width := Width - p.Position.X - 24;
  p.Height := ImageControl1.Height;
  p.Anchors := [TAnchorKind.akLeft, TAnchorKind.akTop, TAnchorKind.akRight];
  FHTMLBox := p;
  ThemeChanged(nil);

  TMSFNCDataBinder1.OnBindError := DataBinderBindError;

  TMSFNCDataBinder1.ConnectSingleHTMLTemplate(p, DataSource1, 'HTML', '<b>Name: <#COMMON_NAME></b><br/><font size="10"><#NOTES></font>');
  TMSFNCDataBinder1.ConnectSingle(ImageControl1, DataSource1, 'Bitmap', 'Graphic');
  TMSFNCDataBinder1.ConnectList(ListBox1, DataSource1, 'Items', 'Species Name');
  TMSFNCDataBinder1.ConnectGrid(s, DataSource1);

  { Memo bound to Notes (ftMemo field); ReadOnly = True: field drives control, not the reverse }
  it := TMSFNCDataBinder1.ConnectSingle(LMemo, DataSource1, 'Text', 'Notes');
  it.ReadOnly := True;
  it.ClearOnInsert := False;

  { Wrong field name: OnBindError fires once and shows the message below the grid }
  TMSFNCDataBinder1.ConnectSingle(LLabel, DataSource1, 'Text', 'WRONG_FIELD');

  TMSFNCDataBinder1.Active := True;
  Button1.Text := 'Deactivate';
end;

procedure TForm130.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and grids keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm130.ThemeChanged(Sender: TObject);
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
  DemoDescription.FontColor := sec;
  if Assigned(FHTMLBox) then
    FHTMLBox.TextColor := txt;
end;

procedure TForm130.DataBinderBindError(Sender: TObject;
  AItem: TTMSFNCDataBinderItem; const AMessage: string);
begin
  if Assigned(FErrorLbl) then
    FErrorLbl.Text := 'Bind error: ' + AMessage;
end;

procedure TForm130.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

{ THTMLPaintBox }

procedure THTMLPaintBox.Paint;
var
  g: TTMSFNCGraphics;
begin
  inherited;
  g := TTMSFNCGraphics.Create(Canvas);
  try
    g.Font.Color := FTextColor;
    g.DrawText(LocalRect, HTML, True, gtaLeading, gtaLeading);
  finally
    g.Free;
  end;
end;

procedure THTMLPaintBox.SetTextColor(const Value: TAlphaColor);
begin
  FTextColor := Value;
  Repaint;
end;

procedure THTMLPaintBox.SetHTML(const Value: string);
begin
  FHTML := Value;
  Repaint;
end;

{ TStringGridEx }

function TStringGridEx.DefinePresentationName: string;
begin
  Result := 'Grid-' + GetPresentationSuffix;
end;


procedure TStringGridEx.ClearData;
begin
  ClearColumns;
end;

procedure TStringGridEx.DataBeginUpdate;
begin

end;

procedure TStringGridEx.DataEndUpdate;
begin

end;

function TStringGridEx.DataGetItemIndex: Integer;
begin
  Result := Selected;
end;

procedure TStringGridEx.DataInsertRow(AInsertPosition: Integer);
begin

end;

procedure TStringGridEx.DataSetItemIndex(AValue: Integer);
begin
  Selected := AValue;
end;

function TStringGridEx.GetDataRowCount: Integer;
begin
  Result := RowCount;
end;

procedure TStringGridEx.SetDataColumnCount(AValue: Integer);
var
  I: Integer;
  sc: TStringColumn;
begin
  for I := 0 to AValue - 1 do
  begin
    sc := TStringColumn.Create(Self);
    AddObject(sc);
  end;
end;

procedure TStringGridEx.SetDataHeader(AColumn: Integer; AValue: string);
begin
  Columns[AColumn].Header := AValue;
end;

procedure TStringGridEx.SetDataRowCount(AValue: Integer);
begin
  RowCount := AValue;
end;

procedure TStringGridEx.SetDataValue(AColumn, ARow: Integer; AValue: string);
begin
  Cells[AColumn, ARow] := AValue;
end;

end.
