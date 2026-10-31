unit UDevToolsDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Edit, FMX.StdCtrls, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCEdgeWebBrowser, FMX.Controls.Presentation, FMX.TabControl,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo, FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TDevToolsForm = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    AddressBar: TLayout;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    NavBtn: TButton;
    NavEdit: TEdit;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    InfoBtn: TButton;
    LoggingMemo: TMemo;
    ClrLogBtn: TButton;
    MethodResponseMemo: TMemo;
    MethodEdit: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    ExeMethodBtn: TButton;
    MethodParamMemo: TMemo;
    Label3: TLabel;
    Label4: TLabel;
    SubscribeEdit: TEdit;
    SubscribeBtn: TButton;
    EventMemo: TMemo;
    ClrEventBtn: TButton;
    Label5: TLabel;
    procedure InfoBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetConsoleMessage(Sender: TObject;
      ALogEntry: TTMSFNCWebBrowserLogEntry);
    procedure ClrLogBtnClick(Sender: TObject);
    procedure ExeMethodBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1DevToolsMethodCompleted(Sender: TObject;
      AEventName, AJSONResponse: string);
    procedure TMSFNCEdgeWebBrowser1DevToolsSubscribedEvent(Sender: TObject;
      AEventName, AJSONResponse: string);
    procedure ClrEventBtnClick(Sender: TObject);
    procedure SubscribeBtnClick(Sender: TObject);
    procedure NavBtnClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  DevToolsForm: TDevToolsForm;

implementation

{$R *.fmx}

//Execute Method
procedure TDevToolsForm.ExeMethodBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.CallDevToolsProtocolMethod(MethodEdit.Text, MethodParamMemo.Text);
end;

//Subscribe to Event
procedure TDevToolsForm.SubscribeBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.SubscribeDevtools(SubscribeEdit.Text);
end;

// Retrieve the default logging
procedure TDevToolsForm.TMSFNCEdgeWebBrowser1GetConsoleMessage(Sender: TObject; ALogEntry: TTMSFNCWebBrowserLogEntry);
var
  lvl: string;
begin
  case AlogEntry.Level of
    lslUnknown: lvl := 'Unknown';
    lslVerbose: lvl := 'Verbose';
    lslInfo: lvl := 'Info';
    lslError: lvl := 'Error';
    lslWarning: lvl := 'Warning';
  end;
  LoggingMemo.Lines.Add(lvl + ': ' + ALogEntry.Text);
  LoggingMemo.Lines.Add('----------------------')
end;

//Other functions
procedure TDevToolsForm.TMSFNCEdgeWebBrowser1DevToolsMethodCompleted(Sender: TObject; AEventName, AJSONResponse: string);
begin
  MethodResponseMemo.Lines.Clear;
  MethodResponseMemo.Lines.Add(AEventName);
  MethodResponseMemo.Lines.Add(TTMSFNCUtils.ParseJSON(AJSONResponse).Format);
end;

procedure TDevToolsForm.TMSFNCEdgeWebBrowser1DevToolsSubscribedEvent(Sender: TObject; AEventName, AJSONResponse: string);
begin
  EventMemo.Lines.Add(AEventName + ':');
  EventMemo.Lines.Add(TTMSFNCUtils.ParseJSON(AJSONResponse).Format);
  EventMemo.Lines.Add('----------------------')
end;

procedure TDevToolsForm.ClrEventBtnClick(Sender: TObject);
begin
  EventMemo.Lines.Clear;
end;

procedure TDevToolsForm.ClrLogBtnClick(Sender: TObject);
begin
  LoggingMemo.Lines.Clear;
end;

procedure TDevToolsForm.InfoBtnClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://chromedevtools.github.io/devtools-protocol/');
end;

procedure TDevToolsForm.NavBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(NavEdit.Text);
end;
procedure TDevToolsForm.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TDevToolsForm.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label: the native labels take the text colours of the theme in effect (without
  a theme: the platform's). The theme manager colours the form; native buttons, edits, lists and
  memos keep the platform look, which is readable on a light and on a dark form. The page in the
  browser is not themed. }
procedure TDevToolsForm.ThemeChanged(Sender: TObject);
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
  DemoDescription.FontColor := sec;
end;

procedure TDevToolsForm.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
