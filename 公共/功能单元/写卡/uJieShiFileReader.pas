unit uJieShiFileReader;

interface

uses Classes, Windows, Variants, SysUtils, uBytesStream,
  Math,uICCDefines;

const REC_LEN = 36; //思维IC卡管理揭示文件记录长度
const REC_SWKDLEN = 32; //思维跨段写卡揭示文件记录长度
const REC_SWKDLEN_SH = 64; //上海思维跨段写卡揭示文件记录长度

const REC_ZZKDLEN = 30; //株洲跨段写卡揭示文件记录长度
const REC_ZZKDLEN_1 = 31; //西宁株洲跨段写卡揭示文件记录长度

const REC_NEWICKGLLEN = 72; //新协议思维IC卡管理揭示文件记录长度
const REC_NEWZZKDLEN = 40; //新协议兰州株洲跨段写卡揭示文件记录长度
const REC_NEWZZKDLEN_1 = 41; //新协议南宁株洲跨段写卡揭示文件记录长度
const REC_NEWSWKDLEN = 40; // 41 新协议思维跨段写卡文件单条记录长度

const JL_UpLine = 0; //交路上行
const JL_DownLine = 1; //交路下行
const JL_UDLine = 2; //交路上下行
const JL_UDOther = 3; //其他


const MT_MAINLINE = 0; //主线
const MT_THIRDLINE = 1; //三线

const DR_FORWARD = 0; //正向
const DR_BACKWARD = 1; //反向

const PASSENGER_CARGO = 0; //客货
const PASSENGER = 1; //客车
const CARGO = 2; //货车

const ZZ_PASSENGER_CARGODC = 4; //客货动
const ZZ_DONGCHE = 3; //动车
const ZZ_PASSENGER_CARGO = 2; //客货
const ZZ_PASSENGER = 1; //客车
const ZZ_CARGO = 0; //货车

const LM_LS = 1; //限速类型 临时
const LM_ZY = 9; //昼夜

const UD_UPLINE = 2; //上行
const UD_DOWNLINE = 1; //下行
const UD_DOWNLINE0 = 0; //下行
const UD_UDLINE = 3; //上下
const UD_NULL = 100; //空

const UP_SXDOWNLINE = 5; //三线下行
const UP_SXUPLINE = 6; //三线上行
const UP_SXUDLINE = 7; //三线上下行

type

    TPosType = (PosBegin, {开始公里表} PosEnd {结束公里表});
  {揭示编辑软件类型}
   TJieShiSoftType = (jsf_SiWeiIckgl08{思维IC卡管理},jsf_SiWeiKdxk08{思维跨度写卡08版}
    ,jsf_ZhuZhouKdxk08{株洲跨度写卡08},jsf_ChongQingKdxk{重庆跨度写卡},
    jsf_SiWeiIckgl09{思维ix卡管理09},jsf_SiWeiKdxk09{思维跨段写卡09},
    jsf_ZhuZhouKdxk09{株洲跨段写卡09});

  ////////////////////////////// ///////////////////////////////////////////////
  /// TJieShiFileReader
  ///读取揭示文件的类
  ///  /////////////////////////////////////////////////////////////////////////

    TJieShiFileReader = class
    public
        constructor Create(strFileName: string);
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); virtual; abstract;
        function GetRecCount(): integer; virtual; abstract;
    private
        m_File: TMemoryStream;
        m_RecLen: Integer;
        function GwUpDownConver(nType: Integer): Integer;
        function jsLbConver(nType: Integer): Integer;
        function GetZeroOne(bytCode: Byte): BYTE;
    published
       property JieShiLen:Integer  read m_RecLen write m_RecLen;
    end;

  /////////////////////////////////////
  /// TJieShiFile  思维IC卡管理揭示文件读取类
  /// 从揭示文件中读取揭示信息
  ////////////////////////////////////

    TSwIckglJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;

    end;
  /////////////////////////////////////
  /// TJieShiFile  株洲跨段写卡揭示文件读取类
  /// 从揭示文件中读取揭示信息
  ////////////////////////////////////

    TZzkdxkJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;
    end;


  /////////////////////////////////////
  /// TJieShiFile  思维跨段写卡揭示文件读取类
  /// 从揭示文件中读取揭示信息
  ////////////////////////////////////

    TSwKdxkJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;
    protected
        procedure GetRecLen;
    end;


  /////////////////////////////////////
  /// TJieShiFile  新协议IC卡管理揭示文件读取类
  /// 从揭示文件中读取揭示信息
  ////////////////////////////////////

    TNewICKGLJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;
        function BufToDateTime(IsTime: Boolean; bf0, bf1, bf2, bf3, bf4, bf5,
            bf6, bf7: Byte): TDateTime;
    end;

  /////////////////////////////////////
  /// TJieShiFile  新协议株洲跨段写卡揭示文件读取类
  /// 从揭示文件中读取揭示信息
  ////////////////////////////////////

    TNewZZKdxkJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;

        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;
    protected
        function DecodenPos(PosType: TPosType; Bytes: TBytesStream): Integer;
    end;

///////////////////////////////////
/// / TJieShiFile  新协议思维跨段写卡揭示文件读取类
  /// 从揭示文件中读取揭示信息
///  ////////////////////////////////
    TNewSwKdxkJieShiFileReader = class(TJieShiFileReader)
    public
        constructor Create(strFileName: string); overload;
        destructor Destroy(); override;
    public
        procedure GetRecord(nIndex: integer; var Rec: RICCJieShiRec); override;
        function GetRecCount(): integer; override;
    protected
        function DecodeJsType(bytCode: BYTE): TICCJieShiType;
        function JLToGWUpdownType(bytCode: BYTE): BYTE;
        function ConverJsLimitType(nType: Integer): Integer;
        function PosConvert(nPos, nSign: Integer): Integer;
    end;

        function strPosToInt(strPos: string): Integer;
        function UpDownTypeToStr(nType: TUpDownType): string;
        function JLUpDownTypeToStr(nType: Integer): string;
        function LineTypeToStr(LineType: TLineType): string;
        function DirectionToStr(Direction: TDirection): string;
        function TrainTypeToStr(TrainType: TTrainType): string;
        function LimiteTypeToStr(nType: Integer): string;
        function JieShiTypeToStr(jst: TICCJieShiType): string;
        function PositionToStr(nPos: Integer; jst: TICCJieShiType): string;

        function CLTypeToStr(nType: Integer): string;
        function IdTypeToStr(nType: Integer): string;
        function LengthPositionToStr(nPos: Integer): string;
        function JsTypeToStr(JstTimeType: TJieShiTimeType): string;

        function ZzJsTypeToStr(nType: Integer): string;
        function DutyDirectionToStr(nDutyDirection: Integer): string;

        function GetIndexByte(IndexByte: Byte): Byte;
        function VerifyMonth(nMonth: Integer): Integer;
        function VerifyDate(nTime: Integer): Integer;
        function VerifyHour(nHour: Integer): Integer;
        function VerifMini(nMini: Integer): Integer;
        function NewJsTypeToStr(nType: Integer): string;
        function NewTrainTypeToStr(nType: Integer): string;
        function NewPositionToStr(nPos: Integer; jst: string): string;
implementation

function IntToUpDownType(nType: Integer): TUpDownType;
begin
    case nType of
        UD_UPLINE: result := udt_Up;
        UD_DOWNLINE: Result := udt_Down;
        UD_UDLINE: result := udt_UpDown;
        UP_SXDOWNLINE: Result := udt_Down;
        UP_SXUPLINE: Result := udt_Up;
        UP_SXUDLINE: Result := udt_UpDown;
    end;
end;

function IntToLineType(nType: Integer): TLineType;
begin
    case nType of
        MT_MAINLINE: result := lt_MasterLine;
        MT_THIRDLINE: Result := lt_TripleLine;
    end;
end;

function IntToDirectionType(nType: Integer): TDirection;
begin
    case nType of
        DR_FORWARD: result := dt_Positive;
        DR_BACKWARD: Result := dt_Opposite;
    end;
end;

function IntToJieShiTimeType(nType: Integer): TJieShiTimeType;
begin
    case nType of
        0: Result := jstd_Day;
        1: Result := jstd_DayNight;
    end;
end;

function IntToTrainType(nType: Integer;JieShiSoftType:TJieShiSoftType): TTrainType;
begin
    if (JieShiSoftType= jsf_SiWeiIckgl08) or
        (JieShiSoftType = jsf_SiWeiIckgl09)
        or (JieShiSoftType = jsf_ChongQingKdxk) then
    begin
        case nType of
            PASSENGER_CARGO: Result := tt_PassengeCargo;
            PASSENGER: Result := tt_Passenge;
            CARGO: Result := tt_Cargo;
        end;
    end;

    if (JieShiSoftType = jsf_ZhuZhouKdxk08) or
        (JieShiSoftType = jsf_SiWeiKdxk08)
        or (JieShiSoftType = jsf_ZhuZhouKdxk09) or
        (JieShiSoftType= jsf_SiWeiKdxk09)
        then
    begin
        case nType of
            ZZ_PASSENGER_CARGODC: Result := tt_PassengeCargoCRH;
            ZZ_DONGCHE: Result := ttCRH;
            ZZ_PASSENGER_CARGO: Result := tt_PassengeCargo;
            ZZ_PASSENGER: Result := tt_Passenge;
            ZZ_CARGO: Result := tt_Cargo;
        end;
    end;
end;

//将 揭示类型转为 限速类别/每天昼夜---思维跨段写卡文件

function DecodeJieShiTypeToLB(bytCode: BYTE): Byte;
begin
    Result := 0;
    case bytCode of
        $09: Result := 1;
        $28: Result := 1;
        $18: Result := 1;
        $0E: Result := 1;
        $0A: Result := 1;
        $0F: Result := 1;
        $0D: Result := 1;
        $38: Result := 1;
        $B1: Result := 1;
        $B0: Result := 1;
    end;
end;

function DecodeType(bytCode, bytLmType: BYTE;JieShiSoftType:TJieShiSoftType): TICCJieShiType;
//功能：将代码转换为揭示类型 为 兼容跨段写卡揭示文件格式，参数增加 限速类别 ：LmType将不同
var
    bytTemp: Byte;
begin
    bytTemp := 0;

    if (JieShiSoftType = jsf_ZhuZhouKdxk08) then
    begin
        if ((bytCode = $0) and (bytLmType = $1)) or
            ((bytCode = $1) and (bytLmType = $1)) or
            ((bytCode = $2) and (bytLmType = $1)) then
            bytTemp := $01;
        if ((bytCode = $0) and (bytLmType = $9)) or
            ((bytCode = $1) and (bytLmType = $9)) or
            ((bytCode = $2) and (bytLmType = $9)) then
            bytTemp := $09;

        if ((bytCode = $3) and (bytLmType = $1)) then
            bytTemp := $05;
        if ((bytCode = $3) and (bytLmType = $9)) then
            bytTemp := $0D;

        if ((bytCode = $4) and (bytLmType = $1)) then
            bytTemp := $06;
        if ((bytCode = $4) and (bytLmType = $9)) then
            bytTemp := $0E;

        if ((bytCode = $5) and (bytLmType = $1)) then
            bytTemp := $02;
        if ((bytCode = $5) and (bytLmType = $9)) then
            bytTemp := $0A;

        if ((bytCode = $6) and (bytLmType = $1)) then
            bytTemp := $10;
        if ((bytCode = $6) and (bytLmType = $9)) then
            bytTemp := $18;

        if ((bytCode = $7) and (bytLmType = $1)) then
            bytTemp := $20;
        if ((bytCode = $7) and (bytLmType = $9)) then
            bytTemp := $28;

        bytCode := bytTemp;
    end;

    if (JieShiSoftType = jsf_SiWeiIckgl09) then
    begin
        case bytCode of
            $01: Result := jst_ICC_LinShiXianSu;
            $02: Result := jst_ICC_DianHuaBiSe;
            $03: Result := jst_ICC_CheZhanXianSu;
            $04: Result := jst_ICC_CeXianXianSu;
            $05: Result := jst_ICC_ChengJiangSuo;
            $06: Result := jst_ICC_LvSeXuKeZheng;
            $07: Result := jst_ICC_TeDingYinDao;
            $1E: Result := jst_ICC_ShiGongTiShi;
            $1F: Result := jst_ICC_FangXunTiShi;
            $20: Result := jst_ICC_JiangGongTiShi;
        end;
        Exit;
    end;

    if (JieShiSoftType = jsf_ZhuZhouKdxk09) then
    begin
        case bytCode of
            $0: Result := jst_ICC_LinShiXianSu;
            $01: Result := jst_ICC_LinShiXianSu;
            $08: Result := jst_ICC_LinShiXianSu;
            $09: Result := jst_ICC_LinShiXianSu;
            $A: Result := jst_ICC_LinShiXianSu;
            $05: Result := jst_ICC_DianHuaBiSe;
            $03: Result := jst_ICC_CheZhanXianSu;
            $04: Result := jst_ICC_CeXianXianSu;
            $02: Result := jst_ICC_ChengJiangSuo;
            $06: Result := jst_ICC_LvSeXuKeZheng;
            $07: Result := jst_ICC_TeDingYinDao;
            $1E: Result := jst_ICC_ShiGongTiShi;
            $1F: Result := jst_ICC_FangXunTiShi;
            $20: Result := jst_ICC_JiangGongTiShi;
            $21: Result := jst_ICC_TeShuJieShi;
        end;
        Exit;
    end;

    case bytCode of
        $01: Result := jst_ICC_LinShiXianSu;
        $20: Result := jst_ICC_TeDingYinDaoMeiRi;
        $28: Result := jst_ICC_TeDingYinDaoZhouYe;
        $10: Result := jst_ICC_LvSePinZhengMeiRi;
        $18: Result := jst_ICC_LvSePinZhengZhouYe;
        $40: Result := jst_ICC_LvSePinZhengLinShi;
        $06: Result := jst_ICC_CeXianXianSuMeiRi;
        $0E: Result := jst_ICC_CeXianXianSuZhouYe;
        $02: Result := jst_ICC_ZhanJianTingYongMeiRi;
        $0A: Result := jst_ICC_ZhanJianTingYongZhouYe;
        $30: Result := jst_ICC_ZhanJianTingYongLinShi;
        $07: Result := jst_ICC_ChengJiangSuoMeiRi;
        $0F: Result := jst_ICC_ChengJiangSuoZhouYe;
        $09: Result := jst_ICC_ZhouYeXianSu;
        $05: Result := jst_ICC_CheZhanXianSuMeiRi;
        $0D: Result := jst_ICC_CheZhanXianSuZhouYe;
    end;
end;

function CLTypeToStr(nType: Integer): string;
begin
    case nType of
        0: Result := '';
        1: Result := '长链';
    end;
    if nType > 1 then
        Result := '长链';
end;




function DirectionToStr(Direction: TDirection): string;
begin
    case Direction of
        dt_Positive: result := '正向';
        dt_Opposite: Result := '反向';
    end;
end;


function DutyDirectionToStr(nDutyDirection: Integer): string;
//功能：出乘方向转换
begin
    case nDutyDirection of
        0: Result := '上行';
        1: Result := '下行';
        2: Result := '上下';
    end;
end;


function GetIndexByte(IndexByte: Byte): Byte;
begin
    IndexByte := IndexByte and $0F;
    Result := $08;
    case IndexByte of
        $0: Result := $08;
        $1: Result := $F0;
        $2: Result := $76;
        $3: Result := $98;
        $4: Result := $AB;
        $5: Result := $80;
        $6: Result := $5A;
        $7: Result := $07;
        $8: Result := $00;
        $9: Result := $25;
        $A: Result := $18;
        $B: Result := $FF;
        $C: Result := $9A;
        $D: Result := $0B;
        $E: Result := $CA;
        $F: Result := $06;
    end;
end;

function IdTypeToStr(nType: Integer): string;
begin
    case nType of
        0: Result := '';
        1: Result := 'A';
        2: Result := 'B';
        3: Result := 'C';
        4: Result := 'D';
        5: Result := 'E';
        6: Result := 'F';
        7: Result := 'G';
        8: Result := 'H';
        9: Result := 'I';
        10: Result := 'J';
        11: Result := 'K';
        12: Result := 'L';
        13: Result := 'M';
        14: Result := 'N';

        65: Result := 'A';
        66: Result := 'B';
        67: Result := 'C';
        68: Result := 'D';
        69: Result := 'E';
        70: Result := 'F';
        71: Result := 'G';
        72: Result := 'H';
        73: Result := 'I';
        74: Result := 'J';
        75: Result := 'K';
        76: Result := 'L';
        77: Result := 'M';
        78: Result := 'N';
    end;
end;

function IsCross(nSection1Begin, nSection1End,
    nSection2Begin, nSection2End: integer): BOOLEAN;
begin
    result := (max(nSection1Begin, nSection1End) >= min(nSection2Begin, nSection2End))
        and (max(nSection2Begin, nSection2End) >= min(nSection1Begin, nSection1End));

end;

function JieShiTypeToStr(jst: TICCJieShiType): string;
begin
    case jst of
        jst_Unknown: Result := '未知类型';
        jst_ICC_LinShiXianSu: Result := '临时限速';
        jst_ICC_ZhouYeXianSu: Result := '昼夜限速';
        jst_ICC_TeDingYinDaoMeiRi: Result := '特定引导每日';
        jst_ICC_TeDingYinDaoZhouYe: Result := '特定引导昼夜';
        jst_ICC_LvSePinZhengMeiRi: Result := '绿色凭证每日';
        jst_ICC_LvSePinZhengZhouYe: Result := '绿色凭证昼夜';
        jst_ICC_LvSePinZhengLinShi: Result := '绿色凭证临时';
        jst_ICC_CeXianXianSuMeiRi: Result := '侧线限速每日';
        jst_ICC_CeXianXianSuZhouYE: Result := '侧线限速昼夜';
        jst_ICC_ZhanJianTingYongMeiRi: Result := '站间停用每日';
        jst_ICC_ZhanJianTingYongZhouYe: Result := '站间停用昼夜';
        jst_ICC_ZhanJianTingYongLinShi: Result := '站间停用临时';
        jst_ICC_ChengJiangSuoMeiRi: Result := '乘降所每日';
        jst_ICC_ChengJiangSuoZhouYe: Result := '乘降所昼夜';
        jst_ICC_CheZhanXianSuMeiRi: Result := '车站限速每日';
        jst_ICC_CheZhanXianSuZhouYe: Result := '车站限速昼夜';
        jst_ICC_YiBanJieShi: Result := '一般揭示';
        jst_ICC_FengSuoJieShi: Result := '封锁揭示';
        jst_ICC_TeShuJieShi: ReSult := '特殊揭示';
        jst_ICC_CheZhanXianSu: Result := '车站限速';
        jst_ICC_CeXianXianSu: Result := '侧线限速';
        jst_ICC_DianHuaBiSe: Result := '电话闭塞';
        jst_ICC_TeDingYinDao: Result := '特定引导';

        jst_ICC_ChengJiangSuo: Result := '乘降所';
        jst_ICC_LvSeXuKeZheng: Result := '绿色许可';
        jst_ICC_ShiGongTiShi: Result := '施工提示';
        jst_ICC_FangXunTiShi: Result := '防汛提示';
        jst_ICC_JiangGongTiShi: Result := '降弓提示';
    end;
end;

function JLUpDownTypeToStr(nType: Integer): string;
begin
    case nType of
        JL_UpLine: result := '上行';
        JL_DownLine: Result := '下行';
        JL_UDLine: result := '上下';
        JL_UDOther: result := '上下';
    end;

end;

function JsTypeToStr(JstTimeType: TJieShiTimeType): string;
begin
    case JstTimeType of
        jstd_Day: Result := '每天';
        jstd_DayNight: Result := '昼夜';
    end;
end;

function LengthPositionToStr(nPos: Integer): string;
begin
    Result := Trim(Format('%7.3f', [nPos / 1000.0]))
end;

function LimiteTypeToStr(nType: Integer): string;
begin
    case nType of
        LM_LS: Result := '临时';
        LM_ZY: Result := '昼夜';
    end;
end;

function LineTypeToStr(LineType: TLineType): string;
begin
    case LineType of
        lt_MasterLine: result := '主线';
        lt_TripleLine: Result := '三线';
    end;
end;

function NewJsTypeToStr(nType: Integer): string;
begin
    case nType of
        $01: Result := '临时限速';
        $02: Result := '电话闭塞';
        $03: Result := '车站限速';
        $04: Result := '侧线限速';
        $05: Result := '乘降所';
        $06: Result := '绿色许可';
        $07: Result := '特定引导';
        $1E, $30: Result := '施工提示';
        $1F, $31: Result := '防汛提示';
        $20, $32: Result := '降弓提示';
        $21: Result := '特殊揭示';
    end;
end;

function NewPositionToStr(nPos: Integer; jst: string): string;
begin
    if (Pos('临时限速', jst) <> 0) or (Pos('乘降所', jst) <> 0) or
        (Pos('施工提示', jst) <> 0) or (Pos('防汛', jst) <> 0) or
        (Pos('降弓提示', jst) <> 0) or (Pos('特殊揭示', jst) <> 0) then
        Result := Trim(Format('%7.3f', [nPos / 1000.0]))
    else
        Result := Trim(IntToStr(nPos));
end;

function NewTrainTypeToStr(nType: Integer): string;
begin
    case nType of
        1: Result := '客车';
        2: Result := '货车';
        3: Result := '客货';
    end;
end;

function PositionToStr(nPos: Integer; jst: TICCJieShiType): string;
begin
    if jst in [jst_ICC_LinShiXianSu, jst_ICC_ZhouYeXianSu, jst_ICC_ChengJiangSuoMeiRi,
        jst_ICC_ChengJiangSuoZhouYe, jst_ICC_LinShiXianSu, jst_ICC_ChengJiangSuo,
        jst_ICC_TeShuJieShi, jst_ICC_FangXunTiShi, jst_ICC_JiangGongTiShi,
        jst_ICC_ShiGongTiShi] then
        Result := Trim(Format('%7.3f', [nPos / 1000.0]))
    else
        Result := Trim(IntToStr(nPos));
end;


function strPosToInt(strPos: string): Integer;
begin
    Delete(strPos, Pos('.', strPos), 1);
    Result := StrToInt(strPos);
end;

function TrainTypeToStr(TrainType: TTrainType): string;
begin
    case TrainType of
        tt_Passenge: Result := '客车';
        tt_Cargo: Result := '货车';
        tt_PassengeCargo: Result := '客货';
    end;
end;

function UpDownTypeToStr(nType: TUpDownType): string;
begin
    case nType of
        udt_Up: Result := '上行';
        udt_Down: Result := '下行';
        udt_UpDown: Result := '上下';
    end;
end;

function UpDownTypeToStr08(nType: TUpDownType): string;
//功能：08年写卡协议工务上下行转换
begin

end;


function VerifMini(nMini: Integer): Integer;
begin
    Result := nMini;
    if (nMini < 0) or (nMini > 59) then
        Result := 0;
end;

function VerifyDate(nTime: Integer): Integer;
begin
    Result := nTime;
    if (nTime <= 0) or (nTime > 31) then
        Result := 1;
end;

function VerifyHour(nHour: Integer): Integer;
begin
    Result := nHour;
    if (nHour < 0) or (nHour > 23) then
        Result := 0;
end;

function VerifyMonth(nMonth: Integer): Integer;
begin
    Result := nMonth;
    if (nMonth <= 0) or (nMonth > 12) then
        Result := 1;
end;

function ZzJsTypeToStr(nType: Integer): string;
begin
    case nType of
        1: Result := '临时';
        9: Result := '昼夜';
    end;
end;

{ TJieShiFileReader }

constructor TSwIckglJieShiFileReader.Create(strFileName: string);
begin
    inherited Create(strFileName);
end;

destructor TSwIckglJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TSwIckglJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div REC_LEN - 1;
end;

procedure TSwIckglJieShiFileReader.GetRecord(nIndex: integer; var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
    nNow_Year, nNow_Month, nNow_Day: WORD;
    nYear, nMonth, nDay, nHour, nMins: integer;
begin

    DecodeDate(Now(), nNow_Year, nNow_Month, nNow_Day);

    Bytes := TBytesStream.Create(REC_LEN);

    m_File.Position := (nIndex + 1) * REC_LEN;
    m_File.ReadBuffer(Bytes.GetBuffer()^, REC_LEN);

    rec.nID := Bytes.ReadByte(0) - 1;
    Rec.nLineNO := BITS(Bytes.ReadByte(2), 0, 5);
    Rec.UpDownType := IntToUpDownType(BITS(Bytes.ReadByte(2), 6, 7));
    Rec.nStationNO := Bytes.ReadByte(3);
    Rec.nPos_Begin := Bytes.ReadTripleBytes(9);
    Rec.nPos_End := Bytes.ReadTripleBytes(12);
    Rec.nPassenger_SpeedLimit := Bytes.ReadByte(15);

    nYear := BYTES[19] * $100 + BYTES[20];
    nMonth := BITS(Bytes[4], 0, 3);
    nDay := BITS(Bytes[6], 3, 7);
    nHour := BITS(Bytes[6], 0, 2) * 4 + BITS(BYTES[5], 6, 7);
    nMins := BITS(Bytes[5], 0, 5);
                            //nYear
//    if g_sysinfo.aCheckIc.JsSoft = jsf_ChongQingKdxk then
//        nYear := nNow_Year;

    Rec.dtStartDate := EncodeDate(nYear, nMonth, nDay);

    Rec.dtStartTime := EncodeTime(nHour, nMins, 0, 0);

    nYear := BYTES[21] * $100 + BYTES[22];
    nMonth := BITS(Bytes[4], 4, 7);
    nDay := BITS(Bytes[8], 3, 7);
    nHour := BITS(Bytes[8], 0, 2) * 4 + BITS(BYTES[7], 6, 7);
    nMins := BITS(Bytes[7], 0, 5);

//    if g_sysinfo.aCheckIc.JsSoft = jsf_ChongQingKdxk then
//        nYear := nNow_Year;
        
    Rec.dtEndDate := EncodeDate(nYear, nMonth, nDay);

    Rec.dtEndTime := EncodeTime(nHour, nMins, 0, 0);
    Rec.dwCommandNO := Bytes.ReadTripleBytes(16);
    Rec.nGWLineNO := Bytes.ReadWORD(24);

    Rec.jstType := DecodeType(Bytes[1], 0,jsf_SiWeiIckgl08);
    Rec.nPos_BeginID := BYTES[26];

    Rec.GWUpDownType := IntToUpDownType(BYTES[28]);

    Rec.LineType := IntToLineType(BYTES[29]);
    Rec.Direction := IntToDirectionType(Bytes[30]);
    Rec.TrainType := IntToTrainType(BYTES[31],jsf_SiWeiIckgl08);

    Rec.nCargo_SpeedLimit := Rec.nPassenger_SpeedLimit;

    Rec.nSpeedLimitLength := 0;
    Rec.nPos_BeginCL := 0;
    Rec.nPos_BeginID := 0;
    Rec.nPos_EndCL := 0;
    Rec.nPos_EndID := 0;

    Bytes.Free();

end;

{ TZzJieShiFileReader }

constructor TZzkdxkJieShiFileReader.Create(strFileName: string);
begin
    inherited Create(strFileName);
end;

destructor TZzkdxkJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TZzkdxkJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div m_RecLen;
end;

procedure TZzkdxkJieShiFileReader.GetRecord(nIndex: integer; var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
    nNow_Year, nNow_Month, nNow_Day: WORD;
    nYear, nMonth, nDay, nHour, nMins: integer;
begin

    DecodeDate(Now(), nNow_Year, nNow_Month, nNow_Day);

    Bytes := TBytesStream.Create(m_RecLen);

    m_File.Position := (nIndex) * m_RecLen;
    m_File.ReadBuffer(Bytes.GetBuffer()^, m_RecLen);

    Rec.nID := BYTES[0];

    Rec.JstTimeType := IntToJieShiTimeType(Bytes[1]);

    Rec.nLineNO := BYTES[2] and $3F;
    Rec.UpDownType := IntToUpDownType(BYTES[2] shr 6);

    Rec.nStationNO := BYTES[3];
    Rec.nPos_Begin := BYTES[11] * $10000 + BYTES[10] * $100 + BYTES[9];
    Rec.nPos_End := BYTES[14] * $10000 + BYTES[13] * $100 + BYTES[12];
    Rec.nPassenger_SpeedLimit := Bytes.ReadByte(15);
    Rec.nCargo_SpeedLimit := Bytes.ReadByte(15);

    nYear := BYTES[19] + 2000; //nNow_Year;
    nMonth := BITS(Bytes[4], 0, 3);

    nDay := BITS(Bytes[6], 3, 7);
    nHour := BITS(Bytes[6], 0, 2) * 4 + BITS(BYTES[5], 6, 7);
    nMins := BITS(Bytes[5], 0, 5);

    Rec.dtStartDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtStartTime := EncodeTime(nHour, nMins, 0, 0);

    nYear := BYTES[20] + 2000; //nNow_Year;
    nMonth := BITS(Bytes[4], 4, 7);
    nDay := BITS(Bytes[8], 3, 7);
    nHour := BITS(Bytes[8], 0, 2) * 4 + BITS(BYTES[7], 6, 7);
    nMins := BITS(Bytes[7], 0, 5);

    Rec.dtEndDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtEndTime := EncodeTime(nHour, nMins, 0, 0);
    Rec.dwCommandNO := BYTES[18] * $10000 + BYTES[17] * $100 + BYTES[16];
    Rec.nGWLineNO := BYTES[24] * $10000 + BYTES[23] * $100 + BYTES[22];
    Rec.jstType := DecodeType(Bytes[21], Bytes[1],jsf_ZhuZhouKdxk08);
    Rec.nPos_BeginID := BYTES[29];

    Rec.GwUpdownType := IntToUpDownType(GwUpDownConver(BYTES[27]));

    Rec.LineType := IntToLineType(BYTES[28]);
    Rec.Direction := dt_Positive;
    Rec.TrainType := IntToTrainType(BYTES[25],jsf_ZhuZhouKdxk08);

    Rec.nSpeedLimitLength := 0;
    Rec.nCargo_SpeedLimit := Rec.nPassenger_SpeedLimit;

    Rec.nSpeedLimitLength := 0;
    Rec.nPos_BeginCL := 0;
    Rec.nPos_BeginID := 0;
    Rec.nPos_EndCL := 0;
    Rec.nPos_EndID := 0;

    Bytes.Free();

end;

{ TFileReaderJs }

constructor TJieShiFileReader.Create(strFileName: string);
var
    nTryTimes: Integer;
begin
    m_File := TMemoryStream.Create();
    nTryTimes := 0;
    try
        if FileExists(strFileName) = False then
            Exit;
    except
        raise;
    end;

    while nTryTimes < 5 do
    begin
        try
            m_File.LoadFromFile(strFileName);
            nTryTimes := 6;
        except
            on E: Exception do
            begin
                if (nTryTimes > 3) then
                    raise Exception.Create(e.Message);
                inc(nTryTimes);
                sleep(300);
            end;
        end;
    end;
end;

destructor TJieShiFileReader.Destroy;
begin
    m_File.Free();
    inherited;
end;

function TJieShiFileReader.GetZeroOne(bytCode: Byte): BYTE;
//功能：如果是非0数字强制转换为1
begin
    Result := bytCode;
    if bytCode <> 0 then
        Result := 1;
end;

function TJieShiFileReader.GwUpDownConver(nType: Integer): Integer;
begin
    Result := 3;
    case nType of
        0: Result := 2;
        1: Result := 1;
        2: Result := 3;
    end;
end;

function TJieShiFileReader.jsLbConver(nType: Integer): Integer;
//功能 ：揭示类别转化统一为 思维写卡格式，0：每天，1：昼夜
begin
    Result := 0;
    case nType of
        0: Result := 1;
        1: Result := 0;
        9: Result := 1;
    end;
end;

{ TSwJieShiFileReader }

constructor TSwKdxkJieShiFileReader.Create(strFileName: string);
begin
    inherited Create(strFileName);
    GetRecLen();
end;

destructor TSwKdxkJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TSwKdxkJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div m_RecLen;
end;

procedure TSwKdxkJieShiFileReader.GetRecLen;
//功能： 获得一条揭示记录文件的长度
var
    Bytes: TBytesStream;
begin
    m_RecLen := REC_SWKDLEN;
    if m_File.Size mod REC_SWKDLEN_SH = 0 then
    begin
        Bytes := TBytesStream.Create(REC_SWKDLEN_SH);
        m_File.Position := 0;
        m_File.ReadBuffer(Bytes.GetBuffer()^, 64);

        if (Bytes[32] = 0) and (Bytes[33] = 0) and (Bytes[34] = 0)
            and (Bytes[35] = 0) then
            m_RecLen := REC_SWKDLEN_SH;
        Bytes.Free;
    end;

end;

procedure TSwKdxkJieShiFileReader.GetRecord(nIndex: integer; var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
    nNow_Year, nNow_Month, nNow_Day: WORD;
    nYear, nMonth, nDay, nHour, nMins: integer;
begin

    DecodeDate(Now(), nNow_Year, nNow_Month, nNow_Day);

    Bytes := TBytesStream.Create(m_RecLen);
    m_File.Position := (nIndex) * m_RecLen;
    m_File.ReadBuffer(Bytes.GetBuffer()^, m_RecLen);

    Rec.nID := BYTES[0];
    Rec.JstTimeType := IntToJieShiTimeType(Bytes[1]);
    Rec.nLineNO := BYTES[2] and $3F;
    Rec.UpDownType := IntToUpDownType(BYTES[2] shr 6);
    Rec.nStationNO := BYTES[3];
    Rec.nPos_Begin := BYTES[11] * $10000 + BYTES[10] * $100 + BYTES[9];
    Rec.nPos_End := BYTES[14] * $10000 + BYTES[13] * $100 + BYTES[12];
    Rec.nPassenger_SpeedLimit := Bytes.ReadByte(15);
    Rec.nCargo_SpeedLimit := Bytes.ReadByte(15);

    nYear := BYTES[19] + 2000;
    nMonth := BITS(Bytes[4], 0, 3);

    nDay := BITS(Bytes[6], 3, 7);
    nHour := BITS(Bytes[6], 0, 2) * 4 + BITS(BYTES[5], 6, 7);
    nMins := BITS(Bytes[5], 0, 5);

    Rec.dtStartDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtStartTime := EncodeTime(nHour, nMins, 0, 0);

    nYear := BYTES[20] + 2000;
    nMonth := BITS(Bytes[4], 4, 7);
    nDay := BITS(Bytes[8], 3, 7);
    nHour := BITS(Bytes[8], 0, 2) * 4 + BITS(BYTES[7], 6, 7);
    nMins := BITS(Bytes[7], 0, 5);

    Rec.dtEndDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtEndTime := EncodeTime(nHour, nMins, 0, 0);
    Rec.dwCommandNO := BYTES[18] * $10000 + BYTES[17] * $100 + BYTES[16];
    Rec.nGWLineNO := BYTES[24] * $10000 + BYTES[23] * $100 + BYTES[22];
    Rec.jstType := DecodeType(Bytes[1], 0,jsf_SiWeiKdxk08);
    Rec.nPos_BeginID := BYTES[27];
    Rec.GwUpdownType := IntToUpDownType(GwUpDownConver(BYTES[29]));
    Rec.LineType := IntToLineType(BYTES[28]);
    Rec.Direction := IntToDirectionType(BYTES[30]);
    Rec.TrainType := IntToTrainType(BYTES[25],jsf_SiWeiKdxk08);

    Rec.nSpeedLimitLength := 0;
    Rec.nCargo_SpeedLimit := Rec.nPassenger_SpeedLimit;

    Rec.nSpeedLimitLength := 0;
    Rec.nPos_BeginCL := 0;
    Rec.nPos_BeginID := 0;
    Rec.nPos_EndCL := 0;
    Rec.nPos_EndID := 0;
    Bytes.Free();

end;

{ TNewICKGLJieShiFileReader }

function TNewICKGLJieShiFileReader.BufToDateTime(IsTime: Boolean; bf0, bf1, bf2,
    bf3, bf4, bf5, bf6, bf7: Byte): TDateTime;
var
    dt: TDateTime;
    Buffer: array[0..7] of byte;
begin
    Buffer[0] := bf0;
    Buffer[1] := bf1;
    Buffer[2] := bf2;
    Buffer[3] := bf3;
    Buffer[4] := bf4;
    Buffer[5] := bf5;
    Buffer[6] := bf6;
    Buffer[7] := bf7;
    if IsTime then
        dt := EncodeTime(0, 1, 0, 0)
    else
        dt := EncodeDate(2009, 1, 1);

    CopyMemory(Pointer(@dt), @Buffer[0], 8);
    Result := dt;
end;

constructor TNewICKGLJieShiFileReader.Create(strFileName: string);
begin
    inherited create(strFileName);
end;

destructor TNewICKGLJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TNewICKGLJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div REC_NEWICKGLLEN;
end;

procedure TNewICKGLJieShiFileReader.GetRecord(nIndex: integer;
    var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
begin

    Bytes := TBytesStream.Create(REC_NEWICKGLLEN);

    m_File.Position := (nIndex) * REC_NEWICKGLLEN;
    m_File.ReadBuffer(Bytes.GetBuffer()^, REC_NEWICKGLLEN);

    Rec.nLineNO := 0;
    Rec.nID := BYTES[0];
    Rec.dwCommandNO := BYTES[51] * $1000000 + BYTES[50] * $10000 + BYTES[49] * $100 + BYTES[48];
    Rec.nGWLineNO := Bytes[7] * $100 + Bytes[6];
    Rec.GwUpdownType := IntToUpDownType(BYTES[3]);
    Rec.jstType := DecodeType(Bytes[2], 0,jsf_SiWeiIckgl09);
    Rec.JstTimeType := IntToJieShiTimeType(BYTES[1]);


    Rec.nPos_Begin := BYTES[55] * $1000000 + BYTES[54] * $10000 + BYTES[53] * $100 + BYTES[52];

    Rec.nPos_BeginCL := BYTES[56];
    Rec.nPos_BeginID := BYTES[57];
    Rec.nPos_End := BYTES[63] * $1000000 + BYTES[62] * $10000 + BYTES[61] * $100 + BYTES[60];
    Rec.nPos_EndCL := BYTES[64];
    Rec.nPos_EndID := BYTES[65];
    Rec.nSpeedLimitLength := BYTES[43] * $1000000 + BYTES[42] * $10000 + BYTES[41] * $100 + BYTES[40];

    Rec.dtStartDate := BufToDateTime(False, BYTES[16], BYTES[17], BYTES[18], BYTES[19],
        BYTES[20], BYTES[21], BYTES[22], BYTES[23]);

    Rec.dtStartTime := BufToDateTime(True, BYTES[8], BYTES[9], BYTES[10], BYTES[11],
        BYTES[12], BYTES[13], BYTES[14], BYTES[15]);

    Rec.dtEndDate := BufToDateTime(False, BYTES[32], BYTES[33], BYTES[34], BYTES[35],
        BYTES[36], BYTES[37], BYTES[38], BYTES[39]);

    Rec.dtEndTime := BufToDateTime(True, BYTES[24], BYTES[25], BYTES[26], BYTES[27],
        BYTES[28], BYTES[29], BYTES[30], BYTES[31]);

    Rec.nPassenger_SpeedLimit := BYTES[44];
    Rec.nCargo_SpeedLimit := BYTES[45];
    Rec.Direction := IntToDirectionType(GetZeroOne(BYTES[5]));
    Rec.LineType := IntToLineType(GetZeroOne(BYTES[4]));
    Rec.TrainType := IntToTrainType(BYTES[66],jsf_SiWeiIckgl09);

    Rec.nStationNO := 0;

    Rec.UpDownType := udt_UpDown;

    Bytes.Free();

end;

{ TNewZZKdxkJieShiFileReader }

constructor TNewZZKdxkJieShiFileReader.Create(strFileName: string);
begin
    inherited create(strFileName);
end;

//功能 ：根据公里标类型，读取相应的公里标位置

function TNewZZKdxkJieShiFileReader.DecodenPos(PosType: TPosType;
    Bytes: TBytesStream): Integer;
begin
    if PosType = PosBegin then
    begin
        if m_RecLen = REC_NEWZZKDLEN then
            Result := Bytes.ReadDWord(32);
        if m_RecLen = REC_NEWZZKDLEN_1 then
            Result := Bytes.ReadDWord(33);
    end;
    if PosType = PosEnd then
    begin
        if m_RecLen = REC_NEWZZKDLEN then
            Result := Bytes.ReadDWord(36);
        if m_RecLen = REC_NEWZZKDLEN_1 then
            Result := Bytes.ReadDWord(37);
    end;
end;

destructor TNewZZKdxkJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TNewZZKdxkJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div m_RecLen;
end;


procedure TNewZZKdxkJieShiFileReader.GetRecord(nIndex: integer;
    var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
    nNow_Year, nNow_Month, nNow_Day: WORD;
    nYear, nMonth, nDay, nHour, nMins: integer;
begin
    DecodeDate(Now(), nNow_Year, nNow_Month, nNow_Day);

    Bytes := TBytesStream.Create(m_RecLen);

    m_File.Position := (nIndex) * m_RecLen;
    m_File.ReadBuffer(Bytes.GetBuffer()^, m_RecLen);

    Rec.nID := BYTES[0];
    Rec.dwCommandNO := Bytes.ReadTripleBytes(10); ;
    Rec.nGWLineNO := Bytes.ReadTripleBytes(16); ;
    Rec.GwUpdownType := IntToUpDownType(GwUpDownConver(BYTES[21]));
    Rec.nLineNO := BYTES[2];
    Rec.jstType := DecodeType(BYTES[15], BYTES[1],jsf_ZhuZhouKdxk09);
    Rec.JstTimeType := IntToJieShiTimeType(jsLbConver(BYTES[1])); //限速类别1，9

    Rec.nPos_Begin := DecodenPos(PosBegin, BYTES);
    Rec.nPos_BeginCL := BYTES[30] - $30;
    Rec.nPos_BeginID := BYTES[23];
    Rec.nPos_End := DecodenPos(PosEnd, BYTES);
    Rec.nPos_EndCL := BYTES[31] - $30;
    Rec.nPos_EndID := BYTES[29];
    Rec.nSpeedLimitLength := BYTES[27] * $10000 + BYTES[26] * $100 + BYTES[25];

    nYear := BYTES[13] + 2000; //nNow_Year;
    nMonth := BITS(Bytes[4], 0, 3);

    nDay := BITS(Bytes[6], 3, 7);
    nHour := BITS(Bytes[6], 0, 2) * 4 + BITS(BYTES[5], 6, 7);
    nMins := BITS(Bytes[5], 0, 5);

    Rec.dtStartDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtStartTime := EncodeTime(nHour, nMins, 0, 0);

    nYear := BYTES[14] + 2000; //nNow_Year;
    nMonth := BITS(Bytes[4], 4, 7);
    nDay := BITS(Bytes[8], 3, 7);
    nHour := BITS(Bytes[8], 0, 2) * 4 + BITS(BYTES[7], 6, 7);
    nMins := BITS(Bytes[7], 0, 5);

    Rec.dtEndDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtEndTime := EncodeTime(nHour, nMins, 0, 0);

    Rec.nPassenger_SpeedLimit := BYTES[9];
    Rec.nCargo_SpeedLimit := BYTES[28];

    Rec.Direction := IntToDirectionType(GetZeroOne(BYTES[24]));
    Rec.LineType := IntToLineType(GetZeroOne(BYTES[22]));

    if Rec.nPos_Begin = 1613510 then
        OutputDebugString('1613510');


    Rec.TrainType := IntToTrainType(BYTES[19],jsf_ZhuZhouKdxk09);
    Rec.nStationNO := 0;

    Rec.UpDownType := udt_Up;
    Bytes.Free();

end;

{ TNewSwKdxkJieShiFileReader }

function TNewSwKdxkJieShiFileReader.ConverJsLimitType(nType: Integer): Integer;
begin
    case nType of
        0: Result := 1;
        1: Result := 1;
        9: Result := 0;
    end;
end;

constructor TNewSwKdxkJieShiFileReader.Create(strFileName: string);
begin
    inherited Create(strFileName);
end;

function TNewSwKdxkJieShiFileReader.JLToGWUpdownType(bytCode: BYTE): BYTE;
//功能：机务方向转化为公务方向，统一按公务方向处理
begin
    case bytCode of
        JL_UpLine: Result := UD_UPLINE;
        JL_DownLine: Result := UD_DOWNLINE;
        JL_UDLine: result := UD_UDLINE;
    end;
end;

function TNewSwKdxkJieShiFileReader.PosConvert(nPos, nSign: Integer): Integer;
begin
    if nSign = 0 then //正数
        Result := nPos
    else
        Result := (-1) * nPos;
end;

function TNewSwKdxkJieShiFileReader.DecodeJsType(bytCode: BYTE): TICCJieShiType;
begin
    case bytCode of
        $01, $09: Result := jst_ICC_LinShiXianSu;
        $20, $28: Result := jst_ICC_TeDingYinDao;
        $10, $18: Result := jst_ICC_LvSeXuKeZheng;
        $06, $0E: Result := jst_ICC_CeXianXianSu;
        $02, $0A: Result := jst_ICC_DianHuaBiSe;
        $07, $0F: Result := jst_ICC_ChengJiangSuo;
        $05, $0D: Result := jst_ICC_CheZhanXianSu;
        $30, $38, $B0: Result := jst_ICC_ShiGongTiShi;
        $B1, $31: Result := jst_ICC_FangXunTiShi;
        $32: Result := jst_ICC_JiangGongTiShi;
        $21: Result := jst_ICC_TeShuJieShi;
    end;
end;

destructor TNewSwKdxkJieShiFileReader.Destroy;
begin
    inherited Destroy;
end;

function TNewSwKdxkJieShiFileReader.GetRecCount: integer;
begin
    result := m_File.Size div m_RecLen;
end;

procedure TNewSwKdxkJieShiFileReader.GetRecord(nIndex: integer;
    var Rec: RICCJieShiRec);
var
    Bytes: TBytesStream;
    wNow_Year, wNow_Month, wNow_Day: WORD;
    nYear, nMonth, nDay, nHour, nMins: integer;
begin
    DecodeDate(Now(), wNow_Year, wNow_Month, wNow_Day);

    Bytes := TBytesStream.Create(m_RecLen);
    m_File.Position := (nIndex) * m_RecLen;
    m_File.ReadBuffer(Bytes.GetBuffer()^, m_RecLen);

    Rec.nID := BYTES[0];
    Rec.dwCommandNO := Bytes.ReadTripleBytes($10);
    Rec.nGWLineNO := Bytes.ReadTripleBytes($16);

    if Rec.dwCommandNO = 930998 then
        OutputDebugString('');



    Rec.GwUpdownType := IntToUpDownType(JLToGWUpdownType(Bytes.ReadByte($1D)));
    Rec.UpDownType := IntToUpDownType(BITS(Bytes.ReadByte(2), 6, 7));
     //BYTES[2] shr 6; //机务上下行

    Rec.nLineNO := BYTES[2] and $3F;

    //揭示类型：【28】 0：一般揭示 2：特殊揭示 3：防汛揭示 4：长轨车揭示
    Rec.SpecialType := Bytes.ReadByte($28);
    Rec.jstType := DecodeJsType(BYTES[1]);
    Rec.JstTimeType := IntToJieShiTimeType(DecodeJieShiTypeToLB(BYTES[1]));
      //限速类别1，9 ConverJsLimitType

    Rec.nPos_Begin := PosConvert(Bits(Bytes.ReadTripleBytes(9), 0, 22),
        Bits(Bytes.ReadTripleBytes(9), 22, 23));
    Rec.nPos_BeginCL := Bytes.ReadByte($20); // 是否长链
    Rec.nPos_BeginID := Bytes.ReadByte($1B); //起始标号,1代表A
    Rec.nPos_End := PosConvert(Bits(Bytes.ReadTripleBytes($C), 0, 22),
        Bits(Bytes.ReadTripleBytes($C), 22, 23));
    Rec.nPos_EndID := Bytes.ReadByte($15);
    Rec.nPos_EndCL := Bytes.ReadByte($21);

    Rec.nSpeedLimitLength := Bytes.ReadTripleBytes($25);
    nYear := BYTES[$13] + 2000;
    nMonth := BITS(Bytes[4], 0, 3);

    nDay := BITS(Bytes[6], 3, 7);
    nHour := BITS(Bytes[6], 0, 2) * 4 + BITS(BYTES[5], 6, 7);
    nMins := BITS(Bytes[5], 0, 5);

    Rec.dtStartDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtStartTime := EncodeTime(nHour, nMins, 0, 0);

    nYear := BYTES[$14] + 2000;
    nMonth := BITS(Bytes[4], 4, 7);
    nDay := BITS(Bytes[8], 3, 7);
    nHour := BITS(Bytes[8], 0, 2) * 4 + BITS(BYTES[7], 6, 7);
    nMins := BITS(Bytes[7], 0, 5);

    Rec.dtEndDate := EncodeDate(nYear, nMonth, nDay);
    Rec.dtEndTime := EncodeTime(nHour, nMins, 0, 0);

    Rec.nCargo_SpeedLimit := Bytes.ReadTripleBytes($22);
    Rec.nPassenger_SpeedLimit := Bytes.ReadByte($F);

    Rec.Direction := IntToDirectionType(GetZeroOne(Bytes.ReadByte($1E))); //0 ：正向
    Rec.LineType := IntToLineType(GetZeroOne(Bytes.ReadByte($1C))); //0:主线 其他：三线
    Rec.TrainType := IntToTrainType(BYTES[$19],jsf_SiWeiKdxk09);

    Bytes.Free();

end;

end.

