unit uLCDayPlan;

interface
uses uHttpWebAPI,superobject,SysUtils,Classes,uTemplateDayPlan,uSaftyEnum,Contnrs;
type
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TSystem
  /// 说明:TSystem接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDayPlanSystem = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:获取机车计划系统管理员密码
    function IsAdmin(DayPlanPassWord : String): Boolean;
    //功能:获取计划车型定义信息
    procedure GetTrainTypes(out TrainTypes : TRsShortTrainArray);
  Private
    m_WebAPIUtils:TWebAPIUtils;
  end;

  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TPlace
  /// 说明:TPlace接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDayPlanPlace = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:获取机车班计划区域
    procedure QueryPlace(PlaceList: TRsDayPlanList);
  Private
    m_WebAPIUtils:TWebAPIUtils;
  end;


  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TGroup
  /// 说明:TGroup接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDayPlanGroup = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:获取指定计划区域内的机车组信息
    procedure QueryGroups(ID : Integer;Groups : TRsDayPlanItemGroupList);
    //功能:获取指定机车组信息
    function GetGroup(DayPlanID : Integer;GroupID : Integer;Group : TRsDayPlanItemGroup): Boolean;

    //添加机组
    procedure Add(Group : TRsDayPlanItemGroup);
    //更新机组
    procedure Update(Group : TRsDayPlanItemGroup);
    //删除机组
    procedure Delete(DayPlanID,GroupID: integer);
  Private
    m_WebAPIUtils:TWebAPIUtils;
    class procedure JsonToGroup(iJson: ISuperObject;Group: TRsDayPlanItemGroup);
    class function GroupToJson(const Group: TRsDayPlanItemGroup): ISuperObject;
  end;


  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TModules
  /// 说明:TModules接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDayPlanModules = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:获取指定机车组内的计划信息
    procedure QueryModules(GroupID : Integer;DayPlanType : Integer;Modules : TRsDayPlanItemList);
    //功能:添加机车计划模版信息
    procedure AddModule(Module : TRsDayPlanItem);
    //功能:修改机车计划模版信息
    procedure UpdateModule(Module : TRsDayPlanItem);
    //功能:删除机车计划模版信息
    procedure DeleteModule(ID : Integer);
    //功能:获取机车信息模版信息
    function GetModule(ID : Integer;Module : TRsDayPlanItem): Boolean;
  Private
    m_WebAPIUtils:TWebAPIUtils;
    procedure JsonToPlanItem(iJson: ISuperObject; PlanItem: TRsDayPlanItem);
    function PlanItemToJson(PlanItem: TRsDayPlanItem): ISuperObject;
  end;



  TRsDayPlanGroup_Export = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_PlanItemGroup: TRsDayPlanItemGroup;
  public
    PlanArray: RsDayPlanInfoArray;
    property PlanItemGroup: TRsDayPlanItemGroup read m_PlanItemGroup;
  end;



  TRsDayPlanGroupList_Export = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsDayPlanGroup_Export;
    procedure SetItem(Index: Integer; AObject: TRsDayPlanGroup_Export);
  public
    property Items[Index: Integer]: TRsDayPlanGroup_Export read GetItem write SetItem; default;
  end;


  TRsDayPlanExportData = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_LeftGroup: TRsDayPlanGroupList_Export;
    m_RightGroup: TRsDayPlanGroupList_Export;
  public
    property LeftGroup: TRsDayPlanGroupList_Export read m_LeftGroup;
    property RightGroup: TRsDayPlanGroupList_Export read m_RightGroup; 
  end;

  
  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TDayPlan
  /// 说明:TDayPlan接口类
  /////////////////////////////////////////////////////////////////////////////
  TRsLCDayPlan = Class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
  public
    //功能:获取指定机车的所有机车计划信息
    procedure QueryPlans(BeginDate : TDateTime;EndDate : TDateTime;GroupID : Integer;out PlanList : RsDayPlanInfoArray);
    //功能:获取指定机车的已下发的计划信息
    procedure QueryPublishPlans(BeginDate : TDateTime;EndDate : TDateTime;GroupID : Integer;out PlanList : RsDayPlanInfoArray);
    //功能:获取指定的机车计划信息
    function GetPlan(PlanGUID : String;out Plan : RsDayPlanInfo): Boolean;
    //功能:添加机车计划信息
    procedure AddDayPlan(Plan : RsDayPlanInfo;Log : RsDayPlanLog);
    //功能:修改机车计划
    procedure UpdateDayPlan(Plan : RsDayPlanInfo;Log : RsDayPlanLog;strSiteID,strDutyID: string);
    //功能:删除机车计划
    function DeleteDayPlan(DayPlanGUID : String;Log : RsDayPlanLog): Boolean;
    //功能:下发机车计划
    procedure SendDayPlan(BeginTime : TDateTime;EndTime : TDateTime;DayPlanID : Integer);
    //功能:从模版中加载机车计划
    procedure Load(BeginTime,EndTime : TDateTime;DayPlanTypeID : Integer;DayPlanID : Integer);
    //功能:导出机车计划
    procedure ExportPlan(BeginDate : TDateTime;EndDate : TDateTime;DayPlanID : Integer;
      DayOrNight : Integer;ExportData: TRsDayPlanExportData);
    //清除计划
    procedure ClearDayPlan(BeginDate,EndDate: TDateTime;DayPlanID:Integer);
    //是否已经加载过计划修
    function IsLoadedPlan(BeginDate,EndDate: TDateTime;DayPlanID, planType: integer): Boolean;
    //改计划为已发送
    procedure SetSended(dtBeginTime,dtEndTime: TDateTime;nDayPlanID: integer; plans: TStrings);
  Private
    m_WebAPIUtils:TWebAPIUtils;
    function JsonToDayPlan(iJson: ISuperObject): RsDayPlanInfo;
    function DayPlanToJson(PlanInfo: RsDayPlanInfo): ISuperObject;
    function PlanLogToJson(Log : RsDayPlanLog): ISuperObject;
    procedure JsonToExportData(iJson: ISuperObject;DayPlan_Export: TRsDayPlanGroup_Export);
  end;



  TRsLCDayTemplate = class
  public
    constructor Create(WebAPIUtils:TWebAPIUtils);
    destructor Destroy;override;
  private
    m_LCSystem: TRsLCDayPlanSystem;
    m_LCPlanPlace: TRsLCDayPlanPlace;
    m_LCPlanGroup: TRsLCDayPlanGroup;
    m_LCPlanModules: TRsLCDayPlanModules;
    m_LCPlan: TRsLCDayPlan;
  public
    property LCSystem: TRsLCDayPlanSystem read m_LCSystem;
    property LCPlanPlace: TRsLCDayPlanPlace read m_LCPlanPlace;
    property LCPlanGroup: TRsLCDayPlanGroup read m_LCPlanGroup;
    property LCPlanModules: TRsLCDayPlanModules read m_LCPlanModules;
    property LCPlan: TRsLCDayPlan read m_LCPlan;
  end;
implementation

{ TRsLCDayPlanPlace }

constructor TRsLCDayPlanPlace.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCDayPlanPlace.QueryPlace(PlaceList: TRsDayPlanList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  RsDayPlan: TRsDayPlan;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Place.QueryPlace',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['placeList'];


  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    RsDayPlan := TRsDayPlan.Create;
    RsDayPlan.ID := JSON.AsArray[i].I['ID'];
    RsDayPlan.Name := JSON.AsArray[i].S['Name'];
    PlaceList.Add(RsDayPlan);
  end;

end;

{ TRsLCDayPlanSystem }

constructor TRsLCDayPlanSystem.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;


procedure TRsLCDayPlanSystem.GetTrainTypes(out TrainTypes: TRsShortTrainArray);
  function JsonToTrainType(iJson: ISuperObject): RRsShortTrain;
  begin
    Result.nID := iJson.I['nID'];
    Result.strShortName := iJson.S['strShortName'];
    Result.strLongName := iJson.S['strLongName'];
  end;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.System.TrainType.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['TrainTypes'];

  SetLength(TrainTypes,JSON.AsArray.Length);
  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    TrainTypes[i] := JsonToTrainType(JSON.AsArray[i]);
  end;

end;

function TRsLCDayPlanSystem.IsAdmin(DayPlanPassWord: String): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['DayPlanPassWord'] := DayPlanPassWord;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.System.IsAdmin',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['result'];
end;
{ TRsLCDayPlanGroup }

procedure TRsLCDayPlanGroup.Add(Group: TRsDayPlanItemGroup);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['group'] := GroupToJson(Group);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Group.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


constructor TRsLCDayPlanGroup.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCDayPlanGroup.Delete(DayPlanID, GroupID: integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['DayPlanID'] := DayPlanID;
  JSON.I['GroupID'] := GroupID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Group.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;


function TRsLCDayPlanGroup.GetGroup(DayPlanID, GroupID: Integer;
  Group: TRsDayPlanItemGroup): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['DayPlanID'] := DayPlanID;
  JSON.I['GroupID'] := GroupID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Group.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];

  if Result then
  begin
    JsonToGroup(JSON.O['Group'],Group);
  end;


end;

class function TRsLCDayPlanGroup.GroupToJson(
  const Group: TRsDayPlanItemGroup): ISuperObject;
begin
  Result := SO;
  Result.I['ID'] := Group.ID;
  Result.S['Name'] := Group.Name;
  Result.I['IsDaWen'] := Group.IsDaWen;
  Result.I['DayPlanID'] := Group.DayPlanID;
  Result.I['ExcelSide'] := Group.ExcelSide;
  Result.I['ExcelPos'] := Group.ExcelPos;

end;

class procedure TRsLCDayPlanGroup.JsonToGroup(iJson: ISuperObject;
  Group: TRsDayPlanItemGroup);
begin
  Group.ID := iJson.I['ID'];
  Group.Name := iJson.S['Name'];
  Group.IsDaWen := iJson.I['IsDaWen'];
  Group.DayPlanID := iJson.I['DayPlanID'];
  Group.ExcelSide := iJson.I['ExcelSide'];
  Group.ExcelPos := iJson.I['ExcelPos'];

end;

procedure TRsLCDayPlanGroup.QueryGroups(ID: Integer;
  Groups: TRsDayPlanItemGroupList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  ItemGroup: TRsDayPlanItemGroup;
begin
  JSON := SO();
  JSON.I['ID'] := ID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Group.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['Groups'];



  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    ItemGroup := TRsDayPlanItemGroup.Create;

    JsonToGroup(JSON.AsArray[i],ItemGroup);


    Groups.Add(ItemGroup);
  end;

end;

procedure TRsLCDayPlanGroup.Update(Group: TRsDayPlanItemGroup);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['group'] := GroupToJson(Group);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Group.Update',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

{ TRsLCDayPlanModules }

procedure TRsLCDayPlanModules.AddModule(Module: TRsDayPlanItem);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['Module'] := PlanItemToJson(Module);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Modules.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

constructor TRsLCDayPlanModules.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

procedure TRsLCDayPlanModules.DeleteModule(ID: Integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['ID'] := ID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Modules.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

function TRsLCDayPlanModules.GetModule(ID: Integer;
  Module: TRsDayPlanItem): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['ID'] := ID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Modules.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);

  Result := JSON.B['bExist'];
  if Result then
  begin
    JsonToPlanItem(JSON.O['Module'],Module);
  end;

  
end;

procedure TRsLCDayPlanModules.JsonToPlanItem(iJson: ISuperObject;
  PlanItem: TRsDayPlanItem);
begin
  PlanItem.ID := iJson.I['ID'];
  PlanItem.DayPlanType := TDayPlanType(iJson.I['DayPlanType']);
  PlanItem.TrainNo1 := iJson.S['TrainNo1'];
  PlanItem.TrainInfo := iJson.S['TrainInfo'];
  PlanItem.TrainNo2 := iJson.S['TrainNo2'];
  PlanItem.TrainNo := iJson.S['TrainNo'];
  PlanItem.Remark := iJson.S['Remark'];
  PlanItem.IsTomorrow := iJson.I['IsTomorrow'];
  PlanItem.DaWenCheXing := iJson.S['DaWenCheXing'];
  PlanItem.DaWenCheHao1 := iJson.S['DaWenCheHao1'];
  PlanItem.DaWenCheHao2 := iJson.S['DaWenCheHao2'];
  PlanItem.DaWenCheHao3 := iJson.S['DaWenCheHao3'];
  PlanItem.GroupID := iJson.I['GroupID'];
end;

function TRsLCDayPlanModules.PlanItemToJson(
  PlanItem: TRsDayPlanItem): ISuperObject;
begin
  Result := SO;
  Result.I['ID'] := PlanItem.ID;
  Result.I['DayPlanType'] := Ord(PlanItem.DayPlanType);
  Result.S['TrainNo1'] := PlanItem.TrainNo1;
  Result.S['TrainInfo'] := PlanItem.TrainInfo;
  Result.S['TrainNo2'] := PlanItem.TrainNo2;
  Result.S['TrainNo'] := PlanItem.TrainNo;
  Result.S['Remark'] := PlanItem.Remark;
  Result.I['IsTomorrow'] := PlanItem.IsTomorrow;
  Result.S['DaWenCheXing'] := PlanItem.DaWenCheXing;
  Result.S['DaWenCheHao1'] := PlanItem.DaWenCheHao1;
  Result.S['DaWenCheHao2'] := PlanItem.DaWenCheHao2;
  Result.S['DaWenCheHao3'] := PlanItem.DaWenCheHao3;
  Result.I['GroupID'] := PlanItem.GroupID;
end;

procedure TRsLCDayPlanModules.QueryModules(GroupID, DayPlanType: Integer;
  Modules: TRsDayPlanItemList);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  PlanItem: TRsDayPlanItem;
begin
  JSON := SO();
  JSON.I['GroupID'] := GroupID;
  JSON.I['DayPlanType'] := DayPlanType;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Modules.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['Modules'];


  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    PlanItem := TRsDayPlanItem.Create;

    JsonToPlanItem(JSON.AsArray[i],PlanItem);
    Modules.Add(PlanItem);
  end;

end;

procedure TRsLCDayPlanModules.UpdateModule(Module: TRsDayPlanItem);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['Module'] := PlanItemToJson(Module);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.Modules.Update',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;
end;

{ TRsLCDayPlan }

procedure TRsLCDayPlan.AddDayPlan(Plan: RsDayPlanInfo; Log: RsDayPlanLog);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.O['Plan'] := DayPlanToJson(Plan);
  JSON.O['Log'] := PlanLogToJson(Log);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Add',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;

procedure TRsLCDayPlan.ClearDayPlan(BeginDate, EndDate: TDateTime;
  DayPlanID: Integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['nDayPlanID'] := DayPlanID;
  JSON.S['dtBeginDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginDate);
  JSON.S['dtEndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.ClearPlan',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

end;

constructor TRsLCDayPlan.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_WebAPIUtils := WebAPIUtils;
end;

function TRsLCDayPlan.DayPlanToJson(PlanInfo: RsDayPlanInfo): ISuperObject;
begin
  Result := SO;
  Result.S['strDayPlanGUID'] := PlanInfo.strDayPlanGUID;
  Result.I['nPlanState'] := Ord(PlanInfo.nPlanState);
  Result.S['dtBeginTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',PlanInfo.dtBeginTime);
  Result.S['dtEndTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',PlanInfo.dtEndTime);
  Result.S['dtCreateTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',PlanInfo.dtCreateTime);
  Result.S['strTrainNo1'] := PlanInfo.strTrainNo1;
  Result.S['strTrainInfo'] := PlanInfo.strTrainInfo;
  Result.S['strTrainNo2'] := PlanInfo.strTrainNo2;
  Result.S['strTrainNo'] := PlanInfo.strTrainNo;
  Result.S['strTrainTypeName'] := PlanInfo.strTrainTypeName;
  Result.S['strTrainNumber'] := PlanInfo.strTrainNumber;
  Result.I['nid'] := PlanInfo.nid;                            
  Result.I['bIsTomorrow'] := PlanInfo.bIsTomorrow;
  Result.S['strRemark'] := PlanInfo.strRemark;
  Result.I['bIsSend'] := PlanInfo.bIsSend;
  Result.S['strDaWenCheXing'] := PlanInfo.strDaWenCheXing;
  Result.S['strDaWenCheHao1'] := PlanInfo.strDaWenCheHao1;
  Result.S['strDaWenCheHao2'] := PlanInfo.strDaWenCheHao2;
  Result.S['strDaWenCheHao3'] := PlanInfo.strDaWenCheHao3;
  Result.I['nDayPlanID'] := PlanInfo.nDayPlanID;
  Result.I['nQuDuanID'] := PlanInfo.nQuDuanID;
  Result.I['nPlanID'] := PlanInfo.nPlanID;
  Result.S['strTrainPlanGUID'] := PlanInfo.strTrainPlanGUID;
end;

function TRsLCDayPlan.DeleteDayPlan(DayPlanGUID: String; Log: RsDayPlanLog): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['DayPlanGUID'] := DayPlanGUID;
  JSON.O['Log'] := PlanLogToJson(Log);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Delete',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['result'];

end;

procedure TRsLCDayPlan.ExportPlan(BeginDate, EndDate: TDateTime; DayPlanID,
  DayOrNight: Integer;ExportData: TRsDayPlanExportData);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
  PlanGroup_Export: TRsDayPlanGroup_Export;
begin
  JSON := SO();
  JSON.S['BeginDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginDate);
  JSON.S['EndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);
  JSON.I['DayPlanID'] := DayPlanID;
  JSON.I['DayOrNight'] := DayOrNight;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Export',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['ExportData'];

  for I := 0 to JSON.O['leftGroups'].AsArray.Length - 1 do
  begin
    PlanGroup_Export := TRsDayPlanGroup_Export.Create;
    ExportData.LeftGroup.Add(PlanGroup_Export);
    JsonToExportData(JSON.O['leftGroups'].AsArray[i],PlanGroup_Export)
  end;

  for I := 0 to JSON.O['rightGroups'].AsArray.Length - 1 do
  begin
    PlanGroup_Export := TRsDayPlanGroup_Export.Create;
    ExportData.RightGroup.Add(PlanGroup_Export);
    JsonToExportData(JSON.O['rightGroups'].AsArray[i],PlanGroup_Export)
  end;


end;

function TRsLCDayPlan.GetPlan(PlanGUID: String;
  out Plan: RsDayPlanInfo): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['PlanGUID'] := PlanGUID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Get',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['bExist'];

  if Result then
    Plan := JsonToDayPlan(Json.O['Plan']);

end;
function TRsLCDayPlan.IsLoadedPlan(BeginDate, EndDate: TDateTime; DayPlanID,
  planType: integer): Boolean;
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.I['nDayPlanID'] := DayPlanID;
  JSON.I['nPlanType'] := planType;
  JSON.S['BeginDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginDate);
  JSON.S['EndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.IsLoadedPlan',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  Result := JSON.B['result'];

end;
function TRsLCDayPlan.JsonToDayPlan(iJson: ISuperObject): RsDayPlanInfo;
begin
  Result.strDayPlanGUID := iJson.S['strDayPlanGUID'];
  Result.nPlanState := TRsPlanState(iJson.I['nPlanState']);
  Result.dtBeginTime := strToDateTimeDef(iJson.S['dtBeginTime'],0);
  Result.dtEndTime := strToDateTimeDef(iJson.S['dtEndTime'],0);
  Result.dtCreateTime := strToDateTimeDef(iJson.S['dtCreateTime'],0);
  Result.strTrainNo1 := iJson.S['strTrainNo1'];
  Result.strTrainInfo := iJson.S['strTrainInfo'];
  Result.strTrainNo2 := iJson.S['strTrainNo2'];
  Result.strTrainNo := iJson.S['strTrainNo'];
  Result.strTrainTypeName := iJson.S['strTrainTypeName'];
  Result.strTrainNumber := iJson.S['strTrainNumber'];
  Result.nid := iJson.I['nid'];
  Result.bIsTomorrow := iJson.I['bIsTomorrow'];
  Result.strRemark := iJson.S['strRemark'];
  Result.bIsSend := iJson.I['bIsSend'];
  Result.strDaWenCheXing := iJson.S['strDaWenCheXing'];
  Result.strDaWenCheHao1 := iJson.S['strDaWenCheHao1'];
  Result.strDaWenCheHao2 := iJson.S['strDaWenCheHao2'];
  Result.strDaWenCheHao3 := iJson.S['strDaWenCheHao3'];
  Result.nDayPlanID := iJson.I['nDayPlanID'];
  Result.nQuDuanID := iJson.I['nQuDuanID'];
  Result.nPlanID := iJson.I['nPlanID'];
  Result.strTrainPlanGUID := iJson.S['strTrainPlanGUID'];
end;

procedure TRsLCDayPlan.JsonToExportData(iJson: ISuperObject;
  DayPlan_Export: TRsDayPlanGroup_Export);
var
  I: Integer;
begin
  TRsLCDayPlanGroup.JsonToGroup(iJson,DayPlan_Export.PlanItemGroup);
  SetLength(DayPlan_Export.PlanArray,iJson.O['PlanArray'].AsArray.Length);  
  for I := 0 to iJson.O['PlanArray'].AsArray.Length - 1 do
  begin
    DayPlan_Export.PlanArray[i] := JsonToDayPlan(iJson.O['PlanArray'].AsArray[i]);
  end;
end;

procedure TRsLCDayPlan.Load(BeginTime,EndTime: TDateTime;
  DayPlanTypeID, DayPlanID: Integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['BeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginTime);
  JSON.S['EndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndTime);
  JSON.I['DayPlanTypeID'] := DayPlanTypeID;
  JSON.I['DayPlanID'] := DayPlanID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Load',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;

function TRsLCDayPlan.PlanLogToJson(Log: RsDayPlanLog): ISuperObject;
begin
  Result := SO();
  Result.S['strLogGUID'] := Log.strLogGUID;
  Result.S['strlogType'] := Log.strlogType;
  Result.S['strDayPlanGUID'] := Log.strDayPlanGUID;
  Result.S['strTrainNo1'] := Log.strTrainNo1;
  Result.S['strTrainInfo'] := Log.strTrainInfo;
  Result.S['strTrainNo2'] := Log.strTrainNo2;
  Result.S['strRemark'] := Log.strRemark;
  Result.S['dtChangeTime'] := formatdatetime('yyyy-mm-dd hh:nn:ss',Log.dtChangeTime);
end;

procedure TRsLCDayPlan.QueryPlans(BeginDate, EndDate: TDateTime;
  GroupID: Integer; out PlanList: RsDayPlanInfoArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.I['GroupID'] := GroupID;
  JSON.S['BeginDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginDate);
  JSON.S['EndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Query',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['PlanList'];

  SetLength(PlanList,JSON.AsArray.Length);

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    PlanList[i] := JsonToDayPlan(JSON.AsArray[i]);
  end;

end;

procedure TRsLCDayPlan.QueryPublishPlans(BeginDate, EndDate: TDateTime;
  GroupID: Integer; out PlanList: RsDayPlanInfoArray);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.I['GroupID'] := GroupID;
  JSON.S['BeginDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginDate);
  JSON.S['EndDate'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndDate);

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.QueryPB',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;

  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData);
  JSON := JSON.O['PlanList'];

  SetLength(PlanList,JSON.AsArray.Length);

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    PlanList[i] := JsonToDayPlan(JSON.AsArray[i]);
  end;

end;

procedure TRsLCDayPlan.SendDayPlan(BeginTime, EndTime: TDateTime;
  DayPlanID: Integer);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();
  JSON.S['BeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',BeginTime);
  JSON.S['EndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',EndTime);
  JSON.I['DayPlanID'] := DayPlanID;

  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Send',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;

procedure TRsLCDayPlan.SetSended(dtBeginTime, dtEndTime: TDateTime;
  nDayPlanID: integer; plans: TStrings);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
  I: Integer;
begin
  JSON := SO();
  JSON.I['nDayPlanID'] := nDayPlanID;
  JSON.S['dtBeginTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtBeginTime);
  JSON.S['dtEndTime'] := FormatDateTime('yyyy-mm-dd hh:nn:ss',dtEndTime);
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.SetSended',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


  JSON := m_WebAPIUtils.GetHttpDataJson(strOutputData).O['plans'];

  for I := 0 to JSON.AsArray.Length - 1 do
  begin
    plans.Add(JSON.AsArray[i].AsString);
  end;

end;

procedure TRsLCDayPlan.UpdateDayPlan(Plan: RsDayPlanInfo; Log: RsDayPlanLog;strSiteID,strDutyID: string);
var
  strOutputData,strResultText : String;
  JSON : ISuperObject;
begin
  JSON := SO();

  JSON.O['Plan'] := DayPlanToJson(Plan);
  JSON.O['Log'] := PlanLogToJson(Log);
  JSON.S['strDutyGUID'] := strSiteID;
  JSON.S['strSiteGUID'] := strDutyID;
  strOutputData := m_WebAPIUtils.Post('TF.RunSafty.LCDayPlan.DayPlan.Update',json.AsString);
  if m_WebAPIUtils.CheckPostSuccess(strOutputData,strResultText) = false then
  begin
    Raise Exception.Create(strResultText);
  end;


end;
{ TRsLCDayTemplate }

constructor TRsLCDayTemplate.Create(WebAPIUtils: TWebAPIUtils);
begin
  m_LCSystem:= TRsLCDayPlanSystem.Create(WebAPIUtils);
  m_LCPlanPlace:= TRsLCDayPlanPlace.Create(WebAPIUtils);
  m_LCPlanGroup:= TRsLCDayPlanGroup.Create(WebAPIUtils);
  m_LCPlanModules:= TRsLCDayPlanModules.Create(WebAPIUtils);
  m_LCPlan:= TRsLCDayPlan.Create(WebAPIUtils);
end;

destructor TRsLCDayTemplate.Destroy;
begin
  m_LCSystem.Free;
  m_LCPlanPlace.Free;
  m_LCPlanGroup.Free;
  m_LCPlanModules.Free;
  m_LCPlan.Free;
  inherited;
end;

{ TRsDayPlanGroupList_Export }

function TRsDayPlanGroupList_Export.GetItem(
  Index: Integer): TRsDayPlanGroup_Export;
begin
  Result := TRsDayPlanGroup_Export(Inherited GetItem(Index));
end;

procedure TRsDayPlanGroupList_Export.SetItem(Index: Integer;
  AObject: TRsDayPlanGroup_Export);
begin
  Inherited SetItem(index,AObject)
end;

{ TRsDayPlanGroup_Export }

constructor TRsDayPlanGroup_Export.Create;
begin
  m_PlanItemGroup := TRsDayPlanItemGroup.Create;
end;

destructor TRsDayPlanGroup_Export.Destroy;
begin
  m_PlanItemGroup.Free;
  SetLength(PlanArray,0);
  inherited;
end;

{ TRsDayPlanExportData }

constructor TRsDayPlanExportData.Create;
begin
  m_LeftGroup := TRsDayPlanGroupList_Export.Create;
  m_RightGroup := TRsDayPlanGroupList_Export.Create;
end;

destructor TRsDayPlanExportData.Destroy;
begin
  m_LeftGroup.Free;
  m_RightGroup.Free;            
  inherited;
end;

end.
