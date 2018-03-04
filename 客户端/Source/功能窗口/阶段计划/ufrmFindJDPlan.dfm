object frmFindJDPlan: TfrmFindJDPlan
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #26597#25214#35745#21010
  ClientHeight = 124
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 14
  object Label1: TLabel
    Left = 40
    Top = 35
    Width = 77
    Height = 14
    Caption = #35831#36755#20837#36710#27425':'
  end
  object edtTrainNo: TEdit
    Left = 123
    Top = 32
    Width = 153
    Height = 22
    TabOrder = 0
    OnExit = edtTrainNoExit
  end
  object btnOK: TButton
    Left = 120
    Top = 68
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 201
    Top = 68
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
