unit uWriteICCarSoftWindowInformation;

interface
uses uTFSystem, Types, xmldom, XMLIntf, msxmldom, XMLDoc, Variants, TypInfo,
    SysUtils,Forms,uWriteICCarSoftDefined;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWindowInformation
  ///  ˵��:������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWindowInformation = class
  public
    {�򿪴��ڵĿ�ݼ�}
    ShortCut : Integer;
    {�򿪴��ڵ����������}
    MousePoint : TPoint;
    {���ڱ���}
    WindowTitle : String;
    {��������}
    WindowClassName : String;
    {�򿪴��ڷ�ʽ}
    OpenWindowStyle : TOpenWindowStyle;
    {�ȴ���ʱ��,��λ����}
    WaitTimeOut : Int64;
  protected
    {����:��ȡTabOrders}
    procedure ReadTabOrders(Node:IXMLNode;var TabOrders : TIntArray);
  public
    {����:��ȡ�ڵ���Ϣ,���鷽��}
    procedure ReadXMLNode(Node:IXMLNode);virtual;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TAdminLoginWindowInformation
  ///  ˵��:����Ա��½������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TAdminLoginWindowInformation = class(TWindowInformation)
  public
    {�ӿؼ����˳��}
    AdminLoginWindowChildOrders : RAdminLoginWindowChildOrders;
  public
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TAttendantLoginWindowInformation
  ///  ˵��:ֵ��Ա��½������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TAttendantLoginWindowInformation = class(TWindowInformation)
  public
    {�ӿؼ����˳��}
    AttendantLoginWindowChildOrders : RAttendantLoginWindowChildOrders;
  public
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWriteICCarWindowInformation
  ///  ˵��:д��������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWriteICCarWindowInformation = class(TWindowInformation)
  public
    {�ӿؼ����˳��}
    WriteICCarWindowChildOrders : RWriteICCarWindowChildOrders;
  public
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TPrintCountWindowInformation
  ///  ˵��:��ӡ����������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TPrintCountWindowInformation = class(TWindowInformation)
  public
    PrintCountWindowChildOrders : RPrintCountWindowChildOrders;
  public
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);override;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TJiaoFuJieShiPrintWindowInformation
  ///  ˵��:������ʾ��ӡ������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TJiaoFuJieShiPrintWindowInformation = class(TWindowInformation)
  public
    constructor Create();
    destructor Destroy();override;
  private
    {��ӡ�����Ӵ�����Ϣ}
    m_PrintCountWindowInformation : TPrintCountWindowInformation;
  public
    {�ӿؼ����˳��}
    JiaoFuJieShiPrintWindowChildOrders : RJiaoFuJieShiPrintWindowChildOrders;
  public
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);override;
  public
    {��ӡ�����Ӵ�����Ϣ}
    property PrintCountWindowInformation : TPrintCountWindowInformation
        read m_PrintCountWindowInformation;
  end;


  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWindowInformationManage
  ///  ˵��:������Ϣ������
  //////////////////////////////////////////////////////////////////////////////
  TWindowInformationManage = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    {����Ա��½������Ϣ}
    m_AdminLoginWindowInformation : TAdminLoginWindowInformation;
    {ֵ��Ա��½������Ϣ}
    m_AttendantLoginWindowInformation : TAttendantLoginWindowInformation;
    {д��������Ϣ}
    m_WriteICCarWindowInformation : TWriteICCarWindowInformation;
    {������ʾ��ӡ������Ϣ}
    m_JiaoFuJieShiPrintWindowInformation : TJiaoFuJieShiPrintWindowInformation;
  protected
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);
  public
    {����Ա��½������Ϣ}
    property AdminLoginWindowInformation : TAdminLoginWindowInformation
        read m_AdminLoginWindowInformation;
    {ֵ��Ա��½������Ϣ}
    property AttendantLoginWindowInformation : TAttendantLoginWindowInformation
        read m_AttendantLoginWindowInformation;
    {д��������Ϣ}
    property WriteICCarWindowInformation : TWriteICCarWindowInformation
        read m_WriteICCarWindowInformation;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWriteICCarSoftInformation
  ///  ˵��:д�������Ϣ��
  //////////////////////////////////////////////////////////////////////////////
  TWriteICCarSoftInformation = class
  public
    Constructor Create();
    Destructor Destroy();override;
  private
    {������ִ�����Ϣ}
    m_WindowInformationManage : TWindowInformationManage;
    {�����ڱ���}
    m_strMainFormTitle : String;
    {����������}
    m_strMainFormClassName : String;
    {�����ڵȴ�ʱ��}
    m_nMainFormWaitTimeOut : Int64;
    {���һ�δ�����Ϣ}
    m_strLastError : String;
    m_XMLDocument : TXMLDocument;
  private
    {����:��֤XML�ļ�}
    function CheckXMLFile(const strFileName : String):Boolean;
    {����:��ȡ�ڵ���Ϣ}
    procedure ReadXMLNode(Node:IXMLNode);
  public
    {����:��ȡXML��Ϣ}
    function LoadXMLFile(const strFileName:String):Boolean;
    {����:��ȡ���һ�δ�����Ϣ}
    function GetLastError():String;
  public
    {������ִ�����Ϣ}
    property WindowInformationManage : TWindowInformationManage
        read m_WindowInformationManage;
    {�����ڱ���}
    property MainFormTitle : String read m_strMainFormTitle;
    {����������}
    property MainFormClassName : String read m_strMainFormClassName;
    {�����ڵȴ�ʱ��}
    property MainFormWaitTimeOut : int64 read m_nMainFormWaitTimeOut;
  end;


implementation

{ TAdminLoginWindowInformation }

procedure TAdminLoginWindowInformation.ReadXMLNode(Node: IXMLNode);
{����:��ȡ�ڵ���Ϣ}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {��ȡ���ű༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'PassWord' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AdminLoginWindowChildOrders.edtPassWord_TabOrders);
      Continue;
    end;
    {��ȡȷ�ϰ�ťTabOrders}
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
{����:��ȡTabOrders}
var
  i : Integer;
begin
  SetLengTh(TabOrders,Node.ChildNodes.Count);
  for I := 0 to Node.ChildNodes.Count - 1 do
    TabOrders[i] := Node.ChildNodes[i].Attributes['TabOrder'];
end;

procedure TWindowInformation.ReadXMLNode(Node: IXMLNode);
{����:��ȡ�ڵ���Ϣ,���鷽��}
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
    {Ĭ��30��}
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
{����:��ȡ�ڵ���Ϣ}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {��ȡ���ű༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'Number' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AttendantLoginWindowChildOrders.edtNumber_TabOrders);
      Continue;
    end;
    {��ȡ����༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'PassWord' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          AttendantLoginWindowChildOrders.edtPassWord_TabOrders);
      Continue;
    end;
    {��ȡȷ�ϰ�ťTabOrders}
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
{����:��ȡ�ڵ���Ϣ}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {��ȡ����TabOrders}
    if Node.ChildNodes[i].NodeName = 'QuDuan' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.cbxQuDuan_TabOrders);
      Continue;
    end;
    {��ȡ�ͳ���ѡ��ťTabOrders}
    if Node.ChildNodes[i].NodeName = 'KeChe' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbKeChe_TabOrders);
      Continue;
    end;
    {��ȡ������ѡ��ťTabOrders}
    if Node.ChildNodes[i].NodeName = 'HuoChe' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbHuoChe_TabOrders);
      Continue;
    end;
    {��ȡ�ͻ�����ѡ��ťTabOrders}
    if Node.ChildNodes[i].NodeName = 'KeHuo' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.rbKeHuo_TabOrders);
      Continue;
    end;
    {��ȡ����ͷ������TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiTou' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.cbxCheCiTou_TabOrders);
      Continue;
    end;
    {��ȡ����ͷ�༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiTouEdit' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.edtCheCiTou_TabOrders);
      Continue;
    end;
    {��ȡ���κű༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'CheCiNumber' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          WriteICCarWindowChildOrders.edtCheCiNumber_TabOrders);
      Continue;
    end;
    {�����}
  end;
end;

{ TWindowInformationManage }

function TWriteICCarSoftInformation.CheckXMLFile(
  const strFileName: String): Boolean;
{����:��֤XML�ļ�}
begin
  Result := False;
  if FileExists(strFileName) = False then
  begin
    m_strLastError := '�ļ�"'+strFileName+'"������!';
    Exit;
  end;
  if m_XMLDocument.DocumentElement = nil then
  begin
    m_strLastError := '�ļ�"'+strFileName+'"û������,�޷�ʹ��!';
    Exit;
  end;

  if m_XMLDocument.DocumentElement.NodeName <> 'д�������Ϣ' then
  begin
    m_strLastError := '�ļ�"'+strFileName+'"����д�����������Ϣ�ļ�!';
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
{����:��ȡ�ڵ���Ϣ}
var
  i : Integer;
begin
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    if Node.ChildNodes[i].NodeName = '����Ա��½����' then
    begin
      m_AdminLoginWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
    if Node.ChildNodes[i].NodeName = 'ֵ��Ա��½����' then
    begin
      m_AttendantLoginWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
    if Node.ChildNodes[i].NodeName = 'д������' then
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
{����:��ȡXML��Ϣ}
var
  i : Integer;
  RootNode : IXMLNode;
begin
  Result := False;
  if CheckXMLFile(strFileName) = False then Exit;
  RootNode := m_XMLDocument.DocumentElement;
  for I := 0 to RootNode.ChildNodes.Count - 1 do
  begin
    if RootNode.ChildNodes[i].NodeName = '�����Ϣ' then
    begin
      ReadXMLNode(RootNode.ChildNodes[i]);
      Continue;
    end;
    if RootNode.ChildNodes[i].NodeName = '������Ϣ' then
    begin
      m_WindowInformationManage.ReadXMLNode(RootNode.ChildNodes[i]);
      Continue;
    end;
  end;
end;


procedure TWriteICCarSoftInformation.ReadXMLNode(Node: IXMLNode);
{����:��ȡ�ڵ���Ϣ}
begin
  if Node.Attributes['MainFormTitle'] <> null then
    m_strMainFormTitle := Node.Attributes['MainFormTitle'];

  if Node.Attributes['MainFormClassName'] <> null then
    m_strMainFormClassName := Node.Attributes['MainFormClassName'];

  if Node.Attributes['MainFormWaitTimeOut'] <> null then
    m_nMainFormWaitTimeOut := Node.Attributes['MainFormWaitTimeOut']
  else
  begin
    {Ĭ��30��}
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
{����:��ȡ�ڵ���Ϣ}
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
    {��ȡ��ӡ�����������TabOrders}
    if Node.ChildNodes[i].NodeName = 'PrintParent' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.PrintParent_TabOrders);
      Continue;
    end;

    {��ȡ����TabOrders}
    if Node.ChildNodes[i].NodeName = 'Section' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxSection_TabOrders);
      Continue;
    end;

    {��ȡ����TabOrders}
    if Node.ChildNodes[i].NodeName = 'Section' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxSection_TabOrders);
      Continue;
    end;

    {��ȡ�г�����TabOrders}
    if Node.ChildNodes[i].NodeName = 'Direction' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxDirection_TabOrders);
      Continue;
    end;

    {��ȡ�ͻ�TabOrders}
    if Node.ChildNodes[i].NodeName = 'KeHuo' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.cbxKeHuo_TabOrders);
      Continue;
    end;

    {��ȡ��ӡ��ťTabOrders}
    if Node.ChildNodes[i].NodeName = 'Print' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          JiaoFuJieShiPrintWindowChildOrders.btnPrint_TabOrders);
      Continue;
    end;

    if Node.ChildNodes[i].NodeName = '��ӡ�������봰��' then
    begin
      m_PrintCountWindowInformation.ReadXMLNode(Node.ChildNodes[i]);
      Continue;
    end;
  end;
end;

{ TPrintCountWindowInformation }

procedure TPrintCountWindowInformation.ReadXMLNode(Node: IXMLNode);
{����:��ȡ�ڵ���Ϣ}
var
  i : Integer;
begin
  inherited;
  for I := 0 to Node.ChildNodes.Count - 1 do
  begin
    {��ȡ��ӡ�����༭��TabOrders}
    if Node.ChildNodes[i].NodeName = 'PrintCount' then
    begin
      ReadTabOrders(Node.ChildNodes[i],
          PrintCountWindowChildOrders.edtPrintCount_TabOrders);
      Continue;
    end;
    {��ȡȷ�ϴ�ӡ��ťTabOrders}
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
  {�����ڵȴ�ʱ��Ĭ��Ϊ30��}
  m_nMainFormWaitTimeOut := 30000;
end;

destructor TWriteICCarSoftInformation.Destroy;
begin
  m_WindowInformationManage.Free;
  m_XMLDocument.Free;
  inherited;
end;

end.
