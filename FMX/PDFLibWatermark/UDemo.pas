unit UDemo;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, FMX.Forms,
  FMX.Types, FMX.Controls, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.TMSFNCCustomComponent;

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

{$R *.fmx}

uses
  FMX.TMSFNCPDFLib, FMX.TMSFNCGraphicsTypes, FMX.TMSFNCUtils, System.IOUtils;

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

        r := RectF(0, p.PageHeight / 2 - 60, p.PageWidth,
          p.PageHeight / 2 + 60);
        p.Graphics.Alignment := gtaCenter;
        p.Graphics.DrawText(AText, r);

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

  lblInfo.Text := Format('Stamped %d page(s).'#13#10'%s', [pages, dst]);
  TTMSFNCUtils.OpenFile(dst);
end;

end.
