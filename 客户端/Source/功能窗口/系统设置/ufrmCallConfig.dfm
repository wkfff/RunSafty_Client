object frmCallConfig: TfrmCallConfig
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21483#29677#35774#32622
  ClientHeight = 375
  ClientWidth = 648
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poMainFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object btnClose: TSpeedButton
    Left = 564
    Top = 331
    Width = 70
    Height = 30
    Caption = #20851#38381
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFBFDFB7AB580FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF6DB67453A45BD7E9D8FFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      7BC58471BE7B7AC1835BAA6447994F4191493B884235803B2F78352A702F2569
      292163241D5E20FFFFFFFFFFFF89D1927BC8869CD5A598D3A194D09D90CE988B
      CB9387C98E82C6897EC3847AC18076BE7C72BD78216324FFFFFFFFFFFF88D391
      7FCC8AA2D8AB9ED6A79AD4A396D29F93CF9A8ECC9589CA9085C78B81C5877DC2
      8278C07E256929FFFFFFFFFFFFFFFFFF83D18D80CD8B7CC9875DB86858B16253
      A95C4DA15647994F4191493B884235803B2F78352A702FFFFFFFFFFFFFFFFFFF
      FFFFFF7DCF886AC575FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFEFC90D699FFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    Margin = 5
    OnClick = btnCloseClick
  end
  object btnSave: TSpeedButton
    Left = 488
    Top = 331
    Width = 70
    Height = 30
    Caption = #20445#23384
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000F4F4F4DDDDDD
      D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
      D2DDDDDDF4F4F4FFFFFFD3B278CF9835CF9835CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835CF9835CF9835D3B278FFFFFFCF9835F5D29A
      CF9835FFFFFFCF9835EABC72CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F5D29ACF9835FFFFFFCF9835EEBF76CF9835FFFFFFCF9835E0A341CF9835FF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835EEBF76CF9835FFFFFFCF9835F0C279
      CF9835FFFFFFCF9835CF9835CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F0C279CF9835FFFFFFCF9835F3C780CF9835FFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835F3C780CF9835FFFFFFCF9835F6CC83
      CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF98
      35F6CC83CF9835FFFFFFCF9835FAD089DEA645CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835DEA645FAD089CF9835FFFFFFCF9835FED48E
      F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF62F6BF
      62FED48ECF9835FFFFFFCF9835FFDE9AFFCC72E4AD4ECF9835CF9835CF9835CF
      9835CF9835CF9835CF9835E4AD4EFFCC72FFDE9ACF9835FFFFFFCF9835FFE39F
      FFD278CF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835FFD2
      78FFE39FCF9835FFFFFFCF9835FFE6A4FFD87ECF9835FFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFCF9835FFD87EFFE6A4CF9835FFFFFFCF9835FFEAA8
      FFDD84CF9835FFFFFFCF9835CF9835FFFFFFFFFFFFFFFFFFFFFFFFCF9835FFDD
      84FFEAA8CF9835FFFFFFCF9835FFEEACFFE089CF9835FFFFFFCF9835CF9835FF
      FFFFFFFFFFFFFFFFFFFFFFCF9835FFE089FFEEACCF9835FFFFFFCF9835FFF8C8
      FFEFAFCF9835FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCF9835FFEF
      AFFFF8C8CF9835FFFFFFE3C288CF9835CF9835CF9835CF9835CF9835CF9835CF
      9835CF9835CF9835CF9835CF9835CF9835CF9835E3C288FFFFFF}
    Margin = 5
    OnClick = btnSaveClick
  end
  object PageControl1: TPageControl
    Left = 8
    Top = 8
    Width = 625
    Height = 317
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = #36890#35759#35774#32622
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label1: TLabel
        Left = 31
        Top = 25
        Width = 104
        Height = 16
        Caption = #31471#21475#21495'(COM)'#65306
      end
      object Label2: TLabel
        Left = 55
        Top = 204
        Width = 80
        Height = 16
        Caption = #21628#21483#24310#36831#65306
      end
      object Label3: TLabel
        Left = 55
        Top = 240
        Width = 80
        Height = 16
        Caption = #36861#21483#38388#38548#65306
      end
      object Label4: TLabel
        Left = 218
        Top = 242
        Width = 16
        Height = 16
        Caption = #20998
      end
      object Label5: TLabel
        Left = 218
        Top = 204
        Width = 16
        Height = 16
        Caption = #31186
      end
      object Label6: TLabel
        Left = 71
        Top = 98
        Width = 64
        Height = 16
        Caption = #25320#21495#38899#65306
      end
      object Label7: TLabel
        Left = 218
        Top = 98
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label8: TLabel
        Left = 55
        Top = 169
        Width = 80
        Height = 16
        Caption = #25320#21495#38388#38548#65306
      end
      object Label9: TLabel
        Left = 218
        Top = 169
        Width = 32
        Height = 16
        Caption = #27627#31186
      end
      object Label10: TLabel
        Left = 55
        Top = 61
        Width = 80
        Height = 16
        Caption = #36890#35759#31867#22411#65306
      end
      object Label11: TLabel
        Left = 39
        Top = 132
        Width = 96
        Height = 16
        Caption = #30333#22825#36890#35805#38899#65306
      end
      object Label12: TLabel
        Left = 218
        Top = 133
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label15: TLabel
        Left = 311
        Top = 198
        Width = 112
        Height = 16
        Caption = #21551#21160#20445#25252#38388#38548#65306
      end
      object Label16: TLabel
        Left = 508
        Top = 198
        Width = 16
        Height = 16
        Caption = #20998
      end
      object Label18: TLabel
        Left = 311
        Top = 234
        Width = 272
        Height = 32
        Caption = #22312#31243#24207#21551#21160#21069#24050#36807#26399#30340#21483#29677#22312#38388#38548#33539#22260#13#20869#20381#28982#26377#25928
        Font.Charset = GB2312_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object Label22: TLabel
        Left = 508
        Top = 163
        Width = 48
        Height = 16
        Caption = '1-1023'
      end
      object Label23: TLabel
        Left = 311
        Top = 163
        Width = 96
        Height = 16
        Caption = #22812#38388#36890#35805#38899#65306
      end
      object Label24: TLabel
        Left = 311
        Top = 96
        Width = 144
        Height = 16
        Caption = #22812#38388#26102#38388#33539#22260#35774#23450#65306
      end
      object Label25: TLabel
        Left = 438
        Top = 129
        Width = 48
        Height = 16
        Caption = #21040#20940#26216
      end
      object Label26: TLabel
        Left = 311
        Top = 129
        Width = 32
        Height = 16
        Caption = #26202#19978
      end
      object edtPort: TRzNumericEdit
        Left = 136
        Top = 22
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 0
        DisplayFormat = '0'
      end
      object edtCallWaiting: TRzNumericEdit
        Left = 136
        Top = 200
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 1
        DisplayFormat = '0'
      end
      object edtRecallSpace: TRzNumericEdit
        Left = 136
        Top = 237
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 2
        DisplayFormat = '0'
      end
      object edtMinSound: TRzNumericEdit
        Left = 136
        Top = 94
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 3
        Max = 1023.000000000000000000
        Min = 1.000000000000000000
        DisplayFormat = '0'
        Value = 1.000000000000000000
      end
      object edtDialDelay: TRzNumericEdit
        Left = 136
        Top = 165
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 4
        Max = 1000.000000000000000000
        DisplayFormat = '0'
      end
      object ComboBox1: TComboBox
        Left = 136
        Top = 58
        Width = 76
        Height = 24
        Style = csDropDownList
        ItemHeight = 16
        TabOrder = 5
        Items.Strings = (
          #20018#21475
          #38899#20048)
      end
      object edtMaxSound: TRzNumericEdit
        Left = 136
        Top = 129
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 6
        Max = 1023.000000000000000000
        Min = 1.000000000000000000
        DisplayFormat = '0'
        Value = 1023.000000000000000000
      end
      object edtOutTimeDelay: TRzNumericEdit
        Left = 429
        Top = 195
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 7
        DisplayFormat = '0'
      end
      object edtMaxSoundNight: TRzNumericEdit
        Left = 429
        Top = 160
        Width = 73
        Height = 24
        Alignment = taLeftJustify
        TabOrder = 8
        Max = 1023.000000000000000000
        Min = 1.000000000000000000
        DisplayFormat = '0'
        Value = 1023.000000000000000000
      end
      object edtNightEnd: TRzDateTimeEdit
        Left = 492
        Top = 126
        Width = 78
        Height = 24
        CalendarElements = [ceWeekNumbers]
        EditType = etTime
        Format = 'hh:nn'
        DropButtonVisible = False
        TabOrder = 9
      end
      object edtNightBegin: TRzDateTimeEdit
        Left = 349
        Top = 126
        Width = 78
        Height = 24
        CalendarElements = [ceWeekNumbers]
        EditType = etTime
        Format = 'hh:nn'
        DropButtonVisible = False
        HideSelection = False
        TabOrder = 10
      end
      object btnTestLine: TButton
        Left = 468
        Top = 22
        Width = 106
        Height = 25
        Caption = #26816#26597#38899#39057#32447#36335
        TabOrder = 11
        OnClick = btnTestLineClick
      end
      object checkCheckAudioLine: TCheckBox
        Left = 311
        Top = 26
        Width = 155
        Height = 17
        Caption = #33258#21160#26816#27979#38899#39057#32447#36335
        TabOrder = 12
      end
      object CheckWaitforConfirm: TCheckBox
        Left = 311
        Top = 60
        Width = 263
        Height = 17
        Caption = #39318#21483#21518#31561#24453#20844#23507#31649#29702#21592#30830#35748#25346#26029
        TabOrder = 13
      end
    end
    object TabSheet2: TTabSheet
      Caption = #26174#31034#35774#32622
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ImageIndex = 1
      ParentFont = False
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label13: TLabel
        Left = 88
        Top = 36
        Width = 104
        Height = 16
        Caption = #21483#29677#26102#38388#24050#36807':'
      end
      object Label14: TLabel
        Left = 88
        Top = 84
        Width = 104
        Height = 16
        Caption = #26410#21040#21040#36798#26102#38388':'
      end
      object Label17: TLabel
        Left = 24
        Top = 132
        Width = 168
        Height = 16
        Caption = #24050#36807#21040#36798#26102#38388#31561#24453#21483#29677':'
      end
      object Label19: TLabel
        Left = 104
        Top = 180
        Width = 88
        Height = 16
        Caption = #27491#22312#21483#29677#20013':'
      end
      object Label20: TLabel
        Left = 40
        Top = 228
        Width = 152
        Height = 16
        Caption = #24050#20652#21483#20294#21496#26426#26410#31163#23507':'
      end
      object Label21: TLabel
        Left = 450
        Top = 36
        Width = 96
        Height = 48
        Caption = #21452#20987#39068#33394#21306#22495#13#13#36873#25321#26032#39068#33394
        Font.Charset = GB2312_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object pColorOutTime: TPanel
        Left = 214
        Top = 32
        Width = 204
        Height = 25
        BevelOuter = bvNone
        Color = clGray
        TabOrder = 0
        OnDblClick = pColorOutTimeDblClick
      end
      object pColorUnenter: TPanel
        Left = 214
        Top = 80
        Width = 204
        Height = 25
        BevelOuter = bvNone
        Color = 9556122
        TabOrder = 1
        OnDblClick = pColorOutTimeDblClick
      end
      object pColorWaitingCall: TPanel
        Left = 214
        Top = 128
        Width = 204
        Height = 25
        BevelOuter = bvNone
        Color = 3352034
        TabOrder = 2
        OnDblClick = pColorOutTimeDblClick
      end
      object pColorCalling: TPanel
        Left = 214
        Top = 176
        Width = 204
        Height = 25
        BevelOuter = bvNone
        Color = 8388863
        TabOrder = 3
        OnDblClick = pColorOutTimeDblClick
      end
      object pColorOutDutyAlarm: TPanel
        Left = 214
        Top = 224
        Width = 204
        Height = 25
        BevelOuter = bvNone
        Color = 33023
        TabOrder = 4
        OnDblClick = pColorOutTimeDblClick
      end
    end
  end
  object ColorDialog1: TColorDialog
    Left = 520
    Top = 16
  end
  object timerTestLine: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timerTestLineTimer
    Left = 480
    Top = 16
  end
end
