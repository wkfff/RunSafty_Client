unit uOffLine;

interface
uses
  Classes,SuperObject,Contnrs,uJsonSerialize,uDrink;
type
  TWorkData = class;
  TOffLineData = class
  public
    constructor Create();
    destructor Destroy;override;
  private
    m_ID: integer;
    m_WorkType: integer;
    m_Data: TWorkData;
    m_CreateTime: TDateTime;
  public
    property ID: integer read m_ID write m_ID;
    property WorkType: integer read m_WorkType write m_WorkType;
    property Data: TWorkData read m_Data write m_Data;
    property CreateTime: TDateTime read m_CreateTime write m_CreateTime;
  end;

  TOffLineDataList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TOffLineData;
    procedure SetItem(Index: Integer; AObject: TOffLineData);
  public
    property Items[Index: Integer]: TOffLineData read GetItem write SetItem; default;
  end;

  TDrinkPersist = class(TSerialPersistent)
  private
    //人员ID
    m_TmGUID: string;
    //工号
    m_TmNumber: string;
    //人员姓名
    m_TmName: string;
    //酒精度
    m_Alcoholicity: integer;
    //机车类型
    m_TrainType: string;
    //机车号
    m_TrainNumber: string;
    {车次}
    m_TrainNo: string;
    
    //测酒地点
    m_PlaceID: string;
    //测酒地点名字                  
    m_PlaceName: string;
    
    //客户端编号
    m_SiteGUID: string;
    //客户端IP
    m_SiteIp: string;
    //客户端名称
    m_SiteName: string;
    
    //所属车间名称
    m_WorkShopName: string;
    //所属车间
    m_WorkShopGUID: string;
    
    //测酒结果
    m_DrinkResult: integer;
    //测酒结果名称
    m_DrinkResultName: string;
    //测酒时间
    m_CreateTime: tdatetime;
    //测酒区域
    m_AreaGUID: string;
    //值班员GUID
    m_DutyGUID: string;
    //值班员工号
    m_DutyNumber: string;
    //值班员名字
    m_DutyName: string;
    //验证方式
    m_VerifyID: integer;
    //所属流程GUID
    m_WorkID: string;
    //测酒类型
    m_WorkTypeID: integer;
    //测酒照片URL
    m_PictureURL: string;
    //备注
    m_Remark: string;   
  public
    procedure LoadFromRsDrink(src: RRsDrink);
  published
    property TmGUID: string read m_TmGUID write m_TmGUID;
    property TmNumber: string read m_TmNumber write m_TmNumber;
    property TmName: string read m_TmName write m_TmName;
    property Alcoholicity: integer read m_Alcoholicity write m_Alcoholicity;
    property TrainType: string read m_TrainType write m_TrainType;
    property TrainNumber: string read m_TrainNumber write m_TrainNumber;
    property TrainNo: string read m_TrainNo write m_TrainNo;
    property PlaceID: string read m_PlaceID write m_PlaceID;
    property PlaceName: string read m_PlaceName write m_PlaceName;
    property SiteGUID: string read m_SiteGUID write m_SiteGUID;
    property SiteIp: string read m_SiteIp write m_SiteIp;
    property SiteName: string read m_SiteName write m_SiteName;
    property WorkShopName: string read m_WorkShopName write m_WorkShopName;
    property WorkShopGUID: string read m_WorkShopGUID write m_WorkShopGUID;
    property DrinkResult: integer read m_DrinkResult write m_DrinkResult;
    property DrinkResultName: string read m_DrinkResultName write m_DrinkResultName;
    property CreateTime: tdatetime read m_CreateTime write m_CreateTime;
    property AreaGUID: string read m_AreaGUID write m_AreaGUID;
    property DutyGUID: string read m_DutyGUID write m_DutyGUID;
    property DutyNumber: string read m_DutyNumber write m_DutyNumber;
    property DutyName: string read m_DutyName write m_DutyName;
    property VerifyID: integer read m_VerifyID write m_VerifyID;
    property WorkID: string read m_WorkID write m_WorkID;
    property WorkTypeID: integer read m_WorkTypeID write m_WorkTypeID;
    property PictureURL: string read m_PictureURL write m_PictureURL;
    property Remark: string read m_Remark write m_Remark;
  end;

  TWorkData = class(TSerialPersistent)
  public
    constructor Create();override;
    destructor Destroy;override;
  private
    m_WorkType: integer;
    m_TrainNo: string;
    m_TrainType: string;
    m_TrainNumber: string;
    m_TmNumber: string;
    m_TmName: string;
    m_Drink: TDrinkPersist;
  published
    property WorkType: integer read m_WorkType write m_WorkType;
    property TrainNo: string read m_TrainNo write m_TrainNo;
    property TrainType: string read m_TrainType write m_TrainType;
    property TrainNumber: string read m_TrainNumber write m_TrainNumber;
    property TmNumber: string read m_TmNumber write m_TmNumber;
    property TmName: string read m_TmName write m_TmName;
    property Drink: TDrinkPersist read m_Drink;
  end;

  
implementation
function TOffLineDataList.GetItem(Index: Integer): TOffLineData;
begin
  result := TOffLineData(inherited GetItem(Index));
end;
procedure TOffLineDataList.SetItem(Index: Integer; AObject: TOffLineData);
begin
  Inherited SetItem(Index,AObject);
end;

{ TBWData }

constructor TWorkData.Create;
begin
  inherited;
  m_Drink := TDrinkPersist.Create;
end;

destructor TWorkData.Destroy;
begin
  m_Drink.Free;
  inherited;
end;

{ TDrinkPersist }

procedure TDrinkPersist.LoadFromRsDrink(src: RRsDrink);
begin
  TmGUID := src.strTrainmanGUID;
  TmNumber := src.strTrainmanNumber;
  TmName := src.strTrainmanName;
  Alcoholicity := src.dwAlcoholicity;
  TrainType := src.strTrainTypeName;
  TrainNumber := src.strTrainNumber;
  TrainNo := src.strTrainNo;
  PlaceID := src.strPlaceID;
  PlaceName := src.strPlaceName;
  SiteGUID := src.strSiteGUID;
  SiteIp := src.strSiteIp;
  SiteName := src.strSiteName;
  WorkShopName := src.strWorkShopName;
  WorkShopGUID := src.strWorkShopGUID;
  DrinkResult := src.nDrinkResult;
  DrinkResultName := src.strDrinkResultName;
  CreateTime := src.dtCreateTime;
  AreaGUID := src.strAreaGUID;
  DutyGUID := src.strDutyGUID;
  DutyNumber := src.strDutyNumber;
  DutyName := src.strDutyName;
  VerifyID := src.nVerifyID;
  WorkID := src.strWorkID;
  WorkTypeID := src.nWorkTypeID;
  PictureURL := src.strPictureURL;
  Remark := src.strRemark;
end;
{ TOffLineData }

constructor TOffLineData.Create;
begin
  m_Data := TWorkData.Create;
end;

destructor TOffLineData.Destroy;
begin
  m_Data.Free;
  inherited;
end;

end.