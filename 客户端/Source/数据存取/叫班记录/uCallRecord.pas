unit uCallRecord;

interface

uses
  Classes,SysUtils,Forms,windows,adodb,StrUtils,utfsystem;
type
  TRoomPlanType = (rptForceSleep = 1 ,rptNormalSleep = 2 );
   //�а����ݽṹ
  TCallData = class
  public
    //����ʱ��
    dtDutyTime: TDateTime;
    //�а�ʱ��
    dtCallTime: TDateTime;
    //����
    strTrainNo: string;
    //�ƻ�GUID
    strGUID: string;
    //�ƻ�����(1��ǿ�ݣ�2������)
    nType: Integer;
    //�а�����(0��δ�а�;1���ѽа�;2����׷��)
    //�˴������ϴνа�ʱ����������ʾ
    nCallState: Integer;
    //�����
    strRoomNumber: string;
    //�豸ID
    nDeviceID: Integer;
    //�Ƿ���׷��
    bAlarm : boolean;
    //�ƻ�״̬
    nPlanState : integer;
    //�Ƿ�а�ɹ�
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

  //�а��¼����
  RCallRecordArray = array of RCallRecord ;

  TCallRecordOpt = class
  public
    //��ѯָ�����ڷ�Χ�ڵĽа��¼
    class procedure QueryRecord(ADOConn: TADOConnection;areaGUID : string;beginDate,endDate : TDateTime;
      strRoomNumber,strTrainNo : string;bIsRecall,bCallSucceed : integer;qxCount:integer;out Rlt  : TADOQuery);
    //��ȡָ��GUID�Ľа��¼
    class function GetRecord(ADOConn: TADOConnection;recordGUID : string): RCallRecord;
    //��ӽа��¼
    class function AddRecord(ADOConn: TADOConnection;callRecord:RCallRecord) : boolean;

  end;

  TDBCallRecord = class (TDBOperate)
  public
     //��ѯָ�����ڷ�Χ�ڵĽа��¼
     procedure QueryRecord(beginDate,endDate : TDateTime;strRoomNumber,strTrainNo : string;
      bIsRecall,bCallSucceed : integer;qxCount:integer;out CallRecordArray  : RCallRecordArray);
    //��ȡָ��GUID�Ľа��¼
    function GetRecord(recordGUID : string): RCallRecord;
    //��ӽа��¼
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
      //(��)
      //TBlobField(FieldByName('CallRecord')).LoadFromStream(callRecord.CallRecord);
      Post;
      Result := true;
      filename := callRecord.strRoomNumber +
        FormatDateTime('yyyymmddhhnn',FieldByName('dtCreateTime').AsDateTime) + '.wav';
    end;

    //(��)
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
          //(��)
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
