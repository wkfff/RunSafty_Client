object frmTrainNoUpdate: TfrmTrainNoUpdate
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #20462#25913#22270#23450#36710#27425
  ClientHeight = 311
  ClientWidth = 403
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
    Top = 90
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
    Top = 149
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
    Top = 148
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
    Left = 208
    Top = 62
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
    Top = 121
    Width = 80
    Height = 16
    Caption = #26426#36710#31867#22411#65306
  end
  object Label6: TLabel
    Left = 221
    Top = 120
    Width = 64
    Height = 16
    Caption = #26426#36710#21495#65306
  end
  object Label10: TLabel
    Left = 24
    Top = 62
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
  object Label7: TLabel
    Left = 21
    Top = 234
    Width = 80
    Height = 16
    Caption = #20986#21220#26102#38388#65306
  end
  object Label8: TLabel
    Left = 205
    Top = 233
    Width = 80
    Height = 16
    Caption = #24320#36710#26102#38388#65306
  end
  object Label11: TLabel
    Left = 21
    Top = 204
    Width = 80
    Height = 16
    Caption = #24378#20241#26102#38388#65306
  end
  object Label12: TLabel
    Left = 205
    Top = 203
    Width = 80
    Height = 16
    Caption = #21483#29677#26102#38388#65306
  end
  object edtTrainNo: TEdit
    Left = 110
    Top = 29
    Width = 255
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 0
  end
  object comboTrainJiaolu: TComboBox
    Left = 110
    Top = 87
    Width = 257
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 3
  end
  object btnConfirm: TButton
    Left = 213
    Top = 262
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 13
    OnClick = btnConfirmClick
  end
  object btnCancel: TButton
    Left = 294
    Top = 262
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 14
    OnClick = btnCancelClick
  end
  object comboTrainmanType: TComboBox
    Left = 287
    Top = 59
    Width = 81
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
    Top = 144
    Width = 80
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 6
  end
  object ComboEndStation: TComboBox
    Left = 288
    Top = 142
    Width = 80
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 7
  end
  object comboTrainType: TComboBox
    Left = 110
    Top = 116
    Width = 80
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 4
  end
  object edtTrainNumber: TEdit
    Left = 287
    Top = 116
    Width = 80
    Height = 24
    CharCase = ecUpperCase
    TabOrder = 5
  end
  object ComboKehuo: TRzComboBox
    Left = 110
    Top = 59
    Width = 80
    Height = 24
    Style = csDropDownList
    ItemHeight = 16
    TabOrder = 1
  end
  object dtpOutDutyTime: TDateTimePicker
    Left = 111
    Top = 229
    Width = 79
    Height = 24
    Date = 40975.000000000000000000
    Format = 'HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 11
  end
  object dtpStartTime: TDateTimePicker
    Left = 285
    Top = 228
    Width = 79
    Height = 24
    Date = 40975.000000000000000000
    Format = 'HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 12
  end
  object dtpArriveTime: TDateTimePicker
    Left = 111
    Top = 199
    Width = 79
    Height = 24
    Date = 40975.000000000000000000
    Format = 'HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 8
  end
  object dtpCallTime: TDateTimePicker
    Left = 285
    Top = 198
    Width = 79
    Height = 24
    Date = 40975.000000000000000000
    Format = 'HH:mm'
    Time = 40975.000000000000000000
    Kind = dtkTime
    TabOrder = 9
  end
  object checkNeedRest: TCheckBox
    Left = 110
    Top = 176
    Width = 58
    Height = 17
    Caption = #20505#29677
    TabOrder = 10
  end
end
