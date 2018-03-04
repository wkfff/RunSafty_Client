object FrmJiaoBanDebug: TFrmJiaoBanDebug
  Left = 0
  Top = 0
  Caption = #21483#29677#25509#21475
  ClientHeight = 458
  ClientWidth = 722
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 0
    Top = 0
    Width = 545
    Height = 458
    Align = alLeft
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Button1: TButton
    Left = 551
    Top = 8
    Width = 130
    Height = 25
    Caption = 'CancelNotify'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 551
    Top = 39
    Width = 130
    Height = 25
    Caption = 'AddNotify'
    TabOrder = 2
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 551
    Top = 70
    Width = 130
    Height = 25
    Caption = 'FindUnCancel'
    TabOrder = 3
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 551
    Top = 101
    Width = 130
    Height = 25
    Caption = 'GetByStateRange'
    TabOrder = 4
    OnClick = Button4Click
  end
end
