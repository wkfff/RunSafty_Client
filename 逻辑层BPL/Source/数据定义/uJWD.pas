unit uJWD;

interface

type

  {�������Ϣ�ṹ��}
  RRsJWD = record
    nID : Integer ;
    strCode:string;
    strName:string ;
    strShortName : string ;
    strPinYinCode : string ;
    strStatCode : string ;
    strUserCode : string ;
    strLJCode : string ;
    dtLastModify : TDateTime ;
    bIsVisible : Boolean;   //�Ƿ���ʾ
  end;

  TRsJWDArray = array of   RRsJWD ;


implementation

end.
