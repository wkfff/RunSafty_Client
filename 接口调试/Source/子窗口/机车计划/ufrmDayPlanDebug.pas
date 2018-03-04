unit ufrmDayPlanDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmDebugBase, ComCtrls, StdCtrls, ExtCtrls,uLCDayPlan,uTemplateDayPlan,uSaftyEnum;

type
  TFrmDayPlanDebug = class(TFrmDebugBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RsLCDayPlanSystem: TRsLCDayPlanSystem;
    RsLCDayPlanPlace: TRsLCDayPlanPlace;
    RsLCDayPlanGroup: TRsLCDayPlanGroup;
    RsLCDayPlanModules: TRsLCDayPlanModules;
    RsLCDayPlan: TRsLCDayPlan;
  public
    { Public declarations }
  published
    //����:��ȡ�����ƻ�ϵͳ����Ա����
    procedure IsAdmin();
    //����:��ȡ�ƻ����Ͷ�����Ϣ
    procedure GetTrainTypes();

    //����:��ȡ������ƻ�����
    procedure QueryPlace();

    //����:��ȡָ���ƻ������ڵĻ�������Ϣ
    procedure QueryGroups();
    //����:��ȡָ����������Ϣ
    procedure GetGroup();

    //����:��ȡָ���������ڵļƻ���Ϣ
    procedure QueryModules();
    //����:��ӻ����ƻ�ģ����Ϣ
    procedure AddModule();
    //����:�޸Ļ����ƻ�ģ����Ϣ
    procedure UpdateModule();
    //����:ɾ�������ƻ�ģ����Ϣ
    procedure DeleteModule();
    //����:��ȡ������Ϣģ����Ϣ
    procedure GetModule();

    //����:��ȡָ�����������л����ƻ���Ϣ
    procedure QueryPlans();
    //����:��ȡָ�����������·��ļƻ���Ϣ
    procedure QueryPublishPlans();
    //����:��ȡָ���Ļ����ƻ���Ϣ
    procedure GetPlan();
    //����:��ӻ����ƻ���Ϣ
    procedure AddDayPlan();
    //����:�޸Ļ����ƻ�
    procedure UpdateDayPlan();
    //����:ɾ�������ƻ�
    procedure DeleteDayPlan();
    //����:�·������ƻ�
    procedure SendDayPlan();
    //����:��ģ���м��ػ����ƻ�
    procedure Load();
    //����:���������ƻ�
    procedure ExportPlan();
  end;


implementation
uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
{ TFrmDayPlanDebug }

procedure TFrmDayPlanDebug.AddDayPlan;
var
  Plan: RsDayPlanInfo;
  Log: RsDayPlanLog;
begin
  RsLCDayPlan.AddDayPlan(Plan,Log);
end;

procedure TFrmDayPlanDebug.AddModule;
var
  Module: TRsDayPlanItem;
begin
  Module := TRsDayPlanItem.Create;
  try
    RsLCDayPlanModules.AddModule(Module);
  finally
    Module.Free;
  end;

end;

procedure TFrmDayPlanDebug.DeleteDayPlan;
var
  PlanGUID: string;
  Log: RsDayPlanLog;
begin
  RsLCDayPlan.DeleteDayPlan(PlanGUID,Log);
end;

procedure TFrmDayPlanDebug.DeleteModule;
var
  id: integer;
begin
  id := 1;
  RsLCDayPlanModules.DeleteModule(id);
end;

procedure TFrmDayPlanDebug.ExportPlan;
var
  BeginDate, EndDate: TDateTime;
  DayPlanID,DayOrNight: Integer;
begin
  BeginDate := Now;
  EndDate := Now;
  DayPlanID := 0;
  DayOrNight := 0;
  RsLCDayPlan.ExportPlan(BeginDate, EndDate,
  DayPlanID,DayOrNight);
end;

procedure TFrmDayPlanDebug.FormCreate(Sender: TObject);
begin
  inherited;
  RsLCDayPlanSystem:= TRsLCDayPlanSystem.Create(GlobalDM.WebAPIUtils);
  RsLCDayPlanPlace:= TRsLCDayPlanPlace.Create(GlobalDM.WebAPIUtils);
  RsLCDayPlanGroup:= TRsLCDayPlanGroup.Create(GlobalDM.WebAPIUtils);
  RsLCDayPlanModules:= TRsLCDayPlanModules.Create(GlobalDM.WebAPIUtils);
  RsLCDayPlan:= TRsLCDayPlan.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmDayPlanDebug.FormDestroy(Sender: TObject);
begin
  RsLCDayPlanSystem.Free;
  RsLCDayPlanPlace.Free;
  RsLCDayPlanGroup.Free;
  RsLCDayPlanModules.Free;
  RsLCDayPlan.Free;
end;

procedure TFrmDayPlanDebug.GetGroup;
var
  Group: TRsDayPlanItemGroup;
begin
  Group := TRsDayPlanItemGroup.Create;
  try
    RsLCDayPlanGroup.GetGroup(1,1,Group);
  finally
    Group.Free;
  end;

end;

procedure TFrmDayPlanDebug.GetModule;
var
  ID: Integer;
  Module: TRsDayPlanItem;
begin
  Module := TRsDayPlanItem.Create;
  try
    id := 1;
    RsLCDayPlanModules.GetModule(ID,Module);
  finally
    Module.Free;
  end;

end;

procedure TFrmDayPlanDebug.GetPlan;
var
  PlanGUID: String;
  Plan: RsDayPlanInfo;
begin
  PlanGUID := '';
  RsLCDayPlan.GetPlan(PlanGUID,Plan);
end;

procedure TFrmDayPlanDebug.GetTrainTypes;
var
  TrainTypes: TRsShortTrainArray;
begin
  RsLCDayPlanSystem.GetTrainTypes(TrainTypes);
end;

procedure TFrmDayPlanDebug.IsAdmin;
begin
  RsLCDayPlanSystem.IsAdmin('');
end;

procedure TFrmDayPlanDebug.Load;
var
  GroupID: Integer;
  BeginTime: TDateTime;
  DayPlanTypeID, DayPlanID: Integer;
begin
  GroupID := 0;
  BeginTime := Now;
  DayPlanTypeID := 0;
  DayPlanID := 0;
  RsLCDayPlan.Load(GroupID, BeginTime,DayPlanTypeID, DayPlanID);
end;

procedure TFrmDayPlanDebug.QueryGroups;
var
  Groups: TRsDayPlanItemGroupList;
begin
  Groups := TRsDayPlanItemGroupList.Create;
  try
    RsLCDayPlanGroup.QueryGroups(1,Groups);
  finally
    Groups.Free;
  end;

end;

procedure TFrmDayPlanDebug.QueryModules;
var
  GroupID, DayPlanType: Integer;
  Modules: TRsDayPlanItemList;
begin
  Modules := TRsDayPlanItemList.Create;
  try
    GroupID := 1;
    DayPlanType := 1;
    RsLCDayPlanModules.QueryModules(GroupID,DayPlanType,Modules);
  finally
    Modules.Free;
  end;

end;

procedure TFrmDayPlanDebug.QueryPlace;
var
  PlanList: TRsDayPlanList;
begin
  PlanList := TRsDayPlanList.Create;
  try
    RsLCDayPlanPlace.QueryPlace(PlanList);
  finally
    PlanList.Free;
  end;

end;

procedure TFrmDayPlanDebug.QueryPlans;
var
  BeginDate, EndDate: TDateTime;
  GroupID: Integer;
  PlanList: RsDayPlanInfoArray;
begin
  BeginDate := Now;
  EndDate := Now;
  GroupID := 0;
  RsLCDayPlan.QueryPlans(BeginDate, EndDate,
  GroupID,PlanList);
end;

procedure TFrmDayPlanDebug.QueryPublishPlans;
var
  BeginDate, EndDate: TDateTime;
  GroupID: Integer;
  PlanList: RsDayPlanInfoArray;
begin
  BeginDate := Now;
  EndDate := Now;
  GroupID := 0;
  RsLCDayPlan.QueryPublishPlans(BeginDate, EndDate,
  GroupID,PlanList);
end;

procedure TFrmDayPlanDebug.SendDayPlan;
var
  beginTime,endTime: TDateTime;
  planid: integer;
begin
  beginTime := Now;
  endTime := now;
  planid := 0;
  RsLCDayPlan.SendDayPlan(beginTime,endTime,planid);
end;

procedure TFrmDayPlanDebug.UpdateDayPlan;
var
  Plan: RsDayPlanInfo;
  Log: RsDayPlanLog;
begin
  RsLCDayPlan.UpdateDayPlan(Plan,log);
end;

procedure TFrmDayPlanDebug.UpdateModule;
var
  Module: TRsDayPlanItem;
begin
  Module := TRsDayPlanItem.Create;
  try
    RsLCDayPlanModules.UpdateModule(Module);
  finally
    Module.Free;
  end;

end;

initialization
  ChildFrmMgr.Reg(TFrmDayPlanDebug);
end.
