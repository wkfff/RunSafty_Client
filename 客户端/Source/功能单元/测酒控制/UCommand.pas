unit UCommand;

interface

uses Classes, SysUtils, Windows, UntDeclare, dialogs, Forms, DateUtils,
 uBaseDefine;

const
  N_Top = 0; //汉字的上半部分
  N_Bottum = 1; //汉字的下半部分
  N_CatchPhoto = 1; //捕捉图像字节
  N_Not_CatchPhoto = 0; //不捕捉图像字节

  //命令重发原因描述
  cs_NotDefine = '没有定义m_funReadPort';
  cs_ReadFail = '读取设备失败';
  cs_LenNotSave = '收到命令和发送命令的长度不一致';
  cs_FistByteNotSave = '收到命令和发送命令的首字节不一致';
  cs_FistByteNotExist = '收到命令首字节不存在';
  cs_CheckByteNotRight = '校验字节错误';
  cs_StatusIsWrong = '返回状态不正确';

  CREAD = FALSE;
  CWRITE = True;

type
  TSndAry116 = array[0..115] of Byte;
  TSndAry64 = array[0..63] of Byte;
  TSndAry58 = array[0..57] of Byte;
  TStandAry6 = array[0..5] of Byte;

type
  RSendArray = record
    nSendLength: Integer; //发送命令字节长度
    SendArray: TSndAry64; //发送字节数组
  end;

type
    RrecArray = record
        nRecLength: Integer; //接收到的命令长度
        RecArray: TSndAry64; //接收到的命令队列
    end;
///////////////////////////////////////////////////////////////////////////////
// 命令基类
// 每次存贮一帧的数据
///////////////////////////////////////////////////////////////////////////////
    TCmdBase = class
    private
        m_StrErr: string; //重发命令的原因描述
        m_bRepeateSend: Boolean; //是否重新发送此命令
        m_bCheckRecData: Boolean; //检查收到命令校验位
        m_RSendArray: RSendArray; //发送命令结构体
        m_RrecArray: RrecArray; //接收命令结构体
        m_byVersion: Byte; //协议版本号
    public
      procedure CheckArray; //发送命令时生成校验数据
      procedure MakeArray; virtual; abstract; //最终构成命令

      function CheckRecArray: Boolean; virtual; abstract; //校验接收到命令的正确性

      procedure WriteRecLen(Len: Integer); //接收到命令的长度
      procedure WriteRec(Index: Integer; val: Byte); //接收到的命令赋值

      function copyEx(strTT: string; nStart: Integer; nEnd: Integer): string;

      {功能：翻译数据}
      procedure TranslationData();virtual; abstract;

      procedure WriteRepeateInfo(bRe: Boolean; strErr: string);

      property RSendArray: RSendArray read m_RSendArray;

      property RecArray : RrecArray read m_RrecArray;

      property bCheckRecData: Boolean read m_bCheckRecData write m_bCheckRecData;

      property strErr: string read m_StrErr;

      property ByVersion: Byte read m_byVersion;

    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///TCmdAA 命令AA命令基类
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA = class(TCmdBase)
    public
      constructor Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
    private
      m_YJDT_First, m_YJDT: TDateTime;
      m_ApparatusInfo : RApparatusInfo;//测酒仪信息
    public
      procedure MakeArray; override;
      procedure WriteStandVolt(StandAry: TStandAry6); //写标准值
      function CheckRecArray: Boolean; override; //校验接收到命令的正确性
      procedure TranslationData(); override; //收到命令解析
    public
      property ApparatusInfo : RApparatusInfo read m_ApparatusInfo;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///TCmdAA_Start 开始检测命令类
    ///功能：发送此命令后，液晶屏进入检测界面，显示姓名、工号、测酒结果和测酒含量
    ///使用范围：D12芯片无效， 374芯片(不管是否带有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_Start = class(TCmdAA)
    public
        constructor Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
        procedure TranslationData(); override; //收到命令解析
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///类： 等待检测命令类
    ///功能：发送此命令后，液晶屏进入待检界面，显示“请测酒......”
    ///使用范围：D12芯片无效， 374芯片(不管是否带有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_Prepare = class(TCmdAA)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
    end;


    ////////////////////////////////////////////////////////////////////////////////
    ///类： 等待吹气类
    ///功能：在有摄像头的情况下，发送此命令后，显示工号和姓名屏幕下方，显示”请测酒“ 字样”
    ///      告诉“被测人” 现在开始吹气了，使软件，硬件，人三者保持同步
    ///使用范围：D12芯片无效， 374芯片(不管是否带有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_ListQZJ = class(TCmdAA)
    public
        constructor Create();
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
    end;


    ////////////////////////////////////////////////////////////////////////////////
    ///类： 工号命令类
    ///功能：发送此命令后，液晶屏显示一个数字”
    ///使用范围：D12芯片无效， 374芯片(不管是否带有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGH = class(TCmdBase)
    public
        constructor Create(SndAry58: TSndAry58; nIndex: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
        procedure TranslationData(); override; //收到命令解析
    end;

    ///////////////////////////////////////////////////////////////////////////////
    ///类： 姓名命令类
    ///功能：发送此命令后，液晶屏显示半个汉字，如果姓名中含有数字，数字当做一个汉字”
    ///使用范围：D12芯片无效， 374芯片(不管是否带有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdName = class(TCmdBase)
    public
        constructor Create(SendAry: TSndAry116; nIndex, nTopOrBottom: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
        procedure TranslationData(); override; //收到命令解析
    end;


    ///////////////////////////////////////////////////////////////////////////////
    ///类： 读基准电压命令
    ///功能：发送此命令后，向单片机索取基准电压”
    ///使用范围：D12芯片无效，374芯片(TJJC-IA,没有液晶屏)有效, 带液晶显示屏无效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGetVolt = class(TCmdBase)
    private
      m_ApparatusBaseVlt : RApparatusVoltage;//基准电压
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //校验接收到命令的正确性
      procedure TranslationData(); override;
      property ApparatusBaseVlt : RApparatusVoltage read m_ApparatusBaseVlt;
    end;
    ///////////////////////////////////////////////////////////////////////////////
    ///类： 读饮酒标准命令
    ///功能：发送此命令后，向单片机索取基准电压”
    ///使用范围：D12芯片无效，374芯片(TJJC-IA,没有液晶屏)有效, 带液晶显示屏无效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGetStdVolt = class(TCmdGetVolt)
    private
      m_byStandVolt: TStandAry6;//饮酒标准
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //校验接收到命令的正确性
      procedure TranslationData(); override; //收到命令解析
      property StandVolt : TStandAry6 read m_byStandVolt;

    end;

    ///////////////////////////////////////////////////////////////////////////////
    ///类： 写基准电压命令
    ///功能：发送此命令后，向单片机写基准电压”
    ///使用范围：D12芯片无效，374芯片(TJJC-IA,没有液晶屏)有效, 带液晶显示屏无效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdWriteVolt = class(TCmdBase)
    public
      Constructor Create(SendAry: TStandAry6);
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //校验接收到命令的正确性
      procedure TranslationData(); override;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///类： 374芯片复位命令
    ///功能：发送此命令后，374芯片进行复位操作”
    ///使用范围：D12芯片无效，374芯片(有液晶屏和无液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdStopRefrash = class(TCmdBase)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
        procedure TranslationData(); override; //收到命令解析
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///类： 摄像头复位命令
    ///功能：发送此命令后，摄像头进行复位操作”
    ///使用范围：D12芯片无效，374芯片(有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdResetCamera = class(TCmdBase)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///类： 发语音命令
    ///功能：发送此命令后，摄像头进行复位操作”
    ///使用范围：D12芯片无效，374芯片(有液晶屏)有效
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_PlayRecSound = class(TCmdBase)
    public
        constructor Create(nRecIndex: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //校验接收到命令的正确性
        procedure TranslationData(); override;
      end;

implementation

{ TCmdBase }

procedure TCmdBase.CheckArray;
//生成校验和数据
var
    I, Len: Integer;
begin
    Len := m_RSendArray.nSendLength;
    m_RSendArray.SendArray[Len - 1] := 0;
    for I := 0 to Len - 2 do
        m_RSendArray.SendArray[Len - 1] := m_RSendArray.SendArray[Len - 1] +
        m_RSendArray.SendArray[I];
    m_RSendArray.SendArray[Len - 1] := 0 - m_RSendArray.SendArray[Len - 1];
end;


function TCmdBase.copyEx(strTT: string; nStart: Integer; nEnd: Integer): string;
var
    strTemp: string;
begin
    strTemp := Copy(FormatDateTime('YYYY-MM-DD HH:MM:SS', now), 12, 8);
    Result := Copy(strTemp, nStart, nEnd);
end;

procedure TCmdBase.WriteRec(Index: Integer; val: Byte);
begin
    m_RrecArray.RecArray[Index] := val;
end;

procedure TCmdBase.WriteRecLen(Len: Integer);
begin
    m_RrecArray.nRecLength := Len;
end;

procedure TCmdBase.WriteRepeateInfo(bRe: Boolean; strErr: string);
begin
    m_bRepeateSend := bRe;
    m_StrErr := strErr;
end;


{ TCmdAA }

function TCmdAA.CheckRecArray: Boolean;
var
  I: Integer;
  Date: byte;
  bIsValid: Boolean;
begin
  //默认正确性检查正确
  Result := True;
  Date := 0;

  //发送和接收数据长度不一致
  if (m_RrecArray.nRecLength <> m_RSendArray.nSendLength) then
  begin
    WriteRepeateInfo(True, cs_LenNotSave);
    Result := False;
    Exit;
  end;

  //发送和接收数据首字节不一致
  if (m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0]) then
  begin
    WriteRepeateInfo(True, cs_LenNotSave);
    Result := False;
    Exit;
  end;

  //首字节不在协议规定的范围之内
  if not ((m_RrecArray.RecArray[0] = $AA)) then
  begin
    WriteRepeateInfo(True, cs_FistByteNotExist);
    Result := False;
    Exit;
  end;

  //收到命令校验字节不正确
  if self.bCheckRecData then
  begin
    for I := 0 to RSendArray.nSendLength - 2 do
      Date := m_RrecArray.RecArray[I] + Date;
    Date := not (Date) + 1;
    if Date <> m_RrecArray.RecArray[RSendArray.nSendLength - 1] then
    begin
      WriteRepeateInfo(True, cs_CheckByteNotRight);
      Result := False;
      Exit;
    end;
  end;

  bIsValid := (m_RrecArray.RecArray[0] and $00 = $00) or
    (m_RrecArray.RecArray[0] and crReady = crReady) or
    (m_RrecArray.RecArray[0] and $02 = $02) or
    (m_RrecArray.RecArray[0] and $14 = $14) or
    (m_RrecArray.RecArray[0] and $18 = $18);

  if bIsValid = False then
  begin
    WriteRepeateInfo(True, cs_StatusIsWrong);
    Result := False;
    Exit;
  end;
  
end;

constructor TCmdAA.Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
var
  I: Integer;
begin
  for I := 0 to 5 do
    m_RSendArray.SendArray[I + 3] := StandAry[I]; //正常；饮酒；酗酒标准
  if bDisplayMeasure then //液晶显示屏中是否显示测酒含量
    m_RSendArray.SendArray[2] := $05
  else
    m_RSendArray.SendArray[2] := $01;

  m_YJDT := now;
  m_YJDT_First := now;
end;

procedure TCmdAA.MakeArray;
var
  StrHH, StrMM, StrSS: string;
begin
  m_RSendArray.nSendLength := 16;

  m_RSendArray.SendArray[0] := $AA;


  m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
  m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
  m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

  strHH := copyEx(FormatDateTime('tt', now), 1, 2);
  m_RSendArray.SendArray[12] := StrToInt(strHH);

  strMM := copyEx(FormatDateTime('tt', now), 4, 2);
  m_RSendArray.SendArray[13] := StrToInt(strMM);

  strSS := copyEx(FormatDateTime('tt', now), 7, 2);
  m_RSendArray.SendArray[14] := StrToInt(strSS);

  CheckArray;
end;

procedure TCmdAA.TranslationData();
//功能：翻译AA协议命令
begin
  m_byVersion := m_RrecArray.RecArray[8]; //协议版本号

  CopyMemory(@m_ApparatusInfo,@m_RrecArray.RecArray[1],2);
  m_ApparatusInfo.wStatus := m_RrecArray.RecArray[3];
  m_ApparatusInfo.bReady := (Bits(m_RrecArray.RecArray[3],0,0) = 1);

  CopyMemory(@m_ApparatusInfo.dwHVoltage0,@m_RrecArray.RecArray[4],2);
  CopyMemory(@m_ApparatusInfo.dwHVoltage1,@m_RrecArray.RecArray[6],2);

  m_ApparatusInfo.bSensorStatus := (m_ApparatusInfo.wStatus and $20) = $20; //传感器状态


end;




procedure TCmdAA.WriteStandVolt(StandAry: TStandAry6);
//功能：写入标准
var
  I: Integer;
begin
  for I := 0 to 5 do
    m_RSendArray.SendArray[I+3] := StandAry[I];
end;

{ TCmdGH }

function TCmdGH.CheckRecArray: Boolean;
begin
    Result := True;
   //判断长度
    if m_RrecArray.nRecLength <> m_RSendArray.nSendLength then
        begin
            Result := False;
            Exit;
        end;

   //首字节是否为 $E0 且相等
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;
   //末字节是否相等
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;

   //判断校验和
    if m_RrecArray.RecArray[63] <> m_RSendArray.SendArray[63] then
        begin
            Result := False;
            Exit;
        end;
end;

constructor TCmdGH.Create(SndAry58: TSndAry58; nIndex: Integer);
var
    I: Integer;
begin
    for I := 0 to 57 do
        m_RSendArray.SendArray[I + 3] := SndAry58[I]; //字模
    m_RSendArray.SendArray[1] := nIndex; //字序号从0开始
end;

procedure TCmdGH.MakeArray;
begin
    m_RSendArray.nSendLength := 64;
    m_RSendArray.SendArray[0] := $EE;

    m_RSendArray.SendArray[2] := $00;

    m_RSendArray.SendArray[61] := $00;
    m_RSendArray.SendArray[62] := $00;

    CheckArray
end;

procedure TCmdGH.TranslationData;
begin

end;

{ TCmdAA_Start }

function TCmdAA_Start.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_Start.Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
begin
    if bDisplayMeasure then
        m_RSendArray.SendArray[2] := $0D
    else
        m_RSendArray.SendArray[2] := $09
end;

procedure TCmdAA_Start.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;
    OutPutdebugString(PChar('发送待测界面命令'));
    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;

    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray();
end;

procedure TCmdAA_Start.TranslationData;
begin
  m_byVersion := m_RrecArray.RecArray[8]; //协议版本号

  CopyMemory(@m_ApparatusInfo,@m_RrecArray.RecArray[1],2);
  m_ApparatusInfo.wStatus := m_RrecArray.RecArray[3];
  m_ApparatusInfo.bReady := (Bits(m_RrecArray.RecArray[3],0,0) = 1);

  CopyMemory(@m_ApparatusInfo.dwHVoltage0,@m_RrecArray.RecArray[4],2);
  CopyMemory(@m_ApparatusInfo.dwHVoltage1,@m_RrecArray.RecArray[6],2);

  m_ApparatusInfo.bSensorStatus := (m_ApparatusInfo.wStatus and $20) = $20; //传感器状态

  //图像捕捉值, 1为捕捉图像, 0 为不捕捉图像
  if Word(m_RrecArray.RecArray[9]) >0 then
    begin
     // if IsWindow(hWnd) then ; //发送捕捉图像消息给测酒界面
        PostMessage(0, 0, 0, 0);
    end;
end;

{ TCmdName }

function TCmdName.CheckRecArray: Boolean;
begin
    Result := True;
   //判断长度
    if m_RrecArray.nRecLength <> m_RSendArray.nSendLength then
        begin
            Result := False;
            Exit;
        end;

   //首字节是否为 $E0 且相等
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;
   //末字节是否相等
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;

   //判断校验和
    if m_RrecArray.RecArray[63] <> m_RSendArray.SendArray[63] then
        begin
            Result := False;
            Exit;
        end;

end;

constructor TCmdName.Create(SendAry: TSndAry116; nIndex, nTopOrBottom: Integer);
var
    I: Integer;
begin
    if nTopOrBottom = N_Top then
        for I := 0 to 60 - 1 do
            m_RSendArray.SendArray[I + 3] := SendAry[I] //字模上半部分60
    else if nTopOrBottom = N_Bottum then
        begin
            for I := 0 to 56 - 1 do
                m_RSendArray.SendArray[I + 3] := SendAry[I + 60]; //字模下半部分56
        end;

    m_RSendArray.SendArray[1] := nIndex * 16 + nTopOrBottom;

end;

procedure TCmdName.MakeArray;
begin
    m_RSendArray.nSendLength := 64;
    m_RSendArray.SendArray[0] := $E0;
    m_RSendArray.SendArray[2] := $00;

    CheckArray
end;


procedure TCmdName.TranslationData;
begin

end;

{ TCmdAA_Prepare }

function TCmdAA_Prepare.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdAA_Prepare.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $15;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;



{ TCmdGetVolt }

function TCmdGetVolt.CheckRecArray: Boolean;
begin
    Result := (m_RrecArray.RecArray[0] = $CC)
end;

procedure TCmdGetVolt.MakeArray;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $CC;

    CheckArray
end;


procedure TCmdGetVolt.TranslationData();
//功能:翻译数据
var
  wVoltage : Word;
begin
  CopyMemory(@wVoltage,@m_RrecArray.RecArray[1],2);
  m_ApparatusBaseVlt.wNormalVoltage := wVoltage;

  CopyMemory(@wVoltage,@m_RrecArray.RecArray[3],2);
  m_ApparatusBaseVlt.wMoreVoltage := wVoltage;

  CopyMemory(@wVoltage,@m_RrecArray.RecArray[5],2);
  m_ApparatusBaseVlt.wMuchVoltage := wVoltage;
end;
{ TCmdWriteVolt }

function TCmdWriteVolt.CheckRecArray: Boolean;
//功能：检查校验位
begin
  Result := (self.m_RrecArray.RecArray[0] = $BB);
end;

constructor TCmdWriteVolt.Create(SendAry: TStandAry6);
var
  i : Integer;
begin
  for i := 0 to 5 do
    m_RSendArray.SendArray[i + 1] := SendAry[I];
end;

procedure TCmdWriteVolt.MakeArray;
begin
  m_RSendArray.nSendLength := 16;
  m_RSendArray.SendArray[0] := $BB;
  CheckArray();
end;

procedure TCmdWriteVolt.TranslationData;
begin
  inherited;
end;

{ TCmdStopRefrash_Prepare }


function TCmdStopRefrash.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdStopRefrash.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $00;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;


procedure TCmdStopRefrash.TranslationData;
begin
//
end;

{ TCmdResetCamera }

function TCmdResetCamera.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdResetCamera.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $03;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;


{ TCmdAA_ListQZJ }

function TCmdAA_ListQZJ.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_ListQZJ.Create();
begin
    m_RSendArray.SendArray[2] := $25;
end;

procedure TCmdAA_ListQZJ.MakeArray;
var
    strHH, strMM, strSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;

    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray;

end;

{ TCmdAA_PlayRecSound }

function TCmdAA_PlayRecSound.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_PlayRecSound.Create(nRecIndex: Integer);
begin
    m_RSendArray.SendArray[0] := $99;
    m_RSendArray.SendArray[1] := nRecIndex;
end;

procedure TCmdAA_PlayRecSound.MakeArray;
var
    I: Integer;
begin
    m_RSendArray.nSendLength := 16;
    for I := 2 to 15 do
        m_RSendArray.SendArray[I] := 0;
    CheckArray;
end;


procedure TCmdAA_PlayRecSound.TranslationData;
begin

end;

{CmdGetStdVolt}


function TCmdGetStdVolt.CheckRecArray: Boolean;
begin
  Result := (Self.m_RrecArray.RecArray[0] = $AB);
end;


procedure TCmdGetStdVolt.MakeArray;
var
  I: Integer;
begin
  m_RSendArray.nSendLength := 16;
  m_RSendArray.SendArray[0] := $AB;
  for I := 1 to 6 do
    m_RSendArray.SendArray[I] := $00;
  CheckArray();
end;

procedure TCmdGetStdVolt.TranslationData();
begin
  m_byStandVolt[0] := m_RrecArray.RecArray[1];
  m_byStandVolt[1] := m_RrecArray.RecArray[2];
  m_byStandVolt[2] := m_RrecArray.RecArray[3];
  m_byStandVolt[3] := m_RrecArray.RecArray[4];
  m_byStandVolt[4] := m_RrecArray.RecArray[5];
  m_byStandVolt[5] := m_RrecArray.RecArray[6];
end;


end.

