unit uDBRunRecord;

interface
uses
  ADODB,uICCDefines,uTrainman;
type
  //////////////////////////////////////////////////////////////////////////////
  ///���м�¼������
  //////////////////////////////////////////////////////////////////////////////
  TRsDBRunRecord = class
  public
    {����:�������м�¼�ļ���¼}
    class procedure AddRecord(Trainman:RRsTrainman;RuntimeInfoArray:TRuntimeInfoArray;strFilePath:String='');
  end;
implementation

{ TDBRunRecord }

class procedure TRsDBRunRecord.AddRecord(Trainman: RRsTrainman;
  RuntimeInfoArray: TRuntimeInfoArray; strFilePath: String);
begin

end;

end.
