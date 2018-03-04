unit uWorkTime;

interface
uses
  Classes,uSaftyEnum,uTrainPlan;
type
  //����ʱ��Ϣ
  RRsWorkTime = record
    //nid
    nid : integer;
    //����ID
    strFlowID : string;
    //��������
    strWorkShopGUID : string;
    //˾������
    strTrainmanNumber:string;
    //˾������
    strTrainmanName:string;
    //��������
    strWorkShopName : string;
    //����ʱ��
    dtBeginWorkTime : TDateTime;
    //����ʱ��
    dtStartTime : TDateTime;
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
    fTotalTime : Integer;
    //
    nFlowState:Integer;
    //
    nkehuoID:Integer;
    //
    nNoticeState:Integer;
    //����
    strTrainTypeName:string;
    //����
    strTrainNumber:string;
    //����
    strTrainNo:string;
    //�����
    strWorkShopNumber:string;
    //�յ�վTMIS
    strDestStationTMIS : string;
    //�յ�վ����
    strDestStationName : string;
    //�Ƿ񱾶γ���
    bLocalOutDepots : integer;
    //���γ���ʱ��
    dtLocalOutDepotsTime : TDateTime;
    //�Ƿ�������
    bDestInDepots : integer;
    //������ʱ��
    dtDestInDepotsTime : TDateTime;
    //�Ƿ���γ���
    bDestOutDepots : integer;
    //��γ���ʱ��
    dtDestOutDepotsTime : TDateTime;
    //�Ƿ񱾶����
    bLocalInDepots : integer;
    //�������ʱ��
    dtLocalInDepotsTime : TDateTime;
    //��·����
    strBackTrainTypeName : string;
    //��·����
    strBackTrainNumber : string;
    //��·����
    strBackTrainNo : string;
    //ʵ�ʵ���ʱ��
    dtRealArriveTime : TDateTime;
    //�Ƿ��Ѿ��ֹ�ȷ��
    bConfirm : integer;
    //�ֹ�ȷ��ʱ��
    dtConfirmTime : TDateTime;
    //�ֹ�ȷ����
    strConfirmDutyUser : string;
    //��·ͣ��ʱ��(����)
    nLocalStopMinutes : integer;
    //��·ͣ��ʱ��(����)
    nRemoteStopMinutes : integer;
    //�����յ���վTMIS
    strArriveStationTMIS : string;
    //�����յ���վ��
    strArriveStationName : string;
    //
    nAlarmMinutes:Integer;
    //
    nOutMinutes:Integer;
    //
    nOutTotalTime:Integer;
    //
    dtFileBeginTime:TDateTime;
    //
    dtFileEndTime:TDateTime;
    //
    nChuQinTypeID:Integer;
    //
    nTuiQinTypeID:Integer;
    //�޸����
    strConfirmRemark:string;

    strDutyUserName:string;

    dtCreateTime:TDateTime ;
    //����ʱ��
    nGoRunTotalMinutes:Integer;
    nBackRunTotalMinutes:Integer;
    //�����ٶ�
    fGoSpeed:Single ;
    fBackSpeed:Single;

        //ֵ�˼ƻ���Ϣ
    TrainmanPlan : RRsTrainmanPlan;
  end;
  TRsWorkTimeArray = array of RRsWorkTime;

  TWorkTimeArray = array of RRsWorkTime;

implementation

end.
