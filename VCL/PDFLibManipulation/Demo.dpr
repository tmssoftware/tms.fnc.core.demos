program Demo;

uses
  Vcl.Forms,
  UDemo in 'UDemo.pas' {Form131};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm131, Form131);
  Application.Run;
end.
