object frmRemind: TfrmRemind
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsNone
  Caption = #25552#31034#20449#24687
  ClientHeight = 402
  ClientWidth = 900
  Color = 9987141
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 16
  object lblMsg1: TLabel
    Left = 22
    Top = 36
    Width = 128
    Height = 16
    Caption = #36825#26159#25552#31034#20449#24687'1'#65281
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    Transparent = False
  end
  object lblClose: TLabel
    Left = 851
    Top = 8
    Width = 28
    Height = 14
    Caption = #20851#38381
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = []
    ParentFont = False
    OnClick = lblCloseClick
    OnMouseEnter = lblCloseMouseEnter
    OnMouseLeave = lblCloseMouseLeave
  end
end
