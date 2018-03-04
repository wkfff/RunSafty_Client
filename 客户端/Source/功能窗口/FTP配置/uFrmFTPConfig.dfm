object frmFTPConfig: TfrmFTPConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'FTP'#37197#32622
  ClientHeight = 220
  ClientWidth = 349
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 65
    Top = 23
    Width = 63
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = 'FTP'#22320#22336#65306
    Layout = tlCenter
  end
  object Label2: TLabel
    Left = 65
    Top = 53
    Width = 63
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #31471#21475#21495#65306
    Layout = tlCenter
  end
  object Label3: TLabel
    Left = 65
    Top = 83
    Width = 63
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #29992#25143#21517#65306
    Layout = tlCenter
  end
  object Label5: TLabel
    Left = 65
    Top = 113
    Width = 63
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #23494#30721#65306
    Layout = tlCenter
  end
  object Label6: TLabel
    Left = 65
    Top = 144
    Width = 63
    Height = 21
    Alignment = taCenter
    AutoSize = False
    Caption = #36335#24452#65306
    Layout = tlCenter
  end
  object btnOK: TButton
    Left = 204
    Top = 182
    Width = 60
    Height = 26
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 278
    Top = 182
    Width = 59
    Height = 26
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object edtHost: TEdit
    Left = 136
    Top = 24
    Width = 121
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 2
  end
  object edtPort: TEdit
    Left = 136
    Top = 54
    Width = 121
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 3
  end
  object edtUserName: TEdit
    Left = 136
    Top = 84
    Width = 121
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 4
  end
  object edtPassword: TEdit
    Left = 136
    Top = 114
    Width = 121
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 5
  end
  object edtPath: TEdit
    Left = 136
    Top = 145
    Width = 121
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#25628#29399#25340#38899#36755#20837#27861
    TabOrder = 6
  end
  object btnTestConnection: TButton
    Left = 278
    Top = 143
    Width = 59
    Height = 25
    Caption = #27979#35797#36830#25509
    TabOrder = 7
    OnClick = btnTestConnectionClick
  end
end
