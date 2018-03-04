unit uLCAnnualLeave;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uSaftyEnum,
  uHttpWebAPI,uJsonSerialize,windows,Contnrs;
type
  TAnnualLeave = class(TPersistent)
  private
    m_ID: string;
    //����ID
    m_WorkShopGUID: string;
    //����Ա����
    m_TrainmanNumber: string;
    //����Ա����
    m_TrainmanName: string;
    //��
    m_Year: integer;
    //��
    m_Month: integer;
    //�ݼ�״̬ 0δ�ݼ� 1���ݼ� 2������
    m_LeaveState: integer;
    //���ݼ�����
    m_LeaveDays: integer;
    //��¼����ʱ��
    m_CreateTime: tdatetime;
    //Ӧ������
    m_NeedDays: integer;
    //ɾ��ԭ��
    m_DelReason: string;
  published
    property ID: string read m_ID write m_ID;
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property TrainmanNumber: string read m_TrainmanNumber write m_TrainmanNumber;
    property TrainmanName: string read m_TrainmanName write m_TrainmanName;
    property Year: integer read m_Year write m_Year;
    property Month: integer read m_Month write m_Month;
    property LeaveState: integer read m_LeaveState write m_LeaveState;
    property LeaveDays: integer read m_LeaveDays write m_LeaveDays;
    property NeedDays: integer read m_NeedDays write m_NeedDays;
    property CreateTime: tdatetime read m_CreateTime write m_CreateTime;
    property DelReason: string read m_DelReason write m_DelReason;
  end;


  TAnnualLeaveList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TAnnualLeave;
    procedure SetItem(Index: Integer; AObject: TAnnualLeave);
  public
    property Items[Index: Integer]: TAnnualLeave read GetItem write SetItem; default;
  end;


  TAnnualQC = class(TPersistent)
  private
    m_ID: string;
    m_Year: integer;
    m_Month: integer;
    m_TrainmanGUID: string;
    m_TrainmanNumber: string;
    m_WorkShopGUID: string;
    m_State: integer;
  published
    property ID: string read m_ID write m_ID;
    property Year: integer read m_Year write m_Year;
    property Month: integer read m_Month write m_Month;
    property TrainmanGUID: string read m_TrainmanGUID write m_TrainmanGUID;
    property TrainmanNumber: string read m_TrainmanNumber write m_TrainmanNumber;
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property State: integer read m_State write m_State;
  end;

  TRsLCAnnualLeave = class(TWepApiBase)
  public
    procedure Add(AnnualLeave: TAnnualLeave);
    procedure Del(ID: string;log: string);
    procedure Get(AnnualQC: TAnnualQC;LeaveList: TAnnualLeaveList);overload;
    function Get(ID: string;AnnualLeave: TAnnualLeave): Boolean;overload;
    procedure BatchAdd(LeaveList: TAnnualLeaveList);
  end;
implementation
function TAnnualLeaveList.GetItem(Index: Integer): TAnnualLeave;
begin
  result := TAnnualLeave(inherited GetItem(Index));
end;
procedure TAnnualLeaveList.SetItem(Index: Integer; AObject: TAnnualLeave);
begin
  Inherited SetItem(Index,AObject);
end;             
{ TRsLCLeaveType }

procedure TRsLCAnnualLeave.Add(AnnualLeave: TAnnualLeave);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AnnualLeave);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAnnualLeave.Add',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCAnnualLeave.BatchAdd(LeaveList: TAnnualLeaveList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(LeaveList);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAnnualLeave.BatchAdd',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCAnnualLeave.Del(ID: string;log: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.S['ID'] := ID;
  JSON.S['log'] := log;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAnnualLeave.Del',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCAnnualLeave.Get(AnnualQC: TAnnualQC; LeaveList: TAnnualLeaveList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := TJsonSerialize.Serialize(AnnualQC);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCAnnualLeave.Get',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);


  TJsonSerialize.DeSerialize(JSON,LeaveList,TAnnualLeave);
end;
function TRsLCAnnualLeave.Get(ID: string; AnnualLeave: TAnnualLeave): Boolean;
var
  AnnualQC: TAnnualQC;
  LeaveList: TAnnualLeaveList;
  iJson: ISuperObject;
begin
  AnnualQC := TAnnualQC.Create;
  LeaveList := TAnnualLeaveList.Create;
  try
    Get(AnnualQC,LeaveList);

    Result := LeaveList.Count > 0;

    if Result then
    begin
      iJson := TJsonSerialize.Serialize(LeaveList.Items[0]);
      TJsonSerialize.DeSerialize(iJson,AnnualLeave);
    end;
  finally
    AnnualQC.Free;
    LeaveList.Free;
  end;
  Result := False;
end;

end.
