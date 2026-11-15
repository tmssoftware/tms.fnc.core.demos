unit UDemo;

{ TMS FNC Core - AI Menu Studio

  A restaurant designs its menu card with the AI service of TMS FNC Core (TTMSFNCAIService) and its interaction
  controls. Ask for a change in your own words ("a brunch menu", "make it vegan", "add desserts"): the service asks
  the model for a plan, the plan view (TTMSFNCAIPlanView) lists its steps with the reason of each, nothing changes
  before you accept a step or apply them all, the preview lens (TTMSFNCAIPreviewLens) shows the whole plan on the
  card while you hold it, and one Undo takes the plan back. A vague request ("make it premium") gets clarification
  cards (TTMSFNCAIChoiceCards) first. The style fields are promptable (TTMSFNCAIPromptEdit): type a value or a
  phrase ("a softer terracotta", "a bit larger"). The drop zone (TTMSFNCAIDropZone) takes a CSV file of dishes, an
  image or a text and offers what can be done with it; nothing leaves the computer before you pick an action.

  No key and no network: the provider of the service is an OpenAI-compatible model whose answers this demo writes
  itself (TDemoModel, set as the Transport of the service). Replace it with a real provider through
  Service.DefaultProfile (Provider, model, key) and the same form works with a real model.

  The same unit runs in the browser (TMS WEB Core): there a real provider is reached through a proxy URL of your
  server (the key never is in the page), and the drop zone takes the content the page hands it (DropText,
  DropStream): the sample CSV; it has no file dialog and takes no files dropped on the page. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, System.UITypes,
  System.IOUtils, System.Math, System.Generics.Collections, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCTheme, VCL.TMSFNCAIClient, VCL.TMSFNCAIProvider, VCL.TMSFNCAISettings, VCL.TMSFNCAIService,
  VCL.TMSFNCAIPromptEdit, VCL.TMSFNCAIPlanView, VCL.TMSFNCAIChoiceCards, VCL.TMSFNCAIPreviewLens,
  VCL.TMSFNCAIDropZone,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, System.IOUtils, System.Math,
  System.Generics.Collections, FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs, FMX.Edit,
  FMX.StdCtrls,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCTheme, FMX.TMSFNCAIClient, FMX.TMSFNCAIProvider, FMX.TMSFNCAISettings, FMX.TMSFNCAIService,
  FMX.TMSFNCAIPromptEdit, FMX.TMSFNCAIPlanView, FMX.TMSFNCAIChoiceCards, FMX.TMSFNCAIPreviewLens,
  FMX.TMSFNCAIDropZone,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, Math, Variants, Generics.Collections, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms,
  WEBLib.Dialogs, WEBLib.StdCtrls, WEBLib.ExtCtrls,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTheme, WEBLib.TMSFNCAIClient, WEBLib.TMSFNCAIProvider,
  WEBLib.TMSFNCAISettings, WEBLib.TMSFNCAIService, WEBLib.TMSFNCAIPromptEdit, WEBLib.TMSFNCAIPlanView,
  WEBLib.TMSFNCAIChoiceCards, WEBLib.TMSFNCAIPreviewLens, WEBLib.TMSFNCAIDropZone,
  {$ENDIF}
  TMS.TMSFNCJSONReader, TMS.TMSFNCAIOperations, TMS.TMSFNCAIRegistry, TMS.TMSFNCAIPlan, TMS.TMSFNCAIAgent,
  TMS.TMSFNCAIValues, UDemoLayout;

type
  {$IFDEF WEBLIB}
  TDemoEdit = TWebEdit;
  {$ELSE}
  TDemoEdit = TEdit;
  {$ENDIF}

  TDish = record
    Section: string;
    Name: string;
    Price: Double;
  end;

  { the menu card: what the plans change }
  TMenuCard = class(TTMSFNCCustomControl)
  private
    FTitle: string;
    FTagline: string;
    FAccent: TTMSFNCGraphicsColor;
    FTitleSize: Integer;
    FDishes: TList<TDish>;
    FLogo: TTMSFNCBitmap;
    FPreviewing: Boolean;
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function IndexOfDish(const AName: string): Integer;
    property Title: string read FTitle write FTitle;
    property Tagline: string read FTagline write FTagline;
    property Accent: TTMSFNCGraphicsColor read FAccent write FAccent;
    property TitleSize: Integer read FTitleSize write FTitleSize;
    property Dishes: TList<TDish> read FDishes;
    property Logo: TTMSFNCBitmap read FLogo;
    property Previewing: Boolean read FPreviewing write FPreviewing;
  end;

  { one answer on its way: the events of its stream, one per tick of its own timer }
  TDemoStream = class
  private
    FTimer: TTimer;
    FChunk: TTMSFNCAITransportChunkCallback;
    FDone: TTMSFNCAITransportDoneCallback;
    FToken: ITMSFNCAICancelToken;
    FBody: TBytes;
    FPos: Integer;
    FFinished: Boolean;
    procedure Tick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent; const ABody: TBytes; const AChunk: TTMSFNCAITransportChunkCallback;
      const ADone: TTMSFNCAITransportDoneCallback; const AToken: ITMSFNCAICancelToken);
    destructor Destroy; override;
    property Finished: Boolean read FFinished;
  end;

  { the model of the demo: an OpenAI-compatible server on this computer whose answers this unit writes; it streams
    them in pieces like a real server, so the progress of the service shows. Requests run side by side (a plan
    and a promptable field). }
  TDemoModel = class(TInterfacedObject, ITMSFNCAITransport)
  private
    FOwner: TComponent;
    FStreams: TObjectList<TDemoStream>;
    function Answer(const ARequest: TTMSFNCAITransportRequest): string;
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    function Send(const ARequest: TTMSFNCAITransportRequest; const AChunk: TTMSFNCAITransportChunkCallback;
      const ADone: TTMSFNCAITransportDoneCallback): ITMSFNCAICancelToken;
  end;

  { the operations a plan is made of: set_title, set_tagline, set_accent, add_dish, remove_dish, set_price }
  TMenuOperation = class(TTMSFNCAICustomOperation)
  private
    FArgs: string;
    FOld: string;
    FOldDish: TDish;
    FOldIndex: Integer;
    function Arg(const AName: string): string;
  protected
    function DoValidate: TTMSFNCAIOperationValidation; override;
    function DoApply: TTMSFNCAIOperationOutcome; override;
    function DoUndo: Boolean; override;
  public
    constructor Create(const AKind, ATarget, AArgsJSON, AWhy: string; ARisk: TTMSFNCAIOperationRisk);
  end;

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TDemoPanel;
    FContent: TDemoPanel;
    FService: TTMSFNCAIService;
    FModel: ITMSFNCAITransport;
    FGoal: TDemoEdit;
    FPlanButton: TDemoButton;
    FCancelButton: TDemoButton;
    FStatus: TDemoText;
    FAccentEdit: TTMSFNCAIPromptEdit;
    FSizeEdit: TTMSFNCAIPromptEdit;
    FTaglineEdit: TTMSFNCAIPromptEdit;
    FZone: TTMSFNCAIDropZone;
    FCard: TMenuCard;
    FSide: TDemoPanel;
    FCards: TTMSFNCAIChoiceCards;
    FPlanView: TTMSFNCAIPlanView;
    FLens: TTMSFNCAIPreviewLens;
    FApplyButton: TDemoButton;
    FUndoButton: TDemoButton;
    FVagueGoal: string;
    procedure CreateService;
    procedure CreateSettings;
    procedure CreateContent;
    procedure RegisterOperations;
    procedure StartPlan(const AGoal, AContext: string);
    procedure UpdateButtons;
    procedure SyncFields;
    procedure PlanClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ApplyClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure SampleClick(Sender: TObject);
    {$IFDEF FMX}
    procedure GoalKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
    {$ELSE}
    procedure GoalKeyPress(Sender: TObject; var Key: Char);
    {$ENDIF}
    procedure ServiceProgress(Sender: TObject; AState: TTMSFNCAIAgentState; AStep, AStepCount: Integer;
      const AText: string);
    procedure ServicePlanReady(Sender: TObject; APlan: TTMSFNCAIPlan);
    procedure ServiceStepChanged(Sender: TObject; AStep: TTMSFNCAIPlanStep);
    procedure ServiceFinished(Sender: TObject);
    procedure ServiceError(Sender: TObject; const AMessage: string);
    procedure PlanStepAction(Sender: TObject; AStep: TTMSFNCAIPlanStep; AAction: TTMSFNCAIPlanViewAction;
      var AHandled: Boolean);
    procedure PlanStepChanged(Sender: TObject; AStep: TTMSFNCAIPlanStep);
    procedure LensBegin(Sender: TObject; var AHandled: Boolean);
    procedure LensEnd(Sender: TObject);
    procedure CardChosen(Sender: TObject; AChoice: TTMSFNCAIChoice);
    procedure CardNone(Sender: TObject);
    procedure FieldApplied(Sender: TObject; const AValue: Variant);
    procedure ZoneActions(Sender: TObject; AContent: TTMSFNCAIDropContent; AActions: TTMSFNCAIDropActions);
    procedure ZoneAction(Sender: TObject; AContent: TTMSFNCAIDropContent; AAction: TTMSFNCAIDropAction);
  public
    property Card: TMenuCard read FCard;
  end;

var
  Form1: TForm1;

implementation

{$IFDEF FMX}
{$R *.fmx}
{$ENDIF}
{$IFDEF VCL}
{$R *.dfm}
{$ENDIF}
{$IFDEF WEBLIB}
{$R *.dfm}
{$ENDIF}

const
  StartTitle = 'Le Petit Jardin';
  StartTagline = 'Seasonal cooking from the market';
  StartAccent = '#5B7F5A';
  SampleCSV = 'Dish;Section;Price'#13#10'Onion soup;Starters;7.50'#13#10'Duck confit;Mains;21.00'#13#10 +
    'Lemon tart;Desserts;8.00'#13#10'Cheese board;Desserts;11.50'#13#10;

{ ---------------------------------------------------------------- helpers }

function ColorToHex(AColor: TTMSFNCGraphicsColor): string;
var
  r, g, b: Integer;
begin
  {$IFDEF FMX}
  r := (AColor shr 16) and $FF;
  g := (AColor shr 8) and $FF;
  b := AColor and $FF;
  {$ELSE}
  r := AColor and $FF;
  g := (AColor shr 8) and $FF;
  b := (AColor shr 16) and $FF;
  {$ENDIF}
  Result := Format('#%.2X%.2X%.2X', [r, g, b]);
end;

function HexToColor(const AHex: string): TTMSFNCGraphicsColor;
var
  v: Integer;
begin
  v := StrToIntDef('$' + Copy(AHex, 2, 6), $5B7F5A);
  {$IFDEF FMX}
  Result := TAlphaColor($FF000000 or Cardinal(v));
  {$ELSE}
  Result := TColor(((v and $FF) shl 16) or (v and $FF00) or ((v shr 16) and $FF));
  {$ENDIF}
end;

{ numbers of the model and of the menu: with a point in every country }
function MoneyText(AValue: Double): string;
begin
  {$IFDEF WEBLIB}
  Result := FormatFloat('0.00', AValue);
  {$ELSE}
  Result := FormatFloat('0.00', AValue, TFormatSettings.Invariant);
  {$ENDIF}
end;

function NumberOf(const AText: string; ADefault: Double): Double;
begin
  {$IFDEF WEBLIB}
  Result := StrToFloatDef(AText, ADefault);
  {$ELSE}
  Result := StrToFloatDef(AText, ADefault, TFormatSettings.Invariant);
  {$ENDIF}
end;

function NumberText(AValue: Double): string;
begin
  {$IFDEF WEBLIB}
  Result := FloatToStr(AValue);
  {$ELSE}
  Result := FloatToStr(AValue, TFormatSettings.Invariant);
  {$ENDIF}
end;

function Dish(const ASection, AName: string; APrice: Double): TDish;
begin
  Result.Section := ASection;
  Result.Name := AName;
  Result.Price := APrice;
end;

{ one value of a flat JSON object }
function ArgValue(const AJSON, AName: string): string;
var
  s: TBytesStream;
  r: TTMSFNCJSONReader;
begin
  Result := '';
  s := TBytesStream.Create(TEncoding.UTF8.GetBytes(AJSON));
  try
    r := TTMSFNCJSONReader.Create(s);
    try
      try
        r.ReadBeginObject;
        while r.HasNext do
          if r.ReadName = AName then
          begin
            if r.HasString then
              Result := r.ReadString
            else
              Result := NumberText(r.ReadDouble);
          end
          else
            r.SkipValue;
      except
        Result := '';
      end;
    finally
      r.Free;
    end;
  finally
    s.Free;
  end;
end;

{ the text of the messages of a chat completions request: all of them, and the last one of the user }
procedure RequestTexts(const ABody: string; out AAll, ALastUser: string);
var
  s: TBytesStream;
  r: TTMSFNCJSONReader;
  role, content: string;
begin
  AAll := '';
  ALastUser := '';
  s := TBytesStream.Create(TEncoding.UTF8.GetBytes(ABody));
  try
    r := TTMSFNCJSONReader.Create(s);
    try
      try
        r.ReadBeginObject;
        while r.HasNext do
          if r.ReadName = 'messages' then
          begin
            r.ReadBeginArray;
            while r.HasNext do
            begin
              role := '';
              content := '';
              r.ReadBeginObject;
              while r.HasNext do
              begin
                if (r.ReadName = 'role') and r.HasString then
                  role := r.ReadString
                else if r.HasString then
                  content := r.ReadString
                else
                  r.SkipValue;
              end;
              r.ReadEndObject;
              AAll := AAll + content + #10;
              if role = 'user' then
                ALastUser := content;
            end;
            r.ReadEndArray;
          end
          else
            r.SkipValue;
      except
        // what was read so far is used
      end;
    finally
      r.Free;
    end;
  finally
    s.Free;
  end;
end;

{ the server-sent events of a streamed answer, in pieces of 24 characters }
function StreamOf(const AContent: string): string;
var
  p: Integer;
begin
  Result := '';
  p := 1;
  while p <= Length(AContent) do
  begin
    Result := Result + 'data: {"model":"menu-demo","choices":[{"index":0,"delta":{"content":' +
      TTMSFNCAIJSONBuilder.Quote(Copy(AContent, p, 24)) + '}}]}'#10#10;
    Inc(p, 24);
  end;
  Result := Result + 'data: {"model":"menu-demo","choices":[{"index":0,"delta":{},"finish_reason":"stop"}],' +
    '"usage":{"prompt_tokens":420,"completion_tokens":160}}'#10#10'data: [DONE]'#10#10;
end;

function Step(const ATitle, AWhy, AKind, AArgs: string): string;
begin
  Result := '{"title":' + TTMSFNCAIJSONBuilder.Quote(ATitle) + ',"why":' + TTMSFNCAIJSONBuilder.Quote(AWhy) +
    ',"expected":"","kind":"' + AKind + '","target":"MenuCard","args":' + AArgs + ',"needs":[]}';
end;

function TextArg(const AName, AValue: string): string;
begin
  Result := '{"' + AName + '":' + TTMSFNCAIJSONBuilder.Quote(AValue) + '}';
end;

function DishArgs(const ASection, AName: string; APrice: Double): string;
begin
  Result := '{"section":' + TTMSFNCAIJSONBuilder.Quote(ASection) + ',"name":' + TTMSFNCAIJSONBuilder.Quote(AName) +
    ',"price":' + MoneyText(APrice) + '}';
end;

function PlanOf(const ATitle, AMessage: string; const ASteps: array of string): string;
var
  I: Integer;
begin
  Result := '{"title":' + TTMSFNCAIJSONBuilder.Quote(ATitle) + ',"message":' + TTMSFNCAIJSONBuilder.Quote(AMessage) +
    ',"read":[],"steps":[';
  for I := 0 to High(ASteps) do
  begin
    if I > 0 then
      Result := Result + ',';
    Result := Result + ASteps[I];
  end;
  Result := Result + ']}';
end;

function Has(const AText: string; const AWords: array of string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to High(AWords) do
    if Pos(AWords[I], AText) > 0 then
      Exit(True);
end;

{ ---------------------------------------------------------------- TMenuCard }

constructor TMenuCard.Create(AOwner: TComponent);
begin
  inherited;
  FDishes := TList<TDish>.Create;
  FLogo := TTMSFNCBitmap.Create;
  FTitle := StartTitle;
  FTagline := StartTagline;
  FAccent := HexToColor(StartAccent);
  FTitleSize := 26;
  FDishes.Add(Dish('Starters', 'Leek and potato soup', 6.50));
  FDishes.Add(Dish('Starters', 'Goat cheese salad', 9.00));
  FDishes.Add(Dish('Mains', 'Steak frites', 23.50));
  FDishes.Add(Dish('Mains', 'Mushroom risotto', 17.00));
  FDishes.Add(Dish('Mains', 'Grilled sea bass', 22.00));
  Width := 420;
  Height := 560;
end;

destructor TMenuCard.Destroy;
begin
  FLogo.Free;
  FDishes.Free;
  inherited;
end;

function TMenuCard.IndexOfDish(const AName: string): Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to FDishes.Count - 1 do
    if SameText(FDishes[I].Name, AName) then
      Exit(I);
end;

procedure TMenuCard.Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF);
const
  Sections: array[0..2] of string = ('Starters', 'Mains', 'Desserts');
var
  paper, r: TRectF;
  y, w, h, k: Single;
  I, S, N: Integer;
  sec: string;

  { a size of the 96 DPI design in pixels of the form (FMX and WEB scale by themselves) }
  function P(AValue: Single): Single;
  begin
    Result := AValue * k;
  end;

  procedure SetFont(ASize: Single; AStyle: TFontStyles; AColor: TTMSFNCGraphicsColor);
  begin
    AGraphics.Font.Name := 'Georgia';
    DemoPixelFont(AGraphics.Font, ASize, Self);
    AGraphics.Font.Style := AStyle;
    AGraphics.Font.Color := AColor;
  end;

begin
  inherited;
  {$IFDEF VCL}
  k := CurrentPPI / 96;
  {$ELSE}
  k := 1;
  {$ENDIF}
  { the card is a printed menu: paper and ink are the colours of the restaurant, not of the theme (demo-colors:
    content, like a picture) }
  w := Min((ARect.Right - ARect.Left) - P(32), P(460));
  h := (ARect.Bottom - ARect.Top) - P(32);
  paper := RectF(ARect.Left + ((ARect.Right - ARect.Left) - w) / 2, ARect.Top + P(16), ARect.Left + ((ARect.Right - ARect.Left) + w) / 2,
    ARect.Top + P(16) + h);
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := MakeGraphicsColor(253, 250, 243);
  AGraphics.Stroke.Kind := gskSolid;
  AGraphics.Stroke.Color := MakeGraphicsColor(221, 214, 200);
  AGraphics.DrawRoundRectangle(paper, P(10));

  AGraphics.Fill.Color := FAccent;
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.DrawRectangle(RectF(paper.Left, paper.Top + P(10), paper.Left + P(6), paper.Bottom - P(10)));

  if not IsBitmapEmpty(FLogo) then
    AGraphics.DrawBitmap(RectF(paper.Right - P(72), paper.Top + P(16), paper.Right - P(16), paper.Top + P(72)), FLogo,
      True, True);

  y := paper.Top + P(24);
  SetFont(FTitleSize, [TFontStyle.fsBold], MakeGraphicsColor(40, 36, 30));
  r := RectF(paper.Left + P(28), y, paper.Right - P(80), y + P(FTitleSize * 1.6));
  AGraphics.DrawText(r, FTitle, False, gtaLeading, gtaCenter);
  y := r.Bottom + P(2);
  SetFont(12, [TFontStyle.fsItalic], FAccent);
  AGraphics.DrawText(RectF(paper.Left + P(28), y, paper.Right - P(28), y + P(22)), FTagline, False, gtaLeading, gtaCenter);
  y := y + P(34);

  for S := 0 to High(Sections) do
  begin
    sec := Sections[S];
    N := 0;
    for I := 0 to FDishes.Count - 1 do
      if SameText(FDishes[I].Section, sec) then
        Inc(N);
    if N = 0 then
      Continue;
    SetFont(11, [TFontStyle.fsBold], FAccent);
    AGraphics.DrawText(RectF(paper.Left + P(28), y, paper.Right - P(28), y + P(20)), UpperCase(sec), False, gtaLeading,
      gtaCenter);
    y := y + P(22);
    SetFont(12, [], MakeGraphicsColor(40, 36, 30));
    for I := 0 to FDishes.Count - 1 do
    begin
      if not SameText(FDishes[I].Section, sec) then
        Continue;
      if y + P(22) > paper.Bottom - P(30) then
        Break;
      AGraphics.DrawText(RectF(paper.Left + P(28), y, paper.Right - P(90), y + P(22)), FDishes[I].Name, False,
        gtaLeading, gtaCenter);
      AGraphics.DrawText(RectF(paper.Right - P(100), y, paper.Right - P(28), y + P(22)), MoneyText(FDishes[I].Price),
        False, gtaTrailing, gtaCenter);
      y := y + P(24);
    end;
    y := y + P(10);
  end;

  if FPreviewing then
  begin
    SetFont(10, [TFontStyle.fsBold], FAccent);
    AGraphics.DrawText(RectF(paper.Left + P(28), paper.Bottom - P(28), paper.Right - P(28), paper.Bottom - P(8)),
      'PREVIEW - release to go back', False, gtaCenter, gtaCenter);
  end;
end;

{ ---------------------------------------------------------------- TDemoModel }

constructor TDemoStream.Create(AOwner: TComponent; const ABody: TBytes; const AChunk: TTMSFNCAITransportChunkCallback;
  const ADone: TTMSFNCAITransportDoneCallback; const AToken: ITMSFNCAICancelToken);
begin
  inherited Create;
  FBody := ABody;
  FChunk := AChunk;
  FDone := ADone;
  FToken := AToken;
  FTimer := TTimer.Create(AOwner);
  FTimer.Interval := 40;
  FTimer.OnTimer := {$IFDEF WEBLIB}@{$ENDIF}Tick;
  FTimer.Enabled := True;
end;

destructor TDemoStream.Destroy;
begin
  FTimer.Free;
  inherited;
end;

procedure TDemoStream.Tick(Sender: TObject);
var
  e: Integer;
  done: TTMSFNCAITransportDoneCallback;
  resp: TTMSFNCAITransportResponse;
begin
  if FFinished then
    Exit;
  if FToken.IsCancelled then
  begin
    FTimer.Enabled := False;
    FFinished := True;
    Exit;
  end;
  { one event at a time, as a server sends them }
  e := FPos;
  while (e + 1 < Length(FBody)) and not ((FBody[e] = 10) and (FBody[e + 1] = 10)) do
    Inc(e);
  e := Min(e + 2, Length(FBody));
  if e > FPos then
    FChunk(200, Copy(FBody, FPos, e - FPos));
  FPos := e;
  if FPos >= Length(FBody) then
  begin
    FTimer.Enabled := False;
    done := FDone;
    resp.Status := 200;
    SetLength(resp.Headers, 1);
    resp.Headers[0] := 'Content-Type: text/event-stream';
    resp.Body := FBody;
    resp.ErrorMessage := '';
    resp.Fatal := False;
    done(resp);
    { only now: a request sent from inside the callback must not free this stream while its tick runs }
    FFinished := True;
  end;
end;

constructor TDemoModel.Create(AOwner: TComponent);
begin
  inherited Create;
  FOwner := AOwner;
  FStreams := TObjectList<TDemoStream>.Create(True);
end;

destructor TDemoModel.Destroy;
begin
  FStreams.Free;
  inherited;
end;

function TDemoModel.Send(const ARequest: TTMSFNCAITransportRequest; const AChunk: TTMSFNCAITransportChunkCallback;
  const ADone: TTMSFNCAITransportDoneCallback): ITMSFNCAICancelToken;
var
  I: Integer;
begin
  for I := FStreams.Count - 1 downto 0 do
    if FStreams[I].Finished then
      FStreams.Delete(I);
  Result := TTMSFNCAICancelToken.Create;
  FStreams.Add(TDemoStream.Create(FOwner, TEncoding.UTF8.GetBytes(StreamOf(Answer(ARequest))), AChunk, ADone, Result));
end;

function TDemoModel.Answer(const ARequest: TTMSFNCAITransportRequest): string;
var
  all, goal, g, line, phrase, field: string;
  lines: TStringList;
  steps: TList<string>;
  I, p: Integer;
  parts: TArray<string>;
begin
  RequestTexts(ARequest.Body, all, goal);

  { a promptable field asks for one value }
  p := Pos('Phrase: ', goal);
  if p > 0 then
  begin
    phrase := LowerCase(Copy(goal, p + 8, MaxInt));
    if Pos(#10, phrase) > 0 then
      phrase := Copy(phrase, 1, Pos(#10, phrase) - 1);
    field := LowerCase(goal);
    if Pos('accent', field) > 0 then
    begin
      if Has(phrase, ['terracotta', 'clay', 'brick']) then
        Exit('{"value":"#C9785D","interpretation":"a softer terracotta, a warm clay red"}')
      else if Has(phrase, ['sea', 'ocean', 'blue']) then
        Exit('{"value":"#2F6F8F","interpretation":"a calm sea blue"}')
      else if Has(phrase, ['olive', 'herb', 'green', 'garden']) then
        Exit('{"value":"#6B7F3A","interpretation":"an olive, herb garden green"}')
      else if Has(phrase, ['wine', 'bordeaux', 'plum']) then
        Exit('{"value":"#7B2D43","interpretation":"a deep wine red"}')
      else
        Exit('{"value":"#B5652E","interpretation":"a warm copper, my reading of the phrase"}');
    end
    else if Pos('font size', field) > 0 then
    begin
      if Has(phrase, ['small', 'less', 'quiet']) then
        Exit('{"value":"20","interpretation":"a smaller title: 20 pt"}')
      else if Has(phrase, ['huge', 'poster', 'much']) then
        Exit('{"value":"36","interpretation":"a poster-size title: 36 pt"}')
      else
        Exit('{"value":"30","interpretation":"a bit larger: 30 pt"}');
    end
    else
    begin
      if Has(phrase, ['friend', 'warm', 'welcom']) then
        Exit('{"value":"Good food, made with care - come as you are","interpretation":"a friendlier tagline"}')
      else if Has(phrase, ['short', 'brief']) then
        Exit('{"value":"Market cooking","interpretation":"the tagline in two words"}')
      else
        Exit('{"value":"Fresh from the market, every day","interpretation":"a tagline about fresh, seasonal food"}');
    end;
  end;

  { a goal: a plan of operations }
  g := LowerCase(goal);
  steps := TList<string>.Create;
  try
    if Has(g, ['import']) then
    begin
      lines := TStringList.Create;
      try
        lines.Text := all;
        for I := 0 to lines.Count - 1 do
        begin
          line := Trim(lines[I]);
          parts := line.Split([';']);
          if (Length(parts) = 3) and (NumberOf(parts[2], -1) >= 0) then
            steps.Add(Step('Add ' + parts[0], 'it is a line of the file, in the section ' + parts[1], 'add_dish',
              DishArgs(parts[1], parts[0], NumberOf(parts[2], 0))));
        end;
      finally
        lines.Free;
      end;
      Exit(PlanOf('Import dishes', IntToStr(steps.Count) + ' dishes from the file.', steps.ToArray));
    end;
    if Has(g, ['restrained']) then
      Exit(PlanOf('A restrained premium menu', 'One accent, a quieter title and a short tagline.', [
        Step('Use a dark bronze accent', 'one accent colour reads as restrained', 'set_accent', TextArg('color', '#8A6D3B')),
        Step('Rename the menu "Maison"', 'a short name in the language of the kitchen', 'set_title', TextArg('text', 'Maison')),
        Step('Shorten the tagline', 'less text, more white space', 'set_tagline', TextArg('text', 'Cuisine du marche'))]));
    if Has(g, ['rich']) then
      Exit(PlanOf('A rich premium menu', 'A gold accent and a signature dish.', [
        Step('Use a gold accent', 'gold reads as rich', 'set_accent', TextArg('color', '#B8860B')),
        Step('Add a tasting menu', 'a signature dish for the evening', 'add_dish', DishArgs('Mains', 'Tasting menu, five courses', 65)),
        Step('Raise the steak to 27.50', 'a premium cut', 'set_price', '{"name":"Steak frites","price":27.50}')]));
    if Has(g, ['editorial']) then
      Exit(PlanOf('An editorial premium menu', 'A red accent and a statement tagline.', [
        Step('Use a red accent', 'strong contrast for an editorial look', 'set_accent', TextArg('color', '#B33A2B')),
        Step('A statement tagline', 'one sentence that tells the story', 'set_tagline', TextArg('text', 'Everything here was picked this morning.'))]));
    if Has(g, ['brunch']) then
      Exit(PlanOf('Sunday brunch', 'A brunch name, a morning colour and three brunch dishes.', [
        Step('Rename the menu "Sunday Brunch"', 'you asked for a brunch menu', 'set_title', TextArg('text', 'Sunday Brunch')),
        Step('Use a sunny yellow accent', 'warm morning colours suit a brunch', 'set_accent', TextArg('color', '#D99A2B')),
        Step('Add shakshuka', 'a brunch classic', 'add_dish', DishArgs('Mains', 'Shakshuka', 12.50)),
        Step('Add buttermilk pancakes', 'something sweet', 'add_dish', DishArgs('Desserts', 'Buttermilk pancakes', 9.80)),
        Step('Remove the steak frites', 'not a brunch dish', 'remove_dish', TextArg('name', 'Steak frites'))]));
    if Has(g, ['vegan', 'plant', 'vegetarian']) then
      Exit(PlanOf('A plant-based menu', 'The meat and fish dishes make room for plant-based ones.', [
        Step('Remove the steak frites', 'it has meat', 'remove_dish', TextArg('name', 'Steak frites')),
        Step('Remove the grilled sea bass', 'it is fish', 'remove_dish', TextArg('name', 'Grilled sea bass')),
        Step('Add a cauliflower steak', 'a plant-based main course', 'add_dish', DishArgs('Mains', 'Roasted cauliflower steak', 16.50)),
        Step('Use a leaf green accent', 'green says plant-based', 'set_accent', TextArg('color', '#3E8E5E')),
        Step('Say it in the tagline', 'guests look for it first', 'set_tagline', TextArg('text', 'Plant-based, seasonal, local'))]));
    if Has(g, ['dessert', 'sweet']) then
      Exit(PlanOf('Desserts', 'Three desserts in a section of their own.', [
        Step('Add a creme brulee', 'a French classic', 'add_dish', DishArgs('Desserts', 'Creme brulee', 7.50)),
        Step('Add a chocolate mousse', 'for chocolate lovers', 'add_dish', DishArgs('Desserts', 'Chocolate mousse', 7.00)),
        Step('Add a cheese plate', 'for those who skip the sweet', 'add_dish', DishArgs('Desserts', 'Cheese plate', 10.50))]));
    if Has(g, ['winter', 'cosy', 'cozy', 'autumn']) then
      Exit(PlanOf('A winter menu', 'Warming dishes and a deep red.', [
        Step('Rename the menu "Winter Kitchen"', 'it says what the season brings', 'set_title', TextArg('text', 'Winter Kitchen')),
        Step('Use a deep wine red accent', 'a warm, dark colour for winter', 'set_accent', TextArg('color', '#7B2D43')),
        Step('Add a beef stew', 'slow cooking for cold days', 'add_dish', DishArgs('Mains', 'Beef and beer stew', 19.50)),
        Step('Remove the goat cheese salad', 'a summer dish', 'remove_dish', TextArg('name', 'Goat cheese salad'))]));
    if Has(g, ['cheap', 'discount', 'lower', 'price']) then
      Exit(PlanOf('Lower prices', 'The three most expensive dishes 10 percent cheaper.', [
        Step('Steak frites 21.15', '10 percent off the most expensive dish', 'set_price', '{"name":"Steak frites","price":21.15}'),
        Step('Grilled sea bass 19.80', '10 percent off', 'set_price', '{"name":"Grilled sea bass","price":19.80}'),
        Step('Mushroom risotto 15.30', '10 percent off', 'set_price', '{"name":"Mushroom risotto","price":15.30}')]));
    Result := PlanOf('Nothing to change', 'I can rename the menu, change its accent colour and tagline, and add, ' +
      'remove or reprice dishes. Try "a brunch menu", "make it vegan", "add desserts" or "a winter menu".', []);
  finally
    steps.Free;
  end;
end;

{ ---------------------------------------------------------------- TMenuOperation }

constructor TMenuOperation.Create(const AKind, ATarget, AArgsJSON, AWhy: string; ARisk: TTMSFNCAIOperationRisk);
begin
  inherited Create(AKind, ATarget, AArgsJSON, aosSelection, ARisk, True, AWhy);
  FArgs := AArgsJSON;
end;

function TMenuOperation.Arg(const AName: string): string;
begin
  Result := ArgValue(FArgs, AName);
end;

function TMenuOperation.DoValidate: TTMSFNCAIOperationValidation;
begin
  if (Kind = 'set_accent') and ((Length(Arg('color')) <> 7) or (Copy(Arg('color'), 1, 1) <> '#')) then
    Result := TTMSFNCAIOperationValidation.Deny('"color" is a colour as #RRGGBB')
  else if ((Kind = 'remove_dish') or (Kind = 'set_price')) and (Form1.Card.IndexOfDish(Arg('name')) < 0) then
    Result := TTMSFNCAIOperationValidation.Deny('the menu has no dish "' + Arg('name') + '"')
  else if (Kind = 'add_dish') and (Trim(Arg('name')) = '') then
    Result := TTMSFNCAIOperationValidation.Deny('"name" is required')
  else
    Result := TTMSFNCAIOperationValidation.Allow;
end;

function TMenuOperation.DoApply: TTMSFNCAIOperationOutcome;
var
  c: TMenuCard;
  d: TDish;
begin
  c := Form1.Card;
  if Kind = 'set_title' then
  begin
    FOld := c.Title;
    c.Title := Arg('text');
  end
  else if Kind = 'set_tagline' then
  begin
    FOld := c.Tagline;
    c.Tagline := Arg('text');
  end
  else if Kind = 'set_accent' then
  begin
    FOld := ColorToHex(c.Accent);
    c.Accent := HexToColor(Arg('color'));
  end
  else if Kind = 'add_dish' then
    c.Dishes.Add(Dish(Arg('section'), Arg('name'), NumberOf(Arg('price'), 0)))
  else if Kind = 'remove_dish' then
  begin
    FOldIndex := c.IndexOfDish(Arg('name'));
    FOldDish := c.Dishes[FOldIndex];
    c.Dishes.Delete(FOldIndex);
  end
  else if Kind = 'set_price' then
  begin
    FOldIndex := c.IndexOfDish(Arg('name'));
    d := c.Dishes[FOldIndex];
    FOld := MoneyText(d.Price);
    d.Price := NumberOf(Arg('price'), d.Price);
    c.Dishes[FOldIndex] := d;
  end;
  c.Invalidate;
  Form1.SyncFields;
  Result := aoeApplied;
end;

function TMenuOperation.DoUndo: Boolean;
var
  c: TMenuCard;
  d: TDish;
  I: Integer;
begin
  c := Form1.Card;
  Result := True;
  if Kind = 'set_title' then
    c.Title := FOld
  else if Kind = 'set_tagline' then
    c.Tagline := FOld
  else if Kind = 'set_accent' then
    c.Accent := HexToColor(FOld)
  else if Kind = 'add_dish' then
  begin
    I := c.IndexOfDish(Arg('name'));
    if I >= 0 then
      c.Dishes.Delete(I);
  end
  else if Kind = 'remove_dish' then
    c.Dishes.Insert(Min(FOldIndex, c.Dishes.Count), FOldDish)
  else if Kind = 'set_price' then
  begin
    I := c.IndexOfDish(Arg('name'));
    if I >= 0 then
    begin
      d := c.Dishes[I];
      d.Price := NumberOf(FOld, d.Price);
      c.Dishes[I] := d;
    end;
  end;
  c.Invalidate;
  Form1.SyncFields;
end;

{ ---------------------------------------------------------------- TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self, ThemeManager);
  FLayout.AddHeader('AI Menu Studio',
    'Ask for a change, review the plan, hold to preview, apply or undo; promptable style fields and a drop zone',
    ['Fluent Light', 'Fluent Dark', 'Microsoft 365 Light', 'Microsoft 365 Dark', 'High Contrast']);
  RegisterOperations;
  CreateService;
  CreateSettings;
  CreateContent;
  SyncFields;
  UpdateButtons;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FPlanView.Plan := nil;
  FService.Cancel;
  FService.Transport := nil;
  FModel := nil;
  FLayout.Free;
end;

{ the factory the registry calls for a step of a plan with this kind }
function MenuFactory(const AKind: string; ARisk: TTMSFNCAIOperationRisk): TTMSFNCAIOperationFactory;
begin
  Result :=
    function(const ATarget, AArgsJSON, AWhy: string): TTMSFNCAICustomOperation
    begin
      Result := TMenuOperation.Create(AKind, ATarget, AArgsJSON, AWhy, ARisk);
    end;
end;

procedure TForm1.RegisterOperations;

  procedure Kind(const AName, ADescription, ASchema: string; ARisk: TTMSFNCAIOperationRisk;
    AAspects: TTMSFNCAIOperationAspects);
  begin
    TMSFNCAIOperations.RegisterKind(AName, ADescription, ARisk, AAspects, True, ASchema, MenuFactory(AName, ARisk));
  end;

begin
  Kind('set_title', 'Renames the menu card.', '{"type":"object","properties":{"text":{"type":"string"}},"required":["text"]}',
    aorForm, [aoaText]);
  Kind('set_tagline', 'Sets the line under the name of the menu.',
    '{"type":"object","properties":{"text":{"type":"string"}},"required":["text"]}', aorForm, [aoaText]);
  Kind('set_accent', 'Sets the accent colour of the menu card.',
    '{"type":"object","properties":{"color":{"type":"string","description":"#RRGGBB"}},"required":["color"]}', aorView,
    [aoaColor]);
  Kind('add_dish', 'Adds a dish to a section (Starters, Mains, Desserts) with its price.',
    '{"type":"object","properties":{"section":{"type":"string"},"name":{"type":"string"},"price":{"type":"number"}},' +
    '"required":["section","name","price"]}', aorForm, [aoaText]);
  Kind('remove_dish', 'Removes a dish by its name.',
    '{"type":"object","properties":{"name":{"type":"string"}},"required":["name"]}', aorForm, [aoaText]);
  Kind('set_price', 'Sets the price of a dish.',
    '{"type":"object","properties":{"name":{"type":"string"},"price":{"type":"number"}},"required":["name","price"]}',
    aorForm, [aoaText]);
end;

procedure TForm1.CreateService;
begin
  FModel := TDemoModel.Create(Self);
  { the service as the Object Inspector sets it; the demo model answers at a local address }
  FService := TTMSFNCAIService.Create(Self);
  FService.DefaultProfile.Provider := aipCustom;
  FService.DefaultProfile.BaseURL := 'http://localhost:9/v1';
  FService.DefaultProfile.Model := 'menu-demo';
  FService.Instructions := 'You design the menu card of a restaurant.';
  FService.Transport := FModel;
  FService.Active := True;
  FService.OnProgress := {$IFDEF WEBLIB}@{$ENDIF}ServiceProgress;
  FService.OnPlanReady := {$IFDEF WEBLIB}@{$ENDIF}ServicePlanReady;
  FService.OnStepChanged := {$IFDEF WEBLIB}@{$ENDIF}ServiceStepChanged;
  FService.OnFinished := {$IFDEF WEBLIB}@{$ENDIF}ServiceFinished;
  FService.OnError := {$IFDEF WEBLIB}@{$ENDIF}ServiceError;
end;

function NewPromptEdit(AOwner: TComponent; AParent: TDemoParent; AKind: TTMSFNCAIValueKind;
  const AContext: string): TTMSFNCAIPromptEdit;
begin
  Result := TTMSFNCAIPromptEdit.Create(AOwner);
  Result.Parent := AParent;
  Result.ValueKind := AKind;
  Result.Context := AContext;
end;

procedure TForm1.CreateSettings;
var
  row: TDemoPanel;

  { a style field with its name in front (the fields alone did not say what '26' is) }
  function StyleField(const AName: string; AKind: TTMSFNCAIValueKind; const AContext: string): TTMSFNCAIPromptEdit;
  var
    r: TDemoPanel;
    n: TDemoText;
  begin
    r := FLayout.AddBox(FSettings, daTop, 58, 16, 4, 16, 0);
    n := FLayout.AddText(r, AName);
    { next to the edit line of the field; the interpretation of a phrase shows under it }
    FLayout.Place(n, daLeft, 64, 0, 0, 8, 28);
    n.WordWrap := False;
    n.VerticalAlign := gtaCenter;
    Result := NewPromptEdit(Self, r, AKind, AContext);
    FLayout.Place(Result, daClient, 0, 0, 0, 0, 0);
    Result.Service := FService;
    Result.OnAfterApply := {$IFDEF WEBLIB}@{$ENDIF}FieldApplied;
  end;

begin
  FSettings := FLayout.AddSettingsPanel(Self, 300);

  FLayout.AddCaption(FSettings, 'Ask for a change');
  FGoal := TDemoEdit.Create(Self);
  FGoal.Parent := FSettings;
  FLayout.Place(FGoal, daTop, 30, 16, 4, 16, 4);
  {$IFDEF FMX}
  FGoal.TextPrompt := 'a brunch menu, make it vegan, ...';
  FGoal.OnKeyDown := {$IFDEF WEBLIB}@{$ENDIF}GoalKeyDown;
  {$ELSE}
  FGoal.TextHint := 'a brunch menu, make it vegan, ...';
  FGoal.OnKeyPress := {$IFDEF WEBLIB}@{$ENDIF}GoalKeyPress;
  {$ENDIF}
  row := FLayout.AddBox(FSettings, daTop, 32, 16, 4, 16, 0);
  FPlanButton := FLayout.AddButton(row, 'Plan', {$IFDEF WEBLIB}@{$ENDIF}PlanClick);
  FLayout.Place(FPlanButton, daLeft, 128, 0, 0, 8, 0);
  FCancelButton := FLayout.AddButton(row, 'Cancel', {$IFDEF WEBLIB}@{$ENDIF}CancelClick);
  FLayout.Place(FCancelButton, daLeft, 128, 0, 0, 0, 0);
  FStatus := FLayout.AddText(FSettings, 'Type what the menu should become and choose Plan. Nothing changes before you ' +
    'accept the plan.');
  FStatus.Height := FLayout.Size(52);

  FLayout.AddCaption(FSettings, 'Style: a value or a phrase');
  FAccentEdit := StyleField('Accent', aivkColor, 'the accent colour of the menu card');
  FSizeEdit := StyleField('Title size', aivkSize, 'the font size of the menu title, in points');
  FTaglineEdit := StyleField('Tagline', aivkText, 'the tagline under the name of the menu');

  FLayout.AddCaption(FSettings, 'Drop a file');
  FZone := TTMSFNCAIDropZone.Create(Self);
  FZone.Parent := FSettings;
  { 92 high: with 120 the sample button fell below the form }
  FLayout.Place(FZone, daTop, 92, 16, 4, 16, 4);
  {$IFDEF WEBLIB}
  { in a page the application hands the zone its content: the sample below }
  FZone.Kinds := [adkCSV, adkText];
  FZone.Text := 'Choose the sample below: its CSV text is dropped here';
  {$ELSE}
  FZone.Kinds := [adkCSV, adkImage, adkText];
  {$ENDIF}
  FZone.OnGetActions := {$IFDEF WEBLIB}@{$ENDIF}ZoneActions;
  FZone.OnActionSelected := {$IFDEF WEBLIB}@{$ENDIF}ZoneAction;
  FLayout.Place(FLayout.AddButton(FSettings, 'Try the sample CSV', {$IFDEF WEBLIB}@{$ENDIF}SampleClick), daTop, 30, 16, 4, 16, 0);
end;

procedure TForm1.CreateContent;
var
  bar: TDemoPanel;
begin
  FContent := FLayout.AddContentPanel(Self);

  { the plan, the cards and the lens on the right }
  FSide := FLayout.AddBox(FContent, daRight, 360, 16, 0, 0, 0);
  FCards := TTMSFNCAIChoiceCards.Create(Self);
  FCards.Parent := FSide;
  FLayout.Place(FCards, daTop, 250, 0, 0, 0, 8);
  FCards.AddChoice('Restrained', 'More white space, one accent, a short tagline').Swatches.CommaText :=
    '#FDFAF3,#28241E,#DDD6C8,#8A6D3B';
  FCards.AddChoice('Rich', 'Gold accent, a signature dish, premium prices').Swatches.CommaText :=
    '#1B1A22,#E9D8A6,#5B5870,#B8860B';
  FCards.AddChoice('Editorial', 'Strong contrast, red accent, a statement line').Swatches.CommaText :=
    '#F4EFE6,#111111,#9A8F7C,#B33A2B';
  FCards.OnChoice := {$IFDEF WEBLIB}@{$ENDIF}CardChosen;
  FCards.OnNoneOfThese := {$IFDEF WEBLIB}@{$ENDIF}CardNone;
  FCards.Visible := False;

  bar := FLayout.AddBox(FSide, daBottom, 36, 0, 8, 0, 0);
  FLens := TTMSFNCAIPreviewLens.Create(Self);
  FLens.Parent := bar;
  FLayout.Place(FLens, daLeft, 150, 0, 4, 8, 4);
  FLens.OnBeginPreview := {$IFDEF WEBLIB}@{$ENDIF}LensBegin;
  FLens.OnEndPreview := {$IFDEF WEBLIB}@{$ENDIF}LensEnd;
  FUndoButton := FLayout.AddButton(bar, 'Undo', {$IFDEF WEBLIB}@{$ENDIF}UndoClick);
  FLayout.Place(FUndoButton, daRight, 90, 0, 2, 0, 2);
  FApplyButton := FLayout.AddButton(bar, 'Apply all', {$IFDEF WEBLIB}@{$ENDIF}ApplyClick);
  FLayout.Place(FApplyButton, daRight, 100, 0, 2, 8, 2);

  FPlanView := TTMSFNCAIPlanView.Create(Self);
  FPlanView.Parent := FSide;
  FLayout.Place(FPlanView, daClient, 0, 0, 0, 0, 0);
  FPlanView.Actions := [apvaAccept, apvaSkip, apvaUndo, apvaPreview, apvaDetails];
  FPlanView.OnStepAction := {$IFDEF WEBLIB}@{$ENDIF}PlanStepAction;
  FPlanView.OnStepChanged := {$IFDEF WEBLIB}@{$ENDIF}PlanStepChanged;

  FCard := TMenuCard.Create(Self);
  FCard.Parent := FContent;
  FLayout.Place(FCard, daClient, 0, 0, 0, 0, 0);
end;

procedure TForm1.SyncFields;
begin
  if not Assigned(FAccentEdit) then
    Exit;
  FAccentEdit.Text := ColorToHex(FCard.Accent);
  FSizeEdit.Text := IntToStr(FCard.TitleSize);
  FTaglineEdit.Text := FCard.Tagline;
end;

procedure TForm1.UpdateButtons;
var
  busy, proposed, applied: Boolean;
  I: Integer;
  p: TTMSFNCAIPlan;
begin
  busy := FService.Busy;
  p := FPlanView.Plan;
  proposed := False;
  applied := False;
  if Assigned(p) then
    for I := 0 to p.Count - 1 do
    begin
      proposed := proposed or (p[I].Status = apsProposed);
      applied := applied or (p[I].Status = apsApplied);
    end;
  FPlanButton.Enabled := not busy;
  FCancelButton.Enabled := busy;
  FApplyButton.Enabled := proposed and not busy;
  FUndoButton.Enabled := applied and not busy;
  FLens.Enabled := proposed and not busy;
end;

procedure TForm1.StartPlan(const AGoal, AContext: string);
begin
  FCards.Visible := False;
  FPlanView.Plan := nil;
  FService.Plan(AGoal, FCard, 'A menu card with a name, a tagline, an accent colour and dishes in the sections ' +
    'Starters, Mains and Desserts.' + AContext);
  UpdateButtons;
end;

procedure TForm1.PlanClick(Sender: TObject);
var
  g: string;
begin
  g := Trim(FGoal.Text);
  if g = '' then
  begin
    FStatus.Text := 'Type what the menu should become first, for example "a brunch menu".';
    Exit;
  end;
  { a request too vague to act on gets three readings to pick from first }
  if TMSFNCAIIsVagueRequest(g) then
  begin
    FVagueGoal := g;
    FCards.Question := 'What does "' + g + '" mean for this menu?';
    FCards.Visible := True;
    FStatus.Text := 'Pick the reading you mean; the plan follows it.';
    Exit;
  end;
  StartPlan(g, '');
end;

procedure TForm1.CancelClick(Sender: TObject);
begin
  FService.Cancel;
  UpdateButtons;
end;

procedure TForm1.ApplyClick(Sender: TObject);
begin
  FService.Apply;
  FPlanView.Invalidate;
  UpdateButtons;
end;

procedure TForm1.UndoClick(Sender: TObject);
var
  I: Integer;
begin
  if not FService.Undo and Assigned(FPlanView.Plan) then
    { steps accepted one by one in the plan view: back in the reverse order }
    for I := FPlanView.Plan.Count - 1 downto 0 do
      if FPlanView.Plan[I].Status = apsApplied then
        FPlanView.PerformAction(FPlanView.Plan[I], apvaUndo);
  FPlanView.Invalidate;
  UpdateButtons;
end;

procedure TForm1.SampleClick(Sender: TObject);
{$IFDEF WEBLIB}
begin
  { a page has no files of its own: the text of the sample is dropped }
  FZone.DropText(SampleCSV);
end;
{$ELSE}
var
  f: string;
begin
  f := TPath.Combine(TPath.GetTempPath, 'menu-dishes.csv');
  TFile.WriteAllText(f, SampleCSV, TEncoding.UTF8);
  FZone.Drop(f);
end;
{$ENDIF}

{$IFDEF FMX}
procedure TForm1.GoalKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkReturn then
  begin
    Key := 0;
    PlanClick(Sender);
  end;
end;
{$ELSE}
procedure TForm1.GoalKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    PlanClick(Sender);
  end;
end;
{$ENDIF}

procedure TForm1.ServiceProgress(Sender: TObject; AState: TTMSFNCAIAgentState; AStep, AStepCount: Integer;
  const AText: string);
begin
  { in words while the model answers: the text of these states is the answer as it arrives (pieces of JSON) }
  case AState of
    aasConnecting: FStatus.Text := 'Asking the model...';
    aasThinking, aasWriting: FStatus.Text := 'The model is answering...';
    aasValidating: FStatus.Text := 'Checking the answer...';
  else
    if AText <> '' then
      FStatus.Text := AText;
  end;
  UpdateButtons;
end;

procedure TForm1.ServicePlanReady(Sender: TObject; APlan: TTMSFNCAIPlan);
begin
  FPlanView.Plan := APlan;
  if APlan.Count = 0 then
    FStatus.Text := 'Nothing to change for that. The menu takes a new name, accent colour, tagline, dishes and ' +
      'prices: try "a brunch menu", "make it vegan", "add desserts" or "a winter menu".'
  else
    FStatus.Text := IntToStr(APlan.Count) + ' steps planned. Accept the ones you want or Apply all; hold Preview ' +
      'to see the result first.';
  UpdateButtons;
end;

procedure TForm1.ServiceStepChanged(Sender: TObject; AStep: TTMSFNCAIPlanStep);
begin
  FPlanView.Invalidate;
  UpdateButtons;
end;

procedure TForm1.ServiceFinished(Sender: TObject);
begin
  FPlanView.Invalidate;
  UpdateButtons;
end;

procedure TForm1.ServiceError(Sender: TObject; const AMessage: string);
begin
  FStatus.Text := AMessage;
  UpdateButtons;
end;

procedure TForm1.PlanStepAction(Sender: TObject; AStep: TTMSFNCAIPlanStep; AAction: TTMSFNCAIPlanViewAction;
  var AHandled: Boolean);
begin
  { a step of the service's plan is applied and skipped through the agent, so one Undo of the service knows it }
  if (FPlanView.Plan = FService.CurrentPlan) and (AAction in [apvaAccept, apvaSkip]) then
  begin
    if AAction = apvaAccept then
      FService.Agent.ApplyStep(AStep.Index)
    else
      FService.Agent.SkipStep(AStep.Index);
    AHandled := True;
  end;
end;

procedure TForm1.PlanStepChanged(Sender: TObject; AStep: TTMSFNCAIPlanStep);
begin
  UpdateButtons;
end;

procedure TForm1.LensBegin(Sender: TObject; var AHandled: Boolean);
begin
  { the whole plan on the card while the lens is held }
  FService.Agent.BeginPreview;
  FCard.Previewing := True;
  FCard.Invalidate;
  AHandled := True;
end;

procedure TForm1.LensEnd(Sender: TObject);
begin
  FService.Agent.EndPreview;
  FCard.Previewing := False;
  FCard.Invalidate;
  SyncFields;
end;

procedure TForm1.CardChosen(Sender: TObject; AChoice: TTMSFNCAIChoice);
begin
  StartPlan(FVagueGoal + ' (' + AChoice.Title + ': ' + AChoice.Description + ')', '');
end;

procedure TForm1.CardNone(Sender: TObject);
begin
  FCards.Visible := False;
  FStatus.Text := 'Say it in other words: what should change on the menu?';
  if FGoal.CanFocus then
    FGoal.SetFocus;
end;

procedure TForm1.FieldApplied(Sender: TObject; const AValue: Variant);
var
  v: string;
begin
  { the value as the field shows it: a colour is a number, '#RRGGBB' as text }
  v := TMSFNCAIValueToText(TTMSFNCAIPromptEdit(Sender).ValueKind, AValue);
  if Sender = FAccentEdit then
    FCard.Accent := HexToColor(v)
  else if Sender = FSizeEdit then
    FCard.TitleSize := EnsureRange(Round(NumberOf(v, FCard.TitleSize)), 12, 48)
  else if Sender = FTaglineEdit then
    FCard.Tagline := v;
  FCard.Invalidate;
end;

procedure TForm1.ZoneActions(Sender: TObject; AContent: TTMSFNCAIDropContent; AActions: TTMSFNCAIDropActions);
begin
  AActions.Clear;
  case AContent.Kind of
    adkCSV: AActions.AddAction('import', 'Import the dishes').Hint := 'The AI maps the columns and plans the new dishes';
    adkImage: AActions.AddAction('logo', 'Use as logo').Hint := 'Shows the image on the card; nothing is sent';
    adkText: AActions.AddAction('tagline', 'Use as tagline').Hint := 'Puts the text under the name; nothing is sent';
  end;
end;

procedure TForm1.ZoneAction(Sender: TObject; AContent: TTMSFNCAIDropContent; AAction: TTMSFNCAIDropAction);
var
  csv: string;
begin
  if AAction.Name = 'import' then
  begin
    { only now does the content go to the model, as data of the request }
    {$IFNDEF WEBLIB}
    if AContent.FileName <> '' then
      csv := TFile.ReadAllText(AContent.FileName)
    else
    {$ENDIF}
      csv := AContent.Text;
    StartPlan('Import the dishes of ' + AContent.DisplayName, #10'The file:'#10 + csv);
  end
  else if AAction.Name = 'logo' then
  begin
    {$IFNDEF WEBLIB}
    FCard.Logo.LoadFromFile(AContent.FileName);
    {$ENDIF}
    FCard.Invalidate;
  end
  else if AAction.Name = 'tagline' then
  begin
    FCard.Tagline := Trim(AContent.Text);
    FCard.Invalidate;
    SyncFields;
  end;
end;

end.
