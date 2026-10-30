unit UFNCPopupMenuAppearance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  VCL.TMSFNCPopupMenu, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer,
  VCL.TMSFNCTheme;

type
  TForm4 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    TMSFNCPopupMenu1: TTMSFNCPopupMenu;
    Button1: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Label1: TLabel;
    procedure TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
    procedure TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
    procedure TMSFNCPopupMenu1MenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
    procedure TMSFNCPopupMenu1MenuItemClick(Sender: TObject;
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
  Form4: TForm4;

implementation
uses
  VCL.TMSFNCUtils;

{$R *.dfm}

procedure TForm4.SetDarkStyle;
begin
  { the Style sub menu switches the application theme: the form, this menu and every FNC control
    follow (TTMSFNCThemeManager on the form) }
  ThemeManager.Theme := 'Fluent Dark';
end;

procedure TForm4.SetLightStyle;
begin
  { the Style sub menu switches the application theme: the form, this menu and every FNC control
    follow (TTMSFNCThemeManager on the form) }
  ThemeManager.Theme := 'Fluent Light';
end;

procedure TForm4.TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
begin
  SetLightStyle;
end;

procedure TForm4.TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
begin
  SetDarkStyle;
end;

procedure TForm4.TMSFNCPopupMenu1MenuItemClick(Sender: TObject;
  AMenuItemControl: TTMSFNCMenuItemControl);
begin
  TTMSFNCUtils.Log(AMenuItemControl.Text + ' Clicked');
end;

procedure TForm4.TMSFNCPopupMenu1MenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  mic: TTMSFNCMenuItem;
begin
  if AMenuItemControl.Text.StartsWith('Sort') then
  begin
    mic := TMSFNCPopupMenu1.GetCheckedMenuItemByGroupName('GroupBy');

    if Assigned(mic) then
      AMenuItemControl.Text := 'Sort by ' + mic.Text;
  end;
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons and edits keep the platform look,
  which is readable on a light and on a dark form. }
procedure TForm4.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
    { a form without FNC controls is not coloured by the manager: do it here }
    Color := t[ttWindowBackground];
  end
  else
  begin
    txt := clWindowText;
    sec := clGrayText;
    Color := clBtnFace;
  end;
  DemoTitle.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  Label1.Font.Color := sec;
end;

procedure TForm4.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm4.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

end.
