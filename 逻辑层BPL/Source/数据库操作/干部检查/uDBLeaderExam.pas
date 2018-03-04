unit uDBLeaderExam;

interface
uses
  Classes,SysUtils,Forms,windows,adodb,uLeaderExam,uTFSystem;
type
  //////////////////////////////////////////////////////////////////////////////
  ///干部检查信息操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBLeaderExam = class
  public

    //功能：根据检查GUID获取检查信息
    class function GetLeaderExam(ADOConn : TADOConnection;examGUID : string) : RRsLeaderExam;
    //功能：获取所有检查信息
    class procedure GetLeaderExams(ADOConn : TADOConnection;beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
    //功能：添加检查
    class function AddLeaderExam(ADOConn : TADOConnection;exam:RRsLeaderExam):boolean;
  end;

  TRsDBLeaderInspect = class (TDBOperate)
  public
      //获取干部检查列表信息
    procedure  GetLeaderInspectList(BeginDate,EndDate:TDateTime;var LeaderInspectList:TRsLeaderInspectList);
    function   AddLeaderInspect(LeaderInspect:RRsLeaderInspect):boolean;
  private
    procedure  AdoToData(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
    procedure  DataToAdo(ADOQuery:TADOQuery;var LeaderInspect:RRsLeaderInspect);
  end;

implementation


{ TLeaderExanOpt }

class function TRsDBLeaderExam.AddLeaderExam(ADOConn : TADOConnection;exam: RRsLeaderExam): boolean;
var
  ado : TADOQuery;
  guid : string;
begin
  guid := NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
      Close;
      Sql.Text := 'insert into TAB_Exam_Information (strGUID,strLeaderGUID,strAreaGUID,nVerifyID,dtCreateTime,strDutyGUID) values '+
        ' (%s,%s,%s,%d,getdate(),%s)';

      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(exam.LeaderGUID),QuotedStr(exam.AreaGUID),
        exam.VerifyID,QuotedStr(exam.DutyGUID)]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TRsDBLeaderExam.GetLeaderExam(ADOConn : TADOConnection;examGUID: string): RRsLeaderExam;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := ADOConn;
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

class procedure TRsDBLeaderExam.GetLeaderExams(ADOConn : TADOConnection;beginDate,endDate : TDateTime;areaGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  Rlt.Connection := ADOConn;
  Rlt.SQL.Text := 'select * from VIEW_Exam_Information where strAreaGUID=%s and dtCreateTime >= %s and dtCreateTime <=%s order by dtCreateTime desc';
  Rlt.SQL.Text := Format(Rlt.SQL.Text,[QuotedStr(areaGUID),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',beginDate)),QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',endDate))]);
  Rlt.Open;

end;

{ TRsDBLeaderInspect }

function TRsDBLeaderInspect.AddLeaderInspect(LeaderInspect:RRsLeaderInspect): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from  TAB_Exam_Information where 1 = 2 ' ;
      Open;
      Append;
      DataToAdo(ado,LeaderInspect);
      Post;
      Result :=  True ;
    end;
  finally
    ado.Free;
  end;
end;

procedure TRsDBLeaderInspect.AdoToData(ADOQuery: TADOQuery;
  var LeaderInspect:RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    LeaderInspect.GUID := FieldByName('strGUID').AsString;
    LeaderInspect.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;;
    LeaderInspect.strTrainmanName := FieldByName('strTrainmanName').AsString;
    LeaderInspect.LeaderGUID := FieldByName('strLeaderGUID').AsString;
    LeaderInspect.AreaGUID := FieldByName('strAreaGUID').AsString;
    LeaderInspect.VerifyID := FieldByName('nVerifyID').AsInteger;
    LeaderInspect.CreateTime := FieldByName('dtCreateTime').AsDateTime;
    LeaderInspect.DutyGUID := FieldByName('strDutyGUID').AsString;
    LeaderInspect.strContext  := FieldByName('strContext').AsString;
  end;
end;

procedure TRsDBLeaderInspect.DataToAdo(ADOQuery: TADOQuery;
  var LeaderInspect: RRsLeaderInspect);
begin
  with ADOQuery do
  begin
    FieldByName('strLeaderGUID').AsString := LeaderInspect.LeaderGUID;
    FieldByName('strAreaGUID').AsString := LeaderInspect.AreaGUID;
    FieldByName('nVerifyID').AsInteger := LeaderInspect.VerifyID;
    FieldByName('dtCreateTime').AsDateTime := LeaderInspect.CreateTime;
    FieldByName('strDutyGUID').AsString := LeaderInspect.DutyGUID;
    FieldByName('strContext').AsString := LeaderInspect.strContext;
  end;  
end;

procedure TRsDBLeaderInspect.GetLeaderInspectList(BeginDate,EndDate: TDateTime;
  var LeaderInspectList:TRsLeaderInspectList);
var
  ado : TADOQuery;
  i:Integer ;
  strText:string;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := m_ADOConnection;
      strText := Format('SELECT * from TAB_Exam_Information where dtCreateTime between %s and %s order by dtCreateTime',[
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate))
      ]);
      Sql.Text := strText;
      Open;
      if RecordCount <= 0 then
        Exit;
      i := 0 ;
      SetLength(LeaderInspectList,RecordCount);
      while not eof do
      begin
        AdoToData(ado,LeaderInspectList[i]);
        Next;
        Inc(i);
      end;
    end;
  finally
    ado.Free;
  end;
end;

end.
