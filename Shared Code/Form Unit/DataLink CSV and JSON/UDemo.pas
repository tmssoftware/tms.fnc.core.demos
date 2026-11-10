unit UDemo;

{ TMS FNC Core - DataLink CSV and JSON

  A TTMSFNCDataLinkCSV or a TTMSFNCDataLinkJSON turns a plain text file into the records of a TTMSFNCDataSet: the
  fields come from the file, the dataset navigates, edits, appends and deletes like any TDataSet, and with
  AutoSaveChanges every post goes back to the file. The demo writes a small product list to the temporary folder
  as CSV and as JSON and shows the records next to the text of the file. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTheme,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTheme,
  {$ENDIF}
  System.IOUtils, Data.DB, TMS.TMSFNCCustomDataLink, TMS.TMSFNCDataLinkCSV, TMS.TMSFNCDataLinkJSON, TMS.TMSFNCDataSet,
  UDemoLayout;

type
  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TDemoPanel;
    FContent: TDemoPanel;
    FSourceRadios: TArray<TDemoRadioButton>;
    FAutoSaveCheck: TDemoCheckBox;
    FFileText: TDemoText;
    FRecords: TDemoText;
    FFileView: TDemoText;
    FStatus: TDemoText;
    FDataSet: TTMSFNCDataSet;
    FLink: TTMSFNCCustomDataLink;
    FCSVFile, FJSONFile, FFileName: string;
    FShowing: Boolean;
    procedure SetAutoSave(AValue: Boolean);
    procedure CreateSettings;
    procedure CreateContent;
    procedure WriteSampleFiles;
    procedure OpenSource;
    procedure ShowRecords;
    procedure ShowFile;
    procedure SourceChanged(Sender: TObject);
    procedure AutoSaveChanged(Sender: TObject);
    procedure FirstClick(Sender: TObject);
    procedure PriorClick(Sender: TObject);
    procedure NextClick(Sender: TObject);
    procedure LastClick(Sender: TObject);
    procedure RestockClick(Sender: TObject);
    procedure AppendClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure ReloadClick(Sender: TObject);
    procedure DataChanged(DataSet: TDataSet);
  public
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}

const
  CSVText =
    'Name;Category;Price;Stock' + #13#10 +
    'Walnut desk;Furniture;749;4' + #13#10 +
    'Task chair;Furniture;289;12' + #13#10 +
    'Monitor arm;Accessories;89;30' + #13#10 +
    'Desk lamp;Lighting;59;17' + #13#10 +
    'Cable tray;Accessories;24;48' + #13#10 +
    'Floor lamp;Lighting;139;6' + #13#10;

  JSONText =
    '[' + #13#10 +
    '  {"Name": "Walnut desk", "Category": "Furniture", "Price": 749, "Stock": 4},' + #13#10 +
    '  {"Name": "Task chair", "Category": "Furniture", "Price": 289, "Stock": 12},' + #13#10 +
    '  {"Name": "Monitor arm", "Category": "Accessories", "Price": 89, "Stock": 30},' + #13#10 +
    '  {"Name": "Desk lamp", "Category": "Lighting", "Price": 59, "Stock": 17},' + #13#10 +
    '  {"Name": "Cable tray", "Category": "Accessories", "Price": 24, "Stock": 48},' + #13#10 +
    '  {"Name": "Floor lamp", "Category": "Lighting", "Price": 139, "Stock": 6}' + #13#10 +
    ']' + #13#10;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self, ThemeManager);
  FLayout.AddHeader('DataLink CSV and JSON',
    'TTMSFNCDataLinkCSV and TTMSFNCDataLinkJSON feed a TTMSFNCDataSet: fields from the file, navigation, editing and saving back',
    ['Fluent Light', 'Fluent Dark']);
  FCSVFile := TPath.Combine(TPath.GetTempPath, 'fnc-products.csv');
  FJSONFile := TPath.Combine(TPath.GetTempPath, 'fnc-products.json');
  WriteSampleFiles;
  FDataSet := TTMSFNCDataSet.Create(Self);
  FDataSet.AfterScroll := DataChanged;
  FDataSet.AfterPost := DataChanged;
  FDataSet.AfterDelete := DataChanged;
  CreateSettings;
  CreateContent;
  OpenSource;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FLayout.Free;
end;

procedure TForm1.WriteSampleFiles;
begin
  TFile.WriteAllText(FCSVFile, CSVText, TEncoding.UTF8);
  TFile.WriteAllText(FJSONFile, JSONText, TEncoding.UTF8);
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Source');
  FSourceRadios := FLayout.AddRadios(FSettings, 'Source', ['CSV file (TTMSFNCDataLinkCSV)', 'JSON file (TTMSFNCDataLinkJSON)'], 0,
    SourceChanged);
  FFileText := FLayout.AddText(FSettings, ' ');

  FLayout.AddCaption(FSettings, 'Changes');
  FAutoSaveCheck := FLayout.AddCheck(FSettings, 'AutoSaveChanges: write every post to the file', True, AutoSaveChanged);
  FLayout.AddButton(FSettings, 'Restock the current product (+10)', RestockClick);
  FLayout.AddButton(FSettings, 'Append a product', AppendClick);
  FLayout.AddButton(FSettings, 'Delete the current product', DeleteClick);
  FLayout.AddButton(FSettings, 'Reload the file', ReloadClick);
  FLayout.AddText(FSettings, 'Edit, Post, Append and Delete are the TDataSet calls; the link writes the records back ' +
    'in the format of the file. Reload reads the file again and brings a fresh copy of the sample data when it was ' +
    'deleted.');

  FLayout.AddCaption(FSettings, 'Navigate');
  FLayout.AddButton(FSettings, 'First', FirstClick);
  FLayout.AddButton(FSettings, 'Prior', PriorClick);
  FLayout.AddButton(FSettings, 'Next', NextClick);
  FLayout.AddButton(FSettings, 'Last', LastClick);
end;

procedure TForm1.CreateContent;
var
  left: TDemoPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  left := FLayout.AddBox(FContent, daLeft, 420, 0, 0, 0, 0);
  FLayout.AddCaption(left, 'Records of the TTMSFNCDataSet', 0);
  FRecords := FLayout.AddText(left, ' ');
  FRecords.TextRole := gtrPrimary;
  FLayout.Place(FRecords, daClient, 0, 16, 4, 16, 0);

  FLayout.AddCaption(FContent, 'The file', 0);
  FStatus := FLayout.AddText(FContent, ' ');
  FFileView := FLayout.AddText(FContent, ' ');
  FFileView.TextRole := gtrPrimary;
  FLayout.Place(FFileView, daClient, 0, 16, 4, 16, 0);
end;

procedure TForm1.OpenSource;
var
  csv: TTMSFNCDataLinkCSV;
  js: TTMSFNCDataLinkJSON;
begin
  FDataSet.Active := False;
  FDataSet.DataLink := nil;
  if Assigned(FLink) then
  begin
    FLink.Free;
    FLink := nil;
  end;
  if TDemoLayout.RadioIndex(FSourceRadios) = 0 then
  begin
    csv := TTMSFNCDataLinkCSV.Create(Self);
    { the separator is detected from the first lines; the first line holds the field names }
    csv.HasFieldNames := True;
    csv.FileName := FCSVFile;
    FFileName := FCSVFile;
    FLink := csv;
  end
  else
  begin
    js := TTMSFNCDataLinkJSON.Create(Self);
    { the root of the file is the array of records; a nested array is named with DataRootElement }
    js.FileName := FJSONFile;
    FFileName := FJSONFile;
    FLink := js;
  end;
  SetAutoSave(TDemoLayout.Checked(FAutoSaveCheck));
  FFileText.Text := FFileName;
  FDataSet.DataLink := FLink;
  FDataSet.Active := True;
  ShowRecords;
  ShowFile;
end;

procedure TForm1.ShowRecords;
var
  s: string;
  I, rec: Integer;
  f: TField;
begin
  if FShowing then
    Exit;
  if not FDataSet.Active then
  begin
    FRecords.Text := 'The dataset is closed.';
    Exit;
  end;
  { the walk over the records scrolls the dataset: no second table while this one is built }
  FShowing := True;
  FDataSet.DisableControls;
  try
    rec := FDataSet.RecNo;
    s := '<table cellpadding="4" cellspacing="0" style="border:1px solid var(--border)"><tr>';
    for I := 0 to FDataSet.FieldCount - 1 do
      s := s + '<th style="text-align:left;background:var(--surface-alt);border-bottom:1px solid var(--border)">' +
        FDataSet.Fields[I].FieldName + ' <span style="color:var(--text-tertiary)">' + FieldTypeNames[FDataSet.Fields[I].DataType] +
        '</span></th>';
    s := s + '</tr>';
    FDataSet.First;
    while not FDataSet.Eof do
    begin
      s := s + '<tr>';
      for I := 0 to FDataSet.FieldCount - 1 do
      begin
        f := FDataSet.Fields[I];
        if FDataSet.RecNo = rec then
          s := s + '<td style="color:var(--accent-text);background:var(--selection);border-bottom:1px solid var(--divider)"><b>' +
            f.DisplayText + '</b></td>'
        else
          s := s + '<td style="border-bottom:1px solid var(--divider)">' + f.DisplayText + '</td>';
      end;
      s := s + '</tr>';
      FDataSet.Next;
    end;
    if rec > 0 then
      FDataSet.RecNo := rec;
    s := s + '</table><br><span style="color:var(--text-secondary)">' + IntToStr(FDataSet.RecordCount) +
      ' records, record ' + IntToStr(FDataSet.RecNo) + ' is current. The field types come from the link: a CSV file ' +
      'gives strings, a JSON file numbers and strings.</span>';
    FRecords.Text := s;
  finally
    FDataSet.EnableControls;
    FShowing := False;
  end;
end;

procedure TForm1.ShowFile;
var
  s: string;
begin
  if TFile.Exists(FFileName) then
  begin
    s := TFile.ReadAllText(FFileName, TEncoding.UTF8);
    s := StringReplace(s, '&', '&amp;', [rfReplaceAll]);
    s := StringReplace(s, '<', '&lt;', [rfReplaceAll]);
    s := StringReplace(s, #13#10, '<br>', [rfReplaceAll]);
    FFileView.Text := '<code>' + s + '</code>';
    FStatus.Text := 'The text of ' + ExtractFileName(FFileName) + ' as it is on disk.';
  end
  else
  begin
    FFileView.Text := '';
    FStatus.Text := 'The file does not exist.';
  end;
end;

procedure TForm1.SourceChanged(Sender: TObject);
begin
  if Assigned(FLink) then
    OpenSource;
end;

procedure TForm1.SetAutoSave(AValue: Boolean);
begin
  if FLink is TTMSFNCDataLinkCSV then
    TTMSFNCDataLinkCSV(FLink).AutoSaveChanges := AValue
  else if FLink is TTMSFNCDataLinkJSON then
    TTMSFNCDataLinkJSON(FLink).AutoSaveChanges := AValue;
end;

procedure TForm1.AutoSaveChanged(Sender: TObject);
begin
  if Assigned(FLink) then
    SetAutoSave(TDemoLayout.Checked(FAutoSaveCheck));
end;

procedure TForm1.DataChanged(DataSet: TDataSet);
begin
  ShowRecords;
  ShowFile;
end;

procedure TForm1.FirstClick(Sender: TObject);
begin
  FDataSet.First;
end;

procedure TForm1.PriorClick(Sender: TObject);
begin
  FDataSet.Prior;
end;

procedure TForm1.NextClick(Sender: TObject);
begin
  FDataSet.Next;
end;

procedure TForm1.LastClick(Sender: TObject);
begin
  FDataSet.Last;
end;

procedure TForm1.RestockClick(Sender: TObject);
begin
  if FDataSet.RecordCount = 0 then
    Exit;
  FDataSet.Edit;
  FDataSet.FieldByName('Stock').AsInteger := FDataSet.FieldByName('Stock').AsInteger + 10;
  FDataSet.Post;
end;

procedure TForm1.AppendClick(Sender: TObject);
begin
  FDataSet.Append;
  FDataSet.FieldByName('Name').AsString := 'Bookshelf ' + IntToStr(FDataSet.RecordCount);
  FDataSet.FieldByName('Category').AsString := 'Furniture';
  FDataSet.FieldByName('Price').AsInteger := 199;
  FDataSet.FieldByName('Stock').AsInteger := 1;
  FDataSet.Post;
end;

procedure TForm1.DeleteClick(Sender: TObject);
begin
  if FDataSet.RecordCount > 0 then
    FDataSet.Delete;
end;

procedure TForm1.ReloadClick(Sender: TObject);
begin
  if not TFile.Exists(FFileName) then
    WriteSampleFiles;
  OpenSource;
end;

end.
