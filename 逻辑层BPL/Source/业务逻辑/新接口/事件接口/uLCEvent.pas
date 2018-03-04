unit uLCEvent;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uRunEvent,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize;
type
  //机车事件接口
  TRsLCEvent = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  private
    m_WebAPIUtils:TWebAPIUtils;
    //JSON对象转换为事件结构
    function JsonToRunEvent(iJson: ISuperObject): RRsRunEvent;
    function EventToJson(Event: RRsRunEvent): ISuperObject;
  public
    //获取计划的所有事件信息(途中详情)
    procedure GetPlanRunEvents(TrainPlanGUID : String;out RunEventArray : TRsRunEventArray);
    //删除运行事件
    procedure DeleteRunEvent(EventGUID: string);
    //重新计划事件信息
    procedure ReCountRunEvent(TrainPlanGUID : String);
    //添加运行事件
    procedure AddRunEvent(runEvent: RRsRunEvent);
    procedure GetPlanStationRunEvents(TrainPlanGUID : String;out RunEventArray : TRsRunEventArray);
  end;
implementation

{ TRsLCEvent }

procedure TRsLCEvent.AddRunEvent(runEvent: RRsRunEvent);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.O['runEvent'] := EventToJson(runEvent);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCRunEvent.AddRunEvent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


constructor TRsLCEvent.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCEvent.DeleteRunEvent(EventGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['EventGUID'] := EventGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCRunEvent.DeleteRunEvent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCEvent.EventToJson(Event: RRsRunEvent): ISuperObject;
begin
  Result := SO;
  Result.S['strRunEventGUID'] := Event.strRunEventGUID;
  Result.S['strTrainPlanGUID'] := Event.strTrainPlanGUID;
  Result.I['nEventID'] := Ord(Event.nEventID);
  Result.S['strEventName'] := Event.strEventName;
  Result.S['dtEventTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Event.dtEventTime);
  Result.S['strTrainNo'] := Event.strTrainNo;
  Result.S['strTrainTypeName'] := Event.strTrainTypeName;
  Result.S['strTrainNumber'] := Event.strTrainNumber;
  Result.I['nTMIS'] := Event.nTMIS;
  Result.S['strStationName'] := Event.strStationName;
  Result.I['nKehuo'] := Ord(Event.nKehuo);
  Result.S['strGroupGUID'] := Event.strGroupGUID;
  Result.S['strTrainmanNumber1'] := Event.strTrainmanNumber1;
  Result.S['strTrainmanNumber2'] := Event.strTrainmanNumber2;
  Result.S['dtCreateTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Event.dtCreateTime);
  Result.I['nResultID'] := Event.nResultID;
  Result.S['strResult'] := Event.strResult;
end;


procedure TRsLCEvent.GetPlanRunEvents(TrainPlanGUID: String;
  out RunEventArray: TRsRunEventArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCRunEvent.GetPlanRunEvents',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['eventArray'];

  SetLength(RunEventArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    RunEventArray[i] := JsonToRunEvent(json.AsArray[i]);
  end;
end;


procedure TRsLCEvent.GetPlanStationRunEvents(TrainPlanGUID: String;
  out RunEventArray: TRsRunEventArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCRunEvent.GetPlanStationRunEvents',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['eventArray'];

  SetLength(RunEventArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    RunEventArray[i] := JsonToRunEvent(json.AsArray[i]);
  end;
end;
function TRsLCEvent.JsonToRunEvent(iJson: ISuperObject): RRsRunEvent;
begin
  Result.strRunEventGUID := iJson.S['strRunEventGUID'];
  Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
  Result.nEventID := TRunEventType(iJson.I['nEventID']);
  Result.strEventName := iJson.S['strEventName'];
  Result.dtEventTime := TJsonParse.ToDateTime(iJson.O['dtEventTime']);
  Result.strTrainNo := iJson.S['strTrainNo'];
  Result.strTrainTypeName := iJson.S['strTrainTypeName'];
  Result.strTrainNumber := iJson.S['strTrainNumber'];
  Result.nTMIS := iJson.I['nTMIS'];
  Result.strStationName := iJson.S['strStationName'];
  Result.nKehuo := TRsKehuo(iJson.I['nKehuo']);
  Result.strGroupGUID := iJson.S['strGroupGUID'];
  Result.strTrainmanNumber1 := iJson.S['strTrainmanNumber1'];
  Result.strTrainmanNumber2 := iJson.S['strTrainmanNumber2'];
  Result.dtCreateTime := TJsonParse.ToDateTime(iJson.O['dtCreateTime']);
  Result.nResultID := iJson.I['nResultID'];
  Result.strResult := iJson.S['strResult'];
end;

procedure TRsLCEvent.ReCountRunEvent(TrainPlanGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCRunEvent.ReCountRunEvent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

end.
