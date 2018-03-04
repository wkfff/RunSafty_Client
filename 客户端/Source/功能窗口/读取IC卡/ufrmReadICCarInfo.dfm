object frmReadICCarInfo: TfrmReadICCarInfo
  Left = 0
  Top = 0
  BorderStyle = bsNone
  ClientHeight = 74
  ClientWidth = 425
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 425
    Height = 74
    Align = alClient
    BorderOuter = fsFlat
    TabOrder = 0
    object Label1: TLabel
      Left = 56
      Top = 24
      Width = 101
      Height = 20
      Caption = #27491#22312#35835#21462'IC'#21345'...'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
    end
    object RzAnimator1: TRzAnimator
      Left = 24
      Top = 22
      Width = 24
      Height = 24
      ImageIndex = 4
    end
  end
  object Timer: TTimer
    OnTimer = TimerTimer
    Left = 296
    Top = 16
  end
end
