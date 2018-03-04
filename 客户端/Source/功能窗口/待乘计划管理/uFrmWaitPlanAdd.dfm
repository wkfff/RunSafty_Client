object frmWaitPlanAdd: TfrmWaitPlanAdd
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #28155#21152#24453#20056#35745#21010
  ClientHeight = 215
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 16
  object Label3: TLabel
    Left = 31
    Top = 27
    Width = 80
    Height = 16
    Caption = #35745#21010#36710#27425#65306
  end
  object Label6: TLabel
    Left = 31
    Top = 89
    Width = 80
    Height = 16
    Caption = #24378#20241#26102#38388#65306
  end
  object Label2: TLabel
    Left = 31
    Top = 123
    Width = 80
    Height = 16
    Caption = #21483#29677#26102#38388#65306
  end
  object Label1: TLabel
    Left = 47
    Top = 59
    Width = 64
    Height = 16
    Caption = #25151#38388#21495#65306
  end
  object edtTrainNo: TEdit
    Left = 124
    Top = 25
    Width = 61
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 76
    Top = 161
    Width = 83
    Height = 30
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 169
    Top = 161
    Width = 83
    Height = 30
    Cancel = True
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
  object edtRoomNumber: TEdit
    Left = 124
    Top = 57
    Width = 138
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 3
    OnKeyPress = edtRoomNumberKeyPress
  end
  object checkEnable: TCheckBox
    Left = 204
    Top = 27
    Width = 58
    Height = 17
    Caption = #21551#29992
    Checked = True
    State = cbChecked
    TabOrder = 4
  end
end
