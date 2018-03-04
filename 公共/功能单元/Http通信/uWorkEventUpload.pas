unit uWorkEventUpload;

interface
uses
  uDBStation,uHttpComm,uRunSafetyInterfaceDefine,uGlobalDM,uTrainman,SysUtils;
procedure PostWorkEvent(Trainman: RTrainman;EventType: TCWYEventType);

implementation
procedure PostWorkEvent(Trainman: RTrainman;EventType: TCWYEventType);
var
  CWYEventHttp: TCWYEventHttp;
  WorkEvent: RRSCWYEvent;
  HttpResult: RHttpResult;
begin
  CWYEventHttp := TCWYEventHttp.Create;
  try
    WorkEvent.etime := Now;
    WorkEvent.tmid := Trainman.strTrainmanNumber;
    WorkEvent.tmname := Trainman.strTrainmanName;
    WorkEvent.stmis :=
      TDBStation.GetStationNumerByID(GlobalDM.ADOConnection,GlobalDM.SiteInfo.strStationGUID);
    WorkEvent.nresult := 0;
    if EventType = cweBeginWork then
      WorkEvent.strResult := '出勤成功'
    else
      WorkEvent.strResult := '退勤成功';

    WorkEvent.sjbz := EventType;

    CWYEventHttp.URLHost := GlobalDM.URLHost;
    CWYEventHttp.CWYEvent := WorkEvent;
    HttpResult := CWYEventHttp.Upload;

    if HttpResult.nResult <> 0 then
    begin
      raise Exception.Create(HttpResult.strResult);
    end;
      
  finally
    CWYEventHttp.Free;
  end;;

end;

end.
