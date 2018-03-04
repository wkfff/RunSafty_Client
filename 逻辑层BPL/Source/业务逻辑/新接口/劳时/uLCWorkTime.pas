unit uLCWorkTime;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uRunEvent,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,uWorkTime,uTrainPlan,Windows;
type
  //��ʱ�ӿ�
  TRsLCWorkTime = class(TWepApiBase)
  private
    function JsonToWorkTime(iJson: ISuperObject): RRsWorkTime;
  public
    procedure CalcWorkTime(TrainPlanGUID: string);
    function GetWorkTime(TrainPlanGUID: string;out WorkTime : RRsWorkTime): Boolean;
  end;
implementation

{ TRsLCWorkTime }

procedure TRsLCWorkTime.CalcWorkTime(TrainPlanGUID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkTime.CalcWorkTime',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

function TRsLCWorkTime.GetWorkTime(TrainPlanGUID: string;
  out WorkTime: RRsWorkTime): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  ZeroMemory(@WorkTime,sizeof(WorkTime));
  JSON := SO();
  json.S['TrainPlanGUID'] := TrainPlanGUID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCWorkTime.GetWorkTime',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.B['bExist'];
  if Result then
  begin
    WorkTime := JsonToWorkTime(JSON.O['workTime']);
  end;
  
end;

function TRsLCWorkTime.JsonToWorkTime(iJson: ISuperObject): RRsWorkTime;
begin
  //nid
  Result.nid := iJson.I['nid']; 
  //����ID
  Result.strFlowID := iJson.S['strFlowID'];
  //��������
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //˾������
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  //˾������
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  //��������
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  //����ʱ��
  Result.dtBeginWorkTime := JSONStringToTime(iJson.S['dtBeginWorkTime']);
  //����ʱ��
  Result.dtStartTime := JSONStringToTime(iJson.S['dtStartTime']);
  //����ʱ��
  Result.dtArriveTime := JSONStringToTime(iJson.S['dtArriveTime']);
  //��Ԣʱ��
  Result.dtInRoomTime := JSONStringToTime(iJson.S['dtInRoomTime']);
  //��Ԣʱ��
  Result.dtOutRoomTime := JSONStringToTime(iJson.S['dtOutRoomTime']);
  //��·����ʱ��
  Result.dtStartTime2 := JSONStringToTime(iJson.S['dtStartTime2']);
  //��·����ʱ��
  Result.dtArriveTime2 := JSONStringToTime(iJson.S['dtArriveTime2']);
  //����ʱ��
  Result.dtEndWorkTime := JSONStringToTime(iJson.S['dtEndWorkTime']);
  //���ڸ�ʱ
  Result.fBeginTotalTime := iJson.I['fBeginTotalTime'];
  //��ʱ
  Result.fRunTotalTime := iJson.I['fRunTotalTime'];
  //���ڸ�ʱ
  Result.fEndTotalTime := iJson.I['fEndTotalTime'];
  //����ʱ
  Result.fTotalTime := iJson.I['fTotalTime'];
  //
  Result.nFlowState := iJson.I['nFlowState'];
  //
  Result.nkehuoID := iJson.I['nkehuoID'];
  //
  Result.nNoticeState := iJson.I['nNoticeState'];
  //����
  Result.strTrainTypeName := iJson.S['strTrainTypeName'];
  //����
  Result.strTrainNumber := iJson.S['strTrainNumber'];
  //����
  Result.strTrainNo := iJson.S['strTrainNo'];
  //�����
  Result.strWorkShopNumber := iJson.S['strWorkShopNumber'];
  //�յ�վTMIS
  Result.strDestStationTMIS := iJson.S['strDestStationTMIS'];
  //�յ�վ����
  Result.strDestStationName := iJson.S['strDestStationName'];
  //�Ƿ񱾶γ���
  Result.bLocalOutDepots := iJson.I['bLocalOutDepots'];
  //���γ���ʱ��
  Result.dtLocalOutDepotsTime := JSONStringToTime(iJson.S['dtLocalOutDepotsTime']);
  //�Ƿ�������
  Result.bDestInDepots := iJson.I['bDestInDepots'];
  //������ʱ��
  Result.dtDestInDepotsTime := JSONStringToTime(iJson.S['dtDestInDepotsTime']);
  //�Ƿ���γ���
  Result.bDestOutDepots := iJson.I['bDestOutDepots'];
  //��γ���ʱ��
  Result.dtDestOutDepotsTime := JSONStringToTime(iJson.S['dtDestOutDepotsTime']);
  //�Ƿ񱾶����
  Result.bLocalInDepots := iJson.I['bLocalInDepots'];
  //�������ʱ��
  Result.dtLocalInDepotsTime := JSONStringToTime(iJson.S['dtLocalInDepotsTime']);
  //��·����
  Result.strBackTrainTypeName := iJson.S['strBackTrainTypeName'];
  //��·����
  Result.strBackTrainNumber := iJson.S['strBackTrainNumber'];
  //��·����
  Result.strBackTrainNo := iJson.S['strBackTrainNo'];
  //ʵ�ʵ���ʱ��
  Result.dtRealArriveTime := JSONStringToTime(iJson.S['dtRealArriveTime']);
  //�Ƿ��Ѿ��ֹ�ȷ��
  Result.bConfirm := iJson.I['bConfirm'];
  //�ֹ�ȷ��ʱ��
  Result.dtConfirmTime := JSONStringToTime(iJson.S['dtConfirmTime']);
  //�ֹ�ȷ����
  Result.strConfirmDutyUser := iJson.S['strConfirmDutyUser'];
  //��·ͣ��ʱ��(����)
  Result.nLocalStopMinutes := iJson.I['nLocalStopMinutes'];
  //��·ͣ��ʱ��(����)
  Result.nRemoteStopMinutes := iJson.I['nRemoteStopMinutes'];
  //�����յ���վTMIS
  Result.strArriveStationTMIS := iJson.S['strArriveStationTMIS'];
  //�����յ���վ��
  Result.strArriveStationName := iJson.S['strArriveStationName'];
  //
  Result.nAlarmMinutes := iJson.I['nAlarmMinutes'];
  //
  Result.nOutMinutes := iJson.I['nOutMinutes'];
  //
  Result.nOutTotalTime := iJson.I['nOutTotalTime'];
  //
  Result.dtFileBeginTime := JSONStringToTime(iJson.S['dtFileBeginTime']);
  //
  Result.dtFileEndTime := JSONStringToTime(iJson.S['dtFileEndTime']);
  //
  Result.nChuQinTypeID := iJson.I['nChuQinTypeID'];
  //
  Result.nTuiQinTypeID := iJson.I['nTuiQinTypeID'];
  //�޸����
  Result.strConfirmRemark := iJson.S['strConfirmRemark'];
  
  Result.strDutyUserName := iJson.S['strDutyUserName'];
  
  Result.dtCreateTime := JSONStringToTime(iJson.S['dtCreateTime']);
  //����ʱ��
  Result.nGoRunTotalMinutes := iJson.I['nGoRunTotalMinutes'];
  Result.nBackRunTotalMinutes := iJson.I['nBackRunTotalMinutes'];
  //�����ٶ�
  Result.fGoSpeed := iJson.D['fGoSpeed'];
  Result.fBackSpeed := iJson.D['fBackSpeed'];

  Result.TrainmanPlan.TrainPlan.strTrainJiaoluName :=  iJson.S['TrainmanPlan.TrainPlan.strTrainJiaoluName'];
  Result.TrainmanPlan.TrainPlan.strTrainPlanGUID := iJson.S['TrainmanPlan.TrainPlan.strTrainPlanGUID'];
  Result.TrainmanPlan.TrainPlan.strTrainTypeName := iJson.S['TrainmanPlan.TrainPlan.strTrainTypeName'];
  Result.TrainmanPlan.TrainPlan.strTrainNumber := iJson.S['TrainmanPlan.TrainPlan.strTrainNumber'];
  Result.TrainmanPlan.TrainPlan.strTrainNo := iJson.S['TrainmanPlan.TrainPlan.strTrainNo'];
  Result.TrainmanPlan.TrainPlan.nKeHuoID := trsKehuo(iJson.I['TrainmanPlan.TrainPlan.nKeHuoID']);

  Result.TrainmanPlan.Group.Trainman1.strTrainmanGUID := iJson.S['TrainmanPlan.Group.Trainman1.strTrainmanGUID'];
  Result.TrainmanPlan.Group.Trainman1.strTrainmanName := iJson.S['TrainmanPlan.Group.Trainman1.strTrainmanName'];
  Result.TrainmanPlan.Group.Trainman1.strTrainmanNumber := iJson.S['TrainmanPlan.Group.Trainman1.strTrainmanNumber'];

  Result.TrainmanPlan.Group.Trainman2.strTrainmanGUID := iJson.S['TrainmanPlan.Group.Trainman2.strTrainmanGUID'];
  Result.TrainmanPlan.Group.Trainman2.strTrainmanName := iJson.S['TrainmanPlan.Group.Trainman2.strTrainmanName'];
  Result.TrainmanPlan.Group.Trainman2.strTrainmanNumber := iJson.S['TrainmanPlan.Group.Trainman2.strTrainmanNumber'];

  Result.TrainmanPlan.Group.Trainman3.strTrainmanGUID := iJson.S['TrainmanPlan.Group.Trainman3.strTrainmanGUID'];
  Result.TrainmanPlan.Group.Trainman3.strTrainmanName := iJson.S['TrainmanPlan.Group.Trainman3.strTrainmanName'];
  Result.TrainmanPlan.Group.Trainman3.strTrainmanNumber := iJson.S['TrainmanPlan.Group.Trainman3.strTrainmanNumber'];
end;

end.
