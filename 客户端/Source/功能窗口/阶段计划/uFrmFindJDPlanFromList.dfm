object frmFindJDPlanFromList: TfrmFindJDPlanFromList
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #36873#25321#35745#21010
  ClientHeight = 416
  ClientWidth = 693
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  DesignSize = (
    693
    416)
  PixelsPerInch = 96
  TextHeight = 16
  object btnOK: TButton
    Left = 512
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = #30830#23450
    Default = True
    TabOrder = 1
    OnClick = btnOKClick
    ExplicitLeft = 546
  end
  object btnCancel: TButton
    Left = 593
    Top = 367
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #21462#28040
    TabOrder = 2
    OnClick = btnCancelClick
    ExplicitLeft = 627
  end
  object ListView1: TListView
    Left = 27
    Top = 16
    Width = 643
    Height = 345
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        Caption = #21306#27573
        Width = 80
      end
      item
        Caption = #36710#27425
        Width = 70
      end
      item
        Caption = #24320#36710#26102#38388
        Width = 140
      end
      item
        Caption = #21040#36798#26102#38388
        Width = 140
      end
      item
        Caption = #24320#36710#31449
        Width = 100
      end
      item
        Caption = #32456#21040#31449
        Width = 100
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 0
    ViewStyle = vsReport
    OnDblClick = ListView1DblClick
    ExplicitWidth = 620
  end
end
