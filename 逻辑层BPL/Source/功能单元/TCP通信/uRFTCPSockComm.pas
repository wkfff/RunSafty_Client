unit uRFTCPSockComm;

interface
uses
  uRFSocket,WinSock,Classes,Windows,SysUtils,Messages;
const
  WM_COMMERROR = WM_USER + 1001;
type

  {接收结果}
  TCommResult = (TCR_SUCESS{收发成功},TCR_TIMEOUT{收发超时},TCR_CANCEL{取消收发},
    TCR_CONERROR{连接出错} ,TCR_RECVERROR{接收出错} ,TRC_SENDERROR{发送出错} );



  //////////////////////////////////////////////////////////////////////////////
  ///类名 :TTCPStrCommBlock
  ///描述:TCP方式字符串数据通信类
  //////////////////////////////////////////////////////////////////////////////
  TTCPStrCommBlock = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    {功能:连接设备}
    function Connect(strIP:string;nPort:Integer):Boolean;
    {功能:是否有数据到来}
    function WaitRecvStr(var bCancelWait:Boolean;out strRecv:string;nWaitSecond:Integer = 0):TCommResult;
    {功能:发送并接收字符串}
    function SendRecvStr(var bCancelWait:Boolean;strSend:string ;out strRecv:string;nWaitSecond:Integer = 0):TCommResult;
  private
     //tcp客户端
    m_TCPClient:TRFTCPClient;
    //收发处理器
    m_StrHandler:TRFTCPIOStrHandler;
    //IO模型
    m_IOMode_Block:TRFIOMode_Block;
  public
    property TCPClient:TRFTCPClient read m_TCPClient write m_TCPClient;
  end;

  //通信异常回调
  TOnCommErrorEvent = procedure (TCPCommObj: TTCPStrCommBlock;nErrCode:Integer);

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTCPCommThread
  /// 描述:TCP通信线程基类
  //////////////////////////////////////////////////////////////////////////////
  
  TTCPCommThread = class(TThread)
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy();override;
  public
    {功能:退出}
    procedure Terminate(); virtual;
  protected
    {功能:处理用户消息}
    function DealUserMsg(var Msg:TMessage):Boolean; virtual;
    {功能:发送用户消息}
    function PostMsg(msg:Cardinal;wparam:Integer;lparam:Integer):Boolean;
    {功能:发送通信错误消息}
    function PostCommErrMsg():Boolean;
  private
    {消息处理函数}
    procedure WndMethod(var Msg: TMessage);
  protected
    //是否取消通信
    bCancelComm:Boolean;
  private
    //消息句柄
    m_MsgWnd:THandle;
     //新建立的通信对象
    m_TCPComm:TTCPStrCommBlock;
    //通信错误
    m_OnCommErrorEvent:TOnCommErrorEvent;
  public
    property TCPComm:TTCPStrCommBlock read m_TCPComm write m_TCPComm;
    //通信错误
    property OnCommError:TOnCommErrorEvent read m_OnCommErrorEvent write m_OnCommErrorEvent;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTCPListenThread
  /// 描述:监听服务器
  //////////////////////////////////////////////////////////////////////////////
  TTCPListenThread = class(TTCPCommThread)
  public
    constructor Create(CreateSuspended: Boolean);
    destructor Destroy();override;
  public
    {功能:开启监听}
    function StartListen(strIP:string;nPort:Integer;nListenQue:Integer):Boolean;
    {功能:停止监听}
    procedure StopListen();
  protected
    procedure Execute; override;
    {功能:建立连接并验证}
    procedure DoAccept(nSock:TSocket);
    {功能:处理用户消息}
    function DealUserMsg(var Msg:TMessage):Boolean;override;
  private
    //监听对象
    m_Listener:TRFTCPListener;
    //连接事件
    m_OnAccpetEvent:TThreadMethod;
    //新连接请求数据
    m_StrRequest:string;
  public
    property OnAccpetEvent:TThreadMethod read m_OnAccpetEvent write m_OnAccpetEvent;

    property StrRequest:string read m_StrRequest write m_StrRequest ;
  end;

implementation

{ TTCPStrCommBlock }

function TTCPStrCommBlock.Connect(strIP: string; nPort: Integer): Boolean;
var
  nSock:Integer;
begin
  result := False;
  if m_TCPClient.RFSock.bActive then
  begin
    result := True;
    Exit;
  end;
  Self.m_TCPClient.RFCon.strIP := strIP;
  Self.m_TCPClient.RFCon.nPort := nPort;
  nSock := self.m_TCPClient.RFCon.Connect(5);
  if nSock <> INVALID_SOCKET then
  begin
    m_TCPClient.RFSock.Sock := nSock;
    m_TCPClient.RFSock.bActive := True;
    Result := True;
  end
end;

constructor TTCPStrCommBlock.Create;
begin
  m_TCPClient:=TRFTCPClient.Create;
  m_StrHandler:=TRFTCPIOStrHandler.Create;
  m_TCPClient.IOHandler := m_StrHandler;
  m_IOMode_Block:=TRFIOMode_Block.Create;
  m_TCPClient.IOMode := m_IOMode_Block;
end;

destructor TTCPStrCommBlock.Destroy;
begin
  m_TCPClient.Free;
  m_IOMode_Block.Free;
  m_StrHandler.Free;
  inherited;
end;

function TTCPStrCommBlock.SendRecvStr(var bCancelWait:Boolean;strSend: string;
  out strRecv: string;nWaitSecond:Integer = 0): TCommResult;
var
  nStart:Integer;
  bCanRecv:Boolean;
begin
  m_StrHandler.SendStr := strSend;
  if m_TCPClient.StartSend = False then
  begin
    result := TRC_SENDERROR;
    Exit;
  end;

  nStart:=GetTickCount;
  while True do
  begin
    bCanRecv := TCPClient.CanRecv();
    if bCanRecv = True then Break;
    if bCancelWait = True then
    begin
      result := TCR_CANCEL;
      Break;
    end;
    if bCanRecv = False then
    begin
      if nWaitSecond = 0 then
        Continue;
      if (GetTickCount - nStart) >= nWaitSecond * 1000 then
      begin
        Result := TCR_TIMEOUT;
        Exit;
      end;
    end;
  end;
  if TCPClient.StartRecv = False then
  begin
    Result := TCR_RECVERROR;
    Exit;
  end;
  strRecv := m_StrHandler.RecvStr;

  Result := TCR_SUCESS;
end;

function TTCPStrCommBlock.WaitRecvStr(var bCancelWait:Boolean;out strRecv: string;nWaitSecond:Integer = 0): TCommResult;
var
  bCanRecv:Boolean;
  nStart:Integer;
begin
  nStart := GetTickCount;
  while True do
  begin
    bCanRecv := TCPClient.CanRecv();
    if bCanRecv = True then
    begin
      if TCPClient.StartRecv = False then
      begin
        result := TCR_RECVERROR;
        Exit;
      end;
      strRecv := m_StrHandler.RecvStr;
      result := TCR_SUCESS;
      Exit;
    end;
    if bCancelWait = True then
    begin
      result := TCR_CANCEL;
      Exit;
    end;
    if nWaitSecond <> 0 then
    begin
      if GetTickCount - nStart > nWaitSecond * 1000 then
      begin
        result := TCR_TIMEOUT;
        Exit;
      end;
    end;
  end;
end;


{ TListenThread }

constructor TTCPListenThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  m_Listener := TRFTCPListener.Create;
end;

function TTCPListenThread.DealUserMsg(var Msg: TMessage): Boolean;
begin
  result := False;
end;

destructor TTCPListenThread.Destroy;
begin
  m_Listener.Free;

  inherited;
end;

procedure TTCPListenThread.DoAccept(nSock: TSocket);
var
  strRecv:string;
begin
  m_TCPComm := TTCPStrCommBlock.Create;
  m_TCPComm.TCPClient.RFSock.Sock := nSock;

  if m_TCPComm.WaitRecvStr(Self.bCancelComm ,strRecv,2) <> TCR_SUCESS then
  begin
    FreeAndNil(m_TCPComm);
    Exit;
  end;
  self.m_StrRequest := strRecv;
  Synchronize(self,m_OnAccpetEvent);
end;

procedure TTCPListenThread.Execute;
var
  nSock:Integer;
begin
  inherited;
  while not self.Terminated do
  begin
    nSock := m_Listener.Accept();
    if nSock <> INVALID_SOCKET then
    begin
      DoAccept(nSock);
    end;
  end;
end;

function TTCPListenThread.StartListen(strIP:string;nPort:Integer;nListenQue:Integer): Boolean;
begin
  m_Listener.nListenQueue := nListenQue;
  result := m_Listener.StartListen(strIP,nPort);
end;

procedure TTCPListenThread.StopListen;
begin
  Self.DoTerminate;
  Self.WaitFor;
  m_Listener.StopListen;
end;

{ TTCPCommThread }

constructor TTCPCommThread.Create(CreateSuspended: Boolean);
begin
  inherited Create(CreateSuspended);
  m_MsgWnd := AllocateHWnd(WndMethod);
  bCancelComm := False;
end;

function TTCPCommThread.DealUserMsg(var Msg: TMessage): Boolean;
begin
  result := False;
  case Msg.Msg of
  WM_COMMERROR :
  begin
    if Assigned(self.m_OnCommErrorEvent) then
    begin
      m_OnCommErrorEvent(Self.m_TCPComm,Msg.WParam);
      Result := True;
    end;
  end;
  end;
end;

destructor TTCPCommThread.Destroy;
begin
  DeallocateHWnd(m_MsgWnd);
  if m_TCPComm <> nil then
    FreeAndNil(m_TCPComm);
end;

function TTCPCommThread.PostCommErrMsg: Boolean;
begin
  PostMsg(WM_COMMERROR,GetLastError,0);
end;

function TTCPCommThread.PostMsg(msg:Cardinal;wparam:Integer;lparam:Integer): Boolean;
begin
  Result := PostMessage(self.m_MsgWnd,msg,wparam,lparam);
end;

procedure TTCPCommThread.Terminate;
begin
  Self.bCancelComm := True;
  inherited Terminate;
end;

procedure TTCPCommThread.WndMethod(var Msg: TMessage);
begin
  if Self.DealUserMsg(msg) = True then Exit;
  Msg.Result := DefWindowProc(self.m_MsgWnd, Msg.Msg, Msg.wParam, Msg.lParam);
end;

end.
