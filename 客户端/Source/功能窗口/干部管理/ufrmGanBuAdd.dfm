object FrmGanbuAdd: TFrmGanbuAdd
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #28155#21152#24178#37096
  ClientHeight = 123
  ClientWidth = 244
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
  DesignSize = (
    244
    123)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 27
    Width = 28
    Height = 13
    Caption = #32844#21153':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 83
    Width = 228
    Height = 2
    Anchors = [akLeft, akTop, akRight]
    ExplicitWidth = 197
  end
  object Label2: TLabel
    Left = 8
    Top = 54
    Width = 28
    Height = 13
    Caption = #24037#21495':'
  end
  object edtNumber: TRzEdit
    Left = 42
    Top = 51
    Width = 191
    Height = 21
    FrameController = GlobalDM.FrameController
    TabOrder = 0
    OnKeyPress = edtNumberKeyPress
  end
  object btnOk: TButton
    Left = 72
    Top = 91
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 1
    OnClick = btnOkClick
  end
  object Button2: TButton
    Left = 156
    Top = 91
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 2
    OnClick = Button2Click
  end
  object cbbZhiWu: TRzComboBox
    Left = 42
    Top = 24
    Width = 189
    Height = 21
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 3
  end
end
