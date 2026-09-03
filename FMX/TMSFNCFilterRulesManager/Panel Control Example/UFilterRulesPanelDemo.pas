unit UFilterRulesPanelDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, TMS.TMSFNCFilterRulesManager;

type
  TForm1 = class(TForm)
    pnlControls: TPanel;
    btnCreateInvoice: TButton;
    btnApproveInvoice: TButton;
    btnSendReminder: TButton;
    btnArchiveInvoice: TButton;
    btnExportInvoices: TButton;
    btnToggleButtons: TButton;
    lblCustomer: TLabel;
    lblDueDate: TLabel;
    chkIncludePaid: TCheckBox;
    rbOverdueOnly: TRadioButton;
    procedure FormCreate(Sender: TObject);
    procedure btnToggleButtonsClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    mgr: TTMSFNCFilterRulesManager;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.btnToggleButtonsClick(Sender: TObject);
begin
  mgr.Rules[0].Active := not mgr.Rules[0].Active;

  mgr.Rules[0].Apply;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  mgr := TTMSFNCFilterRulesManager.Create(Self);
  mgr.AddRuleStartsWith('ShowActionButtons', pnlControls, 'Controls[*]', 'Name', 'btn', False).AddVisibilityAction;
end;

end.
