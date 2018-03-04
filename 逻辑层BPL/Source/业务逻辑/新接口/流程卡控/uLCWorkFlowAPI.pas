unit uLCWorkFlowAPI;

interface
uses
  Classes,SysUtils,uHttpWebAPI,uWorkFlow,uJsonSerialize,superobject;
type
  TConfirmEntity = class(TPersistent)
  private
    m_userNumber: string;
    m_userName: string;
    m_confirmTime: tdatetime;
    m_trainmanNumber: string;
    m_trainmanName: string;
    m_chuqinTime: tdatetime;
    m_trainNo: string;
    m_planID: string;
    m_flowType: string;
    m_confirmBrief: string;
    m_workShopID: string;
    m_workShopName: string;
  published
    property userNumber: string read m_userNumber write m_userNumber;
    property userName: string read m_userName write m_userName;
    property confirmTime: tdatetime read m_confirmTime write m_confirmTime;
    property trainmanNumber: string read m_trainmanNumber write m_trainmanNumber;
    property trainmanName: string read m_trainmanName write m_trainmanName;
    property chuqinTime: tdatetime read m_chuqinTime write m_chuqinTime;
    property trainNo: string read m_trainNo write m_trainNo;
    property planID: string read m_planID write m_planID;
    property flowType: string read m_flowType write m_flowType;
    property confirmBrief: string read m_confirmBrief write m_confirmBrief;
    property workShopID: string read m_workShopID write m_workShopID;
    property workShopName: string read m_workShopName write m_workShopName;
  end;

  
  TLCWorkFlowAPI = class(TWepApiBase)
  public
    procedure AddBWFlow(WorkFlow: TWorkFlow);
    function CheckBWFlow(workShopID,tmid: string;planID: string;Flows: TWorkFlowList): Boolean;
    function CheckEWFlow(workShopID,tmid: string;planID: string;Flows: TWorkFlowList): Boolean;
    function IsUser(const Number: string): Boolean;
    procedure Confirm(Entity: TConfirmEntity);
  end;


  


implementation

{ TLCThirdFlow }

procedure TLCWorkFlowAPI.AddBWFlow(WorkFlow: TWorkFlow);
var
  strOutputData,strResultText : String;
  iJson: ISuperObject;
begin
  iJson := TJsonSerialize.Serialize(WorkFlow);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkFlow.BeginWork.Add',
    iJson.AsString);
    
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;
function TLCWorkFlowAPI.CheckBWFlow(workShopID,tmid: string; planID: string;
  Flows: TWorkFlowList): Boolean;
var
  strOutputData,strResultText : String;
  iJson: ISuperObject;
begin
  iJson := SO();
  iJson.S['tmid'] := tmid;
  iJson.S['planID'] := planID;
  iJson.S['workShopID'] := workShopID;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkFlow.BeginWork.Check',
    iJson.AsString);
    
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  iJson := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(iJson.O['flows'],Flows,TWorkFlow);
  Result := iJson.B['checkRet'];


end;
function TLCWorkFlowAPI.CheckEWFlow(workShopID, tmid, planID: string;
  Flows: TWorkFlowList): Boolean;
begin
  Result := False;
end;

procedure TLCWorkFlowAPI.Confirm(Entity: TConfirmEntity);
var
  strOutputData,strResultText : String;
  iJson: ISuperObject;
begin
  iJson := TJsonSerialize.Serialize(Entity);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkFlow.Confirm.Commit',
    iJson.AsString);
    
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


function TLCWorkFlowAPI.IsUser(const Number: string): Boolean;
var
  strOutputData,strResultText : String;
  iJson: ISuperObject;
begin
  iJson := SO();

  iJson.S['number'] := Number;
  
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkFlow.Confirm.IsUser',
    iJson.AsString);
    
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  iJson := m_WebAPIUtils.GetHttpDataJson(strOutputData);


  Result := iJson.B['exist'];


end;
end.
