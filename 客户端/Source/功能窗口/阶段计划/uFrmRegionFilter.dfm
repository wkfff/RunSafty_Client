object FrmRegionFilter: TFrmRegionFilter
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = #21306#27573#23545#24212#35774#32622
  ClientHeight = 428
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Bevel1: TBevel
    Left = 8
    Top = 383
    Width = 523
    Height = 2
  end
  object Bevel2: TBevel
    Left = 62
    Top = 14
    Width = 203
    Height = 2
    Shape = bsTopLine
  end
  object Label1: TLabel
    Left = 8
    Top = 8
    Width = 48
    Height = 13
    Caption = #34892#36710#21306#27573
  end
  object Bevel3: TBevel
    Left = 330
    Top = 14
    Width = 201
    Height = 2
    Shape = bsTopLine
  end
  object Label2: TLabel
    Left = 273
    Top = 8
    Width = 51
    Height = 13
    Caption = 'TDMS'#21306#27573
  end
  object chkLstRegions: TRzCheckList
    Left = 273
    Top = 24
    Width = 258
    Height = 353
    OnChange = chkLstRegionsChange
    FrameVisible = True
    ItemHeight = 17
    TabOrder = 0
  end
  object lstBoxJl: TRzListBox
    Left = 8
    Top = 24
    Width = 257
    Height = 353
    FrameVisible = True
    ItemHeight = 24
    Items.Strings = (
      'saf'
      'asdf'
      'asd'
      'fasdf')
    Style = lbOwnerDrawFixed
    TabOrder = 1
    OnClick = lstBoxJlClick
  end
  object Button1: TButton
    Left = 377
    Top = 391
    Width = 75
    Height = 25
    Caption = #30830#23450
    TabOrder = 2
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 458
    Top = 391
    Width = 75
    Height = 25
    Caption = #21462#28040
    TabOrder = 3
    OnClick = Button2Click
  end
end
