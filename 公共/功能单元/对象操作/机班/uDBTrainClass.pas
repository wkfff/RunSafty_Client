unit uDBTrainClass;

interface
uses
  uTrainClass,ADODB;
type
  //机班对象数据库操作类
  TDBTrainClass = class
    //添加机班
    class procedure AddTrainClass(TrainClass : RTrainClass;ADOConn : TADOConnection);
    //获取指定乘务员所在的机班信息
    class function GetTrainClass(TrainmanGUID : string;ADOConn : TADOConnection;
      out TrainClass : RTrainClass) : boolean;

  end;
implementation
uses
  SysUtils, DB;
{ TDBTrainClass }

class procedure TDBTrainClass.AddTrainClass(TrainClass: RTrainClass;
  ADOConn: TADOConnection);
var
  strSql,strTrainmanGUIDS : string;
  adoQuery : TADOQuery;
begin
  strTrainmanGUIDS := QuotedStr('00000000-0000-0000-00000-000000000000');

  if TrainClass.strTrainmanGUID1 <> '' then
  begin
    strTrainmanGUIDS := strTrainmanGUIDS + ',' + QuotedStr(TrainClass.strTrainmanGUID1); 
  end;
  if TrainClass.strTrainmanGUID2 <> '' then
  begin
    strTrainmanGUIDS := strTrainmanGUIDS + ',' + QuotedStr(TrainClass.strTrainmanGUID2);
  end;
  if TrainClass.strTrainmanGUID3 <> '' then
  begin
    strTrainmanGUIDS := strTrainmanGUIDS + ',' + QuotedStr(TrainClass.strTrainmanGUID3);
  end;
  
  strTrainmanGUIDs := Format('(%s)',[strTrainmanGUIDS]);
  
  strSql := 'delete from TAB_System_TrainClass where (strTrainmanGUID1 in %s) ' +
  '  or (strTrainmanGUID2 in %s) or (strTrainmanGUID3 in %s)' ;
  strSql := Format(strSql,[strTrainmanGUIDS,strTrainmanGUIDS,strTrainmanGUIDS]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      ExecSQL;

      strSql := 'insert into TAB_System_TrainClass ' +
        ' (strTrainmanGUID1,strTrainmanGUID2,strTrainmanGUID3) ' +
        ' values (%s,%s,%s)';
      strSql := Format(strSql,[QuotedStr(TrainClass.strTrainmanGUID1),
        QuotedStr(TrainClass.strTrainmanGUID2),QuotedStr(TrainClass.strTrainmanGUID3)]);
      Sql.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TDBTrainClass.GetTrainClass(TrainmanGUID: string;
  ADOConn: TADOConnection; out TrainClass: RTrainClass) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  Result := false;
  strSql := 'select top 1 * from TAB_System_TrainClass where strTrainmanGUID1 = %s '+
    ' or strTrainmanGUID2 = %s or strTrainmanGUID3 = %s';
  strSql := Format(strSql,[QuotedStr(TrainmanGUID),
        QuotedStr(TrainmanGUID),QuotedStr(TrainmanGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      SQL.Text := strSql;
      Open;
      if RecordCount > 0 then
      begin
        TrainClass.strGUID := FieldByName('strGUID').AsString;
        TrainClass.strTrainmanGUID1 := FieldByName('strTrainmanGUID1').AsString;
        TrainClass.strTrainmanGUID2 := FieldByName('strTrainmanGUID2').AsString;
        TrainClass.strTrainmanGUID3 := FieldByName('strTrainmanGUID3').AsString;
        Result := true;      
      end;
    end;
  finally
    adoQuery.Free;
  end;  
end;

end.
