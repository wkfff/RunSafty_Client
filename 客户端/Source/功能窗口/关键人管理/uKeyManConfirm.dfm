object FrmKeyManConfirm: TFrmKeyManConfirm
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20851#38190#20154#25552#37266
  ClientHeight = 416
  ClientWidth = 703
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
  object RzMemo1: TRzMemo
    AlignWithMargins = True
    Left = 3
    Top = 63
    Width = 697
    Height = 307
    Margins.Top = 1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = [fsBold]
    Lines.Strings = (
      #27880#24847#20107#39033#65306)
    ParentFont = False
    ReadOnly = True
    TabOrder = 0
    FrameController = GlobalDM.FrameController
  end
  object RzPanel1: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 697
    Height = 58
    Margins.Bottom = 1
    Align = alTop
    BorderOuter = fsFlat
    BorderHighlight = clWhite
    BorderShadow = 13290186
    Color = clWhite
    FlatColor = 7960953
    FlatColorAdjustment = 0
    FrameController = GlobalDM.FrameController
    TabOrder = 1
    object Label1: TLabel
      Left = 16
      Top = 15
      Width = 228
      Height = 23
      Caption = '[2301201]'#23002#26032' '#20026#37325#28857#20154
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object RzPanel2: TRzPanel
    AlignWithMargins = True
    Left = 3
    Top = 376
    Width = 697
    Height = 37
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 2
    object Button1: TButton
      Left = 623
      Top = 0
      Width = 75
      Height = 25
      Caption = #20851#38381
      TabOrder = 0
      OnClick = Button1Click
    end
  end
end
