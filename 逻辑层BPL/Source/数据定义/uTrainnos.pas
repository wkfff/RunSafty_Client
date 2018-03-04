unit uTrainnos;

interface

type
  //ͼ������
  RRsTrainnosInfo = record
    trainjiaoluID:string;
    trainjiaoluName:string;
    placeID:string;
    placeName:string;
    trainTypeName:string;
    trainNumber:string;
    trainNo:string;
    remark:string;
    nNeedRest:Integer;  //�Ƿ���
    dtArriveTime:string;  //���ʱ��
    dtCallTime:string;  //�а�ʱ��
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
