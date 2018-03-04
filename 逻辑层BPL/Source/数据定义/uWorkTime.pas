unit uWorkTime;

interface
uses
  Classes,uSaftyEnum,uTrainPlan;
type
  //趟劳时信息
  RRsWorkTime = record
    //nid
    nid : integer;
    //流程ID
    strFlowID : string;
    //所属车间
    strWorkShopGUID : string;
    //司机工号
    strTrainmanNumber:string;
    //司机姓名
    strTrainmanName:string;
    //车间名称
    strWorkShopName : string;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //开车时间
    dtStartTime : TDateTime;
    //到达时间
    dtArriveTime : TDateTime;
    //入寓时间
    dtInRoomTime : TDateTime;
    //离寓时间
    dtOutRoomTime : TDateTime;
    //回路开车时间
    dtStartTime2 : TDateTime;
    //回路到达时间
    dtArriveTime2 : TDateTime;
    //退勤时间
    dtEndWorkTime : TDateTime;
    //出勤辅时
    fBeginTotalTime : Integer;
    //旅时
    fRunTotalTime : Integer;
    //退勤辅时
    fEndTotalTime : Integer;
    //总劳时
    fTotalTime : Integer;
    //
    nFlowState:Integer;
    //
    nkehuoID:Integer;
    //
    nNoticeState:Integer;
    //车型
    strTrainTypeName:string;
    //车号
    strTrainNumber:string;
    //车次
    strTrainNo:string;
    //车间号
    strWorkShopNumber:string;
    //终到站TMIS
    strDestStationTMIS : string;
    //终到站名称
    strDestStationName : string;
    //是否本段出库
    bLocalOutDepots : integer;
    //本段出库时间
    dtLocalOutDepotsTime : TDateTime;
    //是否外段入库
    bDestInDepots : integer;
    //外段入库时间
    dtDestInDepotsTime : TDateTime;
    //是否外段出库
    bDestOutDepots : integer;
    //外段出库时间
    dtDestOutDepotsTime : TDateTime;
    //是否本段入库
    bLocalInDepots : integer;
    //本段入库时间
    dtLocalInDepotsTime : TDateTime;
    //回路车型
    strBackTrainTypeName : string;
    //回路车号
    strBackTrainNumber : string;
    //回路车次
    strBackTrainNo : string;
    //实际到达时间
    dtRealArriveTime : TDateTime;
    //是否已经手工确认
    bConfirm : integer;
    //手工确认时间
    dtConfirmTime : TDateTime;
    //手工确认人
    strConfirmDutyUser : string;
    //往路停留时间(分钟)
    nLocalStopMinutes : integer;
    //回路停留时间(分钟)
    nRemoteStopMinutes : integer;
    //退勤终到车站TMIS
    strArriveStationTMIS : string;
    //退勤终到车站名
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
    //修改意见
    strConfirmRemark:string;

    strDutyUserName:string;

    dtCreateTime:TDateTime ;
    //旅行时间
    nGoRunTotalMinutes:Integer;
    nBackRunTotalMinutes:Integer;
    //技术速度
    fGoSpeed:Single ;
    fBackSpeed:Single;

        //值乘计划信息
    TrainmanPlan : RRsTrainmanPlan;
  end;
  TRsWorkTimeArray = array of RRsWorkTime;

  TWorkTimeArray = array of RRsWorkTime;

implementation

end.
