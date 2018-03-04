object FrmWaitTimeTable: TFrmWaitTimeTable
  Left = 0
  Top = 0
  Caption = #20505#29677#36710#27425#25151#38388#34920
  ClientHeight = 433
  ClientWidth = 658
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lvWaitTime: TListView
    Left = 0
    Top = 41
    Width = 658
    Height = 392
    Align = alClient
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #36710#27425
        Width = 80
      end
      item
        Caption = #25151#38388
        Width = 80
      end
      item
        Caption = #20505#29677#28857
        Width = 80
      end
      item
        Caption = #21483#29677#28857
        Width = 80
      end
      item
        Caption = #20986#21220#28857
        Width = 80
      end
      item
        Caption = #24320#36710#28857
        Width = 80
      end>
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    GridLines = True
    ReadOnly = True
    RowSelect = True
    ParentFont = False
    TabOrder = 0
    ViewStyle = vsReport
    ExplicitWidth = 923
    ExplicitHeight = 369
  end
  object rzpnl1: TRzPanel
    Left = 0
    Top = 0
    Width = 658
    Height = 41
    Align = alTop
    BorderOuter = fsNone
    TabOrder = 1
    ExplicitWidth = 913
    object btnAdd: TButton
      Left = 20
      Top = 7
      Width = 80
      Height = 28
      Caption = #26032#22686
      TabOrder = 0
      OnClick = btnAddClick
    end
    object btnModfy: TButton
      Left = 119
      Top = 7
      Width = 80
      Height = 28
      Caption = #20462#25913
      TabOrder = 1
      OnClick = btnModfyClick
    end
    object btnDel: TButton
      Left = 217
      Top = 7
      Width = 80
      Height = 28
      Caption = #21024#38500
      TabOrder = 2
      OnClick = btnDelClick
    end
    object btnImPort: TButton
      Left = 316
      Top = 7
      Width = 80
      Height = 28
      Caption = #23548#20837
      TabOrder = 3
      OnClick = btnImPortClick
    end
  end
  object dlgOpen1: TOpenDialog
    DefaultExt = '*.xls'
    FileName = '*.xls'
    Filter = '*.xls'
    Left = 1096
    Top = 16
  end
end
