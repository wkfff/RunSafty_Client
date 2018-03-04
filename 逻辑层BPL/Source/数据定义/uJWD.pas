unit uJWD;

interface

type

  {机务段信息结构体}
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
    bIsVisible : Boolean;   //是否显示
  end;

  TRsJWDArray = array of   RRsJWD ;


implementation

end.
