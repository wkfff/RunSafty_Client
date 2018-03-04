object FrmKeyTrainmanEdit: TFrmKeyTrainmanEdit
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20851#38190#20154#32534#36753
  ClientHeight = 298
  ClientWidth = 469
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 22
    Top = 16
    Width = 40
    Height = 13
    Caption = #20851#38190#20154':'
  end
  object lbl2: TLabel
    Left = 8
    Top = 180
    Width = 52
    Height = 13
    Caption = #30331#35760#21407#22240':'
  end
  object lbl3: TLabel
    Left = 8
    Top = 100
    Width = 52
    Height = 13
    Caption = #27880#24847#20107#39033':'
  end
  object lbl4: TLabel
    Left = 253
    Top = 16
    Width = 40
    Height = 13
    Caption = #30331#35760#20154':'
  end
  object lbl6: TLabel
    Left = 8
    Top = 70
    Width = 52
    Height = 13
    Caption = #36215#22987#26102#38388':'
  end
  object lbl7: TLabel
    Left = 240
    Top = 70
    Width = 52
    Height = 13
    Caption = #25130#27490#26102#38388':'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 252
    Width = 453
    Height = 2
  end
  object Label1: TLabel
    Left = 29
    Top = 43
    Width = 28
    Height = 13
    Caption = #36710#38431':'
  end
  object RzBorder1: TRzBorder
    Left = 69
    Top = 11
    Width = 158
    Height = 23
    BorderHighlight = clWhite
    BorderShadow = 13290186
    BorderOuter = fsFlat
    FlatColor = 7960953
    FlatColorAdjustment = 0
    FrameController = GlobalDM.FrameController
  end
  object RzBorder2: TRzBorder
    Left = 298
    Top = 11
    Width = 158
    Height = 23
    BorderHighlight = clWhite
    BorderShadow = 13290186
    BorderOuter = fsFlat
    FlatColor = 7960953
    FlatColorAdjustment = 0
    FrameController = GlobalDM.FrameController
  end
  object edtKeyTrainman: TtfLookupEdit
    Left = 70
    Top = 12
    Width = 156
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
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    HideSelection = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 0
    OnChange = edtKeyTrainmanChange
    OnExit = edtKeyTrainmanExit
  end
  object edtRegister: TtfLookupEdit
    Left = 301
    Top = 12
    Width = 153
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
    OnSelected = edtRegisterSelected
    OnPrevPage = edtRegisterPrevPage
    OnNextPage = edtRegisterNextPage
    IsAutoPopup = False
    BorderStyle = bsNone
    HideSelection = False
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 1
    OnChange = edtRegisterChange
    OnExit = edtRegisterExit
  end
  object btnConfig: TButton
    Left = 298
    Top = 260
    Width = 75
    Height = 26
    Caption = #30830#23450
    TabOrder = 7
    OnClick = btnConfigClick
  end
  object btnCancel: TButton
    Left = 379
    Top = 260
    Width = 75
    Height = 26
    Caption = #21462#28040
    TabOrder = 8
    OnClick = btnCancelClick
  end
  object dtpStart: TRzDateTimePicker
    Left = 69
    Top = 66
    Width = 158
    Height = 21
    Date = 42360.442520914350000000
    Time = 42360.442520914350000000
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
    FrameController = GlobalDM.FrameController
    FramingPreference = fpCustomFraming
  end
  object dtpEnd: TRzDateTimePicker
    Left = 298
    Top = 66
    Width = 158
    Height = 21
    Date = 42360.442520914350000000
    Time = 42360.442520914350000000
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 4
    FrameController = GlobalDM.FrameController
    FramingPreference = fpCustomFraming
  end
  object mmoReason: TMemo
    Left = 68
    Top = 176
    Width = 386
    Height = 70
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 6
  end
  object mmoAnnouncements: TMemo
    Left = 68
    Top = 95
    Width = 386
    Height = 70
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
  end
  object cbbCheDui: TRzComboBox
    Left = 69
    Top = 39
    Width = 158
    Height = 21
    Style = csDropDownList
    Color = clWhite
    Ctl3D = False
    FlatButtons = True
    FrameColor = 7960953
    FrameHotColor = clGradientActiveCaption
    FrameHotTrack = True
    FrameVisible = True
    FramingPreference = fpCustomFraming
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ItemHeight = 13
    ParentCtl3D = False
    TabOrder = 2
  end
end
