unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids,
  TMS.TMSFNCFilterRulesManager;

type
  TEmployee = class(TComponent)
  private
    FName: string;
    FCompany: string;
    FCity: string;
    FCountry: string;
    FVisible: Boolean;
  published
    property Name: string read FName write FName;
    property Company: string read FCompany write FCompany;
    property City: string read FCity write FCity;
    property Country: string read FCountry write FCountry;
    property Visible: Boolean read FVisible write FVisible;
  end;

  TEmployeeList = class(TComponent)
  private
    FList: TObjectList<TEmployee>;
    function GetCount: Integer;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Add(const AName, ACompany, ACity, ACountry: string);
    function GetItem(AIndex: Integer): TEmployee;
    property Items[AIndex: Integer]: TEmployee read GetItem;
    procedure ShowAll;
  published
    property Count: Integer read GetCount;
  end;

  TFormMain = class(TForm)
    PanelTop: TPanel;
    LabelFilter: TLabel;
    EditSearch: TEdit;
    BtnApply: TButton;
    BtnClear: TButton;
    LabelStatus: TLabel;
    SearchFieldCombo: TComboBox;
    Label1: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure BtnApplyClick(Sender: TObject);
    procedure BtnClearClick(Sender: TObject);
    procedure EditSearchKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    FGrid: TStringGrid;
    FEmployees: TEmployeeList;
    FManager: TTMSFNCFilterRulesManager;
    procedure SetupGrid;
    procedure PopulateData;
    procedure RefreshGrid;
    procedure ApplyFilter;
    procedure UpdateStatus;
  end;

var
  FormMain: TFormMain;

const
  SAMPLE_DATA: array[0..19, 0..3] of string = (
    ('Alice Hoffman', 'Innovatech', 'Amsterdam', 'Netherlands'),
    ('Bruno Maes', 'Innovatech', 'Brussels', 'Belgium'),
    ('Clara Jensen', 'NordSoft', 'Copenhagen', 'Denmark'),
    ('David Park', 'Crestline', 'Seoul', 'South Korea'),
    ('Andres Rossi', 'Crestline', 'Rome', 'Italy'),
    ('Carl Walsh', 'NordSoft', 'Dublin', 'Ireland'),
    ('George Muller', 'Axiom Systems', 'Berlin', 'Germany'),
    ('Emma Novak', 'Axiom Systems', 'Prague', 'Czech Republic'),
    ('Carl Petrov', 'Axiom Systems', 'Sofia', 'Bulgaria'),
    ('Alice Santos', 'Crestline', 'Lisbon', 'Portugal'),
    ('Kevin Larsson', 'NordSoft', 'Stockholm', 'Sweden'),
    ('Evelyne Blanc', 'Innovatech', 'Paris', 'France'),
    ('Alberto Conti', 'Crestline', 'Milan', 'Italy'),
    ('Bernd Okafor', 'Innovatech', 'Lagos', 'Nigeria'),
    ('Casper Lindqvist', 'NordSoft', 'Gothenburg', 'Sweden'),
    ('Damiano Ferreira', 'Axiom Systems', 'Porto', 'Portugal'),
    ('Gregory Dubois', 'Innovatech', 'Lyon', 'France'),
    ('Alfred De Wachter', 'NordSoft', 'Busan', 'South Korea'),
    ('Diana Bauer', 'Axiom Systems', 'Munich', 'Germany'),
    ('Amelia Volkov', 'Crestline', 'Moscow', 'Russia')
  );

implementation

{$R *.dfm}

constructor TEmployeeList.Create(AOwner: TComponent);
begin
  inherited;
  FList := TObjectList<TEmployee>.Create(True);
end;

destructor TEmployeeList.Destroy;
begin
  FList.Free;
  inherited;
end;

procedure TEmployeeList.Add(const AName, ACompany, ACity, ACountry: string);
var
  E: TEmployee;
begin
  E := TEmployee.Create(nil);
  E.Name := AName;
  E.Company := ACompany;
  E.City := ACity;
  E.Country := ACountry;
  E.Visible := True;
  FList.Add(E);
end;

function TEmployeeList.GetCount: Integer;
begin
  Result := FList.Count;
end;

function TEmployeeList.GetItem(AIndex: Integer): TEmployee;
begin
  Result := FList[AIndex];
end;

procedure TEmployeeList.ShowAll;
var
  I: Integer;
begin
  for I := 0 to FList.Count - 1 do
    FList[I].Visible := True;
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FEmployees := TEmployeeList.Create(Self);
  PopulateData;
  SetupGrid;

  FManager := TTMSFNCFilterRulesManager.Create(Self);
  FManager.AddPlaceholder('SearchFieldComboIndex', SearchFieldCombo, 'ItemIndex');
  FManager.AddPlaceholder('FilterField', SearchFieldCombo,
    'Items[{SearchFieldComboIndex}]');
  FManager.AddPlaceholder('SearchText', EditSearch, 'Text');
  FManager.AddRuleStartsWith('NameFilter', FEmployees, 'Items[0..*]',
    '{FilterField}', '{SearchText}').AddVisibilityAction;

  UpdateStatus;
end;

procedure TFormMain.SetupGrid;
const
  HEADERS: array[0..3] of string = ('Name', 'Company', 'City', 'Country');
  WIDTHS: array[0..3] of Integer = (220, 180, 150, 130);
var
  I: Integer;
begin
  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := alClient;
  FGrid.ColCount := Length(HEADERS);
  FGrid.FixedCols := 0;
  FGrid.FixedRows := 1;
  FGrid.RowCount := 2;
  FGrid.Options := FGrid.Options + [goRowSelect];

  for I := 0 to High(HEADERS) do
  begin
    FGrid.Cells[I, 0] := HEADERS[I];
    FGrid.ColWidths[I] := WIDTHS[I];
  end;

  RefreshGrid;
end;

procedure TFormMain.PopulateData;
var
  I: Integer;
begin
  for I := 0 to High(SAMPLE_DATA) do
    FEmployees.Add(SAMPLE_DATA[I][0], SAMPLE_DATA[I][1], SAMPLE_DATA[I][2],
      SAMPLE_DATA[I][3]);
end;

procedure TFormMain.RefreshGrid;
var
  I, Row, VisibleCount: Integer;
  E: TEmployee;
begin
  VisibleCount := 0;
  for I := 0 to FEmployees.Count - 1 do
    if FEmployees.Items[I].Visible then
      Inc(VisibleCount);

  FGrid.RowCount := VisibleCount + 1;
  if FGrid.RowCount < 2 then
    FGrid.RowCount := 2;

  for Row := 1 to FGrid.RowCount - 1 do
    for I := 0 to FGrid.ColCount - 1 do
      FGrid.Cells[I, Row] := '';

  Row := 1;
  for I := 0 to FEmployees.Count - 1 do
  begin
    E := FEmployees.Items[I];
    if E.Visible then
    begin
      FGrid.Cells[0, Row] := E.Name;
      FGrid.Cells[1, Row] := E.Company;
      FGrid.Cells[2, Row] := E.City;
      FGrid.Cells[3, Row] := E.Country;
      Inc(Row);
    end;
  end;
end;

procedure TFormMain.ApplyFilter;
begin
  FManager.Rules[0].Active := True;
  FManager.Apply;
  RefreshGrid;
  UpdateStatus;
end;

procedure TFormMain.UpdateStatus;
var
  I, Visible, Total: Integer;
begin
  Total := FEmployees.Count;
  Visible := 0;
  for I := 0 to Total - 1 do
    if FEmployees.Items[I].Visible then
      Inc(Visible);

  if Visible = Total then
    LabelStatus.Caption := Format('Showing all %d records', [Total])
  else
    LabelStatus.Caption := Format('Showing %d of %d  (%d filtered out)',
      [Visible, Total, Total - Visible]);
end;

procedure TFormMain.BtnApplyClick(Sender: TObject);
begin
  ApplyFilter;
end;

procedure TFormMain.BtnClearClick(Sender: TObject);
begin
  EditSearch.Text := '';
  FManager.Rules[0].Active := False;
  FEmployees.ShowAll;
  RefreshGrid;
  UpdateStatus;
end;

procedure TFormMain.EditSearchKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    ApplyFilter;
end;

end.
