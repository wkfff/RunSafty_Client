unit uDrink;
interface
uses
  Classes,ZKFPEngXUtils,uApparatusCommon;
type
  //测酒记录查询
  RRsDrink = Record
    //测酒记录GUID
    strGUID : string;
    //是否是本段人员
    bLocalAreaTrainman:boolean;
    //乘务员GUID
    strTrainmanGUID : string;
    //人员姓名
    strTrainmanName : string;
    //人员工号
    strTrainmanNumber : string;
    //酒精度(mg/100ml)
    dwAlcoholicity : Integer ;
     //机车类型
    strTrainTypeName : string;
    //机车号
    strTrainNumber : string;
    {车次}
    strTrainNo : String;

    //测酒地点
    strPlaceID : string ;
    //测酒地点名字
    strPlaceName: string ;

    //客户端编号
    strSiteGUID : string;
    //客户端IP
    strSiteIp : string;
    //客户端名称
    strSiteName : string;

    //所属车间名称
    strWorkShopName : string;
    //所属车间
    strWorkShopGUID : string ;

    //测酒结果
    nDrinkResult : integer;
    //测酒结果名称
    strDrinkResultName : string;
    //测酒时间
    dtCreateTime : TDateTime;
    //测酒照片
    DrinkImage : OleVariant;
    //测酒区域
    strAreaGUID : string;
    //值班员GUID
    strDutyGUID : string;
    //值班员工号
    strDutyNumber:string;
    //值班员名字
    strDutyName : string ;
    //验证方式
    nVerifyID : integer;
    //验证类型名称
    strVerifyName : string;
    //所属流程GUID
    strWorkID : string;
    //测酒类型
    nWorkTypeID : integer;
    //测酒类型名称
    strWorkTypeName : string;
    //测酒照片URL
    strPictureURL: string;
    //备注
    strRemark: string;

    //所属部分ID
    strDepartmentID: string;
    //所属部门名称
    strDepartmentName: string;

    //职务ID
    nCadreTypeID: integer;
    //职务名称
    strCadreTypeName: string;

  public
    procedure SetPicture(Picture: TMemoryStream);
    procedure ReadPicture(Stream: TMemoryStream);
    procedure AssignFromTestAlcoholInfo(TestAlcoholInfo: RTestAlcoholInfo);
  End;
  TRsDrinkArray = array of RRsDrink;
  
implementation

{ RRsDrink }

procedure RRsDrink.AssignFromTestAlcoholInfo(TestAlcoholInfo: RTestAlcoholInfo);
begin
  nDrinkResult := Ord(TestAlcoholInfo.taTestAlcoholResult);
  DrinkImage := TestAlcoholInfo.Picture;
  dtCreateTime := TestAlcoholInfo.dtTestTime;

  dwAlcoholicity := TestAlcoholInfo.nAlcoholicity;
end;

procedure RRsDrink.ReadPicture(Stream: TMemoryStream);
begin
  TemplateOleVariantToStream(DrinkImage,Stream);
end;

procedure RRsDrink.SetPicture(Picture: TMemoryStream);
begin
  DrinkImage := StreamToTemplateOleVariant(Picture)
end;

end.
