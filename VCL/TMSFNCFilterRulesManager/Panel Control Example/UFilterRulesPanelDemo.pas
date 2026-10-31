unit UFilterRulesPanelDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes,
  Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Vcl.ExtCtrls, TMS.TMSFNCFilterRulesManager,
  VCL.TMSFNCTheme;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    StepsCaption: TLabel;
    StepsHint: TLabel;
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
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
  public
    mgr: TTMSFNCFilterRulesManager;
  end;

var
  Form1: TForm1;

implementation

uses
  System.StrUtils;

{$R *.dfm}

{ demo-colors: the panel with the invoice controls keeps a light surface (clWindow) on both
  themes: the rule works on its controls by name, whatever their colour. }

procedure TForm1.btnToggleButtonsClick(Sender: TObject);
begin
  mgr.Rules[0].Active := not mgr.Rules[0].Active;
  mgr.Rules[0].Apply;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  mgr := TTMSFNCFilterRulesManager.Create(Self);
  mgr.AddRuleStartsWith('ShowActionButtons', pnlControls, 'Controls[*]', 'Name',
    'btn', False).AddVisibilityAction;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := clWindowText;
    sec := clGrayText;
  end;
  DemoTitle.Font.Color := txt;
  StepsCaption.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  StepsHint.Font.Color := sec;
end;

procedure TForm1.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
