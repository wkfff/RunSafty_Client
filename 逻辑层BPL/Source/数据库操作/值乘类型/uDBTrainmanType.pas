unit uDBTrainmanType;

interface
uses
  ADODB;
type
  TRsDBTrainmanType = class
  public
    class procedure GetTrainmanTypes(ADOConn : TADOConnection;out ADOQuery : TADOQuery);
  end;
implementation

{ TDBTrainmanType }

class procedure TRsDBTrainmanType.GetTrainmanTypes(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery);
var
  strSql : string;
begin
  strSql := 'select * from TAB_System_TrainmanType order by nTrainmanTypeID';
  ADOQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := ADOConn;
  ADOQuery.SQL.Text := strSql;
  ADOQuery.Open;
end;

end.
