unit uLCDrink;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uDrink,uJsonSerialize,IdHTTP,
	IdMultipartFormData,IdGlobal,IdObjs,IdGlobalProtocols;
type	
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TDrinkQueryParam
  /// ˵��:��Ƽ�¼��ѯ����
  /////////////////////////////////////////////////////////////////////////////
  TDrinkQueryParam = Class(TPersistent)
  Protected
    //��ʼʱ��
    m_dtBeginTime : TDateTime;
    //����ʱ��
    m_dtEndTime : TDateTime;
    //�����ID
    m_strJwdId : string;
    //�ص�ID
    m_PlaceId : string;
    //����ID
    m_WorkShopGUID : string;
    //��Ա����                                          
    m_TrainmanName : string;
    //��Ա����
    m_TrainmanNumber : string;
    //��֤��ʽ
    m_VerifyID : Integer;
    //�������
    m_DrinkTypeID : Integer;
    //��ƽ��
    m_DrinkResultID : Integer;
    //����ID
    m_DepartmentID: string;
    //ְ��ID
    m_CadreTypeID: string;
  published
    //��ʼʱ��
    property dtBeginTime : TDateTime read m_dtBeginTime write m_dtBeginTime;
    //����ʱ��
    property dtEndTime : TDateTime read m_dtEndTime write m_dtEndTime;
    //�����ID
    property strJwdId : string read m_strJwdId write m_strJwdId;
    //�ص�ID
    property PlaceId : string read m_PlaceId write m_PlaceId;
    //����ID
    property WorkShopGUID : string read m_WorkShopGUID write m_WorkShopGUID;
    //��Ա����
    property TrainmanName : string read m_TrainmanName write m_TrainmanName;
    //��Ա����
    property TrainmanNumber : string read m_TrainmanNumber write m_TrainmanNumber;
    //��֤��ʽ
    property VerifyID : Integer read m_VerifyID write m_VerifyID;
    //�������
    property DrinkTypeID : Integer read m_DrinkTypeID write m_DrinkTypeID;
    //��ƽ��
    property DrinkResultID : Integer read m_DrinkResultID write m_DrinkResultID;
    property DepartmentID: string read m_DepartmentID write m_DepartmentID;
    property CadreTypeID: string read m_CadreTypeID write m_CadreTypeID;
  end;
  
  /////////////////////////////////////////////////////////////////////////////
  /// ����:TLCDrink
  /// ˵��:TLCDrink�ӿ���
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDrink = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //����:1.9.1    ��ȡ�����Ϣ
    procedure QueryDrink(QueryParam : TDrinkQueryParam;
      out drinkInfoArray : TRsDrinkArray);
    //����:1.9.2    �ϴ���Ƽ�¼
    procedure AddDrinkInfo(drinkInfo : RRsDrink);
    //����:1.9.3    ��ȡ�����ϸ
    function GetDrinkInfo(strGUID : String;out drinkInfo : RRsDrink): Boolean;
    //����:1.9.4    ���ݳ��κͿͻ��˻�ȡ��Ƽ�¼
    function GetTrainNoDrinkInfo(dtBeginTime : TDateTime;strTrainNo : String;
      strPlaceID : String;ncount : Integer;out drinkInfoArray : TRsDrinkArray;var strErr:string): Boolean;
    //����:1.9.5    ��ȡû�г��ڼƻ��Ĳ�Ƽ�¼
    procedure QueryNoPlanDrink(dtBeginTime,dtEndTime : TDateTime;
      TrainmanNumber : String;DrinkTypeID : Integer;out drinkInfoArray : TRsDrinkArray);
    //����:1.9.6    �ݿͻ��˻�ȡ��ĳ��ʱ�俪ʼ��ĳ���˵����һ����Ƽ�¼
    function GetTMLastDrinkInfo(strSiteNumber : String;strTrainmanNumber : String;
      dtStartTime : TDateTime;out drinkInfo : RRsDrink; var strErr: string): Boolean;
    //����:��ȡ��Ƽ�¼
    function GetTrainmanDrinkInfo(strTrainmanGUID : String;strTrainPlanGUID : String;
      WorkType : Integer;out drinkInfo : RRsDrink): Boolean;
  Private
    m_WebAPIUtils:TWebAPIUtils;
  public
    class function DrinkToJson(const drinkInfo : RRsDrink): ISuperObject;
    class function JsonToDrink(iJson: ISuperObject): RRsDrink;
  end;
  
  TRsDrinkImage = class
  public
    constructor Create(URLHost: string);
  private
    m_strURLHost: string;
  public
    function Post(strTrainmanNumber: string;Picture: TMemoryStream): string;

    function DownLoad(strURL: string;FileName: string): Boolean;

    property URLHost: string read m_strURLHost write m_strURLHost;
  end;
        
implementation

{ TRsLCDrink }

procedure TRsLCDrink.AddDrinkInfo(drinkInfo: RRsDrink);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['drinkInfo'] := DrinkToJson(drinkInfo);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.AddDrinkInfo',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCDrink.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

class function TRsLCDrink.DrinkToJson(const drinkInfo: RRsDrink): ISuperObject;
begin
  Result := SO;
  Result.S['strGUID'] := drinkInfo.strGUID;
  Result.I['nDrinkResult'] := drinkInfo.nDrinkResult;
  Result.S['dtCreateTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',drinkInfo.dtCreateTime);
  Result.I['nVerifyID'] := drinkInfo.nVerifyID;
  Result.I['nWorkTypeID'] := drinkInfo.nWorkTypeID;
  Result.S['strWorkTypeName'] := drinkInfo.strWorkTypeName;
  Result.S['strDrinkResultName'] := drinkInfo.strDrinkResultName;
  Result.S['strVerifyName'] := drinkInfo.strVerifyName;
  Result.S['strImagePath'] := drinkInfo.strPictureURL;
  Result.S['strTrainmanGUID'] := drinkInfo.strTrainmanGUID;
  Result.S['strTrainmanNumber'] := drinkInfo.strTrainmanNumber;
  Result.S['strTrainmanName'] := drinkInfo.strTrainmanName;
  Result.S['strTrainNo'] := drinkInfo.strTrainNo;
  Result.S['strTrainNumber'] := drinkInfo.strTrainNumber;
  Result.S['strTrainTypeName'] := drinkInfo.strTrainTypeName;
  Result.S['strPlaceID'] := drinkInfo.strPlaceID;
  Result.S['strPlaceName'] := drinkInfo.strPlaceName;
  Result.S['strSiteGUID'] := drinkInfo.strSiteGUID;
  Result.S['strSiteName'] := drinkInfo.strSiteName;
  Result.S['strWorkShopGUID'] := drinkInfo.strWorkShopGUID;
  Result.I['dwAlcoholicity'] := drinkInfo.dwAlcoholicity;
  Result.S['strWorkShopName'] := drinkInfo.strWorkShopName;
  Result.S['strWorkID'] := drinkInfo.strWorkID;
  Result.S['strAreaGUID'] := drinkInfo.strAreaGUID;
  Result.S['strDutyGUID'] := drinkInfo.strDutyGUID;
  Result.S['strDutyName'] := drinkInfo.strDutyName;
  Result.S['strDutyNumber'] := drinkInfo.strDutyNumber;
  Result.B['bLocalAreaTrainman'] := drinkInfo.bLocalAreaTrainman;
  Result.S['strSiteNumber'] := drinkInfo.strSiteIp;
end;

function TRsLCDrink.GetDrinkInfo(strGUID: String;
  out drinkInfo: RRsDrink): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strGUID'] := strGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.GetDrinkInfo',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];

  if Result then
  begin
    drinkInfo := JsonToDrink(Json.O['drinkInfo']);
  end;
end;
function TRsLCDrink.GetTMLastDrinkInfo(strSiteNumber, strTrainmanNumber: String;
  dtStartTime: TDateTime; out drinkInfo: RRsDrink; var strErr: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  bExist: Boolean;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['strSiteNumber'] := strSiteNumber;
    JSON.S['strTrainmanNumber'] := strTrainmanNumber;
    JSON.S['dtStartTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtStartTime);

    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.GetTMLastDrinkInfo',json.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
    bExist := JSON.B['bExist'];

    if bExist then
    begin
      drinkInfo := JsonToDrink(Json.O['drinkInfo']);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      strErr := 'GetTMLastDrinkInfo' + E.Message;
    end;
  end;

end;

function TRsLCDrink.GetTrainmanDrinkInfo(strTrainmanGUID,
  strTrainPlanGUID: String; WorkType: Integer;
  out drinkInfo: RRsDrink): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['strTrainmanGUID'] := strTrainmanGUID;
  JSON.S['strTrainPlanGUID'] := strTrainPlanGUID;
  JSON.I['WorkType'] := WorkType;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.GetTrainmanDrinkInfo',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];

  if Result then
  begin
    drinkInfo := JsonToDrink(Json.O['drinkInfo']);
  end;
end;

function TRsLCDrink.GetTrainNoDrinkInfo(dtBeginTime: TDateTime; strTrainNo,
  strPlaceID: String; ncount: Integer; out drinkInfoArray: TRsDrinkArray;
  var strErr: string): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  Result := False;
  try
    JSON := SO();
    JSON.S['dtBeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTime);
    JSON.S['strTrainNo'] := strTrainNo;
//    JSON.S['strSiteNumber'] := strSiteNumber;
    JSON.S['strPlaceID'] := strPlaceID;
    JSON.I['ncount'] := ncount;


    strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.GetTrainNoDrinkInfo',json.AsString);
    if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
    begin
      Raise Exception.Create(strResultText);
    end;

    Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
    Json := Json.O['drinkInfoArray'];
    SetLength(drinkInfoArray,Json.AsArray.Length);
    for I := 0 to Json.AsArray.Length - 1 do
    begin
      drinkInfoArray[i] := JsonToDrink(Json.AsArray[i]);
    end;
    Result := True;
  except
    on E: Exception do
    begin
      strErr := 'GetTrainNoDrinkInfo:' + E.Message;
    end;
  end;

end;
class function TRsLCDrink.JsonToDrink(iJson: ISuperObject): RRsDrink;
begin
  Result.strGUID := iJson.S['strGUID'];
  Result.nDrinkResult := iJson.I['nDrinkResult'];
  Result.dtCreateTime := StrToDateTimeDef(iJson.S['dtCreateTime'],0);
  Result.nVerifyID := iJson.I['nVerifyID'];
  Result.nWorkTypeID := iJson.I['nWorkTypeID'];
  Result.strWorkTypeName := iJson.S['strWorkTypeName'];
  Result.strDrinkResultName := iJson.S['strDrinkResultName'];
  Result.strVerifyName := iJson.S['strVerifyName'];
  Result.strPictureURL := iJson.S['strImagePath'];
  Result.strTrainmanGUID := iJson.S['strTrainmanGUID'];
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  Result.strTrainNo := iJson.S['strTrainNo'];
  Result.strTrainNumber := iJson.S['strTrainNumber'];
  Result.strTrainTypeName := iJson.S['strTrainTypeName'];
  Result.strPlaceID := iJson.S['strPlaceID'];
  Result.strPlaceName := iJson.S['strPlaceName'];
  Result.strSiteGUID := iJson.S['strSiteGUID'];
  Result.strSiteName := iJson.S['strSiteName'];
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  Result.dwAlcoholicity := iJson.I['dwAlcoholicity'];
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  Result.strWorkID := iJson.S['strWorkID'];
  Result.strAreaGUID := iJson.S['strAreaGUID'];
  Result.strDutyGUID := iJson.S['strDutyGUID'];
  Result.strDutyName := iJson.S['strDutyName'];
  Result.strDutyNumber := iJson.S['strDutyNumber'];
  Result.bLocalAreaTrainman := iJson.B['bLocalAreaTrainman'];
  Result.strSiteIp := iJson.S['strSiteNumber'];
  Result.strDepartmentID := iJson.S['strDepartmentID'];
  Result.strDepartmentName := iJson.S['strDepartmentName'];
  Result.nCadreTypeID := iJson.I['nCadreTypeID'];
  Result.strCadreTypeName := iJson.S['strCadreTypeName'];
end;

procedure TRsLCDrink.QueryDrink(QueryParam: TDrinkQueryParam;
  out drinkInfoArray: TRsDrinkArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.O['QueryParam'] := TJsonSerialize.Serialize(QueryParam);
  

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.QueryDrink',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Json := Json.O['drinkInfoArray'];
  SetLength(drinkInfoArray,Json.AsArray.Length);
  for I := 0 to Json.AsArray.Length - 1 do
  begin
    drinkInfoArray[i] := JsonToDrink(Json.AsArray[i]);
  end;
end;
procedure TRsLCDrink.QueryNoPlanDrink(dtBeginTime,dtEndTime: TDateTime;
  TrainmanNumber: String; DrinkTypeID: Integer;
  out drinkInfoArray: TRsDrinkArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.S['dtBeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTime);
  JSON.S['dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndTime);
  JSON.S['TrainmanNumber'] := TrainmanNumber;
  JSON.I['DrinkTypeID'] := DrinkTypeID;


  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDrink.QueryNoPlanDrink',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  Json := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Json := Json.O['drinkInfoArray'];
  SetLength(drinkInfoArray,Json.AsArray.Length);
  for I := 0 to Json.AsArray.Length - 1 do
  begin
    drinkInfoArray[i] := JsonToDrink(Json.AsArray[i]);
  end;
end;


{ TRsDrinkImage }

constructor TRsDrinkImage.Create(URLHost: string);
begin
  m_strURLHost := URLHost;
end;

function TRsDrinkImage.DownLoad(strURL, FileName: string): Boolean;
var
  idHttp: TIdHTTP;
  Stream: TMemoryStream;
begin
  Result := False;
  idHttp := TIdHTTP.Create(nil);
  Stream := TMemoryStream.Create;
  try
    try
      idHttp.Request.Pragma := 'no-cache';
      idHttp.Request.CacheControl := 'no-cache';
      idHttp.Request.Connection := 'close';
      idHttp.ConnectTimeout := 1000;
      idHttp.Get(strURL,Stream);

      Result := Stream.Size > 0;
      if Result then
        Stream.SaveToFile(FileName);
      
      idHttp.Disconnect();
    finally
      idHttp.Free;
      Stream.Free;
    end;
  except

  end;
end;

function TRsDrinkImage.Post(strTrainmanNumber: string;
  Picture: TMemoryStream): string;
const
  TempDrinkFile = 'DrinkImg.jpg';
var
  idHttp: TIdHTTP;
  PostStream: TIdMultiPartFormDataStream;
  ResponseStream: TIdStringStream;
  AValues: TIdStringList;
  strResult: string;
  iJSON: ISuperObject;
begin
  idHttp := TIdHTTP.Create(nil);
  AValues := TIdStringList.Create;
  AValues.Values['tid'] := strTrainmanNumber;

  PostStream:= TIdMultiPartFormDataStream.Create;
  ResponseStream := TIdStringStream.Create('');

  try
    idHttp.ConnectTimeout := 3000;
    Picture.Position := 0;
    
    PostStream.AddFormField('tid', AValues.Values['tid']);
    Picture.SaveToFile(ExtractFilePath(ParamStr(0)) + TempDrinkFile);
    PostStream.AddFile('drinkimg',ExtractFilePath(ParamStr(0)) + TempDrinkFile,'');
    idHttp.Request.Pragma := 'no-cache';
    idHttp.Request.CacheControl := 'no-cache';
    idHttp.Request.Connection := 'close';
    idHttp.Request.ContentType := PostStream.RequestContentType;

    idHttp.Post(m_strURLHost, PostStream, ResponseStream);

    strResult := ResponseStream.DataString;;

    if strResult <> '' then
    begin
      iJSON := SO(strResult);
      try
        if iJSON.B['nResult'] then
          Result := iJSON.S['strResult']
        else
          raise Exception.Create('�����Ƭ�ϴ�ʧ��!');
      finally
        iJSON := nil;
      end;
    end;

    
  finally
    ResponseStream.Free;
    PostStream.Free;
    AValues.Free;
    idHttp.Free;
  end;
end;
end.
