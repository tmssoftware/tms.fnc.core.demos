object Form1: TForm1
  Width = 640
  Height = 500
  Caption = 'TMS FNC Core - Cloud Base'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Segoe UI'
  Font.Style = []
  FormContainer = 'appcontent'
  ParentFont = False
  OnCreate = WebFormCreate
  object ThemeLabel: TWebLabel
    Left = 16
    Top = 18
    Width = 40
    Height = 15
    Caption = 'Theme'
    ElementClassName = 'form-label'
    HeightPercent = 100.000000000000000000
    WidthPercent = 100.000000000000000000
  end
  object ThemeCombo: TWebComboBox
    Left = 72
    Top = 12
    Width = 160
    Height = 28
    ElementClassName = 'form-select'
    HeightPercent = 100.000000000000000000
    Text = 'Fluent Light'
    WidthPercent = 100.000000000000000000
    OnChange = ThemeComboChange
    ItemIndex = 0
    Items.Strings = (
      'Fluent Light'
      'Fluent Dark')
  end
  object WebEdit1: TWebEdit
    Left = 16
    Top = 56
    Width = 280
    Height = 32
    Text = 'CSI'
  end
  object WebButton1: TWebButton
    Left = 304
    Top = 56
    Width = 128
    Height = 32
    Caption = 'Search shows'
    ChildOrder = 1
    OnClick = WebButton1Click
  end
  object WebListBox1: TWebListBox
    Left = 16
    Top = 104
    Width = 280
    Height = 320
    ItemHeight = 13
    ItemIndex = -1
    OnClick = WebListBox1Click
  end
  object WebImageControl1: TWebImageControl
    Left = 312
    Top = 104
    Width = 220
    Height = 320
    ChildOrder = 3
  end
  object WebLabel1: TWebLabel
    Left = 16
    Top = 440
    Width = 608
    Height = 40
    Caption = 'TTMSFNCCloudBase sends the search to the TVmaze REST API and parses the JSON list of shows. Selecting a show sends a second GET request with the same component, this time for the poster image.'
    WordWrap = True
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 248
    Top = 8
  end
end
