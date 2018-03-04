object FrameJDPlan: TFrameJDPlan
  Left = 0
  Top = 0
  Width = 451
  Height = 304
  Align = alClient
  BiDiMode = bdLeftToRight
  Color = clBtnFace
  Ctl3D = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  ParentBiDiMode = False
  ParentColor = False
  ParentCtl3D = False
  ParentFont = False
  ParentShowHint = False
  ShowHint = False
  TabOrder = 0
  TabStop = True
  OnResize = FrameResize
  object grdPlan: TAdvStringGrid
    Left = 0
    Top = 0
    Width = 451
    Height = 304
    Cursor = crDefault
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    Color = clWhite
    Constraints.MinHeight = 180
    Ctl3D = False
    RowCount = 2
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    ActiveRowColor = clWhite
    HoverRowColor = clWhite
    OnGetCellColor = grdPlanGetCellColor
    OnClickCell = grdPlanClickCell
    OnDblClickCell = grdPlanDblClickCell
    OnCanEditCell = grdPlanCanEditCell
    OnSelectionChanged = grdPlanSelectionChanged
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnHeaders.Strings = (
      #29366#24577
      #20986#21457#26102#38388
      #36710#27425
      #22987#21457#31449
      #32456#21040#31449)
    ColumnSize.Save = True
    ColumnSize.Key = 'FormColWidths.ini'
    ColumnSize.Section = 'JDPlan'
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
    FixedColWidth = 60
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
      60
      227
      129
      139
      156)
    RowHeights = (
      25
      27)
  end
  object ImageList: TImageList
    Height = 32
    Width = 1
    Left = 240
    Top = 24
  end
end
