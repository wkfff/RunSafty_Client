unit uLCDict_Station;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject;
type
  //��վ��Ϣ�ӿ�
  TRsLCStation = class(TBaseWebInterface)
  public
    {����:�ܹ���·ID��ȡ����Ͻ�ĳ�վ}
    class function Cls_GetByJiaoLu(ConnConfig: RInterConnConfig;JiaoLuID: string;
      var StationArray: TRsStationArray;out ErrStr: string): Boolean;

    {����:�ܹ���·ID��ȡ����Ͻ�ĳ�վ}
    function GetStationsOfJiaoJu(JiaoLuID: string;var StationArray: TRsStationArray;
      out ErrStr: string): Boolean;
  private
    {����:JSON�����л�Ϊ�ṹ��}
    procedure jsonToStation(iJson: ISuperObject;var Station: RRsStation);
  end;

  
implementation

{ TRsLCStation }

function TRsLCStation.GetStationsOfJiaoJu(JiaoLuID: string;
  var StationArray: TRsStationArray;out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
  Station: RRsStation;
begin
  Result := False ;
  json := CreateInputJson;

  json.S['siteID'] := m_strSiteID ;
  json.S['strTrainJiaoluGUID'] := JiaoLuID ;
  
  try

    strResult := Post('TF.RunSafty.BaseDict.LCStation.GetStationsOfJiaoJu',json.AsString);
    
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;

    SetLength(StationArray,jsonArray.Length);
    for I := 0 to jsonArray.Length - 1 do
    begin
      jsonToStation(jsonArray[i],Station);
      StationArray[i] := Station;
    end;

    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;


procedure TRsLCStation.jsonToStation(iJson: ISuperObject;
  var Station: RRsStation);
begin
  Station.strStationGUID := iJson.S['strStationGUID'];
  Station.strStationName := iJson.S['strStationName'];
  Station.strStationNumber := iJson.S['strStationNumber'];
end;

class function TRsLCStation.Cls_GetByJiaoLu(ConnConfig: RInterConnConfig;
  JiaoLuID: string;var StationArray: TRsStationArray;out ErrStr: string): Boolean;
var
  RsLCStation: TRsLCStation;
begin
  RsLCStation := TRsLCStation.Create(ConnConfig.URL,ConnConfig.ClientID,ConnConfig.SiteID);
  try
    Result := RsLCStation.GetStationsOfJiaoJu(JiaoLuID,StationArray,ErrStr);
  finally
    RsLCStation.Free;
  end;
end;

end.
