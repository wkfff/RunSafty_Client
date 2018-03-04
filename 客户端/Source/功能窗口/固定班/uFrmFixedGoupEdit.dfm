object FrmFixedGroupEdit: TFrmFixedGroupEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #22266#23450#29677
  ClientHeight = 283
  ClientWidth = 269
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
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl7: TLabel
    Left = 40
    Top = 11
    Width = 36
    Height = 13
    Caption = #36710#38388#65306
  end
  object lbl6: TLabel
    Left = 28
    Top = 43
    Width = 48
    Height = 13
    Caption = #25351#23548#38431#65306
  end
  object lbl1: TLabel
    Left = 16
    Top = 76
    Width = 60
    Height = 13
    Caption = #26426#32452#32534#21495#65306
  end
  object lbl2: TLabel
    Left = 16
    Top = 108
    Width = 60
    Height = 13
    Caption = #26426#32452#21517#31216#65306
  end
  object cbbWorkShop: TRzComboBox
    Left = 81
    Top = 7
    Width = 167
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
    OnChange = cbbWorkShopChange
  end
  object cbbCheDui: TRzComboBox
    Left = 81
    Top = 39
    Width = 167
    Height = 21
    Style = csDropDownList
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 1
  end
  object edtGroupIndex: TEdit
    Left = 81
    Top = 72
    Width = 167
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object edtGroupName: TEdit
    Left = 81
    Top = 104
    Width = 167
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object btnOK: TButton
    Left = 82
    Top = 242
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 4
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 174
    Top = 242
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 5
    OnClick = btnCancelClick
  end
end
