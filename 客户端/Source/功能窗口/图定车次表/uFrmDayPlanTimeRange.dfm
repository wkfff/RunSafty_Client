object FrmDayPlanTimeRange: TFrmDayPlanTimeRange
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  Caption = #26102#38388#36873#25321
  ClientHeight = 275
  ClientWidth = 503
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -19
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 19
  object GroupBoxDT: TRzGroupBox
    Left = 24
    Top = 96
    Width = 449
    Height = 113
    Caption = #35831#36873#25321#26102#38388#33539#22260
    TabOrder = 2
    object Label3: TLabel
      Left = 9
      Top = 35
      Width = 86
      Height = 19
      Caption = #24320#22987#26102#38388':'
    end
    object Label4: TLabel
      Left = 9
      Top = 72
      Width = 86
      Height = 19
      Caption = #32467#26463#26102#38388':'
    end
    object dtBeginDatePicker: TRzDateTimePicker
      Left = 116
      Top = 34
      Width = 144
      Height = 31
      Date = 41576.580392789350000000
      Format = 'yyy-MM-dd'
      Time = 41576.580392789350000000
      TabOrder = 0
      FramingPreference = fpCustomFraming
    end
    object dtEndDatePicker: TRzDateTimePicker
      Left = 116
      Top = 71
      Width = 144
      Height = 31
      Date = 41576.580392789350000000
      Format = 'yyy-MM-dd'
      Time = 41576.580392789350000000
      TabOrder = 1
      FramingPreference = fpCustomFraming
    end
    object dtBeginTimePicker: TRzDateTimePicker
      Left = 299
      Top = 34
      Width = 114
      Height = 31
      Date = 41576.000011574080000000
      Time = 41576.000011574080000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 2
      FramingPreference = fpCustomFraming
    end
    object dtEndTimePicker: TRzDateTimePicker
      Left = 299
      Top = 71
      Width = 114
      Height = 31
      Date = 41576.999988425920000000
      Time = 41576.999988425920000000
      DateMode = dmUpDown
      Kind = dtkTime
      TabOrder = 3
      FramingPreference = fpCustomFraming
    end
  end
  object btnSave: TButton
    Left = 294
    Top = 228
    Width = 75
    Height = 34
    Caption = #30830#23450
    TabOrder = 0
    OnClick = btnSaveClick
  end
  object btnCancel: TButton
    Left = 398
    Top = 228
    Width = 75
    Height = 34
    Caption = #21462#28040
    TabOrder = 1
    OnClick = btnCancelClick
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 16
    Width = 449
    Height = 65
    Align = alCustom
    Caption = #29677#27425#36873#25321
    TabOrder = 3
    object Label2: TLabel
      Left = 9
      Top = 23
      Width = 86
      Height = 19
      Caption = #36873#25321#26085#26399':'
    end
    object Label1: TLabel
      Left = 261
      Top = 21
      Width = 48
      Height = 19
      Caption = #29677#27425':'
    end
    object dtpPlanStartDate: TRzDateTimePicker
      Left = 116
      Top = 19
      Width = 139
      Height = 27
      Date = 42117.426077638890000000
      Format = 'yyyy-MM-dd'
      Time = 42117.426077638890000000
      TabOrder = 0
      OnChange = cmbDayPlanTypeChange
      FramingPreference = fpCustomFraming
    end
    object cmbDayPlanType: TRzComboBox
      Left = 315
      Top = 19
      Width = 98
      Height = 27
      Style = csDropDownList
      ItemHeight = 19
      TabOrder = 1
      OnChange = cmbDayPlanTypeChange
      Items.Strings = (
        #30333#29677
        #22812#29677
        #20840#22825
        #20854#20182)
    end
    object Panel2: TPanel
      Left = 628
      Top = 15
      Width = 2
      Height = 31
      BevelOuter = bvLowered
      TabOrder = 2
    end
  end
end
