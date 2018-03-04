unit uRunningRecordsFile;

interface
uses uBytesStream,SysUtils,Classes,DateUtils,Math;
const
   //�ļ���ȡ�ɹ�
   FILE_READ_SUCCESS = 0;
   //�ļ�δ�ҵ�
   FILE_NOT_FOUND = 1;
   //�ļ����ʹ���
   FILE_TYPE_ERROR = 2;
   //�ļ����ȷǷ�
   FILE_LENGTH_INVALID = 3;
   //δ֪����
   ELSE_ERROR = 4;
   //��С�ļ�����
   MIN_FILE_LENGTH = 256;
type
  RLJKVersionInfo = Record
    strJKParamA: string;//���A�����汾
    strJKParamB: string;//���B�����汾
    strDataA: string;//����A�汾
    strDataB: string;//����B�汾
    strCommA: string;//ͨ��A�汾
    strCommB: string;//ͨ��B�汾
    strExtCommA: string;//��չͨ��A����
    strExtCommB: string;//��չͨ��B����
    strDiInfoA: string;//������ϢA����
    strDiInfoB: string;//������ϢB����
    strJKA: string;//���A����汾
    strJKB: string;//���B����汾
    strShowVersion1: string;//1����ʾ���汾
    strShowVersion2: string;//2����ʾ���汾
    strShowVersionData1: string;//�������ݰ汾1   ������
    strShowVersionData2: string;//�������ݰ汾2   ������
    strJKZZFactoryFlag: String; //���װ�ó��ұ�ʶ,���޻���˼ά
  end;

  RLKJHeaderInfo = Record
     strCheXing : String;//����
     strCheHao : String;//����
     strCheCi : String;//����
     strCheCiHead : String;//����ͷ
     strSiJiHao : String;//˾����
     strFuSiJiHao : String;//��˾����
     strKeHuo : String;//�ͻ�����,ֱ�����ַ�����ʾ,����"�ͳ�"����"����"
     dtFileDateTime : TDateTime;//���м�¼�ļ�������ʱ��,ע:���ʱ����Ҫ��������,�������ļ���Windows��ϵͳʱ��
     dtFaCheShiJian : TDateTime;//����ʱ��
     dtDaoDaShiJian : TDateTime;//����ʱ��
  end;

  TRunningRecordsFile = class
  public
    Destructor Destroy; override;
  public
    {����: ���ļ��е����ݶ�ȡ���ڴ���,�������ļ��ĺϷ��Լ�顣
     �쳣���ļ���Ч���߲����ڵ�������׳��쳣��
     ����ļ��Ϸ��ԣ���������0���쳣���أ�
    1���ļ����ͷ�2000��
    2���ļ�������}
    function LoadFromFile(const strFileName : String) : Integer;
    {���ܣ��������м�¼�ļ�������Ϣ�������䱣���������ṹ���С�
    �쳣����ȡ����������ͨ���쳣֪ͨ�� }
    procedure GetHeaderInfo(var HeaderInfo:RLKJHeaderInfo);
    {���ܣ��������м�¼�ļ�������Ϣ�������䱣���������ṹ���С�
    �쳣����ȡ����������ͨ���쳣֪ͨ��}
    function GetVersionInfo (var Version:RLJKVersionInfo):Boolean;
    {����:������һ�δ�����Ϣ}
    function GetLastError():String;
  private
    //�ļ���
    m_strFileName : String;
    //���һ�δ�����Ϣ
    m_strLastErrorInfo : String;
    //�ļ�������
    m_MsFile : TMemoryStream;
    {�ж��ļ��Ƿ�2000�ͼ�ؼ�¼�ļ������򷵻�TRUE�����򷵻�FALSE}
    function FileTypeIsJk2000(var MsJkFile : TMemoryStream) : boolean;
    {�����ֽ�BCD��ת��Ϊ16����}
    function BcdToHex(iBcd: integer): integer;
    {��������buf�ڴ�ibegin��ʼ��iLen���ֽ�ת��Ϊ16���������������ڸ��ֽڸ�λ��ǰ����λ�ں�}
    function MoreBcdToHex(buf: array of byte; ibegin,
      iLen: Integer): integer;
    {��ȡ�ͻ�����״̬��
    0: Result := '��������';
    1: Result := '�ͳ�����';
    2: Result := '��������';
    3: Result := '�ͳ�����';}
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
    if MsJkFile.Read(str, SizeOf(str)) > 31 then //��ȡ���ֽ�������32
    begin
        if ((str[0] = $A4) or (str[0] = $A2) or (str[0] = $FC)) then
        begin
            if (str[5] = $A0) or (str[6] = $A0) then
            begin
                for i := 0 to 256 do
                 if str[i]=$A0 then
                   break;
                //2H�ļ���������
                Result := FALSE;
            end
            else
                Result := FALSE; //93H�ļ���������
        end
        else if ((str[0] = $B0) and (str[1] = $F0)) and (str[16] <> $B1) then
        begin
          Result := TRUE;  //2000�ļ���
        end
        else if ((str[0] = $B0) or (str[0] = $FF)) and (str[16] = $B1) then
        begin
          //93A�ļ���������
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
  HeaderInfo.strCheXing := IntToStr(MoreBcdToHex(buf,56, 3));  //�ļ��н���¼���ʹ��룬��Ҫ��Ӧ��ϵͳ�����ó��ʹ������Ҷ�Ӧ������
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

  //HeaderInfo.dtFaCheShiJian ���տ��������ߵ�һ�����źŻ���¼ǰ�Ŀ�����¼
  while m_MsFile.Position < m_MsFile.Size do
  begin
    m_MsFile.ReadBuffer(buf,1);
    case buf[0] of
      $CE : //���źŻ�
        break;
      $CD : //���ڱ仯
        begin
          if m_MsFile.Position < m_MsFile.Size-6 then
          begin
            m_MsFile.ReadBuffer(buf,6);
            dtDate := EncodeDate(self.BcdToHex(buf[3])+2000,
                                 self.BcdToHex(buf[4]),
                                 self.BcdToHex(buf[5]));
          end;
        end;
      $D1 : //����
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
      //$D0 : //ͣ��
      $B8 :
       begin
         // B801,�����Ա�
         m_MsFile.ReadBuffer(buf,1);
         if buf[0] = 1 then
            break;
       end;
    end;  // end case
  end;   // end while

  //HeaderInfo.dtDaoDaShiJian �������һ��վ��ͣ��
  m_MsFile.Position := 0;
  m_MsFile.ReadBuffer(buf, 256);
  //Ĭ������Ϊ�ļ���������
  dtDate := EncodeDate(self.BcdToHex(buf[2])+2000,
                       self.BcdToHex(buf[3]),
                       self.BcdToHex(buf[4]));
  while m_MsFile.Position < m_MsFile.Size do
  begin
    m_MsFile.ReadBuffer(buf,1);
    case buf[0] of
      $CD : //���ڱ仯
        begin
          if m_MsFile.Position < m_MsFile.Size-6 then
          begin
            m_MsFile.ReadBuffer(buf,6);
            dtDate := EncodeDate(self.BcdToHex(buf[3])+2000,
                                 self.BcdToHex(buf[4]),
                                 self.BcdToHex(buf[5]));
          end;
        end;
      $D0 : //ͣ��
        begin
          if m_MsFile.Position < m_MsFile.Size-22 then
          begin
             m_MsFile.ReadBuffer(buf,22);
             //���״̬�£��ǵ���ͣ��
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

//��ȡ�汾��Ϣ�����в������ݰ汾A��Bû�м�¼�����޷���ȡ
function TRunningRecordsFile.GetVersionInfo(var Version: RLJKVersionInfo):Boolean;
var
  I : Integer;
  m_bytStreamForInputJKFile : TBytesStream;
begin

  Result := False;
  
  if FileExists(m_strFileName) = False then 
  begin
    m_strLastErrorInfo := '�ļ�'+m_strFileName+'������';
    Exit;
  end;
  
  m_bytStreamForInputJKFile := TBytesStream.Create(0);
  m_bytStreamForInputJKFile.ZeroBuffer;
  m_bytStreamForInputJKFile.LoadFromFile(m_strFileName);

  if m_bytStreamForInputJKFile.ReadWord(0) <> $F0B0 then
  begin
    m_strLastErrorInfo := '�ļ���ʽ����ȷ';
    Exit;
  end;

  // ��ȡ���ұ�ʶ,0��˼ά��1������
  if m_bytStreamForInputJKFile.ReadWord($56) = $045A then
    Version.strJKZZFactoryFlag := '1'
  else
    Version.strJKZZFactoryFlag := '0';


  I := FindStatPosFromJKFile(m_bytStreamForInputJKFile, $89A8);
  if I < 0 then
  begin
    m_strLastErrorInfo := '�ļ���ʽ����ȷ����ʾ��';
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
    m_strLastErrorInfo := '�ļ���ʽ����ȷ,����汾';
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
    0: Result := '��������';
    1: Result := '�ͳ�����';
    2: Result := '��������';
    3: Result := '�ͳ�����';
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
