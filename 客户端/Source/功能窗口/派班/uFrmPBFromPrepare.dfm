object frmPBFromPrepare: TfrmPBFromPrepare
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20174#22791#29677#27966#29677
  ClientHeight = 311
  ClientWidth = 542
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
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
  object Panel1: TPanel
    Left = 0
    Top = 270
    Width = 542
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object btnCancel: TButton
      Left = 378
      Top = 3
      Width = 80
      Height = 30
      Cancel = True
      Caption = #21462#28040
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnOK: TButton
      Left = 292
      Top = 3
      Width = 80
      Height = 30
      Caption = #30830#23450
      TabOrder = 1
      OnClick = btnOKClick
      OnKeyPress = comboTrainmanJiaoluKeyPress
    end
  end
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 542
    Height = 270
    Align = alClient
    BorderOuter = fsNone
    TabOrder = 0
    object Label4: TLabel
      Left = 44
      Top = 87
      Width = 72
      Height = 16
      Caption = #20154#21592#20132#36335':'
    end
    object Label2: TLabel
      Left = 60
      Top = 162
      Width = 64
      Height = 16
      Caption = #20056#21153#21592#65306
    end
    object lblPlanInfo: TLabel
      Left = 44
      Top = 40
      Width = 432
      Height = 16
      Caption = #35831#20026#36710#27425#20026'21501'#65292#26426#36710#20026'SS4B-0253'#30340#35745#21010#23433#25490#20540#20056#30340#20056#21153#21592
      Font.Charset = GB2312_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object comboTrainmanJiaolu: TRzComboBox
      Left = 156
      Top = 84
      Width = 297
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 0
      OnChange = comboTrainmanJiaoluChange
      OnKeyPress = comboTrainmanJiaoluKeyPress
    end
    object comboTrainman1: TRzComboBox
      Left = 156
      Top = 159
      Width = 297
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      TabOrder = 1
      OnKeyPress = comboTrainmanJiaoluKeyPress
    end
  end
end
