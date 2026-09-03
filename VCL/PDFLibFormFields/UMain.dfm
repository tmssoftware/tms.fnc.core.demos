object Form4: TForm4
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'PDF Generation'
  ClientHeight = 282
  ClientWidth = 411
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  PixelsPerInch = 144
  TextHeight = 25
  object Button1: TButton
    Left = 36
    Top = 24
    Width = 338
    Height = 86
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Generate PDF'
    TabOrder = 0
    WordWrap = True
    OnClick = Button1Click
  end
end
