unit uDBEndWorkRecord;


interface

uses uTFSystem, uTrainman, uApparatusCommon, SysUtils, ADODB, DB, uEndWorkRecord;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBEndWorkRecord
  /// 说明:退勤记录管理类
  //////////////////////////////////////////////////////////////////////////////
  TDBEndWorkRecord = class(TDBOperate)
  private
    {功能:从数据源中拷贝信息到退勤记录对象中}
    procedure DBToEndWorkRecord(Item:TEndWorkRecord;
        SourceADOQuery:TADOQuery);
    {功能:从数据源中拷贝信息到退勤扩展记录对象中}
    procedure DBToEndWorkRecordEx(EndWorkRecordEx:TEndWorkRecordEx;
        SourceADOQuery:TADOQuery);

  public
    {功能:保存退勤记录}
    procedure SaveEndWorkRecord(Item:TEndWorkRecord);
    {功能:获得扩展退勤记录列表}
    procedure GetEndWorkRecordExList(dtBeginDate,dtEndDate:TDateTime;
        strAreaGUID:String;EndWorkRecordExList:TEndWorkRecordExList);
    {功能:获得扩展退勤记录列表}
    class procedure GetEndWorkRecordByGUID(EndWorkGUID : string;out Rlt : TADOQuery;ADOConn : TADOConnection);
    {功能:获得指定日期范围内的退勤记录}
    class procedure GetEndWorks(AreaGUID : string ; beginDate,endDate : TDateTime;out Rlt : TADOQuery; ADOConn : TADOConnection);     
  end;



implementation
uses
  DateUtils;
{ TDBEndWorkRecord }

procedure TDBEndWorkRecord.DBToEndWorkRecord(Item: TEndWorkRecord;
  SourceADOQuery: TADOQuery);
{功能:从数据源中拷贝信息到退勤记录对象中}
begin
  Item.strGUID :=
      Trim(SourceADOQuery.FieldByName('strGUID').AsString);

  Item.strCheCi :=
      Trim(SourceADOQuery.FieldByName('strCheCi').AsString);

  Item.strTrainType :=
      Trim(SourceADOQuery.FieldByName('strTrainType').AsString);

  Item.strTrainNumber :=
      Trim(SourceADOQuery.FieldByName('strTrainNumber').AsString);

  Item.strKeHuo :=
      Trim(SourceADOQuery.FieldByName('strKeHuo').AsString);

  Item.dtKaiCheTime :=
      SourceADOQuery.FieldByName('dtKaiCheTime').AsDateTime;

  Item.dtDaoDaTime :=
      SourceADOQuery.FieldByName('dtDaoDaTime').AsDateTime;


  Item.strTrainmanGUID1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanGUID1').AsString);

  Item.nTrainmanVerifyID1 :=
      SourceADOQuery.FieldByName('nTrainmanVerifyID1').AsInteger;

  Item.strTrainmanGUID2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanGUID2').AsString);

  Item.nTrainmanVerifyID2 :=
      SourceADOQuery.FieldByName('nTrainmanVerifyID2').AsInteger;

  Item.strAreaGUID :=
      Trim(SourceADOQuery.FieldByName('strAreaGUID').AsString);

  Item.dtCreateTime :=
      SourceADOQuery.FieldByName('dtCreateTime').AsDateTime;

  Item.strDutyGUID :=
      Trim(SourceADOQuery.FieldByName('strDutyGUID').AsString);
end;

procedure TDBEndWorkRecord.DBToEndWorkRecordEx(
  EndWorkRecordEx: TEndWorkRecordEx; SourceADOQuery: TADOQuery);
{功能:从数据源中拷贝信息到退勤扩展记录对象中}
begin
  DBToEndWorkRecord(EndWorkRecordEx,SourceADOQuery);
  EndWorkRecordEx.strTrainmanName1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanName1').AsString);

  EndWorkRecordEx.strTrainmanNumber1 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanNumber1').AsString);

  EndWorkRecordEx.TestDrinkResult1 :=
      SourceADOQuery.FieldByName('TestDrinkResult1').AsInteger;

  EndWorkRecordEx.strTrainmanName2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanName2').AsString);

  EndWorkRecordEx.strTrainmanNumber2 :=
      Trim(SourceADOQuery.FieldByName('strTrainmanNumber2').AsString);

  EndWorkRecordEx.TestDrinkResult2 :=
      SourceADOQuery.FieldByName('TestDrinkResult2').AsInteger;
end;



class procedure TDBEndWorkRecord.GetEndWorkRecordByGUID(EndWorkGUID: string;
  out Rlt: TADOQuery; ADOConn: TADOConnection);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_TrainmanEndWork where strGUID = %s';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(EndWorkGUID)]);
  Rlt.Open;
end;

procedure TDBEndWorkRecord.GetEndWorkRecordExList(dtBeginDate,
  dtEndDate: TDateTime; strAreaGUID: String;
  EndWorkRecordExList: TEndWorkRecordExList);
{功能:获得扩展退勤记录列表}
var
  Item : TEndWorkRecordEx;
begin
  EndWorkRecordExList.Clear;
  m_ADOQuery.SQL.Text := 'Select * from VIEW_TrainmanEndWork where '+
      ' strAreaGUID = '+QuotedStr(strAreaGUID)+' And dtCreateTime >= '+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginDate))+
      ' And dtCreateTime <= '+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndDate));
  m_ADOQuery.Open;
  try
    while m_ADOQuery.Eof = False do
    begin
      Item := TEndWorkRecordEx.Create;
      DBToEndWorkRecordEx(Item,m_ADOQuery);
      EndWorkRecordExList.Add(Item);
      m_ADOQuery.Next;
    end;
  finally
    m_ADOQuery.Close;
  end;

end;

class procedure TDBEndWorkRecord.GetEndWorks(AreaGUID: string; beginDate,
  endDate: TDateTime;out Rlt : TADOQuery; ADOConn : TADOConnection);
var
  strSql : string;
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := ADOConn;
    strSql := 'select * from VIEW_TrainmanEndWork where strAreaGUID=%s and dtCreateTime >=%s and dtCreateTime <%s';
    strSql := Format(strSql,[QuotedStr(AreaGUID),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(beginDate))),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',DateOf(beginDate)+ 1))]);
    Sql.Text := strSql;
    Open;  
  end;
end;

procedure TDBEndWorkRecord.SaveEndWorkRecord(Item: TEndWorkRecord);
{功能:保存退勤记录}
begin
  m_ADOQuery.SQL.Text := 'Insert into TAB_WORK_TrainmanEndWork ('+
      'strGUID,strCheCi,strTrainNumber,strTrainType,strKeHuo,'+
      'dtKaiCheTime,dtDaoDaTime,strTrainmanGUID1,nTrainmanVerifyID1,strTrainmanGUID2,'+
      'nTrainmanVerifyID2,strAreaGUID,dtCreateTime,strDutyGUID,strEndStation) Values('+
      QuotedStr(Item.strGUID)+','+
      QuotedStr(Item.strCheCi)+','+
      QuotedStr(Item.strTrainNumber)+','+
      QuotedStr(Item.strTrainType)+','+
      QuotedStr(Item.strKeHuo)+','+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Item.dtKaiCheTime))+','+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Item.dtDaoDaTime))+','+
      QuotedStr(Item.strTrainmanGUID1)+','+
      IntToStr(Item.nTrainmanVerifyID1)+','+
      QuotedStr(Item.strTrainmanGUID2)+','+
      IntToStr(Item.nTrainmanVerifyID2)+','+
      QuotedStr(Item.strAreaGUID)+','+
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',Item.dtCreateTime))+','+
      QuotedStr(Item.strDutyGUID)+','+
      QuotedStr(Item.strEndStation)+')';
      
  m_ADOQuery.ExecSQL;

end;

end.
