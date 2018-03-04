unit uCallWork;

interface

type

  RRsCallWork = record
    nCallWorkType:Integer;  //叫班信息类型 0 增加叫班  1 取消叫班
    strPlanGUID:string;        //计划GUID
    strMsgGUID:string;         //消息ID
    strMsgContent:string;      //短信内容
    strStartTime:string ;     //开车时间
    strCreateTime:string;   //叫班时间
    strTrainmanGUID:string;
    strTrainmanNumber:string;   //工号
    strTrainmanName:string;   //名字
    strMobileNumber:string; //电话号码
  end;

implementation

end.
