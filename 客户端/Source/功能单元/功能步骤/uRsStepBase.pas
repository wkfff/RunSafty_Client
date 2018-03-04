unit uRsStepBase;

interface
uses
  Classes,Contnrs,ADODB,uRsStepConfig,uTFSystem,SysUtils,uGenericData,
  Windows,uCommonFunctions,uTrainPlan,uTrainman,uApparatusCommon,uSaftyEnum,
  uDrink;
type
  TRsStepParam = class(TGenericData)
  public
    AlcoholInfo: RTestAlcoholInfo;
    TrainmanPlan: RRsTrainmanPlan;
    Trainman: RRsTrainman;
  end;
  TRsFunModule = class;
  {步骤执行方向}
  TRsStepDirection = (sdNextStep{下一个步骤},sdPreStep{上一个步骤},
      sdCurrentStep{再次执行当前步骤},sdExit{退出功能});

  TCloseHintEvent = procedure of object;
  {TRsStepBase 步骤基类}
  TRsStepBase = class(TPersistent)
  public
    constructor Create(Owner: TRsFunModule;ConfigNode: TRsStepConfigNode);virtual;
  protected
    {配置节点}
    m_ConfigNode: TRsStepConfigNode;
    {功能管理对象}
    m_Owner: TRsFunModule;
    {功能:写日志}
    procedure LogOut(strLog: string);
    procedure ShowHint(strHint: string);
    procedure CloseHint();

  public
    {功能:初始化}
    procedure Init();virtual;
    {功能:执行接口功能}
    function Execute(Param: TRsStepParam;var Direction: TRsStepDirection): Boolean;virtual;abstract;
  end;

  
  TRsStepBaseClass = class of TRsStepBase;

  {TRsStepList 步骤列表}
  TRsStepList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsStepBase;
    procedure SetItem(Index: Integer; AObject: TRsStepBase);
  public
    property Items[Index: Integer]: TRsStepBase read GetItem write SetItem; default;
  end;


  {TRsFunModule 功能模块}
  TRsFunModule = class
  public
    constructor Create(LogOutEvent: TOnEventByString);virtual;
    destructor Destroy; override;
  public
    {功能:执行各功能模块}
    function Execute(Param: TRsStepParam): Boolean;
    {功能:写日志}
    procedure WriteLog(strLog: string);
    {功能:初始步骤}
    procedure InitStep();
    procedure ShowHint(strHint: string);
    procedure CloseHint();
  private
    {日志输出事件}
    m_OnLogOut: TOnEventByString;
    {功能对象列表}
    m_RsStepList: TRsStepList;
    {功能模块配置信息}
    m_ModuleConfigNode: TRsFunModuleConfigNode;
    {数据库连接}
    m_ADOConnection: TADOConnection;
    m_OnShowHint: TOnEventByString;
    m_OnCloseHint: TCloseHintEvent;
    procedure SetLogOutEvent(OnEventByString: TOnEventByString);
  public
    property ModuleConfigNode: TRsFunModuleConfigNode read m_ModuleConfigNode write
        m_ModuleConfigNode;
    property StepList: TRsStepList read m_RsStepList;
    property OnLogOut: TOnEventByString read m_OnLogOut write SetLogOutEvent;
    property OnShowHint: TOnEventByString read m_OnShowHint write m_OnShowHint;
    property OnCloseHint: TCloseHintEvent read m_OnCloseHint write m_OnCloseHint;
    property ADOConnection: TADOConnection read m_ADOConnection write m_ADOConnection;
  end;


  TRsFunModuleManager = class
  public
    constructor Create(LogOutEvent: TOnEventByString);
    destructor Destroy; override;
  private
    {配置对象}
    m_Config: TRsModuleConfigObject;
    {日志输出事件}
    m_OnLogOut: TOnEventByString;
    {数据库连接}
    m_ADOConnection: TADOConnection;
  public
    procedure LoadConfig(ConfigFileName: string);
    function CreateModule(strModuleName: string): TRsFunModule;
  public
    property ADOConnection: TADOConnection read m_ADOConnection write m_ADOConnection;
  end;

implementation

{ TFunModuleList }

function TRsStepList.GetItem(Index: Integer): TRsStepBase;
begin
  Result := TRsStepBase(inherited GetItem(Index));
end;

procedure TRsStepList.SetItem(Index: Integer; AObject: TRsStepBase);
begin
  inherited SetItem(Index,AObject);
end;

{ TFunModuleBase }

procedure TRsStepBase.CloseHint;
begin
  m_Owner.CloseHint;
end;

constructor TRsStepBase.Create(Owner: TRsFunModule;
  ConfigNode: TRsStepConfigNode);
begin
  inherited Create();
  m_Owner := Owner;
  m_ConfigNode := ConfigNode;
end;

procedure TRsStepBase.Init;
begin
  ;
end;

procedure TRsStepBase.LogOut(strLog: string);
begin
  if Assigned(m_Owner) then
    m_Owner.WriteLog(strLog);
end;


procedure TRsStepBase.ShowHint(strHint: string);
begin
  m_Owner.ShowHint(strHint);
end;

{ TFunModuleManager }

procedure TRsFunModule.CloseHint;
begin
  if Assigned(m_OnCloseHint) then
    m_OnCloseHint();
end;

constructor TRsFunModule.Create(LogOutEvent: TOnEventByString);
begin
  m_OnLogOut := LogOutEvent;
  m_RsStepList := TRsStepList.Create;
end;

destructor TRsFunModule.Destroy;
begin
  m_RsStepList.Free;
  inherited;
end;

function TRsFunModule.Execute(Param: TRsStepParam): Boolean;
{功能:执行各功能模块}
var
  i: Integer;
  Direction: TRsStepDirection;
begin
  i := 0;
  Result := False;
  while i < m_RsStepList.Count do
  begin
    try
      if not m_RsStepList[i].Execute(Param,Direction) then
        Exit;
      Result := i >= m_RsStepList.Count - 1;  
      case Direction of
        sdNextStep: inc(i);
        sdPreStep:
          begin
            if i > 0 then            
              Dec(i);
          end;
        sdCurrentStep:;
        sdExit: Break;
      end;

    except
      on E: Exception do
      begin
        WriteLog(m_RsStepList[i].m_ConfigNode.StepName + '执行失败:' + E.Message);
        raise Exception.Create(m_RsStepList[i].m_ConfigNode.StepName + '执行失败:' + E.Message);
      end;
    end;
  end;


  
end;

procedure TRsFunModule.InitStep;
var
  strClassName: string;
  RsStepBaseClass: TRsStepBaseClass;
  StepBase: TRsStepBase;
  I: Integer;
begin
  if m_ModuleConfigNode = nil then
    Exit;
    
  for I := 0 to m_ModuleConfigNode.StepNodeList.Count - 1 do
  begin
    if not m_ModuleConfigNode.StepNodeList[i].Enable then
      Continue;
      
    strClassName := VariantToString(m_ModuleConfigNode.StepNodeList[i].Attribute['ClassName']);

    if strClassName <> '' then
    begin
      try
        RsStepBaseClass := TRsStepBaseClass(FindClass(strClassName));

        StepBase := RsStepBaseClass.Create(Self,m_ModuleConfigNode.StepNodeList[i]);
        Self.StepList.Add(StepBase);
      except
        on E : Exception do
        begin
          raise Exception.Create('创建失败:' + E.Message);
        end;
      end;
    end
    else
      raise Exception.Create('创建失败:步骤类名为空!');
  end;

end;
procedure TRsFunModule.SetLogOutEvent(OnEventByString: TOnEventByString);
begin
  m_OnLogOut := OnEventByString;
end;

procedure TRsFunModule.ShowHint(strHint: string);
begin
  if Assigned(m_OnShowHint) then
    m_OnShowHint(strHint);
end;

procedure TRsFunModule.WriteLog(strLog: string);
begin
  if Assigned(m_OnLogOut) then
    m_OnLogOut(strLog);
end;



{ TRsFunModuleManager }

constructor TRsFunModuleManager.Create(LogOutEvent: TOnEventByString);
begin
  m_OnLogOut := LogOutEvent;
  m_Config := TRsModuleConfigObject.Create;
end;

function TRsFunModuleManager.CreateModule(strModuleName: string): TRsFunModule;
var
  FunModuleConfigNode: TRsFunModuleConfigNode;
begin
  FunModuleConfigNode := m_Config.FunModuleNodeList.FindModuleByName(strModuleName);
  if FunModuleConfigNode = nil then
    raise Exception.CreateFmt('未找到"%s"功能模块的配置信息!',[strModuleName]);

  Result := TRsFunModule.Create(m_OnLogOut);
  Result.ModuleConfigNode := FunModuleConfigNode;
  Result.ADOConnection := m_ADOConnection;
  try
    Result.InitStep();
  except
    on E: Exception do
    begin
      Result.Free;
      raise Exception.Create(strModuleName + E.Message);
    end;
  end;

end;

destructor TRsFunModuleManager.Destroy;
begin
  m_Config.Free;
  inherited;
end;

procedure TRsFunModuleManager.LoadConfig(ConfigFileName: string);
begin
  m_Config.LoadFromFile(ConfigFileName);
end;

end.
