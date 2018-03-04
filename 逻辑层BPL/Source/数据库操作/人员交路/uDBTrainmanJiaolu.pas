unit uDBTrainmanJiaolu;

interface
uses
  Classes,ADODB, uTrainmanJiaolu, uTFSystem, uStation,uAskForLeave,uSaftyEnum,
  uTrainman, uTrainPlan;
type
  //人员交路数据库操作类
  TRsDBTrainmanJiaolu = class(TDBOperate)   
  private
    //将派班信息填充到ADOQuery中
    procedure DispatchHistoryDetailToADOQuery(ADOQuery: TADOQuery; Group: RRsGroup);
    procedure ADOQueryToTrainmanJiaolu(ADOQuery : TADOQuery;out TrainmanJialu : RRsTrainmanJiaolu);
    procedure ADOQueryToGroup(ADOQuery : TADOQuery;out Group: RRsGroup);
  public
    //得到派班相关参数信息
    class procedure GetPlanParam(ADOConn: TADOConnection; WorkShopGUID: string; out PlanParam: RRsPlanParam);
    //得到运安系统中的若干核心时刻配置
    class procedure GetKernelTimeConfig(ADOConn: TADOConnection; out TimeConfig:RRsKernelTimeConfig);
  public
    //增加派班信息
    procedure AddDispatchHistoryDetail(strDispatchHistoryGUID, strTrainmanJiaoluGUID: string; dtAutoSaveTime: TDateTime; GroupArray: TRsGroupArray);
    //自动保存派班信息     
    procedure AutoSaveDispatchHistory(strTrainmanJiaoluGUID, strWorkShopGUID: string; dtAutoSaveTime: TDateTime; GroupArray: TRsGroupArray);
    //获取人员交路的详细信息
    function GetTrainmanJiaolu(TrainmanJiaoluGUID: string;out TrainmanJiaolu : RRsTrainmanJiaolu) : boolean;
    //获取机组所在的人员交路GUID
    function GetTrainmanJiaoluOfGroup(GroupGUID : string ; out TrainmanJiaolu : RRsTrainmanJiaolu) : boolean;
    //获取机车交路下的人员交路信息
    procedure GetTrainmanJiaolusOfTrainJiaolu(TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray;JiaoluType:TRsJiaoluType);overload;
    //获取指定区段内的人员交路信息
    procedure GetTrainmanJiaolusOfTrainJiaolu(SiteGUID : string;
       TrainJiaoluGUID: string;out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);overload;

    procedure GetTrainmanJiaolusOfTrainJiaoluEx(SiteGUID : string;
       TrainJiaoluGUID: string;out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);overload;
    //获取多个人员交路的机组数组、按照时间排序
    procedure GetGroupArrayInTrainmanJiaolus(TrainmanJiaolus : TStrings;
      StationGUID : string; out GroupArray : TRsGroupArray;nJiaoluType : TRsJiaoluType);
    //删除人员
    procedure DeleteTrainman(TrainmanGUID: string);
    //添加人员,TrainmanIndex:1、正司机，2、副司机、，3、学员
    procedure AddTrainman(GroupGUID: string; TrainmanIndex: Integer; TrainmanGUID: string);
    //添加人员交路信息
    procedure AddTrainmanJiaoLuToTrainman(TrainmanGUID: string;TrainmanJiaoLuGUID:string);
    
    //向人员交路中添加机车，是否成功根据TogetherTrain的strTrainGUID是否为空判断，传入时请不要对此属性赋值
    function IsExist(TrainTypeName:string;TrainNumber:string):Boolean;
    //适用于包乘
    procedure AddTrain(TrainmanJiaoluGUID: string; TogetherTrain: RRsTogetherTrain);
    //获取乘务员所在的机组信息
    function GetTrainmanGroup(TrainmanGUID : string;out Group : RRsGroup) : boolean;
    //获取乘务员所在的机组信息，带入寓时间
    function GetTrainmanGroupWithInRoomTime(TrainmanGUID : string;out Group : RRsGroup) : boolean;
    //获取机组信息
    function GetGroupInfo(GroupGUID :string;out Group :RRsGroup) : boolean;
    //从计划中移除机组
    function RemovePlanGroup(TrainPlanGUID : string) : boolean;
    //判断是否能够从计划中移除机组
    function CanRemovePlanGroup(TrainPlanGUID : string) : boolean;
    //判断此人是否在计划出勤中
    function IsBeginWorking(TrainmanGUID : string;TrainPlanGUID  :String):boolean;
    //将乘务员从计划中移除并从机班中移除
    procedure LeaveTrainmanFromPlan(TrainmanGUID : string;TrainmanIndex : integer;TrainPlanGUID : string);
    //将乘务员从计划中删除不改变状态
    procedure DeleteTrainmanFromPlan(TrainmanGUID : string;TrainmanIndex : integer;TrainPlanGUID : string);
    //将人员增加到计划中
    procedure AddTrainmanToPlan(TrainPlanGUID : string;TrainmanIndex: integer;TrainmanGUID: string);
    //获取交路类型
    function GetTrainmanJiaoluType(TrainmanJiaoluGUID: string;out AType :Integer):Boolean;
    //设置机组所属车站
    function SetGroupStation(GroupGUID :string;StationGUID:string):Boolean;
    //获取机组的车站名字
    function GetGroupStaion(GroupGUID :string;out StationGUID:string):Boolean;

    //修改机组的最近退勤时间和计划时间
    function UpdateArriveTime(TrainPlanGUID,GroupGUID: string;
      LastArriveTime: TDateTime): Boolean;
    //修改机组的最近到达时间
    function UpdateLastTime(GroupGUID: string;
      LastArriveTime: TDateTime): Boolean;
  end;
implementation
uses
  SysUtils, DB, Windows,uDBTrainman;
{ TDBTrainmanJiaolu }

procedure TRsDBTrainmanJiaolu.AddTrain(
  TrainmanJiaoluGUID: string; TogetherTrain: RRsTogetherTrain);
var
  strSql: string;
  adoQuery: TADOQuery;
  trainGUID: string;
begin
  strSql := 'insert into TAB_Nameplate_TrainmanJiaolu_Train ' +
    ' (strTrainGUID,strTrainmanJiaoluGUID,strTrainTypeName,strTrainNumber,dtCreateTime) ' +
    ' values (%s,%s,%s,%s,getdate())';
  trainGUID := TogetherTrain.strTrainGUID;
  strSql := Format(strSql, [QuotedStr(trainGUID), QuotedStr(TogetherTrain.strTrainmanJiaoluGUID),
    QuotedStr(TogetherTrain.strTrainTypeName),
      QuotedStr(TogetherTrain.strTrainNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSql;
    adoQuery.ExecSQL;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.AddTrainman(GroupGUID: string; TrainmanIndex: integer;
  TrainmanGUID: string);
var
  strSql,strTrainmanJiaoluGUID,strTrainJiaoluGUID,strWorkShopGUID: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      m_ADOConnection.BeginTrans;
      try
        strSql := 'select strTrainmanJiaoluGUID from VIEW_Nameplate_Group_TrainmanJiaolu where strGroupGUID = ' + QuotedStr(GroupGUID);
        SQL.Text := strSql;
        Open;
        strTrainmanJiaoluGUID := '';
        if (recordCount > 0) then
        begin
          strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
          strSql := 'select strTrainJiaoluGUID,strWorkShopGUID from  VIEW_Base_JiaoluRelation where strTrainmanJiaoluGUID = ' + QuotedStr(strTrainmanJiaoluGUID);
          Sql.Text := strSql;
          Open;
          if (Recordcount > 0) then
          begin
            strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
            strWorkShopGUID := FieldByName('strWorkShopGUID').AsString;
          end;
        end;
        //添加人员
        if TrainmanIndex = 1 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID1=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(TrainmanGUID), QuotedStr(GroupGUID)]);
        end;
        if TrainmanIndex = 2 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID2=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(TrainmanGUID), QuotedStr(GroupGUID)]);
        end;
        if TrainmanIndex = 3 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID3=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(TrainmanGUID), QuotedStr(GroupGUID)]);
        end;
        
        if TrainmanIndex = 4 then
        begin
          strSql := 'update TAB_Nameplate_Group set strTrainmanGUID4=%s where strGroupGUID = %s';
          strSql := Format(strSql, [QuotedStr(TrainmanGUID), QuotedStr(GroupGUID)]);
        end;
  
        SQL.Text := strSql;
        if Execsql = 0 then
        begin
          m_ADOConnection.RollbackTrans;
          exit;
        end;
        if (strTrainJiaoluGUID <> '') then
        begin
          //修改人员状态为非运转状态
          strSql := 'update Tab_Org_Trainman set strTrainJiaoluGUID=%s,strWorkShopGUID=%s,nTrainmanState = %d where strTrainmanGUID = %s';
          strSql := Format(strSql, [QuotedStr(strTrainJiaoluGUID),QuotedStr(strWorkShopGUID),Ord(tsNormal),QuotedStr(TrainmanGUID)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;
        end else begin
          //修改人员状态为非运转状态
          strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s';
          strSql := Format(strSql, [Ord(tsNormal),QuotedStr(TrainmanGUID)]);
          adoQuery.SQL.Text := strSql;
          if adoQuery.ExecSQL = 0 then
          begin
            m_ADOConnection.RollbackTrans;
            exit;
          end;
        end;
        //添加人员的交路信息;
        m_ADOConnection.CommitTrans;
      except on e : exception do
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

procedure TRsDBTrainmanJiaolu.AddTrainmanJiaoLuToTrainman(TrainmanGUID,
  TrainmanJiaoLuGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Org_Trainman set strTrainmanJiaoluGUID  = %s where strTrainmanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoLuGUID),QuotedStr(TrainmanGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.AddTrainmanToPlan(TrainPlanGUID : string;TrainmanIndex: integer;TrainmanGUID: string);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update tab_Plan_Trainman set strTrainmanGUID1 = %s where strTrainPlanGUID = %s ';
      if TrainmanIndex = 2 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID2 = %s where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 3 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID3 = %s where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 4 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID4 = %s where strTrainPlanGUID = %s ';
      end;
      strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.ADOQueryToGroup(ADOQuery: TADOQuery;
  out Group: RRsGroup);
begin
  with ADOQuery do
  begin
    Group.strGroupGUID := FieldByName('strGroupGUID').AsString;
    Group.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
    Group.dtArriveTime := FieldByName('dtLastArriveTime').AsDateTime;

    Group.ZFQJ.strZFQJGUID := FieldByName('strZFQJGUID').AsString;
    Group.ZFQJ.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;    
    Group.ZFQJ.nQuJianIndex := FieldByName('nQuJianIndex').AsInteger;
    Group.ZFQJ.strBeginStationGUID := FieldByName('strBeginStationGUID').AsString;
    Group.ZFQJ.strBeginStationName := FieldByName('strBeginStationName').AsString;
    Group.ZFQJ.strEndStationGUID := FieldByName('strEndStationGUID').AsString;
    Group.ZFQJ.strEndStationName := FieldByName('strEndStationName').AsString;

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

procedure TRsDBTrainmanJiaolu.ADOQueryToTrainmanJiaolu(ADOQuery: TADOQuery;
  out TrainmanJialu: RRsTrainmanJiaolu);
begin
  with ADOQuery do
  begin
    TrainmanJialu.strTrainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
    TrainmanJialu.strTrainmanJiaoluName := FieldByName('strTrainmanJiaoluName').AsString;
    TrainmanJialu.nJiaoluType := TRsJiaoluType(FieldByName('nJiaoluType').asInteger);
//    TrainmanJialu.strLineGUID := FieldByName('strLineGUID').AsString;
//    TrainmanJialu.strTrainJiaoluGUID := FieldByName('strTrainJiaoluGUID').AsString;
    TrainmanJialu.nKehuoID := TRsKehuo(FieldByName('nKehuoID').asInteger);
    TrainmanJialu.nTrainmanTypeID := TRsTrainmanType(FieldByName('nTrainmanTypeID').asInteger);
    TrainmanJialu.nDragTypeID := TRsDragType(FieldByName('nDragTypeID').asInteger);
    TrainmanJialu.nTrainmanRunType := TRsRunType(FieldByName('nTrainmanRunType').asInteger);
  end;
end;

function TRsDBTrainmanJiaolu.CanRemovePlanGroup(TrainPlanGUID: string): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select top 1 * from tab_Plan_Trainman where strTrainPlanGUID = %s '  +
        ' and (select count(*) from tab_Plan_BeginWork where strTrainPlanGUID = %s) > 0';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID),QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      Open;
      Result := RecordCount = 0;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainmanJiaolu.DeleteTrainman(TrainmanGUID: string);
var
  strSql: string;
  adoQuery: TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;

      m_ADOConnection.BeginTrans;
      try
        //修改人员状态为空
        strSql := 'update Tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s';
        strSql := Format(strSql, [Ord(tsReady),QuotedStr(TrainmanGUID)]);
        adoQuery.SQL.Text := strSql;
        ExecSql;

        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID1=%s where strTrainmanGUID1 = %s';
        strSql := Format(strSql, [QuotedStr(''), QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        if (ExecSQL > 0) then
        begin
          m_ADOConnection.CommitTrans;
          exit;
        end;
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID2=%s where strTrainmanGUID2 = %s';
        strSql := Format(strSql, [QuotedStr(''), QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        if (ExecSQL > 0) then
        begin
          m_ADOConnection.CommitTrans;
          exit;
        end;
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID3=%s where strTrainmanGUID3 = %s';
        strSql := Format(strSql, [QuotedStr(''), QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        if (ExecSQL > 0) then
        begin
          m_ADOConnection.CommitTrans;
          exit;
        end;
        strSql := 'update TAB_Nameplate_Group set strTrainmanGUID4=%s where strTrainmanGUID4 = %s';
        strSql := Format(strSql, [QuotedStr(''), QuotedStr(TrainmanGUID)]);
        SQL.Text := strSql;
        if (ExecSQL > 0) then
        begin
          m_ADOConnection.CommitTrans;
          exit;
        end;
        m_ADOConnection.RollbackTrans;
      except on e : exception do
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

procedure TRsDBTrainmanJiaolu.DeleteTrainmanFromPlan(TrainmanGUID: string;
  TrainmanIndex: integer; TrainPlanGUID: string);
var
  strSql,strSqlGroup : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
      strSql := Format(strSql,[Ord(tsNormal),QuotedStr(TrainmanGUID)]);
      Sql.Text := strSql;      
      ExecSQL;

      strSql := 'update tab_Plan_Trainman set strTrainmanGUID1 = null where strTrainPlanGUID = %s ';
      strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID1 = null where strTrainPlanGUID = %s ';
      if TrainmanIndex = 2 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID2 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID2 = null where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 3 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID3 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID3 = null where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 4 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID4 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID4 = null where strTrainPlanGUID = %s ';
      end;
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      ExecSQL;

      strSqlGroup := Format(strSqlGroup,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSqlGroup;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.GetGroupArrayInTrainmanJiaolus(
  TrainmanJiaolus: TStrings;StationGUID : string ;out GroupArray: TRsGroupArray;
  nJiaoluType : TRsJiaoluType);
var
  adoQuery : TADOQuery;
  strSql : string;
  strTrainmanJiaolus : string;
  i : integer;
begin
  for i := 0 to TrainmanJiaolus.Count - 1 do
  begin
    if strTrainmanJiaolus = '' then
      strTrainmanJiaolus := QuotedStr(TrainmanJiaolus[i])
    else
      strTrainmanJiaolus := strTrainmanJiaolus + ',' + QuotedStr(TrainmanJiaolus[i]);
  end;
  if strTrainmanJiaolus = '' then
    strTrainmanJiaolus := Format('(%s)',[QuotedStr(strTrainmanJiaolus)])
  else
    strTrainmanJiaolus := Format('(%s)',[strTrainmanJiaolus]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select *,' +
        ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber1) as InRoomTime1, ' +
     ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber2) as InRoomTime2, ' +
         ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber3) as InRoomTime3, ' +
     ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber4) as InRoomTime4 ' +
        ' from VIEW_Nameplate_Group ' +
        ' where strTrainmanJiaoluGUID in %s order by groupState,(case when year(dtLastArriveTime)=1899  then 1 else 0 end ),dtLastArriveTime';
      strSql := Format(strSql,[strTrainmanJiaolus]);
      if nJiaoluType = jltNamed then
      begin
        strSql := 'select *,' +
        ' (select max(dtInRoomTime) from ' +  
         ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber1) as InRoomTime1, ' +
         ' (select max(dtInRoomTime) from ' +
         ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber2) as InRoomTime2, ' +
             ' (select max(dtInRoomTime) from ' +
         ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber3) as InRoomTime3, ' +
         ' (select max(dtInRoomTime) from ' +
         ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber4) as InRoomTime4 ' +
        ' from VIEW_Nameplate_TrainmanJiaolu_Named ' +
        ' where strTrainmanJiaoluGUID in %s  and nCheciType=%d order by groupState,(case when year(dtLastArriveTime)=1899  then 1 else 0 end ),nCheciOrder';
      strSql := Format(strSql,[strTrainmanJiaolus,Ord(cctCheci)]);
      end;
      if nJiaoluType = jltTogether then
      begin
        strSql := 'select *, ' +
            ' (select max(dtInRoomTime) from ' +
        		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber1) as InRoomTime1, ' +
             ' (select max(dtInRoomTime) from ' +
             ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber2) as InRoomTime2, ' +
                 ' (select max(dtInRoomTime) from ' +
             ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber3) as InRoomTime3, ' +
             ' (select max(dtInRoomTime) from ' +
             ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber4) as InRoomTime4 ' +
         '  from VIEW_Nameplate_TrainmanJiaolu_TogetherTrain ' +
        ' where strTrainmanJiaoluGUID in %s order by groupState,(case when year(dtLastArriveTime)=1899  then 1 else 0 end ),strTrainmanJiaoluGUID,nOrder';
      strSql := Format(strSql,[strTrainmanJiaolus]);
      end; 
      Sql.Text := strSql;
      Open;
      SetLength(GroupArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToGroup(ADOQuery,GroupArray[i]);
        GroupArray[i].dtArriveTime := FieldByName('dtLastArriveTime').asDateTime;
        GroupArray[i].dtLastInRoomTime1 := FieldByName('InRoomTime1').asDateTime;
        GroupArray[i].dtLastInRoomTime2 := FieldByName('InRoomTime2').asDateTime;
        GroupArray[i].dtLastInRoomTime3 := FieldByName('InRoomTime3').asDateTime;
        GroupArray[i].dtLastInRoomTime4 := FieldByName('InRoomTime4').asDateTime;
        GroupArray[i].GroupState := tsNormal;
        if not FieldByName('GroupState').IsNull then
        begin
          GroupArray[i].GroupState := tsPlaning;
          if TRsPlanState(FieldByName('GroupState').AsInteger) = psBeginWork then
          begin
            GroupArray[i].GroupState := tsRuning;
          end;
        end;

        Inc(i);
        next;
      end;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetGroupInfo(GroupGUID: string; out Group: RRsGroup) : boolean;
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
      strSql := 'select top 1 * from VIEW_Nameplate_Group ' +
        ' where  strGroupGUID = %s' ;
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(adoQuery,Group);
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetGroupStaion(GroupGUID: string;
  out StationGUID: string): Boolean;
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
      strSql := 'select top 1 strStationGUID from tab_Nameplate_Group ' +
        ' where  strGroupGUID = %s' ;
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      StationGUID := adoQuery.FieldByName('strStationGUID').AsString;
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainmanJiaolu.GetKernelTimeConfig(ADOConn: TADOConnection;
  out TimeConfig: RRsKernelTimeConfig);

var
  qry:TADOQuery;
begin
  TimeConfig.nMinCallBeforeChuQing := 30;
  TimeConfig.nMinChuQingBeforeStartTrain_Z := 60;
  TimeConfig.nMinChuQingBeforeStartTrain_K := 90;
  TimeConfig.nMinDayWorkStart := 6*60;
  TimeConfig.nMinNightWokrStart := 18 * 60;

  qry:= TADOQuery.Create(nil);
  try
    qry.Connection := ADOConn;
    qry.SQL.Text := 'select top 1 * from tab_Base_KernelTime';
    qry.Open;
    TimeConfig.nMinCallBeforeChuQing := qry.FieldByName('nMinCallBeforeChuQing').AsInteger;
    TimeConfig.nMinChuQingBeforeStartTrain_Z := qry.FieldByName('nMinChuQingBeforeStartTrain_Z').AsInteger;
    TimeConfig.nMinChuQingBeforeStartTrain_K := qry.FieldByName('nMinChuQingBeforeStartTrain_K').AsInteger;
    TimeConfig.nMinDayWorkStart := qry.FieldByName('nMinDayWorkStart').AsInteger;
    TimeConfig.nMinNightWokrStart := qry.FieldByName('nMinNightWokrStart').AsInteger;
  finally
    qry.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetTrainmanGroup(TrainmanGUID: string;
  out Group: RRsGroup) : boolean;
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
      strSql := 'select top 1 * from VIEW_Nameplate_Group ' +
        ' where  strTrainmanGUID1 = %s or strTrainmanGUID2=%s or strTrainmanGUID3=%s or strTrainmanGUID4=%s' ;
      strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(adoQuery,Group);
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetTrainmanGroupWithInRoomTime(TrainmanGUID: string;
  out Group: RRsGroup) : boolean;
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
      strSql := 'select top 1 *,' +
        ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber1 and (DATEPART (Hour,dtInRoomTime) < 4 or DATEPART (Hour,dtInRoomTime) > 12) ) as InRoomTime1, ' +
     ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber2 and (DATEPART (Hour,dtInRoomTime) < 4 or DATEPART (Hour,dtInRoomTime) > 12) ) as InRoomTime2, ' +
         ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber3 and (DATEPART (Hour,dtInRoomTime) < 4 or DATEPART (Hour,dtInRoomTime) > 12) ) as InRoomTime3, ' +
      ' (select max(dtInRoomTime) from ' +
		 ' TAB_Plan_InRoom where strTrainmanNumber = strTrainmanNumber4 and (DATEPART (Hour,dtInRoomTime) < 4 or DATEPART (Hour,dtInRoomTime) > 12) ) as InRoomTime4 ' +
        ' from VIEW_Nameplate_Group ' +
        ' where  strTrainmanGUID1 = %s or strTrainmanGUID2=%s or strTrainmanGUID3=%s or strTrainmanGUID4=%s' ;
      strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToGroup(adoQuery,Group);

      Group.dtArriveTime := FieldByName('dtLastArriveTime').asDateTime;
      Group.dtLastInRoomTime1 := FieldByName('InRoomTime1').asDateTime;
      Group.dtLastInRoomTime2 := FieldByName('InRoomTime2').asDateTime;
      Group.dtLastInRoomTime3 := FieldByName('InRoomTime3').asDateTime;
      Group.dtLastInRoomTime4 := FieldByName('InRoomTime4').asDateTime;
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetTrainmanJiaolu(TrainmanJiaoluGUID: string;
  out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
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
      ///判断包乘
      strSql := 'select * from VIEW_Base_TrainmanJiaolu where strTrainmanJiaoluGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID)]);
      strSql := strSql + ' order by strTrainmanJiaoluName';
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      ADOQueryToTrainmanJiaolu(ADOQuery,TrainmanJiaolu);
      result := true;
    end;  
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetTrainmanJiaoluOfGroup(GroupGUID: string;
  out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
var
  trainmanJiaoluGUID : string;
  adoQuery : TADOQuery;
  strSql : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      ///判断包乘
      strSql := 'select * from VIEW_Nameplate_Group where strGroupGUID = %s ';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then exit;
      trainmanJiaoluGUID := FieldByName('strTrainmanJiaoluGUID').AsString;
      result := getTrainmanJiaolu(trainmanJiaoluGUID,trainmanJiaolu);

    end;  
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainmanJiaolu.GetTrainmanJiaolusOfTrainJiaolu(
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray;
  JiaoluType: TRsJiaoluType);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      ///判断包乘
      strSql := 'select * from VIEW_Base_JiaoluRelation where 1=1  ';
      if TrainJiaoluGUID <> '' then
      begin
        strSql := strSql + ' and strTrainJiaoluGUID = %s ';
        strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);

      end;
      strSql := strSql + ' order by strTrainmanJiaoluName';
      Sql.Text := strSql;
      Open;

      SetLength(TrainmanJiaoluArray,RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToTrainmanJiaolu(ADOQuery,TrainmanJiaoluArray[i]);
        Inc(i);
        next;
      end;
    end;  
  finally
    adoQuery.Free;
  end;

end;

procedure TRsDBTrainmanJiaolu.GetTrainmanJiaolusOfTrainJiaolu(SiteGUID : string;
       TrainJiaoluGUID: string;out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_JiaoluRelation where 1=1  ';
      if TrainJiaoluGUID <> '' then
      begin
        strSql := strSql + ' and strTrainJiaoluGUID = %s ';
        strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID)]);
      end else begin
        strSql := strSql + ' and strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) ';
        strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      end;
      strSql := strSql + ' order by strTrainmanJiaoluName';
      Sql.Text := strSql;
      Open;

      SetLength(TrainmanJiaoluArray,adoQuery.RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToTrainmanJiaolu(ADOQuery,TrainmanJiaoluArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.GetTrainmanJiaolusOfTrainJiaoluEx(SiteGUID,
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from VIEW_Base_TrainmanJiaolu where strTrainmanJiaoluGUID in (select DISTINCT strTrainmanJiaoluGUID from VIEW_Base_JiaoluRelation where 1=1  ';
      if TrainJiaoluGUID <> '' then
      begin
        strSql := strSql + ' and strTrainJiaoluGUID in (select %s as strTrainJiaoluGUID union select strSubTrainJiaoluGUID as strTrainJiaoluGUID from TAB_Base_TrainJiaolu_SubDetail where strTrainJiaoluGUID = %s)';
        strSql := Format(strSql,[QuotedStr(TrainJiaoluGUID),QuotedStr(TrainJiaoluGUID)]);
      end else begin
        strSql := strSql + ' and strTrainJiaoluGUID in (select strTrainJiaoluGUID from TAB_Base_TrainJiaoluInSite where strSiteGUID = %s) ';
        strSql := Format(strSql,[QuotedStr(SiteGUID)]);
      end;
      strSql := strSql + ' )order by strTrainmanJiaoluName';
      Sql.Text := strSql;
      Open;

      SetLength(TrainmanJiaoluArray,adoQuery.RecordCount);
      i := 0;
      while not eof do
      begin
        ADOQueryToTrainmanJiaolu(ADOQuery,TrainmanJiaoluArray[i]);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.GetTrainmanJiaoluType(TrainmanJiaoluGUID: string;
  out AType: Integer):Boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := False ;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Base_TrainmanJiaolu where strTrainmanJiaoluGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainmanJiaoluGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then
        Exit ;
      AType := adoQuery.FieldByName('nJiaoluType').AsInteger;
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.IsBeginWorking(TrainmanGUID: string;TrainPlanGUID  :String): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from tab_plan_BeginWork where strTrainmanGUID = %s and strTrainPlanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainmanGUID),QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      Open;
      Result := RecordCount > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.IsExist(TrainTypeName,
  TrainNumber: string): Boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := False ;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Train where strTrainTypeName = %s and strTrainNumber = %s ';
      strSql := Format(strSql,[QuotedStr(TrainTypeName),QuotedStr(TrainNumber)]);
      SQL.Text := strSql;
      Open;
      Result := RecordCount > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.LeaveTrainmanFromPlan(TrainmanGUID : string;
  TrainmanIndex : integer;TrainPlanGUID: string);
var
  strSql,strSqlGroup : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update tab_Org_Trainman set nTrainmanState = %d where strTrainmanGUID = %s ';
      strSql := Format(strSql,[Ord(tsReady),QuotedStr(TrainmanGUID)]);
      Sql.Text := strSql;      
      ExecSQL;

      strSql := 'update tab_Plan_Trainman set strTrainmanGUID1 = null where strTrainPlanGUID = %s ';
      strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID1 = null where strTrainPlanGUID = %s ';
      if TrainmanIndex = 2 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID2 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID2 = null where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 3 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID3 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID3 = null where strTrainPlanGUID = %s ';
      end;
      if TrainmanIndex = 4 then
      begin
        strSql := 'update tab_Plan_Trainman set strTrainmanGUID4 = null where strTrainPlanGUID = %s ';
        strSqlGroup := 'update TAB_Nameplate_Group set strTrainmanGUID4 = null where strTrainPlanGUID = %s ';
      end;
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      ExecSQL;

      strSqlGroup := Format(strSqlGroup,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSqlGroup;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.RemovePlanGroup(TrainPlanGUID: string) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from tab_Plan_Trainman where strTrainPlanGUID = %s '  +
        '  and (select count(*) from tab_Plan_BeginWork where strTrainPlanGUID = %s) = 0';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID),QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      Result := ExecSQL > 0;
      

      strSql := 'update TAB_Nameplate_Group set strTrainPlanGUID = null where strTrainPlanGUID = %s ';
      strSql := Format(strSql,[QuotedStr(TrainPlanGUID)]);
      Sql.Text := strSql;
      Result := ExecSQL > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.SetGroupStation(GroupGUID,
  StationGUID: string): Boolean;
var             
  strSql: string;
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'update TAB_Nameplate_Group set strStationGUID = %s where strGroupGUID = %s ';
      strSql := Format(strSql, [QuotedStr(StationGUID),QuotedStr(GroupGUID)]);
      Sql.Text := strSql;
      ExecSQL;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.UpdateArriveTime(TrainPlanGUID, GroupGUID: string;
  LastArriveTime: TDateTime): Boolean;
label
  labelModifyTime ;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;

      strSql := 'update TAB_Plan_Train set dtLastArriveTime = %s where strTrainPlanGUID= %s';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(TrainPlanGUID)]);
      SQL.Text := strSql;
      execSql;

      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Named where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;

      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Order where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;


      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;
      Close;
      Exit;

labelModifyTime:

      edit;
      FieldByName('dtLastArriveTime').AsDateTime := LastArriveTime;
      Post;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID1 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID2 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID3 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;

      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TRsDBTrainmanJiaolu.UpdateLastTime(GroupGUID: string;
  LastArriveTime: TDateTime): Boolean;
label
  labelModifyTime ;
var
  adoQuery : TADOQuery;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;

      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Named where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;

      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_Order where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;


      Close;
      strSql := 'select * from TAB_Nameplate_TrainmanJiaolu_OrderInTrain where strGroupGUID = %s';
      strSql := Format(strSql,[QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
        goto labelModifyTime ;
      Close;
      Exit;

labelModifyTime:

      edit;
      FieldByName('dtLastArriveTime').AsDateTime := LastArriveTime;
      Post;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID1 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID2 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;


      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID3 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;

      strSql := 'update TAB_Org_Trainman set dtLastEndWorkTime=%s where strTrainmanGUID = (select strTrainmanGUID4 from TAB_Nameplate_Group where strGroupGUID = %s)';
      strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',LastArriveTime)),QuotedStr(GroupGUID)]);
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBTrainmanJiaolu.GetPlanParam(ADOConn: TADOConnection; WorkShopGUID: string;
    out PlanParam: RRsPlanParam);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  //确保起见，赋初值
  PlanParam.dtAutoSaveTime1 := EncodeTime(8, 0, 0, 0);
  PlanParam.dtAutoSaveTime2 := EncodeTime(17, 0, 0, 0);
  PlanParam.dtPlanBeginTime := EncodeTime(22, 0, 0, 0);
  PlanParam.dtPlanEndTime := EncodeTime(4, 30, 0, 0);
  PlanParam.dtKeepSleepTime := EncodeTime(4, 20, 0, 0);
  PlanParam.bEnableSleepCheck := True;

  strSql := 'select top 1 * from TAB_Base_PlanParam where strWorkShopGUID = '
    + QuotedStr(WorkShopGUID);
    
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        if not FieldByName('dtAutoSaveTime1').IsNull then PlanParam.dtAutoSaveTime1 := FieldByName('dtAutoSaveTime1').AsDateTime;
        if not FieldByName('dtAutoSaveTime2').IsNull then PlanParam.dtAutoSaveTime2 := FieldByName('dtAutoSaveTime2').AsDateTime;
        if not FieldByName('dtPlanBeginTime').IsNull then PlanParam.dtPlanBeginTime := FieldByName('dtPlanBeginTime').AsDateTime;
        if not FieldByName('dtPlanEndTime').IsNull then PlanParam.dtPlanEndTime := FieldByName('dtPlanEndTime').AsDateTime;
        if not FieldByName('dtKeepSleepTime').IsNull then PlanParam.dtKeepSleepTime := FieldByName('dtKeepSleepTime').AsDateTime;
        if not FieldByName('bEnableSleepCheck').IsNull then PlanParam.bEnableSleepCheck := FieldByName('bEnableSleepCheck').AsBoolean;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBTrainmanJiaolu.DispatchHistoryDetailToADOQuery(ADOQuery: TADOQuery; Group: RRsGroup);
begin
  with ADOQuery do
  begin
    FieldByName('strGroupGUID').AsString := Group.strGroupGUID;
    FieldByName('nGroupState').AsInteger := Ord(Group.GroupState);
    
    FieldByName('strTrainmanGUID1').AsString := Group.Trainman1.strTrainmanGUID;
    FieldByName('strTrainmanNumber1').AsString := Group.Trainman1.strTrainmanNumber;
    FieldByName('strTrainmanName1').AsString := Group.Trainman1.strTrainmanName;
    FieldByName('nTrainmanState1').AsInteger := Ord(Group.Trainman1.nTrainmanState);
    if Group.Trainman1.dtLastEndWorkTime > 0 then FieldByName('dtLastEndWorkTime1').AsDateTime := Group.Trainman1.dtLastEndWorkTime;
    if Group.dtLastInRoomTime1 > 0 then FieldByName('dtLastInRoomTime1').AsDateTime := Group.dtLastInRoomTime1;
    FieldByName('strWorkShopGUID1').AsString := Group.Trainman1.strWorkShopGUID;
    FieldByName('strTrainmanGUID2').AsString := Group.Trainman2.strTrainmanGUID;
    FieldByName('strTrainmanNumber2').AsString := Group.Trainman2.strTrainmanNumber;
    FieldByName('strTrainmanName2').AsString := Group.Trainman2.strTrainmanName;
    FieldByName('nTrainmanState2').AsInteger := Ord(Group.Trainman2.nTrainmanState);
    if Group.Trainman2.dtLastEndWorkTime > 0 then FieldByName('dtLastEndWorkTime2').AsDateTime := Group.Trainman2.dtLastEndWorkTime;
    if Group.dtLastInRoomTime2 > 0 then FieldByName('dtLastInRoomTime2').AsDateTime := Group.dtLastInRoomTime2;
    FieldByName('strWorkShopGUID2').AsString := Group.Trainman2.strWorkShopGUID;      

    FieldByName('strTrainmanGUID3').AsString := Group.Trainman3.strTrainmanGUID;
    FieldByName('strTrainmanNumber3').AsString := Group.Trainman3.strTrainmanNumber;
    FieldByName('strTrainmanName3').AsString := Group.Trainman3.strTrainmanName;
    FieldByName('nTrainmanState3').AsInteger := Ord(Group.Trainman3.nTrainmanState);
    if Group.Trainman3.dtLastEndWorkTime > 0 then FieldByName('dtLastEndWorkTime3').AsDateTime := Group.Trainman3.dtLastEndWorkTime;
    if Group.dtLastInRoomTime3 > 0 then FieldByName('dtLastInRoomTime3').AsDateTime := Group.dtLastInRoomTime3;
    FieldByName('strWorkShopGUID3').AsString := Group.Trainman3.strWorkShopGUID;

    FieldByName('strTrainmanGUID4').AsString := Group.Trainman4.strTrainmanGUID;
    FieldByName('strTrainmanNumber4').AsString := Group.Trainman4.strTrainmanNumber;
    FieldByName('strTrainmanName4').AsString := Group.Trainman4.strTrainmanName;
    FieldByName('nTrainmanState4').AsInteger := Ord(Group.Trainman4.nTrainmanState);
    if Group.Trainman4.dtLastEndWorkTime > 0 then FieldByName('dtLastEndWorkTime4').AsDateTime := Group.Trainman4.dtLastEndWorkTime;
    if Group.dtLastInRoomTime4 > 0 then FieldByName('dtLastInRoomTime4').AsDateTime := Group.dtLastInRoomTime4;
    FieldByName('strWorkShopGUID4').AsString := Group.Trainman4.strWorkShopGUID;

    FieldByName('strTrainPlanGUID').AsString := Group.strTrainPlanGUID;
    FieldByName('strStationGUID').AsString := Group.Station.strStationGUID;
    if Group.dtArriveTime > 0 then FieldByName('dtLastArriveTime').AsDateTime := Group.dtArriveTime;
  end;
end;

procedure TRsDBTrainmanJiaolu.AddDispatchHistoryDetail(strDispatchHistoryGUID, strTrainmanJiaoluGUID: string;
  dtAutoSaveTime: TDateTime; GroupArray: TRsGroupArray);
var             
  strSql: string;
  adoQuery : TADOQuery;
  i: integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from TAB_Plan_DispatchHistoryDetail where dtAutoSaveTime=%s';
      strSql := Format(strSql, [QuotedStr(DateTimeToStr(dtAutoSaveTime))]);
      Sql.Text := strSql;
      ExecSQL;

      Sql.Text := 'Select * from TAB_Plan_DispatchHistoryDetail where 1=2';
      Open;
      for i := 0 to length(GroupArray)-1 do
      begin
        Append;
        FieldByName('strDispatchHistoryGUID').AsString := strDispatchHistoryGUID;
        FieldByName('strTrainmanJiaoluGUID').AsString := strTrainmanJiaoluGUID;
        FieldByName('dtAutoSaveTime').AsDateTime := dtAutoSaveTime;
        FieldByName('nRowIndex').AsInteger := i+1;
        DispatchHistoryDetailToADOQuery(ADOQuery,GroupArray[i]);
        Post;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;
  
procedure TRsDBTrainmanJiaolu.AutoSaveDispatchHistory(strTrainmanJiaoluGUID,
  strWorkShopGUID: string; dtAutoSaveTime: TDateTime; GroupArray: TRsGroupArray);
var
  strSql: string;
  adoQuery: TADOQuery;
  strDispatchHistoryGUID: string;
begin
  if length(GroupArray) = 0 then exit;
  
  m_ADOConnection.BeginTrans;
  try
    strDispatchHistoryGUID := NewGUID;

    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := m_ADOConnection;

        strSql := 'Select * from TAB_Plan_DispatchHistory where dtAutoSaveTime=%s';
        strSql := Format(strSql, [QuotedStr(DateTimeToStr(dtAutoSaveTime))]);
        SQL.Text := strSql;
        Open;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strDispatchHistoryGUID').AsString := strDispatchHistoryGUID;
          FieldByName('strTrainmanJiaoluGUID').AsString := strTrainmanJiaoluGUID;
          FieldByName('strWorkShopGUID').AsString := strWorkShopGUID;
          FieldByName('dtAutoSaveTime').AsDateTime := dtAutoSaveTime;
        end
        else
        begin
          Edit;
          FieldByName('strDispatchHistoryGUID').AsString := strDispatchHistoryGUID;
          FieldByName('strTrainmanJiaoluGUID').AsString := strTrainmanJiaoluGUID;
          FieldByName('strWorkShopGUID').AsString := strWorkShopGUID;
        end;
        Post;
      end;
    finally
      adoQuery.Free;
    end;

    AddDispatchHistoryDetail(strDispatchHistoryGUID, strTrainmanJiaoluGUID, dtAutoSaveTime, GroupArray);
    m_ADOConnection.CommitTrans;
  except on e : exception do
    begin
      m_ADOConnection.RollbackTrans;
      raise Exception.Create(e.message);
    end;
  end;
end;

end.

