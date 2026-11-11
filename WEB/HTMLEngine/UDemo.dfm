object Form1: TForm1
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
  OnCreate = WebFormCreate
  OnDestroy = WebFormDestroy
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 56
  end
  object TopPanel: TWebPanel
    Left = 0
    Top = 0
    Width = 900
    Height = 48
    Align = alTop
    BevelOuter = bvNone
    ShowCaption = False
    TabOrder = 0
    object SampleLbl: TWebLabel
      Left = 12
      Top = 16
      Width = 50
      Height = 15
      Caption = 'Sample'
    end
    object Samples: TWebComboBox
      Left = 70
      Top = 12
      Width = 150
      Height = 23
      TabOrder = 0
      OnChange = SamplesChange
      Items.Strings = ()
    end
    object Themes: TWebComboBox
      Left = 240
      Top = 12
      Width = 160
      Height = 23
      TabOrder = 1
      OnChange = ThemesChange
      Items.Strings = (
        'Fluent Light'
        'Fluent Dark'
        'Material 3 Light'
        'Office 2019 Black')
    end
    object ClearCacheBtn: TWebButton
      Left = 420
      Top = 10
      Width = 110
      Height = 28
      Caption = 'Clear cache'
      TabOrder = 2
      OnClick = ClearCacheBtnClick
    end
  end
  object StatusLbl: TWebLabel
    AlignWithMargins = True
    Left = 12
    Top = 702
    Width = 876
    Height = 15
    Margins.Left = 12
    Align = alBottom
    Caption = 'HTML engine samples'
  end
end
