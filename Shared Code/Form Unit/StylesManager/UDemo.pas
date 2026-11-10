unit UDemo;

{ TMS FNC Core - StylesManager

  TTMSFNCStylesManager and the theme engine side by side. Style can name a theme: the form then follows that theme
  (a form scope on top of the application theme of the ThemeManager). StyleResource loads one of the legacy FNC
  style files that ship with Core: its values become the developer's values of the controls, so a theme leaves them
  alone from then on. TTMSFNCTheme.ThemeFromStyleText turns such a style file into a theme instead, which is
  registered and switched like any other. AdaptToStyle makes a control read the colours of the framework style. }

interface

uses
  {$IFDEF VCL}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Types, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCCustomControl,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCTheme, VCL.TMSFNCStyles, VCL.TMSFNCScrollBar,
  {$ENDIF}

  {$IFDEF FMX}
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Forms, FMX.Controls, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCCustomControl,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCTheme, FMX.TMSFNCStyles, FMX.TMSFNCScrollBar,
  {$ENDIF}
  UDemoLayout;

type
  TForm1 = class(TDemoForm)
    ThemeManager: TTMSFNCThemeManager;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    FLayout: TDemoLayout;
    FSettings: TDemoPanel;
    FContent: TDemoPanel;
    FStyles: TTMSFNCStylesManager;
    FSourceRadios: TArray<TDemoRadioButton>;
    FAdaptCheck: TDemoCheckBox;
    FScrollBars: array[0..1] of TTMSFNCScrollBar;
    FState: TDemoText;
    FStyleThemeName: string;
    procedure CreateSettings;
    procedure CreateContent;
    procedure ApplySource;
    procedure SettingChanged(Sender: TObject);
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

const
  LegacyStyle = 'FNC_OFFICE2019BLACK';

procedure TForm1.FormCreate(Sender: TObject);
begin
  FLayout := TDemoLayout.Create(Self, ThemeManager);
  FLayout.AddHeader('StylesManager',
    'A styles manager whose Style names a theme, a legacy FNC style file from a resource, and AdaptToStyle next to each other',
    ['Fluent Light', 'Fluent Dark', 'Office 2019 White']);
  FStyles := TTMSFNCStylesManager.Create(Self);
  CreateSettings;
  CreateContent;
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
  FLayout.Free;
end;

procedure TForm1.CreateSettings;
begin
  FSettings := FLayout.AddSettingsPanel(Self, 300);

  FLayout.AddCaption(FSettings, 'Where the look comes from');
  FSourceRadios := FLayout.AddRadios(FSettings, 'Source', [
    'The application theme of the ThemeManager',
    'StylesManager.Style = ''Office 2019 Black'' (a theme name)',
    'StylesManager.StyleResource = ''' + LegacyStyle + ''' (a style file)',
    'A theme made from that style file'], 0, SettingChanged);
  FLayout.AddText(FSettings, 'A theme name in Style gives the form a form-scope theme over the application theme ' +
    '(the header picker still changes the application theme behind it). A style file sets the colours of the ' +
    'controls it knows and of the form: they stay as the developer''s values under every theme until the demo ' +
    'restarts. ThemeFromStyleText reads the same file into a theme, registered under its own name.');

  FLayout.AddCaption(FSettings, 'Framework style');
  FAdaptCheck := FLayout.AddCheck(FSettings, 'AdaptToStyle on the scroll bars', False, SettingChanged);
  FLayout.AddText(FSettings, 'AdaptToStyle reads the fill, stroke and font colours of the active FMX or VCL style ' +
    'instead of the control''s own appearance.');
end;

procedure TForm1.CreateContent;
var
  row, card: TDemoPanel;
  I: Integer;
const
  Titles: array[0..2] of string = ('Surface', 'Border', 'Text');
  Texts: array[0..2] of string = (
    'Cards and texts in this demo are small Core controls with theme bindings: Fill=@Surface, Stroke=@Border.',
    'The legacy style files know the released FNC controls (TTMSFNCScrollBar among them), not these: a style file ' +
    'colours the scroll bars and the form, a theme colours everything.',
    'Switch the header theme while a Style names a theme: the form keeps its own theme, the application theme ' +
    'changes behind it.');
begin
  FContent := FLayout.AddContentPanel(Self);

  FScrollBars[0] := TTMSFNCScrollBar.Create(Self);
  FScrollBars[0].Parent := FContent;
  FLayout.Place(FScrollBars[0], daRight, 18, 8, 0, 0, 0);
  FScrollBars[0].Kind := sbkVertical;
  FScrollBars[0].Max := 100;
  FScrollBars[0].PageSize := 25;
  FScrollBars[0].Value := 20;

  FScrollBars[1] := TTMSFNCScrollBar.Create(Self);
  FScrollBars[1].Parent := FContent;
  FLayout.Place(FScrollBars[1], daBottom, 18, 0, 8, 0, 0);
  FScrollBars[1].Kind := sbkHorizontal;
  FScrollBars[1].Max := 100;
  FScrollBars[1].PageSize := 25;
  FScrollBars[1].Value := 60;

  row := FLayout.AddBox(FContent, daTop, 140, 0, 0, 0, 0);
  for I := 0 to 2 do
  begin
    card := FLayout.AddPanel(row, daLeft, 230, 0, 0, 16, 0);
    FLayout.AddCaption(card, Titles[I], 12);
    FLayout.AddText(card, Texts[I]);
  end;

  FLayout.AddCaption(FContent, 'In effect');
  FState := FLayout.AddText(FContent, ' ');
  FLayout.Place(FState, daTop, 80, 16, 4, 16, 4);
end;

procedure TForm1.ApplySource;
var
  def: TTMSFNCThemeDefinition;
  I: Integer;
begin
  case TDemoLayout.RadioIndex(FSourceRadios) of
    0:
      begin
        FStyles.Style := '';
        if FStyleThemeName <> '' then
          ThemeManager.Theme := 'Fluent Light';
      end;
    1: FStyles.Style := 'Office 2019 Black';
    2:
      begin
        FStyles.Style := '';
        FStyles.StyleResource := LegacyStyle;
      end;
    3:
      begin
        FStyles.Style := '';
        if FStyleThemeName = '' then
        begin
          def := TTMSFNCTheme.ThemeFromStyleText(FStyles.GetStyleFromResource('TTMSFNCSTYLE_' + LegacyStyle),
            'Office 2019 Black (style file)');
          FStyleThemeName := def.Name;
          TTMSFNCTheme.RegisterTheme(def);
        end;
        ThemeManager.Theme := FStyleThemeName;
      end;
  end;
  for I := 0 to 1 do
    FScrollBars[I].AdaptToStyle := TDemoLayout.Checked(FAdaptCheck);
end;

procedure TForm1.SettingChanged(Sender: TObject);
begin
  ApplySource;
end;

procedure TForm1.ThemeChanged(Sender: TObject);
var
  s: string;
begin
  s := 'Application theme: <b>' + TTMSFNCTheme.Current + '</b>. Theme of the form: <b>' +
    TTMSFNCTheme.EffectiveThemeName(Self) + '</b>.';
  if FStyles.Style <> '' then
    s := s + ' StylesManager.Style = ''' + FStyles.Style + '''.';
  if FStyles.StyleResource <> '' then
    s := s + ' StylesManager.StyleResource = ''' + FStyles.StyleResource + ''' was loaded.';
  FState.Text := s;
end;

end.
