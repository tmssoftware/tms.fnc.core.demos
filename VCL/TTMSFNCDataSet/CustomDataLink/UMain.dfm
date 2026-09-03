object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Custom data object for TTMSFNCDataSet'
  ClientHeight = 440
  ClientWidth = 640
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    640
    440)
  TextHeight = 15
  object Button1: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Connect'
    TabOrder = 0
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 8
    Top = 39
    Width = 624
    Height = 393
    Anchors = [akLeft, akTop, akRight, akBottom]
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
end
