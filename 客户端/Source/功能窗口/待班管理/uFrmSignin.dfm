object frmSignin: TfrmSignin
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #20056#21153#21592#31614#21040
  ClientHeight = 421
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = ANSI_CHARSET
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
    Left = 348
    Top = 375
    Width = 100
    Height = 30
    Caption = #30830#35748#31614#21040
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
    Left = 454
    Top = 375
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
  object lblEditTrainman: TLabel
    Left = 16
    Top = 380
    Width = 144
    Height = 16
    Cursor = crHandPoint
    Caption = #20056#21153#21592#20449#24687#28155#21152#20462#25913
    Color = clBtnFace
    Font.Charset = GB2312_CHARSET
    Font.Color = clBlue
    Font.Height = -16
    Font.Name = #23435#20307
    Font.Style = [fsUnderline]
    ParentColor = False
    ParentFont = False
    OnClick = lblEditTrainmanClick
  end
  object rzgrpbx2: TRzGroupBox
    Left = 16
    Top = 27
    Width = 508
    Height = 342
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
      Left = 259
      Top = 86
      Width = 80
      Height = 16
      Caption = #24320#36710#26102#38388#65306
    end
    object lblMainDriver: TLabel
      Left = 32
      Top = 130
      Width = 64
      Height = 16
      Caption = #27491#21496#26426#65306
    end
    object Label4: TLabel
      Left = 282
      Top = 130
      Width = 48
      Height = 16
      Caption = #29366#24577#65306
    end
    object Label3: TLabel
      Left = 258
      Top = 56
      Width = 80
      Height = 16
      Caption = #21483#29677#26102#38388#65306
    end
    object Label5: TLabel
      Left = 255
      Top = 25
      Width = 80
      Height = 16
      Caption = #21333#21452#21496#26426#65306
    end
    object btnMainInput: TSpeedButton
      Left = 426
      Top = 194
      Width = 55
      Height = 27
      Caption = #24037#21495
      OnClick = btnMainInputClick
    end
    object btnMainFinger: TSpeedButton
      Left = 310
      Top = 194
      Width = 55
      Height = 27
      Caption = #25351#32441
      OnClick = btnMainFingerClick
    end
    object Label7: TLabel
      Left = 258
      Top = 165
      Width = 80
      Height = 16
      Caption = #27979#37202#32467#26524#65306
    end
    object btnMainDrink: TSpeedButton
      Left = 371
      Top = 194
      Width = 55
      Height = 27
      Caption = #27979#37202
      OnClick = btnMainDrinkClick
    end
    object Label6: TLabel
      Left = 21
      Top = 56
      Width = 80
      Height = 16
      Caption = #24378#20241#26102#38388#65306
    end
    object Label8: TLabel
      Left = 21
      Top = 86
      Width = 80
      Height = 16
      Caption = #20986#21220#26102#38388#65306
    end
    object Label9: TLabel
      Left = 20
      Top = 163
      Width = 80
      Height = 16
      Caption = #31614#21040#26102#38388#65306
    end
    object btnMainCancel: TSpeedButton
      Left = 90
      Top = 194
      Width = 91
      Height = 27
      Caption = #25764#38144#31614#21040
      OnClick = btnMainCancelClick
    end
    object edtTrainNo: TEdit
      Left = 95
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
      Left = 332
      Top = 84
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
    object edtMainDriver: TEdit
      Left = 94
      Top = 129
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
      Left = 332
      Top = 129
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
      Left = 332
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
      TabOrder = 4
    end
    object edtTrainmanTypeName: TEdit
      Left = 332
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
      TabOrder = 5
    end
    object CombMainDrinkResult: TComboBox
      Left = 331
      Top = 162
      Width = 150
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
      Top = 113
      Width = 461
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 7
    end
    object Panel2: TPanel
      Left = 20
      Top = 227
      Width = 461
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 8
    end
    object edtSigninTime: TEdit
      Left = 95
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
      TabOrder = 9
    end
    object edtOutDutyTime: TEdit
      Left = 95
      Top = 84
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
    object edtMainSigninTime: TEdit
      Left = 95
      Top = 162
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
  end
  object pSubDriver: TPanel
    Left = 23
    Top = 254
    Width = 497
    Height = 99
    BevelOuter = bvNone
    TabOrder = 1
    object lblSubDriver: TLabel
      Left = 31
      Top = 14
      Width = 64
      Height = 16
      Caption = #21103#21496#26426#65306
    end
    object Label10: TLabel
      Left = 15
      Top = 43
      Width = 80
      Height = 16
      Caption = #31614#21040#26102#38388#65306
    end
    object lblSubDrinkResult: TLabel
      Left = 253
      Top = 45
      Width = 80
      Height = 16
      Caption = #27979#37202#32467#26524#65306
    end
    object lblSubDriverState: TLabel
      Left = 278
      Top = 14
      Width = 48
      Height = 16
      Caption = #29366#24577#65306
    end
    object btnSubFinger: TSpeedButton
      Left = 306
      Top = 73
      Width = 55
      Height = 27
      Caption = #25351#32441
      OnClick = btnSubFingerClick
    end
    object btnSubDrink: TSpeedButton
      Left = 365
      Top = 73
      Width = 55
      Height = 27
      Caption = #27979#37202
      OnClick = btnSubDrinkClick
    end
    object btnSubInput: TSpeedButton
      Left = 423
      Top = 73
      Width = 55
      Height = 27
      Caption = #24037#21495
      OnClick = btnSubInputClick
    end
    object btnSubCancel: TSpeedButton
      Left = 88
      Top = 73
      Width = 91
      Height = 27
      Caption = #25764#38144#31614#21040
      OnClick = btnSubCancelClick
    end
    object edtSubDriver: TEdit
      Left = 90
      Top = 13
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
    object edtSubSigninTime: TEdit
      Left = 90
      Top = 41
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
    object CombSubDrinkResult: TComboBox
      Left = 327
      Top = 42
      Width = 150
      Height = 24
      Style = csDropDownList
      Enabled = False
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 2
      Text = #26410#27979#37202
      Items.Strings = (
        #26410#27979#37202
        #27491#24120
        #39278#37202
        #37207#37202)
    end
    object edtSubDriverState: TEdit
      Left = 327
      Top = 12
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
  end
  object actLstLogin: TActionList
    Left = 384
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
