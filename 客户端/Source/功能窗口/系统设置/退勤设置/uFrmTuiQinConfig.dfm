object FrmTuiQinConfig: TFrmTuiQinConfig
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
      object Label14: TLabel
        Left = 24
        Top = 27
        Width = 84
        Height = 13
        Caption = #36229#21171#25552#37266#26102#38271#65306
      end
      object Label1: TLabel
        Left = 190
        Top = 27
        Width = 24
        Height = 13
        Caption = #23567#26102
      end
      object edtOutWorkHours: TRzNumericEdit
        Left = 111
        Top = 24
        Width = 73
        Height = 21
        Alignment = taLeftJustify
        TabOrder = 0
        Max = 2400.000000000000000000
        Value = 17.000000000000000000
        DisplayFormat = '0'
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
