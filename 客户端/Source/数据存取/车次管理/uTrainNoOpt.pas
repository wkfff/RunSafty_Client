unit uTrainNoOpt;

interface
uses
  ADODB,SysUtils;
type
  RTrainNo = record
    strTrainNo : string;
    dtSigninTime : TDateTime;
    dtCallTime : TDateTime;
    dtOutDutyTime : TDateTime;
    dtStartTime : TDateTime;
    nTrainmanType : Integer;
    strAreaGUID : string;
    public
      procedure Init;
  end;
  //////////////////////////////////////////////////////////////////////////////
  ///车次信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TTrainNoOpt = class
  public
    //判断车次信息是否存在
    class function IsExistTrainNo(strTrainNo:String) : Boolean;
    //获取车次信息
    class function GetTrainNo(strTrainNo:string) : RTrainNo;
    //获取所有车次信息
    class procedure GetTrainNos(areaGUID : string;out Rlt : TADOQuery);
    //添加车次信息
    class function AddTrainNo(trainNo:RTrainNo):boolean;
    //修改车次信息
    class function UpdateTrainNo(trainNo:RTrainNo):boolean;
    //删除车次信息
    class function DeleteTrainNo(strTrainNo:string):boolean;

    //修改车次信息
    class function GetTrainNosRoom(strTrainNo : string):string;

  end;
implementation

{ TTrainNoOpt }
uses
  uGlobalDM;

class function TTrainNoOpt.AddTrainNo(trainNo: RTrainNo): boolean;
var
  ado : TADOQuery;
  strSql:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Close;
      strSql := 'insert into TAB_Org_TrainNo(strTrainNo,dtSigninTime,dtCallTime,dtOutDutyTime,dtStartTime,nTrainmanType,strAreaGUID) ' +
        ' values(%s,%s,%s,%s,%s,%d,%s)';
      strSql := Format(strSql,[QuotedStr(trainNo.strTrainNo),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtSigninTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtCallTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtOutDutyTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtStartTime)),
        trainNo.nTrainmanType,QuotedStr(trainNo.strAreaGUID)]);
      Sql.Text := strSql;
      Result := ExecSql > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TTrainNoOpt.DeleteTrainNo(strTrainNo: string): boolean;
var
  ado : TADOQuery;
  strSql:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      strSql := 'delete from TAB_Org_TrainNo  where strTrainNo=%s';
      strSql := Format(strSql,[QuotedStr(strTrainNo)]);
      Sql.Text := strSql;
      Result := ExecSql > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TTrainNoOpt.GetTrainNo(strTrainNo: string): RTrainNo;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  with ado do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Close;
    Sql.Text := 'select top 1 * from VIEW_Org_TrainNo where strTrainNo=%s ';
    Sql.Text := Format(Sql.Text,[strTrainNo]);
    Open;
    if RecordCount > 0 then
    begin
      Result.strTrainNo := FieldByName('strTrainNo').AsString;
      Result.dtSigninTime := FieldByName('dtSigninTime').AsDateTime;
      Result.dtCallTime := FieldByName('dtCallTime').AsDateTime;
      Result.dtOutDutyTime := FieldByName('dtOutDutyTime').AsDateTime;                  
      Result.dtStartTime := FieldByName('dtStartTime').AsDateTime;
      Result.nTrainmanType := FieldByName('nTrainmanType').AsInteger;
      Result.strAreaGUID := FieldByName('strAreaGUID').AsString;
    end;
  end;
end;

class procedure TTrainNoOpt.GetTrainNos(areaGUID : string;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Close;
    Sql.Text := 'select * from VIEW_Org_TrainNo where 1=1 ';
    Sql.Text := Sql.Text + ' order by dtStartTime';
    Open;
  end;
end;

class function TTrainNoOpt.GetTrainNosRoom(strTrainNo: string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from Tab_Org_TrainNo where strTrainNo=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strTrainNo)]);
      Open;
      if RecordCount > 0 then
        Result := FieldByName('strRoomNumber').AsString;
    end;
  finally
    ado.Free;
  end;
end;

class function TTrainNoOpt.IsExistTrainNo(strTrainNo: String): Boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_TrainNo where strTrainNo=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strTrainNo)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TTrainNoOpt.UpdateTrainNo(trainNo: RTrainNo): boolean;
var
  ado : TADOQuery;
  strSql:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      strSql := 'update TAB_Org_TrainNo set dtSigninTime=%s,dtCallTime=%s,dtOutDutyTime=%s,dtStartTime=%s,nTrainmanType=%d,strAreaGUID=%s where strTrainNo=%s';
      strSql := Format(strSql,[
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtSigninTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtCallTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtOutDutyTime)),
        QuotedStr(FormatdateTime('yyyy-MM-dd HH:nn:ss',trainNo.dtStartTime)),
        trainNo.nTrainmanType,QuotedStr(trainNo.strAreaGUID),
        QuotedStr(trainNo.strTrainNo)
        ]);
      Sql.Text := strSql ;
      Result := ExecSql > 0;
    end;
  finally
    ado.Free;
  end;
end;

{ RTrainNo }

procedure RTrainNo.Init;
begin
  strTrainNo := '';
  dtSigninTime := 0;
  dtCallTime := 0;
  dtOutDutyTime := 0;
  dtStartTime := 0;
  nTrainmanType := 2;
  strAreaGUID := '';
end;

end.
