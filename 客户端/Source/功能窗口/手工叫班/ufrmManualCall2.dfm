object frmManualCall2: TfrmManualCall2
  Left = 0
  Top = 0
  Caption = #25163#21160#21483#29677
  ClientHeight = 556
  ClientWidth = 829
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    829
    556)
  PixelsPerInch = 96
  TextHeight = 12
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 90
    Height = 14
    Caption = #25163#21160#21628#21483#25151#38388
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -14
    Font.Name = #23435#20307
    Font.Style = [fsBold]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 24
    Top = 52
    Width = 324
    Height = 12
    Caption = #36873#25321#25151#38388#21015#34920#65292#21628#21483#25151#38388#25104#21151#21518#36827#34892#36890#35805#25110#32773#25773#25918#21483#29677#38899#20048#65281
  end
  object Label3: TLabel
    Left = 596
    Top = 26
    Width = 84
    Height = 12
    Anchors = [akTop, akRight]
    Caption = #24555#36895#26597#25214#25151#38388#65306
  end
  object ListView1: TListView
    Left = 24
    Top = 80
    Width = 783
    Height = 457
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #25151#38388#21495
        Width = 100
      end
      item
        Caption = #35774#22791#21495
        Width = 80
      end
      item
        AutoSize = True
        Caption = #26368#22823#20154#25968
      end>
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
  end
  object btnPlayMusic: TButton
    Left = 451
    Top = 49
    Width = 99
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25773#25918#21483#29677#38899#20048
    TabOrder = 1
    OnClick = btnPlayMusicClick
  end
  object btnCall: TButton
    Left = 651
    Top = 49
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #21628#21483#25151#38388
    TabOrder = 2
    OnClick = btnCallClick
  end
  object btnCancelCall: TButton
    Left = 570
    Top = 49
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #21462#28040#21628#21483
    TabOrder = 3
    OnClick = btnCancelCallClick
  end
  object btnHangCall: TButton
    Left = 732
    Top = 49
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #25346#26029#25151#38388
    TabOrder = 4
    OnClick = btnHangCallClick
  end
  object edtRoomNumber: TEdit
    Left = 686
    Top = 23
    Width = 121
    Height = 20
    Anchors = [akTop, akRight]
    TabOrder = 5
    OnChange = edtRoomNumberChange
  end
end
