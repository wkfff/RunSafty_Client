unit uDBTrainPlan;

interface

uses
  ADODB,Classes,uTrainPlan,uTFSystem,uTrainmanJiaolu,uTrainman,uApparatusCommon,
  Dialogs,uTFVariantUtils,Variants,uSaftyEnum,uDBTrainmanJiaolu,uDrink,
  uSite,uDutyUser;

type
  //////////////////////////////////////////////////////////////////////////////
  ///机车计划操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainPlan = class(TDBOperate)
  private
    //将机车计划信息填充到ADOQuery中
    procedure ADOQueryToTrainPlanChangeLog(ADOQuery : TADOQuery;var TrainPlanChangeLog:RRsTrainPlanChangeLog);
    //将机车计划信息填充到ADOQuery中
    procedure TrainPlanToADOQuery(ADOQuery : TADOQuery;TrainPlan : RRsTrainPlan; UpdateState : boolean = true);
    //ADOQuery填充到出勤地点设置结构中
    procedure ADOQueryToChuQinDiDian(ADOQuery : TADOQuery; out CQDD : RRsChuQinDiDian);
     //从ADOQuery填充人员计划
    procedure ADOQueryToTrainmanPlan(ADOQuery : TADOQuery;out TrainmanPlan :  RRsTrainmanPlan);
    //从ADOQuery填充计划下发日志
    procedure ADOQueryToSendLog(ADOQuery : TADOQuery; out  SendLog : RRsTrainPlanSendLog);
    //从ADOQuery填充到机组信息
    procedure ADOQueryToGroup(ADOQuery : TADOQuery;out Group: RRsGroup);
	  procedure GetSubPlans(PlanGUIDs : TStrings;SubPlanGUIDs: TStrings);
    function CancleRelativePlan(PlanGUIDs : TStrings;SiteGUID:String;DutyUserGUID:string): Boolean;
    //获取某个乘务员对于莫条计划来说的提前出勤时间和休息信息设置
    function GetChuQinSetInfo(TrainPlan : RRsTrainPlan;Trainman:RRsTrainman;out
      ChuQinTime : TDateTime;out Rest : RRsRest) : boolean;
  public
    {功能:修改候班信息}
    function SetPlanRest(strPlanGUID:string;RestInfo:RRsRest;DutyUser:TRsDutyUser;SiteInfo:TRsSiteInfo):boolean;
    //根据库接和站接以及出勤点确定出勤时间
    function GetPlanTimes(RemakType:Integer;PlaceID:string;var ATime:Integer):Boolean;
      //从ADOQuery填充机车计划
    procedure ADOQueryToTrainPlan(ADOQuery : TADOQuery;out TrainPlan :  RRsTrainPlan);
    //功能：添加机车计划
    procedure Add(TrainPlan : RRsTrainPlan);
    //功能：修改机车计划
    procedure Update(TrainPlan : RRsTrainPlan;DTNow : Tdatetime;SiteGUID:String;DutyUserGUID:string);
    //功能：删除机车计划
    procedure Delete(TrainPlanGUID : string);
    //功能：获取机车计划
    function GetPlan(TrainPlanGUID : string;var TrainPlan : RRsTrainPlan):boolean;
    //获取出勤地点设置信息
    function GetChuQinDiDian(StationGUID : string; out CQDD : RRsChuQinDiDian) : boolean;
    //功能：从图定车次计划表中加载并生成指定时间范围内的加载机车计划
    procedure LoadTrainPlan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string;PlanState : TRsPlanState);
    //功能:在派班功能中从图定车次加载计划
    procedure LoadTrainPlanByPaiBan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string);
     //功能：撤销计划
    function CancelPlan(PlanGUIDs : TStrings;SiteGUID:String;DutyUserGUID:string) : boolean;
    //功能：判断是否满足删除条件
    function CanCanlePlan(PlanGUIDs : TStrings;var strError: string): Boolean;
    //功能：下发计划
    function SendPlan(PlanGUIDS : TStrings;SiteGUID:String;DutyUserGUID:string) : boolean;     
    procedure RemoveBeginWorkRecord(strTrainmanGUID,strTrainPlanGUID: string);
    //功能: 获取计划计划修改日志
    function GetChangeTrainPlanLog(TrainPlanGUID: string;out TrainPlanChangeLogList:TRsTrainPlanChangeLogArray):Boolean;
  public
    //获取所有人员计划信息
    procedure GetTrainmanPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUID : string;
      out TrainmanPlanArray : TRsTrainmanPlanArray); overload;
     //获取所有已发布未出勤的人员计划信息
    procedure GetPBTrainmanPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUIDS : TStrings;
      out TrainmanPlanArray : TRsTrainmanPlanArray); overload;
    //获取所有人员计划信息
    procedure GetXSTrainmanPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUIDS : TStrings;
      out TrainmanPlanArray : TRsTrainmanPlanArray); overload;
      //获取指定时间退勤的计划信息
     procedure GetTuiQinTrainmanPlans(BeginTime,EndTime : TDateTime;TrainJiaoluGUID : string;
      out TrainmanPlanArray : TRsTrainmanPlanArray);
    procedure RefreshTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan);
    //获取已下发的人员计划信息
    procedure GetSentTrainmanPlans(BeginTime, EndTime: TDateTime;SiteGUID : string;
      TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
    //获取指定GUID的人员计划信息
    function GetTrainmanPlan(TrainmanPlanGUID : string;var TrainmanPlan : RRsTrainmanPlan):boolean;overload;
    //获取指定派班室可接收的计划的下发信息
    procedure GetSendLog(SiteGUID : string;LastTime : TDateTime;out SendLogArray : TRsTrainPlanSendLogArray);overload;
    procedure GetSendLog(SiteGUID : string;PlanGUIDS: TStringList;out SendLogArray : TRsTrainPlanSendLogArray);overload;
    //获取调度台已下发超时未接收的计划
    procedure GetUnRecvSendLog(JDSiteGUID:string;FromTime:TDateTime;out SendLogArray : TRsTrainPlanSendLogArray);
    //功能：接收计划
    procedure ReceivePlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID:string);
    //功能：发布计划
    procedure PublishPlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID:string);    
    //判断两个人员计划的数组是否相等
    function EqualTrainmanPlan(Source,Dest : TRsTrainmanPlanArray):boolean;
    //将人员从计划中移除，并不影响名牌操作
    procedure DeleteTrainmanFromPlan(TrainmanPlanGUID : string;TrainmanIndex : integer);
    //设置计划的值乘机组信息
    procedure SetGroupToPlan(Group : RRsGroup;TrainPlan: RRsTrainPlan;
      DutyUserGUID,DutySiteGUID  : string);
  public
    //更新计划状态，用于计划的人员添加或者删除后引起的计划状态的变化
    procedure UpdatePlanState(TrainPlanGUID : string);
    //清楚计划的异常状态、该人员所在组但是计划中的组信息不是该组
    procedure ClearTrainmanPlanError(GroupGUID : string);
  public
    //根据工号获取乘务员的计划
    function GetPlanByTrainmanNumber(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer) : boolean;
    //根据工号获取乘务员的计划(早于计划)
    function GetPlanByTrainmanNumberPre(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer) : boolean;
    //根据工号获取乘务员的计划(晚于计划)
    function GetPlanByTrainmanNumberBeh(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer) : boolean;
  public
    //获取指定计划应该安排的包成机车的机组信息
    function GetBaoChengGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
    //获取指定计划应该安排的轮乘的机组信息
    function GetLunChengGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
    //获取指定计划应该安排的记名式的机组信息
    function GetJiMingGroup(TrainJiaoluGUID:string;TrainPlan : RRsTrainPlan;out Group : RRsGroup) : boolean;
  public //电子名牌管理
    //记名式交路翻牌
    procedure TurnPlateNamedToLeft(TrainmanJiaoluGUID : string);
    //记名式交路翻牌(向右翻牌)
    procedure TurnPlateNamedToRight(TrainmanJiaoluGUID : string);
    //获取人员当前正在值乘的计划
    function GetPlanOfTrainman(TrainmanGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取当前机组正在值乘的计划
    function GetPlanOfGroup(GroupGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取当前包乘机车内正在值乘的计划信息
    function GetPlanOfTrain(TrainGUID : string;out TrainmanPlan : RRsTrainmanPlan) : boolean;  
  end;

implementation
uses
  SysUtils, DB,DateUtils;
{ TDBTrainPlan }

procedure TRsDBTrainPlan.Add(TrainPlan: RRsTrainPlan);
var
  adoQuery : TADOQuery;
  strSql,strGUID : string;
begin
  strGUID := NewGUID;
  strSql := 'Select * from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      Append;
      TrainPlanToADOQuery(ADOQuery,TrainPlan);
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainPlan.ADOQueryToChuQinDiDian(ADOQuery: TADOQuery;
out  CQDD: RRsChuQinDiDian);
begin
  with ADOQuery do
  begin
    CQDD.strGUID := FieldByName('strGUID').AsString;
    CQDD.strStationGUID := FieldByName('strStationGUID').AsString;
    CQDD.strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
    CQDD.nLocalRest := FieldByName('nLocalRest').AsInteger;
    CQDD.nLocalPre := FieldByName('nLocalPre').AsInteger;
    CQDD.nOutRest := FieldByName('nOutRest').AsInteger;
    CQDD.nOutPre := FieldByName('nOutPre').AsInteger;
    CQDD.nZJPre := FieldByName('nZJPre').AsInteger;
    CQDD.nNightReset := FieldByName('nNightReset').AsInteger;
    CQDD.bIsRest := FieldByName('bIsRest').AsInteger;
    CQDD.dtRestTime := FieldByName('dtRestTime').AsDateTime;
    CQDD.dtCallTime := FieldByName('dtCallTime').AsDateTime;
    CQDD.nContinueHours := FieldByName('nContinueHours').AsInteger;
    CQDD.bRuKuFanPai := FieldByName('bRuKuFanPai').AsInteger;
    CQDD.bLocalChaolao := FieldByName('bLocalChaolao').AsInteger;
    CQDD.bOutChaoLao := FieldByName('bOutChaoLao').AsInteger;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToGroup(ADOQuery: TADOQuery; out Group: RRsGroup);
begin
  with ADOQuery do
  begin
    Group.strGroupGUID := FieldByName('strGroupGUID').AsString;
    if FindField('strZFQJGUID') <> nil then
    begin
      Group.ZFQJ.strZFQJGUID := FieldByName('strZFQJGUID').AsString;
      Group.ZFQJ.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
      Group.ZFQJ.nQuJianIndex := FieldByName('nQuJianIndex').AsInteger;
      Group.ZFQJ.strBeginStationGUID := FieldByName('strBeginStationGUID').AsString;
      Group.ZFQJ.strBeginStationName := FieldByName('strBeginStationName').AsString;
      Group.ZFQJ.strEndStationGUID := FieldByName('strEndStationGUID').AsString;
      Group.ZFQJ.strEndStationName := FieldByName('strEndStationName').AsString;
    end;

    Group.Trainman1.strTrainmanGUID := FieldByName('strTrainmanGUID1').AsString;
    Group.Trainman1.strTrainmanName := FieldByName('strTrainmanName1').AsString;
    Group.Trainman1.strTrainmanNumber := FieldByName('strTrainmanNumber1').AsString;
    Group.Trainman1.strTelNumber := FieldByName('strTelNumber1').AsString;
    if FieldByName('nTrainmanState1').IsNull then
      Group.Trainman1.nTrainmanState := tsNil
    else
      Group.Trainman1.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState1').AsInteger);

    Group.Trainman1.nPostID := TRsPost(adoQuery.FieldByName('nPost1').asInteger);
    Group.Trainman1.strWorkShopGUID := FieldByName('strWorkShopGUID1').AsString;
    Group.Trainman1.dtLastEndworkTime := FieldByName('dtLastEndworkTime1').AsDateTime;


    Group.Trainman2.strTrainmanGUID := FieldByName('strTrainmanGUID2').AsString;
    Group.Trainman2.strTrainmanName := FieldByName('strTrainmanName2').AsString;
    Group.Trainman2.strTrainmanNumber := FieldByName('strTrainmanNumber2').AsString;
    Group.Trainman2.strTelNumber := FieldByName('strTelNumber2').AsString;
    if FieldByName('nTrainmanState2').IsNull then
      Group.Trainman2.nTrainmanState := tsNil
    else
      Group.Trainman2.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState2').AsInteger);
    Group.Trainman2.nPostID := TRsPost(adoQuery.FieldByName('nPost2').asInteger);
    Group.Trainman2.strWorkShopGUID := FieldByName('strWorkShopGUID2').AsString;
    Group.Trainman2.dtLastEndworkTime := FieldByName('dtLastEndworkTime2').AsDateTime;


    Group.Trainman3.strTrainmanGUID := FieldByName('strTrainmanGUID3').AsString;
    Group.Trainman3.strTrainmanName := FieldByName('strTrainmanName3').AsString;
    Group.Trainman3.strTrainmanNumber := FieldByName('strTrainmanNumber3').AsString;
    Group.Trainman3.strTelNumber := FieldByName('strTelNumber3').AsString;
    if FieldByName('nTrainmanState3').IsNull then
      Group.Trainman3.nTrainmanState := tsNil
    else
      Group.Trainman3.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState3').AsInteger);
    Group.Trainman3.nPostID := TRsPost(adoQuery.FieldByName('nPost3').asInteger);
    Group.Trainman3.strWorkShopGUID := FieldByName('strWorkShopGUID3').AsString;
    Group.Trainman3.dtLastEndworkTime := FieldByName('dtLastEndworkTime3').AsDateTime;

    Group.Trainman4.strTrainmanGUID := FieldByName('strTrainmanGUID4').AsString;
    Group.Trainman4.strTrainmanName := FieldByName('strTrainmanName4').AsString;
    Group.Trainman4.strTrainmanNumber := FieldByName('strTrainmanNumber4').AsString;
    Group.Trainman4.strTelNumber := FieldByName('strTelNumber4').AsString;
    if FieldByName('nTrainmanState4').IsNull then
      Group.Trainman4.nTrainmanState := tsNil
    else
      Group.Trainman4.nTrainmanState := TRsTrainmanState(FieldByName('nTrainmanState4').AsInteger);
    Group.Trainman4.nPostID := TRsPost(adoQuery.FieldByName('nPost4').asInteger);
    Group.Trainman4.strWorkShopGUID := FieldByName('strWorkShopGUID4').AsString;
    Group.Trainman4.dtLastEndworkTime := FieldByName('dtLastEndworkTime4').AsDateTime;

  end;
end;

procedure TRsDBTrainPlan.ADOQueryToSendLog(ADOQuery: TADOQuery;
  out SendLog: RRsTrainPlanSendLog);
begin
  with ADOQuery do
  begin
    SendLog.strTrainNo := FieldByname('strTrainNo').AsString; 
    SendLog.strSendGUID := FieldByname('strSendGUID').AsString;
    SendLog.strTrainPlanGUID := FieldByname('strTrainPlanGUID').AsString;
    SendLog.strTrainJiaoluName := FieldByname('strTrainJiaoluName').AsString;
    SendLog.dtStartTime := FieldByname('dtStartTime').AsDateTime;
    SendLog.dtRealStartTime := FieldByname('dtRealStartTime').AsDateTime;
    SendLog.strSendSiteName := FieldByname('strSendSiteName').AsString;
    SendLog.dtSendTime := FieldByname('dtSendTime').AsDateTime;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToTrainmanPlan(ADOQuery: TADOQuery;
  out TrainmanPlan: RRsTrainmanPlan);
begin
  ADOQueryToTrainPlan(ADOQuery,TrainmanPlan.TrainPlan);

  TrainmanPlan.RestInfo.nNeedRest := ADOQuery.FieldByName('nNeedRest').AsInteger;
  TrainmanPlan.RestInfo.dtArriveTime := ADOQuery.FieldByName('dtArriveTime').AsDateTime;
  TrainmanPlan.RestInfo.dtCallTime := ADOQuery.FieldByName('dtCallTime').AsDateTime;

  TrainmanPlan.dtBeginWorkTime := ADOQuery.FieldByName('dtChuQinTime').AsDateTime;

  TrainmanPlan.Group.strGroupGUID := ADOQuery.FieldByName('strGroupGUID').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID1').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanName := ADOQuery.FieldByName('strTrainmanName1').AsString;
  TrainmanPlan.Group.Trainman1.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber1').AsString;
  TrainmanPlan.Group.dtLastEndworkTime1 :=  0;
  if (ADOQuery.FieldByName('EndworkTime1').asString <> '') then
  begin
    TrainmanPlan.Group.dtLastEndworkTime1 :=  ADOQuery.FieldByName('EndworkTime1').AsDateTime;
  end;


  TrainmanPlan.Group.Trainman2.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID2').AsString;
  TrainmanPlan.Group.Trainman2.strTrainmanName := ADOQuery.FieldByName('strTrainmanName2').AsString;
  TrainmanPlan.Group.Trainman2.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber2').AsString;
  if (ADOQuery.FieldByName('EndworkTime2').asString <> '') then
  begin
    TrainmanPlan.Group.dtLastEndworkTime2 :=  ADOQuery.FieldByName('EndworkTime2').AsDateTime;
  end;

  TrainmanPlan.Group.Trainman3.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID3').AsString;
  TrainmanPlan.Group.Trainman3.strTrainmanName := ADOQuery.FieldByName('strTrainmanName3').AsString;
  TrainmanPlan.Group.Trainman3.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber3').AsString;
  if (ADOQuery.FieldByName('EndworkTime3').asString <> '') then
  begin
    TrainmanPlan.Group.dtLastEndworkTime3 :=  ADOQuery.FieldByName('EndworkTime3').AsDateTime;
  end;

  TrainmanPlan.Group.Trainman4.strTrainmanGUID := ADOQuery.FieldByName('strTrainmanGUID4').AsString;
  TrainmanPlan.Group.Trainman4.strTrainmanName := ADOQuery.FieldByName('strTrainmanName4').AsString;
  TrainmanPlan.Group.Trainman4.strTrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber4').AsString;
  if (ADOQuery.FieldByName('EndworkTime4').asString <> '') then
  begin
    TrainmanPlan.Group.dtLastEndworkTime4 :=  ADOQuery.FieldByName('EndworkTime4').AsDateTime;
  end;
end;

function TRsDBTrainPlan.CanCanlePlan(PlanGUIDs: TStrings;
  var strError: string): Boolean;
var
  trainmanPlan: RRsTrainmanPlan;
  I: Integer;
  subGUIDS: TStrings;
begin
  Result := False;

  for I := 0 to PlanGUIDs.Count - 1 do
  begin
    if not GetTrainmanPlan(PlanGUIDs[i], trainmanPlan) then
    begin
      strError := '已有计划已被删除，请刷新后重试';
      Exit;
    end;

    if trainmanPlan.Group.strGroupGUID <> '' then
    begin
      strError := '不能撤销已经安排人员的计划！';
      Exit;
    end;
  end;
  subGUIDS := TStringList.Create;
  try
    GetSubPlans(PlanGUIDs,subGUIDS);

    for I := 0 to subGUIDS.Count - 1 do
    begin
      if not GetTrainmanPlan(subGUIDS[i], trainmanPlan) then
      begin
        Continue;
      end;
      if trainmanPlan.Group.strGroupGUID <> '' then
      begin
        strError := '附加计划已安排人员,不能撤销计划!';
        Exit;
      end;
    end;
  finally
    subGUIDS.Free;
  end;

  Result := True;
end;

function TRsDBTrainPlan.CancelPlan(PlanGUIDs: TStrings;SiteGUID:String;DutyUserGUID:string): boolean;
begin
  Result := CancleRelativePlan(PlanGUIDs,SiteGUID,DutyUserGUID);
end;


function TRsDBTrainPlan.CancleRelativePlan(PlanGUIDs: TStrings; SiteGUID,
  DutyUserGUID: string): Boolean;
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
  subGUIDS: TStrings;
begin
  Result := false;
  subGUIDS := TStringList.Create;
  try
    GetSubPlans(PlanGUIDs,subGUIDS);

    for I := 0 to subGUIDS.Count - 1 do
    begin
      PlanGUIDs.Add(subGUIDS.Strings[i]);
    end;

  finally
    subGUIDS.Free;
  end;

  
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psCancel),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'insert into TAB_Plan_Cancel (strTrainPlanGUID,dtCancelTime,strCancelDutyGUID,strFlowSiteGUID) values (%s,getdate(),%s,%s)';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;

          if execsql = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;

          strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strTrainPlanGUID = %s';
          strSql := Format(strSql,[QuotedStr(''),QuotedStr(PlanGUIDS[i])]);
          SQL.Text := strSql;
          ExecSql;
        end;
        m_ADOConnection.CommitTrans;
        result := true;
      except on e : exception do
        begin
          m_ADOConnection.RollbackTrans;
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.ClearTrainmanPlanError(GroupGUID: string);
var
  strSql,strGroupGUID,strTrainPlanGUID,strTemp : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from TAB_Nameplate_Group where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('未找到该人员所在的机组信息');
        exit;
      end;
      if FieldByName('strTrainPlanGUID').AsString = '' then
      begin
        raise Exception.Create('该人员所在机组当前未值乘计划，不用清理');
        exit;
      end;
      strGroupGUID  :=  FieldByName('strGroupGUID').AsString;
      strTrainPlanGUID  :=  FieldByName('strTrainPlanGUID').AsString;
      strSql := 'select top 1 * from VIEW_Plan_Trainman where strGroupGUID = %s and strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(strGroupGUID),QuotedStr(strTrainPlanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        strTemp := '该人员正在值乘计划,请先撤出该计划:%s[%s]';
        strTemp := Format(strTemp,[FormatDateTime('yyyy-MM-dd HH:nn:ss',FieldByName('dtStartTime').asDateTime)
          ,QuotedStr(FieldByName('strTrainNo').AsString)]);
        raise Exception.Create(strTemp);
        exit;
      end;
      strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(''),QuotedStr(strGroupGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;  
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.Delete(TrainPlanGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'delete from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.DeleteTrainmanFromPlan(TrainmanPlanGUID: string;
  TrainmanIndex: integer);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      if trainmanIndex = 1 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID1=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      if trainmanIndex = 2 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID2=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      if trainmanIndex = 3 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID3=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      if trainmanIndex = 4 then
      begin
        strSql := 'update TAB_Plan_Trainman set strTrainmanGUID4=%s where strTrainPlanGUID=%s';
        strSql := Format(strSql,[QuotedStr(''),QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      strSql := 'delete from tab_plan_trainman where strTrainPlanGUID = %s and (strTrainmanGUID1 is null or strTrainmanGUID1=%s) ' +
        ' and (strTrainmanGUID1 is null or strTrainmanGUID1=%s) and (strTrainmanGUID1 is null or strTrainmanGUID1=%s)';
      strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID),QuotedStr(''),QuotedStr(''),QuotedStr('')]);
      SQL.Text := strSql;
      if ExecSQL > 0 then
      begin
        strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = null where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.EqualTrainmanPlan(Source,
  Dest: TRsTrainmanPlanArray): boolean;
var
  i: Integer;
begin
  result := false;
  if length(Source) <> length(dest) then exit;
  for i := 0 to length(Source) - 1 do
  begin
    if Source[i].TrainPlan.strTrainPlanGUID <> Dest[i].TrainPlan.strTrainPlanGUID then exit;
    if Source[i].TrainPlan.strTrainTypeName <> Dest[i].TrainPlan.strTrainTypeName then exit;
    if Source[i].TrainPlan.strTrainNumber <> Dest[i].TrainPlan.strTrainNumber then exit;
    if Source[i].TrainPlan.strTrainNo <> Dest[i].TrainPlan.strTrainNo then exit;
    if Source[i].TrainPlan.dtStartTime <> Dest[i].TrainPlan.dtStartTime then exit;
    if Source[i].TrainPlan.dtRealStartTime <> Dest[i].TrainPlan.dtRealStartTime then exit;
    if Source[i].TrainPlan.strTrainJiaoluGUID <> Dest[i].TrainPlan.strTrainJiaoluGUID then exit;
    if Source[i].TrainPlan.strTrainJiaoluName <> Dest[i].TrainPlan.strTrainJiaoluName then exit;
    if Source[i].TrainPlan.strStartStation <> Dest[i].TrainPlan.strStartStation then exit;
    if Source[i].TrainPlan.strStartStationName <> Dest[i].TrainPlan.strStartStationName then exit;
    if Source[i].TrainPlan.strEndStation <> Dest[i].TrainPlan.strEndStation then exit;
    if Source[i].TrainPlan.strEndStationName <> Dest[i].TrainPlan.strEndStationName then exit;
    if Source[i].TrainPlan.nTrainmanTypeID <> Dest[i].TrainPlan.nTrainmanTypeID then exit;
    if Source[i].TrainPlan.nPlanType <> Dest[i].TrainPlan.nPlanType then exit;
    if Source[i].TrainPlan.nDragType <> Dest[i].TrainPlan.nDragType then exit;
    if Source[i].TrainPlan.nKeHuoID <> Dest[i].TrainPlan.nKeHuoID then exit;
    if Source[i].TrainPlan.nRemarkType <> Dest[i].TrainPlan.nRemarkType then exit;
    if Source[i].TrainPlan.strRemark <> Dest[i].TrainPlan.strRemark then exit;
    if Source[i].TrainPlan.nPlanState <> Dest[i].TrainPlan.nPlanState then exit;
    if Source[i].TrainPlan.strPlanStateName <> Dest[i].TrainPlan.strPlanStateName then exit;

    if Source[i].dtBeginWorkTime <> Dest[i].dtBeginWorkTime then exit;

    if Source[i].Group.Trainman1.strTrainmanGUID <> Dest[i].Group.Trainman1.strTrainmanGUID then exit;
    if Source[i].Group.Trainman2.strTrainmanGUID <> Dest[i].Group.Trainman2.strTrainmanGUID then exit;
    if Source[i].Group.Trainman3.strTrainmanGUID <> Dest[i].Group.Trainman3.strTrainmanGUID then exit;
    if Source[i].Group.Trainman4.strTrainmanGUID <> Dest[i].Group.Trainman4.strTrainmanGUID then exit;

    if Source[i].RestInfo.nNeedRest <> Dest[i].RestInfo.nNeedRest then exit;
    if Source[i].RestInfo.dtArriveTime <> Dest[i].RestInfo.dtArriveTime then exit;
    if Source[i].RestInfo.dtCallTime <> Dest[i].RestInfo.dtCallTime then exit;
  end;
  result := true;
end;

function TRsDBTrainPlan.GetJiMingGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_Named ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s)) and ' +
                //--机车车号与计划的车型车号相同
                ' ((strCheCi1) = %s) and ' +
                //--没有安排计划的机组
                ' (select count(*) from dbo.VIEW_Nameplate_Group ' +
                '           where strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_Named.strGroupGUID and  ( strTrainPlanGUID = '''' or strTrainPlanGUID is null ) )> 0 ' +
                ' ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        QuotedStr(TrainPlan.strTrainNo),
        Ord(psEndWork)
        ]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetLunChengGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 nTrainmanRunType from TAB_Base_TrainmanJiaolu where strTrainmanJiaouGUID = %s';     

      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_Order ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s and ' +
                ' nKehuoID = %d and nTrainmanTypeID = %d and nDragTypeID = %d)) and ' +
                ' ((strBeginStationGUID = %s and strEndStationGUID = %s) or (strStationGUID=%s)) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where   ' +
                ' strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_Order.strGroupGUID and nPlanState < %d) = 0 ' +
                ' order by nOrder ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        Ord(TrainPlan.nKeHuoID),Ord(TrainPlan.nTrainmanTypeID),Ord(TrainPlan.nDragType),
        QuotedStr(TrainPlan.strStartStation),QuotedStr(TrainPlan.strEndStation), QuotedStr(TrainPlan.strStartStation),
        Ord(psEndWork)
        ]);
        
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetBaoChengGroup(TrainJiaoluGUID: string;
  TrainPlan: RRsTrainPlan; out Group: RRsGroup): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select top 1 * from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
                ' where ' +
                //--人员交路在指定的行车区段内
                ' (strTrainmanJiaoluGUID in (select strTrainmanjiaoluGUID from VIEW_Base_JiaoluRelation where strTrainJiaoluGUID = %s)) and ' +
                //--机车车号与计划的车型车号相同
                ' ((strTrainTypeName + ''-'' + strTrainNumber) = %s) and ' +
                //--没有安排计划的机组
                ' (select count(*) from VIEW_Plan_Trainman ' +
                '           where strGroupGUID = VIEW_Nameplate_TrainmanJiaolu_TogetherTrain.strGroupGUID and nPlanState < %d) = 0 ' +
                ' order by nOrder ';
      strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),
        QuotedStr(TrainPlan.strTrainTypeName + '-' + TrainPlan.strTrainNumber),
        Ord(psEndWork)
        ]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(ADOQuery,group);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChangeTrainPlanLog(TrainPlanGUID: string;out TrainPlanChangeLogList:TRsTrainPlanChangeLogArray): Boolean;
var
  ADOQuery:TADOQuery;
  strSql:string;
  i:Integer;
begin
  Result := False ;
  i := 0 ;
  ADOQuery := NewADOQuery;
  try
    strSql := Format('select * from TAB_Plan_ChangeLog where strTrainPlanGUID =  ''%s'' ORDER BY dtChangeTime DESC',
      [TrainPlanGUID]);
    with ADOQuery do
    begin
      SQL.Text := strSql ;
      Open;
      if ADOQuery.IsEmpty then
        Exit;
      SetLength(TrainPlanChangeLogList,ADOQuery.RecordCount);
      while not ADOQuery.Eof do
      begin
        ADOQueryToTrainPlanChangeLog(ADOQuery,TrainPlanChangeLogList[i]);
        Inc(i);
        ADOQuery.Next;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinDiDian(StationGUID: string;
  out CQDD: RRsChuQinDiDian) : boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Base_ChuQinDiDian where strStationGUID = %s';
      strSql := Format(strSql,[QuotedStr(StationGUID)]);
      sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToChuQinDiDian(ADOQuery,CQDD);
      result := true;    
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetChuQinSetInfo(TrainPlan: RRsTrainPlan;
  Trainman: RRsTrainman; out ChuQinTime: TDateTime; out Rest: RRsRest) : boolean;
var
  cqdd : RRsChuQinDiDian;
  restDate : TDateTime;
begin
  result := false;
  if not GetChuQinDiDian(TrainPlan.strStartStation,cqdd) then exit;
  if TrainPlan.nRemarkType = prtZhanJie then
    ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nZJPre*-1)
  else begin
    if cqdd.strWorkShopGUID = Trainman.strWorkShopGUID then
      ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nLocalPre*-1)
    else
      ChuQinTime :=  IncMinute(TrainPlan.dtRealStartTime,CQDD.nOutPre*-1)
  end;
  restDate := DateOf(TrainPlan.dtRealStartTime);
  if CQDD.dtCallTime >= TimeOf(TrainPlan.dtRealStartTime) then
    restDate := IncDay(restDate,-1);

  Rest.nNeedRest := cqdd.bIsRest;
  Rest.dtArriveTime := restDate + cqdd.dtRestTime;
  Rest.dtCallTime := restDate + cqdd.dtCallTime;
  result := true;
end;

procedure TRsDBTrainPlan.GetPBTrainmanPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUIDS: TStrings; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i,j : integer;
  strTemp1,strTemp2,strTemp:string;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 5 * from VIEW_Plan_Trainman where  (dtStartTime >=%s or '
    + '(dtStartTime <= 36524)) and dtStartTime <= %s  and nPlanState >= ' + IntToStr(Ord(psPublish));
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime))]);

  for j := 0 to TrainJiaoluGUIDS.Count - 1 do
  begin
    strTemp1 := Format(' %s ',[ QuotedStr(TrainJiaoluGUIDS.Strings[j]) ]);
    if ( j <> TrainJiaoluGUIDS.Count - 1 ) then
      strTemp2 := strTemp1 + ' , '
    else
      strTemp2 := strTemp1 ;
    strTemp := strTemp + strTemp2 ;
  end;

  if strTemp <> '' then
    strSql := strSql + 'and strTrainJiaoluGUID  in ( '+ strTemp + ' ) ' ;

  strSql := strSql + ' order by nPlanState,dtbeginworkTime desc,dtStartTime';
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlan(TrainPlanGUID : string;var TrainPlan : RRsTrainPlan) : boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainPlan(adoQuery,TrainPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanByTrainmanNumber(TrainmanNumber : string;SubmitTime :TDateTime;
      out TrainPlan : RRsTrainPlan;out TrainmanIndex : integer): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  //获取计划信息
  strSql := 'select top 1 * from VIEW_Plan_Trainman ' +
    ' where %s >= dateAdd(n,-120,dtStartTime) and %s<=dateAdd(hh,50,dtStartTime) and nPlanState >= 4 ' +
    '  and  ((strTrainmanNumber1 = %s) or (strTrainmanNumber2 = %s)) order by dtStartTime desc ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToTrainPlan(adoQuery,TrainPlan);
        if FieldByName('strTrainmanNumber1').AsString = TrainmanNumber then
          TrainmanIndex := 1;
        if FieldByName('strTrainmanNumber2').AsString = TrainmanNumber then
          TrainmanIndex := 2;
        if FieldByName('strTrainmanNumber3').AsString = TrainmanNumber then
          TrainmanIndex := 3;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetPlanByTrainmanNumberBeh(TrainmanNumber: string;
  SubmitTime: TDateTime; out TrainPlan: RRsTrainPlan;
  out TrainmanIndex: integer): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
  //logMang : TLogManage;
begin
  result := false;
  //logMang := TLogManage.Create;
  try
    //logMang.FileNamePath := 'c:\';
    //获取计划信息
    strSql := 'select top 1 * from VIEW_Plan_Trainman ' +
      ' where %s > dtStartTime and %s < dtStartTime and nPlanState >= 4 ' +
      '  and  ((strTrainmanNumber1 = %s) or (strTrainmanNumber2 = %s) or (strTrainmanNumber3 = %s) or (strTrainmanNumber4 = %s)) order by dtStartTime desc ';
    strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',IncDay(SubmitTime,-3))),
      QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;
        Sql.Text := strSql;
        //logMang.InsertLog(strSql);
        Open;
        //logMang.InsertLog(IntToStr(RecordCount));
        if RecordCount > 0 then
        begin
          ADOQueryToTrainPlan(adoQuery,TrainPlan);
          if FieldByName('strTrainmanNumber1').AsString = TrainmanNumber then
            TrainmanIndex := 1;
          if FieldByName('strTrainmanNumber2').AsString = TrainmanNumber then
            TrainmanIndex := 2;
          if FieldByName('strTrainmanNumber3').AsString = TrainmanNumber then
            TrainmanIndex := 3;
          result := true;
        end;
      end;
    finally
      adoQuery.Free;
    end;
  finally
    //logMang.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanByTrainmanNumberPre(TrainmanNumber: string;
  SubmitTime: TDateTime; out TrainPlan: RRsTrainPlan;
  out TrainmanIndex: integer): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  //获取计划信息
  strSql := 'select top 1 * from VIEW_Plan_Trainman ' +
    ' where dateAdd(n,120,%s) >= dtStartTime and dateAdd(hh,-2,%s)<=dtStartTime and nPlanState >= 4 ' +
    '  and  ((strTrainmanNumber1 = %s) or (strTrainmanNumber2 = %s) or (strTrainmanNumber3 = %s) or (strTrainmanNumber4 = %s)) order by dtStartTime desc ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',SubmitTime)),
    QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        ADOQueryToTrainPlan(adoQuery,TrainPlan);
        if FieldByName('strTrainmanNumber1').AsString = TrainmanNumber then
          TrainmanIndex := 1;
        if FieldByName('strTrainmanNumber2').AsString = TrainmanNumber then
          TrainmanIndex := 2;
        if FieldByName('strTrainmanNumber3').AsString = TrainmanNumber then
          TrainmanIndex := 3;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanOfGroup(GroupGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from TAB_Nameplate_Group where strGroupGUID = %s)';
  strSql := Format(strSql,[QuotedStr(GroupGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetPlanOfTrain(TrainGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain where strTrainGUID = %s)';
  strSql := Format(strSql,[QuotedStr(TrainGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetPlanOfTrainman(TrainmanGUID: string;
  out TrainmanPlan: RRsTrainmanPlan): boolean;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  Result := false;
  if TrainmanGUID = '' then exit;
  
  strSql := 'Select * from VIEW_Plan_Trainman where  ' +
    ' strTrainPlanGUID in (select strTrainPlanGUID from TAB_Nameplate_Group ' +
    ' where strTrainmanGUID1 = %s or strTrainmanGUID2=%s or strTrainmanGUID3 = %s or strTrainmanGUID4 = %s)';
  strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        exit;
      end;
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      Result := true;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TRsDBTrainPlan.GetPlanTimes(RemakType:Integer; PlaceID: string;
  var ATime: Integer): Boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := False ;
  adoQuery := NewADOQuery ;
  try
    strSql := Format('select nMinute from Tab_Base_ChuQinTimeRule where nRemarkType = %d and strPlaceID = %s',
      [RemakType,QuotedStr(PlaceID)]);
    adoQuery.SQL.Text := strSql ;
    adoQuery.Open ;
    if adoQuery.IsEmpty then
      Exit;
    ATime := adoQuery.FieldByName('nMinute').AsInteger ;
    Result := True ;
  finally
    adoQuery.Free ;
  end;
end;

procedure TRsDBTrainPlan.GetSendLog(SiteGUID: string; LastTime: TDateTime;
  out SendLogArray: TRsTrainPlanSendLogArray);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from tab_plan_send  tsend where (dtSendTime > %s) and ' +
    ' (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ' +
    ' or strTrainJiaoluGUID in (select strSubTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s))) ' +
    ' and ' +
	  ' (dtSendTime = (select max(dtSendTime) from tab_plan_send where strTrainPlanGUID=tsend.strTrainPlanGUID)) ' +
    ' order by dtSendTime';
  strSql := Format(strSql,[
    QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',LastTime)),
    QuotedStr(SiteGUID),QuotedStr(SiteGUID)
    ]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;

      SetLength(SendLogArray,0);
      while not eof do
      begin
        if FieldByName('bIsRec').AsInteger = 0 then
        begin
          SetLength(SendLogArray,length(SendLogArray) + 1);
          ADOQueryToSendLog(adoQuery,SendLogArray[length(SendLogArray) - 1]);
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetSendLog(SiteGUID: string; PlanGUIDS: TStringList;
  out SendLogArray: TRsTrainPlanSendLogArray);
var
  strSql : string;
  adoQuery : TADOQuery;
  strPlanGUIDS: string;
  i: Integer;
begin
  strPlanGUIDS := '';
  for I := 0 to PlanGUIDS.Count - 1 do
  begin
    if strPlanGUIDS = '' then
      strPlanGUIDS := QuotedStr(PlanGUIDS[i])
    else
      strPlanGUIDS := strPlanGUIDS + ',' + QuotedStr(PlanGUIDS[i]);
  end;
    
  strSql := 'select * from tab_plan_send  tsend where ' +
    ' (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s)) and ' +
	  ' (strTrainPlanGUID in (%s) ) order by dtSendTime';
  strSql := Format(strSql,[QuotedStr(SiteGUID),strPlanGUIDS]);

  SetLength(SendLogArray,0);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;

      SetLength(SendLogArray,0);
      while not eof do
      begin
        if FieldByName('bIsRec').AsInteger = 0 then
        begin
          SetLength(SendLogArray,length(SendLogArray) + 1);
          ADOQueryToSendLog(adoQuery,SendLogArray[length(SendLogArray) - 1]);
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;


procedure TRsDBTrainPlan.GetSentTrainmanPlans(BeginTime, EndTime: TDateTime;SiteGUID : string;
  TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where ' +
  ' ((dtStartTime >=%s ) or (dtStartTime <= 36524)) and not nPlanState in (%d,%d)';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    Ord(psCancel),Ord(psEdit)]);
  if TrainJiaoluGUID <> '' then
  begin
    strSql := strSql + ' and (strTrainJiaoluGUID = %s or strTrainJiaoluGUID in (select strSubTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID = %s))';
    strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),QuotedStr(TrainJiaoluGUID)]);  
  end
  else begin
    strSql + ' and (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ) ';
    strSql := Format(strSql,[QuotedStr(SiteGUID)]);
  end;

  strSql := strSql + ' order by dtStartTime,nID Desc ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetSubPlans(PlanGUIDs, SubPlanGUIDs: TStrings);
var
  adoQuery : TADOQuery;
  I: Integer;
  strGUIDs: string;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);
  SubPlanGUIDs.Clear;
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := 'select strTrainPlanGUID from TAB_Plan_Train where '
      + 'nPlanState > '+ IntToStr(Ord(psCancel)) + ' and strMainPlanGUID in ' + strGUIDS;
    adoQuery.Open();

    while not  adoQuery.Eof do
    begin
      SubPlanGUIDs.Add(adoQuery.FieldByName('strTrainPlanGUID').AsString);
      adoQuery.Next;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.LoadTrainPlan(BeginDateTime,EndDateTime : TDateTime;
      TrainJiaoluGUID,DutyUserGUID,SiteGUID  :string;PlanState : TRsPlanState);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'exec PROC_LoadTrainNo %s,%s,%s,%s,%s,%d';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginDateTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndDateTime)),
      QuotedStr(TrainJiaoluGUID),
      QuotedStr(DutyUserGUID),
      QuotedStr(SiteGUID),Ord(PlanState)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.LoadTrainPlanByPaiBan(BeginDateTime,
  EndDateTime: TDateTime; TrainJiaoluGUID, DutyUserGUID, SiteGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'exec PROC_LoadTrainNo %s,%s,%s,%s,%s';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginDateTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndDateTime)),
      QuotedStr(TrainJiaoluGUID),
      QuotedStr(DutyUserGUID),
      QuotedStr(SiteGUID)]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoquery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.PublishPlan(PlanGUIDs: TStrings;SiteGUID,DutyUserGUID: string);
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psPublish),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'PROC_Plan_AddPublishRecord %s,%s,%s';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;
          if execsql = 0 then
          begin
            exit;
          end;
        end;
        m_ADOConnection.CommitTrans;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.ReceivePlan(PlanGUIDs : TStrings;SiteGUID,DutyUserGUID  : string);
var
  i : integer;
  strSql,strGUIDs,siteName,dutyUserName,dutyUserID : string;
  adoQuery : TADOQuery;
begin
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := ' select strSiteName from TAB_Base_Site where strSiteGUID=%s';
      strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('本客户端信息没有登记！');
        exit;
      end;
      siteName := FieldByName('strSiteName').AsString;

      strSql := ' select strDutyName,strDutyNumber from TAB_Org_DutyUser where strDutyGUID=%s';
      strSql := Format(strSql,[QuotedStr(DutyUserGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        raise Exception.Create('当前登录用户没有登记！');
        exit;
      end;
      dutyUserName := FieldByName('strDutyName').AsString;
      dutyUserID   := FieldByName('strDutyNumber').AsString;

      strSql := 'update tab_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s and nPlanState = %d';
      strSql := Format(strSql,[Ord(psReceive),strGUIDs,Ord(psSent)]);
      SQL.Text := strSql;
      ExecSQL;

      strSql := ' update tab_plan_send set bIsRec = 1,dtRecTime = getdate(),strRecSiteGUID=%s, ' +
       ' strRecSiteName=%s,strRecUserGUID=%s,strRecUserName=%s,strRecUserID=%s ' +
       ' where strTrainPlanGUID in %s and  ' +
 	     ' (dtSendTime = (select max(dtSendTime) from tab_plan_send tSend where tSend.strTrainPlanGUID=tab_plan_send.strTrainPlanGUID) and bIsRec = 0) ';

      strSql := Format(strSql,[
        QuotedStr(SiteGUID),
        QuotedStr(siteName),
        QuotedStr(DutyUserGUID),
        QuotedStr(dutyUserName),
        QuotedStr(dutyUserID),
        strGUIDs
        ]);
      SQL.Text := strSql;
      ExecSQL;

    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.RefreshTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where strTrainplanGUID = %s';
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := Format(strSql,[QuotedStr(TrainmanPlan.TrainPlan.strTrainPlanGUID)]);

      Open;
      if adoQuery.RecordCount > 0 then
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.RemoveBeginWorkRecord(strTrainmanGUID,
  strTrainPlanGUID: string);
var
  ADOQuery: TADOQuery;
  strBeginWorkGUID: string;
begin
  ADOQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := m_ADOConnection;
  m_ADOConnection.BeginTrans;
  try
    try
      ADOQuery.SQL.Text := 'Update TAB_System_Lock set nLock = -nLock';
      ADOQuery.ExecSQL;

      ADOQuery.SQL.Text := 'Select * from TAB_Plan_BeginWork where strTrainPlanGUID = '
        + QuotedStr(strTrainPlanGUID) + ' and strTrainmanGUID = ' + QuotedStr(strTrainmanGUID);
      ADOQuery.Open();

      if ADOQuery.RecordCount = 0 then
        raise Exception.Create('未找到出勤记录!');

      strBeginWorkGUID := ADOQuery.FieldByName('strBeginWorkGUID').AsString;


      //删除测酒记录
      ADOQuery.SQL.Text := 'delete from TAB_Drink_Information where strWorkID = '
        + QuotedStr(strBeginWorkGUID);

      ADOQuery.ExecSQL;

      ADOQuery.SQL.Text :=
      'update TAB_Plan_Train Set nPlanState = %d where ' +
        'nPlanState = %d and strTrainPlanGUID = %s ';

      ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[Ord(psPublish),Ord(psBeginWork),
      QuotedStr(strTrainPlanGUID)]);
      ADOQuery.ExecSQL;

      ADOQuery.SQL.Text := 'delete from TAB_Plan_BeginWork where strBeginWorkGUID = '
        + QuotedStr(strBeginWorkGUID);
      ADOQuery.ExecSQL;

      m_ADOConnection.CommitTrans;
    except
      on E: Exception do
      begin
        m_ADOConnection.RollbackTrans;
        raise Exception.Create(E.Message);
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBTrainPlan.SendPlan(PlanGUIDS: TStrings;SiteGUID:String;DutyUserGUID:string): boolean;
var
  i : integer;
  strSql,strGUIDs : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  for i := 0 to planGUIDS.Count - 1 do
  begin
    if strGUIDs = '' then
      strGUIDs := QuotedStr(planGUIDs[i])
    else
      strGUIDs := strGUIDs + ',' + QuotedStr(planGUIDs[i]);
  end;
  strGUIDS := Format('(%s)',[strGUIDs]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID in %s';
        strSql := Format(strSql,[Ord(psSent),strGUIDs]);
        SQL.Text := strSql;
        if execsql = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          exit;
        end;
        for i := 0 to PlanGUIDS.Count - 1 do
        begin
          strSql := 'PROC_Plan_AddSendRecord %s,%s,%s';
          strSql := Format(strSql,[QuotedStr(PlanGUIDS[i]),QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);
          SQL.Text := strSql;
          if execsql = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;
        end;
        m_ADOConnection.CommitTrans;
        result := true;
      except on  e : exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise exception.Create(e.Message);
        end;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.SetGroupToPlan(Group: RRsGroup; TrainPlan: RRsTrainPlan;
  DutyUserGUID,DutySiteGUID  : string);
var
  strSql : string;
  dtChuQinTime : TDateTime;
  rest : RRsRest ;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;

       //修改当前机组值乘计划信息
      strSql := 'delete from TAB_Plan_Trainman where strTrainPlanGUID = %s';
//      strSql := Format(strSql,[QuotedStr(Group.strTrainPlanGUID)]);
      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);

      SQL.Text := strSql;
      ExecSQL;
      //根据出勤地点设置获取计划中的出勤时间、侯班信息的缺省信息
      if GetChuQinSetInfo(TrainPlan,Group.Trainman1,dtChuQinTime,rest) then 
      begin
        strSql := 'update TAB_Plan_Train set ' +
          ' nTrainmanTypeID = (select top 1 nTrainmanTypeID from VIEW_Nameplate_Group where strGroupGUID = %s), ' +
          ' dtChuQinTime = %s,nNeedRest=%d,dtArriveTime=%s,dtCallTime=%s where strTrainPlanGUID = %s';
        strSql := Format(strSql,
          [
          QuotedStr(Group.strGroupGUID),
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtChuQinTime)),
          Rest.nNeedRest,
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',Rest.dtArriveTime)),
          QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',Rest.dtCallTime)),
          QuotedStr(TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;  
      end else begin
        strSql := 'update TAB_Plan_Train set ' +
          ' nTrainmanTypeID = (select top 1 nTrainmanTypeID from VIEW_Nameplate_Group where strGroupGUID = %s) where strTrainPlanGUID = %s';
        strSql := Format(strSql,[QuotedStr(Group.strGroupGUID),QuotedStr(TrainPlan.strTrainPlanGUID)]);
        SQL.Text := strSql;
        ExecSQL;
      end;
      //修改人员信息
      strSql := 'select * from TAB_Plan_Trainman where strTrainPlanGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        Append;
      end
      else begin
        Edit;
      end;
      FieldByName('strTrainPlanGUID').AsString := TrainPlan.strTrainPlanGUID;
      FieldByName('strTrainmanGUID1').AsString := Group.Trainman1.strTrainmanGUID;
      FieldByName('strTrainmanGUID2').AsString := Group.Trainman2.strTrainmanGUID;
      FieldByName('strTrainmanGUID3').AsString := Group.Trainman3.strTrainmanGUID;
      FieldByName('strTrainmanGUID4').AsString := Group.Trainman4.strTrainmanGUID;
      FieldByName('strGroupGUID').AsString := Group.strGroupGUID;
      FieldByName('strDutyGUID').AsString := DutyUserGUID;
      FieldByName('strDutySiteGUID').AsString := DutySiteGUID;
      Post;
      //修改当前机组值乘计划信息
      strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = %s where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID),
        QuotedStr(Group.strGroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;  
end;
      
function TRsDBTrainPlan.SetPlanRest(strPlanGUID: string; RestInfo: RRsRest;
  DutyUser: TRsDutyUser; SiteInfo: TRsSiteInfo): boolean;
var
  qry:TADOQuery;
begin
  result := False;
  qry := NewADOQuery();
  try
    qry.SQL.Text := 'select * from TAB_Plan_Train where strTrainPlanGUID = :strTrainPlanGUID';
    qry.Parameters.ParamByName('strTrainPlanGUID').Value := strPlanGUID;
    qry.Open;
    if qry.RecordCount = 0 then Exit;
    qry.Edit;
    qry.FieldByName('nNeedRest').Value := RestInfo.nNeedRest;
    qry.FieldByName('dtArriveTime').Value := RestInfo.dtArriveTime;
    qry.FieldByName('dtCallTime').Value := RestInfo.dtCallTime;
    qry.Post;
    result := True;
  finally
    qry.Free;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToTrainPlan(ADOQuery: TADOQuery; out TrainPlan :  RRsTrainPlan);
begin
  with ADOQuery do
  begin
    TrainPlan.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    TrainPlan.strPlaceID := FieldByName('strPlaceID').AsString;
    TrainPlan.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainPlan.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainPlan.strTrainNo := FieldByName('strTrainNo').AsString;
    if not FieldByName('dtStartTime').IsNull then
      TrainPlan.dtStartTime :=  FieldByName('dtStartTime').Value;
    TrainPlan.dtRealStartTime :=  0;
    if not FieldByName('dtRealStartTime').IsNull then
      TrainPlan.dtRealStartTime := FieldByName('dtRealStartTime').Value;
    if not FieldByName('dtRealStartTime').IsNull then
      TrainPlan.dtFirstStartTime := FieldByName('dtRealStartTime').Value;
    TrainPlan.dtChuQinTime := FieldByName('dtChuQinTime').Value ;
    TrainPlan.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainPlan.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainPlan.strStartStation := FieldByName('strStartStation').AsString;
    TrainPlan.strStartStationName := FieldByName('strStartStationName').AsString;
    TrainPlan.strEndStation := FieldByName('strEndStation').AsString;
    TrainPlan.strEndStationName := FieldByName('strEndStationName').AsString;
    TrainPlan.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').AsInteger);
    TrainPlan.nPlanType := TRsPlanType(FieldByName('nPlanType').AsInteger);
    TrainPlan.nDragType := TRsDragType(FieldByName('nDragType').AsInteger);
    TrainPlan.nKeHuoID := TRsKehuo(FieldByName('nKeHuoID').asInteger);
    TrainPlan.nRemarkType := TRsPlanRemarkType(FieldByName('nRemarkType').AsInteger);
    TrainPlan.strRemark := FieldByName('strRemark').AsString;
    TrainPlan.nPlanState := TRsPlanState(FieldByName('nPlanState').AsInteger);
    TrainPlan.dtLastArriveTime := FieldByName('dtLastArriveTime').asdatetime;
    TrainPlan.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
    TrainPlan.strCreateSiteGUID := FieldByName('strCreateSiteGUID').AsString;
    TrainPlan.strCreateUserGUID := FieldByName('strCreateUserGUID').AsString;
    TrainPlan.strMainPlanGUID := FieldByName('strMainPlanGUID').AsString;

    TrainPlan.strTrackNumber := FieldByName('strTrackNumber').AsString;
    TrainPlan.strWaiQinClientGUID := FieldByName('strWaiQinClientGUID').AsString;
    TrainPlan.strWaiQinClientNumber := FieldByName('strWaiQinClientNumber').AsString;
    TrainPlan.strWaiQinClientName := FieldByName('strWaiQinClientName').AsString;

    TrainPlan.dtSendPlanTime := FieldByName('dtSendTime').AsDateTime;
    TrainPlan.dtRecvPlanTime := FieldByName('dtRecvTime').AsDateTime;
  end;
end;

procedure TRsDBTrainPlan.ADOQueryToTrainPlanChangeLog(ADOQuery : TADOQuery;var TrainPlanChangeLog:RRsTrainPlanChangeLog);
begin
  with ADOQuery do
  begin
    TrainPlanChangeLog.strTrainJiaoluName := FieldByName('strTrainJiaoluName').AsString;
    TrainPlanChangeLog.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
    TrainPlanChangeLog.strTrainNumber := FieldByName('strTrainNumber').AsString;
    TrainPlanChangeLog.strTrainNo := FieldByName('strTrainNo').AsString;
    TrainPlanChangeLog.dtStartTime := FieldByName('dtStartTime').asdatetime;
    TrainPlanChangeLog.dtChangeTime := FieldByName('dtChangeTime').asdatetime;
  end;
end;

procedure TRsDBTrainPlan.TrainPlanToADOQuery(ADOQuery: TADOQuery; TrainPlan : RRsTrainPlan; UpdateState : boolean = true);
begin
  with ADOQuery do
  begin
    FieldByName('strTrainPlanGUID').AsString := TrainPlan.strTrainPlanGUID;
    FieldByName('strPlaceID').asstring := TrainPlan.strPlaceID ;
    FieldByName('strTrainTypeName').AsString := TrainPlan.strTrainTypeName;
    FieldByName('strTrainNumber').AsString := TrainPlan.strTrainNumber;
    FieldByName('strTrainNo').AsString := TrainPlan.strTrainNo;
    FieldByName('dtStartTime').AsDateTime := TrainPlan.dtStartTime;
    FieldByName('dtRealStartTime').AsDateTime := TrainPlan.dtRealStartTime;
    FieldByName('dtChuQinTime').AsDateTime := TrainPlan.dtChuQinTime;
    FieldByName('strTrainJiaoluGUID').AsString := TrainPlan.strTrainJiaoluGUID;
    FieldByName('strStartStation').AsString := TrainPlan.strStartStation;
    FieldByName('strEndStation').AsString := TrainPlan.strEndStation;
    FieldByName('nTrainmanTypeID').AsInteger := Ord(TrainPlan.nTrainmanTypeID);
    FieldByName('nPlanType').AsInteger := Ord(TrainPlan.nPlanType);
    FieldByName('nDragType').AsInteger := Ord(TrainPlan.nDragType);
    FieldByName('nKeHuoID').AsInteger := Ord(TrainPlan.nKeHuoID);
    FieldByName('nRemarkType').AsInteger := Ord(TrainPlan.nRemarkType);
    FieldByName('strRemark').AsString := TrainPlan.strRemark;
    if updateState then
      FieldByName('nPlanState').AsInteger := Ord(TrainPlan.nPlanState);
    FieldByName('dtCreateTime').AsDateTime := TrainPlan.dtCreateTime;
    FieldByName('strCreateSiteGUID').AsString := TrainPlan.strCreateSiteGUID;
    FieldByName('strCreateUserGUID').AsString := TrainPlan.strCreateUserGUID;
    FieldByName('strMainPlanGUID').AsString := TrainPlan.strMainPlanGUID;
    FieldByName('strTrackNumber').AsString := TrainPlan.strTrackNumber;
    FieldByName('strWaiQinClientGUID').AsString := TrainPlan.strWaiQinClientGUID;
    FieldByName('strWaiQinClientNumber').AsString := TrainPlan.strWaiQinClientNumber;
    FieldByName('strWaiQinClientName').AsString := TrainPlan.strWaiQinClientName;

    FieldByName('dtSendTime').AsDateTime := TrainPlan.dtSendPlanTime;
    FieldByName('dtRecvTime').AsDateTime := TrainPlan.dtRecvPlanTime;
  end;
end;

procedure TRsDBTrainPlan.TurnPlateNamedToLeft(TrainmanJiaoluGUID: string);
var
  i : integer;
  strSql,strFirstGroupGUID,strPreCheciGUID,strFinalCheciGUID : string;
  adoQuery,adoQueryOrder : TADOQuery;
begin
  strSql :=  'select * from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s order by nCheciOrder';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID)]);
      Sql.Text := strSql;
      Connection := m_ADOConnection;
      Open;
      i := 0;
      while not eof do
      begin
        if i = 0 then
        begin
          strFirstGroupGUID := FieldByName('strGroupGUID').asstring;
        end;
        if (i = RecordCount -1) then
        begin
          strFinalCheciGUID := FieldByName('strCheCiGUID').asstring;
        end;
        if i > 0 then
        begin
          strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
          strSql := Format(strSql,[QuotedStr(FieldByName('strGroupGUID').AsString),QuotedStr(strPreCheciGUID)]);
          adoQueryOrder := TADOQuery.Create(m_ADOConnection);
          adoQueryOrder.Connection := m_ADOConnection;
          adoQueryOrder.SQL.Text := strSql;
          adoQueryOrder.ExecSQL;
        end;
        strPreCheciGUID := FieldByName('strCheCiGUID').asstring;
        Inc(i);
        next;
      end;
    end;

    strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
    strSql := Format(strSql,[QuotedStr(strFirstGroupGUID),QuotedStr(strFinalCheciGUID)]);
    adoQueryOrder := TADOQuery.Create(m_ADOConnection);
    adoQueryOrder.Connection := m_ADOConnection;
    adoQueryOrder.SQL.Text := strSql;
    adoQueryOrder.ExecSQL;
  finally
    adoQuery.Free;
  end;
end;



procedure TRsDBTrainPlan.TurnPlateNamedToRight(TrainmanJiaoluGUID: string);
var
  i : integer;
  strSql,strFirstGroupGUID,strPreCheciGUID,strFinalCheciGUID : string;
  adoQuery,adoQueryOrder : TADOQuery;
begin
  strSql :=  'select * from TAB_Nameplate_TrainmanJiaolu_Named where strTrainmanJiaoluGUID = %s order by nCheciOrder desc';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID)]);
      Sql.Text := strSql;
      Connection := m_ADOConnection;
      Open;
      i := 0;
      while not eof do
      begin
        if i = 0 then
        begin
          strFirstGroupGUID := FieldByName('strGroupGUID').asstring;
        end;
        if (i = RecordCount -1) then
        begin
          strFinalCheciGUID := FieldByName('strCheCiGUID').asstring;
        end;
        if i > 0 then
        begin
          strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
          strSql := Format(strSql,[QuotedStr(FieldByName('strGroupGUID').AsString),QuotedStr(strPreCheciGUID)]);
          adoQueryOrder := TADOQuery.Create(m_ADOConnection);
          adoQueryOrder.Connection := m_ADOConnection;
          adoQueryOrder.SQL.Text := strSql;
          adoQueryOrder.ExecSQL;
        end;
        strPreCheciGUID := FieldByName('strCheCiGUID').asstring;
        Inc(i);
        next;
      end;
    end;

    strSql := 'update TAB_Nameplate_TrainmanJiaolu_Named set strGroupGUID = %s where strCheciGUID = %s';
    strSql := Format(strSql,[QuotedStr(strFirstGroupGUID),QuotedStr(strFinalCheciGUID)]);
    adoQueryOrder := TADOQuery.Create(m_ADOConnection);
    adoQueryOrder.Connection := m_ADOConnection;
    adoQueryOrder.SQL.Text := strSql;
    adoQueryOrder.ExecSQL;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.Update(TrainPlan: RRsTrainPlan;DTNow : Tdatetime;SiteGUID:String;DutyUserGUID:string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  strSql := 'Select * from TAB_Plan_Train where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    m_ADOConnection.BeginTrans;
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      try
        Sql.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Raise Exception.Create('无次计划信息!');
          exit;
        end;      
        Edit;
        //开车前三个小时不能修改初发开车时间
        if IncHour(TrainPlan.dtRealStartTime,3) < dtnow  then
        begin
          TrainPlan.dtFirstStartTime := TrainPlan.dtRealStartTime;
        end;      
        TrainPlanToADOQuery(ADOQuery,TrainPlan,false);
        Post;


        if Ord(TrainPlan.nPlanState) >= Ord(psSent) then
        begin
          Close;

          strSql := 'PROC_Plan_WriteChangeLog %s,%s,%s';;
          SQL.Text := Format(strSql,[QuotedStr(TrainPlan.strTrainPlanGUID),
            QuotedStr(DutyUserGUID),QuotedStr(SiteGUID)]);

          ExecSQL;
        end;
        

      except
        on E: Exception do
        begin
          m_ADOConnection.RollbackTrans;
          raise Exception.Create(E.Message);
        end;
      end;
    end;
    m_ADOConnection.CommitTrans;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.UpdatePlanState(TrainPlanGUID: string);
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    With adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Plan_Train set nPlanState = %d where strTrainPlanGUID = %s and nPlanState = %d' +
        ' and (select count(*) from VIEW_Plan_BeginWork where strTrainPlanGUID = TAB_Plan_Train.strTrainPlanGUID and ' +
          ' ((strTrainmanGUID1 is null or strTrainmanGUID1 = %s or not(dtTestTime1 is null)) ' +
          ' and  (strTrainmanGUID2 is null or  strTrainmanGUID2 = %s or not(dtTestTime2 is null)) ' +
          ' and (strTrainmanGUID3 is null or strTrainmanGUID3 = %s or not(dtTestTime3 is null)) ' +
          ' and (strTrainmanGUID4 is null or strTrainmanGUID4 = %s or not(dtTestTime4 is null)))' +
        ') > 0';
      strSql := Format(strSql,[Ord(psBeginWork),QuotedStr(TrainPlanGUID),Ord(psPublish),
        QuotedStr(''),QuotedStr(''),QuotedStr(''),QuotedStr('')]);
      Sql.Text := strSql;
      ExecSql;
    end; 
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainPlan.GetTrainmanPlan(TrainmanPlanGUID: string;
  var TrainmanPlan: RRsTrainmanPlan): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  result := false;
  strSql := 'select top 1 * from VIEW_Plan_Trainman where strTrainPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(TrainmanPlanGUID)]);

  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then exit;      
      ADOQueryToTrainmanPlan(adoQuery,TrainmanPlan);
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;


procedure TRsDBTrainPlan.GetTrainmanPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where (dtStartTime >=%s or '
    + '(dtStartTime <= 36524))and dtStartTime <= %s and nPlanState <> 0';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime))]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by dtStartTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetTuiQinTrainmanPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUID: string; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Plan_Trainman where dtLastArriveTime >=%s and dtLastArriveTime <=%s  and nPlanState = %d';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime)),Ord(psEndWork)]);
  if TrainJiaoluGUID <> '' then
    strSql := strSql + ' and strTrainJiaoluGUID = ' + QuotedStr(TrainJiaoluGUID);

  strSql := strSql + ' order by dtLastArriveTime ';    
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(TrainmanPlanArray,RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainPlan.GetUnRecvSendLog(JDSiteGUID: string;
  FromTime: TDateTime; out SendLogArray: TRsTrainPlanSendLogArray);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from tab_plan_send  tsend where (dtSendTime <= %s) and ' +
    ' (strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s) ' +
    ' or strTrainJiaoluGUID in (select strSubTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID in' +
    ' (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID=%s))) ' +
    ' and ' +
	  ' (bIsRec = 0) ' +
    ' order by dtSendTime';
  strSql := Format(strSql,[
    QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',FromTime)),
    QuotedStr(JDSiteGUID),QuotedStr(JDSiteGUID)
    ]);
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;

      SetLength(SendLogArray,0);
      while not eof do
      begin
        if FieldByName('bIsRec').AsInteger = 0 then
        begin
          SetLength(SendLogArray,length(SendLogArray) + 1);
          ADOQueryToSendLog(adoQuery,SendLogArray[length(SendLogArray) - 1]);
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainPlan.GetXSTrainmanPlans(BeginTime, EndTime: TDateTime;
  TrainJiaoluGUIDS: TStrings; out TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i,j : integer;
  strTemp1,strTemp2,strTemp:string;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * ' +
    ' from VIEW_Plan_Trainman as p where dtStartTime >=%s and dtStartTime <= %s and nPlanState >= 4';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',EndTime))]);

  for j := 0 to TrainJiaoluGUIDS.Count - 1 do
  begin
    strTemp1 := Format(' %s ',[ QuotedStr(TrainJiaoluGUIDS.Strings[j]) ]);
    if ( j <> TrainJiaoluGUIDS.Count - 1 ) then
      strTemp2 := strTemp1 + ' , '
    else
      strTemp2 := strTemp1 ;
    strTemp := strTemp + strTemp2 ;
  end;

  if strTemp <> '' then
    strSql := strSql + 'and strTrainJiaoluGUID  in ( '+ strTemp + ' ) ' ;

  strSql := strSql + ' order by dtStartTime ';
  ADOQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      adoQuery.Connection := m_ADOConnection;
      adoQuery.SQL.Text := strSql;
      adoQuery.Open;
      i := 0;
      SetLength(TrainmanPlanArray,adoQuery.RecordCount);
      while not eof do
      begin
        ADOQueryToTrainmanPlan(adoQuery,TrainmanPlanArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
