unit uLCTeamGuide;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uGuideSign,uTrainman,uLCTrainmanMgr;
type
  TRsLCGuideGrpTrainman = class;
  TRsLCGuideSign = class;
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCGuideGroup
  /// ˵��:TLCGuideGroup�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TRsLCGuideGroup = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  Private
    m_WebAPIUtils:TWebAPIUtils;
    m_Trainman: TRsLCGuideGrpTrainman;
    m_GuideSign: TRsLCGuideSign;
  public
    //����:1.10.1    ��ȡ���г���
    procedure GetWorkShopArray(out workShopArray : TRsSimpleInfoArray);
    //����:1.10.2    ��ȡ����GUID
    function GetOwnerWorkShopID(GuideGroupGUID : String): string;
    //����:1.10.3    ��ȡָ��������
    function GetName(GuideGroupGUID : String): string;
    //����:1.10.4    ��ȡ�������ƣ�ָ��������
    function GetWorkShop_GuideGroup(GuideGroupGUID : String): string;
    //����:1.10.5    ���ݳ��䣬��ȡָ����
    procedure GetGroupArray(WorkShopGUID : String;out guideGroupArray : TRsSimpleInfoArray);

    property Trainman: TRsLCGuideGrpTrainman read m_Trainman;
    property GuideSign: TRsLCGuideSign read m_GuideSign;

  end;

  TRsLCGuideGrpTrainman = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //����:1.10.6    ����ԱID��������ָ����ID
    procedure SetGroupByID(trainmanGUID : String;guideGroupID : String);
    //����:1.10.7    �����Ÿ�������ָ����ID
    procedure SetGroupByNumber(trainmanNumber : String;GuideGroupID : String;bNotUpdateExist : Boolean = true);
    //����:1.10.8    ����˾��ְλ
    procedure SetPostID(trainmanGUID : String; nPostID : Integer);
    //����:1.10.9    ���ݲ�ѯ�����͹����������õ�˾���б�
    procedure GetList(QueryParam : RRsQueryTrainman;FilterParam : RRsQueryTrainman;out trainmanArray : TRsTrainmanArray);
    //����:1.10.10    ��ְλ��ȡ��Ա�б�
    procedure GetByPost(WorkShopGUID : String;nPostID : Integer;cmdType : Integer;out trainmanArray : TRsTrainmanArray);
  Private
    m_WebAPIUtils:TWebAPIUtils;
  end;


  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCGuideSign
  /// ˵��:TLCGuideSign�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TRsLCGuideSign = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public     
    //����:1.9.11    ���ǩ����Ϣ                        
    procedure SignIn(guideSignEntity : RRsGuideSign);
    //����:1.9.12    ���ǩ����Ϣ
    procedure SignOut(guideSignEntity : RRsGuideSign);
    //����:1.9.13    ��ѯǩ����Ϣ
    procedure QuerySignRecord(param : RRsQueryGuideSign;out guideSignArray : TRsGuideSignArray);
    //����:1.9.14    ��ѯδǩ����Ϣ
    procedure QueryNotSignRecord(param : RRsQueryGuideSign;out guideSignArray : TRsGuideSignArray);
    //����:1.9.15    ��ȡָ��GUID��ǩ����Ϣ
    function GetSignRecord(strGuideSignGUID : String;out guideSign : RRsGuideSign): Boolean;
    //����:1.9.16    ��ȡָ��˾�����ŵ�ǩ����Ϣ
    function GetSignRecordByTrainmanNumber(strTrainmanNumber : String;strGuideGroupGUID : String;out guideSign : RRsGuideSign): Boolean;
  Private
    m_WebAPIUtils:TWebAPIUtils;
    function QueryParamToJson(param : RRsQueryGuideSign): ISuperObject;
    function GuideSignToJson(GuideSign: RRsGuideSign): ISuperObject;
    function JsonToGuideSign(iJson: ISuperObject): RRsGuideSign;
  end;
  
implementation

{ TRsLCGuideGroup }

constructor TRsLCGuideGroup.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;

  m_Trainman := TRsLCGuideGrpTrainman.Create(WebAPIUtils);
  m_GuideSign := TRsLCGuideSign.Create(WebAPIUtils); 
end;

function TRsLCGuideGroup.GetName(GuideGroupGUID: String): string;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['GuideGroupGUID'] := GuideGroupGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideGroup.GetName',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.S['result'];
end;
destructor TRsLCGuideGroup.Destroy;
begin
  m_Trainman.Free;
  m_GuideSign.Free;
  inherited;
end;

procedure TRsLCGuideGroup.GetGroupArray(WorkShopGUID: String;
  out guideGroupArray: TRsSimpleInfoArray);
  function JsonToGroup(iJson: ISuperObject): RRsSimpleInfo;
  begin
    Result.strGUID := iJson.S['strGUID'];
    Result.strName := iJson.S['strName'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideGroup.GetGroupArray',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['guideGroupArray'];

  SetLength(guideGroupArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    guideGroupArray[i] := JsonToGroup(json.AsArray[i]);
  end;
end;

function TRsLCGuideGroup.GetOwnerWorkShopID(GuideGroupGUID: String): string;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['GuideGroupGUID'] := GuideGroupGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideGroup.GetOwnerWorkShopID',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.S['result'];
end;

procedure TRsLCGuideGroup.GetWorkShopArray(out workShopArray: TRsSimpleInfoArray);
  function JsonToWorkShop(iJson: ISuperObject): RRsSimpleInfo;
  begin
    Result.strGUID := iJson.S['strGUID'];
    Result.strName := iJson.S['strName'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideGroup.GetWorkShopArray',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['workShopArray'];

  SetLength(workShopArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    workShopArray[i] := JsonToWorkShop(json.AsArray[i]);
  end;
end;


function TRsLCGuideGroup.GetWorkShop_GuideGroup(GuideGroupGUID: String): string;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['GuideGroupGUID'] := GuideGroupGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideGroup.GetWorkShop_GuideGroup',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.S['result'];
end;

{ TLCTrainman }

constructor TRsLCGuideGrpTrainman.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCGuideGrpTrainman.GetByPost(WorkShopGUID: String; nPostID, cmdType: Integer;
  out trainmanArray: TRsTrainmanArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['WorkShopGUID'] := WorkShopGUID;
  JSON.I['nPostID'] := nPostID;
  JSON.I['cmdType'] := cmdType;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCTrainman.GetByPost',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Json := Json.O['trainmanArray'];
  SetLength(trainmanArray,JSON.AsArray.Length);

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    trainmanArray[i] := TRsLCTrainmanMgr.JsonToTrainman(JSON.AsArray[i]);
  end;
end;

procedure TRsLCGuideGrpTrainman.GetList(QueryParam, FilterParam: RRsQueryTrainman;
  out trainmanArray: TRsTrainmanArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();

  JSON.O['QueryParam'] := TRsLCTrainmanMgr.RsQueryTrainmanToJson(QueryParam);
  JSON.O['FilterParam'] := TRsLCTrainmanMgr.RsQueryTrainmanToJson(FilterParam);;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCTrainman.GetList',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Json := Json.O['trainmanArray'];
  SetLength(trainmanArray,JSON.AsArray.Length);

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    trainmanArray[i] := TRsLCTrainmanMgr.JsonToTrainman(JSON.AsArray[i]);
  end;
end;



procedure TRsLCGuideGrpTrainman.SetGroupByID(trainmanGUID, guideGroupID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['trainmanGUID'] := trainmanGUID;
  JSON.S['guideGroupID'] := guideGroupID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCTrainman.SetGroupByID',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCGuideGrpTrainman.SetGroupByNumber(trainmanNumber, GuideGroupID: String;
  bNotUpdateExist: Boolean);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['trainmanNumber'] := trainmanNumber;
  JSON.S['GuideGroupID'] := GuideGroupID;
  JSON.B['bNotUpdateExist'] := bNotUpdateExist;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCTrainman.SetGroupByNumber',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


procedure TRsLCGuideGrpTrainman.SetPostID(trainmanGUID: String; nPostID: Integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['trainmanGUID'] := trainmanGUID;
  JSON.I['nPostID'] := nPostID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCTrainman.SetPostID',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


{ TLCGuideSign }

procedure TRsLCGuideSign.SignOut(guideSignEntity: RRsGuideSign);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['guideSignEntity'] := GuideSignToJson(guideSignEntity);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.SignOut',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCGuideSign.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCGuideSign.GetSignRecord(strGuideSignGUID: String;
  out guideSign: RRsGuideSign): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strGuideSignGUID'] := strGuideSignGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.GetSignRecord',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];
  if Result then  
    guideSign := JsonToGuideSign(JSON.O['guideSign']);
end;

function TRsLCGuideSign.GetSignRecordByTrainmanNumber(strTrainmanNumber,
  strGuideGroupGUID: String; out guideSign: RRsGuideSign): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strTrainmanNumber'] := strTrainmanNumber;
  JSON.S['strGuideGroupGUID'] := strGuideGroupGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.GetSignRecordByTrainmanNumber',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];
  if Result then  
    guideSign := JsonToGuideSign(JSON.O['guideSign']);
end;
function TRsLCGuideSign.GuideSignToJson(GuideSign: RRsGuideSign): ISuperObject;
begin
  Result := SO;
  Result.S['strGuideSignGUID'] := GuideSign.strGuideSignGUID;
  Result.S['strTrainmanNumber'] := GuideSign.strTrainmanNumber;
  Result.S['strTrainmanName'] := GuideSign.strTrainmanName;
  Result.S['strWorkShopGUID'] := GuideSign.strWorkShopGUID;
  Result.S['strWorkShopName'] := GuideSign.strWorkShopName;
  Result.S['strGuideGroupGUID'] := GuideSign.strGuideGroupGUID;
  Result.S['strGuideGroupName'] := GuideSign.strGuideGroupName;
  Result.S['dtSignInTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',GuideSign.dtSignInTime);
  Result.I['nSignInFlag'] := Ord(GuideSign.nSignInFlag);
  Result.S['dtSignOutTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',GuideSign.dtSignOutTime);
  Result.I['nSignOutFlag'] := Ord(GuideSign.nSignOutFlag);
end;

function TRsLCGuideSign.JsonToGuideSign(iJson: ISuperObject): RRsGuideSign;
begin
  Result.strGuideSignGUID := iJson.S['strGuideSignGUID'];
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  Result.strGuideGroupGUID := iJson.S['strGuideGroupGUID'];
  Result.strGuideGroupName := iJson.S['strGuideGroupName'];
  Result.dtSignInTime := StrToDateTimeDef(iJson.S['dtSignInTime'],0);
  Result.nSignInFlag := TRsSignFlag(iJson.I['nSignInFlag']);
  Result.dtSignOutTime := StrToDateTimeDef(iJson.S['dtSignOutTime'],0);
  Result.nSignOutFlag := TRsSignFlag(iJson.I['nSignOutFlag']);
end;

procedure TRsLCGuideSign.QueryNotSignRecord(param: RRsQueryGuideSign;
  out guideSignArray: TRsGuideSignArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.O['param'] := QueryParamToJson(param);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.QueryNotSignRecord',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['guideSignArray'];

  SetLength(guideSignArray,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    guideSignArray[i] := JsonToGuideSign(JSON.AsArray[i]);
  end;

end;

function TRsLCGuideSign.QueryParamToJson(
  param: RRsQueryGuideSign): ISuperObject;
begin
  Result := SO;
  Result.S['strTrainmanNumber'] := param.strTrainmanNumber;
  Result.S['strTrainmanName'] := param.strTrainmanName;
  Result.S['strWorkShopGUID'] := param.strWorkShopGUID;
  Result.S['strGuideGroupGUID'] := param.strGuideGroupGUID;
  Result.S['dtSignTimeBegin'] := formatdatetime('yyyy-mm-dd hh:nn:ss',param.dtSignTimeBegin);
  Result.S['dtSignTimeEnd'] := formatdatetime('yyyy-mm-dd hh:nn:ss',param.dtSignTimeEnd);
  Result.I['nSignFlag'] := Ord(param.nSignFlag);
end;

procedure TRsLCGuideSign.QuerySignRecord(param: RRsQueryGuideSign;
  out guideSignArray: TRsGuideSignArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.O['param'] := QueryParamToJson(param);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.QuerySignRecord',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['guideSignArray'];

  SetLength(guideSignArray,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    guideSignArray[i] := JsonToGuideSign(JSON.AsArray[i]);
  end;

end;

procedure TRsLCGuideSign.SignIn(guideSignEntity: RRsGuideSign);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['guideSignEntity'] := GuideSignToJson(guideSignEntity);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeamGuide.LCGuideSign.SignIn',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

end.
