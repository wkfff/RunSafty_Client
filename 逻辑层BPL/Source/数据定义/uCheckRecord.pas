unit uCheckRecord;

interface
type
  RRsCheckRecord = record
  public
    nPointID : integer;
    strPointName : string;
    nIsHold : integer;
    strTrainmanNumber : string;
    strItemContent : string;
    nCheckResult : integer;
    dtCheckTime : TDateTime;
    dtCreateTime : TDateTime;
  end;
  TRsCheckRecordArray = array of RRsCheckRecord;
implementation

end.
