unit uLCTrainnos;

interface

uses
  SysUtils,Classes,uTrainnos,superobject,uBaseWebInterface;

type


  TRsLCTrainnos = class(TBaseWebInterface)
  public
    //根据交路GUID获取图定车次表
    function GetByJiaoLu(TrainjiaoluID:string;out TrainnosInfoList:TRsTrainnosInfoList;out ErrStr:string):Boolean;
    //加载指定交路GUID的指定时间段的车次表
    function Load(TrainjiaoluID:string;StartDate,EndDate:TDateTime;PlanState : integer;out ErrStr:string):Boolean;
    //加载指定交路GUID的指定时间段的车次表
    function LoadAndSend(TrainjiaoluID:string;StartDate,EndDate:TDateTime;out ErrStr:string):Boolean;
    //根据车此ID获取图定车次表
    function GetByID(TrainnoID:string;out TrainnosInfo:RRsTrainnosInfo;out ErrStr:string):Boolean;
    //修改图定车次表
    function Modify(TrainnosInfo:RRsTrainnosInfo;out ErrStr:string):Boolean;
    //添加图定车次
    function Add(TrainnosInfo:RRsTrainnosInfo;out ErrStr:string):Boolean;
    //删除图定车次
    function Delete(TrainnoID:string;out ErrStr:string):Boolean;
    //删除一个交路的图定车次
    function DeleteByJiaoLu(TrainjiaoluID:string;out ErrStr:string):Boolean;
  private
    procedure JsonToData(var TrainnosInfo:RRsTrainnosInfo;Json: ISuperObject);
    procedure DataToJson(Json: ISuperObject;TrainnosInfo:RRsTrainnosInfo);
  end;



implementation

{ TRsLCTrainnos }


{ TRsLCTrainnos }

function TRsLCTrainnos.Add(TrainnosInfo: RRsTrainnosInfo;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  jsonTrainnoInfo : ISuperObject ;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;

  //产生TrainnoInfo信息
  jsonTrainnoInfo := SO('{}');
  DataToJson(jsonTrainnoInfo,TrainnosInfo);

  //添加trainnoInfo Object
  json.O['trainnoInfo'] := jsonTrainnoInfo ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.Add',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    TrainnosInfo.trainNoID := json.S['trainnoID'];
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;



procedure TRsLCTrainnos.DataToJson(Json: ISuperObject;
  TrainnosInfo: RRsTrainnosInfo);
begin
  with   TrainnosInfo do
  begin
    json.S['trainjiaoluID'] := trainjiaoluID ;
    json.S['trainjiaoluName'] := trainjiaoluName ;
    json.S['placeID'] := placeID ;
    json.S['placeName'] := placeName ;
    Json.S['trainTypeName'] := trainTypeName ;
    json.S['trainNumber'] := trainNumber ;
    json.S['trainNo'] := trainNo ;
    json.S['remark'] := remark ;
    json.S['startTime'] := startTime ;
    Json.S['kaiCheTime'] := kaiCheTime;
    json.S['startStationID'] := startStationID ;
    json.S['startStationName'] := startStationName ;
    json.S['endStationID'] := endStationID ;
    json.S['endStationName'] := endStationName ;
    json.S['trainmanTypeID'] := trainmanTypeID ;
    json.S['trainmanTypeName'] := trainmanTypeName ;
    json.S['planTypeID'] := planTypeID ;
    json.S['planTypeName'] := planTypeName ;
    json.S['dragTypeID'] := dragTypeID ;
    json.S['dragTypeName'] := dragTypeName ;
    json.S['kehuoID'] := kehuoID ;
    json.S['kehuoName'] := kehuoName ;
    json.S['remarkTypeID'] := remarkTypeID ;
    json.S['remarkTypeName'] := remarkTypeName ;
    json.S['trainNoID'] := trainNoID ;
    json.I['nNeedRest'] :=  nNeedRest   ;
    json.S['dtArriveTime'] := dtArriveTime  ;
    json.S['dtCallTime'] := dtCallTime ;
    Json.S['strWorkDay'] := strWorkDay ;
  end;
end;

function TRsLCTrainnos.Delete(TrainnoID: string;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainnoID'] := TrainnoID ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.Delete',json.AsString);

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



function TRsLCTrainnos.DeleteByJiaoLu(TrainjiaoluID: string;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['TrainjiaoluID'] := TrainjiaoluID ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.DeleteByJiaoLu',json.AsString);

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

function TRsLCTrainnos.GetByJiaoLu(TrainjiaoluID: string;
  out TrainnosInfoList: TRsTrainnosInfoList;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  jsonArray : TSuperArray;
  strResult : string ;
  i:Integer;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainjiaoluID'] := trainjiaoluID ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.Trainjiaolu.Get',json.AsString);

    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    jsonArray := json.AsArray;
    SetLength(TrainnosInfoList,jsonArray.Length );
    for I := 0 to jsonArray.Length - 1 do
    begin
      JsonToData(TrainnosInfoList[i],jsonArray[i]);
    end;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;

end;

function TRsLCTrainnos.Load(TrainjiaoluID: string; StartDate,
  EndDate: TDateTime;PlanState : integer;out ErrStr:string): Boolean;
var
  json: ISuperObject ;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson ;
  json.S['trainjiaoluID'] := trainjiaoluID ;
  json.S['beginTime'] :=  FormatDateTime('yyyy-MM-dd HH:mm:ss',StartDate);
  json.S['endTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  json.I['planState'] := PlanState;

  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.LoadTrainnos',json.AsString);
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

function TRsLCTrainnos.LoadAndSend(TrainjiaoluID: string; StartDate,
  EndDate: TDateTime; out ErrStr: string): Boolean;
var
  json: ISuperObject ;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson ;
  json.S['trainjiaoluID'] := trainjiaoluID ;
  json.S['beginTime'] :=  FormatDateTime('yyyy-MM-dd HH:mm:ss',StartDate);
  json.S['endTime'] := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.LoadAndSendTrainNos',json.AsString);
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

function TRsLCTrainnos.GetByID(TrainnoID: string;
  out TrainnosInfo: RRsTrainnosInfo;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;
  json.S['trainnoID'] := TrainnoID ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.Find',json.AsString);
    json.Clear();
    if not GetJsonResult(strResult,json,ErrStr) then
      Exit;

    JsonToData(TrainnosInfo,json) ;
    Result := True ;
  except
    on e:Exception do
    begin
      ErrStr := e.Message ;
    end;
  end;
end;

procedure TRsLCTrainnos.JsonToData(var TrainnosInfo: RRsTrainnosInfo;
  Json: ISuperObject);
begin
  with   TrainnosInfo do
  begin
    trainjiaoluID := json.S['trainjiaoluID'] ;
    trainjiaoluName := json.S['trainjiaoluName'] ;
    placeID := json.S['placeID'] ;
    placeName := json.S['placeName'] ;
    trainTypeName := Json.S['trainTypeName'];
    trainNumber := json.S['trainNumber'] ;
    trainNo := json.S['trainNo'];
    remark := json.S['remark'] ;
    if Json.S['startTime'] <> '' then
      startTime := json.S['startTime'] ;
    if Json.S['kaiCheTime'] <> '' then
      kaiCheTime := json.S['kaiCheTime'] ;
    startStationID := json.S['startStationID'] ;
    startStationName := json.S['startStationName'] ;
    endStationID := json.S['endStationID'] ;
    endStationName := json.S['endStationName'] ;
    trainmanTypeID := json.S['trainmanTypeID'] ;
    trainmanTypeName := json.S['trainmanTypeName'] ;
    planTypeID := json.S['planTypeID'] ;
    planTypeName := json.S['planTypeName'] ;
    dragTypeID := json.S['dragTypeID'] ;
    dragTypeName := json.S['dragTypeName'] ;
    kehuoID := json.S['kehuoID'] ;
    kehuoName := json.S['kehuoName'] ;
    remarkTypeID := json.S['remarkTypeID'] ;
    remarkTypeName := json.S['remarkTypeName'] ;
    trainNoID := json.S['trainNoID'] ;

    nNeedRest :=  json.I['nNeedRest'] ;
    if Json.S['dtArriveTime'] <> '' then
      dtArriveTime := json.S['dtArriveTime'] ;

    if Json.S['dtCallTime'] <> '' then
      dtCallTime := json.S['dtCallTime'] ;

    strWorkDay := Json.S['strWorkDay'];
  end;
end;


function TRsLCTrainnos.Modify(TrainnosInfo: RRsTrainnosInfo;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  jsonTrainnoInfo : ISuperObject ;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson;

  //产生TrainnoInfo信息
  jsonTrainnoInfo := SO('{}');
  DataToJson(jsonTrainnoInfo,TrainnosInfo);

  //添加trainnoInfo Object
  json.O['trainnoInfo'] := jsonTrainnoInfo ;
  try
    strResult := Post('TF.Runsafty.TrainNo.LCTrainno.Update',json.AsString);
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
