unit uDBRoomCall;

interface
uses
  Classes,uTFSystem,ADODB,SysUtils,uRoomCall,uSaftyEnum,DB;
type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBRoomDev
  /// 描述:公寓叫班设备操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallDev = class(TDBOperate)
  public
    {功能:增加设备}
    procedure Add(dev:RCallDev);
    {功能:修改设备}
    procedure Modify(dev:RCallDev);
    {功能:删除设备}
    procedure Delete(strGUID:string);
    {功能:获取所有设备}
    procedure GetAll(out devAry:TCallDevAry);
    {功能:根据房间编号查找}
    function FindByRoom(strRoomNum :string;out dev:RCallDev):Boolean;
    {功能:根据设备编号查找}
    function FindByDev(nDevNum:Integer;out dev:RCallDev):Boolean;
  private
    {功能:对象到query}
    procedure Obj2Query(dev:RCallDev;query:TADOQuery);
    {功能:query到对象}
    procedure Query2Obj(query:TADOQuery;var dev:RCallDev);
  end;
  
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBCallVoice
  /// 描述:公寓叫班语音数据库操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallVoice = class(TDBOperate)
  public
    {功能:增加}
    procedure Add(CallVoice:TCallVoice);
    {功能:查找语音记录}
    function Find(strCallVoiceGUID:string;var CallVoice:TCallVoice ) :Boolean;
    {功能:获取录音文件}
    function GetVoiceFile(strGUID,strFilePathName:string):Boolean;
  public
    {数据集到对象}
    procedure Qry2Obj(qry:TADOQuery;var obj:TCallVoice);
    {对象到数据集}
    procedure Obj2Qry(Obj:TCallVoice;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBCallRecord
  /// 描述:公寓叫班记录数据库操作
  //////////////////////////////////////////////////////////////////////////////
  TDBCallRecord = class(TDBOperate)
  public

    {功能:增加}
    procedure Add(callRecord:TCallManRecord) ; overload;
    {功能:增加房间叫班记录}
    procedure Add(CallRoomRecord:TCallRoomRecord); overload;
    {功能 :修改房间叫班记录}
    procedure Update(CallRoomRecord:TCallRoomRecord) ;
    {功能:查询叫班记录}
    procedure qryCallRecord(params:RCallQryParams;var CallManRecordList:TCallManRecordList);

  private
    {构造查询条件}
    procedure SetSearchQry(qry:TADOQuery;params:RCallQryParams);
    {数据集 赋值给 对象}
    procedure Query2Obj(qry:TADOQuery;var callRecord:TCallManRecord);
    {对象 赋值给 数据集}
  procedure Obj2Query(callRecord:TCallManRecord;qry:TADOQuery);
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///类名:TDBCallManPlan
  ///描述:人员叫班计划
  //////////////////////////////////////////////////////////////////////////////
  TDBCallManPlan = class(TDBOperate)
  public
    {功能 : 根据人员计划GUID获取待承计划GUID}
    function FindWaitPlanByCallMan(strCallManGUID:string;var WaitPlanGUID:string):Boolean;
    {功能:按照行车计划和人员查找}
    function FindUnCall(strTrainPlanGUID,strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {功能:按照候版计划GUID查找}
    function FindByWaitPlan(strWaitPlanGUID:string;strTrainmanGUID:string;var callManPlan:TCallManPlan):Boolean;
    {功能:增加记录}
    procedure Add(manPlan:TCallManPlan);overload;
    {功能:增加多个记录}
    procedure Add(manPlanList:TCallManPlanList);overload;

    {功能:修改房间叫班计划}
    function ModifyRoomPlan(RoomPlan:TCallRoomPlan):Boolean;
    {功能:修改记录}
    function ModifyManPlan(manPlan:TCallManPlan):Boolean;
    {功能:删除记录}
    procedure Del(manPlanGUID:string);
    {功能:获取房间待叫班计划列表}
    procedure GetRoomCallPlanList(var roomPlanList:TCallRoomPlanList;eStartState,eEndState:TRoomCallState);
    {功能:获取人员计划按照状态}
    procedure GetManPlanOfState(var manPlanList:TCallManPlanList;ePlanState:TRoomCallState);
    {功能:更新首叫时间}
    procedure UpdateFirstCallTime(strCallPlanGUID:string; dtTime:TDateTime);
    {功能:更新催叫时间}
    procedure UpdateReCallTime(strCallPlanGUID:string;dtTime:TDateTime);
    {功能:对象转换为数据集}
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
