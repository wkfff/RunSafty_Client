object frmWorkTimeEdit: TfrmWorkTimeEdit
  Left = 0
  Top = 0
  Caption = #21171#26102#20449#24687#30830#35748
  ClientHeight = 524
  ClientWidth = 832
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
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 832
    Height = 483
    Align = alClient
    BorderOuter = fsNone
    BorderWidth = 20
    TabOrder = 0
    object RzGroupBox1: TRzGroupBox
      Left = 20
      Top = 103
      Width = 792
      Align = alTop
      Caption = #24448#36335#20449#24687
      GroupStyle = gsTopLine
      TabOrder = 1
      object Label2: TLabel
        Left = 30
        Top = 25
        Width = 60
        Height = 13
        Caption = #20986#21220#26102#38388#65306
      end
      object Label1: TLabel
        Left = 30
        Top = 54
        Width = 60
        Height = 13
        Caption = #26412#27573#24320#36710#65306
      end
      object Label3: TLabel
        Left = 294
        Top = 54
        Width = 52
        Height = 13
        Caption = #22806#31449#21040#36798':'
      end
      object Label12: TLabel
        Left = 567
        Top = 54
        Width = 36
        Height = 13
        Caption = #21306#27573#65306
      end
      object Label13: TLabel
        Left = 294
        Top = 86
        Width = 60
        Height = 13
        Caption = #20837#24211#26102#38388#65306
      end
      object Label14: TLabel
        Left = 30
        Top = 86
        Width = 60
        Height = 13
        Caption = #20013#20572#26102#38388#65306
      end
      object Label15: TLabel
        Left = 294
        Top = 22
        Width = 60
        Height = 13
        Caption = #20986#24211#26102#38388#65306
      end
      object edtDestStation: TRzEdit
        Left = 630
        Top = 54
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object checkLocalOutDepots: TCheckBox
        Left = 568
        Top = 20
        Width = 74
        Height = 17
        Caption = #30452#36890
        TabOrder = 2
        OnClick = checkLocalOutDepotsClick
      end
      object checkDestInDepots: TCheckBox
        Left = 568
        Top = 84
        Width = 74
        Height = 17
        Caption = #30452#36890
        TabOrder = 7
        OnClick = checkLocalOutDepotsClick
      end
      object dtpChuQin: TAdvDateTimePicker
        Left = 92
        Top = 20
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 0
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpLocalOutDepots: TAdvDateTimePicker
        Left = 359
        Top = 20
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 1
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpStartTime: TAdvDateTimePicker
        Left = 92
        Top = 54
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 3
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpArriveTime: TAdvDateTimePicker
        Left = 359
        Top = 54
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 4
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpDestInDepots: TAdvDateTimePicker
        Left = 359
        Top = 84
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 6
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object edtLocalStop: TRzEdit
        Left = 92
        Top = 82
        Width = 155
        Height = 21
        TabOrder = 8
      end
    end
    object RzGroupBox2: TRzGroupBox
      Left = 20
      Top = 208
      Width = 792
      Height = 65
      Align = alTop
      Caption = #23507#20241#20449#24687
      GroupStyle = gsTopLine
      TabOrder = 2
      object Label5: TLabel
        Left = 294
        Top = 33
        Width = 60
        Height = 13
        Caption = #31163#23507#26102#38388#65306
      end
      object Label4: TLabel
        Left = 30
        Top = 35
        Width = 60
        Height = 13
        Caption = #20837#23507#26102#38388#65306
      end
      object checkInOutRoom: TCheckBox
        Left = 568
        Top = 33
        Width = 74
        Height = 17
        Caption = #26080#23507#20241
        TabOrder = 2
      end
      object dtpInRoom: TAdvDateTimePicker
        Left = 92
        Top = 31
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 0
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpOutRoom: TAdvDateTimePicker
        Left = 359
        Top = 30
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 1
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
    end
    object RzGroupBox3: TRzGroupBox
      Left = 20
      Top = 273
      Width = 792
      Height = 98
      Align = alTop
      Caption = #22238#36335#20449#24687
      GroupStyle = gsTopLine
      TabOrder = 3
      object Label6: TLabel
        Left = 30
        Top = 55
        Width = 60
        Height = 13
        Caption = #22806#31449#24320#36710#65306
      end
      object Label7: TLabel
        Left = 294
        Top = 53
        Width = 60
        Height = 13
        Caption = #26412#27573#21040#36798#65306
      end
      object Label8: TLabel
        Left = 30
        Top = 80
        Width = 60
        Height = 13
        Caption = #20013#20572#26102#38388#65306
      end
      object Label9: TLabel
        Left = 294
        Top = 79
        Width = 60
        Height = 13
        Caption = #20837#24211#26102#38388#65306
      end
      object Label10: TLabel
        Left = 569
        Top = 52
        Width = 48
        Height = 13
        Caption = #32456#21040#31449#65306
      end
      object Label16: TLabel
        Left = 30
        Top = 25
        Width = 60
        Height = 13
        Caption = #20986#24211#26102#38388#65306
      end
      object edtRemoteStop: TRzEdit
        Left = 92
        Top = 77
        Width = 154
        Height = 21
        TabOrder = 5
      end
      object edtArriveStation: TRzEdit
        Left = 630
        Top = 52
        Width = 121
        Height = 21
        TabOrder = 4
      end
      object checkDestOutDepotsTime: TCheckBox
        Left = 294
        Top = 27
        Width = 74
        Height = 17
        Caption = #30452#36890
        TabOrder = 1
        OnClick = checkLocalOutDepotsClick
      end
      object checkLocalInDepotsTime: TCheckBox
        Left = 568
        Top = 78
        Width = 74
        Height = 17
        Caption = #30452#36890
        TabOrder = 7
        OnClick = checkLocalOutDepotsClick
      end
      object dtpDestOutDepotsTime: TAdvDateTimePicker
        Left = 92
        Top = 25
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 0
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpStartTime2: TAdvDateTimePicker
        Left = 92
        Top = 52
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 2
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpArriveTime2: TAdvDateTimePicker
        Left = 359
        Top = 52
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 3
        OnExit = dtpStartTimeExit
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpLocalInDepotsTime: TAdvDateTimePicker
        Left = 359
        Top = 77
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 6
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
    end
    object RzGroupBox4: TRzGroupBox
      Left = 20
      Top = 20
      Width = 792
      Height = 83
      Align = alTop
      Caption = #35745#21010#20449#24687
      GroupStyle = gsTopLine
      TabOrder = 0
      object Label11: TLabel
        Left = 27
        Top = 28
        Width = 60
        Height = 13
        Caption = #34892#36710#21306#27573#65306
      end
      object Label17: TLabel
        Left = 294
        Top = 28
        Width = 36
        Height = 13
        Caption = #36710#27425#65306
      end
      object Label18: TLabel
        Left = 570
        Top = 28
        Width = 36
        Height = 13
        Caption = #26426#36710#65306
      end
      object Label19: TLabel
        Left = 33
        Top = 57
        Width = 42
        Height = 13
        Caption = #21496#26426'1'#65306
      end
      object Label20: TLabel
        Left = 294
        Top = 54
        Width = 42
        Height = 13
        Caption = #21496#26426'2'#65306
      end
      object Label21: TLabel
        Left = 570
        Top = 57
        Width = 60
        Height = 13
        Caption = #23454#20064#21496#26426#65306
      end
      object edtTrainJiaolu: TRzEdit
        Left = 91
        Top = 25
        Width = 155
        Height = 21
        Enabled = False
        TabOrder = 0
      end
      object edtTrainNo: TRzEdit
        Left = 359
        Top = 25
        Width = 154
        Height = 21
        Enabled = False
        TabOrder = 1
      end
      object edtTrainNumber: TRzEdit
        Left = 630
        Top = 25
        Width = 121
        Height = 21
        Enabled = False
        TabOrder = 2
      end
      object edtTrainman1: TRzEdit
        Left = 91
        Top = 51
        Width = 155
        Height = 21
        Enabled = False
        TabOrder = 3
      end
      object edtTrainman2: TRzEdit
        Left = 359
        Top = 54
        Width = 154
        Height = 21
        Enabled = False
        TabOrder = 4
      end
      object edtTrainman3: TRzEdit
        Left = 630
        Top = 54
        Width = 121
        Height = 21
        Enabled = False
        TabOrder = 5
      end
    end
    object RzGroupBox5: TRzGroupBox
      Left = 20
      Top = 371
      Width = 792
      Height = 79
      Align = alTop
      Caption = #21171#26102#32479#35745
      GroupStyle = gsTopLine
      TabOrder = 4
      object Label22: TLabel
        Left = 294
        Top = 34
        Width = 60
        Height = 13
        Caption = #23454#38469#36864#21220#65306
      end
      object Label23: TLabel
        Left = 30
        Top = 35
        Width = 60
        Height = 13
        Caption = #25351#32441#36864#21220#65306
      end
      object Label24: TLabel
        Left = 568
        Top = 34
        Width = 48
        Height = 13
        Caption = #24635#21171#26102#65306
      end
      object Label25: TLabel
        Left = 30
        Top = 61
        Width = 60
        Height = 13
        Caption = #20986#21220#36741#26102#65306
      end
      object Label26: TLabel
        Left = 294
        Top = 60
        Width = 36
        Height = 13
        Caption = #26053#26102#65306
      end
      object Label27: TLabel
        Left = 568
        Top = 60
        Width = 60
        Height = 13
        Caption = #36864#21220#36741#26102#65306
      end
      object edtTotal: TRzEdit
        Left = 630
        Top = 32
        Width = 121
        Height = 21
        TabOrder = 2
      end
      object edtChuQin: TRzEdit
        Left = 95
        Top = 58
        Width = 155
        Height = 21
        TabOrder = 3
      end
      object edtRun: TRzEdit
        Left = 359
        Top = 58
        Width = 154
        Height = 21
        TabOrder = 4
      end
      object edtTuiQin: TRzEdit
        Left = 630
        Top = 58
        Width = 121
        Height = 21
        TabOrder = 5
      end
      object dtpFingerTuiQin: TAdvDateTimePicker
        Left = 96
        Top = 33
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 0
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
      object dtpRealTuiQinTime: TAdvDateTimePicker
        Left = 359
        Top = 31
        Width = 154
        Height = 21
        Date = 41594.639965277780000000
        Format = 'yyyy-MM-dd'
        Time = 41594.639965277780000000
        Kind = dkDateTime
        TabOrder = 1
        BorderStyle = bsSingle
        Ctl3D = True
        DateTime = 41594.639965277780000000
        TimeFormat = ' HH:mm'
        Version = '1.1.0.0'
        LabelFont.Charset = DEFAULT_CHARSET
        LabelFont.Color = clWindowText
        LabelFont.Height = -11
        LabelFont.Name = 'Tahoma'
        LabelFont.Style = []
      end
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 483
    Width = 832
    Height = 41
    Align = alBottom
    BorderOuter = fsGroove
    BorderSides = [sdTop]
    TabOrder = 1
    object btnCancel: TButton
      Left = 696
      Top = 6
      Width = 75
      Height = 25
      Caption = #21462#28040
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnOk: TButton
      Left = 607
      Top = 6
      Width = 75
      Height = 25
      Caption = #30830#35748
      TabOrder = 0
      OnClick = btnOkClick
    end
  end
end
