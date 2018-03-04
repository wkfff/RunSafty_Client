object frmSelectSite: TfrmSelectSite
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36873#25321#27966#29677#23460
  ClientHeight = 158
  ClientWidth = 347
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label1: TLabel
    Left = 48
    Top = 51
    Width = 64
    Height = 16
    Caption = #27966#29677#23460#65306
  end
  object btnConfirm: TButton
    Left = 125
    Top = 90
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = btnConfirmClick
  end
  object btnCancel: TButton
    Left = 206
    Top = 90
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object comboSite: TRzComboBox
    Left = 118
    Top = 48
    Width = 156
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
  end
end
