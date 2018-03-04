
unit uApparatus;

interface

uses Windows, SysUtils, untDeclare, Messages, Dialogs, Classes,
  Forms, Math, SyncObjs, UCommand, uBaseDefine, Contnrs, uApparatuslThread;
var
  G_CriticalSection: TRTLCriticalSection;
const
  WM_PhotoCaptured  = WM_User + 201;
type
   /////////////////////////////////////////////////////////////////////////////
   ///  TAlcoholTest  测酒仪通信类
   ///  管理和控制测酒仪数据通讯，和获取测酒仪状态
   ////////////////////////////////////////////// /////////////////////////////
  TApparatus = class
  public
    constructor Create();
    destructor Destroy; override;
  public
    {功能：打开设备}
    function Open(): Boolean;
    {功能：关闭设备}
    procedure Close();
    {功能：开始测试}
    procedure StartTest(bStateChangeOnEndTest: Boolean = False);
    {功能：停止测试}
    procedure StopTest();
    {功能:读取测酒标准}
    function ReadStandValue: TStandAry6;
    {功能:读取基准电压}
    function GetStdVolt(): RApparatusVoltage;
    {功能:设置基准电压}
    function SetStdVolt(ApparatusBaseVlt: RApparatusVoltage): Boolean;
    {功能:发送命令}
    function SendData(Cmd: TCmdBase): boolean;
    {功能:检测设备连接状态}
    function CheckDeviceConn:boolean;
    //测酒仪播放测酒结果声音
    procedure PlaySound(soundindex : integer);
  private
    m_bCommunicationsRegular: Boolean; //通讯是否正常
    m_bConnected: Boolean; //是否连接
    m_USB374Index: Integer; //374设备号
    {测酒状态变化自动结束测试}
    m_bStateChangeOnEndTest: Boolean;

    m_byVersion: Byte; //协议版本号
    m_AlcoholThread: TApparatusThread;
    m_ApparatusInfo: RApparatusInfo; //测酒仪状态
    m_AlcolholConfig: RAlcoholConfig; //测酒仪配置信息
    m_Handle: THandle; //消息接收句柄
    m_OnApparatusInfoChange: TOnApparatusInfoChange; //测酒状态改变事件
    m_OnCommunicationsStateChange: TOnCommunicationsStateChange; //通讯状态变化事件
  private
    function OpenUsb(): Boolean;
    function ReadUSB(Command: TCmdBase): boolean;
    function ReadData(Cmd: TCmdBase): boolean;
    function SendArrayData(SendArray: RSendArray): boolean;
    procedure StopSinglechipRefrash();
    procedure RaiseAbnormityException(strExceptionMsg: string);
    procedure WndEvent(var Message: TMessage);
  public
    //姓名
    XM : string;
    //工号
    GH : string;
    MSGHandle : THandle;
  published
    property USB374Index: Integer read m_USB374Index write m_USB374Index;
    property byVersion: Byte read m_byVersion;
    {测酒仪信息}
    property ApparatusInfo: RApparatusInfo read m_ApparatusInfo write m_ApparatusInfo;
    {测酒仪配置信息}
    property AlcolholConfig: RAlcoholConfig read m_AlcolholConfig write m_AlcolholConfig;
    {通讯是否正常}
    property CommunicationsRegular: Boolean read m_bCommunicationsRegular;
    property Handle: THandle read m_Handle;
    {测酒状态变化事件}
    property OnApparatusInfoChange: TOnApparatusInfoChange
      read m_OnApparatusInfoChange write m_OnApparatusInfoChange;
    {USB连接变化事件}
    property OnCommunicationsStateChange: TOnCommunicationsStateChange read
      m_OnCommunicationsStateChange write m_OnCommunicationsStateChange;
    property Connected: Boolean read m_bConnected;
    property StateChangeOnEndTest: Boolean read m_bStateChangeOnEndTest write
      m_bStateChangeOnEndTest;

  end;

implementation
uses CH375DLL;
{ TApparatus }



function TApparatus.ReadUSB(Command: TCmdBase): BOOLEAN;
//功能：从USB端口中读取数据；
var
  I: Integer;
  P374SendLen: cardinal;
  dwRead: DWORD;
  DataArray: array of Byte;
begin
  Result := False;
  P374SendLen := Command.RSendArray.nSendLength;
  dwRead := Command.RSendArray.nSendLength;
  SetLength(DataArray, dwRead);
  FillChar(DataArray[0], dwRead, 0);
  try
    if CH375ReadData(USB374Index, @DataArray[0], @P374SendLen) then
    begin
      Command.WriteRecLen(P374SendLen);
      for I := 0 to P374SendLen - 1 do
        Command.WriteRec(I, DataArray[I]);
      Result := True;
    end
    else
    begin
      Result := False;
      OutputDbgStr(PChar('读374错误'));
    end;
  except
    on E: exception do
    begin
      OutputDbgStr(PChar('读374错误,错误:(' + E.Message + ')'));
    end;
  end;
end;

function TApparatus.ReadStandValue: TStandAry6;
begin
  Result[0] := (m_AlcolholConfig.dwNormalStandard -
    m_AlcolholConfig.dwNormalModify);

  Result[1] := (m_AlcolholConfig.dwNormalStandard -
    m_AlcolholConfig.dwNormalModify) div 256;

  Result[2] := (m_AlcolholConfig.dwDrinkStandard -
    m_AlcolholConfig.dwDrinkModify);

  Result[3] := (m_AlcolholConfig.dwDrinkStandard -
    m_AlcolholConfig.dwDrinkModify) div 256;

  Result[4] := (m_AlcolholConfig.dwBibulosityStandard -
    m_AlcolholConfig.dwBibulosityModify);

  Result[5] := (m_AlcolholConfig.dwBibulosityStandard -
    m_AlcolholConfig.dwBibulosityModify) div 256;

end;


constructor TApparatus.Create();
begin
  m_bConnected := False;
  m_bCommunicationsRegular := False;
  m_bStateChangeOnEndTest := False;

  m_ApparatusInfo.wStatus := $44;
  m_ApparatusInfo.dwHVoltage0 := 0;
  m_ApparatusInfo.dwHVoltage1 := 0;
  m_ApparatusInfo.bSensorStatus := FALSE;
  m_Handle := forms.AllocateHWnd(WndEvent);
  m_AlcoholThread := TApparatusThread.Create(Self);
  InitializeCriticalSection(G_CriticalSection);

end;

destructor TApparatus.Destroy;
begin
  FreeAndNil(m_AlcoholThread);
  Close();
  forms.DeallocateHWnd(m_Handle);
  DeleteCriticalSection(G_CriticalSection);
  inherited;
end;

function TApparatus.GetStdVolt: RApparatusVoltage;
var
  CmdGetVolt: TCmdGetVolt;
begin
  CmdGetVolt := TCmdGetVolt.Create;
  SendData(CmdGetVolt);
  Result := CmdGetVolt.ApparatusBaseVlt;
  CmdGetVolt.Free;
end;

function TApparatus.ReadData(Cmd: TCmdBase): boolean;
begin
  Result := True;
  Cmd.WriteRepeateInfo(False, ''); //不需要重新发送命令默认值

  if (ReadUSB(Cmd) = FALSE) then
  begin
    if (ReadUSB(Cmd) = FALSE) then
    begin
      if (ReadUSB(Cmd) = FALSE) then
      begin
        Result := False;
        m_AlcolholConfig.dwStatus := crIniStatus;
        RaiseAbnormityException(cs_ReadFail);
      end;
    end;
  end;
end;

procedure TApparatus.WndEvent(var Message: TMessage);
//接收线程消息
begin
  case Message.Msg of
    WM_APPARATUS_INFO_CHANGE:
      begin
        if Assigned(m_OnApparatusInfoChange) then
          m_OnApparatusInfoChange(m_ApparatusInfo);
      end;
    WM_CommunicationsFailure:
      begin
        if Assigned(m_OnCommunicationsStateChange) then
          m_OnCommunicationsStateChange(False);
      end;
    WM_CommunicationsSuccess:
      begin
        if Assigned(m_OnCommunicationsStateChange) then
          m_OnCommunicationsStateChange(True);
      end;

  end;
end;

function TApparatus.SendArrayData(SendArray: RSendArray): boolean;
//往USB中发送数据
var
  ovWrite: TOverLapped;
  P374SendLen: cardinal;
begin
  Result := False;
  try
    P374SendLen := SendArray.nSendLength;
    FillChar(ovWrite, SizeOf(ovWrite), 0);
    Result := CH375WriteData(USB374Index, @SendArray.SendArray, @P374SendLen);
  except
    on E: Exception do
    begin
      OutputDbgStr(PChar('写374错误'));
    end;
  end;
end;

function TApparatus.SendData(Cmd: TCmdBase): boolean;
//功能：向测酒仪硬件设备发送数据
begin
  EnterCriticalSection(G_CriticalSection);
  Result := False;
  try
    Cmd.MakeArray; //生成对应的命令
    if SendArrayData(cmd.RSendArray) then
    begin
      Sleep(10);
      ReadData(cmd); //读取数据 //新增
      m_byVersion := Cmd.ByVersion;
      if Cmd.CheckRecArray = False then //校验数据 //新增
      begin
        RaiseAbnormityException('校验数据失败');
        Exit;
      end;
      Cmd.TranslationData();
      Result := True;
    end;
    Sleep(10);
  finally
    LeaveCriticalSection(G_CriticalSection);

    if Result then
    begin
      if m_bCommunicationsRegular = False then
        PostMessage(Handle, WM_CommunicationsSuccess, 0, 0)
    end
    else
    begin
      if m_bCommunicationsRegular then
        PostMessage(Handle, WM_CommunicationsFailure, 0, 0)
    end;

    m_bCommunicationsRegular := Result;
  end;
end;

function TApparatus.SetStdVolt(ApparatusBaseVlt: RApparatusVoltage): Boolean;
//功能：设置基准电压
var
  wBZ, wYJ, wXJ: Word;
  CmdWriteVolt: TCmdWriteVolt;
  SendAry: TStandAry6;
begin
  wBZ := ApparatusBaseVlt.wNormalVoltage;
  wYJ := ApparatusBaseVlt.wMoreVoltage;
  wXJ := ApparatusBaseVlt.wMuchVoltage;
  CopyMemory(@SendAry[0], @wBZ, 2);
  CopyMemory(@SendAry[2], @wYJ, 2);
  CopyMemory(@SendAry[4], @wXJ, 2);
  CmdWriteVolt := TCmdWriteVolt.Create(SendAry);
  Result := SendData(CmdWriteVolt);
  CmdWriteVolt.Free;
end;

procedure TApparatus.RaiseAbnormityException(strExceptionMsg: string);
//功能：抛出错误异常，并通知窗体。
begin
  OutputDbgStr(strExceptionMsg);
  m_ApparatusInfo.wStatus := crAbnormity;
  m_ApparatusInfo.dwHVoltage0 := 0;
  m_ApparatusInfo.dwHVoltage1 := 0;
  m_ApparatusInfo.bSensorStatus := TRUE;
  m_ApparatusInfo.dwAlcoholicity := 0;
  raise Exception.Create(strExceptionMsg);
end;



procedure TApparatus.StartTest(bStateChangeOnEndTest: Boolean = False);
//功能:开始测酒
begin
  m_bStateChangeOnEndTest := bStateChangeOnEndTest;
  m_AlcoholThread.DeviceIsReady := False;
  m_AlcoholThread.IsReadDeviceState := True;
end;



procedure TApparatus.StopSinglechipRefrash;
//功能:发送停止374复位命令
var
  CmdStopRefrash: TCmdStopRefrash;
begin
  Outputdebugstring('发送停止374复位命令');
  CmdStopRefrash := TCmdStopRefrash.Create;
  SendData(TCmdBase(CmdStopRefrash));
  CmdStopRefrash.Free;
end;


procedure TApparatus.StopTest;
//功能:停止测酒
begin
  m_AlcoholThread.IsReadDeviceState := False;
end;



function TApparatus.Open(): Boolean;
begin

  m_bConnected := False;
  CH375CloseDevice(m_USB374Index);
  Result := OpenUsb();
  if Result then
    m_bConnected := True;

end;



function TApparatus.CheckDeviceConn: boolean;
//功能：读取设备状态
var
  Cmd: TCmdAA;
  wCurrentStatus : Word;
begin
  Result := false;
  if not m_bConnected then
  begin
    Sleep(100);
    if not Open then
    begin
      exit;
    end;
  end;

  Cmd := TCmdAA.Create(ReadStandValue,FALSE);
  try
    Cmd.WriteStandVolt(ReadStandValue);
    if SendData(TCmdBase(Cmd)) then
    begin
      Result := true;
    end;
  finally
    Cmd.Free;
  end;
end;

procedure TApparatus.Close;
//功能：关闭设备,同时停止线程
begin
  if m_bConnected = False then Exit;
  m_bConnected := False;

  if Assigned(m_AlcoholThread) then
    StopTest();

  StopSinglechipRefrash();
  CH375CloseDevice(m_USB374Index);
  m_bConnected := False;
end;


function TApparatus.OpenUsb(): Boolean;
//功能：打开USB端口
begin

  Sleep(100); //374芯片连上后有时候等待700-800ms才开始工作与硬件有关
  CH375ResetDevice(USB374Index);
  OutputDbgStr('发送CH375ResetDevice 命令');
  Sleep(800);
  if CH375OpenDevice(USB374Index) <> INVALID_HANDLE_VALUE then
  begin
    CH375SetExclusive(0, 1);
    OutputDbgStr('CH375OpenDevice 成功'
      + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
    Result := True;
  end
  else
  begin
    OutputDbgStr('CH375OpenDevice 失败！'
      + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
    Result := False;
  end;

end;



procedure TApparatus.PlaySound(soundindex: integer);
var
  cmdSound : TCmdAA_PlayRecSound;
begin
  cmdSound :=TCmdAA_PlayRecSound.Create(soundIndex);
  try
    cmdSound.MakeArray;
    SendData(cmdSound);
  finally
    cmdSound.Free;
  end;
end;

end.

