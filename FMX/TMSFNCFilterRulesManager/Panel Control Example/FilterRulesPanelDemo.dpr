program FilterRulesPanelDemo;

uses
  System.StartUpCopy,
  FMX.Forms,
  UFilterRulesPanelDemo in 'UFilterRulesPanelDemo.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
