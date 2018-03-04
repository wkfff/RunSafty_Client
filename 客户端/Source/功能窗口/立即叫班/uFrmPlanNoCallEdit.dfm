object frmPlanNoCallEdit: TfrmPlanNoCallEdit
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #20462#25913#19981#23450#26102#21483#29677
  ClientHeight = 339
  ClientWidth = 309
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnActivate = FormActivate
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 80
    Height = 16
    Caption = #25152#22312#21306#22495#65306
  end
  object Label2: TLabel
    Left = 24
    Top = 104
    Width = 80
    Height = 16
    Caption = #35745#21010#36710#27425#65306
  end
  object Label3: TLabel
    Left = 24
    Top = 64
    Width = 80
    Height = 16
    Caption = #20837#20303#25151#38388#65306
  end
  object Label4: TLabel
    Left = 24
    Top = 144
    Width = 80
    Height = 16
    Caption = #20837#20303#26102#38388#65306
  end
  object Label5: TLabel
    Left = 24
    Top = 182
    Width = 80
    Height = 16
    Caption = #21483#29677#26102#38388#65306
  end
  object btnFind: TSpeedButton
    Left = 278
    Top = 63
    Width = 23
    Height = 22
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F4F994A9
      CBF9FAFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFB6C7E0335CA54880B94B73B3EFF2F8FFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8C9E15184BC7DB5D77FB5
      D65691C34572B1F5F7FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFB9CBE2588EC18FC5DFA0D3E793C7E0619BC9466197F7F9FCFFFFFFFFFFFF
      D8E5F183ABD15A8FC14D87BE4C85BD5286BB4C81BB87BFDBA3D5E8A5D7E980BB
      DA3F65ACEDF1F7FFFFFFFFFFFFB9D1E6609AC86FA0CAA6C3DEE2EBF4E2EBF4A4
      BEDC538DC179B4D699CCE38DC4DE4F83BCEDF1F8FFFFFFFFFFFFD9E7F2659FCA
      A3C4DEFEFBF9FCF8F3FBF5EFFBF5EFFCF8F4FEFCFA5894C46FABD24073BEBBCD
      E3FFFFFFFFFFFFFFFFFF8BB9D876AAD1FDFBF9FBF5EFFAF4ECFAF4ECFAF4EDFA
      F4EDFBF6F0FEFCFA4F85BB6B95C5FFFFFFFFFFFFFFFFFFFFFFFF68A7CDACCCE4
      FCF7F1FAF3EBFAF3EBFAF3EBFAF4ECFAF4ECFAF4EDFCF8F3A5BFDC5589BEFFFF
      FFFFFFFFFFFFFFFFFFFF62A6CDE4EFF6FAF3ECFAF2EAFAF2EAFAF3EBFAF3EBFA
      F3ECFAF4ECFBF5EFE2EBF44D87BEFFFFFFFFFFFFFFFFFFFFFFFF63A8CFE5EFF7
      FAF3EBFAF2E9FAF2EAFAF2EAFAF3EBFAF3EBFAF3ECFBF5EEE2EBF4508BBFFFFF
      FFFFFFFFFFFFFFFFFFFF6CADD2AED1E6FBF6F0F9F1E8F9F2E9FAF2E9FAF2EAFA
      F3EBFAF3EBFCF7F2A7C4DF5B92C3FFFFFFFFFFFFFFFFFFFFFFFF91C2DD7DB6D7
      FDFAF7FAF3EBF9F1E8F9F2E9FAF2E9FAF2EAFBF5EEFDFBF971A4CD84AED2FFFF
      FFFFFFFFFFFFFFFFFFFFDCECF470B0D4A9CFE5FDFAF7FBF5EFFAF2EAFAF3EBFB
      F6F1FDFBF9A3C5DF639BC9D8E6F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFDCEC
      70B0D47DB7D7AFD1E6E5F0F7E4EFF6ACCEE477ADD267A1CCBAD3E7FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCECF491C3DD6DAED265A9CF63A7CE6A
      A8D08CBBD9DAE8F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = btnFindClick
  end
  object Label8: TLabel
    Left = 24
    Top = 218
    Width = 80
    Height = 16
    Caption = #20986#21220#26102#38388#65306
  end
  object edtTrainNo: TEdit
    Left = 99
    Top = 101
    Width = 177
    Height = 24
    TabOrder = 0
  end
  object comboArea: TComboBox
    Left = 99
    Top = 21
    Width = 177
    Height = 24
    ItemHeight = 0
    TabOrder = 1
  end
  object edtRoomNumber: TEdit
    Left = 99
    Top = 61
    Width = 177
    Height = 24
    ReadOnly = True
    TabOrder = 2
    OnKeyPress = edtRoomNumberKeyPress
  end
  object btnAdd: TButton
    Left = 113
    Top = 291
    Width = 81
    Height = 33
    Cancel = True
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnAddClick
  end
  object btnCancel: TButton
    Left = 210
    Top = 291
    Width = 81
    Height = 33
    Cancel = True
    Caption = #21462#28040
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object checkEnableCallTime: TCheckBox
    Left = 20
    Top = 256
    Width = 135
    Height = 17
    Caption = #19981#30830#23450#21483#29677#26102#38388
    TabOrder = 5
    OnClick = checkEnableCallTimeClick
  end
  object dtpInTime: TAdvDateTimePicker
    Left = 99
    Top = 141
    Width = 177
    Height = 24
    Date = 41137.412430555550000000
    Time = 41137.412430555550000000
    Kind = dkDateTime
    TabOrder = 6
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41137.412430555550000000
    TimeFormat = 'HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object dtpCallTime: TAdvDateTimePicker
    Left = 99
    Top = 180
    Width = 177
    Height = 24
    Date = 41137.412430555550000000
    Time = 41137.412430555550000000
    Kind = dkDateTime
    TabOrder = 7
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41137.412430555550000000
    TimeFormat = 'HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object dtpDutyTime: TAdvDateTimePicker
    Left = 99
    Top = 214
    Width = 177
    Height = 24
    Date = 41137.412430555550000000
    Time = 41137.412430555550000000
    Kind = dkDateTime
    TabOrder = 8
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41137.412430555550000000
    TimeFormat = 'HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object checkEnableDutyTime: TCheckBox
    Left = 156
    Top = 256
    Width = 135
    Height = 17
    Caption = #19981#30830#23450#20986#21220#26102#38388
    TabOrder = 9
    OnClick = checkEnableDutyTimeClick
  end
end
