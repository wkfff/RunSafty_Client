unit uRsPlanCombine;

interface
uses
  Classes,uRsLocalDataDefine,DateUtils,uDBTrainmanJiaolu,uTFSystem,ADODB,
  uTrainmanJiaolu,SysUtils,uDBTrainPlan,uTrainPlan,uDBTrainman,uTrainman,
  uSaftyEnum;
type
  TCombineMsgType = (mtNone,mtError,mtWarning);
  TRsPlanCombine = class
  public
    constructor Create(ADOConnection: TADOConnection;SiteGUID,DutyGUID: string);
    destructor Destroy; override;

  private
    m_DBTrainmanJiaoLu: TRsDBTrainmanJiaolu;
    m_DBTrainPlan: TRsDBTrainPlan;
    m_DBTrainman: TRsDBTrainman;
    m_strSiteGUID: string;
    m_strDutyGUID: string;
  private
    function CheckSourceTrainman(out strMsg: string;strTrainmanGUID,strTrainmanNumber: string): Boolean;
    function CheckGroupInfo(out strMsg: string;Source: TRsLocalPlan;Dest: TRsServerPlan): Boolean;
    function CheckStartTime(out strMsg: string;Source: TRsLocalPlan;Dest: TRsServerPlan): Boolean;
    function CheckTrainNo(out strMsg: string;Source: TRsLocalPlan;Dest: TRsServerPlan): Boolean;

    procedure SetGroupToPlan(Source: TRsLocalPlan;Dest: TRsServerPlan);
    procedure UpdateDestPlanState(Dest: TRsServerPlan);
  public
    function CanCombine(out strMsg: string;
        Source: TRsLocalPlan;Dest: TRsServerPlan): TCombineMsgType;
    function CombinePlan(Source: TRsLocalPlan;Dest: TRsServerPlan): Boolean;
  end;
implementation

{ TRsPlanCombine }

function TRsPlanCombine.CanCombine(out strMsg: string;
    Source: TRsLocalPlan;Dest: TRsServerPlan): TCombineMsgType;
begin
  Result := mtError;
  if not CheckStartTime(strMsg,Source,Dest) then
    Exit;

//  if not CheckPlanTrainman(strMsg,Source,Dest) then
//    Exit;
//
  if not CheckGroupInfo(strMsg,Source,Dest) then
    Exit;

  Result := mtWarning;
  
  if not CheckTrainNo(strMsg,Source,Dest) then
    Exit;

  Result := mtNone;
end;


function TRsPlanCombine.CheckGroupInfo(out strMsg: string; Source: TRsLocalPlan;
  Dest: TRsServerPlan): Boolean;
var
  Group: RRsGroup;
  strTrainmanGUID: string;
begin
  Result := False;

  if Dest.strGroupGUID <> '' then
  begin
    strMsg := '目标计划已安排了人员!';
    Exit;
  end;
  
  if Source.strTrainmanGUID1 <> '' then
    strTrainmanGUID := Source.strTrainmanGUID1
  else
  if Source.strTrainmanGUID2 <> '' then
    strTrainmanGUID := Source.strTrainmanGUID2
  else
  if Source.strTrainmanGUID3 <> '' then
    strTrainmanGUID := Source.strTrainmanGUID3
  else
  begin
    strMsg := '本地计划未安排人员,不能合并计划!';
    Exit;
  end;
  
  m_DBTrainmanJiaoLu.GetTrainmanGroup(strTrainmanGUID,Group);

  if Group.strGroupGUID = '' then
  begin
    strMsg := '计划安排人员未在同一机组内,请在先铭牌中调整为一组人员!';
    Exit;
  end;
  

  if (Group.Trainman1.strTrainmanGUID <> Source.strTrainmanGUID1) or
    (Group.Trainman2.strTrainmanGUID <> Source.strTrainmanGUID2) or
    (Group.Trainman3.strTrainmanGUID <> Source.strTrainmanGUID3) then
  begin
    strMsg := '计划安排人员未在同一机组内,请在先铭牌中调整为一组人员!';
    Exit;
  end;

  if Group.strTrainPlanGUID <> '' then
  begin
    strMsg := '该机组已安排了计划!';
    Exit;
  end;

  Result := True;  
end;

function TRsPlanCombine.CheckStartTime(out strMsg: string; Source: TRsLocalPlan;
  Dest: TRsServerPlan): Boolean;
begin
  Result := CompareDateTime(Source.dtStartTime,Dest.dtStartTime) = 0;

  if not Result then
    strMsg := '计划开车时间不一致,不能合并计划!';

end;


function TRsPlanCombine.CheckSourceTrainman(out strMsg: string;
    strTrainmanGUID,strTrainmanNumber: string): Boolean;
var
  Trainman: RRsTrainman;
begin
  Result := False;
  if strTrainmanGUID <> '' then
  begin
    if not m_DBTrainman.GetTrainman(strTrainmanGUID,Trainman) then
    begin
      strMsg := '不存在工号为:' + strTrainmanNumber + '的乘务员!';
      Exit;
    end;
    if (Trainman.nTrainmanState <> tsNormal) then
    begin
      strMsg := '的乘务员[' + Trainman.strTrainmanName + '],为非正常状态,不能安排计划!';
      Exit;
    end;
    
  end;

  Result := True;
end;

function TRsPlanCombine.CheckTrainNo(out strMsg: string; Source: TRsLocalPlan;
  Dest: TRsServerPlan): Boolean;
begin
  Result := UpperCase(Source.strTrainNo) = UpperCase(Dest.strTrainNo);
  if not Result then
    strMsg := '计划车次不同';
end;

function TRsPlanCombine.CombinePlan(Source: TRsLocalPlan;
  Dest: TRsServerPlan): Boolean;
begin
  //把人员按排到服务器计划中
  SetGroupToPlan(Source,Dest);

  //修改服务器计划状态为已发布
  UpdateDestPlanState(Dest);
  
  //提取事件详细
  //重新保存事件详细


  //取出勤记录
  //保存出勤记录
  //保存出勤事件


  //取退勤记录
  //保存退勤记录
  //保存退勤事件
  //发送退勤消息

  Result := True;
end;

constructor TRsPlanCombine.Create(ADOConnection: TADOConnection;
  SiteGUID,DutyGUID: string);
begin
  m_DBTrainmanJiaoLu := TRsDBTrainmanJiaolu.Create(ADOConnection);
  m_DBTrainPlan := TRsDBTrainPlan.Create(ADOConnection);
  m_DBTrainman := TRsDBTrainman.Create(ADOConnection);
  m_strSiteGUID := SiteGUID;
  m_strDutyGUID := DutyGUID;
end;

destructor TRsPlanCombine.Destroy;
begin
  m_DBTrainmanJiaoLu.Free;
  m_DBTrainPlan.Free;
  m_DBTrainman.Free;
  inherited;
end;

procedure TRsPlanCombine.SetGroupToPlan(Source: TRsLocalPlan;
  Dest: TRsServerPlan);
var
  Group: RRsGroup;
  strTrainmanGUID: string;
  TrainPlan: RRsTrainPlan;
begin
  if Source.strTrainmanGUID1 <> '' then
    strTrainmanGUID := Source.strTrainmanGUID1
  else
  if Source.strTrainmanGUID2 <> '' then
    strTrainmanGUID := Source.strTrainmanGUID2
  else
    strTrainmanGUID := Source.strTrainmanGUID3;
  
  m_DBTrainmanJiaoLu.GetTrainmanGroup(strTrainmanGUID,Group);

  if not m_DBTrainPlan.GetPlan(Dest.strTrainPlanGUID,TrainPlan) then
    raise Exception.Create('未找到计划!');

  m_DBTrainPlan.SetGroupToPlan(Group,TrainPlan,m_strDutyGUID,m_strSiteGUID);
end;

procedure TRsPlanCombine.UpdateDestPlanState(Dest: TRsServerPlan);
var
  GUIDS: TStringList;
begin
  if Dest.nPlanState <> ord(psReceive) then
    Exit;
  GUIDS := TStringList.Create;
  try
    GUIDS.Add(Dest.strTrainPlanGUID);
    m_DBTrainPlan.PublishPlan(GUIDS,m_strSiteGUID,m_strDutyGUID);
  finally
    GUIDS.Free;
  end;

  
end;

end.
