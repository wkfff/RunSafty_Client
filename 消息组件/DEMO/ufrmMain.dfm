object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = #28040#24687#32452#20214'DEMO'
  ClientHeight = 365
  ClientWidth = 693
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
  object Button1: TButton
    Left = 407
    Top = 56
    Width = 75
    Height = 25
    Caption = #28165#38500#28040#24687
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 407
    Top = 129
    Width = 75
    Height = 25
    Caption = #21516#27493#21457#36865
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 407
    Top = 8
    Width = 75
    Height = 25
    Caption = #21457#36865
    TabOrder = 2
    OnClick = Button3Click
  end
  object RzGroupBox1: TRzGroupBox
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 385
    Height = 359
    Align = alLeft
    Caption = #26085#24535
    TabOrder = 3
    object Memo1: TMemo
      Left = 1
      Top = 14
      Width = 383
      Height = 344
      Align = alClient
      Lines.Strings = (
        'Memo1')
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object Button4: TButton
    Left = 407
    Top = 171
    Width = 75
    Height = 25
    Caption = #21516#27493#25509#25910
    TabOrder = 4
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 407
    Top = 208
    Width = 75
    Height = 25
    Caption = #21516#27493#30830#35748
    TabOrder = 5
    OnClick = Button5Click
  end
end
