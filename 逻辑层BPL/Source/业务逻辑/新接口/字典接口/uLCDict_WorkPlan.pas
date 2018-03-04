unit uLCDict_WorkPlan;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject;
type
  TRsLCWorkPlan = class(TBaseWebInterface)
  public
    //根据库接和站接以及出勤点确定出勤时间
    function GetPlanTimes(RemakType:Integer;PlaceID:string;var ATime:Integer):Boolean;  
  end;
implementation

{ TRsLCWorkPlan }

function TRsLCWorkPlan.GetPlanTimes(RemakType: Integer; PlaceID: string;
  var ATime: Integer): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;

  json.I['RemarkType'] := RemakType ;
  json.S['PlaceID'] := PlaceID ;
  
  strResult := Post('TF.RunSafty.BaseDict.LCWorkPlan.GetPlanTimes',json.AsString);
    
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  ATime := json.I['result'];

  Result := ATime <> 0;
end;
end.
