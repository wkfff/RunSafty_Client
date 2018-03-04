unit uDBWriteCardSection;

interface
uses
  uWriteCardSection,ADODB,uTFSystem;
type
  //写卡区段数据库操作类
  TDBWriteCardSection = class(TDBOperate)
  public
    //填充数据到结构
    procedure ADOQueryToSection(ADOQuery : TADOQuery;var Section : RRsWriteCardSection);
    //获取计划所有可选的写卡区段
    procedure GetPlanAllSections(TrainPlanGUID : string;out SectionArray : TRsWriteCardSectionArray);
    //获取计划已经选定的写卡区段
    procedure GetPlanSelectedSections(TrainPlanGUID : string;out SectionArray : TRsWriteCardSectionArray);
    //指定计划的写卡区段
    procedure SetPlanSections(TrainPlanGUID : string ;SectionArray : TRsWriteCardSectionArray;
      DutyUserGUID,DutyUserNumber,DutyUserName : string);
  end;
implementation

uses DB;

{ TDBWriteCardSection }

procedure TDBWriteCardSection.ADOQueryToSection(ADOQuery: TADOQuery;
  var Section: RRsWriteCardSection);
begin
  with ADOQuery do
  begin
    section.strJWDNumber := FieldByName('strJWDNumber').AsString;
    section.strSectionID := FieldByName('strSectionID').AsString;
    section.strSectionName := FieldByName('strSectionName').AsString;
  end;
end;

procedure TDBWriteCardSection.GetPlanAllSections(TrainPlanGUID: string;
  out SectionArray: TRsWriteCardSectionArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  section : RRsWriteCardSection;
begin
  strSql := 'select * from VIEW_Base_TrainJiaolu_Section ' +
    ' WHERE strTrainJiaoluGUID in ' +
    ' (select strtrainjiaoluguid from TAB_Plan_Train where strTrainPlanGUID=:strTrainPlanGUID)' +
    ' order by strSectionID ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Parameters.ParamByName('strTrainPlanGUID').Value := TrainPlanGUID;
      Open;
      SetLength(SectionArray,recordCount);
      while not eof do
      begin
        ADOQueryToSection(ADOQuery,section);
        SectionArray[RecNo - 1] := section;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;

end;

procedure TDBWriteCardSection.GetPlanSelectedSections(TrainPlanGUID: string;
  out SectionArray: TRsWriteCardSectionArray);
var
  adoQuery : TADOQuery;
  strSql : string;
  section : RRsWriteCardSection;
begin
  strSql := 'select * from Tab_Plan_WriteCardSection ' +
    ' WHERE strTrainPlanGUID = :strTrainPlanGUID order by strSectionID ';
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Parameters.ParamByName('strTrainPlanGUID').Value := TrainPlanGUID;
      Open;
      SetLength(SectionArray,recordCount);
      while not eof do
      begin
        ADOQueryToSection(ADOQuery,section);
        SectionArray[RecNo - 1] := section;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TDBWriteCardSection.SetPlanSections(TrainPlanGUID: string;
  SectionArray: TRsWriteCardSectionArray;DutyUserGUID,DutyUserNumber,DutyUserName : string);
var
  adoQuery : TADOQuery;
  i: integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'delete from Tab_Plan_WriteCardSection where strTrainPlanGUID = :strTrainPlanGUID';
      Parameters.ParamByName('strTrainPlanGUID').Value := TrainPlanGUID;
      ExecSQL;
      for i := 0 to length(SectionArray) - 1 do
      begin
        Sql.Text := 'insert into Tab_Plan_WriteCardSection ' +
        ' (strTrainPlanGUID,strSectionID,strSectionName,strJWDNumber,' +
          ' dtCreateTime,strDutyUserGUID,strDutyUserNumber,strDutyUserName) ' +
        ' values (:strTrainPlanGUID,:strSectionID,:strSectionName,:strJWDNumber,'+
        ' getdate(),:strDutyUserGUID,:strDutyUserNumber,:strDutyUserName)';
        Parameters.ParamByName('strTrainPlanGUID').Value := TrainPlanGUID;
        Parameters.ParamByName('strSectionID').Value := SectionArray[i].strSectionID;
        Parameters.ParamByName('strSectionName').Value := SectionArray[i].strSectionName;
        Parameters.ParamByName('strJWDNumber').Value := SectionArray[i].strJWDNumber;
        Parameters.ParamByName('strDutyUserGUID').Value := DutyUserGUID;
        Parameters.ParamByName('strDutyUserNumber').Value := DutyUserNumber;
        Parameters.ParamByName('strDutyUserName').Value := DutyUserName;
        ExecSQL;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
