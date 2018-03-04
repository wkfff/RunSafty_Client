unit uDiaoPlanAction;

interface
uses
  uSite,Windows,SysUtils,uTrainJiaolu ;

type

  //���ȶ�����ƻ�������
  TDiaoDuPlanAction = class
  public
    //���Ӽƻ�
    procedure InsertPlan();
    //ɾ���ƻ�
    procedure RemovePlan();
    //�����ƻ�
    procedure CancelPlan();
    //�·��ƻ�
    procedure SendPlan();
    //ˢ�¼ƻ�
    procedure RefreshPlan();
    //���ռƻ�
    procedure RecvPlan();
    //���ؼƻ�
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
