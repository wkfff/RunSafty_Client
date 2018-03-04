unit uDBXYRelation;

interface
uses
  uXYRelation,uTFSystem,ADODB;
type
 
  //师徒关系数据库处理
  TRsDBXURelation = class(TDBOperate)
  private
    function ExecuteSql(strSql: string): Integer;
  public
    //添加操作日志
    procedure AddLog(OperateLog: RRsXyOperateLog);
    //获取操作日志
    procedure GetLogs(dtBegin,dtEnd: TDateTime;out LogArray: TRsXyOperateLogArray);
    
    //获取所有的师徒关系
    procedure GetRelations(Condition: RRsXyQueryCondition;out XYTeacherArray : TRsXYTeacherArray);
    //师傅是否已经存在
    function ExistTeacher(TeacherGUID : string) : boolean;

    //添加师傅
    procedure AddTeacher(DutyUserGUID,TeacherGUID : string);
    //删除师傅
    procedure DeleteTeacher(DutyUserGUID,TeacherGUID : string);
    //添加学员
    procedure AddStudent(DutyUserGUID,TeacherGUID,StudentGUID : string);
    //删除学员
    procedure DeleteStudent(DutyUserGUID,TeacherGUID,StudentGUID : string);
    
    //判断学员是否已经存在
    function ExistStudent(StudentGUID : string) : boolean;
    //获取指定师傅的学员信息
    procedure GetStudents(TeacherGUID : string; out XYArray : TRsXYStudentArray);
    //获取学员名字显示
    function GetStudentText(Student : RRsXYStudent) : string;
    //获取师傅名字显示
    function GetTeacherText(Teacher : RRsXYTeacher) : string;
    //获取师傅的学员名字显示
    function GetStudentArrayText(StudentArray : TRsXYStudentArray) : string;
     //清除师徒关系
    procedure ClearXYRelations();
    //增加师徒
    function AddTeacherAndStudent(TeacherGUID, StudentGUID: string): boolean;
    //获取简单的司机信息
    procedure GetSimpleTrainmans(out SimpleTrainmanArray: TRsSimpleTrainmanArray);
  end;


  
implementation
uses
  SysUtils, DB;
{ TDBXURelation }

procedure TRsDBXURelation.AddLog(OperateLog: RRsXyOperateLog);
var
  strSQL: string;
begin
  strSQL := 'insert into TAB_Base_XYRelation_Log (nRelationOP,strTeacherGUID,'
    + 'strStudentGUID,strDutyUserGUID) Values (%d,%s,%s,%s)';

  strSQL := Format(strSQL,[Ord(OperateLog.RelationOP),QuotedStr(
    OperateLog.strTeacherGUID),QuotedStr(OperateLog.strStudentGUID),
    QuotedStr(OperateLog.strDutyUserGUID)]);
  ExecuteSql(strSQL);
end;

procedure TRsDBXURelation.AddStudent(DutyUserGUID,TeacherGUID, StudentGUID: string);
var
  strSql : string;
  OperateLog: RRsXyOperateLog;
begin
  strSql := 'insert into TAB_Base_XYRelation_Student (strTeacherGUID,strStudentGUID) values (%s,%s)';
  strSql := Format(strSql,[QuotedStr(TeacherGUID),QuotedStr(StudentGUID)]);
  ExecuteSql(strSql);

  OperateLog.Init();
  OperateLog.RelationOP := xotAddStudent;
  OperateLog.strTeacherGUID := TeacherGUID;
  OperateLog.strDutyUserGUID := DutyUserGUID;
  OperateLog.strStudentGUID := StudentGUID;

  AddLog(OperateLog);
end;

procedure TRsDBXURelation.AddTeacher(DutyUserGUID,TeacherGUID: string);
var
  strSql : string;
  OperateLog: RRsXyOperateLog;
begin
  strSql := 'insert into TAB_Base_XYRelation_Teacher (strTeacherGUID) values (%s)';
  strSql := Format(strSql,[QuotedStr(TeacherGUID)]);
  ExecuteSql(strSql);
  
  OperateLog.Init();
  OperateLog.RelationOP := xotAddTeacher;
  OperateLog.strTeacherGUID := TeacherGUID;
  OperateLog.strDutyUserGUID := DutyUserGUID;

  AddLog(OperateLog);
end;

procedure TRsDBXURelation.DeleteStudent(DutyUserGUID,TeacherGUID, StudentGUID: string);
var
  strSql : string;
  OperateLog: RRsXyOperateLog;
begin
  strSql := 'delete from TAB_Base_XYRelation_Student where strTeacherGUID = %s and strStudentGUID = %s';
  strSql := Format(strSql,[QuotedStr(TeacherGUID),QuotedStr(StudentGUID)]);
  ExecuteSql(strSql);

  OperateLog.Init();
  OperateLog.RelationOP := xotDelStudent;
  OperateLog.strTeacherGUID := TeacherGUID;
  OperateLog.strDutyUserGUID := DutyUserGUID;
  OperateLog.strStudentGUID := StudentGUID;

  AddLog(OperateLog);
end;

procedure TRsDBXURelation.DeleteTeacher(DutyUserGUID,TeacherGUID: string);
var
  strSql : string;
  OperateLog: RRsXyOperateLog;
begin
  strSql := 'delete from TAB_Base_XYRelation_Student where strTeacherGUID = %s';
  strSql := Format(strSql,[QuotedStr(TeacherGUID)]);

  ExecuteSql(strSql);
  
  strSql := 'delete from TAB_Base_XYRelation_Teacher where strTeacherGUID = %s';
  strSql := Format(strSql,[QuotedStr(TeacherGUID)]);
  ExecuteSql(strSql);
  
  OperateLog.Init();
  OperateLog.RelationOP := xotDelTeacher;
  OperateLog.strTeacherGUID := TeacherGUID;
  OperateLog.strDutyUserGUID := DutyUserGUID;

  AddLog(OperateLog);
end;

function TRsDBXURelation.ExecuteSql(strSql: string): Integer;
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := strSql;
    Result := ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TRsDBXURelation.ExistStudent(StudentGUID: string) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 1 * from TAB_Base_XYRelation_Student where strStudentGUID = %s';
  strSql := Format(strSql,[QuotedStr(StudentGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      Result := RecordCount > 0;
    end;
  finally
    adoQuery.Free
  end;

end;

function TRsDBXURelation.ExistTeacher(TeacherGUID: string) : boolean;
var
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select top 1 * from TAB_Base_XYRelation_Teacher where strTeacherGUID = %s';
  strSql := Format(strSql,[QuotedStr(TeacherGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      Result := RecordCount > 0;
    end;
  finally
    adoQuery.Free
  end;

end;

procedure TRsDBXURelation.GetLogs(dtBegin,dtEnd: TDateTime;
    out LogArray: TRsXyOperateLogArray);
var
  ADOQuery: TADOQuery;
  strSql: string;
  i: Integer;
begin
  ADOQuery := NewADOQuery;
  try
    strSql := 'select * from VIEW_Base_XYRelation_Log where dtCreateTime >= %s '
      + 'and dtCreateTime <= %s order by dtCreateTime DESC';
       
    ADOQuery.SQL.Text := Format(strSql,[QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin)),
      QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd))]);

    ADOQuery.Open();

    SetLength(LogArray,ADOQuery.RecordCount);

    for I := 0 to ADOQuery.RecordCount - 1 do
    begin
      with ADOQuery do
      begin
        LogArray[i].RelationOP := TRsXyOperateType(FieldByName('nRelationOP').ASInteger);
        LogArray[i].strTeacherGUID := FieldByName('strTeacherGUID').AsString;
        LogArray[i].strTeacherNumber := FieldByName('strTeacherNumber').AsString;
        LogArray[i].strTeacherName := FieldByName('strTeacherName').AsString;
        LogArray[i].strStudentGUID:= FieldByName('strStudentGUID').AsString;
        LogArray[i].strStudentNumber := FieldByName('strStudentNumber').AsString;
        LogArray[i].strStudentName := FieldByName('strStudentName').AsString;
        LogArray[i].strDutyUserGUID := FieldByName('strDutyUserGUID').AsString;
        LogArray[i].strDutyUserNumber := FieldByName('strDutyNumber').AsString;
        LogArray[i].strDutyUserName := FieldByName('strDutyName').AsString;
        LogArray[i].dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
        Next;
      end;
    end;
      

    
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsDBXURelation.GetRelations(Condition: RRsXyQueryCondition;
    out XYTeacherArray: TRsXYTeacherArray);
var
  strSql,strTempTeacherGUID : string;
  adoQuery : TADOQuery;
  XYTeacher : RRsXYTeacher;
begin
  strSql := 'select * from VIEW_Base_XYRelation_Student'
    + Condition.SQL + ' order by strTeacherGUID,dtCreateTime';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      strTempTeacherGUID := '';
      while not eof do
      begin
        if strTempTeacherGUID <> FieldByName('strTeacherGUID').AsString then
        begin
          SetLength(XYTeacherArray,length(XYTeacherArray) + 1);
          XYTeacherArray[length(XYTeacherArray) - 1].strTeacherGUID :=  FieldByName('strTeacherGUID').AsString;
          XYTeacherArray[length(XYTeacherArray) - 1].strTeacherNumber :=  FieldByName('strTeacherNumber').AsString;
          XYTeacherArray[length(XYTeacherArray) - 1].strTeacherName :=  FieldByName('strTeacherName').AsString;
          strTempTeacherGUID := FieldByName('strTeacherGUID').AsString;
        end;
        XYTeacher := XYTeacherArray[length(XYTeacherArray) - 1];

        if FieldByName('strStudentGUID').AsString <> '' then
        begin
          SetLength(XYTeacher.StudentArray,length(XYTeacher.StudentArray) + 1);
          XYTeacher.StudentArray[length(XYTeacher.StudentArray) - 1].strTeacherGUID := FieldByName('strTeacherGUID').AsString;
          XYTeacher.StudentArray[length(XYTeacher.StudentArray) - 1].strStudentGUID := FieldByName('strStudentGUID').AsString;
          XYTeacher.StudentArray[length(XYTeacher.StudentArray) - 1].strStudentNumber := FieldByName('strStudentNumber').AsString;
          XYTeacher.StudentArray[length(XYTeacher.StudentArray) - 1].strStudentName := FieldByName('strStudentName').AsString;

          XYTeacherArray[length(XYTeacherArray) - 1] := XYTeacher;
        end;

        next;
      end;     
    end;
  finally
    adoQuery.Free
  end;
end;

function TRsDBXURelation.GetStudentArrayText(
  StudentArray: TRsXYStudentArray): string;
var
  i: Integer;
begin
  Result := '';
  for I := 0 to Length(StudentArray) - 1 do
  begin
    if StudentArray[i].strStudentGUID = '' then
      Continue;

    Result := Result + '' +
      Format('、%6s[%s]',[StudentArray[i].strStudentName,StudentArray[i].strStudentNumber]);
  end;

  if Result <> '' then
  begin
    Delete(Result,1,2);
  end;
    
end;

procedure TRsDBXURelation.GetStudents(TeacherGUID: string;
  out XYArray: TRsXYStudentArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select * from VIEW_Base_XYRelation_Student where strTeacherGUID = %s '
    + ' and (not (strStudentGUID is null)) and (strStudentGUID <> '''')';
  strSql := Format(strSql,[QuotedStr(TeacherGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(XYArray,RecordCount);
      i := 0;
      while not eof do
      begin
        XYArray[i].strTeacherGUID := FieldByName('strTeacherGUID').AsString;
        XYArray[i].strStudentGUID := FieldByName('strStudentGUID').AsString;
        XYArray[i].strStudentNumber := FieldByName('strStudentNumber').AsString;
        XYArray[i].strStudentName := FieldByName('strStudentName').AsString;
        inc(i);
        next;
      end;     
    end;
  finally
    adoQuery.Free
  end;
end;

function TRsDBXURelation.GetStudentText(Student: RRsXYStudent): string;
begin
  result := '';
  if Student.strStudentGUID <> '' then
  begin
    Result := Format('%6s[%s]',[Student.strStudentName,Student.strStudentNumber])
  end;
end;

function TRsDBXURelation.GetTeacherText(Teacher: RRsXYTeacher): string;
begin
  result := '';
  if Teacher.strTeacherGUID <> '' then
  begin
    Result := Format('%6s[%s]',[Teacher.strTeacherName,Teacher.strTeacherNumber])
  end;
end;

function TRsDBXURelation.AddTeacherAndStudent(TeacherGUID, StudentGUID: string): boolean;
var
  strSql1, strSql2: string;
begin
  Result := false;
  if (TeacherGUID = '') or (StudentGUID = '') then exit;
  
  strSql1 := 'if not exists (select * from TAB_Base_XYRelation_Teacher where strTeacherGUID=''%s'')' +
            ' insert into TAB_Base_XYRelation_Teacher(strTeacherGUID) values(''%s'')';
  strSql1 := Format(strSql1, [TeacherGUID, TeacherGUID]);

  strSql2 := 'if not exists (select * from TAB_Base_XYRelation_Student where strTeacherGUID=''%s'' and strStudentGUID=''%s'')' +
            ' insert into TAB_Base_XYRelation_Student(strTeacherGUID,strStudentGUID) values(''%s'',''%s'')';
  strSql2 := Format(strSql2, [TeacherGUID, StudentGUID, TeacherGUID, StudentGUID]);

  m_ADOConnection.BeginTrans;
  try
    m_ADOConnection.Execute(strSql1);
    m_ADOConnection.Execute(strSql2);
    m_ADOConnection.CommitTrans;
    Result := true;
  except
    m_ADOConnection.RollbackTrans;
  end;
end;

procedure TRsDBXURelation.ClearXYRelations;
var
  strSql : string;
  adoQuery : TADOQuery;
begin

  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      strSql := 'delete from TAB_Base_XYRelation_Teacher';
      SQL.Text := strSql;
      ExecSQL;

      strSql := 'delete from TAB_Base_XYRelation_Student';
      SQL.Text := strSql;
      ExecSQL;
    end;
  finally
    adoQuery.Free
  end;
end;

procedure TRsDBXURelation.GetSimpleTrainmans(out SimpleTrainmanArray: TRsSimpleTrainmanArray);
var
  i : integer;
  strSql : string;
  adoQuery : TADOQuery;
begin
  strSql := 'select strTrainmanGUID,strTrainmanNumber,strTrainmanName from TAB_Org_Trainman';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      SetLength(SimpleTrainmanArray, RecordCount);
      i := 0;
      while not eof do
      begin
        SimpleTrainmanArray[i].strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        SimpleTrainmanArray[i].strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        SimpleTrainmanArray[i].strTrainmanName := FieldByName('strTrainmanName').AsString;
        inc(i);
        next;
      end;     
    end;
  finally
    adoQuery.Free
  end;
end;


end.
