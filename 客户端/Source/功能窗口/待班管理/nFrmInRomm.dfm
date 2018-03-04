object frmInRoom: TfrmInRoom
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20837#23507#30331#35760
  ClientHeight = 310
  ClientWidth = 475
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object rzgrpbx2: TRzGroupBox
    Left = 17
    Top = 18
    Width = 433
    Height = 144
    Caption = #24453#29677#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 21
      Top = 24
      Width = 60
      Height = 13
      Caption = #24453#29677#36710#27425#65306
    end
    object Label2: TLabel
      Left = 225
      Top = 24
      Width = 60
      Height = 13
      Caption = #24320#36710#26102#38388#65306
    end
    object lblMainDriver: TLabel
      Left = 33
      Top = 65
      Width = 48
      Height = 13
      Caption = #27491#21496#26426#65306
    end
    object Label4: TLabel
      Left = 249
      Top = 65
      Width = 36
      Height = 13
      Caption = #29366#24577#65306
    end
    object lblSubDriver: TLabel
      Left = 30
      Top = 106
      Width = 48
      Height = 13
      Caption = #21103#21496#26426#65306
    end
    object Label6: TLabel
      Left = 249
      Top = 106
      Width = 36
      Height = 13
      Caption = #29366#24577#65306
    end
    object edtTrainNo: TEdit
      Left = 84
      Top = 22
      Width = 129
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 0
    end
    object edtStartTime: TEdit
      Left = 290
      Top = 22
      Width = 121
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtMainDriver: TEdit
      Left = 84
      Top = 64
      Width = 129
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtMainDriverState: TEdit
      Left = 291
      Top = 64
      Width = 121
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 3
    end
    object edtSubDriver: TEdit
      Left = 84
      Top = 104
      Width = 129
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 4
    end
    object edtSubDriverState: TEdit
      Left = 290
      Top = 104
      Width = 121
      Height = 19
      Color = clBtnFace
      Ctl3D = False
      Enabled = False
      ParentCtl3D = False
      ReadOnly = True
      TabOrder = 5
    end
  end
  object btnCancel: TButton
    Left = 375
    Top = 264
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object btnSave: TButton
    Left = 294
    Top = 264
    Width = 75
    Height = 25
    Caption = #30830#35748#20837#23507
    Default = True
    TabOrder = 2
    OnClick = btnSaveClick
  end
  object RzGroupBox1: TRzGroupBox
    Left = 17
    Top = 182
    Width = 433
    Height = 61
    Caption = #20844#23507#20449#24687
    TabOrder = 3
    object Label3: TLabel
      Left = 21
      Top = 24
      Width = 60
      Height = 13
      Caption = #20241#24687#25151#38388#65306
    end
    object CombRoom: TComboBox
      Left = 84
      Top = 20
      Width = 129
      Height = 21
      AutoDropDown = True
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      ItemHeight = 13
      ParentCtl3D = False
      TabOrder = 0
      Text = #26410#20998#37197
    end
  end
end
