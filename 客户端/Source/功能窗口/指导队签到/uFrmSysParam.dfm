object FrmSysParam: TFrmSysParam
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = #21442#25968#35774#32622
  ClientHeight = 328
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    474
    328)
  PixelsPerInch = 96
  TextHeight = 12
  object Label10: TLabel
    Left = 36
    Top = 32
    Width = 60
    Height = 12
    Caption = #25152#22312#36710#38388#65306
  end
  object Label11: TLabel
    Left = 244
    Top = 32
    Width = 48
    Height = 12
    Caption = #25351#23548#32452#65306
  end
  object Label14: TLabel
    Left = 36
    Top = 132
    Width = 180
    Height = 12
    Caption = #31614#21040#21518#65292#22810#38271#26102#38388#21518#35748#20026#26159#31614#36864#65306
  end
  object Label1: TLabel
    Left = 301
    Top = 132
    Width = 24
    Height = 12
    Caption = #20998#38047
  end
  object Bevel1: TBevel
    Left = 0
    Top = 270
    Width = 472
    Height = 2
    Shape = bsTopLine
  end
  object cmbWorkShop: TRzComboBox
    Left = 102
    Top = 29
    Width = 100
    Height = 20
    Style = csDropDownList
    Ctl3D = True
    ItemHeight = 0
    ParentCtl3D = False
    TabOrder = 0
    OnChange = cmbWorkShopChange
  end
  object cmbGuideGroup: TRzComboBox
    Left = 298
    Top = 29
    Width = 85
    Height = 20
    Style = csDropDownList
    ItemHeight = 0
    TabOrder = 1
  end
  object edtSignSpanMinutes: TRzNumericEdit
    Left = 222
    Top = 129
    Width = 73
    Height = 20
    Alignment = taLeftJustify
    TabOrder = 2
    Max = 360.000000000000000000
    Value = 20.000000000000000000
    DisplayFormat = '0'
  end
  object chkAutoFillGroupGUID: TRzCheckBox
    Left = 36
    Top = 84
    Width = 338
    Height = 17
    Caption = #21496#26426#34920#20013#25351#23548#38431#20026#31354#26102#65292#31614#21040#26102#33258#21160#22635#20889#25351#23548#38431
    Checked = True
    State = cbChecked
    TabOrder = 3
  end
  object btnSaveParam: TButton
    Left = 237
    Top = 285
    Width = 80
    Height = 25
    Caption = #20445#23384#21442#25968
    TabOrder = 4
    OnClick = btnSaveParamClick
  end
  object btnClose: TButton
    Left = 350
    Top = 285
    Width = 80
    Height = 25
    Anchors = [akTop, akRight]
    Cancel = True
    Caption = #20851#38381
    TabOrder = 5
    OnClick = btnCloseClick
  end
end
