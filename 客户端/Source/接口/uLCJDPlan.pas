unit uLCJDPlan;

interface
uses
  Classes,SysUtils,uHttpWebAPI,Contnrs,superobject,uJsonSerialize;
type
  TJDPlan = class(TPersistent)
  private
    //���� yyyymmdd
    m_Day: string;
    //��� 0�װ� 1ҹ��
    m_Shift: integer;
    //0����ͼ 1ʵ��ͼ 2�ƻ�
    m_Typ: integer;
    //����
    m_Section_id: string;
    //�г�����
    m_Trainkind: integer;       
    //������id(�ƻ�id)
    m_Train_id: string;
    //����
    m_Train_code: string;
    //����ʱ��
    m_Time_deptart: tdatetime;
    //����ʱ��
    m_Time_arrived: tdatetime;
    //����վ
    m_Station_deptart: string;
    //�յ�վ
    m_Station_arrived: string;
    //������
    m_Loco_num: integer;
    //����
    m_Weight: double;
    //����
    m_Car_count: integer;
    //����
    m_C_length: double;
    //������
    m_Section_name: string;
    
    m_IsUpdate: integer;

    m_PlanGUID: string;
  protected
    procedure AssignTo(Dest: TPersistent); override;
  public
    function CreateClone(): TJDPlan;

  published
    property Day: string read m_Day write m_Day;
    property Shift: integer read m_Shift write m_Shift;
    property Typ: integer read m_Typ write m_Typ;
    property Section_id: string read m_Section_id write m_Section_id;
    property Trainkind: integer read m_Trainkind write m_Trainkind;
    property Train_id: string read m_Train_id write m_Train_id;
    property Train_code: string read m_Train_code write m_Train_code;
    property Time_deptart: tdatetime read m_Time_deptart write m_Time_deptart;
    property Time_arrived: tdatetime read m_Time_arrived write m_Time_arrived;
    property Station_deptart: string read m_Station_deptart write m_Station_deptart;
    property Station_arrived: string read m_Station_arrived write m_Station_arrived;
    property Loco_num: integer read m_Loco_num write m_Loco_num;
    property Weight: double read m_Weight write m_Weight;
    property Car_count: integer read m_Car_count write m_Car_count;
    property C_length: double read m_C_length write m_C_length;
    property Section_name: string read m_Section_name write m_Section_name;
    property PlanGUID: string read m_PlanGUID write m_PlanGUID;
    property IsUpdate: integer read m_IsUpdate write m_IsUpdate;
  end;

  TJDPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TJDPlan;
    procedure SetItem(Index: Integer; AObject: TJDPlan);
  public
    property Items[Index: Integer]: TJDPlan read GetItem write SetItem; default;
  end;

  TTMISSection = class(TPersistent)
  private
    m_Section_id: string;
    m_Section_name: string;
  published
    property Section_id: string read m_Section_id write m_Section_id;
    property Section_name: string read m_Section_name write m_Section_name;
  end;
  
  TTMISSectionList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTMISSection;
    procedure SetItem(Index: Integer; AObject: TTMISSection);
  public
    property Items[Index: Integer]: TTMISSection read GetItem write SetItem; default;
  end;
                      
  TLCJDPlan = class(TWepApiBase)
  public
    procedure QuerySections(SectionList: TTMISSectionList);
    //��ѯ�ƻ��б�
    procedure QueryPlans(JlID: string;SiteNumber : string;BTime,ETime: TDateTime;PlanList: TJDPlanList);
    //�����г��ƻ�
    procedure CreatePlan(Train_id,JiaoluGUID,SiteGUID,UserGUID,SiteNumber,SiteName: string; var planid: string);
    //��ȡ�ͻ��˹�Ͻ������
    procedure GetClientSection(ClientNumber : string;SectionList: TTMISSectionList);
    //ȷ�ϼƻ��Ѿ��յ�(������ʾֵ��Ա�ƻ��б䶯��ȷ�Ϻ�����ʾ)
    procedure ConfirmPlan(Train_id: string);
  end;

  
implementation

function TTMISSectionList.GetItem(Index: Integer): TTMISSection;
begin
  result := TTMISSection(inherited GetItem(Index));
end;
procedure TTMISSectionList.SetItem(Index: Integer; AObject: TTMISSection);
begin
  Inherited SetItem(Index,AObject);
end;           

function TJDPlanList.GetItem(Index: Integer): TJDPlan;
begin                     
  result := TJDPlan(inherited GetItem(Index));
end;
procedure TJDPlanList.SetItem(Index: Integer; AObject: TJDPlan);
begin
  Inherited SetItem(Index,AObject);
end;       
{ TLCJDPlan }

procedure TLCJDPlan.ConfirmPlan(Train_id: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainID'] := Train_id;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTmis.ConfirmPlan',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TLCJDPlan.CreatePlan(Train_id, JiaoluGUID, SiteGUID, UserGUID,
  SiteNumber, SiteName: string;var planid: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['SiteGUID'] := SiteGUID;
  JSON.S['JiaoluGUID'] := JiaoluGUID;
  JSON.S['UserGUID'] := UserGUID;
  JSON.S['SiteNumber'] := SiteNumber;
  JSON.S['SiteName'] := SiteName;
  JSON.S['TrainID'] := Train_id;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTmis.ProduceJDPlan',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := SO(strOutputData);

  planid := JSON.S['planid'];
  
end;

procedure TLCJDPlan.GetClientSection(ClientNumber: string;
  SectionList: TTMISSectionList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  Json.S['strClientID'] := ClientNumber;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTmis.GetSectionByClient',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(JSON,SectionList,TTMISSection);
end;

procedure TLCJDPlan.QueryPlans(JlID: string;SiteNumber : string ;BTime,ETime: TDateTime;
  PlanList: TJDPlanList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['JlID'] := JlID;
  Json.S['SiteNumber'] := SiteNumber;
  JSON.S['BTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BTime);
  JSON.S['ETime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',ETime);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTmis.GetJDPlanList',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(JSON,PlanList,TJDPlan);
end;

procedure TLCJDPlan.QuerySections(SectionList: TTMISSectionList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTmis.GetQDList',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  TJsonSerialize.DeSerialize(JSON,SectionList,TTMISSection);
end;


{ TJDPlan }

procedure TJDPlan.AssignTo(Dest: TPersistent);
var
  json: ISuperObject;
begin
  json := TJsonSerialize.Serialize(Self);
  TJsonSerialize.DeSerialize(json,Dest);
end;

function TJDPlan.CreateClone: TJDPlan;
begin
  Result := TJDPlan.Create();
  Result.Assign(Self);
end;

end.
