object frmQueryCallRecord: TfrmQueryCallRecord
  Left = 0
  Top = 0
  Caption = #21483#29677#35760#24405#26597#35810
  ClientHeight = 522
  ClientWidth = 1144
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #23435#20307
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 16
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1144
    Height = 99
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object Label1: TLabel
      Left = 239
      Top = 20
      Width = 72
      Height = 16
      Caption = #21483#29677#26085#26399':'
    end
    object Label2: TLabel
      Left = 427
      Top = 20
      Width = 16
      Height = 16
      Caption = #33267
    end
    object btnQuery: TSpeedButton
      Left = 918
      Top = 56
      Width = 70
      Height = 30
      Caption = #26597#35810
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF1F4F994A9
        CBF9FAFCFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFB6C7E0335CA54880B94B73B3EFF2F8FFFFFFFFFFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFB8C9E15184BC7DB5D77FB5
        D65691C34572B1F5F7FBFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
        FFFFB9CBE2588EC18FC5DFA0D3E793C7E0619BC9466197F7F9FCFFFFFFFFFFFF
        D8E5F183ABD15A8FC14D87BE4C85BD5286BB4C81BB87BFDBA3D5E8A5D7E980BB
        DA3F65ACEDF1F7FFFFFFFFFFFFB9D1E6609AC86FA0CAA6C3DEE2EBF4E2EBF4A4
        BEDC538DC179B4D699CCE38DC4DE4F83BCEDF1F8FFFFFFFFFFFFD9E7F2659FCA
        A3C4DEFEFBF9FCF8F3FBF5EFFBF5EFFCF8F4FEFCFA5894C46FABD24073BEBBCD
        E3FFFFFFFFFFFFFFFFFF8BB9D876AAD1FDFBF9FBF5EFFAF4ECFAF4ECFAF4EDFA
        F4EDFBF6F0FEFCFA4F85BB6B95C5FFFFFFFFFFFFFFFFFFFFFFFF68A7CDACCCE4
        FCF7F1FAF3EBFAF3EBFAF3EBFAF4ECFAF4ECFAF4EDFCF8F3A5BFDC5589BEFFFF
        FFFFFFFFFFFFFFFFFFFF62A6CDE4EFF6FAF3ECFAF2EAFAF2EAFAF3EBFAF3EBFA
        F3ECFAF4ECFBF5EFE2EBF44D87BEFFFFFFFFFFFFFFFFFFFFFFFF63A8CFE5EFF7
        FAF3EBFAF2E9FAF2EAFAF2EAFAF3EBFAF3EBFAF3ECFBF5EEE2EBF4508BBFFFFF
        FFFFFFFFFFFFFFFFFFFF6CADD2AED1E6FBF6F0F9F1E8F9F2E9FAF2E9FAF2EAFA
        F3EBFAF3EBFCF7F2A7C4DF5B92C3FFFFFFFFFFFFFFFFFFFFFFFF91C2DD7DB6D7
        FDFAF7FAF3EBF9F1E8F9F2E9FAF2E9FAF2EAFBF5EEFDFBF971A4CD84AED2FFFF
        FFFFFFFFFFFFFFFFFFFFDCECF470B0D4A9CFE5FDFAF7FBF5EFFAF2EAFAF3EBFB
        F6F1FDFBF9A3C5DF639BC9D8E6F1FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFBFDCEC
        70B0D47DB7D7AFD1E6E5F0F7E4EFF6ACCEE477ADD267A1CCBAD3E7FFFFFFFFFF
        FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFDCECF491C3DD6DAED265A9CF63A7CE6A
        A8D08CBBD9DAE8F3FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
      Margin = 5
      OnClick = btnQueryClick
    end
    object btnCancel: TSpeedButton
      Left = 994
      Top = 56
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
    object Label3: TLabel
      Left = 10
      Top = 18
      Width = 80
      Height = 16
      Caption = #25152#23646#21306#22495#65306
    end
    object Label4: TLabel
      Left = 560
      Top = 20
      Width = 48
      Height = 16
      Caption = #25151#38388#65306
    end
    object Label5: TLabel
      Left = 687
      Top = 20
      Width = 48
      Height = 16
      Caption = #36710#27425#65306
    end
    object btnPlay: TPngCustomButton
      Left = 769
      Top = 56
      Width = 32
      Height = 32
      OnClick = btnPlayClick
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
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000007BA4944415478DA9D97095054471AC7FFF3E6E0C670CA00
        1E1092081EAB827268484CD48A1CA3C89A72B5346E74091B754112B3E80AD900
        4A598904568DB231A430A71515079850D18462D111026288125039550E91C3A0
        08CCF1DE6CF76326C19199C1F4D43753D3FDFAFB7EDFD1FDBA0598600B8ACF71
        B47699B6856384AF7160E6E874808E7C6813D08F0060C05D6138367FA4EFE6B1
        4B4713EE4F44AFC0D278E88E4F7D197BD7335612C9ACA8406F04F9BA21D8CF15
        12E1A353D5AC0E3F36F5A2BAB9078ACBED50A9D575DC60EFAA8A0FFFDA02E849
        9F1040B838A5F023B1441297183913B279DE604967DB3D169D0F583C50738F3C
        EC2061E0E920C474272184E4BFBCA61D3925BF40A356FFF742BAEC4DD2C53E09
        80382C557133D8CF5D9ABE3690E00B507B67042DFD5A3ED4827126EA0C42BE7C
        9DC5982BB502C772483D51834BCD3D5DCAB4C869645833110071484A51DBDF97
        CFF4DCB0D8078DFD2C7EEA1A01D105861A1798A636007044840C304F6A0D3F67
        21F2CA1A91577AA3B3223D6ABA3184B12EE279F1ADB8A5011EEB9EF741D56D35
        6E0D6820B460D81408290B4C9D244690B704F9A53770BCBCF18E322D6AEA5888
        B13A8561BB4EE52EF49FBA79FF862054B7ABD1715F0B86A1D56D1436C1E8349D
        4E671684560947BEBC1C4508F492E0EDFC2AD436B67FA2DC17FB86A1260C0082
        3F6D489FE13A6361FD57894BD137A2435DB7EA37CFC73686E44144E34BA6B244
        3B47C41C872112B3275BC141C4617D4E29EE355607FCFC59CA353A6C502F09DB
        23AF4D889AEFBF648E372ADA877972C6C838F55C2C6270BAEC2AAAEA6FE183ED
        32A8352C0F622E1AB426682443A7D84051DD8A6367EB1A9419B2B96448CD9BF0
        0E91793E17BDB5A3E09DE5A8BBAB41EF43ED63C60DDE5B8945D8795881FD9B82
        F1765E25B2FF110D9546AB87805908373B11FC9C4458F3FE77682A39E2D55E59
        D849CD0883938EEF92BD383F3D6EF94C54DE1EE6732E3001602D1123E99002FF
        FECB02BE2FF5F31FF19F4402A1D6426B06825F1DE43774AA0DB2E4B528ADBC9A
        5299B531939AB109DB5D5093B26E91BF8FA70B59EBEA71BD3700D81080C483C5
        487E35087B4B6E2025E259647C558583893202C1EA21C6A7A05178DA45822B4D
        5DC83E53DDA0DC1B13484D3985A62AFA4FFD7305DAEFB3E81FD65A0448C82946
        626C1072CFB7F155BC6D892F32BFACC4E1B76466234123E062238203A3C1EB87
        CA70312DC299CE770B4929BE5BF26E24EABB3518225BACC002C0F6EC226C5D1D
        8413359D0456002D29F3F8F069782FFF027277AEC2088560B9C7E653263B8910
        5EB6C0DA036751911EE94E4DB987EC29EE561080EB3D1A0C4F0060EB8745D8BC
        72014AEA7BC8521590D0EAE0682DC22B01EED8FFC5791CA59120ABC33815F4AF
        8D1583196E6244BCF72D2AD32327FF0E901A896BBD1A68589DC91D8F02D85A89
        F1C607726C8C5E88F3CD037CBAA8627B6B215EF073C6812FCBF1F1CE95FCF2E4
        8C0168C1913DE419371122D28C008A0940739F162A123A4B007F7B5F8EB55121
        A8ED18E49FA58AC37D9FC2E113E5C8DF1543A2683A05D622212689586CCAF99E
        A66014203445D1FDF53B11B8A7E230A8622D0088B079BF1C6BA2C370FDEE30BF
        390578D8E1F8A9327CB67B35C93F677225D01E9A2AAD6A18DB8FFE0FCAB4081E
        C02D34F9A432FDF5A5CF784F7644FF90D62C801D01D89429474C5438DA075490
        4E92E0B4BC0C5FA4AC269EB3BCE7E63624573B312E5CB98D638AEA466566EC22
        7E19CEDB92B567CDCA579236BEECCFBF80601640888DFBE490C95EE2735C50F0
        3DBE7E971857E9CCEE017C23D19AE228E4F78DCA0A65D6E58F9332F88DC8718A
        BF7F78C2E19ABC8425E81E6431A2D19904B02100EBD3CF202A66050A4F2AF04D
        DA6A0C91D459F29C365B31036B4687D7B2CEE26ADE5B8103B71B1AF8AD988847
        48F237E509B18B7C17CD94A27788C378DAE89A971025B98597F1C34F6D906750
        E3D01B376F9DD68A9B1D83CF7FB88642E52F2D1733FF1C4EBAEF18D2FD9474FE
        F2C50BD62517E5C42F8186D81F528F7B8423279DD137E2439596AF682D67D973
        DA68EA582D872DD9DFA1B9283BBAEBF2D90BA4FBD7DF5EC744A441DB727396BD
        10BA3261D56CFC3AAC835ACB8DAB8C3F1D912FEAB545E3E4596BB2F69DEC04D8
        91ABC4F5867A79F5C1B80432D205C3EB78F431D813F109D95D50BA2336C4E5F9
        D91E7840C2AB310131A146B45A11E38E36C091E27A9CAB6EEC53EE5DF5121969
        253288310712E86BC185886F70F2E9A2A457435C5F9C2325A106545A9DC51C1B
        375A2F566201D921814385753857D5D47B715F4C3419A2F7843E181DC90C4D4C
        C4958FC4AED3452F07FA39C745CEE68F66B424E8E6466F43A6580CA91151CF89
        A6FB432C0E9CBC84FA96AE7EE5A871EA792F4C1C4A8D21A605BE79648F97CF73
        91EB97FA63D95C0FB24DD394E84174BF5F77047AE364814044666B89FA33152D
        28B8D884818E56C5A58FE233C823378D8D9B0230403811F1709F153ECB3772DB
        5E7777B7E9A1FE52840578C2D7C301F6568F02D054FDDCDA8FCAFA4E281B3A31
        FC60A0AD5971E85F77EBCAEBC8F01D22F730C18BC9D89AB0D5D7859BAD8BD7E4
        A757C447DB4A9F5DC658DBFB18BFE968CE75AAC1D6875D37CE357F7BB468A8AF
        A39B74F7E8F33D8427BC9A8D1D17EB41EC8838129944C4068F5F17E872192632
        4084DE8C1FEA0D53AFFFD0E574BC88D0FD82D4354418FF7A485F242344D4A63C
        366EFF07D6505C0A30440F7D0000000049454E44AE426082}
      DisablePngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C0000072A4944415478DA9D577950D35710FE022440450E490282
        7269C550CFD1BFB4D80E1E2010A0A376B4D656DB4E0551115B405B944BAD825A
        C00BB1073AF52FAB82802228586C511951AC0E88AD10A8E5466E948484EEFB99
        304013127D333B99DF7B2F6FBFDDFD76DF3E1E0C1CA1A1A1962291E80B1E8FF7
        29C9ACC1C141306183BE39A1EF3F494EB7B4B4FC70ECD8B12E43CEE5E95B8F88
        88701B3F7E7CA680CF9F3167EE5CB8B8BA62CA94293031361EB17140A9C4D3A7
        4F51535D8D07E5E5902B148FBABBBB83929292AA6979F04D0018C7C5C51D3715
        08BEF4F6F1C69C397331A81A445B7B1B3A3BBBF1F2E5CB119BCDCCCC60656509
        5B1B5BF08C807BF7EEA1203F1FFD72797A4C4CCC26DAA27C1D00FCF8F8F8DAA9
        53A74E5CB1622554832AD4D737A0B9B595FB0373B7B6C185857EC542211C1C26
        727317CE9F679E69D8BD7BB7337D2A0C01C08F8D8D952D5DB2C461C1C285686E
        69C53FCF9E71876B623DD6D07083ED9B3C69124422216E1617E3C68DA2FA9898
        5897D120469FC627B7D7797979D933E535B532B43FEF20971AC188A78F2E2387
        8A0151A93061820D9C273BE1E6CDDF505C7CB391C2E1341CC4F0538DC94D27DD
        DDDD3F5FBD660D6A6575E8E8ECD06AB5E65B9305FABC616D6D0DA7C99371F6EC
        590AC7DF3F5278376A38A13999B77EFDFAE9342A42376F465F5F1FEA1B1AB52A
        37226F18AB3340451632190B880684C3447B080402A49D3881AAAA2A8F8C8C8C
        C76C5973BA80E25EEEEBEB2B91483CC8F5B5EC9F5A2D373131416151111E3FAE
        C296CDA1502814044289B19CC10124E06ECECE282FBF87EBD70B2B2914736849
        CE6958B06081434040C0BFE1E1DBD1D0D888EE9E1EAD64635CA07A80A3478F61
        C3FA4F70FACC2F54A036A941E8F7C4780B0B086D6D919A9A829C9C1CC7929292
        7AA6C538323272A7A7A7678297D76254CB643AD9CEDCCFDC987AE4283E5ABD8A
        4BB973E72E7020E472F9982034293AC5C505972FE7A2B4B474576262E2774C8B
        39B9A36CE5CA5512B19D1DDADADA74A69A06404AEA11AC5AB902E7CE5FC087F4
        9B9975099B42361288B1C3C140D8DA0A515B27C3E59CECCAD8D8B8794C930DB1
        F27958D836747675A19708A80F40724A2A3E080A4441C1356E7EF9721F646565
        932742C6F4049BB318370E021363A49F3A855DBB764D609A4494FBCD91513BD0
        48F167078C05C0D4548043DFA720502A45C9AD5BDC5E25DD03CB962CC645F244
        684830BB07B8392D08C02703AC2C2D89474740692F669AC404A0292272079A9B
        9B201F18D0599F5F0130C5C18387E1EFEF4B8C7EC0CD318BCDCDCD317BF62C22
        572E42080423E6682FB02F0165911D853A29713F0188B11B0620124D4D2D5C0C
        A1074062D221F892DB1F573DD15CC3741999422271476EEE15846E0AD10A800D
        96C662B188001C180920322A0A2D54F707C803FA001C484C828FB73764B57543
        0024D3DD71392F0FDBB66EE1C2A8350434F894C62C8CAC2051085E012012366D
        D91286172FFB3826EB03F0DDFE03F059B60C0D4DCDDCBC23DD7C05D7AEE1EBAF
        B6EB4D47A65CA950E2E78C9F18093900A2E8E8E83F3E5EB7EE6DA15084DEDE5E
        BD00F6EEDB0F1FEA11DADB3B60656D85A2C242444546A0BFBF5F6F41B2A06254
        595181FCFCAB7F91E10BB9340C0E0E8EF6F7F7DFEEF9DEFBE8EAE81813801901
        88DFBB8F42E0C3292BB87E0DBBBFD9C92957EA51CE9459D9D8E0E2855F515272
        EB705A5ADA1EAE1039393949C2C3C3CB360687A09B6A8142070F786A0071F109
        58BC78098A8A0A298ED190F7BF8AB9BEDB91957176919D38711CE9E9E9F3EAEA
        EA2AB9524C624F61280E080C74739FE68EDE172FD855F77F00443846A2CC4BD9
        B87FFF3EF6ED497865B901CA19785684A827C0EDDB25D50909098B68BA5193F2
        D6F3E7CF7F77EDDAB5D91B367CC61DC88A89AE30B0546283EDD317F321F25101
        52528A9F4C4B436666A6F4EEDDBBBFD374C7D0754C32312C2C2CC5D37351205D
        CB5C4FA02B950C6D483483011E47D69F3993818A8ACAACE4E4E4309A6E80E63A
        56F3C382C49572B3302020D056E2E1C175BEBA40183458FF4031675532FF6A1E
        EB94DBA8E678D14A0D490F8635245073C196C48DF2333B282848E8E1F10E11AC
        9FEBF90DB57628545CF34245872A645EDE15949595B552DA496989BD13DA30AA
        25D30C3E8990798281A0B7C084A5CB967271570C100843C8468A8DC86A3EDF04
        2F288C9772B2515B237B4E964BD596B74247533A1A84F3D6AD5BA35D5DDDFC16
        2DF2C4AC59B3873A1F6DC4E314ABFB45956A00A5774A71A7B494DE13F5B9A9A9
        A97B684BED68E5BA006840D890D8CF9C397386542ADD2B168B5DA6518A52D74C
        B7993DB95630E20FAC16C8A88D7F5255C59A4EF4F4F4C8B2B2B2BE7DF8F0E123
        5A6E246987810F93E19C784BCD0B915028B4F3F3F3933A3A3A2EA59BCF55A51A
        1C7108CB73226D0D595C40FD5E766B6B6B134DB7A8E3DD87D77C9A0D5FE7AB81
        8C23B124B12231673C1BB597552EAA60E824612FE35EB56266F51B3D4EB57984
        F9DD8CC444CB7F991256C3D9AB55AECBE2D1E33F56D4770AABA0245900000000
        49454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 7
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object btnStop: TPngCustomButton
      Left = 845
      Top = 56
      Width = 32
      Height = 32
      OnClick = btnStopClick
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
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000007C74944415478DAA557095494D715FEE69F8D61B3ACB2A9
        40481515AA42238B4B34EAA90C9BC5E4E4E0D198C4106B6840D21AB1604F01E5
        A4391248894B3526DA36E9A2C200134FB4E544EB0015340609A8AC460491C5A0
        6CB3F7BE61068661504CEE9C3BF3CFBBFFBBF77BF7DE77EF7B3C4C9342B71738
        DAB8CCD9A6E3F8AFE8C005EBF5809E3E8C78ECC30338E86A399DF6C448EFED63
        3587531E4E472FEF49F2F09D9FF873F6AEC56291686174880F42FDDDB034C015
        22FEC4A92AAD1EFF6BEA41757337E457DBA154A9EA74033DF1951FBCDA021891
        3E2500FEB2CC92834291282955BA00B18B7DA0A5C1B6075A743CD2E2914A37E1
        650711072F073E7C9DF8E0D37FD99576149CFD166A95EACF97B26377D090F669
        000823F6CA6F2F0D70F7CC7E3984E0F370EDDE085AFA340657F3AC4CD49B98BE
        FC9D8558E429864EABC3DE7F5C414D7377A7224B3A87C4EAE90010866596B6FD
        6ADD02AFCDCBFCD0D8A7C5D79D23205DE09871DED4A84D0074C47C0E58EC6983
        00673E8E7FD588E3E5B73A2AB3A37D2D4158EAA295977D97B466BE47E2723F5C
        BEA3C277FD6AF09F60782A209416983D4388501F114E94DFC2C98B8DF71459D1
        B3CD4198EBE447A49F3EF25CE0ECD7DFDB1C8AEA7615EE3ED480E35876FF3062
        59A2A32F6F470142BC45F8CD89CBB8D6D8FEB1627FC29BA69C3001E0FD6C73F6
        3CD779CFD57F9EBA06BD237AD47529C7566E788137BADD9EE806E3F6D41BF3DE
        E489A09962380874D854508E078DD5F3BFF94BE60D2636A9134564C8AEA5442F
        095C15EC83CAF6610372CE28E5E8414041E53377F0788FCD0166514B93359434
        3ADD280AF6C3A686CF92405EDD8A63E7EA1A1439B18B48A432E8F2098BF59A1B
        F3D6DDA25DEB50775F8D9E41CD98711E19140A389C2ABF8E9A9BEDE32E99D203
        7A84CEF5C1C6D541506B74F4771C849B9D00014E02BCF8FE97683A7BC8BBBDAA
        A48369E32F4D3B991EFBFC92ECA4750B507567D81073931D8E1EC42201D20AE5
        C8DFB6CC38662D7FF5302E18A9C72E212F594AC5484363FAB150B09C089F2D41
        9EEC1ACAABAE6756E56DC9655A24117B8AAE64264606FA79B9D05E578DADDEE4
        7E1B9110A91F9621776B04324B1A20A47058AB036A727B766C20D23FAD40FEDB
        D11851A9C7C260F2C2332E22D4367522BFB8BA41B16F4308D3E314BE57DE77FA
        DDF5687FA845DFB0661200090178BBA00C1989E128BCD06628C39691602B64E5
        3879A52F723EABC48729D118B60440EC2211C08153E3B5C2AF509115E5CCD4B8
        856596DD3FFB7B29EABBD418A212CBB3022039BF14EFBC1486CF6A3A20A48CB2
        06404DC99718EA8503FFAC42616ACC2400ECC94EC487B72DF0F28173A8CC96BA
        3335EE6119655D720270B35B4D93AC0378EB8312EC480887BCBE07028E673504
        1A32269DEF8A83A72BF1D1CED8C900E85122E630CF4D88A83F7C81AA6CE9CC71
        007BA5B8D1A3A638EA272867006CC542BCF9BE0CAF6E8880A2A5DF5066AD0160
        E53AD27F063E29AAC091DFC6614839D903129AFCAC9B0051591600CA084073AF
        064AD2620DC01B7F9461535C246A3B07477B821500CC56B0A71DFE2653E0E82E
        EB006C047CCC1068B1B5E0DF2C04A300C233E55D7FDF1585074A1D06945A2B00
        0478FD3D1936C6AD445BDFD094A5992599AFB32D4EC92EE0E3771900CD24008E
        36026894C3F8F5E10B5064451900B885EF3EA5C87E6DCDB33E331DD137A49904
        C08E006CCD2DC686B8D5E81E5093DCFAF98205CFCD5E882259393E4D8FC7A005
        0046AE76425CAABD8363F2EA46456E42A4611B2EDE9697F162DC2FD2B6BC1068
        6840E6C40A9144CCC796FDC588FBE57A8C6834781CD90804909D398B937BE231
        4CDE3415220391AE598E7CE47C7E1955958ABCAB47D3720C85C8715660E08A94
        8FAE1C4F5985AE012D46D47AF339100BF9385AF635FE5B7B9B1AD4E34BB1960C
        2E0F9E8337A21743A9D6C2DCBEAD90830DA7C72B79E770FDF83B21FD771A1A0C
        A598D8236CF7BF2EA62444FA472EF044CF900EE6335913120AA82171D36A05B4
        1DA92668469BD2F842283C761CFEFA9F1B28517CDB5291BB71050DDF33A9FB89
        E79275CB7E9EB8BBB460FB2A2A28A08234F108C73375C169B5638C352113D951
        18B5846C5BFE97682ECD8FE9BC7AEE120D7F3FD68E893D43938F14AC5D191E97
        121F84EF87F5506974F8D144166C68EF3BD9F1B0F38802371BEA65D57F4A4A21
        49274CEDD8B82E7B62BFB03D45E53B13C25C960779E091128696FA638C8BC9B8
        A3043854568FF3D58DBD8A7DF1AB49D24A3C00B303098CB9E042ECBF74F799D2
        B497C25C9F0FF6A4AD042835FA492E7D1219DAB890077B1BA0B0A40EE72F37F5
        54ECDF104322764FE885C591CC444262578327D2CF94BE1012E09C240D321CCD
        584AB0526B7EDC9AB460DE68AE080C3B077838A4C5815335A86FE9EC538C1A67
        2BEFC11487524B107342761CCAF0F69B2BDDB426106B1779509966213102D18F
        5F777846E3B4CB20A0D91A525F5CD982A28A26F4DF6D95D71CDC9E43AFDCB634
        3E1500130827620FF7852B16FA4B93F7B9BBBBF986077A2262BE17FC3D1C602F
        9E088085EA9BD63E54D57740D1D081E147FD6DCDF2C2DFDDAFBB5847E27BC40F
        30CD8B89794ED81AF3C2CDD6C57BE633EBB7C7D87AFE742D6763EFA7B388038B
        B95E39D03AD879EB7CF317874B877AEF76D170B731DE4378CAAB99B95C680462
        47EC483C835882C9D705B65D8689FB89D9CD78D06898ADFA075D4EAD7984D50B
        CA6B0860BD23B3463142AC9A6AC596F47F984D4D0AF19985E80000000049454E
        44AE426082}
      DisablePngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000007514944415478DAAD577950946518FF2DCB721A08BB201E
        DCDA8039469E246A066976805D86302992A6725BFF381E79945C5A71E4313535
        69A3E1395958D6982B3A22A3E131B9015DC0A2C2A21CC9212DCBEEF63CDFEE32
        BBEB07A2F5CC3CC3F27DEFFB3CBFF7397EEFF349304459B76E9D879F9FDF7247
        47C724FA77223F331A8DC23B89446259F64B5F5FDF5E8D46F3594E4E4EC750EC
        4AEEF73E3B3B3BC4CBCBEB984C269B1016168631A347634C40001CA5529B857D
        7A3D6E3434E0C6CD9BA8A9A9814EA753B5B7B7BFB47EFDFA5AC6FA3000A43B76
        ECD8E5ECECBC222A2A0AE1E1E1D0EB0D686B6FC39D3B1DD06AB5368B691D3C3D
        3DE0EDE50DA9D4015555D5387FBE9CD77D9A9E9E9E4A4BF40F0240B67BF76EB5
        BFBFFFC867E6CE85C160406363136EB7B408E1B60AB98D704A587D140A8C1A35
        928C4B70EAD44FB87EFD7A534A4A4A202DD10D05806CE7CE9DF5919191A3229E
        7802B76FB7086165C38339B707C1EB385D3E0A392E5FBE8C8B172F36A6A5A505
        D983B0B726DBB56B57C3B469D3FC1E8F88809A72DADEFE37240E0E7090DCAF5C
        6CC5C04028725E5EC311E0EF8F2B57AEE05265A526353535C01A84B555696161
        E12763C78E5DF6ECFCF96868B84EB9BE33A453DF2F1A9E9E9EF0F71F831F4E9C
        405D5DDDE75959592B2D3561B12CC9C8C8089B387162D5A28404747777A14973
        CBC6793F88C1C0188D36CEAD418CF41B011767171C3A74102A956A7C7171710D
        BFB65873A28ABF3A6BD6ACF0E0E010D453E861CE238B03A5404A6DC77F2516D8
        665FC67B309842AF27E5E2ED0743B6820303F1DB6F35B870E14235D54304BDEA
        15EC4547478F4A4C4CB899F8C662DCD234A3A3BBBB3FE70C82C807CA534AD4FC
        FEBBE05B880C01E2DF0E4294089883295AFC6CDCB87198113503FABEBEFE4870
        4D780C1B06B9DC1B074A4A505252325AA95436F27A696E6EEEDAC8C8E9EF4F9D
        3A1D756AF53DA17772724271F1C7C8CC48378559340DC67E675FECF912C9C94B
        998CEE490547A1BCFC1C77C6BB6BD7AECD654BAE948F4BCFCE9B17EE4924D2D6
        D66653741C76065058548C952BDEC2B7A5DF0B4423267A62C3B8D8E7B1FFAB03
        58F666327A7B7BFB015840C8E572346B9A70A6ACAC3A233373327BF222D2694B
        484C44474727BAEFDE15055050504846DFC4E9B233423DD877061B6700739E9A
        8D43870F63F9F265A200DCDDDCA8189D70F4E851103979B3151FEAFD5B494B93
        D1DCDC2C844D0CC0871F1560C9E2C5B8F873A5A918450070D14D9D32195F1F3B
        46D15A8E5E6DAF907BEB2E91912D0F8F4770E8C001A4A4A6FAB2155F02D0BC24
        299958EF1674740A6BD3EC8C797EFBF60FB0283E1E2AE27807116E30013062C2
        636138FEDDF758B56A25B41C017327583A46267584AFAF0FF6EEF902444A23AC
        002409B46BB0DA600D207FDB76BCBE7021FEFCAB56782626BC37342408277EF8
        11A929AB8414D8DBE38E52103DEFDDB3C70EC0D224B4B5B683EE73510079F9DB
        F0F22B2FA3F166D3A097115F42274F9E445A6ACA8000DC5C5D7098EA846AC004
        808AB079517C027AB43DB449270A2027370F0B16BC84D6D6560C24962A572A4F
        21233D4D1480B3B30C06BD11A5A5DF529A5609007CE80E287FF1C5D8711EC387
        A387BA400C40764E2EE2E216A0B3B31383C930229BD3A7950267880170777787
        BABE0EE7CE9DFB83EE8428A10DD7AC59B3E1B9F9F3DF899834199D1DB6931417
        1C03782F3B4700A0E31419071C7084103380B7B332A90BB4B65D40C2872CA308
        5554547C949797B75520A2909090F04D9B365D7AF5B585E8EEEA3239310BE79B
        C63122A0E3B876ED5A3F4BDA52B144B8B285DA20878F4D188F79CFCC15EAC99A
        0764048E011E397218F9F9F9936B6B6BAB052A26F52B2828381B1D1313121810
        88BB3D3D36A7E434F0462957FF1006122624569BF0D35E7757575CBD7A856783
        DAD5AB57CFA6A71A8BB5E134F7CD5CB16265695C5C9CB0B157675B8C439D0B8C
        261436276771A2281A8C061CA1EADFB76F5F6C395F08C0DFFDD731E9C8CD9B37
        173DF9E48C053367CE440F45814FF17F0853B71B51F0F1E3A5A8AEAEFE86D29D
        458F9B60B98E61BAE1879106D3C5A49C33E769797068A85044FF15849452E742
        455C71BE82C6F5AA569A90A3E9711D6917AC0612612DA99C3484DAB234262646
        111A3A56682506611CA4F2C584D3C527E70EE268575555B5646666C6D22BFE4E
        6032B119C92C22235570248A8A8A4AC3C3C77B4F8F9C2E14615F9F5EE0F5FB01
        B17488CC510AED3F5A9C3D5B4663F98D36B3733E790B06184AED41046EDCB871
        030DA92F4C9A3489A69C4785B6E28F13A3D120EA9C81B2F2A5A4525DC3AFBFAA
        F89BE0BB2D5BB66CA5D76A7BE70301B080F022F59B3265CA84C4C4C46C854211
        1448D34C505010BCBDE5707276B2D9A0230A6F6C6A2496AB875A5D4F8CD955BF
        7FFFFEF59595952A7AAD216DC7103F4CAC6BC2CD5C173EBEBEBE23E2E3E36309
        C05C5757D760D3086609BBC914750E4D74EA93070F1E2C6DE6E102B86DCEF75D
        3CE0A799F57B9919883BA907A927A92B47DC6E2DE785180C774899CFBBCD8EF9
        D40FF5712A16118EBB0BA9A3C85E76C21CFE0F69EF4027B6977F017043660A10
        1424420000000049454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 8
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object btnPause: TPngCustomButton
      Left = 807
      Top = 56
      Width = 32
      Height = 32
      OnClick = btnPauseClick
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
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000008304944415478DA9D97095CD4C715C77FBBFFDDE5522C72
        C8E501218DA858151A593446EBF1A9ACB028499A6AD59818454111628C1AA19F
        004ABC40A2F1A896D4A46DDA4FBD38367CA22DB5D61502621409A80878208802
        8ACAB177DFFC7797EBBF349AD97D7BCC9BFFBCEF9B79F3664684E72C213159CE
        F6AE23971BC5DC5223C4E34D26C0442F5644EC2502C430968B8D86A35D2DB78F
        5C3C18FFE479FA15FD985E9EF085BF7890DB293B996CDCBC605F84F8BB637280
        1B645CDF47B50613BEBBD98CD29A87505DAA8746ABAD303E6B8E2ACA5C560B58
        485F10809B9A94BB5F2A93AD58A7188BC889BE3050E5AD4706343C35E0A9D6D8
        A7F1609918DE83398C72E1C0D1FF9CB27A6415FC009D56FB87F3A991ABA9CAF0
        2200D2B064D5EDC9011E5EA96F0713BE0897EF77A1B655CF0FB5C8C68326ABD0
        87FF50292678D9C1683022F9EF65B858F3B0519DA218496ADDF300484393F26E
        AD9A33D67BF1543F54B71AF07D6317A82F889971D1C0D4560023092706267AD9
        23602887ECB3D5C82EBCD150943A6F547F88FE7D91E7F97756CC1AE3B9F0353F
        94DCD5E24E9B0EDC8F181E0884C20223864811E22BC3D1C21BF8F25CF57D75CA
        BC11BD217AF7C9856D3A7EE8D5C011EF6D5F1C82D27A2DEE3DD1432C66D1CD00
        44E6C622B305B311CB2A1840C7A2C4481F3ECE1204FBC8B0FE68092E57D7FF51
        BD2D7AA53526AC00A25F2C4E1DED36FAD5CAAFD7CD424B9709154D9A6ECFC534
        F6121A538ED1588A817A3618CC001C35ECAFD3D39C19692EAC231134CC0E8325
        462CCA2AC4A3EAD23157BE4ABAC638AD00B2B02D3997E3E74D0A9C31DE1745F5
        9D3CB979CE45904AC43871F62ACAAED7F3FF997721A37DB160FA78DEDDE367CB
        05BAF9AF0741A7379A47C2047E24E5C31DA02AADC391D31555EAB4C8096457CB
        03F886467ABF12117BEFE48639A878A04373BB9E37CE0AF3DE4E2AC1879FAB90
        B97C2A9F7438AA8B3FFC5FEC8C53F0001FECCB17E8B6AF0E8746A7E7478115F6
        E5EE2441808B046FEEFC16370B0EF8D417E7363033DCE4C42F37454E9F94BA62
        CE5814DFEDB4CC790F80BD4C8AC4BD2AA42F95E3E3DC6B3422A47CF4183B62C3
        790FD77D26D47DBA6A2E3AB5BA6E007E75D0B77C840332722EA3B0F86A5271C6
        927466C6216CF3C9B2A4855302FDBC5D69AD6BBBBDEF0D90B0371FC90BE5C82C
        AC8594E2A1BDA909BB6215E49909F19F09753B68043A343D00D65178C95586F2
        9B8DD873AAB44ABD757E3033E5224F56B51EFF682EEA9F18D0DAA917003810C0
        DAAC7C6C786B32BEF8AE810FC8D63B7791B146C1EF07719942DDAE381B0024AE
        0E120C16EBF0EEBEB3B890123E9499720F4DCA7F50F07B052A9B74E8A0142BB2
        01B0664F2ED6BE21C7B12B4D14F562DCAFAE45567C04BFE462337204BACCB5F3
        0400EC97938C838F23F0F6EED3284A557830531EA15BF29B540470FDA18EE6CD
        36406C662E6216C85150D5CA7B79A7F23AF626980156EDCE11E8B2D6D900A09F
        0E76628C769722FC936F509CAA18D60390ACC0B5661D7406539FECC4001CEDA4
        58B92B07CB946150DF6AE3BDACBE5C8103EB2379B7DEDF29D4ED4F8C44BB8D11
        7020FDCBEE1284A7F403C827809A163D3494406C01BCBF23078BC84879633BD5
        71A828F91E873744F25EBDB75DA83BB4DE3680BD84C3108901EF64FD934D8119
        409EA46AFADB86703CD218F14C63B00120E18DFC463915D50FBB782FCBD425C8
        FE48C9032CFB54A83BF2A19200F40200677B09F49A4EAC39F81FA853C2790077
        F9C663EAD47767BDEC3BCC19AD1D7A01801301BC937E0AD111D3E92CA0E5BD2C
        FAF779FC69B3926FB364AB5097BD5108C08A9B9314E7CBEFE288AAB45A9D1E3D
        855F861397676C7953F9EBC4253303F90D0802000E4BB69D823272261E77D132
        E5389C2D28C4575BA2F836BF4B13EA8E6E8E2200435F008AEEE1CE1CD2BE2E41
        71913AE3D2E1C4343E11390F0F0C9C16FF795976FC0C343D33A04B67EA03E040
        008B524F42B9602EE577D289C428C829C05F93CD00BF4D11EAFE921445ABA02F
        80A3540C7BB1094B334EE36AF607C16D77ABAAF8544CE219BAF11FE7E2A3A7F8
        4F19EB85E60EA379CD3000A296D18387722FE15CF96DFE3F6D319816341231CA
        497C9B833942DDCAC849D0EA8C7CA6B46ED9EE4E62FCF95FD790ABFEA1F642FA
        1BD3A8FABE75BA7FE63569CED45F2EDC9897153303F41C25A49E231CDB60D88E
        486F3E47B03E69A3337B4C85E57FA18EB6EB5EDEB3693450DDF23DDFA2266F4F
        44E3A5D3E7A9FA71F7764CE2151277286BF6EB72657C54101E779AA0D5F71C3C
        4596ADB927A998AC83F47F752CA2ED6965B838899070488DEB559539A57B57C4
        93A611D6EDD8DC0C8348FC42379F2C4C880E757D2DC8134F35664F7E72A15EED
        C8B8B3037020BF12674AAB5BD45BA37E459A3A9267E875208125165C49FC276F
        3C9197F856A8DBF4F15E14C980466FEA3E7E3D6F61F160271561903DB02FB702
        674A6E365FD8363F8254EC9ED0827E47326B91B2A5CA8FC4A6137933830386AE
        5004F147331612EC64CC76BF8158AC53C18E04943CF1A4C380DDC72EA2B2B6B1
        556D36CE3C6FC60087D2FE102383571FD8E2E3F78A62D1AC40CC9EE049699A4D
        8905C4D473DD11598CD36281849ED653F7A78A6A71F2C24DB4DDAB535DDC1F93
        464D6EF7373E108015C285C4D363DCB471FE8AB8AD1E1EEEA3E4815E081BE30D
        7FCFC11864D717804DD595BA56145736405DD580CEA76DB76A54FB3E7E5071AE
        82D4F7491EE1392F26BD63C2D11217EE8EAE3EC35E9A1B13E1E8F5F3D962FB41
        7EC67EF3C0E6DCA47956D7DE78E34CCD3707F33A5AEE3551F543CB7C77E005AF
        66BDF5520B88138933C910120798AF0BBD0B5B2E9D246D24EC66DC6E31CCBCFE
        4997535B23C2F205C53524B07D3D641B49178976208FFB97FF0195A2EB0ACCBE
        F8BE0000000049454E44AE426082}
      DisablePngImage.Data = {
        89504E470D0A1A0A0000000D4948445200000020000000200806000000737A7A
        F40000001974455874536F6674776172650041646F626520496D616765526561
        647971C9653C000007C94944415478DA9D576950545716FEBAA11B181144BA1B
        C4C8A6238189442BFE483038538C64511BACA8E5244636155004C49498545056
        3748145023211B4995FF261908C4181297E0040D250C060742506888C30E826C
        D24D77CFB9977E4C6F8EE8AD3ADDEFDD73DF3DDF59EFB922CC7224242438C9E5
        F21D229128922850AFD783111BF4CE89DE7F21FABCAFAFEFE33367CEDC9FCDBE
        A247F1F7EFDFEF3B77EEDC52A944F2CCF2152BE0EDE383C58B17C3D6C6C664E1
        94568B3B77EEA0ADB51537EBEBA1D6686E8D8C8C6CC8CBCB6B25B6FE4900D864
        66667E602795C6BEFCCACB58BE7C05F43A3D06EE0D607878040F1E3C30596C6F
        6F0F676727B8BAB8422406EAEAEAF07D652526D5EAE2F4F4F4DDB444FB380024
        595959ED4B962C59B071E326E8F43A747676A1B7BF9F7FC0CC6D6D70B7D0BF42
        268387C7023EF7D5975F32CB741D3A74C88B5E35B30120C9C8C85085AE59E311
        B46A157AFBFAF1FBDDBB7C73C1D7FF6F08B1C1D62D7AEA29C8E5325CADAAC295
        2B973BD3D333BCCD4198EF2621B377848484B833E16DED2ADC1B1C22938A2116
        3D2A5C4C878E01D1E9307FBE0BBC1679E2EAD51F515575B59BDCE1690CC27857
        1B32D3877E7E7EDBFFF6FAEB68577560687868466B4173F63B1D514C53C326E6
        3C832B046BCC9B370F9E8B16E1DCB973E48EDB9F907BE38498100088A2A2A29E
        A6D198B0670FC6C7C7D1D9D53D23584C16B0A1A81789E91D3CDD785CE8B4BA69
        E40FE1E9C80202088F05EE904AA5283A7B16CDCDCD01252525BF328C020029F9
        BD7EEDDAB5FEFEFE0164FA76AE8500C0D6D616972E5F414B4B0B7F168B6DB0D4
        6F0956BD10C435B8688DF7FC0B989A9A9AB10431E0EBE585FAFA3A5CBC78A989
        5CB19C586A0E202828C8232C2CEC3F2929FBD0D5DD8D91D1D1FF99953EA41A80
        53A74E2329710F37B288F2ECB392CF111515C9D714169EB2E045446C8346A399
        2956EC7FAEA32364AEAEB4BE001515150BABABAB3B99149BD4D4D477828383B3
        4342FE8A5695CAC4E7CCFCCC744C487C6C2C4ACB2BB8C94747460840045F5350
        5068C18B8CDC86C9C9491300EC69B1B737CE9FFF06353535077373738F32290E
        648EDA4D9B36FB2BDCDC30303060926A02807C12B22326063F5CBACC850C0E0E
        202A721AC0C9FC020B5E648429000184ABAB0CED1D2A9CAF286FCAC8C87C8E49
        72A1A81C4C4EDE8BE1FBF7314601680DC0C993F9888A88C04FD7AE434C427ABA
        BB101313CDD79C3871D282171D1D651580E39C3990DADAA0F8A38F70F0E0C1F9
        4C929C72BF37F5C0DBE826FFABD56AAB00DE27215BDF780375FFBA495A8A71F7
        EEEFD8B93D86AFC97BFF84056F3B815313009D110016D812DACBD9C909A74F9F
        02A5BD82495210809EFDA96FA3B7B7076A8A5CE3E2C000D8D9D9212FEF3D6CD9
        B2054D4DBFF2486F6BBB83B8B858BE263737CF82B773E70E760EF06234239FA5
        1B658A1BB93A2FF7180148773302908A9E9E3ECA5DD3334300709C846CDEBC19
        B76FB7722D5B5A7EC3AEF838BEE6D8F15C0B5E5CEC4E6E4D9D11003658AA2A14
        720270DC1440EA8103E8A3BACF72D71A002664E36BAFD1B9D0497E16A3F1DFB7
        90B07B175F73F4D8710B1E03670D808452DACE6EBA20910BA6015010F6242626
        63E2C1387DA4B10AE0C8D163D8B06103B9A98FCFDDBC59CF739FC54BCEE12316
        BCC43DBB29082D0130E15A8D966AC5A72C083900795A5ADA4F6F6EDBF647994C
        8EB1B131AB000E1F398A706518EE0D0FF3B9DADA1B484E4AE400B2730E5BF092
        1213AC0270A462D4D4D888CACAEF5A48F1553C0DE3E3E3D3D6AF5FBF2FF8CF7F
        C1FDA121AB00B2494BA5321C1313D3697AED5A35DEDA9BCC4E226466E758F052
        08DCA4990B9830671717FCE3ABBFA3BAFADA89A2A2A21C5E883C3D3DFD535252
        6AE3E27761846A81C6280E5829B627B36564E5208CB49C9AD2329974B4FE88B7
        F6A57081E9995916BC7D297B2DB280957456A8CE9EFD00C5C5C5CF75747434F1
        524CE44E6EA80A0B0FF7F55BEA87B189093AD0A73F640258E0947D5D81865B0D
        B0A567D61B2C0B0CC4AB2F8572AD4AADF142D77045661A5752841521EA0970FD
        7A756B7676F66A9AEE16527EDECA952B5FDCBA756B7974740CB4D460525369E2
        06963E2CC5201CB994AE4C6321B5ACF18CCD4FBD25B434FF6151114A4B4B9537
        6EDCF8274D0FCD1CC7440B9293930B82835787D3B1CC7B020664C615EC809A7E
        3069381EC51300CE21EDBFF8A2048D8D4D65F9F9F9143CE882701C1BE2C391C8
        8772F3525858B8AB7F4000EF7C8D413CF660BD04F9DCC1C10195DF5D609DF200
        D59C10E2B4118DC2A8218121165C897C293FCB29AF6501017FE2F59CF5FCC61A
        CD668879234345C7DE0E172E7C4BA959DB4F69A72416BB270CC0AC2513868448
        C62CC140D05D607E28051A8B010DF9543F0B20BC8523AD25125B4C901BBFAE28
        477B9B6A9034571A34EFC7439A5273105E494949693E3EBEEB56AF0E4660E0B3
        BCC3618125F47A16820DBDA34E37859A9F6BF0734D0DDD273ABF292C2CCCA125
        EDE6C21F064000E142E4BE6CD9B267944AE5618542E1BD945294BA663ACDDCC9
        B452930FD454F554D4C6FFD6DCCC9A4E8C8E8EAACACACADE6D6868B845EC6EA2
        7B98E5C5C43826FE60880BB94C26735BB76E9D72E1C285A1F6F6763E3A9DDE64
        1396E714B46DA4F1F7D4EF95F7F7F7F7D0749FC1DFE378CCAB99315F62003287
        C889C899C881C599D95A96F454C1304CC46EC66306C14CEB27BA9C5AB308B3BB
        3D91AD956F991056C3D9AD55FD308DCDC77F015B47EF0AA07F31230000000049
        454E44AE426082}
      Stretch = False
      DownFont.Charset = DEFAULT_CHARSET
      DownFont.Color = clWindowText
      DownFont.Height = -11
      DownFont.Name = 'Tahoma'
      DownFont.Style = []
      DownChagneFont = False
      CornerWidth = 10
      CornerHeight = 10
      TabOrder = 9
      TabStop = True
      WordWrap = False
      IsGainFocus = True
    end
    object Label6: TLabel
      Left = 815
      Top = 20
      Width = 88
      Height = 16
      Caption = #24378#20241'/'#24453#20056#65306
    end
    object dtpBeginDate: TDateTimePicker
      Left = 315
      Top = 16
      Width = 107
      Height = 24
      Date = 40880.000000000000000000
      Format = 'yyyy-MM-dd'
      Time = 40880.000000000000000000
      TabOrder = 0
    end
    object dtpEndDate: TDateTimePicker
      Left = 448
      Top = 16
      Width = 107
      Height = 24
      Date = 40880.999988425930000000
      Format = 'yyyy-MM-dd'
      Time = 40880.999988425930000000
      TabOrder = 1
    end
    object CombArea: TComboBox
      Left = 87
      Top = 15
      Width = 145
      Height = 24
      Style = csDropDownList
      Enabled = False
      ItemHeight = 0
      TabOrder = 2
    end
    object edtTrainmanName: TEdit
      Left = 601
      Top = 15
      Width = 73
      Height = 24
      TabOrder = 3
    end
    object edtTrainmanNumber: TEdit
      Left = 729
      Top = 17
      Width = 73
      Height = 24
      TabOrder = 4
    end
    object DSTrackBar1: TDSTrackBar
      Left = 10
      Top = 61
      Width = 730
      Height = 45
      TabOrder = 5
      TickStyle = tsNone
      FilterGraph = FilterGraph1
    end
    object CombQXCount: TComboBox
      Left = 918
      Top = 15
      Width = 145
      Height = 24
      Style = csDropDownList
      ItemHeight = 16
      ItemIndex = 0
      TabOrder = 6
      Text = #20840#37096#35745#21010
      Items.Strings = (
        #20840#37096#35745#21010
        #24378#20241#35745#21010
        #24453#20056#35745#21010)
    end
  end
  object lvDrink: TListView
    Left = 0
    Top = 99
    Width = 1144
    Height = 407
    Align = alClient
    Columns = <
      item
        Caption = #24207#21495
      end
      item
        Caption = #25152#23646#21306#22495
        Width = 150
      end
      item
        Caption = #36710#27425
        Width = 80
      end
      item
        Caption = #25151#38388
        Width = 150
      end
      item
        Caption = #21483#29677#31867#22411
        Width = 140
      end
      item
        Caption = #21483#29677#32467#26524
        Width = 140
      end
      item
        Caption = #21483#29677#26102#38388
        Width = 180
      end
      item
        Caption = #20540#29677#21592
        Width = 150
      end
      item
        Caption = #24378#20241'/'#24453#20056
        Width = 100
      end>
    GridLines = True
    HideSelection = False
    ReadOnly = True
    RowSelect = True
    TabOrder = 1
    ViewStyle = vsReport
  end
  object ProgressBar1: TProgressBar
    Left = 0
    Top = 506
    Width = 1144
    Height = 16
    Align = alBottom
    TabOrder = 2
  end
  object ActionList1: TActionList
    Left = 1052
    Top = 16
    object actEsc: TAction
      Caption = 'Esc'#20107#20214
      ShortCut = 27
      OnExecute = actEscExecute
    end
  end
  object Filter1: TFilter
    BaseFilter.data = {00000000}
    FilterGraph = FilterGraph1
    Left = 972
    Top = 16
  end
  object FilterGraph1: TFilterGraph
    GraphEdit = False
    LinearVolume = True
    Left = 1012
    Top = 16
  end
  object Timer1: TTimer
    Interval = 500
    OnTimer = Timer1Timer
    Left = 1088
    Top = 16
  end
end
