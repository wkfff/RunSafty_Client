unit uLCSendLog;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uTrainPlan;
type
  TLCSendLog = class(TWepApiBase)
  public
    //��ȡδ�·��ļƻ���Ϣ
    procedure GetUnRecvSendLog(JDSiteGUID: string;
    FromTime: TDateTime; out SendLogArray: TRsTrainPlanSendLogArray);
  end;
implementation

{ TLCSendLog }

procedure TLCSendLog.GetUnRecvSendLog(JDSiteGUID: string; FromTime: TDateTime;
  out SendLogArray: TRsTrainPlanSendLogArray);
  function JsonToSendLog(iJson: ISuperObject): RRsTrainPlanSendLog;
  begin
    //�·���¼GUID
    Result.strSendGUID := iJson.S['strSendGUID'];
    //����
    Result.strTrainNo := iJson.S['strTrainNo'];
    //�����ƻ�����GUID
    Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
    //�г���������
    Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
    //�ƻ�����ʱ��
    Result.dtStartTime := StrToDateTime(iJson.S['dtStartTime']);
    //ʵ�ʿ���ʱ��
    Result.dtRealStartTime := StrToDateTime(iJson.S['dtRealStartTime']);
    //�·��ͻ�������
    Result.strSendSiteName := iJson.S['strSendSiteName'];
    //�·�ʱ��
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
