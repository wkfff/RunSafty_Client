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
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    CWYID: string;    //����Ա����
    CWYXM: string;    //����Ա����
    CQSJ: string;     //����ʱ��
    CYSJ: string;     //��Ԣʱ��
    SJLX: string;     //�¼����� 01����Ԥ��
    CJMS: string;     //�¼�����
  end;
  RRSBFJCEvent = record
  const
    SJBS = 'SJ_JC';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    CWYID1: string;   //����Ա����
    CWYID2: string;   //����Ա����
    CC: string;       //����
    CX: string;       //����
    CH: string;       //����
    JLH: string;      //��·��
    CZH: string;      //��վ��
    CZBZ: string;     //�¼���־{1-����,2-���,3-ͣ��,4-����}
  end;
  RRSBFZhengBeiEvent = record
  const
    SJBS = 'SJ_ZBC';
  public
    SJSJ: string;     //�¼�ʱ��,��ʽYYYYMMDDHHNNSS
    ZBC_BS: string;   //��������ʶ
    CX: string;       //����
    CH: string;       //����
    GDH: string;      //�ɵ���
    JCZT:string;      //����״̬
    SJLX: string;     //�¼�����
    X: string;        //X����
    Y: string;        //Y����
    CDKD: string;     //���������
    CDGD: string;     //�������߶�
  end;

  
  RRSCWYEvent = record
    {�¼�ʱ��}
    etime: TDateTime;
    {����Ա����}
    tmid: string;
    {����Ա����}
    tmname: string;
    {TMISվ��}
    stmis: Integer;
    {���״̬:0}
    nresult: Integer;
    {������Ϣ}
    strResult: string;
    {�¼���־}
    sjbz: TCWYEventType;
  end;


  TYanKaResultType =(rtSame{һ��},rtUnsame{��һ��},rtManul{�˹��鿨});
  RYanKaRecord = record
    {�鿨ʱ��}
    dtTestTime: TDateTime;
    {�鿨�ص�}
    strPlace: string;
    {����}
    strGh: string;
    {����}
    strName: string;
    {�鿨���}
    strResult: string;{�ϸ񣬲��ϸ��˹��鿨}
  end;
  TJCEventType = (jceChuKu = 1,jceRuKu,jceTingChe,jceKaiChe);
  
  RRSJCEvent = record
    {�¼�ʱ��}
    etime: TDateTime;
    {����Ա����}
    tmid1: string;
    {����Ա����}
    tmid2: string;
    {TMISվ��}
    stmis: Integer;
    {����}
    cx: string;
    {����}
    ch: string;
    {����}
    cc: string;
    {�¼���־}
    sjbz: TJCEventType;
  end;

  {TZBEventType �������¼�����}
  TZBEventType = (zbAdd = 1{���},zbDel{ɾ��},zbEdit{�޸�});
  {TZBJCZTState ��������״̬}
  TZBJCZTState = (jcsOther{����},jcsChangBei{����},jcsDuanBei{�̱�},jcsLinXiu{����},
    jcsXiuCheng{�޳�},jcsZhengBei{����},jcsDaiYong{����});

  {RRSZhengBeiXX ������Ϣ}
  RRSZhengBeiXX = record
    {���ݿ��¼ID}
    nid: Integer;
    {�¼�ʱ��}
    etime: TDateTime;
    {վ��}
    stmis: Integer;
    {����}
    cx: string;
    {����}
    ch: string;
    {�¼�����}
    sjlx: TZBEventType;
    {�ɵ���}
    gdh: Integer;
    {��������ʶ}
    zbcbs: string;
    {����״̬}
    jczt: TZBJCZTState;
    {x����}
    xPos: Double;
    {y����}
    yPos: Double;
    {���������}
    cdkd: Integer;
    {�������߶�}
    cdgd: Integer;
  end;

  {����:��������Ϣת��Ϊ�����������ṹ}
  function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
  {����:������Ա�¼�ת��ΪJSON}
  function BFCWYEventToJson(BFCWYEvent: RRSBFCWYEvent): string;
  {����:���ɻ����¼�ת��ΪJSON}
  function BFJCEventToJson(JCEvent: RRSBFJCEvent): string;
  {����:�����������¼�ת��ΪJSON}
  function BFZhengBeiEventToJson(BFZhengBeiEvent: RRSBFZhengBeiEvent): string;
  {����:JSONת��Ϊ���ɻ����¼�}
  function JsonToBFJCEvent(strJson: string): RRSBFJCEvent;
const
  TZBJCZTStateArray : array[TZBJCZTState] of string =
    ('����','����','�̱�','����','�޳�','����','����');
implementation

function ZBCXXToBFZBCEvent(ZBCXX: RRSZhengBeiXX): RRSBFZhengBeiEvent;
{����:��������Ϣת��Ϊ�����������ṹ}
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
