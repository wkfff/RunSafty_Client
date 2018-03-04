object frmTrainPlanUpdate: TfrmTrainPlanUpdate
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = #20462#25913#26426#36710#35745#21010
  ClientHeight = 390
  ClientWidth = 408
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 56
    Top = 32
    Width = 48
    Height = 16
    Caption = #36710#27425#65306
  end
  object Label2: TLabel
    Left = 24
    Top = 87
    Width = 80
    Height = 16
    Caption = #26426#36710#20132#36335#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel
    Left = 40
    Top = 174
    Width = 64
    Height = 16
    Caption = #20986#21457#31449#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label4: TLabel
    Left = 221
    Top = 169
    Width = 64
    Height = 16
    Caption = #32456#21040#31449#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label9: TLabel
    Left = 205
    Top = 59
    Width = 80
    Height = 16
    Caption = #20540#20056#31867#22411#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label5: TLabel
    Left = 24
    Top = 115
    Width = 80
    Height = 16
    Caption = #35745#21010#36710#22411#65306
  end
  object Label6: TLabel
    Left = 204
    Top = 115
    Width = 80
    Height = 16
    Caption = #35745#21010#36710#21495#65306
  end
  object Label10: TLabel
    Left = 24
    Top = 59
    Width = 80
    Height = 16
    Caption = #23458#36135#31867#22411#65306
    Font.Charset = GB2312_CHARSET
    Font.Color = clMaroon
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
  end
  object Label11: TLabel
    Left = 24
    Top = 145
    Width = 80
    Height = 16
    Caption = #23454#38469#36710#22411#65306
  end
  object Label12: TLabel
    Left = 204
    Top = 142
    Width = 80
    Height = 16
    Caption = #23454#38469#36710#21495#65306
  end
  object Label7: TLabel
    Left = 24
    Top = 202
    Width = 80
    Height = 16
    Caption = #20986#21220#26102#38388#65306
  end
  object Label8: TLabel
    Left = 24
    Top = 230
    Width = 80
    Height = 16
    Caption = #24320#36710#26102#38388#65306
  end
  object Label13: TLabel
    Left = 24
    Top = 291
    Width = 80
    Height = 16
    Caption = #24378#20241#26102#38388#65306
  end
  object Label14: TLabel
    Left = 24
    Top = 319
    Width = 80
    Height = 16
    Caption = #21483#29677#26102#38388#65306
  end
  object edtTrainNo: TEdit
    Left = 110
    Top = 29
    Width = 256
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object comboTrainJiaolu: TComboBox
    Left = 110
    Top = 84
    Width = 258
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 1
  end
  object comboTrainmanType: TComboBox
    Left = 278
    Top = 56
    Width = 90
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    ItemIndex = 0
    TabOrder = 2
    Text = #21452#21496#26426
    Items.Strings = (
      #21452#21496#26426
      #21333#21496#26426)
  end
  object ComboStartStation: TComboBox
    Left = 111
    Top = 165
    Width = 90
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 3
  end
  object ComboEndStation: TComboBox
    Left = 278
    Top = 166
    Width = 90
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 4
  end
  object comboTrainType: TComboBox
    Left = 110
    Top = 111
    Width = 90
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 5
  end
  object edtTrainNumber: TEdit
    Left = 278
    Top = 111
    Width = 90
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 6
  end
  object edtRealTrainNumber: TEdit
    Left = 278
    Top = 138
    Width = 90
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 7
  end
  object comboRealTrainType: TComboBox
    Left = 110
    Top = 138
    Width = 90
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 8
  end
  object dtpOutDutyTime: TDateTimePicker
    Left = 110
    Top = 196
    Width = 256
    Height = 24
    Date = 40975.000000000000000000
    Format = 'yyyy-MM-dd HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 9
  end
  object dtpStartTime: TDateTimePicker
    Left = 110
    Top = 226
    Width = 258
    Height = 24
    Date = 40975.000000000000000000
    Format = 'yyyy-MM-dd HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 10
  end
  object btnConfirm: TButton
    Left = 209
    Top = 352
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 11
    OnClick = btnConfirmClick
  end
  object btnCancel: TButton
    Left = 290
    Top = 352
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 12
    OnClick = btnCancelClick
  end
  object dtpArriveTime: TDateTimePicker
    Left = 110
    Top = 285
    Width = 256
    Height = 24
    Date = 40975.000000000000000000
    Format = 'yyyy-MM-dd HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 13
  end
  object dtpCallTime: TDateTimePicker
    Left = 110
    Top = 315
    Width = 258
    Height = 24
    Date = 40975.000000000000000000
    Format = 'yyyy-MM-dd HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 14
  end
  object checkNeedRest: TCheckBox
    Left = 110
    Top = 259
    Width = 58
    Height = 17
    Caption = #20505#29677
    TabOrder = 15
  end
  object ComboKehuo: TRzComboBox
    Left = 110
    Top = 56
    Width = 80
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 16
  end
end
