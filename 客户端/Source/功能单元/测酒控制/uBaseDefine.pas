unit uBaseDefine;

interface

uses Windows, Messages;

const
    WM_APPARATUS_INFO_CHANGE = WM_USER + 1010;//���״̬�����仯
    WM_CommunicationsFailure = WM_USER + 1018; //ͨ���쳣
    WM_CommunicationsSuccess = WM_USER + 1019; //ͨ������

    //�����״̬
    crAbnormity = $FF; //�쳣,ͨѶʧ��.
    crReady = $01; //01������  ֻ�в�����ڸ�״̬�²��ܼ��
    crBusy = $100; //�ж��豸����ƺ��Ƿ����»ָ������״̬
    crNormal = $02; //����
    crWarn = $10; //����
    crMore = $14; //����
    crMuch = $18; //���
    crSave = $80; //��������
    crNotTest = $00; //δ��⣻
    crIniStatus = $44;//��ʼ״̬
    crTimeOut = $F1;//��ʱ


type


  //�����������Ϣ
  RAlcoholConfig = record
    dwNormalStandard: DWORD; //������׼
    dwNormalModify: DWORD; //��������
    dwDrinkStandard: DWORD; //���Ʊ�׼
    dwDrinkModify: DWORD; //��������
    dwBibulosityStandard: DWORD; //��Ʊ�׼
    dwBibulosityModify: DWORD; //�������
    dwVltStandard: DWORD; //������׼
    dwVltModify: DWORD; //��������
    dwVltDrinkStandard: DWORD; //���Ʊ�׼
    dwVltDrinkModify: DWORD; //��������
    dwVltBibulosityStandard: DWORD; //��Ʊ�׼
    dwVltBibulosityModify: DWORD; //�������
    dwVltNormalStepUp: DWORD; //������ѹ
    dwVltNormalStepDown: DWORD; //������ѹ
    dwRespondTime: DWORD; //��Ӧʱ��
    dwStatus: DWORD; //����Ǽ��״̬
  end;


  {RApparatusBaseVlt ����ǵ�ѹ��Ϣ�ṹ��}
  RApparatusVoltage = record
    wNormalVoltage: Word; //������ѹ
    wMoreVoltage: Word; //���Ƶ�ѹ
    wMuchVoltage: Word; //��Ƶ�ѹ
  end;

  {����豸״̬}
  TAlcoholicStatus = (acrNormal {����}, acrMore {����}, acrMuch {���},
     acrAbnormity {�쳣}, acrReady {������},acrWarn {����},
     acrBusy{��ƺ��Ƿ񷵻�},acrWarmup {����Ԥ��},acrIniStatus {��ʼ״̬},
     acrTimeOut {��ʱ});

  {����Ƿ�����Ϣ}
  RApparatusInfo = record
    dwAlcoholicity: Word; //�ƾ�������
    wStatus: Word; //����Ǽ��״̬
    bReady :Boolean; //������Ƿ�׼���� ��������False����������True
    dwHVoltage0: Word; //ͨ��0��ѹ ��˷��ѹ
    dwHVoltage1: Word; //ͨ��1��ѹ ��ƴ�������ѹ
    bSensorStatus: boolean; //������״̬�Ƿ���Ч
  end;

  {���״̬��Ϣ�ı��¼�}
  TOnApparatusInfoChange = procedure(Info: RApparatusInfo) of object;
  {ͨѶ״̬�仯�¼�}
  TOnCommunicationsStateChange = Procedure(bState : Boolean)of object;
  

function AlcoholicStatusToString(wStatus: WORD):String;

implementation

function AlcoholicStatusToString(wStatus: WORD):String;
//���ܣ�������豸״̬����Ϊ�ַ���
begin
  Result := 'δ֪';
  case wStatus of
    crNormal : Result := '����';
    crMore : Result := '����';
    crMuch : Result := '���';
    crAbnormity : Result := '�쳣';
    crReady : Result := '������';
    crWarn : Result := '����';
    crNotTest : Result := '����Ԥ��';
    crIniStatus : Result := '��ʼ״̬';
    crTimeOut : Result := '��ʱ';
    crBusy : Result := '��ƺ��Ƿ񷵻�';
  end;
end;

{function GetAlcoholResult(dwResult: DWORD): TAlcoholicStatus;
//���ܣ���ò���ǵĵ�ǰ���
begin
  Result := acrIniStatus;
  if dwResult = crAbnormity then
      Result := acrAbnormity; //�쳣,ͨѶʧ��.

  if dwResult = crReady then
      Result := acrReady; //01������  ֻ�в�����ڸ�״̬�²��ܼ��

  if dwResult = crBusy then
      Result := acrBusy; //�ж��豸����ƺ��Ƿ����»ָ������״̬

  if dwResult = crNormal then
      Result := acrNormal; //����

  if dwResult = crWarn then
      Result := acrWarn; //����

  if dwResult = crMore then
      Result := acrMore; //����

  if dwResult = crMuch then
      Result := acrMuch; //���

  if dwResult = crNotTest then
      Result := acrWarmup; //δ��⣻

  if dwResult = crIniStatus then
      Result := acrIniStatus; //��ʼ״̬
end;   }

end.

