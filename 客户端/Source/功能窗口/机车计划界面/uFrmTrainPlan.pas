unit uFrmTrainPlan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel, Menus,uTrainPlan,
  uSaftyEnum,uDutyPlace,uStation,DateUtils,uTFMessageDefine,uRSCommonFunctions,
  uRunSaftyMessageDefine,uTrainman,utfsystem,uLCTrainPlan,uLCDutyPlace,uTrainJiaolu,
  uLCTrainnos,uDayPlan,uSite,uLCBaseDict,utfskin;


const
  COL_XUHAO_INDEX = 0;
  COL_STATE_INDEX = 1;
  COL_TRAINJIAOLU_INDEX = 2;
  COL_WAIQIN_INDEX = 3;
  COL_TRAINTYPE_INDEX = 4;
  COL_TRAINNO_INDEX = 5;
  COL_CHECI_INDEX = 6;
  COL_REMARK_INDEX = 7;
  COL_REMARKTYPE_INDEX = 8;
  COL_DUTYPLACE_INDEX = 9 ;

  COL_BEGINWORKTIME_INDEX = 10;
  COL_REALKAICHETIME_INDEX = 11;
  COL_PLANKAICHETIME_INDEX = 12;
  COL_REAL_BEGINWORKTIME_INDEX = 13 ; //实际出勤时间

  COL_TRAINMAN_INDEX = 14;
  COL_SUBTRAINMAN_INDEX = 15;
  COL_XUEYUAN_INDEX = 16;
  COL_XUEYUAN2_INDEX = 17;

  COL_STARTSTATION_INDEX = 18;
  COL_ENDSTATION_INDEX = 19;
  COL_TRAINMANTYPE_INDEX = 20;
  COL_PLANTYPE_INDEX = 21;
  COL_DRAGSTATE_INDEX = 22;
  COL_KEHUO_INDEX = 23;

  COL_HOUBAN_INDEX = 24;
  COL_HOUBANSHIJIAN_INDEX = 25;
  COL_JIAOBANSHIJIAN_INDEX = 26;

  COL_SendPlan_INDEX = 27;
  COL_RecPlan_INDEX = 28;

type
  TCheckJDPlanCallback = function(const planid: string): Boolean of object;
  TFrmTrainPlan = class(TForm)
    PlanGrid: TAdvStringGrid;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    PopupMenu: TPopupMenu;
    miClearTrainmanPlan: TMenuItem;
    procedure PlanGridMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miSelectColumnClick(Sender: TObject);
    procedure PlanGridCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure PlanGridGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure PlanGridGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure PlanGridGetEditorType(Sender: TObject; ACol,
      ARow: Integer; var AEditor: TEditorType);
    procedure PlanGridKeyPress(Sender: TObject; var Key: Char);
    procedure PlanGridCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure PlanGridEditCellDone(Sender: TObject; ACol,
      ARow: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure miClearTrainmanPlanClick(Sender: TObject);
    procedure PlanGridCustomCellBkgDraw(Sender: TObject; Canvas: TCanvas; ACol,
      ARow: Integer; AState: TGridDrawState; ARect: TRect; Printing: Boolean);
  private
    { Private declarations }
    m_nSelectCol : Integer ;//当前选中的实际列
    //机车计划信息
    m_PlanArray : TRsTrainmanPlanArray;
    //出勤点
    m_PlaceList:TRsDutyPlaceList;
     //车站列表
    m_StationArray: TRsStationArray;
    //当前时间
    m_dtNow: TDateTime;
    //是否修改
    m_bModifyed: Boolean;
    //web接口机车计划
    m_webTrainPlan: TRsLCTrainPlan ;
    //出勤点
    m_webDutyPlace:TRsLCDutyPlace ;
    //图定车次
    m_webTrainnos : TRsLCTrainnos;
    //行车区段
    m_TrainJl:RRsTrainJiaolu ;
    //开始和结束时间
    m_dtStartDate:TDateTime ;
    m_dtEndDate:TDateTime ;
    m_CheckJDPlanCallback: TCheckJDPlanCallback;
  private
    //设置交路号
    procedure SetTrainJiaoLu(TrainJiaolu:RRsTrainJiaolu);
    //创建一个新的机车计划，内容为空,后续通过GRID填充
    procedure CreateNewPlan(var TrainPlan: RRsTrainPlan);
    //机车计划添加到数据库
    procedure SubmitAddPlan(Plan: RRsTrainPlan);
    //更新机车计划，同时发送更新消息
    procedure UpdatePlan(nRow,nCol: Integer); overload;
    procedure ModifyPlan(PlanID:string;nRow,nCol: Integer);
    //复制计划
    function CopyPlan(PlanList:TStrings):Integer;
    //删除机车计划  ,返回值为成功的条数 ,参数为要删的列表
    function DeletePlan(PlanList:TStrings):Integer;
    //下发计划
    procedure SendPlanInner(PlanList:TStrings);
    //撤销计划
    procedure InnerCancelPlan(PlanList:TStrings);

    //根据指定的行号，吧GRID转成一个机车计划结构体
    procedure GridRowToTrainPlan(nRow: Integer; var Plan: RRsTrainPlan);overload;
    //根据指定的行号,把相关列赋值给候班结构体
    procedure GridRowToRest(nRow: Integer;var restInfo: RRsRest);
    //grid操作
    procedure NextFocus();
    //获取所有计划
    procedure GetAllPlan(PlanList:TStrings);
    //获取选中计划
    procedure GetSelPlan(PlanList:TStrings);
  public
    //初始化机车计划数据
    procedure RefreshPlan();
    //增加计划
    procedure InsertPlan();
    //删除计划
    procedure RemovePlan();
    //下发计划
    procedure SendPlan();
    //撤销计划
    procedure CancelPlan();
    //从图定车次表加载计划
    procedure LoadPlan();
  public
    property CheckJDPlanCallback: TCheckJDPlanCallback read m_CheckJDPlanCallback write m_CheckJDPlanCallback;
    property TrainJiaolu:RRsTrainJiaolu  read m_TrainJl write SetTrainJiaoLu;
    property StartDate:TDateTime read m_dtStartDate write m_dtStartDate ;
    property EndDate:TDateTime  read m_dtEndDate write m_dtEndDate;
    property dtNow: TDateTime read m_dtNow write m_dtNow;
  end;


implementation

uses
  uFrmSelectColumn,uGlobalDM,uFrmDayPlanTimeRange,ufrmHint ;


type
  PPlan = ^RRsTrainmanPlan;
  PSiteInfo = ^RRsSiteInfo;
  TWaiQin = class
  private
    class var _SiteArray: TRsSiteArray;
    class function FindSite(name: string): PSiteInfo;static;
  public
    class procedure Init();
    class function GetID(name: string): string;
    class function GetNumber(name: string): string;
    class procedure FillCombString(Grid: TAdvStringGrid);
  end;
{$R *.dfm}

//对参数不够(4)长度的前面补充0，缺几个补充几个
function FormatTrainNumber(TrainNumber: string): string;
begin
  Result := Trim(TrainNumber);
  if length(Result) = 3 then
    Result := '0' + Result;
  if length(Result) = 2 then
    Result := '00' + Result;
  if length(Result) = 1 then
    Result := '000' + Result;
end;

function GetCloumnName(Index:integer):string;
var
  strName:string;
begin
  strName := '' ;
  if Index < 0 then
    raise Exception.Create('列名不能为负数');
  case Index of
    COL_TRAINJIAOLU_INDEX  : strName := 'trainjiaoluID';
    COL_TRAINTYPE_INDEX  : strName := 'trainTypeName';
    COL_TRAINNO_INDEX  : strName := 'trainNumber';
    COL_CHECI_INDEX  : strName := 'trainNo';
    COL_REMARK_INDEX  : strName := 'strRemark';
    COL_DUTYPLACE_INDEX  : strName := 'placeID';
    COL_BEGINWORKTIME_INDEX  : strName := 'kaiCheTime';
    COL_PLANKAICHETIME_INDEX  : strName := 'startTime';

    COL_REMARKTYPE_INDEX : strName := 'remarkTypeID' ;
    COL_STARTSTATION_INDEX  : strName := 'startStationID';
    COL_ENDSTATION_INDEX  : strName := 'endStationID';
    COL_TRAINMANTYPE_INDEX  : strName := 'trainmanTypeID';
    COL_PLANTYPE_INDEX  : strName := 'planTypeID';
    COL_DRAGSTATE_INDEX  : strName := 'dragTypeID';
    COL_KEHUO_INDEX  : strName := 'kehuoID';
    COL_WAIQIN_INDEX  : strName := 'waiqinID';
  else
    strName := '' ;
  end;
  Result := strName ;
end;

//根据出勤点获取出勤点编号
function GetDutyPlacIDFromName(PlaceList: TRsDutyPlaceList;Name:string):string;
var
  i : integer ;
begin
  Result := '';
  for I := 0 to length(PlaceList) - 1 do
  begin
    if PlaceList[i].placeName = name then
    begin
      Result := PlaceList[i].placeID ;
      Break ;
    end;
  end;

end;
//根据站名获取站的ID
function GetStationIDFromName(Stations: TRsStationArray;Name:string):string;
var
  i : integer ;
begin
  Result := '';
  for I := 0 to length(Stations) - 1 do
  begin
    if Stations[i].strStationName = name then
    begin
      Result := Stations[i].strStationGUID ;
      Break ;
    end;
  end;
end;
//投递消息
procedure PostPlanMessage(TFMessageList: TTFMessageList);overload;
var
  I: Integer;
begin
  for I := 0 to TFMessageList.Count - 1 do
  begin
    GlobalDM.TFMessageCompnent.PostMessage(TFMessageList.Items[i]);
  end;
end;
procedure PostPlanMessage(TFMessage: TTFMessage);overload;
begin
  GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
end;

//把机车计划填充到消息结构体里面
procedure FillMessageWithPlan(TFMessage: TTFMessage;Plan: RRsTrainPlan);
begin
  TFMessage.StrField['GUID'] := Plan.strTrainPlanGUID;
  TFMessage.dtField['dtStartTime'] := Plan.dtStartTime;
  TFMessage.StrField['strTrainTypeName'] := Plan.strTrainTypeName;
  TFMessage.StrField['strTrainNumber'] := Plan.strTrainNumber;
  TFMessage.StrField['strTrainNo'] := Plan.strTrainNo;
  TFMessage.StrField['siteName'] := GlobalDM.SiteInfo.strSiteName;
  TFMessage.StrField['jiaoLuName'] := Plan.strTrainJiaoluName;
  TFMessage.StrField['jiaoLuGUID'] := Plan.strTrainJiaoluGUID;
end;

procedure TFrmTrainPlan.CreateNewPlan(var TrainPlan: RRsTrainPlan);
begin
  FillChar(TrainPlan,SizeOf(TrainPlan),0);

  if Length(m_PlaceList) > 0 then
  begin
    TrainPlan.strPlaceID :=   m_PlaceList[0].placeID ;
    TrainPlan.strPlaceName := m_PlaceList[0].placeName ;
  end;
  TrainPlan.strTrainPlanGUID := NewGUID;
  TrainPlan.strTrainTypeName := '';
  TrainPlan.strTrainNumber := '';
  TrainPlan.strTrainNo := '';
  TrainPlan.dtStartTime := strToDateTime('2000-01-01');
  TrainPlan.dtRealStartTime := strToDateTime('2000-01-01');
  TrainPlan.dtChuQinTime := strToDateTime('2000-01-01');
  TrainPlan.strTrainJiaoluGUID := m_TrainJl.strTrainJiaoluGUID;
  TrainPlan.strTrainJiaoluName := m_TrainJl.strTrainJiaoluName;
  TrainPlan.strStartStation := m_TrainJl.strStartStation;
  TrainPlan.strStartStationName := m_TrainJl.strStartStationName;
  TrainPlan.strEndStation := m_TrainJl.strEndStation;
  TrainPlan.strEndStationName := m_TrainJl.strEndStationName;

  TrainPlan.nTrainmanTypeID :=  ttNormal;
  TrainPlan.nPlanType := ptYunYong;
  TrainPlan.nDragType := pdtBenWu;
  TrainPlan.nKeHuoID := khKe;
  TrainPlan.nRemarkType := prtKuJie;
  TrainPlan.nPlanState := psEdit;
  TrainPlan.strPlanStateName := TRsPlanStateNameAry[TrainPlan.nPlanState];
  TrainPlan.nNeedRest := 0;
  TrainPlan.dtChuQinTime := 0;
  TrainPlan.dtArriveTime := 0;
  TrainPlan.dtCallTime := 0;
  

  TrainPlan.dtCreateTime := m_dtNow;

  TrainPlan.strCreateSiteGUID := GlobalDM.SiteInfo.strSiteGUID;

  TrainPlan.strCreateSiteName := GlobalDM.SiteInfo.strSiteName;

  TrainPlan.strCreateUserGUID := GlobalDM.DutyUser.strDutyGUID;

  TrainPlan.strCreateUserName := GlobalDM.DutyUser.strDutyName;
end;

procedure TFrmTrainPlan.SubmitAddPlan(Plan: RRsTrainPlan);
var
  receivePlan:RRsReceiveTrainPlan;
  strError:string;
begin
  receivePlan.TrainPlan := Plan ;
  receivePlan.strUserID := GlobalDM.DutyUser.strDutyGUID ;
  receivePlan.strUserName := GlobalDM.DutyUser.strDutyName ;
  receivePlan.strSiteID := GlobalDM.SiteInfo.strSiteGUID ;
  receivePlan.strSiteName := GlobalDM.SiteInfo.strSiteName ;

  if not m_webTrainPlan.AddTrainPlan(receivePlan,strError) then
  begin
    BoxErr(strError);
    Exit;
  end;
end;


procedure TFrmTrainPlan.InnerCancelPlan(PlanList: TStrings);
var
  i: integer;
  planGUID: string;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
  error : string;
  Plan: RRsTrainPlan;
begin
  TFMessageList := TTFMessageList.Create;
  try
    //检测是否需要添加消息
    for i := 0 to PlanList.Count - 1 do
    begin
      planGUID := PlanList[i];
      Plan.strTrainPlanGUID := planGUID;

      m_webTrainPlan.GetTrainPlanByID(planGUID,Plan);
  

      if Plan.nPlanState >= pssent then
      begin
        TFMessage := TTFMessage.Create;
        TFMessage.msg := TFM_PLAN_TRAIN_CANCEL;
        FillMessageWithPlan(TFMessage,Plan);
        TFMessageList.Add(TFMessage);
      end;

    end;

    if not m_webTrainPlan.CancelTrainPlan(PlanList, GlobalDM.DutyUser.strDutyGUID,1,error) then
    begin
      raise Exception.Create(error);
    end
    else
    begin
      if TFMessageList.Count > 0 then
      begin
        PostPlanMessage(TFMessageList);
      end;
    end;
  finally
    TFMessageList.Free;
  end;


end;

procedure TFrmTrainPlan.CancelPlan;
var
  planList: TStringList;
begin
  planList := TStringList.Create;
  try
    GetSelPlan(planList);
    if planList.Count = 0 then
    begin
      Box('没有要撤销的计划！');
      Exit;
    end;

    //检测计划能否删除
    if not TBox('您确认要撤销选中的计划信息吗？') then exit;

    try
      InnerCancelPlan(planList);
      
      Box('撤销计划成功！');

      RefreshPlan;
    except
      on e: exception do
      begin
        Box(PChar(Format('撤销计划失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    planList.Free;
  end;
end;

function TFrmTrainPlan.CopyPlan(PlanList: TStrings): Integer;
var
  i : Integer ;
  planid : string;
  plan: RRsTrainPlan;
  error: string;
  receivePlan:RRsReceiveTrainPlan;
begin

  Result := 0 ;
  for i := 0 to PlanList.Count - 1 do
  begin
    planid := PlanList[i];
    if planid = '' then continue;

    //检测是被能获取到
    if not m_webTrainPlan.GetTrainPlanByID(planid,plan) then
    begin
      Box('已有计划已被删除，请刷新后重试');
      Continue
    end;
    //检测是否能复制
    if plan.nPlanState <> psEdit then
    begin
      Box('只能复制处于编辑状态的计划！');
      Continue;
    end;


    plan.strTrainPlanGUID := NewGUID ;

    receivePlan.TrainPlan := plan ;
    receivePlan.strUserID := GlobalDM.DutyUser.strDutyGUID ;
    receivePlan.strUserName := GlobalDM.DutyUser.strDutyName ;
    receivePlan.strSiteID := GlobalDM.SiteInfo.strSiteGUID ;
    receivePlan.strSiteName := GlobalDM.SiteInfo.strSiteName ;
    if not m_webTrainPlan.AddTrainPlan(receivePlan,error) then
    begin
      Box(error);
    end;

    inc(result);
  end;
end;

function TFrmTrainPlan.DeletePlan(PlanList: TStrings): Integer;
var
  i : Integer ;
  planid : string;
  plan: RRsTrainPlan;
  error:string;
begin
  Result := 0 ;
  for i := 0 to PlanList.Count - 1 do
  begin
    planid := PlanList[i];
    if planid = '' then continue;

    //检测是被删除

    if not m_webTrainPlan.GetTrainPlanByID(planid,plan) then
    begin
      Box('已有计划已被删除，请刷新后重试');
      Continue
    end;
    //检测是否能删除
    if plan.nPlanState <> psEdit then
    begin
      Box('只能删除处于编辑状态的计划！');
      Continue;
    end;


    if not m_webTrainPlan.DeleteTrainPlan(planid,error) then
    begin
      BoxErr(error);
    end;
    inc(result);
  end;
end;


procedure TFrmTrainPlan.FormCreate(Sender: TObject);
begin
  TtfSkin.InitAdvGrid(PlanGrid);
  
  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_webTrainnos := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

   //记录strGrid的列宽
  PlanGrid.SelectionRectangleColor := clRed;
  PlanGrid.ColumnSize.Key := 'FormColWidths.ini';
  PlanGrid.ColumnSize.Section := 'TrainPlan';
  PlanGrid.ColumnSize.Save := false;
  PlanGrid.ColumnSize.Location := clIniFile;
  GlobalDM.SetGridColumnWidth(PlanGrid);
  GlobalDM.SetGridColumnVisible(PlanGrid);

  m_dtStartDate := GlobalDM.GetNow ;
  m_dtEndDate := m_dtStartDate + 2 ;

  m_dtNow := GlobalDM.GetNow;

  TWaiQin.Init();
end;

procedure TFrmTrainPlan.FormDestroy(Sender: TObject);
begin
  GlobalDM.SaveGridColumnWidth(PlanGrid);

  m_webTrainPlan.Free ;
  m_webDutyPlace.Free ;
  m_webTrainnos.Free ;
end;

procedure TFrmTrainPlan.GetAllPlan(PlanList: TStrings);
var
  i: integer;
  planid: string;
  plan: RRsTrainPlan;
begin
  for i := 0 to PlanGrid.RowCount - 1 do
  begin
    planid := PlanGrid.Cells[99, i];
    if planid = '' then
      continue;

    plan.strTrainPlanGUID := planid;

    if not m_webTrainPlan.GetTrainPlanByID(planid,plan) then
      continue;

    if plan.nPlanState <> psEdit then
      Continue;

    if plan.strTrainNo = '' then
      Continue;

    if plan.dtStartTime <= 36524 then
      Continue;

    planList.Add(planid);
  end;
end;



procedure TFrmTrainPlan.GetSelPlan(PlanList: TStrings);
var
  i : Integer;
  index :Integer ;
  planid : string;
begin
  for i := 0 to PlanGrid.SelectedRowCount - 1 do
  begin
    index := PlanGrid.SelectedRow[i];
    planid := PlanGrid.Cells[99, index];
    if planid = '' then
      continue;
    PlanList.Add(planid);
  end;
end;


procedure TFrmTrainPlan.GridRowToRest(nRow: Integer; var restInfo: RRsRest);
begin
  if restInfo.nNeedRest = 1 then
    restInfo.dtCallTime :=  StrToDateTime(PlanGrid.Cells[COL_JIAOBANSHIJIAN_INDEX,nRow] + ':00');
end;

procedure TFrmTrainPlan.GridRowToTrainPlan(nRow: Integer;
  var Plan: RRsTrainPlan);
var
  sValue: string;
begin
  Plan.strTrainTypeName :=
    PlanGrid.Cells[COL_TRAINTYPE_INDEX,nRow];
  Plan.strTrainNumber :=
    PlanGrid.Cells[COL_TRAINNO_INDEX,nRow];
  Plan.strTrainNo :=
    PlanGrid.Cells[COL_CHECI_INDEX,nRow];
  Plan.dtStartTime :=
    StrToDateTime(PlanGrid.Cells[COL_PLANKAICHETIME_INDEX,nRow] + ':00');
  Plan.dtRealStartTime :=
    StrToDateTime(PlanGrid.Cells[COL_REALKAICHETIME_INDEX,nRow]);

  Plan.strStartStation :=
    StationNameToGUID(PlanGrid.Cells[COL_STARTSTATION_INDEX,nRow],m_StationArray);
  Plan.strStartStationName :=
    PlanGrid.Cells[COL_STARTSTATION_INDEX,nRow];
  Plan.strEndStation :=
    StationNameToGUID(PlanGrid.Cells[COL_ENDSTATION_INDEX,nRow],m_StationArray);
  Plan.strEndStationName :=
    PlanGrid.Cells[COL_ENDSTATION_INDEX,nRow];
  Plan.nTrainmanTypeID :=
    TrianmanTypeNameToType(PlanGrid.Cells[COL_TRAINMANTYPE_INDEX,nRow]);
  Plan.nPlanType :=
    PlanTypeNameToType(PlanGrid.Cells[COL_PLANTYPE_INDEX,nRow]);
  Plan.nDragType :=
    DragTypeNameToType(PlanGrid.Cells[COL_DRAGSTATE_INDEX,nRow]);
  Plan.nKeHuoID :=
    KeHuoNameToType(PlanGrid.Cells[COL_KEHUO_INDEX,nRow]);
  Plan.nRemarkType :=
    PlanRemarkTypeNameToType(PlanGrid.Cells[COL_REMARKTYPE_INDEX,nRow]);

  Plan.strPlaceID:=
    DutyPlaceToGUID(PlanGrid.Cells[COL_DUTYPLACE_INDEX,nRow],m_PlaceList);

  Plan.strRemark := PlanGrid.Cells[COL_REMARK_INDEX, nRow];


  sValue := PlanGrid.Cells[COL_WAIQIN_INDEX,nRow];
  Plan.strWaiqinClientGUID := TWaiQin.GetID(sValue);
  Plan.strWaiQinClientNumber := TWaiQin.GetNumber(sValue);
  Plan.strWaiQinClientName := sValue;
end;



procedure TFrmTrainPlan.RefreshPlan;
  function FormatTime(value: TDateTime): string;
  begin
    if value > 1 then
      Result := FormatDateTime('yyyy-mm-dd hh:nn',value)
    else
      Result := '';
  end;
  procedure FillGridWithPlan(Plan: PPlan;nRow: Integer);
  begin
   with PlanGrid do
    begin
      Objects[0,nRow + 1] := TObject(Plan);
      Cells[COL_XUHAO_INDEX, nRow + 1] := IntToStr(nRow + 1);
      Cells[COL_STATE_INDEX, nRow + 1] := TRsPlanStateNameAry[Plan.TrainPlan.nPlanState];
      Cells[COL_TRAINJIAOLU_INDEX, nRow + 1] := Plan.TrainPlan.strTrainJiaoluName;
      Cells[COL_WAIQIN_INDEX, nRow + 1] := Plan.TrainPlan.strWaiQinClientName;

      Cells[COL_TRAINTYPE_INDEX, nRow + 1] :=  Plan.TrainPlan.strTrainTypeName;
      Cells[COL_TRAINNO_INDEX, nRow + 1] := Plan.TrainPlan.strTrainNumber;
      Cells[COL_CHECI_INDEX, nRow + 1] :=  Plan.TrainPlan.strTrainNo;
      Cells[COL_PLANKAICHETIME_INDEX, nRow + 1] := FormatTime(Plan.TrainPlan.dtStartTime);
      Cells[COL_REALKAICHETIME_INDEX, nRow + 1] := FormatTime(Plan.TrainPlan.dtRealStartTime);
      Cells[COL_BEGINWORKTIME_INDEX, nRow + 1] := FormatTime(Plan.TrainPlan.dtChuQinTime);
      Cells[COL_REAL_BEGINWORKTIME_INDEX,nRow + 1] := FormatTime(Plan.TrainPlan.dtRealBeginWorkTime);
      Cells[COL_STARTSTATION_INDEX, nRow + 1] := Plan.TrainPlan.strStartStationName;
      Cells[COL_ENDSTATION_INDEX, nRow + 1] := Plan.TrainPlan.strEndStationName;
      Cells[COL_TRAINMANTYPE_INDEX, nRow + 1] := TRsTrainmanTypeName[Plan.TrainPlan.nTrainmanTypeID];
      Cells[COL_PLANTYPE_INDEX, nRow + 1] := TRsPlanTypeName[Plan.TrainPlan.nPlanType];
      Cells[COL_DRAGSTATE_INDEX, nRow + 1] := TRsDragTypeName[Plan.TrainPlan.nDragType];
      Cells[COL_KEHUO_INDEX, nRow + 1] := TRsKeHuoNameArray[Plan.TrainPlan.nKeHuoID];
      Cells[COL_REMARKTYPE_INDEX, nRow + 1] := TRsPlanRemarkTypeName[Plan.TrainPlan.nRemarkType];
      Cells[COL_REMARK_INDEX, nRow + 1] := Plan.TrainPlan.strRemark;
      Cells[COL_TRAINMAN_INDEX, nRow + 1] := GetTrainmanText(Plan.Group.Trainman1);
      Cells[COL_SUBTRAINMAN_INDEX, nRow + 1] := GetTrainmanText(Plan.Group.Trainman2);
      Cells[COL_XUEYUAN_INDEX, nRow + 1] := GetTrainmanText(Plan.Group.Trainman3);
      Cells[COL_XUEYUAN2_INDEX, nRow + 1] := GetTrainmanText(Plan.Group.Trainman4);
      Cells[COL_DUTYPLACE_INDEX,nRow + 1] :=  Plan.TrainPlan.strPlaceName ;
      if Plan.TrainPlan.nNeedRest = 1 then
      begin
        Cells[COL_HOUBAN_INDEX,nRow + 1] := '候班';
        Cells[COL_HOUBANSHIJIAN_INDEX,nRow + 1] := FormatTime(Plan.TrainPlan.dtArriveTime);
        Cells[COL_JIAOBANSHIJIAN_INDEX,nRow + 1] := FormatTime(Plan.TrainPlan.dtCallTime);
      end;

      Cells[COL_SendPlan_Index,nRow + 1] :=  FormatTime(Plan.TrainPlan.dtSendPlanTime);
      Cells[COL_RecPlan_INDEX,nRow + 1] :=  FormatTime(Plan.TrainPlan.dtRecvPlanTime);
      Cells[99, nRow + 1] := Plan.TrainPlan.strTrainPlanGUID;
    end;
  end;
var
  jlID:string;
  error:string;
  i : integer;
  planArray : TRsTrainmanPlanArray;
begin
  TfrmHint.ShowHint('正在加载计划,请稍等...');
  try
    jlID := m_TrainJl.strTrainJiaoluGUID ;
    if jlID = '' then
    begin
      Box('行车区段为空');
      exit;
    end;
    
    try
      if not m_webTrainPlan.GetTrainmanPlanByJiaoLu(jlID,m_dtStartDate,m_dtEndDate,planArray,error) then
      begin
        BoxErr(error);
        Exit;
      end;

      m_PlanArray := planArray;
      PlanGrid.BeginUpdate;
      try
        with PlanGrid do
        begin
          ClearRows(FixedRows, RowCount);

          if length(planArray) > 0 then
            RowCount := length(planArray) + 1
          else begin
            RowCount := FixedRows + 1;
            Cells[99,1] := ''
          end;

          for i := 0 to length(planArray) - 1 do
          begin
            FillGridWithPlan(PPlan(@planArray[i]), i);
          end;
        end;
      finally
        PlanGrid.EndUpdate;
      end;

      PlanGrid.Repaint();
    except on e: exception do
      begin
        Box('获取计划信息失败：' + e.Message);
      end;
    end;
  finally
    TfrmHint.CloseHint;
  end;

end;

procedure TFrmTrainPlan.InsertPlan;
var
  jlID : string;
  Plan: RRsTrainPlan;
begin
  jlID := m_TrainJl.strTrainJiaoluGUID ;
  if jlID = '' then
  begin
    BoxErr('行车区段为空');
    Exit ;
  end;

  if Length(m_PlaceList) = 0 then
  begin
    BoxErr('没有出勤点');
    Exit ;
  end;

  CreateNewPlan(Plan);
  
  SubmitAddPlan(Plan);
  
  RefreshPlan;
end;

procedure TFrmTrainPlan.LoadPlan;
var
  btime, etime: TDateTime;
  msg: string;
  jlid : string;
  error:string;
begin

  jlid  := m_TrainJl.strTrainJiaoluGUID ;


  if not TFrmDayPlanTimeRange.GetTimeRange(btime,etime) then
    Exit;

  msg := '确定要从图定车次表中加载并成%s到%s的计划吗?';
  msg := Format(msg, [FormatDateTime('yyyy-MM-dd hh:nn', btime), FormatDateTime('yyyy-MM-dd hh:nn', etime)]);


  //检查是否已经导入计划车型车号

  if Application.MessageBox(PChar(msg), '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  try
  
    if not m_webTrainnos.Load(jlid,btime,etime,1,error) then
    begin
      BoxErr(error);
      Exit ;
    end;

    RefreshPlan;
  except on e: exception do
    begin
      Box(Format('从图定车次表中加载计划错误：%s', [e.Message]));
    end;
  end;
end;

procedure TFrmTrainPlan.miClearTrainmanPlanClick(Sender: TObject);
var
  nSucceedCount: integer;
  planList : TStringList;
begin
  planList := TStringList.Create;
  try
    //获取要删除的数据
    GetSelPlan(planList);
    //检查是否没有选中一个
    if planList.Count = 0 then
    begin
      Application.MessageBox('没有要复制的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    if Application.MessageBox('您确定要复制此机车计划吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
    try
      nSucceedCount := CopyPlan(planList);
      Application.MessageBox(PChar(Format('成功复制%d条计划，失败%d条！',
        [nSucceedCount, planList.Count - nSucceedCount])), '提示', MB_OK + MB_ICONINFORMATION);
      RefreshPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('复制失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    FreeAndNil(planList);
  end;
end;

procedure TFrmTrainPlan.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(PlanGrid,'TrainPlan');
end;

procedure TFrmTrainPlan.ModifyPlan(PlanID:string;nRow, nCol: Integer);
var
  TFMessage: TTFMessage;
  sourcePlan : RRsTrainPlan;
  receivePlan:RRsReceiveTrainPlan;
  error:string;
  JsonObjectArray:TJsonObjectArray ;
  sValue:string;
begin
  receivePlan.TrainPlan.strTrainPlanGUID := PlanID ;
  receivePlan.strUserID := GlobalDM.DutyUser.strDutyGUID ;
  receivePlan.strUserName := GlobalDM.DutyUser.strDutyName ;
  receivePlan.strSiteID := GlobalDM.SiteInfo.strSiteGUID ;
  receivePlan.strSiteName := GlobalDM.SiteInfo.strSiteName ;

  
  if nCol = COL_BEGINWORKTIME_INDEX then
  begin
    SetLength(JsonObjectArray,2);
    JsonObjectArray[0].strName := GetCloumnName(COL_BEGINWORKTIME_INDEX);
    JsonObjectArray[0].strValue := PlanGrid.Cells[COL_BEGINWORKTIME_INDEX,nRow];

    JsonObjectArray[1].strName := GetCloumnName(COL_PLANKAICHETIME_INDEX);
    JsonObjectArray[1].strValue := PlanGrid.Cells[COL_PLANKAICHETIME_INDEX,nRow];
  end
  else if nCol = COL_CHECI_INDEX then
  begin
    SetLength(JsonObjectArray,2);
    JsonObjectArray[0].strName := GetCloumnName(COL_CHECI_INDEX);
    JsonObjectArray[0].strValue := PlanGrid.Cells[COL_CHECI_INDEX,nRow];

    JsonObjectArray[1].strName := GetCloumnName(COL_KEHUO_INDEX);
    JsonObjectArray[1].strValue := IntToStr( Ord (KeHuoNameToType ( PlanGrid.Cells[COL_KEHUO_INDEX,nRow] ) ) );
  end else if nCol = COL_WAIQIN_INDEX then
  begin
    SetLength(JsonObjectArray,3);
    sValue := PlanGrid.Cells[COL_WAIQIN_INDEX,nRow];

    JsonObjectArray[0].strName := 'waiqinID';
    JsonObjectArray[0].strValue := TWaiQin.GetID(sValue);

    JsonObjectArray[1].strName := 'waiqinNumber';
    JsonObjectArray[1].strValue := TWaiQin.GetNumber(sValue);
    
    JsonObjectArray[2].strName := 'waiqinName';
    JsonObjectArray[2].strValue := sValue;
  end
  else
  begin
    SetLength(JsonObjectArray,1);
    JsonObjectArray[0].strName := GetCloumnName(nCol);
    case nCol   of
      COL_REMARKTYPE_INDEX :  sValue := inttostr( Ord ( PlanRemarkTypeNameToType (PlanGrid.Cells[nCol,nRow]) ) );
      COL_DUTYPLACE_INDEX  :  sValue := GetDutyPlacIDFromName(m_PlaceList,PlanGrid.Cells[nCol,nRow]);
      COL_STARTSTATION_INDEX : sValue := GetStationIDFromName(m_StationArray,PlanGrid.Cells[nCol,nRow]);
      COL_ENDSTATION_INDEX : sValue := GetStationIDFromName(m_StationArray,PlanGrid.Cells[nCol,nRow]);
      COL_TRAINMANTYPE_INDEX : sValue := inttostr( Ord (TrianmanTypeNameToType (PlanGrid.Cells[nCol,nRow] ) ));
      COL_PLANTYPE_INDEX : sValue := inttostr( Ord (PlanTypeNameToType (PlanGrid.Cells[nCol,nRow] ) ));
      COL_DRAGSTATE_INDEX : sValue := inttostr( Ord ( DragTypeNameToType (PlanGrid.Cells[nCol,nRow] ) ));
      COL_KEHUO_INDEX : sValue := inttostr( Ord ( KeHuoNameToType (PlanGrid.Cells[nCol,nRow] ) ));
    else
      sValue := PlanGrid.Cells[nCol,nRow]  ;
    end;
    JsonObjectArray[0].strValue := sValue ;
  end;
  


  TFMessage := TTFMessage.Create;
  try
    //此处不允许调度室修改值乘类型
    if not m_webTrainPlan.GetTrainPlanByID(PlanID,sourcePlan) then
    begin
      BoxErr(error);
      Exit;
    end;
    receivePlan.TrainPlan := sourcePlan ;

    if not m_webTrainPlan.UpdateTrainPlan(receivePlan,JsonObjectArray,error) then
    begin
      BoxErr(error);
      exit ;
    end;
      
    if sourcePlan.nPlanState >= psSent then
    begin
      TFMessage.msg := TFM_PLAN_TRAIN_UPDATE;
      FillMessageWithPlan(TFMessage,sourcePlan);
      PostPlanMessage(TFMessage);
    end;

  finally
    TFMessage.Free;
  end;
end;

procedure TFrmTrainPlan.NextFocus;
var
  selectCol : integer;
begin
  selectCol := PlanGrid.RealColIndex(PlanGrid.Col);
  if selectCol < COL_PLANKAICHETIME_INDEX then
    PlanGrid.Col := PlanGrid.Col + 1
  else
  if selectCol = COL_PLANKAICHETIME_INDEX then
  begin
    if PlanGrid.Row < PlanGrid.RowCount - 1 then
      PlanGrid.Row := PlanGrid.Row + 0;
    PlanGrid.Col := PlanGrid.DisplColIndex(COL_TRAINNO_INDEX);
  end;
end;

procedure TFrmTrainPlan.RemovePlan;
var
  nSucceedCount: integer;
  planList : TStringList;
begin
  planList := TStringList.Create;
  try
    GetSelPlan(planList);
    
    if planList.Count = 0 then
    begin
      Application.MessageBox('没有要删除的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    if not TBox('您确定要删除此机车计划吗？') then Exit; 


    nSucceedCount := DeletePlan(planList);
    Box(Format('成功删除%d条计划，失败%d条！',[nSucceedCount, planList.Count - nSucceedCount]));
    RefreshPlan;
  finally
    FreeAndNil(planList);
  end;
end;

procedure TFrmTrainPlan.SendPlan;
var
  planList: TStringList;
begin
  //获取选中计划的GUID，并判断选中的计划是否符合要求
  planList := TStringList.Create;
  try
    GetAllPlan(planList);
    
    if planList.Count = 0 then
    begin
      Application.MessageBox('没有要下发的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    
    if not TBox('您确认要下发计划信息吗？') then exit;
    try
      SendPlanInner(planList);
      Box('下发计划成功！'); 
      //刷新计划显示
      RefreshPlan;
    except on e: exception do
      begin
        Box(PChar(Format('下发计划失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    planList.Free;
  end;
end;

procedure TFrmTrainPlan.SendPlanInner(PlanList: TStrings);
var
  i: integer;
  planid: string;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
  error:string;
  TrainPlan: RRsTrainPlan;
begin
  TFMessageList := TTFMessageList.Create;
  try
    //检测是否需要添加消息
    for i := 0 to PlanList.Count - 1 do
    begin
      planid := PlanList[i];

      trainPlan.strTrainPlanGUID := planid;

      if not m_webTrainPlan.GetTrainPlanByID(planid,TrainPlan) then
      begin
        Continue;
      end;

      TFMessage := TTFMessage.Create;
      TFMessage.msg := TFM_PLAN_TRAIN_PUBLISH;
      FillMessageWithPlan(TFMessage,trainPlan);
      TFMessageList.Add(TFMessage);
    end;

    if not m_webTrainPlan.SendTrainPlan(PlanList, GlobalDM.DutyUser.strDutyGUID,error) then
    begin
      Raise Exception.Create(error);
    end
    else
    begin
      if TFMessageList.Count > 0 then
        PostPlanMessage(TFMessageList);
    end;  
  finally
    TFMessageList.Free;
  end;
end;

procedure TFrmTrainPlan.SetTrainJiaoLu(TrainJiaolu: RRsTrainJiaolu);
var
  jlid : string ;
  error:string ;
begin
  m_TrainJl := TrainJiaolu ;

  jlid := TrainJiaolu.strTrainJiaoluGUID ;

  SetLength(m_StationArray,0);
  if not RsLCBaseDict.LCStation.GetStationsOfJiaoJu(jlid,m_StationArray,error) then
  begin
    BoxErr('获取车站错误: '+ error);
    exit ;
  end;

  SetLength(m_PlaceList,0);
  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(jlid,m_PlaceList,error) then
  begin
    BoxErr('获取出勤点错误: '+ error);
    exit ;
  end;
end;

procedure TFrmTrainPlan.PlanGridCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if (Length(m_PlanArray) = 0) or (ARow = 0) then
    Exit;

  if Integer(m_PlanArray[ARow - 1].
      TrainPlan.nPlanState) >= Integer(psEndWork) then
  begin
    Exit;
  end;
  CanEdit :=
    (ACol = COL_TRAINNO_INDEX) OR
    (ACol = COL_TRAINTYPE_INDEX) OR
    (ACol = COL_CHECI_INDEX) OR
    (ACol = COL_WAIQIN_INDEX) OR
    (ACol = COL_PLANKAICHETIME_INDEX) OR
    (ACol = COL_STARTSTATION_INDEX) OR
    (ACol = COL_ENDSTATION_INDEX) OR
    (ACol = COL_PLANTYPE_INDEX) OR
    (ACol = COL_DRAGSTATE_INDEX) OR
    (ACol = COL_REMARKTYPE_INDEX) OR
    (ACol = COL_REMARK_INDEX) OR
    (ACol = COL_KEHUO_INDEX) or
    (ACol = COL_DUTYPLACE_INDEX) or
    (ACol = COL_BEGINWORKTIME_INDEX );
end;

procedure TFrmTrainPlan.PlanGridCellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: string; var Valid: Boolean);
var
  strTime: string;
  dtTime: TDateTime;
begin
  if (Length(m_PlanArray) = 0)  then Exit;

  if (ACol = COL_TRAINNO_INDEX) then
  begin
    Value := FormatTrainNumber(Value);
  end;
  
  //验证开车时间和实际开车时间
  if (ACol = COL_PLANKAICHETIME_INDEX) or (ACOL = COL_REALKAICHETIME_INDEX) then
  begin
    strTime := Value;
    try
      dtTime := strDecodeTime(strTime,m_dtNow);
    except
      on E: exception do
      begin
        Valid := False;
        Exit;
      end;
    end;

    Value := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    PlanGrid.Cells[ACol,ARow]  := Value;
    if ACol = COL_PLANKAICHETIME_INDEX then
    begin
      PlanGrid.Cells[COL_REALKAICHETIME_INDEX,PlanGrid.Row]
       := Value;
    end;
  end;


  //根据开车时间计算出勤时间
  if ( ACol = COL_BEGINWORKTIME_INDEX) then
  begin
    strTime := Value;
    try
      dtTime := strDecodeTime(strTime,m_dtNow);
    except
      on E: exception do
      begin
        Valid := False;
        Exit;
      end;
    end;

    Value := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    PlanGrid.Cells[ACol,ARow]  := Value;

  end;

  //验证车次和车型
  if (ACol = COL_CHECI_INDEX) or (ACol = COL_TRAINTYPE_INDEX) then
  begin
    Value := UpperCase(Value);
  end;
  m_bModifyed := True;
  m_nSelectCol := ACol ;
end;

procedure TFrmTrainPlan.PlanGridCustomCellBkgDraw(Sender: TObject;
  Canvas: TCanvas; ACol, ARow: Integer; AState: TGridDrawState; ARect: TRect;
  Printing: Boolean);
begin
  if (ACol = 0) and (ARow > PlanGrid.FixedRows - 1) and (PlanGrid.Objects[0,ARow] <> nil) then
  begin

    if not Assigned(m_CheckJDPlanCallback) then Exit;

    if m_CheckJDPlanCallback(PPlan(PlanGrid.Objects[0,ARow]).TrainPlan.strTrainPlanGUID) then
    begin
      OffsetRect(ARect,-3,3);
      ARect.Left := ARect.Right - 10;
      ARect.Bottom := ARect.Bottom - 6;
      Canvas.Brush.Color := $005A8DDA;
      Canvas.FillRect(ARect);
    end;
  end;
end;

procedure TFrmTrainPlan.PlanGridEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  nMinute,nRealCol,nMinuteCall:Integer ;
  nRemarkType:Integer;
  placeid:string;
  dtTime : TDateTime ;
  sValue:string;
  nKehuo : integer;
begin
  if m_nSelectCol <= 0  then
  begin
   m_nSelectCol := ACol ;
  end;
  nRealCol := m_nSelectCol ;

  if nRealCol = COL_CHECI_INDEX then
  begin

    sValue := RsLCBaseDict.LCTrainType.GetKehuoByCheCi(PlanGrid.Cells[PlanGrid.RealColIndex(ACol),ARow]);
    if not TryStrToInt(sValue,nKehuo) then
    begin
      nKehuo := 1;
    end;
    PlanGrid.Cells[(COL_KEHUO_INDEX),ARow] := TRsKeHuoNameArray[TRsKehuo(nKehuo)];
    UpdatePlan(ARow,COL_CHECI_INDEX);
    RefreshPlan;
  end;



  if nRealCol = COL_REMARKTYPE_INDEX then
  begin
    ;
  end;
  

  if not m_bModifyed then exit;
  if ( nRealCol = COL_BEGINWORKTIME_INDEX )  then
  begin
    sValue := PlanGrid.Cells[COL_BEGINWORKTIME_INDEX,ARow] + ':00' ;
    dtTime :=  StrToDateTime(sValue);

    nRemarkType := Integer ( m_PlanArray[ARow -1 ].TrainPlan.nRemarkType );
    placeid := m_PlanArray[ARow -1 ].TrainPlan.strPlaceID;

    nMinute := 60 ;
    case nRemarkType of
      //库接 90分钟
      1 : nMinute := 90;
      //站接
      2 : nMinute := 60;
    end;

    //计算间隔
    RsLCBaseDict.LCWorkPlan.GetPlanTimes(nRemarkType,placeid,nMinute) ;
    dtTime := IncMinute(dtTime,-nMinute)  ;
    sValue := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    PlanGrid.Cells[COL_PLANKAICHETIME_INDEX,ARow]  := sValue;


    if m_PlanArray[ARow -1 ].RestInfo.nNeedRest = 1 then
    begin
      nMinuteCall := 0;
      dtTime := IncMinute(dtTime,-nMinuteCall)  ;
      sValue := FormatDateTime('yy-MM-dd hh:nn',dtTime);
      PlanGrid.Cells[COL_JIAOBANSHIJIAN_INDEX,ARow]  := sValue;
    end;
  end;

  UpdatePlan(ARow,nRealCol);
  m_bModifyed := False;

  if nRealCol = COL_PLANKAICHETIME_INDEX then
  begin
    RefreshPlan;
  end else begin
    RefreshPlan;
  end;
end;

procedure TFrmTrainPlan.PlanGridGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  if ACol = 0 then
    HAlign := taLeftJustify
  else
    HAlign := taCenter;
end;

procedure TFrmTrainPlan.PlanGridGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = 1 then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if PlanGrid.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;
  end;
end;

procedure TFrmTrainPlan.PlanGridGetEditorType(Sender: TObject; ACol,
  ARow: Integer; var AEditor: TEditorType);
var
  i: Integer;
  strText: string;
begin
  case ACol of
    COL_STARTSTATION_INDEX, COL_ENDSTATION_INDEX :
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for I := 0 to Length(m_StationArray) - 1 do
      begin
        TAdvStringGrid(Sender).AddComboString(m_StationArray[i].strStationName);
      end;
    end;
    COL_WAIQIN_INDEX:
    begin
      AEditor := edComboList;
      TWaiQin.FillCombString(TAdvStringGrid(Sender));
    end;
    COL_KEHUO_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for strText in TRsKeHuoName do
      begin
        TAdvStringGrid(Sender).AddComboString(strText);
      end;    
    end;

    COL_TRAINMANTYPE_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for strText in TRsTrainmanTypeName do
      begin
        TAdvStringGrid(Sender).AddComboString(strText);
      end;    
    end;

    COL_PLANTYPE_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for strText in TRsPlanTypeName do
      begin
        TAdvStringGrid(Sender).AddComboString(strText);
      end;
    end;
    COL_DRAGSTATE_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for strText in TRsDragTypeName do
      begin
        TAdvStringGrid(Sender).AddComboString(strText);
      end;
    end;
    COL_REMARKTYPE_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for strText in TRsPlanRemarkTypeName do
      begin
        TAdvStringGrid(Sender).AddComboString(strText);
      end;
    end;
    COL_DUTYPLACE_INDEX:
    begin
      AEditor := edComboList;
      TAdvStringGrid(Sender).ClearComboString;
      for i := 0 to Length(m_PlaceList) - 1  do
      begin
        TAdvStringGrid(Sender).AddComboString(m_PlaceList[i].placeName);
      end;
    end;
  end;
end;

procedure TFrmTrainPlan.PlanGridKeyPress(Sender: TObject;
  var Key: Char);
var
  selectCol : integer;
begin
  selectCol := PlanGrid.RealColIndex(PlanGrid.Col);
  if (selectCol = COL_PLANKAICHETIME_INDEX) or
     (selectCol = COL_REALKAICHETIME_INDEX) or
      (selectCol = COL_BEGINWORKTIME_INDEX )
  then
  begin
     if not (Key in ['0'..'9',#8,#13]) then
      Key := #0;
  end;
  
  if Key = #13 then
  begin
    NextFocus();
    if NOT((selectCol = COL_TRAINMAN_INDEX) OR
      (selectCol = COL_SubTRAINMAN_INDEX) OR
      (selectCol = COL_XUEYUAN_INDEX) OR
      (selectCol = COL_XUEYUAN2_INDEX)) then
    BEGIN
      Key := #0;
    END;
  end;
end;

procedure TFrmTrainPlan.PlanGridMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col,row : integer;
  pt : TPoint;
begin
  if Button = mbRight then
  begin
    PlanGrid.MouseToCell(X,Y,col,row);
    if Row = 0 then
    begin
      pt := Point(X,Y);
      pt := PlanGrid.ClientToScreen(pt);
      pMenuColumn.Popup(pt.X,pt.y);
    end
    else
    begin
      if (PlanGrid.Row > 0)  and (Length(m_PlanArray) > 0)then
      begin
        pt := Point(X,Y);
        pt := PlanGrid.ClientToScreen(pt);
        PopupMenu.Popup(pt.X,pt.Y);
      end;
    end;
  end;
end;

procedure TFrmTrainPlan.UpdatePlan(nRow,nCol: Integer);
begin
  if nRow > PlanGrid.RowCount - 1 then
    Exit;

  GridRowToTrainPlan(nRow,m_PlanArray[nRow - 1].TrainPlan);
  GridRowToRest(nRow,m_PlanArray[nRow -1].RestInfo);

  ModifyPlan(m_PlanArray[nRow - 1].TrainPlan.strTrainPlanGUID,nRow,nCol);
end;



{ TWaiQin }

class procedure TWaiQin.FillCombString(Grid: TAdvStringGrid);
var
  I: Integer;
begin
  Grid.ClearComboString();
  for I := 0 to Length(_SiteArray) - 1 do
  begin
    Grid.AddComboString(_SiteArray[i].strSiteName);
  end;
end;

class function TWaiQin.FindSite(name: string): PSiteInfo;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Length(_SiteArray) - 1 do
  begin
    if _SiteArray[i].strSiteName = name then
    begin
      Result := PSiteInfo(@_SiteArray[i]);
    end;
  end;
end;

class function TWaiQin.GetID(name: string): string;
var
  SiteInfo: PSiteInfo;
begin
  SiteInfo := FindSite(name);
  if SiteInfo = nil then
    Result := ''
  else
    Result := SiteInfo.strSiteGUID;
end;

class function TWaiQin.GetNumber(name: string): string;
var
  SiteInfo: PSiteInfo;
begin
  SiteInfo := FindSite(name);
  if SiteInfo = nil then
    Result := ''
  else
    Result := SiteInfo.strSiteNumber;
end;

class procedure TWaiQin.Init;
begin
  RsLCBaseDict.LCSite.GetSites(_SiteArray) ;
end;

end.
