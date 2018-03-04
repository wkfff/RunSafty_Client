object frmOutDuty: TfrmOutDuty
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20986#21220#30331#35760
  ClientHeight = 411
  ClientWidth = 798
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
  object btnSave: TSpeedButton
    Left = 603
    Top = 362
    Width = 100
    Height = 30
    Caption = #20801#35768#20986#21220
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
  object btnCancel: TSpeedButton
    Left = 709
    Top = 362
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
    OnClick = btnCancelClick
  end
  object rzgrpbx2: TRzGroupBox
    Left = 16
    Top = 9
    Width = 761
    Height = 339
    Caption = #31614#21040#20449#24687
    TabOrder = 0
    object Label1: TLabel
      Left = 21
      Top = 24
      Width = 80
      Height = 16
      Caption = #24453#29677#36710#27425#65306
    end
    object Label2: TLabel
      Left = 501
      Top = 56
      Width = 80
      Height = 16
      Caption = #24320#36710#26102#38388#65306
    end
    object lblMainDriver: TLabel
      Left = 32
      Top = 101
      Width = 64
      Height = 16
      Caption = #27491#21496#26426#65306
    end
    object Label4: TLabel
      Left = 292
      Top = 101
      Width = 48
      Height = 16
      Caption = #29366#24577#65306
    end
    object Label3: TLabel
      Left = 501
      Top = 24
      Width = 80
      Height = 16
      Caption = #21483#29677#26102#38388#65306
    end
    object Label5: TLabel
      Left = 21
      Top = 56
      Width = 80
      Height = 16
      Caption = #21333#21452#21496#26426#65306
    end
    object btnMainInput: TSpeedButton
      Left = 682
      Top = 171
      Width = 55
      Height = 27
      Caption = #24037#21495
      OnClick = btnMainInputClick
    end
    object btnMainFinger: TSpeedButton
      Left = 558
      Top = 171
      Width = 55
      Height = 27
      Caption = #25351#32441
      OnClick = btnMainFingerClick
    end
    object Label7: TLabel
      Left = 501
      Top = 104
      Width = 80
      Height = 16
      Caption = #27979#37202#32467#26524#65306
    end
    object btnMainDrink: TSpeedButton
      Left = 621
      Top = 171
      Width = 55
      Height = 27
      Caption = #27979#37202
      OnClick = btnMainDrinkClick
    end
    object Label6: TLabel
      Left = 500
      Top = 139
      Width = 80
      Height = 16
      Caption = #20241#24687#26102#38271#65306
    end
    object lblMainVerifyResult: TLabel
      Left = 334
      Top = 172
      Width = 128
      Height = 16
      Caption = #39564#35777#32467#26524#65306#26410#39564#35777
      Font.Charset = GB2312_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object lblMainRestHint: TLabel
      Left = 672
      Top = 137
      Width = 64
      Height = 16
      Caption = #20241#24687#20805#36275
      Font.Charset = GB2312_CHARSET
      Font.Color = clMaroon
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentFont = False
    end
    object Label8: TLabel
      Left = 259
      Top = 24
      Width = 80
      Height = 16
      Caption = #24378#20241#26102#38388#65306
    end
    object Label9: TLabel
      Left = 259
      Top = 56
      Width = 80
      Height = 16
      Caption = #20986#21220#26102#38388#65306
    end
    object Label10: TLabel
      Left = 21
      Top = 141
      Width = 80
      Height = 16
      Caption = #20837#23507#26102#38388#65306
    end
    object Label11: TLabel
      Left = 259
      Top = 141
      Width = 80
      Height = 16
      Caption = #31163#23507#26102#38388#65306
    end
    object edtTrainNo: TEdit
      Left = 97
      Top = 22
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 0
    end
    object edtStartTime: TEdit
      Left = 576
      Top = 54
      Width = 160
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
    end
    object edtMainDriver: TEdit
      Left = 96
      Top = 100
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 2
    end
    object edtMainDriverState: TEdit
      Left = 339
      Top = 100
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 3
    end
    object edtCallTime: TEdit
      Left = 577
      Top = 22
      Width = 160
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 4
    end
    object edtTrainmanTypeName: TEdit
      Left = 97
      Top = 54
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object CombMainDrinkResult: TComboBox
      Left = 576
      Top = 99
      Width = 160
      Height = 24
      Style = csDropDownList
      Enabled = False
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 6
      Text = #26410#27979#37202
      Items.Strings = (
        #26410#27979#37202
        #27491#24120
        #39278#37202
        #37207#37202)
    end
    object Panel1: TPanel
      Left = 21
      Top = 86
      Width = 715
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 7
    end
    object Panel2: TPanel
      Left = 20
      Top = 209
      Width = 716
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 8
    end
    object edtMainDriverRestLength: TEdit
      Left = 577
      Top = 136
      Width = 85
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 9
    end
    object edtSigninTime: TEdit
      Left = 340
      Top = 22
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 10
    end
    object edtOutDutyTime: TEdit
      Left = 339
      Top = 54
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 11
    end
    object edtMainInTime: TEdit
      Left = 97
      Top = 140
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 12
    end
    object edtMainOutTime: TEdit
      Left = 338
      Top = 136
      Width = 150
      Height = 22
      Color = 15330541
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ParentCtl3D = False
      ParentFont = False
      ReadOnly = True
      TabOrder = 13
    end
    object pSubDriver: TPanel
      Left = 4
      Top = 215
      Width = 753
      Height = 120
      BevelOuter = bvNone
      TabOrder = 14
      object lblSubDriver: TLabel
        Left = 26
        Top = 59
        Width = 64
        Height = 16
        Caption = #21103#21496#26426#65306
      end
      object Label12: TLabel
        Left = 10
        Top = 28
        Width = 80
        Height = 16
        Caption = #20837#23507#26102#38388#65306
      end
      object Label13: TLabel
        Left = 260
        Top = 32
        Width = 80
        Height = 16
        Caption = #31163#23507#26102#38388#65306
      end
      object lblSubDriverState: TLabel
        Left = 292
        Top = 61
        Width = 48
        Height = 16
        Caption = #29366#24577#65306
      end
      object lblSubDriverRestLength: TLabel
        Left = 500
        Top = 60
        Width = 80
        Height = 16
        Caption = #20241#24687#26102#38271#65306
      end
      object lblSubDrinkResult: TLabel
        Left = 501
        Top = 31
        Width = 80
        Height = 16
        Caption = #27979#37202#32467#26524#65306
      end
      object lblSubRestHint: TLabel
        Left = 672
        Top = 64
        Width = 64
        Height = 16
        Caption = #20241#24687#20805#36275
        Font.Charset = GB2312_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object btnSubInput: TSpeedButton
        Left = 682
        Top = 88
        Width = 55
        Height = 27
        Caption = #24037#21495
        OnClick = btnSubInputClick
      end
      object btnSubDrink: TSpeedButton
        Left = 619
        Top = 88
        Width = 55
        Height = 27
        Caption = #27979#37202
        OnClick = btnSubDrinkClick
      end
      object btnSubFinger: TSpeedButton
        Left = 558
        Top = 88
        Width = 55
        Height = 27
        Caption = #25351#32441
        OnClick = btnSubFingerClick
      end
      object lblSubVerifyResult: TLabel
        Left = 340
        Top = 86
        Width = 128
        Height = 16
        Caption = #39564#35777#32467#26524#65306#26410#39564#35777
        Font.Charset = GB2312_CHARSET
        Font.Color = clMaroon
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentFont = False
      end
      object edtSubDriver: TEdit
        Left = 94
        Top = 58
        Width = 150
        Height = 22
        Color = 15330541
        Ctl3D = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 0
      end
      object edtSubInTime: TEdit
        Left = 94
        Top = 30
        Width = 150
        Height = 22
        Color = 15330541
        Ctl3D = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 1
      end
      object edtSubDriverState: TEdit
        Left = 334
        Top = 58
        Width = 150
        Height = 22
        Color = 15330541
        Ctl3D = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 2
      end
      object edtSubOutTime: TEdit
        Left = 334
        Top = 30
        Width = 150
        Height = 22
        Color = 15330541
        Ctl3D = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 3
      end
      object CombSubDrinkResult: TComboBox
        Left = 576
        Top = 28
        Width = 160
        Height = 24
        Style = csDropDownList
        Enabled = False
        ItemHeight = 16
        ItemIndex = 0
        TabOrder = 4
        Text = #26410#27979#37202
        Items.Strings = (
          #26410#27979#37202
          #27491#24120
          #39278#37202
          #37207#37202)
      end
      object edtSubDriverRestLength: TEdit
        Left = 577
        Top = 58
        Width = 85
        Height = 22
        Color = 15330541
        Ctl3D = False
        Font.Charset = GB2312_CHARSET
        Font.Color = clBlack
        Font.Height = -16
        Font.Name = #23435#20307
        Font.Style = []
        ParentCtl3D = False
        ParentFont = False
        ReadOnly = True
        TabOrder = 5
      end
    end
  end
  object actLstLogin: TActionList
    Left = 440
    object actCancel: TAction
      Caption = 'Esc'#20107#20214
      ShortCut = 27
      OnExecute = actCancelExecute
    end
    object actEnter: TAction
      Caption = #22238#36710#20107#20214
      ShortCut = 13
      OnExecute = actEnterExecute
    end
  end
end
