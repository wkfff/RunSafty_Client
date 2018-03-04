object FrmWorkFlowCheck: TFrmWorkFlowCheck
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #27969#31243#21345#25511
  ClientHeight = 464
  ClientWidth = 728
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 427
    Width = 712
    Height = 2
  end
  object Label1: TLabel
    Left = 8
    Top = 435
    Width = 242
    Height = 19
    Caption = #35831#32852#31995#20540#29677#20027#20219#36827#34892#30830#35748'!'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #26999#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object lstBoxFlows: TRzListBox
    Left = 8
    Top = 8
    Width = 457
    Height = 413
    FrameVisible = True
    ItemHeight = 60
    Items.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5')
    Style = lbOwnerDrawFixed
    TabOrder = 0
    OnClick = lstBoxFlowsClick
    OnDrawItem = lstBoxFlowsDrawItem
  end
  object btnSign: TButton
    Left = 617
    Top = 433
    Width = 103
    Height = 25
    Caption = #20540#29677#20027#20219#30830#35748
    TabOrder = 1
    OnClick = btnSignClick
  end
  object RzMemo1: TRzMemo
    Left = 471
    Top = 8
    Width = 249
    Height = 413
    Color = clInfoBk
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    ReadOnly = True
    TabOrder = 2
    FrameVisible = True
  end
end
