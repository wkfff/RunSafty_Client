unit uEndWork;

interface

uses
  uDrink   ;


type

  RRsEndWorkInfo = record
    endworkID:string;
    trainmanID:string;
    planID:string;
    verifyID:string;
    dutyUserID:string;
    stationID:string;
    placeID:string;
    arriveTime: TDateTime;
    lastEndWorkTime: TDateTime;
    remark:string;
  end;


  RRsDrinksInfo = record
    trainmanID : string;
    drinkResult : string;
    workTypeID : string;
    createTime : TDateTime;
    imagePath  : string;
    drink : RRsDrink ;
  end;

  RRsEndWork = record
    endWorkInfo : RRsEndWorkInfo ;
    drinksInfo:RRsDrinksInfo;
    dutyUserID:string;
  end;


implementation

end.
