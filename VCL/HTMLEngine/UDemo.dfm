object frmHTMLDemo: TfrmHTMLDemo
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - HTML engine'
  ClientHeight = 720
  ClientWidth = 900
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 15
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 56
  end
  object Bar: TPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    ShowCaption = False
    TabOrder = 0
    object SampleLbl: TLabel
      Left = 12
      Top = 16
      Width = 40
      Height = 15
      Caption = 'Sample'
    end
    object Samples: TComboBox
      Left = 70
      Top = 12
      Width = 150
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'All samples'
      OnChange = SamplesChange
      Items.Strings = (
        'All samples'
        '4.x markup'
        'CSS styling'
        'Tables'
        'Lists'
        'Floats'
        'Theme colours'
        'RTL text'
        'Inline image'
        'Rowspan'
        'Cache')
    end
    object Themes: TComboBox
      Left = 240
      Top = 12
      Width = 160
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Fluent Light'
      OnChange = ThemesChange
      Items.Strings = (
        'Fluent Light'
        'Fluent Dark'
        'Material 3 Light'
        'Office 2019 Black')
    end
    object ExportBtn: TButton
      Left = 420
      Top = 10
      Width = 130
      Height = 28
      Caption = 'Export PDF'
      TabOrder = 2
      OnClick = ExportClick
    end
    object ClearCacheBtn: TButton
      Left = 562
      Top = 10
      Width = 110
      Height = 28
      Caption = 'Clear cache'
      TabOrder = 3
      OnClick = ClearCacheClick
    end
  end
  object StatusLbl: TLabel
    AlignWithMargins = True
    Left = 12
    Top = 702
    Width = 885
    Height = 15
    Margins.Left = 12
    Align = alBottom
    Caption = 'Hover the link to see its title'
  end
end
