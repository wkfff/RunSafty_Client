unit uTrainType;

interface
uses
  uSaftyEnum;
type
  //车次类型分配信息
  RRsTrainNoBelong = record
    //车次头，为空时表示为全数字
    strTrainNoHead : string;
    //开始范围
    nBeginNumber : integer;
    //结束范围
    nEndNumber : integer;
    //客货类型
    nKehuoID  : TRsKehuo;
  end;

  TRsTrainNoBelongArray = array of RRsTrainNoBelong;
implementation

end.
