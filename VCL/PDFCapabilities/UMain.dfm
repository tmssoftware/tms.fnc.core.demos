object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - PDF capabilities'
  ClientHeight = 520
  ClientWidth = 820
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  object DemoHeader: TPanel
    Left = 0
    Top = 0
    Width = 820
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object DemoTitle: TLabel
      Left = 24
      Top = 12
      Width = 606
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'PDF capabilities'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -20
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object DemoDescription: TLabel
      Left = 24
      Top = 44
      Width = 772
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Generate, inspect, edit, reorganize, extract and merge PDF documents with TTMSFNCPDFLib'
    end
    object DemoThemeCombo: TComboBox
      Left = 646
      Top = 16
      Width = 150
      Height = 23
      Style = csDropDownList
      Anchors = [akTop, akRight]
      ItemIndex = 0
      TabOrder = 2
      Text = 'Fluent Light'
      OnChange = DemoThemeComboChange
      Items.Strings = (
        'Fluent Light'
        'Fluent Dark')
    end
  end
  object SettingsPanel: TPanel
    AlignWithMargins = True
    Left = 24
    Top = 72
    Width = 260
    Height = 424
    Margins.Left = 24
    Margins.Top = 0
    Margins.Right = 0
    Margins.Bottom = 24
    Align = alLeft
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 1
    object StepsCaption: TLabel
      Left = 0
      Top = 0
      Width = 260
      Height = 24
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      AutoSize = False
      Caption = 'Steps'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object CreateButton: TButton
      Left = 0
      Top = 32
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = '1. Generate source PDF'
      TabOrder = 0
      OnClick = CreateButtonClick
    end
    object EditButton: TButton
      Left = 0
      Top = 76
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = '2. Edit and reorganize'
      TabOrder = 1
      OnClick = EditButtonClick
    end
    object InspectButton: TButton
      Left = 0
      Top = 120
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = '3. Inspect result'
      TabOrder = 2
      OnClick = InspectButtonClick
    end
    object OpenButton: TButton
      Left = 0
      Top = 164
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = '4. Open PDF'
      TabOrder = 3
      OnClick = OpenButtonClick
    end
    object StepsHint: TLabel
      Left = 0
      Top = 208
      Width = 260
      Height = 64
      Align = alTop
      AutoSize = False
      Caption = 'Steps 3 and 4 create the source PDF first when it does not exist yet.'
      WordWrap = True
    end
  end
  object LogMemo: TMemo
    AlignWithMargins = True
    Left = 300
    Top = 72
    Width = 496
    Height = 424
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 24
    Margins.Bottom = 24
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Consolas'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
