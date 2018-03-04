unit uDBTrainType;

interface

uses
  Classes,ADODB,uTrainType,uSaftyEnum;
type
  //////////////////////////////////////////////////////////////////////////////
  ///�������Ͳ�����
  //////////////////////////////////////////////////////////////////////////////
  TRsDBTrainType = class
  public
    //���ܣ���ȡ��������,����ADOQuery
    class procedure GetTrainTypes(ADOConn : TADOConnection;out ADOQuery : TADOQuery); overload;
    //���ܣ���ȡ�������ͣ�����StringList
    class procedure GetTrainTypes(ADOConn : TADOConnection;var TrainTypes : TStrings); overload;
    //���ܣ���ȡ���еĳ������ͷ�����Ϣ
    class procedure GetTrainNoBelongArray(ADOConn : TADOConnection;out TrainNoBelongArray : TRsTrainNoBelongArray);
  end;
implementation

uses DB;

{ TDBTrainType }

class procedure TRsDBTrainType.GetTrainTypes(ADOConn: TADOConnection;
  out ADOQuery: TADOQuery);
var
  strSql : string;  
begin
  strSql := 'select * from TAB_System_TrainType order by strTrainTypeName';
  ADOQuery := TADOQuery.Create(nil);
  ADOQuery.Connection := ADOConn;
  ADOQuery.SQL.Text := strSql;
  ADOQuery.Open;
end;

class procedure TRsDBTrainType.GetTrainNoBelongArray(ADOConn: TADOConnection;
  out TrainNoBelongArray: TRsTrainNoBelongArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_Base_TrainNoBelong order by nid';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      SetLength(TrainNoBelongArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainNoBelongArray[i].strTrainNoHead := FieldByName('strTrainNoHead').AsString;
        TrainNoBelongArray[i].nBeginNumber := FieldByName('nBeginNumber').AsInteger;
        TrainNoBelongArray[i].nEndNumber := FieldByName('nEndNumber').AsInteger;
        TrainNoBelongArray[i].nKehuoID := TRsKehuo(FieldByName('nKehuoID').AsInteger);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

class procedure TRsDBTrainType.GetTrainTypes(ADOConn: TADOConnection;
  var TrainTypes: TStrings);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from TAB_System_TrainType order by strTrainTypeName';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      while not eof do
      begin
        TrainTypes.Add(FieldByName('strTrainTypeName').AsString);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
