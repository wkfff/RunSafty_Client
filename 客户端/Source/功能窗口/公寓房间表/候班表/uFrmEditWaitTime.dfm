object FrmEditWaitTime: TFrmEditWaitTime
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #32534#36753#20505#29677#34920
  ClientHeight = 210
  ClientWidth = 460
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lbl3: TLabel
    Left = 13
    Top = 28
    Width = 68
    Height = 19
    Caption = #36710'      '#27425':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl8: TLabel
    Left = 13
    Top = 70
    Width = 70
    Height = 19
    Caption = #20505#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl4: TLabel
    Left = 236
    Top = 69
    Width = 70
    Height = 19
    Caption = #21483#29677#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl5: TLabel
    Left = 13
    Top = 112
    Width = 70
    Height = 19
    Caption = #20986#21220#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl6: TLabel
    Left = 236
    Top = 111
    Width = 70
    Height = 19
    Caption = #24320#36710#26102#38388':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 236
    Top = 28
    Width = 74
    Height = 19
    Caption = #25151'  '#38388'  '#21495':'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object edtCheci: TEdit
    Left = 88
    Top = 25
    Width = 128
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 0
  end
  object edtHouBan: TRzDateTimeEdit
    Left = 88
    Top = 66
    Width = 128
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 2
  end
  object edtJiaoBan: TRzDateTimeEdit
    Left = 320
    Top = 66
    Width = 116
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 3
  end
  object edtChuQin: TRzDateTimeEdit
    Left = 88
    Top = 108
    Width = 128
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 4
  end
  object edtKaiche: TRzDateTimeEdit
    Left = 320
    Top = 108
    Width = 116
    Height = 27
    EditType = etTime
    Format = 'hh:nn:ss'
    DropButtonVisible = False
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 5
  end
  object btnOK: TButton
    Left = 222
    Top = 151
    Width = 88
    Height = 33
    Caption = #30830#23450
    TabOrder = 6
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 348
    Top = 151
    Width = 88
    Height = 33
    Caption = #21462#28040
    TabOrder = 7
    OnClick = btnCancelClick
  end
  object edtRoomNum: TEdit
    Left = 320
    Top = 25
    Width = 116
    Height = 27
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Tahoma'
    Font.Style = []
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    ParentFont = False
    TabOrder = 1
  end
end
