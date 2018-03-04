object frmSetOrg: TfrmSetOrg
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'frmSetOrg'
  ClientHeight = 191
  ClientWidth = 334
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label4: TLabel
    Left = 41
    Top = 66
    Width = 60
    Height = 13
    Caption = #25152#22312#36710#38388#65306
  end
  object Label7: TLabel
    Left = 53
    Top = 33
    Width = 48
    Height = 13
    Caption = #26426#21153#27573#65306
  end
  object Label5: TLabel
    Left = 41
    Top = 99
    Width = 60
    Height = 13
    Caption = #25152#23646#21306#27573#65306
  end
  object comboWorkShop: TRzComboBox
    Left = 102
    Top = 63
    Width = 145
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnChange = comboWorkShopChange
  end
  object comboArea: TRzComboBox
    Left = 102
    Top = 29
    Width = 145
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 1
    OnChange = comboAreaChange
  end
  object btnOK: TButton
    Left = 146
    Top = 149
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 2
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 227
    Top = 149
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 3
    OnClick = btnCancelClick
  end
  object comboTrainJiaolu: TRzComboBox
    Left = 102
    Top = 96
    Width = 145
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 4
  end
end
