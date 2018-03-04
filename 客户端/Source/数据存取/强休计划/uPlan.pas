unit uPlan;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,utfsystem;
type
  //强休计划状态枚举,同时也对应人员状态
  TPlanStateEnum = (pseNull{未录入},pseNew{未签到},pseSignin{已签到},
    pseInroom{已入寓},pseOutroom{已离寓},pseOutduty{已出勤});

  //强休计划信息
  RPlan = record
    strGUID : string; //计划GUID
    strTrainNo : string;
    dtSigninTime : TDateTime;
    dtCallTime : TDateTime;
    dtOutDutyTime : TDateTime;    
    dtStartTime : TDateTime;
    strMainDriverGUID : string;
    nMainDriverState : Integer;
    strSubDriverGUID : string;
    nSubDriverState :Integer;
    strInputGUID : string;
    dtInputTime : TDateTime;
    nState : Integer;
    nTrainmanTypeID : Integer;
    strAreaGUID : string;
    bCalled : integer;
    public
      //初始化数据
      procedure Init;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///强休计划操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBPlan = class
  public
    // 获取车次入住的房间
     class function GetTrainNosRoom(strTrainNo : string):string;
    //根据行车计划GUID获取强休计划GUID
    class function FindByID(PlanGUID:string):Boolean;
    //判断指定日期内的指定车次的计划是否存在
    class function ExistPlan(planDate : TDateTime;areaGUID:string;trainNo : string;ADOConn : TADOConnection):boolean;
    //查询指定日期范围内计划信息
    class procedure QueryPlan(beginDate,endDate : TDateTime;areaGUID : string;out Rlt : TADOQuery);
    //乘务员签到
    class function Signin(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
    //获取所有的计划
    class procedure GetPlans(planDate : TDateTime;out Rlt : TADOQuery) ;
    //获取所有指定日期的计划
    class procedure GetPlansOnlyDate(planDate : TDateTime;out Rlt : TADOQuery) ;
    //获取没有做计划的车次
    class procedure GetAllCanEditPlans(areaGUID : string ;planDate : TDateTime;out Rlt : TADOQuery);
    //获取指定GUID的计划
    class function GetPlan(planGUID : string): RPlan;
    //添加计划
    class function AddPlan(plan:RPlan) : boolean;
    //修改计划
    class function EditPlan(plan:RPlan) : boolean;
    //判断指定车次的计划是否已经存在
    class function ExistPlanByTrainNo(plan:RPlan) : boolean;
    //更改计划房间
    class function EditPlanRoom(PlanGUID:string;RoomNumber:string):boolean;
    //修改强休计划的叫班时间
    class function UpdatePlanRecordTime(planGUID : string) : boolean;
    //修改强休计划的叫班时间
    class function UpdateCalTime(planGUID : string;CallTime : TDateTime) : boolean;
    //删除计划
    class function DeletePlan(planGUID : string) : boolean;
    //获取乘务员的待班计划
    class procedure GetTrainmanPlan(strTrainmanGUID:string ; out Rlt : TADOQuery);
    //是否存在乘务员的待班计划
    class function ExistTrainmanPlan(strTrainmanGUID : string) : Boolean;

    //获取指定车次的签到信息
    class procedure GetSigninByTrainNo(trainNo : string ;planDate : TDateTime ;out Rlt : TADOQuery);
    //获取指定车次的入寓信息
    class procedure GetInRoomByTrainNo(trainNo : string ;planDate : TDateTime ;out Rlt : TADOQuery);
    //获取指定车次的离寓信息
    class procedure GetOutRoomByTrainNo(trainNo : string ;planDate : TDateTime ;out Rlt : TADOQuery);
    //获取指定车次的出勤信息
    class procedure GetOutDutyByTrainNo(trainNo : string ;planDate : TDateTime ;out Rlt : TADOQuery);

    //获取指定计划的GUID的签到信息
    class procedure GetSigninByGUID(planGUID: string;out Rlt : TADOQuery);
    
    //获取当前需要叫班的计划信息
    class procedure GetCalls(planDate : TDateTime;out Rlt  : TADOQuery);
    //获取指定车次的签到信息
    class procedure GetCallsByTrainNo(trainNo : string ;planDate : TDateTime;out Rlt : TADOQuery);
    //获取指定计划的GUID的签到信息
    class procedure GetCallsByGUID(planGUID : string;out Rlt : TADOQuery);
    //乘务员入寓
    class function InRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
    //乘务员出寓
    class function OutRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
     //获取乘务员所在计划的状态
    class procedure GetTrainmanCall(strTrainmanGUID : string;out Rlt : TADOQuery);
    //获取乘务员所在计划的状态
    class function GetTrainmanPlanState(strTrainmanGUID : string;NeedPlanState:Integer) : RPlan;

    //获取当前需要退勤的计划信息
    class procedure GetOutDuty(planDate : TDateTime;out Rlt :TADOQuery);
    //获取乘务员所在出勤的状态
    class procedure GetTrainmanOutDuties(strTrainmanGUID : string;out Rlt : TADOQuery) ;
    //获取乘务员所在出勤的信息
    class function GetTrainmanOutDuty(strTrainmanGUID : string) : RPlan;

    //获取指定计划的GUID的出勤信息
    class procedure GetOutDutyByGUID(planGUID : string;out Rlt  : TADOQuery);
    //乘务员出勤
    class function OutDuty(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
    //修改叫班标志
    class function EditCallState(bCalled:Boolean;strGUID:string) : boolean;
    //修改待乘标志
    class procedure EditRoomWaitingState(strGUID:string;callCount : integer);
    //获取待乘记录打印数据
    class procedure GetDCJLs(beginTime,endTime : TDateTime;var adoQuery : TADOQuery);
    //取消指定强休计划的指定人员的签到信息
    class function CancelSignin(PlanGUID,TrainmanGUID : string; out Errormsg : string) : boolean;
  end;
implementation

{ TPlan }
uses
  uGlobalDM, DB,DateUtils;
class function TDBPlan.GetPlan(planGUID: string): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text ,[QuotedStr(planGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin
          strGUID := FieldByName('strGUID').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          dtSigninTime := FieldByName('dtSigninTime').AsDateTime;
          dtCallTime := FieldByName('dtCallTime').AsDateTime;
          dtOutDutyTime := FieldByName('dtOutDutyTime').AsDateTime;
          dtStartTime := FieldByName('dtStartTime').AsDateTime;
          strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
          nMainDriverState := FieldByName('nMainDriverState').AsInteger;
          strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
          nSubDriverState := FieldByName('nSubDriverState').asInteger;
          strInputGUID := FieldByName('strInputGUID').AsString;
          dtInputTime := FieldByName('dtInputTime').AsDateTime;
          nState := FieldByName('nState').AsInteger;
          nTrainmanTypeID := FieldByName('nTrainmanTypeID').AsInteger;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
          bCalled := 0;
          if FieldByName('bCalled').AsBoolean then
             bCalled := 1;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TDBPlan.GetSigninByGUID(planGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select top 1 * from tab_RestInWaiting_Plan where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetSigninByTrainNo(trainNo: string;
  planDate: TDateTime ; out RLt  : TADOQuery);
begin
  RLt := TADOQuery.Create(nil);
  with RLt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_Plan ' +
      ' where ((dbo.getdatestring(dtSignInTime) >= %s) or (dtSignInTime >= %s))  and strTrainNo = %s order by dtSigninTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(planDate,-12))),QuotedStr(trainNo)]);
    Open;
  end;
end;

class procedure TDBPlan.GetPlans(planDate : TDateTime;out Rlt : TADOQuery) ;
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    Sql.Text := 'select * from VIEW_RestInWaiting_Plan where dbo.getdatestring(dtStartTime) >= %s  and nState >=1 order by nState,dtStartTime';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate))]);
    Open;
  end;

end;

class procedure TDBPlan.GetPlansOnlyDate(planDate: TDateTime;
  out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select * from VIEW_RestInWaiting_Plan where dbo.getdatestring(dtSignInTime) = %s  and nState >=1 order by nState,dtStartTime';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate))]);
    Open;
  end;
end;

class procedure TDBPlan.GetTrainmanCall(strTrainmanGUID: string ; out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Call ' +
    ' where ((strMainDriverGUID =%s) and (nMainDriverState>1) and (nMainDriverState<4)) or ((strSubDriverGUID=%s)  and (nSubDriverState>1 ) and (nSubDriverState<4 )) and (nState>1 and nState < 4) order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetTrainmanOutDuties(
  strTrainmanGUID: string;out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection;
    SQL.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty ' +
    ' where ((strMainDriverGUID =%s) and (nMainDriverState>3) and (nMainDriverState<5)) or ((strSubDriverGUID=%s)  and (nSubDriverState>3 ) and (nSubDriverState<5 )) and (nState>3 and nState < 5) order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
    Open;
  end;

end;

class function TDBPlan.GetTrainmanOutDuty(strTrainmanGUID: string): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty ' +
        ' where ((strMainDriverGUID =%s) and (nMainDriverState>3) and (nMainDriverState<5)) or ((strSubDriverGUID=%s)  and (nSubDriverState>3 ) and (nSubDriverState<5 )) and (nState>3 and nState < 5) order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strTrainNo := FieldByName('strTrainNo').AsString;
        Result.dtStartTime := FieldByName('dtStartTime').AsDateTime;
        Result.strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
        Result.nMainDriverState := FieldByName('nMainDriverState').AsInteger;
        Result.strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
        Result.nSubDriverState := FieldByName('nSubDriverState').AsInteger;
        Result.nState := FieldByName('nState').AsInteger;
      end;
    end;
  finally
    ado.Free
  end;

end;

class procedure TDBPlan.GetTrainmanPlan(strTrainmanGUID: string;out Rlt  :TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Plan where ((strMainDriverGUID =%s) and (nMainDriverState=1)) or ((strSubDriverGUID=%s)  and (nSubDriverState=1)) and nState=1 order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
    Open;
  end;
end;

class function TDBPlan.GetTrainmanPlanState(strTrainmanGUID: string;NeedPlanState:Integer): RPlan;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Call where 1=1 ';
      if NeedPlanState = 1 then
      begin
        SQL.Text := SQL.Text + ' and( dbo.GetDateString(dtSigninTime) >= dbo.GetDateString(getdate())  or dtSigninTime >= getdate()-0.0415)  ' ;
      end;
      if NeedPlanState = 2 then
      begin
        SQL.Text := SQL.Text + ' and( dbo.GetDateString(dtSigninTime) >= dbo.GetDateString(getdate())  or dtSigninTime >= getdate()-0.0415)  ';
      end;
      if NeedPlanState = 3 then
      begin
        SQL.Text := SQL.Text + ' and( dbo.GetDateString(dtSigninTime) >= dbo.GetDateString(getdate())  or dtCallTime >= getdate()-0.0415)  ';
      end;
      if NeedPlanState = 4 then
      begin
        SQL.Text := SQL.Text + ' and( dbo.GetDateString(dtOutDutyTime) >= dbo.GetDateString(getdate())  or dtOutDutyTime >= getdate()-0.0415)  ';
      end;                  
       SQL.Text := SQL.Text + ' and (((strMainDriverGUID =%s) and (nMainDriverState>1) and (nMainDriverState<4)) or ((strSubDriverGUID=%s)  and (nSubDriverState>1 ) and (nSubDriverState<4 ))) ';
       SQL.Text := SQL.Text + ' and (nState>0 and nState < 4) order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.strGUID := FieldByName('strGUID').AsString;
        Result.strTrainNo := FieldByName('strTrainNo').AsString;
        Result.dtStartTime := FieldByName('dtStartTime').AsDateTime;
        Result.strMainDriverGUID := FieldByName('strMainDriverGUID').AsString;
        Result.nMainDriverState := FieldByName('nMainDriverState').AsInteger;
        Result.strSubDriverGUID := FieldByName('strSubDriverGUID').AsString;
        Result.nSubDriverState := FieldByName('nSubDriverState').AsInteger;
        Result.nState := FieldByName('nState').AsInteger;        
      end;
    end;
  finally
    ado.Free
  end;
end;

class function TDBPlan.GetTrainNosRoom(strTrainNo: string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from Tab_Org_TrainNo where strTrainNo=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strTrainNo)]);
      Open;
      if RecordCount > 0 then
        Result := FieldByName('strRoomNumber').AsString;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.InRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'exec PROC_InRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.OutDuty(strTrainmanGUID: string ;strMainGUID :string;
        nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'exec PROC_OutDuty %s,%s,%d,%s,%d,%s,%d,%s,%d';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),nMainDrinkResult,
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),nSubDrinkResult]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.OutRoom(strPlanGUID: string ;strRoomNumber:string;strMainGUID :string;
        nMainVerify:Integer;strSubGUID : string;nSubVerify:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'exec PROC_OutRoom %s,%s,%s,%d,%s,%s,%d,%s';
      SQL.Text := Format(SQL.Text,[QuotedStr(strPlanGUID),QuotedStr(strRoomNumber),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;end;

class procedure TDBPlan.QueryPlan(beginDate,endDate : TDateTime;areaGUID : string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := GlobalDM.LocalADOConnection ;
  Rlt.SQL.Text := 'select * from VIEW_RestInWaiting_Plan where strAreaGUID=%s and dtSigninTime >= %s and dtSigninTime <=%s order by dtSigninTime desc';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  Rlt.Open;
end;

class function TDBPlan.Signin(strTrainmanGUID: string ;strMainGUID :string;
  nMainVerify:Integer;nMainDrinkResult:Integer;strSubGUID : string;nSubVerify:Integer;nSubDrinkResult:Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'exec PROC_Signin %s,%s,%d,%s,%d,%s,%d,%s,%d';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),
        QuotedStr(strMainGUID),nMainVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),nMainDrinkResult,
        QuotedStr(strSubGUID),nSubVerify,QuotedStr(GlobalDM.DutyUser.strDutyGUID),nSubDrinkResult]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.UpdateCalTime(planGUID: string;
  CallTime: TDateTime): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'update TAB_RestInWaiting_Plan set dtCallTime = %s ' +
        ' where strGUID=%s and (nMainDriverState >= 2 or nSubDriverState >=2)  and bCalled = 0';
      Sql.Text := Format(Sql.Text, [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:00',CallTime)),QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TDBPlan.UpdatePlanRecordTime(planGUID: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'update TAB_RestInWaiting_Plan set dtCallTime = getdate() ' +
        ' where strGUID=%s and (nMainDriverState >= 3 or nSubDriverState >=3)  and bCalled = 0';
      Sql.Text := Format(Sql.Text, [QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.AddPlan(plan: RPlan): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin

      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where 1=2';
      Open;
      Append;
      FieldByName('strGUID').AsString := plan.strGUID;
      FieldByName('strTrainNo').AsString := plan.strTrainNo;
      FieldByName('dtSigninTime').AsDateTime := plan.dtSigninTime;
      FieldByName('dtCallTime').AsDateTime := plan.dtCallTime;
      FieldByName('dtOutDutyTime').AsDateTime := plan.dtOutDutyTime;
      FieldByName('dtStartTime').AsDateTime := plan.dtStartTime;
      FieldByName('strMainDriverGUID').AsString := plan.strMainDriverGUID;
      FieldByName('nMainDriverState').AsInteger := plan.nMainDriverState;
      FieldByName('strSubDriverGUID').AsString := plan.strSubDriverGUID;
      FieldByName('nSubDriverState').asInteger := plan.nSubDriverState;
      FieldByName('strInputGUID').AsString := plan.strInputGUID;
      FieldByName('dtInputTime').AsDateTime := plan.dtInputTime;
      FieldByName('nState').AsInteger := 1;
      FieldByName('nTrainmanTypeID').AsInteger := plan.nTrainmanTypeID;
      FieldByName('strAreaGUID').AsString := plan.strAreaGUID;

      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.CancelSignin(PlanGUID, TrainmanGUID: string;
  out Errormsg: string): boolean;
var
  adoQuery : TADOQuery;
  strSql,strSqlSignin : string;
begin
  result := false;
  Errormsg := '';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where strGUID=%s and ' +
        ' (strMainDriverGUID = %s or strSubDriverGUID=%s)';
      Sql.Text := Format(Sql.Text,[QuotedStr(PlanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
      Open;
      if RecordCount = 0 then
      begin
        Errormsg := '未找到指定的强休计划';
        exit;
      end;
      if FieldByName('strMainDriverGUID').AsString = TrainmanGUID then
      begin
        if FieldByName('nMainDriverState').AsInteger <> Ord(pseSignin) then
        begin
          Errormsg := '只有刚签到过的司机才能撤销';
          exit;
        end;
        strSql := 'update TAB_RestInWaiting_Plan set strMainDriverGUID=%s,nMainDriverState=%d where strGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),Ord(pseNew),QuotedStr(PlanGUID)]);
        strSqlSignin := '';
        if FieldByName('nState').AsInteger >= Ord(pseSignin) then
        begin
          strSql := 'update TAB_RestInWaiting_Plan set strMainDriverGUID=%s,nMainDriverState=%d,nState=%d where strGUID=%s';
          strSql := Format(strSql,[QuotedStr(''),Ord(pseNew),Ord(pseNew),QuotedStr(PlanGUID)]);
        end;
        if FieldByName('nSubDriverState').AsInteger < Ord(pseSignin) then
        begin
          strSqlSignin := 'delete from TAB_ResInWaiting_Signin where strPlanGUID = %s';
          strSqlSignin := Format(strSqlSignin,[QuotedStr(PlanGUID)]);
        end;        
      end;

      if FieldByName('strSubDriverGUID').AsString = TrainmanGUID then
      begin
        if FieldByName('nSubDriverState').AsInteger <> Ord(pseSignin) then
        begin
          Errormsg := '只有刚签到过的司机才能撤销';
          exit;
        end;
        strSql := 'update TAB_RestInWaiting_Plan set strSubDriverGUID=%s,nSubDriverState=%d where strGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),Ord(pseNew),QuotedStr(PlanGUID)]);
        if FieldByName('nState').AsInteger >= Ord(pseSignin) then
        begin
          strSql := 'update TAB_RestInWaiting_Plan set strSubDriverGUID=%s,nSubDriverState=%d,nState=%d where strGUID=%s';
          strSql := Format(strSql,[QuotedStr(''),Ord(pseNew),Ord(pseNew),QuotedStr(PlanGUID)]);
        end;
        strSqlSignin := '';
        if FieldByName('nMainDriverState').AsInteger < Ord(pseSignin) then
        begin
          strSqlSignin := 'delete from TAB_ResInWaiting_Signin where strPlanGUID = %s';
          strSqlSignin := Format(strSqlSignin,[QuotedStr(PlanGUID)]);
        end;            
      end;
      if strSql='' then
      begin
        Errormsg := '只有刚签到过的司机才能撤销';
        exit;
      end;
      
      if strSqlSignin <> '' then
      begin
        Sql.Text := strSqlSignin;
        ExecSQL;
      end;
      
      Sql.Text := strSql;
      Result := ExecSQL > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TDBPlan.DeletePlan(planGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'delete from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(planGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

function BooleanToInt(bValue:Boolean):Integer;
begin
   Result := 0;
   if bValue then
    Result := 1;
end;
class function TDBPlan.EditCallState(bCalled:Boolean;strGUID:string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Sql.Text := 'Select * from TAB_RestInWaiting_Plan  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strGUID)]);
      Open;
      if RecordCount > 0  then
      begin
        Edit;
        FieldByName('nCall').AsInteger := FieldByName('nCall').AsInteger + 1;
        FieldByName('bCalled').AsBoolean := bCalled;
        Post;
      end;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.EditPlan(plan: RPlan): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select * from TAB_RestInWaiting_Plan where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(plan.strGUID)]);
      Open;
      Edit;
      FieldByName('strMainDriverGUID').AsString := plan.strMainDriverGUID;
      FieldByName('strSubDriverGUID').AsString := plan.strSubDriverGUID;
      FieldByName('dtSigninTime').AsDateTime := plan.dtSigninTime;
      FieldByName('dtCallTime').AsDateTime := plan.dtCallTime;
      FieldByName('dtOutDutyTime').AsDateTime := plan.dtOutDutyTime;
      FieldByName('dtStartTime').AsDateTime := plan.dtStartTime;
      FieldByName('nTrainmanTypeID').AsInteger := plan.nTrainmanTypeID;
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBPlan.EditPlanRoom(PlanGUID, RoomNumber: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'update TAB_RestInWaiting_InOutRoom set strRoomNumber = %s  where strPlanGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(RoomNumber),QuotedStr(PlanGUID)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TDBPlan.EditRoomWaitingState(strGUID: string;callCount : integer);
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'Select * from TAB_RoomWaiting_CallRecord  where strGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(strGUID)]);
      Open;
      if RecordCount > 0  then
      begin
        Edit;
        FieldByName('nCallCount').AsInteger := callCount;
        Post;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class function TDBPlan.ExistPlan(planDate: TDateTime; areaGUID,
  trainNo: string;ADOConn : TADOConnection): boolean;
var
  adoQuery : TADOQuery;
begin
  Result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := 'select top 1 strGUID from TAB_RestInWaiting_Plan where strAreaGUID=%s and strTrainNo=%s and dbo.GetDateString(dtStartTime) = dbo.GetDateString(%s)';
      SQL.Text := Format(Sql.Text,[QuotedStr(areaGUID),QuotedStr(trainNo),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(planDate)))]);
      Open;
      if RecordCount > 0 then
      begin
        Result := true;
      end;     
    end; 
  finally
    adoQuery.Free;
  end;
end;

class function TDBPlan.ExistPlanByTrainNo(plan: RPlan): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select ' +
        '  count(*) from TAB_RestInWaiting_Plan ' +
        '  where ' +
        '  ((dbo.GetDateString(dtStartTime)=dbo.GetDateString(%s))  or ' +
        '  (dbo.GetDateString(dtSigninTime) = dbo.GetDateString(%s)) or ' +
        '  (dbo.GetDateString(dtOutDutyTime) = dbo.GetDateString(%s)) or ' +
        '  (dbo.GetDateString(dtCallTime) = dbo.GetDateString(%s))) ' +
        '  and strTrainNo=%s ';
      Sql.Text := Format(Sql.Text,
        [QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',plan.dtStartTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',plan.dtSigninTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',plan.dtOutDutyTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',plan.dtCallTime)),
        QuotedStr(plan.strTrainNo)]);
      if plan.strGUID <> '' then
      begin
        Sql.Text :=  Sql.Text + ' and strGUID <> ' + QuotedStr(plan.strGUID);
      end;      
      Open;
      Result := Fields[0].AsInteger > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TDBPlan.ExistTrainmanPlan(strTrainmanGUID: string): Boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      SQL.Text := 'select top 1 * from VIEW_RestInWaiting_Plan where ((strMainDriverGUID =%s) and (nMainDriverState=1)) or ((strSubDriverGUID=%s)  and (nSubDriverState=1)) and nState=1 order by dtStartTime';
      SQL.Text := Format(SQL.Text,[QuotedStr(strTrainmanGUID),QuotedStr(strTrainmanGUID)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free
  end;
end;

class function TDBPlan.FindByID(PlanGUID: string): Boolean;
var
  ADOQuery : TADOQuery ;
  strSql : string ;
begin
  Result := False ;
  ADOQuery := TADOQuery.Create(nil);
  try
    with ADOQuery do
    begin
      Connection := GlobalDM.LocalADOConnection;
      strSql := Format('select * from TAB_RestInWaiting_Plan  where strGUID = %s ', [PlanGUID]);
      Sql.Text := strSql ;
      Open;
      if ADOQuery.RecordCount > 0 then
        Result := True ;
    end;
  finally
    ADOQuery.Free ;
  end;
end;

class procedure TDBPlan.GetAllCanEditPlans(areaGUID : string ;planDate : TDateTime;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'exec PROC_GetPlans %s,%s';
    Sql.Text := Format(Sql.Text ,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd',planDate))]);
    Open;
  end;
end;

class procedure TDBPlan.GetCalls(planDate: TDateTime;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select * from VIEW_RestInWaiting_InOutRoom where dtCallTime >= %s  and nState >=1 and nState <=3 order by dtCallTime,strRoomNumber';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',DateOf(planDate -1)) + ' 23:30:00')]);
    Open;
  end;
end;

class procedure TDBPlan.GetCallsByGUID(planGUID: string; out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_InOutRoom where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetCallsByTrainNo(trainNo: string;
  planDate: TDateTime; out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_InOutRoom where dbo.getdatestring(dtStartTime) >= %s  and nState >=1 and strTrainNo = %s order by dtStartTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),QuotedStr(trainNo)]);
    Open;
  end;
end;

class procedure TDBPlan.GetDCJLs(beginTime, endTime: TDateTime;
  var adoQuery: TADOQuery);
var
  strSql : string;
begin
  with adoQuery do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    strSql := 'select * from    ' +
          ' ( ' +
          ' (    ' +
          ' select strTrainNo,dtSignInTime,strMainDriverName,dtMainInTime,strSubDriverName,dtSubInTime,dtMainOutTime,dtSubOutTime,strRoomNumber, ' +
          ' (select TOP 1 dtCreateTime from tab_RestInWaiting_CallRecord  where strPlanGUID= VIEW_RestInWaiting_Call.strGUID order by dtCreatetime) as dtRealCallTime ' +
          ' from VIEW_RestInWaiting_Call   where dtCallTime >=%s and dtCallTime <= %s  ' +
          ' ) ' +
          ' union   ' +
          ' (       ' +
          ' select strTrainNo,dtStartTime as dtSignInTime,null,null,null,null,null,null,nRoomID as strRoomNumber, ' +
          ' (select TOP 1 dtCreateTime from tab_RestInWaiting_CallRecord  where strPlanGUID= VIEW_RoomWaiting_CallRecord.strGUID order by dtCreatetime) as dtRealCallTime ' +
          '  from VIEW_RoomWaiting_CallRecord where dtCallTime >=%s and dtCallTime <= %s  ' +
          ' ) ' +
          ' ) ' +
          ' as t1 order by dtRealCallTime desc';
    strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',begintime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endtime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',begintime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endtime))]);
    SQL.Text := strSql;
    Open;
  end;
end;

{
class procedure TDBPlan.GetInRoomByTrainNo(trainNo: string;
  planDate: TDateTime; out Rlt: TADOQuery);
begin
  RLt := TADOQuery.Create(nil);
  with RLt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_Plan ' +
      ' where ((dbo.getdatestring(dtSignInTime) >= %s) or (dtSignInTime >= %s))  and strTrainNo = %s order by dtSigninTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(planDate,-12))),
      QuotedStr(trainNo)]);
    Open;
  end;

end;
}

class procedure TDBPlan.GetInRoomByTrainNo(trainNo: string;
  planDate: TDateTime; out Rlt: TADOQuery);
begin
  RLt := TADOQuery.Create(nil);
  with RLt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from TAB_RestInWaiting_Plan ' +
      ' where ((dbo.getdatestring(dtSignInTime) >= %s) or (dtSignInTime >= %s))  and strTrainNo = %s order by dtSigninTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(planDate,-12))),
      QuotedStr(trainNo)]);
    Open;
  end;

end;

class procedure TDBPlan.GetOutDuty(planDate: TDateTime;out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select * from VIEW_RestInWaiting_OutDuty where dbo.getdatestring(dtStartTime) >= %s  and (nState >=1 ) order by nState,dtStartTime';
    Sql.Text := Format(Sql.Text ,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate))]);
    Open;
  end;
end;

class procedure TDBPlan.GetOutDutyByGUID(planGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_OutDuty where strGUID = %s';
    SQL.Text := Format(SQL.Text,[QuotedStr(planGUID)]);
    Open;
  end;
end;

class procedure TDBPlan.GetOutDutyByTrainNo(trainNo: string;
  planDate: TDateTime;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from VIEW_RestInWaiting_Plan ' +
      ' where ((dbo.getdatestring(dtOutDutyTime) >= %s) or (dtOutDutyTime >= %s)) and strTrainNo = %s order by dtOutDutyTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(planDate,-12))),
      QuotedStr(trainNo)]);
    Open;
  end;
end;

class procedure TDBPlan.GetOutRoomByTrainNo(trainNo: string;
  planDate: TDateTime; out Rlt: TADOQuery);
begin
  RLt := TADOQuery.Create(nil);
  with RLt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Sql.Text := 'select top 1 * from tab_RestInWaiting_Plan ' +
      ' where ((dbo.getdatestring(dtCallTime) >= %s) or (dtCallTime >= %s))  and strTrainNo = %s order by dtCallTime';
    SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd',planDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(planDate,-12))),
      QuotedStr(trainNo)]);
    Open;
  end;

end;

{ RPlan }

procedure RPlan.Init;
begin
  strGUID := '';
  strTrainNo := '';
  dtStartTime := 0;
  strMainDriverGUID :='';
  nMainDriverState := 0;
  strSubDriverGUID := '';
  nSubDriverState := 0;
  strInputGUID := '';
  dtInputTime := 0;
  nState := 0;
  dtCallTime := 0;
  nTrainmanTypeID := 2;
  strAreaGUID := '';
end;

end.
