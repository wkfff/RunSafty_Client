object frmStudentManage: TfrmStudentManage
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #23398#21592#31649#29702
  ClientHeight = 474
  ClientWidth = 489
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object RzBorder1: TRzBorder
    Left = 8
    Top = 8
    Width = 473
    Height = 458
    BorderOuter = fsFlatRounded
  end
  object lstStudentView: TRzListView
    Left = 19
    Top = 18
    Width = 369
    Height = 439
    Margins.Left = 5
    Margins.Top = 5
    Margins.Bottom = 5
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #23398#21592
        Width = 298
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
    OnCustomDrawItem = lstStudentViewCustomDrawItem
    OnCustomDrawSubItem = lstStudentViewCustomDrawSubItem
  end
  object RzBitBtn1: TRzBitBtn
    Left = 394
    Top = 18
    Caption = #28155#21152
    TabOrder = 1
    OnClick = RzBitBtn1Click
  end
  object RzBitBtn2: TRzBitBtn
    Left = 394
    Top = 49
    Caption = #21024#38500
    TabOrder = 2
    OnClick = RzBitBtn2Click
  end
end
