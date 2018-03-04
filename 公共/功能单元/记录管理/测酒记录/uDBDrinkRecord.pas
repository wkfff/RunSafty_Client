unit uDBDrinkRecord;

interface
uses uTFSystem, uTrainman, uApparatusCommon, SysUtils, ADODB, DB;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TDBDrinkRecord
  /// ˵��:��Ƽ�¼������
  //////////////////////////////////////////////////////////////////////////////
  TDBDrinkRecord = class(TDBOperate)
  public
    {����:�����Ƽ�¼}
    procedure SaveDrinkRecord(Trainman:TTrainman;
        TestAlcoholInfo:RTestAlcoholInfo;AreaGUID,DutyGUID : string);
    {����:������Ա�Ƿ��ƺϸ�}
    function CheckTrainmanDrinkByTestTime(strTrainmanNumber:String;
        dtBeginTestTime:TDateTime;var strDrinkResultName:String):Boolean;
  public
    {����:�������Ͳ�ƽ�������ַ���}
    class function GetTestDrinkString(nValue:Integer):String;
    {����:�����ַ�����ƽ����������}
    class function GetTestDrinkInteger(strText:String):Integer;
  end;

implementation

{ TDBDrinkRecord }

function TDBDrinkRecord.CheckTrainmanDrinkByTestTime(strTrainmanNumber: String;
  dtBeginTestTime: TDateTime;var strDrinkResultName:String): Boolean;
{����:����ʱ���ȡ����Ա��Ƽ�¼}
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
{����:�����ַ�����ƽ����������}
begin
  Result := 0;
  if strText = '����' then
    Result := 1;
  if strText = '����' then
    Result := 2;
  if strText = '���' then
    Result := 3;
end;

class function TDBDrinkRecord.GetTestDrinkString(nValue: Integer): String;
{����:�������Ͳ�ƽ�������ַ���}
begin
  Result := 'δ����';
  case nValue of
    1 : Result := '����';
    2 : Result := '����';
    3 : Result := '���';
  end;
end;

procedure TDBDrinkRecord.SaveDrinkRecord(Trainman: TTrainman;
  TestAlcoholInfo: RTestAlcoholInfo;AreaGUID,DutyGUID : string);
{����:�����Ƽ�¼}
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
