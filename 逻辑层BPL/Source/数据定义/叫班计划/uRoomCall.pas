unit uRoomCall;

interface
uses
  Classes,SysUtils,DateUtils,uTFSystem,
  Graphics,uSaftyEnum,superobject,uPubFun,Contnrs;
type

  {��ѯ����}
  RCallQryParams = record
  public
    //����
    strTrainNo:string;
    //����
    strRoomNum:string;
    //�а࿪ʼʱ��
    dtStartCallTime:TDateTime;
    //�а����ʱ��
    dtEndCallTime:TDateTime;
  end;

  //////////////////////////////////////////////////////////////////////////////
  //����:TCallManPlan
  //����:��Ա�а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TCallManPlan = class
    //��Ա�а�ƻ�GUID
    strGUID:string;
    //���ƻ�guid
    strWaitPlanGUID:string;
    //�а�֪ͨGUID
    strCallNotifyGUID:string;
    //��Աguid
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //�г��ƻ�guid
    strTrainPlanGUID:string;
    //�г�����
    strTrainNo:string;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //��ס����
    strRoomNum:string;
    //�׽�ʱ��
    dtFirstCallTime:TDateTime;
    //�߽�ʱ��
    dtReCallTime:TDateTime;
    //�ƻ�״̬
    ePlanState:TRoomCallState;
    //�а�����
    strCallContent:string;

  end;

  //��Ա�а�ƻ�����
  TCallManPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManPlan;
    procedure SetItem(Index: Integer; AObject: TCallManPlan);
  public
    function Add(AObject: TCallManPlan): Integer;
    property Items[Index: Integer]: TCallManPlan read GetItem write SetItem; default;
    {����:������Աguid����}
    function Find(strTrainmanGUID:string):TCallManPlan;

  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TCallRoomPlan
  /// ����:����а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //��Ա�а�ƻ�����
    manList:TCallManPlanList;
    //����id
    nID:Integer;
    //����
    strRoomNum:string;
    //���ƻ�
    strWaitPlanGUID:string;
    //�г��ƻ�
    strTrainPlanGUID:string;
    //����
    strTrainNo:string;
    //����ʱ��
    dtCreateTime:TDateTime;
    //�豸���
    nDeviceID:Integer;
    //�а�ʱ��
    dtStartCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //�׽�ʱ��
    dtFirstCallTime:TDateTime;
    //�߽�ʱ��
    dtReCallTime:TDateTime;
    //�ƻ�״̬
    ePlanState:TRoomCallState;
  public
    {����:������Ա�а�ƻ���ʼ��}
    procedure Init(manPlan:TCallManPlan);
    {����:�ж��Ƿ�ʼ�׽�}
    function bNeedFirstCall(dtNow:TDateTime):Boolean;
    {����:�ж��Ƿ�ʼ�߽�}
    function bNeedReCall(dtNow:TDateTime):Boolean;
    {����:ת��Ϊjson����}
    function ToJsonStr():string;
    {����:����json����}
    procedure FromJson(strJson:string);
  end;

  //����а�ƻ�����
  TCallRoomPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallRoomPlan;
    procedure SetItem(Index: Integer; AObject: TCallRoomPlan);
  public
    function Add(AObject: TCallRoomPlan): Integer;
    property Items[Index: Integer]: TCallRoomPlan read GetItem write SetItem; default;
    {����:���շ��䳵�β���}
    function FindByRoomTrainNo(strRoomNum,strTrainNo:string):TCallRoomPlan;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallManRecord
  ///����:��Ա�а��¼
  //////////////////////////////////////////////////////////////////////////////
  TCallManRecord = class
  public
    //��¼GUID
    strGUID:string;
    //�а�ƻ�GUID
    strCallManPlanGUID:string;
    //��Աguid
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //��¼����ʱ��
    dtCreateTime:TDateTime;
    //����
    strTrainNo:string;
    //����
    strRoomNum:string;
    //�豸ID
    nDeviceID:Integer;
    //�а���
    eCallResult:TRoomCallResult;
    //���Դ���
    nConTryTimes:Integer;
    //�ƻ�����ʱ��
    dtChuQinTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //�а�����
    eCallState :TRoomCallState;
    //�а෽ʽ
    eCallType:TRoomCallType;
    //ֵ��Ա
    strDutyUser:string;
    //������Ϣ
    strMsg:string;
    //�а෢������
    strVoiceTxt:string;
    //������¼GUID
    strCallVoiceGUID:string;

  public
    {����:����}
    procedure Clone(SCallManRecord:TCallManRecord);
    {����:���ݽа�ƻ����г�ʼ��}
    procedure Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
  end;

  {��Ա�а��¼����}
  TCallManRecordList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TCallManRecord;
    procedure SetItem(Index: Integer; AObject: TCallManRecord);
  public
    function Add(AObject: TCallManRecord): Integer;
    property Items[Index: Integer]: TCallManRecord read GetItem write SetItem; default;
        {����:����}
    procedure Clone(CallManRecordList :TCallManRecordList);
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallVoice
  ///����:����а�����
  //////////////////////////////////////////////////////////////////////////////
  TCallVoice = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //������¼GUID
    strCallVoiceGUID:string;
    //�����ļ�
    vms:TMemoryStream;
    //����ʱ��
    dtCreateTime:TDateTime;
  end;




  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:TCallRoomRecord
  ///����:����а��¼
  //////////////////////////////////////////////////////////////////////////////
  TCallRoomRecord = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //��Ա�а��¼�б�
    CallManRecordList :TCallManRecordList;
    //�а�����
    CallVoice:TCallVoice;
  private
    //����а�ƻ�
    m_strCallPlanGUID:string;
    //��Ԣ����
    m_strRoomNum:string;
    //�豸ID
    m_nDeviceID :Integer;
    //�а�ʱ��
    m_dtCallTime:TDateTime;
    //���Դ���
    m_nConTryTimes:Integer;
    //��Ϣ
    m_strMsg:string;
    //�а���
    m_eCallResult:TRoomCallResult;
    //�а�¼��
    m_strCallVoiceGUID:string;
    //����
    m_strTrainNo :string;
    //�а�����
    m_eCallState :TRoomCallState;
    //�а෽ʽ
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
    {����:��¡}
    procedure Clone(s_CallRoomRecord:TCallRoomRecord);
    {����:���ݷ���а�ƻ����г�ʼ��}
    procedure Init(RoomPlan:TCallRoomPlan;dtNow:TDateTime);
  public
    //�а�ƻ�
    property strCallPlanGUID :string read m_strCallPlanGUID write m_strCallPlanGUID;
    //�����
    property strRoomNum:string read m_strRoomNum write SetRoomNum;
    //�豸ID
    property nDeviceID:Integer read m_nDeviceID write SetDeviceID;
    //�а�ʱ��
    property dtCallTime:TDateTime read m_dtCallTime write SetCallTime;
    //���ӳ��Դ���
    property nConTryTimes:Integer read m_nConTryTimes write SetConTryTimes;
    //��Ϣ
    property strMsg:string read m_strMsg write SetStrMsg;
    //�а���
    property eCallResult:TRoomCallResult read m_eCallResult write SetCallResult;
    //����
    property strTrainNo :string read m_strTrainNo write SetTrainNo;
    //�а�����
    property eCallState :TRoomCallState read m_eCallState write SetCallState;
    //�а෽ʽ
    property eCallType:TRoomCallType read m_eCallType write SetCallType;
    //¼��GUID
    property CallVoiceGUID : string read m_strCallVoiceGUID write m_strCallVoiceGUID;
  end;
  
  {�а�����ص�����}
  TCallDevCallBackData= class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //����а�ƻ�
    callRoomRecord:TCallRoomRecord;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ṹ������:RCallDev
  ///����:�����豸������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RCallDev= record
  public
    //guid
    strGUID:string;
    //������
    strRoomNum:string;
    //�豸���
    nDevNum:Integer;
  public
    {����:�½���ʼ��}
    procedure New();
  end;
  {�����豸������Ϣ����}
  TCallDevAry = array of RCallDev;


implementation

{ RRoomCall }
function TCallRoomPlan.bNeedReCall(dtNow:TDateTime):Boolean;
begin
  result := False;
  //δ�׽�,�˳�
  if Self.dtFirstCallTime <1 then Exit;

  //���10����
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
  //���׽�
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
    //�����
  iJson.S['strRoomNum'] := strRoomNum;
    //����id
  iJson.I['nID'] := nID;
    //�豸���
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
    //¼��GUID
    Self.m_strCallVoiceGUID := s_CallRoomRecord.m_strCallVoiceGUID ;
    //����
    Self.strTrainNo := s_CallRoomRecord.strTrainNo ;
      //����
    Self.strRoomNum:=s_CallRoomRecord.strRoomNum;
    //�а��豸ID
    self.nDeviceID:=s_CallRoomRecord.nDeviceID;
    //�а�ʱ��
    self.dtCallTime:=s_CallRoomRecord.dtCallTime;
    //��Ա�а��¼�б�
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
   //��¼GUID
    strGUID:=SCallManRecord.strGUID;
    //�а�ƻ�GUID
    strCallManPlanGUID:=SCallManRecord.strCallManPlanGUID;
    strTrainmanGUID:=SCallManRecord.strTrainmanGUID;
    //��Ա����
    strTrainmanNumber:=SCallManRecord.strTrainmanNumber;
    //��Ա����
    strTrainmanName:=SCallManRecord.strTrainmanName;
    //��¼����ʱ��
    dtCreateTime:=SCallManRecord.dtCreateTime;
    //����
    strTrainNo:=SCallManRecord.strTrainNo;
    //����
    strRoomNum:=SCallManRecord.strRoomNum;
    //�豸ID
    nDeviceID:=SCallManRecord.nDeviceID;
    //�а���
    eCallResult:=SCallManRecord.eCallResult;
    //���Դ���
    nConTryTimes:=SCallManRecord.nConTryTimes;
    //�ƻ�����ʱ��
    dtChuQinTime:=SCallManRecord.dtChuQinTime;
    //�а�ʱ��
    dtCallTime:=SCallManRecord.dtCallTime;
    //�а�����
    eCallState :=SCallManRecord.eCallState;
    //�а෽ʽ
    eCallType:=SCallManRecord.eCallType;
    //ֵ��Ա
    strDutyUser:=SCallManRecord.strDutyUser;
    //������Ϣ
    strMsg:=SCallManRecord.strMsg;
    //�а෢������
    strVoiceTxt:=SCallManRecord.strVoiceTxt;
end;

procedure TCallManRecord.Init(RoomPlan:TCallRoomPlan; ManPlan:TCallManPlan;dtNow:TDateTime);
begin
  //��¼GUID
    strGUID:= NewGUID;;
    //�а�ƻ�GUID
    strCallManPlanGUID:= ManPlan.strGUID;
    //��Աguid
    strTrainmanGUID:=ManPlan.strTrainmanGUID;
    //��Ա����
    strTrainmanNumber:= ManPlan.strTrainmanNumber;
    //��Ա����
    strTrainmanName:= ManPlan.strTrainmanName;
    //��¼����ʱ��
    dtCreateTime:= dtNow;
    //����
    strTrainNo:= ManPlan.strTrainNo;
    //����
    strRoomNum:= ManPlan.strRoomNum;
    //�豸ID
    nDeviceID:=RoomPlan.nDeviceID;
    //�ƻ�����ʱ��
    dtChuQinTime:= ManPlan.dtChuQinTime;
    //�а�ʱ��
    dtCallTime:= ManPlan.dtCallTime;
    //�а�����
    strVoiceTxt:= ManPlan.strCallContent;

    if ManPlan.ePlanState >= TCS_FIRSTCALL then
      eCallState := TCS_RECALL;
    if ManPlan.ePlanState = TCS_Publish then
      eCallState := TCS_FIRSTCALL;
end;

end.
