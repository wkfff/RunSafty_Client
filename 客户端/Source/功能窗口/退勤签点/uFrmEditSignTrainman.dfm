object FrmEditSignTrainman: TFrmEditSignTrainman
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35843#25972#31614#28857#20154#21592
  ClientHeight = 206
  ClientWidth = 358
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 16
    Top = 15
    Width = 86
    Height = 19
    Caption = #21407#21496#26426#24037#21495':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label1: TLabel
    Left = 16
    Top = 50
    Width = 86
    Height = 19
    Caption = #26032#21496#26426#24037#21495':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 16
    Top = 86
    Width = 85
    Height = 19
    Caption = #35843' '#25972' '#21407' '#22240':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 207
    Top = 15
    Width = 38
    Height = 19
    Caption = #22995#21517':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel
    Left = 207
    Top = 50
    Width = 38
    Height = 19
    Caption = #22995#21517':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtS_Number: TEdit
    Left = 108
    Top = 11
    Width = 93
    Height = 27
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
  end
  object edtD_Number: TEdit
    Left = 108
    Top = 46
    Width = 93
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 1
    OnChange = edtD_NumberChange
  end
  object mmoRemark: TMemo
    Left = 108
    Top = 85
    Width = 236
    Height = 67
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 179
    Top = 165
    Width = 75
    Height = 29
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 271
    Top = 165
    Width = 75
    Height = 29
    Caption = #21462#28040
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object edtS_Name: TEdit
    Left = 251
    Top = 11
    Width = 93
    Height = 27
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 5
  end
  object edtD_Name: TEdit
    Left = 251
    Top = 46
    Width = 93
    Height = 27
    Enabled = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 6
  end
end
