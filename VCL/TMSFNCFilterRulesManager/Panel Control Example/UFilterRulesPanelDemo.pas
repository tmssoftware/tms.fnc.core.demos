unit UFilterRulesPanelDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, TMS.TMSFNCFilterRulesManager;

type
  TForm1 = class(TForm)
    pnlControls: TPanel;
    btnCreateInvoice: TButton;
    btnApproveInvoice: TButton;
    btnSendReminder: TButton;
    btnArchiveInvoice: TButton;
    btnExportInvoices: TButton;
    lblCustomer: TLabel;
    lblDueDate: TLabel;
    chkIncludePaid: TCheckBox;
    rbOverdueOnly: TRadioButton;
    btnToggleButtons: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnToggleButtonsClick(Sender: TObject);
  public
    mgr: TTMSFNCFilterRulesManager;
  end;

var
  Form1: TForm1;

implementation

uses
  System.StrUtils;

{$R *.dfm}

procedure TForm1.btnToggleButtonsClick(Sender: TObject);
begin
  mgr.Rules[0].Active := not mgr.Rules[0].Active;
  mgr.Rules[0].Apply;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ReportMemoryLeaksOnShutdown := True;
  mgr := TTMSFNCFilterRulesManager.Create(Self);
  mgr.AddRuleStartsWith('ShowActionButtons', pnlControls, 'Controls[*]', 'Name',
    'btn', False).AddVisibilityAction;
end;

end.
