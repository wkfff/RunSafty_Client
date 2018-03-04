object frmImportRealtion: TfrmImportRealtion
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #23548#20837#24072#24466#20851#31995
  ClientHeight = 608
  ClientWidth = 634
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object RzBorder1: TRzBorder
    Left = 8
    Top = 8
    Width = 618
    Height = 592
    BorderOuter = fsFlatRounded
  end
  object lvRealtion: TRzListView
    Left = 19
    Top = 18
    Width = 502
    Height = 572
    Margins.Left = 5
    Margins.Top = 5
    Margins.Bottom = 5
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Alignment = taCenter
        Caption = #21496#26426#24037#21495
        Width = 90
      end
      item
        Alignment = taCenter
        Caption = #21496#26426#22995#21517
        Width = 90
      end
      item
        Alignment = taCenter
        Caption = #23398#21592#24037#21495
        Width = 90
      end
      item
        Alignment = taCenter
        Caption = #23398#21592#22995#21517
        Width = 161
      end>
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    FrameHotStyle = fsButtonUp
    FrameStyle = fsGroove
    FrameVisible = True
    GridLines = True
    ParentFont = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnCustomDrawItem = lvRealtionCustomDrawItem
    OnCustomDrawSubItem = lvRealtionCustomDrawSubItem
  end
  object btnOpen: TRzBitBtn
    Left = 527
    Top = 18
    Width = 90
    Height = 30
    Caption = #25171#24320'Excel'#8230
    TabOrder = 1
    OnClick = btnOpenClick
  end
  object btnImport: TRzBitBtn
    Left = 527
    Top = 60
    Width = 90
    Height = 30
    Caption = #23548#20837
    TabOrder = 2
    OnClick = btnImportClick
  end
  object btnExit: TRzBitBtn
    Left = 527
    Top = 560
    Width = 90
    Height = 30
    Caption = #36864#20986
    TabOrder = 3
    OnClick = btnExitClick
  end
  object OpenDialog: TOpenDialog
    DefaultExt = '*.xls'
    FileName = '*.xls'
    Filter = '*.xls|*.xls|*.xlsx|*.xlsx'
    Options = [ofReadOnly, ofHideReadOnly, ofFileMustExist, ofEnableSizing]
    Left = 544
    Top = 152
  end
end
