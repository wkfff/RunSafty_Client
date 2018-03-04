unit uSystemDict;

interface
type
  //测酒类型
  RRsDrinkType = record
    nDrinkTypeID : integer;
    strDrinkTypeName : string;
  end;
  TRsDrinkTypeArray = array of RRsDrinkType;

  //测酒结果
  RRsDrinkResult = record
    nDrinkResult : integer;
    strDrinkResultName : string;
  end;
  TRsDrinkResultArray = array of RRsDrinkResult;

  //验证方式
  RRsVerify = record
    nVerifyID : Integer;
    strVerifyName : string;
  end;
  TRsVerifyArray = array of RRsVerify;
implementation

end.
