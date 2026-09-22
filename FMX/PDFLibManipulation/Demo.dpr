program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in 'UDemo.pas' {Form131};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm131, Form131);
  Application.Run;
end.
