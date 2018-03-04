unit uWriteICCarSoftWindowInformation;

interface
uses uTFSystem, Types, xmldom, XMLIntf, msxmldom, XMLDoc, Variants, TypInfo,
    SysUtils,Forms,uWriteICCarSoftDefined;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWindowInformation
  ///  说明:窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TWindowInformation = class
  public
    {打开窗口的快捷键}
    ShortCut : Integer;
    {打开窗口的鼠标点击坐标}
    MousePoint : TPoint;
    {窗口标题}
    WindowTitle : String;
    {窗口类名}
    WindowClassName : String;
    {打开窗口方式}
    OpenWindowStyle : TOpenWindowStyle;
    {等待打开时间,单位毫秒}
    WaitTimeOut : Int64;
  protected
    {功能:读取TabOrders}
    procedure ReadTabOrders(Node:IXMLNode;var TabOrders : TIntArray);
  public
    {功能:读取节点信息,纯虚方法}
    procedure ReadXMLNode(Node:IXMLNode);virtual;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TAdminLoginWindowInformation
  ///  说明:管理员登陆窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TAdminLoginWindowInformation = class(TWindowInformation)
  public
    {子控件句柄顺序}
    AdminLoginWindowChildOrders : RAdminLoginWindowChildOrders;
  public
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TAttendantLoginWindowInformation
  ///  说明:值班员登陆窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TAttendantLoginWindowInformation = class(TWindowInformation)
  public
    {子控件句柄顺序}
    AttendantLoginWindowChildOrders : RAttendantLoginWindowChildOrders;
  public
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWriteICCarWindowInformation
  ///  说明:写卡窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TWriteICCarWindowInformation = class(TWindowInformation)
  public
    {子控件句柄顺序}
    WriteICCarWindowChildOrders : RWriteICCarWindowChildOrders;
  public
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TPrintCountWindowInformation
  ///  说明:打印份数窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TPrintCountWindowInformation = class(TWindowInformation)
  public
    PrintCountWindowChildOrders : RPrintCountWindowChildOrders;
  public
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TJiaoFuJieShiPrintWindowInformation
  ///  说明:交付揭示打印窗口信息
  //////////////////////////////////////////////////////////////////////////////
  TJiaoFuJieShiPrintWindowInformation = class(TWindowInformation)
  public
    constructor Create();
    destructor Destroy();override;
  private
    {打印份数子窗口信息}
    m_PrintCountWindowInformation : TPrintCountWindowInformation;
  public
    {子控件句柄顺序}
    JiaoFuJieShiPrintWindowChildOrders : RJiaoFuJieShiPrintWindowChildOrders;
  public
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);override;
  public
    {打印份数子窗口信息}
    property PrintCountWindowInformation : TPrintCountWindowInformation
        read m_PrintCountWindowInformation;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWindowInformationManage
  ///  说明:窗口信息管理器
  //////////////////////////////////////////////////////////////////////////////
  TWindowInformationManage = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    {管理员登陆窗口信息}
    m_AdminLoginWindowInformation : TAdminLoginWindowInformation;
    {值班员登陆窗口信息}
    m_AttendantLoginWindowInformation : TAttendantLoginWindowInformation;
    {写卡窗口信息}
    m_WriteICCarWindowInformation : TWriteICCarWindowInformation;
    {交付揭示打印窗口信息}
    m_JiaoFuJieShiPrintWindowInformation : TJiaoFuJieShiPrintWindowInformation;
  protected
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);
  public
    {管理员登陆窗口信息}
    property AdminLoginWindowInformation : TAdminLoginWindowInformation
        read m_AdminLoginWindowInformation;
    {值班员登陆窗口信息}
    property AttendantLoginWindowInformation : TAttendantLoginWindowInformation
        read m_AttendantLoginWindowInformation;
    {写卡窗口信息}
    property WriteICCarWindowInformation : TWriteICCarWindowInformation
        read m_WriteICCarWindowInformation;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TWriteICCarSoftInformation
  ///  说明:写卡软件信息类
  //////////////////////////////////////////////////////////////////////////////
  TWriteICCarSoftInformation = class
  public
    Constructor Create();
    Destructor Destroy();override;
  private
    {软件各种窗口信息}
    m_WindowInformationManage : TWindowInformationManage;
    {主窗口标题}
    m_strMainFormTitle : String;
    {主窗口类名}
    m_strMainFormClassName : String;
    {主窗口等待时间}
    m_nMainFormWaitTimeOut : Int64;
    {最后一次错误信息}
    m_strLastError : String;
    m_XMLDocument : TXMLDocument;
  private
    {功能:验证XML文件}
    function CheckXMLFile(const strFileName : String):Boolean;
    {功能:读取节点信息}
    procedure ReadXMLNode(Node:IXMLNode);
  public
    {功能:读取XML信息}
    function LoadXMLFile(const strFileName:String):Boolean;
    {功能:获取最后一次错误信息}
    function GetLastError():String;
  public
    {软件各种窗口信息}
    property WindowInformationManage : TWindowInformationManage
        read m_WindowInformationManage;
    {主窗口标题}
    property MainFormTitle : String read m_strMainFormTitle;
    {主窗口类名}
    property MainFormClassName : String read m_strMainFormClassName;
    {主窗口等待时间}
    property MainFormWaitTimeOut : int64 read m_nMainFormWaitTimeOut;
  end;


implementation

{ TAdminLoginWindowInformation }

procedure TAdminLoginWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {读取工号编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'PassWord' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AdminLoginWindowChildOrders.edtPassWord_TabOrders);
      Continue;
    end;
    {读取确认按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'Confirm' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AdminLoginWindowChildOrders.btnConfirm_TabOrders);
      Continue;
    end;
  end;
end;

{ TWindowInformation }

procedure TWindowInformation.ReadTabOrders(Node: IXMLNode;
  var TabOrders: TIntArray);
{功能:读取TabOrders}
var
  i : Integer;
begin
  SetLengTh(TabOrders,Node.ChildNodes.Count);
  for I := 0 to Node.ChildNodes.Count - 1 do
    TabOrders[i] := Node.ChildNodes[i].Attributes['TabOrder'];
end;

procedure TWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息,纯虚方法}
begin
  if Node.Attributes['ShortCut'] <> null then
    ShortCut := Node.Attributes['ShortCut'];

  if Node.Attributes['MousePoint_X'] <> null then
    MousePoint.X := Node.Attributes['MousePoint_X'];

  if Node.Attributes['MousePoint_Y'] <> null then
    MousePoint.Y := Node.Attributes['MousePoint_Y'];

  if Node.Attributes['WindowTitle'] <> null then
    WindowTitle := Node.Attributes['WindowTitle'];

  if Node.Attributes['WindowClassName'] <> null then
    WindowClassName := Node.Attributes['WindowClassName'];

  if Node.Attributes['WaitTimeOut'] <> null then
    WaitTimeOut := Node.Attributes['WaitTimeOut']
  else
  begin
    {默认30秒}
    WaitTimeOut := 30000;
  end;

  if Node.Attributes['OpenWindowStyle'] <> null then
  begin
    OpenWindowStyle := TOpenWindowStyle(GetEnumValue(TypeInfo(TOpenWindowStyle),
        Node.Attributes['OpenWindowStyle']));
  end;
end;

{ TAttendantLoginWindowInformation }

procedure TAttendantLoginWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {读取工号编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'Number' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AttendantLoginWindowChildOrders.edtNumber_TabOrders);
      Continue;
    end;
    {读取密码编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'PassWord' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AttendantLoginWindowChildOrders.edtPassWord_TabOrders);
      Continue;
    end;
    {读取确认按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'Confirm' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AttendantLoginWindowChildOrders.btnConfirm_TabOrders);
      Continue;
    end;
  end;
end;

{ TWriteICCarWindowInformation }

procedure TWriteICCarWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {读取区段TabOrders}
    if Node.ChildNodes[i].NodeName = 'QuDuan' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.cbxQuDuan_TabOrders);
      Continue;
    end;
    {读取客车单选按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'KeChe' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbKeChe_TabOrders);
      Continue;
    end;
    {读取货车单选按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'HuoChe' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbHuoChe_TabOrders);
      Continue;
    end;
    {读取客货车单选按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'KeHuo' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbKeHuo_TabOrders);
      Continue;
    end;
    {读取车次头下拉框TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiTou' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.cbxCheCiTou_TabOrders);
      Continue;
    end;
    {读取车次头编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiTouEdit' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.edtCheCiTou_TabOrders);
      Continue;
    end;
    {读取车次号编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiNumber' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.edtCheCiNumber_TabOrders);
      Continue;
    end;
    {待添加}
  end;
end;

{ TWindowInformationManage }

function TWriteICCarSoftInformation.CheckXMLFile(
  const strFileName: String): Boolean;
{功能:验证XML文件}
begin
  Result := False;
  if FileExists(strFileName) = False then
  begin
    m_strLastError := '文件"'+strFileName+'"不存在!';
    Exit;
  end;
  if m_XMLDocument.DocumentElement = nil then
  begin
    m_strLastError := '文件"'+strFileName+'"没有内容,无法使用!';
    Exit;
  end;

  if m_XMLDocument.DocumentElement.NodeName <> '写卡软件信息' then
  begin
    m_strLastError := '文件"'+strFileName+'"不是写卡软件窗口信息文件!';
    Exit;
  end;
  
  Result := True;
end;

constructor TWindowInformationManage.Create;
begin
  m_AdminLoginWindowInformation := TAdminLoginWindowInformation.Create;
  m_AttendantLoginWindowInformation := TAttendantLoginWindowInformation.Create;
  m_WriteICCarWindowInformation := TWriteICCarWindowInformation.Create;
  m_JiaoFuJieShiPrintWindowInformation := TJiaoFuJieShiPrintWindowInformation.Create;
end;

destructor TWindowInformationManage.Destroy;
begin
  m_AdminLoginWindowInformation.Free;
  m_AttendantLoginWindowInformation.Free;
  m_WriteICCarWindowInformation.Free;
  m_JiaoFuJieShiPrintWindowInformation.Free;
  inherited;
end;

procedure TWindowInformationManage.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    if Node.ChildNodes[i].NodeName = '管理员登陆窗口' then
    begin
      m_AdminLoginWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
    if Node.ChildNodes[i].NodeName = '值班员登陆窗口' then
    begin
      m_AttendantLoginWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
    if Node.ChildNodes[i].NodeName = '写卡窗口' then
    begin
      m_WriteICCarWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
  end;
end;

function TWriteICCarSoftInformation.GetLastError: String;
begin
  Result := m_strLastError;
end;

function TWriteICCarSoftInformation.LoadXMLFile(
  const strFileName: String): Boolean;
{功能:读取XML信息}
var
  i : Integer;
  RootNode : IXMLNode;
begin
  Result := False;
  if CheckXMLFile(strFileName) = False then Exit;
  RootNode := m_XMLDocument.DocumentElement;
  for I := 0 to RootNode.ChildNodes.Count - 1 do
  begin
    if RootNode.ChildNodes[i].NodeName = '软件信息' then
    begin
      ReadXMLNode(RootNode.ChildNodes[i]);
      Continue;
    end;
    if RootNode.ChildNodes[i].NodeName = '窗口信息' then
    begin
      m_WindowInformationManage.ReadXMLNode(RootNode.ChildNodes[i]);
      Continue;
    end;
  end;
end;


procedure TWriteICCarSoftInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
begin
  if Node.Attributes['MainFormTitle'] <> null then
    m_strMainFormTitle := Node.Attributes['MainFormTitle'];

  if Node.Attributes['MainFormClassName'] <> null then
    m_strMainFormClassName := Node.Attributes['MainFormClassName'];

  if Node.Attributes['MainFormWaitTimeOut'] <> null then
    m_nMainFormWaitTimeOut := Node.Attributes['MainFormWaitTimeOut']
  else
  begin
    {默认30秒}
    m_nMainFormWaitTimeOut := 30000;
  end;

end;

{ TJiaoFuJieShiPrintWindowInformation }

constructor TJiaoFuJieShiPrintWindowInformation.Create;
begin
  m_PrintCountWindowInformation := TPrintCountWindowInformation.Create;
end;

destructor TJiaoFuJieShiPrintWindowInformation.Destroy;
begin
  m_PrintCountWindowInformation.Free;
  inherited;
end;

procedure TJiaoFuJieShiPrintWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    if Node.ChildNodes[i].NodeName = 'PrintPreview' then
    begin
      if Node.ChildNodes[i].Attributes['X'] <> null then
      begin
        JiaoFuJieShiPrintWindowChildOrders.btnPrintPreview_MousePoint.X :=
          Node.ChildNodes[i].Attributes['X'];
      end;

      if Node.ChildNodes[i].Attributes['Y'] <> null then
      begin
        JiaoFuJieShiPrintWindowChildOrders.btnPrintPreview_MousePoint.X :=
          Node.ChildNodes[i].Attributes['Y'];
      end;
      Continue;
    end;
    {读取打印参数所属面板TabOrders}
    if Node.ChildNodes[i].NodeName = 'PrintParent' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.PrintParent_TabOrders);
      Continue;
    end;

    {读取区段TabOrders}
    if Node.ChildNodes[i].NodeName = 'Section' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxSection_TabOrders);
      Continue;
    end;

    {读取区段TabOrders}
    if Node.ChildNodes[i].NodeName = 'Section' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxSection_TabOrders);
      Continue;
    end;

    {读取行车方向TabOrders}
    if Node.ChildNodes[i].NodeName = 'Direction' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxDirection_TabOrders);
      Continue;
    end;

    {读取客货TabOrders}
    if Node.ChildNodes[i].NodeName = 'KeHuo' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxKeHuo_TabOrders);
      Continue;
    end;

    {读取打印按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'Print' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.btnPrint_TabOrders);
      Continue;
    end;

    if Node.ChildNodes[i].NodeName = '打印份数输入窗口' then
    begin
      m_PrintCountWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
  end;
end;

{ TPrintCountWindowInformation }

procedure TPrintCountWindowInformation.ReadXMLNode(Node: IXMLNode);
{功能:读取节点信息}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {读取打印份数编辑框TabOrders}
    if Node.ChildNodes[i].NodeName = 'PrintCount' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          PrintCountWindowChildOrders.edtPrintCount_TabOrders);
      Continue;
    end;
    {读取确认打印按钮TabOrders}
    if Node.ChildNodes[i].NodeName = 'Confirm' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          PrintCountWindowChildOrders.btnConfirm_TabOrders);
      Continue;
    end;
  end;
end;

{ TWriteICCarSoftInformation }

constructor TWriteICCarSoftInformation.Create;
begin
  m_XMLDocument := TXMLDocument.Create(Application.MainForm);
  m_XMLDocument.Active := True;
  m_WindowInformationManage := TWindowInformationManage.Create;
  {主窗口等待时间默认为30秒}
  m_nMainFormWaitTimeOut := 30000;
end;

destructor TWriteICCarSoftInformation.Destroy;
begin
  m_WindowInformationManage.Free;
  m_XMLDocument.Free;
  inherited;
end;

end.
