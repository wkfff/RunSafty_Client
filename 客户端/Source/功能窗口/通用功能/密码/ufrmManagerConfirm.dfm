object frmManagerConfirm: TfrmManagerConfirm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #31649#29702#21592#36523#20221#30830#35748
  ClientHeight = 154
  ClientWidth = 303
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 16
  object lbl1: TLabel
    Left = 39
    Top = 40
    Width = 144
    Height = 16
    Caption = #35831#36755#20837#31649#29702#21592#23494#30721#65306
  end
  object btnOK: TBitBtn
    Left = 115
    Top = 96
    Width = 73
    Height = 22
    Caption = #30830#23450'[&Q]'
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TBitBtn
    Left = 194
    Top = 96
    Width = 73
    Height = 22
    Caption = #21462#28040'[&C]'
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object edtPassWord: TEdit
    Left = 39
    Top = 59
    Width = 225
    Height = 24
    Hint = #35831#36755#20837#31649#29702#21592#23494#30721
    ParentShowHint = False
    PasswordChar = '*'
    ShowHint = True
    TabOrder = 0
    OnKeyPress = edtPassWordKeyPress
  end
end
