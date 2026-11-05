program Demo;

uses
  Vcl.Forms,
  UDemo in 'UDemo.pas' {frmHTMLDemo},
  UHTMLSamples in 'UHTMLSamples.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmHTMLDemo, frmHTMLDemo);
  Application.Run;
end.
