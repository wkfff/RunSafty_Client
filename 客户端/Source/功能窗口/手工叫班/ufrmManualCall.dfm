object frmManualCall: TfrmManualCall
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21483#29677
  ClientHeight = 550
  ClientWidth = 924
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TRzPanel
    Left = 0
    Top = 57
    Width = 924
    Height = 493
    Align = alClient
    BorderOuter = fsNone
    GradientColorStyle = gcsCustom
    GradientColorStart = 12942605
    GradientColorStop = 16571569
    TabOrder = 0
    VisualStyle = vsGradient
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 924
    Height = 57
    Align = alTop
    BorderOuter = fsFlat
    BorderSides = [sdBottom]
    Color = 12942605
    TabOrder = 1
    DesignSize = (
      924
      56)
    object checkPlayMusic: TCheckBox
      Left = 24
      Top = 21
      Width = 137
      Height = 17
      Caption = #36830#36890#21518#25773#25918#21483#29677#38899#20048
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object btnCancelCall: TButton
      Left = 800
      Top = 17
      Width = 105
      Height = 34
      Anchors = [akTop, akRight]
      Caption = #21462#28040#21483#29677
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelCallClick
    end
  end
end
