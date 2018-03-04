unit uDBCheckICCarRecord;

interface
uses uTFSystem, uTrainman, uApparatusCommon, SysUtils, ADODB, DB,
    uCheckICCarRecord,DateUtils;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBDrinkRecord
  /// 说明:测酒记录管理类
  //////////////////////////////////////////////////////////////////////////////
  TDBCheckICCarRecord = class(TDBOperate)
  public
    {功能:根据区域ID获得当前最大的记录ID}
    function GetMaxRecordIDByArea(strAreaGUID:String):Integer;
    {功能:保存验卡记录}
    procedure SaveCheckICCarRecordList(CheckICCarRecordList : TCheckICCarRecordList);
  end;



implementation

{ TDBCheckICCarRecord }

function TDBCheckICCarRecord.GetMaxRecordIDByArea(strAreaGUID: String): Integer;
{功能:根据区域ID获得当前最大的记录ID}
begin
  m_ADOQuery.SQL.Text := 'select Max(nRecordID) from TAB_Record_ICCarCheck '+
        ' Where strAreaGUID = ' + QuotedStr(strAreaGUID);
  m_ADOQuery.Open;
  Result := m_ADOQuery.Fields[0].AsInteger;
  m_ADOQuery.Close;
end;

procedure TDBCheckICCarRecord.SaveCheckICCarRecordList(
  CheckICCarRecordList: TCheckICCarRecordList);
{功能:保存验卡记录}
var
  i : Integer;
  strSQLText : String;
  strDateTime : String;
  Item : TCheckICCarRecord;
begin
  for I := 0 to CheckICCarRecordList.Count - 1 do
  begin
    Item := CheckICCarRecordList.Items[i];
    if Item.strWorkID = '' then
    begin
      strDateTime :=
          formatDateTime('yyyy-mm-dd hh:nn:ss',IncHour(Item.dtCreateTime,-1));

      strSQLText := 'Select strGUID from TAB_WORK_TrainmanBeginWork Where '+
          '((strTrainmanGUID1 = '+QuotedStr(Item.strTrainmanGUID)+') or '+
          ' (strTrainmanGUID2 = '+QuotedStr(Item.strTrainmanGUID)+')) And '+
          ' (dtCreateTime > '+QuotedStr(strDateTime)+') '+
          ' Order by dtCreateTime Desc ';
      m_ADOQuery.SQL.Text := strSQLText;
      m_ADOQuery.Open;
      if m_ADOQuery.RecordCount > 0 then
        Item.strWorkID := Trim(m_ADOQuery.Fields[0].AsString);
      m_ADOQuery.Close;
    end;

    Item := CheckICCarRecordList.Items[i];
    strSQLText := 'Insert Into TAB_Record_ICCarCheck (strGUID,strTrainmanGUID,'+
        'dtCreateTime,strCheckResult,nJSCount,nTsJsCount,strWorkID,strAreaGUID,'+
        'nRecordID) Values('+QuotedStr(Item.GUID)+','+
        QuotedStr(Item.strTrainmanGUID)+','+
        QuotedStr(formatDateTime('yyyy-mm-dd hh:nn:ss',Item.dtCreateTime))+','+
        QuotedStr(Item.strCheckResult)+','+IntToStr(Item.nJSCount)+','+
        IntToStr(Item.nTsJsCount)+','+QuotedStr(Item.strWorkID)+','+
        QuotedStr(Item.strAreaGUID)+','+IntToStr(Item.nRecordID)+')';

    m_ADOQuery.SQL.Text := strSQLText;
    m_ADOQuery.ExecSQL;
  end;
end;

end.
