object FrmMain: TFrmMain
  Left = 0
  Top = 0
  Caption = #25509#21475#27979#35797
  ClientHeight = 448
  ClientWidth = 770
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl1: TPageControl
    Left = 462
    Top = 8
    Width = 305
    Height = 432
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #22522#30784#23383#20856#25509#21475
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 746
      ExplicitHeight = 0
      object GroupBox1: TGroupBox
        Left = 3
        Top = 108
        Width = 286
        Height = 105
        Caption = #20154#21592#20132#36335
        TabOrder = 0
        object SpeedButton2: TSpeedButton
          Left = 11
          Top = 16
          Width = 158
          Height = 33
          Caption = 'GetTrainmanJiaolusOfTrainJiaolu'
        end
      end
      object GroupBox2: TGroupBox
        Left = 3
        Top = 3
        Width = 286
        Height = 105
        Caption = #26426#36710#20132#36335
        TabOrder = 1
        object SpeedButton1: TSpeedButton
          Left = 11
          Top = 16
          Width = 158
          Height = 33
          Caption = 'GetTrainJiaoluArrayOfSite'
        end
      end
      object GroupBox3: TGroupBox
        Left = 3
        Top = 219
        Width = 286
        Height = 105
        Caption = #36710#31449
        TabOrder = 2
        object SpeedButton3: TSpeedButton
          Left = 11
          Top = 16
          Width = 158
          Height = 33
          Caption = 'Cls_GetByJiaoLu'
          OnClick = SpeedButton3Click
        end
      end
    end
  end
  object Memo1: TMemo
    Left = 8
    Top = 8
    Width = 448
    Height = 432
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object XPManifest1: TXPManifest
    Left = 376
    Top = 232
  end
end
