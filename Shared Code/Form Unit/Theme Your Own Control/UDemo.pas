unit UDemo;

{ TMS FNC Core - Theme Your Own Control

  TStatusCard is a small TTMSFNCCustomControl written for this demo. It follows every theme without a line of
  theme code in its paint method: its Fill, Stroke, fonts and accent colour are bound to theme tokens with
  TTMSFNCTheme.RegisterBindings, its shape is a card (RegisterShape), its body text is drawn in a text role
  (TextRoleColor, ApplyTextRole), its status chip takes the status colours of the theme (StatusColors) and its
  icons come from TTMSFNCThemeIcons (Draw for the big one, LoadInto for a tinted SVG bitmap). Next to the cards:
  a TTMSFNCScrollBar in the Fluent look of the theme, a TTMSFNCHint and a TTMSFNCPopup that take the theme's frame. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCTheme, VCL.TMSFNCThemeIcons, VCL.TMSFNCScrollBar, VCL.TMSFNCHint, VCL.TMSFNCPopup,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCTheme, FMX.TMSFNCThemeIcons, FMX.TMSFNCScrollBar, FMX.TMSFNCHint, FMX.TMSFNCPopup,
  {$ENDIF}

  {$IFDEF WEBLIB}
  SysUtils, Classes, Types, WEBLib.Graphics, WEBLib.Controls, WEBLib.Forms, WEBLib.Dialogs,
  WEBLib.TMSFNCTypes, WEBLib.TMSFNCUtils, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  WEBLib.TMSFNCCustomControl, WEBLib.TMSFNCCustomComponent, WEBLib.TMSFNCTheme, WEBLib.TMSFNCThemeIcons,
  WEBLib.TMSFNCScrollBar, WEBLib.TMSFNCPopup,
  {$ENDIF}
  UDemoLayout;

type
  { a card with an icon, a title, a status chip, a text and a progress bar; everything it draws comes from the
    theme in effect, and without a theme from its own properties }
  TStatusCard = class(TTMSFNCCustomControl)
  private
    FFont: TTMSFNCGraphicsFont;
    FTitleFont: TTMSFNCGraphicsFont;
    FAccentColor: TTMSFNCGraphicsColor;
    FTitle: string;
    FText: string;
    FStatus: string;
    FKind: TTMSFNCStatusKind;
    FTextRole: TTMSFNCGraphicsTextRole;
    FIcon: string;
    FIconState: TTMSFNCThemeIconState;
    FProgress: Integer;
    FBadge: TTMSFNCBitmap;
    procedure SetFont(const Value: TTMSFNCGraphicsFont);
    procedure SetTitleFont(const Value: TTMSFNCGraphicsFont);
    procedure SetAccentColor(const Value: TTMSFNCGraphicsColor);
    procedure SetTitle(const Value: string);
    procedure SetText(const Value: string);
    procedure SetStatus(const Value: string);
    procedure SetKind(const Value: TTMSFNCStatusKind);
    procedure SetTextRole(const Value: TTMSFNCGraphicsTextRole);
    procedure SetIcon(const Value: string);
    procedure SetIconState(const Value: TTMSFNCThemeIconState);
    procedure SetProgress(const Value: Integer);
    procedure AppearanceChanged(Sender: TObject);
  protected
    procedure Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Font: TTMSFNCGraphicsFont read FFont write SetFont;
    property TitleFont: TTMSFNCGraphicsFont read FTitleFont write SetTitleFont;
    property AccentColor: TTMSFNCGraphicsColor read FAccentColor write SetAccentColor default gcSteelblue;
    property Title: string read FTitle write SetTitle;
    property Text: string read FText write SetText;
    property Status: string read FStatus write SetStatus;
    property Kind: TTMSFNCStatusKind read FKind write SetKind default tskNone;
    property TextRole: TTMSFNCGraphicsTextRole read FTextRole write SetTextRole default gtrSecondary;
    property Icon: string read FIcon write SetIcon;
    property IconState: TTMSFNCThemeIconState read FIconState write SetIconState default tisNormal;
    property Progress: Integer read FProgress write SetProgress default 0;
  end;

  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TDemoPanel;
    FContent: TDemoPanel;
    FCards: array[0..2] of TStatusCard;
    FRoleRadios: TArray<TDemoRadioButton>;
    FIconRadios: TArray<TDemoRadioButton>;
    FThemeThirdCheck: TDemoCheckBox;
    FThemeScrollCheck: TDemoCheckBox;
    FScrollBar: TTMSFNCScrollBar;
    FScrollText: TDemoText;
    FTokens: TDemoText;
    FPopup: TTMSFNCPopup;
    FPopupContent: TDemoPanel;
    {$IFNDEF WEBLIB}
    FHint: TTMSFNCHint;
    {$ENDIF}
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySettings;
    procedure SettingChanged(Sender: TObject);
    procedure KeepFillClick(Sender: TObject);
    procedure HintClick(Sender: TObject);
    procedure PopupClick(Sender: TObject);
    procedure ScrollValueChanged(Sender: TObject; Value: Double);
    procedure ThemeChanged(Sender: TObject);
  public
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

{ TStatusCard }

constructor TStatusCard.Create(AOwner: TComponent);
begin
  inherited;
  FFont := TTMSFNCGraphicsFont.Create;
  FFont.OnChanged := {$IFDEF WEBLIB}@{$ENDIF}AppearanceChanged;
  FTitleFont := TTMSFNCGraphicsFont.Create;
  FTitleFont.Size := 14;
  TTMSFNCTheme.MakeSemibold(FTitleFont);
  FTitleFont.OnChanged := {$IFDEF WEBLIB}@{$ENDIF}AppearanceChanged;
  FAccentColor := gcSteelblue;
  FTextRole := gtrSecondary;
  FIcon := 'Document';
  FBadge := TTMSFNCBitmap.Create;
  { a monochrome SVG icon as a bitmap: ThemeTint draws it in the theme's secondary text colour while a themed
    control paints it, and in the colour given here without a theme }
  TTMSFNCThemeIcons.LoadInto(FBadge, 'StarFilled', 16, gcDarkgray, bttTextSecondary);
  Width := 240;
  Height := 150;
end;

destructor TStatusCard.Destroy;
begin
  FBadge.Free;
  FTitleFont.Free;
  FFont.Free;
  inherited;
end;

procedure TStatusCard.AppearanceChanged(Sender: TObject);
begin
  Invalidate;
end;

procedure TStatusCard.SetAccentColor(const Value: TTMSFNCGraphicsColor);
begin
  FAccentColor := Value;
  Invalidate;
end;

procedure TStatusCard.SetFont(const Value: TTMSFNCGraphicsFont);
begin
  FFont.Assign(Value);
end;

procedure TStatusCard.SetTitleFont(const Value: TTMSFNCGraphicsFont);
begin
  FTitleFont.Assign(Value);
end;

procedure TStatusCard.SetIcon(const Value: string);
begin
  FIcon := Value;
  Invalidate;
end;

procedure TStatusCard.SetIconState(const Value: TTMSFNCThemeIconState);
begin
  FIconState := Value;
  Invalidate;
end;

procedure TStatusCard.SetKind(const Value: TTMSFNCStatusKind);
begin
  FKind := Value;
  Invalidate;
end;

procedure TStatusCard.SetProgress(const Value: Integer);
begin
  FProgress := Value;
  Invalidate;
end;

procedure TStatusCard.SetStatus(const Value: string);
begin
  FStatus := Value;
  Invalidate;
end;

procedure TStatusCard.SetText(const Value: string);
begin
  FText := Value;
  Invalidate;
end;

procedure TStatusCard.SetTextRole(const Value: TTMSFNCGraphicsTextRole);
begin
  FTextRole := Value;
  Invalidate;
end;

procedure TStatusCard.SetTitle(const Value: string);
begin
  FTitle := Value;
  Invalidate;
end;

procedure TStatusCard.Draw(AGraphics: TTMSFNCGraphics; ARect: TRectF);
var
  t: TTMSFNCResolvedTheme;
  r, ir, pill, bar: TRectF;
  p, s: Single;
  bg, txt, border, trk: TTMSFNCGraphicsColor;
  scale: Single;
begin
  { the base class paints the surface: rounded with the theme's card radius and border }
  inherited;
  t := ThemeOf(Self);
  s := ScalePaintValue(1.0);
  p := 16 * s;
  r := RectF(ARect.Left + p, ARect.Top + p, ARect.Right - p, ARect.Bottom - p);

  { the icon in the colour of its state: TextSecondary, Text on hover, AccentText when selected ... }
  ir := RectF(r.Left, r.Top, r.Left + 32 * s, r.Top + 32 * s);
  {$IFDEF VCL}
  scale := PaintScaleFactor;
  {$ELSE}
  scale := 1;
  {$ENDIF}
  if Assigned(t) then
    txt := TTMSFNCThemeIcons.StateColor(t, FIconState)
  else
    txt := FFont.Color;
  TTMSFNCThemeIcons.Draw(AGraphics, FIcon, ir, txt, scale, 32);

  { the title in the bound title font }
  AGraphics.Font.AssignSource(FTitleFont);
  AGraphics.DrawText(RectF(ir.Right + 12 * s, r.Top, r.Right, ir.Bottom), FTitle, False, gtaLeading, gtaCenter);

  { the status chip: background, text and border of the status kind in this theme (the drop theme without one) }
  TTMSFNCTheme.StatusColors(t, FKind, bg, txt, border);
  AGraphics.Font.AssignSource(FFont);
  AGraphics.Font.Size := FFont.Size - 1;
  pill := RectF(r.Left, ir.Bottom + 12 * s, r.Left + AGraphics.CalculateTextWidth(FStatus) + 20 * s, ir.Bottom + 34 * s);
  AGraphics.Fill.Kind := gfkSolid;
  AGraphics.Fill.Color := bg;
  AGraphics.Stroke.Kind := gskSolid;
  AGraphics.Stroke.Color := border;
  AGraphics.DrawRoundRectangle(pill, (pill.Bottom - pill.Top) / 2);
  AGraphics.Font.Color := txt;
  AGraphics.DrawText(pill, FStatus, False, gtaCenter, gtaCenter);

  { the text in its role: the role colour replaces the theme's text colour, a colour of the developer stays }
  AGraphics.Font.AssignSource(FFont);
  if Assigned(t) then
    TTMSFNCTheme.ApplyTextRole(AGraphics.Font, FTextRole, t[ttText], TTMSFNCTheme.TextRoleColor(t, FTextRole));
  AGraphics.DrawText(RectF(r.Left, pill.Bottom + 10 * s, r.Right - 24 * s, r.Bottom - 12 * s), FText, True, gtaLeading, gtaLeading);

  { the tinted badge bitmap at the right }
  AGraphics.DrawBitmap(RectF(r.Right - 18 * s, pill.Bottom + 10 * s, r.Right, pill.Bottom + 28 * s), FBadge);

  { the progress bar: the track in the theme's track colour, the value in the bound accent }
  if Assigned(t) then
    trk := t[ttTrack]
  else
    trk := Stroke.Color;
  bar := RectF(r.Left, r.Bottom - 4 * s, r.Right, r.Bottom);
  AGraphics.Stroke.Kind := gskNone;
  AGraphics.Fill.Color := trk;
  AGraphics.DrawRoundRectangle(bar, 2 * s);
  if FProgress > 0 then
  begin
    bar.Right := bar.Left + (bar.Right - bar.Left) * FProgress / 100;
    AGraphics.Fill.Color := FAccentColor;
    AGraphics.DrawRoundRectangle(bar, 2 * s);
  end;
end;

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self, ThemeManager);
  FLayout.AddHeader('Theme Your Own Control',
    'A custom control that follows the theme: bindings, shape, text roles, status colours, theme icons, Fluent scroll bar, themed hint and popup',
    ['Fluent Light', 'Fluent Dark', 'Microsoft 365 Light', 'Microsoft 365 Dark', 'Office 2019 White', 'Office 2019 Black',
     'High Contrast']);
  CreateSettings;
  CreateContent;
  ApplySettings;
  TTMSFNCTheme.AddChangeListener({$IFDEF WEBLIB}@{$ENDIF}ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener({$IFDEF WEBLIB}@{$ENDIF}ThemeChanged);
  FLayout.Free;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self);

  FLayout.AddCaption(FSettings, 'Text role of the cards');
  FRoleRadios := FLayout.AddRadios(FSettings, 'Role', ['Primary', 'Secondary', 'Tertiary', 'Accent'], 1,
    {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Icon state');
  FIconRadios := FLayout.AddRadios(FSettings, 'Icon', ['Normal', 'Hover', 'Selected', 'Disabled'], 0,
    {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);

  FLayout.AddCaption(FSettings, 'Theme');
  FThemeThirdCheck := FLayout.AddCheck(FSettings, 'Theme the third card', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FThemeScrollCheck := FLayout.AddCheck(FSettings, 'Theme the scroll bar', True, {$IFDEF WEBLIB}@{$ENDIF}SettingChanged);
  FLayout.AddButton(FSettings, 'Keep my fill on the first card', {$IFDEF WEBLIB}@{$ENDIF}KeepFillClick);
  FLayout.AddText(FSettings, 'ThemingEnabled = False shows a control as it was dropped. KeepValues hands the fill back ' +
    'to the developer: the theme leaves it alone from then on, also after a switch.');

  FLayout.AddCaption(FSettings, 'Hint and popup');
  {$IFNDEF WEBLIB}
  FLayout.AddButton(FSettings, 'Show a hint at the first card', {$IFDEF WEBLIB}@{$ENDIF}HintClick);
  {$ENDIF}
  FLayout.AddButton(FSettings, 'Open a popup', {$IFDEF WEBLIB}@{$ENDIF}PopupClick);
  FLayout.AddText(FSettings, 'The hint window and the popup frame take the colours of the theme; hover a card for ' +
    'its hint.');
end;

procedure TForm1.CreateContent;
const
  Titles: array[0..2] of string = ('Build', 'Tests', 'Release');
  Statuses: array[0..2] of string = ('Passed', 'Warnings', 'Blocked');
  Kinds: array[0..2] of TTMSFNCStatusKind = (tskSuccess, tskWarning, tskError);
  Icons: array[0..2] of string = ('Settings', 'Shield', 'Send');
  Texts: array[0..2] of string = (
    'Compiled in 42 s for every platform. The surface, border and fonts are theme bindings.',
    'Two tests report slow queries. The chip uses StatusColors, the icon the state colour.',
    'Waiting for the review. ThemingEnabled = False shows the control as it was dropped.');
  Progress: array[0..2] of Integer = (100, 65, 20);
var
  row: TDemoPanel;
  I: Integer;
begin
  FContent := FLayout.AddContentPanel(Self);

  row := FLayout.AddBox(FContent, daTop, 150, 0, 0, 0, 0);
  for I := 0 to 2 do
  begin
    FCards[I] := TStatusCard.Create(Self);
    FCards[I].Parent := row;
    FLayout.Place(FCards[I], daLeft, 250, 0, 0, 16, 0);
    FCards[I].Title := Titles[I];
    FCards[I].Status := Statuses[I];
    FCards[I].Kind := Kinds[I];
    FCards[I].Icon := Icons[I];
    FCards[I].Text := Texts[I];
    FCards[I].Progress := Progress[I];
    FCards[I].Hint := Titles[I] + ': ' + Statuses[I];
    FCards[I].ShowHint := True;
  end;

  FLayout.AddCaption(FContent, 'Scroll bar');
  FScrollBar := TTMSFNCScrollBar.Create(Self);
  FScrollBar.Parent := FContent;
  FLayout.Place(FScrollBar, daTop, 18, 0, 4, 16, 0);
  FScrollBar.Kind := sbkHorizontal;
  FScrollBar.Min := 0;
  FScrollBar.Max := 100;
  FScrollBar.PageSize := 20;
  FScrollBar.Value := 30;
  FScrollBar.OnValueChanged := {$IFDEF WEBLIB}@{$ENDIF}ScrollValueChanged;
  FScrollText := FLayout.AddText(FContent, 'Value 30. Under a theme the scroll bar takes the Fluent look: a slim thumb ' +
    'on the surface, chevrons on hover; without a theme the classic one.');

  FLayout.AddCaption(FContent, 'What the control gets from the theme');
  FTokens := FLayout.AddText(FContent, ' ');
  FLayout.Place(FTokens, daTop, 120, 16, 4, 16, 4);

  { the content of the popup lives on the form; the popup shows it in a themed frame }
  FPopupContent := FLayout.AddPanel(FContent, daTop, 0, 0, 0, 0, 0);
  FPopupContent.Width := 260;
  FPopupContent.Height := 96;
  FLayout.AddCaption(FPopupContent, 'Themed popup', 8);
  FLayout.AddText(FPopupContent, 'Any control can be the content; the frame, its shadow and the rounded corners ' +
    'follow the theme of the placement control.');

  FPopup := TTMSFNCPopup.Create(Self);
  FPopup.ContentControl := FPopupContent;
  FPopup.Placement := ppBottom;

  {$IFNDEF WEBLIB}
  FHint := TTMSFNCHint.Create(Self);
  {$ENDIF}
end;

procedure TForm1.ApplySettings;
const
  Roles: array[0..3] of TTMSFNCGraphicsTextRole = (gtrPrimary, gtrSecondary, gtrTertiary, gtrAccent);
  States: array[0..3] of TTMSFNCThemeIconState = (tisNormal, tisHover, tisSelected, tisDisabled);
var
  I: Integer;
begin
  for I := 0 to 2 do
  begin
    FCards[I].TextRole := Roles[TDemoLayout.RadioIndex(FRoleRadios)];
    FCards[I].IconState := States[TDemoLayout.RadioIndex(FIconRadios)];
  end;
  FCards[2].ThemingEnabled := TDemoLayout.Checked(FThemeThirdCheck);
  FScrollBar.ThemingEnabled := TDemoLayout.Checked(FThemeScrollCheck);
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySettings;
end;

procedure TForm1.KeepFillClick(Sender: TObject);
begin
  { demo-colors: the developer's own fill, kept under every theme }
  FCards[0].Fill.Color := MakeGraphicsColor(255, 244, 206);
  TTMSFNCTheme.KeepValues(FCards[0], ['Fill']);
end;

procedure TForm1.HintClick(Sender: TObject);
{$IFNDEF WEBLIB}
var
  pt: TPointF;
{$ENDIF}
begin
  {$IFNDEF WEBLIB}
  pt := FCards[0].ConvertClientToScreen(PointF(16, 40));
  FHint.ShowHintAt('A TTMSFNCHint: the window, its border and its text follow the theme', Round(pt.X), Round(pt.Y));
  {$ENDIF}
end;

procedure TForm1.PopupClick(Sender: TObject);
begin
  FPopup.PlacementControl := TControl(Sender);
  FPopup.Popup;
end;

procedure TForm1.ScrollValueChanged(Sender: TObject; Value: Double);
begin
  FScrollText.Text := 'Value ' + IntToStr(Round(Value)) + '. Under a theme the scroll bar takes the Fluent look: a slim ' +
    'thumb on the surface, chevrons on hover; without a theme the classic one.';
end;

procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  s: string;
begin
  t := ThemeOf(Self);
  if Assigned(t) then
    s := 'Theme <b>' + TTMSFNCTheme.Current + '</b><br>' +
      'Surface ' + TTMSFNCGraphics.ColorToHTML(t[ttSurface]) + ', Border ' + TTMSFNCGraphics.ColorToHTML(t[ttBorder]) +
      ', Text ' + TTMSFNCGraphics.ColorToHTML(t[ttText]) + ', TextSecondary ' + TTMSFNCGraphics.ColorToHTML(t[ttTextSecondary]) +
      ', Accent ' + TTMSFNCGraphics.ColorToHTML(t[ttAccent]) + ', Success ' + TTMSFNCGraphics.ColorToHTML(t[ttSuccess]) +
      ', Warning ' + TTMSFNCGraphics.ColorToHTML(t[ttWarning]) + ', Error ' + TTMSFNCGraphics.ColorToHTML(t[ttError]) + '<br>' +
      'Card radius ' + FloatToStr(TTMSFNCTheme.ShapeRadius(TStatusCard, t)) + ' px. ' +
      'The bindings: Fill=@Surface, Stroke=@Border, Font=@Text, TitleFont=@Text, AccentColor=@Accent.'
  else
    s := 'No theme: the card paints its own Fill, Stroke, Font and AccentColor, the status chip the colours of the ' +
      'drop theme.';
  FTokens.Text := s;
end;

initialization
  TTMSFNCTheme.RegisterBindings(TStatusCard, ['Fill=@Surface', 'Stroke=@Border', 'Font=@Text', 'TitleFont=@Text',
    'AccentColor=@Accent']);
  TTMSFNCTheme.RegisterShape(TStatusCard, tshCard);

end.
