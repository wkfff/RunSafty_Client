unit uLeaderExamOpt;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //�ɲ����
  //////////////////////////////////////////////////////////////////////////////
  RLeaderExam = record
    GUID : string;
    LeaderGUID : string;    //�ɲ�GUID
    AreaGUID : string;     //�������GUID
    VerifyID :  Integer;     //��֤��ʽID
    CreateTime : TDateTime; //���ʱ��
    DutyGUID : string;      //ֵ��ԱGUID
    public
      procedure Init;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///�ɲ������Ϣ������
  //////////////////////////////////////////////////////////////////////////////
  TLeaderExanOpt = class
  public
    //���ݼ��GUID��ȡ�����Ϣ
    class function GetLeaderExam(examGUID : string) : RLeaderExam;
    //��ȡ���м����Ϣ
    class procedure GetLeaderExams(beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
    //��Ӽ��
    class function AddLeaderExam(exam:RLeaderExam):boolean;
  end;
implementation

{ TRoomOpt }
uses
  uGlobalDM,utfsystem;


{ RRoom }

procedure RLeaderExam.Init;
begin
  GUID := '';
  LeaderGUID := '';
  AreaGUID := '';
  VerifyID := 0;
  CreateTime := 0;
  DutyGUID := '';
end;

{ TLeaderExanOpt }

class function TLeaderExanOpt.AddLeaderExam(exam: RLeaderExam): boolean;
var
  ado : TADOQuery;
  guid : string;
begin
  guid := NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'insert into TAB_Exam_Information (strGUID,strLeaderGUID,strAreaGUID,nVerifyID,dtCreateTime,strDutyGUID) values '+
        ' (%s,%s,%s,%d,%s,%s)';

      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(exam.LeaderGUID),QuotedStr(exam.AreaGUID),
        exam.VerifyID,QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',GlobalDM.GetNow)),QuotedStr(exam.DutyGUID)]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TLeaderExanOpt.GetLeaderExam(examGUID: string): RLeaderExam;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Exam_Information  where strGUID = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(examGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.GUID := FieldByName('strGUID').AsString;
        Result.LeaderGUID := FieldByName('strLeaderGUID').AsString;
        Result.AreaGUID := FieldByName('strAreaGUID').AsString;
        Result.VerifyID := FieldByName('nVerifyID').AsInteger;
        Result.CreateTime := FieldByName('dtCreateTime').AsDateTime;
        Result.DutyGUID := FieldByName('strDutyGUID').AsString;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TLeaderExanOpt.GetLeaderExams(beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
begin  
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := GlobalDM.LocalADOConnection ;
  Rlt.SQL.Text := 'select * from VIEW_Exam_Information where  dtCreateTime >= %s and dtCreateTime <=%s order by dtCreateTime desc';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  Rlt.Open;

end;

end.
