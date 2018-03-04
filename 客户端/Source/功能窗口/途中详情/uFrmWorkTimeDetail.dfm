object frmWorkTimeDetail: TfrmWorkTimeDetail
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36255#21171#26102#35814#32454#20449#24687
  ClientHeight = 564
  ClientWidth = 851
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
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 851
    Height = 564
    Align = alClient
    BorderOuter = fsNone
    BorderWidth = 10
    TabOrder = 0
    object lstviewTurn: TRzListView
      Left = 10
      Top = 10
      Width = 831
      Height = 544
      Align = alClient
      BorderStyle = bsNone
      Columns = <
        item
          Caption = #20107#20214#26102#38388
          Width = 150
        end
        item
          Caption = #21457#29983#22320
          Width = 250
        end
        item
          Caption = #20107#20214
          Width = 100
        end
        item
          Caption = #36710#21495
          Width = 60
        end
        item
          Caption = #36710#27425
          Width = 254
        end>
      Ctl3D = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      FrameStyle = fsLowered
      FrameVisible = True
      GridLines = True
      LargeImages = ImageList1
      ParentFont = False
      PopupMenu = PopupMenu1
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
    end
  end
  object ImageList1: TImageList
    Height = 24
    Width = 24
    Left = 200
    Top = 272
  end
  object PopupMenu1: TPopupMenu
    Left = 344
    Top = 272
    object miDeleteEvent: TMenuItem
      Caption = #21024#38500#20107#20214
      OnClick = miDeleteEventClick
    end
  end
end
