object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'TMS FNC Core - Filter rules manager'
  ClientHeight = 520
  ClientWidth = 760
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
    Width = 760
    Height = 72
    Align = alTop
    BevelOuter = bvNone
    ParentColor = True
    ShowCaption = False
    TabOrder = 0
    object DemoTitle: TLabel
      Left = 24
      Top = 12
      Width = 546
      Height = 30
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'Filter rules manager - panel'
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
      Width = 712
      Height = 20
      Anchors = [akLeft, akTop, akRight]
      AutoSize = False
      Caption = 'A rule shows and hides the action buttons of a panel, whatever else the panel holds'
    end
    object DemoThemeCombo: TComboBox
      Left = 586
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
      Caption = 'Rule'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Segoe UI Semibold'
      Font.Style = []
      ParentFont = False
    end
    object btnToggleButtons: TButton
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
      Caption = 'Toggle action buttons'
      TabOrder = 0
      OnClick = btnToggleButtonsClick
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
      Caption = 'The rule selects every control of the panel whose name starts with btn and sets its visibility. The other controls stay.'
      WordWrap = True
    end
  end
  object pnlControls: TPanel
    AlignWithMargins = True
    Left = 300
    Top = 72
    Width = 436
    Height = 424
    Margins.Left = 16
    Margins.Top = 0
    Margins.Right = 24
    Margins.Bottom = 24
    Align = alClient
    BevelOuter = bvLowered
    Color = clWindow
    ParentBackground = False
    TabOrder = 0
    object lblCustomer: TLabel
      Left = 1
      Top = 95
      Width = 396
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Customer: FNC Demo Company'
      Layout = tlCenter
      ExplicitWidth = 255
    end
    object lblDueDate: TLabel
      Left = 1
      Top = 214
      Width = 396
      Height = 25
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Due date: 30 days'
      Layout = tlCenter
      ExplicitWidth = 143
    end
    object btnCreateInvoice: TButton
      Left = 1
      Top = 1
      Width = 396
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Create invoice'
      TabOrder = 0
    end
    object chkIncludePaid: TCheckBox
      Left = 1
      Top = 34
      Width = 396
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Include paid invoices'
      TabOrder = 1
    end
    object btnExportInvoices: TButton
      Left = 1
      Top = 62
      Width = 396
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Export invoices'
      TabOrder = 2
    end
    object btnArchiveInvoice: TButton
      Left = 1
      Top = 120
      Width = 396
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Archive invoice'
      TabOrder = 3
    end
    object rbOverdueOnly: TRadioButton
      Left = 1
      Top = 153
      Width = 396
      Height = 28
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Overdue only'
      TabOrder = 4
    end
    object btnApproveInvoice: TButton
      Left = 1
      Top = 181
      Width = 396
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Approve invoice'
      TabOrder = 5
    end
    object btnSendReminder: TButton
      Left = 1
      Top = 239
      Width = 396
      Height = 33
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alTop
      Caption = 'Send reminder'
      TabOrder = 6
    end
  end
  object ThemeManager: TTMSFNCThemeManager
    Theme = 'Fluent Light'
    Left = 8
    Top = 8
  end
end
