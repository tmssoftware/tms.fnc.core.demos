program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in 'UDemo.pas' {frmHTMLDemo},
  UHTMLSamples in 'UHTMLSamples.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmHTMLDemo, frmHTMLDemo);
  Application.Run;
end.
