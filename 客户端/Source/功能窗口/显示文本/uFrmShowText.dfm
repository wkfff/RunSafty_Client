object frmShowText: TfrmShowText
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #26597#30475#20869#23481
  ClientHeight = 351
  ClientWidth = 661
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
    Left = 32
    Top = 24
    Width = 593
    Height = 273
    BorderStyle = bsNone
    Color = clInfoBk
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
    FrameVisible = True
  end
  object btnCancel: TButton
    Left = 550
    Top = 303
    Width = 75
    Height = 25
    Cancel = True
    Caption = #20851#38381
    TabOrder = 1
    OnClick = btnCancelClick
  end
end
