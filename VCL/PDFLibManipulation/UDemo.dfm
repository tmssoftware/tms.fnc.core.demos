object Form131: TForm131
  Left = 0
  Top = 0
  Caption = 'TMS FNC PDFLib Document Manipulation Demo'
  ClientHeight = 340
  ClientWidth = 460
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
    Width = 412
    Height = 60
    AutoSize = False
    Caption = 
      'Builds two documents, then opens one and merges, reorders, rotate' +
      's and deletes pages, writes its metadata, adds a link annotation ' +
      'and reads the first page back as text.'
    WordWrap = True
  end
  object btnRun: TButton
    Left = 24
    Top = 24
    Width = 412
    Height = 32
    Caption = 'Assemble a pack from two documents'
    TabOrder = 0
    OnClick = btnRunClick
  end
  object memoText: TMemo
    Left = 24
    Top = 140
    Width = 412
    Height = 180
    ScrollBars = ssBoth
    TabOrder = 1
  end
end
