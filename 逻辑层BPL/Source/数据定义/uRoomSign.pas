unit uRoomSign;

interface
uses
  Classes,Contnrs;
type
  TRsRoomSignType = (stInRoom{入寓},stOutRoom{离寓});
  RRsRoomSign = record
    strInRoomGUID: string;
    strTrainPlanGUID: string;
    strTrainmanGUID: string;
    dtInRoomTime: TDateTime;
    nInRoomVerifyID: string;
    strDutyUserGUID: string;
    strTrainmanNumber: string;
    strTrainmanName: string;
    SignType: TRsRoomSignType;
  end;
  TRsRoomSignArray = array of RRsRoomSign;

  // add by lyq
  //2014-06-13

  //床位信息
  RRsBedInfo = record
    strRoomNumber:string;
    dtInRoomTime:TDateTime;
    strTrainmanGUID:string;
    strTrainmanName:string;
    strTrainmanNumber:string;
    nBedNumber:Integer;
  end;

  RRsBedInfoPointer = ^RRsBedInfo  ;

  TRsBedInfoList = array [0..2]  of  RRsBedInfo ;
  TRsBedInfoArray = array of   RRsBedInfo ;

  //房间信息
  RRsRoomInfo = record
    nID:Integer;
    strRoomNumber:string;           //房间号
    listBedInfo: TRsBedInfoList ;   //床位信息
  end;

  TRsRoomInfoArray = array of RRsRoomInfo;


  TRsRoomSign = class
  public
    strPlanGUID : string ;    //计划GUID
    strInRoomGUID: string;      //入寓GUID
    strOutRoomGUID: string;     //离开公寓GUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //乘务员GUID
    dtInRoomTime: TDateTime;    //入寓时间
    dtOutRoomTime: TDateTime;   //离寓时间
    nInRoomVerifyID: Integer;    //入寓方式
    nOutRoomVerifyID: Integer;   //离寓方式
    strDutyUserGUID: string;    //值班员GUID
    strDutyUserName:string;     //值班员名字
    strSiteGUID:string;
    strTrainmanNumber: string;  //乘务员工号
    strTrainmanName: string;    //乘务员名字
    strRoomNumber:string;     //房间编号
    nBedNumber:Integer;        //床位编号
  end;

  TRsRoomSignList = class (TObjectList)
  protected
    procedure SetItem(Index:Integer;AObject:TRsRoomSign);
    function  GetItem(Index:Integer):TRsRoomSign;
  public
    function Add(AObject: TRsRoomSign): Integer;
    property Items[Index:Integer] : TRsRoomSign  read GetItem write SetItem;
  end;



  
  //公寓部分
  {入寓信息}
  TRsInRoomInfo = record
    strInRoomGUID: string;      //入寓GUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //乘务员GUID
    dtInRoomTime: TDateTime;    //入寓时间
    nInRoomVerifyID: Integer;    //入寓方式
    strDutyUserGUID: string;    //值班员GUID
    strDutyUserName:string;
    strSiteGUID:string;
    strTrainmanNumber: string;  //乘务员工号
    strRoomNumber:string;     //房间编号
    nBedNumber:Integer;        //床位编号
    nIsOutRoom:Integer;       //是否已经离寓
    dtCreatetTime:TDateTime;
  end;

  TRsInRoomInfoArray = array of TRsInRoomInfo;

  {离寓信息}
  TRsOutRoomInfo = record
    strInRoomGUID: string;      //入寓GUID
    strOutRoomGUID: string;     //离开公寓GUID
    strTrainPlanGUID: string;
    strTrainmanGUID: string;    //乘务员GUID
    dtOutRoomTime: TDateTime;   //离寓时间
    nOutRoomVerifyID: Integer;   //离寓方式
    strDutyUserGUID: string;    //值班员GUID
    strDutyUserName:string;
    strSiteGUID:string;
    strTrainmanNumber: string;  //乘务员工号
    dtCreatetTime:TDateTime;
  end;

  TRsOutRoomInfoArray = array of TRsOutRoomInfo;
  //


implementation

{ TRoomSignInOutList }



function TRsRoomSignList.Add(AObject: TRsRoomSign): Integer;
begin
  Result := inherited  Add(AObject)  ;
end;

function TRsRoomSignList.GetItem(Index: Integer): TRsRoomSign;
begin
  Result := TRsRoomSign ( inherited GetItem(Index)) ;
end;

procedure TRsRoomSignList.SetItem(Index: Integer; AObject: TRsRoomSign);
begin
  inherited SetItem(Index,AObject);
end;

end.
