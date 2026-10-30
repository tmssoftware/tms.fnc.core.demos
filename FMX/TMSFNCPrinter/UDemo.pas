unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Printer, FMX.TMSFNCPrinters, FMX.TMSFNCGraphicsTypes,
  FMX.TMSFNCTypes, FMX.TMSFNCUtils, FMX.TMSFNCGraphics, FMX.TMSFNCCustomControl, FMX.Objects,
  FMX.TMSFNCPrintIO,
  FMX.ListBox, FMX.Layouts, FMX.TMSFNCTheme;

type
  TForm3 = class(TForm)
    PrintDialog1: TPrintDialog;
    ThemeManager: TTMSFNCThemeManager;
    DemoHeader: TLayout;
    DemoTitle: TLabel;
    DemoDescription: TLabel;
    DemoThemeCombo: TComboBox;
    SettingsPanel: TLayout;
    StepsCaption: TLabel;
    StepsHint: TLabel;
    Button1: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
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
  Form3: TForm3;

implementation

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
  {$IFDEF MSWINDOWS}
  if (PrintDialog1.Execute) then
  {$ENDIF}
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
    TMSFNCPrinter.Graphics.DrawBitmap(50,400, TMSFNCPrinter.PageWidth - 50, TMSFNCPrinter.PageHeight - 50, Image1.Bitmap, True, True);

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
  StepsCaption.FontColor := txt;
  DemoDescription.FontColor := sec;
  StepsHint.FontColor := sec;
end;

procedure TForm3.DemoThemeComboChange(Sender: TObject);
begin
  if DemoThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := DemoThemeCombo.Items[DemoThemeCombo.ItemIndex];
end;

end.
