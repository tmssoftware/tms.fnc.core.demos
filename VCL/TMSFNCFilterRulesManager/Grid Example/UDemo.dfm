object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - Filter rules manager'
  ClientHeight = 620
  ClientWidth = 1040
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 15
  OnDestroy = FormDestroy
  object DemoHeader: TPanel
    Left = 0
    Top = 0
    Width = 1040
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object DemoTitle: TLabel
      Left = 24
      Top = 12
      Width = 826
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Filter rules manager - list'
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
      Width = 992
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Hide the rows of a list of plain objects with a rule: the manager reads and writes their properties'
    end
    object DemoThemeCombo: TComboBox
      Left = 866
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
    object LabelFilter: TLabel
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
      Caption = 'Filter'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object LabelField: TLabel
      Left = 0
      Top = 32
      Width = 260
      Height = 20
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Field'
    end
    object SearchFieldCombo: TComboBox
      Left = 0
      Top = 56
      Width = 260
      Height = 23
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 0
      Text = 'Name'
      Items.Strings = (
        'Name'
        'Company'
        'City'
        'Country')
    end
    object Label1: TLabel
      Left = 0
      Top = 87
      Width = 260
      Height = 20
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 4
      AutoSize = False
      Caption = 'Starts with'
    end
    object EditSearch: TEdit
      Left = 0
      Top = 111
      Width = 260
      Height = 23
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      TabOrder = 1
      Text = ''
      OnKeyDown = EditSearchKeyDown
    end
    object BtnApply: TButton
      Left = 0
      Top = 142
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = 'Apply filter'
      Default = True
      TabOrder = 2
      OnClick = BtnApplyClick
    end
    object BtnClear: TButton
      Left = 0
      Top = 186
      Width = 260
      Height = 36
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      Caption = 'Clear'
      TabOrder = 3
      OnClick = BtnClearClick
    end
    object LabelStatus: TLabel
      Left = 0
      Top = 230
      Width = 260
      Height = 40
      Align = alTop
      AlignWithMargins = True
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 8
      AutoSize = False
      Caption = ''
      WordWrap = True
    end
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
