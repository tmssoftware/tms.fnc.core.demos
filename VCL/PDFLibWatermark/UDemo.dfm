object Form130: TForm130
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - PDF watermark'
  ClientHeight = 232
  ClientWidth = 640
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
    Width = 640
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object DemoTitle: TLabel
      Left = 24
      Top = 12
      Width = 426
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'PDF watermark'
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
      Width = 592
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Stamps a watermark under the content of every page of an existing PDF'
    end
    object DemoThemeCombo: TComboBox
      Left = 466
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
  object btnWatermark: TButton
    Left = 24
    Top = 96
    Width = 320
    Height = 36
    Caption = 'Create a report and stamp it CONFIDENTIAL'
    TabOrder = 0
    OnClick = btnWatermarkClick
  end
  object lblInfo: TLabel
    Left = 24
    Top = 148
    Width = 592
    Height = 60
    Anchors = [akLeft, akTop, akRight]
    AutoSize = False
    Caption = 'Generates a three page report, then opens it again and draws a watermark under the content of every page with BeginPageEdit(I, pelUnderlay).'
    WordWrap = True
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
