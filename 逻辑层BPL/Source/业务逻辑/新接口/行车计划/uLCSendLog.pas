unit uLCSendLog;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uTrainPlan;
type
  TLCSendLog = class(TWepApiBase)
  public
    //获取未下发的计划信息
    procedure GetUnRecvSendLog(JDSiteGUID: string;
    FromTime: TDateTime; out SendLogArray: TRsTrainPlanSendLogArray);
  end;
implementation

{ TLCSendLog }

procedure TLCSendLog.GetUnRecvSendLog(JDSiteGUID: string; FromTime: TDateTime;
  out SendLogArray: TRsTrainPlanSendLogArray);
  function JsonToSendLog(iJson: ISuperObject): RRsTrainPlanSendLog;
  begin
    //下发记录GUID
    Result.strSendGUID := iJson.S['strSendGUID'];
    //车次
    Result.strTrainNo := iJson.S['strTrainNo'];
    //机车计划关联GUID
    Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
    //行车区段名称
    Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
    //计划开车时间
    Result.dtStartTime := StrToDateTime(iJson.S['dtStartTime']);
    //实际开车时间
    Result.dtRealStartTime := StrToDateTime(iJson.S['dtRealStartTime']);
    //下发客户端名称
    Result.strSendSiteName := iJson.S['strSendSiteName'];
    //下发时间
    Result.dtSendTime := StrToDateTime(iJson.S['dtSendTime']);
  end;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['SiteGUID'] := JDSiteGUID;
  JSON.S['FromTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',FromTime);

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCSendLog.UnRecvSendLog.Query',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(SendLogArray,JSON.O['Logs'].AsArray.Length);
  for I := 0 to Length(SendLogArray) - 1 do
  begin
    SendLogArray[i] := JsonToSendLog(JSON.O['Logs'].AsArray[i]);
  end;
  
end;
end.
