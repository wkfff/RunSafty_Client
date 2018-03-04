unit uXYRelation;

interface
uses
  SysUtils;
type
  //学员信息
  RRsXYStudent = record
    strTeacherGUID : string;
    strStudentGUID : string;
    strStudentNumber : string;
    strStudentName : string;
  end;
  TRsXYStudentArray = array of RRsXYStudent;
  PRsXYStudent = ^RRsXYStudent;
  //师傅信息
  RRsXYTeacher = record
    strTeacherGUID : string;
    strTeacherNumber : string;
    strTeacherName : string;
    StudentArray : TRsXYStudentArray;    
  end;
  PRsXYTeacher = ^RRsXYTeacher;
  TRsXYTeacherArray = array of RRsXYTeacher;


   {RXyQueryCondition 师徒关系查询条件}
  RRsXyQueryCondition = record
    {工号}
    strTrainmanNumber: string;
    {姓名}
    strTrainmanName: string;
    {简拼}
    strJp: string;
    {车间GUID}
    strWorkShopGUID: string;
  public
    {功能:初始化字段值}
    procedure Init();
    {功能:生成SQL条件语句}
    function SQL(): string;
  end;

  {TXyOperateType 操作类型}
  TRsXyOperateType = (xotAddTeacher{添加师傅},xotDelTeacher{删除师傅},
    xotAddStudent{添加学员},xotDelStudent{删除学员});

  {RXyOperateLog 操作日志结构}
  RRsXyOperateLog = record
    dtCreateTime: TDateTime;
    {操作类型}
    RelationOP: TRsXyOperateType;
    {师傅GUID}
    strTeacherGUID: string;
    {师傅工号}
    strTeacherNumber: string;
    {师傅姓名}
    strTeacherName: string;
    {学员GUID}
    strStudentGUID: string;
    {学员工号}
    strStudentNumber: string;
    {学员姓名}
    strStudentName: string;
    {值班员GUID}
    strDutyUserGUID: string;
    {值班员工号}
    strDutyUserNumber: string;
    {值班员姓名}
    strDutyUserName: string;
  public
    procedure Init();
  end;

  PRsXyOperateLog = ^RRsXyOperateLog;
  TRsXyOperateLogArray = array of RRsXyOperateLog;

  //司机信息
  RRsSimpleTrainman = record
    strTrainmanGUID : string;
    strTrainmanNumber : string;
    strTrainmanName : string;
  end;  
  TRsSimpleTrainmanArray = array of RRsSimpleTrainman;

const
  TRsXyOperateTypeName : array[TRsXyOperateType] of string = ('添加师傅','删除师傅','添加学员','删除学员');
implementation

{ RXyQueryCondition }

procedure RRsXyQueryCondition.Init;
begin
  strTrainmanNumber := '';
  strTrainmanName := '';
  strJp := '';
  strWorkShopGUID := '';
end;

function RRsXyQueryCondition.SQL: string;
begin
  Result := ' where (1=1)';


  if strTrainmanNumber <> '' then
  begin
    Result := Result +
      Format(' and (strTeacherNumber = %s or strStudentNumber = %s)',
      [QuotedStr(strTrainmanNumber),QuotedStr(strTrainmanNumber)]);
  end;


  if strTrainmanName <> '' then
  begin
    Result := Result +
      Format(' and (strTeacherName = %s or strStudentName = %s)',
      [QuotedStr(strTrainmanName),QuotedStr(strTrainmanName)]);
  end;

  if strJp <> '' then
  begin
    Result := Result +
        Format(' and (strTeacherJp = %s or strStudentJp = %s)',
        [QuotedStr(strJp),QuotedStr(strJp)]);
  end;

  if strWorkShopGUID <> '' then
  begin
    Result := Result +
        Format(' and (strWorkShopGUID = %s)',
        [QuotedStr(strWorkShopGUID)]);
  end;
end;

{ RRsXyOperateLog }

procedure RRsXyOperateLog.Init;
begin
  strTeacherGUID := '';
  strStudentGUID := '';
  strDutyUserGUID := '';
end;

end.
