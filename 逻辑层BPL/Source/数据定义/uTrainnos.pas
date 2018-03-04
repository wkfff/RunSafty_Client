unit uTrainnos;

interface

type
  //图定车次
  RRsTrainnosInfo = record
    trainjiaoluID:string;
    trainjiaoluName:string;
    placeID:string;
    placeName:string;
    trainTypeName:string;
    trainNumber:string;
    trainNo:string;
    remark:string;
    nNeedRest:Integer;  //是否候版
    dtArriveTime:string;  //候班时间
    dtCallTime:string;  //叫班时间
    startTime:string;
    kaiCheTime:string;
    startStationID:string;
    startStationName:string;
    endStationID:string;
    endStationName:string;
    trainmanTypeID:string;
    trainmanTypeName:string;
    planTypeID:string;
    planTypeName:string;
    dragTypeID:string;
    dragTypeName:string;
    kehuoID:string;
    kehuoName:string;
    remarkTypeID:string;
    remarkTypeName:string;
    trainNoID:string;
    strWorkDay:string ;
  end;

  TRsTrainnosInfoList = array of RRsTrainnosInfo;

implementation

end.
