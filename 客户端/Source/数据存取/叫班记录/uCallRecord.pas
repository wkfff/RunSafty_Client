unit uCallRecord;

interface

uses
  Classes,SysUtils,Forms,windows,adodb,StrUtils,utfsystem;
type
  TRoomPlanType = (rptForceSleep = 1 ,rptNormalSleep = 2 );
   //叫班数据结构
  TCallData = class
  public
    //出勤时间
    dtDutyTime: TDateTime;
    //叫班时间
    dtCallTime: TDateTime;
    //车次
    strTrainNo: string;
    //计划GUID
    strGUID: string;
    //计划类型(1：强休；2：待乘)
    nType: Integer;
    //叫班类型(0：未叫班;1：已叫班;2：已追叫)
    //此处根据上次叫班时间来限制显示
    nCallState: Integer;
    //房间号
    strRoomNumber: string;
    //设备ID
    nDeviceID: Integer;
    //是否已追叫
    bAlarm : boolean;
    //计划状态
    nPlanState : integer;
    //是否叫班成功
    nCallSucceed : integer;
  end;
  RCallRecord = record
    strGUID : string;
    strPlanGUID : string;
    dtCreateTime : TDateTime;
    strRoomNumber : string;
    strTrainNo : string;
    bIsRecall : integer;
    bCallSucceed : integer;
    CallRecord : TMemoryStream;
    strDutyGUID : string;
    strAreaGUID : string;
    strFileName:string ;
  end;

  //叫班记录数组
  RCallRecordArray = array of RCallRecord ;

  TCallRecordOpt = class
  public
    //查询指定日期范围内的叫班记录
    class procedure QueryRecord(ADOConn: TADOConnection;areaGUID : string;beginDate,endDate : TDateTime;
      strRoomNumber,strTrainNo : string;bIsRecall,bCallSucceed : integer;qxCount:integer;out Rlt  : TADOQuery);
    //获取指定GUID的叫班记录
    class function GetRecord(ADOConn: TADOConnection;recordGUID : string): RCallRecord;
    //添加叫班记录
    class function AddRecord(ADOConn: TADOConnection;callRecord:RCallRecord) : boolean;

  end;

  TDBCallRecord = class (TDBOperate)
  public
     //查询指定日期范围内的叫班记录
     procedure QueryRecord(beginDate,endDate : TDateTime;strRoomNumber,strTrainNo : string;
      bIsRecall,bCallSucceed : integer;qxCount:integer;out CallRecordArray  : RCallRecordArray);
    //获取指定GUID的叫班记录
    function GetRecord(recordGUID : string): RCallRecord;
    //添加叫班记录
    function AddRecord(callRecord:RCallRecord) : boolean;
  private
    procedure AdoToData(ADOQery:TADOQuery;var callRecord:RCallRecord);
    procedure DataToAdo(ADOQery:TADOQuery; callRecord:RCallRecord);
  end;



implementation
uses
  uCallRoomDM,DB,uGlobalDM;
{ TCallRecordOpt }

class function TCallRecordOpt.AddRecord(ADOConn: TADOConnection;callRecord: RCallRecord): boolean;
var
  ado : TADOQuery;
  filename: string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from TAB_RestInWaiting_CallRecord where 1=2';
      Open;
      Append;
      FieldByName('strGUID').AsString := NewGUID;
      FieldByName('strPlanGUID').AsString := callRecord.strPlanGUID;
      FieldByName('dtCreateTime').AsDateTime := callRecord.dtCreateTime;
      FieldByName('strRoomNumber').AsString := callRecord.strRoomNumber;
      FieldByName('strTrainNo').AsString := callRecord.strTrainNo;
      FieldByName('bIsRecall').AsInteger := callRecord.bIsRecall;
      FieldByName('bCallSucceed').AsInteger := callRecord.bCallSucceed;
      FieldByName('strDutyGUID').AsString := callRecord.strDutyGUID;
      FieldByName('strAreaGUID').AsString := callRecord.strAreaGUID;
      //(闫)
      //TBlobField(FieldByName('CallRecord')).LoadFromStream(callRecord.CallRecord);
      Post;
      Result := true;
      filename := callRecord.strRoomNumber +
        FormatDateTime('yyyymmddhhnn',FieldByName('dtCreateTime').AsDateTime) + '.wav';
    end;

    //(闫)
    if not DirectoryExists(GlobalDM.AppPath + '\upload\callrecord') then
    begin
      ForceDirectories(GlobalDM.AppPath + '\upload\callrecord');
    end;
    callRecord.CallRecord.SaveToFile(GlobalDM.AppPath + '\upload\callrecord\' + filename);
    DMCallRoom.FTPCon.UpLoad(filename,False);

  finally
    ado.Free;
  end;
end;

class function TCallRecordOpt.GetRecord(ADOConn: TADOConnection;recordGUID: string): RCallRecord;
var
  ado : TADOQuery;
begin

  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from TAB_RestInWaiting_CallRecord where strGUID=%s';
      Sql.Text := Format(Sql.Text ,[QuotedStr(recordGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin

          strGUID := FieldByName('strGUID').AsString;
          strPlanGUID := FieldByName('strPlanGUID').AsString;
          dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
          strRoomNumber := Trim(FieldByName('strRoomNumber').AsString);
          strTrainNo := FieldByName('strTrainNo').AsString;
          bIsRecall := FieldByName('bIsRecall').AsInteger;
          bCallSucceed := FieldByName('bCallSucceed').AsInteger;
          strDutyGUID := FieldByName('strDutyGUID').AsString;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
          //(闫)
//          CallRecord := TMemoryStream.Create;
//          TBlobField(FieldByName('CallRecord')).SaveToStream(CallRecord);
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TCallRecordOpt.QueryRecord(ADOConn: TADOConnection;areaGUID : string;beginDate, endDate: TDateTime;
  strRoomNumber, strTrainNo: string; bIsRecall,
  bCallSucceed: integer;qxCount:integer;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  RLT.Connection := ADOConn ;
  RLT.SQL.Text := 'select (select count(*) from TAB_RoomWaiting_CallRecord where TAB_RoomWaiting_CallRecord.strGUID=VIEW_RestInWaiting_CallRecord.strPlanGUID) as QXCount ,* from VIEW_RestInWaiting_CallRecord where  dtCreateTime >= %s and dtCreateTime <=%s ';
  RLT.SQL.Text := Format(RLT.SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);

  if qxCount >=0 then
  begin
    RLT.SQL.Text :=  RLT.SQL.Text + ' and (select count(*) from TAB_RoomWaiting_CallRecord where TAB_RoomWaiting_CallRecord.strGUID=VIEW_RestInWaiting_CallRecord.strPlanGUID) = ' + IntToStr(qxCount);
  end;
  if Trim(strRoomNumber) <> '' then
  begin
    RLT.SQL.Text :=  RLT.SQL.Text + ' and strRoomNumber = ' + QuotedStr(strRoomNumber);
  end;

  if Trim(strTrainNo) <> '' then
  begin
    RLT.SQL.Text :=  RLT.SQL.Text + ' and strTrainNo = ' + QuotedStr(strTrainNo);
  end;

  if bIsRecall > -1 then
  begin
    RLT.SQL.Text :=  RLT.SQL.Text + ' and bIsRecall = ' + IntToStr(bIsRecall);
  end;

  if bCallSucceed > -1 then
  begin
    RLT.SQL.Text :=  RLT.SQL.Text + ' and bCallSucceed = ' + IntToStr(bCallSucceed);
  end;
  RLT.SQL.Text := RLT.SQL.Text + ' order by dtCreateTime desc';
  RLT.Open;
end;

{ TDBCallRecord }

function TDBCallRecord.AddRecord(callRecord: RCallRecord): boolean;
var
  adoQuery : TADOQuery ;
begin
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      Open;
      Append;
      DataToAdo(adoQuery,callRecord);
      Post;
      Result := true;
    end;
  finally
    adoQuery.Free ;
  end;
end;

procedure TDBCallRecord.AdoToData(ADOQery: TADOQuery;
  var callRecord: RCallRecord);
begin
  with callRecord do
  begin
    strGUID := ADOQery.FieldByName('strGUID').AsString;
    strPlanGUID := ADOQery.FieldByName('strPlanGUID').AsString;
    dtCreateTime := ADOQery.FieldByName('dtCreateTime').AsDateTime;
    strRoomNumber := Trim(ADOQery.FieldByName('strRoomNumber').AsString);
    strTrainNo := ADOQery.FieldByName('strTrainNo').AsString;
    bIsRecall := ADOQery.FieldByName('bIsRecall').AsInteger;
    bCallSucceed := ADOQery.FieldByName('bCallSucceed').AsInteger;
    strDutyGUID := ADOQery.FieldByName('strDutyGUID').AsString;
    strAreaGUID := ADOQery.FieldByName('strAreaGUID').AsString;
  end;
end;

procedure TDBCallRecord.DataToAdo(ADOQery: TADOQuery; callRecord: RCallRecord);
begin
  with ADOQery do
  begin
    FieldByName('strGUID').AsString := NewGUID;
    FieldByName('strPlanGUID').AsString := callRecord.strPlanGUID;
    FieldByName('dtCreateTime').AsDateTime := callRecord.dtCreateTime;
    FieldByName('strRoomNumber').AsString := callRecord.strRoomNumber;
    FieldByName('strTrainNo').AsString := callRecord.strTrainNo;
    FieldByName('bIsRecall').AsInteger := callRecord.bIsRecall;
    FieldByName('bCallSucceed').AsInteger := callRecord.bCallSucceed;
    FieldByName('strDutyGUID').AsString := callRecord.strDutyGUID;
    FieldByName('strAreaGUID').AsString := callRecord.strAreaGUID;
  end;
end;

function TDBCallRecord.GetRecord(recordGUID: string): RCallRecord;
var
  adoQuery : TADOQuery ;
  strSql : string ;
begin
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      strSql :=Format( 'select * from TAB_RestInWaiting_CallRecord where strGUID = %s',
        [QuotedStr(recordGUID)] );
      Sql.Text := strSql ;;
      Open;
      if RecordCount > 0 then
      begin
        AdoToData(adoQuery,Result);
      end;
    end;
  finally
    adoQuery.Free ;
  end;
end;

procedure TDBCallRecord.QueryRecord(beginDate, endDate: TDateTime;
  strRoomNumber, strTrainNo: string; bIsRecall, bCallSucceed, qxCount: integer;
  out CallRecordArray: RCallRecordArray);
var
  adoQuery : TADOQuery ;
  i : Integer ;
begin
  i := 0 ;
  adoQuery := NewADOQuery ;
  try
    with adoQuery do
    begin
      SQL.Text := 'select (select count(*) from TAB_RoomWaiting_CallRecord where TAB_RoomWaiting_CallRecord.strGUID=VIEW_RestInWaiting_CallRecord.strPlanGUID) as QXCount ,* from VIEW_RestInWaiting_CallRecord where  dtCreateTime >= %s and dtCreateTime <=%s ';
      SQL.Text := Format(SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);

      if qxCount >=0 then
      begin
        SQL.Text :=  SQL.Text + ' and (select count(*) from TAB_RoomWaiting_CallRecord where TAB_RoomWaiting_CallRecord.strGUID=VIEW_RestInWaiting_CallRecord.strPlanGUID) = ' + IntToStr(qxCount);
      end;
      if Trim(strRoomNumber) <> '' then
      begin
        SQL.Text :=  SQL.Text + ' and strRoomNumber = ' + QuotedStr(strRoomNumber);
      end;

      if Trim(strTrainNo) <> '' then
      begin
        SQL.Text :=  SQL.Text + ' and strTrainNo = ' + QuotedStr(strTrainNo);
      end;

      if bIsRecall > -1 then
      begin
        SQL.Text :=  SQL.Text + ' and bIsRecall = ' + IntToStr(bIsRecall);
      end;

      if bCallSucceed > -1 then
      begin
        SQL.Text :=  SQL.Text + ' and bCallSucceed = ' + IntToStr(bCallSucceed);
      end;
      SQL.Text := SQL.Text + ' order by dtCreateTime desc';
      Open;
      if adoQuery.RecordCount > 0 then
      begin
        SetLength(CallRecordArray,adoQuery.RecordCount);
        while not adoQuery.Eof do
        begin
          AdoToData(adoQuery,CallRecordArray[i]);
          Inc(i);
          adoQuery.Next ;
        end;
      end;
    end;
  finally
    adoQuery.Free ;
  end;
end;

end.
