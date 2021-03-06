unit uCommonFunctions;

interface
uses
  SysUtils,uTFSystem,ShellAPI,Windows,Variants;
const
  {ACCESS 数据库连接字符串}
  ACCESS_CONNECTIONSTRING = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  ACCESS_CONNECTIONSTRING_F='Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Jet OLEDB:Database Password=%s';
  {功能:判断文件是否正在使用}
  function IsFileInUse(const FName: string): Boolean;

  {功能:目录尾加'\'修正}
  function MakePath(const Dir: string): string;

  {功能:变体类型转换为字符串}
  function VariantToString(Value: Variant): string;

  {功能:变体类型转换为整型}
  function VariantToInteger(Value: Variant): Integer;

  {功能:变体类型转换为布尔类型}
  function VariantToBoolean(Value: Variant): Boolean;

  {功能:变体类型转换为时间}
  function VariantToDateTime(Value: Variant): TDateTime;

  
  {功能:判断是否是一个合语法的配置}
  function IsValidSQLConfig(SQLConfig: RSQLServerConfig): Boolean;

  {功能:取两个目录的相对路径}
  function GetRelativePath(ATo, AFrom: string;const PathStr: string = '\';
      const ParentStr: string = '..';const CurrentStr: string = '.';
      const UseCurrentDir: Boolean = False): string;

  {功能:计算在字符串中某字符出现的次数}
  function CharCounts(Str: PChar; Chr: Char): Integer;
  {功能:打开指定目录}
  function OpenPath(strPath: string;var strError: string): Boolean;
implementation


function IsFileInUse(const FName: string): Boolean;
{功能:判断文件是否正在使用}
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(FName) then
    Exit;
  HFileRes := CreateFile(PChar(FName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;



function VariantToString(Value: Variant): string;
{功能:变体类型转换为字符串}
begin
  if Value = null then
    Result := ''
  else
    Result := Value;
end;

function VariantToInteger(Value: Variant): Integer;
{功能:变体类型转换为整型}
begin
  if Value = null then
    Result := -1
  else
    Result := Value;
end;

function VariantToBoolean(Value: Variant): Boolean;
{功能:变体类型转换为布尔类型}
begin
  if Value = null then
    Result := False
  else
    Result := Value;
end;


function VariantToDateTime(Value: Variant): TDateTime;
{功能:变体类型转换为时间}
begin
  if value = Null then
    Result := 0
  else
    Result := StrToDateTime(Value);
end;

function OpenPath(strPath: string;var strError: string): Boolean;
{功能:打开指定目录}
var
  nResult: Integer;
begin
  nResult := ShellExecute(0,'open',PChar(strPath),nil,nil,SW_SHOWNORMAL);

  Result := nResult >= 32;

  case nResult of
    ERROR_PATH_NOT_FOUND:
      begin
        strError := '指定目录不存在!';
      end;  
  end;
end;
function SameCharCounts(s1, s2: string): Integer;
var
  Str1, Str2: PChar;
begin
  Result := 1;
  s1 := s1 + #0;
  s2 := s2 + #0;
  Str1 := PChar(s1);
  Str2 := PChar(s2);

  while (s1[Result] = s2[Result]) and (s1[Result] <> #0) do
  begin
    Inc(Result);
  end;
  Dec(Result);
  if (StrByteType(Str1, Result - 1) = mbLeadByte) or
    (StrByteType(Str2, Result - 1) = mbLeadByte) then
    Dec(Result);
end;



// 返回字符串右边的字符
function StrRight(Str: string; Len: Integer): string;
begin
  if Len >= Length(Str) then
    Result := Str
  else
    Result := Copy(Str, Length(Str) - Len + 1, Len);
end;
// 在字符串中某字符出现的次数
function CharCounts(Str: PChar; Chr: Char): Integer;
{功能:计算在字符串中某字符出现的次数}
var
  p: PChar;
begin
  Result := 0;
  p := StrScan(Str, Chr);
  while p <> nil do
  begin
    case StrByteType(Str, Integer(p - Str)) of
      mbSingleByte: begin
        Inc(Result);
        Inc(p);
      end;
      mbLeadByte: Inc(p);
    end;
    Inc(p);
    p := StrScan(p, Chr);
  end;
end;

// 取两个目录的相对路径
function GetRelativePath(ATo, AFrom: string;
  const PathStr: string = '\'; const ParentStr: string = '..';
  const CurrentStr: string = '.'; const UseCurrentDir: Boolean = False): string;
{功能:取两个目录的相对路径}
var
  i, HeadNum: Integer;
begin
  ATo := StringReplace(ATo, '/', '\', [rfReplaceAll]);
  AFrom := StringReplace(AFrom, '/', '\', [rfReplaceAll]);
  while AnsiPos('\\', ATo) > 0 do
    ATo := StringReplace(ATo, '\\', '\', [rfReplaceAll]);
  while AnsiPos('\\', AFrom) > 0 do
    AFrom := StringReplace(AFrom, '\\', '\', [rfReplaceAll]);
  if StrRight(ATo, 1) = ':' then
    ATo := ATo + '\';
  if StrRight(AFrom, 1) = ':' then
    AFrom := AFrom + '\';

  HeadNum := SameCharCounts(AnsiUpperCase(ExtractFilePath(ATo)),
    AnsiUpperCase(ExtractFilePath(AFrom)));
  if HeadNum > 0 then
  begin
    ATo := StringReplace(Copy(ATo, HeadNum + 1, MaxInt), '\', PathStr, [rfReplaceAll]);
    AFrom := Copy(AFrom, HeadNum + 1, MaxInt);

    Result := '';
    HeadNum := CharCounts(PChar(AFrom), '\');
    for i := 1 to HeadNum do
      Result := Result + ParentStr + PathStr;
    if (Result = '') and UseCurrentDir then
      Result := CurrentStr + PathStr;
    Result := Result + ATo;
  end
  else
    Result := ATo;
end;

function AddDirSuffix(const Dir: string): string;
{功能:目录尾加'\'修正}
begin
  Result := Trim(Dir);
  if Result = '' then Exit;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF};
end;

{功能:目录尾加'\'修正}
function MakePath(const Dir: string): string;
begin
  Result := AddDirSuffix(Dir);
end;


function IsValidSQLConfig(SQLConfig: RSQLServerConfig): Boolean;
{功能:判断是否是一个合语法的配置}
begin
  Result := (SQLConfig.strAddress = '') or (SQLConfig.strUserName = '')
      or (SQLConfig.strDBName = '');

  Result := not Result;
end;
end.
