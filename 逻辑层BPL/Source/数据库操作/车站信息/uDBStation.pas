unit uDBStation;

interface
uses
  ADODB,SysUtils,uStation;
type
  //////////////////////////////////////////////////////////////////////////////
  ///��վ������
  //////////////////////////////////////////////////////////////////////////////
  TRsDBStation = class
  public
    //���ܣ���ȡ���еĳ�վ��Ϣ
    class procedure GetStations(ADOConn : TADOConnection;out ADOQuery: TADOQuery);
    //���ܣ�����ID��ȡ��վTMIS
    class function GetStationNumerByID(ADOConn : TADOConnection;strID: string): Integer;
    //���ܣ���ȡ��·��վ��Ϣ
    class function GetStationsOfJiaoJu(ADOConn : TADOConnection;strJiaoLuID: string): TRsStationArray;
    
  end;

implementation

{ TDBStation }

class function TRsDBStation.GetStationNumerByID(ADOConn: TADOConnection;
  strID: string): Integer;
var
  ADOQuery: TADOQuery;
begin
  Result := 0;
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := ADOConn;
    ADOQuery.SQL.Text := 'select * from TAB_Base_Station where strStationGUID = '
      + QuotedStr(strID);

    ADOQuery.Open();

    if ADOQuery.RecordCount > 0 then
      Result := ADOQuery.FieldByName('strStationNumber').AsInteger;
  finally
    ADOQuery.Free;
  end;
end;

class procedure TRsDBStation.GetStations(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery);
var
  strSql : string;
begin
  strSql := 'select * from TAB_Base_Station  order by strStationNumber';
  adoQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := ADOConn;
  ADOQuery.SQL.Text := strSql;
  ADOQuery.Open;
end;

class function TRsDBStation.GetStationsOfJiaoJu(ADOConn: TADOConnection;
  strJiaoLuID: string): TRsStationArray;
const
  QUERY_SQL = 'select B.strStationGUID,B.strStationNumber,B.strStationName from ' +
    'TAB_Base_StationInTrainJiaolu AS A ' +
    'inner join TAB_Base_Station AS B ON B.strStationGUID = A.strStationGUID ' +
    'where A.strTrainJiaoluGUID = %s order by nSortid';
var
  ADOQuery: TADOQuery;
  i: Integer;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := ADOConn;
    ADOQuery.SQL.Text := Format(QUERY_SQL,[QuotedStr(strJiaoLuID)]);


    ADOQuery.Open();

    SetLength(Result,ADOQuery.RecordCount);

    for I := 0 to ADOQuery.RecordCount - 1 do
    begin
      Result[i].strStationGUID :=  ADOQuery.FieldByName('strStationGUID').AsString;
      Result[i].strStationName :=  ADOQuery.FieldByName('strStationName').AsString;
      Result[i].strStationNumber :=  ADOQuery.FieldByName('strStationNumber').AsString;
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
