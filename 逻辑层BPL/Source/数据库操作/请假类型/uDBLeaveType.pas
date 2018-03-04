unit uDBLeaveType;

interface
uses
  uAskForLeave,ADODB;
type
  //////////////////////////////////////////////////////////////////////////////
  ///请假类型操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBLeaveType = class
  public
    //功能：获取所有的请假类型
    class procedure GetAllLeaveType(ADOConn : TADOConnection ; out LeaveTypeArray : TRsLeaveTypeArray);
  end;

implementation

uses DB;

{ TDBLeaveType }

class procedure TRsDBLeaveType.GetAllLeaveType(ADOConn: TADOConnection;
  out LeaveTypeArray: TRsLeaveTypeArray);
var
  strSql : string;
  adoQuery : TADOQuery;
  i : integer;  
begin
  strSql := 'select * from TAB_System_LeaveType order by nLeaveTypeID';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      SetLength(LeaveTypeArray,RecordCount);
      i := 0;
      while not eof do
      begin
        LeaveTypeArray[i].nLeaveTypeID := FieldByName('nLeaveTypeID').AsInteger;
        LeaveTypeArray[i].strLeaveTypeName := FieldByName('strLeaveTypeName').AsString;        
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
