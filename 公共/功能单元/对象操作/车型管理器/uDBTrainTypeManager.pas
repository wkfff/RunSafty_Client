unit uDBTrainTypeManager;

interface
uses
  uTrainTypeManager,ADODB;
type
  TDBTrainTypeManager = class
  public
    //获取车型列表
    class procedure GetTrainTypeArray(out TrainTypeArray:TTrainTypeArray ;ADOConn : TADOConnection);
    //添加车型
    class procedure AddTrainType(TrainType:RTrainType ;ADOConn : TADOConnection);
    //删除车型
    class procedure DeleteTrainType(TrainTypeName : string ;ADOConn : TADOConnection);
    //是否已经存在此车型
    class function Exist(TrainTypeName : string;ADOConn : TADOConnection):boolean;

  end;
implementation
uses
  SysUtils;
{ TDBTrainTypeManager }

class procedure TDBTrainTypeManager.AddTrainType(TrainType: RTrainType;
  ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'insert into TAB_System_TrainType (strTrainTypeName,strTrainTypeCode) values (%s,%s)';
  strSql := Format(strSql,[QuotedStr(TrainType.strTrainTypeName),QuotedStr(TrainType.strTrainTypeCode)]);
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

class procedure TDBTrainTypeManager.DeleteTrainType(TrainTypeName : string;
  ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;  
begin
  strSql := 'delete from  TAB_System_TrainType where strTrainTypeName=%s';
  strSql := Format(strSql,[QuotedStr(TrainTypeName)]);
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

class function TDBTrainTypeManager.Exist(TrainTypeName: string;ADOConn : TADOConnection): boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 1 * from TAB_System_TrainType where strTrainTypeName=%s';
  strSql := Format(strSql,[QuotedStr(TrainTypeName)]);

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      Result := (RecordCount > 0);
    end;
  finally
    adoQuery.Free;
  end;
end;

class procedure TDBTrainTypeManager.GetTrainTypeArray(
  out TrainTypeArray: TTrainTypeArray; ADOConn: TADOConnection);
var
  strSql : string;
  adoQuery : TADOQuery;
  i : integer;
begin
  strSql := 'select * from TAB_System_TrainType order by strTrainTypeName';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      SetLength(TrainTypeArray,RecordCount);
      i := 0;
      while not eof do
      begin
        TrainTypeArray[i].strTrainTypeCode := FieldByName('strTrainTypeCode').AsString;
        TrainTypeArray[i].strTrainTypeName := FieldByName('strTrainTypeName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
