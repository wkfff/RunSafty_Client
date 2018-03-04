object FrmDebugBase: TFrmDebugBase
  Left = 0
  Top = 0
  Caption = 'FrmDebugBase'
  ClientHeight = 447
  ClientWidth = 749
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Memo1: TMemo
    Left = 391
    Top = 0
    Width = 358
    Height = 447
    Align = alClient
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 263
    Top = 0
    Width = 128
    Height = 447
    Align = alLeft
    TabOrder = 1
    object Button1: TButton
      Left = 24
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 0
      OnClick = Button1Click
    end
  end
  object TreeView1: TTreeView
    Left = 0
    Top = 0
    Width = 263
    Height = 447
    Align = alLeft
    Indent = 19
    TabOrder = 2
  end
end
