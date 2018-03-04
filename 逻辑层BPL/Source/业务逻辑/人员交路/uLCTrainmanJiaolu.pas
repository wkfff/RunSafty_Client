unit uLCTrainmanJiaolu;

interface


uses
  SysUtils,uTrainmanJiaolu,superobject,uBaseWebInterface,uSaftyEnum;


type
  TRsLCTrainmanJiaolu = class(TBaseWebInterface)
  public
    //获取机车交路下的人员交路信息
    function GetTrainmanJiaolusOfTrainJiaolu(TrainJiaoluGUID: string;
      out TrainmanJiaoluArray: TRsTrainmanJiaoluArray;out ErrStr:string):Boolean;

  private
      //json->trainmanjiaolu
    procedure JsonToTrainmanJiaolu(var TrainmanJiaolu: RRsTrainmanJiaolu;Json: ISuperObject);
  end;

implementation

{ TRsLCTrainmanJiaolu }

function TRsLCTrainmanJiaolu.GetTrainmanJiaolusOfTrainJiaolu(
  TrainJiaoluGUID: string; out TrainmanJiaoluArray: TRsTrainmanJiaoluArray;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['strTrainjiaoluGUID'] := TrainJiaoluGUID ;
  try
    strResult := Post('TF.Runsafty.NamePlate.NameGroup.GetTrainmanJiaolusOfTrainJiaolu',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainmanJiaoluArray,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToTrainmanJiaolu(TrainmanJiaoluArray[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
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
