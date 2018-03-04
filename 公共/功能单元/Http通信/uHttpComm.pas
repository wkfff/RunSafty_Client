unit uHttpComm;

interface
uses
  Classes,SysUtils,IdBaseComponent, IdComponent,IdTCPConnection, IdTCPClient,
  IdHTTP,uLkJSON,uRunSafetyInterfaceDefine;
const
  URL_INROOM = 'Web�ӿ�/InRoom.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_OUTROOM = 'Web�ӿ�/OutRoom.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_YANKA = 'Web�ӿ�/Verify.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_RUKU = 'Web�ӿ�/InDepots.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_CHUKU = 'Web�ӿ�/OutDepots.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_ZHENGBEI = 'Web�ӿ�/TrainMaintains.ashx?etime=%s&tmid=%s&cx=%s' +
    '&ch=%s&sjlx=%s&gdh=%s&xh=%s&jczt=%s&x=%s&y=%s&cdkd=%s&cdgd=%s';

  URL_ENTERSTATION = 'Web�ӿ�/EnterStation.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_LEAVESTATION = 'Web�ӿ�/LeaveStation.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_BEGINWORK = 'Web�ӿ�/BeginWork.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_ENDWORK = 'Web�ӿ�/EndWork.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';
type
  {RHttpResult HTTP�ϴ����ؽ����Ϣ}
  RHttpResult = record
    nResult: Integer;  //���״̬
    strResult: string; //�������
  end;


  {THttpCommBase  HTTPͨ��Ϣ����}
  THttpCommBase = class
  protected
    m_URLHost: string;
    {����:��ȡURL��ַ}
    function GetURL(): string;virtual;abstract;
    {����:��巵�ص�HTTP���}
    function DecodeHttpResult(strValue: string): RHttpResult;
  public
    {����:�ϴ���Ϣ}
    function Upload(): RHttpResult;virtual;
    property URLHost: string read m_URLHost write m_URLHost;
  end;

  TCWYEventHttp = class(THttpCommBase)
  protected
    {�¼���Ϣ}
    m_CWYEvent: RRSCWYEvent;
    {����:��ȡURL��ַ}
    function GetURL(): string;override;
  public
    property CWYEvent: RRSCWYEvent read m_CWYEvent
        write m_CWYEvent;
  end;


  TJCEventHttp = class(THttpCommBase)
  protected
    m_JCEvent: RRSJCEvent;
    function GetURL(): string;override;
  public
    property JCEvent: RRSJCEvent read m_JCEvent
        write m_JCEvent;
  end;


  TZBCEventHttp = class(THttpCommBase)
  protected
    m_ZhengBeiXX: RRSZhengBeiXX;
    function GetURL(): string;override;
  public
    property ZhengBeiXX: RRSZhengBeiXX read m_ZhengBeiXX
        write m_ZhengBeiXX;
  end;

implementation

{ THttpCommBase }

function THttpCommBase.Upload: RHttpResult;
{����:�ϴ���Ϣ}
var
  IdHTTP: TIdHTTP;
  strResult: string;
  strUrl: string;
begin
  IdHTTP := TIdHTTP.Create(nil);
  try
    IdHTTP.ReadTimeout := 1000;
    strUrl := GetURL();
    strResult := IdHTTP.Get(strUrl);
    Result := DecodeHttpResult(strResult);
  finally
    IdHTTP.Free;
  end;
end;

function THttpCommBase.DecodeHttpResult(strValue: string): RHttpResult;
{����:��巵�ص�HTTP���}
var
  JSONObject : TlkJSONObject;
  strTemp: string;
begin
  JSONObject := TlkJSON.ParseText(strValue) as TlkJSONobject;
  try
    strTemp := JSONObject.getString('nResult');
    if strTemp <> '' then
      Result.nResult := StrToInt(strTemp)
    else
      Result.nResult := 1;
    Result.strResult :=  JSONObject.getString('strResult');
  finally
    JSONObject.Free;
  end;
end;


{ TInRoomRecordHttp }

function TCWYEventHttp.GetURL: string;
{����:��ȡURL��ַ}
var
  strURL: string;
begin
  case m_CWYEvent.sjbz of
    cweInRoom: strURL := Trim(m_URLHost) + Trim(URL_INROOM);
    cweOutRoom: strURL := Trim(m_URLHost) + Trim(URL_OUTROOM);
    cweYanKa: strURL := Trim(m_URLHost) + Trim(URL_YANKA);
    cweBeginWork: strURL := Trim(m_URLHost) + Trim(URL_BEGINWORK);
    cweEndWork: strURL := Trim(m_URLHost) + Trim(URL_ENDWORK);
  end;

  
  with m_CWYEvent do
  begin
    Result := Format(strURL,[
      tmid,
      FormatDateTime('yyyy-mm-dd,hh:nn:ss',etime),
      tmname,
      IntToStr(stmis),
      IntToStr(nResult),
      strResult
      ]);
  end;
end;

{ TJCEventHttp }

function TJCEventHttp.GetURL: string;
var
  strURL: string;
begin
  case m_JCEvent.sjbz of
    jceChuKu: strURL:= Trim(m_URLHost) + Trim(URL_CHUKU);
    jceRuKu: strURL:= Trim(m_URLHost) + Trim(URL_RUKU);
    jceTingChe: strURL:= Trim(m_URLHost) + Trim(URL_ENTERSTATION);
    jceKaiChe: strURL:= Trim(m_URLHost) + Trim(URL_LEAVESTATION);
  end;

  with m_JCEvent do
  begin
      Result := Format(strURL,[
      FormatDateTime('yyyy-mm-dd,hh:nn:ss',etime),
      tmid1,
      tmid2,
      IntToStr(stmis),
      cx,
      ch,
      cc]);
  end;
end;

{ TZBCEventHttp }

function TZBCEventHttp.GetURL: string;
var
  strURL: string;
begin
  strURL := Trim(m_URLHost) + Trim(URL_ZHENGBEI);

  
  with m_ZhengBeiXX do
  begin
      Result := Format(strURL,[
      FormatDateTime('yyyy-mm-dd,hh:nn:ss',etime),
      '0', //����ԱID  ����û��
      CX,
      CH,
      Format('%.2d',[Integer(sjlx)]),
      IntToStr(gdh),
      '0', //���   ����û��
      Format('%.2d',[Integer(jczt)]),
      FloatToStr(xPos),
      FloatToStr(yPos),
      IntToStr(cdkd),
      IntToStr(cdgd)
      ]);
  end;
end;



end.

