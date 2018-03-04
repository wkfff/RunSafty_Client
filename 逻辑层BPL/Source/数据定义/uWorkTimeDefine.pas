unit uWorkTimeDefine;

interface
uses
  Classes,uSaftyEnum,uTrainPlan;
type
  //趟劳时信息
  RRsWorkTimeInfo = record
    //流程ID
    strFlowID : string;
    //所属车间
    strWorkShopGUID : string;
    //出勤时间
    dtBeginWorkTime : TDateTime;
    //开车时间
    dtStartTimeTime : TDateTime;
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
    fTotalTime : integer;
    //值乘计划信息
    TrainmanPlan : RRsTrainmanPlan;
  end;
  TRsArrayWorkTimeInfo = array of RRsWorkTimeInfo;

implementation

end.
