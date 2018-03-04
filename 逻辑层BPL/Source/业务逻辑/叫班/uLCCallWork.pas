unit uLCCallWork;

interface

uses
  SysUtils,superobject,uBaseWebInterface,uCallWork;

type

  //****************************
  //  叫班接口
  //****************************

  TRsLCCallWork = class(TBaseWebInterface)
  public
    //发送叫班信息
    function SendCallWork(CallWork:RRsCallWork;out ErrStr:string):Boolean;
    //取消叫班信息
    function CancelCallWork(PlanGUID:string;TrainmanGUID:string;out ErrStr:string):Boolean;
  private
    procedure DataToJson(CallWork:RRsCallWork;Json: ISuperObject);
  end;

implementation

{ TRsLCCallWork }


function TRsLCCallWork.CancelCallWork(PlanGUID:string;TrainmanGUID:string;out ErrStr:string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson ;
  json.S['strPlanGUID'] := PlanGUID ;
  json.S['strTrainmanGUID'] := TrainmanGUID ;
  try
    strResult := Post('cancelcallworkmsg',json.AsString);
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

procedure TRsLCCallWork.DataToJson(CallWork: RRsCallWork; Json: ISuperObject);
begin
  with CallWork do
  begin
    Json.S['strPlanGUID'] := strPlanGUID ;
    Json.S['strMsgGUID'] := strMsgGUID ;
    Json.S['strMsgContent'] := strMsgContent ;
    Json.S['dtStartTime'] := strStartTime ;
    Json.S['dtCreateTime'] := strCreateTime ;

    Json.S['strTrainmanGUID'] := strTrainmanGUID ;
    Json.S['strTrainmanNumber'] := strTrainmanNumber ;
    Json.S['strTrainmanName'] := strTrainmanName ;
    Json.S['strMobileNumber'] := strMobileNumber ;
  end;
end;

function TRsLCCallWork.SendCallWork(CallWork: RRsCallWork;
  out ErrStr: string): Boolean;
var
  json: ISuperObject;
  strResult : string ;
begin
  Result := False ;
  json := CreateInputJson ;
  DataToJson(CallWork,json);
  try
    strResult := Post('SubmitNeedCallWorkMsg',json.AsString);
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
