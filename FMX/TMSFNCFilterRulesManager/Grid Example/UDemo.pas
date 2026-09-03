unit UDemo;

// Demonstrates TTMSFNCFilterRulesManager with plain Delphi objects and a
// standard FMX TStringGrid.  No TMS data-display component is used.
//
// The filter manager iterates FEmployees.Items[0..*] via RTTI, evaluates
// each TEmployee.Name against the StartsWith rule, and writes True/False to
// TEmployee.Visible.  The grid is then rebuilt from visible employees only.

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Generics.Collections,
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.Forms,
  FMX.StdCtrls, FMX.Edit, FMX.Grid, FMX.Grid.Style, FMX.ScrollBox,
  TMS.TMSFNCValue,
  TMS.TMSFNCFilterRulesManager, FMX.ListBox;

// ---------------------------------------------------------------------------
//  TEmployee — plain published-property object; RTTI can read/write fields
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
//  TEmployeeList — TComponent wrapper so FilterRulesManager can use it as a
//  source.  GetItem / Count give the RTTI path "Items[0..*]" its meaning:
//    - resolver strips trailing 's' → finds GetItem method
//    - ResolveDimFromParam tries 'Count' as last resort → returns total count
// ---------------------------------------------------------------------------
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

// ---------------------------------------------------------------------------
//  Form
// ---------------------------------------------------------------------------
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
      var KeyChar: Char; Shift: TShiftState);
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
    ('Alice Hoffman',    'Innovatech',    'Amsterdam',   'Netherlands'),
    ('Bruno Maes',       'Innovatech',    'Brussels',    'Belgium'),
    ('Clara Jensen',     'NordSoft',      'Copenhagen',  'Denmark'),
    ('David Park',       'Crestline',     'Seoul',       'South Korea'),
    ('Andres Rossi',       'Crestline',     'Rome',        'Italy'),
    ('Carl Walsh',      'NordSoft',      'Dublin',      'Ireland'),
    ('George Muller',    'Axiom Systems', 'Berlin',      'Germany'),
    ('Emma Novak',       'Axiom Systems', 'Prague',      'Czech Republic'),
    ('Carl Petrov',      'Axiom Systems', 'Sofia',       'Bulgaria'),
    ('Alice Santos',     'Crestline',     'Lisbon',      'Portugal'),
    ('Kevin Larsson',    'NordSoft',      'Stockholm',   'Sweden'),
    ('Evelyne Blanc',      'Innovatech',    'Paris',       'France'),
    ('Alberto Conti',      'Crestline',     'Milan',       'Italy'),
    ('Bernd Okafor',      'Innovatech',    'Lagos',       'Nigeria'),
    ('Casper Lindqvist',  'NordSoft',      'Gothenburg',  'Sweden'),
    ('Damiano Ferreira',   'Axiom Systems', 'Porto',       'Portugal'),
    ('Gregory Dubois',   'Innovatech',    'Lyon',        'France'),
    ('Alfred De Wachter',       'NordSoft',      'Busan',       'South Korea'),
    ('Diana Bauer',     'Axiom Systems', 'Munich',      'Germany'),
    ('Amelia Volkov',      'Crestline',     'Moscow',      'Russia')
  );

implementation

{$R *.fmx}

// ---------------------------------------------------------------------------
//  TEmployeeList
// ---------------------------------------------------------------------------

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
  E.Name    := AName;
  E.Company := ACompany;
  E.City    := ACity;
  E.Country := ACountry;
  E.Visible := True;
  FList.Add(E);
end;

function TEmployeeList.GetItem(AIndex: Integer): TEmployee;
begin
  Result := FList[AIndex];
end;

function TEmployeeList.GetCount: Integer;
begin
  Result := FList.Count;
end;

procedure TEmployeeList.ShowAll;
var
  i: Integer;
begin
  for i := 0 to FList.Count - 1 do
    FList[i].Visible := True;
end;

// ---------------------------------------------------------------------------
//  TFormMain
// ---------------------------------------------------------------------------

procedure TFormMain.FormCreate(Sender: TObject);
begin
  FEmployees := TEmployeeList.Create(Self);
  PopulateData;
  SetupGrid;

  FManager := TTMSFNCFilterRulesManager.Create(Self);
  // FilterRulesManager iterates Items[0..*] on FEmployees via RTTI,
  // tests each TEmployee.Name, and sets TEmployee.Visible accordingly.
FManager.AddPlaceholder('SearchFieldComboIndex', SearchFieldCombo, 'ItemIndex');
FManager.AddPlaceholder('FilterField', SearchFieldCombo, 'Items[{SearchFieldComboIndex}]');
FManager.AddPlaceholder('SearchText', EditSearch, 'Text');

  FManager.AddRuleStartsWith('NameFilter', FEmployees, 'Items[0..*]', '{FilterField}', '{SearchText}').AddVisibilityAction;
  UpdateStatus;
end;

procedure TFormMain.SetupGrid;
const
  HEADERS: array[0..3] of string = ('Name', 'Company', 'City', 'Country');
  WIDTHS:  array[0..3] of Single = (220, 180, 150, 130);
var
  Col: TStringColumn;
  i: Integer;
begin
  FGrid := TStringGrid.Create(Self);
  FGrid.Parent := Self;
  FGrid.Align := TAlignLayout.Client;
  FGrid.RowCount := 0;

  for i := 0 to High(HEADERS) do
  begin
    Col := TStringColumn.Create(FGrid);
    Col.Header := HEADERS[i];
    Col.Width  := WIDTHS[i];
    FGrid.AddObject(Col);
  end;

  RefreshGrid;
end;

procedure TFormMain.PopulateData;
var
  i: Integer;
begin
  for i := 0 to High(SAMPLE_DATA) do
    FEmployees.Add(
      SAMPLE_DATA[i][0], SAMPLE_DATA[i][1],
      SAMPLE_DATA[i][2], SAMPLE_DATA[i][3]);
end;

procedure TFormMain.RefreshGrid;
var
  i, row: Integer;
  E: TEmployee;
begin
  // Count visible records first so RowCount is set once.
  row := 0;
  for i := 0 to FEmployees.Count - 1 do
    if FEmployees.Items[i].Visible then
      Inc(row);

  FGrid.BeginUpdate;
  try
    FGrid.RowCount := row;
    row := 0;
    for i := 0 to FEmployees.Count - 1 do
    begin
      E := FEmployees.Items[i];
      if E.Visible then
      begin
        FGrid.Cells[0, row] := E.Name;
        FGrid.Cells[1, row] := E.Company;
        FGrid.Cells[2, row] := E.City;
        FGrid.Cells[3, row] := E.Country;
        Inc(row);
      end;
    end;
  finally
    FGrid.EndUpdate;
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
  i, Visible, Total: Integer;
begin
  Total   := FEmployees.Count;
  Visible := 0;
  for i := 0 to Total - 1 do
    if FEmployees.Items[i].Visible then
      Inc(Visible);
  if Visible = Total then
    LabelStatus.Text := Format('Showing all %d records', [Total])
  else
    LabelStatus.Text := Format('Showing %d of %d  (%d filtered out)',
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
  RefreshGrid;
  UpdateStatus;
end;

procedure TFormMain.EditSearchKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
    ApplyFilter;
end;

end.
