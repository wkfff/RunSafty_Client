unit uPubFun;

interface
uses
  Classes ,SysUtils,DateUtils;


type
  TPubFun = class
  public
    {����:json�����ַ���ת��ΪTDateTime}
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
