unit uRunSafetyInterfaceDefine;

interface
uses
  uLKJson,SysUtils;
type
  TCWYEventType = (cweInRoom = 1,cweOutRoom,cweYanKa,cweBeginWork,cweEndWork);

  RRSBFCWYEvent = record
  const
    SJBS = 'SJ_CWY';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    CWYID: string;    //乘务员工号
    CWYXM: string;    //乘务员姓名
    CQSJ: string;     //出勤时间
    CYSJ: string;     //出寓时间
    SJLX: string;     //事件类型 01超劳预警
    CJMS: string;     //事件描述
  end;
  RRSBFJCEvent = record
  const
    SJBS = 'SJ_JC';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    CWYID1: string;   //乘务员工号
    CWYID2: string;   //乘务员工号
    CC: string;       //车次
    CX: string;       //车型
    CH: string;       //车号
    JLH: string;      //交路号
    CZH: string;      //车站号
    CZBZ: string;     //事件标志{1-出库,2-入库,3-停车,4-开车}
  end;
  RRSBFZhengBeiEvent = record
  const
    SJBS = 'SJ_ZBC';
  public
    SJSJ: string;     //事件时间,格式YYYYMMDDHHNNSS
    ZBC_BS: string;   //整备场标识
    CX: string;       //车型
    CH: string;       //车号
    GDH: string;      //股道号
    JCZT:string;      //机车状态
    SJLX: string;     //事件类型
    X: string;        //X坐标
    Y: string;        //Y坐标
    CDKD: string;     //整备场宽度
    CDGD: string;     //整备场高度
  end;

  
  RRSCWYEvent = record
    {事件时间}
    etime: TDateTime;
    {乘务员工号}
    tmid: string;
    {乘务员姓名}
    tmname: string;
    {TMIS站号}
    stmis: Integer;
    {结果状态:0}
    nresult: Integer;
    {描述信息}
    strResult: string;
    {事件标志}
    sjbz: TCWYEventType;
  end;


  TYanKaResultType =(rtSame{一致},rtUnsame{不一致},rtManul{人工验卡});
  RYanKaRecord = record
    {验卡时间}
    dtTestTime: TDateTime;
    {验卡地点}
    strPlace: string;
    {工号}
    strGh: string;
    {姓名}
    strName: string;
    {验卡结果}
    strResult: string;{合格，不合格，人工验卡}
  end;
  TJCEventType = (jceChuKu = 1,jceRuKu,jceTingChe,jceKaiChe);
  
  RRSJCEvent = record
    {事件时间}
    etime: TDateTime;
    {乘务员工号}
    tmid1: string;
    {乘务员工号}
    tmid2: string;
    {TMIS站号}
    stmis: Integer;
    {车型}
    cx: string;
    {车号}
    ch: string;
    {车次}
    cc: string;
    {事件标志}
    sjbz: TJCEventType;
  end;

  {TZBEventType 整备场事件类型}
  TZBEventType = (zbAdd = 1{添加},zbDel{删除},zbEdit{修改});
  {TZBJCZTState 整备机车状态}
  TZBJCZTState = (jcsOther{其它},jcsChangBei{长备},jcsDuanBei{短备},jcsLinXiu{临修},
    jcsXiuCheng{修程},jcsZhengBei{整备},jcsDaiYong{待用});

  {RRSZhengBeiXX 整备信息}
  RRSZhengBeiXX = record
    {数据库记录ID}
    nid: Integer;
    {事件时间}
    etime: TDateTime;
    {站号}
    stmis: Integer;
    {车型}
    cx: string;
    {车号}
    ch: string;
    {事件类型}
    sjlx: TZBEventType;
    {股道号}
    gdh: Integer;
    {整备场标识}
    zbcbs: string;
    {机车状态}
    jczt: TZBJCZTState;
    {x坐标}
    xPos: Double;
    {y坐标}
    yPos: Double;
    {整备场宽度}
    cdkd: Integer;
    {整备场高度}
    cdgd: Integer;
  end;

  {功能:整备场信息转换为博飞整备场结构}
  function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
  {功能:博飞人员事件转换为JSON}
  function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
  {功能:博飞机车事件转换为JSON}
  function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
  {功能:博飞整备场事件转换为JSON}
  function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
  {功能:JSON转换为博飞机车事件}
  function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
const
  TZBJCZTStateArray : array[TZBJCZTState] of string =
    ('其它','长备','短备','临修','修程','整备','待用');
implementation

function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
{功能:整备场信息转换为博飞整备场结构}
begin
  Result.SJSJ := FormatDateTime('YYYYMMDDHHNNSS',ZBCXX.etime);
  Result.ZBC_BS := ZBCXX.zbcbs;
  Result.CX := ZBCXX.cx;
  Result.CH := ZBCXX.ch;
  Result.GDH := IntToStr(ZBCXX.gdh);
  Result.JCZT := Format('%.2d',[Integer(ZBCXX.jczt)]);
  Result.SJLX := Format('%.2d',[Integer(ZBCXX.sjlx)]);
  Result.X := FloatToStr(ZBCXX.xPos);
  Result.Y := FloatToStr(ZBCXX.yPos);
  Result.CDKD := IntToStr(ZBCXX.cdkd);
  Result.CDGD := IntToStr(ZBCXX.cdgd);
end;
function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
var
  JSONObject : TlkJSONObject;
begin
  JSONObject := TlkJSON.ParseText(strJson) as TlkJSONobject;
  try
    Result.SJSJ := JSONObject.getString('SJSJ');
    Result.CWYID1 := JSONObject.getString('CWYID1');
    Result.CWYID2 := JSONObject.getString('CWYID2');
    Result.CC := JSONObject.getString('CC');
    Result.CX := JSONObject.getString('CX');
    Result.CH := JSONObject.getString('CH');
    Result.JLH := JSONObject.getString('JLH');
    Result.CZH := JSONObject.getString('CZH');
    Result.CZBZ := JSONObject.getString('CZBZ');
  finally
    JSONObject.Free;
  end;
end;


function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFZhengBeiEvent.SJBS);
    JSONObject.Add('SJSJ',BFZhengBeiEvent.SJSJ);
    JSONObject.Add('ZBC_BS',BFZhengBeiEvent.ZBC_BS);
    JSONObject.Add('CX',BFZhengBeiEvent.CX);
    JSONObject.Add('CH',BFZhengBeiEvent.CH);
    JSONObject.Add('GDH',BFZhengBeiEvent.GDH);
    JSONObject.Add('JCZT',BFZhengBeiEvent.JCZT);
    JSONObject.Add('SJLX',BFZhengBeiEvent.SJLX);
    JSONObject.Add('JCX',BFZhengBeiEvent.X);
    JSONObject.Add('JCY',BFZhengBeiEvent.Y);
    JSONObject.Add('CDKD',BFZhengBeiEvent.CDKD);
    JSONObject.Add('CDGD',BFZhengBeiEvent.CDGD);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;
function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',BFCWYEvent.SJBS);
    JSONObject.Add('SJSJ',BFCWYEvent.SJSJ);
    JSONObject.Add('CWYID',BFCWYEvent.CWYID);
    JSONObject.Add('CWYXM',BFCWYEvent.CWYXM);
    JSONObject.Add('CQSJ',BFCWYEvent.CQSJ);
    JSONObject.Add('CYSJ',BFCWYEvent.CYSJ);
    JSONObject.Add('SJLX',BFCWYEvent.SJLX);
    JSONObject.Add('CJMS',BFCWYEvent.CJMS);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
var
  JSONObject : TlkJSONObject;
begin
  Result := '';
  JSONObject := TlkJSONobject.Create;
  try
    JSONObject.Add('SJBS',JCEvent.SJBS);
    JSONObject.Add('SJSJ',JCEvent.SJSJ);
    JSONObject.Add('CWYID1',JCEvent.CWYID1);
    JSONObject.Add('CWYID2',JCEvent.CWYID2);
    JSONObject.Add('CC',JCEvent.CC);
    JSONObject.Add('CX',JCEvent.CX);
    JSONObject.Add('CH',JCEvent.CH);
    JSONObject.Add('JLH',JCEvent.JLH);
    JSONObject.Add('CZH',JCEvent.CZH);
    JSONObject.Add('CZBZ',JCEvent.CZBZ);
    
    Result := TlkJSON.GenerateText(JSONObject);

  finally
    JSONObject.Free;
  end;
end;

end.
