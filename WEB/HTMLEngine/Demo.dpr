program Demo;

uses
  Vcl.Forms,
  WEBLib.Forms,
  UDemo in 'UDemo.pas' {Form1: TWebForm} {*.html},
  UHTMLSamples in '..\..\Shared Code\Business Logic\HTML Engine\UHTMLSamples.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
