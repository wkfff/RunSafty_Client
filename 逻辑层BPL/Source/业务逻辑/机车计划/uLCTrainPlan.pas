unit uLCTrainPlan;

interface

uses
  SysUtils,Dialogs,Windows,Classes,uTrainman,uTrainPlan,superobject,uDrink,
  uBaseWebInterface,uSaftyEnum,uApparatusCommon,uTrainmanJiaolu,uEndWork;

type

  //JSON结构体
  RJsonObject = record
    strName : string ;
    strValue:string  ;
  end;

  TJsonObjectArray = array of  RJsonObject ;

  {
    //此部分JSON字符串由 左东亮定义
    }
  TRsLCTrainPlan = class(TBaseWebInterface)
  public
    //3.1.1	新建已编辑机车计划
    function AddTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;out ErrStr:string):Boolean;
    //3.1.2	新建已接收机车计划
    function RecieveTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;out ErrStr:string):Boolean;
    // 接收机车计划
    function RecvPlan(DutyUserGUID:string;out PlanList:TStrings;out ErrStr:string):Boolean;
  public
     //3.1.3	获取指定客户端在指定时间范围下的指定区段的人员计划
    function GetTrainmanPlanByJiaoLu(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
    //3.1.4	获取指定客户端在指定时间范围下的指定区段的已下发的人员计划
    function GetTrainmanPlanFromSent(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
    //3.1.6	获取指定客户端的出勤计划列表
    function  GetChuQinPlanByClient(BeginDate,EndDate:TDateTime;out ChuQinPlanArray:TRsChuQinPlanArray;out ErrStr:string):Boolean;
    //3.1.7	获取指定客户端的退勤计划列表
    function  GetTuiQinPlanByClient(BeginDate,EndDate:TDateTime; ShowAll : Integer;out TuiQinPlanArray:TRsTuiQinPlanArray;out ErrStr:string):Boolean;
    function  GetCQTZByClient(BeginDate,EndDate:TDateTime;out ChuQinPlanArray:TRsChuQinPlanArray;out ErrStr:string):Boolean;
    function  GetTQTZByClient(BeginDate,EndDate:TDateTime;out TuiQinPlanArray:TRsTuiQinPlanArray;out ErrStr:string):Boolean;
    //3.1.8	获取指定人员在指定客户端下的出勤计划
    function  GetChuQinPlanByTrainman(TrainmanID:string;out ChuQinPlan:RRsChuQinPlan;out ErrStr:string):Boolean;
    //3.1.9	获取指定人员在指定客户端下的退勤计划
    function  GetTuiQinPlanByTrainman(TrainmanID:string;out TuiQinPlan:RRsTuiQinPlan;out ErrStr:string):Boolean;
    //3.1.10	执行退勤
    function  ExcuteTuiQin(EndWork:RRsEndWork;out ErrStr:string):Boolean;

    //指定的乘务员执行出勤操作
    function BeginWork(TrainmanGUID : string;
      TrainmanPlan:RRsTrainmanPlan;Verify : TRsRegisterFlag;RsDrink : RRsDrink;
      DutyUserGUID:string;BeginWorkStationGUID:string;DTNow : TDateTime;out ErrStr:string):Boolean;

    //删除计划
    function  DeleteTrainPlan(TrainPlan:string;out ErrStr:string):Boolean;
    //下发计划
    function  SendTrainPlan(PlanList:TStrings;DutyUserGUID:string;out ErrStr:string):Boolean;
    //撤销计划  IsSubPlan 是否是子计划
    function  CancelTrainPlan(PlanList:TStrings;DutyUserGUID:string;CanDeleteMainPlan:Integer;out ErrStr:string):Boolean;overload;
    function  CancelTrainPlan(PlanList:TStrings;DutyUserGUID:string;IgnoreCheck:Boolean;out ErrStr:string):Boolean;overload;
    //编辑计划
    function  UpdateTrainPlan(ReceiveTrainPlan:RRsReceiveTrainPlan;JsonObjectArray:TJsonObjectArray;out ErrStr:string):Boolean;
    //从计划里面移除人员
    function  RemoveTrainman(TrainmanGUID:string;TrainmanPlanGUID:string;GroupGUID:string;TrainmanIndex:Integer;out ErrStr:string):Boolean;
    //从计划里面移除机组
    function  RemoveGroup(GroupGUID:string;TrainmanPlanGUID:string;out ErrStr:string):Boolean;
    //根据计划ID获取人员计划
    function GetTrainmanPlanByGUID(TrainPlanGUID:string;out TrainmanPlan:RRsTrainmanPlan;out ErrStr:string):Boolean;
    //根据计划ID获取人员计划
    function GetTrainmanPlanOfNeedRest(TrainPlanGUIDS:TStrings;out TrainmanPlanArray:TRsTrainmanPlanArray;out ErrStr:string):Boolean;
    //根据ID获取行车计划
    function GetTrainPlanByID(TrainPlanGUID:string;out Plan:RRsTrainPlan): Boolean;
    //导出机车计划
    function ExportTrainPlan(dtStart,dtEnd: TDateTime;JiaoLuID: string): TRsTrainPlanArray;
  private
    //公共部分
    function EditTrainPlan(var ReceiveTrainPlan:RRsReceiveTrainPlan;DataType:string;out ErrStr:string):Boolean;
    //获取TARINMANPLAN
    function GetTrainmanPlan(TrainjiaoluID:string;BeginTime,EndTime:TDateTime;out TrainmanPlanArray:TRsTrainmanPlanArray;DataType:string;out ErrStr:string):Boolean;
    //接受计划->json
    procedure ReceiveTrainPlanToJson(ReceiveTrainPlan:RRsReceiveTrainPlan;Json: ISuperObject);

    //
    procedure EndWorkToJson(EndWork:RRsEndWork;Json: ISuperObject);
    //planlist -> json
    procedure PlanListToJson(PlanList:TStrings;Json: ISuperObject);
  public
    //json->trainmanplan
    class procedure JsonToTrainmanPlan(var TrainmanPlan:RRsTrainmanPlan;Json: ISuperObject);
    //json->trainplan
    class procedure JsonToTrainPlan(var TrainPlan:RRsTrainPlan;Json: ISuperObject);

    class procedure JsonToTuiQinData(var TuiQinPlan:RRsTuiQinPlan;Json: ISuperObject);

    class procedure JsonToAlcohol(var TestAlcoholInfo: RTestAlcoholInfo;Json: ISuperObject);

    class procedure JsonToChuQinData(var ChuQinPlan:RRsChuQinPlan;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainPlans }



function TRsLCTrainPlan.AddTrainPlan(var ReceiveTrainPlan: RRsReceiveTrainPlan;
  out ErrStr: string): Boolean;
begin
  Result := EditTrainPlan(ReceiveTrainPlan,'TF.Runsafty.Plan.Train.Editable.Add',ErrStr);
end;

function TRsLCTrainPlan.BeginWork(TrainmanGUID: string;
  TrainmanPlan: RRsTrainmanPlan; Verify: TRsRegisterFlag; RsDrink: RRsDrink;
  DutyUserGUID, BeginWorkStationGUID: string; DTNow: TDateTime;out ErrStr:string):Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['TrainmanGUID'] := TrainmanGUID ;
  json.S['DutyUserGUID'] := DutyUserGUID ;

  json.S['beginwork.strBeginWorkGUID'] :=  '' ;
  json.S['beginwork.strTrainPlanGUID'] := TrainmanPlan.TrainPlan.strTrainPlanGUID ;
  json.S['beginwork.strTrainmanGUID'] :=  TrainmanGUID ;
  json.S['beginwork.dtCreateTime'] :=  FormatDateTime('yyyy-MM-dd HH:nn:ss',dtnow) ;
  json.I['beginwork.nVerifyID'] :=  ord(Verify) ;
  json.S['beginwork.strStationGUID'] :=  BeginWorkStationGUID ;
  json.S['beginwork.strRemark'] :=  RsDrink.strRemark ;

  //测酒
  Json.S['drink.trainmanID'] := TrainmanGUID ;
  Json.I['drink.drinkResult'] := RsDrink.nDrinkResult ;
  Json.S['drink.workTypeID'] := '2' ;
  Json.S['drink.createTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',DTNow) ;
  Json.S['drink.imagePath'] := RsDrink.strPictureURL ;

  //人员信息
  json.b['drink.bLocalAreaTrainman'] :=  RsDrink.bLocalAreaTrainman ;
  Json.S['drink.strTrainmanName'] := RsDrink.strTrainmanName  ;
  Json.S['drink.strTrainmanNumber'] := RsDrink.strTrainmanNumber  ;

  //车次信息
  Json.S['drink.strTrainNo'] := RsDrink.strTrainNo  ;
  Json.S['drink.strTrainNumber'] := RsDrink.strTrainNumber  ;
  Json.S['drink.strTrainTypeName'] := RsDrink.strTrainTypeName  ;

  //车间信息
  Json.S['drink.strWorkShopGUID'] := RsDrink.strWorkShopGUID  ;
  Json.S['drink.strWorkShopName'] := RsDrink.strWorkShopName  ;
  //退勤点信息
  Json.S['drink.strPlaceID'] := RsDrink.strPlaceID  ;
  Json.S['drink.strPlaceName'] := RsDrink.strPlaceName  ;

  json.S['drink.strDutyNumber'] := RsDrink.strDutyNumber ;
  json.S['drink.strDutyName'] := RsDrink.strDutyName ;

  json.S['drink.strAreaGUID'] := RsDrink.strAreaGUID ;

  Json.S['drink.strSiteGUID'] := RsDrink.strSiteGUID  ;
  json.S['drink.strSiteNumber'] := RsDrink.strSiteIp ;
  json.S['drink.strSiteName'] := RsDrink.strSiteName ;

  //酒精度
  Json.I['drink.dwAlcoholicity'] := RsDrink.dwAlcoholicity ;
  json.I['drink.nWorkTypeID']  := RsDrink.nWorkTypeID ;

  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.ExecuteBeginWork',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.CancelTrainPlan(PlanList: TStrings;
  DutyUserGUID: string; IgnoreCheck: Boolean; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['DutyUserGUID'] := DutyUserGUID ;
  json.S['SiteGUID'] :=  m_strSiteID ;
  json.i['CanDeleteMainPlan'] := 1 ;
  json.B['IgnoreCheck'] := IgnoreCheck;
  PlanListToJson(PlanList,json);
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Cancel',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCTrainPlan.CancelTrainPlan(PlanList: TStrings;DutyUserGUID:string;CanDeleteMainPlan:Integer;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['DutyUserGUID'] := DutyUserGUID ;
  json.S['SiteGUID'] :=  m_strSiteID ;
  json.i['CanDeleteMainPlan'] := CanDeleteMainPlan ;
  PlanListToJson(PlanList,json);
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Cancel',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.DeleteTrainPlan(TrainPlan: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strTrainPlanGUID'] := TrainPlan ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Delete',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.UpdateTrainPlan(ReceiveTrainPlan:RRsReceiveTrainPlan;
  JsonObjectArray:TJsonObjectArray;out ErrStr:string):Boolean;
var
  json: ISuperObject;
  strResult : string ;
  strText:string;
  I: Integer;
begin
  Result := False ;
  json := CreateInputJson;
  Json.S['trainPlan.trainPlanGUID'] := ReceiveTrainPlan.TrainPlan.strTrainPlanGUID ;
  for I := 0 to Length(JsonObjectArray)- 1 do
  begin
    strText := Format('trainPlan.%s',[JsonObjectArray[i].strName]);
    json.S[strText] := JsonObjectArray[i].strValue ;
  end;

  with ReceiveTrainPlan do
  begin
    Json.S['user.userID'] := strUserID ;
    Json.S['user.userName'] := strUserName ;

    Json.S['site.siteID'] := strSiteID ;
    Json.S['site.siteName'] := strSiteName ;
  end;

  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Update',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.EditTrainPlan(var ReceiveTrainPlan: RRsReceiveTrainPlan;
  DataType: string; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  ReceiveTrainPlanToJson(ReceiveTrainPlan,json);
  try
    strResult := Post(DataType,json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    ReceiveTrainPlan.strPlanID := json.S['planID'] ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

procedure TRsLCTrainPlan.EndWorkToJson(EndWork: RRsEndWork; Json: ISuperObject);
begin
  with EndWork.endWorkInfo do
  begin
    json.S['siteID'] := m_strSiteID ;
    Json.S['endwork.endworkID'] := endworkID ;
    Json.S['endwork.trainmanID'] := trainmanID;
    Json.S['endwork.planID'] := planID ;
    Json.S['endwork.verifyID'] := verifyID ;
    Json.S['endwork.dutyUserID'] := dutyUserID ;
    Json.S['endwork.stationID'] := stationID ;
    Json.S['endwork.placeID'] := placeID ;
    Json.S['endwork.arriveTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',arriveTime) ;
    Json.S['endwork.lastEndWorkTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',lastEndWorkTime) ;
    Json.S['endwork.remark'] := remark ;
  end;

  with EndWork.drinksInfo do
  begin
    Json.S['drink.trainmanID'] := trainmanID ;
    Json.S['drink.drinkResult'] := drinkResult ;
    Json.S['drink.workTypeID'] := workTypeID ;
    Json.S['drink.createTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',createTime) ;
    Json.S['drink.imagePath'] := imagePath ;

    //人员信息
    Json.B['drink.bLocalAreaTrainman'] := drink.bLocalAreaTrainman ;
    Json.S['drink.strTrainmanName'] := drink.strTrainmanName  ;
    Json.S['drink.strTrainmanNumber'] := drink.strTrainmanNumber  ;

    //车次信息
    Json.S['drink.strTrainNo'] := drink.strTrainNo  ;
    Json.S['drink.strTrainNumber'] := drink.strTrainNumber  ;
    Json.S['drink.strTrainTypeName'] := drink.strTrainTypeName  ;

    //车间信息
    Json.S['drink.strWorkShopGUID'] := drink.strWorkShopGUID  ;
    Json.S['drink.strWorkShopName'] := drink.strWorkShopName  ;
    //退勤点信息
    Json.S['drink.strPlaceID'] := drink.strPlaceID  ;
    Json.S['drink.strPlaceName'] := drink.strPlaceName  ;
    Json.S['drink.strSiteGUID'] := drink.strSiteGUID  ;
    Json.S['drink.strSiteNumber'] := drink.strSiteIp ;
    Json.S['drink.strSiteName'] := drink.strSiteName  ;

    Json.S['drink.strAreaGUID'] := drink.strAreaGUID;
    //值班员信息
    Json.S['drink.strDutyNumber'] := drink.strDutyNumber;
    Json.S['drink.strDutyName'] := drink.strDutyName;
    //酒精度
    Json.I['drink.dwAlcoholicity'] := drink.dwAlcoholicity ;
    json.I['drink.nWorkTypeID']  := drink.nWorkTypeID ;
  end;
  json.S['dutyUser.dutyUserID']  := EndWork.dutyUserID ;
end;

function TRsLCTrainPlan.ExcuteTuiQin(EndWork: RRsEndWork;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  EndWorkToJson(EndWork,json);
  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.ExecuteEndWork',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.ExportTrainPlan(dtStart, dtEnd: TDateTime;
  JiaoLuID: string): TRsTrainPlanArray;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
  I: Integer;
begin
  json := CreateInputJson;
  json.S['BeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStart) ;
  json.S['EndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd) ;
  json.S['TrainJiaoluGUID'] := JiaoLuID ;
  strResult := Post('TF.Runsafty.Plan.LCTrainPlan.GetExportTrainPlans',json.AsString);
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    Raise Exception.Create(ErrStr);
  end;

  SetLength(Result,json.AsArray.Length);
  for I := 0 to Length(Result) - 1 do
  begin
    JsonToTrainPlan(Result[i],json.AsArray[i]);
  end;

end;

function TRsLCTrainPlan.GetChuQinPlanByClient(BeginDate, EndDate: TDateTime;
  out ChuQinPlanArray:TRsChuQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.ChuQin.Get',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(ChuQinPlanArray,jsonArray.Length );

    for I := 0 to jsonArray.Length - 1 do
      JsonToChuQinData(ChuQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetChuQinPlanByTrainman(TrainmanID: string;
  out ChuQinPlan:RRsChuQinPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainmanID'] := TrainmanID ;

  try
    strResult := Post('TF.Runsafty.Plan.Site.Trainman.ChuQin.Get',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToChuQinData(ChuQinPlan,json) ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


function TRsLCTrainPlan.GetCQTZByClient(BeginDate, EndDate: TDateTime;
  out ChuQinPlanArray: TRsChuQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.ChuQin.TZ',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(ChuQinPlanArray,jsonArray.Length );

    for I := 0 to jsonArray.Length - 1 do
      JsonToChuQinData(ChuQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanFromSent(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  out ErrStr: string): Boolean;
begin
  Result := GetTrainmanPlan(TrainjiaoluID,BeginTime,EndTime,
    TrainmanPlanArray,'TF.Runsafty.Plan.Site.Trainman.Sent.Get',ErrStr) ;
end;

function TRsLCTrainPlan.GetTQTZByClient(BeginDate, EndDate: TDateTime;
  out TuiQinPlanArray: TRsTuiQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.TuiQin.TZ',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TuiQinPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
      JsonToTuiQinData(TuiQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlan(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  DataType: string; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainjiaoluID'] := trainjiaoluID;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginTime) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndTime) ;

  try
    strResult := Post(DataType,json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainmanPlan(TrainmanPlanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanByGUID(TrainPlanGUID: string;
  out TrainmanPlan: RRsTrainmanPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['TrainPlanGUID'] := TrainPlanGUID;

  ZeroMemory(@TrainmanPlan,SizeOf(TrainmanPlan));
  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.GetTrainmanPlanByGUID',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToTrainmanPlan(TrainmanPlan,json);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainmanPlanOfNeedRest(TrainPlanGUIDS: TStrings;
  out TrainmanPlanArray: TRsTrainmanPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;

begin
  Result := False ;
  json := CreateInputJson;
  for I := 0 to TrainPlanGUIDS.Count - 1 do
  begin
      strResult :=  strResult + TrainPlanGUIDS.Strings[i] + ',' ;
  end;
  json.S['TrainPlanGUIDList'] := strResult ;
  strResult := ''  ;
  try
    strResult := Post('TF.Runsafty.Plan.RCTrainmanplan.GetTrainmanPlanOfNeedRest',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainmanPlan(TrainmanPlanArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTrainPlanByID(TrainPlanGUID: string;
  out Plan: RRsTrainPlan): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['TrainPlanGUID'] := TrainPlanGUID;

  strResult := Post('TF.Runsafty.Plan.LCTrainPlan.GetPlanByGUID',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;
  Result := json.I['Exist'] = 1;

  if Result then  
    JsonToTrainPlan(Plan,json.O['Plan']);
end;

function TRsLCTrainPlan.GetTrainmanPlanByJiaoLu(TrainjiaoluID: string; BeginTime,
  EndTime: TDateTime; out TrainmanPlanArray: TRsTrainmanPlanArray;
  out ErrStr: string): Boolean;
begin
  Result := GetTrainmanPlan(TrainjiaoluID,BeginTime,EndTime,
    TrainmanPlanArray,'TF.Runsafty.Plan.Site.Trainmanplan.Get',ErrStr) ;
end;

function TRsLCTrainPlan.GetTuiQinPlanByClient(BeginDate, EndDate: TDateTime; ShowAll : Integer;
  out  TuiQinPlanArray:TRsTuiQinPlanArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['begintime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',BeginDate) ;
  json.S['endtime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  json.I['showAll'] :=  ShowAll ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.TuiQin.Get',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TuiQinPlanArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
      JsonToTuiQinData(TuiQinPlanArray[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.GetTuiQinPlanByTrainman(TrainmanID: string;
  out TuiQinPlan:RRsTuiQinPlan; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['siteID'] := m_strSiteID ;
  json.S['trainmanID'] := TrainmanID ;
  try
    strResult := Post('TF.Runsafty.Plan.Site.Trainman.TuiQin.Get',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

      ZeroMemory(@TuiQinPlan,SizeOf(TuiQinPlan));

    JsonToTuiQinData(TuiQinPlan,json) ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


class procedure TRsLCTrainPlan.JsonToChuQinData(var ChuQinPlan:RRsChuQinPlan;Json: ISuperObject);
var
  jsonChuQinGroup : ISuperObject ;
begin
  JsonToTrainPlan(ChuQinPlan.TrainPlan,Json.O['trainPlan']);

  jsonChuQinGroup := Json.O['chuqinGroup'];
  JsonToGroup(ChuQinPlan.ChuQinGroup.Group,jsonChuQinGroup.O['group']);

  with ChuQinPlan.ChuQinGroup do
  begin
    nVerifyID1 := TRsRegisterFlag ( strtoint ( jsonChuQinGroup.S['verifyID1'] ) );
    JsonToAlcohol(testAlcoholInfo1,jsonChuQinGroup.O['testAlcoholInfo1']);

    nVerifyID2 := TRsRegisterFlag ( strtoint ( jsonChuQinGroup.S['verifyID2'] ) );
    JsonToAlcohol(testAlcoholInfo2,jsonChuQinGroup.O['testAlcoholInfo2']);

    nVerifyID3 := TRsRegisterFlag ( strtoint (jsonChuQinGroup.S['verifyID3'] ) );
    JsonToAlcohol(testAlcoholInfo3,jsonChuQinGroup.O['testAlcoholInfo3']);

    nVerifyID4 := TRsRegisterFlag ( StrToInt(  jsonChuQinGroup.S['verifyID4'] ) ) ;
    JsonToAlcohol(testAlcoholInfo4,jsonChuQinGroup.O['testAlcoholInfo4']);

    strChuQinMemo := jsonChuQinGroup.S['chuQinMemo'];
  end;

  with ChuQinPlan do
  begin
    if Json.S['beginWorkTime'] <> ''  then
      dtBeginWorkTime := StrToDateTime(Json.S['beginWorkTime']);
    strICCheckResult := Json.S['icCheckResult'] ;
    nFlowState := Json.I['nFlowState'];
  end;
end;



class procedure  TRsLCTrainPlan.JsonToAlcohol(var TestAlcoholInfo: RTestAlcoholInfo;Json: ISuperObject);
begin
  with TestAlcoholInfo do
  begin
    taTestAlcoholResult :=  TTestAlcoholResult ( StrToInt( Json.S['testAlcoholResult'] ) ) ;
    picture := Json.S['picture'] ;

    if Json.S['testTime'] <> '' then
      dtTestTime := StrToDateTime( Json.S['testTime'] )
    else
      dtTestTime := 0;
  end;
end;


class procedure TRsLCTrainPlan.JsonToTrainmanPlan(var TrainmanPlan: RRsTrainmanPlan;Json: ISuperObject);
begin
  JsonToTrainPlan(TrainmanPlan.TrainPlan,Json.O['trainPlan']);
  JsonToGroup(TrainmanPlan.Group,Json.O['group']);
end;

class procedure TRsLCTrainPlan.JsonToTrainPlan(var TrainPlan:RRsTrainPlan;
  Json: ISuperObject);
begin
  with TrainPlan do
  begin
    dtChuQinTime := 0;
    nPlanState := TRsPlanState ( strtoint( json.S['planStateID'] )) ;
    strPlanStateName := json.S['planStateName'] ;
    strPlaceID := json.S['placeID'] ;
    strPlaceName := json.S['placeName'] ;

    strTrainJiaoluGUID := json.S['trainJiaoluGUID'] ;
    strTrainJiaoluName :=  json.S['trainJiaoluName'] ;

    strTrainTypeName := json.S['trainTypeName'] ;
    strTrainNumber := json.S['trainNumber'] ;
    strTrainNo := json.S['trainNo'] ;

    if json.S['startTime'] <> '' then
      dtStartTime := StrToDateTime(json.S['startTime']) ;
    if json.S['realStartTime'] <> '' then
      dtRealStartTime := StrToDateTime(json.S['realStartTime']) ;
    if json.S['firstStartTime'] <> '' then
      dtFirstStartTime := StrToDateTime(json.S['firstStartTime']) ;
    if Json.S['kaiCheTime']  <>  '' then
      dtChuQinTime :=   StrToDateTime(json.S['kaiCheTime']) ;

    if Json.S['beginWorkTime'] <> '' then
      dtRealBeginWorkTime :=  StrToDateTime(json.S['beginWorkTime']) ;

    strStartStation := json.S['startStationID'] ;
    strStartStationName := json.S['startStationName'] ;
    strEndStation := json.S['endStationID'] ;
    strEndStationName := json.S['endStationName'] ;


    if json.S['trainmanTypeID '] <> '' then
      nTrainmanTypeID := trstrainmantype ( strtoint( json.S['trainmanTypeID '] ) );
    strTrainmanTypeName := json.S['trainmanTypeName'] ;

    if json.S['planTypeID'] <> '' then
      nPlanType :=   trsplantype ( strtoint(json.S['planTypeID']) ) ;
    strPlanTypeName := json.S['planTypeName'] ;

    if json.S['dragTypeID'] <> '' then
      nDragType := trsdragtype ( strtoint(json.S['dragTypeID']) ) ;
    strDragTypeName := json.S['dragTypeName'] ;

    if json.S['kehuoID'] <> '' then
      nKeHuoID := TRsKeHuo ( strtoint( json.S['kehuoID'] ) ) ;
    strKehuoName := json.S['kehuoName'] ;

    if json.S['remarkTypeID'] <> '' then
      nRemarkType := trsplanremarktype ( strtoint( json.S['remarkTypeID'] ) );
    strRemarkTypeName := json.S['remarkTypeName'] ;
    strRemark := json.S['strRemark'] ;


    if json.S['lastArriveTime'] <> '' then
      dtLastArriveTime := StrToDateTime( json.S['lastArriveTime'] );

    strTrainPlanGUID := Json.S['planID'];
    if json.S['createTime'] <> '' then
      dtCreateTime := StrToDateTime( json.S['createTime'] );


    nNeedRest :=  json.I['nNeedRest'] ;
    if Json.S['dtArriveTime'] <> '' then
      dtArriveTime := StrToDateTime( json.S['dtArriveTime']) ;

    if Json.S['dtCallTime'] <> '' then
      dtCallTime :=  StrToDateTime( json.S['dtCallTime'] ) ;


    strCreateSiteGUID := json.S['createSiteGUID']  ;
    strCreateSiteName := json.S['createSiteName'] ;
    strCreateUserGUID := json.S['createUserGUID'] ;
    strCreateUserName:= json.S['createUserName'] ;
    strMainPlanGUID := json.S['mainPlanGUID'] ;

    strTrackNumber := json.S['strTrackNumber'] ;
    strWaiQinClientGUID := json.S['strWaiQinClientGUID'] ;
    strWaiQinClientNumber := json.S['strWaiQinClientNumber'] ;
    strWaiQinClientName := json.S['strWaiQinClientName'] ;

    if Json.S['sendPlanTime'] <> '' then
      dtSendPlanTime :=  StrToDateTime( json.S['sendPlanTime'] ) ;

    if Json.S['recvPlanTime'] <> '' then
      dtRecvPlanTime :=  StrToDateTime( json.S['recvPlanTime'] ) ;

  end;
end;

class procedure TRsLCTrainPlan.JsonToTuiQinData(var TuiQinPlan:RRsTuiQinPlan;
  Json: ISuperObject);
var
  jsonTuiQinGroup : ISuperObject ;
begin
  JsonToTrainPlan(TuiQinPlan.TrainPlan,Json.O['trainPlan']);

  jsonTuiQinGroup := Json.O['tuiqinGroup'];
  JsonToGroup(TuiQinPlan.TuiQinGroup.Group,jsonTuiQinGroup.O['group']);
  with TuiQinPlan.TuiQinGroup do
  begin
    nVerifyID1 :=  TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID1']));
    JsonToAlcohol(testAlcoholInfo1,jsonTuiQinGroup.O['testAlcoholInfo1']);

    nVerifyID2 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID2']) );
    JsonToAlcohol(testAlcoholInfo2,jsonTuiQinGroup.O['testAlcoholInfo2']);

    nVerifyID3 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID3']) );
    JsonToAlcohol(testAlcoholInfo3,jsonTuiQinGroup.O['testAlcoholInfo3']);

    nVerifyID4 := TRsRegisterFlag ( strtoint(jsonTuiQinGroup.S['verifyID4']) );
    JsonToAlcohol(testAlcoholInfo4,jsonTuiQinGroup.O['testAlcoholInfo4']);

  end;

  with TuiQinPlan do
  begin
    if jsonTuiQinGroup.S['turnStartTime'] <> '' then
      dtTurnStartTime := StrToDatetime(jsonTuiQinGroup.S['turnStartTime']) ;
    if jsonTuiQinGroup.S['signed'] <> ''  then
      bSigned := StrToInt( jsonTuiQinGroup.S['signed'] );
    if jsonTuiQinGroup.S['isOver'] <> ''  then
      bIsOver  := StrToInt( jsonTuiQinGroup.S['isOver'] );
    if jsonTuiQinGroup.S['turnMinutes'] <> '' then
      nTurnMinutes := StrToInt( jsonTuiQinGroup.S['turnMinutes'] );
    if jsonTuiQinGroup.S['turnAlarmMinutes'] <> '' then
      nTurnAlarmMinutes := StrToInt( jsonTuiQinGroup.S['turnAlarmMinutes'] ) ;

    if Json.S['beginWorkTime'] <> '' then
     dtBeginWorkTime := StrToDateTimeDef(Json.S['beginWorkTime'],0)
  end;
end;

procedure TRsLCTrainPlan.PlanListToJson(PlanList: TStrings; Json: ISuperObject);
var
  i : Integer ;
  jsonArray:ISuperObject ;
  jsonPlan:ISuperObject ;
begin
  jsonArray := SO('[]');
  for I := 0 to PlanList.Count - 1 do
  begin
    jsonPlan := SO('{}');
    jsonPlan.S['strTrainPlanGUID'] := PlanList.Strings[i];
    jsonArray.AsArray.Add(jsonPlan);
  end;
  Json.O['plans'] := jsonArray ;
end;

procedure TRsLCTrainPlan.ReceiveTrainPlanToJson(
  ReceiveTrainPlan: RRsReceiveTrainPlan; Json: ISuperObject);
begin
  with ReceiveTrainPlan.TrainPlan do
  begin
    Json.S['trainPlan.trainjiaoluID'] := strTrainJiaoluGUID ;
    Json.S['trainPlan.placeID'] := strPlaceID ;
    Json.S['trainPlan.trainTypeName']:= strTrainTypeName ;
    Json.S['trainPlan.trainNumber']:= strTrainNumber ;
    Json.S['trainPlan.trainNo']:= strTrainNo;
    Json.S['trainPlan.kaiCheTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtChuQinTime);   //计划开车时间
    Json.S['trainPlan.startTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtStartTime);    //出勤
    Json.S['trainPlan.startStationID']:= strStartStation;
    Json.S['trainPlan.endStationID']:= strEndStation;
    Json.S['trainPlan.trainmanTypeID']:= IntToStr(Ord(nTrainmanTypeID));
    Json.S['trainPlan.planTypeID']:= IntToStr(Ord(nPlanType));
    Json.S['trainPlan.dragTypeID']:= IntToStr(Ord(nDragType));
    Json.S['trainPlan.kehuoID']:= IntToStr(Ord(nKeHuoID));
    Json.S['trainPlan.remarkTypeID']:= IntToStr(Ord(nRemarkType));
    Json.S['trainPlan.strMainPlanGUID'] := strMainPlanGUID ;

    Json.S['trainPlan.strTrackNumber'] := strTrackNumber ;
    Json.S['trainPlan.strWaiQinClientGUID'] := strWaiQinClientGUID ;
    Json.S['trainPlan.strWaiQinClientNumber'] := strWaiQinClientNumber ;
    Json.S['trainPlan.strWaiQinClientName'] := strWaiQinClientName ;
    //计划下发时间
    Json.S['trainPlan.sendPlanTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtSendPlanTime);
    //计划接收时间
    Json.S['trainPlan.recvPlanTime']:= FormatDateTime('yyyy-MM-dd HH:mm:ss',dtRecvPlanTime);
    //候版时间
    json.I['trainPlan.nNeedRest'] :=  nNeedRest;
    if nNeedRest >= 1  then
    begin
      json.S['trainPlan.dtArriveTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtArriveTime ) ;
      json.S['trainPlan.dtCallTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtCallTime );
    end;
  end;

  with ReceiveTrainPlan do
  begin
    Json.S['user.userID'] := strUserID ;
    Json.S['user.userName'] := strUserName ;

    Json.S['site.siteID'] := strSiteID ;
    Json.S['site.siteName'] := strSiteName ;
  end;
end;

function TRsLCTrainPlan.RecieveTrainPlan(
  var ReceiveTrainPlan: RRsReceiveTrainPlan; out ErrStr: string): Boolean;
begin
  Result := EditTrainPlan(ReceiveTrainPlan,'TF.Runsafty.Plan.Train.Accept.Add',ErrStr);
end;

function TRsLCTrainPlan.RecvPlan(DutyUserGUID: string; out PlanList: TStrings;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray:TSuperArray;
  strResult : string ;
  i : Integer ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strDutyGUID'] := DutyUserGUID ;
  json.S['strSiteGUID'] :=  m_strSiteID ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Receive',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.asarray;
    for I := 0 to jsonArray.Length - 1 do
    begin
      PlanList.Add(jsonArray[i].S['planGUID']);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.RemoveGroup(GroupGUID, TrainmanPlanGUID: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strGroupGUID'] := GroupGUID ;
  json.S['strTrainPlanGUID'] :=  TrainmanPlanGUID ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.RemoveGroup',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.RemoveTrainman(TrainmanGUID, TrainmanPlanGUID: string;GroupGUID:string;
  TrainmanIndex: Integer; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainmanGUID'] := TrainmanGUID ;
  json.S['trainmanPlanGUID'] :=  TrainmanPlanGUID ;
  json.S['strGroupGUID'] := GroupGUID ;
  json.I['trainmanIndex'] := TrainmanIndex ;
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.RemoveTrainman',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

function TRsLCTrainPlan.SendTrainPlan(PlanList: TStrings;DutyUserGUID:string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['DutyUserGUID'] := DutyUserGUID ;
  json.S['SiteGUID'] :=  m_strSiteID ;
  PlanListToJson(PlanList,json);
  try
    strResult := Post('TF.Runsafty.Plan.LCTrainPlan.Send',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

end.
