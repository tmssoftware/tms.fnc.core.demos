object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - Data set'
  ClientHeight = 520
  ClientWidth = 860
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  OnDestroy = FormDestroy
  object DemoHeader: TPanel
    Left = 0
    Top = 0
    Width = 860
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object DemoTitle: TLabel
      Left = 24
      Top = 12
      Width = 646
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Custom data object'
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
      Width = 812
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'A custom data object is shown as a data set without a database'
    end
    object DemoThemeCombo: TComboBox
      Left = 686
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
    Height = 400
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
      Caption = 'Data object'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object Button1: TButton
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
      Caption = 'Connect'
      TabOrder = 0
      OnClick = Button1Click
    end
    object StepsHint: TLabel
      Left = 0
      Top = 76
      Width = 260
      Height = 110
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      AutoSize = False
      Caption = 'Connect sets the data object of the TTMSFNCDataSet. The grid shows its records through the standard data-aware controls.'
      WordWrap = True
    end
  end
  object DBGrid1: TDBGrid
    AlignWithMargins = True
    Left = 300
    Top = 72
    Width = 536
    Height = 424
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 24
    Margins.Bottom = 24
    Align = alClient
    DataSource = DataSource1
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
  end
  object TMSFNCDataSet1: TTMSFNCDataSet
    FieldDefs = <>
    Left = 96
    Top = 72
  end
  object DataSource1: TDataSource
    DataSet = TMSFNCDataSet1
    Left = 272
    Top = 80
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
