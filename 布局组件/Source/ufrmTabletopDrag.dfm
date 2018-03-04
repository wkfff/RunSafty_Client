object frmTabletopDrag: TfrmTabletopDrag
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmTabletopDrag'
  ClientHeight = 164
  ClientWidth = 156
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnMouseLeave = FormMouseLeave
  OnMouseMove = FormMouseMove
  OnMouseUp = FormMouseUp
  OnPaint = FormPaint
  PixelsPerInch = 96
  TextHeight = 12
  object ActionList1: TActionList
    Left = 64
    Top = 72
    object Action1: TAction
      Caption = 'Action1'
      ShortCut = 27
      OnExecute = Action1Execute
    end
  end
end
