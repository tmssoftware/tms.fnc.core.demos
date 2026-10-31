unit UFilterRulesPanelDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, TMS.TMSFNCFilterRulesManager,
  FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    StepsCaption: TLabel;
    StepsHint: TLabel;
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
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    mgr: TTMSFNCFilterRulesManager;
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

{ demo-colors: the panel with the invoice controls keeps the platform look (a light surface) on
  both themes: the rule works on its controls by name, whatever their colour. }

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
  mgr.AddRuleStartsWith('ShowActionButtons', pnlControls, 'Controls[*]', 'Name', 'btn', False).AddVisibilityAction;
end;


procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and grids keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TAlphaColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := TAlphaColorRec.Black;
    sec := $FF5B6470;
  end;
  DemoTitle.FontColor := txt;
  StepsCaption.FontColor := txt;
  DemoDescription.FontColor := sec;
  StepsHint.FontColor := sec;
end;

procedure TForm1.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
