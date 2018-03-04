unit uTrainNo;

interface
uses
  uSaftyEnum;
type
  /// 类名:TTrainNo
  /// 说明:图定车次信息
  //////////////////////////////////////////////////////////////////////////////
  RRsTrainNo = record
  public
    strGUID : String;
     //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    {车次}
    strTrainNo : String;
    {开车时间}
    dtStartTime : TDateTime;
    //实际开车时间
    dtRealStartTime : TDateTime;
    {机车交路}
    strTrainJiaoluGUID : String;
   //机车交路名称
    strTrainJiaoluName : string;
    {起始站GUID}
    strStartStation : string;
    //起始站名称
    strStartStationName : string;
    {终到站GUID}
    strEndStation : string;
    //终到站名称
    strEndStationName : string;
    //值乘方式
    nTrainmanTypeID : TRsTrainmanType;
    //计划类型
    nPlanType : TRsPlanType;
    //牵引状态
    nDragType : TRsDragType;
    //客货
    nKeHuoID : TRsKehuo;
    //备注类型
    nRemarkType : TRsPlanRemarkType;
    //备注内容
    strRemark : string;


     {记录产生时间}
    dtCreateTime : TDateTime;
    //创建的客户端GUID
    strCreateSiteGUID : string;
    //创建的客户端名称
    strCreateSiteName : string;
    //创建人
    strCreateUserGUID : string;
    //创建人名称
    strCreateUserName : string;
  end;
  TRsTrainNoArray = array of RRsTrainNo;
implementation

end.
