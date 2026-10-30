unit UDemo;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, WEBLib.TMSFNCPrinters, WEBLib.TMSFNCGraphics, WEBLib.TMSFNCGraphicsTypes,
  Vcl.Graphics, Vcl.Controls, WEBLib.ExtCtrls, Vcl.StdCtrls, WEBLib.StdCtrls, WEBLIB.TMSFNCTypes,
  VCL.TMSFNCTypes, VCL.TMSFNCUtils, VCL.TMSFNCGraphics, VCL.TMSFNCGraphicsTypes, WEBLib.TMSFNCTheme;

type
  TForm1 = class(TWebForm)
    ThemeManager: TTMSFNCThemeManager;
    ThemeLabel: TWebLabel;
    ThemeCombo: TWebComboBox;
    WebButton1: TWebButton;
    WebImageControl1: TWebImageControl;
    procedure WebButton1Click(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure ThemeComboChange(Sender: TObject);
  private
    { Private declarations }
    bmp : TTMSFNCBitmap;
    procedure DoBitmapChange(Sender: TObject);
    procedure ThemeChanged(Sender: TObject);
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

{ TForm1 }
procedure TForm1.DoBitmapChange(Sender: TObject);
begin
  WebButton1.Enabled := True;
end;

procedure TForm1.WebButton1Click(Sender: TObject);
begin
  TMSFNCPrinter.BeginDoc;
end;

{ demo-colors: the printed page (blue text, red ellipse) is the subject of this demo }
procedure TForm1.WebFormCreate(Sender: TObject);
begin
  TTMSFNCTheme.AddChangeListener(@ThemeChanged);
  ThemeChanged(nil);
  WebButton1.Enabled := False;
  bmp := TTMSFNCBitmap.Create;
  bmp.OnChange := DoBitmapChange;
  bmp.LoadFromFile(WebImageControl1.Picture.FileName);

  TMSFNCPrinter.OnDrawContent :=
  procedure
  begin
    TMSFNCPrinter.Graphics.Font.Color := gcBlue;
    TMSFNCPrinter.Graphics.Font.Size := 40;
    TMSFNCPrinter.Graphics.DrawText(0,20, TMSFNCPrinter.PageWidth, 100, 'Hello', False, gtaCenter, gtaCenter);

    TMSFNCPrinter.Graphics.Fill.Color := gcRed;
    TMSFNCPrinter.Graphics.DrawEllipse(100,200, TMSFNCPrinter.PageWidth - 100, 300);

    TMSFNCPrinter.Graphics.DrawBitmap(50,400, TMSFNCPrinter.PageWidth - 50, TMSFNCPrinter.PageHeight - 50, bmp, True, True);
    TMSFNCPrinter.EndDoc;
    bmp.Free;
  end;
end;

{ Core has no FNC label or button: the page's own controls take the colours of the theme in
  effect (without a theme: the browser's). }
procedure TForm1.ThemeChanged(Sender: TObject);
var
  t: TTMSFNCResolvedTheme;
begin
  t := nil;
  if TTMSFNCTheme.Current <> '' then
    t := TTMSFNCTheme.Resolve(TTMSFNCTheme.Current);
  if Assigned(t) then
  begin
    Color := t[ttWindowBackground];
    ThemeLabel.Font.Color := t[ttText];
  end
  else
  begin
    Color := clBtnFace;
    ThemeLabel.Font.Color := clWindowText;
  end;
end;

procedure TForm1.ThemeComboChange(Sender: TObject);
begin
  if ThemeCombo.ItemIndex >= 0 then
    ThemeManager.Theme := ThemeCombo.Items[ThemeCombo.ItemIndex];
end;

end.