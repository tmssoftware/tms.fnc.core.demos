object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'TMS FNC PDF Capabilities'
  ClientHeight = 520
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 17
  object HeaderPanel: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 112
    Align = alTop
    BevelOuter = bvNone
    Color = 3158064
    ParentBackground = False
    TabOrder = 0
    object TitleLabel: TLabel
      Left = 24
      Top = 20
      Width = 174
      Height = 30
      Caption = 'PDF capabilities'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -24
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object DescriptionLabel: TLabel
      Left = 24
      Top = 60
      Width = 750
      Height = 40
      AutoSize = False
      Caption = 'Generate, inspect, edit, reorganize, extract, and merge PDF documents with TTMSFNCPDFLib.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 15132390
      Font.Height = -13
      Font.Name = 'Segoe UI'
      Font.Style = []
      ParentFont = False
      WordWrap = True
    end
  end
  object ActionsPanel: TPanel
    Left = 0
    Top = 112
    Width = 820
    Height = 66
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object CreateButton: TButton
      Left = 18
      Top = 13
      Width = 180
      Height = 40
      Caption = '1. Generate source PDF'
      TabOrder = 0
      OnClick = CreateButtonClick
    end
    object EditButton: TButton
      Left = 204
      Top = 13
      Width = 180
      Height = 40
      Caption = '2. Edit and reorganize'
      TabOrder = 1
      OnClick = EditButtonClick
    end
    object InspectButton: TButton
      Left = 390
      Top = 13
      Width = 150
      Height = 40
      Caption = '3. Inspect result'
      TabOrder = 2
      OnClick = InspectButtonClick
    end
    object OpenButton: TButton
      Left = 546
      Top = 13
      Width = 140
      Height = 40
      Caption = '4. Open PDF'
      TabOrder = 3
      OnClick = OpenButtonClick
    end
  end
  object LogMemo: TMemo
    Left = 0
    Top = 178
    Width = 820
    Height = 342
    Align = alClient
    Color = 16448250
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 2697513
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
end
