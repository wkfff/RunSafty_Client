object FrmTrainPlan: TFrmTrainPlan
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'FrmTrainPlan'
  ClientHeight = 430
  ClientWidth = 978
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object PlanGrid: TAdvStringGrid
    Left = 0
    Top = 0
    Width = 978
    Height = 430
    Cursor = crDefault
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clWhite
    ColCount = 29
    Constraints.MinHeight = 180
    Ctl3D = False
    RowCount = 2
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    OnKeyPress = PlanGridKeyPress
    OnMouseUp = PlanGridMouseUp
    ActiveRowColor = clWhite
    HoverRowColor = clWhite
    OnCustomCellBkgDraw = PlanGridCustomCellBkgDraw
    OnGetCellColor = PlanGridGetCellColor
    OnGetAlignment = PlanGridGetAlignment
    OnCanEditCell = PlanGridCanEditCell
    OnCellValidate = PlanGridCellValidate
    OnGetEditorType = PlanGridGetEditorType
    OnEditCellDone = PlanGridEditCellDone
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnHeaders.Strings = (
      #24207#21495
      #29366#24577
      #34892#36710#21306#27573
      #22806#21220#31471
      #36710#22411
      #36710#21495
      #36710#27425
      #25240#36820#36710#27425
      #22791#27880#31867#22411
      #20986#21220#28857
      #35745#21010#24320#36710#26102#38388
      #23454#38469#24320#36710#26102#38388
      #35745#21010#20986#21220#26102#38388
      #23454#38469#20986#21220#26102#38388
      #21496#26426
      #21103#21496#26426
      #23398#21592
      #23398#21592'2'
      #21457#36710#31449
      #32456#21040#31449
      #20540#20056#31867#22411
      #35745#21010#31867#22411
      #29301#24341#29366#24577
      #23458#36135
      #26159#21542#20505#29677
      #20505#29677#26102#38388
      #21483#29677#26102#38388
      #19979#21457#26102#38388
      #25509#25910#26102#38388)
    ColumnSize.Save = True
    ColumnSize.Key = 'FormColWidths.ini'
    ColumnSize.Section = 'TrainPlan'
    ColumnSize.Location = clIniFile
    ControlLook.FixedGradientHoverFrom = 15000287
    ControlLook.FixedGradientHoverTo = 14406605
    ControlLook.FixedGradientHoverMirrorFrom = 14406605
    ControlLook.FixedGradientHoverMirrorTo = 13813180
    ControlLook.FixedGradientHoverBorder = 12033927
    ControlLook.FixedGradientDownFrom = 14991773
    ControlLook.FixedGradientDownTo = 14991773
    ControlLook.FixedGradientDownMirrorFrom = 14991773
    ControlLook.FixedGradientDownMirrorTo = 14991773
    ControlLook.FixedGradientDownBorder = 14991773
    ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownHeader.Font.Color = clWindowText
    ControlLook.DropDownHeader.Font.Height = -11
    ControlLook.DropDownHeader.Font.Name = 'Tahoma'
    ControlLook.DropDownHeader.Font.Style = []
    ControlLook.DropDownHeader.Visible = True
    ControlLook.DropDownHeader.Buttons = <>
    ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
    ControlLook.DropDownFooter.Font.Color = clWindowText
    ControlLook.DropDownFooter.Font.Height = -11
    ControlLook.DropDownFooter.Font.Name = 'Tahoma'
    ControlLook.DropDownFooter.Font.Style = []
    ControlLook.DropDownFooter.Visible = True
    ControlLook.DropDownFooter.Buttons = <>
    EnableHTML = False
    EnhRowColMove = False
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDownClear = '(All)'
    FixedColWidth = 50
    FixedRowHeight = 25
    FixedRowAlways = True
    FixedFont.Charset = GB2312_CHARSET
    FixedFont.Color = 3355443
    FixedFont.Height = -16
    FixedFont.Name = #23435#20307
    FixedFont.Style = [fsBold]
    Flat = True
    FloatFormat = '%.2f'
    Look = glClassic
    Multilinecells = True
    PrintSettings.DateFormat = 'dd/mm/yyyy'
    PrintSettings.Font.Charset = DEFAULT_CHARSET
    PrintSettings.Font.Color = clWindowText
    PrintSettings.Font.Height = -11
    PrintSettings.Font.Name = 'Tahoma'
    PrintSettings.Font.Style = []
    PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
    PrintSettings.FixedFont.Color = clWindowText
    PrintSettings.FixedFont.Height = -11
    PrintSettings.FixedFont.Name = 'Tahoma'
    PrintSettings.FixedFont.Style = []
    PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
    PrintSettings.HeaderFont.Color = clWindowText
    PrintSettings.HeaderFont.Height = -11
    PrintSettings.HeaderFont.Name = 'Tahoma'
    PrintSettings.HeaderFont.Style = []
    PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
    PrintSettings.FooterFont.Color = clWindowText
    PrintSettings.FooterFont.Height = -11
    PrintSettings.FooterFont.Name = 'Tahoma'
    PrintSettings.FooterFont.Style = []
    PrintSettings.PageNumSep = '/'
    ScrollType = ssFlat
    ScrollWidth = 16
    SearchFooter.Color = clBtnFace
    SearchFooter.FindNextCaption = 'Find &next'
    SearchFooter.FindPrevCaption = 'Find &previous'
    SearchFooter.Font.Charset = DEFAULT_CHARSET
    SearchFooter.Font.Color = clWindowText
    SearchFooter.Font.Height = -11
    SearchFooter.Font.Name = 'Tahoma'
    SearchFooter.Font.Style = []
    SearchFooter.HighLightCaption = 'Highlight'
    SearchFooter.HintClose = 'Close'
    SearchFooter.HintFindNext = 'Find next occurence'
    SearchFooter.HintFindPrev = 'Find previous occurence'
    SearchFooter.HintHighlight = 'Highlight occurences'
    SearchFooter.MatchCaseCaption = 'Match case'
    SelectionColor = clHighlight
    SelectionTextColor = clHighlightText
    ShowModified.Color = clWhite
    ShowDesignHelper = False
    SortSettings.AutoSortForGrouping = False
    SortSettings.AutoFormat = False
    SortSettings.SortOnVirtualCells = False
    Version = '5.6.0.0'
    ColWidths = (
      50
      58
      129
      47
      48
      80
      79
      77
      91
      110
      110
      67
      47
      90
      66
      49
      108
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64
      64)
    RowHeights = (
      25
      27)
  end
  object pMenuColumn: TPopupMenu
    Left = 480
    Top = 160
    object miSelectColumn: TMenuItem
      Caption = #36873#25321#21015
      OnClick = miSelectColumnClick
    end
  end
  object PopupMenu: TPopupMenu
    AutoPopup = False
    Left = 440
    Top = 160
    object miClearTrainmanPlan: TMenuItem
      Caption = #22797#21046#35745#21010
      OnClick = miClearTrainmanPlanClick
    end
  end
end
