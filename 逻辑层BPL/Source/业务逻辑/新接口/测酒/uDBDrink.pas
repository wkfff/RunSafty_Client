unit uDBDrink;

interface
uses
  ADODB,Classes,uDrink,uTFSystem,IdHTTP,IdMultipartFormData,IdGlobal,IdObjs,
  IdGlobalProtocols,superobject;
type
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
  TRsDBDrink = class(TDBOperate)
  public
    procedure QueryDrink(dtBeginTime,dtEndTime : TDateTime;strJwdId,PlaceId:string;
      WorkShopGUID,TrainmanName,TrainmanNumber : string;
      VerifyID,DrinkTypeID,DrinkResultID : integer;
      out DrinkArray : TRsDrinkArray);
    //根据车次和客户端获取从某个时间开始的人员最新测酒记录
    function GetTrainNoDrinkInfo(strTrainNo,strSiteNumber:string;ncount:Integer;
        dtStartTime:TDateTime;var DrinkArray : TRsDrinkArray ;var strErr:string):Boolean;
    //获取没有计划的测酒记录
    procedure QueryNoPlanDrink(dtBeginTime,dtEndTime : TDateTime;
    TrainmanNumber : string;DrinkTypeID:Integer;
    out DrinkArray : TRsDrinkArray);

    function GetDrinkInfo(strGUID: string; out Drink: RRsDrink): boolean;
    //根据客户端获取从某个时间开始的某个人的最后一条测酒记录
    function GetTMLastDrinkInfo(strSiteNumber,strTrainmanNumber:string;
        dtStartTime:TDateTime;out drinkInfo:RRsDrink;var strErr:string):Boolean;
    //修改测酒时间
    procedure UpdateDrinkTime(strGUID: string;DrinkTime:TDateTime);
  end;
implementation
uses
  SysUtils, DB, ZKFPEngXUtils;
{ TDBDrink }

function TRsDBDrink.GetTMLastDrinkInfo(strSiteNumber, strTrainmanNumber: string;
  dtStartTime: TDateTime; out drinkInfo: RRsDrink; var strErr: string): Boolean;
var
  qry:TADOQuery;
  strsql:string;
begin
  result := False;

  strsql := 'select top 1 strTrainmanGUID, strTrainmanNumber,strTrainmanName,dwAlcoholicity,nDrinkResult,dtCreateTime ' ;
  strsql := strsql + ' from TAB_Drink_Information  where dtcreatetime >= :dtStartTime and ' ;
  strsql := strsql + ' strTrainmanNumber = :strTrainmanNumber and strSiteNumber = :strSiteNumber ';
  strsql := strsql + ' order by dtcreateTime desc';

  qry := NewADOQuery();
  try
    try
      qry.SQL.Text := strsql;
      qry.Parameters.ParamByName('strTrainmanNumber').Value := strTrainmanNumber;
      qry.Parameters.ParamByName('strSiteNumber').Value := strSiteNumber;
      qry.Parameters.ParamByName('dtStartTime').Value := dtStartTime;
      qry.Open;
      if qry.RecordCount > 0 then
      begin
        drinkInfo.strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
        drinkInfo.strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
        drinkInfo.strTrainmanName := qry.FieldByName('strTrainmanName').Value;
        drinkInfo.dwAlcoholicity := qry.FieldByName('dwAlcoholicity').Value;
        drinkInfo.nDrinkResult := qry.FieldByName('nDrinkResult').Value;
        drinkInfo.dtCreateTime := qry.FieldByName('dtCreateTime').Value;
      end;
      result := True;
    except on e:Exception do
      strErr := 'GetTMLastDrinkInfo:'+e.Message;
    end;
  finally
    qry.Free;
  end;
end;

function TRsDBDrink.GetTrainNoDrinkInfo(strTrainNo, strSiteNumber: string;
  ncount: Integer; dtStartTime: TDateTime; var DrinkArray: TRsDrinkArray;
  var strErr: string): Boolean;
var
  qry:TADOQuery;
  i:Integer;
  strsql:string;
begin
  result := false;
  
  strsql := 'select top ' + IntToStr(ncount) + ' strTrainmanNumber,strTrainmanName,';
  strsql := strsql + 'strTrainmanGUID, dwAlcoholicity,nDrinkResult,dtCreateTime' ;
  strsql := strsql + ' from TAB_Drink_Information WHERE dtCreateTime in';
  strsql := strsql + '(select max(dtCreateTime) from TAB_Drink_Information ';
  strsql := strsql + ' where dtcreatetime >= :dtStartTime and strTrainNo = :strTrainNo ';
  strsql := strsql + ' and strSiteNumber = :strSiteNumber group by strTrainmanNumber)';
 // Box(strsql);
  qry := NewADOQuery();
  try
    try
      qry.SQL.Text := strsql;
      qry.Parameters.ParamByName('strTrainNo').DataType := ftWideString;
      qry.Parameters.ParamByName('strTrainNo').Value := strTrainNo;
      qry.Parameters.ParamByName('strSiteNumber').Value := strSiteNumber;
      qry.Parameters.ParamByName('dtStartTime').Value := dtStartTime;
      qry.Open;
      //SetLength(DrinkArray,qry.RecordCount);
      for i := 0 to qry.RecordCount - 1 do
      begin
        DrinkArray[i].strTrainmanGUID := qry.FieldByName('strTrainmanGUID').Value;
        DrinkArray[i].strTrainmanNumber := qry.FieldByName('strTrainmanNumber').Value;
        DrinkArray[i].strTrainmanName := qry.FieldByName('strTrainmanName').Value;
        DrinkArray[i].dwAlcoholicity := qry.FieldByName('dwAlcoholicity').Value;
        DrinkArray[i].nDrinkResult := qry.FieldByName('nDrinkResult').Value;
        DrinkArray[i].dtCreateTime := qry.FieldByName('dtCreateTime').Value;
        qry.Next;
      end;
      result := True;
    except on e:Exception do
      strErr := 'GetTrainNoDrinkInfo:'+e.Message;
    end;
  finally
    qry.Free;
  end;
end;

procedure TRsDBDrink.QueryDrink(dtBeginTime, dtEndTime: TDateTime; strJwdId,PlaceId:string;WorkShopGUID,
  TrainmanName, TrainmanNumber: string; VerifyID, DrinkTypeID,
  DrinkResultID: integer; out DrinkArray: TRsDrinkArray);
var
  adoQuery : TADOQuery;
  i : integer;
  strSql : string;
begin
  strSql := 'select * from VIEW_Drink_query where dtCreateTime >= %s and dtCreateTime <= %s ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtBeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtEndTime))]);

  if PlaceId  <> '' then
  begin
    strSql := strSql + ' and strPlaceID = %s ';
    strSql := Format(strSql,[QuotedStr(PlaceId)]);;
  end;

  if strJwdId <> '' then
  begin
    strSql := strSql + ' and strAreaGUID = %s ';
    strSql := Format(strSql,[QuotedStr(strJwdId)]);;
  end;

  if WorkShopGUID <> '' then
  begin
    strSql := strSql + ' and strWorkShopGUID = %s ';
    strSql := Format(strSql,[QuotedStr(WorkShopGUID)]);;
  end;

  if TrainmanNumber <> '' then
  begin
    strSql := strSql + ' and strTrainmanNumber = %s ';
    strSql := Format(strSql,[QuotedStr(TrainmanNumber)]);;
  end;
  if VerifyID > -1 then
  begin
    strSql := strSql + ' and nVerifyID = %d ';
    strSql := Format(strSql,[VerifyID]);;
  end;
  if DrinkTypeID > -1 then
  begin
    strSql := strSql + ' and nWorkTypeID = %d ';
    strSql := Format(strSql,[DrinkTypeID]);;
  end;
  if DrinkResultID > -1 then
  begin
    strSql := strSql + ' and nDrinkResult = %d ';
    strSql := Format(strSql,[DrinkResultID]);;
  end;
  if TrainmanName <> '' then
  begin
    strSql := strSql + ' and strTrainmanName like %s ';
    strSql := Format(strSql,[QuotedStr(TrainmanName + '%')]);;    
  end;
  strSql := strSql + ' order by dtCreateTime desc';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(DrinkArray,RecordCount);
      i := 0;
      while not eof do
      begin
        DrinkArray[i].strGUID := FieldByname('strGUID').AsString;
        DrinkArray[i].bLocalAreaTrainman := FieldByname('bLocalAreaTrainman').AsBoolean;
        //人员
        DrinkArray[i].strTrainmanGUID := FieldByname('strTrainmanGUID').AsString;
        DrinkArray[i].strTrainmanName := FieldByname('strTrainmanName').AsString;
        DrinkArray[i].strTrainmanNumber := FieldByname('strTrainmanNumber').AsString;
        //车次
        DrinkArray[i].strTrainNo := FieldByname('strTrainNo').AsString;
        DrinkArray[i].strTrainTypeName := FieldByname('strTrainTypeName').AsString;
        DrinkArray[i].strTrainNumber := FieldByname('strTrainNumber').AsString;
        //出勤点
        DrinkArray[i].strPlaceID := FieldByname('strPlaceID').AsString;
        DrinkArray[i].strPlaceName := FieldByname('strPlaceName').AsString;
        DrinkArray[i].strSiteGUID := FieldByname('strSiteGUID').AsString;
        DrinkArray[i].strSiteIp := FieldByName('strSiteNumber').AsString ;
        DrinkArray[i].strSiteName := FieldByname('strSiteName').AsString;

        DrinkArray[i].strDutyNumber := FieldByname('strDutyNumber').AsString;
        DrinkArray[i].strDutyName := FieldByname('strDutyName').AsString;

        //车间
        DrinkArray[i].strWorkShopGUID := FieldByname('strWorkShopGUID').AsString;
        DrinkArray[i].strWorkShopName := FieldByname('strWorkShopName').AsString;

        DrinkArray[i].strAreaGUID := FieldByname('strAreaGUID').AsString;
        //酒精度
        DrinkArray[i].dwAlcoholicity := FieldByname('dwAlcoholicity').AsInteger;

        DrinkArray[i].nDrinkResult := FieldByname('nDrinkResult').AsInteger;
        DrinkArray[i].strDrinkResultName := FieldByname('strDrinkResultName').AsString;
        DrinkArray[i].dtCreateTime := FieldByname('dtCreateTime').AsDateTime;
        DrinkArray[i].nVerifyID := FieldByname('nVerifyID').AsInteger;
        DrinkArray[i].strVerifyName := FieldByname('strVerifyName').AsString;
        DrinkArray[i].nWorkTypeID := FieldByname('nWorkTypeID').AsInteger;
        DrinkArray[i].strWorkTypeName := FieldByname('strWorkTypeName').AsString;


        inc(i);
        next;
      end;
    end;
  finally
    adoquery.Free;
  end;
end;
    
procedure TRsDBDrink.QueryNoPlanDrink(dtBeginTime, dtEndTime: TDateTime;
  TrainmanNumber: string; DrinkTypeID: Integer; out DrinkArray: TRsDrinkArray);
var
  adoQuery : TADOQuery;
  i : integer;
  strSql : string;
begin
  strSql := 'select * from VIEW_Drink_Query where dtCreateTime >= %s and dtCreateTime <= %s ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtBeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',dtEndTime))]);

  if TrainmanNumber <> '' then
  begin
    strSql := strSql + ' and strTrainmanNumber = %s ';
    strSql := Format(strSql,[QuotedStr(TrainmanNumber)]);;
  end;

  if DrinkTypeID > -1 then
  begin
    strSql := strSql + ' and nWorkTypeID = %d ';
    strSql := Format(strSql,[DrinkTypeID]);;
  end;

  strSql := strSql + ' and  (strWorkID = '''' or strWorkID is Null ) order by dtCreateTime desc';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(DrinkArray,RecordCount);
      i := 0;
      while not eof do
      begin
        DrinkArray[i].strGUID := FieldByname('strGUID').AsString;
        DrinkArray[i].bLocalAreaTrainman := FieldByname('bLocalAreaTrainman').AsBoolean;
        //人员
        DrinkArray[i].strTrainmanGUID := FieldByname('strTrainmanGUID').AsString;
        DrinkArray[i].strTrainmanName := FieldByname('strTrainmanName').AsString;
        DrinkArray[i].strTrainmanNumber := FieldByname('strTrainmanNumber').AsString;
        //车次
        DrinkArray[i].strTrainNo := FieldByname('strTrainNo').AsString;
        DrinkArray[i].strTrainTypeName := FieldByname('strTrainTypeName').AsString;
        DrinkArray[i].strTrainNumber := FieldByname('strTrainNumber').AsString;
        //出勤点
        DrinkArray[i].strPlaceID := FieldByname('strPlaceID').AsString;
        DrinkArray[i].strPlaceName := FieldByname('strPlaceName').AsString;
        DrinkArray[i].strSiteGUID := FieldByname('strSiteGUID').AsString;
        DrinkArray[i].strSiteName := FieldByname('strSiteName').AsString;
        DrinkArray[i].strSiteIp := FieldByname('strSiteNumber').AsString;

        //
        DrinkArray[i].strDutyNumber := FieldByname('strDutyNumber').AsString;
        DrinkArray[i].strDutyName := FieldByname('strDutyName').AsString;

        DrinkArray[i].strAreaGUID := FieldByname('strAreaGUID').AsString;
        //车间
        DrinkArray[i].strWorkShopGUID := FieldByname('strWorkShopGUID').AsString;
        DrinkArray[i].strWorkShopName := FieldByname('strWorkShopName').AsString;
        //酒精度
        DrinkArray[i].dwAlcoholicity := FieldByname('dwAlcoholicity').AsInteger;

        DrinkArray[i].nDrinkResult := FieldByname('nDrinkResult').AsInteger;
        DrinkArray[i].strDrinkResultName := FieldByname('strDrinkResultName').AsString;
        DrinkArray[i].dtCreateTime := FieldByname('dtCreateTime').AsDateTime;
        DrinkArray[i].nVerifyID := FieldByname('nVerifyID').AsInteger;
        DrinkArray[i].strVerifyName := FieldByname('strVerifyName').AsString;
        DrinkArray[i].nWorkTypeID := FieldByname('nWorkTypeID').AsInteger;
        DrinkArray[i].strWorkTypeName := FieldByname('strWorkTypeName').AsString;


        inc(i);
        next;
      end;
    end;
  finally
    adoquery.Free;
  end;
end;

procedure TRsDBDrink.UpdateDrinkTime(strGUID: string; DrinkTime: TDateTime);
var
  adoQuery : TADOQuery;
begin
  if strGUID = '' then exit;

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := Format('update  TAB_Drink_Information set dtCreateTime = ''%s'' where strGUID=''%s''', [FormatDateTime('yyyy-MM-DD HH:nn:ss',DrinkTime),strGUID]);
      ExecSQL
    end;
  finally
    adoquery.Free;
  end;
end;

function TRsDBDrink.GetDrinkInfo(strGUID: string; out Drink: RRsDrink): boolean;
var
  adoQuery : TADOQuery;
begin
  result := false;
  if strGUID = '' then exit;

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := Format('select * From VIEW_Drink_Query where strGUID=''%s''', [strGUID]);
      Open;
      if not eof then
      begin
        Drink.strGUID := FieldByname('strGUID').AsString;
        Drink.strTrainmanName := FieldByname('strTrainmanName').AsString;
        Drink.strTrainmanNumber := FieldByname('strTrainmanNumber').AsString;
        Drink.strWorkShopName := FieldByname('strWorkShopName').AsString;
        Drink.nDrinkResult := FieldByname('nDrinkResult').AsInteger;
        Drink.strDrinkResultName := FieldByname('strDrinkResultName').AsString;
        Drink.dtCreateTime := FieldByname('dtCreateTime').AsDateTime;
        Drink.nVerifyID := FieldByname('nVerifyID').AsInteger;
        Drink.strVerifyName := FieldByname('strVerifyName').AsString;
        Drink.nWorkTypeID := FieldByname('nWorkTypeID').AsInteger;
        Drink.strWorkTypeName := FieldByname('strWorkTypeName').AsString;
        Drink.strPictureURL := Trim(FieldByname('strImagePath').AsString); 
        result := true;
      end;
      Close;
    end;
  finally
    adoquery.Free;
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

