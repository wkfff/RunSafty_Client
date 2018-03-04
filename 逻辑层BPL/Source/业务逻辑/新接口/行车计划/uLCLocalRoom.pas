unit uLCLocalRoom;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uDutyUser,uRoomSign;
type
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLCLocalRoom
  /// 说明:TLCLocalRoom接口类
  /////////////////////////////////////////////////////////////////////////////
  TLCLocalRoom = Class(TWepApiBase)
  public
  public
    //功能:查询本段入寓记录
    procedure QueryInRoomRecord(BeginTime : TDateTime;EndTime : TDateTime;
      WorkShopGUID : String;Signs : TRsRoomSignList);
    //功能:修改本段入寓时间
    procedure UpdateInRoomTime(strInRoomGUID : String;NewTime : TDateTime);
  end;

implementation


function EnQueryInRoomRecordInputJSON(BeginTime : TDateTime;EndTime : TDateTime;WorkShopGUID : String):String;
//功能:生成(查询本段入寓记录)接口输入参数JSON字符串
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['BeginTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',BeginTime);
    JSON.S['EndTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',EndTime);
    JSON.S['WorkShopGUID'] := WorkShopGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure DeQueryInRoomRecordOutputJSON(strJSON:String;Signs : TRsRoomSignList);
//功能:解析(查询本段入寓记录)接口返回参数
var
  i : Integer;
  JSONArray : TSuperArray;
  JSON : ISuperObject;
  RoomSign : TRsRoomSign;
begin
  JSON := SO(strJSON);
  JSON := JSON.O['data'];
  try
    JSONArray := JSON.A['Signs'];
    for I := 0 to JSONArray.Length - 1 do
    begin
      RoomSign := TRsRoomSign.Create();

      RoomSign.strInRoomGUID := JSONArray.O[i].S['strInRoomGUID'];
      RoomSign.strTrainPlanGUID := JSONArray.O[i].S['strTrainPlanGUID'];
      RoomSign.strTrainmanGUID := JSONArray.O[i].S['strTrainmanGUID'];
      if JSONArray.O[i].S['dtInRoomTime'] <> '' then
        RoomSign.dtInRoomTime := StrToDateTime(JSONArray.O[i].S['dtInRoomTime']);
      RoomSign.nInRoomVerifyID := JSONArray.O[i].I['nInRoomVerifyID'];
      RoomSign.strDutyUserGUID := JSONArray.O[i].S['strDutyUserGUID'];
      RoomSign.strTrainmanNumber := JSONArray.O[i].S['strTrainmanNumber'];
      RoomSign.strTrainmanName := JSONArray.O[i].S['strTrainmanName'];

      Signs.Add(RoomSign);
    end;
  finally
    JSON := nil;
  end;
end;

function EnUpdateInRoomTimeInputJSON(strInRoomGUID : String;NewTime : TDateTime):String;
//功能:生成(修改本段入寓时间)接口输入参数JSON字符串
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['strInRoomGUID'] := strInRoomGUID;
    JSON.S['NewTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',NewTime);
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;


procedure TLCLocalRoom.QueryInRoomRecord(BeginTime : TDateTime;EndTime : TDateTime;WorkShopGUID : String;Signs : TRsRoomSignList);
//功能:查询本段入寓记录
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnQueryInRoomRecordInputJSON(BeginTime,EndTime,WorkShopGUID);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.LocalRoom.InRoom.Query',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  DeQueryInRoomRecordOutputJSON(strOutputData,Signs);
end;

procedure TLCLocalRoom.UpdateInRoomTime(strInRoomGUID : String;NewTime : TDateTime);
//功能:修改本段入寓时间
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnUpdateInRoomTimeInputJSON(strInRoomGUID,NewTime);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.LocalRoom.InRoom.UpdateTime',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  
  begin
    Raise Exception.Create(strResultText);
  end;
end;

end.
