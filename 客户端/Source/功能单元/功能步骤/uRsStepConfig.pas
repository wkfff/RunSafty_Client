unit uRsStepConfig;

interface
uses
  Classes,IniFiles,uTFSystem,XMLDoc,XMLIntf,Windows,uCommonFunctions,SysUtils,
  Contnrs;
type
  TRsModuleConfigObject = class;
  TRsStepConfigNodeList = class;
  TRsFunModuleConfigNode = class;

  {TRsStepConfigNode 功能步骤配置节点}
  TRsStepConfigNode = class
  public
    constructor Create(Owner: TRsFunModuleConfigNode);
    destructor Destroy; override;
  public
    procedure LoadFromXml(Node: IXMLNode);
  private
    m_Owner: TRsFunModuleConfigNode;
    m_XMLNode: IXMLNode;
    function GetAttribute(Name: string): Variant;
    procedure SetAttribute(Name: string; const Value: Variant);
    function GetStepName(): string;
    procedure SetStepName(Value:string);
    function GetEnable(): Boolean;
    procedure SetEnable(Value: Boolean);
    function GetStepClassName(): string;
    procedure SetStepClassName(const Value: string);
  public
    property StepName: string read GetStepName write SetStepName;
    property StepClassName: string read GetStepClassName write SetStepClassName;
    property Enable: Boolean read GetEnable write SetEnable;
    property Attribute[Name: string]: Variant read GetAttribute write SetAttribute;
  end;

  {TRsStepConfigNodeList 功能步骤配置列表}
  TRsStepConfigNodeList = class(TObjectList)
  public
    constructor Create(Owner: TRsFunModuleConfigNode);
  private
    m_Owner: TRsFunModuleConfigNode;
  protected
    function GetItem(Index: Integer): TRsStepConfigNode;
    procedure SetItem(Index: Integer; AObject: TRsStepConfigNode);
  public
    procedure LoadFromXml(Node: IXMLNode);
    function ItemByModuleClassName(strClassName: string): TRsStepConfigNode;
  public
    property Items[Index: Integer]: TRsStepConfigNode read GetItem write SetItem; default;
  end;


  TRsFunModuleConfigNode = class
  public
    constructor Create(Owner: TRsModuleConfigObject);
    destructor Destroy; override;
  private
    m_Owner: TRsModuleConfigObject;
    m_XMLNode: IXMLNode;
    m_RsStepNodeList: TRsStepConfigNodeList;
    function GetAttribute(Name: string): Variant;
    function GetEnable: Boolean;
    function GetModlueName: string;
    procedure SetAttribute(Name: string; const Value: Variant);
    procedure SetEnable(const Value: Boolean);
    procedure SetModlueName(const Value: string);
  public
    procedure LoadFromXml(Node: IXMLNode);
  public
    property ModlueName: string read GetModlueName write SetModlueName;
    property Enable: Boolean read GetEnable write SetEnable;
    property Attribute[Name: string]: Variant read GetAttribute write SetAttribute;
    property StepNodeList: TRsStepConfigNodeList read m_RsStepNodeList;
  end;

  TRsFunModuleConfigNodeList = class(TObjectList)
  public
    constructor Create(Owner: TRsModuleConfigObject);
  private
    m_Owner: TRsModuleConfigObject;
  protected
    function GetItem(Index: Integer): TRsFunModuleConfigNode;
    procedure SetItem(Index: Integer; AObject: TRsFunModuleConfigNode);
  public
    procedure LoadFromXml(Node: IXMLNode);
    function FindModuleByName(strModuleName: string): TRsFunModuleConfigNode;
  public
    property Items[Index: Integer]: TRsFunModuleConfigNode read GetItem write SetItem; default;
  
  end;
  
  {TRsModuleConfigObject 功能配置对象}
  TRsModuleConfigObject = class
  public
    constructor Create();
    destructor Destroy; override;
  public
    {功能:从文件加载配置信息}
    procedure LoadFromFile(FileName: string);
    {功能:保存配置信息到文件}
    procedure SaveToFile(FileName: string);
  private
    {XML文档对象}
    m_XMLDoc: IXMLDocument;
    {系统目录}
    m_strSysPath: string;
    {功能模块列表}
    m_FunModuleNodeList: TRsFunModuleConfigNodeList;
  private
    {功能:查找根节点}
    function FindRootNode(): IXMLNode;
  public
    property FunModuleNodeList: TRsFunModuleConfigNodeList read m_FunModuleNodeList;
    {系统目录}
    property sysPath: string read m_strSysPath;
  end;

implementation

{ TRsStepConfigObject }

constructor TRsModuleConfigObject.Create;
begin
  m_XMLDoc := NewXMLDocument();
  m_strSysPath := MakePath(ExtractFilePath(ParamStr(0)));
  m_FunModuleNodeList := TRsFunModuleConfigNodeList.Create(Self);
end;

destructor TRsModuleConfigObject.Destroy;
begin
  m_FunModuleNodeList.Free;
  m_XMLDoc := nil;
  inherited;
end;


function TRsModuleConfigObject.FindRootNode: IXMLNode;
{功能:查找根节点}
begin
  Result := m_XMLDoc.ChildNodes.Nodes['ModuleConfig'];
  if Result = nil then
    Result := m_XMLDoc.AddChild('ModuleConfig');
end;

procedure TRsModuleConfigObject.LoadFromFile(FileName: string);
{功能:从文件加载配置信息}
begin
  m_XMLDoc.LoadFromFile(FileName);
  m_FunModuleNodeList.LoadFromXml(FindRootNode);
end;


procedure TRsModuleConfigObject.SaveToFile(FileName: string);
{功能:保存配置信息到文件}
begin
  m_XMLDoc.SaveToFile(FileName);
end;

{ TRsStepConfigNode }

constructor TRsStepConfigNode.Create(Owner: TRsFunModuleConfigNode);
begin
  m_Owner := Owner;
end;

destructor TRsStepConfigNode.Destroy;
begin
  inherited;
end;

function TRsStepConfigNode.GetAttribute(Name: string): Variant;
begin
  Result := m_XMLNode.Attributes[Name];
end;

function TRsStepConfigNode.GetEnable: Boolean;
begin
  Result := VariantToBoolean(Attribute['Enable']);
end;

function TRsStepConfigNode.GetStepClassName: string;
begin
  Result := Attribute['ClassName'];
end;

function TRsStepConfigNode.GetStepName: string;
begin
  Result := VariantToString(Attribute['StepName']);
end;

procedure TRsStepConfigNode.LoadFromXml(Node: IXMLNode);
begin
  m_XMLNode := Node;
end;

procedure TRsStepConfigNode.SetAttribute(Name: string; const Value: Variant);
begin
  m_XMLNode.Attributes[Name] := Value;
end;

procedure TRsStepConfigNode.SetEnable(Value: Boolean);
begin
  Attribute['Enable'] := Value;
end;

procedure TRsStepConfigNode.SetStepClassName(const Value: string);
begin
  Attribute['ClassName'] := Value;
end;

procedure TRsStepConfigNode.SetStepName(Value: string);
begin
  Attribute['Name'] := Value;
end;


{ TRsStepConfigNodeList }

constructor TRsStepConfigNodeList.Create(Owner: TRsFunModuleConfigNode);
begin
  m_Owner := Owner;
  inherited Create();
end;

function TRsStepConfigNodeList.GetItem(Index: Integer): TRsStepConfigNode;
begin
  Result := TRsStepConfigNode(inherited GetItem(Index));
end;

function TRsStepConfigNodeList.ItemByModuleClassName(
  strClassName: string): TRsStepConfigNode;
var
  i: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].StepClassName = strClassName then
    begin
      Result := Items[i];
      Break;
    end;    
  end;

end;

procedure TRsStepConfigNodeList.LoadFromXml(Node: IXMLNode);
var
  i: Integer;
  ConfigNode: TRsStepConfigNode;
begin
  Clear;
  if Node = nil then
    Exit;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    ConfigNode := TRsStepConfigNode.Create(m_Owner);
    ConfigNode.LoadFromXml(Node.ChildNodes.Nodes[i]);
    Add(ConfigNode);
  end;

end;

procedure TRsStepConfigNodeList.SetItem(Index: Integer; AObject: TRsStepConfigNode);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsFunModuleConfigNode }

constructor TRsFunModuleConfigNode.Create(Owner: TRsModuleConfigObject);
begin
  m_Owner := Owner;
  m_RsStepNodeList := TRsStepConfigNodeList.Create(Self);
end;

destructor TRsFunModuleConfigNode.Destroy;
begin
  m_RsStepNodeList.Free;
  inherited;
end;

function TRsFunModuleConfigNode.GetAttribute(Name: string): Variant;
begin
  Result := m_XMLNode.Attributes[Name];
end;

function TRsFunModuleConfigNode.GetEnable: Boolean;
begin
  Result := Attribute['Enable'];
end;

function TRsFunModuleConfigNode.GetModlueName: string;
begin
  Result := Attribute['ModuleName'];
end;

procedure TRsFunModuleConfigNode.LoadFromXml(Node: IXMLNode);
begin
  m_XMLNode := Node;
  m_RsStepNodeList.LoadFromXml(m_XMLNode);
end;

procedure TRsFunModuleConfigNode.SetAttribute(Name: string;
  const Value: Variant);
begin
  m_XMLNode.Attributes[Name] := Value;
end;

procedure TRsFunModuleConfigNode.SetEnable(const Value: Boolean);
begin
  Attribute['Enable'] := Value;
end;

procedure TRsFunModuleConfigNode.SetModlueName(const Value: string);
begin
  Attribute['ModuleName'] := Value;
end;

{ TRsFunModuleConfigNodeList }

constructor TRsFunModuleConfigNodeList.Create(Owner: TRsModuleConfigObject);
begin
  m_Owner := Owner;
  inherited Create();
end;

function TRsFunModuleConfigNodeList.FindModuleByName(
  strModuleName: string): TRsFunModuleConfigNode;
var
  i: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if UpperCase(strModuleName) = UpperCase(Items[i].ModlueName) then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TRsFunModuleConfigNodeList.GetItem(
  Index: Integer): TRsFunModuleConfigNode;
begin
  Result := TRsFunModuleConfigNode(inherited GetItem(Index));
end;

procedure TRsFunModuleConfigNodeList.LoadFromXml(Node: IXMLNode);
var
  i: Integer;
  ConfigNode: TRsFunModuleConfigNode;
begin
  Clear;
  if Node = nil then
    Exit;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    ConfigNode := TRsFunModuleConfigNode.Create(m_Owner);
    ConfigNode.LoadFromXml(Node.ChildNodes.Nodes[i]);
    Add(ConfigNode);
  end;

end;


procedure TRsFunModuleConfigNodeList.SetItem(Index: Integer;
  AObject: TRsFunModuleConfigNode);
begin
  inherited SetItem(Index,AObject);
end;

initialization


finalization

end.
