object FrmGeXingChuQin: TFrmGeXingChuQin
  Left = 0
  Top = 0
  Caption = 'FrmGeXingChuQin'
  ClientHeight = 392
  ClientWidth = 653
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 653
    Height = 41
    Align = alTop
    BorderOuter = fsFlat
    TabOrder = 0
    DesignSize = (
      653
      41)
    object btnPrint: TButton
      Left = 456
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #25171#21360
      TabOrder = 0
      OnClick = btnPrintClick
    end
    object btnExit: TButton
      Left = 552
      Top = 8
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #36864#20986
      TabOrder = 1
      OnClick = btnExitClick
    end
  end
  object rzpnl2: TRzPanel
    Left = 0
    Top = 41
    Width = 653
    Height = 351
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 1
  end
  object dlgPnt1: TPrintDialog
    Left = 368
    Top = 8
  end
  object dlgPntSet1: TPrinterSetupDialog
    Left = 400
    Top = 8
  end
  object tmr1: TTimer
    Interval = 500
    Left = 216
    Top = 24
  end
end
