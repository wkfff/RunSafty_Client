unit uRFSocket;

interface
uses
  WinSock,Windows,SysUtils,Classes,Contnrs,StrUtils,SyncObjs,Math,uTFSystem;
const
  CS_BUF_LEN = 8192;
type

  {socket上下文环境}
  TRFSocketContext = class
  public
    {开启socket运行环境}
    class function Start():Boolean;
    {关闭socket运行环境}
    class function Close():Boolean;
  end;

  {端口地址信息配置}
  RSockInfo = record
  public
    //远程ip地址
    strIP:string;
    //端口号
    nPort:Integer;
    //socket地址结构体
    SockAddr :TSockAddrIn;
  end;

  //数据包包头结构体
  RRFSockPackHead = record
  public
    //包开始标示
    nStartFlag:Integer;
    //包ID
    nPackageID:Integer;
    //命令ID
    nOrderID:Integer;
    //分包总数
    nSubPackageCount:Integer;
    //所有分包数据总长度
    nTotalDataLen:Integer;
    //当前分包索引
    nSubPackageIndex:Integer;
    //当前包的总大小
    nPackageSize:Integer;
  public
    {功能:重置信息}
    procedure Reset();
  end;

  {数据包包头结构体}
  RRFSockPackTail = record
  public
    //包结束标示
    nEndFlag:Integer;
  public
    {功能:重置}
    procedure Reset();
  end;


  {socket通信数据包 一个包限定大小为8K}
  TRFSockPackage = class
  public
    //数据包缓冲区
    data:array[0..8191] of char;
    //包头结构体
    RHead:RRFSockPackHead;
    //包尾结构体
    RTail:RRFSockPackTail;
    //已接收包长度
    nHandleLen:Integer;
  public
    {功能:重置包信息}
    procedure ClearPackage();
  public
    class function GetMaxDataSize():Integer;
  private
    {功能:获取已接收数据域长度}
    function GetDataLen():Integer;
    {功能:获取待接收数据长度}
    function GetNeedRecvLen():Integer;
  public
    //数据长度
    property nDataLen:Integer read GetDataLen;
    //待接收数据长度
    property nNeedRecvLen:Integer read GetNeedRecvLen;
  end;

  {预声明TCP客户端对象}
  TRFTCPClient = class;
  //收发回调数据
  TRFTCPIOHandleFun = procedure (Client:TRFTCPClient;nTotalSize:Integer;nHasDeal:Integer) of object;

  {数据接收基类,数据收发是分包执行的}
  TRFTCPIOHandler = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {功能:开始发送}
    function StartSend():Boolean;virtual;
    {功能:开始接受}
    function StartRecv():Boolean;virtual;
    
    {功能:接收数据接口}
    procedure DoRecv(package:TRFSockPackage;var bFinish:Boolean);virtual;abstract;
    {功能:发送数据接口}
    procedure DoSend(package:TRFSockPackage;var bFinish:Boolean);virtual;abstract;
    {功能:获取下一个发送数据包}
    function GetSendPackage(var package:TRFSockPackage):Boolean;virtual;abstract;
    {功能:获取下一个接收数据包}
    function GetRecvPackage(var package:TRFSockPackage):Boolean;virtual;abstract;
    
  protected
    {功能:重置发送信息}
    procedure ClearSendInfo();
    {功能:重置接收信}
    procedure ClearRecvInfo();

  protected
    //发送分包总数
    nSendPackageCount:Integer;
    //发送当前包索引
    nSendPackageIndex:Integer;
    //发送分包总数
    nRecvPackageCount:Integer;
    //发送当前包索引
    nRecvPackageIndex:Integer;

    //待发送数据长度
    nToTalSendLen:Integer;
    //已发送数据长度
    nHasSendLen:Integer;
    //待接收数据长度
    nToTalRecvLen:Integer;
    //已接收数据长度
    nHasRecvLen:Integer;
    //发送数据包
    SendPackage:TRFSockPackage ;
    //接受数据包
    RecvPackage:TRFSockPackage;
    //处理器使用者
    m_Client:TRFTCPClient;
    //发送回调事件
    m_OnSendEvent:TRFTCPIOHandleFun;
    //接收回调事件
    m_OnRecvEvent:TRFTCPIOHandleFun;
  public
    property OnSendEvent:TRFTCPIOHandleFun read m_OnRecvEvent write m_OnRecvEvent ;
    property OnRecvEvent:TRFTCPIOHandleFun read m_OnRecvEvent write m_OnRecvEvent ;
    property Client:TRFTCPClient read m_Client write m_Client ;
  end;


  {字符串数据收发处理}
  TRFTCPIOStrHandler = class(TRFTCPIOHandler)
  public
    {功能:开始发送}
    function StartSend():Boolean;override;
    {功能:开始接受}
    function StartRecv():Boolean;override;
    
    {功能:获取下一个发送数据包}
    function GetSendPackage(var package:TRFSockPackage):Boolean;override;
    {功能:获取下一个接收数据包}
    function GetRecvPackage(var package:TRFSockPackage):Boolean;override;

    {功能:接收包数据}
    procedure DoRecv(package:TRFSockPackage;var bFinish:Boolean);override;
    {功能:发送数据接口}
    procedure DoSend(package:TRFSockPackage;var bFinish:Boolean);override;

  private
    //获取数据包中的字符串数据
    function GetRecvPackStrData(package:TRFSockPackage):string;
  private
    //发送字符串数据
    m_StrSendData:string;
    //接受字符串数据
    m_StrRecvData:string;
  public
    property SendStr :string read m_StrSendData write m_StrSendData;
    property RecvStr :string read m_StrRecvData write m_StrRecvData;
  end;



  {套接字封装}
  TRFSock = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //是否连接
    bActive:Boolean;
  public
    function CreateSock():Integer;
    {关闭套接字}
    function CloseSock():Boolean;

  private
    //发送超时
    m_nSendTimeOut:Integer;
    //接收超时
    m_nRecvTimeOut:Integer;
    //关闭超时
    m_nCloseTimeOut:Integer;
    //套接字对象
    m_Sock:TSocket;
  private
    function GetLocalInfo():RSockInfo;
    function GetRemoteInfo():RSockInfo;
    procedure SetSendTimeOut(nTimeOut:Integer);
    procedure SetRecvTimeOut(nTimeOut:Integer);
    procedure SetCloseTimeOut(nTimeOut:Integer);
    procedure SetSock(nSock: TSocket);
  public
    //本地连接信息
    property LocalInfo:RSockInfo read GetLocalInfo ;
    //远程连接信息
    property RemoteInfo:RSockInfo read GetRemoteInfo ;
    //发送超时
    property nSendTimeOut:Integer read m_nSendTimeOut write SetSendTimeOut;
    //接收超时
    property nRecvTimeOut:Integer read m_nRecvTimeOut write SetRecvTimeOut;
    //关闭超时
    property nCloseTimeOut:Integer read m_nCloseTimeOut write SetCloseTimeOut;
    //原始套接字
    property Sock :TSocket read m_Sock write SetSock;
  end;

  {套接字列表}
  TRFSockList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRFSock;
    procedure SetItem(Index: Integer; AObject: TRFSock);

  public
    function Add(AObject: TRFSock): Integer;
    property Items[Index: Integer]: TRFSock read GetItem write SetItem; default;
  end;

  {tcp连接函数}
  TRFTCPCon = class
  public
    {执行连接}
    function Connect(nMaxSecond:Integer):Integer;
  private
    //IP
    m_strIP:string;
    //端口
    m_nPort:Integer;
  public
    property strIP:string read m_strIP write m_strIP ;
    property nPort:Integer read m_nPort write m_nPort;
  end;

  //socket通信线程执行函数
  TRunEvent = function(Sender:TObject) :Boolean of object;


  //通信回调
  TSockExceptEvent = procedure(Client:TRFTCPClient;nErrorCode:Integer) of object;
  //连接被关闭事件
  TSockCloseEvent = procedure(Client:TRFTCPClient) of object;
  
  //socketIO处理模型
  TRFIOMode = class
  public
    //开始发送
    function StartSend(client:TRFTCPClient):Boolean;virtual;abstract;
    //开始接收
    function StartRecv(client:TRFTCPClient):Boolean;virtual;abstract;
  protected
    //是否线程处理
    m_bThreadMode:Boolean;
  public
    property bThreadMode:Boolean read m_bThreadMode write m_bThreadMode ;
  end;

  //socketIO处理模型(阻塞模式)
  TRFIOMode_Block = class(TRFIOMode)
  public
    constructor Create();
  public
    //开始发送
    function StartSend(client:TRFTCPClient):Boolean;override;
    //开始接收
    function StartRecv(client:TRFTCPClient):Boolean;override;
  end;

  {SocketIO处理模型(Select模式)}
  TRFIOMode_Select = class(TRFIOMode)
  public
    {功能:开始发送}
    function StartSend(client:TRFTCPClient):Boolean;override;
    {功能:开始接收}
    function StartRecv(client:TRFTCPClient):Boolean;override;
  protected
    {功能:线程执行函数}
    function IOFun(Sender:TObject) :Boolean;
  end;

  {客户端socket对象}
  TRFTCPClient = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    
    {功能:开始发送}
    function StartSend():Boolean;
    {功能:开始接受}
    function StartRecv():Boolean;

    //检测是否可发送
    function CanSend(nWaitS:Integer = 0;nWaitMS:Integer= 10):Boolean;
    //检测是否可接收
    function CanRecv(nWaitS:Integer = 0;nWaitMS:Integer= 10):Boolean;
    
    {功能:完成发送}
    procedure FinishSend( bError:Boolean);
    {功能:完成接收}
    procedure FinishRecv(bError:Boolean);

    {功能:获取错误信息}
    function GetErr():string;
  private

    {功能:设置收发数据处理器}
    procedure SetIOHandler(IOHandler:TRFTCPIOHandler);
    {功能:设置IO模型}
    procedure SetIOMode(ioMode:TRFIOMode);
  private
    //套接字封装
    m_RFSock:TRFSock;
    //连接对象
    m_RFCon:TRFTCPCon;
     //连接断开事件
    m_OnCloseEvent:TSockCloseEvent;
    //通信异常事件
    m_OnExceptEvent:TSockExceptEvent;
    //收发数据处理器
    m_IOHandler :TRFTCPIOHandler;
    //IO模型
    m_IOMode:TRFIOMode;
    //是否发送
    m_bSend:Boolean;
    //是否接收
    m_bRecv:Boolean;
  public
    //套接字
    property RFSock:TRFSock read m_RFSock write m_RFSock ;
    //连接对象
    property RFCon:TRFTCPCon  read m_RFCon write m_RFCon  ;
    //数据处理
    property IOHandler :TRFTCPIOHandler read m_IOHandler write m_IOHandler;
    //IO模型
    property IOMode:TRFIOMode read m_IOMode write m_IOMode;
    //关闭事件
    property OnCloseEvent:TSockCloseEvent read m_OnCloseEvent write m_OnCloseEvent ;
    //异常事件
    property OnExceptEvent:TSockExceptEvent read m_OnExceptEvent write m_OnExceptEvent;
  end;


  {客户端TCP套接字列表}
  TRFTCPClientList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRFTCPClient;
    procedure SetItem(Index: Integer; AObject: TRFTCPClient);
  public
    //查找对象
    function Find(nSock:TSocket):TRFTCPClient;
    
    function  Add(AObject: TRFTCPClient) :Integer;
    property Items[Index: Integer]: TRFTCPClient read GetItem write SetItem; default;
  end;


  {Server端监听者对象}
  TRFTCPListener = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {功能:开启监听}
    function StartListen(strIP:string ;nPort:Integer):Boolean;
    {功能:关闭监听}
    function StopListen():Boolean;
    {功能:接收连接}
    function Accept():TSocket;
  public
    //监听套接字
    ListenRFSock:TRFSock;
  private
    //监听队列长度
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
   //接收n秒超时
  setsockopt( sock, SOL_SOCKET, SO_RCVTIMEO, PChar(@m_nRecvTimeOut), sizeof(Integer));
end;

procedure TRFSock.SetSendTimeOut(nTimeOut: Integer);
begin
  //发送n秒超时
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
  
  FD_Zero(FDRead);       //初始化FDSet
  //将监听套接字放入读集合
  FD_SET(ListenRFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //测试FDSet中是否有可读的连接
  begin
    addrLen := SizeOf(AddrIn);
    nSock := WinSock.accept(ListenRFSock.Sock,@AddrIn,@addrLen);
    SocketMode:= 0;//阻塞
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
  //创建套接字
  if ListenRFSock.CreateSock() = INVALID_SOCKET then Exit;
  
  SockAddr.sin_family := AF_INET;
  SockAddr.sin_addr.S_addr:= Inet_addr(PAnsiChar(AnsiString(strIP)));//点分字符串格式的IP地址转换为互联网格式
  SockAddr.sin_port:= Htons(nPort); //Host To Net Short，主机字节顺序转为网络字节顺序

  //绑定本机IP地址、端口，绑定之前先设置好LocalAddr的参数  
  nReult := Bind(ListenRFSock.Sock, SockAddr, SizeOf(SockAddr));
  if nReult <>0  then
  begin
    ListenRFSock.CloseSock;
    Exit;
  end;
  
  //设置WinSock I/O模式  
  SocketMode:= 1;
  IoCtlSocket(ListenRFSock.Sock, FIONBIO, SocketMode);
  
  //开始监听，最多同时监听5个连接  
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
  //拷贝头
  CopyMemory(@SendPackage.data[0],@SendPackage.RHead,SizeOf(SendPackage.RHead));


  //拷贝数据
  CopyMemory(@SendPackage.data[SizeOf(SendPackage.RHead)],PChar(strCur),nRealDataSize);


  //拷贝尾
  CopyMemory(@SendPackage.data[SizeOf(SendPackage.RHead)+ nRealDataSize],@SendPackage.RTail,SizeOf(SendPackage.RTail));
  //测试
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

  addrIn.sin_family:= AF_INET;   //IPV4族
  addrIn.sin_addr.S_addr:= Inet_addr(PAnsiChar(AnsiString(strIP)));//点分字符串格式的IP地址转换为互联网格式
  addrIn.sin_port:= Htons(nPort); //Host To Net Short，主机字节顺序转为网络字节顺序


  nSize := sizeof(addrIn);
  //非阻塞套接字
  SocketMode:= 1;
  IoCtlSocket(nSock,FIONBIO,SocketMode);
  WinSock.connect(nSock,addrIn,nSize);

  timeout.tv_sec :=0;//3秒
  timeout.tv_usec :=50;
  FD_ZERO(FDWrite);
  FD_SET(nSock,FDWrite);
  
  dtStart := GetTickCount;
  while True do
  begin
    //FD_WRITE 的一个作用是，在非阻塞条件时，进行连接成功，可以获取到集合值
    if Select(0, nil, @fdwrite, nil, @timeout) > 0 then
    begin
      SocketMode := 0;
      IoCtlSocket(nSock, FIONBIO, SocketMode);//修改为阻塞
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
  FD_Zero(FDRead);       //初始化FDSet
  //将客户端已连接套接字放入读集合
  FD_SET(RFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //测试FDSet中是否有可读的连接
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
  FD_Zero(FDWrite);       //初始化FDSet
  //将客户端已连接套接字放入读集合
  FD_SET(RFSock.Sock,FDWrite);
  if Select(0,nil, @FDWrite, nil, @timeVal) > 0 then  //测试FDSet中是否有可读的连接
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
        client.FinishRecv(true);//异常
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
        client.FinishSend(true);//异常
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
  FD_Zero(FDRead);       //初始化FDSet
  //将客户端已连接套接字放入读集合
  //FD_SET(m_RFSock.Sock,FDRead);
  if Select(0, @FDRead, nil, nil, @timeVal) > 0 then  //测试FDSet中是否有可读的连接
  begin
    //遍历可读集合,recv数据
    for i := 0 to FDRead.fd_count - 1 do
    begin
      //有数据到达
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
  //分包总数
  nRecvPackageCount:=0;
  //当前包索引
  nRecvPackageIndex:=0;
  //待接收数据长度
  nTotalRecvLen:=0;
  //已接收数据长度
  nHasRecvLen:=0;
  RecvPackage.ClearPackage;
end;

procedure TRFTCPIOHandler.ClearSendInfo;
begin
  //分包总数
  nSendPackageCount:=0;
  //当前包索引
  nSendPackageIndex:=0;
  //待发送数据长度
  nTotalSendLen:=0;
  //已发送数据长度
  nHasSendLen:=0;
  self.SendPackage.ClearPackage;
  
end;


constructor TRFTCPIOHandler.Create;
begin
  SendPackage:=TRFSockPackage.Create ;
    //接受数据包
  RecvPackage:=TRFSockPackage.Create;
end;

destructor TRFTCPIOHandler.Destroy;
begin
  SendPackage.Free;
    //接受数据包
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
