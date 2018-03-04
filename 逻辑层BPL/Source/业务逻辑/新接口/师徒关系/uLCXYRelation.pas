unit uLCXYRelation;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,uXYRelation;
type
  //ʦͽ��ϵ�ӿ�
  TRsLCXYRelation = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  private
    m_WebAPIUtils:TWebAPIUtils;
    function XyQueryConditionToJson(Param: RRsXyQueryCondition): ISuperObject;
    function JsonToTeacher(iJson: ISuperObject): RRsXYTeacher;
    function JsonToStudent(iJson: ISuperObject): RRsXYStudent;
    function JsonToSimpleTrainman(iJson: ISuperObject): RRsSimpleTrainman;
    function JsonToLog(iJson: ISuperObject): RRsXyOperateLog;
  public
    //��ȡ���е�ʦͽ��ϵ
    procedure GetRelations(param : RRsXyQueryCondition;out teacherArray : TRsXYTeacherArray);
    //��ȡ������־
    procedure GetLogs(dtBegin : TDateTime;dtEnd : TDateTime;out logArray : TRsXyOperateLogArray);
    //���ʦ��
    procedure AddTeacher(DutyUserGUID : String;TeacherGUID : String);
    //ɾ��ʦ��
    procedure DeleteTeacher(DutyUserGUID : String;TeacherGUID : String);
    //���ѧԱ
    procedure AddStudent(DutyUserGUID : String;TeacherGUID : String;StudentGUID : String);
    //ɾ��ѧԱ
    procedure DeleteStudent(DutyUserGUID : String;TeacherGUID : String;StudentGUID : String);
    //���ʦͽ��ϵ
    procedure ClearXYRelations();
    //����ʦͽ
    procedure AddTeacherAndStudent(TeacherGUID : String;StudentGUID : String);
    //��ȡָ��ʦ����ѧԱ��Ϣ
    procedure GetStudents(TeacherGUID : String;out XYArray : TRsXYStudentArray);
    //��ȡ�򵥵�˾����Ϣ
    procedure GetSimpleTrainmans(out trainmanArray : TRsSimpleTrainmanArray); 
  end;

  TXyRelationStrFormat = class
  public
    //��ȡѧԱ������ʾ
    class function GetStudentText(Student : RRsXYStudent) : string;
    //��ȡʦ��������ʾ
    class function GetTeacherText(Teacher : RRsXYTeacher) : string;
    //��ȡʦ����ѧԱ������ʾ
    class function GetStudentArrayText(StudentArray : TRsXYStudentArray) : string;
  end;
implementation

{ TXyRelationStrFormat }

class function TXyRelationStrFormat.GetStudentArrayText(
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
      Format('��%6s[%s]',[StudentArray[i].strStudentName,StudentArray[i].strStudentNumber]);
  end;

  if Result <> '' then
  begin
    Delete(Result,1,2);
  end;
    
end;

class function TXyRelationStrFormat.GetStudentText(
  Student: RRsXYStudent): string;
begin
  result := '';
  if Student.strStudentGUID <> '' then
  begin
    Result := Format('%6s[%s]',[Student.strStudentName,Student.strStudentNumber])
  end;
end;

class function TXyRelationStrFormat.GetTeacherText(
  Teacher: RRsXYTeacher): string;
begin
  result := '';
  if Teacher.strTeacherGUID <> '' then
  begin
    Result := Format('%6s[%s]',[Teacher.strTeacherName,Teacher.strTeacherNumber])
  end;
end;

{ TRsLCEvent }

procedure TRsLCXYRelation.AddStudent(DutyUserGUID, TeacherGUID, StudentGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['TeacherGUID'] := TeacherGUID;
  json.S['StudentGUID'] := StudentGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.AddStudent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

procedure TRsLCXYRelation.AddTeacher(DutyUserGUID, TeacherGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['TeacherGUID'] := TeacherGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.AddTeacher',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

procedure TRsLCXYRelation.AddTeacherAndStudent(TeacherGUID, StudentGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TeacherGUID'] := TeacherGUID;
  json.S['StudentGUID'] := StudentGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.AddTeacherAndStudent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

procedure TRsLCXYRelation.ClearXYRelations;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.ClearXYRelations',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

constructor TRsLCXYRelation.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCXYRelation.DeleteStudent(DutyUserGUID, TeacherGUID,
  StudentGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['TeacherGUID'] := TeacherGUID;
  json.S['StudentGUID'] := StudentGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.DeleteStudent',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;
procedure TRsLCXYRelation.DeleteTeacher(DutyUserGUID, TeacherGUID: String);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['DutyUserGUID'] := DutyUserGUID;
  json.S['TeacherGUID'] := TeacherGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.DeleteTeacher',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

procedure TRsLCXYRelation.GetLogs(dtBegin, dtEnd: TDateTime;
  out logArray: TRsXyOperateLogArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: integer;
begin
  JSON := SO();
  JSON.S['dtBegin'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBegin);
  JSON.S['dtEnd'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEnd);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.GetLogs',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['logArray'];

  SetLength(logArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    logArray[i] := JsonToLog(json.AsArray[i]);
  end;

end;

procedure TRsLCXYRelation.GetRelations(param: RRsXyQueryCondition;
  out teacherArray: TRsXYTeacherArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  json.o['param'] := XyQueryConditionToJson(param);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.GetRelations',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['teacherArray'];

  SetLength(teacherArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    teacherArray[i] := JsonToTeacher(json.AsArray[i]);
  end;
end;

procedure TRsLCXYRelation.GetSimpleTrainmans(
  out trainmanArray: TRsSimpleTrainmanArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: integer;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.GetSimpleTrainmans',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['trainmanArray'];

  SetLength(trainmanArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    trainmanArray[i] := JsonToSimpleTrainman(json.AsArray[i]);
  end;

end;

procedure TRsLCXYRelation.GetStudents(TeacherGUID: String;
  out XYArray: TRsXYStudentArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: integer;
begin
  JSON := SO();
  json.S['TeacherGUID'] := TeacherGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCTeacherXYRel.GetStudents',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['XYArray'];

  SetLength(XYArray,json.AsArray.Length);
  for I := 0 to json.AsArray.Length - 1 do
  begin
    XYArray[i] := JsonToStudent(json.AsArray[i]);
  end;

end;
function TRsLCXYRelation.JsonToLog(iJson: ISuperObject): RRsXyOperateLog;
begin
  if iJson.S['dtCreateTime'] <> '' then
    Result.dtCreateTime := StrToDateTime(iJson.S['dtCreateTime'])
  else
    Result.dtCreateTime := 0;
  Result.RelationOP := TRsXyOperateType(iJson.I['RelationOP']);
  Result.strTeacherGUID := iJson.S['strTeacherGUID'];
  Result.strTeacherNumber := iJson.S['strTeacherNumber'];
  Result.strTeacherName := iJson.S['strTeacherName'];
  Result.strStudentGUID := iJson.S['strStudentGUID'];
  Result.strStudentNumber := iJson.S['strStudentNumber'];
  Result.strStudentName := iJson.S['strStudentName'];
  Result.strDutyUserGUID := iJson.S['strDutyUserGUID'];
  Result.strDutyUserNumber := iJson.S['strDutyUserNumber'];
  Result.strDutyUserName := iJson.S['strDutyUserName'];
end;

function TRsLCXYRelation.JsonToSimpleTrainman(
  iJson: ISuperObject): RRsSimpleTrainman;
begin
  Result.strTrainmanGUID := iJson.S['strTrainmanGUID'];
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  Result.strTrainmanName := iJson.S['strTrainmanName'];
end;

function TRsLCXYRelation.JsonToStudent(iJson: ISuperObject): RRsXYStudent;
begin
  Result.strTeacherGUID := iJson.S['strTeacherGUID'];
  Result.strStudentGUID := iJson.S['strStudentGUID'];
  Result.strStudentNumber := iJson.S['strStudentNumber'];
  Result.strStudentName := iJson.S['strStudentName'];
end;

function TRsLCXYRelation.JsonToTeacher(iJson: ISuperObject): RRsXYTeacher;
var
  I: Integer;
begin
  Result.strTeacherGUID := iJson.S['strTeacherGUID'];
  Result.strTeacherNumber := iJson.S['strTeacherNumber'];
  Result.strTeacherName := iJson.S['strTeacherName'];
  if (iJson.O['StudentArray'] <> nil) and (iJson.O['StudentArray'].IsType(stArray)) then
  begin
    SetLength(Result.StudentArray,iJson.O['StudentArray'].AsArray.Length);

    for I := 0 to iJson.O['StudentArray'].AsArray.Length - 1 do
    begin
      Result.StudentArray[i] := JsonToStudent(iJson.O['StudentArray'].AsArray[i]);
    end;

  end
  else
    SetLength(Result.StudentArray,0);



end;

function TRsLCXYRelation.XyQueryConditionToJson(
  Param: RRsXyQueryCondition): ISuperObject;
begin
  Result := SO;
  Result.S['strTrainmanNumber'] := param.strTrainmanNumber;
  Result.S['strTrainmanName'] := param.strTrainmanName;
  Result.S['strJp'] := param.strJp;
  Result.S['strWorkShopGUID'] := param.strWorkShopGUID;
end;

end.
