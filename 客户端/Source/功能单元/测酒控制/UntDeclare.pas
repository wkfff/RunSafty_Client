unit UntDeclare;
interface
uses
    Windows, Messages,SysUtils;

procedure OutputDbgStr(S: string);
procedure WriteFileString(Msg: string; Value: string);
function Bits(dwWord: Word; nStart, nEnd: integer): Word;

implementation

function Bits(dwWord: Word; nStart, nEnd: integer): Word;
var
  dwMark: Word;
begin
  dwMark := 1;
  dwMark := dwMark shl (nEnd - nStart + 1) - 1;
  result := (dwWord shr nStart) and dwMark;
end;

procedure OutputDbgStr(S: string);
begin
    OutputDebugString(pchar(S));
end;

//���ܣ��������Ϣ�ļ���д����Ϣ

procedure WriteFileString(Msg: string; Value: string);
begin
    OutputDbgStr(DateTimeToStr(now()) + '---- ' + Msg + '= ' + Value);
end;



end.

