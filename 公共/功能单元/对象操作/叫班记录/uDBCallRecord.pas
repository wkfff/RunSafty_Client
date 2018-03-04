unit uDBCallRecord;

interface
uses
  Classes,ADODB,uCallRecord;
type
  TDBCallRecord = class
  public
    //查询指定日期范围内的叫班记录
    class procedure QueryRecord(areaGUID : string;beginDate,endDate : TDateTime;
      strRoomNumber,strTrainNo : string;bIsRecall,bCallSucceed : integer;out Rlt  : TADOQuery);
    //获取指定GUID的叫班记录
    class function GetRecord(recordGUID : string): RCallRecord;
    //添加叫班记录
    class function AddRecord(callRecord:RCallRecord) : boolean;

  end;
implementation
uses
  uGlobalDM,DB,SysUtils;
{ TCallRecordOpt }

class function TDBCallRecord.AddRecord(callRecord: RCallRecord): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
      Sql.Text := 'select * from TAB_RestInWaiting_CallRecord where 1=2';
      Open;
      Append;
      FieldByName('strGUID').AsString := TGlobalDM.NewGUID;
      FieldByName('strPlanGUID').AsString := callRecord.strPlanGUID;
      FieldByName('dtCreateTime').AsDateTime := callRecord.dtCreateTime;
      FieldByName('strRoomNumber').AsString := callRecord.strRoomNumber;
      FieldByName('strTrainNo').AsString := callRecord.strTrainNo;
      FieldByName('bIsRecall').AsInteger := callRecord.bIsRecall;
      FieldByName('bCallSucceed').AsInteger := callRecord.bCallSucceed;
      FieldByName('strDutyGUID').AsString := callRecord.strDutyGUID;
      FieldByName('strAreaGUID').AsString := callRecord.strAreaGUID;
      TBlobField(FieldByName('CallRecord')).LoadFromStream(callRecord.CallRecord);
      Post;
      Result := true;
    end;
  finally
    ado.Free;
  end;
end;

class function TDBCallRecord.GetRecord(recordGUID: string): RCallRecord;
var
  ado : TADOQuery;
begin

  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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

class procedure TDBCallRecord.QueryRecord(areaGUID : string;beginDate, endDate: TDateTime;
  strRoomNumber, strTrainNo: string; bIsRecall,
  bCallSucceed: integer;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  RLT.Connection := GlobalDM.ADOConn;
  RLT.SQL.Text := 'select * from VIEW_RestInWaiting_CallRecord where strAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s ';
  RLT.SQL.Text := Format(RLT.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);

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
