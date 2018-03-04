unit uPlanCommand;

interface

uses
  Classes,uDiaoPlanAction ;

type

  //计划基类命令
  TPlanCommand = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //执行动作
    procedure ActionExecute(Sender: TObject);
    //执行动作
    procedure Action();virtual;
  protected
    m_actPlanAction:TDiaoDuPlanAction ;
  end;

  //增加计划
  TPlanInsertCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //删除计划
  TPlanRemoveCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
    //撤销计划
  //导出命令
  TPlanCancelCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //下发计划
  TPlanSendCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //刷新计划
  TPlanRefreshCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //接收计划
  TPlanRecvCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //加载计划
  TPlanLoadCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;



implementation

{ TPlanCommand }

procedure TPlanCommand.Action;
begin
  ;
end;

procedure TPlanCommand.ActionExecute(Sender: TObject);
begin
  Action ;
end;

constructor TPlanCommand.Create();
begin
  m_actPlanAction := TDiaoDuPlanAction.Create ;
end;

destructor TPlanCommand.Destroy;
begin
  m_actPlanAction.Free ;
end;


{ TPlanInsertCmd }

procedure TPlanInsertCmd.Action;
begin
  m_actPlanAction.InsertPlan ;
end;

{ TPlanRemoveCmd }

procedure TPlanRemoveCmd.Action;
begin
  m_actPlanAction.RemovePlan ;
end;

{ TPlanCancelCmd }

procedure TPlanCancelCmd.Action;
begin
  m_actPlanAction.CancelPlan ;
end;

{ TPlanSendCmd }

procedure TPlanSendCmd.Action;
begin
  m_actPlanAction.SendPlan ;
end;

{ TPlanRefreshCmd }

procedure TPlanRefreshCmd.Action;
begin
  m_actPlanAction.RefreshPlan ;
end;

{ TPlanRecvCmd }

procedure TPlanRecvCmd.Action;
begin
  m_actPlanAction.RecvPlan ;
end;

{ TPlanLoadCmd }

procedure TPlanLoadCmd.Action;
begin
  m_actPlanAction.LoadPlan ;
end;



end.
