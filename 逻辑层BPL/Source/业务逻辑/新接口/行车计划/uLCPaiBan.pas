unit uLCPaiBan;

interface
uses
  superobject,SysUtils,Classes,Contnrs,uHttpWebAPI,uSaftyEnum,uDutyUser,uTrainPlan;
type
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TPaiBan
  /// ˵��:TPaiBan�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TLCPaiBan = Class(TWepApiBase)
  public
     //����:�����ƻ��Ļ���
    procedure ExchangeGroup(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser);
    //����:Ϊ�ƻ����û���
    procedure SetGroup(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser);
    //����:�Զ��ɰ�
    procedure AutoDispatch(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser);
    //����:�����ƻ�
    procedure PublishPlan(PlanGUIDs : String;DutyGUID : String;SiteGUID : String);
   //����:����Ա���ŵ��ƻ���ָ��λ����
    procedure SetTrainmanToPlan(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser);
    //��ȡ�ɰ�дʵ��¼
    procedure GetXSTrainmanPlans(dtBeginTime,dtEndTime: TDateTime;jiaolus: TStrings;out Plans: TRsTrainmanPlanArray);
    //���üƻ���Ԣ����Ϣ
    procedure SetPlanRest(PlanGUID: string;RestInfo: RRsRest);
    //��ȡ�ƻ��䶯��־
    procedure GetChangeTrainPlanLog(TrainPlanGUID: string;out Logs: TRsTrainPlanChangeLogArray);
  end;
  
implementation

uses uLCTrainPlan;

function EnExchangeGroupInputJSON(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser):String;
//����:����(�����ƻ��Ļ���)�ӿ��������JSON�ַ���
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['SourcePlanGUID'] := SourcePlanGUID;
    JSON.S['DestPlanGUID'] := DestPlanGUID;
    ItemJSON := SO('{}');
    ItemJSON.S['strDutyGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['strDutyNumber'] := DutyUser.strDutyNumber;
    ItemJSON.S['strDutyName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.ExchangeGroup(SourcePlanGUID : String;DestPlanGUID : String;DutyUser : TRsDutyUser);
//����:�����ƻ��Ļ���
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnExchangeGroupInputJSON(SourcePlanGUID,DestPlanGUID,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.ExchangeGroup',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TLCPaiBan.GetChangeTrainPlanLog(TrainPlanGUID: string;
  out Logs: TRsTrainPlanChangeLogArray);
  function JsonToLog(iJson: ISuperObject): RRsTrainPlanChangeLog;
  begin
    //�ƻ�GUID
    Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
    //��������
    Result.strTrainTypeName := iJson.S['strTrainTypeName'];
    //������
    Result.strTrainNumber := iJson.S['strTrainNumber'];
    {����}
    Result.strTrainNo := iJson.S['strTrainNo'];
    //�ƻ�����ʱ��
    Result.dtStartTime := StrToDateTime(iJson.S['dtStartTime']);
  
    {������·}
    Result.strTrainJiaoluGUID := iJson.S['strTrainJiaoluGUID'];
    //������·����
    Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
    {��ʼվGUID}
    Result.strStartStation := iJson.S['strStartStation'];
    //��ʼվ����
    Result.strStartStationName := iJson.S['strStartStationName'];
    {�յ�վGUID}
    Result.strEndStation := iJson.S['strEndStation'];
    //�յ�վ����
    Result.strEndStationName := iJson.S['strEndStationName'];
    //ֵ�˷�ʽ
    Result.nTrainmanTypeID := TRsTrainmanType(iJson.I['nTrainmanTypeID']);
  
    Result.strTrainmanTypeName := iJson.S['strTrainmanTypeName'];
    //�ƻ�����
    Result.nPlanType := TRsPlanType(iJson.I['nPlanType']);
    Result.strPlanTypeName := iJson.S['strPlanTypeName'];
    //ǣ��״̬
    Result.nDragType := TRsDragType(iJson.I['nDragType']);
    Result.strDragTypeName := iJson.S['strDragTypeName'];
    //�ͻ�
    Result.nKeHuoID := TRsKehuo(iJson.I['nKeHuoID']);
    Result.strKehuoName := iJson.S['strKehuoName'];
    //��ע����
    Result.nRemarkType := TRsPlanRemarkType(iJson.I['nRemarkType']);
    Result.strRemarkTypeName := iJson.S['strRemarkTypeName'];
    //��ע����
    Result.strRemark := iJson.S['strRemark'];
    //�ƻ�״̬
    Result.nPlanState := TRsPlanState(iJson.I['nPlanState']);
    {��¼����ʱ��}
    Result.dtCreateTime := StrToDateTime(iJson.S['dtCreateTime']);
    //�ı�ʱ��
    Result.dtChangeTime := StrToDateTime(iJson.S['dtChangeTime']);
  end;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['TrainPlanGUID'] := TrainPlanGUID;

  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.TrainPlan.Log.Query',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Logs'];

  SetLength(Logs,JSON.AsArray.Length);

  for I := 0 to Length(Logs) - 1 do
  begin
    Logs[i] := JsonToLog(JSON.AsArray[i]);
  end;

end;



procedure TLCPaiBan.GetXSTrainmanPlans(dtBeginTime, dtEndTime: TDateTime;
  jiaolus: TStrings; out Plans: TRsTrainmanPlanArray);
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
  I: Integer;
begin
  JSON := SO;
  JSON.S['dtBeginTime'] := TimeToJSONString(dtBeginTime);
  JSON.S['dtEndTime'] := TimeToJSONString(dtEndTime);
  JSON.S['jiaolus'] := jiaolus.CommaText;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.GetXS',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['Plans'];

  SetLength(Plans,JSON.AsArray.Length);

  for I := 0 to Length(Plans) - 1 do
  begin
    TRsLCTrainPlan.JsonToTrainmanPlan(Plans[i],JSON.AsArray[i]);
  end;

end;


function EnSetGroupInputJSON(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser):String;
//����:����(Ϊ�ƻ����û���)�ӿ��������JSON�ַ���
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['PlanGUID'] := PlanGUID;
    JSON.S['GroupGUID'] := GroupGUID;
    ItemJSON := SO('{}');
    ItemJSON.S['strDutyGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['strDutyNumber'] := DutyUser.strDutyNumber;
    ItemJSON.S['strDutyName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.SetGroup(PlanGUID : String;GroupGUID : String;DutyUser : TRsDutyUser);
//����:Ϊ�ƻ����û���
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnSetGroupInputJSON(PlanGUID,GroupGUID,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.SetGroup',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
        

procedure TLCPaiBan.SetPlanRest(PlanGUID: string; RestInfo: RRsRest);
  function RestToJson(): ISuperObject;
  begin
    Result := SO();
    //�Ƿ���Ҫǿ�� 0:����Ҫ��1����Ҫ
    Result.I['nNeedRest'] := RestInfo.nNeedRest;
    //����ʱ��
    Result.S['dtArriveTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',RestInfo.dtArriveTime);
    //�а�ʱ��
    Result.S['dtCallTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',RestInfo.dtCallTime);
  end;
var
  strOutputData,strResultText : String;
  JSON: ISuperObject;
begin
  JSON := SO;
  JSON.S['PlanGUID'] := PlanGUID;
  JSON.O['RestInfo'] := RestToJson();


  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCPaiBan.SetPlanRest',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
function EnAutoDispatchInputJSON(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser):String;
//����:����(�Զ��ɰ�)�ӿ��������JSON�ַ���
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainJiaoluGUID'] := TrainJiaoluGUID;
    JSON.S['PlanGUIDs'] := PlanGUIDs;
    ItemJSON := SO('{}');
    ItemJSON.S['userID'] := DutyUser.strDutyGUID;
    ItemJSON.S['userName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;


procedure TLCPaiBan.AutoDispatch(TrainJiaoluGUID : String;PlanGUIDs : String;DutyUser : TRsDutyUser);
//����:�Զ��ɰ�
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnAutoDispatchInputJSON(TrainJiaoluGUID,PlanGUIDs,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.AutoDispatch',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;



function EnPublishPlanInputJSON(PlanGUIDs : String;DutyGUID : String;SiteGUID : String):String;
//����:����(�����ƻ�)�ӿ��������JSON�ַ���
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['PlanGUIDs'] := PlanGUIDs;
    JSON.S['DutyGUID'] := DutyGUID;
    JSON.S['SiteGUID'] := SiteGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;   

procedure TLCPaiBan.PublishPlan(PlanGUIDs : String;DutyGUID : String;SiteGUID : String);
//����:�����ƻ�
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnPublishPlanInputJSON(PlanGUIDs,DutyGUID,SiteGUID);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.PublishPlan',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


 
function EnGetLastArrvieTimeInputJSON(TrainPlanGUID : String):String;
//����:����(��ȡ�ƻ���󵽴�ʱ��)�ӿ��������JSON�ַ���
var
  JSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure DeGetLastArrvieTimeOutputJSON(strJSON:String; var ArriveTime : TDateTime);
//����:����(��ȡ�ƻ���󵽴�ʱ��)�ӿڷ��ز���
var
  JSON : ISuperObject;
begin
  JSON := SO(strJSON);
  JSON := JSON.O['data'];
  try
    if JSON.S['ArriveTime'] <> '' then
      ArriveTime := StrToDateTime(JSON.S['ArriveTime']);
  finally
    JSON := nil;
  end;       
end;

      

function EnSetTrainmanToPlanInputJSON(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser):String;
//����:����(����Ա���ŵ��ƻ���ָ��λ����)�ӿ��������JSON�ַ���
var
  JSON,ItemJSON : ISuperObject;
begin
  Result := '';
  JSON := SO('{}');
  try
    JSON.S['TrainPlanGUID'] := TrainPlanGUID;
    JSON.S['TrainmanNumber'] := TrainmanNumber;
    JSON.I['TrainmanIndex'] := TrainmanIndex;
    ItemJSON := SO('{}');
    ItemJSON.S['userGUID'] := DutyUser.strDutyGUID;
    ItemJSON.S['userID'] := DutyUser.strDutyNumber;
    ItemJSON.S['userName'] := DutyUser.strDutyName;
    JSON.O['DutyUser'] := ItemJSON;
    Result := JSON.AsString;
  finally
    JSON := nil;
  end;
end;

procedure TLCPaiBan.SetTrainmanToPlan(TrainPlanGUID : String;TrainmanNumber : String;TrainmanIndex : Integer;DutyUser : TRsDutyUser);
//����:����Ա���ŵ��ƻ���ָ��λ����
var
  strInputData,strOutputData,strResultText : String;
begin
  strInputData := EnSetTrainmanToPlanInputJSON(TrainPlanGUID,TrainmanNumber,TrainmanIndex,DutyUser);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.Plan.PaiBan.SetTrainman',strInputData);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;    
end.
