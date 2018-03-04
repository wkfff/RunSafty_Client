unit uDBDrinkRecord;

interface
uses uTFSystem, uTrainman, uApparatusCommon, SysUtils, ADODB, DB;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBDrinkRecord
  /// 说明:测酒记录管理类
  //////////////////////////////////////////////////////////////////////////////
  TDBDrinkRecord = class(TDBOperate)
  public
    {功能:保存测酒记录}
    procedure SaveDrinkRecord(Trainman:TTrainman;
        TestAlcoholInfo:RTestAlcoholInfo;AreaGUID,DutyGUID : string);
    {功能:检查乘务员是否测酒合格}
    function CheckTrainmanDrinkByTestTime(strTrainmanNumber:String;
        dtBeginTestTime:TDateTime;var strDrinkResultName:String):Boolean;
  public
    {功能:根据整型测酒结果返回字符串}
    class function GetTestDrinkString(nValue:Integer):String;
    {功能:根据字符串测酒结果返回整型}
    class function GetTestDrinkInteger(strText:String):Integer;
  end;

implementation

{ TDBDrinkRecord }

function TDBDrinkRecord.CheckTrainmanDrinkByTestTime(strTrainmanNumber: String;
  dtBeginTestTime: TDateTime;var strDrinkResultName:String): Boolean;
{功能:根据时间获取乘务员测酒记录}
begin
  Result := False;
  m_ADOQuery.SQL.Text :=
      'Select strDrinkResultName from VIEW_Drink_Information '+
      'where strTrainmanNumber = '+
      QuotedStr(strTrainmanNumber)+' And dtCreateTime >= '+
      QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTestTime))+
      ' Order by nDrinkResult';
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount = 0 then
  begin
    m_ADOQuery.Close;
    Exit;
  end;

  strDrinkResultName :=
      Trim(m_ADOQuery.FieldByName('strDrinkResultName').AsString);

  Result := True;
  m_ADOQuery.Close;
end;

class function TDBDrinkRecord.GetTestDrinkInteger(strText: String): Integer;
{功能:根据字符串测酒结果返回整型}
begin
  Result := 0;
  if strText = '正常' then
    Result := 1;
  if strText = '饮酒' then
    Result := 2;
  if strText = '酗酒' then
    Result := 3;
end;

class function TDBDrinkRecord.GetTestDrinkString(nValue: Integer): String;
{功能:根据整型测酒结果返回字符串}
begin
  Result := '未测试';
  case nValue of
    1 : Result := '正常';
    2 : Result := '饮酒';
    3 : Result := '酗酒';
  end;
end;

procedure TDBDrinkRecord.SaveDrinkRecord(Trainman: TTrainman;
  TestAlcoholInfo: RTestAlcoholInfo;AreaGUID,DutyGUID : string);
{功能:保存测酒记录}
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'Select * from TAB_Drink_Information where strWorkID = %s and strTrainmanGUID=%s';
  strSql := Format(strSql,[QuotedStr(Trainman.StateInfo.Properties[PROPERTIES_WORKID]),QuotedStr(Trainman.GUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;
      if RecordCount = 0 then
      begin
        Append;
        FieldByName('strTrainmanGUID').AsString := Trainman.GUID;
        TestAlcoholInfo.Picture.Position := 0;
        (FieldByName('DrinkImage') As TBlobField).LoadFromStream(TestAlcoholInfo.Picture);
        FieldByName('dtCreateTime').AsDateTime := Now;
        FieldByName('strAreaGUID').AsString :=AreaGUID;
        FieldByName('strDutyGUID').AsString :=DutyGUID;
        case TestAlcoholInfo.taTestAlcoholResult of
          taNormal : FieldByName('nDrinkResult').AsInteger := 1;
          taAlcoholContentMiddling : FieldByName('nDrinkResult').AsInteger := 2;
          taAlcoholContentHeight : FieldByName('nDrinkResult').AsInteger := 3;
        end;
        FieldByName('nVerifyID').AsInteger := Trainman.StateInfo.Properties[PROPERTIES_REGISTERFLAG];
        FieldByName('strWorkID').AsString := Trainman.StateInfo.Properties[PROPERTIES_WORKID];
      end else begin
        Edit;
        TestAlcoholInfo.Picture.Position := 0;
        (FieldByName('DrinkImage') As TBlobField).LoadFromStream(TestAlcoholInfo.Picture);
        FieldByName('dtCreateTime').AsDateTime := Now;
        FieldByName('strAreaGUID').AsString :=Trainman.StateInfo.Properties[PROPERTIES_AREAGUID];
        FieldByName('strDutyGUID').AsString :=Trainman.StateInfo.Properties[PROPERTIES_DUTYUSERID];
        case TestAlcoholInfo.taTestAlcoholResult of
          taNormal : FieldByName('nDrinkResult').AsInteger := 1;
          taAlcoholContentMiddling : FieldByName('nDrinkResult').AsInteger := 2;
          taAlcoholContentHeight : FieldByName('nDrinkResult').AsInteger := 3;
        end;
        FieldByName('nVerifyID').AsInteger := Trainman.StateInfo.Properties[PROPERTIES_REGISTERFLAG];
      end;
      Post;
    end;
  finally
    adoQuery.Free;
  end;

end;

end.
