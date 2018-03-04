unit uDBRoomCall;

interface
uses
  Classes,uTFSystem,ADODB,SysUtils,uRoomCall,uSaftyEnum,DB;
type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBRoomDev
  /// ����:��Ԣ�а��豸����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallDev = class(TDBOperate)
  public
    {����:�����豸}
    procedure Add(dev:RCallDev);
    {����:�޸��豸}
    procedure Modify(dev:RCallDev);
    {����:ɾ���豸}
    procedure Delete(strGUID:string);
    {����:��ȡ�����豸}
    procedure GetAll(out devAry:TCallDevAry);
    {����:���ݷ����Ų���}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {����:�����豸��Ų���}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  private
    {����:����query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {����:query������}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBCallVoice
  /// ����:��Ԣ�а��������ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallVoice = class(TDBOperate)
  public
    {����:����}
    procedure Add(CallVoice:TCallVoice);
    {����:����������¼}
    function Find(strCallVoiceGUID:string;var CallVoice:TCallVoice ) :Boolean;
    {����:��ȡ¼���ļ�}
    function GetVoiceFile(strGUID,strFilePathName:string):Boolean;
  public
    {���ݼ�������}
    procedure Qry2Obj(qry:TADOQuery;var obj:TCallVoice);
    {�������ݼ�}
    procedure Obj2Qry(Obj:TCallVoice;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBCallRecord
  /// ����:��Ԣ�а��¼���ݿ����
  //////////////////////////////////////////////////////////////////////////////
  TDBCallRecord = class(TDBOperate)
  public

    {����:����}
    procedure Add(callRecord:TCallManRecord) ; overload;
    {����:���ӷ���а��¼}
    procedure Add(CallRoomRecord:TCallRoomRecord); overload;
    {���� :�޸ķ���а��¼}
    procedure Update(CallRoomRecord:TCallRoomRecord) ;
    {����:��ѯ�а��¼}
    procedure qryCallRecord(params:RCallQryParams;var CallManRecordList:TCallManRecordList);

  private
    {�����ѯ����}
    procedure SetSearchQry(qry:TADOQuery;params:RCallQryParams);
    {���ݼ� ��ֵ�� ����}
    procedure Query2Obj(qry:TADOQuery;var callRecord:TCallManRecord);
    {���� ��ֵ�� ���ݼ�}
  procedure Obj2Query(callRecord:TCallManRecord;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///����:TDBCallManPlan
  ///����:��Ա�а�ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TDBCallManPlan = class(TDBOperate)
  public
    {���� : ������Ա�ƻ�GUID��ȡ���мƻ�GUID}
    function FindWaitPlanByCallMan(strCallManGUID:string;var WaitPlanGUID:string):Boolean;
    {����:�����г��ƻ�����Ա����}
    function FindUnCall(strTrainPlanGUID,strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {����:���պ��ƻ�GUID����}
    function FindByWaitPlan(strWaitPlanGUID:string;strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {����:���Ӽ�¼}
    procedure Add(manPlan:TCallManPlan);overload;
    {����:���Ӷ����¼}
    procedure Add(manPlanList:TCallManPlanList);overload;

    {����:�޸ķ���а�ƻ�}
    function ModifyRoomPlan(RoomPlan:TCallRoomPlan):Boolean;
    {����:�޸ļ�¼}
    function ModifyManPlan(manPlan:TCallManPlan):Boolean;
    {����:ɾ����¼}
    procedure Del(manPlanGUID:string);
    {����:��ȡ������а�ƻ��б�}
    procedure GetRoomCallPlanList(var roomPlanList:TCallRoomPlanList;eStartState,eEndState:TRoomCallState);
    {����:��ȡ��Ա�ƻ�����״̬}
    procedure GetManPlanOfState(var manPlanList:TCallManPlanList;ePlanState:TRoomCallState);
    {����:�����׽�ʱ��}
    procedure UpdateFirstCallTime(strCallPlanGUID:string; dtTime:TDateTime);
    {����:���´߽�ʱ��}
    procedure UpdateReCallTime(strCallPlanGUID:string;dtTime:TDateTime);
    {����:����ת��Ϊ���ݼ�}
    class procedure Obj2Qry(obj:TCallManPlan;qry:TADOQuery);
    class procedure Qry2Obj(qry:TADOQuery;var obj :TCallManPlan);
  end;

implementation



procedure TDBCallRecord.Add(callRecord: TCallManRecord);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Record_CallMan where 1<>1';
    qry.Open;
    qry.Append;
    self.Obj2Query(callRecord,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;
procedure TDBCallRecord.Add(CallRoomRecord:TCallRoomRecord);
var
  i:Integer;
  dbCallPlan:TDBCallManPlan;
  callManRecord:TCallManRecord;
begin
  dbCallPlan := TDBCallManPlan.Create(self.GetADOConnection);
  Self.GetADOConnection.BeginTrans;
  try
    try
      for I := 0 to CallRoomRecord.CallManRecordList.Count - 1 do
      begin
        callManRecord :=  CallRoomRecord.CallManRecordList.Items[i];
        Add(callManRecord);
        if callManRecord.eCallState = TCS_FIRSTCALL then
          dbCallPlan.UpdateFirstCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
        if callManRecord.eCallState = TCS_RECALL then
          dbCallPlan.UpdateReCallTime(callManRecord.strCallManPlanGUID,callManRecord.dtCreateTime);
      end;
      Self.GetADOConnection.CommitTrans;
    except on e:Exception do
      begin
        GetADOConnection.RollbackTrans;
        RaiseLastWin32Error;
      end;
    end;
  finally
    dbCallPlan.Free;
  end;
end;

function TDBCallVoice.GetVoiceFile(strGUID, strFilePathName:string): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select msVoice from Tab_Record_CallVoice where strCallVoiceGUID=:strCallVoiceGUID';
    qry.Parameters.ParamByName('strCallVoiceGUID').Value := strGUID;
    qry.Open;
    if qry.RecordCount = 0  then Exit;
    if not qry.FieldByName('msVoice').IsNull then
    begin
      TBlobField(qry.FieldByName('msVoice')).SaveToFile(strFilePathName);
      result := True;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBCallRecord.Obj2Query(callRecord: TCallManRecord; qry: TADOQuery);
begin
  qry.FieldByName('strGUID').Value := callRecord.strGUID;
  qry.FieldByName('strPlanGUID').Value := callRecord.strCallManPlanGUID;
  qry.FieldByName('strTrainNo').Value := callRecord.strTrainNo;
  qry.FieldByName('strRoomNum').Value := callRecord.strRoomNum;
  qry.FieldByName('dtCallTime').Value := callRecord.dtCallTime;
  qry.FieldByName('eCallType').Value := callRecord.eCallType;
  qry.FieldByName('eCallState').Value := callRecord.eCallState;
  qry.FieldByName('strDutyUser').Value := callRecord.strDutyUser;
  qry.FieldByName('eCallResult').Value := callRecord.eCallResult;
  qry.FieldByName('strmsg').Value := callRecord.strMsg;
  //TBlobField(qry.FieldByName('msVoice')).LoadFromStream(callRecord msVoice);
  
  qry.FieldByName('dtCreateTime').Value := callRecord.dtCreateTime;
  qry.FieldByName('nDeviceID').Value := callRecord.nDeviceID;
  qry.FieldByName('nConTryTimes').Value := callRecord.nConTryTimes;
  qry.FieldByName('dtChuQinTime').Value := callRecord.dtChuQinTime;
  qry.FieldByName('strCallVoiceGUID').Value := callRecord.strCallVoiceGUID;
  qry.FieldByName('strTrainmanGUID').Value := callRecord.strTrainmanGUID;
  qry.FieldByName('strTrainmanNumber').Value := callRecord.strTrainmanNumber;
  qry.FieldByName('strTrainmanName').Value := callRecord.strTrainmanName;
  qry.FieldByName('strVoiceTxt').Value := callRecord.strVoiceTxt;
end;

procedure TDBCallRecord.qryCallRecord(params: RCallQryParams;
  var CallManRecordList:TCallManRecordList);
var
  qry:TADOQuery;
  i:Integer;
  CallManRecord:TCallManRecord;
begin
  qry := NewADOQuery;
  try
    self.SetSearchQry(qry,params);
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    for i := 0 to qry.RecordCount - 1 do
    begin
      CallManRecord:=TCallManRecord.Create;
      Self.Query2Obj(qry,CallManRecord);
      CallManRecordList.Add(CallManRecord) ;
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;


procedure TDBCallRecord.Query2Obj(qry: TADOQuery; var callRecord:TCallManRecord);
begin
  callRecord.strGUID := qry.FieldByName('strGUID').Value;
  //callRecord.strPlanGUID := qry.FieldByName('strPlanGUID').Value;
  callRecord.strTrainNo := qry.FieldByName('strTrainNo').Value;
  callRecord.strRoomNum := qry.FieldByName('strRoomNum').Value;
  callRecord.dtCallTime := qry.FieldByName('dtCallTime').Value;
  callRecord.eCallType := qry.FieldByName('eCallType').Value;
   callRecord.eCallState :=qry.FieldByName('eCallState').Value;
  callRecord.strDutyUser := qry.FieldByName('strDutyUser').Value;
  callRecord.eCallResult := qry.FieldByName('eCallResult').Value;
  callRecord.strMsg := qry.FieldByName('strMsg').Value;

  callRecord.dtCreateTime := qry.FieldByName('dtCreateTime').Value;
  callRecord.nDeviceID := qry.FieldByName('nDeviceID').Value;
  callRecord.nConTryTimes := qry.FieldByName('nConTryTimes').Value;
  callRecord.dtChuQinTime := qry.FieldByName('dtChuQinTime').Value;
  callRecord.strCallVoiceGUID := qry.FieldByName('strCallVoiceGUID').Value;
  callRecord.strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
  callRecord.strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
  callRecord.strTrainmanName := qry.FieldByName('strTrainmanName').Value;
  callRecord.strVoiceTxt :=qry.FieldByName('strVoiceTxt').Value; 

end;

procedure TDBCallRecord.SetSearchQry(qry: TADOQuery; params: RCallQryParams);
var
  strSql:string;
begin
  strSql := 'select * from tab_Record_CallMan where dtCallTime >=:dtStart and '
    + ' dtCallTime <= :dtEnd';
  if params.strTrainNo <> '' then
    strSql := strSql + ' and strTrainNo =:strTrainNo';
  if params.strRoomNum <> '' then
    strSql := strSql + ' and strRoomNum =:strRoomNum';
  qry.SQL.Text := strSql;
  qry.Parameters.ParamByName('dtStart').Value := params.dtStartCallTime;
  qry.Parameters.ParamByName('dtEnd').Value := params.dtEndCallTime;
  if qry.Parameters.FindParam('strTrainNo') <> nil then
    qry.Parameters.ParamByName('strTrainNo').Value := params.strTrainNo;
  if qry.Parameters.FindParam('strRoomNum') <> nil then
    qry.Parameters.ParamByName('strRoomNum').Value := params.strRoomNum;

end;

procedure TDBCallRecord.Update(CallRoomRecord: TCallRoomRecord);
begin
  ;
end;

{ TDBRoomDev }

procedure TDBCallDev.Add(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev';
    qry.Open;
    qry.Append;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Delete(strGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete  from tab_Base_RoomCallDev where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := strGUID;
    qry.ExecSQL;
  finally
    qry.free;
  end;
end;

function TDBCallDev.FindByDev(nDevNum:Integer;out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev where nDevNum =:nDevNum';
    qry.Parameters.ParamByName('nDevNum').Value := nDevNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

function TDBCallDev.FindByRoom(strRoomNum:string;out dev: RCallDev): Boolean;
var
  qry:TADOQuery;
begin
  Result := False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Base_RoomCallDev where strRoomNum =:strRoomNum';
    qry.Parameters.ParamByName('strRoomNum').Value := strRoomNum;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Query2Obj(qry,dev);
    Result := True;
  finally
    qry.Free;
  end;
end;

procedure TDBCallDev.GetAll(out devAry: TCallDevAry);
var
  qry:TADOQuery;
  i:Integer;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from tab_Base_RoomCallDev ';
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    SetLength(devAry,qry.RecordCount);
    for i := 0 to qry.RecordCount - 1 do
    begin
      Self.Query2Obj(qry,devAry[i]);
      qry.Next;
    end;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Modify(dev: RCallDev);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select *  from tab_Base_RoomCallDev where strGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := dev.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Query(dev,qry);
    qry.Post;
  finally
    qry.free;
  end;
end;

procedure TDBCallDev.Obj2Query(dev: RCallDev; query: TADOQuery);
begin
  query.FieldByName('strGUID').value := dev.strGUID;
  query.FieldByName('strRoomNum').value := dev.strRoomNum;
  query.FieldByName('nDevNum').value := dev.nDevNum;
end;

procedure TDBCallDev.Query2Obj(query: TADOQuery;var dev: RCallDev);
begin
  dev.strGUID := query.FieldByName('strGUID').value;
  dev.strRoomNum := query.FieldByName('strRoomNum').value;
  dev.nDevNum := query.FieldByName('nDevNum').value;
end;

{ TDBManCallPlan }

procedure TDBCallManPlan.Add(manPlan: TCallManPlan);
var
  qry:TADOQuery;
begin
  qry:=NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlan.strGUID;
    qry.Open;
    if qry.RecordCount=0 then
      qry.Append
    else
      qry.Edit;
    self.Obj2Qry(manPlan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;


procedure TDBCallManPlan.Add(manPlanList: TCallManPlanList);
var
  i:Integer;
  manPlan:TCallManPlan;
begin
  Self.GetADOConnection.BeginTrans;
  try
    for i := 0 to manPlanList.Count - 1 do
    begin
      manPlan := manPlanList.Items[i];
      Self.Add(manPlan);
    end;
    GetADOConnection.CommitTrans;
  except on e:Exception do
    GetADOConnection.RollbackTrans;
  end;
    
end;

procedure TDBCallManPlan.Del(manPlanGUID: string);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'delete From tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlanGUID;
    qry.ExecSQL;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.FindByWaitPlan(strWaitPlanGUID: string;strTrainmanGUID:string;
  var callManPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result:= False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strWaitPlanGUID =:strWaitPlanGUID'
      + ' and strTrainmanGUID =:strTrainmanGUID   and eCallPlanState =:eCallPlanState ';
    qry.Parameters.ParamByName('strWaitPlanGUID').Value := strWaitPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('eCallPlanState').Value := TCS_Publish;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Qry2Obj(qry,callManPlan);
    Result := True ;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.FindUnCall(strTrainPlanGUID, strTrainmanGUID: string;
  var callManPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result:= False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strTrainPlanGUID =:strTrainPlanGUID'
      + ' and strTrainmanGUID =:strTrainmanGUID and eCallPlanState =:eCallPlanState ';
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strTrainPlanGUID;
    qry.Parameters.ParamByName('strTrainmanGUID').Value := strTrainmanGUID;
    qry.Parameters.ParamByName('eCallPlanState').Value := TCS_Publish;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    self.Qry2Obj(qry,callManPlan);
    Result := True ;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.FindWaitPlanByCallMan(strCallManGUID: string;
  var WaitPlanGUID: string): Boolean;
var
  qry:TADOQuery;
begin
  result:= False;
  qry:= NewADOQuery;
  try
    qry.SQL.Text := 'select strWaitPlanGUID from tab_plan_CallMan where strCallPlanGUID =:strCallPlanGUID' ;
    qry.Parameters.ParamByName('strCallPlanGUID').Value := strCallManGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    WaitPlanGUID := qry.FieldByName('strWaitPlanGUID').Value;
    Result := True ;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.GetManPlanOfState(var manPlanList:TCallManPlanList;
            ePlanState:TRoomCallState);
var
  qry:TADOQuery;
  i:Integer;
  manPlan:TCallManPlan;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where ePlanState = :state '
      + ' order by dtCallTime';
    qry.Parameters.ParamByName('state').Value := ePlanState;
    qry.Open;

    for i := 0 to qry.RecordCount - 1 do
    begin
      manPlan:=TCallManPlan.Create;
      Self.Qry2Obj(qry,manPlan);
      manPlanList.Add(manPlan);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

procedure TDBCallManPlan.GetRoomCallPlanList(var roomPlanList: TCallRoomPlanList;
  eStartState, eEndState: TRoomCallState);
var
  qry:TADOQuery;
  roomPlan:TCallRoomPlan;
  manPlan:TCallManPlan;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_CallMan where eCallPlanState >= :eStartState'
      + ' and eCallPlanState <= :eEndState order by dtCallTime,strRoomNum asc';
    qry.Parameters.ParamByName('eStartState').value := eStartState;
    qry.Parameters.ParamByName('eEndState').value := eEndState;
    qry.Open;
    while not qry.Eof do
    begin
      manPlan := TCallManPlan.Create;
      Self.Qry2Obj(qry,manPlan);
      roomPlan := roomPlanList.FindByRoomTrainNo(manPlan.strRoomNum,manPlan.strTrainNo);
      if roomPlan = nil then
      begin
        roomPlan := TCallRoomPlan.Create;
        roomPlan.Init(manPlan);
        roomPlanList.Add(roomPlan);
      end;
      roomPlan.manList.Add(manPlan);
      qry.Next;
    end;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.ModifyManPlan(manPlan: TCallManPlan): Boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry:=NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_plan_CallMan where strCallPlanGUID =:strGUID';
    qry.Parameters.ParamByName('strGUID').Value := manPlan.strGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    self.Obj2Qry(manPlan,qry);
    qry.Post;
  finally
    qry.Free;
  end;
end;

function TDBCallManPlan.ModifyRoomPlan(RoomPlan: TCallRoomPlan): Boolean;
var
  i:Integer;
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  Self.GetADOConnection.BeginTrans;
  try
    try
      for i := 0 to RoomPlan.manList.Count - 1 do
      begin
        ModifyManPlan(RoomPlan.manList.Items[i]);
      end;
      self.GetADOConnection.CommitTrans;
    except on e:Exception do
      self.GetADOConnection.RollbackTrans;
    end;
  finally
    qry.Free;
  end
end;

class procedure TDBCallManPlan.Obj2Qry(obj: TCallManPlan; qry: TADOQuery);
begin
  qry.FieldByName('strCallPlanGUID').Value := obj.strGUID;
  qry.FieldByName('strWaitPlanGUID').Value := obj.strWaitPlanGUID;
  qry.FieldByName('strTrainPlanGUID').Value := obj.strTrainPlanGUID;
  qry.FieldByName('strTrainNo').Value := obj.strTrainNo;
  qry.FieldByName('dtCallTime').Value := obj.dtCallTime;
  qry.FieldByName('dtChuQinTime').Value := obj.dtChuQinTime;
  qry.FieldByName('strTrainmanGUID').Value := obj.strTrainmanGUID;
  qry.FieldByName('strTrainmanNumber').Value := obj.strTrainmanNumber;
  qry.FieldByName('strTrainmanName').Value := obj.strTrainmanName;
  qry.FieldByName('strRoomNum').Value := obj.strRoomNum;
  qry.FieldByName('dtFirstCallTime').Value := obj.dtFirstCallTime;
  qry.FieldByName('dtRecallTime').Value := obj.dtRecallTime;
  qry.FieldByName('eCallPlanState').Value := obj.ePlanState;
end;

class procedure TDBCallManPlan.Qry2Obj(qry: TADOQuery; var obj: TCallManPlan);
begin
  obj.strGUID := qry.FieldByName('strCallPlanGUID').Value;
  obj.strWaitPlanGUID := qry.FieldByName('strWaitPlanGUID').Value;
  obj.strTrainPlanGUID := qry.FieldByName('strTrainPlanGUID').Value;
  obj.strTrainNo := qry.FieldByName('strTrainNo').Value;
  obj.dtCallTime := qry.FieldByName('dtCallTime').Value;
  obj.dtChuQinTime := qry.FieldByName('dtChuQinTime').Value;
  obj.strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
  obj.strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
  obj.strTrainmanName := qry.FieldByName('strTrainmanName').Value;
  obj.strRoomNum := qry.FieldByName('strRoomNum').Value;
  obj.dtFirstCallTime := qry.FieldByName('dtFirstCallTime').Value;
  obj.dtRecallTime := qry.FieldByName('dtRecallTime').Value;
  obj.ePlanState := qry.FieldByName('eCallPlanState').Value;
end;

procedure TDBCallManPlan.UpdateFirstCallTime(strCallPlanGUID:string;dtTime: TDateTime);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := strCallPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_FIRSTCALL ;
    qry.FieldByName('dtFirstCallTime').Value := dtTime;
    qry.Post;
  finally
    qry.Free;
  end; 
end;

procedure TDBCallManPlan.UpdateReCallTime(strCallPlanGUID:string;dtTime: TDateTime);
var
  qry:TADOQuery;
begin
  qry := NewADOQuery;
  try
    qry.SQL.Text := 'select * from tab_Plan_Callman where strCallPlanGUID =:strCallPlanGUID';
    qry.Parameters.ParamByName('strCallPlanGUID').Value := strCallPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('eCallPlanState').Value := TCS_RECALL ;
    qry.FieldByName('dtRecallTime').Value := dtTime;
    qry.Post;
  finally
    qry.Free;
  end; 
end;

{ TDBCallVoice }

procedure TDBCallVoice.Add(CallVoice: TCallVoice);
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  qry.SQL.Text := 'select * from Tab_Record_CallVoice where 1<>1';
  try
    qry.Open;
    qry.Append;
    self.Obj2Qry(CallVoice,qry);
    qry.Post;
  finally
    qry.Free;
  end;

end;

function TDBCallVoice.Find(strCallVoiceGUID: string;
  var CallVoice: TCallVoice): Boolean;
var
  qry:TADOQuery;
begin
  qry:= NewADOQuery;
  qry.SQL.Text := 'select * from Tab_Record_CallVoice where strCallVoiceGUID =:strCallVoiceGUID';
  try
    qry.Parameters.ParamByName('strCallVoiceGUID').Value := strCallVoiceGUID;
    qry.Open;
    self.Qry2Obj(qry,CallVoice);
  finally
    qry.Free;
  end;

end;

procedure TDBCallVoice.Obj2Qry(Obj: TCallVoice; qry: TADOQuery);
begin
   qry.FieldByName('strCallVoiceGUID').Value := Obj.strCallVoiceGUID;
   TBlobField(qry.FieldByName('msVoice')).LoadFromStream(Obj.vms);
   qry.FieldByName('dtCreateTime').Value := Obj.dtCreateTime;

end;

procedure TDBCallVoice.Qry2Obj(qry: TADOQuery; var obj: TCallVoice);
begin
  Obj.strCallVoiceGUID := qry.FieldByName('strCallVoiceGUID').Value;
  Obj.dtCreateTime := qry.FieldByName('dtCreateTime').Value ;
  if not qry.FieldByName('msVoice').IsNull then
  begin
    TBlobField(qry.FieldByName('msVoice')).SaveToStream(Obj.vms);
  end;
end;

end.
