object FrmLeaderResult: TFrmLeaderResult
  Left = 0
  Top = 0
  Caption = #20056#21153#21592#24453#20056#30331#35760#31807
  ClientHeight = 606
  ClientWidth = 1012
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object rzpnl2: TRzPanel
    Left = 0
    Top = 544
    Width = 1012
    Height = 62
    Align = alBottom
    BorderOuter = fsNone
    TabOrder = 0
    object lb6: TLabel
      Left = 6
      Top = 18
      Width = 247
      Height = 58
      Caption = #20849#35745#19981#33021#20986#23507#20154#21592':'#13#10
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -29
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lbCount: TLabel
      Left = 284
      Top = 18
      Width = 59
      Height = 29
      Caption = '0 '#20010
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -29
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
  end
  object strGridRoomSign: TAdvStringGrid
    Left = 0
    Top = 49
    Width = 1012
    Height = 495
    Cursor = crDefault
    Align = alClient
    ColCount = 9
    DefaultRowHeight = 30
    RowCount = 2
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = #23435#20307
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowSelect]
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
      #20056#21153#21592
      #25151#38388#21495
      #20837#23507#26102#38388
      #20837#23507#26041#24335
      #24050#20241#24687#26102#38388
      #31163#23507#26102#38388
      #31163#23507#26041#24335
      #20540#29677#21592)
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
    FixedRowHeight = 30
    FixedFont.Charset = ANSI_CHARSET
    FixedFont.Color = clWindowText
    FixedFont.Height = -16
    FixedFont.Name = #23435#20307
    FixedFont.Style = [fsBold]
    FloatFormat = '%.2f'
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
    ShowDesignHelper = False
    Version = '5.6.0.0'
    ColWidths = (
      64
      140
      106
      204
      99
      100
      110
      123
      64)
  end
  object rzpnl3: TRzPanel
    Left = 0
    Top = 0
    Width = 1012
    Height = 49
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 2
    object lb1: TLabel
      Left = 8
      Top = 13
      Width = 91
      Height = 19
      Caption = #24320#22987#26102#38388':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lb2: TLabel
      Left = 356
      Top = 13
      Width = 91
      Height = 19
      Caption = #32467#26463#26102#38388':'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbStartDate: TLabel
      Left = 112
      Top = 13
      Width = 209
      Height = 19
      Caption = '2014-12-31 12:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lbEndDate: TLabel
      Left = 469
      Top = 13
      Width = 209
      Height = 19
      Caption = '2014-12-31 12:00:00'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnPrint: TButton
      Left = 723
      Top = 7
      Width = 49
      Height = 32
      Caption = #25171#21360
      TabOrder = 0
      OnClick = btnPrintClick
    end
  end
  object mm1: TMainMenu
    Left = 528
    Top = 232
    object mniN1: TMenuItem
      Caption = #31995#32479'(&S)'
      object mniE1: TMenuItem
        Caption = #36864#20986'(&E)'
        OnClick = mniE1Click
      end
    end
    object mniV1: TMenuItem
      Caption = #26597#35810#32479#35745'(&V)'
      object mniF1: TMenuItem
        Action = actFind
        Caption = #21047#26032'(&F)'
      end
      object mniPrint: TMenuItem
        Action = actPrint
      end
    end
  end
  object actlst1: TActionList
    Left = 816
    Top = 120
    object actFind: TAction
      Caption = 'actFind'
      OnExecute = actFindExecute
    end
    object actPrint: TAction
      Caption = #25171#21360'(&P)'
      OnExecute = actPrintExecute
    end
  end
  object frxReport1: TfrxReport
    Version = '4.3'
    DotMatrixReport = False
    IniFile = '\Software\Fast Reports'
    PreviewOptions.Buttons = [pbPrint, pbLoad, pbSave, pbExport, pbZoom, pbFind, pbOutline, pbPageSetup, pbTools, pbEdit, pbNavigator, pbExportQuick]
    PreviewOptions.Zoom = 1.000000000000000000
    PrintOptions.Printer = 'Default'
    PrintOptions.PrintOnSheet = 0
    ReportOptions.CreateDate = 41814.473001365700000000
    ReportOptions.LastChange = 41900.404276273150000000
    ScriptLanguage = 'PascalScript'
    ScriptText.Strings = (
      'begin'
      ''
      'end.')
    OnPreview = frxReport1Preview
    Left = 464
    Top = 232
    Datasets = <
      item
        DataSet = frxUserDataSet
        DataSetName = 'frxUserDataSet'
      end>
    Variables = <>
    Style = <>
    object Data: TfrxDataPage
      Height = 1000.000000000000000000
      Width = 1000.000000000000000000
    end
    object Page1: TfrxReportPage
      PaperWidth = 210.000000000000000000
      PaperHeight = 297.000000000000000000
      PaperSize = 9
      LeftMargin = 5.000000000000000000
      RightMargin = 5.000000000000000000
      object ReportTitle1: TfrxReportTitle
        Height = 113.385900000000000000
        Top = 18.897650000000000000
        Width = 755.906000000000000000
        object Memo1: TfrxMemoView
          Left = 298.582870000000000000
          Top = 11.338590000000000000
          Width = 147.401670000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #28052#27194#23007#37723#27194#32223#28052#27196#27365#29825#25198#32753)
          ParentFont = False
        end
        object Memo2: TfrxMemoView
          Left = 18.897650000000000000
          Top = 59.913420000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            #37813#25779#23875#37827#22549#26879)
          ParentFont = False
        end
        object SysMemo1: TfrxSysMemoView
          Left = 94.488250000000000000
          Top = 59.913420000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[DATE]')
          ParentFont = False
        end
        object Memo3: TfrxMemoView
          Left = 510.236550000000000000
          Top = 37.795300000000000000
          Width = 68.031540000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            #29863#23792#59216#37827#22549#26879)
          ParentFont = False
        end
        object Memo4: TfrxMemoView
          Left = 510.236550000000000000
          Top = 71.252010000000000000
          Width = 71.811070000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            #37812#57413#57627#37827#22549#26879)
          ParentFont = False
        end
        object MmoStart: TfrxMemoView
          Left = 612.283860000000000000
          Top = 37.795300000000000000
          Width = 154.960730000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MmoEnd: TfrxMemoView
          Left = 612.283860000000000000
          Top = 71.811070000000000000
          Width = 154.960730000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGreen
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
      end
      object Header1: TfrxHeader
        Height = 49.133890000000000000
        Top = 192.756030000000000000
        Width = 755.906000000000000000
        object Shape2: TfrxShapeView
          Align = baClient
          Width = 755.906000000000000000
          Height = 49.133890000000000000
        end
        object MemoName: TfrxMemoView
          Left = 18.897650000000000000
          Top = 15.118120000000000000
          Width = 64.252010000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoRoomNumber: TfrxMemoView
          Left = 120.944960000000000000
          Top = 15.118120000000000000
          Width = 83.149660000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoIn: TfrxMemoView
          Left = 222.992270000000000000
          Top = 15.118120000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoInTime: TfrxMemoView
          Left = 332.598640000000000000
          Top = 15.118120000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoOut: TfrxMemoView
          Left = 442.205010000000000000
          Top = 15.118120000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoOutTime: TfrxMemoView
          Left = 551.811380000000000000
          Top = 15.118120000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object MemoDutyName: TfrxMemoView
          Left = 657.638220000000000000
          Top = 15.118120000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          ParentFont = False
        end
        object Line8: TfrxLineView
          Left = 110.385900000000000000
          Height = 49.133890000000000000
          Diagonal = True
        end
        object Line10: TfrxLineView
          Left = 321.260050000000000000
          Height = 49.133890000000000000
          Diagonal = True
        end
        object Line11: TfrxLineView
          Left = 434.645950000000000000
          Height = 49.133890000000000000
          Diagonal = True
        end
        object Line12: TfrxLineView
          Left = 548.031850000000000000
          Height = 49.133890000000000000
          Diagonal = True
        end
        object Line13: TfrxLineView
          Left = 653.858690000000000000
          Height = 49.133890000000000000
          Diagonal = True
        end
        object Line9: TfrxLineView
          Left = 215.433210000000000000
          Height = 49.133890000000000000
          Frame.Typ = [ftLeft]
        end
      end
      object MasterData1: TfrxMasterData
        Height = 56.692950000000000000
        Top = 264.567100000000000000
        Width = 755.906000000000000000
        DataSet = frxUserDataSet
        DataSetName = 'frxUserDataSet'
        RowCount = 0
        object Shape1: TfrxShapeView
          Align = baClient
          Width = 755.906000000000000000
          Height = 56.692950000000000000
        end
        object Memo12: TfrxMemoView
          Left = 11.338590000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."1"]')
          ParentFont = False
        end
        object Memo13: TfrxMemoView
          Left = 117.165430000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."2"]')
          ParentFont = False
        end
        object Memo14: TfrxMemoView
          Left = 219.212740000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."3"]')
          ParentFont = False
        end
        object Memo15: TfrxMemoView
          Left = 332.598640000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."4"]')
          ParentFont = False
        end
        object Memo16: TfrxMemoView
          Left = 442.205010000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."5"]')
          ParentFont = False
        end
        object Memo17: TfrxMemoView
          Left = 551.811380000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."6"]')
          ParentFont = False
        end
        object Memo18: TfrxMemoView
          Left = 661.417750000000000000
          Top = 18.897650000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          StretchMode = smMaxHeight
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          Memo.UTF8 = (
            '[frxUserDataSet."7"]')
          ParentFont = False
        end
        object Line1: TfrxLineView
          Left = 109.606370000000000000
          Height = 56.692950000000000000
          Diagonal = True
        end
        object Line2: TfrxLineView
          Left = 215.433210000000000000
          Height = 56.692950000000000000
          Diagonal = True
        end
        object Line3: TfrxLineView
          Left = 321.260050000000000000
          Height = 52.913420000000000000
          Diagonal = True
        end
        object Line4: TfrxLineView
          Left = 321.260050000000000000
          Top = 52.913420000000000000
          Height = 3.779530000000000000
          Diagonal = True
        end
        object Line5: TfrxLineView
          Left = 434.645950000000000000
          Height = 56.692950000000000000
          Diagonal = True
        end
        object Line6: TfrxLineView
          Left = 548.031850000000000000
          Height = 56.692950000000000000
          Diagonal = True
        end
        object Line7: TfrxLineView
          Left = 653.858690000000000000
          Height = 56.692950000000000000
          Diagonal = True
        end
      end
      object Footer1: TfrxFooter
        Height = 64.252010000000000000
        Top = 343.937230000000000000
        Width = 755.906000000000000000
        object MmoCountTitle: TfrxMemoView
          Left = 22.677180000000000000
          Top = 22.677180000000000000
          Width = 143.622140000000000000
          Height = 18.897650000000000000
          Visible = False
          DisplayFormat.DecimalSeparator = '.'
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clBlack
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          Memo.UTF8 = (
            #37711#36779#57720#28051#23944#20824#37713#21700#30252#27996#21700#25011)
          ParentFont = False
        end
        object MemoCount: TfrxMemoView
          Left = 188.976500000000000000
          Top = 22.677180000000000000
          Width = 94.488250000000000000
          Height = 18.897650000000000000
          Visible = False
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clRed
          Font.Height = -16
          Font.Name = 'Arial'
          Font.Style = [fsBold]
          ParentFont = False
        end
      end
    end
  end
  object frxUserDataSet: TfrxUserDataSet
    RangeEnd = reCount
    UserName = 'frxUserDataSet'
    Fields.Strings = (
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8')
    OnGetValue = frxUserDataSetGetValue
    Left = 496
    Top = 232
  end
end
