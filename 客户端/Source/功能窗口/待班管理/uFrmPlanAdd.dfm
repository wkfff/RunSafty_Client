object frmPlanAdd: TfrmPlanAdd
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #28155#21152#35745#21010
  ClientHeight = 275
  ClientWidth = 414
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
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
    Top = 67
    Width = 80
    Height = 16
    Caption = #24378#20241#26102#38388#65306
  end
  object Label2: TLabel
    Left = 31
    Top = 101
    Width = 80
    Height = 16
    Caption = #21483#29677#26102#38388#65306
  end
  object Label7: TLabel
    Left = 31
    Top = 136
    Width = 80
    Height = 16
    Caption = #20986#21220#26102#38388#65306
  end
  object Label1: TLabel
    Left = 31
    Top = 171
    Width = 80
    Height = 16
    Caption = #24320#36710#26102#38388#65306
  end
  object edtTrainNo: TEdit
    Left = 124
    Top = 25
    Width = 79
    Height = 22
    Ctl3D = False
    ParentCtl3D = False
    TabOrder = 0
  end
  object radioDouble: TRadioButton
    Left = 293
    Top = 28
    Width = 73
    Height = 17
    Caption = #21452#21496#26426
    Checked = True
    TabOrder = 1
    TabStop = True
  end
  object radioSingle: TRadioButton
    Left = 209
    Top = 28
    Width = 75
    Height = 17
    Caption = #21333#21496#26426
    TabOrder = 2
  end
  object btnOK: TButton
    Left = 194
    Top = 210
    Width = 83
    Height = 30
    Caption = #30830#23450
    Default = True
    TabOrder = 3
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 287
    Top = 210
    Width = 83
    Height = 30
    Cancel = True
    Caption = #21462#28040
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object edtSigninTime: TAdvDateTimePicker
    Left = 124
    Top = 65
    Width = 242
    Height = 24
    Date = 41141.651064814820000000
    Format = 'yyyy-MM-dd'
    Time = 41141.651064814820000000
    Kind = dkDateTime
    TabOrder = 5
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41141.651064814820000000
    TimeFormat = ' HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object edtCallTime: TAdvDateTimePicker
    Left = 124
    Top = 98
    Width = 242
    Height = 24
    Date = 41141.651064814820000000
    Format = 'yyyy-MM-dd'
    Time = 41141.651064814820000000
    Kind = dkDateTime
    TabOrder = 6
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41141.651064814820000000
    TimeFormat = ' HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object edtOutDutyTime: TAdvDateTimePicker
    Left = 124
    Top = 133
    Width = 242
    Height = 24
    Date = 41141.651064814820000000
    Format = 'yyyy-MM-dd'
    Time = 41141.651064814820000000
    Kind = dkDateTime
    TabOrder = 7
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41141.651064814820000000
    TimeFormat = ' HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
  object edtStartTime: TAdvDateTimePicker
    Left = 124
    Top = 167
    Width = 242
    Height = 24
    Date = 41141.651064814820000000
    Format = 'yyyy-MM-dd'
    Time = 41141.651064814820000000
    Kind = dkDateTime
    TabOrder = 8
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41141.651064814820000000
    TimeFormat = ' HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
end
