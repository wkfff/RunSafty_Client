unit uPlanManager;

interface

uses
  SysUtils,Classes,Windows,Messages,Contnrs,uTrainJiaoluItem,uTrainPlan,uSaftyEnum;

const
  WM_USER_REFRESH_JIAOLU = WM_USER + 400;
type

  //没有被处理的集合
  TUnHandledTrainJiaoluSet = set of Char;

  //计划管理操作类
  TRsPlanManager  = class
  public
    constructor Create(Handle:Cardinal);
    destructor  Destroy();override;
  public
    //添加一个交路
    procedure AddTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem);
    //删除一个交路
    procedure RemoveTrainJiaoLu(TrainJiaoluItem:TRsTrainJiaoluItem) ;
    // 清除所有交路
    procedure ClearTrainJiaoLu();
  public
    //设置相应的人员计划信息
    procedure SetTrainmanPlan(Pos:Integer;TrainmanPlanArray : TRsTrainmanPlanArray) ;
    //通知
    procedure Notify();
    //获取没有被处理的交路集合
    function  GetUnHandledJiaoLu():TUnHandledTrainJiaoluSet;
    //添加没有被处理的交路
    procedure  AddUnHandledJiaoLu(Index:Integer);
    //清空没有被处理交路集合
    procedure   ClearUnHandledJiaoLu();
    //获取得到的交路列表
    function   GetTrainJiaoLuList():TRsTrainJiaoluItemList;
  private
    //主窗体句柄
    m_hMainHandle:Cardinal;
    //交路列表
    m_listTrainJiaoLuItem:TRsTrainJiaoluItemList;
    //没有被处理的交路
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
  //获取是下发状态和接受状态的计划
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
