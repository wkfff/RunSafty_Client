unit uCallControl;
////////////////////////////////////////////////////////////////////////////////

//����: TCallControl

//���������ڿ������߽а�ϵͳ

////////////////////////////////////////////////////////////////////////////////

interface

uses SysUtils, CPort, StrUtils, Windows,uLogs;

type
  TCallControl = class

  public
    constructor Create();
    destructor Destroy(); override;

  public
    {���ܣ��򿪴���}
    function OpenPort(const port: integer; const band: integer = 9600): integer;
    {���ܣ��رմ���}
    procedure ClosePort();
    {���ܣ����ôӻ��豸��}
    function SetCallControlNum(const num: word): integer;
    {���ܣ���ȡ�ӻ��豸��}
    function GetCallControlNum(var devnum: word): integer;
    {���ܣ������豸}
    function CallRoom(const num: word): integer;
    {���ܣ���ѯ�����豸��}
    function QueryCallDevState(var devnum: word): integer;
    //��ѯ�豸״̬
    function QueryDeviceState(nDeviceID : Word) : boolean;
    {���ܣ��Ҷ�}
    function Hangup(const num: word): integer;
    {���ܣ�������ģ�鸴λ}
    function Reset() : integer;
    {���ܣ����ŷ�ʽѡ��}
    function SelectType(const typeID : word) : Integer;
    {���ܣ���ȡ¼��ģʽ}
    function GetRecordMode():Integer;
    {���ܣ�����¼��ģʽѡ��}
    function SetRecordMode(Mode : Word) : boolean;
    {���ܣ���ȡ����ģʽ}
    function GetPlayMode() : Integer;
    {���ܣ����÷���ģʽ}
    function SetPlayMode(Mode : Word) : boolean;
    //�򿪹���
    function OpenGF() : boolean;
    //�رչ���
    function CloseGF() : boolean;
  private
    {���ܣ�CRCУ��}
    procedure TCRC(old: array of byte; const len: Integer);
    {���ܣ����߽а�Э����װ}
    procedure FixProtocol(const parm: word = 0);
    function WriteSerial(const wdata: array of byte; const len: integer): integer;
    function ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;overload;
    function ReadSerial(var wdata: array of byte; const len: integer):Integer;overload;
    function GetSerialErrCode(strerr: string): integer;
  private
    ComPort1: TComPort;
    {���ӵĴ��ں�}
    m_nPort: integer;
    {������}
    m_nBand: integer;
    {��λ����������}
    m_byScmd: array[0..7] of byte;
    {��λ������ָ��}
    m_byRcmd: array[0..7] of byte;
    {Э������}
    type protocol = (SETCALLNUM, GETCALLNUM, CALL, QUERYCALL, HANG,SELECT_TYPE,ptReset,ptRecordEx,ptPlayEx,ptTestGF);
    {��ǰ����}
    var  m_ptltype: protocol;

  end;

implementation

constructor TCallControl.Create();
  //���ܣ���ʼ����Ա�������������ڶ���
begin
  m_nPort := -1;
  m_nBand := 9600;
  m_byScmd[0] := $AA;
  m_byScmd[1] := $55;
  ComPort1 := TComPort.Create(nil);
end;


destructor TCallControl.Destroy();
    //���ܣ��رմ���
begin
  if ComPort1.Connected = FALSE then
    ComPort1.Close();
  m_nPort := -1;
  if Assigned(ComPort1) then
   FreeAndNil(ComPort1);
end;

function TCallControl.SelectType(const typeID: word): Integer;
 //���ܣ�ѡ��ͨѶģʽ(1������;2����)
 //����ֵ��1 �����豸�ɹ�  >1 ����ʧ�ܴ�����
begin
  m_ptltype := SELECT_TYPE;
  FixProtocol(typeID);

  //�򴮿�д����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
end;

function TCallControl.SetCallControlNum(const num: word): integer;
   //���ܣ��ӻ����������
   //������num �ӻ������

var rst: integer;
    devnum: word;
begin

   //Э����װ
  m_ptltype := SETCALLNUM;
  FixProtocol(num);

   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst; //

end;

function TCallControl.SetPlayMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptPlayEx;
  FixProtocol(Mode);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;
  end
end;

function TCallControl.SetRecordMode(Mode: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := ptRecordEx;
  FixProtocol(Mode);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      rst := m_byRcmd[3];
      if rst = Mode then
        Result := true;
    end;;
  end
end;

function TCallControl.GetCallControlNum(var devnum: word): integer;
   //���ܣ��ӻ�����Ų�ѯ
   //
var rst: integer;
begin
     //Э����װ
  m_ptltype := GETCALLNUM;
  FixProtocol(0);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));

   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else
    Result := rst;
end;


function TCallControl.GetPlayMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptPlayEx;
  FixProtocol(0);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
    end;;
  end
end;

function TCallControl.GetRecordMode: Integer;
var
  rst: integer;
begin
  Result := -1;
  m_ptltype := ptRecordEx;
  FixProtocol(0);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      Result := m_byRcmd[3];
      if (Result < 1) or (Result > 2) then
        Result := -1;
    end;;
  end
end;

function TCallControl.CallRoom(const num: word): integer;
//���ܣ����з����
var
  strTemp: string;
  i: Integer;
begin
  //Э����װ
  m_ptltype := CALL;
  FixProtocol(num);
  //��ͨ����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
  {�ƣ�����������д����־}
  strTemp := '';
  for I := 0 to Length(m_byScmd) - 1 do
  begin
    strTemp := strTemp + IntToStr(m_byScmd[i]);
  end;  
  TLog.SaveLog(Now,'���ͺ������' + strTemp);
  
  OutputDebugString(PChar(Format('--------------------------------------���ͺ�������:%d',[Result])));
  //д�ɹ������ȡ��������
  if (Result = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------ȡ��������:%d',[Result])));
  end
end;

function TCallControl.QueryCallDevState(var devnum: word): integer;
//��ѯ�����豸��
//������devnum = 0 ���豸����
//����ֵ: 1: 2: 3:
var rst: integer;
begin
  //Э����װ
  m_ptltype := QUERYCALL;
  FixProtocol(0);

   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    Result := ReadSerial(m_byRcmd, sizeof(m_byRcmd), devnum);
  end
  else begin
    Result := rst;
  end;

end;

function TCallControl.QueryDeviceState(nDeviceID: Word): boolean;
var
  rst: integer;
begin
  Result := false;
  m_ptltype := QUERYCALL;
  try
    FixProtocol(0);
    //�򴮿�д����
    rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
    OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����:%d',[rst])));
    if (rst <> 1) then
    begin
      OutputDebugString(PChar(Format('--------------------------------------���Ͳ�ѯ����ʧ��:%d',[Result])));
      exit;
    end;
    //д�ɹ������ȡ��������
    Sleep(500);
    ZeroMemory(@m_byRcmd[0], Length(m_byRcmd));
    ComPort1.Read(m_byRcmd, sizeof(m_byRcmd));
    OutputDebugString(PChar(Format('--------------------------------------��ȡ��ѯ����سɹ�:%d',[m_byRcmd[5]])));    
    if m_byRcmd[5] <> 1 then exit;

    Result := true;
  except

  end;
end;

function TCallControl.Hangup(const num: word): integer;
 //���ܣ��һ�
 //����ֵ��1 �����豸�ɹ�  >1 ����ʧ�ܴ�����
begin

   //Э����װ
  m_ptltype := HANG;
  FixProtocol(num);

  //�򴮿�д����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));

end;

procedure TCallControl.TCRC(old: array of byte; const len: Integer);
var i: integer;
  sum: integer;
  strhex: string;
begin
  sum := 0;
  for i := 0 to len - 2 do
    sum := sum + old[i];

  sum := not (sum);
  strhex := IntToHex(sum, 2);
  m_byScmd[7] := StrToInt('$' + strhex) + 1;

end;

function TCallControl.OpenGF: boolean;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(1);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end

end;

function TCallControl.OpenPort(const port: integer; const band: integer): integer;
  //���ܣ��򿪴���
  //����ֵ��1 ���ڴ򿪳ɹ�   >1���ڴ�ʧ�ܴ�����
var strcom: string;
begin
  m_nPort := port;
  strcom := 'COM' + IntToStr(m_nPort);
  begin
    try
      ComPort1.Port := strcom;
      ComPort1.Open();
    except
      on Err: Exception do
      begin
        Result := GetSerialErrCode(Err.Message);
        exit;
      end;
    end
  end;
  Result := 1;
end;

function TCallControl.CloseGF: boolean;
var
  i,rst: integer;
begin
  Result := false;
  m_ptltype := ptTestGF;
  FixProtocol(2);
   //�򴮿�д����
  rst := WriteSerial(m_byScmd, sizeof(m_byScmd));
   //д�ɹ������ȡ��������
  if (rst = 1) then
  begin
    Sleep(100);
    rst := ReadSerial(m_byRcmd, sizeof(m_byRcmd));
    if rst = 1 then
    begin
      if Length(m_byScmd) <> Length(m_byRcmd) then exit;
      for i := 0 to Length(m_byScmd) - 1 do
      begin
        if m_byScmd[i] <> m_byRcmd[i] then exit;       
      end;        
      Result := true;
    end;;
  end
end;

procedure TCallControl.ClosePort();
  //���ܣ��رմ���
begin
  ComPort1.Close();
end;

procedure TCallControl.FixProtocol(const parm: word);
//���ܣ����߽а�Э����װ
begin
   //���Э�����ݲ���
  ZeroMemory(@m_byScmd[2], Length(m_byScmd) - 2);
  case m_ptltype of
    SETCALLNUM:
      begin
        m_byScmd[2] := $58;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    GETCALLNUM:
      begin
        m_byScmd[2] := $59;
      end;
    CALL:
      begin
        m_byScmd[2] := $60;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    QUERYCALL:
      begin
        m_byScmd[2] := $61;
      end;
    HANG:
      begin
        m_byScmd[2] := $62;
        m_byScmd[3] := HIBYTE(parm);
        m_byScmd[4] := LOBYTE(parm);
      end;
    SELECT_TYPE:
      begin
        m_byScmd[2] := $63;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
     ptReset:
      begin
        m_byScmd[2] := $64;
        m_byScmd[3] := 0;
        m_byScmd[4] := 0;
      end;
      ptRecordEx:
      begin
        m_byScmd[2] := $65;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
      ptPlayEx:
      begin
        m_byScmd[2] := $66;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;

      ptTestGF :
      begin
        m_byScmd[2] := $70;
        m_byScmd[3] := parm;
        m_byScmd[4] := 0;
      end;
  end;
    //
  TCRC(m_byScmd, sizeof(m_byScmd));

end;

function TCallControl.WriteSerial(const wdata: array of byte; const len: integer)
  : integer;
//���ܣ�д��������
//����ֵ��1 д�ɹ� ��>1 �˿ڴ�����
begin
  try
    ComPort1.ClearBuffer(True,TRUe);
    ComPort1.Write(wdata, sizeof(wdata));
  except
    on Err: Exception do
    begin
      Result := GetSerialErrCode(Err.Message);
      exit;
    end;

  end;
  Result := 1;
end;

function TCallControl.ReadSerial(var wdata: array of byte; const len: integer; var num: word): integer;
//���ܣ�����������
//����ֵ��1 ��ȡ���ݳɹ�  >1 ������ʧ�ܴ�����
var rst: integer;

begin
  rst := ComPort1.Read(wdata, len);

  if rst = sizeof(wdata) then
  begin
    num := makeword(wdata[4], wdata[3]); //�����
    case wdata[2] of
      $61:
        begin
          if num = 0 then
          begin
            Result := 1;
          end
          else
            Result := wdata[5]; //
        end; //end if
    else
      Result := 1;
    end; //end case
  end
  else
    Result := -1; //

end;

function TCallControl.ReadSerial(var wdata: array of byte;
  const len: integer): Integer;
//���ܣ�����������
//����ֵ��1 ��ȡ���ݳɹ�  >1 ������ʧ�ܴ�����
var
  rst: integer;
begin
  Result := -1; //
  rst := ComPort1.Read(wdata, len);
  if rst = sizeof(wdata) then
  begin
    Result := 1;
  end;
end;

function TCallControl.Reset: integer;
begin
   //Э����װ
  m_ptltype := ptReset;
  FixProtocol(0);
  //�򴮿�д����
  Result := WriteSerial(m_byScmd, sizeof(m_byScmd));
end;

function TCallControl.GetSerialErrCode(strerr: string): integer;
var idx: integer;
begin
  idx := Pos('code:', strerr);
  strerr := LeftStr(strerr, Length(strerr) - Length(')'));
  Result := StrToInt(RightStr(strerr, Length(strerr) - idx - Length('code:')));
end;


end.

