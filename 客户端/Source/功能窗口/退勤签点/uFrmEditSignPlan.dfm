object FrmEditSignPlan: TFrmEditSignPlan
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #32534#36753#20505#29677#35745#21010
  ClientHeight = 274
  ClientWidth = 448
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
    Left = 22
    Top = 53
    Width = 78
    Height = 19
    Caption = #36710'   '#27425':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl3: TLabel
    Left = 14
    Top = 89
    Width = 86
    Height = 19
    Caption = #20505#29677#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 14
    Top = 125
    Width = 86
    Height = 19
    Caption = #21483#29677#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl6: TLabel
    Left = 22
    Top = 17
    Width = 78
    Height = 19
    Caption = #20132'   '#36335':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 14
    Top = 161
    Width = 86
    Height = 19
    Caption = #20986#21220#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 14
    Top = 197
    Width = 86
    Height = 19
    Caption = #24320#36710#26102#38388':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object lbl7: TLabel
    Left = 257
    Top = 53
    Width = 86
    Height = 19
    Caption = #26159#21542#20505#29677':'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 232
    Top = 231
    Width = 90
    Height = 33
    Caption = #30830#23450
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 343
    Top = 231
    Width = 90
    Height = 33
    Caption = #21462#28040
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object edtCheCi: TEdit
    Left = 107
    Top = 49
    Width = 131
    Height = 27
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 2
  end
  object dtpHouBanDay: TDateTimePicker
    Left = 107
    Top = 85
    Width = 179
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 3
  end
  object dtpJiaoBanDay: TDateTimePicker
    Left = 107
    Top = 121
    Width = 179
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 4
  end
  object dtpHouBanTime: TDateTimePicker
    Left = 301
    Top = 85
    Width = 132
    Height = 27
    Date = 41947.000000000000000000
    Format = 'HH:mm'
    Time = 41947.000000000000000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 5
  end
  object dtpJiaoBanTime: TDateTimePicker
    Left = 301
    Top = 121
    Width = 132
    Height = 27
    Date = 41947.000000000000000000
    Format = 'HH:mm'
    Time = 41947.000000000000000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 6
  end
  object dtpChuQinDay: TDateTimePicker
    Left = 107
    Top = 157
    Width = 179
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 7
  end
  object dtpChuQinTime: TDateTimePicker
    Left = 301
    Top = 157
    Width = 132
    Height = 27
    Date = 41947.000000000000000000
    Format = 'HH:mm'
    Time = 41947.000000000000000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 8
  end
  object dtpKaiCheDay: TDateTimePicker
    Left = 107
    Top = 193
    Width = 179
    Height = 27
    Date = 41947.461762893520000000
    Time = 41947.461762893520000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 9
  end
  object dtpKaiCheTime: TDateTimePicker
    Left = 301
    Top = 193
    Width = 132
    Height = 27
    Date = 41947.000000000000000000
    Format = 'HH:mm'
    Time = 41947.000000000000000000
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    Kind = dtkTime
    ParentFont = False
    TabOrder = 10
  end
  object cbbRest: TComboBox
    Left = 358
    Top = 49
    Width = 75
    Height = 27
    Style = csDropDownList
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 19
    ItemIndex = 0
    ParentFont = False
    TabOrder = 11
    Text = #21542
    Items.Strings = (
      #21542
      #26159)
  end
  object edtTrainJiaoLu: TEdit
    Left = 106
    Top = 13
    Width = 326
    Height = 27
    Enabled = False
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 12
  end
end
