object frmEditPlanTime: TfrmEditPlanTime
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20462#25913#35745#21010#26102#38388
  ClientHeight = 299
  ClientWidth = 373
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 15
    Width = 28
    Height = 13
    Caption = #36710#27425':'
  end
  object Label2: TLabel
    Left = 24
    Top = 34
    Width = 28
    Height = 13
    Caption = #20132#36335':'
  end
  object Label3: TLabel
    Left = 24
    Top = 53
    Width = 52
    Height = 13
    Caption = #35745#21010#26102#38388':'
  end
  object Label4: TLabel
    Left = 24
    Top = 72
    Width = 34
    Height = 13
    Caption = #21496#26426'1:'
  end
  object Label5: TLabel
    Left = 24
    Top = 91
    Width = 34
    Height = 13
    Caption = #21496#26426'2:'
  end
  object Label6: TLabel
    Left = 24
    Top = 110
    Width = 28
    Height = 13
    Caption = #23398#21592':'
  end
  object lblTrainNo: TLabel
    Left = 82
    Top = 15
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblPlanTime: TLabel
    Left = 82
    Top = 53
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblPlanJiaoLu: TLabel
    Left = 82
    Top = 34
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblTrainman1: TLabel
    Left = 82
    Top = 72
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblTrainman2: TLabel
    Left = 82
    Top = 91
    Width = 4
    Height = 13
    Caption = '-'
  end
  object lblTrainman3: TLabel
    Left = 82
    Top = 110
    Width = 4
    Height = 13
    Caption = '-'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 129
    Width = 355
    Height = 2
  end
  object Label7: TLabel
    Left = 24
    Top = 142
    Width = 112
    Height = 13
    Caption = #35831#35774#32622#26032#30340#35745#21010#26102#38388':'
  end
  object Bevel2: TBevel
    Left = 8
    Top = 258
    Width = 355
    Height = 2
  end
  object Label8: TLabel
    Left = 27
    Top = 165
    Width = 24
    Height = 13
    Caption = #22791#27880
  end
  object dtDatePicker: TRzDateTimePicker
    Left = 142
    Top = 137
    Width = 97
    Height = 21
    Date = 41601.405125497690000000
    Format = 'yyyy-MM-dd'
    Time = 41601.405125497690000000
    TabOrder = 0
  end
  object dtTimePicker: TRzDateTimePicker
    Left = 245
    Top = 137
    Width = 97
    Height = 21
    Date = 41601.405125497690000000
    Time = 41601.405125497690000000
    Kind = dtkTime
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 186
    Top = 266
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 267
    Top = 266
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 4
    OnClick = btnCancelClick
  end
  object memRemark: TRzMemo
    Left = 24
    Top = 184
    Width = 318
    Height = 68
    TabOrder = 2
  end
end
