unit uDBCallRecord;

interface

uses
  Classes,SysUtils,Forms,windows,adodb,uCallRecord,uTFSystem;
type
  //////////////////////////////////////////////////////////////////////////////
  ///叫班记录操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsCallRecordOpt = class
  public
    //功能：查询指定日期范围内的叫班记录
    class procedure QueryRecord(ADOConn : TADOConnection ;areaGUID : string;beginDate,endDate : TDateTime;
      strRoomNumber,strTrainNo : string;bIsRecall,bCallSucceed : integer;qxCount:integer;out Rlt  : TADOQuery);
    //功能：获取指定GUID的叫班记录
    class function GetRecord(ADOConn : TADOConnection ;recordGUID : string): RCallRecord;
    //功能：添加叫班记录
    class function AddRecord(ADOConn : TADOConnection ;callRecord:RCallRecord) : boolean;
  end;

implementation
uses
  DB;
{ TCallRecordOpt }

class function TRsCallRecordOpt.AddRecord(ADOConn : TADOConnection ;callRecord: RCallRecord): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from TAB_Plan_CallRecord where strTrainPlanGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(callRecord.strPlanGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Edit;
      end else begin
        Append;
        FieldByName('strTrainPlanGUID').AsString := callRecord.strPlanGUID;
        FieldByName('strRoomNumber').AsString := callRecord.strRoomNumber;
      end;
      if callRecord.bIsRecall = 0 then
      begin
        FieldByName('dtFirstCallTime').AsDateTime := callRecord.dtCreateTime;
        FieldByName('nFirstCallResult').AsInteger := callRecord.bCallSucceed;
        TBlobField(FieldByName('FirstCallRecord')).LoadFromStream(callRecord.CallRecord);
      end else begin
        FieldByName('dtSecondCallTime').AsDateTime := callRecord.dtCreateTime;
        FieldByName('nSecondCallResult').AsInteger := callRecord.bCallSucceed;
        TBlobField(FieldByName('SencondCallRecord')).LoadFromStream(callRecord.CallRecord);
      end;
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;


class function TRsCallRecordOpt.GetRecord(ADOConn : TADOConnection ;recordGUID: string): RCallRecord;
var
  ado : TADOQuery;
begin

  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Sql.Text := 'select * from view_RestInWaiting_CallRecord where strGUID=%s';
      Sql.Text := Format(Sql.Text ,[QuotedStr(recordGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        with Result do
        begin

          strGUID := FieldByName('strGUID').AsString;
          strPlanGUID := FieldByName('strPlanGUID').AsString;
          dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
          strRoomNumber := FieldByName('strRoomNumber').AsString;
          strTrainNo := FieldByName('strTrainNo').AsString;
          bIsRecall := FieldByName('bIsRecall').AsInteger;
          bCallSucceed := FieldByName('bCallSucceed').AsInteger;
          strDutyGUID := FieldByName('strDutyGUID').AsString;
          strAreaGUID := FieldByName('strAreaGUID').AsString;
          CallRecord := TMemoryStream.Create;
          TBlobField(FieldByName('CallRecord')).SaveToStream(CallRecord);
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TRsCallRecordOpt.QueryRecord(ADOConn : TADOConnection ;areaGUID : string;beginDate, endDate: TDateTime;
  strRoomNumber, strTrainNo: string; bIsRecall,
  bCallSucceed: integer;qxCount:integer;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  RLT.Connection := ADOConn;
  RLT.SQL.Text := 'select (select count(*) from TAB_RoomWaiting_CallRecord where TAB_RoomWaiting_CallRecord.strGUID=VIEW_RestInWaiting_CallRecord.strPlanGUID) as QXCount ,* from VIEW_RestInWaiting_CallRecord where strAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s ';
  RLT.SQL.Text := Format(RLT.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);

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

end.
