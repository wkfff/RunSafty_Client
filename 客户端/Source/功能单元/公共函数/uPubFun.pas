unit uPubFun;

interface
uses
  Classes ,SysUtils,DateUtils;


type
  TPubFun = class
  public
    {功能:json日期字符串转换为TDateTime}
    class function Str2DateTime(strDateTime:string):TDateTime;
  end;


implementation

{ TPubFun }

class function TPubFun.Str2DateTime(strDateTime: string): TDateTime;
begin
  result := 0;
  TryStrToDateTime(strDateTime,Result);
end;

end.
