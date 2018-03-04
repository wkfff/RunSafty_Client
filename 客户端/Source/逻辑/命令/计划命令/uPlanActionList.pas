unit uPlanActionList;

interface

uses
  SysUtils,ActnList,uPlanCommand,uDiaoPlanAction;


type
  //�ƻ������б���
  TPlanActionList = class
  public
    constructor Create();
    destructor  Destroy();override;
  public
    //�������������
    procedure CreatePlanCmd();
    procedure DestroyPlanCmd();

    //����ACT��
    procedure CreatePlanAct();
    procedure DestroyPlanAct();
  public
    //���Ӽƻ�
    actInsertPlan : TAction ;
    //ɾ���ƻ�
    actRemovePlan : TAction ;
    //ȡ��
    actCancelPlan : TAction;
    //�·��ƻ�
    actSendPlan : TAction;
    //ˢ�¼ƻ�
    actRefreshPlan : TAction;
    //���ռƻ�
    actRecvPlan : TAction ;
    //���ؼƻ�
    actLoadPlan : TAction  ;
  private
    //ʵ�ʵĲ�����
    //���Ӽƻ�
    m_CmdInsertPlan : TPlanInsertCmd ;
    //ɾ���ƻ�
    m_CmdRemovePlan : TPlanRemoveCmd;
    //ȡ��
    m_CmdCancelPlan : TPlanCancelCmd;
    //�·��ƻ�
    m_CmdSendPlan : TPlanSendCmd;
    //ˢ�¼ƻ�
    m_CmdRefreshPlan : TPlanRefreshCmd;
    //���ռƻ�
    m_CmdRecvPlan : TPlanRecvCmd ;
    //���ؼƻ�
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
  //���Ӽƻ�
  actInsertPlan := TAction.Create(nil)  ;
  actInsertPlan.Caption := '���Ӽƻ�' ;
  actInsertPlan.OnExecute := m_CmdInsertPlan.ActionExecute;
  //ɾ���ƻ�
  actRemovePlan := TAction.Create(nil)  ;
  actRemovePlan.Caption := 'ɾ���ƻ�';
  actRemovePlan.OnExecute := m_CmdRemovePlan.ActionExecute;
  //ȡ��
  actCancelPlan := TAction.Create(nil) ;
  actCancelPlan.Caption := '�����ƻ�';
  actCancelPlan.OnExecute := m_CmdCancelPlan.ActionExecute;
  //�·��ƻ�
  actSendPlan := TAction.Create(nil) ;
  actSendPlan.Caption := '�·��ƻ�';
  actSendPlan.OnExecute := m_CmdSendPlan.ActionExecute;
  //ˢ�¼ƻ�
  actRefreshPlan := TAction.Create(nil) ;
  actRefreshPlan.Caption := 'ˢ�¼ƻ�';
  actRefreshPlan.OnExecute := m_CmdRefreshPlan.ActionExecute;
  //���ռƻ�
  actRecvPlan := TAction.Create(nil)  ;
  actRecvPlan.Caption := '���ռƻ�';
  actRecvPlan.OnExecute := m_CmdRecvPlan.ActionExecute ;
  //���ؼƻ�
  actLoadPlan := TAction.Create(nil)   ;
  actLoadPlan.Caption := '��ͼ�����α����';
  actLoadPlan.OnExecute := m_CmdLoadPlan.ActionExecute ;
end;

procedure TPlanActionList.CreatePlanCmd;
begin
  //���Ӽƻ�
  m_CmdInsertPlan := TPlanInsertCmd.Create ;
  //ɾ���ƻ�
  m_CmdRemovePlan := TPlanRemoveCmd.Create;
  //ȡ��
  m_CmdCancelPlan := TPlanCancelCmd.Create;
  //�·��ƻ�
  m_CmdSendPlan := TPlanSendCmd.Create;
  //ˢ�¼ƻ�
  m_CmdRefreshPlan := TPlanRefreshCmd.Create;
  //���ռƻ�
  m_CmdRecvPlan := TPlanRecvCmd.Create ;
  //���ؼƻ�
  m_CmdLoadPlan := TPlanLoadCmd.Create  ;
end;

destructor TPlanActionList.Destroy;
begin
  DestroyPlanCmd ;
  DestroyPlanAct ;
end;

procedure TPlanActionList.DestroyPlanAct;
begin
  //���Ӽƻ�
  actInsertPlan.Free ;
  //ɾ���ƻ�
  actRemovePlan.Free ;
  //ȡ��
  actCancelPlan.Free;
  //�·��ƻ�
  actSendPlan.Free;
  //ˢ�¼ƻ�
  actRefreshPlan.Free;
  //���ռƻ�
  actRecvPlan.Free ;
  //���ؼƻ�
  actLoadPlan.Free  ;
end;

procedure TPlanActionList.DestroyPlanCmd;
begin
  //���Ӽƻ�
  m_CmdInsertPlan.Free;
  //ɾ���ƻ�
  m_CmdRemovePlan.Free;
  //ȡ��
  m_CmdCancelPlan.Free;
  //�·��ƻ�
  m_CmdSendPlan.Free;
  //ˢ�¼ƻ�
  m_CmdRefreshPlan.Free;
  //���ռƻ�
  m_CmdRecvPlan.Free ;
  //���ؼƻ�
  m_CmdLoadPlan.Free  ;
end;

end.
