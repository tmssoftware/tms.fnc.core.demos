unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, UMyDataLink,
  System.Rtti, FMX.Grid.Style, Data.Bind.EngExt, Fmx.Bind.DBEngExt,
  Fmx.Bind.Grid, System.Bindings.Outputs, Fmx.Bind.Editors,
  Data.Bind.Components, Data.Bind.Grid, Data.Bind.DBScope, FMX.ScrollBox,
  FMX.Grid, FMX.Controls.Presentation, FMX.StdCtrls, Data.DB, TMS.TMSFNCDataSet;

type
  TForm1 = class(TForm)
    TMSFNCDataSet1: TTMSFNCDataSet;
    Button1: TButton;
    Grid1: TGrid;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkGridToDataSourceBindSourceDB1: TLinkGridToDataSource;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    FDataLink: TMyDataLink;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.Button1Click(Sender: TObject);
var
  I: Integer;
begin
  TMSFNCDataSet1.Active := True;

  for I := 0 to Grid1.ColumnCount - 1 do
    Grid1.Columns[I].Width := 150;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FDataLink.Free;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FDataLink := TMyDataLink.Create;
  FDataLink.OwnsObjects := True;
  FDataLink.InitSampleData;

  TMSFNCDataSet1.DataObject := FDataLink;
end;

end.
