unit uRFSocket;

interface
uses
  WinSock,Windows,SysUtils,Classes,Contnrs,StrUtils,SyncObjs,Math,uTFSystem;
const
  CS_BUF_LEN = 8192;
type

  {socket�����Ļ���}
  TRFSocketContext = class
  public
    {����socket���л���}
    class function Start():Boolean;
    {�ر�socket���л���}
    class function Close():Boolean;
  end;

  {�˿ڵ�ַ��Ϣ����}
  RSockInfo = record
  public
    //Զ��ip��ַ
    strIP:string;
    //�˿ں�
    nPort:Integer;
    //socket��ַ�ṹ��
    SockAddr :TSockAddrIn;
  end;

  //���ݰ���ͷ�ṹ��
  RRFSockPackHead = record
  public
    //����ʼ��ʾ
    nStartFlag:Integer;
    //��ID
    nPackageID:Integer;
    //����ID
    nOrderID:Integer;
    //�ְ�����
    nSubPackageCount:Integer;
    //���зְ������ܳ���
    nTotalDataLen:Integer;
    //��ǰ�ְ�����
    nSubPackageIndex:Integer;
    //��ǰ�����ܴ�С
    nPackageSize:Integer;
  public
    {����:������Ϣ}
    procedure Reset();
  end;

  {���ݰ���ͷ�ṹ��}
  RRFSockPackTail = record
  public
    //��������ʾ
    nEndFlag:Integer;
  public
    {����:����}
    procedure Reset();
  end;


  {socketͨ�����ݰ� һ�����޶���СΪ8K}
  TRFSockPackage = class
  public
    //���ݰ�������
    data:array[0..8191] of char;
    //��ͷ�ṹ��
    RHead:RRFSockPackHead;
    //��β�ṹ��
    RTail:RRFSockPackTail;
    //�ѽ��հ�����
    nHandleLen:Integer;
  public
    {����:���ð���Ϣ}
    procedure ClearPackage();
  public
    class function GetMaxDataSize():Integer;
  private
    {����:��ȡ�ѽ��������򳤶�}
    function GetDataLen():Integer;
    {����:��ȡ���������ݳ���}
    function GetNeedRecvLen():Integer;
  public
    //���ݳ���
    property nDataLen:Integer read GetDataLen;
    //���������ݳ���
    property nNeedRecvLen:Integer read GetNeedRecvLen;
  end;

  {Ԥ����TCP�ͻ��˶���}
  TRFTCPClient = class;
  //�շ��ص�����
  TRFTCPIOHandleFun = procedure (Client:TRFTCPClient;nTotalSize:Integer;nHasDeal:Integer) of object;

  {���ݽ��ջ���,�����շ��Ƿְ�ִ�е�}
  TRFTCPIOHandler = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {����:��ʼ����}
    function StartSend():Boolean;virtual;
    {����:��ʼ����}
    function StartRecv():Boolean;virtual;
    
    {����:�������ݽӿ�}
    procedure DoRecv(package:TRFSockPackage;var bFinish:Boolean);virtual;abstract;
    {����:�������ݽӿ�}
    procedure DoSend(package:TRFSockPackage;var bFinish:Boolean);virtual;abstract;
    {����:��ȡ��һ���������ݰ�}
    function GetSendPackage(var package:TRFSockPackage):Boolean;virtual;abstract;
    {����:��ȡ��һ���������ݰ�}
    function GetRecvPackage(var package:TRFSockPackage):Boolean;virtual;abstract;
    
  protected
    {����:���÷�����Ϣ}
    procedure ClearSendInfo();
    {����:���ý�����}
    procedure ClearRecvInfo();

  protected
    //���ͷְ�����
    nSendPackageCount:Integer;
    //���͵�ǰ������
    nSendPackageIndex:Integer;
    //���ͷְ�����
    nRecvPackageCount:Integer;
    //���͵�ǰ������
    nRecvPackageIndex:Integer;

    //���������ݳ���
    nToTalSendLen:Integer;
    //�ѷ������ݳ���
    nHasSendLen:Integer;
    //���������ݳ���
    nToTalRecvLen:Integer;
    //�ѽ������ݳ���
    nHasRecvLen:Integer;
    //�������ݰ�
    SendPackage:TRFSockPackage ;
    //�������ݰ�
    RecvPackage:TRFSockPackage;
    //������ʹ����
    m_Client:TRFTCPClient;
    //���ͻص��¼�
    m_OnSendEvent:TRFTCPIOHandleFun;
    //���ջص��¼�
    m_OnRecvEvent:TRFTCPIOHandleFun;
  public
    property OnSendEvent:TRFTCPIOHandleFun read m_OnRecvEvent write m_OnRecvEvent ;
    property OnRecvEvent:TRFTCPIOHandleFun read m_OnRecvEvent write m_OnRecvEvent ;
    property Client:TRFTCPClient read m_Client write m_Client ;
  end;


  {�ַ��������շ�����}
  TRFTCPIOStrHandler = class(TRFTCPIOHandler)
  public
    {����:��ʼ����}
    function StartSend():Boolean;override;
    {����:��ʼ����}
    function StartRecv():Boolean;override;
    
    {����:��ȡ��һ���������ݰ�}
    function GetSendPackage(var package:TRFSockPackage):Boolean;override;
    {����:��ȡ��һ���������ݰ�}
    function GetRecvPackage(var package:TRFSockPackage):Boolean;override;

    {����:���հ�����}
    procedure DoRecv(package:TRFSockPackage;var bFinish:Boolean);override;
    {����:�������ݽӿ�}
    procedure DoSend(package:TRFSockPackage;var bFinish:Boolean);override;

  private
    //��ȡ���ݰ��е��ַ�������
    function GetRecvPackStrData(package:TRFSockPackage):string;
  private
    //�����ַ�������
    m_StrSendData:string;
    //�����ַ�������
    m_StrRecvData:string;
  public
    property SendStr :string read m_StrSendData write m_StrSendData;
    property RecvStr :string read m_StrRecvData write m_StrRecvData;
  end;



  {�׽��ַ�װ}
  TRFSock = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //�Ƿ�����
    bActive:Boolean;
  public
    function CreateSock():Integer;
    {�ر��׽���}
    function CloseSock():Boolean;

  private
    //���ͳ�ʱ
    m_nSendTimeOut:Integer;
    //���ճ�ʱ
    m_nRecvTimeOut:Integer;
    //�رճ�ʱ
    m_nCloseTimeOut:Integer;
    //�׽��ֶ���
    m_Sock:TSocket;
  private
    function GetLocalInfo():RSockInfo;
    function GetRemoteInfo():RSockInfo;
    procedure SetSendTimeOut(nTimeOut:Integer);
    procedure SetRecvTimeOut(nTimeOut:Integer);
    procedure SetCloseTimeOut(nTimeOut:Integer);
    procedure SetSock(nSock: TSocket);
  public
    //����������Ϣ
    property LocalInfo:RSockInfo read GetLocalInfo ;
    //Զ��������Ϣ
    property RemoteInfo:RSockInfo read GetRemoteInfo ;
    //���ͳ�ʱ
    property nSendTimeOut:Integer read m_nSendTimeOut write SetSendTimeOut;
    //���ճ�ʱ
    property nRecvTimeOut:Integer read m_nRecvTimeOut write SetRecvTimeOut;
    //�رճ�ʱ
    property nCloseTimeOut:Integer read m_nCloseTimeOut write SetCloseTimeOut;
    //ԭʼ�׽���
    property Sock :TSocket read m_Sock write SetSock;
  end;

  {�׽����б�}
  TRFSockList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRFSock;
    procedure SetItem(Index: Integer; AObject: TRFSock);

  public
    function Add(AObject: TRFSock): Integer;
    property Items[Index: Integer]: TRFSock read GetItem write SetItem; default;
  end;

  {tcp���Ӻ���}
  TRFTCPCon = class
  public
    {ִ������}
    function Connect(nMaxSecond:Integer):Integer;
  private
    //IP
    m_strIP:string;
    //�˿�
    m_nPort:Integer;
  public
    property strIP:string read m_strIP write m_strIP ;
    property nPort:Integer read m_nPort write m_nPort;
  end;

  //socketͨ���߳�ִ�к���
  TRunEvent = function(Sender:TObject) :Boolean of object;


  //ͨ�Żص�
  TSockExceptEvent = procedure(Client:TRFTCPClient;nErrorCode:Integer) of object;
  //���ӱ��ر��¼�
  TSockCloseEvent = procedure(Client:TRFTCPClient) of object;
  
  //socketIO����ģ��
  TRFIOMode = class
  public
    //��ʼ����
    function StartSend(client:TRFTCPClient):Boolean;virtual;abstract;
    //��ʼ����
    function StartRecv(client:TRFTCPClient):Boolean;virtual;abstract;
  protected
    //�Ƿ��̴߳���
    m_bThreadMode:Boolean;
  public
    property bThreadMode:Boolean read m_bThreadMode write m_bThreadMode ;
  end;

  //socketIO����ģ��(����ģʽ)
  TRFIOMode_Block = class(TRFIOMode)
  public
    constructor Create();
  public
    //��ʼ����
    function StartSend(client:TRFTCPClient):Boolean;override;
    //��ʼ����
    function StartRecv(client:TRFTCPClient):Boolean;override;
  end;

  {SocketIO����ģ��(Selectģʽ)}
  TRFIOMode_Select = class(TRFIOMode)
  public
    {����:��ʼ����}
    function StartSend(client:TRFTCPClient):Boolean;override;
    {����:��ʼ����}
    function StartRecv(client:TRFTCPClient):Boolean;override;
  protected
    {����:�߳�ִ�к���}
    function IOFun(Sender:TObject) :Boolean;
  end;

  {�ͻ���socket����}
  TRFTCPClient = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    
    {����:��ʼ����}
    function StartSend():Boolean;
    {����:��ʼ����}
    function StartRecv():Boolean;

    //����Ƿ�ɷ���
    function CanSend(nWaitS:Integer = 0;nWaitMS:Integer= 10):Boolean;
    //����Ƿ�ɽ���
    function CanRecv(nWaitS:Integer = 0;nWaitMS:Integer= 10):Boolean;
    
    {����:��ɷ���}
    procedure FinishSend( bError:Boolean);
    {����:��ɽ���}
    procedure FinishRecv(bError:Boolean);

    {����:��ȡ������Ϣ}
    function GetErr():string;
  private

    {����:�����շ����ݴ�����}
    procedure SetIOHandler(IOHandler:TRFTCPIOHandler);
    {����:����IOģ��}
    procedure SetIOMode(ioMode:TRFIOMode);
  private
    //�׽��ַ�װ
    m_RFSock:TRFSock;
    //���Ӷ���
    m_RFCon:TRFTCPCon;
     //���ӶϿ��¼�
    m_OnCloseEvent:TSockCloseEvent;
    //ͨ���쳣�¼�
    m_OnExceptEvent:TSockExceptEvent;
    //�շ����ݴ�����
    m_IOHandler :TRFTCPIOHandler;
    //IOģ��
    m_IOMode:TRFIOMode;
    //�Ƿ���
    m_bSend:Boolean;
    //�Ƿ����
    m_bRecv:Boolean;
  public
    //�׽���
    property RFSock:TRFSock read m_RFSock write m_RFSock ;
    //���Ӷ���
    property RFCon:TRFTCPCon  read m_RFCon write m_RFCon  ;
    //���ݴ���
    property IOHandler :TRFTCPIOHandler read m_IOHandler write m_IOHandler;
    //IOģ��
    property IOMode:TRFIOMode read m_IOMode write m_IOMode;
    //�ر��¼�
    property OnCloseEvent:TSockCloseEvent read m_OnCloseEvent write m_OnCloseEvent ;
    //�쳣�¼�
    property OnExceptEvent:TSockExceptEvent read m_OnExceptEvent write m_OnExceptEvent;
  end;


  {�ͻ���TCP�׽����б�}
  TRFTCPClientList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRFTCPClient;
    procedure SetItem(Index: Integer; AObject: TRFTCPClient);
  public
    //���Ҷ���
    function Find(nSock:TSocket):TRFTCPClient;
    
    function  Add(AObject: TRFTCPClient) :Integer;
    property Items[Index: Integer]: TRFTCPClient read GetItem write SetItem; default;
  end;


  {Server�˼����߶���}
  TRFTCPListener = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {����:��������}
    function StartListen(strIP:string ;nPort:Integer):Boolean;
    {����:�رռ���}
    function StopListen():Boolean;
    {����:��������}
    function Accept():TSocket;
  public
    //�����׽���
    ListenRFSock:TRFSock;
  private
    //�������г���
    m_ListenQueueCount:Integer;
  public
    property nListenQueue:Integer read m_ListenQueueCount write m_ListenQueueCount ;
  end;



implementation

{ TRFSocketContext }

class function TRFSocketContext.Close: Boolean;
begin
  WSACleanup;
end;

class function TRFSocketContext.Start: Boolean;
var
  WSData: WSAData;
begin
   WSAStartUp($202, WSData);
end;

{ TRFSClient }




function TRFTCPClient.StartRecv: Boolean;
begin
  result := False;
  if Self.m_RFSock.bActive = False then Exit;
  if Self.m_IOHandler = nil then Exit;
  if self.m_IOMode = nil then Exit;
  m_IOHandler.StartRecv();
  Result := m_IOMode.StartRecv(Self);
end;

function TRFTCPClient.StartSend: Boolean;
begin
  result := False;
  if Self.m_RFSock.bActive = False then Exit;
  if Self.m_IOHandler = nil then Exit;
  if self.m_IOMode = nil then Exit;
  m_IOHandler.StartSend();
  result := m_IOMode.StartSend(Self);
end;



{ RRFSock }

function TRFSock.CloseSock: Boolean;
begin
  result := False;
  if Sock = INVALID_SOCKET then
  begin
    Result := True;
    Exit;
  end;
  
  if closesocket(sock) = INVALID_SOCKET then Exit;
  result := True;
end;

constructor TRFSock.Create;
begin

end;

function TRFSock.CreateSock: Integer;
begin
  Sock := socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  result := Sock;
end;

destructor TRFSock.Destroy;
begin
  if self.Sock <> INVALID_SOCKET then
    self.CloseSock();
  inherited;
end;

function TRFSock.GetLocalInfo: RSockInfo;
var
  nLen:Integer;
  sockAddr:TSockAddrIn;
begin
  FillChar(Result,SizeOf(RSockInfo),0);
  nLen := SizeOf(sockAddr);
  if WinSock.getsockname(sock, sockAddr, nLen) = -1 then Exit;
  if sockAddr.sin_family = AF_INET then
  begin
    Result.SockAddr := sockAddr;
    result.strIP := inet_ntoa(sockAddr.sin_addr) ;
    result.nPort := ntohs(sockAddr.sin_port);
  end;
end;

function TRFSock.GetRemoteInfo: RSockInfo;
var
  nLen:Integer;
  sockAddr:TSockAddrIn;
begin
  FillChar(Result,SizeOf(RSockInfo),0);
  nLen := SizeOf(sockAddr);
  if WinSock.getpeername(sock, sockAddr, nLen) = -1 then Exit;
  if sockAddr.sin_family = AF_INET then
  begin
    Result.SockAddr := sockAddr;
    result.strIP := inet_ntoa(sockAddr.sin_addr) ;
    result.nPort := ntohs(sockAddr.sin_port);
  end;
end;

procedure TRFSock.SetCloseTimeOut(nTimeOut: Integer);
var
  m_linger:linger;
begin
  m_linger.l_onoff := 1;
  m_linger.l_linger := nTimeOut;
  setsockopt(Sock,  SOL_SOCKET, SO_LINGER, PChar(@m_linger),sizeof(m_linger));
end;

procedure TRFSock.SetRecvTimeOut(nTimeOut: Integer);
begin
   //����n�볬ʱ
  setsockopt( sock, SOL_SOCKET, SO_RCVTIMEO, PChar(@m_nRecvTimeOut), sizeof(Integer));
end;

procedure TRFSock.SetSendTimeOut(nTimeOut: Integer);
begin
  //����n�볬ʱ
  setsockopt(sock, SOL_SOCKET, SO_SNDTIMEO, PChar(@m_nSendTimeOut), sizeof(Integer));
end;

procedure TRFSock.SetSock(nSock:TSocket);
var
  TimeOut :Integer;
  nLen:Integer;
begin
  Self.m_Sock := nSock;
  m_nSendTimeOut := 5;
  m_nRecvTimeOut := 5;
  m_nCloseTimeOut := 5;
end;

constructor TRFTCPClient.Create;
begin
  m_RFSock:=TRFSock.Create;
  m_RFCon:=TRFTCPCon.Create;
end;

destructor TRFTCPClient.Destroy;
begin
  if RFSock <> nil then
  begin
    RFSock.CloseSock;
    RFSock.Free;
  end;
  m_RFCon.Free;
  inherited;
end;


procedure TRFTCPClient.FinishRecv(bError: Boolean);
var
  nError:Integer;
begin
  if bError and Assigned(Self.m_OnExceptEvent) then
  begin
    if RFSock.Sock <> INVALID_SOCKET then
      m_OnExceptEvent(Self,GetLastError);
  end;
end;

procedure TRFTCPClient.FinishSend(bError: Boolean);
var
  nError:Integer;
begin
  if bError and Assigned(Self.m_OnExceptEvent) then
  begin
    if RFSock.Sock <> INVALID_SOCKET then
      m_OnExceptEvent(Self,GetLastError);
  end;
end;





function TRFTCPClient.GetErr: string;
begin
  Result := IntToStr(GetLastError) + ':';
end;

procedure TRFTCPClient.SetIOHandler(IOHandler: TRFTCPIOHandler);
begin
  Self.m_IOHandler := IOHandler;
  m_IOHandler.Client := Self;
end;

procedure TRFTCPClient.SetIOMode(ioMode: TRFIOMode);
begin

end;

{ TRFTCPListener }

constructor TRFTCPListener.Create();
begin
  ListenRFSock := TRFSock.Create;
end;

destructor TRFTCPListener.Destroy;
begin
  ListenRFSock.Free;
  inherited;
end;

function TRFTCPListener.Accept():TSocket;
var
  i:Integer;
  tempSock:TSocket;
  FDRead :TFDSet;
  timeVal:TTimeVal  ;
  AddrIn:TSockAddrIn;
  nSock:TSocket;
  addrLen:Integer;
  SocketMode:Integer;
begin
  result := INVALID_SOCKET;
  
  timeVal.tv_sec := 0;
  timeVal.tv_usec := 100;
  
  FD_Zero(FDRead);       //��ʼ��FDSet
  //�������׽��ַ��������
  FD_SET(ListenRFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //����FDSet���Ƿ��пɶ�������
  begin
    addrLen := SizeOf(AddrIn);
    nSock := WinSock.accept(ListenRFSock.Sock,@AddrIn,@addrLen);
    SocketMode:= 0;//����
    IoCtlSocket(ListenRFSock.Sock, FIONBIO, SocketMode);
    if nSock = INVALID_SOCKET then Exit;
    result := nSock;
  end;
end;


function TRFTCPListener.StartListen(strIP:string ;nPort:Integer): Boolean;
var
  WSData: WSAData;  
  nReult:Integer;
  SocketMode: Integer;
  SockAddr :TSockAddrIn; 
begin
  result := False;
  //�����׽���
  if ListenRFSock.CreateSock() = INVALID_SOCKET then Exit;
  
  SockAddr.sin_family := AF_INET;
  SockAddr.sin_addr.S_addr:= Inet_addr(PAnsiChar(AnsiString(strIP)));//����ַ�����ʽ��IP��ַת��Ϊ��������ʽ
  SockAddr.sin_port:= Htons(nPort); //Host To Net Short�������ֽ�˳��תΪ�����ֽ�˳��

  //�󶨱���IP��ַ���˿ڣ���֮ǰ�����ú�LocalAddr�Ĳ���  
  nReult := Bind(ListenRFSock.Sock, SockAddr, SizeOf(SockAddr));
  if nReult <>0  then
  begin
    ListenRFSock.CloseSock;
    Exit;
  end;
  
  //����WinSock I/Oģʽ  
  SocketMode:= 1;
  IoCtlSocket(ListenRFSock.Sock, FIONBIO, SocketMode);
  
  //��ʼ���������ͬʱ����5������  
  Listen(ListenRFSock.Sock, Self.nListenQueue);
  result := True;

end;

function TRFTCPListener.StopListen: Boolean;
begin
  Self.Free;
end;

{ TRFSockList }

function TRFSockList.Add(AObject: TRFSock): Integer;
begin
  result := inherited Add(AObject);
end;

function TRFSockList.GetItem(Index: Integer): TRFSock;
begin
  result := TRFSock(inherited GetItem(Index));
end;

procedure TRFSockList.SetItem(Index: Integer; AObject: TRFSock);
begin
  inherited SetItem(Index,AObject);
end;



{ TRFSockStrRecver }



function TRFTCPIOStrHandler.GetRecvPackage(var package: TRFSockPackage): Boolean;
begin
  package := RecvPackage;
end;

function TRFTCPIOStrHandler.GetRecvPackStrData(package:TRFSockPackage): string;
var
  str:string;
begin
  str := StrPas(@package.data[SizeOf(package.RHead)]);
  Result := str;
  //Result := LeftStr(str,Length(str)-SizeOf(package.RTail));
end;

function TRFTCPIOStrHandler.GetSendPackage(var package: TRFSockPackage): Boolean;
var
  nMaxDataSize,nRealDataSize:Integer;
  strCur:string;
  nLeft:Integer;
  charary :array[0..8191] of Char;
begin
  Result := False;
  if nHasSendLen = nTotalSendLen then Exit;
  
  nMaxDataSize := TRFSockPackage.GetMaxDataSize();
  nLeft := nTotalSendLen - nHasSendLen;
  if nLeft >= nMaxDataSize then
    nRealDataSize := nMaxDataSize
  else
    nRealDataSize := nLeft;
  strCur := MidStr(SendStr,nHasSendLen,nRealDataSize);
  self.SendPackage.RHead.nSubPackageIndex := Self.nSendPackageIndex;
  SendPackage.RHead.nSubPackageCount := nSendPackageCount;
  SendPackage.RHead.nTotalDataLen := nTotalSendLen;
  SendPackage.RHead.nPackageSize := SizeOf(SendPackage.RHead) + SizeOf(SendPackage.RTail) +nRealDataSize;
  //����ͷ
  CopyMemory(@SendPackage.data[0],@SendPackage.RHead,SizeOf(SendPackage.RHead));


  //��������
  CopyMemory(@SendPackage.data[SizeOf(SendPackage.RHead)],PChar(strCur),nRealDataSize);


  //����β
  CopyMemory(@SendPackage.data[SizeOf(SendPackage.RHead)+ nRealDataSize],@SendPackage.RTail,SizeOf(SendPackage.RTail));
  //����
  CopyMemory(@SendPackage.RHead,@SendPackage.data[0],SizeOf(SendPackage.RHead));
  CopyMemory(@charary[0],@SendPackage.data[SizeOf(SendPackage.RHead)],nRealDataSize);
  CopyMemory(@SendPackage.RTail,@SendPackage.data[SizeOf(SendPackage.RHead)+ nRealDataSize],SizeOf(SendPackage.RTail));
  package := SendPackage;
  Result := True;
end;

function TRFTCPIOStrHandler.StartRecv: Boolean;
begin
  inherited StartRecv;
  Self.RecvStr := '';
end;

function TRFTCPIOStrHandler.StartSend: Boolean;
var
  nMaxDataSize :Integer;
begin
  inherited StartSend;
  nMaxDataSize := TRFSockPackage.GetMaxDataSize();
  nSendPackageCount := Ceil(Length(self.SendStr)/ nMaxDataSize);
  nTotalSendLen := Length(Self.SendStr);
end;

procedure TRFTCPIOStrHandler.DoRecv(package:TRFSockPackage;var bFinish:Boolean);
begin
  bFinish := False;
  if Self.nTotalRecvLen = 0 then
    Self.nTotalRecvLen := package.RHead.nTotalDataLen;
  nHasRecvLen := nHasRecvLen +  package.GetDataLen;
  self.m_StrRecvData := m_StrRecvData + GetRecvPackStrData(package);
  if Assigned(Self.OnRecvEvent) then
    OnRecvEvent(Self.Client,self.nTotalRecvLen,self.nHasRecvLen);
  if nHasRecvLen = Self.nTotalRecvLen then
  begin
    ClearRecvInfo;
    bFinish := True;
  end;
end;



procedure TRFTCPIOStrHandler.DoSend(package:TRFSockPackage;var bFinish:Boolean);
begin
  bFinish := False;
  nHasSendLen := nHasSendLen +  package.GetDataLen;
  if Assigned(Self.OnSendEvent) then
    OnSendEvent(Self.Client,self.nTotalSendLen,self.nHasSendLen);
  if nHasSendLen = nTotalSendLen then
  begin
    ClearSendInfo;
    bFinish := True;
  end;
  
end;



{ TRFSockPackage }

function TRFSockPackage.GetNeedRecvLen: Integer;
begin
  if self.nHandleLen < SizeOf(RHead) then
  begin
    result := SizeOf(RHead) - nHandleLen;
  end
  else
  begin
    CopyMemory(@RHead,@self.data[0],SizeOf(RHead));
    result:= RHead.nPackageSize - nHandleLen;
  end;
end;

procedure TRFSockPackage.ClearPackage;
begin
  Self.RHead.Reset();
  Self.RTail.Reset();
  nHandleLen := 0;
end;

function TRFSockPackage.GetDataLen: Integer;
begin
  result := RHead.nPackageSize - SizeOf(RHead)-sizeof(RTail);
end;
class function TRFSockPackage.GetMaxDataSize: Integer;
begin
  Result := CS_BUF_LEN - SizeOf(RRFSockPackHead)-sizeof(RRFSockPackTail);
end;

{ TFCTCPCon }

function TRFTCPCon.Connect(nMaxSecond:Integer): Integer;
var
  nSize :Integer;
  dtStart:Integer;
  SocketMode:Integer;
  FDWrite :TFDSET ;
  timeout:TTimeVal;
  addrIn:TSockAddrIn;
  nSock:TSocket;
begin
  result := INVALID_SOCKET;
  nSock:= Socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
  if nSock = INVALID_SOCKET then Exit;

  addrIn.sin_family:= AF_INET;   //IPV4��
  addrIn.sin_addr.S_addr:= Inet_addr(PAnsiChar(AnsiString(strIP)));//����ַ�����ʽ��IP��ַת��Ϊ��������ʽ
  addrIn.sin_port:= Htons(nPort); //Host To Net Short�������ֽ�˳��תΪ�����ֽ�˳��


  nSize := sizeof(addrIn);
  //�������׽���
  SocketMode:= 1;
  IoCtlSocket(nSock,FIONBIO,SocketMode);
  WinSock.connect(nSock,addrIn,nSize);

  timeout.tv_sec :=0;//3��
  timeout.tv_usec :=50;
  FD_ZERO(FDWrite);
  FD_SET(nSock,FDWrite);
  
  dtStart := GetTickCount;
  while True do
  begin
    //FD_WRITE ��һ�������ǣ��ڷ���������ʱ���������ӳɹ������Ի�ȡ������ֵ
    if Select(0, nil, @fdwrite, nil, @timeout) > 0 then
    begin
      SocketMode := 0;
      IoCtlSocket(nSock, FIONBIO, SocketMode);//�޸�Ϊ����
      result := nSock;
      Exit;
    end;
    if (GetTickCount -dtStart) > nMaxSecond* 1000 then
    begin
      closesocket(nSock);
      Exit;
    end; 
  end;
end;



{ TRFTCPClient }

function TRFTCPClient.CanRecv(nWaitS:Integer = 0;nWaitMS:Integer= 10): Boolean;
var
  FDRead :TFDSet;
  timeVal:TTimeVal  ;
begin
  result := False;
  timeVal.tv_sec := nWaitS;
  timeVal.tv_usec := nWaitMS;
  FD_Zero(FDRead);       //��ʼ��FDSet
  //���ͻ����������׽��ַ��������
  FD_SET(RFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //����FDSet���Ƿ��пɶ�������
  begin
    result := True;
  end;
end;

function TRFTCPClient.CanSend(nWaitS:Integer = 0;nWaitMS:Integer= 10): Boolean;
var
  FDWrite :TFDSet;
  timeVal:TTimeVal  ;
begin
  result := False;
  timeVal.tv_sec := nWaitS;
  timeVal.tv_usec := nWaitMS;
  FD_Zero(FDWrite);       //��ʼ��FDSet
  //���ͻ����������׽��ַ��������
  FD_SET(RFSock.Sock,FDWrite);
  if Select(0,nil, @FDWrite, nil, @timeVal) > 0 then  //����FDSet���Ƿ��пɶ�������
  begin
    result := True;
  end;
end;

constructor TRFIOMode_Block.Create;
begin
  self.bThreadMode := False;
end;

function TRFIOMode_Block.StartRecv(client: TRFTCPClient): Boolean;
var
  package:TRFSockPackage;
  nRecv:Integer;
  pBuf:PChar;
  nPackSize:Integer;
  nNeedRecvLen:Integer;
  bFinish:Boolean;
begin
  result := False;
  while client.IOHandler.GetRecvPackage(package) do
  begin
    nRecv := 0;
    while package.GetNeedRecvLen <> 0 do
    begin
      nNeedRecvLen := package.GetNeedRecvLen();
      nRecv := WinSock.recv(client.RFSock.Sock,package.data[package.nHandleLen] ,nNeedRecvLen,0);
      if nRecv = SOCKET_ERROR then
      begin
        box(IntToStr(Windows.GetLastError));
        client.FinishRecv(true);//�쳣
        Exit;
      end;
      package.nHandleLen := package.nHandleLen + nRecv;
    end;
    client.IOHandler.DoRecv(package,bFinish);
    if bFinish then
    begin
      client.FinishRecv(False);
      result := True;
      Exit;
    end;
  end;
end;

function TRFIOMode_Block.StartSend(client: TRFTCPClient): Boolean;
var
  package:TRFSockPackage;
  nSend:Integer;
  pBuf:PChar;
  nPackSize:Integer;
  bFinish:Boolean;
begin
  result := False;
  while client.IOHandler.GetSendPackage(package) do
  begin
    nSend := 0;
    nPackSize :=package.RHead.nPackageSize;
    while package.nHandleLen < nPackSize do
    begin
      nSend := WinSock.send(client.RFSock.Sock,package.data[nSend],nPackSize -nSend,0);
      if nSend = SOCKET_ERROR then
      begin
        client.FinishSend(true);//�쳣
        Exit;
      end;
      package.nHandleLen := package.nHandleLen + nSend;
    end;
    client.IOHandler.DoSend(package,bFinish);
    if bFinish then
    begin
      client.FinishSend(False);
      Result := True;
      Exit;
    end;
  end;
end;

{ TRFIOMode_Select }

function TRFIOMode_Select.IOFun(Sender: TObject): Boolean;
var
  FDRead :TFDSet;
  FDWrite:TFDSet;
  timeVal:TTimeVal  ;
  acceptSock:TSocket;
  i:Integer;
  tempSock:TSocket;
begin
  result := False;
  timeVal.tv_sec := 0;
  timeVal.tv_usec := 500;
  FD_Zero(FDRead);       //��ʼ��FDSet
  //���ͻ����������׽��ַ��������
  //FD_SET(m_RFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //����FDSet���Ƿ��пɶ�������
  begin
    //�����ɶ�����,recv����
    for i := 0 to FDRead.fd_count - 1 do
    begin
      //�����ݵ���
      begin
        //self.m_Thread.Synchronize(self.Recved);
      end;
    end;
  end;
end;

function TRFIOMode_Select.StartRecv(client: TRFTCPClient): Boolean;
begin

end;

function TRFIOMode_Select.StartSend(client: TRFTCPClient): Boolean;
begin

end;

{ TRFTCPIOHandler }

procedure TRFTCPIOHandler.ClearRecvInfo;
begin
  //�ְ�����
  nRecvPackageCount:=0;
  //��ǰ������
  nRecvPackageIndex:=0;
  //���������ݳ���
  nTotalRecvLen:=0;
  //�ѽ������ݳ���
  nHasRecvLen:=0;
  RecvPackage.ClearPackage;
end;

procedure TRFTCPIOHandler.ClearSendInfo;
begin
  //�ְ�����
  nSendPackageCount:=0;
  //��ǰ������
  nSendPackageIndex:=0;
  //���������ݳ���
  nTotalSendLen:=0;
  //�ѷ������ݳ���
  nHasSendLen:=0;
  self.SendPackage.ClearPackage;
  
end;


constructor TRFTCPIOHandler.Create;
begin
  SendPackage:=TRFSockPackage.Create ;
    //�������ݰ�
  RecvPackage:=TRFSockPackage.Create;
end;

destructor TRFTCPIOHandler.Destroy;
begin
  SendPackage.Free;
    //�������ݰ�
  RecvPackage.Free;
  inherited;
end;

function TRFTCPIOHandler.StartRecv: Boolean;
begin
  ClearRecvInfo();
end;

function TRFTCPIOHandler.StartSend: Boolean;
begin
  ClearSendInfo();

end;

{ TRFTCPClientList }

function TRFTCPClientList.Add(AObject: TRFTCPClient): Integer;
begin
  result := inherited Add(AObject);
end;

function TRFTCPClientList.Find(nSock: TSocket): TRFTCPClient;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if self.Items[i].RFSock.Sock = nSock then
    begin
      Result := Items[i];
      Exit;
    end;
  end;
end;

function TRFTCPClientList.GetItem(Index: Integer): TRFTCPClient;
begin
  Result := TRFTCPClient(inherited GetItem(Index));
end;

procedure TRFTCPClientList.SetItem(Index: Integer; AObject: TRFTCPClient);
begin
  inherited SetItem(Index,AObject);
end;

{ RRFSockPackHead }

procedure RRFSockPackHead.Reset;
begin
  ZeroMemory(@self,SizeOf(Self));
end;

{ RRFSockPackTail }

procedure RRFSockPackTail.Reset;
begin
  ZeroMemory(@self,SizeOf(Self));
end;


end.
