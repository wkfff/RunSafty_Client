object frmRoomSignEdit: TfrmRoomSignEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20837#23507#26102#38388
  ClientHeight = 188
  ClientWidth = 369
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
    Left = 20
    Top = 18
    Width = 40
    Height = 13
    Caption = #20056#21153#21592':'
  end
  object lblTrainman: TLabel
    Left = 78
    Top = 18
    Width = 4
    Height = 13
    Caption = '-'
  end
  object Label3: TLabel
    Left = 20
    Top = 39
    Width = 52
    Height = 13
    Caption = #20837#23507#26102#38388':'
  end
  object Label2: TLabel
    Left = 20
    Top = 58
    Width = 28
    Height = 13
    Caption = #22791#27880':'
  end
  object dtDatePicker: TRzDateTimePicker
    Left = 78
    Top = 34
    Width = 131
    Height = 21
    Date = 41601.490698599540000000
    Format = 'yyyy-MM-dd'
    Time = 41601.490698599540000000
    TabOrder = 0
  end
  object dtTimePicker: TRzDateTimePicker
    Left = 215
    Top = 34
    Width = 130
    Height = 21
    Date = 41601.490698599540000000
    Time = 41601.490698599540000000
    Kind = dtkTime
    TabOrder = 1
  end
  object Button1: TButton
    Left = 189
    Top = 156
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 3
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 270
    Top = 156
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 4
    OnClick = Button2Click
  end
  object memRemark: TRzMemo
    Left = 77
    Top = 61
    Width = 268
    Height = 89
    TabOrder = 2
  end
end
