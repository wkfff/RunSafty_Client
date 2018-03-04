object frmSingleInputBox: TfrmSingleInputBox
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36755#20837#23545#35805#26694
  ClientHeight = 212
  ClientWidth = 454
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
  object lblHint: TLabel
    Left = 56
    Top = 40
    Width = 60
    Height = 13
    Caption = #36755#20837#20869#23481#65306
  end
  object edtText: TEdit
    Left = 56
    Top = 80
    Width = 337
    Height = 21
    TabOrder = 0
  end
  object btnOK: TButton
    Left = 232
    Top = 136
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 318
    Top = 136
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
