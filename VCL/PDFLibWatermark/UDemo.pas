unit UDemo;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Classes, System.Types,
  Vcl.Graphics, Vcl.Forms, Vcl.StdCtrls, Vcl.Controls,
  VCL.TMSFNCCustomComponent;

type
  TForm130 = class(TForm)
    btnWatermark: TButton;
    lblInfo: TLabel;
    procedure btnWatermarkClick(Sender: TObject);
  private
    function CreateReport(const AFileName: string): Integer;
    procedure StampWatermark(const ASource, ATarget: string;
      const AText: string);
  public
  end;

var
  Form130: TForm130;

implementation

{$R *.dfm}

uses
  VCL.TMSFNCPDFLib, VCL.TMSFNCGraphicsTypes, VCL.TMSFNCUtils, System.IOUtils,
  System.Math;

function TForm130.CreateReport(const AFileName: string): Integer;
var
  p: TTMSFNCPDFLib;
  I: Integer;
begin
  p := TTMSFNCPDFLib.Create(Self);
  try
    p.Header := 'Quarterly report';
    p.Footer := 'Page';
    p.BeginDocument(AFileName);
    for I := 1 to 3 do
    begin
      p.NewPage;
      p.Graphics.Font.Name := 'Arial';
      p.Graphics.Font.SizeNoScale := 22;
      p.Graphics.Font.Color := gcBlack;
      p.Graphics.DrawText(Format('Section %d', [I]), PointF(60, 90));
      p.Graphics.Font.SizeNoScale := 11;
      p.Graphics.DrawText('This page carries the content a reader is meant ' +
        'to read. The watermark goes underneath it.',
        RectF(60, 130, p.PageWidth - 60, 200));
    end;
    Result := p.GetPageCount;
    p.EndDocument;
  finally
    p.Free;
  end;
end;

procedure TForm130.StampWatermark(const ASource, ATarget: string;
  const AText: string);
var
  p: TTMSFNCPDFLib;
  I: Integer;
  r: TRectF;
  a: Double;
begin
  p := TTMSFNCPDFLib.Create(Self);
  try
    p.OpenDocument(ASource);

    for I := 0 to p.GetPageCount - 1 do
    begin
      // pelUnderlay draws beneath what the page already holds, so the
      // watermark never covers the content. pelOverlay would draw on top.
      p.BeginPageEdit(I, pelUnderlay);
      try
        p.Graphics.Font.Name := 'Arial';
        p.Graphics.Font.SizeNoScale := 64;
        p.Graphics.Font.Color := MakeGraphicsColor(220, 220, 220);
        p.Graphics.Fill.Kind := gfkNone;
        p.Graphics.Stroke.Kind := gskNone;

        // Rotate 45 degrees about the middle of the page. DrawSetTransform
        // takes the matrix directly, so the stamp is drawn around (0,0) and
        // the transform puts it on the diagonal.
        a := -45 * Pi / 180;
        p.Graphics.DrawSaveState;
        p.Graphics.DrawSetTransform(Cos(a), Sin(a), -Sin(a), Cos(a),
          p.PageWidth / 2, p.PageHeight / 2);

        r := RectF(-p.PageWidth / 2, -40, p.PageWidth / 2, 40);
        p.Graphics.Alignment := gtaCenter;
        p.Graphics.DrawText(AText, r);

        p.Graphics.DrawRestoreState;

        p.EndPageEdit;
      except
        p.CancelPageEdit;
        raise;
      end;
    end;

    p.SaveDocument(ATarget);
    p.CloseDocument;
  finally
    p.Free;
  end;
end;

procedure TForm130.btnWatermarkClick(Sender: TObject);
var
  src, dst: string;
  pages: Integer;
begin
  src := TPath.Combine(TPath.GetDocumentsPath, 'FNCWatermark_source.pdf');
  dst := TPath.Combine(TPath.GetDocumentsPath, 'FNCWatermark_stamped.pdf');

  pages := CreateReport(src);
  StampWatermark(src, dst, 'CONFIDENTIAL');

  lblInfo.Caption := Format('Stamped %d page(s).'#13#10'%s', [pages, dst]);
  TTMSFNCUtils.OpenFile(dst);
end;

end.
