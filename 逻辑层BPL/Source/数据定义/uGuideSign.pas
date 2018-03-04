unit uGuideSign;

interface

type
  //签到方式
  TRsSignFlag = (sfNone{无},sfInput{手动输入},sfFinger{指纹识别});

  //指导组签到信息
  RRsGuideSign = record
    //签到记录GUID
    strGuideSignGUID : string;
    //乘务员工号
    strTrainmanNumber : string;
    //乘务员姓名
    strTrainmanName : string;
    //所属车间GUID
    strWorkShopGUID : string; 
    //所属车间名称
    strWorkShopName  :string;
    //所属指导组GUID
    strGuideGroupGUID : string; 
    //所属指导组名称
    strGuideGroupName : string;
    //签到时间
    dtSignInTime : TDateTime;
    //签到方式
    nSignInFlag : TRsSignFlag;
    //签退时间
    dtSignOutTime : TDateTime;
    //签退方式
    nSignOutFlag : TRsSignFlag;
  end;
  TRsGuideSignArray = array of RRsGuideSign;

  //指导组签到信息查询条件
  RRsQueryGuideSign = record
    //工号，空为所有
    strTrainmanNumber : string;
    //姓名，空为所有
    strTrainmanName : string;
    //所属车间，空为所有
    strWorkShopGUID : string;
    //所属指导组 ，空为所有
    strGuideGroupGUID : string;
    //签到时间-开始查询时间
    dtSignTimeBegin : TDateTime;   
    //签到时间-终止查询时间
    dtSignTimeEnd : TDateTime;
    //签到方式，sfNone为所有
    nSignFlag : TRsSignFlag; 
  end;

  //简单的信息，只包含GUID和名称
  RRsSimpleInfo = record
    //GUID
    strGUID : string;
    //名称
    strName : string;
  end;
  TRsSimpleInfoArray = array of RRsSimpleInfo;

  //简单的司机信息
  RRsTrainmanInfo = record
    //GUID
    strTrainmanGUID : string;
    //名称
    strTrainmanName : string;
  end;
  TRsTrainmanInfoArray = array of RRsTrainmanInfo;
               
const
  //签到方式
  TRsSignFlagArray : array[TRsSignFlag] of string = ('','手动','指纹');

implementation

end.

