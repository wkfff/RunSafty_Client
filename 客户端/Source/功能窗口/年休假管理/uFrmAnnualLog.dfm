object FrmAnnualLog: TFrmAnnualLog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #35831#36755#20837#21024#38500#21407#22240
  ClientHeight = 243
  ClientWidth = 476
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
  object Bevel1: TBevel
    Left = 8
    Top = 199
    Width = 460
    Height = 2
  end
  object memLog: TRzMemo
    Left = 8
    Top = 8
    Width = 460
    Height = 185
    TabOrder = 0
    FrameController = GlobalDM.FrameController
  end
  object Button1: TButton
    Left = 312
    Top = 207
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 393
    Top = 207
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
end
