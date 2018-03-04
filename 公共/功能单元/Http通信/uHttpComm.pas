unit uHttpComm;

interface
uses
  Classes,SysUtils,IdBaseComponent, IdComponent,IdTCPConnection, IdTCPClient,
  IdHTTP,uLkJSON,uRunSafetyInterfaceDefine;
const
  URL_INROOM = 'Web接口/InRoom.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_OUTROOM = 'Web接口/OutRoom.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_YANKA = 'Web接口/Verify.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_RUKU = 'Web接口/InDepots.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_CHUKU = 'Web接口/OutDepots.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_ZHENGBEI = 'Web接口/TrainMaintains.ashx?etime=%s&tmid=%s&cx=%s' +
    '&ch=%s&sjlx=%s&gdh=%s&xh=%s&jczt=%s&x=%s&y=%s&cdkd=%s&cdgd=%s';

  URL_ENTERSTATION = 'Web接口/EnterStation.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_LEAVESTATION = 'Web接口/LeaveStation.ashx?etime=%s&tmid1=%s&tmid2=%s' +
    '&stmis=%s&cx=%s&ch=%s&cc=%s';

  URL_BEGINWORK = 'Web接口/BeginWork.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';

  URL_ENDWORK = 'Web接口/EndWork.ashx?tmid=%s&etime=%s&tmname=%s' +
    '&stmis=%s&nresult=%s&strResult=%s';
type
  {RHttpResult HTTP上传返回结果信息}
  RHttpResult = record
    nResult: Integer;  //结果状态
    strResult: string; //结果描述
  end;


  {THttpCommBase  HTTP通信息基类}
  THttpCommBase = class
  protected
    m_URLHost: string;
    {功能:获取URL地址}
    function GetURL(): string;virtual;abstract;
    {功能:解板返回的HTTP结果}
    function DecodeHttpResult(strValue: string): RHttpResult;
  public
    {功能:上传信息}
    function Upload(): RHttpResult;virtual;
    property URLHost: string read m_URLHost write m_URLHost;
  end;

  TCWYEventHttp = class(THttpCommBase)
  protected
    {事件信息}
    m_CWYEvent: RRSCWYEvent;
    {功能:获取URL地址}
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
{功能:上传信息}
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
{功能:解板返回的HTTP结果}
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
{功能:获取URL地址}
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
      '0', //乘务员ID  此项没用
      CX,
      CH,
      Format('%.2d',[Integer(sjlx)]),
      IntToStr(gdh),
      '0', //序号   此项没用
      Format('%.2d',[Integer(jczt)]),
      FloatToStr(xPos),
      FloatToStr(yPos),
      IntToStr(cdkd),
      IntToStr(cdgd)
      ]);
  end;
end;



end.

