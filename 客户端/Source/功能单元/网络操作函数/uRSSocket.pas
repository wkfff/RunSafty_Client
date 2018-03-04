unit uRSSocket;

interface

uses 

SysUtils, Windows, dialogs, winsock, Classes, ComObj, WinInet, Variants;

//错误信息常量
const

  C_Err_GetLocalIp = '获取本地ip失败'; 

  C_Err_GetNameByIpAddr = '获取主机名失败'; 

  C_Err_GetSQLServerList = '获取SQLServer服务器失败'; 

  C_Err_GetUserResource = '获取共享资失败'; 

  C_Err_GetGroupList = '获取所有工作组失败'; 

  C_Err_GetGroupUsers = '获取工作组中所有计算机失败'; 

  C_Err_GetNetList = '获取所有网络类型失败'; 

  C_Err_CheckNet = '网络不通';

  C_Err_CheckAttachNet = '未登入网络';

  C_Err_InternetConnected ='没有上网';

  C_Txt_CheckNetSuccess = '网络畅通';

  C_Txt_CheckAttachNetSuccess = '已登入网络';

  C_Txt_InternetConnected ='上网了';




//检测机器是否登入网络 

function IsLogonNet: Boolean; 




//得到本机的局域网Ip地址 

function GetLocalIP(var LocalIp:string): Boolean; 




//通过Ip返回机器名 

function GetNameByIPAddr(IPAddr: string; var MacName: string): Boolean ; 




//获取网络中SQLServer列表 

function GetSQLServerList(var List: Tstringlist): Boolean; 







//获取网络中的工作组 

function GetGroupList(var List: TStringList): Boolean; 







//获取网络中的资源 

function GetUserResource(IpAddr: string; var List: TStringList): Boolean; 










//判断Ip协议有没有安装 这个函数有问题 

function IsIPInstalled : boolean; 


/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////

/////////////////////////////////////////////////

////////////// 代码实现部门////////////

implementation




{================================================================= 

功 能: 检测机器是否登入网络 

参 数: 无 

返回值: 成功: True 失败: False 

备 注: 

版 本: 

1.0 2002/10/03 09:55:00 

=================================================================} 

function IsLogonNet: Boolean; 

begin 

  Result := False;

  if GetSystemMetrics(SM_NETWORK) <> 0 then

  Result := True;

end; 







{================================================================= 

功 能: 返回本机的局域网Ip地址 

参 数: 无 

返回值: 成功: True, 并填充LocalIp 失败: False 

备 注: 

版 本: 

1.0 2002/10/02 21:05:00 

=================================================================} 

function GetLocalIP(var LocalIp: string): Boolean; 

var 

  HostEnt: PHostEnt;

  IP: String;

  Addr: PChar;

  Buffer: array [0..63] of Char;

  WSData: TWSADATA;

begin

  Result := False;

  try

    WSAStartUp(2, WSData);

    GetHostName(Buffer, SizeOf(Buffer));

    //Buffer:='ZhiDa16';

    HostEnt := GetHostByName(Buffer);

    if HostEnt = nil then exit;

    Addr := HostEnt^.h_addr_list^;

    IP := Format( '%d.%d.%d.%d', [ Byte(Addr[0]), Byte(Addr[1]),

    Byte(Addr[2]), Byte(addr[3]) ]

    );

    LocalIp := Ip;

    Result := True;

  finally

    WSACleanup;

  end;

end; 




{================================================================= 

功 能: 通过Ip返回机器名 

参 数: 

IpAddr: 想要得到名字的Ip

返回值: 成功: 机器名 失败: ''

备 注:

inet_addr function converts a string containing an Internet 

Protocol dotted address into an in_addr. 

版 本: 

1.0 2002/10/02 22:09:00 

=================================================================} 

function GetNameByIPAddr(IPAddr : String;var MacName:String): Boolean; 

var

  SockAddrIn: TSockAddrIn;

  HostEnt: PHostEnt;

  WSAData: TWSAData;

begin 

  Result := False;

  if IpAddr = '' then exit;

  try

    WSAStartup(2, WSAData);

    SockAddrIn.sin_addr.s_addr := inet_addr(PChar(IPAddr));

    HostEnt := gethostbyaddr(@SockAddrIn.sin_addr.S_addr, 4, AF_INET);

    if HostEnt <> nil then

    MacName := StrPas(Hostent^.h_name);

    Result := True;

  finally

    WSACleanup;

  end;

end;




{================================================================= 

功 能: 返回网络中SQLServer列表 

参 数: 

List: 需要填充的List 

返回值: 成功: True,并填充List 失败 False 

备 注: 

版 本: 

1.0 2002/10/02 22:44:00 

=================================================================} 

function GetSQLServerList(var List: Tstringlist): boolean; 

var 

  i: integer;

  //sRetValue: String;

  SQLServer: Variant;

  ServerList: Variant;

begin

  //Result := False;

  List.Clear;

  try

    SQLServer := CreateOleObject('SQLDMO.Application');

    ServerList := SQLServer.ListAvailableSQLServers;

    for i := 1 to Serverlist.Count do

    list.Add (Serverlist.item(i));

    Result := True;

  Finally

    SQLServer := NULL;

    ServerList := NULL;

  end;

end;




{================================================================= 

功 能: 判断IP协议有没有安装 

参 数: 无 

返回值: 成功: True 失败: False; 

备 注: 该函数还有问题 

版 本: 

1.0 2002/10/02 21:05:00 

=================================================================} 

function IsIPInstalled : boolean; 

var 

  WSData: TWSAData;

  ProtoEnt: PProtoEnt;

begin 

  Result := True;

  try

    if WSAStartup(2,WSData) = 0 then

    begin

      ProtoEnt := GetProtoByName('IP');

      if ProtoEnt = nil then

      Result := False

    end;

  finally

    WSACleanup;

  end;

end; 







{================================================================= 

功 能: 返回网络中的共享资源 

参 数: 

IpAddr: 机器Ip 

List: 需要填充的List 

返回值: 成功: True,并填充List 失败: False; 

备 注: 

WNetOpenEnum function starts an enumeration of network 

resources or existing connections. 

WNetEnumResource function continues a network-resource 

enumeration started by the WNetOpenEnum function. 

版 本: 

1.0 2002/10/03 07:30:00 

=================================================================} 

function GetUserResource(IpAddr: string; var List: TStringList): Boolean; 

type 

  TNetResourceArray = ^TNetResource;//网络类型的数组

Var 

  i: Integer;

  Buf: Pointer;

  Temp: TNetResourceArray;

  lphEnum: THandle;

  NetResource: TNetResource;

  Count,BufSize,Res: DWord;

Begin 

  Result := False;

  List.Clear;

  if copy(Ipaddr,0,2) <> '//' then

    IpAddr := '//'+IpAddr; //填充Ip地址信息

  FillChar(NetResource, SizeOf(NetResource), 0);//初始化网络层次信息

  NetResource.lpRemoteName := @IpAddr[1];//指定计算机名称

  //获取指定计算机的网络资源句柄

  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_ANY,

  RESOURCEUSAGE_CONNECTABLE, @NetResource,lphEnum);

  Buf:=nil;

  if Res <> NO_ERROR then exit;//执行失败

  while True do//列举指定工作组的网络资源

  begin

    Count := $FFFFFFFF;//不限资源数目

    BufSize := 8192;//缓冲区大小设置为8K

    GetMem(Buf, BufSize);//申请内存，用于获取工作组信息

    //获取指定计算机的网络资源名称

    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

    if Res = ERROR_NO_MORE_ITEMS then break;//资源列举完毕

    if (Res <> NO_ERROR) then Exit;//执行失败

    Temp := TNetResourceArray(Buf);

    for i := 0 to Count - 1 do

    begin

      //获取指定计算机中的共享资源名称，+2表示删除"//"，

      //如//192.168.0.1 => 192.168.0.1

      List.Add(Temp^.lpRemoteName + 2);

      Inc(Temp);

    end;

  end;

  Res := WNetCloseEnum(lphEnum);//关闭一次列举

  if Res <> NO_ERROR then exit;//执行失败

    Result := True;

    FreeMem(Buf);

End;




{================================================================= 

功 能: 返回网络中的工作组 

参 数: 

List: 需要填充的List 

返回值: 成功: True,并填充List 失败: False; 

备 注: 

版 本: 

1.0 2002/10/03 08:00:00 

=================================================================} 

function GetGroupList( var List : TStringList ) : Boolean; 

type 

  TNetResourceArray = ^TNetResource;//网络类型的数组

Var 

  NetResource: TNetResource;

  Buf: Pointer;

  Count,BufSize,Res: DWORD;

  lphEnum: THandle;

  p: TNetResourceArray;

  i,j: SmallInt;

  NetworkTypeList: TList;

Begin 

  Result := False;

  NetworkTypeList := TList.Create;

  List.Clear;

  //获取整个网络中的文件资源的句柄，lphEnum为返回名柄

  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_DISK,

  RESOURCEUSAGE_CONTAINER, Nil,lphEnum); 

  if Res <> NO_ERROR then exit;//Raise Exception(Res);//执行失败 

  //获取整个网络中的网络类型信息

  Count := $FFFFFFFF;//不限资源数目

  BufSize := 8192;//缓冲区大小设置为8K

  GetMem(Buf, BufSize);//申请内存，用于获取工作组信息

  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

  //资源列举完毕 //执行失败

  if ( Res = ERROR_NO_MORE_ITEMS ) or (Res <> NO_ERROR ) then Exit;

  P := TNetResourceArray(Buf);

  for i := 0 to Count - 1 do//记录各个网络类型的信息

  begin

    NetworkTypeList.Add(p);

    Inc(P);

  end;

  Res := WNetCloseEnum(lphEnum);//关闭一次列举

  if Res <> NO_ERROR then exit;

  for j := 0 to NetworkTypeList.Count-1 do //列出各个网络类型中的所有工作组名称

  begin//列出一个网络类型中的所有工作组名称

    NetResource := TNetResource(NetworkTypeList.Items[J]^);//网络类型信息

    //获取某个网络类型的文件资源的句柄，NetResource为网络类型信息，lphEnum为返回名柄

    Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,

    RESOURCEUSAGE_CONTAINER, @NetResource,lphEnum);

    if Res <> NO_ERROR then break;//执行失败

    while true do//列举一个网络类型的所有工作组的信息

    begin

      Count := $FFFFFFFF;//不限资源数目

      BufSize := 8192;//缓冲区大小设置为8K

      GetMem(Buf, BufSize);//申请内存，用于获取工作组信息

      //获取一个网络类型的文件资源信息，

      Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

      //资源列举完毕 //执行失败

      if ( Res = ERROR_NO_MORE_ITEMS ) or (Res <> NO_ERROR) then break;

      P := TNetResourceArray(Buf);

      for i := 0 to Count - 1 do//列举各个工作组的信息

      begin

        List.Add( StrPAS( P^.lpRemoteName ));//取得一个工作组的名称

        Inc(P);

      end;

    end;

    Res := WNetCloseEnum(lphEnum);//关闭一次列举

    if Res <> NO_ERROR then break;//执行失败

  end;

  Result := True;

  FreeMem(Buf);

  NetworkTypeList.Destroy;

End;







end.


