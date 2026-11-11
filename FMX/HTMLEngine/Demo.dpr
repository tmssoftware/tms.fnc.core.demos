program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in 'UDemo.pas' {frmHTMLDemo},
  UHTMLSamples in '..\..\Shared Code\Business Logic\HTML Engine\UHTMLSamples.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmHTMLDemo, frmHTMLDemo);
  Application.Run;
end.
