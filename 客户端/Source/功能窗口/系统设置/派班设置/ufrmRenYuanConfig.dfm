object frmRenYuanConfig: TfrmRenYuanConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #31995#32479#35774#32622
  ClientHeight = 252
  ClientWidth = 430
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzPageControl1: TRzPageControl
    Left = 8
    Top = 8
    Width = 417
    Height = 209
    ActivePage = TabSheet1
    HotTrackColor = clBtnFace
    ShowFocusRect = False
    TabColors.HighlightBar = clBtnFace
    TabColors.Unselected = clBtnFace
    TabIndex = 0
    TabOrder = 0
    TabStyle = tsRoundCorners
    FixedDimension = 19
    object TabSheet1: TRzTabSheet
      Caption = #22522#26412#35774#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object chkSleepCheck: TCheckBox
        Left = 24
        Top = 16
        Width = 121
        Height = 17
        Caption = #21551#29992#20837#23507#31614#28857#21345#25511
        TabOrder = 0
      end
    end
  end
  object btnOk: TButton
    Left = 266
    Top = 220
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object btnCancel: TButton
    Left = 347
    Top = 220
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
  end
end
