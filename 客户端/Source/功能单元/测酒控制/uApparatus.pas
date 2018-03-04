
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
   ///  TAlcoholTest  �����ͨ����
   ///  ����Ϳ��Ʋ��������ͨѶ���ͻ�ȡ�����״̬
   ////////////////////////////////////////////// /////////////////////////////
  TApparatus = class
  public
    constructor Create();
    destructor Destroy; override;
  public
    {���ܣ����豸}
    function Open(): Boolean;
    {���ܣ��ر��豸}
    procedure Close();
    {���ܣ���ʼ����}
    procedure StartTest(bStateChangeOnEndTest: Boolean = False);
    {���ܣ�ֹͣ����}
    procedure StopTest();
    {����:��ȡ��Ʊ�׼}
    function ReadStandValue: TStandAry6;
    {����:��ȡ��׼��ѹ}
    function GetStdVolt(): RApparatusVoltage;
    {����:���û�׼��ѹ}
    function SetStdVolt(ApparatusBaseVlt: RApparatusVoltage): Boolean;
    {����:��������}
    function SendData(Cmd: TCmdBase): boolean;
    {����:����豸����״̬}
    function CheckDeviceConn:boolean;
    //����ǲ��Ų�ƽ������
    procedure PlaySound(soundindex : integer);
  private
    m_bCommunicationsRegular: Boolean; //ͨѶ�Ƿ�����
    m_bConnected: Boolean; //�Ƿ�����
    m_USB374Index: Integer; //374�豸��
    {���״̬�仯�Զ���������}
    m_bStateChangeOnEndTest: Boolean;

    m_byVersion: Byte; //Э��汾��
    m_AlcoholThread: TApparatusThread;
    m_ApparatusInfo: RApparatusInfo; //�����״̬
    m_AlcolholConfig: RAlcoholConfig; //�����������Ϣ
    m_Handle: THandle; //��Ϣ���վ��
    m_OnApparatusInfoChange: TOnApparatusInfoChange; //���״̬�ı��¼�
    m_OnCommunicationsStateChange: TOnCommunicationsStateChange; //ͨѶ״̬�仯�¼�
  private
    function OpenUsb(): Boolean;
    function ReadUSB(Command: TCmdBase): boolean;
    function ReadData(Cmd: TCmdBase): boolean;
    function SendArrayData(SendArray: RSendArray): boolean;
    procedure StopSinglechipRefrash();
    procedure RaiseAbnormityException(strExceptionMsg: string);
    procedure WndEvent(var Message: TMessage);
  public
    //����
    XM : string;
    //����
    GH : string;
    MSGHandle : THandle;
  published
    property USB374Index: Integer read m_USB374Index write m_USB374Index;
    property byVersion: Byte read m_byVersion;
    {�������Ϣ}
    property ApparatusInfo: RApparatusInfo read m_ApparatusInfo write m_ApparatusInfo;
    {�����������Ϣ}
    property AlcolholConfig: RAlcoholConfig read m_AlcolholConfig write m_AlcolholConfig;
    {ͨѶ�Ƿ�����}
    property CommunicationsRegular: Boolean read m_bCommunicationsRegular;
    property Handle: THandle read m_Handle;
    {���״̬�仯�¼�}
    property OnApparatusInfoChange: TOnApparatusInfoChange
      read m_OnApparatusInfoChange write m_OnApparatusInfoChange;
    {USB���ӱ仯�¼�}
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
//���ܣ���USB�˿��ж�ȡ���ݣ�
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
      OutputDbgStr(PChar('��374����'));
    end;
  except
    on E: exception do
    begin
      OutputDbgStr(PChar('��374����,����:(' + E.Message + ')'));
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
  Cmd.WriteRepeateInfo(False, ''); //����Ҫ���·�������Ĭ��ֵ

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
//�����߳���Ϣ
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
//��USB�з�������
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
      OutputDbgStr(PChar('д374����'));
    end;
  end;
end;

function TApparatus.SendData(Cmd: TCmdBase): boolean;
//���ܣ�������Ӳ���豸��������
begin
  EnterCriticalSection(G_CriticalSection);
  Result := False;
  try
    Cmd.MakeArray; //���ɶ�Ӧ������
    if SendArrayData(cmd.RSendArray) then
    begin
      Sleep(10);
      ReadData(cmd); //��ȡ���� //����
      m_byVersion := Cmd.ByVersion;
      if Cmd.CheckRecArray = False then //У������ //����
      begin
        RaiseAbnormityException('У������ʧ��');
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
//���ܣ����û�׼��ѹ
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
//���ܣ��׳������쳣����֪ͨ���塣
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
//����:��ʼ���
begin
  m_bStateChangeOnEndTest := bStateChangeOnEndTest;
  m_AlcoholThread.DeviceIsReady := False;
  m_AlcoholThread.IsReadDeviceState := True;
end;



procedure TApparatus.StopSinglechipRefrash;
//����:����ֹͣ374��λ����
var
  CmdStopRefrash: TCmdStopRefrash;
begin
  Outputdebugstring('����ֹͣ374��λ����');
  CmdStopRefrash := TCmdStopRefrash.Create;
  SendData(TCmdBase(CmdStopRefrash));
  CmdStopRefrash.Free;
end;


procedure TApparatus.StopTest;
//����:ֹͣ���
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
//���ܣ���ȡ�豸״̬
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
//���ܣ��ر��豸,ͬʱֹͣ�߳�
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
//���ܣ���USB�˿�
begin

  Sleep(100); //374оƬ���Ϻ���ʱ��ȴ�700-800ms�ſ�ʼ������Ӳ���й�
  CH375ResetDevice(USB374Index);
  OutputDbgStr('����CH375ResetDevice ����');
  Sleep(800);
  if CH375OpenDevice(USB374Index) <> INVALID_HANDLE_VALUE then
  begin
    CH375SetExclusive(0, 1);
    OutputDbgStr('CH375OpenDevice �ɹ�'
      + FormatDateTime('yyyy-mm-dd hh:mm:ss', now));
    Result := True;
  end
  else
  begin
    OutputDbgStr('CH375OpenDevice ʧ�ܣ�'
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

