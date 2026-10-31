unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Memo.Types,
  System.ImageList, FMX.ImgList, FMX.StdCtrls, FMX.TMSFNCCustomComponent,
  FMX.TMSFNCStateManager, FMX.TMSFNCResponsiveManager,
  FMX.Controls.Presentation, FMX.ScrollBox, FMX.Memo,
  FMX.Layouts, FMX.ListBox, FMX.TMSFNCTheme;

type
  TForm20 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    Memo1: TMemo;
    Panel1: TPanel;
    TMSFNCResponsiveManager1: TTMSFNCResponsiveManager;
    ImageList1: TImageList;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    StyleBook1: TStyleBook;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form20: TForm20;

implementation

{$R *.fmx}

{ demo-colors: the layouts saved in the responsive manager hold the properties of the memo and
  the panel (their colours too): they are the subject of this demo and do not follow the theme. }

procedure TForm20.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;


procedure TForm20.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and grids keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm20.ThemeChanged(Sender: TObject);
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

procedure TForm20.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
