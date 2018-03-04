unit uLCDict_TrainType;

interface
uses
  uTrainType,Classes,SysUtils,uBaseWebInterface,superobject;
type
  //机车类型
  TRsLCTrainType = class(TBaseWebInterface)
  public
    //通过车次获取客户类型名称
    function GetKehuoByCheCi(TrainNo: string): string;
    //获取机车类型列表
    procedure GetTrainTypes(TrainTypes: TStrings);
  end;
implementation

{ TRsLCTrainType }

function TRsLCTrainType.GetKehuoByCheCi(TrainNo: string): string;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['TrainNo'] := TrainNo ;
  strResult := Post('TF.Runsafty.Utility.TGlobalDM.GetKehuoByCheCi',json.AsString);
  json.Clear();
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  Result := json.S['Kehuo'] ;
end;

procedure TRsLCTrainType.GetTrainTypes(TrainTypes: TStrings);
var
  json,jTypes: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
begin
  TrainTypes.Clear;
  json := CreateInputJson;
  strResult := Post('TF.Runsafty.BaseDict.LCTrainType.GetTrainTypes',json.AsString);

  json.Clear();
    
  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;
  jTypes := json.O['TrainTypes'];
  for I := 0 to jTypes.AsArray.Length - 1 do
  begin

    TrainTypes.Add(jTypes.AsArray[i].AsString);
  end;
end;

end.
