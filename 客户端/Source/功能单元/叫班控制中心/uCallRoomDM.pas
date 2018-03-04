unit uCallRoomDM;

interface

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, Messages,
  MPlayer, Graphics,Forms,
  uMixerRecord, uCallRecord, uCallControl,
  uApparatusCommon,uUDPControl, uFTPTransportControl,uFtpConnect;
const
  //���ݿ�����֪ͨ��Ϣ
  WM_MSGDBCONNECT = WM_USER + 1;
  //��������֪ͨ��Ϣ
  WM_MSGSerialCONNECT = WM_USER + 2;
  //����״̬�л�֪ͨ��Ϣ
  WM_MSGRepartChanged = WM_USER + 3;
  //ָ��ʶ����Ϣ֪ͨ
  WM_MSGFingerCapture = WM_User + 11;
  //ָ��¼�밴ѹ֪ͨ��Ϣ
  WM_MSGFingerEnorll = WM_USER + 12;
  //���ܵ�ͼƬ����֪ͨ��Ϣ
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;
  //��ʼ¼��֪ͨ��Ϣ
  WM_MSGRecordBegin = WM_User + 21;
  //¼������֪ͨ��Ϣ
  WM_MSGRecordEnd = WM_User + 22;
  //��ʼ�а�֪ͨ��Ϣ
  WM_MSGCallBegin = WM_User + 31;
  //�а������Ϣ,wParam������0=�ɹ�,1=�򿪴���ʧ��,2=ͨ������ʧ��
  WM_MSGCallEnd = WM_User + 34;
  //�ȴ�ֵ��Ա�ֶ��ҶϽа�֪ͨ��Ϣ
  WM_MSGWaitingForConfirm = WM_User + 40;
  //(��)
  //UDP��FTP�������֪ͨ��Ϣ
  WM_MSGTestUDPEnd = WM_USER + 50;
  WM_MSGTestFTPEnd = WM_USER + 51;
type

  {*******���ݿ����ýṹ*****}
  RDBConfig = record
    IP: string;
    UserName: string;
    Password: string;
    DBName: string;
  end;
  //ָ�����¼�
  TProgressNotify = procedure(Max, Position: Integer; var Cancel: boolean) of object;

  TRecordThread = class(TThread)
  private
    mixerRecord: TMixerRecord;
  protected
    procedure Execute(); override;
  public
    RecordStream: TMemoryStream;
    destructor Destroy; override;
  end;
  //////////////////////////////////////////////////////////////
  ///ȫ�����ݶ���
  //////////////////////////////////////////////////////////////
  TDMCallRoom = class(TDataModule)
    ADOConn: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    //�а�ģʽ ���ƣ�
    m_bCallModel: Boolean;// True:�����а�ģʽ��False:Զ�̽а�ģʽ
    m_bInstallAddress: Boolean;// True:��Ԣ��False:�ɰ���

    //���������ֵȴ�����ʱ�䣬��λ��
    m_nCallWaiting: Cardinal;
    //׷�м��ʱ�䣬��λ��
    m_nRecallSpace: Cardinal;
    m_CallControl: TCallControl; //���п�����
    //��С����
    m_nMinSound: Word;
    //ҹ����С��
    m_nMaxSoundNight: Word;
    //ҹ�䷶Χ��ʼʱ��
    m_dNightBegin: Double;
    //ҹ�䷶Χ����ʱ��
    m_dNightEnd: Double;
    //�����
    m_nMaxSound: Word;
    //�����ӳ�
    m_nDialDelay: Word;
    //ͨѶ����ID
    m_nCommTypeID: word;
    //�˿ں�
    m_nPort: Integer;
    //���ڱ���ʱ��
    m_nOutTimeDelay: word;
    //�������Ƿ�������
    m_bSerialConnected: boolean;
    //�Ƿ��ס����
    m_bRemeberLogin: boolean;
    //��ס������
    m_strRemeberPWD: string;
    //�Ƿ��Զ���¼
    m_bAutoLogin: boolean;
    //�Ƿ�����Ƶ��·
    m_bCheckAudioLine: boolean;
    m_nColorOutTime: integer;
    m_nColorUnenter: integer;
    m_nColorWaitingCall: integer;
    m_nColorCalling: integer;
    m_nColorOutDutyAlarm: integer;
    //�ȴ��׽�ȷ��
    m_bWaitforConfirm: boolean;
    m_bComming: boolean;

        //��������
    procedure LoadConfig;
    //--------------------------�����¼�---------------------------------
    procedure SetSerialConnected(const Value: boolean);
    procedure SetCommTypeID(const Value: word);
    procedure SetDialDelay(const Value: Word);
    procedure SetPort(const Value: Integer);
    procedure SetMinSound(const Value: Word);
    procedure SetCallWaiting(const Value: Cardinal);
    procedure SetRecallSpace(const Value: Cardinal);
    function GetMinRestLength: double;
    procedure SetMinRestLength(const Value: Double);
    procedure SetMaxSound(const Value: Word);
    //��������������С����
    procedure MinWaveOut;
    //��ϵͳ�����������������
    procedure MaxWaveOut(strRoomNo: string);
    {���ܣ���ȡ���õķ����ն�����}
    procedure GetRoomSound(strRoomNo: string;out nSound,nNightSound: Integer);

    procedure SetReparting(const Value: boolean);
    procedure SetRemeberLogin(const Value: boolean);
    procedure SetRemeberPWD(const Value: string);
    procedure SetAutoLogin(const Value: boolean);
    procedure SetOutTimeDelay(const Value: word);
    procedure SetColorCalling(const Value: integer);
    procedure SetColorOutTime(const Value: integer);
    procedure SetColorUnenter(const Value: integer);
    procedure SetColorWaitingCall(const Value: integer);
    procedure SetColorOutDutyAlarm(const Value: integer);
    procedure SetComming(const Value: boolean);
    //---------------------------����--------------------------------------
    {���ܣ���а����������ʱ�䣨�ƣ�}
    procedure SetPlaySoundTime(soundString: TStrings;dtTime: TDateTime);
  public
    { Public declarations }
    //ָ����״̬{0����������1�����쳣}

    //���ݿ����ýṹ
    DBConfig: RDBConfig;
    //�����¼ֵ��Ա��Ϣ�ṹ
    //DutyUser: RDutyUser;
    //ģ�����ͣ�������ʾ������ģ��
    ModuleType: Integer;
    //��ǰ���������õ�����
    LocalArea: string;
    //�ж��Ƿ��ڵȴ�ֵ��Ա�ֶ�ȷ���׽�
    WaitingForConfirm: boolean;
    HangupTime: TDateTime;
    //�Ƿ�ɰ汾
    OldVersion: boolean;
    //��һ�μ�¼�ĳ��ڳ���
    LastDrinkTrainNo: string;

    //UDPͨѶFTPͨѶ (��)
    UDPControl: TUDPControl;
    FTPCon: TFTPConnect;
    bUDPConnect: Boolean;
    bCanUDPLogs: Boolean;
    bFTPConnect: Boolean;
    bCanFTPLogs: Boolean;

    //����ϵͳ������Ϣ
    procedure SaveConfig;
    //���з���
    function CallRoom(nDeviceID: Integer): integer;
    //��ȡ�ɵ�Э��ĺ�������
    function GetOldCallCommand(nDeviceID: Integer): string;
    //��ȡ�µ�Э��ĺ�������
    function GetNewCallCommand(nDeviceID: Integer): string;
    //�ҶϺ���
    function HangCall(): boolean;
    //�����״νа�����
    procedure PlayFirstCall(roomNumber, trainNo: string;strTime: string = '1899-12-30 00:00:00');
    //����׷������
    procedure PlaySecondCall(roomNumber, trainNo: string);
    //�Զ��а�
    function AutoCallRoom(planGUID, roomNuber, trainNo: string; nDeveiveID: Integer;
      recall: boolean; playMusic: boolean = true): Boolean;
    //�Զ���ͨ�а�
    function AutoConnectCall(roomNuber, trainNo: string; nDeveiveID: Integer; var bCancel: boolean;
      playMusic: boolean = true): boolean;
    //�رջ�Ͳ
    procedure CloseMic;
    //�򿪻�Ͳ
    procedure OpenMic;
    //��ʼ¼��
    procedure StartRecord;
    //�Ƿ��ڽа������
    property Comming: boolean read m_bComming write SetComming;
    //��Сǿ��ʱ��(Сʱ)
    property MinRestLength: Double read GetMinRestLength write SetMinRestLength;
    //���������ֵȴ�����ʱ�䣬��λ��
    property CallWaiting: Cardinal read m_nCallWaiting write SetCallWaiting;
    //׷�м��ʱ�䣬��λ��
    property RecallSpace: Cardinal read m_nRecallSpace write SetRecallSpace;
    //��С������
    property MinSound: Word read m_nMinSound write SetMinSound;
    //���ͨ����
    property MaxSound: Word read m_nMaxSound write SetMaxSound;
    //���ڶ˿ں�
    property Port: Integer read m_nPort write SetPort;
    //����������ӳ�
    property DialDelay: Word read m_nDialDelay write SetDialDelay;
    //ͨѶ����(����������)
    property CommTypeID: word read m_nCommTypeID write SetCommTypeID;
    //���ڱ���ʱ��
    property OutTimeDelay: word read m_nOutTimeDelay write SetOutTimeDelay;
    //�����Ƿ��Ѿ�����
    property SerialConnected: boolean read m_bSerialConnected write SetSerialConnected;
    //�а����
    property CallControl: TCallControl read m_CallControl;
    //�Ƿ��ס����
    property RemeberLogin: boolean read m_bRemeberLogin write SetRemeberLogin;
    //��ס������
    property RemeberPWD: string read m_strRemeberPWD write SetRemeberPWD;
    //�Ƿ��Զ���¼
    property AutoLogin: boolean read m_bAutoLogin write SetAutoLogin;
    //ҹ����С��
    property MaxSoundNight: Word read m_nMaxSoundNight write m_nMaxSoundNight;
    //ҹ�䷶Χ��ʼʱ��
    property NightBegin: Double read m_dNightBegin write m_dNightBegin;
    //ҹ�䷶Χ����ʱ��
    property NightEnd: Double read m_dNightEnd write m_dNightEnd;
    //�ȴ��׽�ȷ��
    property WaitforConfirm: boolean read m_bWaitforConfirm write m_bWaitforConfirm;
    //�Ƿ�����Ƶ��·
    property CheckAudioLine: boolean read m_bCheckAudioLine write m_bCheckAudioLine;
    property ColorOutTime: integer read m_nColorOutTime write SetColorOutTime;
    property ColorUnenter: integer read m_nColorUnenter write SetColorUnenter;
    property ColorWaitingCall: integer read m_nColorWaitingCall write SetColorWaitingCall;
    property ColorCalling: integer read m_nColorCalling write SetColorCalling;
    property ColorOutDutyAlarm: integer read m_nColorOutDutyAlarm write SetColorOutDutyAlarm;


    //�а�ģʽ ���ƣ�
    property bCallModel: Boolean read m_bCallModel write m_bCallModel;
    property bInstallAddress: Boolean read m_bInstallAddress write m_bInstallAddress;
  end;

var
  DMCallRoom: TDMCallRoom;

implementation
{$R *.dfm}
uses
  IniFiles, ADOInt, MMSystem, Variants, ActiveX, uAudio,
  DirectShow9, DSPack, DateUtils, Controls,uLogs,uGlobalDM;
{ TDMGlobal }

function ConvertSoundChar(soundChar: string): string;
begin
  Result := soundChar;
  if Result = '*' then
  begin
    Result := 'star';
  end;
end;




function TDMCallRoom.AutoCallRoom(planGUID, roomNuber, trainNo: string; nDeveiveID: Integer;
  recall: boolean; playMusic: boolean = true): Boolean;
//���ܣ��Զ��а�
var
  i, devID, maxCallCount: Integer;
  callSucceed: boolean;
  recordThread: TRecordThread;
  ms: TMemoryStream;
  recordData: RCallRecord;
begin
  Result := false;
  devID := nDeveiveID;
  maxCallCount := 0;
  callSucceed := false;
  try
    CloseMic;
    Comming := True;
{$REGION '���Ӻ��У����ʧ�����ظ�10��'}
    repeat
      Sleep(500);
      Application.ProcessMessages;
      if CallRoom(devID) > 0 then
      begin
        Inc(maxCallCount);
      end
      else begin
        maxCallCount := 1000;
        callSucceed := true;
      end;
    until (maxCallCount >= 10);
{$ENDREGION '���Ӻ��У����ʧ�����ظ�10��'}
    //����¼���̣߳�������¼��
    recordThread := TRecordThread.Create(true);
    try
      recordThread.Resume;
{$REGION '���Žа�����'}
      if callSucceed then
      begin
        if not recall then
        begin
          PlayFirstCall(roomNuber, trainNo);
            //�ȴ�˾���ش�6��ȴ�
          for i := 1 to 30 do
          begin
            Application.ProcessMessages;
            Sleep(200);
          end;
        end
        else
          PlaySecondCall(roomNuber, trainNo);
        Result := true;
      end
      else begin
        CallControl.SetPlayMode(2);
        PlaySound(PChar(GlobalDM.AppPath + 'Sounds\�а�ʧ��.wav'), 0, SND_FILENAME or SND_SYNC);
      end;
{$ENDREGION '���Žа�����'}

{$REGION 'ֹͣ¼��������¼������'}
      recordThread.Terminate;
      recordThread.WaitFor;
      ms := recordThread.RecordStream;
      recordData.strPlanGUID := planGUID;
      recordData.strRoomNumber := roomNuber;
      recordData.strTrainNo := trainNo;
      recordData.dtCreateTime := Now ;
      recordData.bIsRecall := 0;
      if reCall then
        recordData.bIsRecall := 1;
      recordData.bCallSucceed := 0;
      if callSucceed then
        recordData.bCallSucceed := 1;
      recordData.strDutyGUID := '1';
      recordData.CallRecord := ms;
      recordData.strAreaGUID := '';
      TCallRecordOpt.AddRecord(ADOConn,recordData);
{$ENDREGION 'ֹͣ¼��������¼������'}
    finally
      recordThread.Free;
    end;
  finally
    HangCall();
    Comming := False;
    OpenMic;
  end;
end;

function TDMCallRoom.AutoConnectCall(roomNuber, trainNo: string;
  nDeveiveID: Integer; var bCancel: boolean; playMusic: boolean): boolean;
//���ܣ��Զ��а�
var
  i, devID, maxCallCount: Integer;
  callSucceed: boolean;
begin

  CloseMic;
  try
    Result := false;
    devID := nDeveiveID;
    maxCallCount := 0;
    callSucceed := false;

    //�� �ȹҶ�һ��
    HangCall;

    repeat
      Sleep(500);
      Application.ProcessMessages;
      if bCancel then
        exit;
      if CallRoom(devID) > 0 then
      begin
        Inc(maxCallCount);
      end
      else begin
        maxCallCount := 1000;
        callSucceed := true;
        Result := true;
      end;
    until (maxCallCount >= 10);

    if callSucceed then
    begin
      if playMusic then
      begin
        PlayFirstCall(roomNuber, trainNo);
        //�ȴ�˾���ش�6��ȴ�
        for i := 1 to 30 do
        begin
          if bCancel then exit;
          Application.ProcessMessages;
          Sleep(200);
        end;
      end;
    end
    else begin
      CallControl.SetPlayMode(2);
      PlaySound(PChar(GlobalDM.AppPath + 'Sounds\�а�ʧ��.wav'), 0, SND_FILENAME or SND_SYNC);
    end;
  finally
    OpenMic;
  end;
end;

function TDMCallRoom.CallRoom(nDeviceID: Integer): integer;
var
  i, deviceID: Integer;
  callCommand, sound: string;

begin
  Result := 2;
//  Comming := true;
  TLog.SaveLog(now, '��ʼ�����豸��' + IntToStr(nDeviceID));
{$REGION '�򿪴���'}
  try
    if not SerialConnected then
    begin
      OutputDebugString('--------------------------------------�򿪴���');
      if m_CallControl.OpenPort(m_nPort) = 1 then
      begin
        SerialConnected := true;
        OutputDebugString('--------------------------------------�򿪴��ڳɹ�');
      end
      else begin
        Result := 1;
        SerialConnected := false;
        OutputDebugString('--------------------------------------�򿪴���ʧ��');
      end;
    end;
  except
    Result := 1;
    SerialConnected := false;
  end;
{$ENDREGION '�򿪴���'}
  //�򿪴���ʧ�ܣ��˳�
  if Result = 1 then
  begin
    TLog.SaveLog(now, '�򿪴���ʧ�ܣ�ֹͣ�����豸��' + IntToStr(nDeviceID));
//    Comming := false;
    exit;
  end;

  OutputDebugString('--------------------------------------��ʼ�����豸');
  //�����;�˳����������ʧ��
  if m_CallControl.CallRoom(nDeviceID) <> 1 then
  begin
    OutputDebugString('--------------------------------------�����豸ʧ��');
//    Comming := false;
    TLog.SaveLog(now, '�����豸��' + IntToStr(nDeviceID) + ' ʧ�ܣ�');
    exit;
  end;
  TLog.SaveLog(now, '�����豸��' + IntToStr(nDeviceID) + ' �ɹ���');
  OutputDebugString('--------------------------------------�����豸�ɹ�');
  deviceID := nDeviceID;
  Application.ProcessMessages;
{$REGION '���ڷ�ʽͨѶ'}
  if CommTypeID = 1 then
  begin
    Sleep(7000);
    Application.ProcessMessages;
    OutputDebugString('--------------------------------------��ʼ��ѯ���ؽ��');
    for i := 0 to 5 do
    begin
      Sleep(1000);
      if m_CallControl.QueryDeviceState(deviceID) then
      begin
        OutputDebugString('--------------------------------------��ѯ���ؽ���ɹ�');
        Result := 0;
        break;
      end else begin
        TLog.SaveLog(now, '333�а����');
//        Comming := false;
        OutputDebugString('--------------------------------------��ѯ���ؼ�����ʧ��');
      end;
    end;
    exit;
  end;
{$ENDREGION '���ڷ�ʽͨѶ'}

{$REGION '���ַ�ʽͨѶ'}
  if OldVersion then
  begin
    callCommand := GetOldCallCommand(nDeviceID);
  end else begin
    callCommand := GetNewCallCommand(nDeviceID);
  end;

  TLog.SaveLog(Now,callCommand);

  MinWaveOut;
  try
    OutputDebugString('--------------------------------------���÷���ģʽ');
    CallControl.SetPlayMode(1);
    for i := 1 to Length(callCommand) do
    begin
      sound := GlobalDM.AppPath + 'Sounds\' + Format('%s.wav', [ConvertSoundChar(callCommand[i])]);
      PlaySound(PChar(Sound), 0, SND_FILENAME or SND_SYNC);
      Application.ProcessMessages;
      Sleep(DialDelay);
    end;
    Application.ProcessMessages;

    OutputDebugString('--------------------------------------��ʼ��ѯ���ؽ��');
    for i := 0 to 5 do
    begin
      Sleep(1000);
      if m_CallControl.QueryDeviceState(deviceID) then
      begin
        OutputDebugString('--------------------------------------��ѯ���ؽ���ɹ�');
        Result := 0;
        break;
      end else begin
        OutputDebugString('--------------------------------------��ѯ���ؼ�����ʧ��');
      end;
    end;
  finally
    if Result > 0 then
    begin
      HangCall;
    end;
    //MaxWaveOut(nDeviceID);
  end;
{$ENDREGION '���ַ�ʽͨѶ'}
end;

procedure TDMCallRoom.CloseMic;
begin
  exit;
  SetVolumeMute(Depth, true);
end;



procedure TDMCallRoom.DataModuleCreate(Sender: TObject);
begin
  Comming := false;
  LoadConfig;
  m_CallControl := TCallControl.Create;
  try
    if m_CallControl.OpenPort(m_nPort) = 1 then
    begin
      SerialConnected := true;
    end
    else begin
      SerialConnected := false;
    end;
  except
    SerialConnected := false;
  end;

  m_CallControl.SelectType(m_nCommTypeID);

  //�а�ģʽ ���ƣ�
  if not m_bCallModel then
  begin
    UDPControl := TUDPControl.Create;
    UDPControl.OpenPort();
  end;

  FTPCon := TFTPConnect.Create;
  FTPCon.SetFTPConfig();
  bUDPConnect := True;
  bFTPConnect := True;
  bCanUDPLogs := True;
  bCanFTPLogs := True;
end;

procedure TDMCallRoom.DataModuleDestroy(Sender: TObject);
begin
  WaitingForConfirm := false;

  //HangCall;
  Comming := False;
  m_CallControl.Free;
  UDPControl.Free;

end;





function TDMCallRoom.GetMinRestLength: double;
begin

end;

function TDMCallRoom.GetNewCallCommand(nDeviceID: Integer): string;
var
  roomString: string;
  buffer: array[0..5] of byte;
  jyc: byte;
  strjyc: string;
begin
  roomString := IntToStr(nDeviceID);
  if Length(roomString) = 3 then
    roomString := '0' + roomString;
  if Length(roomString) = 2 then
    roomString := '00' + roomString;
  if Length(roomString) = 1 then
    roomString := '000' + roomString;
  buffer[0] := $F;
  buffer[1] := StrToInt(roomString[1]);
  buffer[2] := StrToInt(roomString[2]);
  buffer[3] := StrToInt(roomString[3]);
  buffer[4] := StrToInt(roomString[4]);
  jyc := buffer[0];
  jyc := jyc xor buffer[1];
  jyc := jyc xor buffer[2];
  jyc := jyc xor buffer[3];
  jyc := jyc xor buffer[4];
  strjyc := inttostr(Integer(jyc));
  strjyc := (strjyc[length(strjyc)]);
  Result := Format('*%s%s#', [roomString, strjyc]);
end;





function TDMCallRoom.GetOldCallCommand(nDeviceID: Integer): string;
var
  roomString: string;
begin
  roomString := IntToStr(nDeviceID);
  if Length(roomString) = 4 then
    roomString := '0' + roomString;
  if Length(roomString) = 3 then
    roomString := '00' + roomString;
  if Length(roomString) = 2 then
    roomString := '000' + roomString;
  if Length(roomString) = 1 then
    roomString := '0000' + roomString;
  Result := Format('***%s#', [roomString]);
end;

procedure TDMCallRoom.GetRoomSound(strRoomNo: string; out nSound,
  nNightSound: Integer);
var
  Qry: TADOQuery;
begin
  Qry := TADOQuery.Create(nil);
  try
    try
      with Qry do
      begin
        //Connection := ADOConn;
        Close;
        SQL.Text := 'select * from TAB_System_Room where strRoomNumber = %s';
        SQL.Text := Format(SQL.Text,[QuotedStr(strRoomNo)]);
        Open;
        if recordcount = 0 then Exit;
        nSound := FieldByName('nSound').AsInteger;
        nNightSound := FieldByName('nNightSound').AsInteger;
      end;
    except
      nSound := 0;
      nNightSound := 0;
    end;
  finally
    Qry.Free;
  end;
end;

function TDMCallRoom.HangCall: boolean;
var
  i: Integer;
  callCommand, sound: string;
begin
  Result := false;
  try
    if CommTypeID > 1 then
    begin
      MinWaveOut;
      try
        if OldVersion then
          callCommand := Format('***%s#', ['00000'])
        else
          callCommand := Format('***%s#', ['00005']);
        CallControl.SetPlayMode(1);
        for i := 1 to Length(callCommand) do
        begin
          sound := GlobalDM.AppPath + 'Sounds\' + Format('%s.wav', [ConvertSoundChar(callCommand[i])]);
          PlaySound(PChar(Sound), 0, SND_FILENAME or SND_SYNC);
          Application.ProcessMessages;
          Sleep(DialDelay);
        end;
      finally
        MaxWaveOut('');
      end;
    end;
    CallControl.SetPlayMode(0);
    if m_CallControl.Hangup(0) <> 1 then
    begin
      exit;
    end;
    if CommTypeID = 1 then
    begin
      Sleep(7000);
    end;
    Result := true;
  finally
    TLog.SaveLog(now, '444�а����');
//    Comming := false;
  end;
end;



procedure TDMCallRoom.LoadConfig;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'Config.ini');
  try
    //�а���Ϣ
    m_nPort := ini.ReadInteger('CallInfo', 'Port', 1);

    m_nCallWaiting := ini.ReadInteger('CallInfo', 'CallWaiting', 10);
    m_nRecallSpace := ini.ReadInteger('CallInfo', 'RecallSpace', 5 * 60);
    m_nMaxSound := ini.ReadInteger('CallInfo', 'MaxSound', 1023);
    m_nMinSound := ini.ReadInteger('CallInfo', 'MinSound', 1);
    m_nDialDelay := ini.ReadInteger('CallInfo', 'DialDelay', 100);
    m_nCommTypeID := ini.ReadInteger('CallInfo', 'CommTypeID', 1);
    m_nOutTimeDelay := ini.ReadInteger('CallInfo', 'OutTimeDelay', 30);
    m_nColorOutTime := ini.ReadInteger('CallInfo', 'ColorOutTime', clGray);
    m_nColorUnenter := ini.ReadInteger('CallInfo', 'ColorUnenter', $0091D09A);
    m_nColorWaitingCall := ini.ReadInteger('CallInfo', 'ColorWaitingCall', $003325E2);
    m_nColorCalling := ini.ReadInteger('CallInfo', 'ColorCalling', $008000FF);
    m_nColorOutDutyAlarm := ini.ReadInteger('CallInfo', 'ColorOutDutyAlarm', $000080FF);

    m_nMaxSoundNight := ini.ReadInteger('CallInfo', 'MaxSoundNight', 1023);
    m_dNightBegin := ini.ReadFloat('CallInfo', 'NightBegin', TimeOf(StrToDateTime('1900-01-01 22:00:00')));
    m_dNightEnd := ini.ReadFloat('CallInfo', 'NightEnd', TimeOf(StrToDateTime('1900-01-01 07:00:00')));
    m_bCheckAudioLine := ini.ReadBool('CallInfo', 'CheckAudioLine', false);
    m_bWaitforConfirm := ini.ReadBool('CallInfo', 'WaitforConfirm', false);

    OldVersion := ini.ReadBool('CallInfo', 'OldVerion', false);
    //OldVersion := True ;

    //��ȡ�а�ģʽ ���ƣ�
    bCallModel := ini.ReadInteger('CallModel','Model',0) = 0;
    bInstallAddress := ini.ReadInteger('InstallAddress','Address',0) = 0;
  finally
    ini.Free;
  end;
end;



procedure TDMCallRoom.MaxWaveOut(strRoomNo: string);
var
  v: Longint;
  dtNow, dtBegin, dtEnd: TDateTime;
  sound: Word;
  nSound,nNightSound: Integer;
begin
  if strRoomNo <> '' then
    GetRoomSound(strRoomNo,nSound,nNightSound)
  else
    nSound := 0;
  
  dtNow := Now ;

  dtBegin := DateOf(dtNow) + m_dNightBegin;
  dtEnd := DateOf(dtNow) + 1 + m_dNightEnd;
  if (nSound = 0) or (nNightSound = 0) then
    sound := m_nMaxSound
  else
    sound := word(nSound);
  if ((dtNow >= dtBegin) and (dtNow <= dtEnd)) then
  begin
    if (nSound = 0) or (nNightSound = 0) then
      sound := m_nMaxSoundNight
    else
      sound := word(nNightSound);
  end else begin
    dtBegin := DateOf(dtNow) - 1 + m_dNightBegin;
    dtEnd := DateOf(dtNow) + m_dNightEnd;
    if ((dtNow >= dtBegin) and (dtNow <= dtEnd)) then
    begin
      if (nSound = 0) or (nNightSound = 0) then
        sound := m_nMaxSoundNight
      else
        sound := word(nNightSound);
    end;
  end;

  v := (sound shl 8) or (sound shl 24);
  waveOutSetVolume(0, v);
end;

procedure TDMCallRoom.MinWaveOut;
var
  t, v: Longint;
begin
  t := m_nMinSound;
  v := (t shl 8) or (t shl 24);
  waveOutSetVolume(0, v);
end;



procedure TDMCallRoom.OpenMic;
begin
  exit;
  SetVolume(Depth, 65535);
  SetVolumeMute(Depth, false);
end;

procedure TDMCallRoom.PlayFirstCall(roomNumber, trainNo: string;
  strTime: string = '1899-12-30 00:00:00');
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
  //speech: TSpeech;
begin
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  soundString := TStringList.Create;
  try
    //������
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���������.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���������.wav');
    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���������Ա��ע��.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    //soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г����ڽа�.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г�.wav');
    if strTime <> '1899-12-30 00:00:00' then
    begin
      SetPlaySoundTime(soundString,StrToDateTime(strtime));
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav')
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���ڽа�.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\ʦ����ش�.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    CallControl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;
    
  finally
    soundString.Free;
  end;
end;


procedure TDMCallRoom.PlaySecondCall(roomNumber, trainNo: string);
var
  soundString: TStrings;
  i: Integer;
  bHZroomnumber: Boolean; //�Ƿ�Ϊ���ַ����
  strHZroomnumber: string; //���ַ��䲥�ŵ������ļ�
begin
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���������.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���������.wav');

    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г����������Ա��ץ��ʱ�����.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\������Ա��ע��.wav');
    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '�㲥����.wav';
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\����.wav');

    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\���г��ѽа��븴��.wav');
    TLog.SaveLog(now, '���ò���ģʽ');
    CallControl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        TLog.SaveLog(now, '�����ַ�' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '�����ַ����' + soundString[i]);
      end;
    end;  

  finally
    soundString.Free;
  end;
end;



procedure TDMCallRoom.SaveConfig;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'Config.ini');
  try
    ini.WriteInteger('CallInfo', 'CallWaiting', m_nCallWaiting);
    ini.WriteInteger('CallInfo', 'RecallSpace', m_nRecallSpace);
    ini.WriteInteger('CallInfo', 'MinSound', m_nMinSound);
    ini.WriteInteger('CallInfo', 'MaxSound', m_nMaxSound);
    ini.WriteInteger('CallInfo', 'Port', m_nPort);
    ini.WriteInteger('CallInfo', 'DialDelay', m_nDialDelay);
    ini.WriteInteger('CallInfo', 'CommTypeID', m_nCommTypeID);
    ini.WriteInteger('CallInfo', 'OutTimeDelay', m_nOutTimeDelay);
    ini.WriteInteger('CallInfo', 'ColorOutTime', m_nColorOutTime);
    ini.WriteInteger('CallInfo', 'ColorUnenter', m_nColorUnenter);
    ini.WriteInteger('CallInfo', 'ColorWaitingCall', m_nColorWaitingCall);
    ini.WriteInteger('CallInfo', 'ColorCalling', m_nColorCalling);
    ini.WriteInteger('CallInfo', 'ColorOutDutyAlarm', m_nColorOutDutyAlarm);
    ini.WriteInteger('CallInfo', 'MaxSoundNight', m_nMaxSoundNight);
    ini.WriteFloat('CallInfo', 'NightBegin', m_dNightBegin);
    ini.WriteFloat('CallInfo', 'NightEnd', m_dNightEnd);
    ini.WriteBool('CallInfo', 'CheckAudioLine', m_bCheckAudioLine);
    ini.WriteBool('CallInfo', 'WaitforConfirm', m_bWaitforConfirm);
  finally
    ini.Free;
  end;
end;


procedure TDMCallRoom.SetAutoLogin(const Value: boolean);
begin
  if Value <> m_bAutoLogin then
  begin
    m_bAutoLogin := Value;
    SaveConfig;
  end;
end;


procedure TDMCallRoom.SetCallWaiting(const Value: Cardinal);
begin
  if Value <> m_nCallWaiting then
  begin
    m_nCallWaiting := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetColorCalling(const Value: integer);
begin
  if Value <> m_nColorCalling then
  begin
    m_nColorCalling := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetColorOutTime(const Value: integer);
begin
  if Value <> m_nColorOutTime then
  begin
    m_nColorOutTime := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetColorUnenter(const Value: integer);
begin
  if Value <> m_nColorUnenter then
  begin
    m_nColorUnenter := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetColorWaitingCall(const Value: integer);
begin
  if Value <> m_nColorWaitingCall then
  begin
    m_nColorWaitingCall := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetComming(const Value: boolean);
begin
  m_bComming := Value;
  if m_bComming = false then
    HangupTime := GlobalDM.GetNow;
end;

procedure TDMCallRoom.SetCommTypeID(const Value: word);
begin
  if m_nCommTypeID <> Value then
  begin
    m_nCommTypeID := Value;
    m_CallControl.SelectType(Value);
    SaveConfig;
  end;
end;



procedure TDMCallRoom.SetDialDelay(const Value: Word);
begin
  if m_nDialDelay <> Value then
  begin
    m_nDialDelay := Value;
    SaveConfig;
  end;

end;



procedure TDMCallRoom.SetMaxSound(const Value: Word);
begin
  if m_nMaxSound <> Value then
  begin
    m_nMaxSound := Value;
    SaveConfig;
  end;
end;


procedure TDMCallRoom.SetMinRestLength(const Value: Double);
begin
  ;
end;

procedure TDMCallRoom.SetMinSound(const Value: Word);
begin
  if m_nMinSound <> Value then
  begin
    m_nMinSound := Value;
    SaveConfig;
  end;
end;



procedure TDMCallRoom.SetColorOutDutyAlarm(const Value: integer);
begin
  if Value <> m_nColorOutDutyAlarm then
  begin
    m_nColorOutDutyAlarm := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetOutTimeDelay(const Value: word);
begin
  if m_nOutTimeDelay <> Value then
  begin
    m_nOutTimeDelay := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetPlaySoundTime(soundString: TStrings; dtTime: TDateTime);
var
  nHour,nMinute,nDiv,nMod: Integer;
begin
  nHour := StrToInt(FormatDateTime('h',dtTime));
  nDiv := nHour div 10;
  nMod := nHour mod 10;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'ʮ.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'һ.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end
  else
    if nDiv = 0 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '0.wav');
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '��.wav');

  nMinute := StrToInt(FormatDateTime('n',dtTime));
  nDiv := nMinute div 10;
  nMod := nMinute mod 10;
  if (nDiv = 0) and (nMod = 0) then Exit;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'ʮ.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + 'һ.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end;
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '��.wav');
end;

procedure TDMCallRoom.SetPort(const Value: Integer);
begin
  if m_nPort <> Value then
  begin
    m_nPort := Value;
    if m_CallControl.OpenPort(m_nPort) = 1 then
    begin
      SerialConnected := true;
    end
    else begin
      SerialConnected := false;
    end;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetRecallSpace(const Value: Cardinal);
begin
  if Value <> m_nRecallSpace then
  begin
    m_nRecallSpace := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetRemeberLogin(const Value: boolean);
begin
  if m_bRemeberLogin <> Value then
  begin
    m_bRemeberLogin := Value;
    SaveConfig;
  end;
end;

procedure TDMCallRoom.SetRemeberPWD(const Value: string);
begin
  if m_strRemeberPWD <> Value then
  begin
    m_strRemeberPWD := Value;
    SaveConfig;
  end;
end;



procedure TDMCallRoom.SetReparting(const Value: boolean);
begin

end;

procedure TDMCallRoom.SetSerialConnected(const Value: boolean);
var
  intBool: integer;
begin
  if m_bSerialConnected <> Value then
  begin
    m_bSerialConnected := value;
    intBool := 0;
    if m_bSerialConnected then
      intBool := 1;
  end;
end;

procedure TDMCallRoom.StartRecord;
begin
  //CreateThread(
end;


{ TRecordThread }

destructor TRecordThread.Destroy;
begin
  if RecordStream <> nil then
    FreeAndNil(RecordStream);
  if mixerRecord <> nil then
    FreeAndNil(mixerRecord);
  inherited;
end;

procedure TRecordThread.Execute;
begin
  mixerRecord := TMixerRecord.Create;
  mixerRecord.Start;

  while not Terminated do
  begin
    Application.ProcessMessages;
  end;
  mixerRecord.Stop;
  RecordStream := mixerRecord.GetRecordStream;
end;

end.

