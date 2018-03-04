unit uDBKeHuo;

interface

uses
  uKeHuo,ADODB;
type
  //////////////////////////////////////////////////////////////////////////////
  ///客货类型操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBKeHuo = class
  public
    //功能：获取所有的客货信息
    class procedure GetKeHuos(ADOConn : TADOConnection;out KeHuoArray:TRsKeHuoArray);
  end;
implementation

uses DB;

{ TDBKeHuo }

class procedure TRsDBKeHuo.GetKeHuos(ADOConn: TADOConnection;
  out KeHuoArray: TRsKeHuoArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from tab_System_KeHuo order by nKehuoID';
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(KeHuoArray,RecordCount);
      i := 0;
      while not eof do
      begin
        KeHuoArray[i].nKehuoID := FieldByName('nKehuoID').AsInteger;
        KeHuoArray[i].strKeHuoName := FieldByName('strKeHuoName').AsString;
        inc(i);     
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
