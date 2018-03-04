unit ufrmXYRelationDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ufrmDebugBase, ComCtrls, StdCtrls, ExtCtrls,uLCXYRelation,uXYRelation,
  DateUtils;

type
  TFrmXYRelationDebug = class(TFrmDebugBase)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RsLCXYRelation: TRsLCXYRelation;
  public
    { Public declarations }
  published
    //获取所有的师徒关系
    procedure GetRelations();
    //获取操作日志
    procedure GetLogs();
    //添加师傅
    procedure AddTeacher();
    //删除师傅
    procedure DeleteTeacher();
    //添加学员
    procedure AddStudent();
    //删除学员
    procedure DeleteStudent();
    //清除师徒关系
    procedure ClearXYRelations();
    //增加师徒
    procedure AddTeacherAndStudent();
    //获取指定师傅的学员信息
    procedure GetStudents();
    //获取简单的司机信息
    procedure GetSimpleTrainmans();
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
procedure TFrmXYRelationDebug.AddStudent;
var
  DutyUserGUID, TeacherGUID,
  StudentGUID: String;
begin
  TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';
  StudentGUID := '033F60AA-65C1-427E-BF9A-B80C4AF0CA3C';
  RsLCXYRelation.AddStudent(DutyUserGUID, TeacherGUID,
  StudentGUID);

  TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';
  StudentGUID := '042308AB-7D6E-48C9-BFF4-844786EEE028';
  RsLCXYRelation.AddStudent(DutyUserGUID, TeacherGUID,
  StudentGUID);
end;

procedure TFrmXYRelationDebug.AddTeacher;
var
  DutyUserGUID, TeacherGUID: string;
begin
  DutyUserGUID := '';
  TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';

  RsLCXYRelation.AddTeacher(DutyUserGUID, TeacherGUID);

  TeacherGUID := '032693C2-1F2B-47EF-A383-6EA34BB975B0';

  RsLCXYRelation.AddTeacher(DutyUserGUID, TeacherGUID);
end;
procedure TFrmXYRelationDebug.AddTeacherAndStudent;
var
  teacherID,StudentID: string;
begin
  teacherID := '04EABA57-C32E-48E1-BFD3-D763B6645242';
  StudentID := '0536C763-986F-4066-AFE0-17D7A7489B92';
  RsLCXYRelation.AddTeacherAndStudent(teacherID,StudentID);
end;

procedure TFrmXYRelationDebug.ClearXYRelations;
begin
  RsLCXYRelation.ClearXYRelations();
end;

procedure TFrmXYRelationDebug.DeleteStudent;
var
  DutyUserGUID, TeacherGUID,
  StudentGUID: String;
begin
    TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';
  StudentGUID := '042308AB-7D6E-48C9-BFF4-844786EEE028';
  RsLCXYRelation.DeleteStudent(DutyUserGUID, TeacherGUID,
  StudentGUID);
end;

procedure TFrmXYRelationDebug.DeleteTeacher;
var
  DutyUserGUID, TeacherGUID: string;
begin
  TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';
  RsLCXYRelation.DeleteTeacher(DutyUserGUID, TeacherGUID);
end;

procedure TFrmXYRelationDebug.FormCreate(Sender: TObject);
begin
  inherited;
  RsLCXYRelation := TRsLCXYRelation.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmXYRelationDebug.FormDestroy(Sender: TObject);
begin
  RsLCXYRelation.Free;
  inherited;
end;

procedure TFrmXYRelationDebug.GetLogs;
var
  dtBegin, dtEnd: TDateTime;
  logArray: TRsXyOperateLogArray;
begin
  dtBegin := IncDay(Now,-1);
  dtEnd := IncDay(Now,1);
  RsLCXYRelation.GetLogs(dtBegin, dtEnd,logArray);
end;

procedure TFrmXYRelationDebug.GetRelations;
var
  param: RRsXyQueryCondition;
  teacherArray: TRsXYTeacherArray;
begin
  RsLCXYRelation.GetRelations(param,teacherArray);
end;

procedure TFrmXYRelationDebug.GetSimpleTrainmans;
var
  trainmanArray: TRsSimpleTrainmanArray;
begin
  RsLCXYRelation.GetSimpleTrainmans(trainmanArray);
end;

procedure TFrmXYRelationDebug.GetStudents;
var
  TeacherGUID: String;
  XYArray: TRsXYStudentArray;
begin
  TeacherGUID := '0178AA32-CD39-4867-B134-5AB7B1B5E155';
  RsLCXYRelation.GetStudents(TeacherGUID,XYArray);
end;

initialization
  ChildFrmMgr.Reg(TFrmXYRelationDebug);
end.
