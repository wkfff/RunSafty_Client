unit uPlanCommand;

interface

uses
  Classes,uDiaoPlanAction ;

type

  //�ƻ���������
  TPlanCommand = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //ִ�ж���
    procedure ActionExecute(Sender: TObject);
    //ִ�ж���
    procedure Action();virtual;
  protected
    m_actPlanAction:TDiaoDuPlanAction ;
  end;

  //���Ӽƻ�
  TPlanInsertCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //ɾ���ƻ�
  TPlanRemoveCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
    //�����ƻ�
  //��������
  TPlanCancelCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //�·��ƻ�
  TPlanSendCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //ˢ�¼ƻ�
  TPlanRefreshCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //���ռƻ�
  TPlanRecvCmd = class(TPlanCommand)
  public
    procedure Action();override;
  end;
  //���ؼƻ�
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
