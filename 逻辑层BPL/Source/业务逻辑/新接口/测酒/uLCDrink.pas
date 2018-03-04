unit uLCDrink;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uDrink,uJsonSerialize,IdHTTP,
	IdMultipartFormData,IdGlobal,IdObjs,IdGlobalProtocols;
type	
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TDrinkQueryParam
  /// 说明:测酒记录查询参数
  /////////////////////////////////////////////////////////////////////////////
  TDrinkQueryParam = Class(TPersistent)
  Protected
    //开始时间
    m_dtBeginTime : TDateTime;
    //结束时间
    m_dtEndTime : TDateTime;
    //机务段ID
    m_strJwdId : string;
    //地点ID
    m_PlaceId : string;
    //车间ID
    m_WorkShopGUID : string;
    //人员姓名                                          
    m_TrainmanName : string;
    //人员工号
    m_TrainmanNumber : string;
    //验证方式
    m_VerifyID : Integer;
    //测酒类型
    m_DrinkTypeID : Integer;
    //测酒结果
    m_DrinkResultID : Integer;
    //部门ID
    m_DepartmentID: string;
    //职务ID
    m_CadreTypeID: string;
  published
    //开始时间
    property dtBeginTime : TDateTime read m_dtBeginTime write m_dtBeginTime;
    //结束时间
    property dtEndTime : TDateTime read m_dtEndTime write m_dtEndTime;
    //机务段ID
    property strJwdId : string read m_strJwdId write m_strJwdId;
    //地点ID
    property PlaceId : string read m_PlaceId write m_PlaceId;
    //车间ID
    property WorkShopGUID : string read m_WorkShopGUID write m_WorkShopGUID;
    //人员姓名
    property TrainmanName : string read m_TrainmanName write m_TrainmanName;
    //人员工号
    property TrainmanNumber : string read m_TrainmanNumber write m_TrainmanNumber;
    //验证方式
    property VerifyID : Integer read m_VerifyID write m_VerifyID;
    //测酒类型
    property DrinkTypeID : Integer read m_DrinkTypeID write m_DrinkTypeID;
    //测酒结果
    property DrinkResultID : Integer read m_DrinkResultID write m_DrinkResultID;
    property DepartmentID: string read m_DepartmentID write m_DepartmentID;
    property CadreTypeID: string read m_CadreTypeID write m_CadreTypeID;
  end;
  
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TLCDrink
  /// 说明:TLCDrink接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDrink = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:1.9.1    获取测酒信息
    procedure QueryDrink(QueryParam : TDrinkQueryParam;
      out drinkInfoArray : TRsDrinkArray);
    //功能:1.9.2    上传测酒记录
    procedure AddDrinkInfo(drinkInfo : RRsDrink);
    //功能:1.9.3    获取测酒明细
    function GetDrinkInfo(strGUID : String;out drinkInfo : RRsDrink): Boolean;
    //功能:1.9.4    根据车次和客户端获取测酒记录
    function GetTrainNoDrinkInfo(dtBeginTime : TDateTime;strTrainNo : String;
      strPlaceID : String;ncount : Integer;out drinkInfoArray : TRsDrinkArray;var strErr:string): Boolean;
    //功能:1.9.5    获取没有出勤计划的测酒记录
    procedure QueryNoPlanDrink(dtBeginTime,dtEndTime : TDateTime;
      TrainmanNumber : String;DrinkTypeID : Integer;out drinkInfoArray : TRsDrinkArray);
    //功能:1.9.6    据客户端获取从某个时间开始的某个人的最后一条测酒记录
    function GetTMLastDrinkInfo(strSiteNumber : String;strTrainmanNumber : String;
      dtStartTime : TDateTime;out drinkInfo : RRsDrink; var strErr: string): Boolean;
    //功能:获取测酒记录
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
          raise Exception.Create('测酒照片上传失败!');
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
