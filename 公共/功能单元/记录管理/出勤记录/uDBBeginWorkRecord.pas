unit uDBBeginWorkRecord;

interface
uses
  uTFSystem, uTrainman, uApparatusCommon, SysUtils, ADODB, DB,
  uBeginWorkRecord,uPlan;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBBeginWorkRecord
  /// 说明:出勤记录管理类
  //////////////////////////////////////////////////////////////////////////////
  TDBBeginWorkRecord = class(TDBOperate)
  private
    {功能:从数据源中拷贝信息到出勤记录对象中}
    procedure DBToBeginWorkRecord(BeginWorkRecord:TBeginWorkRecord;
        SourceADOQuery:TADOQuery);
    {功能:从数据源中拷贝信息到出勤扩展记录对象中}
    procedure DBToBeginWorkRecordEx(BeginWorkRecordEx:TBeginWorkRecordEx;
        SourceADOQuery:TADOQuery);
  public
    {功能:保存出勤记录}
    procedure SaveBeginWorkRecord(BeginWorkRecord:TBeginWorkRecord;plan : TPlan);
    {功能:获得扩展出勤记录列表}
    procedure GetBeginWorkRecordExList(dtBeginDate,dtEndDate:TDateTime;
        strAreaGUID:String;BeginWorkRecordExList:TBeginWorkRecordExList);
    class procedure GetOutDutyByGUID(strGUID : string;out Rlt : TADOQuery;ADOConn : TADOConnection);
    //查询叫班计划
    class procedure QueryBeginWorks(AreaGUID:string;beginDate,endDate : TDateTime;out Rlt  : TADOQuery;ADOConn : TADOConnection);
    //获取出勤计划乘务员的验卡结果
    class function GetPlanTrainmanCheckResult(planGUID,trainmanGUID : string; adoconn : TADOConnection):string;
  end;

implementation
uses
  DateUtils;
{ TDBBeginWorkRecord }

procedure TDBBeginWorkRecord.DBToBeginWorkRecord(
  BeginWorkRecord: TBeginWorkRecord; SourceADOQuery: TADOQuery);
{功能:从数据源中拷贝信息到出勤记录对象中}
begin
  BeginWorkRecord.strGUID :=
      Trim(SourceADOQuery.FieldByName('strGUID').AsString);

  BeginWorkRecord.strSectionName :=
      Trim(SourceADOQuery.FieldByName('strSectionName').AsString);

  BeginWorkRecord.strCheCi :=
      Trim(SourceADOQuery.FieldByName('strCheCi').AsString);

  BeginWorkRecord.strTrainType :=
      Trim(SourceADOQuery.FieldByName('strTrainType').AsString);

  BeginWorkRecord.strTrainNumber :=
      Trim(SourceADOQuery.FieldByName('strTrainNumber').AsString);

  BeginWorkRecord.strKeHuo :=
      Trim(SourceADOQuery.FieldByName('strKeHuo').AsString);

  BeginWorkRecord.dtKaiCheTime :=
      SourceADOQuery.FieldByName('dtKaiCheTime').AsDateTime;

  BeginWorkRecord.strTrainmanGUID1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanGUID1').AsString);

  BeginWorkRecord.nTrainmanVerifyID1 :=
      SourceADOQuery.FieldByName('nTrainmanVerifyID1').AsInteger;

  BeginWorkRecord.strTrainmanGUID2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanGUID2').AsString);

  BeginWorkRecord.nTrainmanVerifyID2 :=
      SourceADOQuery.FieldByName('nTrainmanVerifyID2').AsInteger;

  BeginWorkRecord.strAreaGUID :=
      Trim(SourceADOQuery.FieldByName('strAreaGUID').AsString);

  BeginWorkRecord.dtCreateTime :=
      SourceADOQuery.FieldByName('dtCreateTime').AsDateTime;

  BeginWorkRecord.strDutyGUID :=
      Trim(SourceADOQuery.FieldByName('strDutyGUID').AsString);

  BeginWorkRecord.strPlanGUID :=
      Trim(SourceADOQuery.FieldByName('strPlanGUID').AsString);


end;

procedure TDBBeginWorkRecord.DBToBeginWorkRecordEx(
  BeginWorkRecordEx: TBeginWorkRecordEx; SourceADOQuery: TADOQuery);
{功能:从数据源中拷贝信息到出勤扩展记录对象中}
begin
  DBToBeginWorkRecord(BeginWorkRecordEx,SourceADOQuery);
  BeginWorkRecordEx.strTrainmanName1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanName1').AsString);

  BeginWorkRecordEx.strTrainmanNumber1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanNumber1').AsString);

  BeginWorkRecordEx.CheckCardResult1 :=
      Trim(SourceADOQuery.FieldByName('CheckCardResult1').AsString);

  BeginWorkRecordEx.TestDrinkResult1 :=
      SourceADOQuery.FieldByName('TestDrinkResult1').AsInteger;

  BeginWorkRecordEx.strTrainmanName2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanName2').AsString);

  BeginWorkRecordEx.strTrainmanNumber2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanNumber2').AsString);

  BeginWorkRecordEx.CheckCardResult2 :=
      Trim(SourceADOQuery.FieldByName('CheckCardResult2').AsString);

  BeginWorkRecordEx.TestDrinkResult2 :=
      SourceADOQuery.FieldByName('TestDrinkResult2').AsInteger;
end;

procedure TDBBeginWorkRecord.GetBeginWorkRecordExList(dtBeginDate,
  dtEndDate: TDateTime; strAreaGUID: String;
  BeginWorkRecordExList: TBeginWorkRecordExList);
{功能:获得扩展出勤记录列表}
var
  Item : TBeginWorkRecordEx;
begin
  BeginWorkRecordExList.Clear;
  m_ADOQuery.SQL.Text := 'Select * from VIEW_TrainmanBeginWork where '+
      ' strAreaGUID = '+QuotedStr(strAreaGUID)+' And dtCreateTime >= '+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginDate))+
      ' And dtCreateTime <= '+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndDate));
  m_ADOQuery.Open;
  try
    while m_ADOQuery.Eof = False do
    begin
      Item := TBeginWorkRecordEx.Create;
      DBToBeginWorkRecordEx(Item,m_ADOQuery);
      BeginWorkRecordExList.Add(Item);
      m_ADOQuery.Next;
    end;
  finally
    m_ADOQuery.Close;
  end;
end;

class procedure TDBBeginWorkRecord.GetOutDutyByGUID(strGUID: string;
  out Rlt: TADOQuery; ADOConn: TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_TrainmanBeginWork where strPlanGUID = %s';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(strGUID)]);
  Rlt.Open;
end;

class function TDBBeginWorkRecord.GetPlanTrainmanCheckResult(planGUID,
  trainmanGUID: string; adoconn : TADOConnection): string;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := '';
  adoQuery := TADOQuery.Create(nil);
  with adoQuery do
  begin
    Connection := ADOConn;
    strSql := 'select top 1 * from VIEW_Plan_TrainmanCheckResult where strGUID=%s and strTrainmanGUID=%s';
    strSql := Format(strSql,[QuotedStr(planGUID), QuotedStr(trainmanGUID)]);
    Sql.Text := strSql;
    Open;
    if RecordCount > 0 then
      Result := FieldByName('strCheckResult').AsString;
  end;

end;

class procedure TDBBeginWorkRecord.QueryBeginWorks(AreaGUID: string; beginDate,
  endDate: TDateTime; out Rlt: TADOQuery; ADOConn: TADOConnection);
var
  strSql : string;
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    strSql := 'select * from VIEW_RestInWaiting_InOutRoom where strAreaGUID=%s and dtOutDutyTime >=%s and dtOutDutyTime <%s';
    strSql := Format(strSql,[QuotedStr(AreaGUID),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(beginDate))),
      QuotedStr(FormatDateTime('yyyy-MM-dd',DateOf(endDate)) + ' 23:59:59')]);
    Sql.Text := strSql;
    Open;
  end;
end;

procedure TDBBeginWorkRecord.SaveBeginWorkRecord(
  BeginWorkRecord: TBeginWorkRecord;plan : TPlan);
{功能:保存出勤记录}
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_WORK_TrainmanBeginWork where strPlanGUID = %s';
  strSql := Format(strSql,[QuotedStr(BeginWorkRecord.strPlanGUID)]);
  adoQuery := TADOQuery.Create(m_ADOConnection);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        Append;
        FieldByName('strGUID').AsString := (BeginWorkRecord.strGUID);
        FieldByName('strSectionName').AsString := (BeginWorkRecord.strSectionName);
        FieldByName('strCheCi').AsString := (BeginWorkRecord.strCheCi);
        FieldByName('strTrainNumber').AsString := (BeginWorkRecord.strTrainNumber);
        FieldByName('strTrainType').AsString := (BeginWorkRecord.strTrainType);
        FieldByName('strKeHuo').AsString := (BeginWorkRecord.strKeHuo);
        FieldByName('dtKaiCheTime').AsDateTime := BeginWorkRecord.dtKaiCheTime;
        FieldByName('strAreaGUID').AsString := (BeginWorkRecord.strAreaGUID);
        FieldByName('dtCreateTime').AsDateTime := BeginWorkRecord.dtCreateTime;
        FieldByName('strDutyGUID').AsString := (BeginWorkRecord.strDutyGUID);
        FieldByName('strPlanGUID').AsString := (BeginWorkRecord.strPlanGUID);
        if BeginWorkRecord.strTrainmanGUID1 <> '' then
        begin
          FieldByName('strTrainmanGUID1').AsString := (BeginWorkRecord.strTrainmanGUID1);
          FieldByName('nTrainmanVerifyID1').AsInteger := BeginWorkRecord.nTrainmanVerifyID1;
        end;
        if BeginWorkRecord.strTrainmanGUID2 <> '' then
        begin
          FieldByName('strTrainmanGUID2').AsString := (BeginWorkRecord.strTrainmanGUID2);
          FieldByName('nTrainmanVerifyID2').AsInteger := BeginWorkRecord.nTrainmanVerifyID2;
        end;
        Post;
        if plan.nTrainmanTypeID = 1 then
        begin
          SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID1=%s,nTrainmanState1=5,nState=5 where strGUID = %s';
          SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID1),QuotedStr(BeginWorkRecord.strPlanGUID)]);
          ExecSQL;
        end else begin
          if (BeginWorkRecord.strTrainmanGUID1 <> '') and (BeginWorkRecord.strTrainmanGUID2 <> '') then
          begin
            SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID1=%s,strTrainmanGUID2=%s,nTrainmanState1=5,nTrainmanState2=5,nState=5 where strGUID = %s';
            SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID1),QuotedStr(BeginWorkRecord.strTrainmanGUID2),QuotedStr(BeginWorkRecord.strPlanGUID)]);
            ExecSQL;
          end else begin
            if BeginWorkRecord.strTrainmanGUID1 <> '' then
            begin
              SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID1=%s ,nTrainmanState1=5 where strGUID = %s';
              SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID1),QuotedStr(BeginWorkRecord.strPlanGUID)]);
              ExecSQL;
            end;
            if BeginWorkRecord.strTrainmanGUID2 <> '' then
            begin
              SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID2=%s ,nTrainmanState2=5 where strGUID = %s';
              SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID2),QuotedStr(BeginWorkRecord.strPlanGUID)]);
              ExecSQL;
            end;
          end;
        end;        
      end else begin
        Edit;
        if BeginWorkRecord.strTrainmanGUID1 <> '' then
        begin
          FieldByName('strTrainmanGUID1').AsString := (BeginWorkRecord.strTrainmanGUID1);
          FieldByName('nTrainmanVerifyID1').AsInteger := BeginWorkRecord.nTrainmanVerifyID1;
        end;
        if BeginWorkRecord.strTrainmanGUID2 <> '' then
        begin
          FieldByName('strTrainmanGUID2').AsString := (BeginWorkRecord.strTrainmanGUID2);
          FieldByName('nTrainmanVerifyID2').AsInteger := BeginWorkRecord.nTrainmanVerifyID2;
        end;
        Post;
        
        if BeginWorkRecord.strTrainmanGUID1 <> '' then
        begin
          SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID1=%s ,nTrainmanState1=5,nState=5 where strGUID = %s';
          SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID1),QuotedStr(BeginWorkRecord.strPlanGUID)]);
          ExecSQL;
        end;

        if BeginWorkRecord.strTrainmanGUID2 <> '' then
        begin
          SQL.Text := 'update TAB_Plan_Record set strTrainmanGUID2=%s ,nTrainmanState2=5,nState=5 where strGUID = %s';
          SQL.Text := Format(SQL.Text,[QuotedStr(BeginWorkRecord.strTrainmanGUID2),QuotedStr(BeginWorkRecord.strPlanGUID)]);
          ExecSQL;
        end;
      end;

    end;  
  finally
    adoQuery.Free;
  end;


end;

end.
