unit uTrainTypeManager;

interface
uses Classes;


type
  {RTrainType ������Ϣ}
  RTrainType = Record
    {��������}
    strTrainTypeName : String;    
    {���ͱ��}
    strTrainTypeCode : String;
  end;
  
  {TTrainTypeArray ��������}
  TTrainTypeArray = array of RTrainType;

  
implementation



end.
