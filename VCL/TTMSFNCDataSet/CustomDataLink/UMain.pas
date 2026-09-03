unit UMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  VCL.Controls, VCL.Forms, VCL.Graphics, VCL.Dialogs, UMyDataLink,
  System.Rtti, VCL.StdCtrls, Data.DB, TMS.TMSFNCDataSet, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    TMSFNCDataSet1: TTMSFNCDataSet;
    Button1: TButton;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
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
  FDataLink := TMyDataLink.Create;
  FDataLink.OwnsObjects := True;
  FDataLink.InitSampleData;

  TMSFNCDataSet1.DataObject := FDataLink;
end;

end.
