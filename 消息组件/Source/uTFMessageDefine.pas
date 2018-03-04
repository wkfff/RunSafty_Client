unit uTFMessageDefine;

interface
uses
  Contnrs,Messages,superobject;
const
  {��������ʧ����Ϣ}
  WM_ERROR = WM_USER + 2078;
  {���յ�������Ϣ}
  WM_TFONMESSAGE = WM_USER + 2079;


  {����Ϣ}
  TFMESSAGE_STATE_NEW = 0;
  {����ʧ�ܵ���Ϣ}
  TFMESSAGE_STATE_FAILED = 1;
  {��ȷ�Ͻ��յ���Ϣ}
  TFMESSAGE_STATE_RECIEVED = 2;
  {׼���������Ϣ}
  TFMESSAGE_STATE_CANCELD = 3;
type
  {HTTP�����������}
  THttpMode = (hmPostMessage{��WEB������Ϣ},hmGetMessage{��WEB��ȡ��Ϣ},
    hmConfirmMessage{��WEBȷ����Ϣ});


////////////////////////////////////////////////////////////////////////////////
/// TTFMessage  ��Ϣ����
////////////////////////////////////////////////////////////////////////////////
  TTFMessage = class
  public
    constructor Create();
  private
    {JSON�ַ���}
    m_strJSON: string;
    {�Զ�������}
    m_nTag: Integer;
    {��Ϣ������}
    m_nResult: Integer;
  private
    {����:��ȡ�����ֶ�ֵ}
    function GetIntField(FieldName: string): Integer;
    {����:��ȡ�ַ����ֶ�ֵ}
    function GetStrField(FieldName: string): string;
    {����:��ȡʱ�������ֶ�ֵ}
    function GetDtField(FieldName: string): TDateTime;
    {����:���������ֶ�ֵ}
    procedure SetIntField(FieldName: string; const Value: Integer);
    {����:�����ַ����ֶ�ֵ}
    procedure SetStrField(FieldName: string; const Value: string);
    {����:����ʱ�������ֶ�ֵ}
    procedure SetDtField(FieldName: string; const Value: TDateTime);
    {����:��ȡ���������ֶ�ֵ}
    function GetObjectField(FieldName: string): ISuperObject;
    {����:���ö��������ֶ�ֵ}
    procedure SetObjectField(FieldName: string; const Value: ISuperObject);

    {����:��ȡ��Ϣ����ֵ}
    function Getmsg: Integer;
    {����:��ȡ��ϢIDֵ}
    function GetmsgID: string;
    {����:��ȡ��Ϣ���ֵ}
    function GetnResult: Integer;
    {����:������Ϣ����}
    procedure Setmsg(const Value: Integer);
    {����:������ϢID}
    procedure SetmsgID(const Value: string);
    {����:������Ϣ���}
    procedure SetnResult(const Value: Integer);
    {����:��ȡ��Ϣ��������}
    function GetMode: Integer;
    {����:������Ϣ��������}
    procedure SetMode(const Value: Integer);

    {����:��ȡJSON}
    function GetJSON: string;
    {����:����JSON}
    procedure SetJson(const Value: string);
  public
    property JSON: string read GetJSON write SetJson;
    property Mode: Integer read GetMode write SetMode;
    property msg: Integer read Getmsg write Setmsg;
    property msgID: string read GetmsgID write SetmsgID;
    property nResult: Integer read GetnResult write SetnResult;
    property IntField[FieldName: string]: Integer read GetIntField write SetIntField;
    property StrField[FieldName: string]: string read GetStrField write SetStrField;
    property dtField[FieldName: string]: TDateTime read GetDtField write SetDtField;
    property ObjectField[FieldName: string]: ISuperObject read GetObjectField write SetObjectField;

    property Tag: Integer read m_nTag write m_nTag;
  end;

  {TTFMessageList  ��Ϣ�б�}
  TTFMessageList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTFMessage;
    procedure SetItem(Index: Integer; AObject: TTFMessage);
    function GetJSON: string;
    procedure SetJSON(const Value: string);
  public
    property Items[Index: Integer]: TTFMessage read GetItem write SetItem; default;
    property JSON: string read GetJSON write SetJSON;
  end;

  TOnMessageEvent = procedure(TFMessages: TTFMessageList) of object;
implementation
{ TTFMessageList }

function TTFMessageList.GetItem(Index: Integer): TTFMessage;
begin
  Result := TTFMessage(inherited GetItem(Index));
end;

function TTFMessageList.GetJSON: string;
var
  iJson: ISuperObject;
  iTemp: ISuperObject;
  i: Integer;
begin
  iJson := SO('[]');
  for I := 0 to Count - 1 do
  begin
    iTemp := SO(Items[i].JSON);
    iJson.AsArray.Add(iTemp);
    iTemp := nil;
  end;
  Result := iJson.AsString;
  iJson := nil;  
end;


procedure TTFMessageList.SetItem(Index: Integer; AObject: TTFMessage);
begin
  inherited SetItem(Index,AObject);
end;
procedure TTFMessageList.SetJSON(const Value: string);
var
  iJson: ISuperObject;
  i: Integer;
  TFMessage: TTFMessage;
begin
  Clear;
  iJson := SO(Value);
  if iJson = nil then exit;
  
  for I := 0 to iJson.AsArray.Length - 1 do
  begin
    TFMessage := TTFMessage.Create;
    TFMessage.JSON := iJson.AsArray.O[i].AsString;
    Add(TFMessage);
  end;
  iJson := nil;  
end;


{ TTFMessage }

constructor TTFMessage.Create;
begin
  m_strJSON := '{}';
end;


function TTFMessage.GetDtField(FieldName: string): TDateTime;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := JavaToDelphiDateTime(iJson.I[FieldName]);
  iJson := nil;  
end;


function TTFMessage.GetIntField(FieldName: string): Integer;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := iJson.I[FieldName];
  iJson := nil;  
end;


function TTFMessage.GetJSON: string;
begin
  Result := m_strJSON;
end;

function TTFMessage.GetMode: Integer;
begin
  Result := IntField['mode']
end;

function TTFMessage.Getmsg: Integer;
begin
  Result := IntField['msgType']
end;
function TTFMessage.GetmsgID: string;
begin
  Result := StrField['msgID'];
end;

function TTFMessage.GetnResult: Integer;
begin
  Result := m_nResult;
end;


function TTFMessage.GetObjectField(FieldName: string): ISuperObject;
begin
  Result := SO(m_strJSON).O[FieldName];
end;

function TTFMessage.GetStrField(FieldName: string): string;
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  Result := iJson.S[FieldName];
  iJson := nil;  
end;


procedure TTFMessage.SetDtField(FieldName: string; const Value: TDateTime);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.I[FieldName] := DelphiToJavaDateTime(Value);
  m_strJSON := iJson.AsString;
  iJson := nil;  
end;


procedure TTFMessage.SetIntField(FieldName: string; const Value: Integer);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.I[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;
end;


procedure TTFMessage.SetJson(const Value: string);
begin
  m_strJSON := Value;
end;

procedure TTFMessage.SetMode(const Value: Integer);
begin
  IntField['mode'] := Value;
end;

procedure TTFMessage.Setmsg(const Value: Integer);
begin
  IntField['msgType'] := Value;
end;

procedure TTFMessage.SetmsgID(const Value: string);
begin
  StrField['msgID'] := Value;
end;
procedure TTFMessage.SetnResult(const Value: Integer);
begin
  m_nResult := Value;
end;

procedure TTFMessage.SetObjectField(FieldName: string;
  const Value: ISuperObject);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.O[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;
end;

procedure TTFMessage.SetStrField(FieldName: string; const Value: string);
var
  iJson: ISuperObject;
begin
  iJson := SO(m_strJSON);
  iJson.S[FieldName] := Value;
  m_strJSON := iJson.AsString;
  iJson := nil;  
end;

end.
