unit uWorkTimeDefine;

interface
uses
  Classes,uSaftyEnum,uTrainPlan;
type
  //����ʱ��Ϣ
  RRsWorkTimeInfo = record
    //����ID
    strFlowID : string;
    //��������
    strWorkShopGUID : string;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //����ʱ��
    dtStartTimeTime : TDateTime;
    //����ʱ��
    dtArriveTime : TDateTime;
    //��Ԣʱ��
    dtInRoomTime : TDateTime;
    //��Ԣʱ��
    dtOutRoomTime : TDateTime;
    //��·����ʱ��
    dtStartTime2 : TDateTime;
    //��·����ʱ��
    dtArriveTime2 : TDateTime;
    //����ʱ��
    dtEndWorkTime : TDateTime;
    //���ڸ�ʱ
    fBeginTotalTime : Integer;
    //��ʱ
    fRunTotalTime : Integer;
    //���ڸ�ʱ
    fEndTotalTime : Integer;
    //����ʱ
    fTotalTime : integer;
    //ֵ�˼ƻ���Ϣ
    TrainmanPlan : RRsTrainmanPlan;
  end;
  TRsArrayWorkTimeInfo = array of RRsWorkTimeInfo;

implementation

end.
