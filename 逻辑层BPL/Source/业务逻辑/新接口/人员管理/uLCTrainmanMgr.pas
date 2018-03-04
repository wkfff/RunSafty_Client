unit uLCTrainmanMgr;

interface
uses
  Classes,SysUtils,uBaseWebInterface,uStation,superobject,uTrainman,uLLCommonFun,
  uHttpWebAPI,uSaftyEnum,uTrainmanJiaolu;
const
  OPTION_GETTM_NOPICNOFINGER = 0;
  OPTION_GETTM_INCLUDEFINGER = 1;
  OPTION_GETTM_INCLUDEPIC = 2;
type
  //ö��ͳ����Ϣ
  REnumSum = record
    //ö������
    EnumName: string;
    //ö��ID
    EnumID: string;
    //ͳ������
    EnumCount: integer;
  end;

  TEnumSumArray = array of REnumSum;


  TListProgress = procedure(postion,max: integer);
  //��Ա��Ϣ�ӿ�
  TRsLCTrainmanMgr = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //���ܣ���ӳ���Ա
    procedure AddTrainman(const Trainman : RRsTrainman);
    //���ܣ��޸ĳ���Ա
    procedure UpdateTrainman(const Trainman : RRsTrainman) ;
    //���ܣ�ɾ������Ա
    procedure DeleteTrainman(TrainmanGUID: string);

    //��ȡָ��ID�ĳ���Ա����Ϣ
    function GetTrainmanByNumber(TrainmanNumber : string;out Trainman : RRsTrainman;option: integer = 0) : boolean;
    //��ҳ����
    procedure QueryTrainmans_blobFlag(QueryTrainman: RRsQueryTrainman;PageIndex: integer;
      out TrainmanArray: TRsTrainmanArray;out nTotalCount:Integer);
    //��ȡ������Ա
    function GetPopupTrainmans(WorkShopGUID, strKeyName: string; PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
    //��ȡ��ԱժҪ��Ϣ
    procedure GetTrainmansBrief(startNid,nCount,option: integer;out TrainmanArray:TRsTrainmanArray;out nTotalCount: integer);

    procedure ListTrainman(QueryTrainman: RRsQueryTrainman;out TrainmanArray:TRsTrainmanArray;Progress: TListProgress);

    //����˾����ϵ��ʽ
    procedure UpdateTrainmanTel(TrainmanGUID : string;TrainmanTel,
      TrainmanMobile,TrainmanAddress,TrainmanRemark : string);

    //�Ƿ���ڷ�GUID��˾������  where GUID = TrainmanGUID and strTrainmanNumber <>  TrainmanNumber
    function ExistNumber(TrainmanGUID,TrainmanNumber : string) : boolean;

    //����GUID��ȡ����Ա��Ϣ
    function GetTrainman(TrainmanGUID : string;out Trainman : RRsTrainman;option: Integer = 0) : boolean;

    //���ָ��
    procedure ClearFinger(TrainmanGUID : string);

    //����ָ����Ƭ    
    procedure UpdateFingerAndPic(const Trainman : RRsTrainman);

    //����ָ����Ա״̬
    procedure SetTrainmanState(TrainmanGUID : string; TrainmanState : integer);

    //����nid��ȡ����Ա
    function GetTrainmanByID(ID: integer;out Trainman: RRsTrainman): Boolean;

    //��ȡ��״̬��Ա����ͳ����Ϣ
    procedure GetTrainmanStateCount(WorkShopGUID: string;var TrainmanStateCount: RTrainmanStateCount);

    //��ȡָ������� ��Ա��·״��
    procedure GetTrainmanJiaoLuCount(WorkShopGUID : string;var CountArray: TRsTrainJiaoLuCountArray);

    //��ȡָ�������ڸ�����������Ա������
    procedure GetTrainmanLeaveCount(WorkShopGUID : string;out EnumSumArray: TEnumSumArray);

    //��ȡ�������Ա�� ����״��
    procedure GetTrainmanRunStateCount(WorkShopGUID : string;var CountArray:TRTrainmanRunStateCountArray);

    procedure UpdateTrainmanJiaolu(TrainmanGUID: string;TrainmanJiaoluGUID: string);
    //�޸���Ա������֯�ṹ
    procedure UpdateTrainmanOrg(TrainmanNumber : string;
      AreaGUID : string;WorkShopGUID : string;TrainJiaoluGUID : string;
      DutyUserGUID : string;DutyUserNumber : string;DutyUserName:string);
  private
    m_WebAPIUtils:TWebAPIUtils;

  public
    class function JsonToTrainman(ijson: ISuperObject): RRsTrainman;
    class function TrainmanToJson(const Trainman : RRsTrainman): ISuperObject;
    class function RsQueryTrainmanToJson(const QueryTrainman: RRsQueryTrainman): ISuperObject;
  end;
implementation

{ TRsLCTrainmanMgr }

procedure TRsLCTrainmanMgr.AddTrainman(const Trainman: RRsTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['trainman'] := TrainmanToJson(Trainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.AddTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCTrainmanMgr.ClearFinger(TrainmanGUID : string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.ClearFinger',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCTrainmanMgr.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCTrainmanMgr.DeleteTrainman(TrainmanGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['TrainmanGUID'] := TrainmanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.DelTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;



function TRsLCTrainmanMgr.ExistNumber(TrainmanGUID,
  TrainmanNumber: string): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.S['TrainmanNumber'] := TrainmanNumber; 

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.ExistNumber',JSON.AsString);

  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Result := m_WebAPIUtils.GetHttpDataJson(strOutputData).B['result'];

end;

function TRsLCTrainmanMgr.GetPopupTrainmans(WorkShopGUID, strKeyName: string;
  PageIndex: integer; out TrainmanArray: TRsTrainmanArray): integer;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  JSONTrainmanArray : ISuperObject;
  i: integer;
begin
  json := SO();
  json.S['WorkShopGUID'] := WorkShopGUID;
  json.S['strKeyName'] := strKeyName;
  json.I['PageIndex'] := PageIndex;
 

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetPopupTrainmans',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  json := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.I['nTotalCount'];

  JSONTrainmanArray := JSON.O['trainmanArray'];
  SetLength(TrainmanArray,JSONTrainmanArray.AsArray.Length);
  for I := 0 to JSONTrainmanArray.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(JSONTrainmanArray.AsArray[i]);
  end;
end;

function TRsLCTrainmanMgr.GetTrainman(TrainmanGUID: string;
  out Trainman: RRsTrainman;option: integer): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainman',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['trainmanArray'];
  
  result := json.AsArray.Length > 0;

  if Result then
  begin
    Trainman := JsonToTrainman(json.AsArray[0]);
  end;
end;

function TRsLCTrainmanMgr.GetTrainmanByID(ID: integer;
  out Trainman: RRsTrainman): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.I['ID'] := ID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Trainman.GetByID',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.I['Exist'] = 1;


  if Result then
  begin
    Trainman := JsonToTrainman(json.O['TM']);
  end;
end;

function TRsLCTrainmanMgr.GetTrainmanByNumber(TrainmanNumber: string;
  out Trainman: RRsTrainman;option: integer): boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanNumber'] := TrainmanNumber;
  json.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainmanByNumber',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['trainmanArray'];
  
  result := json.AsArray.Length > 0;

  if Result then
  begin
    Trainman := JsonToTrainman(json.AsArray[0]);
  end;
end;


procedure TRsLCTrainmanMgr.GetTrainmanJiaoLuCount(WorkShopGUID: string;
  var CountArray: TRsTrainJiaoLuCountArray);
  function JsonToJiaoLuCount(iJson: ISuperObject): RRsTrainJiaoLuCount;
  begin
    //��·����
    Result.strJiaoLuName := iJson.S['strJiaoLuName'];
    //��Ա����
    Result.nCount := iJson.I['nCount'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.TrainmanJiaoLu',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(CountArray,JSON.O['SumCount'].AsArray.Length);
  for I := 0 to Length(CountArray) - 1 do
  begin
    CountArray[i] := JsonToJiaoLuCount(JSON.O['SumCount'].AsArray[i]);
  end;

end;

procedure TRsLCTrainmanMgr.GetTrainmanLeaveCount(WorkShopGUID: string;
  out EnumSumArray: TEnumSumArray);
  function JsonToLeaveCount(iJson: ISuperObject): REnumSum;
  begin
    //ö������
    Result.EnumName := iJson.S['EnumName'];
    //ö��ID
    Result.EnumID := iJson.S['EnumID'];
    //ͳ������
    Result.EnumCount := iJson.I['EnumCount'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.Leave',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(EnumSumArray,JSON.O['Sum'].AsArray.Length);
  for I := 0 to Length(EnumSumArray) - 1 do
  begin
    EnumSumArray[i] := JsonToLeaveCount(JSON.O['Sum'].AsArray[i]);
  end;

end;

procedure TRsLCTrainmanMgr.GetTrainmanRunStateCount(WorkShopGUID: string;
  var CountArray: TRTrainmanRunStateCountArray);
  function JsonToSimpleGrp(iJson: ISuperObject): RRsGroup;
  begin
    Result := EmptyRsGroup;
    Result.GroupState := TRsTrainmanState(iJson.I['GroupState']);
    Result.Trainman1.strTrainmanNumber := iJson.S['TrainmanNumber1'];
    Result.Trainman1.strTrainmanName := iJson.S['TrainmanName1'];

    Result.Trainman2.strTrainmanNumber := iJson.S['TrainmanNumber2'];
    Result.Trainman2.strTrainmanName := iJson.S['TrainmanName2'];

    Result.Trainman3.strTrainmanNumber := iJson.S['TrainmanNumber3'];
    Result.Trainman3.strTrainmanName := iJson.S['TrainmanName3'];

    Result.Trainman4.strTrainmanNumber := iJson.S['TrainmanNumber4'];
    Result.Trainman4.strTrainmanName := iJson.S['TrainmanName4'];
  end;
  function JsonToCountInfo(iJson: ISuperObject): RTrainmanRunStateCount;
  var
    k: Integer;
  begin
    Result.strJiaoLuName := iJson.S['strJiaoLuName'];
    //������
    Result.nRuningCount := iJson.I['nRuningCount'];
    //������Ϣ
    Result.nLocalCount := iJson.I['nLocalCount'];
    //�����Ϣ
    Result.nSiteCount := iJson.I['nSiteCount'];
    SetLength(Result.group,iJson.O['group'].AsArray.Length);
    for k := 0 to Length(Result.group) - 1 do
    begin
      Result.group[k] := JsonToSimpleGrp(iJson.O['group'].AsArray[k]);
    end;
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.Sum.RunState',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  SetLength(CountArray,JSON.O['Sum'].AsArray.Length);
  for I := 0 to Length(CountArray) - 1 do
  begin
    CountArray[i] := JsonToCountInfo(JSON.O['Sum'].AsArray[i]);
  end;

end;
procedure TRsLCTrainmanMgr.GetTrainmansBrief(
  startNid,nCount,option: integer;out TrainmanArray:TRsTrainmanArray;out nTotalCount: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  i: integer;
begin
  JSON := SO();
  JSON.I['startNid'] := startNid;
  JSON.I['nCount'] := nCount;
  JSON.I['option'] := option;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.GetTrainmansBrief',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  nTotalCount := JSON.I['nTotalCount'];
  JSON := JSON.O['trainmanArray'];
  SetLength(TrainmanArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(json.AsArray[i]);
  end;
end;




procedure TRsLCTrainmanMgr.GetTrainmanStateCount(WorkShopGUID: string;
  var TrainmanStateCount: RTrainmanStateCount);
  function JsonToStateCount(iJson: ISuperObject): RTrainmanStateCount;
  begin
    {����ת}
    Result.nUnRuning := iJson.I['nUnRuning'];
    {Ԥ��}
    Result.nReady := iJson.I['nReady'];
    {������������}
    Result.nNormal := iJson.I['nNormal'];
    {�Ѱ��żƻ�}
    Result.nPlaning := iJson.I['nPlaning'];
    {����Ԣ}
    Result.nInRoom := iJson.I['nInRoom'];
    {����Ԣ}
    Result.nOutRoom := iJson.I['nOutRoom'];
    {�ѳ���}
    Result.nRuning := iJson.I['nRuning'];
    {����Ա}
    Result.nNil := iJson.I['nNil'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.GetTrainmanStateCount',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  TrainmanStateCount := JsonToStateCount(JSON.O['SumCount']);
end;


class function TRsLCTrainmanMgr.JsonToTrainman(ijson: ISuperObject): RRsTrainman;
begin
  //˾��GUID
  Result.strTrainmanGUID := iJson.S['strTrainmanGUID'];
  //˾������
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  //˾������
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];

  Result.nPostID := TRsPost(iJson.I['nPostID']);
  //ְλ����
  Result.strPostName := iJson.S['strPostName'];
  //��������GUID
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //������������
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  {ָ��1}
  Result.FingerPrint1 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint1']);

  if iJson.O['nFingerPrint1_Null'] <> nil then
    Result.nFingerPrint1_Null := iJson.I['nFingerPrint1_Null']
  else
  begin
    if Length(iJson.S['FingerPrint1']) = 0 then
      {ָ��1�ձ�־,��λ0,����Ϊ1}
      Result.nFingerPrint1_Null := 0
    else
      Result.nFingerPrint1_Null := 1;
  end;


  
  {ָ��2}
  Result.FingerPrint2 := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['FingerPrint2']);

  if iJson.O['nFingerPrint2_Null'] <> nil then
    Result.nFingerPrint2_Null := iJson.I['nFingerPrint2_Null']
  else
  begin
    if Length(iJson.S['FingerPrint2']) = 0 then
      {ָ��2�ձ�־,��λ0,����Ϊ1}
      Result.nFingerPrint2_Null := 0
    else
      Result.nFingerPrint2_Null := 1;
  end;
  


  //�����Ƭ
  Result.Picture := TCF_VariantParse.Base64ToOleVariantBytes(iJson.S['Picture']);

  if iJson.O['nPicture_Null'] <> nil then
    Result.nPicture_Null := iJson.I['nPicture_Null']
  else
  begin
    if Length(iJson.S['Picture']) = 0 then
      //��Ƭ�ձ�־,��λ0,����Ϊ1
      Result.nPicture_Null := 0
    else
      Result.nPicture_Null := 1;
  end;

  
  //ָ����GUID
  Result.strGuideGroupGUID := iJson.S['strGuideGroupGUID'];
  //ָ��������
  Result.strGuideGroupName := iJson.S['strGuideGroupName'];
  //��ϵ�绰
  Result.strTelNumber := iJson.S['strTelNumber'];
  //�ֻ���
  Result.strMobileNumber := iJson.S['strMobileNumber'];
  //��ͥסַ
  Result.strAdddress := iJson.S['strAddress'];
  //��ʻ����
  Result.nDriverType := TRsDriverType(iJson.I['nDriverType']);                                 


  Result.strDriverTypeName := iJson.S['strDriverTypeName'];

  //�а�״̬
  Result.nCallWorkState := TRsCallWorkState(iJson.I['nCallWorkState']);

  //�а�ʱ��
  Result.strCallWorkGUID := iJson.S['strCallWorkGUID'];
  //�ؼ���(0,1)
  Result.bIsKey := iJson.I['bIsKey'];
  //��ְ����
  Result.dtRuZhiTime := StrToDateTimeDef(iJson.S['dtRuZhiTime'],0);
  //��ְ����
  Result.dtJiuZhiTime := StrToDateTimeDef(iJson.S['dtJiuZhiTime'],0);
  //1��2��3
  Result.nDriverLevel := iJson.I['nDriverLevel'];
  //ABCD
  Result.strABCD := iJson.S['strABCD'];
  //��ע
  Result.strRemark := iJson.S['strRemark'];

  //�ͻ�ID
  Result.nKeHuoID := TRsKehuo(iJson.I['nKeHuoID']);
  
  //�ͻ�����
  Result.strKeHuoName := iJson.S['strKeHuoName'];
  //��������
  Result.strTrainJiaoluGUID := iJson.S['strTrainJiaoluGUID'];
  //������Ա��·
  Result.strTrainmanJiaoluGUID := iJson.S['strTrainmanJiaoluGUID'];
  //��������
  Result.strTrainJiaoluName := iJson.S['strTrainJiaoluName'];
  //�������ʱ��
  Result.dtLastEndworkTime := StrToDateTimeDef(iJson.S['dtLastEndworkTime'],0);
  //����α��
  Result.strAreaGUID := iJson.S['strareaguid'];
  //�������
  Result.nID := iJson.I['nID'];
  //����ʱ��
  Result.dtCreateTime := StrToDateTimeDef(iJson.S['dtCreateTime'],0);
  //״̬
  TCF_Enum.SetEnumValue(@Result.nTrainmanState,SizeOf(Result.nTrainmanState),iJson.I['nTrainmanState']);
  //������ƴ
  Result.strJP := iJson.S['strJP'];
  //�����Ԣʱ��
  Result.dtLastInRoomTime := StrToDateTimeDef(iJson.S['dtLastInRoomTime'],0);
  //�����Ԣʱ��
  Result.dtLastOutRoomTime := StrToDateTimeDef(iJson.S['dtLastOutRoomTime'],0); 
end;


procedure TRsLCTrainmanMgr.ListTrainman(QueryTrainman: RRsQueryTrainman;
  out TrainmanArray: TRsTrainmanArray; Progress: TListProgress);
var
  index,totalCount: integer;
  tmpArray: TRsTrainmanArray;
  I: integer;
begin
  totalCount := 0;
  index := 1;
  repeat
    QueryTrainmans_blobFlag(QueryTrainman,index,tmpArray,totalCount);
//    GetTrainmansBrief(index,20,option,tmpArray,totalCount);

    if Length(tmpArray) = 0 then break;
    
    Inc(index);   

    SetLength(TrainmanArray,Length(TrainmanArray) + Length(tmpArray));
    for I := 0 to Length(tmpArray) - 1 do
    begin
      TrainmanArray[Length(TrainmanArray) - Length(tmpArray) + i] := tmpArray[i];
    end;

    if Assigned(Progress) then
      Progress(Length(TrainmanArray),totalCount);
      
  until (Length(TrainmanArray) >=  totalCount);
  
  
end;

procedure TRsLCTrainmanMgr.QueryTrainmans_blobFlag(
  QueryTrainman: RRsQueryTrainman; PageIndex: integer;
  out TrainmanArray: TRsTrainmanArray; out nTotalCount: Integer);
var
  json: ISuperObject;
  strOutputData,strResultText : string ;
  I: Integer;
begin
  json := SO;
  json.I['PageIndex'] := PageIndex;
  json.O['QueryTrainman'] := RsQueryTrainmanToJson(QueryTrainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.QueryTrainmans_blobFlag',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
  
  json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  

  nTotalCount := json.I['nTotalCount'];

  json := json.O['trainmanArray'];
  SetLength(TrainmanArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    TrainmanArray[i] := JsonToTrainman(json.AsArray[i]);
  end;
end;

class function TRsLCTrainmanMgr.RsQueryTrainmanToJson(
  const QueryTrainman: RRsQueryTrainman): ISuperObject;
begin
  Result := SO();
  //���ţ���Ϊ����
  Result.S['strTrainmanNumber'] := QueryTrainman.strTrainmanNumber;
  //��������Ϊ����
  Result.S['strTrainmanName'] := QueryTrainman.strTrainmanName;
  //����α��
  Result.S['strAreaGUID'] := QueryTrainman.strAreaGUID;
  //�������䣬��Ϊ����
  Result.S['strWorkShopGUID'] := QueryTrainman.strWorkShopGUID;
  //������Ϣ
  Result.S['strTrainJiaoluGUID'] := QueryTrainman.strTrainJiaoluGUID;
  //ָ����
  Result.S['strGuideGroupGUID'] := QueryTrainman.strGuideGroupGUID;
  //�ѵǼ�ָ��������-1Ϊ����
  Result.I['nFingerCount'] := QueryTrainman.nFingerCount;
  //�Ƿ�����Ƭ��-1Ϊ����
  Result.I['nPhotoCount'] := QueryTrainman.nPhotoCount;      
end;

procedure TRsLCTrainmanMgr.SetTrainmanState(TrainmanGUID: string;
  TrainmanState: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.I['TrainmanState'] := TrainmanState;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.SetTrainmanState',JSON.AsString);

  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

class function TRsLCTrainmanMgr.TrainmanToJson(
  const Trainman: RRsTrainman): ISuperObject;
begin
  Result := SO();
  //˾��GUID
  Result.S['strTrainmanGUID'] := Trainman.strTrainmanGUID;
  //˾������
  Result.S['strTrainmanName'] := Trainman.strTrainmanName;
  //˾������
  Result.S['strTrainmanNumber'] := Trainman.strTrainmanNumber;
  //ְλ
  Result.I['nPostID'] := Ord(Trainman.nPostID);
  //ְλ����
  Result.S['strPostName'] := Trainman.strPostName;
  //��������GUID
  Result.S['strWorkShopGUID'] := Trainman.strWorkShopGUID;
  //������������
  Result.S['strWorkShopName'] := Trainman.strWorkShopName;

  {ָ��1}
  Result.S['FingerPrint1'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.FingerPrint1,True);
  {ָ��1�ձ�־,��λ0,����Ϊ1}
  Result.I['nFingerPrint1_Null'] := Trainman.nFingerPrint1_Null;


  {ָ��2}
  Result.S['FingerPrint2'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.FingerPrint2,True);
  {ָ��2�ձ�־,��λ0,����Ϊ1}
  Result.I['nFingerPrint2_Null'] := Trainman.nFingerPrint2_Null;


  //�����Ƭ
  Result.S['Picture'] := TCF_VariantParse.OleVariantBytesToBase64(Trainman.Picture,True);
  //��Ƭ�ձ�־,��λ0,����Ϊ1
  Result.I['nPicture_Null'] := Trainman.nPicture_Null;
  
  //ָ����GUID
  Result.S['strGuideGroupGUID'] := Trainman.strGuideGroupGUID;
  //ָ��������
  Result.S['strGuideGroupName'] := Trainman.strGuideGroupName;
  //��ϵ�绰
  Result.S['strTelNumber'] := Trainman.strTelNumber;
  //�ֻ���
  Result.S['strMobileNumber'] := Trainman.strMobileNumber;
  //��ͥסַ
  Result.S['strAddress'] := Trainman.strAdddress;
  //��ʻ����
  Result.I['nDriverType'] := Ord(Trainman.nDriverType);
  Result.S['strDriverTypeName'] := Trainman.strDriverTypeName;
  //�а�״̬
  Result.I['nCallWorkState'] := Ord(Trainman.nCallWorkState);
  //�а�ʱ��
  Result.S['strCallWorkGUID'] := Trainman.strCallWorkGUID;
  //�ؼ���(0,1)
  Result.I['bIsKey'] := Trainman.bIsKey;
  //��ְ����
  Result.S['dtRuZhiTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtRuZhiTime);
  //��ְ����
  Result.S['dtJiuZhiTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtJiuZhiTime);
  //1��2��3
  Result.I['nDriverLevel'] := Trainman.nDriverLevel;
  //ABCD
  Result.S['strABCD'] := Trainman.strABCD;
  //��ע
  Result.S['strRemark'] := Trainman.strRemark;
  //�ͻ�ID
  Result.I['nKeHuoID'] := Ord(Trainman.nKeHuoID);
  //�ͻ�����
  Result.S['strKeHuoName'] := Trainman.strKeHuoName;
  //��������
  Result.S['strTrainJiaoluGUID'] := Trainman.strTrainJiaoluGUID;
  //������Ա��·
  Result.S['strTrainmanJiaoluGUID'] := Trainman.strTrainmanJiaoluGUID;
  //��������
  Result.S['strTrainJiaoluName'] := Trainman.strTrainJiaoluName;
  //�������ʱ��
  Result.S['dtLastEndworkTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastEndworkTime);
  //����α��
  Result.S['strAreaGUID'] := Trainman.strAreaGUID;
  //�ͽӿڶ��岻ͳһ����������д�����п����ã���ʱ��д��JSON��
  Result.S['strareaguid'] := Trainman.strAreaGUID;

  //�������
  Result.I['nID'] := Trainman.nID;
  //����ʱ��
  Result.S['dtCreateTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtCreateTime);
  //״̬
  Result.I['nTrainmanState'] := Ord(Trainman.nTrainmanState);
  //������ƴ
  Result.S['strJP'] := Trainman.strJP;
  //�����Ԣʱ��
  Result.S['dtLastInRoomTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastInRoomTime);
  //�����Ԣʱ��
  Result.S['dtLastOutRoomTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',Trainman.dtLastOutRoomTime);  
end;

procedure TRsLCTrainmanMgr.UpdateFingerAndPic(const Trainman : RRsTrainman);
var
  json: ISuperObject;
  strOutputData,strResultText: string;
begin
  json := so;
  json.o['trainman'] := TrainmanToJson(Trainman);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateFingerAndPic',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTrainmanMgr.UpdateTrainman(const Trainman: RRsTrainman);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO;
  JSON.O['trainman'] := TrainmanToJson(Trainman);


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateTrainman',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCTrainmanMgr.UpdateTrainmanJiaolu(TrainmanGUID,
  TrainmanJiaoluGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['TrainmanGUID'] := TrainmanGUID;
  json.s['TrainmanJiaoluGUID'] := TrainmanJiaoluGUID;
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.UpdateTrainmanJiaolu',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;
procedure TRsLCTrainmanMgr.UpdateTrainmanOrg(TrainmanNumber, AreaGUID,
  WorkShopGUID, TrainJiaoluGUID, DutyUserGUID, DutyUserNumber: string;
  DutyUserName:string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.s['TrainmanNumber'] := TrainmanNumber;
  json.s['AreaGUID'] := AreaGUID;
  json.s['WorkShopGUID'] := WorkShopGUID;
  json.s['TrainJiaoluGUID'] := TrainJiaoluGUID;
  json.s['DutyUserGUID'] := DutyUserGUID;
  json.s['DutyUserNumber'] := DutyUserNumber;
  json.s['DutyUserName'] := DutyUserName;
  
  strOutputData := m_WebAPIUtils.Post('TF.Runsafty.LCTrainmanMgr.UpdateTMOrg',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

procedure TRsLCTrainmanMgr.UpdateTrainmanTel(TrainmanGUID, TrainmanTel,
  TrainmanMobile, TrainmanAddress, TrainmanRemark: string);
var
  json: ISuperObject;
  strOutputData,strResultText : string ;
begin
  json := SO;
  json.S['TrainmanGUID'] := TrainmanGUID;
  json.S['TrainmanTel'] := TrainmanTel;
  json.S['TrainmanMobile'] := TrainmanMobile;
  json.S['TrainmanAddress'] := TrainmanAddress;
  json.S['TrainmanRemark'] := TrainmanRemark;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTrainmanMgr.UpdateTrainmanTel',JSON.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

end.
