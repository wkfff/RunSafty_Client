unit uPlanLater;

interface

type
  //计时种类
  TPassType = (ptPass,ptBeginStop,ptEndStop,ptBothStop);
  RRsLasterSection = record
    //计划GUID
    strPlanGUD : string;
    //第一站过站时间
    dtStartTime : TDateTime;
    //第二个站过站时间
    dtEndTime : TDateTime;
    //计时种类(0，直接过站，1前一个站停车，2后一个站停车，3前后站都停车)
    nPassType : TPassType;
    //车次
    strTrainNo : string;
    //发生时间(第一个站进站时间)
    strCreateTime : TDateTime;
    //标准时间
    nStandardSeconds :integer;
    //实际时间
    nRealSeconds: integer;
    //最大速度
    nMaxSpeed : integer;
    //起始站TMIS号
    strBeginStationTMIS : string;
    //起始站名称
    strBeginStationName : string;
    //结束站TMIS号
    strEndStationTMIS : string;
    //结束站名称
    strEndStationName : string;
    //司机工号
    strTrainmanNumber1 : string;
    //副司机工号
    strTrainmanNumber2 : string;
  end;
  TRsLasterSectionArray = array of RRsLasterSection;
implementation

end.
