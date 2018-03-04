unit uLCDict_TrainmanJiaoLu;

interface
uses
  SysUtils,uTrainmanJiaolu,superobject,uBaseWebInterface,uSaftyEnum;


type
  TRsLCTrainmanJiaolu = class(TBaseWebInterface)
  public
    //获取机车交路下的人员交路信息
    procedure GetTMJLByTrainJL(TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);

    //获取机车交路下的人员交路，如果机车交路为空则取客户端管辖的所有交路
    procedure GetTMJLByTrainJLWithSite(SiteGUID,TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);

    //获取机车交路下的人员交路，如果机车交路为空则取客户端管辖的所有交路(包含虚拟交路)
    procedure GetTMJLByTrainJLWithSiteVirtual(SiteGUID,TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
    //获取客户端管辖的人员交路列表及交路对应的所有出勤点信息
    procedure GetTMJLOfSite(SiteNumber : string;out JLList : TRsSiteTMJLArray);
  private
      //json->trainmanjiaolu
    procedure JsonToTrainmanJiaolu(var TrainmanJiaolu: RRsTrainmanJiaolu;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainmanJiaolu }
procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJL(
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJL',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;




procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJLWithSite(SiteGUID,
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  json.S['SiteGUID'] := m_strSiteID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJLWithSite',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;
procedure TRsLCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(SiteGUID,
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
begin
  json := CreateInputJson;
  json.S['TrainjiaoluGUID'] := TrainJiaoluGUID ;
  json.S['SiteGUID'] := m_strSiteID ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainmanJL.GetTMJLByTrainJLWithSiteVirtual',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(TrainmanJiaoluArray,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
  end;
end;


procedure TRsLCTrainmanJiaolu.GetTMJLOfSite(SiteNumber: string;
  out JLList: TRsSiteTMJLArray);
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  ErrInfo: string;
  K: Integer;
begin
  json := CreateInputJson;
  json.S['SiteNumber'] := SiteNumber ;
  strResult := Post('TF.RunSafty.BaseDict.LCTrainJL.Site.Trainmanjiaolus',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrInfo) then
  begin
    raise Exception.Create(ErrInfo);
  end;


  jsonArray := json.AsArray;
  SetLength(JLList,jsonArray.Length );
  for I := 0 to jsonArray.Length - 1 do
  begin
    JLList[i].JlName := jsonArray[i].S['JlName'];
    JLList[i].JlGUID := jsonArray[i].S['JlGUID'];
    JLList[i].JlType :=  TRsJiaoluType(jsonArray[i].I['JlType']);
    SetLength(JLList[i].PlaceList ,jsonArray[i].A['PlaceList'].Length);
    for K := 0 to jsonArray[i].A['PlaceList'].Length - 1 do
    begin
      JLList[i].PlaceList[k].ID := jsonArray[i].A['PlaceList'][k].S['ID'];
      JLList[i].PlaceList[k].Name := jsonArray[i].A['PlaceList'][k].S['Name'];
    end;
  end;
end;

procedure TRsLCTrainmanJiaolu.JsonToTrainmanJiaolu(
  var TrainmanJiaolu: RRsTrainmanJiaolu; Json: ISuperObject);
begin
  with TrainmanJiaolu do
  begin
    strTrainmanJiaoluGUID := Json.S['strTrainmanJiaoluGUID'];
    strTrainmanJiaoluName := Json.S['strTrainmanJiaoluName'];
    nJiaoluType := TRsJiaoluType(Json.I['nJiaoluType']);
    strLineGUID := Json.S['strLineGUID'];
    strTrainJiaoluGUID := Json.S['strTrainJiaoluGUID'];
    nKehuoID := TRsKehuo(Json.I['nKehuoID']);
    nTrainmanTypeID := TRsTrainmanType(Json.I['nTrainmanTypeID']);
    nDragTypeID := TRsDragType(Json.I['nDragTypeID']);
    nTrainmanRunType := TRsRunType(Json.I['nTrainmanRunType'])  ;
    //开始车站GUID
    strStartStationGUID :=  Json.S['strStartStationGUID'];
    //开始车站名称
    strStartStationName :=  Json.S['strStartStationName'];
    //结束车站GUID
    strEndStationGUID :=   Json.S['strEndStationGUID'];
    //结束车站名称
    strEndStationName :=  Json.S['strEndStationName'];
    //所属区域
    strAreaGUID :=   Json.S['strAreaGUID'];
  end;
end;

end.
