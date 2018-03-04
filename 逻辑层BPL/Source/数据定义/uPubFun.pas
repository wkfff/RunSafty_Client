unit uPubFun;

interface
uses
  Classes,SysUtils,DateUtils,Forms;
type
  ///////////////////////////////////////////////////////////////////////////////
  ///����:TPubFun
  ///����:��������
  ///////////////////////////////////////////////////////////////////////////////
  TPubFun = class
  public
    {����:�ַ���������}
    class function Str2DateTime(strDateTime:string):TDateTime;
    {����:����ת��Ϊ�ַ���}
    class function DateTime2Str(dt:TDateTime):string;
    {����:����ת��Ϊ�ַ���MM-DD HH:nn}
    class function DT2StrmmddHHnn(dt:TDateTime):string;
    {����:��������ת��Ϊ����}
    class function Bool2Int(bl_Value:Boolean):Integer;
    {����:����ת��Ϊ��������}
    class function Int2Bool(n_Value:Integer):Boolean;
    {����:��ȡϵͳ·��}
    class function AppPath():string;
    {����:�ж��Ƿ���ʱ��������}
    class function CheckInTimeSec(dtStart,dtEnd,dtNow:TDateTime):Boolean;
    {����:��ʽ����ʾ����Ա��������}
    class function FormatTMNameNum(strName,strGH: string): string;
    {����:����ʱ��**Сʱ**����}
    class function CalTimeSpanHM(dtFrom,dtEnd:TDateTime):string;
  end;

implementation

{ TPubFun }

class function TPubFun.AppPath: string;
begin
  Result := ExtractFilePath(Application.ExeName);
end;

class function TPubFun.Bool2Int(bl_Value: Boolean): Integer;
begin
  result := 0;
  if bl_Value then result := 1;
  
end;
class function TPubFun.FormatTMNameNum(strName,strGH: string): string;
begin
  result :='';
  if strGH <> '' then
  begin
    result := Format('%s[%s]',[strName,strGH]);
  end;
end;
class function TPubFun.CalTimeSpanHM(dtFrom, dtEnd: TDateTime): string;
var
  nHours,nMinutes:Integer;
begin
  nHours := DateUtils.HoursBetween(dtFrom,dtEnd);
  nMinutes := DateUtils.MinutesBetween(dtFrom,dtEnd);
  Result := Format('%dʱ%d��',[nHours,nMinutes]);
  if dtFrom > dtEnd then
  begin
    Result := '��'+ result;
  end;

end;

class function TPubFun.CheckInTimeSec(dtStart, dtEnd,
  dtNow: TDateTime): Boolean;
var
  time_Start,time_end,time_now:TDateTime;
begin
  time_Start := TimeOf(dtStart);
  time_end := TimeOf(dtEnd);
  time_now := TimeOf(dtNow);
  result := False;
  
  if time_Start < time_end then
  begin
    if (time_now >= time_Start) and (time_now <= time_end) then
    begin
      result := True;
      Exit;
    end;
  end
  else
  begin
    if (time_now >= time_Start) or (time_now <= time_end)  then
    begin
      result := True;
      Exit;
    end;
  end;
  
end;

class function TPubFun.DateTime2Str(dt: TDateTime): string;
begin
  Result := '';
  if dt > 1 then
    result := FormatDateTime('yyyy-mm-dd HH:mm:ss',dt);
end;
class function TPubFun.DT2StrmmddHHnn(dt:TDateTime):string;
begin
  Result := '';
  if dt > 1 then
    result := FormatDateTime('yy-mm-dd HH:mm',dt);
end;

class function TPubFun.Int2Bool(n_Value: Integer): Boolean;
begin
  result := False;
  if n_Value >0 then result := True;

end;

class function TPubFun.str2DateTime(strDateTime: string): TDateTime;
begin
  result := 0;
  TryStrToDateTime(strDateTime,result);
end;

end.
