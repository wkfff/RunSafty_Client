object frmUDPConfig: TfrmUDPConfig
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #21483#29677#27169#24335#37197#32622
  ClientHeight = 209
  ClientWidth = 409
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
  object btnOK: TButton
    Left = 270
    Top = 176
    Width = 57
    Height = 25
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnOKClick
  end
  object btnCancel: TButton
    Left = 343
    Top = 176
    Width = 57
    Height = 25
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object grpUDPConfig: TGroupBox
    Left = 183
    Top = 21
    Width = 217
    Height = 140
    Caption = 'UDP'#37197#32622
    TabOrder = 2
    object Label2: TLabel
      Left = 13
      Top = 66
      Width = 60
      Height = 13
      Caption = #36828#31243#22320#22336#65306
    end
    object Label3: TLabel
      Left = 13
      Top = 102
      Width = 60
      Height = 13
      Caption = #36828#31243#31471#21475#65306
    end
    object Label1: TLabel
      Left = 13
      Top = 31
      Width = 60
      Height = 13
      Caption = #26412#22320#31471#21475#65306
    end
    object edtRemoteAddress: TEdit
      Left = 79
      Top = 63
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object edtRemotePort: TEdit
      Left = 79
      Top = 97
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object edtLocalPort: TEdit
      Left = 79
      Top = 28
      Width = 121
      Height = 21
      TabOrder = 2
    end
  end
  object grpInstallAddress: TGroupBox
    Left = 8
    Top = 104
    Width = 161
    Height = 57
    Caption = #23433#35013#22320#28857
    TabOrder = 3
    object rbGongYu: TRadioButton
      Left = 11
      Top = 22
      Width = 65
      Height = 16
      Caption = #20844#23507
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbGongYuClick
    end
    object rbPaiBanShi: TRadioButton
      Left = 85
      Top = 21
      Width = 58
      Height = 17
      Caption = #27966#29677#23460
      TabOrder = 1
      OnClick = rbPaiBanShiClick
    end
  end
  object grpModelConfig: TGroupBox
    Left = 8
    Top = 21
    Width = 161
    Height = 60
    Caption = #27169#24335#37197#32622
    TabOrder = 4
    object rbNormalCall: TRadioButton
      Left = 11
      Top = 24
      Width = 64
      Height = 17
      Caption = #27491#24120#21483#29677
      Checked = True
      TabOrder = 0
      TabStop = True
      OnClick = rbNormalCallClick
    end
    object rbRemotCall: TRadioButton
      Left = 85
      Top = 24
      Width = 66
      Height = 17
      Caption = #36828#31243#21483#29677
      TabOrder = 1
      OnClick = rbRemotCallClick
    end
  end
end
