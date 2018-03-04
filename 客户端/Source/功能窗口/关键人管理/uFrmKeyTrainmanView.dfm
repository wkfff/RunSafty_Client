object FrmKeyTrainmanView: TFrmKeyTrainmanView
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20851#38190#20154#20449#24687
  ClientHeight = 315
  ClientWidth = 471
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
    Left = 30
    Top = 67
    Width = 40
    Height = 13
    Caption = #20851#38190#20154':'
  end
  object lbl2: TLabel
    Left = 18
    Top = 197
    Width = 52
    Height = 13
    Caption = #30331#35760#21407#22240':'
  end
  object lbl3: TLabel
    Left = 18
    Top = 121
    Width = 52
    Height = 13
    Caption = #27880#24847#20107#39033':'
  end
  object lbl4: TLabel
    Left = 253
    Top = 30
    Width = 40
    Height = 13
    Caption = #30331#35760#20154':'
  end
  object lbl5: TLabel
    Left = 6
    Top = 10
    Width = 64
    Height = 13
    Caption = #30331#35760#23458#25143#31471':'
  end
  object lbl6: TLabel
    Left = 18
    Top = 95
    Width = 52
    Height = 13
    Caption = #36215#22987#26102#38388':'
  end
  object lbl7: TLabel
    Left = 241
    Top = 94
    Width = 52
    Height = 13
    Caption = #25130#27490#26102#38388':'
  end
  object lbl8: TLabel
    Left = 241
    Top = 10
    Width = 52
    Height = 13
    Caption = #30331#35760#26102#38388':'
  end
  object lbl9: TLabel
    Left = 42
    Top = 30
    Width = 28
    Height = 13
    Caption = #36710#38388':'
  end
  object lbl10: TLabel
    Left = 253
    Top = 67
    Width = 40
    Height = 13
    Caption = #25351#23548#38431':'
  end
  object lblClient: TLabel
    Left = 75
    Top = 10
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblWorkShop: TLabel
    Left = 75
    Top = 30
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblRegisterTime: TLabel
    Left = 299
    Top = 10
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblRegister: TLabel
    Left = 299
    Top = 30
    Width = 4
    Height = 13
    Caption = '-'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 52
    Width = 455
    Height = 2
  end
  object Bevel2: TBevel
    Left = 8
    Top = 272
    Width = 455
    Height = 2
  end
  object btnCancel: TButton
    Left = 375
    Top = 280
    Width = 75
    Height = 26
    Caption = #20851#38381
    TabOrder = 0
    OnClick = btnCancelClick
  end
  object dtpStart: TRzDateTimePicker
    Left = 76
    Top = 91
    Width = 147
    Height = 21
    Date = 42360.442520914350000000
    Time = 42360.442520914350000000
    Enabled = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 1
  end
  object dtpEnd: TRzDateTimePicker
    Left = 299
    Top = 91
    Width = 153
    Height = 21
    Date = 42360.442520914350000000
    Time = 42360.442520914350000000
    Enabled = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object mmoReason: TMemo
    Left = 76
    Top = 194
    Width = 374
    Height = 70
    Color = clCream
    Enabled = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object mmoAnnouncements: TMemo
    Left = 76
    Top = 118
    Width = 374
    Height = 70
    Color = clCream
    Enabled = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ReadOnly = True
    TabOrder = 4
  end
  object edtKeyTrainman: TEdit
    Left = 76
    Top = 64
    Width = 147
    Height = 21
    Color = clCream
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
  end
  object edtCheDui: TEdit
    Left = 299
    Top = 64
    Width = 153
    Height = 21
    Color = clCream
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 6
  end
end
