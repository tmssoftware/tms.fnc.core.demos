unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, VCL.TMSFNCPrinters, VCL.TMSFNCGraphicsTypes,
  Vcl.Imaging.pngimage, Vcl.ExtCtrls, Vcl.StdCtrls, VCL.TMSFNCTypes,
  VCL.TMSFNCTheme;

type
  TForm3 = class(TForm)
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TPanel;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TPanel;
    StepsCaption: TLabel;
    StepsHint: TLabel;
    Button1: TButton;
    PrintDialog1: TPrintDialog;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure DemoThemeComboChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    procedure ThemeChanged(Sender: TObject);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  if (PrintDialog1.Execute) then
    TMSFNCPrinter.BeginDoc;
end;

{ demo-colors: the printed page (blue text, red ellipse) is the subject of this demo }
procedure TForm3.FormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(ThemeChanged);
  ThemeChanged(nil);
  TMSFNCPrinter.OnDrawContent :=
  procedure
  begin
    TMSFNCPrinter.Graphics.Font.Color := gcBlue;
    TMSFNCPrinter.Graphics.Font.Size := 40;
    TMSFNCPrinter.Graphics.DrawText(0,20, TMSFNCPrinter.PageWidth, 100, 'Hello', False, gtaCenter, gtaCenter);

    TMSFNCPrinter.Graphics.Fill.Color := gcRed;
    TMSFNCPrinter.Graphics.DrawEllipse(100,200, TMSFNCPrinter.PageWidth - 100, 300);
    TMSFNCPrinter.Graphics.DrawBitmap(50,400, TMSFNCPrinter.PageWidth - 50, TMSFNCPrinter.PageHeight - 50, Image1.Picture, True, True);
    TMSFNCPrinter.EndDoc;
  end;
end;

procedure TForm3.FormDestroy(Sender: TObject);
begin
  TTMSFNCTheme.RemoveChangeListener(ThemeChanged);
end;

{ Core has no FNC label or button: the native labels take the text colours of the theme in
  effect (without a theme: the platform's). Native buttons, edits and memos keep the platform
  look, which is readable on a light and on a dark form. }
procedure TForm3.ThemeChanged(Sender: TObject);
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
  StepsCaption.Font.Color := txt;
  DemoDescription.Font.Color := sec;
  StepsHint.Font.Color := sec;
end;

procedure TForm3.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
