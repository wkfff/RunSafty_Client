object FrmJDPlan: TFrmJDPlan
  Left = 0
  Top = 0
  Align = alClient
  BorderStyle = bsNone
  Caption = #38454#27573#35745#21010
  ClientHeight = 432
  ClientWidth = 753
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
  DesignSize = (
    753
    432)
  PixelsPerInch = 96
  TextHeight = 13
  object PageControl_Section: TRzPageControl
    Left = 57
    Top = 0
    Width = 696
    Height = 432
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = 'Tahoma'
    Font.Style = []
    HotTrack = False
    ParentFont = False
    ShowFocusRect = False
    ShowShadow = False
    TabColors.HighlightBar = 16645629
    TabColors.Unselected = clSilver
    TabHeight = 30
    TabIndex = 0
    TabOrder = 0
    UseGradients = False
    FixedDimension = 30
    object TabSheet1: TRzTabSheet
      Caption = 'TabSheet1'
    end
    object TabSheet2: TRzTabSheet
      Caption = 'TabSheet2'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 57
    Height = 432
    Align = alLeft
    BorderOuter = fsGroove
    TabOrder = 1
    object RzPanel2: TRzPanel
      Left = 2
      Top = 2
      Width = 53
      Height = 31
      Align = alTop
      BorderOuter = fsGroove
      TabOrder = 0
      object chkAutoRefresh: TRzCheckBox
        Left = 2
        Top = 2
        Width = 49
        Height = 39
        Align = alTop
        Caption = #33258#21160#21047#26032
        Checked = True
        FillColor = clWhite
        FocusColor = clWhite
        FrameColor = 7960953
        FrameController = GlobalDM.FrameController
        HotTrack = True
        HotTrackColor = clGradientActiveCaption
        HotTrackStyle = htsFrame
        State = cbChecked
        TabOrder = 0
        OnClick = chkAutoRefreshClick
      end
    end
    object RzPanel3: TRzPanel
      Left = 2
      Top = 33
      Width = 53
      Height = 397
      Align = alClient
      BorderOuter = fsGroove
      TabOrder = 1
      object SpeedButton1: TSpeedButton
        Left = 2
        Top = 2
        Width = 49
        Height = 393
        Align = alClient
        Caption = #21047#26032
        Flat = True
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = #23435#20307
        Font.Style = [fsBold]
        ParentFont = False
        OnClick = SpeedButton1Click
        ExplicitLeft = -1
        ExplicitTop = 25
        ExplicitWidth = 69
        ExplicitHeight = 411
      end
    end
  end
  object btnFind: TButton
    Left = 668
    Top = 3
    Width = 75
    Height = 25
    Action = actF2
    Anchors = [akTop, akRight]
    Caption = #26597#25214'(&F2)'
    TabOrder = 2
  end
  object tmrRefreshPlan: TTimer
    Interval = 10000
    OnTimer = tmrRefreshPlanTimer
    Left = 360
    Top = 200
  end
  object RzFrameController1: TRzFrameController
    FrameVisible = True
    Left = 48
    Top = 272
  end
  object ActionList1: TActionList
    Left = 384
    Top = 72
    object actF2: TAction
      Caption = 'actF2'
      ShortCut = 113
      OnExecute = actF2Execute
    end
  end
end
