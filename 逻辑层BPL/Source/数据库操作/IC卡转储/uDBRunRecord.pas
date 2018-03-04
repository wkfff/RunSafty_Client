unit uDBRunRecord;

interface
uses
  ADODB,uICCDefines,uTrainman;
type
  //////////////////////////////////////////////////////////////////////////////
  ///运行记录操作类
  //////////////////////////////////////////////////////////////////////////////
  TRsDBRunRecord = class
  public
    {功能:保存运行记录文件记录}
    class procedure AddRecord(Trainman:RRsTrainman;RuntimeInfoArray:TRuntimeInfoArray;strFilePath:String='');
  end;
implementation

{ TDBRunRecord }

class procedure TRsDBRunRecord.AddRecord(Trainman: RRsTrainman;
  RuntimeInfoArray: TRuntimeInfoArray; strFilePath: String);
begin

end;

end.
