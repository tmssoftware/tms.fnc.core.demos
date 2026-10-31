unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, System.ImageList, Vcl.ImgList,
  VCL.TMSFNCCustomComponent, VCL.TMSFNCStateManager,
  VCL.TMSFNCResponsiveManager, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Vcl.VirtualImageList,
  VCL.TMSFNCTheme;

type
  TForm20 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    Memo1: TMemo;
    Panel1: TPanel;
    TMSFNCResponsiveManager1: TTMSFNCResponsiveManager;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    VirtualImageList1: TVirtualImageList;
    ImageCollection1: TImageCollection;
    VirtualImageList2: TVirtualImageList;
    procedure TMSFNCResponsiveManager1AfterLoadState(Sender: TObject;
      AState: TTMSFNCStateManagerItem);
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

{$R *.dfm}

{ demo-colors: the layouts saved in the responsive manager hold the properties of the memo and
  the panel (their colours too): they are the subject of this demo and do not follow the theme. }

procedure TForm20.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
end;

procedure TForm20.TMSFNCResponsiveManager1AfterLoadState(Sender: TObject;
  AState: TTMSFNCStateManagerItem);
begin
  if AState.Index = 0 then
  begin
    Button1.Images := VirtualImageList2;
    Button2.Images := VirtualImageList2;
    Button3.Images := VirtualImageList2;
    Button4.Images := VirtualImageList2;
  end
  else
  begin
    Button1.Images := VirtualImageList1;
    Button2.Images := VirtualImageList1;
    Button3.Images := VirtualImageList1;
    Button4.Images := VirtualImageList1;
  end;
end;


procedure TForm20.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm20.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
  txt, sec: TColor;
begin
  t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    txt := t[ttText];
    sec := t[ttTextSecondary];
  end
  else
  begin
    txt := clWindowText;
    sec := clGrayText;
  end;
  DemoTitle.Font.Color := txt;
  DemoDescription.Font.Color := sec;
end;

procedure TForm20.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
