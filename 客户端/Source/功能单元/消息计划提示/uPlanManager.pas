unit uPlanManager;

interface

uses
  SysUtils,Classes,Windows,Messages,Contnrs,uTrainJiaoluItem,uTrainPlan,uSaftyEnum;

const
  WM_USER_REFRESH_JIAOLU = WM_USER + 400;
type

  //û�б�����ļ���
  TUnHandledTrainJiaoluSet = set of Char;

  //�ƻ����������
  TRsPlanManager  = class
  public
    constructor Create(Handle:Cardinal);
    destructor  Destroy();override;
  public
    //���һ����·
    procedure AddTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem);
    //ɾ��һ����·
    procedure RemoveTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem) ;
    // ������н�·
    procedure ClearTrainJiaoLu();
  public
    //������Ӧ����Ա�ƻ���Ϣ
    procedure SetTrainmanPlan(Pos:Integer;TrainmanPlanArray : TRsTrainmanPlanArray) ;
    //֪ͨ
    procedure Notify();
    //��ȡû�б�����Ľ�·����
    function  GetUnHandledJiaoLu():TUnHandledTrainJiaoluSet;
    //���û�б�����Ľ�·
    procedure  AddUnHandledJiaoLu(Index:Integer);
    //���û�б�����·����
    procedure   ClearUnHandledJiaoLu();
    //��ȡ�õ��Ľ�·�б�
    function   GetTrainJiaoLuList():TRsTrainJiaoluItemList;
  private
    //��������
    m_hMainHandle:Cardinal;
    //��·�б�
    m_listTrainJiaoLuItem:TRsTrainJiaoluItemList;
    //û�б�����Ľ�·
    m_setUnHandledTrainjiaolu:TUnHandledTrainJiaoluSet;
  end;


implementation

{ TRsPlanManager }

procedure TRsPlanManager.AddTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem);
begin
  m_listTrainJiaoLuItem.Add(TrainJiaoluItem) ;
end;

procedure TRsPlanManager.AddUnHandledJiaoLu(Index: Integer);
begin
  if  m_listTrainJiaoLuItem.Items[Index].PlanList.Count > 0  then
    Include( m_setUnHandledTrainjiaolu,Char (Index) );
end;

procedure TRsPlanManager.ClearTrainJiaoLu;
begin
  m_listTrainJiaoLuItem.Clear;
end;

procedure TRsPlanManager.ClearUnHandledJiaoLu;
begin
  m_setUnHandledTrainjiaolu := [];
end;

constructor TRsPlanManager.Create(Handle:Cardinal);
begin
  m_hMainHandle := Handle ;
  m_listTrainJiaoLuItem := TRsTrainJiaoluItemList.Create;
end;

destructor TRsPlanManager.Destroy;
begin
  m_listTrainJiaoLuItem.Free ;
  inherited;
end;


function TRsPlanManager.GetTrainJiaoLuList: TRsTrainJiaoluItemList;
begin
  Result := m_listTrainJiaoLuItem ;
end;

function TRsPlanManager.GetUnHandledJiaoLu: TUnHandledTrainJiaoluSet;
begin
  Result := m_setUnHandledTrainjiaolu ;
end;

procedure TRsPlanManager.RemoveTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem);
begin
  m_listTrainJiaoLuItem.Remove(TrainJiaoluItem);
end;

procedure TRsPlanManager.SetTrainmanPlan(Pos: Integer;
  TrainmanPlanArray: TRsTrainmanPlanArray);
var
  i : Integer ;
begin
  if ( Pos < 0 ) and ( Pos >= m_listTrainJiaoLuItem.Count ) then  Exit ;
  //��ȡ���·�״̬�ͽ���״̬�ļƻ�
  m_listTrainJiaoLuItem.Items[Pos].PlanList.Clear;
  for I := 0 to Length(TrainmanPlanArray) - 1 do
  begin
    if TrainmanPlanArray[i].TrainPlan.nPlanState in [psSent,psReceive] then
      m_listTrainJiaoLuItem.Items[Pos].PlanList.Add(TrainmanPlanArray[i].TrainPlan.strTrainPlanGUID) ;
  end;
end;

procedure TRsPlanManager.Notify;
begin
  PostMessage(m_hMainHandle,WM_USER_REFRESH_JIAOLU,0,0);
end;


end.
