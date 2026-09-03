program Demo;

uses
  VCL.Forms, 
  UMain in 'UMain.pas' {Form4}, 
  UConsts in 'UConsts.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.
