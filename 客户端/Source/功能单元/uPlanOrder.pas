unit uPlanOrder;

interface
uses
  Classes,SysUtils,uTrainPlan,DateUtils,IniFiles,Contnrs;
type
  TOrderBehaviour = (obAsc,obDesc);
  const TOrderBehaviourName: array[TOrderBehaviour] of string = ('ÉýÐò','½µÐò');
type
  TOrderSetting = class
  private
    m_OrderBehaviour: TOrderBehaviour;
    m_FieldName: string;
    m_Priority: integer;
  public
    procedure Load(MemIniFile: TMemIniFile;Section: string);
    procedure Save(MemIniFile: TMemIniFile;Section: string);

    property OrderBehaviour: TOrderBehaviour read m_OrderBehaviour write m_OrderBehaviour;
    property FieldName: string read m_FieldName write m_FieldName;
    Property Priority: integer read m_Priority write m_Priority;
  end;


  TOrderSettingList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TOrderSetting;
    procedure SetItem(Index: Integer; AObject: TOrderSetting);
  public
    function FindSetting(const FieldName: string): TOrderSetting;
    property Items[Index: Integer]: TOrderSetting read GetItem write SetItem; default;
  end;


  TFormPlanOrder = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_FormName: string;
    m_OrderSettings: TOrderSettingList;
  public
    procedure Load(MemIniFile: TMemIniFile);
    procedure Save(MemIniFile: TMemIniFile);
    procedure ReSetPriority();
    property FormName: string read m_FormName write m_FormName;
    property OrderSettings: TOrderSettingList read m_OrderSettings;
  end;


  TFormPlanOrderCfg = class
  public
    constructor Create(const FileName: string);
    destructor Destroy;override;
  private
    m_MemIniFile: TMemIniFile;
    m_FormCfgs: TObjectList;
    class var _instance: TFormPlanOrderCfg;
  public
    class function SingleInstance: TFormPlanOrderCfg;
    procedure UpdateFile();
    function FindFormCfg(const Name: string): TFormPlanOrder;
  end;
    
  TPlanOrder = class
  private
    function ComparePlan(): integer;
  public
    function OrderDDPlan(PlanArray: TRsTrainmanPlanArray): TRsTrainmanPlanArray;
    function OrderPBPlan(PlanArray: TRsTrainmanPlanArray): TRsTrainmanPlanArray;
    function OrderCQPlan(PlanArray: TRsChuQinPlanArray): TRsChuQinPlanArray;
    function OrderTQPlan(PlanArray: TRsTuiQinPlanArray): TRsTuiQinPlanArray;
  end;


implementation

{ TPlanOrder }

function TPlanOrder.OrderCQPlan(PlanArray: TRsChuQinPlanArray): TRsChuQinPlanArray;
begin

end;

function TPlanOrder.OrderDDPlan(PlanArray: TRsTrainmanPlanArray): TRsTrainmanPlanArray;
begin

end;


function ComparePBPlan(Item1, Item2: Pointer): Integer;
begin
  if PRsTrainmanPlan(Item1).TrainPlan.nPlanState >
    PRsTrainmanPlan(Item2).TrainPlan.nPlanState then
    Result := 1
  else
  if PRsTrainmanPlan(Item1).TrainPlan.nPlanState <
    PRsTrainmanPlan(Item2).TrainPlan.nPlanState then
    Result := -1
  else
    Result := CompareDateTime(PRsTrainmanPlan(Item1).TrainPlan.dtStartTime,PRsTrainmanPlan(Item2).TrainPlan.dtStartTime);
end;


function TPlanOrder.OrderPBPlan(PlanArray: TRsTrainmanPlanArray): TRsTrainmanPlanArray;
var
  I: Integer;
  lst: TList;
  FormPlanOrder: TFormPlanOrder;
begin
  lst := TList.Create;
  try
    FormPlanOrder := TFormPlanOrderCfg.SingleInstance.FindFormCfg('ÅÉ°à´°¿Ú');
    SetLength(Result,Length(PlanArray));
    for I := 0 to Length(PlanArray) - 1 do
    begin
      lst.Add(@PlanArray[i]);
    end;

    lst.Sort(ComparePBPlan);

    for I := 0 to lst.Count - 1 do
    begin
      Result[i] := PRsTrainmanPlan(lst[i])^;
    end;
  finally
    lst.Free;
  end;

end;
function TPlanOrder.OrderTQPlan(PlanArray: TRsTuiQinPlanArray): TRsTuiQinPlanArray;
begin

end;



function TOrderSettingList.FindSetting(const FieldName: string): TOrderSetting;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].FieldName = FieldName then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TOrderSettingList.GetItem(Index: Integer): TOrderSetting;
begin
  result := TOrderSetting(inherited GetItem(Index));
end;
procedure TOrderSettingList.SetItem(Index: Integer; AObject: TOrderSetting);
begin
  Inherited SetItem(Index,AObject);
end;


{ TFormPlanOrder }

constructor TFormPlanOrder.Create;
begin
  inherited;
  m_OrderSettings := TOrderSettingList.Create;
end;

destructor TFormPlanOrder.Destroy;
begin
  m_OrderSettings.Free;
  inherited;
end;

procedure TFormPlanOrder.Load(MemIniFile: TMemIniFile);
var
  nCount: Integer;
  I: Integer;
begin
  m_OrderSettings.Clear;
  nCount := MemIniFile.ReadInteger(FormName,'FieldCount',0);
  for I := 0 to nCount - 1 do
  begin
    m_OrderSettings.Add(TOrderSetting.Create);
    (m_OrderSettings.Last as TOrderSetting).Load(MemIniFile,FormName + IntToStr(i + 1));    
  end;
end;

procedure TFormPlanOrder.ReSetPriority;
var
  I: Integer;
begin
  for I := 0 to m_OrderSettings.Count - 1 do
  begin
    m_OrderSettings[i].Priority := i + 1;
  end;
end;

procedure TFormPlanOrder.Save(MemIniFile: TMemIniFile);
var
  I: Integer;
begin
  MemIniFile.WriteInteger(FormName,'FieldCount',m_OrderSettings.Count);
  for I := 0 to m_OrderSettings.Count - 1 do
  begin
    m_OrderSettings[i].Save(MemIniFile,FormName + IntToStr(i + 1));
  end;
end;

{ TFormPlanOrderCfg }

constructor TFormPlanOrderCfg.Create(const FileName: string);
var
  I: Integer;
begin
  m_MemIniFile := TMemIniFile.Create(FileName);

  m_FormCfgs := TObjectList.Create;

  
  m_FormCfgs.Add(TFormPlanOrder.Create);
  (m_FormCfgs.Last as TFormPlanOrder).FormName := 'µ÷¶È´°¿Ú';

  m_FormCfgs.Add(TFormPlanOrder.Create);
  (m_FormCfgs.Last as TFormPlanOrder).FormName := 'ÅÉ°à´°¿Ú';

  m_FormCfgs.Add(TFormPlanOrder.Create);
  (m_FormCfgs.Last as TFormPlanOrder).FormName := '³öÇÚ´°¿Ú';

  m_FormCfgs.Add(TFormPlanOrder.Create);
  (m_FormCfgs.Last as TFormPlanOrder).FormName := 'ÍËÇÚ´°¿Ú';


  for I := 0 to m_FormCfgs.Count - 1 do
  begin
    (m_FormCfgs[i] as TFormPlanOrder).Load(m_MemIniFile);
  end;
end;

destructor TFormPlanOrderCfg.Destroy;
begin
  m_FormCfgs.Free;
  m_MemIniFile.Free;
  inherited;
end;


function TFormPlanOrderCfg.FindFormCfg(const Name: string): TFormPlanOrder;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_FormCfgs.Count - 1 do
  begin
    if (m_FormCfgs[i] as TFormPlanOrder).FormName = Name then
    begin
      Result := m_FormCfgs[i] as TFormPlanOrder;
      Break;
    end;
    
  end;
end;

class function TFormPlanOrderCfg.SingleInstance: TFormPlanOrderCfg;
begin
  if not Assigned(_instance) then
  begin
    _instance := TFormPlanOrderCfg.Create(ExtractFilePath(ParamStr(0)) + 'FormPlanOrder.ini');
  end;
  
  Result := _instance;
end;

procedure TFormPlanOrderCfg.UpdateFile;
var
  I: Integer;
begin
  for I := 0 to m_FormCfgs.Count - 1 do
  begin
    (m_FormCfgs[i] as TFormPlanOrder).Save(m_MemIniFile);
  end;
  m_MemIniFile.UpdateFile();
end;

{ TOrderSetting }

procedure TOrderSetting.Load(MemIniFile: TMemIniFile; Section: string);
begin
  m_FieldName := MemIniFile.ReadString(Section,'FieldName','');
  m_Priority := MemIniFile.ReadInteger(Section,'Priority',0);
  m_OrderBehaviour := TOrderBehaviour(MemIniFile.ReadInteger(Section,'OrderBehaviour',0)); 
end;

procedure TOrderSetting.Save(MemIniFile: TMemIniFile; Section: string);
begin
  MemIniFile.WriteString(Section,'FieldName',m_FieldName);
  MemIniFile.WriteInteger(Section,'Priority',m_Priority);
  MemIniFile.WriteInteger(Section,'OrderBehaviour',Ord(m_OrderBehaviour));
end;
end.
