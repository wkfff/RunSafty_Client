unit uRsDBChangeLog;

interface
uses
  ADODB,uTFSystem,SysUtils;
type
  TRsDBChangeLog = class(TDBOperate)
  public
    procedure WriteChangeLog(strKeyValue,strRecordType,strFieldType,strNewValue,strRemark: string);
  end;
implementation

{ TRsDBChangeLog }

procedure TRsDBChangeLog.WriteChangeLog(strKeyValue,strRecordType, strFieldType,
  strNewValue, strRemark: string);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'insert into TAB_Data_ChangeLog (strKeyValue,strRecordType,strFieldType,'
      + 'strNewValue,strRemark) Values (%s,%s,%s,%s,%s)';
    ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[
      QuotedStr(strKeyValue),
      QuotedStr(strRecordType),
      QuotedStr(strFieldType),
      QuotedStr(strNewValue),
      QuotedStr(strRemark)]);
    ADOQuery.ExecSQL;

  finally
    ADOQuery.Free;
  end;
end;

end.
