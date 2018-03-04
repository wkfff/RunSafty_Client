object frmMain_RoomSign: TfrmMain_RoomSign
  Left = 0
  Top = 0
  Caption = #20844#23507#31614#21040#31649#29702
  ClientHeight = 722
  ClientWidth = 1259
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pMain: TPanel
    Left = 0
    Top = 0
    Width = 1259
    Height = 696
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 5
    TabOrder = 0
    object PageControl1: TPageControl
      Left = 5
      Top = 5
      Width = 1249
      Height = 686
      ActivePage = tabCall
      Align = alClient
      Style = tsFlatButtons
      TabOrder = 0
      object tabCall: TTabSheet
        Caption = #20844#23507#21483#29677#31649#29702
        ImageIndex = 1
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object Splitter1: TSplitter
          Left = 0
          Top = 212
          Width = 1241
          Height = 0
          Cursor = crVSplit
          Align = alTop
          Beveled = True
          MinSize = 200
          ExplicitTop = 285
          ExplicitWidth = 1278
        end
        object Splitter2: TSplitter
          Left = 0
          Top = 209
          Width = 1241
          Height = 3
          Cursor = crVSplit
          Align = alTop
          ExplicitWidth = 451
        end
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 1241
          Height = 41
          Align = alTop
          BevelEdges = [beLeft, beTop, beRight]
          BevelInner = bvRaised
          BevelOuter = bvLowered
          Ctl3D = False
          ParentCtl3D = False
          TabOrder = 0
          DesignSize = (
            1241
            41)
          object lblCallCount: TLabel
            Left = 914
            Top = 15
            Width = 322
            Height = 14
            Anchors = [akTop, akRight]
            Caption = #24403#21069#20849#26377'0'#26465#24378#20241#35745#21010#65292#20854#20013'0'#26465#26410#21483#29677',0'#26465#24050#21483#29677#12290
            Color = clBtnFace
            Font.Charset = GB2312_CHARSET
            Font.Color = clRed
            Font.Height = -14
            Font.Name = #23435#20307
            Font.Style = []
            ParentColor = False
            ParentFont = False
            ExplicitLeft = 578
          end
          object btnOutRoom: TSpeedButton
            Left = 106
            Top = 8
            Width = 92
            Height = 27
            Caption = #20986#23507'(&F4)'
            Flat = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFCFDFE91B5CF306FA12D699A5985AEE3EA
              F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF8DB8D21E
              71A72B8BBD34A3D9339FD92779B38BACC9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFC1DAE81F79AD3098C64BC8E347C5E7299DC828B6E42E97D04D84
              AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF67A8CA2F8EBD388CBA2B78AF42
              97C60C5B95094A881C92CE34A7DD387AABFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              4298C431A0C8579EC873BDDE82DEF659B4DA0D5D911680BD25B2F33DAEE24488
              B5FFFFFFFFFFFFFFFFFFFFFFFF53A7D032A7CF7ADDF22E77AF8CE0F678D0ED2C
              8AB81E8DC926B5EF209DDD44B5E53086BCFFFFFFFFFFFFFFFFFF7ABEDE3CB4DA
              7CD9EE4FAED43881B44092BD218BBC2EACDF30B9EE2192D21F9DDD44B7E82B96
              CFC0D7E6FFFFFFFFFFFF3AAAD769DDF282DDF22CA4CA2AAAD036A9D536A9DC36
              B8E92491CB2390CE24A6E345BAEB3CACE168A1C5FFFFFFFFFFFF5EC3E255D2EB
              9DE8F978E1F661D8F652D3F741C1EA31AADB2B9FD62697D127A7E02BAFE946B6
              E63989B9FFFFFFFFFFFFE0F4FA3BBEE027B3DA7ED3EBCBF0FB84DDF547C6EB3E
              BDE937B5E52DA6DC2CACE32BB0E948B9E82788C1FFFFFFFFFFFFFFFFFFFFFFFF
              EAF8FC60CAE658CBE6A9E0F3A2E3F84ACBF141C4EF3ABDEC33B8EB2EB4EA49BC
              EA2790CDFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8E8F439BFE08AD6EBB6
              EAFA56CEF142C3EE2BAFE937B0E843B8E84295C1FFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFE0F5FA2DB8DC6DCFE9BCEAF8B9E9F971CCF041B3EA3098
              D490BFD9FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF7D
              D4EB3FBCDE32B3D927AED535B6E2228FC62C8DC662A3C5FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEDF9FCDBF2F9F1FAFD8FD7EB32B4
              E044B5EB2485B8FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFF66C9E528AED667B6D9FFFFFF}
            Margin = 5
            OnClick = btnOutRoomClick
          end
          object btnInRoom: TSpeedButton
            Left = 8
            Top = 8
            Width = 92
            Height = 27
            Caption = #20837#23507'(&F3)'
            Flat = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
              E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5E5
              E5FFFFFFFFFFFFFFFFFFD9D9D9D9D9D99E9E9E72727272727272727272727272
              72727272727272727272727272729E9E9ED9D9D9D9D9D9FFFFFFFFFFFFFFFFFF
              898989FFFFFFFFFFFFFFFFFF898989898989898989FFFFFFFFFFFFFFFFFF8989
              89FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF898989FFFFFFFFFFFFFFFFFF89898989
              8989898989FFFFFFFFFFFFFFFFFF898989FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              898989FFFFFFFFFFFFFFFFFF898989898989898989FFFFFFFFFFFFFFFFFF8989
              89FFFFFFFFFFFFFFFFFFFFFFFFF4F4F4777777FFFFFFFFFFFFFFFFFF89898989
              8989898989FFFFFFFFFFFFFFFFFF777777F4F4F4FFFFFFFFFFFFF4F4F459C168
              1AC93361C96FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF61C96F1AC9
              3359C168F4F4F4FFFFFF6CD47B1AC9339EF8A81AC93361C96FFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFF61C96F1AC9339EF8A81AC9336CD47BFFFFFF1AC933A3FDAD
              5DED6D79F4881AC9335DC36BFFFFFFFFFFFFFFFFFF61C96F1AC93379F4885DED
              6DA3FDAD1AC933FFFFFF78DF871AC93383F9915AF16C83F9911AC93361C96FF8
              F8F861C96F1AC93383F9915AF16C83F9911AC93378DF87FFFFFFFFFFFF78DF87
              1AC9338BFF9B66F9798BFF9B1AC9334EB55D1AC9338BFF9B66F9798BFF9B1AC9
              3378DF87FFFFFFFFFFFFFFFFFFFFFFFF3EA44D1AC93397FFAA74FF8897FFAA1A
              C93397FFAA74FF8897FFAA1AC93378DF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              71717160C76F1AC933A1FFB680FF9980FF9980FF99A1FFB61AC93378DF87FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF717171D4D4D466CD751AC933A8FFC18A
              FFA7A8FFC11AC93378DF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              717171ECECECECECEC3EA44D1AC933CAFFDF1AC93378DF87FFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFABABAB717171717171ABABAB78DF871A
              C93378DF87FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            Margin = 5
            OnClick = btnInRoomClick
          end
          object btnCall: TSpeedButton
            Left = 204
            Top = 8
            Width = 105
            Height = 27
            Caption = #25163#24037#21483#29677'(&F6)'
            Flat = True
            Glyph.Data = {
              32050000424D3205000000000000320400002800000010000000100000000100
              08000000000000010000120B0000120B0000FF000000FF000000FBFBFB00F4F6
              F500F0F0F000F6F6F600F3F5F400D7FFEC00FFFDFF00E9F2ED00299960000A8B
              4900D6EAE0000D8A4900E5EDE900BFC6C20041B97D00CCDFD500C0FFDF00EEF4
              F10040B87C00FDFDFD001A955500FCFCFC009CB4A800277F4D004AD18D00DFDD
              DE00AEF0CE00C4D9CE0036AF7200C3DBCF00A4B1AA0088A3920000743400F0F4
              F20062DDA00087C8A500D5E5DB00D6E8E000007333009AADA1000786460032A5
              6800E0FFF4000084410052CF9000E3FEF200BEFDDD0081DDAE000D723F003185
              550074C19A0007753E0045996F003AB27A0043A6710081BC9D00E8EDEA00D1D3
              D200E4E6E5003FBB7D00D8E9E0002FA26800289F65004A8F6B00E6E3E500D4EC
              E000D7D3D50056D29400F9F5F700359D69001698580031A46B000D754000C4FF
              E300B5BCB8003FC08000BFD7CB008DF0BF005196730090F6C300138E4F002990
              5A0079BE9B00E3E3E300A0D5BC0085E4B400027C3E00DCF8ED0096D4B300DBFF
              F00055B18100A7F6CE00299C6000218F570071C79A005CCA9200FFFCFF002899
              6100ADF1CE00D9E9E000A1EFC8007DDBAC003D8E6400007E3E003A8F63001D8A
              5300C0FEDF00FAFBFB009EB2A800D2E5DC00EDF3F0001D92560031A76B0048BA
              880063DDA00015864D004EBC8B0057967400BDFADB00A9DBC50092D2B00082D9
              AB008ED3AF0044AD7700F2F3F20038AE7200EBE1E60088D7AE00FFF6FC0055C3
              8C004D9C7400A9B8B000FEF0F700B7DFCA0018834D0054AD7C00A5B9AE0099B0
              A400157F4A009BE9C20094B2A300E8FFFA009FF4C900ABFBD300259B5F00DFDB
              DD00BCC2BF0025995F0013854900D7EAE000FBF6F900269C5E005FD298006CA6
              88007CA8910039AE7300E7EEEB003EB1790000733400E7E7E7002780510063AB
              85005BC492001E955A0085E8B600E6DCE1003AB0750060D89C0038B57A000377
              3700FAF7F90047B67C00ADF0CE00A2B4AB000C7B4200D5FFEE00D3EBDF008BA4
              950057CD9200CED2CF00E5FFF800E5ECE800178C51004CC98A008AEBBA0090CC
              AC0048C28500AFFFD70063E2A300D4FFED00FFFFFF00BFBFBF00C0C0C000C1C1
              C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600C7C7C700C8C8C800C9C9
              C900CACACA00CBCBCB00CCCCCC00CDCDCD00CECECE00CFCFCF00D0D0D000D1D1
              D100D2D2D200D3D3D300D4D4D400D5D5D500D6D6D600D7D7D700D8D8D800D9D9
              D900DADADA00DBDBDB00DCDCDC00DDDDDD00DEDEDE00DFDFDF00E0E0E000E1E1
              E100E2E2E200E3E3E300E4E4E400E5E5E500E6E6E600E7E7E700E8E8E800E9E9
              E900EAEAEA00EBEBEB00ECECEC00EDEDED00EEEEEE00EFEFEF00F0F0F000F1F1
              F100F2F2F200F3F3F300F4F4F400F5F5F500F6F6F600F7F7F700F8F8F800F9F9
              F900FAFAFA00FBFBFB00FCFCFC00FDFDFD00FEFEFE00BEBEBEBEBE139C950A0C
              00BEBEBEBEBEBEBEBEBE2731A9209E26171F03BEBEBEBEBE7C4E09AE48303356
              672B683ABEBEBEBE75508A8673469D325245286603BEBE8314695DA33554537E
              A539340BB1BEBE3F93083E746D844019914282B6A06B04513D707125801B5A37
              B3A1906194B5075C7DA877600FAB4B127B1C9B476F3C07293BA221965E18432C
              B7BA0EA697630187B27A06448572BC22A7985F813638BE9AA45806AA9F794F4D
              B855652F9915BE0DAC7F2402B98EBB8F5B648B1A1EBEBEBE89BD782362496A10
              2E76AF8C00BEBEBE006C57B42A0505598D2D1602BEBEBEBEBEBE92AD4CB0411D
              884ABEBEBEBEBEBEBEBEBEBE016E1104BEBEBEBEBEBE}
            Margin = 5
            OnClick = btnCallClick
          end
          object btnLeaderExam: TSpeedButton
            Left = 315
            Top = 8
            Width = 110
            Height = 27
            Caption = #24178#37096#26816#26597'(&F8)'
            Flat = True
            Glyph.Data = {
              36030000424D3603000000000000360000002800000010000000100000000100
              18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
              B2B2B27B7B7B5050504D4D4D4D4D4D4D4D4D4D4D4D5050507B7B7BB2B2B2FFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFF8888884D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D
              4D4D4D4D4D4D4D4D4D4D4D4D4D4D868686FFFFFFFFFFFFFFFFFFADADAD4D4D4D
              5C5C5CC4C4C4FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFFBFBFBC4C4C45E5E5E4D4D
              4DADADADFFFFFFFFFFFF7B7B7B4D4D4DC9C9C9FFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFC9C9C94D4D4D7B7B7BFFFFFFFFFFFF5050504D4D4D
              FBFBFBFFFFFFFFFFFFFFFFFFFFFFFFC3C3C3A2A2A2FFFFFFFFFFFFFBFBFB4D4D
              4D505050FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFD1D1D15A
              5A5A565656C5C5C5FFFFFFFFFFFF4D4D4D4D4D4DFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFDBDBDB5C5C5C565656565656626262EBEBEBFFFFFF4D4D
              4D4D4D4DFFFFFFFFFFFF4D4D4D4D4D4DFFFFFFFFFFFFE7E7E76464645C5C5C8A
              8A8A5656565656567C7C7CFBFBFB4D4D4D4D4D4DFFFFFFFFFFFF4D4D4D4D4D4D
              FFFFFFFFFFFF6C6C6C707070E1E1E1FFFFFFABABAB565656565656A4A4A4D3D3
              D3646464FFFFFFFFFFFF5353534D4D4DF9F9F9FFFFFF989898F7F7F7FFFFFFFF
              FFFFFFFFFFB7B7B7565656565656CDCDCDF7F7F7FFFFFFFFFFFF7D7D7D4D4D4D
              CBCBCBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFC1C1C15858586262
              62EBEBEBFFFFFFFFFFFFABABAB4D4D4D606060C9C9C9FFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFDFDFDC9C9C95A5A5A7E7E7EFBFBFBFFFFFFFFFFFF838383
              4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D4D7D7D7DF0F0F0B7B7
              B75C5C5CA4A4A4FFFFFFFFFFFFFFFFFFADADAD7777774D4D4D4D4D4D4D4D4D4D
              4D4D4D4D4D4D4D4D777777ADADADFFFFFFD9D9D9646464FFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFE5E5E5FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
              FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
            Margin = 5
            OnClick = btnLeaderExamClick
          end
          object btnCallNow2: TSpeedButton
            Left = 431
            Top = 8
            Width = 105
            Height = 27
            Caption = #31435#21363#21483#29677
            Flat = True
            Glyph.Data = {
              32050000424D3205000000000000320400002800000010000000100000000100
              08000000000000010000120B0000120B0000FF000000FF000000FBFBFB00F4F6
              F500F0F0F000F6F6F600F3F5F400D7FFEC00FFFDFF00E9F2ED00299960000A8B
              4900D6EAE0000D8A4900E5EDE900BFC6C20041B97D00CCDFD500C0FFDF00EEF4
              F10040B87C00FDFDFD001A955500FCFCFC009CB4A800277F4D004AD18D00DFDD
              DE00AEF0CE00C4D9CE0036AF7200C3DBCF00A4B1AA0088A3920000743400F0F4
              F20062DDA00087C8A500D5E5DB00D6E8E000007333009AADA1000786460032A5
              6800E0FFF4000084410052CF9000E3FEF200BEFDDD0081DDAE000D723F003185
              550074C19A0007753E0045996F003AB27A0043A6710081BC9D00E8EDEA00D1D3
              D200E4E6E5003FBB7D00D8E9E0002FA26800289F65004A8F6B00E6E3E500D4EC
              E000D7D3D50056D29400F9F5F700359D69001698580031A46B000D754000C4FF
              E300B5BCB8003FC08000BFD7CB008DF0BF005196730090F6C300138E4F002990
              5A0079BE9B00E3E3E300A0D5BC0085E4B400027C3E00DCF8ED0096D4B300DBFF
              F00055B18100A7F6CE00299C6000218F570071C79A005CCA9200FFFCFF002899
              6100ADF1CE00D9E9E000A1EFC8007DDBAC003D8E6400007E3E003A8F63001D8A
              5300C0FEDF00FAFBFB009EB2A800D2E5DC00EDF3F0001D92560031A76B0048BA
              880063DDA00015864D004EBC8B0057967400BDFADB00A9DBC50092D2B00082D9
              AB008ED3AF0044AD7700F2F3F20038AE7200EBE1E60088D7AE00FFF6FC0055C3
              8C004D9C7400A9B8B000FEF0F700B7DFCA0018834D0054AD7C00A5B9AE0099B0
              A400157F4A009BE9C20094B2A300E8FFFA009FF4C900ABFBD300259B5F00DFDB
              DD00BCC2BF0025995F0013854900D7EAE000FBF6F900269C5E005FD298006CA6
              88007CA8910039AE7300E7EEEB003EB1790000733400E7E7E7002780510063AB
              85005BC492001E955A0085E8B600E6DCE1003AB0750060D89C0038B57A000377
              3700FAF7F90047B67C00ADF0CE00A2B4AB000C7B4200D5FFEE00D3EBDF008BA4
              950057CD9200CED2CF00E5FFF800E5ECE800178C51004CC98A008AEBBA0090CC
              AC0048C28500AFFFD70063E2A300D4FFED00FFFFFF00BFBFBF00C0C0C000C1C1
              C100C2C2C200C3C3C300C4C4C400C5C5C500C6C6C600C7C7C700C8C8C800C9C9
              C900CACACA00CBCBCB00CCCCCC00CDCDCD00CECECE00CFCFCF00D0D0D000D1D1
              D100D2D2D200D3D3D300D4D4D400D5D5D500D6D6D600D7D7D700D8D8D800D9D9
              D900DADADA00DBDBDB00DCDCDC00DDDDDD00DEDEDE00DFDFDF00E0E0E000E1E1
              E100E2E2E200E3E3E300E4E4E400E5E5E500E6E6E600E7E7E700E8E8E800E9E9
              E900EAEAEA00EBEBEB00ECECEC00EDEDED00EEEEEE00EFEFEF00F0F0F000F1F1
              F100F2F2F200F3F3F300F4F4F400F5F5F500F6F6F600F7F7F700F8F8F800F9F9
              F900FAFAFA00FBFBFB00FCFCFC00FDFDFD00FEFEFE00BEBEBEBEBE139C950A0C
              00BEBEBEBEBEBEBEBEBE2731A9209E26171F03BEBEBEBEBE7C4E09AE48303356
              672B683ABEBEBEBE75508A8673469D325245286603BEBE8314695DA33554537E
              A539340BB1BEBE3F93083E746D844019914282B6A06B04513D707125801B5A37
              B3A1906194B5075C7DA877600FAB4B127B1C9B476F3C07293BA221965E18432C
              B7BA0EA697630187B27A06448572BC22A7985F813638BE9AA45806AA9F794F4D
              B855652F9915BE0DAC7F2402B98EBB8F5B648B1A1EBEBEBE89BD782362496A10
              2E76AF8C00BEBEBE006C57B42A0505598D2D1602BEBEBEBEBEBE92AD4CB0411D
              884ABEBEBEBEBEBEBEBEBEBE016E1104BEBEBEBEBEBE}
            OnClick = btnCallNow2Click
          end
          object btnChanngeRoom: TSpeedButton
            Left = 542
            Top = 8
            Width = 105
            Height = 27
            Caption = #26356#25442#25151#38388
            Flat = True
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              08000000000000010000C40E0000C40E00000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
              0000000000000000000000000000A3A35C5C67E3A3000000000000000000A309
              65AEBF5DE30000000000000000009BEC77BFBF2F5D0000000000A3A4A3A3A3A3
              A366776F2F5DE3E4A300A4F5F6F6F6F6F6FF67776F2F5D09E400A4F5EAEAEAEA
              EAF2F267776FAFA4E400A407EAEAE9E9E9F1F1E927BFA407A400E407EAEAEAF2
              F2F2E9E9E9A4F6A4E69EE408E1EAEAF3F3F3F3F3F3F3A4EFEEE6E408E1EAEAEA
              EBF3F3F3F3F3F3E7E700E408E1EAEAEAEAEBEBEBF3F3EB08EC00ECF6E1E2EAEA
              EAEBEBEBEBEBEB08EC00ECF6D9E1E1E2EAEAEAEBEBEBEBF6EC00ECF6F6F6F6F6
              F6F6F6F6F6F6F6F6EC00ECECECECECECECECECECECECECECEC00}
            OnClick = btnChanngeRoomClick
          end
          object btnEditCallTime: TSpeedButton
            Left = 653
            Top = 8
            Width = 105
            Height = 27
            Caption = #20462#25913#21483#29677
            Flat = True
            Glyph.Data = {
              36050000424D3605000000000000360400002800000010000000100000000100
              08000000000000010000C40E0000C40E00000001000000000000000000000000
              80000080000000808000800000008000800080800000C0C0C000C0DCC000F0CA
              A6000020400000206000002080000020A0000020C0000020E000004000000040
              20000040400000406000004080000040A0000040C0000040E000006000000060
              20000060400000606000006080000060A0000060C0000060E000008000000080
              20000080400000806000008080000080A0000080C0000080E00000A0000000A0
              200000A0400000A0600000A0800000A0A00000A0C00000A0E00000C0000000C0
              200000C0400000C0600000C0800000C0A00000C0C00000C0E00000E0000000E0
              200000E0400000E0600000E0800000E0A00000E0C00000E0E000400000004000
              20004000400040006000400080004000A0004000C0004000E000402000004020
              20004020400040206000402080004020A0004020C0004020E000404000004040
              20004040400040406000404080004040A0004040C0004040E000406000004060
              20004060400040606000406080004060A0004060C0004060E000408000004080
              20004080400040806000408080004080A0004080C0004080E00040A0000040A0
              200040A0400040A0600040A0800040A0A00040A0C00040A0E00040C0000040C0
              200040C0400040C0600040C0800040C0A00040C0C00040C0E00040E0000040E0
              200040E0400040E0600040E0800040E0A00040E0C00040E0E000800000008000
              20008000400080006000800080008000A0008000C0008000E000802000008020
              20008020400080206000802080008020A0008020C0008020E000804000008040
              20008040400080406000804080008040A0008040C0008040E000806000008060
              20008060400080606000806080008060A0008060C0008060E000808000008080
              20008080400080806000808080008080A0008080C0008080E00080A0000080A0
              200080A0400080A0600080A0800080A0A00080A0C00080A0E00080C0000080C0
              200080C0400080C0600080C0800080C0A00080C0C00080C0E00080E0000080E0
              200080E0400080E0600080E0800080E0A00080E0C00080E0E000C0000000C000
              2000C0004000C0006000C0008000C000A000C000C000C000E000C0200000C020
              2000C0204000C0206000C0208000C020A000C020C000C020E000C0400000C040
              2000C0404000C0406000C0408000C040A000C040C000C040E000C0600000C060
              2000C0604000C0606000C0608000C060A000C060C000C060E000C0800000C080
              2000C0804000C0806000C0808000C080A000C080C000C080E000C0A00000C0A0
              2000C0A04000C0A06000C0A08000C0A0A000C0A0C000C0A0E000C0C00000C0C0
              2000C0C04000C0C06000C0C08000C0C0A000F0FBFF00A4A0A000808080000000
              FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00000000000000
              0000000000000000000000000000A3A35C5C67E3A3000000000000000000A309
              65AEBF5DE30000000000000000009BEC77BFBF2F5D0000000000A3A4A3A3A3A3
              A366776F2F5DE3E4A300A4F5F6F6F6F6F6FF67776F2F5D09E400A4F5EAEAEAEA
              EAF2F267776FAFA4E400A407EAEAE9E9E9F1F1E927BFA407A400E407EAEAEAF2
              F2F2E9E9E9A4F6A4E69EE408E1EAEAF3F3F3F3F3F3F3A4EFEEE6E408E1EAEAEA
              EBF3F3F3F3F3F3E7E700E408E1EAEAEAEAEBEBEBF3F3EB08EC00ECF6E1E2EAEA
              EAEBEBEBEBEBEB08EC00ECF6D9E1E1E2EAEAEAEBEBEBEBF6EC00ECF6F6F6F6F6
              F6F6F6F6F6F6F6F6EC00ECECECECECECECECECECECECECECEC00}
            OnClick = btnEditCallTimeClick
          end
          object btnTestMessage: TButton
            Left = 792
            Top = 10
            Width = 75
            Height = 25
            Caption = #27979#35797
            TabOrder = 0
            Visible = False
            OnClick = btnTestMessageClick
          end
        end
        object strGridCall: TAdvStringGrid
          Left = 0
          Top = 41
          Width = 1241
          Height = 168
          Cursor = crDefault
          Align = alTop
          ColCount = 12
          Constraints.MinHeight = 50
          Ctl3D = False
          Font.Charset = GB2312_CHARSET
          Font.Color = clWindowText
          Font.Height = -16
          Font.Name = #23435#20307
          Font.Style = []
          Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
          ParentCtl3D = False
          ParentFont = False
          ScrollBars = ssBoth
          TabOrder = 1
          ActiveRowColor = 15532006
          ActiveCellFont.Charset = DEFAULT_CHARSET
          ActiveCellFont.Color = clWhite
          ActiveCellFont.Height = -11
          ActiveCellFont.Name = 'Tahoma'
          ActiveCellFont.Style = [fsBold]
          ColumnHeaders.Strings = (
            #24207#21495
            #24453#29677#36710#27425
            #25151#38388#21495
            #24378#20241#26102#38388
            #21483#29677#26102#38388
            #20986#21220#26102#38388
            #21333#21452#21496#26426
            #27491#21496#26426
            #27491#21496#26426#29366#24577
            #21103#21496#26426
            #21103#21496#26426#29366#24577
            #21483#29677#29366#24577)
          ColumnSize.Stretch = True
          ControlLook.FixedGradientHoverFrom = 13619409
          ControlLook.FixedGradientHoverTo = 12502728
          ControlLook.FixedGradientHoverMirrorFrom = 12502728
          ControlLook.FixedGradientHoverMirrorTo = 11254975
          ControlLook.FixedGradientHoverBorder = 12033927
          ControlLook.FixedGradientDownFrom = 8816520
          ControlLook.FixedGradientDownTo = 7568510
          ControlLook.FixedGradientDownMirrorFrom = 7568510
          ControlLook.FixedGradientDownMirrorTo = 6452086
          ControlLook.FixedGradientDownBorder = 11440207
          ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownHeader.Font.Color = clWindowText
          ControlLook.DropDownHeader.Font.Height = -11
          ControlLook.DropDownHeader.Font.Name = 'Tahoma'
          ControlLook.DropDownHeader.Font.Style = []
          ControlLook.DropDownHeader.Visible = True
          ControlLook.DropDownHeader.Buttons = <>
          ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
          ControlLook.DropDownFooter.Font.Color = clWindowText
          ControlLook.DropDownFooter.Font.Height = -11
          ControlLook.DropDownFooter.Font.Name = 'Tahoma'
          ControlLook.DropDownFooter.Font.Style = []
          ControlLook.DropDownFooter.Visible = True
          ControlLook.DropDownFooter.Buttons = <>
          Filter = <>
          FilterDropDown.Font.Charset = DEFAULT_CHARSET
          FilterDropDown.Font.Color = clWindowText
          FilterDropDown.Font.Height = -11
          FilterDropDown.Font.Name = 'Tahoma'
          FilterDropDown.Font.Style = []
          FilterDropDownClear = '(All)'
          FixedColWidth = 40
          FixedRowHeight = 22
          FixedFont.Charset = GB2312_CHARSET
          FixedFont.Color = clBlack
          FixedFont.Height = -16
          FixedFont.Name = #23435#20307
          FixedFont.Style = [fsBold]
          Flat = True
          FloatFormat = '%.2f'
          Look = glStandard
          PrintSettings.DateFormat = 'dd/mm/yyyy'
          PrintSettings.Font.Charset = DEFAULT_CHARSET
          PrintSettings.Font.Color = clWindowText
          PrintSettings.Font.Height = -11
          PrintSettings.Font.Name = 'Tahoma'
          PrintSettings.Font.Style = []
          PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
          PrintSettings.FixedFont.Color = clWindowText
          PrintSettings.FixedFont.Height = -11
          PrintSettings.FixedFont.Name = 'Tahoma'
          PrintSettings.FixedFont.Style = []
          PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
          PrintSettings.HeaderFont.Color = clWindowText
          PrintSettings.HeaderFont.Height = -11
          PrintSettings.HeaderFont.Name = 'Tahoma'
          PrintSettings.HeaderFont.Style = []
          PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
          PrintSettings.FooterFont.Color = clWindowText
          PrintSettings.FooterFont.Height = -11
          PrintSettings.FooterFont.Name = 'Tahoma'
          PrintSettings.FooterFont.Style = []
          PrintSettings.PageNumSep = '/'
          ScrollWidth = 16
          SearchFooter.Color = clBtnFace
          SearchFooter.FindNextCaption = 'Find &next'
          SearchFooter.FindPrevCaption = 'Find &previous'
          SearchFooter.Font.Charset = DEFAULT_CHARSET
          SearchFooter.Font.Color = clWindowText
          SearchFooter.Font.Height = -11
          SearchFooter.Font.Name = 'Tahoma'
          SearchFooter.Font.Style = []
          SearchFooter.HighLightCaption = 'Highlight'
          SearchFooter.HintClose = 'Close'
          SearchFooter.HintFindNext = 'Find next occurence'
          SearchFooter.HintFindPrev = 'Find previous occurence'
          SearchFooter.HintHighlight = 'Highlight occurences'
          SearchFooter.MatchCaseCaption = 'Match case'
          SelectionColor = clNone
          SelectionRectangle = True
          ShowSelection = False
          ShowDesignHelper = False
          SortSettings.HeaderColorTo = 16579058
          SortSettings.HeaderMirrorColor = 16380385
          SortSettings.HeaderMirrorColorTo = 16182488
          Version = '5.6.0.0'
          ColWidths = (
            40
            80
            60
            130
            130
            139
            77
            129
            93
            127
            94
            122)
        end
        object grpRoomPlan: TGroupBox
          Left = 0
          Top = 212
          Width = 1241
          Height = 443
          Align = alClient
          Caption = #20844#23507#24453#20056#20449#24687
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clGray
          Font.Height = -11
          Font.Name = 'Tahoma'
          Font.Style = []
          ParentFont = False
          TabOrder = 2
          object Panel5: TPanel
            Left = 2
            Top = 15
            Width = 1021
            Height = 426
            Align = alClient
            BevelOuter = bvNone
            BorderWidth = 5
            TabOrder = 0
            object RoomPlanGrid: TAdvStringGrid
              Left = 5
              Top = 5
              Width = 1011
              Height = 416
              Cursor = crDefault
              Align = alClient
              ColCount = 9
              Constraints.MinHeight = 50
              Ctl3D = False
              Font.Charset = GB2312_CHARSET
              Font.Color = clWindowText
              Font.Height = -16
              Font.Name = #23435#20307
              Font.Style = []
              Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRowSelect]
              ParentCtl3D = False
              ParentFont = False
              ScrollBars = ssBoth
              TabOrder = 0
              ActiveRowColor = 15532006
              ActiveCellFont.Charset = DEFAULT_CHARSET
              ActiveCellFont.Color = clWindowText
              ActiveCellFont.Height = -11
              ActiveCellFont.Name = 'Tahoma'
              ActiveCellFont.Style = [fsBold]
              ColumnHeaders.Strings = (
                #24207#21495
                #24453#29677#36710#27425
                #25151#38388#21495
                #24037#21495
                #22995#21517
                #21040#36798#26102#38388
                #21483#29677#26102#38388
                #20986#21220#26102#38388
                #29366#24577)
              ColumnSize.Stretch = True
              ControlLook.FixedGradientHoverFrom = 13619409
              ControlLook.FixedGradientHoverTo = 12502728
              ControlLook.FixedGradientHoverMirrorFrom = 12502728
              ControlLook.FixedGradientHoverMirrorTo = 11254975
              ControlLook.FixedGradientHoverBorder = 12033927
              ControlLook.FixedGradientDownFrom = 8816520
              ControlLook.FixedGradientDownTo = 7568510
              ControlLook.FixedGradientDownMirrorFrom = 7568510
              ControlLook.FixedGradientDownMirrorTo = 6452086
              ControlLook.FixedGradientDownBorder = 11440207
              ControlLook.DropDownHeader.Font.Charset = DEFAULT_CHARSET
              ControlLook.DropDownHeader.Font.Color = clWindowText
              ControlLook.DropDownHeader.Font.Height = -11
              ControlLook.DropDownHeader.Font.Name = 'Tahoma'
              ControlLook.DropDownHeader.Font.Style = []
              ControlLook.DropDownHeader.Visible = True
              ControlLook.DropDownHeader.Buttons = <>
              ControlLook.DropDownFooter.Font.Charset = DEFAULT_CHARSET
              ControlLook.DropDownFooter.Font.Color = clWindowText
              ControlLook.DropDownFooter.Font.Height = -11
              ControlLook.DropDownFooter.Font.Name = 'Tahoma'
              ControlLook.DropDownFooter.Font.Style = []
              ControlLook.DropDownFooter.Visible = True
              ControlLook.DropDownFooter.Buttons = <>
              Filter = <>
              FilterDropDown.Font.Charset = DEFAULT_CHARSET
              FilterDropDown.Font.Color = clWindowText
              FilterDropDown.Font.Height = -11
              FilterDropDown.Font.Name = 'Tahoma'
              FilterDropDown.Font.Style = []
              FilterDropDownClear = '(All)'
              FixedColWidth = 40
              FixedRowHeight = 22
              FixedFont.Charset = GB2312_CHARSET
              FixedFont.Color = clBlack
              FixedFont.Height = -16
              FixedFont.Name = #23435#20307
              FixedFont.Style = [fsBold]
              Flat = True
              FloatFormat = '%.2f'
              Look = glStandard
              PrintSettings.DateFormat = 'dd/mm/yyyy'
              PrintSettings.Font.Charset = DEFAULT_CHARSET
              PrintSettings.Font.Color = clWindowText
              PrintSettings.Font.Height = -11
              PrintSettings.Font.Name = 'Tahoma'
              PrintSettings.Font.Style = []
              PrintSettings.FixedFont.Charset = DEFAULT_CHARSET
              PrintSettings.FixedFont.Color = clWindowText
              PrintSettings.FixedFont.Height = -11
              PrintSettings.FixedFont.Name = 'Tahoma'
              PrintSettings.FixedFont.Style = []
              PrintSettings.HeaderFont.Charset = DEFAULT_CHARSET
              PrintSettings.HeaderFont.Color = clWindowText
              PrintSettings.HeaderFont.Height = -11
              PrintSettings.HeaderFont.Name = 'Tahoma'
              PrintSettings.HeaderFont.Style = []
              PrintSettings.FooterFont.Charset = DEFAULT_CHARSET
              PrintSettings.FooterFont.Color = clWindowText
              PrintSettings.FooterFont.Height = -11
              PrintSettings.FooterFont.Name = 'Tahoma'
              PrintSettings.FooterFont.Style = []
              PrintSettings.PageNumSep = '/'
              ScrollWidth = 16
              SearchFooter.Color = clBtnFace
              SearchFooter.FindNextCaption = 'Find &next'
              SearchFooter.FindPrevCaption = 'Find &previous'
              SearchFooter.Font.Charset = DEFAULT_CHARSET
              SearchFooter.Font.Color = clWindowText
              SearchFooter.Font.Height = -11
              SearchFooter.Font.Name = 'Tahoma'
              SearchFooter.Font.Style = []
              SearchFooter.HighLightCaption = 'Highlight'
              SearchFooter.HintClose = 'Close'
              SearchFooter.HintFindNext = 'Find next occurence'
              SearchFooter.HintFindPrev = 'Find previous occurence'
              SearchFooter.HintHighlight = 'Highlight occurences'
              SearchFooter.MatchCaseCaption = 'Match case'
              SelectionColor = 15532006
              SelectionRectangle = True
              ShowSelection = False
              ShowDesignHelper = False
              SortSettings.HeaderColorTo = 16579058
              SortSettings.HeaderMirrorColor = 16380385
              SortSettings.HeaderMirrorColorTo = 16182488
              Version = '5.6.0.0'
              ColWidths = (
                40
                85
                68
                145
                141
                145
                150
                147
                87)
            end
          end
          object Panel1: TPanel
            Left = 1023
            Top = 15
            Width = 216
            Height = 426
            Align = alRight
            BevelOuter = bvNone
            TabOrder = 1
            object GroupBox1: TGroupBox
              Left = 6
              Top = 159
              Width = 203
              Height = 193
              Caption = #29366#24577#39068#33394#35828#26126#65306
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clBlack
              Font.Height = -11
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              TabOrder = 0
              object PColor1: TPanel
                Left = 17
                Top = 26
                Width = 171
                Height = 20
                BevelOuter = bvNone
                Caption = #21483#29677#26102#38388#24050#36807
                Color = clGray
                TabOrder = 0
              end
              object pColor2: TPanel
                Left = 17
                Top = 57
                Width = 171
                Height = 20
                BevelOuter = bvNone
                Caption = #26410#21040#21040#36798#26102#38388
                Color = 9556122
                TabOrder = 1
              end
              object pColor3: TPanel
                Left = 17
                Top = 89
                Width = 171
                Height = 20
                BevelOuter = bvNone
                Caption = #24050#36807#21040#36798#26102#38388#31561#24453#21483#29677
                Color = 3352034
                TabOrder = 2
              end
              object pColor4: TPanel
                Left = 17
                Top = 120
                Width = 171
                Height = 20
                BevelOuter = bvNone
                Caption = #27491#22312#21483#29677#20013
                Color = 8388863
                TabOrder = 3
              end
              object pColor5: TPanel
                Left = 17
                Top = 150
                Width = 171
                Height = 20
                BevelOuter = bvNone
                Caption = #24050#20652#21483#20294#21496#26426#26410#31163#23507
                Color = 33023
                TabOrder = 4
              end
            end
            object GroupBox2: TGroupBox
              Left = 6
              Top = 3
              Width = 202
              Height = 150
              Caption = #19981#23450#26102#21483#29677#24453#20056#20449#24687
              TabOrder = 1
              object btnCallNow: TButton
                Left = 32
                Top = 21
                Width = 153
                Height = 29
                Caption = #31435#21363#21483#29677
                TabOrder = 0
                OnClick = btnCallNowClick
              end
              object btnAddTemp: TButton
                Left = 32
                Top = 54
                Width = 153
                Height = 25
                Caption = #28155#21152
                TabOrder = 1
                OnClick = btnAddTempClick
              end
              object btnDeleteTemp: TButton
                Left = 32
                Top = 114
                Width = 153
                Height = 25
                Caption = #21024#38500
                TabOrder = 2
                OnClick = btnDeleteTempClick
              end
              object btnEditTemp: TButton
                Left = 32
                Top = 83
                Width = 153
                Height = 25
                Caption = #20462#25913
                TabOrder = 3
                OnClick = btnEditTempClick
              end
            end
            object pngbtbtnManual: TPngBitBtn
              Left = 56
              Top = 368
              Width = 113
              Height = 41
              Caption = #25163#24037#21483#29677
              TabOrder = 2
              Visible = False
              OnClick = pngbtbtnManualClick
              PngImage.Data = {
                89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
                F40000001974455874536F6674776172650041646F626520496D616765526561
                647971C9653C000006D64944415478DAC5576B4C1457143EB3B3B3BB80A2A855
                0A96051610E4A13C6DB50F35D25A131B6D93DAA455DB34AD5193DA9A34DA541B
                152D6A9AFAF82322A2315ADB546DFCA1C6F8485A41D116EA8B9708CB63DFB0EC
                B2BBECECBC767BEEEC6009C167499DEC97C9CCBD73BFEF9CFB9D7BEF52A15008
                9EE7453D7701233C1EB361C306B3284A2FA82868BCD7D232F3C48913EEFF4B00
                F3CDFAF51DB9F9452F9E3E7D1A227511306EFC5870B99C29E5E507DAB07DD854
                8F940066FDFA759DFAC4D4D89C9C2CD8B7AF0C22222240A3D1C0E85191D0D3D3
                3DA5A2A2A26538112321805EB366CDAFC986D4C5A3A3C742566606ECDF5F0E91
                9191B200B59A061515B294969626615F7EA405D05F22B93E396571764E0E4461
                D40465E5071E08A0691A2864F17A5C95BB76EDFE1CBF91464AC083C8B3B2B321
                272B131A9BEE415656066CDBB61D743A1D301A06D4B41AD478F7FBBC603675BE
                7EF06065D5E0A97856016A12B921357D515676164CCD480752CE376FDE86F4F4
                543877FE02D8AD36D0EAB461018C1AA781028BB9CBBA63C70E3215DC7F11A05A
                B162C5C7D3A6E71D4CD02742DEF41CA0542A39D577EB1B61C2F871D0DBDB03D5
                D535A08BD0A107D4321886813EB70BDAEEB7ACD857565681E3049F45806AD5CA
                95CBB3A7E556262525C3F49C6C7C4301F2435F9F17DADB3B202A2A0AF4FA97E0
                E8B1E3B20F08F140168890FA3BB703A5A5DF8FC3B1D8A715A05AB56AD5F26443
                4A65CEF45C9886A9A7A81042050E8713CC6613CE399A4E45832139116AAEDFC0
                F2738246AB9105D00C0D5A460B168B09FEAEFBEBFDCACA432788179E54806AF5
                EAD5CBF589499585854590993955767630180293C90C6E8F07189AC16871AE31
                23D1D1D1E0F7B370EBD62DD9078C9A011ACB916403CD02172F9CAFDABB77EF3C
                E2852711407DB0648921BFB0A8A5A868064C9D9A2193039237B7B681C80BE134
                2301F1814A45CB42B41879435333F01CA7B4877D4016A83FAFD7C0B16347E3EB
                EAEA2C8F13402D5DBAD490979BD752F0F22B9031254D8E30C006E07EAB512664
                1842AC9689695A2513A9D01441490436C082D9629389C99A40DE4BC120983A3B
                A0E6DAD58D656565A5D4E3C8F30B0A5A66CC980969692932B9CBE506ABDD0134
                A6810C3C40CC2031A510F03C2F474EE6DEE7EF0751146508822083C3F66B557F
                54EFD9B3A7F86102A865CB96190A30EDB9F9059091968A065383D56AC7127363
                348C1CF5506232B080C403443C62CC9868703A7B8165D9F07B5EC4BE22294728
                29D912F33001DA4D9B3607E6BFBD0092D0D15A345197D98A83F831C5647DFF37
                D50F2396EF7C78E98F898981AECE2EEC17EE230A12387BECB079F3A689C30960
                4AB694B4CF2D7E332E9DA41DCBAC139D2E4A921CED03627CE608D130C4C22001
                1CC7CBA68D8F8B83A6E666F40F87630910F0FB31039B270D15C06C2DD9D65E3C
                7F7E5C6A8A012454DA65B50C9AEF2727E6F9813B0F8140401E3C31510F8DB85A
                1273864222ECD8BE5D16407DB1F6BBD7BC9EDEFEA424FDA905F3DF4A30A424A2
                523FD86CDDF27C0F10F3C4488F242610119C0292014EFE36488E7EF88B8B8B85
                76A311DF090F04E86ACB27B1A49D8BFF0AB267AF45A3D9C1E7F5C965F658623E
                FCCC63B6389E00FBF201AC023FB607C86A85BF208EC343BFAFBF15CD6875BBDD
                4D376EDCF8D96834D61101E37EDF1BE74C2FDE0DC6DAC3103BE738B0BE1E9044
                7E08B1187E2626121148C409BC12B100BEFE00E8FAAB6054EF11E8507FC839D8
                58A3CBE9A8B3DB6CF516DC061B1A1A4C10DE0509FA112E022260A2A3EDB24D64
                BBA9DA534B216EEE2F40476762043E74AB12B14C8CF52D056507BB9CDDE0F17A
                64527F3F6BB7D9EDF5B8191997241CFA949C363AACB3E06C6DCBB2EA66C72D85
                8C900A0A44E54E4A44220226947C16BF73DA64EB2712124426BC0331F93B8167
                3DC0FA7D381D4E70743B7141114279BE8DD4B5BB09D0E08FD97FE17AC359576F
                B74F1988EC6CEA635F5335219CE80EEB6CA86BED7AF7E4B5D64BF89E3890E822
                DBEFB067C251738A172E5CF9EA959F7C2E0D58EC93209830CFEE96D436CC5C63
                5B6B5B55535373BBC7D3275DD83AF95CF55D3DB062D70F49B19E50842E94A2A6
                0984EC102E2E41121CEE1146EB1BD06C762C3A72B9F18C12F1C3975B527A88F8
                ED1F151A199D4FBA6334FD78F892F78C12951FE15352187DF2DBB4A6206EC101
                4E85A0B19482E065A3E41D4E94B42020280C321892FA361EADC2C3025860C819
                703801B2114999928A403815830CCC1BAF443161DD7B85BF8D8ED4CD221FE211
                8CE304C92448419FCB17A8A729A0EF74F45CD16968D5C59B9D57B18B511927F4
                3801E4D220A2946756210F0EE93B1A9140842068A57D40E05010E37995F6475E
                4F7322522322942C514A64D2208389439E9FE84FE748FF377CEAEBB9FF3BFE07
                54E9EFCFABADB4AA0000000049454E44AE426082}
            end
          end
        end
      end
    end
  end
  object RzPanel2: TRzPanel
    Left = 0
    Top = 696
    Width = 1259
    Height = 26
    Align = alBottom
    BorderOuter = fsFlatRounded
    BorderSides = [sdTop]
    Color = 16511722
    TabOrder = 1
    object PngCustomButton7: TPngCustomButton
      Left = 5
      Top = 6
      Width = 19
      Height = 19
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000013000000130806000000725036
        CC000000097048597300000B1200000B1201D2DD7EFC000003204944415478DA
        95945F48DA5114C7BF9ABA4D2B30FBA31526098B16B398910BD98884450B7AE9
        A1A7881AEC6D8316940F33CB8D28091FB6B781FD7B0C82E8CF1EC68CDAD89CD5
        8494060D8CB286A374427FF62797ED5C99626AFB73E0CBBDBFC3B99F7BEEEF9C
        7B39A7A7A74834994CA6A4E10EE916E90AE912E91BE903E905C9EAF3F93C89EB
        38F13082886830F378BCBB252525BCC2C24288C5620804021C1F1F23180C6267
        6707EBEBEB3FC99E99CDE6C72D2D2DBE241881A46CD7B1B1B1AB333333282F2F
        47555515944A254422118E8E8EE0F178B0B4B484D5D555ACACAC607373D3CDB2
        A72C3FC7600412D2DC4E4E554F4F0FDADBDBA150286219333003448D20B05AAD
        B0DBED585B5B7391AB9AD67E8DC29E8C8E8EDE5B5C5C845EAF476666266C361B
        743A5DD2FF8CFAF7F7F7D1DFDF8FF9F9796C6F6F3F25D87D8E542A55A4A5A57D
        A400BED168447171711280CFE723140A25F9373636D0DBDBCB80A1939393CB0C
        D6575454D4D3DCDC8C8E8E8E9419A58245E32C160B262626B0B5B56562B0B76A
        B5BADA603040A3D120959D97193387C30193C904A7D36967B02F04118F8C8C44
        DAE07F61AC5D5A5B5BB1BCBC1CE40885C2975AAD5637373787CACACA33558B87
        0D0C0CA0B3B3F38C9F5599B5487D7D3DABAC8D430DEAA7CC24535353C8CECE4E
        B9FBDEDE1EC6C7C723954E84FAFD7E343636B2CC020CF68A76B8313434849A9A
        1AFCC9E2A1D1632F2C2C44E02E97EB35833D94CBE58F9A9A9A40D7E3DCFE4A84
        D2E2485C575717262727E1F57A0D0C56C0E1703C2A95EAC2F0F03068C4BF1A03
        B6B5B5C1ED76FFA0E657466E00FDE0819C9C9CEE8A8A0AD04D406E6EEE5F6FC0
        EEEE6EA48A54404C4F4F0FD2B1F5519880E25EE5E7E76B4A4B4B31383818A954
        7CD5E2ABCCE6DDDDDDA8ABAB63C77490EB26C18E63AF060159933DCFCACABA9E
        979787DADA5A343434A0ACAC0CE9E9E9383C3C64971AAC85D87D64AFC9ECECEC
        3B5A739B4041C638F39EFDCED048FFF0814422B99891911179CBE81B2C8EBD69
        070707080402DFE9DB42B17D2CA3E8FA188C16C8699091AE91B45C2E574DBE02
        9AB307934B0A938E28FE53381C7E4FF3372427C9473E2F63FC02FC1586C9AF3E
        8FF00000000049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 0
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object PngCustomButton8: TPngCustomButton
      Left = 692
      Top = 6
      Width = 16
      Height = 16
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002D74944415478DA95D15D4853611807F0FFD9749E31E7D9
        96D36D7ECCA50E212FCA2EA49B282A9C4196185410D18D5D247691577D6899E1
        5544D44D0651E44516DA85AED2F04613F3AB2C3575AEE9BEFC584CA74E3D6EE7
        ECBC9D090A9125FDE1E1BD799FDFCBF33E142104FF137B8BD9CA854941702E62
        CD2F9B2CA67602ECCD66AD006825146604422A6889F2A682D2A0FF8B832FAC9C
        8AFD2730F9DE5C17E15128162308245E2957493C363F81A0A066032BD692BBCE
        13DB026263B64030946028A0999493A04804ACA715E199AFF8391D806376F176
        51B5B33A7AF70F406C2E91D2BB1A15BA623089B960BDCF1159F183F3FB40A878
        808EC7E73E87ED789533E737406CD48BC70BB936EFA8525B8C586908A1B90608
        EB2C22A110082716CF89400ADC43767EFFD51FB11B80BD253B5B22458738A74E
        6D3A4BA9D28A109E6FC5DADC47082C0B7E3D0476690D713202590C0191A76174
        60227CF8C664DC0630D698D59E68DE7B2421C922BE6407581F286E09C1F90096
        7C8BE056C3E0D639302A0A723A0691B814F4764D784ED53AD33780A16799D319
        078F19003DC6BB5F432613104BE211E5950CE0B62D402A8EA94DA240279AB0B6
        CCE2538FA7E9CC3DD7E90DA0F791E9893AC3509A683E849991614C0DFB2057D3
        202117B24C4A304A09BCB62528140214866CCC4ECD62643C6839FFD0DDB6F589
        9DF74DDD097AF581CC7C0BDAEBACB05CBE0076D18FBE362B34D2659873682CCC
        8541EBB2F0ADC71128AC99D26C6E6D6B0B1F6A4D36C6A032433023C9980ADD6E
        06DEEF6378F7EA2D723369E4E73108F03A7475BA47CF3D70EDF90388A6F956C6
        1B05C31447043956FD41241B9331D8D58F602082028B068C5687CE0E9FFBE263
        8F715B209AA6EB190520A4556F54237D5F0A62781EAE713752F5047E970CBD03
        81BE4B4F3DF97F0536F3B2C2780702A94C322891A693033C816D62056EEF6A4D
        59BDB76A47209AFAF274693844AE711CCAC33C91120E8314507AA5C1EBDCBCF3
        0BE4775DF044BB2E660000000049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 1
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object PngCustomButton9: TPngCustomButton
      Left = 349
      Top = 6
      Width = 16
      Height = 16
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002C64944415478DAA5925D48936114C7FFEFB677DF5351D2
        692DC8A68E21467725A483208A6AE25D7A9957DD4417BB5A5057D1455E45845E
        745161DD84314872EAD6C24802AB41231D696E38ABB92FA7FB783FB79EE7DD85
        C2A49B5E383C0FE779CFEF9CFF3987A956ABF89F8F390CB0B0B0A0237E37B191
        4AA5E22067173172AD44C8B946CE27C402C3C3C3721D80043B89EF656B6B6B9F
        D56A85C96482D16804FD2F9FCF636F6F0FF1781CA954EA03F15DAB03CCCDCDBD
        73381C2E9BCD0686610E2D5B922444221144A3D1677500BFDFBFED72B98E68B5
        DA7F0272B91CAD36550778331B4C5B0CEA9662B188FEFE7EE8743AB02CAB4828
        954AC866B3482412B0DBED080683FB80A9C5AC4110E517527E73E8983EC9D020
        9AA5B7B75709A659690F789E8746A3417777370281400DF03494D188A2F85DC7
        325DA8CA486E84D1D9C4411004A50A1A4001E9741A85424149D8D9D9B92F6162
        F6F7715192E31DCD2C7841447287C3D6461457CF7521FA2584582C86B1B13164
        3219650A2A954A91303F3F5F038C4FC7CF02F2476B138BAD4C09263D835FE912
        E23F2238D39E03192942A110464747417BA356ABD1D3D3431B5E03DC9D5A75AB
        19F8DA0820912AA0C48B68346AB05BE490F8F61EA78E56402462606040A9804A
        723A9D989999A9016E4D7CF5980DAA072D161D62C95D94399E4004E8356AC844
        FBCFE54F78786708D94C4A6924AD8036D7E7F3A5981B8F3E6B4B65AE70B2C3CC
        7224336939785102BDF3246B6C6D1B17FA9A71C56543329954B6922ED9FAFA3A
        96969652CCC8FD45A1C1A862AD4D7AEC14CAD8DC22EB9A2BA25CE0C01578D8DB
        4D787CEF32B4AC5A914125ACACAC201C0EFF21937133976EFBDF369BD88B4259
        200B9215C522E76DB354F2A74FC0DDD280C146B3C662361B9531D225E2388E06
        3E976579DCEBF56E3383375F1BA4B2382D95F9F35259302FBFBA2E1CDCCCC9C9
        490B09B013AB900A563D1E0F7FF0FD2FC853B7176F72FA260000000049454E44
        AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 2
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object PngCustomButton13: TPngCustomButton
      Left = 207
      Top = 7
      Width = 16
      Height = 16
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002974944415478DAA5935B4854511486FF7351674CD35133
        721C191DAFA525A66306920F5261205154A8A81531616862541025845011F556
        9886480A79C1A76E50A81198284284A3658DE938A64E64EAE8E8E89CCB3E9D8E
        E44B8E116DD80F7BAFBD3FD6BFFEB5284992F03F8B5A0FD0DF60E80E1BB6ED65
        58091207F02B14C6E3C3FB8DA6B1E4BF02CC4D31EDE1AEAFD934272867691920
        0E09CB1283EF71BADE94C2918C0D01B3CD9B2466CE0DC12EDF33CA134814E09E
        05661C147636F0D48680E9F3AC6435E6431B9C088A6E05F7AC1F8C8A024F5110
        1608C6B66704EE2FEF9AF708683DAB9D3F50D1B8992C4C81E739D0A40E34AD05
        BBE5087A6A2FBBB449B99AA493D59C47C0C3E2D8BE63A5D7D304DA0B7EACA048
        581418B09480B6FB37DF99EA07523D4AA83977C84F5CB69AF51A2A32BBA00292
        2A78B590BC0B5D2DB73030C18E125584F152DDD3993F003525391A1FDAD9941E
        DA77D070BA13E64765B073214A6C9BF70FEC387A15D6B602F4D853DF10F8E49B
        6A5EDBD7005567F2E942A3AB9ECCBC2A36143D019C23C0B76E60791A927B0EE0
        1C40401CA0CFC5A7B60BE8B4ED7EC1D0CCF192DA4E9702682ECFAACD89EE3505
        A497FE4A58F66B50EE1EB9D09C534E7F09022FDBCA71508526C88DB580C9F159
        747CD1B79CAA7E9BA700DE5F8B17C2D30F3341F38FC1F8A857758B3C88C043FC
        BD6547DC7273A9D56AAC4494C1D2D1C6EFB93BE4AD00CC95094497994791A11B
        088EC984306B0121820211051134CB828804AAC030D8466DD0A45CC4707BB394
        76FB23AD00061BCBAE70432FAB745B27D9C515119186A87507C7F2D90A4E64C1
        8B516EAFE87D77128BEE55AEB930D652E23FF1C1AC9F728ACF63832675DEB493
        A2882C438E1149FE447C259B236429C0D73F2B3A799725E2C403A7C769FC97F5
        137A8C4EF0144DFBC20000000049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 3
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object PngCustomButton14: TPngCustomButton
      Left = 450
      Top = 8
      Width = 16
      Height = 16
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000018B4944415478DA9DD2CB2B446118C7F173E622B9378422
        8964C142446C1029445252CA469658DAD0C86556FE080B1B25561626B92F4951
        2C2416EE113191989BEFA3479963C6C2A94F4FEFE93DBFF7BCCFFB9AE170D890
        C7E9741A3F1E1B2A5183645C61174708C904BFDFFF35D18C1260A20071784522
        3251AEE31904FE0A28421DF29084179C630F39F231BCBF021C0E87947CF4E310
        C778462A8A518A4D590B1B8140E03D5AC0000EF4A32AB8F0881D0D6BC522AE09
        B8B106A4539A75622D96708B6CB4631B696A96009F35A05AF7D785656DA4F462
        0B6768C1027A314EC0534480DD6E6FA39C60149332091370C3A3EF3D3A1E0C06
        833E6B4027455E16A2116B38D5DF9F431FA631822102DEAC0165928C795C2217
        DD58D166CAF6EEF582B909084704D86CB6788AFC45835E9C3BAC43F6DA83295D
        409ABB1A0A850C6B80940E3DB607C8A954409A3BA62723AB0FE12356408936D0
        A52BCBC5F1A25EFF6C586FA5112BC0609C42C992B6E8FD6FD2FD4F9AA679F17D
        DFFF0A9092A02791A137735FBE21C08819F0DFE71395C2B4E168C0263E000000
        0049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 4
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object PngCustomButton15: TPngCustomButton
      Left = 551
      Top = 6
      Width = 16
      Height = 16
      TextAlign = taTFCenter
      TextLeftSpacer = 0
      TextRightSpacer = 0
      ImagesConfig.NormalIndex = -1
      ImagesConfig.HotIndex = -1
      ImagesConfig.FocusIndex = -1
      ImagesConfig.DownIndex = -1
      ImagesConfig.DisableIndex = -1
      ImagesConfig.DownDisableIndex = -1
      ImagesConfig.UseImages = False
      NormalPngImage.Data = {
        89504E470D0A1A0A0000000D49484452000000100000001008060000001FF3FF
        610000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000002BE4944415478DA95925D48936114C7CFEBF6BABDBAF955
        D9D2B28BAC0B6FBA2BB4A0C082BCA9EBBA5B141244444C0B8D22A2A20FE8A60B
        E922ECC284104B41FC0031359C41E1C7D0A6E698733A37A76E7BF7BECFFB7C6D
        3D0EEA223FA0037FCED5F99DC3FFFCA5743A0DBBD5C791B899705642082F4506
        DBA763724CE8A98648BFAAE34BD26E80D6AF31450CF6334E2B09E5401903CE08
        28962C084454980FA93DBB02DEF547EAB34DE9E73645024C58460853886B180C
        D18726837447C0DB9E50B68659FC40816C45184334618861029AC1C0AE98C0EB
        8FC2C2E246DDAE173C6A9D7D62314383CD22412A95027F58051D195060936172
        3A0C6B2BB1AD1EBCFFB256C67D1D0F28A5A6DADA5AE7F5D7A3F71388363A0A2D
        56BB350BE697635064B780676211D448A2EA2FA065785D11467DA0F160CD21EB
        8A459665181F1F6F76B95CCE73F55DA719C27D078BED4AAED88E2905CF880F0C
        553F9C0188AD66B171DA224B4721CD21E41B63E585D83C3535D58C10BA26943F
        BA7EA2821A469FA3344F51D7348804A273A914A9C8009A7A426594F185922241
        2714C2310302F35E12A5F6F37BC39F9DBAAE570AC8D989E8C97286492F4FB13E
        CEE995B9A1069401BC6A5FA804E0238E021996D674C8B54AB01CD5C137E3A1A7
        4A6372717131B4B5B5CD608CAB66E255B699C17B813F9E65000F5BBC174D1274
        EC1780E06A1274F1E3FC1C33243403829E41385E9A02B7DBDDDCD9D9E9FCF753
        19C0EDA631974DC97AB947B8EB0F27001958400858CD26913C0673DFDC941192
        3FDAF5186D01DC78F3235BFC3679A4C4266FA60B0410539649DAA6DBFE5F1108
        FBA37727BB6FBED82E2BD2E567C3242F274B761458219644B0B8140775430394
        34C048624009CDCD39AFFE3970076D0BA869ECED2ECA952F104420185CA75433
        1A3861B3DC20ABE2EC25E1F8B277A08EED9456E9CCAD4F0A43B45D04A59A2162
        FBDE7695C07FD46FB5CDC52402304EE90000000049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 5
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object lblSysTime: TLabel
      Left = 31
      Top = 8
      Width = 159
      Height = 13
      Caption = '2015'#24180'01'#26376'01'#26085' 00'#26102'00'#20998'00'#31186
    end
    object lblDutyUser: TLabel
      Left = 226
      Top = 7
      Width = 108
      Height = 13
      Caption = #20540#29677#21592#65306#31995#32479#31649#29702#21592
    end
    object lblDBState: TLabel
      Left = 369
      Top = 7
      Width = 60
      Height = 13
      Caption = #25968#25454#24211#27491#24120
    end
    object lblFingerState: TLabel
      Left = 470
      Top = 7
      Width = 75
      Height = 13
      AutoSize = False
      Caption = #25351#32441#20202#27491#24120
    end
    object lblSerialState: TLabel
      Left = 573
      Top = 7
      Width = 108
      Height = 13
      Caption = #20018#21475#29366#24577#65306#25171#24320#25104#21151
    end
    object lblTestLine: TLabel
      Left = 712
      Top = 7
      Width = 225
      Height = 13
      Caption = #38899#39057#32447#36335#26816#27979#22833#36133':'#24403#21069#24405#38899#35774#22791#19981#26159'LineIn'
    end
    object lblUDPState: TLabel
      Left = 976
      Top = 7
      Width = 24
      Height = 13
      Caption = 'UDP:'
    end
    object lblFTPState: TLabel
      Left = 1075
      Top = 7
      Width = 22
      Height = 13
      Caption = 'FTP:'
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 416
    object N1: TMenuItem
      Caption = #29992#25143'(&U)'
      object mniModifyPassword: TMenuItem
        Caption = #20462#25913#23494#30721
        OnClick = mniModifyPasswordClick
      end
      object N6: TMenuItem
        Caption = #20999#25442#29992#25143
        OnClick = N6Click
      end
      object N5: TMenuItem
        Caption = '-'
      end
      object N4: TMenuItem
        Caption = #20999#25442#21151#33021
        OnClick = N4Click
      end
      object N8: TMenuItem
        Caption = '-'
      end
      object miExit: TMenuItem
        Caption = #36864#20986
        ShortCut = 88
        OnClick = miExitClick
      end
    end
    object N2: TMenuItem
      Caption = #31995#32479#35774#32622'(S)'
      object mniCallOnfig: TMenuItem
        Caption = #21483#29677#35774#32622'...'
        OnClick = mniCallOnfigClick
      end
      object mniFTPConfig: TMenuItem
        Caption = 'FTP'#35774#32622'...'
        OnClick = mniFTPConfigClick
      end
      object miUDPConfig: TMenuItem
        Caption = #21483#29677#27169#24335#35774#32622'...'
        Visible = False
        OnClick = miUDPConfigClick
      end
      object N9: TMenuItem
        Caption = '-'
      end
      object N11: TMenuItem
        Caption = #36710#27425#31649#29702'..'
        OnClick = N11Click
      end
      object miRoom: TMenuItem
        Caption = #25151#38388#31649#29702'..'
        OnClick = miRoomClick
      end
      object N13: TMenuItem
        Caption = '-'
      end
      object mniTrainmanManager: TMenuItem
        Caption = #20154#21592#24211#31649#29702'(&P)...'
        OnClick = mniTrainmanManagerClick
      end
    end
    object N3: TMenuItem
      Caption = #25968#25454#20132#20114'(&T)'
      object N10: TMenuItem
        Action = actImportTrainmanInfo
        Caption = #19979#36733#21496#26426#20449#24687'...'
      end
      object E1: TMenuItem
        Action = actExportSignInfo
        Caption = #22238#20256#25968#25454'(&E)...'#13#10
      end
    end
    object N7: TMenuItem
      Caption = #26597#35810#19982#32479#35745'(R)'
      object miQueryLeaderExam: TMenuItem
        Caption = #24178#37096#26816#26597#35760#24405#26597#35810'...'
        OnClick = miQueryLeaderExamClick
      end
      object miQueryCallRecord: TMenuItem
        Caption = #21483#29677#35760#24405#26597#35810'...'
        OnClick = miQueryCallRecordClick
      end
      object N12: TMenuItem
        Caption = '-'
      end
      object miDCJL: TMenuItem
        Caption = #24453#20056#35760#24405#25171#21360'...'
        OnClick = miDCJLClick
      end
      object miQueryRoomState: TMenuItem
        Caption = #25151#38388#29366#24577#26597#35810'...'
        OnClick = miQueryRoomStateClick
      end
    end
    object miHelp: TMenuItem
      Caption = #24110#21161'(&H)'
      object miAbout: TMenuItem
        Caption = #20851#20110'..'
        ShortCut = 112
        OnClick = miAboutClick
      end
    end
  end
  object TimerSystemTime: TTimer
    OnTimer = TimerSystemTimeTimer
    Left = 464
  end
  object ActionList1: TActionList
    Left = 680
    Top = 368
    object actF5: TAction
      Caption = 'actF5'
      ShortCut = 116
      OnExecute = actF5Execute
    end
    object actF4: TAction
      Caption = 'actF4'
      ShortCut = 115
      OnExecute = actF4Execute
    end
    object actF3: TAction
      Caption = 'actF3'
      ShortCut = 114
      OnExecute = actF3Execute
    end
    object actF6: TAction
      Caption = 'actF6'
      ShortCut = 117
      OnExecute = actF6Execute
    end
    object actCtrlI: TAction
      Caption = 'actCtrlI'
      ShortCut = 16457
      OnExecute = actCtrlIExecute
    end
    object actTrainman: TAction
      Caption = 'actTrainman'
    end
    object actRestInWaiting: TAction
      Caption = 'actRestInWaiting'
      OnExecute = actRestInWaitingExecute
    end
    object actFingerLevel: TAction
      Caption = 'actFingerLevel'
      OnExecute = actFingerLevelExecute
    end
    object actImportTrainmanInfo: TAction
      Caption = #21496#26426#20449#24687
      OnExecute = actImportTrainmanInfoExecute
    end
    object actExportSignInfo: TAction
      Caption = 'actExportSignInfo'
      OnExecute = actExportSignInfoExecute
    end
    object actF10: TAction
      ShortCut = 119
      OnExecute = actF10Execute
    end
  end
  object timerAutoCall: TTimer
    OnTimer = timerAutoCallTimer
    Left = 544
  end
  object timerDBAutoConnect: TTimer
    OnTimer = timerDBAutoConnectTimer
    Left = 584
  end
  object timerTestLineBegin: TTimer
    OnTimer = timerTestLineBeginTimer
    Left = 640
  end
  object timerTestLineEnd: TTimer
    Enabled = False
    Interval = 3000
    OnTimer = timerTestLineEndTimer
    Left = 680
  end
  object timerAutoRefresh: TTimer
    Interval = 3000
    OnTimer = timerAutoRefreshTimer
    Left = 504
  end
end
