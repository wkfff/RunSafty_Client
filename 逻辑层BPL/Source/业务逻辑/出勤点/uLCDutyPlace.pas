unit uLCDutyPlace;

interface

uses
  SysUtils,superobject,uDutyPlace,uBaseWebInterface;

type


  TRsLCDutyPlace = class(TBaseWebInterface)
  public
    //根据交路ID获取出勤点
    function GetDutyPlaceByJiaoLu(JiaoLuID:string;out DutyPlaceList:TRsDutyPlaceList;out ErrStr:string):Boolean;
    //根据交路ID和客户端的SITE获取出勤点
    function GetDutyPlaceByClient(JiaoLuID:string; out DutyPlaceList:TRsDutyPlaceList;out ErrStr:string):Boolean;

    //获取出勤点列表
    procedure GetDutyPlaceList(out DutyPlaceList:TRsDutyPlaceList);
    //获取客户端所在出勤地点
    function GetSiteDutyPlace(SiteID: string; out DutyPlace:RRsDutyPlace): Boolean;
  private
    procedure JsonToData(var DutyPlace:RRsDutyPlace;Json: ISuperObject);
  end;


implementation

{ TRsChuQinPlace }

function TRsLCDutyPlace.GetDutyPlaceByJiaoLu(JiaoLuID: string;
  out DutyPlaceList:TRsDutyPlaceList;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainjiaoluID'] := JiaoLuID ;
  try
    strResult := Post('TF.Runsafty.LCDutyPlace.GetPlaceOfTrainJiaolu',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(DutyPlaceList,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
      JsonToData(DutyPlaceList[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;




procedure TRsLCDutyPlace.GetDutyPlaceList(out DutyPlaceList: TRsDutyPlaceList);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
  I: Integer;
begin
  json := CreateInputJson;

  json.S['siteID'] := SiteID ;
  
  strResult := Post('TF.Runsafty.DutyPlace.LCDutyPlace.GetAllPlace',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;



  SetLength(DutyPlaceList,json.AsArray.Length);
  for I := 0 to length(DutyPlaceList) - 1 do
  begin
    JsonToData(DutyPlaceList[i],json.AsArray[i]);
  end;

end;

function TRsLCDutyPlace.GetSiteDutyPlace(SiteID: string;
  out DutyPlace: RRsDutyPlace): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  Result := True;
  json := CreateInputJson;

  json.S['siteID'] := SiteID ;
  
  strResult := Post('TF.Runsafty.DutyPlace.LCDutyPlace.Site.GetPlace',json.AsString);

  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  JsonToData(DutyPlace,json);
end;

function TRsLCDutyPlace.GetDutyPlaceByClient( JiaoLuID: string;
  out DutyPlaceList:TRsDutyPlaceList;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;

  json.S['siteID'] := m_strSiteID ;
  json.S['trainjiaoluID'] := JiaoLuID ;
  
  try

    strResult := Post('TF.Runsafty.LCDutyPlace.GetPlaceOfClient',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(DutyPlaceList,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
      JsonToData(DutyPlaceList[i],jsonArray[i]);
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


procedure TRsLCDutyPlace.JsonToData(var DutyPlace: RRsDutyPlace;
  Json: ISuperObject);
begin
  with DutyPlace do
  begin
    placeID  := Json.S['placeID'];
    placeName  := Json.S['placeName'];
  end;
end;

end.
