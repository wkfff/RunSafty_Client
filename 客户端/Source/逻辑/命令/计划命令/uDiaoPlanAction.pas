unit uDiaoPlanAction;

interface
uses
  uSite,Windows,SysUtils,uTrainJiaolu ;

type

  //调度端命令计划动作类
  TDiaoDuPlanAction = class
  public
    //增加计划
    procedure InsertPlan();
    //删除计划
    procedure RemovePlan();
    //撤销计划
    procedure CancelPlan();
    //下发计划
    procedure SendPlan();
    //刷新计划
    procedure RefreshPlan();
    //接收计划
    procedure RecvPlan();
    //加载计划
    procedure LoadPlan();
  end;


implementation

uses
  uFrmTrainPlan,ufrmTrainplanExport ;

{ TPlanAction }

procedure TDiaoDuPlanAction.CancelPlan;
begin
  FrmTrainPlan.CancelPlan ;
end;


procedure TDiaoDuPlanAction.InsertPlan;
begin
  FrmTrainPlan.InsertPlan ;
end;

procedure TDiaoDuPlanAction.LoadPlan;
begin
  FrmTrainPlan.LoadPlan ;
end;

procedure TDiaoDuPlanAction.RecvPlan;
begin
  //
end;

procedure TDiaoDuPlanAction.RefreshPlan;
begin
  FrmTrainPlan.InitTrainPlan ;
end;

procedure TDiaoDuPlanAction.RemovePlan;
begin
  FrmTrainPlan.RemovePlan ;
end;

procedure TDiaoDuPlanAction.SendPlan;
begin
  FrmTrainPlan.SendPlan ;
end;

end.
