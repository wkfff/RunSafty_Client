unit uMealTicketRule;

interface

uses
  SysUtils,uTrainmanJiaolu;

type

  //索取饭票信息的人员信息
  RRsMealTicketPersonInfo = record
    //人员名字
    strTrainmanNumber:string;
    //车间名字
    strWorkShopGUID:string;
    //区段
    strQuDuan:string;
    //车次
    strCheCi:string;
    //派班时间
    dtPaiBan:TDateTime;
  end;



  // 车次/区段等相关信息
  RRsMealTicketCheCi = record
    //GUID
    strGUID:string;
    //车间GUID和ITYPE数据库查询饭票使用的
    //车间GUID
    strWorkShopGUID:string;
    // 交路类型
    iType:Integer;
    //区段
    strQuDuan:string;
    //车次
    strCheCi:string;
    //开始时间(发放饭票是开始-结束时间仅TIME部分有效)
    //例如 06:00 ~ 09:00
    dtStartTime:TDateTime;
    //停止时间
    dtEndTime:TDateTime;
    //规则GUID
    strRuleGUID:string;
  end;

  RRsMealTicketCheCiPointer = ^RRsMealTicketCheCi ;


  TRsMealTicketCheCiList = array of RRsMealTicketCheCi;


  //饭票配置RULE
  RRsMealTicketRule = record
    //本条记录的GUID
    strGUID:string;
    //规则名字
    strName:string;
    //车间GUID
    strWorkShopGUID:string;
    // 交路类型
    iType:Integer;
    //早餐
    iA:Integer;
    //正餐
    iB:Integer;
  end;


  RRsMealTicketRulePointer = ^RRsMealTicketRule;


  TRsMealTicketRuleList = array of RRsMealTicketRule ;

  //详细说明
 // 饭票规则可以对多个 行车计划信息


implementation

end.
