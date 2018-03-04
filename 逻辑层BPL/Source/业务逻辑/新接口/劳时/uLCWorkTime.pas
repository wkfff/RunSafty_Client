unit uLCWorkTime;

interface
uses
  Classes,SysUtils,uBaseWebInterface,superobject,uRunEvent,uSaftyEnum,uLLCommonFun,
  uHttpWebAPI,uJsonSerialize,uWorkTime,uTrainPlan,Windows;
type
  //劳时接口
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
  //流程ID
  Result.strFlowID := iJson.S['strFlowID'];
  //所属车间
  Result.strWorkShopGUID := iJson.S['strWorkShopGUID'];
  //司机工号
  Result.strTrainmanNumber := iJson.S['strTrainmanNumber'];
  //司机姓名
  Result.strTrainmanName := iJson.S['strTrainmanName'];
  //车间名称
  Result.strWorkShopName := iJson.S['strWorkShopName'];
  //出勤时间
  Result.dtBeginWorkTime := JSONStringToTime(iJson.S['dtBeginWorkTime']);
  //开车时间
  Result.dtStartTime := JSONStringToTime(iJson.S['dtStartTime']);
  //到达时间
  Result.dtArriveTime := JSONStringToTime(iJson.S['dtArriveTime']);
  //入寓时间
  Result.dtInRoomTime := JSONStringToTime(iJson.S['dtInRoomTime']);
  //离寓时间
  Result.dtOutRoomTime := JSONStringToTime(iJson.S['dtOutRoomTime']);
  //回路开车时间
  Result.dtStartTime2 := JSONStringToTime(iJson.S['dtStartTime2']);
  //回路到达时间
  Result.dtArriveTime2 := JSONStringToTime(iJson.S['dtArriveTime2']);
  //退勤时间
  Result.dtEndWorkTime := JSONStringToTime(iJson.S['dtEndWorkTime']);
  //出勤辅时
  Result.fBeginTotalTime := iJson.I['fBeginTotalTime'];
  //旅时
  Result.fRunTotalTime := iJson.I['fRunTotalTime'];
  //退勤辅时
  Result.fEndTotalTime := iJson.I['fEndTotalTime'];
  //总劳时
  Result.fTotalTime := iJson.I['fTotalTime'];
  //
  Result.nFlowState := iJson.I['nFlowState'];
  //
  Result.nkehuoID := iJson.I['nkehuoID'];
  //
  Result.nNoticeState := iJson.I['nNoticeState'];
  //车型
  Result.strTrainTypeName := iJson.S['strTrainTypeName'];
  //车号
  Result.strTrainNumber := iJson.S['strTrainNumber'];
  //车次
  Result.strTrainNo := iJson.S['strTrainNo'];
  //车间号
  Result.strWorkShopNumber := iJson.S['strWorkShopNumber'];
  //终到站TMIS
  Result.strDestStationTMIS := iJson.S['strDestStationTMIS'];
  //终到站名称
  Result.strDestStationName := iJson.S['strDestStationName'];
  //是否本段出库
  Result.bLocalOutDepots := iJson.I['bLocalOutDepots'];
  //本段出库时间
  Result.dtLocalOutDepotsTime := JSONStringToTime(iJson.S['dtLocalOutDepotsTime']);
  //是否外段入库
  Result.bDestInDepots := iJson.I['bDestInDepots'];
  //外段入库时间
  Result.dtDestInDepotsTime := JSONStringToTime(iJson.S['dtDestInDepotsTime']);
  //是否外段出库
  Result.bDestOutDepots := iJson.I['bDestOutDepots'];
  //外段出库时间
  Result.dtDestOutDepotsTime := JSONStringToTime(iJson.S['dtDestOutDepotsTime']);
  //是否本段入库
  Result.bLocalInDepots := iJson.I['bLocalInDepots'];
  //本段入库时间
  Result.dtLocalInDepotsTime := JSONStringToTime(iJson.S['dtLocalInDepotsTime']);
  //回路车型
  Result.strBackTrainTypeName := iJson.S['strBackTrainTypeName'];
  //回路车号
  Result.strBackTrainNumber := iJson.S['strBackTrainNumber'];
  //回路车次
  Result.strBackTrainNo := iJson.S['strBackTrainNo'];
  //实际到达时间
  Result.dtRealArriveTime := JSONStringToTime(iJson.S['dtRealArriveTime']);
  //是否已经手工确认
  Result.bConfirm := iJson.I['bConfirm'];
  //手工确认时间
  Result.dtConfirmTime := JSONStringToTime(iJson.S['dtConfirmTime']);
  //手工确认人
  Result.strConfirmDutyUser := iJson.S['strConfirmDutyUser'];
  //往路停留时间(分钟)
  Result.nLocalStopMinutes := iJson.I['nLocalStopMinutes'];
  //回路停留时间(分钟)
  Result.nRemoteStopMinutes := iJson.I['nRemoteStopMinutes'];
  //退勤终到车站TMIS
  Result.strArriveStationTMIS := iJson.S['strArriveStationTMIS'];
  //退勤终到车站名
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
  //修改意见
  Result.strConfirmRemark := iJson.S['strConfirmRemark'];
  
  Result.strDutyUserName := iJson.S['strDutyUserName'];
  
  Result.dtCreateTime := JSONStringToTime(iJson.S['dtCreateTime']);
  //旅行时间
  Result.nGoRunTotalMinutes := iJson.I['nGoRunTotalMinutes'];
  Result.nBackRunTotalMinutes := iJson.I['nBackRunTotalMinutes'];
  //技术速度
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
