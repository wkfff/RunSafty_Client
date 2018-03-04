unit uCallRoomDM;

interface

uses
  SysUtils, Classes, DB, ADODB, Contnrs, Windows, Messages,
  MPlayer, Graphics,Forms,
  uMixerRecord, uCallRecord, uCallControl,
  uApparatusCommon,uUDPControl, uFTPTransportControl,uFtpConnect;
const
  //数据库连接通知消息
  WM_MSGDBCONNECT = WM_USER + 1;
  //串口连接通知消息
  WM_MSGSerialCONNECT = WM_USER + 2;
  //检修状态切换通知消息
  WM_MSGRepartChanged = WM_USER + 3;
  //指纹识别消息通知
  WM_MSGFingerCapture = WM_User + 11;
  //指纹录入按压通知消息
  WM_MSGFingerEnorll = WM_USER + 12;
  //接受到图片接收通知消息
  WM_MSGImageReceived = WM_USER + 13;
  WM_MSGFeatureInfo = WM_USER + 14;
  //开始录音通知消息
  WM_MSGRecordBegin = WM_User + 21;
  //录音结束通知消息
  WM_MSGRecordEnd = WM_User + 22;
  //开始叫班通知消息
  WM_MSGCallBegin = WM_User + 31;
  //叫班结束消息,wParam参数：0=成功,1=打开串口失败,2=通信连接失败
  WM_MSGCallEnd = WM_User + 34;
  //等待值班员手动挂断叫班通知消息
  WM_MSGWaitingForConfirm = WM_User + 40;
  //(闫)
  //UDP、FTP测试完成通知消息
  WM_MSGTestUDPEnd = WM_USER + 50;
  WM_MSGTestFTPEnd = WM_USER + 51;
type

  {*******数据库设置结构*****}
  RDBConfig = record
    IP: string;
    UserName: string;
    Password: string;
    DBName: string;
  end;
  //指纹仪事件
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
  ///全局数据对象
  //////////////////////////////////////////////////////////////
  TDMCallRoom = class(TDataModule)
    ADOConn: TADOConnection;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    //叫班模式 （闫）
    m_bCallModel: Boolean;// True:正常叫班模式，False:远程叫班模式
    m_bInstallAddress: Boolean;// True:公寓，False:派班室

    //呼叫完音乐等待保护时间，单位秒
    m_nCallWaiting: Cardinal;
    //追叫间隔时间，单位秒
    m_nRecallSpace: Cardinal;
    m_CallControl: TCallControl; //呼叫控制类
    //最小音量
    m_nMinSound: Word;
    //夜间最小音
    m_nMaxSoundNight: Word;
    //夜间范围开始时间
    m_dNightBegin: Double;
    //夜间范围结束时间
    m_dNightEnd: Double;
    //最大音
    m_nMaxSound: Word;
    //拨号延迟
    m_nDialDelay: Word;
    //通讯类型ID
    m_nCommTypeID: word;
    //端口号
    m_nPort: Integer;
    //过期保护时间
    m_nOutTimeDelay: word;
    //串口已是否已连接
    m_bSerialConnected: boolean;
    //是否记住密码
    m_bRemeberLogin: boolean;
    //记住的密码
    m_strRemeberPWD: string;
    //是否自动登录
    m_bAutoLogin: boolean;
    //是否检测音频线路
    m_bCheckAudioLine: boolean;
    m_nColorOutTime: integer;
    m_nColorUnenter: integer;
    m_nColorWaitingCall: integer;
    m_nColorCalling: integer;
    m_nColorOutDutyAlarm: integer;
    //等待首叫确认
    m_bWaitforConfirm: boolean;
    m_bComming: boolean;

        //加载配置
    procedure LoadConfig;
    //--------------------------属性事件---------------------------------
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
    //将音量调整到最小音量
    procedure MinWaveOut;
    //将系统音量调整到最大音量
    procedure MaxWaveOut(strRoomNo: string);
    {功能：获取设置的房间终端音量}
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
    //---------------------------其它--------------------------------------
    {功能：向叫班语音中添加时间（闫）}
    procedure SetPlaySoundTime(soundString: TStrings;dtTime: TDateTime);
  public
    { Public declarations }
    //指纹仪状态{0代表正常，1代表异常}

    //数据库配置结构
    DBConfig: RDBConfig;
    //当起登录值班员信息结构
    //DutyUser: RDutyUser;
    //模块类型，用于显示主窗口模块
    ModuleType: Integer;
    //当前程序所适用的区域
    LocalArea: string;
    //判断是否处于等待值班员手动确认首叫
    WaitingForConfirm: boolean;
    HangupTime: TDateTime;
    //是否旧版本
    OldVersion: boolean;
    //上一次记录的出勤车次
    LastDrinkTrainNo: string;

    //UDP通讯FTP通讯 (闫)
    UDPControl: TUDPControl;
    FTPCon: TFTPConnect;
    bUDPConnect: Boolean;
    bCanUDPLogs: Boolean;
    bFTPConnect: Boolean;
    bCanFTPLogs: Boolean;

    //保存系统配置信息
    procedure SaveConfig;
    //呼叫房间
    function CallRoom(nDeviceID: Integer): integer;
    //获取旧的协议的呼叫命令
    function GetOldCallCommand(nDeviceID: Integer): string;
    //获取新的协议的呼叫命令
    function GetNewCallCommand(nDeviceID: Integer): string;
    //挂断呼叫
    function HangCall(): boolean;
    //播放首次叫班音乐
    procedure PlayFirstCall(roomNumber, trainNo: string;strTime: string = '1899-12-30 00:00:00');
    //播放追叫音乐
    procedure PlaySecondCall(roomNumber, trainNo: string);
    //自动叫班
    function AutoCallRoom(planGUID, roomNuber, trainNo: string; nDeveiveID: Integer;
      recall: boolean; playMusic: boolean = true): Boolean;
    //自动连通叫班
    function AutoConnectCall(roomNuber, trainNo: string; nDeveiveID: Integer; var bCancel: boolean;
      playMusic: boolean = true): boolean;
    //关闭话筒
    procedure CloseMic;
    //打开话筒
    procedure OpenMic;
    //开始录音
    procedure StartRecord;
    //是否在叫班过程中
    property Comming: boolean read m_bComming write SetComming;
    //最小强休时长(小时)
    property MinRestLength: Double read GetMinRestLength write SetMinRestLength;
    //呼叫完音乐等待保护时间，单位秒
    property CallWaiting: Cardinal read m_nCallWaiting write SetCallWaiting;
    //追叫间隔时间，单位秒
    property RecallSpace: Cardinal read m_nRecallSpace write SetRecallSpace;
    //最小拨号音
    property MinSound: Word read m_nMinSound write SetMinSound;
    //最大通话音
    property MaxSound: Word read m_nMaxSound write SetMaxSound;
    //串口端口号
    property Port: Integer read m_nPort write SetPort;
    //拨号音间隔延迟
    property DialDelay: Word read m_nDialDelay write SetDialDelay;
    //通讯类型(语音、串口)
    property CommTypeID: word read m_nCommTypeID write SetCommTypeID;
    //过期保护时间
    property OutTimeDelay: word read m_nOutTimeDelay write SetOutTimeDelay;
    //串口是否已经连接
    property SerialConnected: boolean read m_bSerialConnected write SetSerialConnected;
    //叫班对象
    property CallControl: TCallControl read m_CallControl;
    //是否记住密码
    property RemeberLogin: boolean read m_bRemeberLogin write SetRemeberLogin;
    //记住的密码
    property RemeberPWD: string read m_strRemeberPWD write SetRemeberPWD;
    //是否自动登录
    property AutoLogin: boolean read m_bAutoLogin write SetAutoLogin;
    //夜间最小音
    property MaxSoundNight: Word read m_nMaxSoundNight write m_nMaxSoundNight;
    //夜间范围开始时间
    property NightBegin: Double read m_dNightBegin write m_dNightBegin;
    //夜间范围结束时间
    property NightEnd: Double read m_dNightEnd write m_dNightEnd;
    //等待首叫确认
    property WaitforConfirm: boolean read m_bWaitforConfirm write m_bWaitforConfirm;
    //是否检测音频线路
    property CheckAudioLine: boolean read m_bCheckAudioLine write m_bCheckAudioLine;
    property ColorOutTime: integer read m_nColorOutTime write SetColorOutTime;
    property ColorUnenter: integer read m_nColorUnenter write SetColorUnenter;
    property ColorWaitingCall: integer read m_nColorWaitingCall write SetColorWaitingCall;
    property ColorCalling: integer read m_nColorCalling write SetColorCalling;
    property ColorOutDutyAlarm: integer read m_nColorOutDutyAlarm write SetColorOutDutyAlarm;


    //叫班模式 （闫）
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
//功能：自动叫班
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
{$REGION '连接呼叫，如果失败则重复10此'}
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
{$ENDREGION '连接呼叫，如果失败则重复10此'}
    //创建录音线程，并启动录音
    recordThread := TRecordThread.Create(true);
    try
      recordThread.Resume;
{$REGION '播放叫班音乐'}
      if callSucceed then
      begin
        if not recall then
        begin
          PlayFirstCall(roomNuber, trainNo);
            //等待司机回答，6秒等待
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
        PlaySound(PChar(GlobalDM.AppPath + 'Sounds\叫班失败.wav'), 0, SND_FILENAME or SND_SYNC);
      end;
{$ENDREGION '播放叫班音乐'}

{$REGION '停止录音并保存录音数据'}
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
{$ENDREGION '停止录音并保存录音数据'}
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
//功能：自动叫班
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

    //闫 先挂断一下
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
        //等待司机回答，6秒等待
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
      PlaySound(PChar(GlobalDM.AppPath + 'Sounds\叫班失败.wav'), 0, SND_FILENAME or SND_SYNC);
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
  TLog.SaveLog(now, '开始呼叫设备：' + IntToStr(nDeviceID));
{$REGION '打开串口'}
  try
    if not SerialConnected then
    begin
      OutputDebugString('--------------------------------------打开串口');
      if m_CallControl.OpenPort(m_nPort) = 1 then
      begin
        SerialConnected := true;
        OutputDebugString('--------------------------------------打开串口成功');
      end
      else begin
        Result := 1;
        SerialConnected := false;
        OutputDebugString('--------------------------------------打开串口失败');
      end;
    end;
  except
    Result := 1;
    SerialConnected := false;
  end;
{$ENDREGION '打开串口'}
  //打开串口失败，退出
  if Result = 1 then
  begin
    TLog.SaveLog(now, '打开串口失败，停止呼叫设备：' + IntToStr(nDeviceID));
//    Comming := false;
    exit;
  end;

  OutputDebugString('--------------------------------------开始呼叫设备');
  //如果中途退出则代表连接失败
  if m_CallControl.CallRoom(nDeviceID) <> 1 then
  begin
    OutputDebugString('--------------------------------------呼叫设备失败');
//    Comming := false;
    TLog.SaveLog(now, '呼叫设备：' + IntToStr(nDeviceID) + ' 失败！');
    exit;
  end;
  TLog.SaveLog(now, '呼叫设备：' + IntToStr(nDeviceID) + ' 成功！');
  OutputDebugString('--------------------------------------呼叫设备成功');
  deviceID := nDeviceID;
  Application.ProcessMessages;
{$REGION '串口方式通讯'}
  if CommTypeID = 1 then
  begin
    Sleep(7000);
    Application.ProcessMessages;
    OutputDebugString('--------------------------------------开始查询返回结果');
    for i := 0 to 5 do
    begin
      Sleep(1000);
      if m_CallControl.QueryDeviceState(deviceID) then
      begin
        OutputDebugString('--------------------------------------查询返回结果成功');
        Result := 0;
        break;
      end else begin
        TLog.SaveLog(now, '333叫班结束');
//        Comming := false;
        OutputDebugString('--------------------------------------查询返回及诶过失败');
      end;
    end;
    exit;
  end;
{$ENDREGION '串口方式通讯'}

{$REGION '音乐方式通讯'}
  if OldVersion then
  begin
    callCommand := GetOldCallCommand(nDeviceID);
  end else begin
    callCommand := GetNewCallCommand(nDeviceID);
  end;

  TLog.SaveLog(Now,callCommand);

  MinWaveOut;
  try
    OutputDebugString('--------------------------------------设置放音模式');
    CallControl.SetPlayMode(1);
    for i := 1 to Length(callCommand) do
    begin
      sound := GlobalDM.AppPath + 'Sounds\' + Format('%s.wav', [ConvertSoundChar(callCommand[i])]);
      PlaySound(PChar(Sound), 0, SND_FILENAME or SND_SYNC);
      Application.ProcessMessages;
      Sleep(DialDelay);
    end;
    Application.ProcessMessages;

    OutputDebugString('--------------------------------------开始查询返回结果');
    for i := 0 to 5 do
    begin
      Sleep(1000);
      if m_CallControl.QueryDeviceState(deviceID) then
      begin
        OutputDebugString('--------------------------------------查询返回结果成功');
        Result := 0;
        break;
      end else begin
        OutputDebugString('--------------------------------------查询返回及诶过失败');
      end;
    end;
  finally
    if Result > 0 then
    begin
      HangCall;
    end;
    //MaxWaveOut(nDeviceID);
  end;
{$ENDREGION '音乐方式通讯'}
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

  //叫班模式 （闫）
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
    TLog.SaveLog(now, '444叫班结束');
//    Comming := false;
  end;
end;



procedure TDMCallRoom.LoadConfig;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'Config.ini');
  try
    //叫班信息
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

    //读取叫班模式 （闫）
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
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
  //speech: TSpeech;
begin
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  soundString := TStringList.Create;
  try
    //背景音
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\北京机务段.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\北京机务段.wav');
    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\包乘组乘务员请注意.wav');
    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    //soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车现在叫班.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车.wav');
    if strTime <> '1899-12-30 00:00:00' then
    begin
      SetPlaySoundTime(soundString,StrToDateTime(strtime));
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\出勤.wav')
    end;

    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\现在叫班.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\师傅请回答.wav');
    TLog.SaveLog(now, '设置播放模式');
    CallControl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
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
  bHZroomnumber: Boolean; //是否为汉字房间号
  strHZroomnumber: string; //汉字房间播放的语音文件
begin
  bHZroomnumber := False;
  MaxWaveOut(roomNumber);
  soundString := TStringList.Create;
  try
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\Gmrhy14a.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\北京机务段.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\北京机务段.wav');

    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车包乘组乘务员请抓紧时间出乘.wav');
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\服务人员请注意.wav');
    try
      StrToInt(roomNumber);
      for i := 1 to Length(roomNumber) do
      begin
        soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + roomNumber[i] + '.wav');
      end;
    except
      bHZroomnumber := True;
      strHZroomnumber := ExtractFilePath(Application.ExeName) + 'CallMusic\' + '广播找人.wav';
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\房间.wav');

    for i := 1 to Length(trainNo) do
    begin
      soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + trainNo[i] + '.wav')
    end;
    soundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\次列车已叫班请复查.wav');
    TLog.SaveLog(now, '设置播放模式');
    CallControl.SetPlayMode(1);
    if bHZroomnumber then
    begin
      PlaySound(PChar(strHZroomnumber), 0, SND_FILENAME or SND_SYNC);
    end
    else
    begin
      for i := 0 to soundString.Count - 1 do
      begin
        TLog.SaveLog(now, '播放字符' + soundString[i]);
        PlaySound(PChar(soundString[i]), 0, SND_FILENAME or SND_SYNC);
        TLog.SaveLog(now, '播放字符完成' + soundString[i]);
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
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '十.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '一.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end
  else
    if nDiv = 0 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '0.wav');
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '点.wav');

  nMinute := StrToInt(FormatDateTime('n',dtTime));
  nDiv := nMinute div 10;
  nMod := nMinute mod 10;
  if (nDiv = 0) and (nMod = 0) then Exit;
  if nDiv > 0 then
  begin
    if nDiv > 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nDiv) + '.wav');
    SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '十.wav');
  end;
  if nMod > 0 then
  begin
    if nMod = 1 then
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '一.wav')
    else
      SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + IntToStr(nMod) + '.wav');
  end;
  SoundString.Add(ExtractFilePath(Application.ExeName) + 'CallMusic\' + '分.wav');
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

