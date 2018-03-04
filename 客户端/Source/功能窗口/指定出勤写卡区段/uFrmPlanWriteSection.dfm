object frmPlanWriteSection: TfrmPlanWriteSection
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #35831#25351#23450#20986#21220#20889#21345#21306#27573
  ClientHeight = 328
  ClientWidth = 444
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
  PixelsPerInch = 96
  TextHeight = 13
  object checklstWriteSection: TCheckListBox
    Left = 36
    Top = 24
    Width = 369
    Height = 249
    ItemHeight = 13
    TabOrder = 0
  end
  object Button1: TButton
    Left = 249
    Top = 279
    Width = 75
    Height = 25
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = Button1Click
  end
  object btnCancel: TButton
    Left = 330
    Top = 279
    Width = 75
    Height = 25
    Cancel = True
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
