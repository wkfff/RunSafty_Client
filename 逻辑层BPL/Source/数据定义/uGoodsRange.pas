unit uGoodsRange;

interface

uses
  SysUtils;

type
  //物品编号范围
  RRsGoodsRange = record
    strGUID:string;         //唯一编号
    nLendingTypeID:Integer; //物品类型 {电台/IC卡/其他}
    nStartCode:Integer;     //开始编号
    nStopCode:Integer;      //截止编号
    strExceptCodes:string;  //排除的编号
    strWorkShopGUID:string; //车间编号
  end;

  //物品范围数组
  TRsGoodsRangeList = array of  RRsGoodsRange ;

  //物品范围指针
  PRsGoodsRange =  ^RRsGoodsRange ;

implementation

end.
