unit uPlanActionList;

interface

uses
  SysUtils,ActnList,uPlanCommand,uDiaoPlanAction;


type
  //计划动作列表类
  TPlanActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //创建命令操作类
    procedure CreatePlanCmd();
    procedure DestroyPlanCmd();

    //创建ACT类
    procedure CreatePlanAct();
    procedure DestroyPlanAct();
  public
    //增加计划
    actInsertPlan : TAction ;
    //删除计划
    actRemovePlan : TAction ;
    //取消
    actCancelPlan : TAction;
    //下发计划
    actSendPlan : TAction;
    //刷新计划
    actRefreshPlan : TAction;
    //接收计划
    actRecvPlan : TAction ;
    //加载计划
    actLoadPlan : TAction  ;
  private
    //实际的操作类
    //增加计划
    m_CmdInsertPlan : TPlanInsertCmd ;
    //删除计划
    m_CmdRemovePlan : TPlanRemoveCmd;
    //取消
    m_CmdCancelPlan : TPlanCancelCmd;
    //下发计划
    m_CmdSendPlan : TPlanSendCmd;
    //刷新计划
    m_CmdRefreshPlan : TPlanRefreshCmd;
    //接收计划
    m_CmdRecvPlan : TPlanRecvCmd ;
    //加载计划
    m_CmdLoadPlan : TPlanLoadCmd  ;
  end;

implementation

{ TPlanActionList }

constructor TPlanActionList.Create;
begin
  CreatePlanCmd ;
  CreatePlanAct ;

end;

procedure TPlanActionList.CreatePlanAct;
begin
  //增加计划
  actInsertPlan := TAction.Create(nil)  ;
  actInsertPlan.Caption := '增加计划' ;
  actInsertPlan.OnExecute := m_CmdInsertPlan.ActionExecute;
  //删除计划
  actRemovePlan := TAction.Create(nil)  ;
  actRemovePlan.Caption := '删除计划';
  actRemovePlan.OnExecute := m_CmdRemovePlan.ActionExecute;
  //取消
  actCancelPlan := TAction.Create(nil) ;
  actCancelPlan.Caption := '撤销计划';
  actCancelPlan.OnExecute := m_CmdCancelPlan.ActionExecute;
  //下发计划
  actSendPlan := TAction.Create(nil) ;
  actSendPlan.Caption := '下发计划';
  actSendPlan.OnExecute := m_CmdSendPlan.ActionExecute;
  //刷新计划
  actRefreshPlan := TAction.Create(nil) ;
  actRefreshPlan.Caption := '刷新计划';
  actRefreshPlan.OnExecute := m_CmdRefreshPlan.ActionExecute;
  //接收计划
  actRecvPlan := TAction.Create(nil)  ;
  actRecvPlan.Caption := '接收计划';
  actRecvPlan.OnExecute := m_CmdRecvPlan.ActionExecute ;
  //加载计划
  actLoadPlan := TAction.Create(nil)   ;
  actLoadPlan.Caption := '从图定车次表加载';
  actLoadPlan.OnExecute := m_CmdLoadPlan.ActionExecute ;
end;

procedure TPlanActionList.CreatePlanCmd;
begin
  //增加计划
  m_CmdInsertPlan := TPlanInsertCmd.Create ;
  //删除计划
  m_CmdRemovePlan := TPlanRemoveCmd.Create;
  //取消
  m_CmdCancelPlan := TPlanCancelCmd.Create;
  //下发计划
  m_CmdSendPlan := TPlanSendCmd.Create;
  //刷新计划
  m_CmdRefreshPlan := TPlanRefreshCmd.Create;
  //接收计划
  m_CmdRecvPlan := TPlanRecvCmd.Create ;
  //加载计划
  m_CmdLoadPlan := TPlanLoadCmd.Create  ;
end;

destructor TPlanActionList.Destroy;
begin
  DestroyPlanCmd ;
  DestroyPlanAct ;
end;

procedure TPlanActionList.DestroyPlanAct;
begin
  //增加计划
  actInsertPlan.Free ;
  //删除计划
  actRemovePlan.Free ;
  //取消
  actCancelPlan.Free;
  //下发计划
  actSendPlan.Free;
  //刷新计划
  actRefreshPlan.Free;
  //接收计划
  actRecvPlan.Free ;
  //加载计划
  actLoadPlan.Free  ;
end;

procedure TPlanActionList.DestroyPlanCmd;
begin
  //增加计划
  m_CmdInsertPlan.Free;
  //删除计划
  m_CmdRemovePlan.Free;
  //取消
  m_CmdCancelPlan.Free;
  //下发计划
  m_CmdSendPlan.Free;
  //刷新计划
  m_CmdRefreshPlan.Free;
  //接收计划
  m_CmdRecvPlan.Free ;
  //加载计划
  m_CmdLoadPlan.Free  ;
end;

end.
