unit UFNCPopupMenuAppearance;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCPopupMenu, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer,
  FMX.TMSFNCTheme;

type
  TForm1 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    TMSFNCPopupMenu: TTMSFNCPopupMenu;
    Button1: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Label1: TLabel;
    procedure TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
    procedure TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
    procedure TMSFNCPopupMenuMenuItemControlAdded(Sender: TObject;
      AMenuItemControl: TTMSFNCMenuItemControl);
    procedure TMSFNCPopupMenuMenuItemClick(Sender: TObject;
      AMenuItemControl: TTMSFNCMenuItemControl);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
    procedure SetLightStyle;
    procedure SetDarkStyle;
  end;

var
  Form1: TForm1;

implementation

uses
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCUtils;

{$R *.fmx}

procedure TForm1.SetDarkStyle;
begin
  { the Style sub menu switches the application theme: the form, this menu and every FNC control
    follow (TTMSFNCThemeManager on the form) }
  ThemeManager.Theme := 'Fluent Dark';
end;

procedure TForm1.SetLightStyle;
begin
  { the Style sub menu switches the application theme: the form, this menu and every FNC control
    follow (TTMSFNCThemeManager on the form) }
  ThemeManager.Theme := 'Fluent Light';
end;

procedure TForm1.TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
begin
  SetLightStyle;
end;

procedure TForm1.TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
begin
  SetDarkStyle;
end;

procedure TForm1.TMSFNCPopupMenuMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
begin
  TTMSFNCUtils.Log(AMenuItemControl.Text + ' Clicked');
end;

procedure TForm1.TMSFNCPopupMenuMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  dmi: TTMSFNCMenuItem;
begin
  if AMenuItemControl.Text.StartsWith('Sort') then
  begin
    dmi := TMSFNCPopupMenu.GetCheckedMenuItemByGroupName('GroupBy');

    if Assigned(dmi) then
      AMenuItemControl.Text := 'Sort by ' + dmi.Text;
  end;
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons and edits keep the platform look,
  which is readable on a light and on a dark form. }
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
    { a form without FNC controls is not coloured by the manager: do it here }
    Fill.Kind := TBrushKind.Solid;
    Fill.Color := t[ttWindowBackground];
  end
  else
  begin
    txt := TAlphaColorRec.Black;
    sec := $FF5B6470;
    Fill.Kind := TBrushKind.None;
  end;
  DemoTitle.FontColor := txt;
  DemoDescription.FontColor := sec;
  Label1.FontColor := sec;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

end.
