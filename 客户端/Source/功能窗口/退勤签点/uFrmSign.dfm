object FrmSign: TFrmSign
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = 'FrmSign'
  ClientHeight = 641
  ClientWidth = 911
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 376
    Top = 312
    Width = 31
    Height = 13
    Caption = 'Label1'
  end
  object plTop: TRzPanel
    Left = 0
    Top = 0
    Width = 911
    Height = 30
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 0
    DesignSize = (
      911
      30)
    object btnRefreshPaln: TPngSpeedButton
      Left = 435
      Top = 2
      Width = 100
      Height = 25
      Caption = #21047#26032#35745#21010'(F5)'
      OnClick = btnRefreshPalnClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000016D4944415478DA95933F28C55114C7EFD3AF37480683DE
        20C9A048CAF25264900CA478912CCAF092C5C06233582C6233F8B31824CBF367
        906478615332480649261924935EF239BDEFE376FB21A73EF5FBDD7BCFF79C7B
        CEB989743AED62AC126AA00E2278807B78D1FE96FEE7128140398CC10434CBD9
        AC00B7B00A1BB00E03D0EF0B54C3267443999CDEB59794D8079C6AAF0B864B02
        15B0AB45DB3C50B44B8935401686BCAC9C2F30054B8A300F0B5E74CBA84A8E93
        D0110A58C1CE74E71C8C78CE4E0EDB9052362E1468E1E3420B834A3FB44E458F
        82F5451348298AA57F046FEE1F96F8610E7E332B788FAE933781363E66824305
        75E12446A0571D336B35016BCD4E70C8AEF30CA38148A48266E01ADAE304CE61
        459D788543CF79DA15DB1C29EBE538017F90AEF4DFE48AE39D91731EFAACE0BE
        C0B152FF6B94CDD966E5A9D405ABE83EECC1B82B3EA6ACA226BD9ADC28AB35BF
        D526608766A151452BB5AA16EA95CD23DCB9EFE7FC659F5B535D594C0F12B400
        00000049454E44AE426082}
    end
    object btnSign: TPngSpeedButton
      Left = 541
      Top = 2
      Width = 90
      Height = 25
      Caption = #25163#24037#31614#28857
      Visible = False
      OnClick = btnSignClick
      PngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000001524944415478DA8DD33F28465118C7F17391FFA9374416
        9B90287FDEC440168BE54D06830C168AD1A6F41A9412DE49D80C62917F118998
        24264A36491948ACFE7F9FEEA36EA77B754E7DEABEF7DEF3BBE79CE779BD783C
        6E424613EAF186433C9B88E18504F4611685FA7B1B0378720988E10C15D67B83
        5870099089C728B3DE1BC7844B4026F6D11EB8F7856E6CBA9E411D52A8C227E6
        31896FD7800CE469C00BEEF0EE52856CF4A30569F890E7BA2D29E3322EA302D2
        31AA4BF5223E768B046EC2029A71841CF3FF58432F7E8201B2E7198C18BFEB6A
        506A4DDCD3C33DC5185AF1281F9580122ECEF18A39E3D7BCDC0A98C6150E908F
        5534487925402E2E30851DACA3D80A58C2B0F13B525658ADAB789080844E9287
        D7D8458115B082212CA253CF20F67706B2DF36E3FF072AB1A5A50B0EE9CE1E9D
        548424BA64CB7623E5A2111D1A96857B6CE0C4F8DD58AB01723FF90B54B74B09
        6BD738C40000000049454E44AE426082}
    end
    object Label2: TLabel
      Left = 8
      Top = 9
      Width = 52
      Height = 13
      Caption = #24320#22987#26102#38388':'
    end
    object Label3: TLabel
      Left = 215
      Top = 9
      Width = 52
      Height = 13
      Caption = #25130#27490#26102#38388':'
    end
    object chkShowFinished: TCheckBox
      Left = 796
      Top = 7
      Width = 97
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #26174#31034#24050#32467#26463
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 0
      OnClick = chkShowFinishedClick
    end
    object chkFirstDay: TCheckBox
      Left = 635
      Top = 7
      Width = 128
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #26174#31034#31532#19968#22825#35745#21010
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 1
      Visible = False
      OnClick = chkFirstDayClick
    end
    object chkSecondDay: TCheckBox
      Left = 662
      Top = 7
      Width = 128
      Height = 17
      Anchors = [akTop, akRight]
      Caption = #26174#31034#31532#20108#22825#35745#21010
      Checked = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      State = cbChecked
      TabOrder = 2
      Visible = False
      OnClick = chkSecondDayClick
    end
    object dtpStartDay: TRzDateTimePicker
      Left = 66
      Top = 5
      Width = 83
      Height = 21
      Date = 41969.658351087960000000
      Time = 41969.658351087960000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 3
    end
    object dtpStartTime: TRzDateTimePicker
      Left = 148
      Top = 5
      Width = 61
      Height = 21
      Date = 41969.658546354160000000
      Format = 'HH:mm'
      Time = 41969.658546354160000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dtkTime
      TabOrder = 4
    end
    object dtpEndTime: TRzDateTimePicker
      Left = 346
      Top = 5
      Width = 61
      Height = 21
      Date = 41969.658546354160000000
      Format = 'HH:mm'
      Time = 41969.658546354160000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      Kind = dtkTime
      TabOrder = 5
    end
    object dtpEndDay: TRzDateTimePicker
      Left = 267
      Top = 5
      Width = 83
      Height = 21
      Date = 41969.658351087960000000
      Time = 41969.658351087960000000
      ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
      TabOrder = 6
    end
  end
  object tabTrainJiaolu: TRzTabControl
    Left = 0
    Top = 30
    Width = 911
    Height = 23
    Align = alTop
    BackgroundColor = 15065568
    Color = clWhite
    FlatColor = 7440017
    ImageMargin = 10
    HotTrackColor = 7440017
    ParentBackgroundColor = False
    ParentColor = False
    ShowCard = False
    ShowCardFrame = False
    SoftCorners = True
    TabColors.HighlightBar = 7440017
    TabColors.Shadow = clNavy
    TabColors.Unselected = clBtnFace
    TabHeight = 20
    TabIndex = 0
    TabOrder = 1
    Tabs = <
      item
        Caption = #26426#36710#20132#36335
      end>
    TabStyle = tsRoundCorners
    UseGradients = False
    OnChange = tabTrainJiaoluChange
    FixedDimension = 20
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 53
    Width = 911
    Height = 588
    Align = alClient
    BorderOuter = fsFlat
    TabOrder = 2
    object GridSignPlan: TAdvStringGrid
      Left = 1
      Top = 1
      Width = 909
      Height = 586
      Cursor = crDefault
      Align = alClient
      BorderStyle = bsNone
      Color = clWhite
      ColCount = 12
      Ctl3D = False
      FixedColor = 16448250
      RowCount = 2
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing]
      ParentCtl3D = False
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 0
      OnMouseDown = GridSignPlanMouseDown
      OnMouseUp = GridSignPlanMouseUp
      ActiveRowColor = clWhite
      HoverRowColor = clWhite
      OnGetCellColor = GridSignPlanGetCellColor
      ActiveCellFont.Charset = DEFAULT_CHARSET
      ActiveCellFont.Color = clWindowText
      ActiveCellFont.Height = -11
      ActiveCellFont.Name = 'Tahoma'
      ActiveCellFont.Style = [fsBold]
      ColumnHeaders.Strings = (
        #24207#21495
        #29366#24577
        #36710#27425
        #20986#21220#26102#38388
        #24320#36710#26102#38388
        #20505#29677#26102#38388
        #21483#29677#26102#38388
        #21496#26426'1'
        #21496#26426'2'
        #21496#26426'3'
        #21496#26426'4'
        #32467#26463)
      ColumnSize.Save = True
      ColumnSize.Key = 'FormColWidths.ini'
      ColumnSize.Section = 'SignPlan'
      ColumnSize.Location = clIniFile
      ControlLook.FixedGradientHoverFrom = 16775139
      ControlLook.FixedGradientHoverTo = 16775139
      ControlLook.FixedGradientHoverMirrorFrom = 16772541
      ControlLook.FixedGradientHoverMirrorTo = 16508855
      ControlLook.FixedGradientHoverBorder = 12033927
      ControlLook.FixedGradientDownFrom = 16377020
      ControlLook.FixedGradientDownTo = 16377020
      ControlLook.FixedGradientDownMirrorFrom = 16242317
      ControlLook.FixedGradientDownMirrorTo = 16109962
      ControlLook.FixedGradientDownBorder = 11440207
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
      FixedColWidth = 40
      FixedRowHeight = 25
      FixedFont.Charset = GB2312_CHARSET
      FixedFont.Color = 3355443
      FixedFont.Height = -16
      FixedFont.Name = #23435#20307
      FixedFont.Style = [fsBold]
      Flat = True
      FloatFormat = '%.2f'
      Look = glClassic
      MouseActions.SelectOnRightClick = True
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
      SelectionColorTo = clHighlight
      SelectionTextColor = clHighlightText
      ShowModified.Color = clWhite
      ShowDesignHelper = False
      SortSettings.AutoSortForGrouping = False
      SortSettings.Full = False
      SortSettings.AutoFormat = False
      SortSettings.SortOnVirtualCells = False
      SortSettings.HeaderColorTo = 16579058
      SortSettings.HeaderMirrorColor = 16380385
      SortSettings.HeaderMirrorColorTo = 16182488
      Version = '5.6.0.0'
      ColWidths = (
        40
        60
        42
        81
        76
        76
        76
        51
        51
        51
        106
        64)
      RowHeights = (
        25
        27)
    end
  end
  object pMenuColumn: TPopupMenu
    Left = 608
    Top = 96
    object miSelectColumn: TMenuItem
      Caption = #36873#25321#21015
      OnClick = miSelectColumnClick
    end
    object N11: TMenuItem
      Caption = '-'
    end
  end
  object PMTuiQin: TPopupMenu
    OnPopup = PMTuiQinPopup
    Left = 344
    Top = 144
    object N1: TMenuItem
      Caption = #20462#25913#20154#21592
      OnClick = N1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object N3: TMenuItem
      Caption = #23450#20301#31614#28857
      OnClick = N3Click
    end
  end
  object pmPaiBan: TPopupMenu
    Left = 416
    Top = 144
    object MenuItem1: TMenuItem
      Caption = #32467#26463
      OnClick = MenuItem1Click
    end
  end
end
