unit uDBStation;

interface
uses
  uStation,ADODB;
type
  TDBStation = class
  public
      //��ӳ�վ
    class procedure GetStation(var Station : RStation;ADOConn : TADOConnection);
    //��ӳ�վ
    class procedure AddStation(Station : RStation;ADOConn : TADOConnection);
    //ɾ����վ
    class procedure DeleteStation(Station : RStation;ADOConn : TADOConnection);
    //ɾ����վ
    class function  ExistStation(Station : RStation;ADOConn : TADOConnection) : boolean;
    //��ȡ���г�վ����
    class procedure GetStationArray(out StationArray : TStationArray;ADOConn : TADOConnection);
  end;
implementation
uses
  SysUtils, DB;

{ TDBStation }

class procedure TDBStation.AddStation(Station: RStation;
  ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'insert into TAB_System_Station (strStationName) values (%s)';
  strSql := Format(strSql,[QuotedStr(Station.strStationName)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBStation.DeleteStation(Station: RStation;
  ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'delete from TAB_System_Station where strStationName = %s';
  strSql := Format(strSql,[QuotedStr(Station.strStationName)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TDBStation.ExistStation(Station: RStation;
  ADOConn: TADOConnection): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 1 * from TAB_System_Station where strStationName = %s';
  strSql := Format(strSql,[QuotedStr(Station.strStationName)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      Result := RecordCount > 0;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBStation.GetStation(var Station: RStation;
  ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 1 * from TAB_System_Station where strStationName = %s';
  strSql := Format(strSql,[QuotedStr(Station.strStationName)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        Station.strGUID := FieldByName('strGUID').AsString;
        Station.strStationName := FieldByName('strStationName').AsString;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBStation.GetStationArray(out StationArray: TStationArray;
  ADOConn: TADOConnection);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_System_Station order by strStationName';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      SetLength(StationArray,RecordCount);
      i := 0;
      while not eof do
      begin
        StationArray[i].strGUID := FieldByName('strGUID').AsString;
        StationArray[i].strStationName := FieldByName('strStationName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
