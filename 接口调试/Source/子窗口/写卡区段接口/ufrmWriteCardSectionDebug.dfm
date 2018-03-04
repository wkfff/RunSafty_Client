object FrmWriteCardSection: TFrmWriteCardSection
  Left = 0
  Top = 0
  Caption = #20889#21345#21306#27573
  ClientHeight = 417
  ClientWidth = 674
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 391
    Top = 0
    Width = 283
    Height = 417
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 263
    Top = 0
    Width = 128
    Height = 417
    Align = alLeft
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 263
    Height = 417
    Align = alLeft
    Indent = 19
    TabOrder = 2
    Items.NodeData = {
      01030000003D0000000000000000000000FFFFFFFFFFFFFFFF00000000000000
      001247006500740050006C0061006E0041006C006C0053006500630074006900
      6F006E007300470000000000000000000000FFFFFFFFFFFFFFFF000000000000
      00001747006500740050006C0061006E00530065006C00650063007400650064
      00530065006300740069006F006E007300370000000000000000000000FFFFFF
      FFFFFFFFFF00000000000000000F53006500740050006C0061006E0053006500
      6300740069006F006E007300}
  end
end
