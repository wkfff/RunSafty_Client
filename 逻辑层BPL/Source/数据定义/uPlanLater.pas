unit uPlanLater;

interface

type
  //��ʱ����
  TPassType = (ptPass,ptBeginStop,ptEndStop,ptBothStop);
  RRsLasterSection = record
    //�ƻ�GUID
    strPlanGUD : string;
    //��һվ��վʱ��
    dtStartTime : TDateTime;
    //�ڶ���վ��վʱ��
    dtEndTime : TDateTime;
    //��ʱ����(0��ֱ�ӹ�վ��1ǰһ��վͣ����2��һ��վͣ����3ǰ��վ��ͣ��)
    nPassType : TPassType;
    //����
    strTrainNo : string;
    //����ʱ��(��һ��վ��վʱ��)
    strCreateTime : TDateTime;
    //��׼ʱ��
    nStandardSeconds :integer;
    //ʵ��ʱ��
    nRealSeconds: integer;
    //����ٶ�
    nMaxSpeed : integer;
    //��ʼվTMIS��
    strBeginStationTMIS : string;
    //��ʼվ����
    strBeginStationName : string;
    //����վTMIS��
    strEndStationTMIS : string;
    //����վ����
    strEndStationName : string;
    //˾������
    strTrainmanNumber1 : string;
    //��˾������
    strTrainmanNumber2 : string;
  end;
  TRsLasterSectionArray = array of RRsLasterSection;
implementation

end.
