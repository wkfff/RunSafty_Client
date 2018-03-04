unit uLLCommonFun;

interface
uses
  SysUtils,ShellAPI,Windows,Variants,classes,StrUtils,DB,DateUtils,
  activex,EncdDecd,IdURI;
const
  {ACCESS 数据库连接字符串}
  CONNECTIONSTRING_ACCESS = 'Provider=Microsoft.Jet.OLEDB.4.0;Data Source=%s;Persist Security Info=False';
  {SQLServer连接字符串}
  CONNECTIONSTRING_SQLSERVER = 'Provider=SQLOLEDB.1;Persist Security Info=True;' +
    'Data Source=%s;User ID=%s;Password=%s;Initial Catalog=%s';

  LR = #13#10;


type
  TCF_Path = class
    {功能:打开指定目录}
    class function OpenPath(strPath: string;var strError: string): Boolean;

    {功能:目录尾加'\'修正}
    class function MakePath(const Dir: string): string;
  end;

  TCF_TxtFile = class
  public
    class procedure WriteTxtFile(const FileName: string;const Value: string);

    class procedure AppendTxtFile(const FileName: string;const Value: string);

    class procedure WriteBufferToFile(const FileName: string;Value:Pointer;Len: integer);

    class procedure AppBufferToFile(const FileName: string;Value:Pointer;Len: integer);

    class procedure ReadBufferFile(const FileName: string;Value: Pointer;Len: integer);

    class function GetFileSize(const FileName: string): integer;

    class function ReadTxtFile(const FileName: string): string;

    class function CreateFile(FileName: string): boolean;


  end;

  TCF_ValueCompare = class
  public
    class function Compare(V1, V2: Integer; Desc: Boolean = False): integer;overload;
    class function Compare(V1, V2: string; Desc: Boolean = False): integer;overload;
    class function Compare(V1, V2: TDateTime; Desc: Boolean = False): integer;overload;
  end;

  TCF_Array = class
  public
    class function IndexInt(V: integer;const intArray: Array of integer): integer;
    class function IndexStr(V: string;const StrArray: Array of string;IgCase: Boolean = True): integer;
  end;


  {$REGION '变体类型转换'}
  TCF_VariantParse = class
  public
    {功能:变体类型转换为字符串}
    class function VariantToString(Value: Variant): string;

    {功能:变体类型转换为整型}
    class function VariantToInteger(Value: Variant): Integer;

    {功能:变体类型转换为布尔类型}
    class function VariantToBoolean(Value: Variant): Boolean;

    {功能:变体类型转换为时间,时间采用字符串格式}
    class function VariantToDateTime(Value: Variant): TDateTime;

    {功能:变体类型转换为流}
    class procedure VariantToStream(const v : Variant; Stream : TMemoryStream);

    {功能:BLOB字段从VARIANT加载数据}
    class procedure BlobFieldLoadVariant(Field: TBlobField;const v : Variant);

    {功能:流转换为变体类型}
    class procedure StreamToVariant(Stream : TMemoryStream; var v : Variant);

    class procedure StreamToOleVariant(Stream : TMemoryStream; var v : OleVariant);

    class procedure OleVariantToStream(const v : OleVariant; Stream : TMemoryStream);

    {功能:变体类型转换为指针}
    class function VariantToBuffer(const v : Variant; var pData: Pointer): integer;

    {功能:指针类型转换为变体类型}
    class function BufferToVariant(pData: Pointer;len: integer): Variant;

    class function OleVariantBytesToBase64(const v : OleVariant;URIEncode: Boolean = False): string;

    class function Base64ToOleVariantBytes(const value: string): OleVariant;
  end;

  {$ENDREGION '变体类型转换'}

  TCF_Directory = class
  public
    {* 删除整个目录, DelRoot 表示是否删除目录本身}
    class function Deltree(Dir: string; DelRoot: Boolean = True;DelEmptyDirOnly: Boolean = False): Boolean;

    {删除整个目录中的空目录, DelRoot 表示是否删除目录本身}
    class procedure DelEmptyTree(Dir: string; DelRoot: Boolean = True);

    class procedure ExploreDir(APath: string; ShowDir: Boolean);

    class procedure ExploreFile(AFile: string; ShowDir: Boolean);

    class procedure EnumFile(Path: string;Files: TStrings;Filter: string = '*.*';includePath: Boolean = False);
  end;

  TCF_Enum = class
  public
    {可用于变量和结构体，不可用于对象的属性}
    class procedure SetEnumValue(p: Pointer; Size, Value: Integer);
  end;
  
  {$REGION 'INI文件操作'}
  function ReadIniFileString(strFileName,strSection,strIdent: string;strDefault: string = ''): string;
  function ReadIniFileInt(strFileName,strSection,strIdent: string;nDefault: Integer = 0): Integer;
  function ReadIniFileBoolean(strFileName,strSection,strIdent: string;bDefault: Boolean = False): Boolean;
  procedure WriteIniFileString(strFileName,strSection,strIdent,strValue: string);
  procedure WriteIniFileInt(strFileName,strSection,strIdent: string;nValue: Integer);
  procedure WriteIniFileBoolean(strFileName,strSection,strIdent: string;bValue: Boolean);
  {$ENDREGION 'INI文件操作'}

  {功能:设置时间格式}
  procedure SetDateTimeFormat();

  {功能:判断文件是否正在使用}
  function IsFileInUse(const FName: string): Boolean;
  
  {功能:返回右子串}
  function StrRight(Str: string; Len: Integer): string;

  {功能:获取文件创建时间}
  function GetFileCreateTime(const FileName: string): TDateTime;

  {功能:获取模块所在路径}
  function GetSelfPath:string;

  {功能:创建一个GUID字符串}
  function CreateGuidString: string;

  {功能:在线程内延时，同时检测线程是否退出}
  procedure ThreadDelay(ms: Cardinal;Thread: TThread);

  // 二分法在列表中查找
  function HalfFind(List: TList; P: Pointer; SCompare: TListSortCompare): Integer;

implementation
// 二分法在列表中查找
function HalfFind(List: TList; P: Pointer; SCompare: TListSortCompare): Integer;
var
  L, R, M: Integer;
  Res: Integer;
begin
  Result := -1;
  L := 0;
  R := List.Count - 1;
  if R < L then Exit;
  if SCompare(P, List[L]) < 0 then Exit;
  if SCompare(P, List[R]) > 0 then Exit;
  while True do
  begin
    M := (L + R) shr 1;
    Res := SCompare(P, List[M]);
    if Res > 0 then
      L := M
    else if Res < 0 then
      R := M
    else
    begin
      Result := M;
      Exit;
    end;
    if L = R then
      Exit
    else if R - L = 1 then
    begin
      if SCompare(P, List[L]) = 0 then
        Result := L
      else if SCompare(P, List[R]) = 0 then
        Result := R;
      Exit;
    end;
  end;
end;

type
  TInnerThread = class(TThread)
  public
    property Terminated;
  end;
procedure ThreadDelay(ms: Cardinal;Thread: TThread);
var
  nTick: Cardinal;
begin
  nTick := 0;
  repeat
    Sleep(10);
    Inc(nTick,10);      
  until (TInnerThread(Thread).Terminated or (nTick >= ms));
end;

function CreateGuidString: string;
var
  P: PWideChar;
  GUID: TGUID;
begin
  CoCreateGuid(GUID);
  if not Succeeded(StringFromCLSID(GUID, P)) then
    Result := ''
  else
    Result := P;
  CoTaskMemFree(P);
end;
  
function GetSelfPath:string;
var
  buf : array[0..255] of Char;
  s : string;
begin
  FillChar(buf,SizeOf(buf),#0);
  GetModuleFileName(HInstance,buf,SizeOf(buf));
  s := StrPas(buf);
  s := ExtractFilePath(s);
  if Copy(s,Length(s),1)<>'\' then s:=s+'\';
  result := s;
end;

function GetFileCreateTime(const FileName: string): TDateTime;
var
  FileTime: TFileTime;
  LocalFileTime: TFileTime;
  hFile: THandle;
  SystemTime: TSystemTime;
  strFileName:string;
begin
  Result := 0;
  strFileName := AnsiReplaceText(FileName,'\\','\');
  FileTime.dwLowDateTime := 0;
  FileTime.dwHighDateTime := 0;
  hFile := FileOpen(strFileName, fmShareDenyNone);
  try
    if hFile <> 0 then
    begin
      Windows.GetFileTime(hFile, @FileTime, nil, nil);
      FileTimeToLocalFileTime(FileTime, LocalFileTime);
      FileTime := LocalFileTime;
    end;
  finally
    FileClose(hFile);
  end;
  if FileTimeToSystemTime(FileTime, SystemTime) then
    Result := SystemTimeToDateTime(SystemTime);

end;
procedure SetDateTimeFormat();
begin
  SysUtils.TimeSeparator := ':';
  SysUtils.DateSeparator := '-';
  SysUtils.ShortDateFormat := 'yyyy-MM-dd';
  SysUtils.LongDateFormat := 'yyyy-MM-dd';
  SysUtils.ShortTimeFormat := 'HH:mm';
  SysUtils.LongTimeFormat := 'HH:mm:ss';
end;



{$REGION 'INI文件操作'}
function ReadIniFileString(strFileName,strSection,strIdent: string;strDefault: string = ''): string;
var
  buf: array[Byte] of Char; {准备接受缓冲区}
begin
	GetPrivateProfileString(pchar(strSection), pchar(strIdent),pchar(strDefault), buf, Length(buf), pchar(strFileName));
	result := Trim(buf);
end;

function ReadIniFileInt(strFileName,strSection,strIdent: string;nDefault: Integer = 0): Integer;
var
  strResult: string;
begin
  strResult := ReadIniFileString(strFileName,strSection,strIdent,'');
  if strResult = '' then
    Result := nDefault
  else
  begin
    if not TryStrToInt(strResult,Result) then
      Result := nDefault;
  end;

end;

function ReadIniFileBoolean(strFileName,strSection,strIdent: string;bDefault: Boolean = False): Boolean;
var
  strResult: string;
begin
  strResult := ReadIniFileString(strFileName,strSection,strIdent,'');
  if strResult = '' then
    Result := bDefault
  else
  begin
    if not TryStrToBool(strResult,Result) then
      Result := bDefault;
  end;

end;


procedure WriteIniFileString(strFileName,strSection,strIdent,strValue: string);
begin
  WritePrivateProfileString(PChar(strSection),PChar(strIdent),PChar(strValue),PChar(strFileName));
end;
procedure WriteIniFileInt(strFileName,strSection,strIdent: string;nValue: Integer);
begin
  WriteIniFileString(strFileName,strSection,strIdent,IntToStr(nValue));
end;
procedure WriteIniFileBoolean(strFileName,strSection,strIdent: string;bValue: Boolean);
begin
  WriteIniFileString(strFileName,strSection,strIdent,BoolToStr(bValue,True));
end;

{$ENDREGION 'INI文件操作'}


function IsFileInUse(const FName: string): Boolean;
{功能:判断文件是否正在使用}
var
  HFileRes: HFILE;
begin
  Result := False;
  if not FileExists(FName) then
    Exit;                          
  HFileRes := windows.CreateFile(PChar(FName), GENERIC_READ or GENERIC_WRITE, 0,
    nil, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  Result := (HFileRes = INVALID_HANDLE_VALUE);
  if not Result then
    CloseHandle(HFileRes);
end;



// 返回字符串右边的字符
function StrRight(Str: string; Len: Integer): string;
begin
  if Len >= Length(Str) then
    Result := Str
  else
    Result := Copy(Str, Length(Str) - Len + 1, Len);
end;


function AddDirSuffix(const Dir: string): string;
{功能:目录尾加'\'修正}
begin
  Result := Trim(Dir);
  if Result = '' then Exit;
  if not IsPathDelimiter(Result, Length(Result)) then
    Result := Result + {$IFDEF MSWINDOWS} '\'; {$ELSE} '/'; {$ENDIF};
end;


{ TVariantParse }

class function TCF_VariantParse.Base64ToOleVariantBytes(
  const value: string): OleVariant;
var
  OutPut: TMemoryStream;
  Input: TStringStream;
begin
  OutPut := TMemoryStream.Create;
  Input := TStringStream.Create(value);
  try
    if value = '' then
      Result := null;
    Input.Position := 0;
    DecodeStream(input,output);
    OutPut.Position := 0;
    StreamToOleVariant(OutPut,Result);
  finally
    input.Free;
    output.Free;
  end;

end;


class procedure TCF_VariantParse.BlobFieldLoadVariant(Field: TBlobField;
  const v: Variant);
var
  Mem: TMemoryStream;
begin
  if v = null then Exit;

  if not VarIsArray(v) then Exit;
  
  Mem := TMemoryStream.Create;
  try
    VariantToStream(v,Mem);
    Mem.Position := 0;
    Field.LoadFromStream(Mem);
  finally
    Mem.Free;
  end;
end;

class function TCF_VariantParse.BufferToVariant(pData: Pointer;
  len: integer): Variant;
var
  p : pointer;
begin
  Result := VarArrayCreate ([0, len - 1], varByte);
  p := VarArrayLock (Result);
  try
    Move(pData^,p^,len);
  finally
    VarArrayUnlock (Result);
  end;
end;

class function TCF_VariantParse.OleVariantBytesToBase64(
  const v: OleVariant;URIEncode: Boolean): string;
var
  input: TMemoryStream;
  output: TStringStream;
begin
  input := TMemoryStream.Create;
  output := TStringStream.Create('');
  try
    if VarIsNull(v) or (not VarIsArray(v)) then
    begin
      Result := '';
      Exit;
    end;    
    OleVariantToStream(v,input);

    input.Position := 0;
    EncodeStream(input,output);
    output.Position := 0;

    if URIEncode then
      Result := TIdURI.PathEncode(output.DataString)
    else
      Result := output.DataString;
  finally
    input.Free;
    output.Free;
  end;

end;

class procedure TCF_VariantParse.OleVariantToStream(const v: OleVariant;
  Stream: TMemoryStream);
var
  p : pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound (v, 1) - VarArrayLowBound (v, 1) + 1;
  p := VarArrayLock (v);
  try
    Stream.Write (p^, Stream.Size);
  finally
    VarArrayUnlock (v);
    Stream.Position := 0;
  end;
end;

class procedure TCF_VariantParse.StreamToOleVariant(Stream: TMemoryStream;
  var v: OleVariant);
var
  p : pointer;
begin
  v := VarArrayCreate ([0, Stream.Size - 1], varByte);
  p := VarArrayLock (v);
  try
    Stream.Position := 0;
    Stream.Read (p^, Stream.Size);
  finally
    VarArrayUnlock (v);
  end;

end;
class procedure TCF_VariantParse.StreamToVariant(Stream: TMemoryStream;
  var v: Variant);
var
  p : pointer;
begin
  v := VarArrayCreate ([0, Stream.Size - 1], varByte);
  p := VarArrayLock (v);
  try
    Stream.Position := 0;
    Stream.Read (p^, Stream.Size);
  finally
    VarArrayUnlock (v);
  end;

end;


class function TCF_VariantParse.VariantToBoolean(Value: Variant): Boolean;
begin
    if Value = null then
    Result := False
  else
    Result := Value;
end;

class function TCF_VariantParse.VariantToBuffer(const v: Variant;
  var pData: Pointer): integer;
var
  p : pointer;
begin
  Result := VarArrayHighBound (v, 1) - VarArrayLowBound (v, 1) + 1;
  if Result = 0 then
  begin
    pData := nil;
    Exit;
  end;
  p := VarArrayLock (v);
  try
    GetMem(pData,Result);
    Move(p^,pData^,Result);
  finally
    VarArrayUnlock (v);
  end;
end;

class function TCF_VariantParse.VariantToDateTime(Value: Variant): TDateTime;
begin
  if value = Null then
    Result := 0
  else
    Result := StrToDateTime(Value);
end;

class function TCF_VariantParse.VariantToInteger(Value: Variant): Integer;
begin
    if value = Null then
    Result := 0
  else
    Result := Value;
end;

class procedure TCF_VariantParse.VariantToStream(const v: Variant;
  Stream: TMemoryStream);
var
  p : pointer;
begin
  Stream.Position := 0;
  Stream.Size := VarArrayHighBound (v, 1) - VarArrayLowBound (v, 1) + 1;
  p := VarArrayLock (v);
  try
    Stream.Write (p^, Stream.Size);
  finally
    VarArrayUnlock (v);
    Stream.Position := 0;
  end;
end;

class function TCF_VariantParse.VariantToString(Value: Variant): string;
begin
  Result := VarToStrDef(Value,'');
end;

{ TTxtFile }

class procedure TCF_TxtFile.AppBufferToFile(const FileName: string;
  Value: Pointer; Len: integer);
var
  FileStream: TFileStream;
begin
  if not FileExists(FileName) then
    FileStream := TFileStream.Create(FileName,fmCreate)
  else
    FileStream := TFileStream.Create(FileName,fmOpenWrite);
  try
    FileStream.Position := FileStream.Size;
    FileStream.Write(Value^,Len);
  finally
    FileStream.Free;
  end;
end;

class procedure TCF_TxtFile.AppendTxtFile(const FileName, Value: string);
var
  FileStream: TFileStream;
begin
  if not FileExists(FileName) then
    FileStream := TFileStream.Create(FileName,fmCreate)
  else
    FileStream := TFileStream.Create(FileName,fmOpenWrite);
  try
    FileStream.Position := FileStream.Size;
    FileStream.Write(PChar(Value)^,Length(Value));
  finally
    FileStream.Free;
  end;
end;

class function TCF_TxtFile.CreateFile(FileName: string): boolean;
var
  F: TextFile;
begin
  if not DirectoryExists(ExtractFilePath(FileName)) then
  begin
    raise Exception.Create(ExtractFilePath(FileName) + ',不存在!');
  end;
  try
    AssignFile(F,FileName);
    Rewrite(F);
    Result := True;
  finally
    CloseFile(F);
  end;

end;


class function TCF_TxtFile.GetFileSize(const FileName: string): integer;
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName,fmOpenRead);
  try
    Result := FileStream.Size;   
  finally
    FileStream.Free;
  end;
end;

class procedure TCF_TxtFile.ReadBufferFile(const FileName: string;
  Value: Pointer; Len: integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName,fmOpenRead);
  try
    if Len > FileStream.Size then
      Raise Exception.Create('读取长度大于文件长度!');

    FileStream.Position := 0;
    FileStream.Read(Value^,Len);   
  finally
    FileStream.Free;
  end;
end;

class function TCF_TxtFile.ReadTxtFile(const FileName: string): string;
var
  FileStream: TFileStream;
begin
  if not FileExists(FileName) then
  begin
    Result := '';
    Exit;
  end;
  FileStream := TFileStream.Create(FileName,fmOpenRead);
  try
    if FileStream.Size > 1024 * 1024 * 10 then
      Raise Exception.Create('文件大于10M，不能按字符串读取!');
      
    SetLength(Result,FileStream.Size);
    
    FileStream.Read(PChar(Result)^,FileStream.Size);
    
  finally
    FileStream.Free;
  end;
end;

class procedure TCF_TxtFile.WriteBufferToFile(const FileName: string;
  Value: Pointer; Len: integer);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName,fmCreate);
  try
    FileStream.Write(Value^,Len);   
  finally
    FileStream.Free;
  end;
end;

class procedure TCF_TxtFile.WriteTxtFile(const FileName, Value: string);
var
  FileStream: TFileStream;
begin
  FileStream := TFileStream.Create(FileName,fmCreate);
  try
    FileStream.Write(PChar(Value)^,Length(Value));
  finally
    FileStream.Free;
  end;
end;

{ TPath }

class function TCF_Path.MakePath(const Dir: string): string;
begin
  Result := AddDirSuffix(Dir);
end;


class function TCF_Path.OpenPath(strPath: string; var strError: string): Boolean;
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

{ TValueCompare }

class function TCF_ValueCompare.Compare(V1, V2: Integer; Desc: Boolean): integer;
begin
  if V1 > V2 then
    Result := 1
  else if V1 < V2 then
    Result := -1
  else // V1 = V2
    Result := 0;
  if Desc then
    Result := -Result;
end;

class function TCF_ValueCompare.Compare(V1, V2: string; Desc: Boolean): integer;
begin
  Result := CompareStr(V1,V2);

  if Desc then
    Result := - Result;
end;

class function TCF_ValueCompare.Compare(V1, V2: TDateTime; Desc: Boolean): integer;
begin
  Result := CompareDateTime(V1,V2);

  if Desc then
    Result := -Result;
end;

{ TCF_Directory }

class procedure TCF_Directory.DelEmptyTree(Dir: string; DelRoot: Boolean);
var
  sr: TSearchRec;
  fr: Integer;
begin
  fr := SysUtils.FindFirst(AddDirSuffix(Dir) + '*.*', faDirectory, sr);
  try
    while fr = 0 do
    begin
      if (sr.Name <> '.') and (sr.Name <> '..') and (sr.Attr and faDirectory
        = faDirectory) then
      begin
        SetFileAttributes(PChar(AddDirSuffix(Dir) + sr.Name), FILE_ATTRIBUTE_NORMAL);
        DelEmptyTree(AddDirSuffix(Dir) + sr.Name, True);
      end;
      fr := SysUtils.FindNext(sr);
    end;
  finally
    SysUtils.FindClose(sr);
  end;

  if DelRoot then
    RemoveDir(Dir);
end;


class function TCF_Directory.Deltree(Dir: string; DelRoot,
  DelEmptyDirOnly: Boolean): Boolean;
var
  sr: TSearchRec;
  fr: Integer;
begin
  Result := True;
  if not DirectoryExists(Dir) then
    Exit;
  fr := SysUtils.FindFirst(AddDirSuffix(Dir) + '*.*', faAnyFile, sr);
  try
    while fr = 0 do
    begin
      if (sr.Name <> '.') and (sr.Name <> '..') then
      begin
        SetFileAttributes(PChar(AddDirSuffix(Dir) + sr.Name), FILE_ATTRIBUTE_NORMAL);
        if sr.Attr and faDirectory = faDirectory then
          Result := Deltree(AddDirSuffix(Dir) + sr.Name, True, DelEmptyDirOnly)
        else if not DelEmptyDirOnly then
          Result := SysUtils.DeleteFile(AddDirSuffix(Dir) + sr.Name);
      end;
      fr := FindNext(sr);
    end;
  finally
    SysUtils.FindClose(sr);
  end;

  if DelRoot then
    Result := RemoveDir(Dir);
end;

class procedure TCF_Directory.EnumFile(Path: string;Files: TStrings;Filter: string;
  includePath: Boolean);
var
  sr: TSearchRec;
begin
  Files.Clear;
  if FindFirst(Path + Filter, SysUtils.faArchive, sr) = 0 then
  begin
    repeat
      if (sr.Attr and SysUtils.faArchive) = sr.Attr then
      begin
        if includePath then
          Files.Add(Path + sr.Name)
        else
          Files.Add(sr.Name);
      end;

    until FindNext(sr) <> 0;
    SysUtils.FindClose(sr);
  end;

end;
class procedure TCF_Directory.ExploreDir(APath: string; ShowDir: Boolean);
var
  strExecute: AnsiString;
begin
  if not ShowDir then
    strExecute := AnsiString(Format('EXPLORER.EXE "%s"', [APath]))
  else
    strExecute := AnsiString(Format('EXPLORER.EXE /e, "%s"', [APath]));
  WinExec(PAnsiChar(strExecute), SW_SHOWNORMAL);
end;


class procedure TCF_Directory.ExploreFile(AFile: string; ShowDir: Boolean);
var
  strExecute: AnsiString;
begin
  if not ShowDir then
    strExecute := AnsiString(Format('EXPLORER.EXE /select, "%s"', [AFile]))
  else
    strExecute := AnsiString(Format('EXPLORER.EXE /e, /select, "%s"', [AFile]));
  WinExec(PAnsiChar(strExecute), SW_SHOWNORMAL);
end;

{ TCF_Array }

class function TCF_Array.IndexInt(V: integer;
  const intArray: array of integer): integer;
var
  Index: Integer;
begin
  Result := -1;
  for Index := Low(intArray) to High(intArray) do
    if V = intArray[Index] then
    begin
      Result := Index;
      Exit;
    end;
end;

class function TCF_Array.IndexStr(V: string;
  const StrArray: array of string;IgCase: Boolean = True): integer;
type
  TSameFunc = function(const S1, S2: string): Boolean;
var
  Index: Integer;
  SameFunc: TSameFunc;
begin
  Result := -1;
  if IgCase then
    SameFunc := AnsiSameText
  else
    SameFunc := AnsiSameStr;

  for Index := Low(StrArray) to High(StrArray) do
    if SameFunc(StrArray[Index], V) then
    begin
      Result := Index;
      Exit;
    end;
end;
{ TCF_Enum }

class procedure TCF_Enum.SetEnumValue(p: Pointer; Size, Value: Integer);
begin
  case Size of
    1: PByte(P)^ := Value;
    2: PWord(P)^ := Value;
    4: Pinteger(P)^ := Value;
  end;
end;

end.

