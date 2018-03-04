unit uXYRelation;

interface
uses
  SysUtils;
type
  //ѧԱ��Ϣ
  RRsXYStudent = record
    strTeacherGUID : string;
    strStudentGUID : string;
    strStudentNumber : string;
    strStudentName : string;
  end;
  TRsXYStudentArray = array of RRsXYStudent;
  PRsXYStudent = ^RRsXYStudent;
  //ʦ����Ϣ
  RRsXYTeacher = record
    strTeacherGUID : string;
    strTeacherNumber : string;
    strTeacherName : string;
    StudentArray : TRsXYStudentArray;    
  end;
  PRsXYTeacher = ^RRsXYTeacher;
  TRsXYTeacherArray = array of RRsXYTeacher;


   {RXyQueryCondition ʦͽ��ϵ��ѯ����}
  RRsXyQueryCondition = record
    {����}
    strTrainmanNumber: string;
    {����}
    strTrainmanName: string;
    {��ƴ}
    strJp: string;
    {����GUID}
    strWorkShopGUID: string;
  public
    {����:��ʼ���ֶ�ֵ}
    procedure Init();
    {����:����SQL�������}
    function SQL(): string;
  end;

  {TXyOperateType ��������}
  TRsXyOperateType = (xotAddTeacher{���ʦ��},xotDelTeacher{ɾ��ʦ��},
    xotAddStudent{���ѧԱ},xotDelStudent{ɾ��ѧԱ});

  {RXyOperateLog ������־�ṹ}
  RRsXyOperateLog = record
    dtCreateTime: TDateTime;
    {��������}
    RelationOP: TRsXyOperateType;
    {ʦ��GUID}
    strTeacherGUID: string;
    {ʦ������}
    strTeacherNumber: string;
    {ʦ������}
    strTeacherName: string;
    {ѧԱGUID}
    strStudentGUID: string;
    {ѧԱ����}
    strStudentNumber: string;
    {ѧԱ����}
    strStudentName: string;
    {ֵ��ԱGUID}
    strDutyUserGUID: string;
    {ֵ��Ա����}
    strDutyUserNumber: string;
    {ֵ��Ա����}
    strDutyUserName: string;
  public
    procedure Init();
  end;

  PRsXyOperateLog = ^RRsXyOperateLog;
  TRsXyOperateLogArray = array of RRsXyOperateLog;

  //˾����Ϣ
  RRsSimpleTrainman = record
    strTrainmanGUID : string;
    strTrainmanNumber : string;
    strTrainmanName : string;
  end;  
  TRsSimpleTrainmanArray = array of RRsSimpleTrainman;

const
  TRsXyOperateTypeName : array[TRsXyOperateType] of string = ('���ʦ��','ɾ��ʦ��','���ѧԱ','ɾ��ѧԱ');
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
