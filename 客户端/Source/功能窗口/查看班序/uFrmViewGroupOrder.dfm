object frmViewGroupOrder: TfrmViewGroupOrder
  Left = 0
  Top = 0
  Caption = #29677#24207#26597#30475
  ClientHeight = 420
  ClientWidth = 1013
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 12
  object RzPanel3: TRzPanel
    Left = 0
    Top = 0
    Width = 1013
    Height = 45
    Align = alTop
    BorderOuter = fsGroove
    BorderSides = [sdBottom]
    Font.Charset = GB2312_CHARSET
    Font.Color = clRed
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
    TabOrder = 0
    DesignSize = (
      1013
      45)
    object btnExport: TPngSpeedButton
      Left = 923
      Top = 9
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #23548#20986
      Flat = True
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -12
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      OnClick = btnExportClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        61000002274944415478DAA5D35F6852511C07F0EF55EFBD6AF9A75ACBD48583
        B5062AEAC3FEF85023A33F444450542F81568BF6D41F8A1511F41263107BE8A1
        2008A2511121F4D28BA3D2B56504639B6344B15208953972DCDC5476FF9CAEB7
        C40535927EF0E30787F3FD700E8743E13F8BEA0E0E9D92676F9DB9BBB10727EE
        2BC0AE9E27C47FD85F573A1E8EC36AE26C43B7CE66A8C0E9C7C4B7DB53173031
        3C059BF9FB4F20D47787F0A4113ABD6ED590402F60C11686397310CC128F75FA
        45F3C0B58B1CD57773901CDFBF135EAFF7AFE15C318B9E977BD1D422209BA461
        C83A61996BFF77607C6E0CB7672EA3D99307052DDEC5CA58C36D690B9F1CFEB8
        2A309A8EE045EA11D28B297C2BCFC3D755064D6B0189C54894130981F58F8048
        445C7D13446A69128C310FDD5A110613E4300D8666E4D682C8C868AC50F80D20
        3259168A381F3D86F9D22CEC0D5A3836B442A3A6A166257C91A2BF1016767507
        9EBD7ECF2BC0D17DDDF0783C0A706F7A0091CF4FD169ED44463EF687FC0C0C8C
        51864B6871E6C1EA54B068DC88C493BC2009760538B2673BDC6EB7025C791B92
        EF20E26B2989D0B64BE8DA18004554E84F9C434EFF0A5B1B9B313E5504C5197D
        CF8323930A7028E087CBE5822449E89FB80046C5A2B7ED3AD4D0286865FD46E2
        0C1C9BD6633A330B3ADD044BAEA3F68C0776B4C3E9742A1B2B5D0DAD9CDC721E
        0F5383686036A310B76199E76B40ABC50487C3A16C5C19AA74A5AAB35A63894F
        1044A906D4F913ABA5003F001CD11B7AAC886D540000000049454E44AE426082}
      ExplicitLeft = 634
    end
    object Label1: TLabel
      Left = 16
      Top = 16
      Width = 163
      Height = 12
      Caption = #25552#31034':'#36873#25321#20154#21592#20132#36335#26597#30475#29677#24207
    end
  end
  object strGridLeaveInfo: TAdvStringGrid
    Left = 185
    Top = 45
    Width = 828
    Height = 375
    Cursor = crDefault
    Align = alClient
    BevelOuter = bvNone
    BorderStyle = bsNone
    ColCount = 6
    Ctl3D = False
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goTabs, goRowSelect]
    ParentCtl3D = False
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 1
    ActiveCellFont.Charset = DEFAULT_CHARSET
    ActiveCellFont.Color = clWindowText
    ActiveCellFont.Height = -11
    ActiveCellFont.Name = 'Tahoma'
    ActiveCellFont.Style = [fsBold]
    ColumnHeaders.Strings = (
      #24207#21495
      #21496#26426'A'
      #21496#26426'B'
      #21496#26426'C'
      #36864#21220#26102#38388
      #29366#24577)
    ControlLook.FixedGradientHoverFrom = clGray
    ControlLook.FixedGradientHoverTo = clWhite
    ControlLook.FixedGradientDownFrom = clGray
    ControlLook.FixedGradientDownTo = clSilver
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
    Filter = <>
    FilterDropDown.Font.Charset = DEFAULT_CHARSET
    FilterDropDown.Font.Color = clWindowText
    FilterDropDown.Font.Height = -11
    FilterDropDown.Font.Name = 'Tahoma'
    FilterDropDown.Font.Style = []
    FilterDropDownClear = '(All)'
    FixedColWidth = 45
    FixedRowHeight = 24
    FixedFont.Charset = GB2312_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -14
    FixedFont.Name = #23435#20307
    FixedFont.Style = [fsBold]
    Flat = True
    FloatFormat = '%.2f'
    Look = glSoft
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
    ShowDesignHelper = False
    Version = '5.6.0.0'
    ColWidths = (
      45
      150
      150
      150
      150
      64)
    RowHeights = (
      24
      22
      22
      22
      22
      22
      22
      22
      22
      22)
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 45
    Width = 185
    Height = 375
    Align = alLeft
    BorderOuter = fsGroove
    BorderSides = [sdRight]
    TabOrder = 2
    object rgTrainmanJiaolu: TRzRadioGroup
      Left = 0
      Top = 0
      Width = 183
      Height = 375
      Align = alClient
      BorderSides = []
      Color = clWhite
      Ctl3D = True
      GroupStyle = gsUnderline
      ParentCtl3D = False
      TabOrder = 0
      OnClick = rgTrainmanJiaoluClick
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.xls'
    FileName = '*.xls'
    Filter = '*.xls'
    Left = 488
    Top = 8
  end
end
