unit uLCTrainJiaolu;

interface

uses
  SysUtils,Classes,uTrainman,superobject,uBaseWebInterface,uTrainJiaolu;

type
  //机车交路接口
  TRsLCTrainJiaolu = class(TBaseWebInterface)
  public
      //获取行车区段根据客户端
    function GetTrainJiaoluBySite(out TrainJiaoluArray: TRsTrainJiaoluArray;out ErrStr:string):Boolean;
  private
      //json->TrainJiaolu
    procedure JsonToTrainJiaolu(var TrainJiaolu: RRsTrainJiaolu;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainJiaolu }

function TRsLCTrainJiaolu.GetTrainJiaoluBySite(
  out TrainJiaoluArray: TRsTrainJiaoluArray; out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strSiteGUID'] := m_strSiteID ;

  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetAllTrainJiaoluArrayOfSite',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainJiaoluArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainJiaolu(TrainJiaoluArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


procedure TRsLCTrainJiaolu.JsonToTrainJiaolu(var TrainJiaolu: RRsTrainJiaolu;
  Json: ISuperObject);
begin
  with TrainJiaolu do
  begin
    TrainJiaolu.strTrainJiaoluGUID := Json.S['strTrainJiaoluGUID'];
    TrainJiaolu.strTrainJiaoluName := Json.S['strTrainJiaoluName'];
    TrainJiaolu.strStartStation := Json.S['strStartStation'];
    TrainJiaolu.strEndStation := Json.S['strEndStation'];
    TrainJiaolu.strWorkShopGUID := Json.S['strWorkShopGUID'];
    TrainJiaolu.bIsBeginWorkFP := Json.i['bIsBeginWorkFP'];
    TrainJiaolu.strStartStationName := Json.S['strStartStationName'];
    TrainJiaolu.strEndStationName := Json.S['strEndStationName'];
  end;
end;

end.
