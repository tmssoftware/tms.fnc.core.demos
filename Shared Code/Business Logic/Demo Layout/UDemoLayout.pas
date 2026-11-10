unit UDemoLayout;

{ Layout helpers shared by the TMS FNC Core demos that build their page in code, the same code for FMX, VCL and
  WEB: the demo header (title, description and a theme picker), a settings panel, a content panel, section captions,
  secondary texts, check boxes, radio buttons and buttons on the 8 px grid of the demo guidelines.

  Core has no FNC button, check box or label: panels and texts are small TTMSFNCCustomControl descendants that take
  their colours from the theme through TTMSFNCTheme.RegisterBindings (a surface with a border, a text in a text
  role); check boxes, radio buttons, buttons and the theme picker are the framework's own controls, whose captions
  are given the theme's text colour when the theme changes. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, System.SysUtils, System.Classes, System.Types, System.UITypes, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.StdCtrls,
  VCL.TMSFNCTypes, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl, VCL.TMSFNCTheme;
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Classes, System.Types, System.UITypes, FMX.Types, FMX.Controls, FMX.Forms, FMX.StdCtrls,
  FMX.ListBox, FMX.Graphics, FMX.Controls.Presentation,
  FMX.TMSFNCTypes, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl, FMX.TMSFNCTheme;
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.StdCtrls,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes, WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCTheme;
  {$ENDIF}

type
  {$IFDEF WEBLIB}
  TDemoForm = TWebForm;
  TDemoParent = TControl;
  TDemoCheckBox = TWebCheckBox;
  TDemoRadioButton = TWebRadioButton;
  TDemoButton = TWebButton;
  TDemoComboBox = TWebComboBox;
  {$ENDIF}
  {$IFDEF FMX}
  TDemoForm = TForm;
  TDemoParent = TFmxObject;
  TDemoCheckBox = TCheckBox;
  TDemoRadioButton = TRadioButton;
  TDemoButton = TButton;
  TDemoComboBox = TComboBox;
  {$ENDIF}
  {$IFDEF VCL}
  TDemoForm = TForm;
  TDemoParent = TWinControl;
  TDemoCheckBox = TCheckBox;
  TDemoRadioButton = TRadioButton;
  TDemoButton = TButton;
  TDemoComboBox = TComboBox;
  {$ENDIF}

  TDemoAlign = (daTop, daLeft, daRight, daBottom, daClient);

  { a surface with a border: the base class binds Fill to the theme's Surface and Stroke to its Border }
  TDemoPanel = class(TTMSFNCCustomControl)
  public
    constructor Create(AOwner: TComponent); override;
  end;

  { a text in a text role; the font is bound to the theme's text colour }
  TDemoText = class(TTMSFNCCustomControl)
  private
    FFont: TTMSFNCGraphicsFont;
    FText: string;
    FRole: TTMSFNCGraphicsTextRole;
    FWordWrap: Boolean;
    FVerticalAlign: TTMSFNCGraphicsTextAlign;
    procedure SetFont(const Value: TTMSFNCGraphicsFont);
    procedure SetText(const Value: string);
    procedure SetRole(const Value: TTMSFNCGraphicsTextRole);
    procedure DemoFontChanged(Sender: TObject);
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    function TextHeight(AWidth: Single): Single;
    property WordWrap: Boolean read FWordWrap write FWordWrap;
    property VerticalAlign: TTMSFNCGraphicsTextAlign read FVerticalAlign write FVerticalAlign;
  published
    property Font: TTMSFNCGraphicsFont read FFont write SetFont;
    property Text: string read FText write SetText;
    property TextRole: TTMSFNCGraphicsTextRole read FRole write SetRole;
  end;

  TDemoLayout = class
  private
    FOwner: TDemoForm;
    FThemeManager: TTMSFNCThemeManager;
    FPlaceOrder: Integer;
    FNatives: TList;
    FHeader: TDemoPanel;
    FThemes: TDemoComboBox;
    procedure ThemeChanged(Sender: TObject);
    procedure ThemesChange(Sender: TObject);
    procedure ColorNative(AControl: TControl; AText: TTMSFNCGraphicsColor);
    function InnerWidth(AParent: TDemoParent): Integer;
  public
    constructor Create(AOwner: TDemoForm; AThemeManager: TTMSFNCThemeManager);
    destructor Destroy; override;
    { pixels at the form's DPI (VCL); the value as is elsewhere }
    function Size(AValue: Integer): Integer;
    { aligns a control after every control aligned before it, with margins }
    procedure Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
    { the header of every demo: title, description and the theme picker, on the themed surface }
    procedure AddHeader(const ATitle, ADescription: string; const AThemes: array of string);
    { a bold section caption }
    function AddCaption(AParent: TDemoParent; const AText: string; ATop: Integer = 16): TDemoText;
    { secondary text, as high as its wrapped lines }
    function AddText(AParent: TDemoParent; const AText: string): TDemoText;
    function AddCheck(AParent: TDemoParent; const AText: string; AChecked: Boolean; AOnChange: TNotifyEvent): TDemoCheckBox;
    { radio buttons of one group, each 28 px high }
    function AddRadios(AParent: TDemoParent; const AGroup: string; const ANames: array of string; AIndex: Integer;
      AOnChange: TNotifyEvent): TArray<TDemoRadioButton>;
    function AddButton(AParent: TDemoParent; const AText: string; AOnClick: TNotifyEvent): TDemoButton;
    function AddPanel(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TDemoPanel;
    { a panel without surface or border, to group controls }
    function AddBox(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TDemoPanel;
    function AddSettingsPanel(AParent: TDemoParent; AWidth: Integer = 260): TDemoPanel;
    function AddContentPanel(AParent: TDemoParent): TDemoPanel;
    { the caption text of a native control, the checked state of a check box or radio button }
    class function Checked(AControl: TControl): Boolean;
    class procedure SetChecked(AControl: TControl; AValue: Boolean);
    class function RadioIndex(const ARadios: TArray<TDemoRadioButton>): Integer;
    class procedure SetCaption(AControl: TControl; const AText: string);
    property Header: TDemoPanel read FHeader;
    property ThemeManager: TTMSFNCThemeManager read FThemeManager;
  end;

{ the resolved theme in effect for a control (nil without a theme) }
function ThemeOf(AControl: TComponent): TTMSFNCResolvedTheme;

implementation

function ThemeOf(AControl: TComponent): TTMSFNCResolvedTheme;
var
  n: string;
begin
  n := TTMSFNCTheme.EffectiveThemeName(AControl);
  if n = '' then
    n := TTMSFNCTheme.Current;
  if n <> '' then
    Result := TTMSFNCTheme.Resolve(n)
  else
    Result := nil;
end;

{ TDemoPanel }

constructor TDemoPanel.Create(AOwner: TComponent);
begin
  inherited;
  Width := 200;
  Height := 100;
end;

{ TDemoText }

constructor TDemoText.Create(AOwner: TComponent);
begin
  inherited;
  FFont := TTMSFNCGraphicsFont.Create;
  FFont.OnChanged := {$IFDEF WEBLIB}@{$ENDIF}DemoFontChanged;
  FWordWrap := True;
  FVerticalAlign := gtaLeading;
  Fill.Kind := gfkNone;
  Stroke.Kind := gskNone;
  Width := 200;
  Height := 24;
end;

destructor TDemoText.Destroy;
begin
  FFont.Free;
  inherited;
end;

procedure TDemoText.DemoFontChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TDemoText.SetFont(const Value: TTMSFNCGraphicsFont);
begin
  FFont.Assign(Value);
end;

procedure TDemoText.SetRole(const Value: TTMSFNCGraphicsTextRole);
begin
  FRole := Value;
  Invalidate;
end;

procedure TDemoText.SetText(const Value: string);
begin
  FText := Value;
  Invalidate;
end;

function TDemoText.TextHeight(AWidth: Single): Single;
var
  g: TTMSFNCGraphics;
begin
  Result := Height;
  g := TTMSFNCGraphics.CreateBitmapCanvas;
  try
    if g.BeginScene then
    begin
      g.Font.AssignSource(FFont);
      Result := g.CalculateTextHeight(FText, RectF(0, 0, AWidth, 10000), FWordWrap);
      g.EndScene;
    end;
  finally
    g.Free;
  end;
end;

procedure TDemoText.Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  t: TTMSFNCResolvedTheme;
  c: TTMSFNCGraphicsColor;
begin
  inherited;
  AGraphics.Font.AssignSource(FFont);
  { the theme's text colour comes through the font binding; a role takes its own colour }
  t := ThemeOf(Self);
  if Assigned(t) and (FRole <> gtrPrimary) then
  begin
    c := TTMSFNCTheme.TextRoleColor(t, FRole);
    if c <> gcNull then
      AGraphics.Font.Color := c;
  end;
  AGraphics.DrawText(ARect, FText, FWordWrap, gtaLeading, FVerticalAlign);
end;

{ TDemoLayout }

constructor TDemoLayout.Create(AOwner: TDemoForm; AThemeManager: TTMSFNCThemeManager);
begin
  inherited Create;
  FOwner := AOwner;
  FThemeManager := AThemeManager;
  FNatives := TList.Create;
  TTMSFNCTheme.AddChangeListener({$IFDEF WEBLIB}@{$ENDIF}ThemeChanged);
end;

destructor TDemoLayout.Destroy;
begin
  TTMSFNCTheme.RemoveChangeListener({$IFDEF WEBLIB}@{$ENDIF}ThemeChanged);
  FNatives.Free;
  inherited;
end;

function TDemoLayout.Size(AValue: Integer): Integer;
begin
  {$IFDEF VCL}
  Result := MulDiv(AValue, FOwner.CurrentPPI, 96);
  {$ELSE}
  Result := AValue;
  {$ENDIF}
end;

function TDemoLayout.InnerWidth(AParent: TDemoParent): Integer;
begin
  { the width a top aligned control gets between the 16 px margins; the parent's width is known before it is shown }
  Result := Round(TControl(AParent).Width) - Size(32);
end;

procedure TDemoLayout.Place(AControl: TControl; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer);
begin
  { a position beyond every control aligned earlier (VCL and WEB order controls of the same alignment by their
    position less their margin, so the steps are larger than any margin) }
  Inc(FPlaceOrder);
  {$IFDEF FMX}
  AControl.Position.Y := 100000 + FPlaceOrder * 1000;
  AControl.Position.X := 100000 + FPlaceOrder * 1000;
  case AAlign of
    daTop: AControl.Align := TAlignLayout.Top;
    daLeft: AControl.Align := TAlignLayout.Left;
    daRight: AControl.Align := TAlignLayout.Right;
    daBottom: AControl.Align := TAlignLayout.Bottom;
    daClient: AControl.Align := TAlignLayout.Client;
  end;
  case AAlign of
    daTop, daBottom: AControl.Height := ASize;
    daLeft, daRight: AControl.Width := ASize;
  end;
  AControl.Margins.Rect := RectF(ALeft, ATop, ARight, ABottom);
  {$ELSE}
  AControl.Top := 100000 + FPlaceOrder * 1000;
  AControl.Left := 100000 + FPlaceOrder * 1000;
  case AAlign of
    daTop: AControl.Align := alTop;
    daLeft: AControl.Align := alLeft;
    daRight: AControl.Align := alRight;
    daBottom: AControl.Align := alBottom;
    daClient: AControl.Align := alClient;
  end;
  case AAlign of
    daTop, daBottom: AControl.Height := Size(ASize);
    daLeft, daRight: AControl.Width := Size(ASize);
  end;
  AControl.AlignWithMargins := True;
  AControl.Margins.Left := Size(ALeft);
  AControl.Margins.Top := Size(ATop);
  AControl.Margins.Right := Size(ARight);
  AControl.Margins.Bottom := Size(ABottom);
  {$ENDIF}
end;

procedure TDemoLayout.AddHeader(const ATitle, ADescription: string; const AThemes: array of string);
var
  t, d: TDemoText;
  I: Integer;
begin
  FHeader := TDemoPanel.Create(FOwner);
  FHeader.Parent := FOwner;
  Place(FHeader, daTop, 72, 0, 0, 0, 0);
  FHeader.Stroke.Kind := gskNone;

  FThemes := TDemoComboBox.Create(FOwner);
  FThemes.Parent := FHeader;
  Place(FThemes, daRight, 160, 0, 20, 24, 20);
  for I := 0 to High(AThemes) do
    FThemes.Items.Add(AThemes[I]);
  {$IFDEF VCL}
  FThemes.Style := csDropDownList;
  {$ENDIF}
  FThemes.ItemIndex := 0;
  FThemes.OnChange := {$IFDEF WEBLIB}@{$ENDIF}ThemesChange;
  FNatives.Add(FThemes);

  d := TDemoText.Create(FOwner);
  d.Parent := FHeader;
  Place(d, daBottom, 24, 24, 0, 16, 8);
  d.WordWrap := False;
  d.TextRole := gtrSecondary;
  d.Text := ADescription;

  t := TDemoText.Create(FOwner);
  t.Parent := FHeader;
  Place(t, daClient, 0, 24, 10, 16, 0);
  t.WordWrap := False;
  t.VerticalAlign := gtaCenter;
  t.Font.Size := 20;
  TTMSFNCTheme.MakeSemibold(t.Font);
  t.Text := ATitle;

  ThemeChanged(nil);
end;

procedure TDemoLayout.ThemesChange(Sender: TObject);
begin
  if Assigned(FThemeManager) and (FThemes.ItemIndex >= 0) then
    FThemeManager.Theme := FThemes.Items[FThemes.ItemIndex];
end;

procedure TDemoLayout.ColorNative(AControl: TControl; AText: TTMSFNCGraphicsColor);
begin
  {$IFDEF FMX}
  if AControl is TPresentedTextControl then
  begin
    TPresentedTextControl(AControl).StyledSettings := TPresentedTextControl(AControl).StyledSettings - [TStyledSetting.FontColor];
    TPresentedTextControl(AControl).FontColor := AText;
  end;
  {$ELSE}
  if AControl is TDemoCheckBox then
    TDemoCheckBox(AControl).Font.Color := AText
  else if AControl is TDemoRadioButton then
    TDemoRadioButton(AControl).Font.Color := AText;
  {$ENDIF}
end;

procedure TDemoLayout.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  bg, txt: TTMSFNCGraphicsColor;
  I: Integer;
begin
  if csDestroying in FOwner.ComponentState then
    Exit;
  t := ThemeOf(FOwner);
  if Assigned(t) then
  begin
    bg := t[ttWindowBackground];
    txt := t[ttText];
  end
  else
  begin
    {$IFDEF FMX}
    bg := gcNull;
    txt := gcBlack;
    {$ELSE}
    bg := clBtnFace;
    txt := clWindowText;
    {$ENDIF}
  end;
  {$IFDEF FMX}
  if bg = gcNull then
    FOwner.Fill.Kind := TBrushKind.None
  else
  begin
    FOwner.Fill.Kind := TBrushKind.Solid;
    FOwner.Fill.Color := bg;
  end;
  {$ELSE}
  FOwner.Color := bg;
  {$ENDIF}
  for I := 0 to FNatives.Count - 1 do
    ColorNative(TControl(FNatives[I]), txt);
end;

function TDemoLayout.AddCaption(AParent: TDemoParent; const AText: string; ATop: Integer): TDemoText;
begin
  Result := TDemoText.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 24, 16, ATop, 16, 4);
  Result.WordWrap := False;
  Result.VerticalAlign := gtaCenter;
  Result.Font.Size := 13;
  TTMSFNCTheme.MakeSemibold(Result.Font);
  Result.Text := AText;
end;

function TDemoLayout.AddText(AParent: TDemoParent; const AText: string): TDemoText;
begin
  Result := TDemoText.Create(FOwner);
  Result.Parent := AParent;
  Result.TextRole := gtrSecondary;
  Result.Text := AText;
  Place(Result, daTop, Round(Result.TextHeight(InnerWidth(AParent))) + 2, 16, 4, 16, 4);
end;

function TDemoLayout.AddCheck(AParent: TDemoParent; const AText: string; AChecked: Boolean; AOnChange: TNotifyEvent): TDemoCheckBox;
begin
  Result := TDemoCheckBox.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 28, 16, 0, 16, 0);
  SetCaption(Result, AText);
  SetChecked(Result, AChecked);
  {$IFDEF FMX}
  Result.OnChange := AOnChange;
  {$ELSE}
  Result.OnClick := AOnChange;
  {$ENDIF}
  FNatives.Add(Result);
  ThemeChanged(nil);
end;

function TDemoLayout.AddRadios(AParent: TDemoParent; const AGroup: string; const ANames: array of string; AIndex: Integer;
  AOnChange: TNotifyEvent): TArray<TDemoRadioButton>;
var
  box: TDemoPanel;
  I: Integer;
begin
  { one box per group: VCL groups radio buttons by their parent }
  box := AddBox(AParent, daTop, 28 * Length(ANames), 0, 0, 0, 0);
  SetLength(Result, Length(ANames));
  for I := 0 to High(ANames) do
  begin
    Result[I] := TDemoRadioButton.Create(FOwner);
    Result[I].Parent := box;
    Place(Result[I], daTop, 28, 16, 0, 16, 0);
    SetCaption(Result[I], ANames[I]);
    {$IFNDEF VCL}
    Result[I].GroupName := AGroup;
    {$ENDIF}
    SetChecked(Result[I], I = AIndex);
    {$IFDEF FMX}
    Result[I].OnChange := AOnChange;
    {$ELSE}
    Result[I].OnClick := AOnChange;
    {$ENDIF}
    FNatives.Add(Result[I]);
  end;
  ThemeChanged(nil);
end;

function TDemoLayout.AddButton(AParent: TDemoParent; const AText: string; AOnClick: TNotifyEvent): TDemoButton;
begin
  Result := TDemoButton.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, daTop, 28, 16, 8, 16, 0);
  SetCaption(Result, AText);
  Result.OnClick := AOnClick;
end;

function TDemoLayout.AddPanel(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TDemoPanel;
begin
  Result := TDemoPanel.Create(FOwner);
  Result.Parent := AParent;
  Place(Result, AAlign, ASize, ALeft, ATop, ARight, ABottom);
end;

function TDemoLayout.AddBox(AParent: TDemoParent; AAlign: TDemoAlign; ASize, ALeft, ATop, ARight, ABottom: Integer): TDemoPanel;
begin
  Result := AddPanel(AParent, AAlign, ASize, ALeft, ATop, ARight, ABottom);
  Result.Fill.Kind := gfkNone;
  Result.Stroke.Kind := gskNone;
  TTMSFNCTheme.KeepValues(Result, ['Fill', 'Stroke']);
end;

function TDemoLayout.AddSettingsPanel(AParent: TDemoParent; AWidth: Integer): TDemoPanel;
begin
  Result := AddPanel(AParent, daLeft, AWidth, 16, 16, 0, 16);
end;

function TDemoLayout.AddContentPanel(AParent: TDemoParent): TDemoPanel;
begin
  Result := AddBox(AParent, daClient, 0, 16, 16, 16, 16);
end;

class function TDemoLayout.Checked(AControl: TControl): Boolean;
begin
  {$IFDEF FMX}
  if AControl is TCheckBox then
    Result := TCheckBox(AControl).IsChecked
  else if AControl is TRadioButton then
    Result := TRadioButton(AControl).IsChecked
  else
    Result := False;
  {$ELSE}
  if AControl is TDemoCheckBox then
    Result := TDemoCheckBox(AControl).Checked
  else if AControl is TDemoRadioButton then
    Result := TDemoRadioButton(AControl).Checked
  else
    Result := False;
  {$ENDIF}
end;

class procedure TDemoLayout.SetChecked(AControl: TControl; AValue: Boolean);
begin
  {$IFDEF FMX}
  if AControl is TCheckBox then
    TCheckBox(AControl).IsChecked := AValue
  else if AControl is TRadioButton then
    TRadioButton(AControl).IsChecked := AValue;
  {$ELSE}
  if AControl is TDemoCheckBox then
    TDemoCheckBox(AControl).Checked := AValue
  else if AControl is TDemoRadioButton then
    TDemoRadioButton(AControl).Checked := AValue;
  {$ENDIF}
end;

class function TDemoLayout.RadioIndex(const ARadios: TArray<TDemoRadioButton>): Integer;
var
  I: Integer;
begin
  Result := 0;
  for I := 0 to High(ARadios) do
    if Checked(ARadios[I]) then
      Exit(I);
end;

class procedure TDemoLayout.SetCaption(AControl: TControl; const AText: string);
begin
  {$IFDEF FMX}
  if AControl is TPresentedTextControl then
    TPresentedTextControl(AControl).Text := AText;
  {$ELSE}
  if AControl is TDemoCheckBox then
    TDemoCheckBox(AControl).Caption := AText
  else if AControl is TDemoRadioButton then
    TDemoRadioButton(AControl).Caption := AText
  else if AControl is TDemoButton then
    TDemoButton(AControl).Caption := AText;
  {$ENDIF}
end;

initialization
  TTMSFNCTheme.RegisterBindings(TDemoText, ['Font=@Text']);

end.
