unit UDevTools;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes,
  VCL.TMSFNCCustomControl, VCL.TMSFNCWebBrowser, VCL.TMSFNCEdgeWebBrowser;

type
  TForm3 = class(TForm)
    Splitter2: TSplitter;
    Panel2: TPanel;
    InfoBtn: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    LoggingMemo: TMemo;
    ClrLogBtn: TButton;
    Button2: TButton;
    NavEdit: TEdit;
    TMSFNCEdgeWebBrowser1: TTMSFNCEdgeWebBrowser;
    Label1: TLabel;
    SubscribeEdit: TEdit;
    SubscribeBtn: TButton;
    EventMemo: TMemo;
    ClrEventBtn: TButton;
    Label2: TLabel;
    MethodEdit: TEdit;
    Label3: TLabel;
    MethodParamMemo: TMemo;
    MethodResponseMemo: TMemo;
    Label4: TLabel;
    ExeMethodBtn: TButton;
    Label5: TLabel;
    procedure Button2Click(Sender: TObject);
    procedure InfoBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1GetConsoleMessage(Sender: TObject;
      ALogEntry: TTMSFNCWebBrowserLogEntry);
    procedure ClrLogBtnClick(Sender: TObject);
    procedure ExeMethodBtnClick(Sender: TObject);
    procedure SubscribeBtnClick(Sender: TObject);
    procedure ClrEventBtnClick(Sender: TObject);
    procedure TMSFNCEdgeWebBrowser1DevToolsMethodCompleted(Sender: TObject;
      AEventName, AJSONResponse: string);
    procedure TMSFNCEdgeWebBrowser1DevToolsSubscribedEvent(Sender: TObject;
      AEventName, AJSONResponse: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button2Click(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.Navigate(NavEdit.Text);
end;

procedure TForm3.ClrEventBtnClick(Sender: TObject);
begin
  EventMemo.Lines.Clear;
end;

procedure TForm3.ClrLogBtnClick(Sender: TObject);
begin
  LoggingMemo.Lines.Clear;
end;

procedure TForm3.ExeMethodBtnClick(Sender: TObject);
begin
  //Other Possible: CSS.getMediaQueries
  TMSFNCEdgeWebBrowser1.CallDevToolsProtocolMethod(MethodEdit.Text, MethodParamMemo.Text);
end;

procedure TForm3.InfoBtnClick(Sender: TObject);
begin
  TTMSFNCUtils.OpenURL('https://chromedevtools.github.io/devtools-protocol/');
end;

procedure TForm3.SubscribeBtnClick(Sender: TObject);
begin
  TMSFNCEdgeWebBrowser1.SubscribeDevtools(SubscribeEdit.Text);
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DevToolsMethodCompleted(Sender: TObject;
  AEventName, AJSONResponse: string);
begin
  MethodResponseMemo.Lines.Clear;
  MethodResponseMemo.Lines.Add(AEventName);
  MethodResponseMemo.Lines.Add(TTMSFNCUtils.ParseJSON(AJSONResponse).Format);
end;

procedure TForm3.TMSFNCEdgeWebBrowser1DevToolsSubscribedEvent(Sender: TObject;
  AEventName, AJSONResponse: string);
begin
  EventMemo.Lines.Add(AEventName + ':');
  EventMemo.Lines.Add(TTMSFNCUtils.ParseJSON(AJSONResponse).Format);
  EventMemo.Lines.Add('----------------------')
end;

procedure TForm3.TMSFNCEdgeWebBrowser1GetConsoleMessage(Sender: TObject; ALogEntry: TTMSFNCWebBrowserLogEntry);
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

end.
