unit uDBLine;

interface
uses
  ADODB,uLine;
type
  TRsDBLine = class
  public
    //获取区域内的线路信息(返回ADOQuery)
    class procedure GetLines(ADOConn :TADOConnection;out ADOQuery : TADOQuery;strAreaGUID : string);overload;
    //获取派班室管辖人员交路所属的线路信息(返回LINEArray)
    class procedure GetLines(ADOConn : TADOConnection;strSiteGUID : string; out LineArray : TRsLineArray); overload;
    //获取机调台管辖机车交路所属的线路纤细(返回LINEArray)
    class procedure GetLinesOfJiDiao(ADOConn : TADOConnection;strSiteGUID : string; out LineArray : TRsLineArray); overload;

  end;
implementation
{ TDBLine }
uses
  SysUtils, DB;
class procedure TRsDBLine.GetLines(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery;strAreaGUID : string);
var
  strSql : string;
begin
  strSql := 'select * from TAB_Base_Line where strAreaGUID=%s order by strAreaGUID,strLineName';
  strSql := Format(strSql,[QuotedStr(strAreaGUID)]);
  adoQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := ADOConn;
  ADOQuery.SQL.Text := strSql;
  ADOQuery.Open;
end;

class procedure TRsDBLine.GetLines(ADOConn: TADOConnection; strSiteGUID: string;
  out LineArray: TRsLineArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  SetLength(LineArray,0);
  strSql := 'select strLineGUID,strLineName from VIEW_Base_TrainmanJiaoluInSite where strSiteGUID=%s group by strLineGUID,strLineName order by strLineName';
  strSql := Format(strSql,[QuotedStr(strSiteGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(LineArray,recordCount);
      i := 0;
      while not eof do
      begin
        LineArray[i].strLineGUID := FieldByName('strLineGUID').AsString;
        LineArray[i].strLineName := FieldByName('strLineName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TRsDBLine.GetLinesOfJiDiao(ADOConn: TADOConnection;
  strSiteGUID: string; out LineArray: TRsLineArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  SetLength(LineArray,0);
  strSql := 'select strLineGUID,strLineName from VIEW_Base_TrainJiaoluInSite where strSiteGUID=%s group by strLineGUID,strLineName order by strLineName';
  strSql := Format(strSql,[QuotedStr(strSiteGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(LineArray,recordCount);
      i := 0;
      while not eof do
      begin
        LineArray[i].strLineGUID := FieldByName('strLineGUID').AsString;
        LineArray[i].strLineName := FieldByName('strLineName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

end.
