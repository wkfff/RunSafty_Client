unit uSystemDict;

interface
type
  //�������
  RRsDrinkType = record
    nDrinkTypeID : integer;
    strDrinkTypeName : string;
  end;
  TRsDrinkTypeArray = array of RRsDrinkType;

  //��ƽ��
  RRsDrinkResult = record
    nDrinkResult : integer;
    strDrinkResultName : string;
  end;
  TRsDrinkResultArray = array of RRsDrinkResult;

  //��֤��ʽ
  RRsVerify = record
    nVerifyID : Integer;
    strVerifyName : string;
  end;
  TRsVerifyArray = array of RRsVerify;
implementation

end.
