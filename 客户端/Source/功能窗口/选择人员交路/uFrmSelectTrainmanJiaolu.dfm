object frmSelectTrainmanJiaolu: TfrmSelectTrainmanJiaolu
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #35831#36873#25321#30446#26631#20154#21592#20132#36335
  ClientHeight = 204
  ClientWidth = 366
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 16
  object Label2: TLabel
    Left = 48
    Top = 73
    Width = 80
    Height = 16
    Caption = #20154#21592#20132#36335#65306
  end
  object btnOK: TButton
    Left = 131
    Top = 120
    Width = 77
    Height = 28
    Caption = #30830#23450
    Default = True
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 227
    Top = 120
    Width = 77
    Height = 28
    Cancel = True
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object comboTrainmanJiaolu: TRzComboBox
    Left = 134
    Top = 70
    Width = 171
    Height = 24
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 2
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 200
    Top = 8
  end
end
