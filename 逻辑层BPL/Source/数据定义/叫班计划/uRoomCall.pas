unit uRoomCall;

interface
uses
  Classes,SysUtils,DateUtils,uTFSystem,
  Graphics,uSaftyEnum,superobject,uPubFun,Contnrs;
type

  {查询条件}
  RCallQryParams = record
  public
    //车次
    strTrainNo:string;
    //房间
    strRoomNum:string;
    //叫班开始时间
    dtStartCallTime:TDateTime;
    //叫班结束时间
    dtEndCallTime:TDateTime;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //类名:TCallManPlan
  //描述:人员叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TCallManPlan = class
    //人员叫班计划GUID
    strGUID:string;
    //候班计划guid
    strWaitPlanGUID:string;
    //叫班通知GUID
    strCallNotifyGUID:string;
    //人员guid
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员姓名
    strTrainmanName:string;
    //行车计划guid
    strTrainPlanGUID:string;
    //行车车次
    strTrainNo:string;
    //叫班时间
    dtCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //入住房间
    strRoomNum:string;
    //首叫时间
    dtFirstCallTime:TDateTime;
    //催叫时间
    dtReCallTime:TDateTime;
    //计划状态
    ePlanState:TRoomCallState;
    //叫班内容
    strCallContent:string;

  end;

  //人员叫班计划数组
  TCallManPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManPlan;
    procedure SetItem(Index: Integer; AObject: TCallManPlan);
  public
    function Add(AObject: TCallManPlan): Integer;
    property Items[Index: Integer]: TCallManPlan read GetItem write SetItem; default;
    {功能:按照人员guid查找}
    function Find(strTrainmanGUID:string):TCallManPlan;

  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TCallRoomPlan
  /// 描述:房间叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //人员叫班计划数组
    manList:TCallManPlanList;
    //索引id
    nID:Integer;
    //房间
    strRoomNum:string;
    //候班计划
    strWaitPlanGUID:string;
    //行车计划
    strTrainPlanGUID:string;
    //车次
    strTrainNo:string;
    //创建时间
    dtCreateTime:TDateTime;
    //设备编号
    nDeviceID:Integer;
    //叫班时间
    dtStartCallTime:TDateTime;
    //出勤时间
    dtChuQinTime:TDateTime;
    //首叫时间
    dtFirstCallTime:TDateTime;
    //催叫时间
    dtReCallTime:TDateTime;
    //计划状态
    ePlanState:TRoomCallState;
  public
    {功能:根据人员叫班计划初始化}
    procedure Init(manPlan:TCallManPlan);
    {功能:判断是否开始首叫}
    function bNeedFirstCall(dtNow:TDateTime):Boolean;
    {功能:判断是否开始催叫}
    function bNeedReCall(dtNow:TDateTime):Boolean;
    {功能:转换为json数据}
    function ToJsonStr():string;
    {功能:解析json数据}
    procedure FromJson(strJson:string);
  end;

  //房间叫班计划数组
  TCallRoomPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallRoomPlan;
    procedure SetItem(Index: Integer; AObject: TCallRoomPlan);
  public
    function Add(AObject: TCallRoomPlan): Integer;
    property Items[Index: Integer]: TCallRoomPlan read GetItem write SetItem; default;
    {功能:按照房间车次查找}
    function FindByRoomTrainNo(strRoomNum,strTrainNo:string):TCallRoomPlan;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallManRecord
  ///描述:人员叫班记录
  //////////////////////////////////////////////////////////////////////////////
  TCallManRecord = class
  public
    //记录GUID
    strGUID:string;
    //叫班计划GUID
    strCallManPlanGUID:string;
    //人员guid
    strTrainmanGUID:string;
    //人员工号
    strTrainmanNumber:string;
    //人员名称
    strTrainmanName:string;
    //记录创建时间
    dtCreateTime:TDateTime;
    //车次
    strTrainNo:string;
    //房间
    strRoomNum:string;
    //设备ID
    nDeviceID:Integer;
    //叫班结果
    eCallResult:TRoomCallResult;
    //尝试次数
    nConTryTimes:Integer;
    //计划出勤时间
    dtChuQinTime:TDateTime;
    //叫班时间
    dtCallTime:TDateTime;
    //叫班类型
    eCallState :TRoomCallState;
    //叫班方式
    eCallType:TRoomCallType;
    //值班员
    strDutyUser:string;
    //描述信息
    strMsg:string;
    //叫班发音内容
    strVoiceTxt:string;
    //语音记录GUID
    strCallVoiceGUID:string;

  public
    {功能:拷贝}
    procedure Clone(SCallManRecord:TCallManRecord);
    {功能:根据叫班计划进行初始化}
    procedure Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
  end;

  {人员叫班记录数组}
  TCallManRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManRecord;
    procedure SetItem(Index: Integer; AObject: TCallManRecord);
  public
    function Add(AObject: TCallManRecord): Integer;
    property Items[Index: Integer]: TCallManRecord read GetItem write SetItem; default;
        {功能:拷贝}
    procedure Clone(CallManRecordList :TCallManRecordList);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallVoice
  ///描述:房间叫班语音
  //////////////////////////////////////////////////////////////////////////////
  TCallVoice = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //语音记录GUID
    strCallVoiceGUID:string;
    //语音文件
    vms:TMemoryStream;
    //创建时间
    dtCreateTime:TDateTime;
  end;




  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:TCallRoomRecord
  ///描述:房间叫班记录
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomRecord = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //人员叫班记录列表
    CallManRecordList :TCallManRecordList;
    //叫班语音
    CallVoice:TCallVoice;
  private
    //房间叫班计划
    m_strCallPlanGUID:string;
    //公寓房间
    m_strRoomNum:string;
    //设备ID
    m_nDeviceID :Integer;
    //叫班时间
    m_dtCallTime:TDateTime;
    //尝试次数
    m_nConTryTimes:Integer;
    //消息
    m_strMsg:string;
    //叫班结果
    m_eCallResult:TRoomCallResult;
    //叫班录音
    m_strCallVoiceGUID:string;
    //车次
    m_strTrainNo :string;
    //叫班类型
    m_eCallState :TRoomCallState;
    //叫班方式
    m_eCallType:TRoomCallType;

  private
    procedure SetRoomNum(strRoomNum:string);
    procedure SetDeviceID(nDeviceID:Integer);
    procedure SetCallTime(dtCallTime:TDateTime);
    procedure SetConTryTimes(nConTryTimes:Integer);
    procedure SetStrMsg(strMsg:string);
    procedure SetCallResult(callResult:TRoomCallResult);
    procedure SetTrainNo(strTrainNo:string);
    procedure SetCallState(eCallState:TRoomCallState);
    procedure SetCallType(eCallType:TRoomCallType);
  public
    {功能:克隆}
    procedure Clone(s_CallRoomRecord:TCallRoomRecord);
    {功能:根据房间叫班计划进行初始化}
    procedure Init(RoomPlan:TCallRoomPlan;dtNow:TDateTime);
  public
    //叫班计划
    property strCallPlanGUID :string read m_strCallPlanGUID write m_strCallPlanGUID;
    //房间号
    property strRoomNum:string read m_strRoomNum write SetRoomNum;
    //设备ID
    property nDeviceID:Integer read m_nDeviceID write SetDeviceID;
    //叫班时间
    property dtCallTime:TDateTime read m_dtCallTime write SetCallTime;
    //连接尝试次数
    property nConTryTimes:Integer read m_nConTryTimes write SetConTryTimes;
    //消息
    property strMsg:string read m_strMsg write SetStrMsg;
    //叫班结果
    property eCallResult:TRoomCallResult read m_eCallResult write SetCallResult;
    //车次
    property strTrainNo :string read m_strTrainNo write SetTrainNo;
    //叫班类型
    property eCallState :TRoomCallState read m_eCallState write SetCallState;
    //叫班方式
    property eCallType:TRoomCallType read m_eCallType write SetCallType;
    //录音GUID
    property CallVoiceGUID : string read m_strCallVoiceGUID write m_strCallVoiceGUID;
  end;
  
  {叫班操作回调数据}
  TCallDevCallBackData= class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //房间叫班计划
    callRoomRecord:TCallRoomRecord;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///结构体名称:RCallDev
  ///描述:房间设备配置信息
  //////////////////////////////////////////////////////////////////////////////
  RCallDev= record
  public
    //guid
    strGUID:string;
    //房间编号
    strRoomNum:string;
    //设备编号
    nDevNum:Integer;
  public
    {功能:新建初始化}
    procedure New();
  end;
  {房间设备配置信息数组}
  TCallDevAry = array of RCallDev;


implementation

{ RRoomCall }
function TCallRoomPlan.bNeedReCall(dtNow:TDateTime):Boolean;
begin
  result := False;
  //未首叫,退出
  if Self.dtFirstCallTime <1 then Exit;

  //间隔10分钟
  if IncMinute( dtStartCallTime ,10) <= dtNow  then
  begin
    result := True;
  end;
end;
constructor TCallRoomPlan.Create;
begin
  manList:=TCallManPlanList.Create;
end;

destructor TCallRoomPlan.Destroy;
begin
  manList.Free;
  inherited;
end;

procedure TCallRoomPlan.FromJson(strJson: string);
begin

end;



procedure TCallRoomPlan.Init(manPlan: TCallManPlan);
begin
  Self.strTrainPlanGUID := manPlan.strTrainPlanGUID;
  self.strWaitPlanGUID := manPlan.strWaitPlanGUID;
  self.strRoomNum := manPlan.strRoomNum;
  self.strTrainNo := manPlan.strTrainNo;
  self.dtStartCallTime := manPlan.dtCallTime;
  self.dtChuQinTime := manPlan.dtChuQinTime;
  self.dtFirstCallTime:= manPlan.dtFirstCallTime;
  self.dtReCallTime:=manPlan.dtReCallTime;
  self.ePlanState := manPlan.ePlanState;
end;


function TCallRoomPlan.bNeedFirstCall(dtNow:TDateTime): Boolean;
begin
  result := False;
  //已首叫
  if Self.dtFirstCallTime > 1 then Exit;

  if dtStartCallTime <= dtNow  then
  begin
    result := True;
  end;

end;


function TCallRoomPlan.ToJsonStr: string;
var
  iJson:ISuperObject;
begin
  iJson := so();
    //房间号
  iJson.S['strRoomNum'] := strRoomNum;
    //索引id
  iJson.I['nID'] := nID;
    //设备编号
  iJson.I['nDeviceID'] := nDeviceID;
end;

{ RRoomDev }

procedure RCallDev.New;
begin
  strGUID := NewGUID();
end;



{ TCallDevCallBackData }

constructor TCallDevCallBackData.Create;
begin
  callRoomRecord:=TCallRoomRecord.Create;
end;

destructor TCallDevCallBackData.Destroy;
begin
  callRoomRecord.Free;
  inherited;
end;

{ TCallManPlanList }

function TCallManPlanList.Add(AObject: TCallManPlan): Integer;
begin
  result := inherited Add(AObject);
end;

procedure TCallManRecordList.Clone(CallManRecordList: TCallManRecordList);
var
  i:Integer;
  callManRecord:TCallManRecord;
begin
  for i := 0 to CallManRecordList.Count - 1 do
  begin
    callManRecord:=TCallManRecord.Create;
    callManRecord.Clone(CallManRecordList.Items[i]);
    self.Add(callManRecord) ;
  end;
end;

function TCallManPlanList.Find(strTrainmanGUID: string): TCallManPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TCallManPlanList.GetItem(Index: Integer): TCallManPlan;
begin
  Result := TCallManPlan(inherited GetItem(Index));
end;

procedure TCallManPlanList.SetItem(Index: Integer; AObject: TCallManPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallRoomPlanList }

function TCallRoomPlanList.Add(AObject: TCallRoomPlan): Integer;
begin
  Result := inherited Add(AObject);
end;

function TCallRoomPlanList.FindByRoomTrainNo(strRoomNum,strTrainNo:string): TCallRoomPlan;
var
  i:Integer;
begin
  result := nil;
  for I := 0 to Self.Count - 1 do
  begin
    if self.Items[i].strRoomNum = strRoomNum then
    begin
      if self.Items[i].strTrainNo = strTrainNo then
      begin
        result := self.Items[i];
        Exit;
      end;
    end;
  end;
    
end;

function TCallRoomPlanList.GetItem(Index: Integer): TCallRoomPlan;
begin
  result := TCallRoomPlan(inherited GetItem(Index));
end;

procedure TCallRoomPlanList.SetItem(Index: Integer; AObject: TCallRoomPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TCallVoice }

constructor TCallVoice.Create;
begin
  
  //vms:=TMemoryStream.Create;
end;

destructor TCallVoice.Destroy;
begin
  FreeAndNil(vms);
  inherited;
end;


{ TRoomCallRecord }

procedure TCallRoomRecord.Clone(s_CallRoomRecord: TCallRoomRecord);
begin
    //录音GUID
    Self.m_strCallVoiceGUID := s_CallRoomRecord.m_strCallVoiceGUID ;
    //车次
    Self.strTrainNo := s_CallRoomRecord.strTrainNo ;
      //房间
    Self.strRoomNum:=s_CallRoomRecord.strRoomNum;
    //叫班设备ID
    self.nDeviceID:=s_CallRoomRecord.nDeviceID;
    //叫班时间
    self.dtCallTime:=s_CallRoomRecord.dtCallTime;
    //人员叫班记录列表
    CallManRecordList.clone(s_CallRoomRecord.CallManRecordList);
end;

constructor TCallRoomRecord.Create;
begin
   CallManRecordList :=TCallManRecordList.Create;
end;

destructor TCallRoomRecord.Destroy;
begin
  CallManRecordList.Free;
  if CallVoice <> nil then
    CallVoice.Free;
  inherited;
end;


procedure TCallRoomRecord.Init(RoomPlan: TCallRoomPlan;dtNow:TDateTime);
var
  i:Integer;
  manRecord:TCallManRecord;
begin
  for i := 0 to RoomPlan.manList.Count - 1 do
  begin
    manRecord := TCallManRecord.Create;
    manRecord.Init(RoomPlan,RoomPlan.manList.Items[i],dtNow);
    Self.CallManRecordList.Add(manRecord)
  end;
  self.m_strRoomNum := RoomPlan.strRoomNum;
  self.m_strTrainNo := RoomPlan.strTrainNo;
  self.m_dtCallTime := dtNow;
end;

procedure TCallRoomRecord.SetCallResult(callResult: TRoomCallResult);
var
  i:Integer;
begin
  Self.m_eCallResult := callResult;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallResult := callResult;
  end;
end;

procedure TCallRoomRecord.SetCallTime(dtCallTime: TDateTime);
var
  i:Integer;
begin
  Self.m_dtCallTime := dtCallTime;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].dtCallTime := dtCallTime;
  end;
end;

procedure TCallRoomRecord.SetConTryTimes(nConTryTimes: Integer);
var
  i:Integer;
begin
  Self.m_nConTryTimes := nConTryTimes;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nConTryTimes := nConTryTimes;
  end;
end;

procedure TCallRoomRecord.SetDeviceID(nDeviceID: Integer);
var
  i:Integer;
begin
  Self.m_nDeviceID := nDeviceID;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].nDeviceID := nDeviceID;
  end;
end;

procedure TCallRoomRecord.SetRoomNum(strRoomNum: string);
var
  i:Integer;
begin
  Self.m_strRoomNum := strRoomNum;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strRoomNum := strRoomNum;
  end;
end;

procedure TCallRoomRecord.SetStrMsg(strMsg: string);
var
  i:Integer;
begin
  Self.m_strMsg := strMsg;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strMsg := strMsg;
  end;
end;

procedure TCallRoomRecord.SetTrainNo(strTrainNo: string);
var
  i:Integer;
begin
  self.m_strTrainNo := strTrainNo;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].strTrainNo := strTrainNo;
  end;
end;
procedure TCallRoomRecord.SetCallState(eCallState:TRoomCallState);
var
  i:Integer;
begin
  self.m_eCallState := eCallState;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallState := eCallState;
  end;
end;

procedure TCallRoomRecord.SetCallType(eCallType:TRoomCallType);
var
  i:Integer;
begin
  self.m_eCallType := eCallType;
  for i := 0 to self.CallManRecordList.Count - 1 do
  begin
    self.CallManRecordList.Items[i].eCallType := eCallType;
  end;
end;
{ TCallManRecordList }

function TCallManRecordList.Add(AObject: TCallManRecord): Integer;
begin
  result := inherited Add(AObject);
end;

function TCallManRecordList.GetItem(Index: Integer): TCallManRecord;
begin
  result := TCallManRecord(inherited GetItem(Index));
end;

procedure TCallManRecordList.SetItem(Index: Integer; AObject: TCallManRecord);
begin
  inherited SetItem(Index,AObject);
end;

procedure TCallManRecord.Clone(SCallManRecord: TCallManRecord);
begin
   //记录GUID
    strGUID:=SCallManRecord.strGUID;
    //叫班计划GUID
    strCallManPlanGUID:=SCallManRecord.strCallManPlanGUID;
    strTrainmanGUID:=SCallManRecord.strTrainmanGUID;
    //人员工号
    strTrainmanNumber:=SCallManRecord.strTrainmanNumber;
    //人员名称
    strTrainmanName:=SCallManRecord.strTrainmanName;
    //记录创建时间
    dtCreateTime:=SCallManRecord.dtCreateTime;
    //车次
    strTrainNo:=SCallManRecord.strTrainNo;
    //房间
    strRoomNum:=SCallManRecord.strRoomNum;
    //设备ID
    nDeviceID:=SCallManRecord.nDeviceID;
    //叫班结果
    eCallResult:=SCallManRecord.eCallResult;
    //尝试次数
    nConTryTimes:=SCallManRecord.nConTryTimes;
    //计划出勤时间
    dtChuQinTime:=SCallManRecord.dtChuQinTime;
    //叫班时间
    dtCallTime:=SCallManRecord.dtCallTime;
    //叫班类型
    eCallState :=SCallManRecord.eCallState;
    //叫班方式
    eCallType:=SCallManRecord.eCallType;
    //值班员
    strDutyUser:=SCallManRecord.strDutyUser;
    //描述信息
    strMsg:=SCallManRecord.strMsg;
    //叫班发音内容
    strVoiceTxt:=SCallManRecord.strVoiceTxt;
end;

procedure TCallManRecord.Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
begin
  //记录GUID
    strGUID:= NewGUID;;
    //叫班计划GUID
    strCallManPlanGUID:= ManPlan.strGUID;
    //人员guid
    strTrainmanGUID:=ManPlan.strTrainmanGUID;
    //人员工号
    strTrainmanNumber:= ManPlan.strTrainmanNumber;
    //人员名称
    strTrainmanName:= ManPlan.strTrainmanName;
    //记录创建时间
    dtCreateTime:= dtNow;
    //车次
    strTrainNo:= ManPlan.strTrainNo;
    //房间
    strRoomNum:= ManPlan.strRoomNum;
    //设备ID
    nDeviceID:=RoomPlan.nDeviceID;
    //计划出勤时间
    dtChuQinTime:= ManPlan.dtChuQinTime;
    //叫班时间
    dtCallTime:= ManPlan.dtCallTime;
    //叫班内容
    strVoiceTxt:= ManPlan.strCallContent;

    if ManPlan.ePlanState >= TCS_FIRSTCALL then
      eCallState := TCS_RECALL;
    if ManPlan.ePlanState = TCS_Publish then
      eCallState := TCS_FIRSTCALL;
end;

end.
