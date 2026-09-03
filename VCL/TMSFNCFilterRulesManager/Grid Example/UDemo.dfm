object FormMain: TFormMain
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'TMS FNC Filter Rules Manager VCL Demo'
  ClientHeight = 900
  ClientWidth = 1440
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -18
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 144
  TextHeight = 25
  object PanelTop: TPanel
    Left = 0
    Top = 0
    Width = 1440
    Height = 66
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object LabelFilter: TLabel
      AlignWithMargins = True
      Left = 15
      Top = 0
      Width = 42
      Height = 66
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      Caption = 'Filter:'
      Layout = tlCenter
      ExplicitHeight = 25
    end
    object LabelStatus: TLabel
      AlignWithMargins = True
      Left = 931
      Top = 0
      Width = 485
      Height = 66
      Margins.Left = 24
      Margins.Top = 0
      Margins.Right = 24
      Margins.Bottom = 0
      Align = alClient
      Alignment = taRightJustify
      Layout = tlCenter
      ExplicitLeft = 1411
      ExplicitWidth = 5
      ExplicitHeight = 25
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 234
      Top = 0
      Width = 85
      Height = 66
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Alignment = taCenter
      Caption = 'starts with:'
      Layout = tlCenter
      ExplicitHeight = 25
    end
    object EditSearch: TEdit
      AlignWithMargins = True
      Left = 331
      Top = 11
      Width = 300
      Height = 44
      Margins.Left = 12
      Margins.Top = 11
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alLeft
      TabOrder = 0
      OnKeyDown = EditSearchKeyDown
      ExplicitHeight = 33
    end
    object BtnApply: TButton
      AlignWithMargins = True
      Left = 643
      Top = 11
      Width = 150
      Height = 44
      Margins.Left = 12
      Margins.Top = 11
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alLeft
      Caption = 'Apply Filter'
      TabOrder = 1
      OnClick = BtnApplyClick
    end
    object BtnClear: TButton
      AlignWithMargins = True
      Left = 802
      Top = 11
      Width = 105
      Height = 44
      Margins.Left = 9
      Margins.Top = 11
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alLeft
      Caption = 'Clear'
      TabOrder = 2
      OnClick = BtnClearClick
    end
    object SearchFieldCombo: TComboBox
      AlignWithMargins = True
      Left = 69
      Top = 11
      Width = 150
      Height = 33
      Margins.Left = 12
      Margins.Top = 11
      Margins.Right = 0
      Margins.Bottom = 11
      Align = alLeft
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 3
      Text = 'Name'
      Items.Strings = (
        'Name'
        'Company'
        'City'
        'Country')
    end
  end
end
