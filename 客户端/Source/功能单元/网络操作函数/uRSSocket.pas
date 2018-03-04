unit uRSSocket;

interface

uses 

SysUtils, Windows, dialogs, winsock, Classes, ComObj, WinInet, Variants;

//������Ϣ����
const

  C_Err_GetLocalIp = '��ȡ����ipʧ��'; 

  C_Err_GetNameByIpAddr = '��ȡ������ʧ��'; 

  C_Err_GetSQLServerList = '��ȡSQLServer������ʧ��'; 

  C_Err_GetUserResource = '��ȡ������ʧ��'; 

  C_Err_GetGroupList = '��ȡ���й�����ʧ��'; 

  C_Err_GetGroupUsers = '��ȡ�����������м����ʧ��'; 

  C_Err_GetNetList = '��ȡ������������ʧ��'; 

  C_Err_CheckNet = '���粻ͨ';

  C_Err_CheckAttachNet = 'δ��������';

  C_Err_InternetConnected ='û������';

  C_Txt_CheckNetSuccess = '���糩ͨ';

  C_Txt_CheckAttachNetSuccess = '�ѵ�������';

  C_Txt_InternetConnected ='������';




//�������Ƿ�������� 

function IsLogonNet: Boolean; 




//�õ������ľ�����Ip��ַ 

function GetLocalIP(var LocalIp:string): Boolean; 




//ͨ��Ip���ػ����� 

function GetNameByIPAddr(IPAddr: string; var MacName: string): Boolean ; 




//��ȡ������SQLServer�б� 

function GetSQLServerList(var List: Tstringlist): Boolean; 







//��ȡ�����еĹ����� 

function GetGroupList(var List: TStringList): Boolean; 







//��ȡ�����е���Դ 

function GetUserResource(IpAddr: string; var List: TStringList): Boolean; 










//�ж�IpЭ����û�а�װ ������������� 

function IsIPInstalled : boolean; 


/////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////

/////////////////////////////////////////////////

////////////// ����ʵ�ֲ���////////////

implementation




{================================================================= 

�� ��: �������Ƿ�������� 

�� ��: �� 

����ֵ: �ɹ�: True ʧ��: False 

�� ע: 

�� ��: 

1.0 2002/10/03 09:55:00 

=================================================================} 

function IsLogonNet: Boolean; 

begin 

  Result := False;

  if GetSystemMetrics(SM_NETWORK) <> 0 then

  Result := True;

end; 







{================================================================= 

�� ��: ���ر����ľ�����Ip��ַ 

�� ��: �� 

����ֵ: �ɹ�: True, �����LocalIp ʧ��: False 

�� ע: 

�� ��: 

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

�� ��: ͨ��Ip���ػ����� 

�� ��: 

IpAddr: ��Ҫ�õ����ֵ�Ip

����ֵ: �ɹ�: ������ ʧ��: ''

�� ע:

inet_addr function converts a string containing an Internet 

Protocol dotted address into an in_addr. 

�� ��: 

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

�� ��: ����������SQLServer�б� 

�� ��: 

List: ��Ҫ����List 

����ֵ: �ɹ�: True,�����List ʧ�� False 

�� ע: 

�� ��: 

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

�� ��: �ж�IPЭ����û�а�װ 

�� ��: �� 

����ֵ: �ɹ�: True ʧ��: False; 

�� ע: �ú����������� 

�� ��: 

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

�� ��: ���������еĹ�����Դ 

�� ��: 

IpAddr: ����Ip 

List: ��Ҫ����List 

����ֵ: �ɹ�: True,�����List ʧ��: False; 

�� ע: 

WNetOpenEnum function starts an enumeration of network 

resources or existing connections. 

WNetEnumResource function continues a network-resource 

enumeration started by the WNetOpenEnum function. 

�� ��: 

1.0 2002/10/03 07:30:00 

=================================================================} 

function GetUserResource(IpAddr: string; var List: TStringList): Boolean; 

type 

  TNetResourceArray = ^TNetResource;//�������͵�����

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

    IpAddr := '//'+IpAddr; //���Ip��ַ��Ϣ

  FillChar(NetResource, SizeOf(NetResource), 0);//��ʼ����������Ϣ

  NetResource.lpRemoteName := @IpAddr[1];//ָ�����������

  //��ȡָ���������������Դ���

  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_ANY,

  RESOURCEUSAGE_CONNECTABLE, @NetResource,lphEnum);

  Buf:=nil;

  if Res <> NO_ERROR then exit;//ִ��ʧ��

  while True do//�о�ָ���������������Դ

  begin

    Count := $FFFFFFFF;//������Դ��Ŀ

    BufSize := 8192;//��������С����Ϊ8K

    GetMem(Buf, BufSize);//�����ڴ棬���ڻ�ȡ��������Ϣ

    //��ȡָ���������������Դ����

    Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

    if Res = ERROR_NO_MORE_ITEMS then break;//��Դ�о����

    if (Res <> NO_ERROR) then Exit;//ִ��ʧ��

    Temp := TNetResourceArray(Buf);

    for i := 0 to Count - 1 do

    begin

      //��ȡָ��������еĹ�����Դ���ƣ�+2��ʾɾ��"//"��

      //��//192.168.0.1 => 192.168.0.1

      List.Add(Temp^.lpRemoteName + 2);

      Inc(Temp);

    end;

  end;

  Res := WNetCloseEnum(lphEnum);//�ر�һ���о�

  if Res <> NO_ERROR then exit;//ִ��ʧ��

    Result := True;

    FreeMem(Buf);

End;




{================================================================= 

�� ��: ���������еĹ����� 

�� ��: 

List: ��Ҫ����List 

����ֵ: �ɹ�: True,�����List ʧ��: False; 

�� ע: 

�� ��: 

1.0 2002/10/03 08:00:00 

=================================================================} 

function GetGroupList( var List : TStringList ) : Boolean; 

type 

  TNetResourceArray = ^TNetResource;//�������͵�����

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

  //��ȡ���������е��ļ���Դ�ľ����lphEnumΪ��������

  Res := WNetOpenEnum( RESOURCE_GLOBALNET, RESOURCETYPE_DISK,

  RESOURCEUSAGE_CONTAINER, Nil,lphEnum); 

  if Res <> NO_ERROR then exit;//Raise Exception(Res);//ִ��ʧ�� 

  //��ȡ���������е�����������Ϣ

  Count := $FFFFFFFF;//������Դ��Ŀ

  BufSize := 8192;//��������С����Ϊ8K

  GetMem(Buf, BufSize);//�����ڴ棬���ڻ�ȡ��������Ϣ

  Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

  //��Դ�о���� //ִ��ʧ��

  if ( Res = ERROR_NO_MORE_ITEMS ) or (Res <> NO_ERROR ) then Exit;

  P := TNetResourceArray(Buf);

  for i := 0 to Count - 1 do//��¼�����������͵���Ϣ

  begin

    NetworkTypeList.Add(p);

    Inc(P);

  end;

  Res := WNetCloseEnum(lphEnum);//�ر�һ���о�

  if Res <> NO_ERROR then exit;

  for j := 0 to NetworkTypeList.Count-1 do //�г��������������е����й���������

  begin//�г�һ�����������е����й���������

    NetResource := TNetResource(NetworkTypeList.Items[J]^);//����������Ϣ

    //��ȡĳ���������͵��ļ���Դ�ľ����NetResourceΪ����������Ϣ��lphEnumΪ��������

    Res := WNetOpenEnum(RESOURCE_GLOBALNET, RESOURCETYPE_DISK,

    RESOURCEUSAGE_CONTAINER, @NetResource,lphEnum);

    if Res <> NO_ERROR then break;//ִ��ʧ��

    while true do//�о�һ���������͵����й��������Ϣ

    begin

      Count := $FFFFFFFF;//������Դ��Ŀ

      BufSize := 8192;//��������С����Ϊ8K

      GetMem(Buf, BufSize);//�����ڴ棬���ڻ�ȡ��������Ϣ

      //��ȡһ���������͵��ļ���Դ��Ϣ��

      Res := WNetEnumResource(lphEnum, Count, Pointer(Buf), BufSize);

      //��Դ�о���� //ִ��ʧ��

      if ( Res = ERROR_NO_MORE_ITEMS ) or (Res <> NO_ERROR) then break;

      P := TNetResourceArray(Buf);

      for i := 0 to Count - 1 do//�оٸ������������Ϣ

      begin

        List.Add( StrPAS( P^.lpRemoteName ));//ȡ��һ�������������

        Inc(P);

      end;

    end;

    Res := WNetCloseEnum(lphEnum);//�ر�һ���о�

    if Res <> NO_ERROR then break;//ִ��ʧ��

  end;

  Result := True;

  FreeMem(Buf);

  NetworkTypeList.Destroy;

End;







end.


