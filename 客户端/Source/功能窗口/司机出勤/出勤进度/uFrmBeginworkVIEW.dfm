object frmBeginworkView: TfrmBeginworkView
  Left = 0
  Top = 0
  BorderIcons = [biMinimize]
  BorderStyle = bsDialog
  Caption = #20986#21220#36827#24230#22270
  ClientHeight = 525
  ClientWidth = 644
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
  PixelsPerInch = 96
  TextHeight = 13
  object pFlowCanvas: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 384
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object imgCanvas: TImage
      Left = 0
      Top = 0
      Width = 644
      Height = 384
      Align = alClient
      ExplicitWidth = 456
      ExplicitHeight = 201
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 484
    Width = 644
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    DesignSize = (
      644
      41)
    object btnAllow: TButton
      Left = 462
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = #20801#35768#20986#21220
      Default = True
      TabOrder = 0
      OnClick = btnAllowClick
    end
    object btnCancel: TButton
      Left = 543
      Top = 6
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Cancel = True
      Caption = #20851#38381
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnRefresh: TButton
      Left = 11
      Top = 6
      Width = 75
      Height = 25
      Caption = #21047#26032#36827#24230
      Default = True
      TabOrder = 2
      OnClick = btnRefreshClick
    end
  end
  object memoBrief: TMemo
    Left = 0
    Top = 384
    Width = 644
    Height = 100
    Align = alBottom
    Lines.Strings = (
      #20986#21220#27969#31243#21512#26684#65292#20801#35768#20986#21220#12290)
    TabOrder = 2
  end
end
