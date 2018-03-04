unit uDBRuntimeFileRecord;

interface
uses uTFSystem, uTrainman, uICCDefines, SysUtils, ADODB, DB;


type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TRuntimeFileRecordDB
  /// 说明:运行记录管理类
  //////////////////////////////////////////////////////////////////////////////
  TDBRuntimeFileRecord = class(TDBOperate)
  public
    {功能:保存运行记录文件记录}
    procedure SaveRuntimeFileRecord(Trainman:TTrainman;
        RuntimeInfoArray:TRuntimeInfoArray;strFilePath:String='');
  end;

implementation

{ TRuntimeFileRecordDB }

procedure TDBRuntimeFileRecord.SaveRuntimeFileRecord(Trainman: TTrainman;
  RuntimeInfoArray: TRuntimeInfoArray; strFilePath: String);
{功能:保存运行记录文件记录}
var
  i : Integer;
begin
  m_ADOQuery.SQL.Text := 'Select * from TAB_Record_YunXingJiLu where 1=2';
  m_ADOQuery.Open;
  try
    for I := 0 to LengTh(RuntimeInfoArray) - 1 do
    begin
      m_ADOQuery.Append;
      m_ADOQuery.FieldByName('strTrainmanGUID').AsString := Trainman.GUID;
      m_ADOQuery.FieldByName('strTrainmanNumber').AsString := Trainman.TrainmanNumber;
      m_ADOQuery.FieldByName('strFileName').AsString := RuntimeInfoArray[i].strFileName;
      m_ADOQuery.FieldByName('nFileSize').AsInteger := RuntimeInfoArray[i].nFileLength;
      m_ADOQuery.FieldByName('strTrainNumber').AsString := RuntimeInfoArray[i].strTrainCoding;
      m_ADOQuery.FieldByName('strCheCi').AsString := RuntimeInfoArray[i].strTrianNum;

      if strFilePath <> '' then
      begin
        if FileExists(strFilePath+RuntimeInfoArray[i].strFileName) then
        begin
          (m_ADOQuery.FieldByName('FileContent') As TBlobField).LoadFromFile(
              strFilePath+RuntimeInfoArray[i].strFileName);
        end;
      end;
      
      m_ADOQuery.FieldByName('strWorkID').AsString :=
          Trainman.StateInfo.Properties[PROPERTIES_WORKID];
      m_ADOQuery.Post;
    end;
  finally
    m_ADOQuery.Close;
  end;

end;

end.
