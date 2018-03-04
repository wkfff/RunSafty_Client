unit uTrainTypeManager;

interface
uses Classes;


type
  {RTrainType 车型信息}
  RTrainType = Record
    {车型名称}
    strTrainTypeName : String;    
    {车型编号}
    strTrainTypeCode : String;
  end;
  
  {TTrainTypeArray 车型数组}
  TTrainTypeArray = array of RTrainType;

  
implementation



end.
