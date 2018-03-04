unit uRsLocalDataDefine;

interface
uses
  Classes,Contnrs,DateUtils;
type
  TRsServerPlan = class;

  TRsLocalPlan =  class
  private
    m_ServerPlan: TRsServerPlan;
  public
    nID: Integer;
    strTrainPlanGUID: string;
    strTrainNo: string;
    dtStartTime: TDateTime;
    nPlanState: Integer;
    dtCreateTime: TDateTime;
    strTrainmanGUID1: string;
    strTrainmanNumber1: string;
    strTrainmanName1: string;
    strTrainmanGUID2: string;
    strTrainmanNumber2: string;
    strTrainmanName2: string;
    strTrainmanGUID3: string;
    strTrainmanNumber3: string;
    strTrainmanName3: string;

  public
    procedure LinkServerPlan(Plan: TRsServerPlan);
    procedure BreakLink();
    property ServerPlan: TRsServerPlan read m_ServerPlan write m_ServerPlan;
  end;

  TRsLocalPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLocalPlan;
    procedure SetItem(Index: Integer; AObject: TRsLocalPlan);
  public
    property Items[Index: Integer]: TRsLocalPlan read GetItem write SetItem; default;
  end;


  TRsServerPlan = class
  private
    m_LocalPlan: TRsLocalPlan;
  public
    strTrainPlanGUID: string;
    strTrainNo: string;
    dtStartTime: TDateTime;
    nPlanState: Integer;
    dtCreateTime: TDateTime;
    strGroupGUID: string;
    strTrainJiaoluGUID: string;
    strTrainmanGUID1: string;
    strTrainmanNumber1: string;
    strTrainmanName1: string;
    strTrainmanGUID2: string;
    strTrainmanNumber2: string;
    strTrainmanName2: string;
    strTrainmanGUID3: string;
    strTrainmanNumber3: string;
    strTrainmanName3: string;
    strTrainJiaoLuName: string;
  public
    procedure LinkLocalPlan(Plan: TRsLocalPlan);
    procedure BreakLink();
    property LocalPlan: TRsLocalPlan read m_LocalPlan write m_LocalPlan;
  end;
  
  TRsServerPlanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsServerPlan;
    procedure SetItem(Index: Integer; AObject: TRsServerPlan);
  public
    property Items[Index: Integer]: TRsServerPlan read GetItem write SetItem; default;
  end;

  TRsPlanListSort = class
  public
    class procedure Sort(PlanList: TRsServerPlanList);overload;
    class procedure Sort(PlanList: TRsLocalPlanList);overload;
  end;
function CompareServerPlanData(Item1, Item2: Pointer): Integer;
function CompareLocalPlanData(Item1, Item2: Pointer): Integer;
implementation
function CompareServerPlanData(Item1, Item2: Pointer): Integer;
begin
  Result := CompareDateTime(TRsServerPlan(Item1).dtStartTime,TRsServerPlan(Item2).dtStartTime);
end;
function CompareLocalPlanData(Item1, Item2: Pointer): Integer;
begin
  Result := CompareDateTime(TRsLocalPlan(Item1).dtStartTime,TRsLocalPlan(Item2).dtStartTime);
end;
{ TRsLocalPlanList }

function TRsLocalPlanList.GetItem(Index: Integer): TRsLocalPlan;
begin
  Result := TRsLocalPlan(inherited GetItem(Index));
end;

procedure TRsLocalPlanList.SetItem(Index: Integer; AObject: TRsLocalPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsServerPlanList }

function TRsServerPlanList.GetItem(Index: Integer): TRsServerPlan;
begin
  Result := TRsServerPlan(inherited GetItem(Index));
end;

procedure TRsServerPlanList.SetItem(Index: Integer; AObject: TRsServerPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsServerPlan }

procedure TRsServerPlan.BreakLink;
begin
  if Assigned(m_LocalPlan) then
    m_LocalPlan.ServerPlan := nil;

  m_LocalPlan := nil;
end;

procedure TRsServerPlan.LinkLocalPlan(Plan: TRsLocalPlan);
begin
  Plan.ServerPlan := Self;
  Self.m_LocalPlan := Plan;
end;

{ TRsLocalPlan }

procedure TRsLocalPlan.BreakLink;
begin
  if Assigned(m_ServerPlan) then
    m_ServerPlan.LocalPlan := nil;

  m_ServerPlan := nil;
end;

procedure TRsLocalPlan.LinkServerPlan(Plan: TRsServerPlan);
begin
  Plan.LocalPlan := Self;
  Self.ServerPlan := Plan;
end;

{ TRsPlanListSort }

class procedure TRsPlanListSort.Sort(PlanList: TRsServerPlanList);
var
  TempList: TRsServerPlanList;
  i: Integer;
begin
  TempList := TRsServerPlanList.Create;
  try
    TempList.OwnsObjects := False;
    PlanList.OwnsObjects := False;
    i := 0;
    while i < PlanList.Count do
    begin
      if not Assigned(PlanList.Items[i].LocalPlan) then
      begin
        TempList.Add(PlanList.Items[i]);
        PlanList.Delete(i);
      end
      else
        inc(i); 
    end;

    PlanList.Sort(CompareServerPlanData);
    TempList.Sort(CompareServerPlanData);

    for I := 0 to TempList.Count - 1 do
    begin
      PlanList.Add(TempList.Items[i]);
    end;

  finally
    PlanList.OwnsObjects := True;
    TempList.Free;
  end;

end;

class procedure TRsPlanListSort.Sort(PlanList: TRsLocalPlanList);
var
  TempList: TRsLocalPlanList;
  i: Integer;
begin
  TempList := TRsLocalPlanList.Create;
  try
    TempList.OwnsObjects := False;
    PlanList.OwnsObjects := False;
    i := 0;
    while i < PlanList.Count do
    begin
      if not Assigned(PlanList.Items[i].ServerPlan) then
      begin
        TempList.Add(PlanList.Items[i]);
        PlanList.Delete(i);
      end
      else
        inc(i); 
    end;

    PlanList.Sort(CompareLocalPlanData);
    TempList.Sort(CompareLocalPlanData);

    for I := 0 to TempList.Count - 1 do
    begin
      PlanList.Add(TempList.Items[i]);
    end;

  finally
    PlanList.OwnsObjects := True;
    TempList.Free;
  end;

end;
end.
