object frmOutRoom: TfrmOutRoom
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #31163#23507#30331#35760
  ClientHeight = 472
  ClientWidth = 555
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poMainFormCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 16
  object RzGroupBox1: TRzGroupBox
    Left = 18
    Top = 384
    Width = 513
    Height = 61
    Caption = #20844#23507#20449#24687
    TabOrder = 0
    object Label3: TLabel
      Left = 21
      Top = 27
      Width = 80
      Height = 16
      Caption = #20241#24687#25151#38388#65306
    end
    object btnCancel: TSpeedButton
      Left = 415
      Top = 21
      Width = 70
      Height = 30
      Caption = #20851#38381
      Flat = True
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
    object btnSave: TSpeedButton
      Left = 309
      Top = 21
      Width = 100
      Height = 30
      Caption = #30830#35748#31163#23507
      Flat = True
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
    object CombRoom: TComboBox
      Left = 94
      Top = 23
      Width = 129
      Height = 24
      AutoDropDown = True
      BevelInner = bvNone
      BevelOuter = bvNone
      Ctl3D = False
      Font.Charset = GB2312_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = []
      ItemHeight = 0
      ParentCtl3D = False
      ParentFont = False
      TabOrder = 0
      Text = #26410#20998#37197
    end
  end
  object rzgrpbx2: TRzGroupBox
    Left = 18
    Top = 18
    Width = 513
    Height = 354
    Caption = #31614#21040#20449#24687
    TabOrder = 1
    object Label1: TLabel
      Left = 21
      Top = 24
      Width = 80
      Height = 16
      Caption = #24453#29677#36710#27425#65306
    end
    object Label2: TLabel
      Left = 262
      Top = 86
      Width = 80
      Height = 16
      Caption = #24320#36710#26102#38388#65306
    end
    object lblMainDriver: TLabel
      Left = 37
      Top = 132
      Width = 64
      Height = 16
      Caption = #27491#21496#26426#65306
    end
    object Label4: TLabel
      Left = 282
      Top = 132
      Width = 48
      Height = 16
      Caption = #29366#24577#65306
    end
    object Label5: TLabel
      Left = 261
      Top = 56
      Width = 80
      Height = 16
      Caption = #21483#29677#26102#38388#65306
    end
    object Label6: TLabel
      Left = 261
      Top = 24
      Width = 80
      Height = 16
      Caption = #21333#21452#21496#26426#65306
    end
    object btnMainInput: TSpeedButton
      Left = 431
      Top = 197
      Width = 55
      Height = 27
      Caption = #24037#21495
      OnClick = btnMainInputClick
    end
    object btnMainFinger: TSpeedButton
      Left = 354
      Top = 197
      Width = 55
      Height = 27
      Caption = #25351#32441
      OnClick = btnMainFingerClick
    end
    object lblMainVerifyResult: TLabel
      Left = 32
      Top = 206
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
    object Label7: TLabel
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
    object Label10: TLabel
      Left = 17
      Top = 162
      Width = 80
      Height = 16
      Caption = #20837#23507#26102#38388#65306
    end
    object Label11: TLabel
      Left = 256
      Top = 164
      Width = 80
      Height = 16
      Caption = #31163#23507#26102#38388#65306
    end
    object edtTrainNo: TEdit
      Left = 94
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
      Left = 337
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
      Left = 93
      Top = 131
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
      Left = 337
      Top = 131
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
      Left = 337
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
      Left = 337
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
    object Panel1: TPanel
      Left = 21
      Top = 117
      Width = 466
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 6
    end
    object Panel2: TPanel
      Left = 20
      Top = 230
      Width = 466
      Height = 2
      BevelOuter = bvLowered
      TabOrder = 7
    end
    object edtSigninTime: TEdit
      Left = 94
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
      TabOrder = 8
    end
    object edtOutDutyTime: TEdit
      Left = 94
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
      TabOrder = 9
    end
    object edtMainInTime: TEdit
      Left = 93
      Top = 163
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
    object edtMainOutTime: TEdit
      Left = 335
      Top = 163
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
    object pSubDriver: TPanel
      Left = 10
      Top = 241
      Width = 488
      Height = 99
      BevelOuter = bvNone
      TabOrder = 12
      object lblSubDriver: TLabel
        Left = 25
        Top = 11
        Width = 64
        Height = 16
        Caption = #21103#21496#26426#65306
      end
      object Label9: TLabel
        Left = 8
        Top = 40
        Width = 80
        Height = 16
        Caption = #20837#23507#26102#38388#65306
      end
      object lblSubVerifyResult: TLabel
        Left = 12
        Top = 73
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
      object Label12: TLabel
        Left = 247
        Top = 42
        Width = 80
        Height = 16
        Caption = #31163#23507#26102#38388#65306
      end
      object lblSubDriverState: TLabel
        Left = 277
        Top = 11
        Width = 48
        Height = 16
        Caption = #29366#24577#65306
      end
      object btnSubFinger: TSpeedButton
        Left = 345
        Top = 67
        Width = 55
        Height = 27
        Caption = #25351#32441
        OnClick = btnSubFingerClick
      end
      object btnSubInput: TSpeedButton
        Left = 422
        Top = 67
        Width = 55
        Height = 27
        Caption = #24037#21495
        OnClick = btnSubInputClick
      end
      object edtSubDriver: TEdit
        Left = 84
        Top = 9
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
        Left = 84
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
      object edtSubDriverState: TEdit
        Left = 326
        Top = 9
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
        Left = 326
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
        TabOrder = 3
      end
    end
  end
  object actLstLogin: TActionList
    Left = 432
    Top = 65528
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
