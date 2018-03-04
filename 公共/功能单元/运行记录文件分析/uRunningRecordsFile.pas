unit uRunningRecordsFile;

interface
uses uBytesStream,SysUtils,Classes,DateUtils,Math;
const
   //文件读取成功
   FILE_READ_SUCCESS = 0;
   //文件未找到
   FILE_NOT_FOUND = 1;
   //文件类型错误
   FILE_TYPE_ERROR = 2;
   //文件长度非法
   FILE_LENGTH_INVALID = 3;
   //未知错误
   ELSE_ERROR = 4;
   //最小文件长度
   MIN_FILE_LENGTH = 256;
type
  RLJKVersionInfo = Record
    strJKParamA: string;//监控A参数版本
    strJKParamB: string;//监控B参数版本
    strDataA: string;//数据A版本
    strDataB: string;//数据B版本
    strCommA: string;//通信A版本
    strCommB: string;//通信B版本
    strExtCommA: string;//扩展通信A程序
    strExtCommB: string;//扩展通信B程序
    strDiInfoA: string;//地面信息A程序
    strDiInfoB: string;//地面信息B程序
    strJKA: string;//监控A程序版本
    strJKB: string;//监控B程序版本
    strShowVersion1: string;//1端显示器版本
    strShowVersion2: string;//2端显示器版本
    strShowVersionData1: string;//彩屏数据版本1   ？？？
    strShowVersionData2: string;//彩屏数据版本2   ？？？
    strJKZZFactoryFlag: String; //监控装置厂家标识,株洲或者思维
  end;

  RLKJHeaderInfo = Record
     strCheXing : String;//车型
     strCheHao : String;//车号
     strCheCi : String;//车次
     strCheCiHead : String;//车次头
     strSiJiHao : String;//司机号
     strFuSiJiHao : String;//副司机号
     strKeHuo : String;//客货类型,直接用字符串表示,例如"客车"或者"货车"
     dtFileDateTime : TDateTime;//运行记录文件的生成时间,注:这个时间需要分析出来,而不是文件在Windows的系统时间
     dtFaCheShiJian : TDateTime;//发车时间
     dtDaoDaShiJian : TDateTime;//到达时间
  end;

  TRunningRecordsFile = class
  public
    Destructor Destroy; override;
  public
    {功能: 从文件中的内容读取至内存中,并进行文件的合法性检查。
     异常：文件无效或者不存在等情况下抛出异常。
     检查文件合法性，正常返回0，异常返回：
    1：文件类型非2000型
    2：文件不存在}
    function LoadFromFile(const strFileName : String) : Integer;
    {功能：分析运行记录文件基本信息，并将其保存至给定结构体中。
    异常：读取等其他错误通过异常通知。 }
    procedure GetHeaderInfo(var HeaderInfo:RLKJHeaderInfo);
    {功能：分析运行记录文件基本信息，并将其保存至给定结构体中。
    异常：读取等其他错误通过异常通知。}
    function GetVersionInfo (var Version:RLJKVersionInfo):Boolean;
    {功能:获得最后一次错误信息}
    function GetLastError():String;
  private
    //文件名
    m_strFileName : String;
    //最后一次错误信息
    m_strLastErrorInfo : String;
    //文件缓冲区
    m_MsFile : TMemoryStream;
    {判断文件是否2000型监控记录文件，是则返回TRUE，否则返回FALSE}
    function FileTypeIsJk2000(var MsJkFile : TMemoryStream) : boolean;
    {将单字节BCD码转换为16进制}
    function BcdToHex(iBcd: integer): integer;
    {将缓冲区buf内从ibegin开始的iLen个字节转换为16进制数（缓冲区内各字节高位在前，低位在后）}
    function MoreBcdToHex(buf: array of byte; ibegin,
      iLen: Integer): integer;
    {获取客货本补状态：
    0: Result := '货车本务';
    1: Result := '客车本务';
    2: Result := '货车补机';
    3: Result := '客车补机';}
    function GetKeHuoString(byKH : byte) : string;
    function FindStatPosFromJKFile(bytStream: TBytesStream;
       wFindValue: Word): Integer;
    function ReadJKDateInfo(nPos: Integer; bytStream: TBytesStream): string;       
  end;

implementation

{ TRunningRecordsFile }

function TRunningRecordsFile.FindStatPosFromJKFile(bytStream: TBytesStream;
  wFindValue: Word): Integer;
var
  nRange: Int64;
  I: Integer;
  bytH, bytL: Byte;
begin
  nRange := $1A4;
  Result := -1;
  bytL := wFindValue and $FF;
  bytH := wFindValue and $FF00 shr 8;

  if bytStream.GetSize < nRange then
    Exit;
  for I := 0 to nRange - 1 do
  begin
    if (bytStream.Bytes[I] = bytL) and (bytStream.Bytes[I + 1] = bytH) then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function TRunningRecordsFile.FileTypeIsJk2000(var MsJkFile : TMemoryStream): boolean;
var
    str:array[0..255] of byte;
    i:integer;
begin
    Result := FALSE;
    MsJkFile.Position := 0;
    if MsJkFile.Read(str, SizeOf(str)) > 31 then //读取的字节数大于32
    begin
        if ((str[0] = $A4) or (str[0] = $A2) or (str[0] = $FC)) then
        begin
            if (str[5] = $A0) or (str[6] = $A0) then
            begin
                for i := 0 to 256 do
                 if str[i]=$A0 then
                   break;
                //2H文件，不处理
                Result := FALSE;
            end
            else
                Result := FALSE; //93H文件，不处理
        end
        else if ((str[0] = $B0) and (str[1] = $F0)) and (str[16] <> $B1) then
        begin
          Result := TRUE;  //2000文件。
        end
        else if ((str[0] = $B0) or (str[0] = $FF)) and (str[16] = $B1) then
        begin
          //93A文件，不处理
          Result := FALSE;
        end;
    end;

end;

procedure TRunningRecordsFile.GetHeaderInfo(
  var HeaderInfo: RLKJHeaderInfo);
var
  buf : array[0..255] of byte;
  dtDate : TDateTime;
begin
  FillChar(HeaderInfo, SizeOf(HeaderInfo), 0);

  m_MsFile.Position := 0;

  m_MsFile.ReadBuffer(buf, 256);

  HeaderInfo.strSiJiHao := IntToStr(MoreBcdToHex(buf,24, 4));
  HeaderInfo.strFuSiJiHao := IntToStr(MoreBcdToHex(buf,28, 4));
  HeaderInfo.strKeHuo := self.GetKeHuoString(BcdToHex(buf[9]));

  HeaderInfo.strCheCiHead :=
    Trim(Chr(buf[10])+Chr(buf[11])+Chr(buf[12])+Chr(buf[13]));

  HeaderInfo.strCheCi :=
      IntToStr(MoreBcdToHex(buf,14, 3));
  HeaderInfo.strCheHao := IntToStr(MoreBcdToHex(buf,60, 3));
  HeaderInfo.strCheXing := IntToStr(MoreBcdToHex(buf,56, 3));  //文件中仅记录车型代码，需要在应用系统中设置车型代码表查找对应描述。
  HeaderInfo.dtFileDateTime := EncodeDateTime(self.BcdToHex(buf[2])+2000,
                                              self.BcdToHex(buf[3]),
                                              self.BcdToHex(buf[4]),
                                              self.BcdToHex(buf[5]),
                                              self.BcdToHex(buf[6]),
                                              self.BcdToHex(buf[7]),
                                              0);
  dtDate := EncodeDate(self.BcdToHex(buf[2])+2000,
                       self.BcdToHex(buf[3]),
                       self.BcdToHex(buf[4]));

  //HeaderInfo.dtFaCheShiJian 按照开车键或者第一条过信号机记录前的开车记录
  while m_MsFile.Position < m_MsFile.Size do
  begin
    m_MsFile.ReadBuffer(buf,1);
    case buf[0] of
      $CE : //过信号机
        break;
      $CD : //日期变化
        begin
          if m_MsFile.Position < m_MsFile.Size-6 then
          begin
            m_MsFile.ReadBuffer(buf,6);
            dtDate := EncodeDate(self.BcdToHex(buf[3])+2000,
                                 self.BcdToHex(buf[4]),
                                 self.BcdToHex(buf[5]));
          end;
        end;
      $D1 : //开车
        begin
          if m_MsFile.Position < m_MsFile.Size-26 then
          begin
             m_MsFile.ReadBuffer(buf,26);
             HeaderInfo.dtFaCheShiJian := dtDate+EncodeTime(self.BcdToHex(buf[0]),
                                                  self.BcdToHex(buf[1]),
                                                  self.BcdToHex(buf[2]),
                                                  0);
          end
          else
            break;
        end;
      //$D0 : //停车
      $B8 :
       begin
         // B801,开车对标
         m_MsFile.ReadBuffer(buf,1);
         if buf[0] = 1 then
            break;
       end;
    end;  // end case
  end;   // end while

  //HeaderInfo.dtDaoDaShiJian 按照最后一次站内停车
  m_MsFile.Position := 0;
  m_MsFile.ReadBuffer(buf, 256);
  //默认日期为文件创建日期
  dtDate := EncodeDate(self.BcdToHex(buf[2])+2000,
                       self.BcdToHex(buf[3]),
                       self.BcdToHex(buf[4]));
  while m_MsFile.Position < m_MsFile.Size do
  begin
    m_MsFile.ReadBuffer(buf,1);
    case buf[0] of
      $CD : //日期变化
        begin
          if m_MsFile.Position < m_MsFile.Size-6 then
          begin
            m_MsFile.ReadBuffer(buf,6);
            dtDate := EncodeDate(self.BcdToHex(buf[3])+2000,
                                 self.BcdToHex(buf[4]),
                                 self.BcdToHex(buf[5]));
          end;
        end;
      $D0 : //停车
        begin
          if m_MsFile.Position < m_MsFile.Size-22 then
          begin
             m_MsFile.ReadBuffer(buf,22);
             //监控状态下，非调车停车
             if (self.BcdToHex(buf[21]) and $6 = 4) and (self.BcdToHex(buf[21]) and $6 <> 2) then
             begin
               HeaderInfo.dtDaoDaShiJian := dtDate+EncodeTime(self.BcdToHex(buf[0]),
                                                  self.BcdToHex(buf[1]),
                                                  self.BcdToHex(buf[2]),
                                                  0);
             end;
                
          end
          else
            break;
        end;
    end;  // end case
  end;   // end while

end;

//读取版本信息，其中彩屏数据版本A，B没有记录，暂无法获取
function TRunningRecordsFile.GetVersionInfo(var Version: RLJKVersionInfo):Boolean;
var
  I : Integer;
  m_bytStreamForInputJKFile : TBytesStream;
begin

  Result := False;
  
  if FileExists(m_strFileName) = False then 
  begin
    m_strLastErrorInfo := '文件'+m_strFileName+'不存在';
    Exit;
  end;
  
  m_bytStreamForInputJKFile := TBytesStream.Create(0);
  m_bytStreamForInputJKFile.ZeroBuffer;
  m_bytStreamForInputJKFile.LoadFromFile(m_strFileName);

  if m_bytStreamForInputJKFile.ReadWord(0) <> $F0B0 then
  begin
    m_strLastErrorInfo := '文件格式不正确';
    Exit;
  end;

  // 读取厂家标识,0是思维，1是株所
  if m_bytStreamForInputJKFile.ReadWord($56) = $045A then
    Version.strJKZZFactoryFlag := '1'
  else
    Version.strJKZZFactoryFlag := '0';


  I := FindStatPosFromJKFile(m_bytStreamForInputJKFile, $89A8);
  if I < 0 then
  begin
    m_strLastErrorInfo := '文件格式不正确，显示屏';
    Exit;
  end;

  Inc(I, 5);
  Version.strShowVersion1 := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strShowVersion2 := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strShowVersionData1 := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strShowVersionData2 := ReadJKDateInfo(I, m_bytStreamForInputJKFile);


  I := FindStatPosFromJKFile(m_bytStreamForInputJKFile, $87A8);
  if I < 0 then
  begin
    m_strLastErrorInfo := '文件格式不正确,程序版本';
    Exit;
  end;

  Inc(I, 5);
  Version.strJKA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strJKB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strDataA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strDataB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strCommA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strCommB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strExtCommA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strExtCommB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strDiInfoA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strDiInfoB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strJKParamA := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
  Inc(I, 3);
  Version.strJKParamB := ReadJKDateInfo(I, m_bytStreamForInputJKFile);
end;

function TRunningRecordsFile.LoadFromFile(const strFileName: String) : Integer;
begin
  try
    Result := FILE_READ_SUCCESS;
    if Assigned(m_MsFile) = False then
      m_MsFile := TMemoryStream.Create;
    if not FileExists(strFileName) then
    begin
      Result := FILE_NOT_FOUND;
      Exit;
    end
    else
      m_MsFile.LoadFromFile(strFileName);

    if not FileTypeIsJk2000(m_MsFile) then
      Result := FILE_TYPE_ERROR
    else
    if m_MsFile.Size < MIN_FILE_LENGTH then
       Result := FILE_LENGTH_INVALID
    else
       Result := FILE_READ_SUCCESS;

    m_strFileName := strFileName;
  Except
    Result := ELSE_ERROR;
    if Assigned(m_MsFile) then
    begin
       m_MsFile.Free;
       m_MsFile := nil;
    end;
  end;
end;

function TRunningRecordsFile.BcdToHex(iBcd: integer): integer;
begin
  Result := (iBcd div 16) * 10 + (iBcd mod 16);
end;

function TRunningRecordsFile.MoreBcdToHex(buf : array of byte; ibegin, iLen: Integer): integer;
var
     i: integer;
     k: Extended;
     l: Integer;
begin
     k := 0;
     l := 0;
     for i := iLen - 1 downto 0 do
     begin
          k := k + BcdToHex(buf[ibegin + i]) * Power(100, l);
          Inc(l);
     end;
     Result := Round(k);
end;

function TRunningRecordsFile.ReadJKDateInfo(nPos: Integer;
  bytStream: TBytesStream): string;
begin
  Result := '20000000';
  if Assigned(bytStream) then
  begin
    Result := Format('%.4d%.2d%.2d',
        [StrToInt(bytStream.ReadBytesAsString(nPos, 1)) + 2000,
        StrToInt(bytStream.ReadBytesAsString(nPos + 1, 1)),
        StrToInt(bytStream.ReadBytesAsString(nPos + 2, 1))]);
  end;
end;

function TRunningRecordsFile.GetKeHuoString(byKH: byte): string;
begin
  Result := '';
  case byKH of
    0: Result := '货车本务';
    1: Result := '客车本务';
    2: Result := '货车补机';
    3: Result := '客车补机';
  end;
end;

function TRunningRecordsFile.GetLastError: String;
begin
  Result := m_strLastErrorInfo;
end;

destructor TRunningRecordsFile.Destroy;
begin
  if Assigned(m_MsFile) then
  begin
    m_MsFile.Free;
    m_MsFile := nil;
  end;
end;

end.
