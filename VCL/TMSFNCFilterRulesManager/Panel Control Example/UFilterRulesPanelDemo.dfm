object Form1: TForm1
  Left = 0
  Top = 0
  Margins.Left = 5
  Margins.Top = 5
  Margins.Right = 5
  Margins.Bottom = 5
  Caption = 'TMS FNC Filter Rules Manager Panel Control VCL Demo'
  ClientHeight = 420
  ClientWidth = 435
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
  object pnlControls: TPanel
    Left = 12
    Top = 72
    Width = 398
    Height = 326
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    BevelOuter = bvLowered
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
  object btnToggleButtons: TButton
    Left = 12
    Top = 12
    Width = 398
    Height = 48
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Caption = 'Toggle action buttons'
    TabOrder = 1
    OnClick = btnToggleButtonsClick
  end
end
