program DevToolsDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UDevToolsDemo in 'UDevToolsDemo.pas' {DevToolsForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TDevToolsForm, DevToolsForm);
  Application.Run;
end.
