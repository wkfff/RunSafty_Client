unit uRoomCallRemind;

interface
uses
  Classes,SysUtils,uTrainPlan,uTFSystem,DateUtils,Contnrs,StrUtils,uSaftyEnum;
const
  REMINDPATH = '叫班提醒\';
type
  TRemindItem = class
  public
    constructor Create(RemindMinutes: integer);
    destructor Destroy;override;
  private
    m_StringList: TStringList;
    m_nRemindMinutes: integer;
    m_Fields: TStringList;
    function GetRecTime(RecString: string): TDateTime;
    function GetPlanString(Plan: RRsTrainmanPlan): string;
    function ContainPlan(PlanID: string): Boolean;
  public
    procedure RemoveTimeout();
    function GetRemindString(RemindPlans: TStrings;PlanArray : TRsTrainmanPlanArray): string;
  end;

  RJlPlans = record
    JlGUID: string;
    PlanArray : TRsTrainmanPlanArray;
  end;

  PJlPlans = ^RJlPlans;
  
  TRemindCtl = class
  public
    constructor Create(RemindMinutes: TIntArray);
    destructor Destroy;override;
  private
    m_Items: TObjectList;
    m_RemindPlans: TStrings;
    m_JlPlanLst: TList;
    procedure ClearJlPlans();
    function FindJlPlans(JlGUID: string): PJlPlans;
  public
    class procedure SortArray(var intArray: TIntArray);
    procedure SetPlanArray(JLGUID: string;PlanArray : TRsTrainmanPlanArray);
    function GetRemindString(PlanArray : TRsTrainmanPlanArray): string;overload;
    function GetRemindString(): string;overload;
  end;
implementation

{ TRemindHistory }

procedure TRemindCtl.ClearJlPlans;
var
  I: Integer;
  p: PJlPlans;
begin
  for I := 0 to m_JlPlanLst.Count - 1 do
  begin
    p := PJlPlans(m_JlPlanLst[i]);
    Dispose(p);
  end;

  m_JlPlanLst.Clear;
end;

constructor TRemindCtl.Create(RemindMinutes: TIntArray);
var
  I: Integer;
begin
  SortArray(RemindMinutes);
  m_Items := TObjectList.Create;
  m_RemindPlans := TStringList.Create;

  m_JlPlanLst := TList.Create;
  for I := 0 to Length(RemindMinutes) - 1 do
  begin
    m_Items.Add(TRemindItem.Create(RemindMinutes[i]));
  end;
end;

destructor TRemindCtl.Destroy;
begin
  ClearJlPlans;
  m_Items.Free;
  m_RemindPlans.Free;
  m_JlPlanLst.Free;
  inherited;
end;

function TRemindCtl.FindJlPlans(JlGUID: string): PJlPlans;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_JlPlanLst.Count - 1 do
  begin
    if SameText(PJlPlans(m_JlPlanLst[i]).JlGUID,JlGUID) then
    begin
      Result := PJlPlans(m_JlPlanLst[i]);
      break;
    end;
  end;
end;

function TRemindCtl.GetRemindString: string;
var
  I: Integer;
  j: Integer;
begin
  Result := '';
  m_RemindPlans.clear;
  for I := 0 to m_Items.Count - 1 do
  begin
    for j := 0 to m_JlPlanLst.Count - 1 do
    begin
      Result := Result + TRemindItem(m_Items.Items[i]).GetRemindString(m_RemindPlans,PJlPlans(m_JlPlanLst[j]).PlanArray)
    end;
  end;
end;


function TRemindCtl.GetRemindString(
  PlanArray: TRsTrainmanPlanArray): string;
var
  I: Integer;
begin
  Result := '';
  m_RemindPlans.clear;
  for I := 0 to m_Items.Count - 1 do
  begin
    Result := Result + TRemindItem(m_Items.Items[i]).GetRemindString(m_RemindPlans,PlanArray)
  end;
end;


procedure TRemindCtl.SetPlanArray(JLGUID: string;
  PlanArray: TRsTrainmanPlanArray);
var
  p: PJlPlans;
begin
  p := FindJlPlans(JLGUID);

  if p = nil then
  begin
    New(p);
    p.JlGUID := JLGUID;
    p.PlanArray := PlanArray;
    m_JlPlanLst.Add(p);
  end
  else
  begin
    p.PlanArray := PlanArray;
  end;
  
end;

class procedure TRemindCtl.SortArray(var intArray: TIntArray);
var
  i,j: integer;
  tmpValue: integer;
begin
  for I := 0 to length(intArray) - 1 do
  begin
    for j := 0 to length(intArray) - i - 2 do
    begin
      if intArray[j] > intArray[j + 1] then
      begin
        tmpValue := intArray[j];
        intArray[j] := intArray[j + 1];
        intArray[j + 1] := tmpValue;
      end;
    end;
  end;
end;

{ TRemindItem }

function TRemindItem.ContainPlan(PlanID: string): Boolean;
var
  I: Integer;
begin
  Result := false;
  for I := 0 to m_StringList.Count - 1 do
  begin
    m_Fields.CommaText := m_StringList.Strings[i];

    if m_Fields.Count > 0 then
      Result := m_Fields.Strings[0] = PlanID;
    if Result then
    break;

  end;
end;

constructor TRemindItem.Create(RemindMinutes: integer);
begin
  m_Fields := TStringList.Create;
  m_StringList := TStringList.Create;

  m_nRemindMinutes := RemindMinutes;
end;

destructor TRemindItem.Destroy;
begin
  m_StringList.Free;
  m_Fields.Free;
  inherited;
end;

function TRemindItem.GetPlanString(Plan: RRsTrainmanPlan): string;
  function GetPlanTrainman(): string;
  begin
    Result := '';

    if Plan.Group.Trainman1.strTrainmanNumber <> '' then
    begin
      Result := Result + Format(' [%s]%s',[Plan.Group.Trainman1.strTrainmanNumber,
      Plan.Group.Trainman1.strTrainmanName]);
    end;

    if Plan.Group.Trainman2.strTrainmanNumber <> '' then
    begin
      Result := Result + Format(' [%s]%s',[Plan.Group.Trainman2.strTrainmanNumber,
      Plan.Group.Trainman2.strTrainmanName]);
    end;

    if Plan.Group.Trainman3.strTrainmanNumber <> '' then
    begin
      Result := Result + Format(' [%s]%s',[Plan.Group.Trainman3.strTrainmanNumber,
      Plan.Group.Trainman3.strTrainmanName]);
    end;

    if Plan.Group.Trainman4.strTrainmanNumber <> '' then
    begin
      Result := Result + Format(' [%s]%s',[Plan.Group.Trainman4.strTrainmanNumber,
      Plan.Group.Trainman4.strTrainmanName]);
    end;
  
  end;
  function GetTimeSplan(): string;
  var
    nHour: integer;
    nMinite: integer;
  begin
    Result := '';
    nHour := m_nRemindMinutes div 60;
    nMinite := m_nRemindMinutes mod 60;

    if nHour > 0 then
      Result := IntToStr(nHour) + '小时';

    if nMinite > 0 then
      Result := Result + IntToStr(nMinite) + '分';    
  end;
begin
  Result := Format('车次:[%s] [%s]内需要出勤 乘务员:%s ，请注意叫班',[Plan.TrainPlan.strTrainNo,GetTimeSplan(),GetPlanTrainman()])
end;

function TRemindItem.GetRecTime(RecString: string): TDateTime;
var
  strTime: string;
begin
  Result := 0;
  m_Fields.CommaText := RecString;
  if m_Fields.Count > 1 then
  begin
    strTime := ReplaceStr(m_Fields.Strings[1],'@',' ');
    Result := StrToDateTime(strTime);
  end;
end;

function TRemindItem.GetRemindString(RemindPlans: TStrings;
  PlanArray: TRsTrainmanPlanArray): string;
var
  I: Integer;
begin
  Result := '';
  RemoveTimeout();
  for I := 0 to Length(PlanArray) - 1 do
  begin
    if (PlanArray[i].TrainPlan.nPlanState < psPublish) or (PlanArray[i].TrainPlan.nPlanState >= psBeginWork)  then Continue;

    if (CompareDateTime(IncMinute(Now,m_nRemindMinutes),PlanArray[i].TrainPlan.dtStartTime) > 0)
    and  (CompareDateTime(PlanArray[i].TrainPlan.dtStartTime,Now) > 0) then
    begin
      if not ContainPlan(PlanArray[i].TrainPlan.strTrainPlanGUID) then
      begin
        if RemindPlans.IndexOf(PlanArray[i].TrainPlan.strTrainPlanGUID ) = -1 then
        begin
          RemindPlans.Add(PlanArray[i].TrainPlan.strTrainPlanGUID);
          m_StringList.Add(PlanArray[i].TrainPlan.strTrainPlanGUID + ',' +
          FormatDateTime('yyyy-mm-dd@hh:nn:ss',PlanArray[i].TrainPlan.dtStartTime));

          Result := Result + GetPlanString(PlanArray[i]) + #13#10;
        end;


      end;
    end;
  end;

  if Result <> '' then
    Result := Result + #13#10;

end;

procedure TRemindItem.RemoveTimeout;
var
  I: Integer;
begin
  i := 0;
  while i <= m_StringList.Count - 1 do
  begin
    if CompareDateTime(Now,GetRecTime(m_StringList.Strings[i])) > 0   then
    begin
      m_StringList.Delete(i);
    end
    else
      Inc(i);
  end;

end;

end.
