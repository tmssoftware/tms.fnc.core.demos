program DownloadManagerDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UEdgeDownloadManagerDemo in 'UEdgeDownloadManagerDemo.pas' {Form3};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
