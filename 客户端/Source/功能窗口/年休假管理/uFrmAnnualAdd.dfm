object FrmAnnualAdd: TFrmAnnualAdd
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #24180#20241#20551
  ClientHeight = 139
  ClientWidth = 228
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 11
    Top = 38
    Width = 28
    Height = 13
    Caption = #20154#21592':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 94
    Width = 212
    Height = 2
  end
  object Label1: TLabel
    Left = 11
    Top = 11
    Width = 28
    Height = 13
    Caption = #26376#20221':'
  end
  object Label2: TLabel
    Left = 11
    Top = 65
    Width = 52
    Height = 13
    Caption = #24212#20241#22825#25968':'
  end
  object edtKeyTrainman: TtfLookupEdit
    Left = 70
    Top = 35
    Width = 150
    Height = 21
    Columns = <>
    PopStyle.ShowColumn = True
    PopStyle.ShowFooter = True
    PopStyle.PageCount = 0
    PopStyle.PageIndex = 0
    PopStyle.BGColor = clWhite
    PopStyle.ColHeight = 20
    PopStyle.FooterHeight = 25
    PopStyle.RowHeight = 25
    PopStyle.PopBorderColor = clGray
    PopStyle.BorderWidth = 2
    PopStyle.CellMargins.Left = 2
    PopStyle.CellMargins.Top = 2
    PopStyle.CellMargins.Right = 2
    PopStyle.CellMargins.Bottom = 2
    PopStyle.SelectedBGColor = cl3DDkShadow
    PopStyle.NormalCellFont.Charset = DEFAULT_CHARSET
    PopStyle.NormalCellFont.Color = clBlack
    PopStyle.NormalCellFont.Height = -12
    PopStyle.NormalCellFont.Name = #23435#20307
    PopStyle.NormalCellFont.Style = []
    PopStyle.SelectedCellFont.Charset = DEFAULT_CHARSET
    PopStyle.SelectedCellFont.Color = clWhite
    PopStyle.SelectedCellFont.Height = -12
    PopStyle.SelectedCellFont.Name = #23435#20307
    PopStyle.SelectedCellFont.Style = []
    PopStyle.MaxViewCol = 10
    OnSelected = edtKeyTrainmanSelected
    OnPrevPage = edtKeyTrainmanPrevPage
    OnNextPage = edtKeyTrainmanNextPage
    IsAutoPopup = False
    HideSelection = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
    OnChange = edtKeyTrainmanChange
    OnExit = edtKeyTrainmanExit
  end
  object btnConfig: TButton
    Left = 62
    Top = 102
    Width = 75
    Height = 26
    Caption = #30830#23450
    TabOrder = 4
    OnClick = btnConfigClick
  end
  object btnCancel: TButton
    Left = 143
    Top = 102
    Width = 75
    Height = 26
    Caption = #21462#28040
    TabOrder = 5
    OnClick = btnCancelClick
  end
  object cbbMonth: TRzComboBox
    Left = 149
    Top = 8
    Width = 71
    Height = 21
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 1
  end
  object cbbYear: TRzComboBox
    Left = 70
    Top = 8
    Width = 73
    Height = 21
    Ctl3D = False
    FrameController = GlobalDM.FrameController
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 0
  end
  object edtNeedDays: TSpinEdit
    Left = 70
    Top = 62
    Width = 150
    Height = 22
    MaxValue = 100
    MinValue = 0
    TabOrder = 3
    Value = 5
  end
end
