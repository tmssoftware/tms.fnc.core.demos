unit UMyDataLink;

interface

uses
  Classes, Db, Rtti, Generics.Collections,
  TMS.TMSFNCDataSet;

type
  //In this example we have the following:
  //A TObjectList that contains all the data records and a TMyRecord object
  //Which represents the record itself.

  TMyRecord = class
  private
    FName: string;
    FAge: Integer;
    FCountry: string;
  public
    constructor Create(AName: string; AAge: Integer; ACountry: string);
    property Name: string read FName write FName;
    property Age: Integer read FAge write FAge;
    property Country: string read FCountry write FCountry;
  end;

  TMyDataLink = class(TObjectList<TMyRecord>, ITMSFNCDataObject)
  protected
    procedure Activate(AValue: Boolean);
    procedure AddRecord(ARecord: TValue);
    procedure DeleteRecord(AIndex: Integer);
    procedure InsertRecord(AIndex: Integer; ARecord: TValue);
    function CreateDefaultRecord: TValue;
    procedure InitializeFieldDefs(AFieldDefs: TFieldDefs);
    function GetRecord(AIndex: Integer): TValue;
    function GetRecordIndex(ARecord: TValue): Integer;
    function GetRecordCount: Integer;
    function GetRecordValue(ARecord: TValue; AField: string; AFieldType: TFieldType): ValueType;
    procedure SetRecordValue(ARecordIndex: Integer; AField: string; AValue: ValueType);
    function CompareRecords(AField: string; ARecord1, ARecord2: TValue): Integer;
    function Clone: TObject;
    procedure SetNotification(ANotifyObject: ITMSFNCDataObjectNotification);
  protected
    function _AddRef: Integer; stdcall;
    function QueryInterface(const IID: TGUID; out Obj): HResult; stdcall;
    function _Release: Integer; stdcall;
  public
    procedure InitSampleData;
  end;

implementation

{ TMyRecord }

constructor TMyRecord.Create(AName: string; AAge: Integer; ACountry: string);
begin
  inherited Create;
  FName := AName;
  FAge := AAge;
  FCountry := ACountry;
end;

{ TMyDataLink }

procedure TMyDataLink.Activate(AValue: Boolean);
begin
  //Use this when you need to do something during dataset Active changes
  //Example: load a file automatically
end;

procedure TMyDataLink.AddRecord(ARecord: TValue);
begin
  //The record in this case will be equivalent to TMyRecord
  //It was already created (CreateDefaultRecord) but needs to be added
  //This will add to the end
  Add(ARecord.AsType<TMyRecord>);
end;

function TMyDataLink.Clone: TObject;
begin
  //This is needed whenever the dataset is cloned. It needs a clone of the data
  //so it doesn't reference any of the original data.
  //TTMSFNCDataGrid is using this for example.

  //Right now just return nil instead of cloning
  Result := nil;
end;

function TMyDataLink.CompareRecords(AField: string; ARecord1,
  ARecord2: TValue): Integer;
begin
  //Used when sorting
  //If you know beforehand that you are not going to sort your data, then
  //you might skip the implementation to save time
  Result := 0;
end;

function TMyDataLink.CreateDefaultRecord: TValue;
begin
  //Create default record object
  //This is then will be added later (e.g. dataset insert)
  Result := TMyRecord.Create('', 0, '');
end;

procedure TMyDataLink.DeleteRecord(AIndex: Integer);
begin
  //Deleting a record by index
  Delete(AIndex);
end;

function TMyDataLink.GetRecord(AIndex: Integer): TValue;
begin
  //Get a record by index
  Result := Items[AIndex];
end;

function TMyDataLink.GetRecordCount: Integer;
begin
  //Return how many record items we have
  Result := Count;
end;

function TMyDataLink.GetRecordIndex(ARecord: TValue): Integer;
begin
  //Get the index of a given record
  Result := IndexOf(ARecord.AsType<TMyRecord>)
end;

function TMyDataLink.GetRecordValue(ARecord: TValue; AField: string; AFieldType: TFieldType): ValueType;
var
  ctx: TRttiContext;
  rttitype: TRttiType;
  rttiprop: TRttiProperty;
begin
  //Extract a value from a given record by the field name
  //You can either manually parse the object or use RTTI if applicable
  ctx := TRttiContext.Create;
  try
    rttitype := ctx.GetType(ARecord.AsType<TMyRecord>.ClassType);
    rttiprop := rttitype.GetProperty(AField);
    Result := rttiprop.GetValue(ARecord.AsType<TMyRecord>).AsVariant;
  finally
    ctx.free;
  end;

  //Having access to AFieldType can help with conversion
  //For example: all data is string, but it is expected a date will be returned
  //as a TDateTime. You can validate if AFieldType is ftDate/ftDateTime
  //and convert accordingly.
end;

procedure TMyDataLink.InitializeFieldDefs(AFieldDefs: TFieldDefs);
begin
  //Add field definitions, here I'm using the same field names as TMyRecord
  //So I can use RTTI to get/set data
  AFieldDefs.Add('Name', ftString, 255);
  AFieldDefs.Add('Age', ftInteger);
  AFieldDefs.Add('Country', ftString, 255);

  //The stuff above is simple, but this can be more complex, for example:
  //Needing to parse a whole line of string to determine types
end;

procedure TMyDataLink.InsertRecord(AIndex: Integer; ARecord: TValue);
begin
  //Insert a previously created record to an index
  Insert(AIndex, ARecord.AsType<TMyRecord>);
end;

procedure TMyDataLink.SetNotification(
  ANotifyObject: ITMSFNCDataObjectNotification);
begin
  //This is only needed when you want to signal back to the dataset to:
  //- Refresh
  //- Deactivate
  //Then you'd save ANotifyObject to a variable here to use later
end;

procedure TMyDataLink.SetRecordValue(ARecordIndex: Integer; AField: string;
  AValue: ValueType);
var
  ctx: TRttiContext;
  rttitype: TRttiType;
  rttiprop: TRttiProperty;
begin
  //Set a record value based on index and field name
  //Similarly to GetRecordValue, you can do manual parsing or use RTTI
  ctx := TRttiContext.Create;
  try
    rttitype := ctx.GetType(Items[ARecordIndex].ClassType);
    rttiprop := rttitype.GetProperty(AField);
    rttiprop.SetValue(Items[ARecordIndex], TValue.From(AValue));
  finally
    ctx.free;
  end;
end;

function TMyDataLink._AddRef: Integer;
begin
  Result := -1;
end;

function TMyDataLink._Release: Integer;
begin
  Result := -1;
end;

function TMyDataLink.QueryInterface(const IID: TGUID; out Obj): HResult;
const
  E_NOINTERFACE = HResult($80004002);
begin
  if GetInterface(IID, Obj) then Result := 0 else Result := E_NOINTERFACE;
end;

procedure TMyDataLink.InitSampleData;
var
  a, I: Integer;
  n, c: string;
begin
  for I := 1 to 30 do
  begin
    case Random(120) mod 5 of
      0: n := 'David';
      1: n := 'Laura';
      2: n := 'Isaac';
      3: n := 'Marie';
      else
        n := 'Leon';
    end;

    case Random(120) mod 5 of
      0: n := n + ' Kleermakers';
      1: n := n + ' Tailor';
      2: n := n + ' Terzi';
      3: n := n + ' Sastre';
      else
        n := n + ' Schneider';
    end;

    a := 20 + Random(40);

    case Random(120) mod 5 of
      0: c := 'Australia';
      1: c := 'Spain';
      2: c := 'France';
      else
        c := 'Denmark';
    end;

    Add(TMyRecord.Create(n, a, c));
  end;
end;

end.
