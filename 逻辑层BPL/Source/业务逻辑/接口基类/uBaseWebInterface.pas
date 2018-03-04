unit uBaseWebInterface;

interface

uses
  SysUtils,Classes,superobject,uHttpCom,uTrainman,uTrainmanJiaolu,uSaftyEnum,
  windows;

type

  RRsWebInterfaceResult = record
    result:Integer;
    resultStr : string ;
  end;

  RInterConnConfig = record
    URL: string;
    ClientID: string;
    SiteID: string;
  end;

  TRecieveHttpDataEvent = procedure(const data: string) of object;
  //��վ�ӿڻ���
  TBaseWebInterface = class
  public
    //���캯��
    //AURL �ӿڵ�ַ
    //ClientID�ͻ��˱��
    constructor Create(AUrl:string;ClientID:string;SiteID:string);
    //��������
    destructor  Destroy();override;
  public
    //json -> group
    class procedure JsonToGroup(var Group:RRsGroup;Json: ISuperObject);

  protected
    //����JSON��������
    function  CreateInputJson():ISuperObject;
    //�ύJSON���ݵ�WEB�ӿ� dataType = �ύ����  sendstr ���������   ErrStr  ���������
    function  Post(DataType:string;SendStr:string):string;
    {����:�ύ����,ԭʼ��ʽ}
    function PostStringS(DataType: string; Values: TStringS):string;
    //���JSON�ķ��ؽ��,������JSON����
    function  GetJsonResult(AStr:string;out AJson:ISuperObject;out ErrStr:string):Boolean;
  protected
    //�ͻ��˱��
    m_strClientID:string;
    //��ַ�ӿ�
    m_strUrl:string;
    //SITE_id
    m_strSiteID:string;
    m_OnRecieveHttpDataEvent: TRecieveHttpDataEvent;
  public
    procedure SetConnConfig(ConnConfig: RInterConnConfig);
    property ClientID:string read m_strClientID ;
    property Url:string read m_strUrl ;
    property SiteID:string read m_strSiteID ;
    property OnRecieveHttpDataEvent: TRecieveHttpDataEvent read m_OnRecieveHttpDataEvent write m_OnRecieveHttpDataEvent;
  end;

implementation

{ TBaseWebInterface }


function TBaseWebInterface.GetJsonResult(AStr: string;
  out AJson: ISuperObject;out ErrStr:string): Boolean;
var
  json: ISuperObject;
begin
  Result := False ;
  try
    if AStr = '' then
    begin
      ErrStr := '��������Ϊ��' ;
      exit ;
    end;

    //ͨ���¼�֪ͨ�յ������ݣ����ڵ��Գ���
    if Assigned(m_OnRecieveHttpDataEvent) then
      m_OnRecieveHttpDataEvent(AStr);
      
    json := SO(AStr);
    if json = nil then
      Exit ;
    if  json.I['result']  = 0  then
    begin
      if  json.O['data'] <> nil  then
      begin
        AJson :=  json.O['data'] ;
      end;
      Result := True ;
    end
    else
      ErrStr := json.S['resultStr'];
  except
   on e:Exception do
   begin
    ErrStr := e.Message ;
   end;
  end;
end;



class procedure TBaseWebInterface.JsonToGroup(var Group: RRsGroup;
  Json: ISuperObject);
var
  strList:TStringList;
  nIndex:Integer;
  eFixedGroupType:TFixedGroupType;

  procedure JsonToTrainman(var Trainman: RRsTrainman;  Json: ISuperObject);
  begin
    with Trainman do
    begin
      strTrainmanGUID := Json.S['trainmanID'] ;
      strTrainmanNumber := Json.S['trainmanNumber'] ;
      strTrainmanName := Json.S['trainmanName'] ;
      nPostID :=  TRsPost ( strtoint(Json.S['postID']) ) ;
      strFixedGroupGUID := Json.S['strFixedGroupID'];
      strTelNumber := Json.S['telNumber'] ;
      strMobileNumber := strTelNumber ;
      //strMobileNumber := Json.S['mobileNumber'];
      nTrainmanState := TRsTrainmanState   (StrToInt(Json.S['trainmanState']));
      strPostName := Json.S['postName'] ;
      nDriverType := TRsDriverType ( strtoint ( Json.S['driverTypeID'] ) ) ;
      strDriverTypeName := Json.S['driverTypeName'] ;
      strABCD := Json.S['ABCD'] ;
      bIsKey :=  ( StrToInt(Json.S['isKey']) ) ;
      if (Json.S['lastEndworkTime'] <> '') then
        dtLastEndworkTime := StrToDateTimeDef(Json.S['lastEndworkTime'],StrToDateTime('2000-01-01')) ;
      eFixGroupType := Fixed_None;
      if Json.S['callWorkState'] <> '' then
        nCallWorkState :=  TRsCallWorkState ( StrToInt(Json.S['callWorkState']) );
      if Json.S['callWorkID'] <> '' then
        strCallWorkGUID := Json.S['callWorkID'];
    end;
  end;

begin


  ZeroMemory(@Group,SizeOf(Group));
  with Group do
  begin
    strGroupGUID := Json.S['groupID'];
    if Json.S['groupState'] <> '' then
      groupState :=  TRsTrainmanState ( strtoint ( Json.S['groupState'] ) ) ;
    strTrainPlanGUID := Json.S['trainPlanID'];
    strTrainNo := Json.S['trainNo'] ;
    strTrainTypeName := Json.S['trainTypeName'] ;
    strTrainNumber := Json.S['trainNumber'] ;

    if json.S['arriveTime'] <> '' then
      dtArriveTime := StrToDateTime(json.S['arriveTime']) ;

    if json.S['lastInRoomTime1'] <> '' then
      dtLastInRoomTime1:= StrToDateTime(json.S['lastInRoomTime1']) ;

    if json.S['lastInRoomTime2'] <> '' then
      dtLastInRoomTime2:= StrToDateTime(json.S['lastInRoomTime2']) ;

    if json.S['lastInRoomTime3'] <> '' then
      dtLastInRoomTime3:= StrToDateTime(json.S['lastInRoomTime3']) ;

    if json.S['lastInRoomTime4'] <> '' then
      dtLastInRoomTime4:=  StrToDateTime(json.S['lastInRoomTime4']) ;


    if json.S['LastOutRoomTime1'] <> '' then
      dtLastOutRoomTime1:=  StrToDateTime(json.S['LastOutRoomTime1']) ;

    if json.S['LastOutRoomTime2'] <> '' then
      dtLastOutRoomTime2:=  StrToDateTime(json.S['LastOutRoomTime2']) ;

    if json.S['LastOutRoomTime3'] <> '' then
      dtLastOutRoomTime3:=  StrToDateTime(json.S['LastOutRoomTime3']) ;

    if json.S['LastOutRoomTime4'] <> '' then
      dtLastOutRoomTime4:=  StrToDateTime(json.S['LastOutRoomTime4']) ;

    if json.S['LastEndworkTime1'] <> '' then
      dtLastEndworkTime1 :=  StrToDateTimedef(json.S['LastEndworkTime1'],0) ;

    if json.S['LastEndworkTime2'] <> '' then
      dtLastEndworkTime2 :=  StrToDateTimedef(json.S['LastEndworkTime2'],0) ;

    if json.S['LastEndworkTime3'] <> '' then
      dtLastEndworkTime3 :=  StrToDateTimedef(json.S['LastEndworkTime3'],0) ;

    if json.S['LastEndworkTime4'] <> '' then
      dtLastEndworkTime4 :=  StrToDateTimedef(json.S['LastEndworkTime4'],0) ;


  end;

  with Group.place do
  begin
    placeID := Json.S['place.placeID'];
    placeName := Json.S['place.placeName'];
  end;

  with Group.Station do
  begin
    strStationGUID := Json.S['station.stationID'] ;
    strStationNumber := Json.S['station.stationNumber'];
    strStationName := Json.S['station.stationName'];
  end;


  strList:=TStringList.Create;
  Try
    with Group do
    begin
      JsonToTrainman(trainman1,Json.O['trainman1']);

      JsonToTrainman(trainman2,Json.O['trainman2']);

      JsonToTrainman(trainman3,Json.O['trainman3']);

      JsonToTrainman(trainman4,Json.O['trainman4']);
      //��ȡһ�¹̶����id����,����guid���������ݽ����жϴ���
      if Trainman1.strTrainmanGUID <> '' then
        strList.Add(Trainman1.strFixedGroupGUID);
      if Trainman2.strTrainmanGUID <> '' then
      begin
        if strList.Find(Trainman2.strFixedGroupGUID,nIndex) = False then
          strList.Add(Trainman2.strFixedGroupGUID);
      end;
      if Trainman3.strTrainmanGUID <> '' then
      begin
        if strList.Find(Trainman3.strFixedGroupGUID,nIndex) = False then
          strList.Add(Trainman3.strFixedGroupGUID);
      end;
      if Trainman4.strTrainmanGUID <> '' then
      begin
        if strList.Find(Trainman4.strFixedGroupGUID,nIndex) = False then
          strList.Add(Trainman4.strFixedGroupGUID);
      end;
      //Ĭ��Ϊʲô������
      eFixedGroupType := Fixed_None;
      //������Աֻ��һ���̶����id
      if strList.Count = 1 then
      begin
        if strList.Strings[0] <> '' then  //�̶���id��Ϊ��,��ֻ��һ��,��ȫ���ǹ̶���
        begin
          eFixedGroupType := Fixed_Fix;
        end;
      end;
      if strList.Count > 1 then //�ж���̶���id ,���Ƿǰ�
      begin
        eFixedGroupType := Fixed_UnFix;//
      end;


      if Trainman1.strTrainmanGUID <> '' then
        Trainman1.eFixGroupType := eFixedGroupType;
      if Trainman2.strTrainmanGUID <> '' then
        Trainman2.eFixGroupType := eFixedGroupType;
      if Trainman3.strTrainmanGUID <> '' then
        Trainman3.eFixGroupType := eFixedGroupType;
      if Trainman4.strTrainmanGUID <> '' then
        Trainman4.eFixGroupType := eFixedGroupType;

    end;
  Finally
    strList.Free;
  End;
end;



constructor TBaseWebInterface.Create(AUrl, ClientID: string;SiteID:string);
begin
  inherited Create();
  m_strClientID := ClientID ;
  m_strUrl := AUrl ;
  m_strSiteID := SiteID ;
end;

function TBaseWebInterface.CreateInputJson: ISuperObject;
var
  json : ISuperObject ;
begin
  json := SO('{}');
  json.S['cid'] := m_strSiteID;//m_strClientID ;
  json.S['siteID'] := m_strSiteID;
  Result := json ;
end;

destructor TBaseWebInterface.Destroy;
begin
  inherited;
end;


function TBaseWebInterface.Post(DataType, SendStr: string): string;
var
  http : TRsHttpCom;
begin
  http := TRsHttpCom.Create;
  try
    Result := http.Post(m_strUrl,DataType,SendStr);
  finally
    http.Free ;
  end;

end;

function TBaseWebInterface.PostStringS(DataType: string; Values: TStrings):string;
var
  http : TRsHttpCom;
begin
  Result := '';
  http := TRsHttpCom.Create;
  try
    Result := http.PostStringS(m_strUrl + 'DataType=' + DataType,Values);
  finally
    http.Free ;
  end;
end;

procedure TBaseWebInterface.SetConnConfig(ConnConfig: RInterConnConfig);
begin
  m_strClientID := ConnConfig.ClientID;
  m_strUrl := ConnConfig.URL;
  m_strSiteID := ConnConfig.SiteID;
end;

end.
