unit UCommand;

interface

uses Classes, SysUtils, Windows, UntDeclare, dialogs, Forms, DateUtils,
 uBaseDefine;

const
  N_Top = 0; //���ֵ��ϰ벿��
  N_Bottum = 1; //���ֵ��°벿��
  N_CatchPhoto = 1; //��׽ͼ���ֽ�
  N_Not_CatchPhoto = 0; //����׽ͼ���ֽ�

  //�����ط�ԭ������
  cs_NotDefine = 'û�ж���m_funReadPort';
  cs_ReadFail = '��ȡ�豸ʧ��';
  cs_LenNotSave = '�յ�����ͷ�������ĳ��Ȳ�һ��';
  cs_FistByteNotSave = '�յ�����ͷ�����������ֽڲ�һ��';
  cs_FistByteNotExist = '�յ��������ֽڲ�����';
  cs_CheckByteNotRight = 'У���ֽڴ���';
  cs_StatusIsWrong = '����״̬����ȷ';

  CREAD = FALSE;
  CWRITE = True;

type
  TSndAry116 = array[0..115] of Byte;
  TSndAry64 = array[0..63] of Byte;
  TSndAry58 = array[0..57] of Byte;
  TStandAry6 = array[0..5] of Byte;

type
  RSendArray = record
    nSendLength: Integer; //���������ֽڳ���
    SendArray: TSndAry64; //�����ֽ�����
  end;

type
    RrecArray = record
        nRecLength: Integer; //���յ��������
        RecArray: TSndAry64; //���յ����������
    end;
///////////////////////////////////////////////////////////////////////////////
// �������
// ÿ�δ���һ֡������
///////////////////////////////////////////////////////////////////////////////
    TCmdBase = class
    private
        m_StrErr: string; //�ط������ԭ������
        m_bRepeateSend: Boolean; //�Ƿ����·��ʹ�����
        m_bCheckRecData: Boolean; //����յ�����У��λ
        m_RSendArray: RSendArray; //��������ṹ��
        m_RrecArray: RrecArray; //��������ṹ��
        m_byVersion: Byte; //Э��汾��
    public
      procedure CheckArray; //��������ʱ����У������
      procedure MakeArray; virtual; abstract; //���չ�������

      function CheckRecArray: Boolean; virtual; abstract; //У����յ��������ȷ��

      procedure WriteRecLen(Len: Integer); //���յ�����ĳ���
      procedure WriteRec(Index: Integer; val: Byte); //���յ������ֵ

      function copyEx(strTT: string; nStart: Integer; nEnd: Integer): string;

      {���ܣ���������}
      procedure TranslationData();virtual; abstract;

      procedure WriteRepeateInfo(bRe: Boolean; strErr: string);

      property RSendArray: RSendArray read m_RSendArray;

      property RecArray : RrecArray read m_RrecArray;

      property bCheckRecData: Boolean read m_bCheckRecData write m_bCheckRecData;

      property strErr: string read m_StrErr;

      property ByVersion: Byte read m_byVersion;

    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///TCmdAA ����AA�������
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA = class(TCmdBase)
    public
      constructor Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
    private
      m_YJDT_First, m_YJDT: TDateTime;
      m_ApparatusInfo : RApparatusInfo;//�������Ϣ
    public
      procedure MakeArray; override;
      procedure WriteStandVolt(StandAry: TStandAry6); //д��׼ֵ
      function CheckRecArray: Boolean; override; //У����յ��������ȷ��
      procedure TranslationData(); override; //�յ��������
    public
      property ApparatusInfo : RApparatusInfo read m_ApparatusInfo;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///TCmdAA_Start ��ʼ���������
    ///���ܣ����ʹ������Һ������������棬��ʾ���������š���ƽ���Ͳ�ƺ���
    ///ʹ�÷�Χ��D12оƬ��Ч�� 374оƬ(�����Ƿ����Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_Start = class(TCmdAA)
    public
        constructor Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
        procedure TranslationData(); override; //�յ��������
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ �ȴ����������
    ///���ܣ����ʹ������Һ�������������棬��ʾ������......��
    ///ʹ�÷�Χ��D12оƬ��Ч�� 374оƬ(�����Ƿ����Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_Prepare = class(TCmdAA)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
    end;


    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ �ȴ�������
    ///���ܣ���������ͷ������£����ʹ��������ʾ���ź�������Ļ�·�����ʾ�����ơ� ������
    ///      ���ߡ������ˡ� ���ڿ�ʼ�����ˣ�ʹ�����Ӳ���������߱���ͬ��
    ///ʹ�÷�Χ��D12оƬ��Ч�� 374оƬ(�����Ƿ����Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_ListQZJ = class(TCmdAA)
    public
        constructor Create();
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
    end;


    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ ����������
    ///���ܣ����ʹ������Һ������ʾһ�����֡�
    ///ʹ�÷�Χ��D12оƬ��Ч�� 374оƬ(�����Ƿ����Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGH = class(TCmdBase)
    public
        constructor Create(SndAry58: TSndAry58; nIndex: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
        procedure TranslationData(); override; //�յ��������
    end;

    ///////////////////////////////////////////////////////////////////////////////
    ///�ࣺ ����������
    ///���ܣ����ʹ������Һ������ʾ������֣���������к������֣����ֵ���һ�����֡�
    ///ʹ�÷�Χ��D12оƬ��Ч�� 374оƬ(�����Ƿ����Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdName = class(TCmdBase)
    public
        constructor Create(SendAry: TSndAry116; nIndex, nTopOrBottom: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
        procedure TranslationData(); override; //�յ��������
    end;


    ///////////////////////////////////////////////////////////////////////////////
    ///�ࣺ ����׼��ѹ����
    ///���ܣ����ʹ��������Ƭ����ȡ��׼��ѹ��
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(TJJC-IA,û��Һ����)��Ч, ��Һ����ʾ����Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGetVolt = class(TCmdBase)
    private
      m_ApparatusBaseVlt : RApparatusVoltage;//��׼��ѹ
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //У����յ��������ȷ��
      procedure TranslationData(); override;
      property ApparatusBaseVlt : RApparatusVoltage read m_ApparatusBaseVlt;
    end;
    ///////////////////////////////////////////////////////////////////////////////
    ///�ࣺ �����Ʊ�׼����
    ///���ܣ����ʹ��������Ƭ����ȡ��׼��ѹ��
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(TJJC-IA,û��Һ����)��Ч, ��Һ����ʾ����Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdGetStdVolt = class(TCmdGetVolt)
    private
      m_byStandVolt: TStandAry6;//���Ʊ�׼
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //У����յ��������ȷ��
      procedure TranslationData(); override; //�յ��������
      property StandVolt : TStandAry6 read m_byStandVolt;

    end;

    ///////////////////////////////////////////////////////////////////////////////
    ///�ࣺ д��׼��ѹ����
    ///���ܣ����ʹ��������Ƭ��д��׼��ѹ��
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(TJJC-IA,û��Һ����)��Ч, ��Һ����ʾ����Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdWriteVolt = class(TCmdBase)
    public
      Constructor Create(SendAry: TStandAry6);
    public
      procedure MakeArray; override;
      function CheckRecArray: Boolean; override; //У����յ��������ȷ��
      procedure TranslationData(); override;
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ 374оƬ��λ����
    ///���ܣ����ʹ������374оƬ���и�λ������
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(��Һ��������Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdStopRefrash = class(TCmdBase)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
        procedure TranslationData(); override; //�յ��������
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ ����ͷ��λ����
    ///���ܣ����ʹ����������ͷ���и�λ������
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(��Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdResetCamera = class(TCmdBase)
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
    end;

    ////////////////////////////////////////////////////////////////////////////////
    ///�ࣺ ����������
    ///���ܣ����ʹ����������ͷ���и�λ������
    ///ʹ�÷�Χ��D12оƬ��Ч��374оƬ(��Һ����)��Ч
    ////////////////////////////////////////////////////////////////////////////////
    TCmdAA_PlayRecSound = class(TCmdBase)
    public
        constructor Create(nRecIndex: Integer);
    public
        procedure MakeArray; override;
        function CheckRecArray: Boolean; override; //У����յ��������ȷ��
        procedure TranslationData(); override;
      end;

implementation

{ TCmdBase }

procedure TCmdBase.CheckArray;
//����У�������
var
    I, Len: Integer;
begin
    Len := m_RSendArray.nSendLength;
    m_RSendArray.SendArray[Len - 1] := 0;
    for I := 0 to Len - 2 do
        m_RSendArray.SendArray[Len - 1] := m_RSendArray.SendArray[Len - 1] +
        m_RSendArray.SendArray[I];
    m_RSendArray.SendArray[Len - 1] := 0 - m_RSendArray.SendArray[Len - 1];
end;


function TCmdBase.copyEx(strTT: string; nStart: Integer; nEnd: Integer): string;
var
    strTemp: string;
begin
    strTemp := Copy(FormatDateTime('YYYY-MM-DD HH:MM:SS', now), 12, 8);
    Result := Copy(strTemp, nStart, nEnd);
end;

procedure TCmdBase.WriteRec(Index: Integer; val: Byte);
begin
    m_RrecArray.RecArray[Index] := val;
end;

procedure TCmdBase.WriteRecLen(Len: Integer);
begin
    m_RrecArray.nRecLength := Len;
end;

procedure TCmdBase.WriteRepeateInfo(bRe: Boolean; strErr: string);
begin
    m_bRepeateSend := bRe;
    m_StrErr := strErr;
end;


{ TCmdAA }

function TCmdAA.CheckRecArray: Boolean;
var
  I: Integer;
  Date: byte;
  bIsValid: Boolean;
begin
  //Ĭ����ȷ�Լ����ȷ
  Result := True;
  Date := 0;

  //���ͺͽ������ݳ��Ȳ�һ��
  if (m_RrecArray.nRecLength <> m_RSendArray.nSendLength) then
  begin
    WriteRepeateInfo(True, cs_LenNotSave);
    Result := False;
    Exit;
  end;

  //���ͺͽ����������ֽڲ�һ��
  if (m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0]) then
  begin
    WriteRepeateInfo(True, cs_LenNotSave);
    Result := False;
    Exit;
  end;

  //���ֽڲ���Э��涨�ķ�Χ֮��
  if not ((m_RrecArray.RecArray[0] = $AA)) then
  begin
    WriteRepeateInfo(True, cs_FistByteNotExist);
    Result := False;
    Exit;
  end;

  //�յ�����У���ֽڲ���ȷ
  if self.bCheckRecData then
  begin
    for I := 0 to RSendArray.nSendLength - 2 do
      Date := m_RrecArray.RecArray[I] + Date;
    Date := not (Date) + 1;
    if Date <> m_RrecArray.RecArray[RSendArray.nSendLength - 1] then
    begin
      WriteRepeateInfo(True, cs_CheckByteNotRight);
      Result := False;
      Exit;
    end;
  end;

  bIsValid := (m_RrecArray.RecArray[0] and $00 = $00) or
    (m_RrecArray.RecArray[0] and crReady = crReady) or
    (m_RrecArray.RecArray[0] and $02 = $02) or
    (m_RrecArray.RecArray[0] and $14 = $14) or
    (m_RrecArray.RecArray[0] and $18 = $18);

  if bIsValid = False then
  begin
    WriteRepeateInfo(True, cs_StatusIsWrong);
    Result := False;
    Exit;
  end;
  
end;

constructor TCmdAA.Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
var
  I: Integer;
begin
  for I := 0 to 5 do
    m_RSendArray.SendArray[I + 3] := StandAry[I]; //���������ƣ���Ʊ�׼
  if bDisplayMeasure then //Һ����ʾ�����Ƿ���ʾ��ƺ���
    m_RSendArray.SendArray[2] := $05
  else
    m_RSendArray.SendArray[2] := $01;

  m_YJDT := now;
  m_YJDT_First := now;
end;

procedure TCmdAA.MakeArray;
var
  StrHH, StrMM, StrSS: string;
begin
  m_RSendArray.nSendLength := 16;

  m_RSendArray.SendArray[0] := $AA;


  m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
  m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
  m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

  strHH := copyEx(FormatDateTime('tt', now), 1, 2);
  m_RSendArray.SendArray[12] := StrToInt(strHH);

  strMM := copyEx(FormatDateTime('tt', now), 4, 2);
  m_RSendArray.SendArray[13] := StrToInt(strMM);

  strSS := copyEx(FormatDateTime('tt', now), 7, 2);
  m_RSendArray.SendArray[14] := StrToInt(strSS);

  CheckArray;
end;

procedure TCmdAA.TranslationData();
//���ܣ�����AAЭ������
begin
  m_byVersion := m_RrecArray.RecArray[8]; //Э��汾��

  CopyMemory(@m_ApparatusInfo,@m_RrecArray.RecArray[1],2);
  m_ApparatusInfo.wStatus := m_RrecArray.RecArray[3];
  m_ApparatusInfo.bReady := (Bits(m_RrecArray.RecArray[3],0,0) = 1);

  CopyMemory(@m_ApparatusInfo.dwHVoltage0,@m_RrecArray.RecArray[4],2);
  CopyMemory(@m_ApparatusInfo.dwHVoltage1,@m_RrecArray.RecArray[6],2);

  m_ApparatusInfo.bSensorStatus := (m_ApparatusInfo.wStatus and $20) = $20; //������״̬


end;




procedure TCmdAA.WriteStandVolt(StandAry: TStandAry6);
//���ܣ�д���׼
var
  I: Integer;
begin
  for I := 0 to 5 do
    m_RSendArray.SendArray[I+3] := StandAry[I];
end;

{ TCmdGH }

function TCmdGH.CheckRecArray: Boolean;
begin
    Result := True;
   //�жϳ���
    if m_RrecArray.nRecLength <> m_RSendArray.nSendLength then
        begin
            Result := False;
            Exit;
        end;

   //���ֽ��Ƿ�Ϊ $E0 �����
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;
   //ĩ�ֽ��Ƿ����
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;

   //�ж�У���
    if m_RrecArray.RecArray[63] <> m_RSendArray.SendArray[63] then
        begin
            Result := False;
            Exit;
        end;
end;

constructor TCmdGH.Create(SndAry58: TSndAry58; nIndex: Integer);
var
    I: Integer;
begin
    for I := 0 to 57 do
        m_RSendArray.SendArray[I + 3] := SndAry58[I]; //��ģ
    m_RSendArray.SendArray[1] := nIndex; //����Ŵ�0��ʼ
end;

procedure TCmdGH.MakeArray;
begin
    m_RSendArray.nSendLength := 64;
    m_RSendArray.SendArray[0] := $EE;

    m_RSendArray.SendArray[2] := $00;

    m_RSendArray.SendArray[61] := $00;
    m_RSendArray.SendArray[62] := $00;

    CheckArray
end;

procedure TCmdGH.TranslationData;
begin

end;

{ TCmdAA_Start }

function TCmdAA_Start.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_Start.Create(StandAry: TStandAry6; bDisplayMeasure: boolean);
begin
    if bDisplayMeasure then
        m_RSendArray.SendArray[2] := $0D
    else
        m_RSendArray.SendArray[2] := $09
end;

procedure TCmdAA_Start.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;
    OutPutdebugString(PChar('���ʹ����������'));
    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;

    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray();
end;

procedure TCmdAA_Start.TranslationData;
begin
  m_byVersion := m_RrecArray.RecArray[8]; //Э��汾��

  CopyMemory(@m_ApparatusInfo,@m_RrecArray.RecArray[1],2);
  m_ApparatusInfo.wStatus := m_RrecArray.RecArray[3];
  m_ApparatusInfo.bReady := (Bits(m_RrecArray.RecArray[3],0,0) = 1);

  CopyMemory(@m_ApparatusInfo.dwHVoltage0,@m_RrecArray.RecArray[4],2);
  CopyMemory(@m_ApparatusInfo.dwHVoltage1,@m_RrecArray.RecArray[6],2);

  m_ApparatusInfo.bSensorStatus := (m_ApparatusInfo.wStatus and $20) = $20; //������״̬

  //ͼ��׽ֵ, 1Ϊ��׽ͼ��, 0 Ϊ����׽ͼ��
  if Word(m_RrecArray.RecArray[9]) >0 then
    begin
     // if IsWindow(hWnd) then ; //���Ͳ�׽ͼ����Ϣ����ƽ���
        PostMessage(0, 0, 0, 0);
    end;
end;

{ TCmdName }

function TCmdName.CheckRecArray: Boolean;
begin
    Result := True;
   //�жϳ���
    if m_RrecArray.nRecLength <> m_RSendArray.nSendLength then
        begin
            Result := False;
            Exit;
        end;

   //���ֽ��Ƿ�Ϊ $E0 �����
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;
   //ĩ�ֽ��Ƿ����
    if m_RrecArray.RecArray[0] <> m_RSendArray.SendArray[0] then
        begin
            Result := False;
            Exit;
        end;

   //�ж�У���
    if m_RrecArray.RecArray[63] <> m_RSendArray.SendArray[63] then
        begin
            Result := False;
            Exit;
        end;

end;

constructor TCmdName.Create(SendAry: TSndAry116; nIndex, nTopOrBottom: Integer);
var
    I: Integer;
begin
    if nTopOrBottom = N_Top then
        for I := 0 to 60 - 1 do
            m_RSendArray.SendArray[I + 3] := SendAry[I] //��ģ�ϰ벿��60
    else if nTopOrBottom = N_Bottum then
        begin
            for I := 0 to 56 - 1 do
                m_RSendArray.SendArray[I + 3] := SendAry[I + 60]; //��ģ�°벿��56
        end;

    m_RSendArray.SendArray[1] := nIndex * 16 + nTopOrBottom;

end;

procedure TCmdName.MakeArray;
begin
    m_RSendArray.nSendLength := 64;
    m_RSendArray.SendArray[0] := $E0;
    m_RSendArray.SendArray[2] := $00;

    CheckArray
end;


procedure TCmdName.TranslationData;
begin

end;

{ TCmdAA_Prepare }

function TCmdAA_Prepare.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdAA_Prepare.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $15;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;



{ TCmdGetVolt }

function TCmdGetVolt.CheckRecArray: Boolean;
begin
    Result := (m_RrecArray.RecArray[0] = $CC)
end;

procedure TCmdGetVolt.MakeArray;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $CC;

    CheckArray
end;


procedure TCmdGetVolt.TranslationData();
//����:��������
var
  wVoltage : Word;
begin
  CopyMemory(@wVoltage,@m_RrecArray.RecArray[1],2);
  m_ApparatusBaseVlt.wNormalVoltage := wVoltage;

  CopyMemory(@wVoltage,@m_RrecArray.RecArray[3],2);
  m_ApparatusBaseVlt.wMoreVoltage := wVoltage;

  CopyMemory(@wVoltage,@m_RrecArray.RecArray[5],2);
  m_ApparatusBaseVlt.wMuchVoltage := wVoltage;
end;
{ TCmdWriteVolt }

function TCmdWriteVolt.CheckRecArray: Boolean;
//���ܣ����У��λ
begin
  Result := (self.m_RrecArray.RecArray[0] = $BB);
end;

constructor TCmdWriteVolt.Create(SendAry: TStandAry6);
var
  i : Integer;
begin
  for i := 0 to 5 do
    m_RSendArray.SendArray[i + 1] := SendAry[I];
end;

procedure TCmdWriteVolt.MakeArray;
begin
  m_RSendArray.nSendLength := 16;
  m_RSendArray.SendArray[0] := $BB;
  CheckArray();
end;

procedure TCmdWriteVolt.TranslationData;
begin
  inherited;
end;

{ TCmdStopRefrash_Prepare }


function TCmdStopRefrash.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdStopRefrash.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $00;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;


procedure TCmdStopRefrash.TranslationData;
begin
//
end;

{ TCmdResetCamera }

function TCmdResetCamera.CheckRecArray: Boolean;
begin
    Result := True;
end;

procedure TCmdResetCamera.MakeArray;
var
    StrHH, StrMM, StrSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;
    m_RSendArray.SendArray[2] := $03;


    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray
end;


{ TCmdAA_ListQZJ }

function TCmdAA_ListQZJ.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_ListQZJ.Create();
begin
    m_RSendArray.SendArray[2] := $25;
end;

procedure TCmdAA_ListQZJ.MakeArray;
var
    strHH, strMM, strSS: string;
begin
    m_RSendArray.nSendLength := 16;

    m_RSendArray.SendArray[0] := $AA;
    m_RSendArray.SendArray[1] := $00;

    m_RSendArray.SendArray[9] := StrToInt(FormatDateTime('YY', now));
    m_RSendArray.SendArray[10] := StrToInt(FormatDateTime('MM', now));
    m_RSendArray.SendArray[11] := StrToInt(FormatDateTime('DD', now));

    strHH := copyEx(FormatDateTime('tt', now), 1, 2);
    m_RSendArray.SendArray[12] := StrToInt(strHH);

    strMM := copyEx(FormatDateTime('tt', now), 4, 2);
    m_RSendArray.SendArray[13] := StrToInt(strMM);

    strSS := copyEx(FormatDateTime('tt', now), 7, 2);
    m_RSendArray.SendArray[14] := StrToInt(strSS);

    CheckArray;

end;

{ TCmdAA_PlayRecSound }

function TCmdAA_PlayRecSound.CheckRecArray: Boolean;
begin
    Result := True;
end;

constructor TCmdAA_PlayRecSound.Create(nRecIndex: Integer);
begin
    m_RSendArray.SendArray[0] := $99;
    m_RSendArray.SendArray[1] := nRecIndex;
end;

procedure TCmdAA_PlayRecSound.MakeArray;
var
    I: Integer;
begin
    m_RSendArray.nSendLength := 16;
    for I := 2 to 15 do
        m_RSendArray.SendArray[I] := 0;
    CheckArray;
end;


procedure TCmdAA_PlayRecSound.TranslationData;
begin

end;

{CmdGetStdVolt}


function TCmdGetStdVolt.CheckRecArray: Boolean;
begin
  Result := (Self.m_RrecArray.RecArray[0] = $AB);
end;


procedure TCmdGetStdVolt.MakeArray;
var
  I: Integer;
begin
  m_RSendArray.nSendLength := 16;
  m_RSendArray.SendArray[0] := $AB;
  for I := 1 to 6 do
    m_RSendArray.SendArray[I] := $00;
  CheckArray();
end;

procedure TCmdGetStdVolt.TranslationData();
begin
  m_byStandVolt[0] := m_RrecArray.RecArray[1];
  m_byStandVolt[1] := m_RrecArray.RecArray[2];
  m_byStandVolt[2] := m_RrecArray.RecArray[3];
  m_byStandVolt[3] := m_RrecArray.RecArray[4];
  m_byStandVolt[4] := m_RrecArray.RecArray[5];
  m_byStandVolt[5] := m_RrecArray.RecArray[6];
end;


end.

