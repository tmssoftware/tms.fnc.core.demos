unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.DBCtrls, VCL.TMSFNCCustomComponent,
  VCL.TMSFNCDataBinding, Data.DB, Datasnap.DBClient, Vcl.ExtCtrls, Grids,
  Vcl.Buttons, Vcl.ComCtrls,
  VCL.TMSFNCTheme;

type
  THTMLPaintBox = class(TPaintBox)
  private
    FHTML: string;
    FTextColor: TColor;
    procedure SetHTML(const Value: string);
    procedure SetTextColor(const Value: TColor);
  protected
    procedure Paint; override;
  published
    property HTML: string read FHTML write SetHTML;
    property TextColor: TColor read FTextColor write SetTextColor;
  end;

  TStringGridEx = class(TStringGrid, ITMSFNCDataBinderGrid, ITMSFNCDataBinderSelection)
  protected
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
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    ClientDataSet1: TClientDataSet;
    DataSource1: TDataSource;
    TMSFNCDataBinder1: TTMSFNCDataBinder;
    DBNavigator1: TDBNavigator;
    ListBox1: TListBox;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    FHTMLBox: THTMLPaintBox;
    FMemo: TMemo;
    FStatusBar: TStatusBar;
    procedure ThemeChanged(Sender: TObject);
    procedure DataBinderBindError(Sender: TObject; AItem: TTMSFNCDataBinderItem;
      const AMessage: string);
    { Private declarations }
  public
    { Public declarations }
    procedure DoSelectCell(Sender: TObject; ACol, ARow: Longint;
    var CanSelect: Boolean);
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

uses
  VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes;

procedure TForm130.Button1Click(Sender: TObject);
begin
  TMSFNCDataBinder1.Active := not TMSFNCDataBinder1.Active;
  if TMSFNCDataBinder1.Active then
    Button1.Caption := 'Deactivate'
  else
    Button1.Caption := 'Activate';
end;

procedure TForm130.Button2Click(Sender: TObject);
begin
  TMSFNCDataBinder1.StartEditor;
end;

procedure TForm130.DoSelectCell(Sender: TObject; ACol, ARow: Longint;
  var CanSelect: Boolean);
begin
  TMSFNCDataBinder1.ItemByObject[Sender, ''].NotifySetActiveRecord;
end;

procedure TForm130.FormCreate(Sender: TObject);
var
  s: TStringGridEx;
  p: THTMLPaintBox;
  m: TMemo;
  sb: TStatusBar;
  it: TTMSFNCDataBinderItem;
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);

  { Status bar: indexed path demo — Panels[0].Text bound to Common_Name }
  sb := TStatusBar.Create(Self);
  sb.Parent := Self;
  sb.Panels.Add;
  sb.Panels[0].Width := ClientWidth;
  sb.Panels[0].Style := psText;
  sb.SimplePanel := False;
  FStatusBar := sb;

  s := TStringGridEx.Create(Self);
  s.Parent := Self;
  s.Name := 'StringGrid1';
  s.Align := alClient;
  s.Margins.Left := 24;
  s.Margins.Right := 24;
  s.Margins.Bottom := 170;
  s.Margins.Top := Image1.Height + 20;
  s.AlignWithMargins := True;
  s.FixedRows := 1;
  s.Options := s.Options + [goRowSelect];
  s.OnSelectCell := DoSelectCell;

  { TMemo bound read-only to the Notes memo field }
  m := TMemo.Create(Self);
  m.Parent := Self;
  m.Name := 'NotesDisplay';
  m.Align := alBottom;
  m.AlignWithMargins := True;
  m.Margins.Left := 24;
  m.Margins.Right := 24;
  m.Margins.Bottom := 4;
  m.Height := 140;
  m.ReadOnly := True;
  m.ScrollBars := ssVertical;
  FMemo := m;

  p := THTMLPaintBox.Create(Self);
  p.Parent := Self;
  p.Name := 'HTMLPaintBox1';
  p.Left := Image1.Left + Image1.Width + 20;
  p.Top := Image1.Top;
  p.Width := ClientWidth - p.Left - 24;
  p.Height := Image1.Height;
  p.Anchors := [akLeft, akTop, akRight];
  FHTMLBox := p;
  ThemeChanged(nil);

  TMSFNCDataBinder1.OnBindError := DataBinderBindError;

  TMSFNCDataBinder1.ConnectSingleHTMLTemplate(p, DataSource1, 'HTML', '<b>Name: <#COMMON_NAME></b><br/><font size="10"><#NOTES></font>');
  TMSFNCDataBinder1.ConnectSingle(Image1, DataSource1, 'Picture', 'Graphic');
  TMSFNCDataBinder1.ConnectList(ListBox1, DataSource1, 'Items', 'Species Name');
  TMSFNCDataBinder1.ConnectGrid(s, DataSource1);

  { Memo bound to Notes (ftMemo field); ReadOnly = True: field drives control, not the reverse }
  it := TMSFNCDataBinder1.ConnectSingle(m, DataSource1, 'Text', 'Notes');
  it.ReadOnly := True;
  it.ClearOnInsert := False;

  { Indexed path: Panels[0].Text bound to Common_Name }
  TMSFNCDataBinder1.ConnectSingle(sb, DataSource1, 'Panels[0].Text', 'Common_Name');

  { Wrong field name: OnBindError fires once and sets the status bar's second hint }
  TMSFNCDataBinder1.ConnectSingle(sb, DataSource1, 'Hint', 'WRONG_FIELD');

  TMSFNCDataBinder1.Active := True;
  Button1.Caption := 'Deactivate';
end;

procedure TForm130.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm130.ThemeChanged(Sender: TObject);
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
  DemoDescription.Font.Color := sec;
  if Assigned(FHTMLBox) then
    FHTMLBox.TextColor := txt;
end;

procedure TForm130.DataBinderBindError(Sender: TObject;
  AItem: TTMSFNCDataBinderItem; const AMessage: string);
begin
  if Assigned(FStatusBar) then
  begin
    if FStatusBar.Panels.Count < 2 then
      FStatusBar.Panels.Add;
    FStatusBar.Panels[1].Text := 'Bind error: ' + AMessage;
  end;
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
    g.DrawText(ClientRect, HTML, True, gtaLeading, gtaLeading);
  finally
    g.Free;
  end;
end;

procedure THTMLPaintBox.SetTextColor(const Value: TColor);
begin
  FTextColor := Value;
  Invalidate;
end;

procedure THTMLPaintBox.SetHTML(const Value: string);
begin
  FHTML := Value;
  Invalidate;
end;

{ TStringGridEx }

procedure TStringGridEx.ClearData;
begin
  ColCount := 0;
  RowCount := FixedRows + 1;
end;

procedure TStringGridEx.DataBeginUpdate;
begin

end;

procedure TStringGridEx.DataEndUpdate;
begin

end;

function TStringGridEx.DataGetItemIndex: Integer;
begin
  Result := Row - FixedRows;
end;

procedure TStringGridEx.DataInsertRow(AInsertPosition: Integer);
begin

end;

procedure TStringGridEx.DataSetItemIndex(AValue: Integer);
begin
  Row := AValue + FixedRows;
end;

function TStringGridEx.GetDataRowCount: Integer;
begin
  Result := RowCount - FixedRows;
end;

procedure TStringGridEx.SetDataColumnCount(AValue: Integer);
begin
  ColCount := AValue;
end;

procedure TStringGridEx.SetDataHeader(AColumn: Integer; AValue: string);
begin
  Cells[AColumn, 0] := AValue;
end;

procedure TStringGridEx.SetDataRowCount(AValue: Integer);
begin
  RowCount := AValue + FixedRows;
end;

procedure TStringGridEx.SetDataValue(AColumn, ARow: Integer; AValue: string);
begin
  Cells[AColumn, ARow + FixedRows] := AValue;
end;

end.
