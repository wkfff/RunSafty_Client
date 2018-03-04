object frmQueryDrinkPhoto: TfrmQueryDrinkPhoto
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #27979#37202#29031#29255
  ClientHeight = 300
  ClientWidth = 400
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Image1: TImage
    Left = 0
    Top = 0
    Width = 400
    Height = 300
    Align = alClient
    Stretch = True
    ExplicitWidth = 473
    ExplicitHeight = 273
  end
  object ActionList1: TActionList
    Left = 312
    Top = 104
    object actEsc: TAction
      Caption = 'actEsc'
      ShortCut = 27
      OnExecute = actEscExecute
    end
  end
end
