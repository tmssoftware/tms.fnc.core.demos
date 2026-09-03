unit UDevToolsDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes,
  FMX.Edit, FMX.StdCtrls, FMX.TMSFNCCustomControl, FMX.TMSFNCWebBrowser,
  FMX.TMSFNCEdgeWebBrowser, FMX.Controls.Presentation, FMX.TabControl,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TDevToolsForm = class(TForm)
    Panel1: TPanel;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    NavBtn: TButton;
    NavEdit: TEdit;
    Panel2: TPanel;
    Splitter1: TSplitter;
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
  private
    { Private declarations }
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
end.
