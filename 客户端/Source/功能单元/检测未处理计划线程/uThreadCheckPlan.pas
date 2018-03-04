unit uThreadCheckPlan;

interface

uses

  Classes,SysUtils,Windows,uLCTrainPlan,uPlanManager,uTrainPlan,uTrainJiaoluItem;

type
  TThreadCheckPlan = class(TThread)
  public
    constructor Create(PlanManager : TRsPlanManager);
    destructor Destroy();override;
  public
    //�˳��߳�
    procedure   ExitThread();
    //������Ϣʱ��
    procedure   SetSleepTime(Interval:Integer);
    //���ÿ�ʼʱ��ͽ���ʱ��
    procedure   SetQueryTime(BeginTime:TDateTime);
  private
    //���ƻ�
    procedure   CheckPlan();
    //��ȡָ����·�ļƻ�
    function   GetPlan(TrainJiaoluGUID:string):TRsTrainmanPlanArray;
  private
    { Private declarations }
    m_planManager : TRsPlanManager ;
    //WEB�ƻ��ӿ�
    m_webTrainPlan:TRsLCTrainPlan;
    //�����ϴ�ʱ����
    m_nInterval:Integer;
    //�˳��¼�
    m_hExitEvent : Cardinal ;
    //�ƻ��Ŀ�ʼʱ��
    m_dtBeginTime:TDateTime;
    //�ƻ��Ľ�ֹʱ��
    m_dtEndTime : TDateTime;
  protected
    procedure Execute; override;
  end;

implementation

uses
  uGlobalDM ;

{ TThreadCheckPlan }

constructor TThreadCheckPlan.Create(PlanManager : TRsPlanManager);
begin
  inherited Create(True);
  m_hExitEvent := CreateEvent(nil,False,False,nil);
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_planManager := PlanManager ;
end;

destructor TThreadCheckPlan.Destroy;
begin
  m_webTrainPlan.Free ;
  if m_hExitEvent <> 0 then
    CloseHandle(m_hExitEvent);

end;

procedure TThreadCheckPlan.Execute;
begin
  while True do
  begin
    //���ȴ��¼�
    if WaitForSingleObject(m_hExitEvent, m_nInterval * 1000 ) = WAIT_OBJECT_0 then
      Exit
    else
      CheckPlan();
  end;
end;

procedure TThreadCheckPlan.ExitThread;
begin
  SetEvent(m_hExitEvent);
  Sleep(1000);
  CloseHandle(m_hExitEvent);
  m_hExitEvent := 0 ;
end;

function TThreadCheckPlan.GetPlan(TrainJiaoluGUID:string): TRsTrainmanPlanArray;
var
  dtBeginTime,dtEndTime : TDateTime;
  trainmanPlanArray : TRsTrainmanPlanArray;
  strError:string;
begin
  dtBeginTime := m_dtBeginTime ;
  dtEndTime := m_dtEndTime ;
  m_webTrainPlan.GetTrainmanPlanFromSent(TrainJiaoluGUID,dtBeginTime,dtEndTime,trainmanPlanArray,strError);
  Result := trainmanPlanArray ;
end;

procedure TThreadCheckPlan.SetQueryTime(BeginTime: TDateTime);
begin
  m_dtBeginTime := BeginTime ;
  m_dtEndTime := BeginTime + 2 ;
end;

procedure TThreadCheckPlan.SetSleepTime(Interval: Integer);
begin
  if ( Interval < 0) then
    Interval := 10 ;
  m_nInterval := Interval ;
end;

procedure TThreadCheckPlan.CheckPlan;
var
  i : Integer ;
  trainmanPlanArray : TRsTrainmanPlanArray;
  TrainJiaoluItem:TRsTrainJiaoluItem;
begin
  m_planManager.ClearUnHandledJiaoLu ;
  for I := 0 to m_planManager.GetTrainJiaoLuList.Count - 1 do
  begin
    TrainJiaoluItem := m_planManager.GetTrainJiaoLuList.Items[i];
    trainmanPlanArray := GetPlan(TrainJiaoluItem.JiaoLuGUID);
    m_planManager.SetTrainmanPlan(I,trainmanPlanArray);
    m_planManager.AddUnHandledJiaoLu(I);
  end;
  m_planManager.Notify();
end;

end.
