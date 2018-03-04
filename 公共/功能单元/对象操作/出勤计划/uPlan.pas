unit uPlan;

interface
uses
  SysUtils,uTFSystem,Contnrs, uTrainNo;

const
  {δ¼��}
  PLANSTATE_NOINPUT = 0;
  {δǩ��}
  PLANSTATE_NOSIGNIN = 1;
  {��ǩ��}
  PLANSTATE_SIGNIN = 2;
  {����Ԣ}
  PLANSTATE_INROOM = 3;
  {����Ԣ}
  PLANSTATE_OUTROOM = 4;
  {�ѳ���}
  PLANSTATE_BEGINWORK = 5;
type

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TPlan
  /// ˵��:�ƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TPlan = class(TTrainNo)
  public
    constructor Create();
    {����:��������}
    procedure CopyFrom(Plan:TPlan);reintroduce;
  public
    {����:�����ͼƻ�״̬ת��Ϊ�ַ���}
    class function PlanStateToString(nTypeID : Integer) : String;
    {����:���ַ����ƻ�״̬ת��Ϊ����}
    class function PlanStateToInt(strType : string) : Integer;
  public
    {����}
    strTrainType : String;
    {����}
    strTrainNumber : String;
    {����Ա1GUID}
    strTrainmanGUID1 : String;
    {����Ա1�ƻ�״̬}
    nTrainmanState1 : Integer;
    {����Ա2GUID}
    strTrainmanGUID2 : String;
    {����Ա2�ƻ�״̬}
    nTrainmanState2 : Integer;
    {�ƻ�״̬}
    nState : Integer;
    {�ƻ�ʱ��}
    dtPlanDate : TDateTime;
    {¼����}
    strInputGUID : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TPlanList
  /// ˵��:�ƻ���Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TPlanList = Class(TObjectList)
  protected
    function GetItem(Index: Integer): TPlan;
    procedure SetItem(Index: Integer; Item: TPlan);
  public
  public
    function Add(Item: TTrainNo): Integer;
    property Items[Index: Integer]: TPlan read GetItem write SetItem; default;
  end;
  

implementation

{ TPlan }

procedure TPlan.CopyFrom(Plan: TPlan);
{����:��������}
begin
  inherited CopyFrom(TTrainNo(Plan));
  strTrainType := Plan.strTrainType;
  strTrainNumber := Plan.strTrainNumber;
  strTrainmanGUID1 := Plan.strTrainmanGUID1;
  nTrainmanState1 := Plan.nTrainmanState1;
  strTrainmanGUID2 := Plan.strTrainmanGUID2;
  nTrainmanState2 := Plan.nTrainmanState2;
  nState := Plan.nState;
  dtPlanDate := Plan.dtPlanDate;
  strInputGUID := plan.strInputGUID; 
end;

constructor TPlan.Create;
begin
  strGUID := '';
  nState := PLANSTATE_NOSIGNIN;
  strTrainType := '';
  strTrainNumber := '';
  strTrainmanGUID1 := '';
  nTrainmanState1 := 1;
  strTrainmanGUID2 := '';
  nTrainmanState2 := 1;
end;

class function TPlan.PlanStateToInt(strType: string): Integer;
{����:���ַ����ƻ�״̬ת��Ϊ����}
begin
  Result := 0;

  if strType = 'δ¼��' then
    Result := 0;

  if strType = 'δǩ��' then
    Result := 1;

  if strType = '��ǩ��' then
    Result := 2;

  if strType = '����Ԣ' then
    Result := 3;

  if strType = '����Ԣ' then
    Result := 4;

  if strType = '�ѳ���' then
    Result := 5;
end;

class function TPlan.PlanStateToString(nTypeID: Integer): String;
{����:�����ͼƻ�״̬ת��Ϊ�ַ���}
begin
  Result := '';
  case nTypeID of
    0 : Result := 'δ¼��';
    1 : Result := 'δǩ��';
    2 : Result := '��ǩ��';
    3 : Result := '����Ԣ';
    4 : Result := '����Ԣ';
    5 : Result := '�ѳ���';
  end;
end;

{ TPlanList }

function TPlanList.Add(Item : TTrainNo): Integer;
begin
  Result := inherited Add(Item);
end;

function TPlanList.GetItem(Index: Integer): TPlan;
begin
  Result := TPlan(inherited GetItem(Index));
end;

procedure TPlanList.SetItem(Index: Integer; Item: TPlan);
begin
  inherited SetItem(Index,Item);
end;

end.
