program Demo;

uses
  VCL.Forms, 
  UMain in 'UMain.pas' {Form1}, 
  UMyDataLink in 'UMyDataLink.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
