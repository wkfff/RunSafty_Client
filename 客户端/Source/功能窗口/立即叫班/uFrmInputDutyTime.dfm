object frmInputDutyTime: TfrmInputDutyTime
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #36755#20837
  ClientHeight = 139
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 16
    Top = 34
    Width = 80
    Height = 19
    Caption = #20986#21220#26102#38388#65306
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object btnOK: TButton
    Left = 120
    Top = 89
    Width = 73
    Height = 32
    Caption = #30830#23450'(&F)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 205
    Top = 89
    Width = 69
    Height = 32
    Caption = #21462#28040'(&C)'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object dtpDutyTime: TAdvDateTimePicker
    Left = 97
    Top = 31
    Width = 177
    Height = 24
    Date = 41137.412430555550000000
    Time = 41137.412430555550000000
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = []
    Kind = dkDateTime
    ParentFont = False
    TabOrder = 2
    BorderStyle = bsSingle
    Ctl3D = True
    DateTime = 41137.412430555550000000
    TimeFormat = 'HH:mm'
    Version = '1.1.0.0'
    LabelFont.Charset = DEFAULT_CHARSET
    LabelFont.Color = clWindowText
    LabelFont.Height = -11
    LabelFont.Name = 'Tahoma'
    LabelFont.Style = []
  end
end
