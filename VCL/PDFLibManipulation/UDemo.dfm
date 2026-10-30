object Form131: TForm131
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - PDF document manipulation'
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
      Caption = 'PDF document manipulation'
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
      Caption = 'Merge, reorder, rotate and delete pages, edit metadata and read text back'
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
      Caption = 'Document pack'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object btnRun: TButton
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
      Caption = 'Assemble a pack'
      TabOrder = 0
      OnClick = btnRunClick
    end
    object lblInfo: TLabel
      Left = 0
      Top = 76
      Width = 260
      Height = 150
      Align = alTop
      AutoSize = False
      Caption = 'Builds two documents, then opens one and merges, reorders, rotates and deletes pages, writes its metadata, adds a link annotation and reads the first page back as text.'
      WordWrap = True
    end
  end
  object memoText: TMemo
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
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 2
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
