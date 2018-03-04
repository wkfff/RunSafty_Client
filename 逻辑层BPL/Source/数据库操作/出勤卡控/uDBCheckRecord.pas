unit uDBCheckRecord;

interface

uses
  uCheckRecord,ADODB;
type
  //////////////////////////////////////////////////////////////////////////////
  ///出勤卡控操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBCheckcRecord = class
  public
    class procedure GetTrainmanCheckRecord(ADOConn:TADOConnection;
      TrainNumber:string;CheckTime : TDateTime;out CheckRecordArray : TRsCheckRecordArray);
  end;
implementation
uses
  SysUtils,DateUtils;
{ TDBCheckcRecord }

class procedure TRsDBCheckcRecord.GetTrainmanCheckRecord(ADOConn: TADOConnection;
  TrainNumber: string; CheckTime: TDateTime;
  out CheckRecordArray: TRsCheckRecordArray);
const
  QUERY_SQL = 'select C.*,B.strPointName,B.nIsHold,B.nPointID '
    + 'from TAB_CheckPoint_Standard AS B '
    + 'Left Join (SELECT top 1 * FROM TAB_Plan_RunEvent_TrainmanDetail AS A '
    + 'where A.dtEventTime > %s and A.dtEventTime < %s AND A.strTrainmanNumber = %s order by a.dtEventTime desc) '
    + 'AS C ON  C.nEventID = B.nPointID ';
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
  dtMaxTime,dtMinTime : TDateTime;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      dtMaxTime := IncMinute(CheckTime,30);
      dtMinTime := IncMinute(CheckTime,-30);

      strSql := Format(QUERY_SQL,[
        QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss', dtMinTime)),
        QuotedStr(FormatDateTime('yyyy-MM-dd hh:nn:ss',dtMaxTime)),
        QuotedStr(TrainNumber)]);
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(CheckRecordArray,RecordCount);
      i := 0;
      while not eof do
      begin
        CheckRecordArray[i].nPointID := FieldByName('nPointID').AsInteger;
        CheckRecordArray[i].strPointName := FieldByName('strPointName').AsString;
        CheckRecordArray[i].nIsHold := FieldByName('nIsHold').AsInteger;
        if FieldByName('dtEventTime').IsNull then
        begin
          CheckRecordArray[i].strItemContent := '无记录';
          CheckRecordArray[i].nCheckResult := 1;
        end
        else
        begin
          CheckRecordArray[i].strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
          CheckRecordArray[i].strItemContent := FieldByName('strResult').AsString;
          CheckRecordArray[i].nCheckResult := FieldByName('nResultID').AsInteger;
          CheckRecordArray[i].dtCheckTime := FieldByName('dtEventTime').AsDateTime;
          CheckRecordArray[i].dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
        end;

        Inc(i);
        next;
      end;
    end;                    
  finally
    adoQuery.Free;
  end;
end;

end.
