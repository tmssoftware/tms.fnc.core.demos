object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC PDFLib Watermark Demo'
  ClientHeight = 180
  ClientWidth = 420
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object lblInfo: TLabel
    Left = 24
    Top = 72
    Width = 372
    Height = 88
    AutoSize = False
    Caption =
      'Generates a three page report, then opens it again and draws a wa' +
      'termark under the content of every page with BeginPageEdit(I, pel' +
      'Underlay).'
    WordWrap = True
  end
  object btnWatermark: TButton
    Left = 24
    Top = 24
    Width = 372
    Height = 32
    Caption = 'Create a report and stamp it CONFIDENTIAL'
    TabOrder = 0
    OnClick = btnWatermarkClick
  end
end
