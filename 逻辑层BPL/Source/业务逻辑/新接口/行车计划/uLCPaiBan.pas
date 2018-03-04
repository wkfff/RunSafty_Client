unit uLCPaiBan;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uDutyUser,uTrainPlan;
type
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TPaiBan
  /// 说明:TPaiBan接口类
  /////////////////////////////////////////////////////////////////////////////
  TLCPaiBan = Class(TWepApiBase)
  public
     //功能:交换计划的机组
    procedure ExchangeGroup(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser);
    //功能:为计划设置机组
    procedure SetGroup(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser);
    //功能:自动派班
    procedure AutoDispatch(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser);
    //功能:发布计划
    procedure PublishPlan(PlanGUIDs : String;DutyGUID : String;SiteGUID : String);
   //功能:将人员安排到计划的指定位置中
    procedure SetTrainmanToPlan(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser);
    //获取派班写实记录
    procedure GetXSTrainmanPlans(dtBeginTime,dtEndTime: TDateTime;jiaolus: TStrings;out Plans: TRsTrainmanPlanArray);
    //设置计划的寓休信息
    procedure SetPlanRest(PlanGUID: string;RestInfo: RRsRest);
    //获取计划变动日志
    procedure GetChangeTrainPlanLog(TrainPlanGUID: string;out Logs: TRsTrainPlanChangeLogArray);
  end;
  
implementation

uses uLCTrainPlan;

function EnExchangeGroupInputJSON(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser):String;
//功能:生成(交换计划的机组)接口输入参数JSON字符串
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['SourcePlanGUID'] := SourcePlanGUID;
    JSON.S['DestPlanGUID'] := DestPlanGUID;
    ItemJSON := SO('{}');
    ItemJSON.S['strDutyGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['strDutyNumber'] := DutyUser.strDutyNumber;
    ItemJSON.S['strDutyName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.ExchangeGroup(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser);
//功能:交换计划的机组
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnExchangeGroupInputJSON(SourcePlanGUID,DestPlanGUID,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.ExchangeGroup',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TLCPaiBan.GetChangeTrainPlanLog(TrainPlanGUID: string;
  out Logs: TRsTrainPlanChangeLogArray);
  function JsonToLog(iJson: ISuperObject): RRsTrainPlanChangeLog;
  begin
    //计划GUID
    Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
    //机车类型
    Result.strTrainTypeName := iJson.S['strTrainTypeName'];
    //机车号
    Result.strTrainNumber := iJson.S['strTrainNumber'];
    {车次}
    Result.strTrainNo := iJson.S['strTrainNo'];
    //计划开车时间
    Result.dtStartTime := StrToDateTime(iJson.S['dtStartTime']);
  
    {机车交路}
    Result.strTrainJiaoluGUID := iJson.S['strTrainJiaoluGUID'];
    //机车交路名称
    Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
    {起始站GUID}
    Result.strStartStation := iJson.S['strStartStation'];
    //起始站名称
    Result.strStartStationName := iJson.S['strStartStationName'];
    {终到站GUID}
    Result.strEndStation := iJson.S['strEndStation'];
    //终到站名称
    Result.strEndStationName := iJson.S['strEndStationName'];
    //值乘方式
    Result.nTrainmanTypeID := TRsTrainmanType(iJson.I['nTrainmanTypeID']);
  
    Result.strTrainmanTypeName := iJson.S['strTrainmanTypeName'];
    //计划类型
    Result.nPlanType := TRsPlanType(iJson.I['nPlanType']);
    Result.strPlanTypeName := iJson.S['strPlanTypeName'];
    //牵引状态
    Result.nDragType := TRsDragType(iJson.I['nDragType']);
    Result.strDragTypeName := iJson.S['strDragTypeName'];
    //客货
    Result.nKeHuoID := TRsKehuo(iJson.I['nKeHuoID']);
    Result.strKehuoName := iJson.S['strKehuoName'];
    //备注类型
    Result.nRemarkType := TRsPlanRemarkType(iJson.I['nRemarkType']);
    Result.strRemarkTypeName := iJson.S['strRemarkTypeName'];
    //备注内容
    Result.strRemark := iJson.S['strRemark'];
    //计划状态
    Result.nPlanState := TRsPlanState(iJson.I['nPlanState']);
    {记录产生时间}
    Result.dtCreateTime := StrToDateTime(iJson.S['dtCreateTime']);
    //改变时间
    Result.dtChangeTime := StrToDateTime(iJson.S['dtChangeTime']);
  end;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['TrainPlanGUID'] := TrainPlanGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.TrainPlan.Log.Query',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Logs'];

  SetLength(Logs,JSON.AsArray.Length);

  for I := 0 to Length(Logs) - 1 do
  begin
    Logs[i] := JsonToLog(JSON.AsArray[i]);
  end;

end;



procedure TLCPaiBan.GetXSTrainmanPlans(dtBeginTime, dtEndTime: TDateTime;
  jiaolus: TStrings; out Plans: TRsTrainmanPlanArray);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['dtBeginTime'] := TimeToJSONString(dtBeginTime);
  JSON.S['dtEndTime'] := TimeToJSONString(dtEndTime);
  JSON.S['jiaolus'] := jiaolus.CommaText;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.GetXS',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Plans'];

  SetLength(Plans,JSON.AsArray.Length);

  for I := 0 to Length(Plans) - 1 do
  begin
    TRsLCTrainPlan.JsonToTrainmanPlan(Plans[i],JSON.AsArray[i]);
  end;

end;


function EnSetGroupInputJSON(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser):String;
//功能:生成(为计划设置机组)接口输入参数JSON字符串
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['PlanGUID'] := PlanGUID;
    JSON.S['GroupGUID'] := GroupGUID;
    ItemJSON := SO('{}');
    ItemJSON.S['strDutyGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['strDutyNumber'] := DutyUser.strDutyNumber;
    ItemJSON.S['strDutyName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.SetGroup(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser);
//功能:为计划设置机组
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnSetGroupInputJSON(PlanGUID,GroupGUID,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.SetGroup',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
        

procedure TLCPaiBan.SetPlanRest(PlanGUID: string; RestInfo: RRsRest);
  function RestToJson(): ISuperObject;
  begin
    Result := SO();
    //是否需要强休 0:不需要，1：需要
    Result.I['nNeedRest'] := RestInfo.nNeedRest;
    //到达时间
    Result.S['dtArriveTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',RestInfo.dtArriveTime);
    //叫班时间
    Result.S['dtCallTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',RestInfo.dtCallTime);
  end;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['PlanGUID'] := PlanGUID;
  JSON.O['RestInfo'] := RestToJson();


  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.SetPlanRest',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
function EnAutoDispatchInputJSON(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser):String;
//功能:生成(自动派班)接口输入参数JSON字符串
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainJiaoluGUID'] := TrainJiaoluGUID;
    JSON.S['PlanGUIDs'] := PlanGUIDs;
    ItemJSON := SO('{}');
    ItemJSON.S['userID'] := DutyUser.strDutyGUID;
    ItemJSON.S['userName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;


procedure TLCPaiBan.AutoDispatch(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser);
//功能:自动派班
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnAutoDispatchInputJSON(TrainJiaoluGUID,PlanGUIDs,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.AutoDispatch',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;



function EnPublishPlanInputJSON(PlanGUIDs : String;DutyGUID : String;SiteGUID : String):String;
//功能:生成(发布计划)接口输入参数JSON字符串
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['PlanGUIDs'] := PlanGUIDs;
    JSON.S['DutyGUID'] := DutyGUID;
    JSON.S['SiteGUID'] := SiteGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;   

procedure TLCPaiBan.PublishPlan(PlanGUIDs : String;DutyGUID : String;SiteGUID : String);
//功能:发布计划
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnPublishPlanInputJSON(PlanGUIDs,DutyGUID,SiteGUID);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.PublishPlan',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


 
function EnGetLastArrvieTimeInputJSON(TrainPlanGUID : String):String;
//功能:生成(获取计划最后到达时间)接口输入参数JSON字符串
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure DeGetLastArrvieTimeOutputJSON(strJSON:String; var ArriveTime : TDateTime);
//功能:解析(获取计划最后到达时间)接口返回参数
var
  JSON : ISuperObject;
begin
  JSON := SO(strJSON);
  JSON := JSON.O['data'];
  try
    if JSON.S['ArriveTime'] <> '' then
      ArriveTime := StrToDateTime(JSON.S['ArriveTime']);
  finally
    JSON := nil;
  end;       
end;

      

function EnSetTrainmanToPlanInputJSON(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser):String;
//功能:生成(将人员安排到计划的指定位置中)接口输入参数JSON字符串
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    JSON.S['TrainmanNumber'] := TrainmanNumber;
    JSON.I['TrainmanIndex'] := TrainmanIndex;
    ItemJSON := SO('{}');
    ItemJSON.S['userGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['userID'] := DutyUser.strDutyNumber;
    ItemJSON.S['userName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.SetTrainmanToPlan(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser);
//功能:将人员安排到计划的指定位置中
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnSetTrainmanToPlanInputJSON(TrainPlanGUID,TrainmanNumber,TrainmanIndex,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.SetTrainman',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;    
end.
