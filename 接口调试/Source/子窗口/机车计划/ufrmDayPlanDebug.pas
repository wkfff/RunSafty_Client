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
    //功能:获取机车计划系统管理员密码
    procedure IsAdmin();
    //功能:获取计划车型定义信息
    procedure GetTrainTypes();

    //功能:获取机车班计划区域
    procedure QueryPlace();

    //功能:获取指定计划区域内的机车组信息
    procedure QueryGroups();
    //功能:获取指定机车组信息
    procedure GetGroup();

    //功能:获取指定机车组内的计划信息
    procedure QueryModules();
    //功能:添加机车计划模版信息
    procedure AddModule();
    //功能:修改机车计划模版信息
    procedure UpdateModule();
    //功能:删除机车计划模版信息
    procedure DeleteModule();
    //功能:获取机车信息模版信息
    procedure GetModule();

    //功能:获取指定机车的所有机车计划信息
    procedure QueryPlans();
    //功能:获取指定机车的已下发的计划信息
    procedure QueryPublishPlans();
    //功能:获取指定的机车计划信息
    procedure GetPlan();
    //功能:添加机车计划信息
    procedure AddDayPlan();
    //功能:修改机车计划
    procedure UpdateDayPlan();
    //功能:删除机车计划
    procedure DeleteDayPlan();
    //功能:下发机车计划
    procedure SendDayPlan();
    //功能:从模版中加载机车计划
    procedure Load();
    //功能:导出机车计划
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
