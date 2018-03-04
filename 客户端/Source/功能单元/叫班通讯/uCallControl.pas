unit uCallControl;
////////////////////////////////////////////////////////////////////////////////

//类名: TCallControl

//描述：用于控制无线叫班系统

////////////////////////////////////////////////////////////////////////////////

interface

uses SysUtils, CPort, StrUtils, Windows,uLogs;

type
  TCallControl = class

  public
    constructor Create();
    destructor Destroy(); override;

  public
    {功能：打开串口}
    function OpenPort(const port: integer; const band: integer = 9600): integer;
    {功能：关闭串口}
    procedure ClosePort();
    {功能：设置从机设备号}
    function SetCallControlNum(const num: word): integer;
    {功能：获取从机设备号}
    function GetCallControlNum(var devnum: word): integer;
    {功能：呼叫设备}
    function CallRoom(const num: word): integer;
    {功能：查询呼叫设备号}
    function QueryCallDevState(var devnum: word): integer;
    //查询设备状态
    function QueryDeviceState(nDeviceID : Word) : boolean;
    {功能：挂断}
    function Hangup(const num: word): integer;
    {功能：发射器模块复位}
    function Reset() : integer;
    {功能：拨号方式选择}
    function SelectType(const typeID : word) : Integer;
    {功能：获取录音模式}
    function GetRecordMode():Integer;
    {功能：设置录音模式选择}
    function SetRecordMode(Mode : Word) : boolean;
    {功能：获取放音模式}
    function GetPlayMode() : Integer;
    {功能：设置放音模式}
    function SetPlayMode(Mode : Word) : boolean;
    //打开攻放
    function OpenGF() : boolean;
    //关闭攻放
    function CloseGF() : boolean;
  private
    {功能：CRC校验}
    procedure TCRC(old: array of byte; const len: Integer);
    {功能：无线叫班协议组装}
    procedure FixProtocol(const parm: word = 0);
    function WriteSerial(const wdata: array of byte; const len: integer): integer;
    function ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;overload;
    function ReadSerial(var wdata: array of byte; const len: integer):Integer;overload;
    function GetSerialErrCode(strerr: string): integer;
  private
    ComPort1: TComPort;
    {连接的串口号}
    m_nPort: integer;
    {波特率}
    m_nBand: integer;
    {上位机发送命令}
    m_byScmd: array[0..7] of byte;
    {下位机返回指令}
    m_byRcmd: array[0..7] of byte;
    {协议类型}
    type protocol = (SETCALLNUM, GETCALLNUM, CALL, QUERYCALL, HANG,SELECT_TYPE,ptReset,ptRecordEx,ptPlayEx,ptTestGF);
    {当前命令}
    var  m_ptltype: protocol;

  end;

implementation

constructor TCallControl.Create();
  //功能：初始化成员变量，创建串口对象
begin
  m_nPort := -1;
  m_nBand := 9600;
  m_byScmd[0] := $AA;
  m_byScmd[1] := $55;
  ComPort1 := TComPort.Create(nil);
end;


destructor TCallControl.Destroy();
    //功能：关闭串口
begin
  if ComPort1.Connected = FALSE then
    ComPort1.Close();
  m_nPort := -1;
  if Assigned(ComPort1) then
   FreeAndNil(ComPort1);
end;

function TCallControl.SelectType(const typeID: word): Integer;
 //功能：选择通讯模式(1：串口;2音乐)
 //返回值：1 呼叫设备成功  >1 呼叫失败错误码
begin
  m_ptltype := SELECT_TYPE;
  FixProtocol(typeID);

  //向串口写数据
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
end;

function TCallControl.SetCallControlNum(const num: word): integer;
   //功能：从机房间号设置
   //参数：num 从机房间号

var rst: integer;
    devnum: word;
begin

   //协议组装
  m_ptltype := SETCALLNUM;
  FixProtocol(num);

   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst; //

end;

function TCallControl.SetPlayMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptPlayEx;
  FixProtocol(Mode);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;
  end
end;

function TCallControl.SetRecordMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptRecordEx;
  FixProtocol(Mode);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;;
  end
end;

function TCallControl.GetCallControlNum(var devnum: word): integer;
   //功能：从机房间号查询
   //
var rst: integer;
begin
     //协议组装
  m_ptltype := GETCALLNUM;
  FixProtocol(0);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst;
end;


function TCallControl.GetPlayMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptPlayEx;
  FixProtocol(0);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
    end;;
  end
end;

function TCallControl.GetRecordMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptRecordEx;
  FixProtocol(0);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
      if (Result < 1) or (Result > 2) then
        Result := -1;
    end;;
  end
end;

function TCallControl.CallRoom(const num: word): integer;
//功能：呼叫房间号
var
  strTemp: string;
  i: Integer;
begin
  //协议组装
  m_ptltype := CALL;
  FixProtocol(num);
  //接通命令
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {闫，将发送命令写入日志}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;  
  TLog.SaveLog(Now,'发送呼叫命令：' + strTemp);
  
  OutputDebugString(PChar(Format('--------------------------------------发送呼叫命令:%d',[Result])));
  //写成功，则读取串口数据
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------取呼叫命令:%d',[Result])));
  end
end;

function TCallControl.QueryCallDevState(var devnum: word): integer;
//查询呼叫设备号
//参数：devnum = 0 无设备呼叫
//返回值: 1: 2: 3:
var rst: integer;
begin
  //协议组装
  m_ptltype := QUERYCALL;
  FixProtocol(0);

   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else begin
    Result := rst;
  end;

end;

function TCallControl.QueryDeviceState(nDeviceID: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := QUERYCALL;
  try
    FixProtocol(0);
    //向串口写数据
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------发送查询命令:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------发送查询命令失败:%d',[Result])));
      exit;
    end;
    //写成功，则读取串口数据
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------读取查询命令返回成功:%d',[m_byRcmd[5]])));    
    if m_byRcmd[5] <> 1 then exit;

    Result := true;
  except

  end;
end;

function TCallControl.Hangup(const num: word): integer;
 //功能：挂机
 //返回值：1 呼叫设备成功  >1 呼叫失败错误码
begin

   //协议组装
  m_ptltype := HANG;
  FixProtocol(num);

  //向串口写数据
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));

end;

procedure TCallControl.TCRC(old: array of byte; const len: Integer);
var i: integer;
  sum: integer;
  strhex: string;
begin
  sum := 0;
  for i := 0 to len - 2 do
    sum := sum + old[i];

  sum := not (sum);
  strhex := IntToHex(sum, 2);
  m_byScmd[7] := StrToInt('$' + strhex) + 1;

end;

function TCallControl.OpenGF: boolean;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(1);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end

end;

function TCallControl.OpenPort(const port: integer; const band: integer): integer;
  //功能：打开串口
  //返回值：1 串口打开成功   >1串口打开失败错误码
var strcom: string;
begin
  m_nPort := port;
  strcom := 'COM' + IntToStr(m_nPort);
  begin
    try
      ComPort1.Port := strcom;
      ComPort1.Open();
    except
      on Err: Exception do
      begin
        Result := GetSerialErrCode(Err.Message);
        exit;
      end;
    end
  end;
  Result := 1;
end;

function TCallControl.CloseGF: boolean;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(2);
   //向串口写数据
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //写成功，则读取串口数据
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end
end;

procedure TCallControl.ClosePort();
  //功能：关闭串口
begin
  ComPort1.Close();
end;

procedure TCallControl.FixProtocol(const parm: word);
//功能：无线叫班协议组装
begin
   //清空协议内容部分
  ZeroMemory(@m_byScmd[2], Length(m_byScmd) - 2);
  case m_ptltype of
    SETCALLNUM:
      begin
        m_byScmd[2] := $58;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    GETCALLNUM:
      begin
        m_byScmd[2] := $59;
      end;
    CALL:
      begin
        m_byScmd[2] := $60;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    QUERYCALL:
      begin
        m_byScmd[2] := $61;
      end;
    HANG:
      begin
        m_byScmd[2] := $62;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    SELECT_TYPE:
      begin
        m_byScmd[2] := $63;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
     ptReset:
      begin
        m_byScmd[2] := $64;
        m_byScmd[3] := 0;
        m_byScmd[4] := 0;
      end;
      ptRecordEx:
      begin
        m_byScmd[2] := $65;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
      ptPlayEx:
      begin
        m_byScmd[2] := $66;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;

      ptTestGF :
      begin
        m_byScmd[2] := $70;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
  end;
    //
  TCRC(m_byScmd, sizeof(m_byScmd));

end;

function TCallControl.WriteSerial(const wdata: array of byte; const len: integer)
  : integer;
//功能：写串口数据
//返回值：1 写成功 ；>1 端口错误码
begin
  try
    ComPort1.ClearBuffer(True,TRUe);
    ComPort1.Write(wdata, sizeof(wdata));
  except
    on Err: Exception do
    begin
      Result := GetSerialErrCode(Err.Message);
      exit;
    end;

  end;
  Result := 1;
end;

function TCallControl.ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;
//功能：读串口数据
//返回值：1 读取数据成功  >1 读数据失败错误码
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);

  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //房间号
    case wdata[2] of
      $61:
        begin
          if num = 0 then
          begin
            Result := 1;
          end
          else
            Result := wdata[5]; //
        end; //end if
    else
      Result := 1;
    end; //end case
  end
  else
    Result := -1; //

end;

function TCallControl.ReadSerial(var wdata: array of byte;
  const len: integer): Integer;
//功能：读串口数据
//返回值：1 读取数据成功  >1 读数据失败错误码
var
  rst: integer;
begin
  Result := -1; //
  rst := ComPort1.Read(wdata, len);
  if rst = sizeof(wdata) then
  begin
    Result := 1;
  end;
end;

function TCallControl.Reset: integer;
begin
   //协议组装
  m_ptltype := ptReset;
  FixProtocol(0);
  //向串口写数据
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
end;

function TCallControl.GetSerialErrCode(strerr: string): integer;
var idx: integer;
begin
  idx := Pos('code:', strerr);
  strerr := LeftStr(strerr, Length(strerr) - Length(')'));
  Result := StrToInt(RightStr(strerr, Length(strerr) - idx - Length('code:')));
end;


end.

