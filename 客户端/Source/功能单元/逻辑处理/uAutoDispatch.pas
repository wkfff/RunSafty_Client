unit uAutoDispatch;

interface
uses
  uTrainPlan,ADODB,uDBTrainPlan,uTrainmanJiaolu,uTFSystem;
type
  TAutoDispatch = class(TDBOperate)
  private
    m_DBTrainPlan : TRsDBTrainPlan;
  public
    constructor Create(ADOConnection: TADOConnection);override;
    destructor Destroy;override;
  public
    //×Ô¶¯ÅÉ°à
    function DispatchPlan(Plan: RRsTrainPlan; out Group  :RRsGroup) : boolean;

  end;
implementation
uses
  SysUtils;
{ TAutoDispatch }

constructor TAutoDispatch.Create(ADOConnection: TADOConnection);
begin
  inherited;
  m_DBTrainPlan := TRsDBTrainPlan.Create(m_ADOConnection);
end;

destructor TAutoDispatch.Destroy;
begin
  m_DBTrainPlan.Free;
  inherited;
end;

function TAutoDispatch.DispatchPlan(Plan: RRsTrainPlan; out Group  :RRsGroup) : boolean;
begin
  result := true;
  //if m_DBTrainPlan.GetBaoChengGroup(Plan.strTrainJiaoluGUID,plan,Group) then exit;
  if m_DBTrainPlan.GetJiMingGroup(Plan.strTrainJiaoluGUID,plan,Group) then exit;
  //if m_DBTrainPlan.GetLunChengGroup(Plan.strTrainJiaoluGUID,plan,Group) then exit;
  result := false;
end;

end.
