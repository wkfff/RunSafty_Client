unit uDBLeaderExam;

interface
uses
  Classes,uLeaderExam,ADODB,uTFSystem;
type
//////////////////////////////////////////////////////////////////////////////
  ///干部检查信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBLeaderExam = class(TDBOperate)
  public
    //根据检查GUID获取检查信息
    class function GetLeaderExam(examGUID : string) : RLeaderExam;
    //获取所有检查信息
    class procedure GetLeaderExams(beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
    //添加检查
    class function AddLeaderExam(exam:RLeaderExam):boolean;
  end;
implementation
USES
  SysUtils,uGlobalDM;
{ TLeaderExanOpt }

class function TDBLeaderExam.AddLeaderExam(exam: RLeaderExam): boolean;
var
  ado : TADOQuery;
  guid : string;
begin
  guid := TGlobalDM.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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

class function TDBLeaderExam.GetLeaderExam(examGUID: string): RLeaderExam;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.ADOConn;
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

class procedure TDBLeaderExam.GetLeaderExams(beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
begin  
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := GlobalDM.ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_Exam_Information where strAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s order by dtCreateTime desc';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  Rlt.Open;

end;
end.
