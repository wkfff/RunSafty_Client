unit uTMImporter;

interface
uses
  classes,SysUtils,uTrainman,uSaftyEnum,uJWD,uTFSystem,forms,windows,Variants,
  uLCTrainmanMgr,uWorkShop;
type
  TTMImporter = class
  protected
    m_OnProgress: TOnReadChangeEvent;
    m_JWDArray: TRsJWDArray;
    m_WorkShopArray : TRsWorkShopArray;
    function FindJWDCode(const name: string): string;
    function FindWorkShopID(const name: string): string;
    function FindTeamID(const name: string): string;
    function FindTrainJlID(const name: string): string;
    function InitDict(): Boolean;
    function FindKeHuo(const name: string): TRsKehuo;
    function FindDriverType(const name: string): TRsDriverType;
    function FindPost(const name: string): TRsPost;
    function ConvertLevel(const value: string): integer;
    function ConvertDate(const value: string): TDateTime;
  public
    procedure Import(const fileName: string;out TMArray: TRsTrainmanArray);virtual;abstract;
    procedure CreateTemplate(const fileName: string);virtual;abstract;
    property OnProgress: TOnReadChangeEvent read m_OnProgress write m_OnProgress;
  end;

  TTMXlsImporter = class(TTMImporter)
  public
    procedure Import(const fileName: string;out TMArray: TRsTrainmanArray);override;
    procedure CreateTemplate(const fileName: string);override;
  end;


  TExportProgress = procedure(position,max : integer);
  
  TTMXlsExporter = class
  private
    class procedure CreateTitle(MSExcelWorkSheet: Variant);
    class procedure CreateBoday(MSExcelWorkSheet: Variant;TMArray: TRsTrainmanArray;Progress: TExportProgress);
  public
    class procedure SaveAs(const fileName: string;TMArray: TRsTrainmanArray;Progress: TExportProgress);
  end;
implementation

uses uGlobalDM,comobj, uLCBaseDict;

const
  XLS_COL_JWD = 1;
  XLS_COL_CC = 2;
  XLS_COL_TEAM = 3;
  XLS_COL_NUMBER = 4;
  XLS_COL_NAME = 5;
  XLS_COL_POST = 6;
  XLS_COL_TELNUMBER = 7;
  XLS_COL_CELLPHONE = 8;
  XLS_COL_ADRESS = 9;
  XLS_COL_LEVEL = 10;
  XLS_COL_DRVTYPE = 11;
  XLS_COL_KEHUO = 12;
  XLS_COL_ABCD = 13;
  XLS_COL_RUZHI = 14;
  XLS_COL_JIUZHI = 15;
  
XLSTITLES: ARRAY[XLS_COL_JWD..XLS_COL_JIUZHI] OF STRING =
('机务段','车间','指导队','工号','姓名','职位','电话','手机',
'地址','司机等级','驾驶工种','客货','ABCD','入职日期','就职日期');

{ TTMXlsImporter }

procedure TTMXlsImporter.CreateTemplate(const fileName: string);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  I: Integer;
begin
  try
    MSExcel := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  try
    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];

    for I := Low(XLSTITLES) to High(XLSTITLES) do
    begin
      MSExcelWorkSheet.Cells[1,i] := XLSTITLES[i];
    end;
    
    MSExcelWorkBook.SaveAs(FileName);
  finally
    MSExcel.quit;
  end;
end;

procedure TTMXlsImporter.Import(const fileName: string;
  out TMArray: TRsTrainmanArray);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  nIndex,nTotalCount : integer;
  S :string;
  trainman : RRsTrainman;
  dtNow: TDateTime;
begin
  MSExcelWorkBook := null;
  try
    MSExcel := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  try
    ZeroMemory(@trainman,SizeOf(trainman));

    trainman.FingerPrint1 :=NULL;
    trainman.FingerPrint2 := NULL;
    trainman.Picture := NULL;


    MSExcel.workBooks.Open(filename);
    MSExcelWorkBook :=MSExcel.Workbooks[1];
    MSExcelWorkSheet := MSExcelWorkBook.WorkSheets[1];



    for nIndex:= Low(XLSTITLES) to High(XLSTITLES) do
    begin
      s := MSExcelWorkSheet.Cells[1,nIndex];
      if s <> XLSTITLES[nIndex] then
      begin
        Box(Format('模板类型不符合要求,第 %d 列应是 "%s"',[nIndex,XLSTITLES[nIndex]]));
        Exit;
      end;
    end;

    InitDict();
    
    nIndex := 2;
    nTotalCount := 0;

    dtNow := GlobalDM.GetNow;
    while true do
    begin
      S := MSExcelWorkSheet.Cells[nIndex,4];
      if S = '' then break;
      Inc(nTotalCount);
      Inc(nIndex);
    end;

    
    if nTotalCount = 0 then
    begin
       Application.MessageBox('没有可导入的乘务员信息！','提示',MB_OK + MB_ICONINFORMATION);
       exit;
    end;
    nIndex := 2;


    SetLength(TMArray,nTotalCount);
    for nIndex := 2 to nTotalCount + 1 do
    begin
      with trainman do
      begin
        strTrainmanGUID := NewGUID;
        nTrainmanState := tsNil;
        dtCreateTime := dtNow;
        strAreaGUID := FindJWDCode(MSExcelWorkSheet.Cells[nIndex,XLS_COL_JWD]);
        strWorkShopGUID := FindWorkShopID(MSExcelWorkSheet.Cells[nIndex,XLS_COL_CC]);
        strGuideGroupGUID := FindTeamID(MSExcelWorkSheet.Cells[nIndex,XLS_COL_TEAM]);
        strTrainmanNumber := MSExcelWorkSheet.Cells[nIndex,XLS_COL_NUMBER];
        strTrainmanName := MSExcelWorkSheet.Cells[nIndex,XLS_COL_NAME];
        nPostID := FindPost(MSExcelWorkSheet.Cells[nIndex,XLS_COL_POST]);
        nDriverLevel := ConvertLevel(MSExcelWorkSheet.Cells[nIndex,XLS_COL_LEVEL]);
        nDriverType := FindDriverType(MSExcelWorkSheet.Cells[nIndex,XLS_COL_DRVTYPE]);
        nKeHuoID := FindKeHuo(MSExcelWorkSheet.Cells[nIndex,XLS_COL_KEHUO]);
        strABCD := MSExcelWorkSheet.Cells[nIndex,XLS_COL_ABCD];
        strTelNumber := MSExcelWorkSheet.Cells[nIndex,XLS_COL_TELNUMBER];
        strMobileNumber := MSExcelWorkSheet.Cells[nIndex,XLS_COL_CELLPHONE];
        strAdddress := MSExcelWorkSheet.Cells[nIndex,XLS_COL_ADRESS];
        dtRuZhiTime := ConvertDate(MSExcelWorkSheet.Cells[nIndex,XLS_COL_RUZHI]);
        dtJiuZhiTime := ConvertDate(MSExcelWorkSheet.Cells[nIndex,XLS_COL_JIUZHI]);
        strJP := GlobalDM.GetHzPy(MSExcelWorkSheet.Cells[nIndex,XLS_COL_NAME]);
      end;

      TMArray[nIndex - 2] := trainman;
      if Assigned(m_OnProgress) then
      begin
        m_OnProgress(nTotalCount,nIndex - 1);
      end;
    end;
  finally
    MSExcel.Quit;
    MSExcel := Unassigned;
  end;
end;

{ TTMImporter }

function TTMImporter.ConvertDate(const value: string): TDateTime;
  function TruncFirstInt(Delimiter: char;var s: string): integer;
  var
    nIndex: integer;
    s1: string;
  begin
    Result := 0;
    nIndex := Pos(Delimiter,s);
    if nIndex > 1 then
    begin
      s1 := Copy(s,1,nIndex - 1);
      s := Copy(s,nIndex + 1,Length(s) - nIndex - 1);
      Result := StrToIntDef(s1,0);
    end;
  end;
var
  s: string;
  nYear: integer;
  nMonth: integer;
  nDay: integer;
  Delimiter: char;
begin
  Result := 0;
  s := value;
  if Pos('.',s) > 0 then
    Delimiter := '.'
  else
  if Pos('-',value) > 0 then
    Delimiter := '-'
  else
    Exit;


  

  nYear := TruncFirstInt(Delimiter,s);
  if nYear < 1900 then Exit;

  nMonth := TruncFirstInt(Delimiter,s);
  if nMonth = 0 then
    nMonth := 1;

  nDay := TruncFirstInt(Delimiter,s);
  if nDay = 0 then
    nDay := 1;

  Result := EncodeDate(nYear,nMonth,nDay);

end;

function TTMImporter.ConvertLevel(const value: string): integer;
var
  s: string;
begin
  s := Trim(value);
  Result := 0;
  if s = '' then Exit;

  if S[1] in ['0'..'9'] then
    Result := StrToInt(S[1])
  else
  if S[1] in ['A'..'Z'] then
    Result := Ord(S[1]) - Ord('A') + 1
  else
  if S[1] in ['a'..'z'] then
    Result := Ord(S[1]) - Ord('a') + 1;

end;

function TTMImporter.FindDriverType(const name: string): TRsDriverType;
var
  driverType: TRsDriverType; 
begin
  Result := drtNone;
  for driverType := low(TRsDriverType) to high(TRsDriverType) do
  begin
    if TRsDriverTypeNameArray[driverType] =  name then
       Result := driverType;
  end;
end;

function TTMImporter.FindJWDCode(const name: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(m_JWDArray) - 1 do
  begin
    if m_JWDArray[i].strName = name then
    begin
      result := m_JWDArray[i].strUserCode;
      break;
    end;
  end;
end;

function TTMImporter.FindKeHuo(const name: string): TRsKehuo;
begin
  Result := khNone;
  if Pos('客',name) > 0 then
    Result := khKe
  else
  if Pos('货',name) > 0 then
    Result := khHuo
  else
  if Pos('调',name) > 0 then
  Result := khDiao;

end;

function TTMImporter.FindPost(const name: string): TRsPost;
var
  post: TRsPost;
begin
  Result := ptNone;
  for post := low(TRsPost) to high(TRsPost) do
  begin
    if TRsPostNameAry[post] = name then
      Result := post;
  end;
end;

function TTMImporter.FindTeamID(const name: string): string;
begin
  if name = '' then
    Result := ''
  else
    result := RsLCBaseDict.LCGuideGroup.GetGuideGroupGUIDByName(name);
end;

function TTMImporter.FindTrainJlID(const name: string): string;
begin
  Result := '';
end;

function TTMImporter.FindWorkShopID(const name: string): string;
begin
  if name = '' then
    Result := ''
  else
    RsLCBaseDict.LCWorkShop.GetWorkShopGUIDByName(name)
end;

function TTMImporter.InitDict: Boolean;
var
  error: string;
begin
  Result := False;
  if not RsLCBaseDict.LCJwd.GetAllJwdList(m_JWDArray,error) then
  begin
    Application.MessageBox(pchar(error),'错误',MB_OK + MB_ICONERROR);
    Exit;
  end;
  

  Result := True;
end;

{ TTMXlsExporter }

class procedure TTMXlsExporter.CreateBoday(MSExcelWorkSheet: Variant;TMArray: TRsTrainmanArray;Progress: TExportProgress);
var
  i: integer;
  range: Variant;
begin
  for i := 0 to Length(TMArray) - 1 do
  begin
    if Assigned(Progress) then
      Progress(i + 1,Length(TMArray));
    
    MSExcelWorkSheet.Cells[i + 2,1] := TMArray[i].strWorkShopName;
    MSExcelWorkSheet.Cells[i + 2,2] := TMArray[i].strGuideGroupName;
    MSExcelWorkSheet.Cells[i + 2,3] := TMArray[i].strTrainmanNumber;
    MSExcelWorkSheet.Cells[i + 2,4] := TMArray[i].strTrainmanName;
    MSExcelWorkSheet.Cells[i + 2,5] := TRsPostNameAry[TMArray[i].nPostID];
    range := MSExcelWorkSheet.Cells[i + 2,6];
    range.FormulaR1C1  := TMArray[i].strTelNumber;
    range := MSExcelWorkSheet.Cells[i + 2,7];
    range.FormulaR1C1  := TMArray[i].strMobileNumber;
    MSExcelWorkSheet.Cells[i + 2,8] := TMArray[i].strAdddress;
    MSExcelWorkSheet.Cells[i + 2,9] := IntToStr(TMArray[i].nDriverLevel);
    MSExcelWorkSheet.Cells[i + 2,10] := TRsDriverTypeNameArray[TMArray[i].nDriverType];
    MSExcelWorkSheet.Cells[i + 2,11] := TRsKeHuoNameArray[TMArray[i].nKeHuoID];
    MSExcelWorkSheet.Cells[i + 2,12] := TMArray[i].strABCD;
    
    if TMArray[i].dtRuZhiTime > 1 then
    MSExcelWorkSheet.Cells[i + 2,13] := FormatDateTime('yyyy-MM-dd',TMArray[i].dtRuZhiTime);
    
    if TMArray[i].dtJiuZhiTime > 1 then    
    MSExcelWorkSheet.Cells[i + 2,14] := FormatDateTime('yyyy-MM-dd',TMArray[i].dtJiuZhiTime);
  end;
end;

class procedure TTMXlsExporter.CreateTitle(MSExcelWorkSheet: Variant);
var
  I: Integer;
begin
  //导出信息中没有机务段
  for I := Low(XLSTITLES) + 1  to High(XLSTITLES) do
  begin
    MSExcelWorkSheet.Cells[1,i - 1] := XLSTITLES[i];
  end;
end;

class procedure TTMXlsExporter.SaveAs(const fileName: string;
  TMArray: TRsTrainmanArray;Progress: TExportProgress);
var
  MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
  defautExt,fullName: string;
  version: Double;
begin
  try
    MSExcel := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  
  try
    if TryStrToFloat(MSExcel.Version,version) then
    begin
      if version >= 12 then
        defautExt := '.xlsx'
      else
        defautExt := '.xls';
    end
    else
      defautExt := '.xls';

    if ExtractFileExt(FileName) = '' then
      fullName := FileName + defautExt
    else
      fullName := FileName;

      
    MSExcelWorkBook := MSExcel.WorkBooks.Add();
    MSExcelWorkSheet := MSExcelWorkBook.Worksheets[1];
    
    CreateTitle(MSExcelWorkSheet);
    CreateBoday(MSExcelWorkSheet,TMArray,Progress);
    
    MSExcelWorkBook.SaveAs(fullName);
  finally
    MSExcel.Quit;
    MSExcel := Unassigned;
  end;
end;

end.
