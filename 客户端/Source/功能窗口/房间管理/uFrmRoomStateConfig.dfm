object frmRoomStateConfig: TfrmRoomStateConfig
  Left = 0
  Top = 0
  BorderStyle = bsSingle
  Caption = #26174#31034#35774#32622
  ClientHeight = 372
  ClientWidth = 461
  Color = clScrollBar
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
  object Panel1: TPanel
    Left = 0
    Top = 311
    Width = 461
    Height = 61
    Align = alBottom
    TabOrder = 0
    object btnOK: TButton
      Left = 254
      Top = 16
      Width = 96
      Height = 33
      Caption = #30830#23450
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnOKClick
    end
    object btnCancel: TButton
      Left = 356
      Top = 16
      Width = 93
      Height = 33
      Caption = #21462#28040
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 461
    Height = 311
    ActivePage = TabSheet3
    Align = alClient
    TabOrder = 1
    object TabSheet1: TTabSheet
      Caption = #28378#21160#25991#26412
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label2: TLabel
        Left = 8
        Top = 19
        Width = 60
        Height = 13
        Caption = #28378#21160#25991#26412#65306
      end
      object Label9: TLabel
        Left = 24
        Top = 160
        Width = 84
        Height = 13
        Caption = #28378#21160#23383#20307#22823#23567#65306
      end
      object Label10: TLabel
        Left = 57
        Top = 123
        Width = 48
        Height = 13
        Caption = #27599#27425#28378#21160
      end
      object Label11: TLabel
        Left = 188
        Top = 123
        Width = 24
        Height = 13
        Caption = #20687#32032
      end
      object Label3: TLabel
        Left = 267
        Top = 123
        Width = 60
        Height = 13
        Caption = #28378#21160#39057#29575#65306
      end
      object Label18: TLabel
        Left = 248
        Top = 165
        Width = 84
        Height = 13
        Caption = #28378#21160#23383#20307#39068#33394#65306
      end
      object Label19: TLabel
        Left = 45
        Top = 201
        Width = 60
        Height = 13
        Caption = #28378#21160#32972#26223#65306
      end
      object mmoText: TMemo
        Left = 74
        Top = 16
        Width = 367
        Height = 89
        TabOrder = 0
      end
      object edtSpeed: TEdit
        Left = 111
        Top = 120
        Width = 71
        Height = 21
        TabOrder = 1
        Text = '2'
      end
      object edtScorllFont: TEdit
        Left = 114
        Top = 157
        Width = 71
        Height = 21
        TabOrder = 2
        Text = '10'
      end
      object edtInterval: TEdit
        Left = 333
        Top = 120
        Width = 71
        Height = 21
        ReadOnly = True
        TabOrder = 3
        Text = '200'
      end
      object clrbxScorlFontCL: TColorBox
        Left = 335
        Top = 162
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 4
      end
      object clrbxScorlBKCL: TColorBox
        Left = 111
        Top = 198
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 5
      end
    end
    object TabSheet2: TTabSheet
      Caption = #25151#38388#20154#21592
      ImageIndex = 1
      ExplicitLeft = 8
      ExplicitTop = 22
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label8: TLabel
        Left = 16
        Top = 22
        Width = 84
        Height = 13
        Caption = #26368#22823#25151#38388#20154#25968#65306
      end
      object Label4: TLabel
        Left = 40
        Top = 58
        Width = 60
        Height = 13
        Caption = #25151#38388#34892#23485#65306
      end
      object Label5: TLabel
        Left = 208
        Top = 58
        Width = 84
        Height = 13
        Caption = #25151#38388#23383#20307#22823#23567#65306
      end
      object Label15: TLabel
        Left = 208
        Top = 94
        Width = 84
        Height = 13
        Caption = #25151#38388#23383#20307#39068#33394#65306
      end
      object Label14: TLabel
        Left = 40
        Top = 93
        Width = 60
        Height = 13
        Caption = #25151#38388#32972#26223#65306
      end
      object Label6: TLabel
        Left = 40
        Top = 130
        Width = 60
        Height = 13
        Caption = #20154#21592#34892#23485#65306
      end
      object Label7: TLabel
        Left = 208
        Top = 130
        Width = 84
        Height = 13
        Caption = #20154#21592#23383#20307#22823#23567#65306
      end
      object Label17: TLabel
        Left = 208
        Top = 166
        Width = 84
        Height = 13
        Caption = #20154#21592#23383#20307#39068#33394#65306
      end
      object Label16: TLabel
        Left = 40
        Top = 166
        Width = 60
        Height = 13
        Caption = #20154#21592#32972#26223#65306
      end
      object Label12: TLabel
        Left = 40
        Top = 205
        Width = 60
        Height = 13
        Caption = #21047#26032#39057#29575#65306
      end
      object Label13: TLabel
        Left = 183
        Top = 205
        Width = 12
        Height = 13
        Caption = #31186
      end
      object Label1: TLabel
        Left = 232
        Top = 206
        Width = 60
        Height = 13
        Caption = #26174#31034#21015#25968#65306
      end
      object Label29: TLabel
        Left = 256
        Top = 21
        Width = 36
        Height = 13
        Caption = #21015#23485#65306
      end
      object edtRoomMaxCount: TEdit
        Left = 106
        Top = 19
        Width = 71
        Height = 21
        TabOrder = 0
        Text = '1'
      end
      object edtRoomWidth: TEdit
        Left = 106
        Top = 55
        Width = 71
        Height = 21
        TabOrder = 1
        Text = '10'
      end
      object edtRoomFont: TEdit
        Left = 298
        Top = 55
        Width = 71
        Height = 21
        TabOrder = 2
        Text = '10'
      end
      object clrbxRoomFont: TColorBox
        Left = 298
        Top = 91
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 3
      end
      object clrbxRoomBK: TColorBox
        Left = 106
        Top = 90
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 4
      end
      object edtTrainmanWidth: TEdit
        Left = 106
        Top = 127
        Width = 71
        Height = 21
        TabOrder = 5
        Text = '10'
      end
      object edtTrainmanFont: TEdit
        Left = 298
        Top = 127
        Width = 71
        Height = 21
        TabOrder = 6
        Text = '10'
      end
      object clrbxTrainmanFont: TColorBox
        Left = 298
        Top = 163
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 7
      end
      object clrbxTrainmanBK: TColorBox
        Left = 106
        Top = 163
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 8
      end
      object edtRefresh: TEdit
        Left = 106
        Top = 202
        Width = 71
        Height = 21
        TabOrder = 9
        Text = '1'
      end
      object edtColCount: TEdit
        Left = 298
        Top = 202
        Width = 71
        Height = 21
        TabOrder = 10
        Text = '8'
      end
      object edtColWidth: TEdit
        Left = 298
        Top = 18
        Width = 71
        Height = 21
        TabOrder = 11
        Text = '8'
      end
    end
    object TabSheet3: TTabSheet
      Caption = #26102#38388#21450#23433#20840
      ImageIndex = 2
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object Label20: TLabel
        Left = 16
        Top = 40
        Width = 84
        Height = 13
        Caption = #26102#38388#23383#20307#22823#23567#65306
      end
      object Label21: TLabel
        Left = 40
        Top = 78
        Width = 60
        Height = 13
        Caption = #26102#38388#32972#26223#65306
      end
      object Label22: TLabel
        Left = 226
        Top = 40
        Width = 84
        Height = 13
        Caption = #26102#38388#23383#20307#39068#33394#65306
      end
      object Label23: TLabel
        Left = 16
        Top = 120
        Width = 84
        Height = 13
        Caption = #23433#20840#23383#20307#22823#23567#65306
      end
      object Label24: TLabel
        Left = 226
        Top = 120
        Width = 84
        Height = 13
        Caption = #23433#20840#23383#20307#39068#33394#65306
      end
      object Label25: TLabel
        Left = 40
        Top = 158
        Width = 60
        Height = 13
        Caption = #23433#20840#32972#26223#65306
      end
      object Label26: TLabel
        Left = 40
        Top = 208
        Width = 60
        Height = 13
        Caption = #23433#20840#22825#25968#65306
      end
      object Label27: TLabel
        Left = 250
        Top = 78
        Width = 60
        Height = 13
        Caption = #26102#38388#23485#24230#65306
      end
      object Label28: TLabel
        Left = 250
        Top = 158
        Width = 60
        Height = 13
        Caption = #23433#20840#23485#24230#65306
      end
      object edtTimeFontSize: TEdit
        Left = 106
        Top = 37
        Width = 71
        Height = 21
        TabOrder = 0
        Text = '10'
      end
      object clrbxTimeBKCL: TColorBox
        Left = 106
        Top = 75
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 1
      end
      object clrbxTimeFontCL: TColorBox
        Left = 316
        Top = 37
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 2
      end
      object edtSafeFontSize: TEdit
        Left = 106
        Top = 117
        Width = 71
        Height = 21
        TabOrder = 3
        Text = '10'
      end
      object clrbxSafeFontCL: TColorBox
        Left = 316
        Top = 117
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 4
      end
      object clrbxSafeBKCL: TColorBox
        Left = 106
        Top = 155
        Width = 87
        Height = 22
        ItemHeight = 16
        TabOrder = 5
      end
      object edtSafeDays: TEdit
        Left = 106
        Top = 205
        Width = 71
        Height = 21
        TabOrder = 6
        Text = '10'
      end
      object btnConfig: TButton
        Left = 182
        Top = 203
        Width = 55
        Height = 25
        Caption = #35774#32622
        TabOrder = 7
        OnClick = btnConfigClick
      end
      object edtTimeWidth: TEdit
        Left = 316
        Top = 75
        Width = 71
        Height = 21
        TabOrder = 8
        Text = '10'
      end
      object edtSafeWidth: TEdit
        Left = 316
        Top = 155
        Width = 71
        Height = 21
        TabOrder = 9
        Text = '10'
      end
    end
  end
end
