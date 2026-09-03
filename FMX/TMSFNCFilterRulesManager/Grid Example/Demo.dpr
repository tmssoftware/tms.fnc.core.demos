program Demo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDemo in 'UDemo.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
