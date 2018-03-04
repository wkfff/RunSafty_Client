unit uFrmMain_JiDiao;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, Menus, ToolWin, ComCtrls, ExtCtrls,
  RzPanel, StdCtrls, RzTabs, Buttons, PngCustomButton, RzStatus, RzCmboBx, RzDTP,
  pngimage, PngSpeedButton, RzSplit, RzButton, RzLabel,uStation,uDBStation,
  RzRadChk, uTrainPlan, uSite, uTrainJiaolu, RzListVw, uLine,uDBTrainJiaolu,uTrainman,
  uTFSystem,uDBTrainPlan, ActnList,uSaftyEnum,uRSCommonFunctions,uTFMessageDefine,
  uRunSaftyMessageDefine, AdvDateTimePicker,uFrmSelectColumn,uStrGridUtils,
  AdvListV,ufrmConfig,uTrainnos,uLCTrainnos,uDutyPlace,uLCDutyPlace,uLCTrainPlan,
  uLCBaseDict;
const
  COL_XUHAO_INDEX = 0;
  COL_STATE_INDEX = 1;
  COL_TRAINJIAOLU_INDEX = 2;
  COL_TRAINTYPE_INDEX = 3;
  COL_TRAINNO_INDEX = 4;
  COL_CHECI_INDEX = 5;
  COL_REMARKTYPE_INDEX = 7;
  COL_REMARK_INDEX = 6;


  COL_DUTYPLACE_INDEX = 8 ;

  COL_BEGINWORKTIME_INDEX = 9;
  COL_REALKAICHETIME_INDEX = 10;
  COL_PLANKAICHETIME_INDEX = 11;

  COL_TRAINMAN_INDEX = 12;
  COL_SUBTRAINMAN_INDEX = 13;
  COL_XUEYUAN_INDEX = 14;
  COL_XUEYUAN2_INDEX = 15;

  COL_STARTSTATION_INDEX = 16;
  COL_ENDSTATION_INDEX = 17;
  COL_TRAINMANTYPE_INDEX = 18;
  COL_PLANTYPE_INDEX = 19;
  COL_DRAGSTATE_INDEX = 20;
  COL_KEHUO_INDEX = 21;


type
  TfrmMain_JiDiao = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    PngCustomButton3: TPngCustomButton;
    mSet: TMenuItem;
    N3: TMenuItem;
    N6: TMenuItem;
    Panel1: TPanel;
    RzStatusBar1: TRzStatusBar;
    statusPanelDBState: TRzStatusPane;
    Panel2: TPanel;
    Panel3: TPanel;
    lbl_State_DB: TLabel;
    rzpnlDataView: TRzPanel;
    rzpnl1: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    rzpnl2: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    mmExit: TMenuItem;
    btnExchangeModule: TPngSpeedButton;
    N7: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    miModifyPassword: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N36: TMenuItem;
    N37: TMenuItem;
    ActionList1: TActionList;
    Action1: TAction;
    statusSysTime: TRzGlyphStatus;
    btnRefreshPaln: TPngSpeedButton;
    tmrRefreshTime: TTimer;
    pnlLogSend: TRzPanel;
    Label4: TLabel;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    lstviewMsg: TAdvListView;
    dtpPlanStartDate: TRzDateTimePicker;
    dtpPlanStartTime: TRzDateTimePicker;
    PopupMenu: TPopupMenu;
    N2: TMenuItem;
    statusAppVersion: TRzGlyphStatus;
    statusMessage: TRzStatusPane;
    statusUpdate: TRzStatusPane;
    TimerCheckUpdate: TTimer;
    btnLoadPlan: TPngSpeedButton;
    btnAddPlan: TPngSpeedButton;
    btnSendPlan: TPngSpeedButton;
    btnDeletePlan: TPngSpeedButton;
    btnCancelPlan: TPngSpeedButton;
    mniN5: TMenuItem;
    mniN6: TMenuItem;
    procedure btnLoadPlanClick(Sender: TObject);
    procedure btnAddPlanClick(Sender: TObject);
    procedure btnDeletePlanClick(Sender: TObject);
    procedure btnSendPlanClick(Sender: TObject);
    procedure btnCancelPlanClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure rzchckbxChuQinClick(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure miModifyPasswordClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure FormClick(Sender: TObject);
    procedure strGridTrainPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure strGridTrainPlanCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure strGridTrainPlanEditCellDone(Sender: TObject; ACol,
      ARow: Integer);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure tmrRefreshTimeTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure strGridTrainPlanGetEditorType(Sender: TObject; ACol,
      ARow: Integer; var AEditor: TEditorType);
    procedure strGridTrainPlanKeyPress(Sender: TObject; var Key: Char);
    procedure tabTrainJiaoluChange(Sender: TObject);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure miSelectColumnClick(Sender: TObject);
    procedure strGridTrainPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure PopupMenuPopup(Sender: TObject);
    procedure miExportPlanToXlsClick(Sender: TObject);
    procedure TimerCheckUpdateTimer(Sender: TObject);
    procedure N35Click(Sender: TObject);
  private
    //行车区段数据库操作
    m_DBTrainJiaolu : TRsDBTrainJiaolu;
    //机车计划数据库操作累
    m_DBTrainPlan : TRsDBTrainPlan;
    //行车区段数组
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //机车计划信息
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    //出勤点
    m_dutyPlaceList:TRsDutyPlaceList;
     //车站列表
    m_StationArray: TRsStationArray;
    m_dtNow: TDateTime;
    m_bModifyed: Boolean;
    //图定车次
    m_webTrainnos : TRsLCTrainnos;
    //人员计划
    m_webTrainPlan : TRsLCTrainPlan ;
    //出勤点
    m_webDutyPlace:TRsLCDutyPlace ;
  private
    { Private declarations }
    //初始化数据
    procedure InitData;
    //初始化行车区段信息
    procedure InitTrainJiaolus;
    //初始化机车计划数据
    procedure InitTrainPlan();
    //初始化交路车站
    procedure InitStations();
    //清空列表框的日志消息
    procedure InitSendLog();

    //数据库已连接
    procedure DBConnected(Sender : TObject);
    //数据库已断开
    procedure DBDisconnected(Sender : TObject);
    //更新状态栏应用程序的最新版本信息
    procedure OnAppVersionChange(Sender: TObject);

    //获取所有计划
    procedure GetAllPlan(PlanList:TStrings);
    //获取选中计划
    procedure GetSelPlan(PlanList:TStrings);
    //创建一个新的机车计划，内容为空,后续通过GRID填充
    procedure AddNewPlan(var TrainPlan: RRsTrainPlan);
  //机车计划添加到数据库
    procedure AddPlan(Plan: RRsTrainPlan);
    //更新机车计划，同时发送更新消息
    procedure UpdatePlan(Plan: RRsTrainPlan);overload;
    procedure UpdatePlan(nRow: Integer); overload;
    //删除机车计划  ,返回值为成功的条数 ,参数为要删的列表
    function  DeletePlan(PlanList:TStrings):Integer;
    //下发计划
    function  SendPlan(PlanList:TStrings):Boolean;
    //撤销计划
    function  CancelPlan(PlanList:TStrings):Boolean;


    //根据指定的行号，吧GRID转成一个机车计划结构体
    procedure GridRowToTrainPlan(nRow: Integer; var Plan: RRsTrainPlan);overload;
    //把一个指定机车计划结构体添加到指定的GRID行里面
    procedure AddRTrainmanPlanToControl(TrainmanPlan: RRsTrainmanPlan;
        nRow: Integer);
    //grid操作
    procedure NextFocus();

    //投递消息
    procedure PostPlanMessage(TFMessageList: TTFMessageList);overload;
    procedure PostPlanMessage(TFMessage: TTFMessage);overload;
    
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //把机车计划填充到消息结构体里面
    procedure FillMessageWithPlan(TFMessage: TTFMessage;Plan: RRsTrainPlan);


    {公共函数区}
    //对参数不够(4)长度的前面补充0，缺几个补充几个
    function FormatTrainNumber(TrainNumber: string): string;
    //获取选中的行车区段信息
    function GetSelectedTrainJiaolu(out TrainJiaoluGUID : string):boolean;

    //菜单点击
    procedure JiaoLuChangeMenuClick(Sender: TObject);
  public
    //进入机调界面
    class procedure EnterJiDiao;
    //离开机掉界面
    class procedure LeaveJiDiao;
  end;

var
  frmMain_JiDiao: TfrmMain_JiDiao;

implementation
uses
  uGlobalDM, ADODB, DateUtils, DB, uFrmTrainNo,
  {uFrmTrainPlanUpdate,}  uDBLine,
  uRunSaftyDefine,uDBSite, uFrmSetStringGridCol,uFrmExchangeModule,
  ufrmModifyPassWord,uFrmLogin,uFrmTrainmanManage, ufrmTimeRange,
  ufrmTrainplanExport;
{$R *.dfm}

procedure TfrmMain_JiDiao.AddNewPlan(var TrainPlan: RRsTrainPlan);
begin
  TrainPlan.strTrainPlanGUID := NewGUID;
  TrainPlan.strTrainTypeName := '';
  TrainPlan.strTrainNumber := '';
  TrainPlan.strTrainNo := '';
  TrainPlan.dtStartTime := strToDateTime('2000-01-01');
  TrainPlan.dtRealStartTime := strToDateTime('2000-01-01');
  TrainPlan.dtChuQinTime := strToDateTime('2000-01-01');
  TrainPlan.strTrainJiaoluGUID :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  TrainPlan.strTrainJiaoluName :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluName;

  TrainPlan.strStartStation :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strStartStation;

  TrainPlan.strStartStationName :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strStartStationName;

  TrainPlan.strEndStation :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strEndStation;

  TrainPlan.strEndStationName :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strEndStationName;

  TrainPlan.nTrainmanTypeID :=  ttNormal;

  TrainPlan.nPlanType := ptYunYong;

  TrainPlan.nDragType := pdtBenWu;

  TrainPlan.nKeHuoID := khKe;

  TrainPlan.nRemarkType := prtKuJie;

  TrainPlan.nPlanState := psEdit;

  TrainPlan.strPlanStateName := TRsPlanStateNameAry[TrainPlan.nPlanState];

  TrainPlan.dtCreateTime := m_dtNow;

  TrainPlan.strCreateSiteGUID := GlobalDM.SiteInfo.strSiteGUID;

  TrainPlan.strCreateSiteName := GlobalDM.SiteInfo.strSiteName;

  TrainPlan.strCreateUserGUID := GlobalDM.DutyUser.strDutyGUID;

  TrainPlan.strCreateUserName := GlobalDM.DutyUser.strDutyName;
end;

procedure TfrmMain_JiDiao.AddPlan(Plan: RRsTrainPlan);
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

  {
  m_DBTrainPlan.Add(Plan);
  }

end;

procedure TfrmMain_JiDiao.AddRTrainmanPlanToControl(
  TrainmanPlan: RRsTrainmanPlan; nRow: Integer);
begin
  with strGridTrainPlan do
  begin
    Cells[COL_XUHAO_INDEX, nRow + 1] := IntToStr(nRow + 1);
    Cells[COL_STATE_INDEX, nRow + 1] := TRsPlanStateNameAry[TrainmanPlan.TrainPlan.nPlanState];
    Cells[COL_TRAINJIAOLU_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strTrainJiaoluName;
    Cells[COL_TRAINTYPE_INDEX, nRow + 1] :=  TrainmanPlan.TrainPlan.strTrainTypeName;
    Cells[COL_TRAINNO_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strTrainNumber;
    Cells[COL_CHECI_INDEX, nRow + 1] :=  TrainmanPlan.TrainPlan.strTrainNo;
    Cells[COL_PLANKAICHETIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtStartTime);
    Cells[COL_REALKAICHETIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtRealStartTime);
    Cells[COL_BEGINWORKTIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtChuQinTime);
    Cells[COL_STARTSTATION_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strStartStationName;
    Cells[COL_ENDSTATION_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strEndStationName;
    Cells[COL_TRAINMANTYPE_INDEX, nRow + 1] := TRsTrainmanTypeName[TrainmanPlan.TrainPlan.nTrainmanTypeID];
    Cells[COL_PLANTYPE_INDEX, nRow + 1] := TRsPlanTypeName[TrainmanPlan.TrainPlan.nPlanType];
    Cells[COL_DRAGSTATE_INDEX, nRow + 1] := TRsDragTypeName[TrainmanPlan.TrainPlan.nDragType];
    Cells[COL_KEHUO_INDEX, nRow + 1] := TRsKeHuoNameArray[TrainmanPlan.TrainPlan.nKeHuoID];
    Cells[COL_REMARKTYPE_INDEX, nRow + 1] := TRsPlanRemarkTypeName[TrainmanPlan.TrainPlan.nRemarkType];
    Cells[COL_REMARK_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strRemark;
    Cells[COL_TRAINMAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman1);
    Cells[COL_SUBTRAINMAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman2);
    Cells[COL_XUEYUAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman3);
    Cells[COL_XUEYUAN2_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman4);


    Cells[COL_DUTYPLACE_INDEX,nRow + 1] :=  TrainmanPlan.TrainPlan.strPlaceName ;

    Cells[99, nRow + 1] := TrainmanPlan.TrainPlan.strTrainPlanGUID;
  end;
end;

procedure TfrmMain_JiDiao.btnAddPlanClick(Sender: TObject);
var
  strTrainJiaoluGUID : string;
  TrainPlan: RRsTrainPlan;
  listDutyPlace:TRsDutyPlaceList ;
  strError : string;
begin
  if not GlobalDM.ADOConnection.Connected then
  begin
    Box('数据库连接已断开，请稍后再试');
    exit;
  end;
  
  if tabTrainJiaolu.TabIndex > -1 then
    strTrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;


  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(strTrainJiaoluGUID,listDutyPlace,strError) then
  begin
    BoxErr('获取出勤点信息错误');
    Exit;
  end;

  if Length(listDutyPlace)  = 0 then
  begin
    BoxErr('该交路下面没有出勤点,增加计划失败');
    Exit ;
  end;

  TrainPlan.strPlaceID :=   listDutyPlace[0].placeID ;
  TrainPlan.strPlaceName := listDutyPlace[0].placeName ;

  AddNewPlan(TrainPlan);
  AddPlan(TrainPlan);
  InitTrainPlan;
end;

{
 procedure TfrmMain_JiDiao.btnCancelPlanClick(Sender: TObject);
var
  i,index: integer;
  guids: TStrings;
  planGUID: string;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
  strError: string;
begin
  guids := TStringList.Create;
  TFMessageList := TTFMessageList.Create;
  try
    for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
    begin
      index := strGridTrainPlan.SelectedRow[i];
      
      planGUID := strGridTrainPlan.Cells[99, index];
      if planGUID = '' then
      begin
        continue;
      end;

      if m_TrainmanPlanArray[index - 1].TrainPlan.nPlanState >= pssent then
      begin
        TFMessage := TTFMessage.Create;
        TFMessage.msg := TFM_PLAN_TRAIN_CANCEL;
        FillMessageWithPlan(TFMessage,m_TrainmanPlanArray[index - 1].TrainPlan);
        TFMessageList.Add(TFMessage);
      end;

      guids.Add(planGUID);
    end;

    if guids.Count = 0 then
    begin
      Application.MessageBox('没有要撤销的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    if not m_DBTrainPlan.CanCanlePlan(guids,strError) then
    begin
      Box(strError);
      Exit;
    end;

    if not TBox('您确认要撤销选中的计划信息吗？') then exit;

    if not m_DBTrainPlan.CancelPlan(guids,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
    begin
      Application.MessageBox('撤销计划失败！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end
    else
    begin
      if TFMessageList.Count > 0 then
      begin
        PostPlanMessage(TFMessageList);
      end;

    end;
  finally
    guids.Free;
    TFMessageList.Free;
  end;

  InitTrainPlan;
  Application.MessageBox('撤销计划成功！', '提示', MB_OK + MB_ICONINFORMATION);
end;

}

procedure TfrmMain_JiDiao.btnCancelPlanClick(Sender: TObject);
var
  planList: TStringList;
begin
  planList := TStringList.Create;
  try
    GetSelPlan(planList);
    if planList.Count = 0 then
    begin
      Application.MessageBox('没有要撤销的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    //检测计划能否删除
    if not TBox('您确认要撤销选中的计划信息吗？') then exit;

    try
      if CancelPlan(planList) then
        Application.MessageBox('撤销计划成功！', '提示', MB_OK + MB_ICONINFORMATION)
      else
        Application.MessageBox('撤销计划失败！', '提示', MB_OK + MB_ICONINFORMATION);
      InitTrainPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('下发计划失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    planList.Free;
  end;
end;


{
procedure TfrmMain_JiDiao.btnDeletePlanClick(Sender: TObject);
var
  i, nSucceedCount, nTotalCount: integer;
  trainPlanGUID: string;
  trainPlan: RRsTrainPlan;
begin
  nTotalCount := 0;
  for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
  begin
    //检测选中行的数据有效性
    trainPlanGUID := strGridTrainPlan.Cells[99, strGridTrainPlan.selectedrow[i]];
    trainPlan.strTrainPlanGUID := trainPlanGUID;
    if trainPlanGUID = '' then continue;

    if not m_DBTrainPlan.GetPlan(trainPlanGUID, trainPlan) then
    begin
      Box('已有计划已被删除，请刷新后重试');
      exit;
    end;

    if trainPlan.nPlanState <> psEdit then
    begin
      Box('只能删除处于编辑状态的计划！');
      exit;
    end;
    nTotalCount := nTotalCount + 1;
  end;

  if nTotalCount = 0 then
  begin
    Application.MessageBox('没有要删除的计划！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox('您确定要删除此机车计划吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  strGridTrainPlan.BeginUpdate;
  try
    nSucceedCount := 0;
    for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
    begin
      m_DBTrainPlan.Delete(trainPlanGUID);
      nSucceedCount := nSucceedCount + 1;
    end;
    Application.MessageBox(PChar(Format('成功删除%d条计划，失败%d条！',
      [nSucceedCount, nTotalCount - nSucceedCount])), '提示', MB_OK + MB_ICONINFORMATION);
    InitTrainPlan;
  finally
    strGridTrainPlan.EndUpdate;
  end;
end;
}


procedure TfrmMain_JiDiao.btnDeletePlanClick(Sender: TObject);
var
  nSucceedCount: integer;
  planList : TStringList;
begin
  planList := TStringList.Create;
  //获取要删除的数据
  GetSelPlan(planList);
  
  //检查是否没有选中一个
  if planList.Count = 0 then
  begin
    Application.MessageBox('没有要删除的计划！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox('您确定要删除此机车计划吗？', '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  strGridTrainPlan.BeginUpdate;
  //开始删除
  try
    try
      nSucceedCount := DeletePlan(planList);
      Application.MessageBox(PChar(Format('成功删除%d条计划，失败%d条！',
        [nSucceedCount, planList.Count - nSucceedCount])), '提示', MB_OK + MB_ICONINFORMATION);
      InitTrainPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('删除失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    FreeAndNil(planList);
    strGridTrainPlan.EndUpdate;
  end;
end;

procedure TfrmMain_JiDiao.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TfrmMain_JiDiao.btnLoadPlanClick(Sender: TObject);
var
  dt, dtBeginTime, dtEndTime: TDateTime;
  strMsg: string;
  strTrainJiaoluGUID : string;
  strError:string;
begin
  if tabTrainJiaolu.TabIndex > -1 then
    strTrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;

  dt := DateOf(GlobalDM.GetNow);
  dtBeginTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');
  dtEndTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 17:59');


  if not TuDingTimeRange(dtBeginTime,dtEndTime) then
    Exit;

  strMsg := '确定要从图定车次表中加载并成%s到%s的计划吗?';
  strMsg := Format(strMsg, [FormatDateTime('yyyy-MM-dd hh:nn', dtBeginTime), FormatDateTime('yyyy-MM-dd hh:nn', dtEndTime)]);

  if Application.MessageBox(PChar(strMsg), '提示', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  try
  
    if not m_webTrainnos.Load(strTrainJiaoluGUID,dtBeginTime,dtEndTime,strError) then
    begin
      BoxErr(strError);
      Exit ;
    end;

    {
    m_DBTrainPlan.LoadTrainPlan(dtBeginTime, dtEndTime,strTrainJiaoluGUID,
      GlobalDM.DutyUser.strDutyGUID,GlobalDM.SiteInfo.strSiteGUID,psEdit);
     }

    InitTrainPlan;
  except on e: exception do
    begin
      Box(Format('从图定车次表中加载计划错误：%s', [e.Message]));
    end;
  end;
end;

procedure TfrmMain_JiDiao.btnRefreshPalnClick(Sender: TObject);
begin
  InitSendLog();
  InitTrainPlan();
end;

{
 procedure TfrmMain_JiDiao.btnSendPlanClick(Sender: TObject);
var
  i: integer;
  guids: TStrings;
  planGUID: string;
  trainPlan: RRsTrainPlan;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
begin
  //获取选中计划的GUID，并判断选中的计划是否符合要求
  guids := TStringList.Create;
  TFMessageList := TTFMessageList.Create;
  try
    for i := 0 to strGridTrainPlan.RowCount - 1 do
    begin
      planGUID := strGridTrainPlan.Cells[99, i];
      if planGUID = '' then
      begin
        continue;
      end;
      trainPlan.strTrainPlanGUID := planGUID;
      if not m_DBTrainPlan.GetPlan(planGUID, trainPlan) then
        continue;

      if trainPlan.nPlanState <> psEdit then
        Continue;

      if trainPlan.strTrainNo = '' then
        Continue;

      if trainPlan.dtStartTime <= 36524 then
        Continue;
      TFMessage := TTFMessage.Create;
      TFMessage.msg := TFM_PLAN_TRAIN_PUBLISH;
      FillMessageWithPlan(TFMessage,trainPlan);
      TFMessageList.Add(TFMessage);
      
      guids.Add(planGUID);
    end;
    if guids.Count = 0 then
    begin
      Application.MessageBox('没有要下发的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if not TBox('您确认要下发计划信息吗？') then exit;
    

    try
      if not m_DBTrainPlan.SendPlan(guids,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
      begin
        Application.MessageBox('下发计划失败！', '提示', MB_OK + MB_ICONERROR);
        GlobalDM.ADOConnection.RollbackTrans;
        exit;
      end
      else
      begin
        if TFMessageList.Count > 0 then
          PostPlanMessage(TFMessageList);
      end;  
      //刷新计划显示
      InitTrainPlan;
      Box('下发计划成功！');
    except on e: exception do
      begin
        Box(PChar(Format('下发计划失败,错误信息:%s！', [e.Message])));
      end;
    end;

  finally
    guids.Free;
    TFMessageList.Free;
  end;
end;

}

procedure TfrmMain_JiDiao.btnSendPlanClick(Sender: TObject);
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
      if not SendPlan(planList) then
        Application.MessageBox('下发计划失败！', '提示', MB_OK + MB_ICONERROR) 
      else
         Box('下发计划成功！'); 
      //刷新计划显示
      InitTrainPlan;
    except on e: exception do
      begin
        Box(PChar(Format('下发计划失败,错误信息:%s！', [e.Message])));
      end;
    end;
  finally
    planList.Free;
  end;
end;

function TfrmMain_JiDiao.CancelPlan(PlanList: TStrings): Boolean;
var
  i: integer;
  planGUID: string;
  trainPlan: RRsTrainPlan;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
  strError : string;
begin
  Result := false ;
  TFMessageList := TTFMessageList.Create;

  //检测是否需要添加消息
  for i := 0 to PlanList.Count - 1 do
  begin
    planGUID := PlanList[i];
    trainPlan.strTrainPlanGUID := planGUID;
    m_DBTrainPlan.GetPlan(planGUID, trainPlan);

    if trainPlan.nPlanState >= pssent then
    begin
      TFMessage := TTFMessage.Create;
      TFMessage.msg := TFM_PLAN_TRAIN_CANCEL;
      FillMessageWithPlan(TFMessage,trainPlan);
      TFMessageList.Add(TFMessage);
    end;

  end;
    
  if not m_DBTrainPlan.CanCanlePlan(planList,strError) then
  begin
    Box(strError);
    Exit;
  end;


  //if not m_webTrainPlan.CancelPlan(PlanList, GlobalDM.DutyUser.strDutyGUID,strError) then
  if not m_DBTrainPlan.CancelPlan(PlanList,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
  begin
    //撤销失败
    exit;
  end
  else
  begin
    if TFMessageList.Count > 0 then
    begin
      PostPlanMessage(TFMessageList);
    end;
  end;
  Result := True ;
end;

procedure TfrmMain_JiDiao.DBConnected(Sender: TObject);
begin
  statusPanelDBState.Caption := '数据库已连接!';
  statusPanelDBState.Font.Color := clBlack;
end;

procedure TfrmMain_JiDiao.DBDisconnected(Sender: TObject);
begin
  statusPanelDBState.Caption := '数据库已断开!';
  statusPanelDBState.Font.Color := clRed;
end;

function TfrmMain_JiDiao.DeletePlan(PlanList:TStrings):Integer;
var
  i : Integer ;
  trainPlanGUID : string;
  trainPlan: RRsTrainPlan;
  strError:string;
begin
  Result := 0 ;
  for i := 0 to PlanList.Count - 1 do
  begin
    trainPlanGUID := PlanList[i];
    if trainPlanGUID = '' then continue;

    //检测是被删除
    if not m_DBTrainPlan.GetPlan(trainPlanGUID, trainPlan) then
    begin
      Box('已有计划已被删除，请刷新后重试');
      Continue
    end;
    //检测是否能删除
    if trainPlan.nPlanState <> psEdit then
    begin
      Box('只能删除处于编辑状态的计划！');
      Continue;
    end;

    //m_DBTrainPlan.Delete(trainPlanGUID);
    if not m_webTrainPlan.DeleteTrainPlan(trainPlanGUID,strError) then
    begin
      BoxErr(strError);
    end;
    inc(result);
  end;
end;

procedure TfrmMain_JiDiao.dtpPlanStartTimeChange(Sender: TObject);
begin
  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
end;

class procedure TfrmMain_JiDiao.EnterJiDiao;
begin
  if frmMain_JiDiao = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TfrmMain_JiDiao, frmMain_JiDiao);
    frmMain_JiDiao.InitData;
  end;
  frmMain_JiDiao.Show;
end;

procedure TfrmMain_JiDiao.FillMessageWithPlan(TFMessage: TTFMessage;
  Plan: RRsTrainPlan);
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

function TfrmMain_JiDiao.FormatTrainNumber(TrainNumber: string): string;
begin
  Result := Trim(TrainNumber);
  if length(Result) = 3 then
    Result := '0' + Result;
  if length(Result) = 2 then
    Result := '00' + Result;
  if length(Result) = 1 then
    Result := '000' + Result;  
end;



procedure TfrmMain_JiDiao.FormClick(Sender: TObject);
begin
  LeaveJiDiao;
end;

procedure TfrmMain_JiDiao.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_JiDiao.FormCreate(Sender: TObject);
begin
  //strGrid的选中框颜色
  strGridTrainPlan.SelectionRectangleColor := clRed;
  //数据库操作类
  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_DBTrainPlan := TRsDBTrainPlan.Create(GlobalDM.ADOConnection);
  //图定车次WEB
  m_webTrainnos := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  //记录strGrid的列宽
  strGridTrainPlan.ColumnSize.Key := 'FormColWidths.ini';
  strGridTrainPlan.ColumnSize.Section := 'TrainPlan';
  strGridTrainPlan.ColumnSize.Save := false;
  strGridTrainPlan.ColumnSize.Location := clIniFile;
  GlobalDM.SetGridColumnWidth(strGridTrainPlan);
  GlobalDM.SetGridColumnVisible(strGridTrainPlan);
  m_dtNow := GlobalDM.GetNow;
  dtpPlanStartTime.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
end;

procedure TfrmMain_JiDiao.FormDestroy(Sender: TObject);
begin
  GlobalDM.SaveGridColumnWidth(strGridTrainPlan);
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
  tmrRefreshTime.Enabled := False;
  TimerCheckUpdate.Enabled := False;
  m_DBTrainJiaolu.Free;
  m_DBTrainPlan.Free;
  m_webTrainnos.Free;
  m_webTrainPlan.Free ;
  m_webDutyPlace.Free ;
end;

procedure TfrmMain_JiDiao.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open;
  
  tmrRefreshTime.Enabled := True;
end;

procedure TfrmMain_JiDiao.GetAllPlan(PlanList: TStrings);
var
  i: integer;
  planGUID: string;
  trainPlan: RRsTrainPlan;
begin
  for i := 0 to strGridTrainPlan.RowCount - 1 do
  begin
    planGUID := strGridTrainPlan.Cells[99, i];
    if planGUID = '' then
      continue;

    trainPlan.strTrainPlanGUID := planGUID;
    if not m_DBTrainPlan.GetPlan(planGUID, trainPlan) then
      continue;

    if trainPlan.nPlanState <> psEdit then
      Continue;

    if trainPlan.strTrainNo = '' then
      Continue;

    if trainPlan.dtStartTime <= 36524 then
      Continue;

    planList.Add(planGUID);
  end;
end;

function TfrmMain_JiDiao.GetSelectedTrainJiaolu(
  out TrainJiaoluGUID: string): boolean;
begin
  result := false;
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  if length(m_TrainjiaoluArray) < tabTrainJiaolu.Tabs.Count then exit;
  TrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  result := true;
end;

procedure TfrmMain_JiDiao.GetSelPlan(PlanList: TStrings);
var
  i : Integer;
  index :Integer ;
  planGUID : string;
begin
  for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
  begin
    index := strGridTrainPlan.SelectedRow[i];
    planGUID := strGridTrainPlan.Cells[99, index];
    if planGUID = '' then
      continue;
    PlanList.Add(planGUID);
  end;
end;

procedure TfrmMain_JiDiao.GridRowToTrainPlan(nRow: Integer;
  var Plan: RRsTrainPlan);
begin
  Plan.strTrainTypeName :=
    strGridTrainPlan.Cells[COL_TRAINTYPE_INDEX,nRow];
  Plan.strTrainNumber :=
    strGridTrainPlan.Cells[COL_TRAINNO_INDEX,nRow];
  Plan.strTrainNo :=
    strGridTrainPlan.Cells[COL_CHECI_INDEX,nRow];
  Plan.dtStartTime :=
    StrToDateTime(strGridTrainPlan.Cells[COL_PLANKAICHETIME_INDEX,nRow] + ':00');
  Plan.dtRealStartTime :=
    StrToDateTime(strGridTrainPlan.Cells[COL_REALKAICHETIME_INDEX,nRow]);

  Plan.dtChuQinTime :=
    StrToDateTime(strGridTrainPlan.Cells[COL_BEGINWORKTIME_INDEX,nRow] + ':00' );

  Plan.strStartStation :=
    StationNameToGUID(strGridTrainPlan.Cells[COL_STARTSTATION_INDEX,nRow],m_StationArray);
  Plan.strStartStationName :=
    strGridTrainPlan.Cells[COL_STARTSTATION_INDEX,nRow];
  Plan.strEndStation :=
    StationNameToGUID(strGridTrainPlan.Cells[COL_ENDSTATION_INDEX,nRow],m_StationArray);
  Plan.strEndStationName :=
    strGridTrainPlan.Cells[COL_ENDSTATION_INDEX,nRow];
  Plan.nTrainmanTypeID :=
    TrianmanTypeNameToType(strGridTrainPlan.Cells[COL_TRAINMANTYPE_INDEX,nRow]);
  Plan.nPlanType :=
    PlanTypeNameToType(strGridTrainPlan.Cells[COL_PLANTYPE_INDEX,nRow]);
  Plan.nDragType :=
    DragTypeNameToType(strGridTrainPlan.Cells[COL_DRAGSTATE_INDEX,nRow]);
  Plan.nKeHuoID :=
    KeHuoNameToType(strGridTrainPlan.Cells[COL_KEHUO_INDEX,nRow]);
  Plan.nRemarkType :=
    PlanRemarkTypeNameToType(strGridTrainPlan.Cells[COL_REMARKTYPE_INDEX,nRow]);

  Plan.strPlaceID:=
    DutyPlaceToGUID(strGridTrainPlan.Cells[COL_DUTYPLACE_INDEX,nRow],m_dutyPlaceList);

  Plan.strRemark := strGridTrainPlan.Cells[COL_REMARK_INDEX, nRow];
end;

procedure TfrmMain_JiDiao.InitTrainPlan();
var
  strError:string;
  i : integer;
  dtBeginTime,dtEndTime : TDateTime;
  trainJiaoluGUID : string;
  trainmanPlanArray : TRsTrainmanPlanArray;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;
  dtBeginTime := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  dtEndTime := dtBeginTime + 2;
  try
  
    if not m_webTrainPlan.GetTrainmanPlanByJiaoLu(TrainJiaoluGUID,dtBeginTime,dtEndTime,trainmanPlanArray,strError) then
    begin
      BoxErr(strError);
      Exit;
    end;


    {
    m_DBTrainPlan.GetTrainmanPlans(dtBeginTime,dtEndTime, TrainJiaoluGUID,trainmanPlanArray);

    //是否刷新判断
    //if m_DBTrainPlan.EqualTrainmanPlan(m_TrainmanPlanArray,trainmanPlanArray) then exit;
     }

    m_TrainmanPlanArray := trainmanPlanArray;
    with strGridTrainPlan do
    begin
      ClearRows(1, 10000);

      if length(trainmanPlanArray) > 0 then
        RowCount := length(trainmanPlanArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(trainmanPlanArray) - 1 do
      begin
        AddRTrainmanPlanToControl(trainmanPlanArray[i], i);
      end;

      strGridTrainPlan.Repaint();
    end;
  except on e: exception do
    begin
      Box('获取计划信息失败：' + e.Message);
    end;
  end;
end;

procedure TfrmMain_JiDiao.JiaoLuChangeMenuClick(Sender: TObject);
var
  strJiaoLuGUID: string;
  trainmanPlan : RRsTrainmanPlan;
begin

  if (Length(m_TrainmanPlanArray) = 0) then
    Exit;
  m_DBTrainPlan.GetTrainmanPlan(m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strTrainPlanGUID,trainmanPlan);
  if (trainmanPlan.TrainPlan.nPlanState >= psPublish) then
  begin
    Box('已经发布的计划不能修改行车区段');
    exit;
  end;
  strJiaoLuGUID := TMenuItem(Sender).Hint;

  m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strTrainJiaoluGUID
      := strJiaoLuGUID;

  m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strStartStation :=
      m_TrainjiaoluArray[TMenuItem(Sender).Tag].strStartStation;

  m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strStartStationName :=
      m_TrainjiaoluArray[TMenuItem(Sender).Tag].strStartStationName;

  m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strEndStation :=
      m_TrainjiaoluArray[TMenuItem(Sender).Tag].strEndStation;

  m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan.strEndStationName :=
      m_TrainjiaoluArray[TMenuItem(Sender).Tag].strEndStationName;
      

  m_DBTrainPlan.Update(m_TrainmanPlanArray[strGridTrainPlan.Row - 1].TrainPlan,GlobalDM.GetNow,
    GlobalDM.SiteInfo.strSiteGUID,GlobalDM.DutyUser.strDutyGUID);


  InitTrainPlan();
end;

class procedure TfrmMain_JiDiao.LeaveJiDiao;
begin
  GlobalDM.OnAppVersionChange := nil;
  //释放已硬件驱动
  if frmMain_JiDiao <> nil then
    FreeAndNil(frmMain_JiDiao);
end;

procedure TfrmMain_JiDiao.miExportPlanToXlsClick(Sender: TObject);
begin
  ExportTrainPlan(m_TrainjiaoluArray);
end;

procedure TfrmMain_JiDiao.miModifyPasswordClick(Sender: TObject);
begin
 TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_JiDiao.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(strGridTrainPlan,'TrainPlan');
end;

procedure TfrmMain_JiDiao.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_JiDiao.N25Click(Sender: TObject);
begin
  TfrmTrainmanManage.OpenTrainmanQuery;
end;

procedure TfrmMain_JiDiao.N29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_JiDiao.N31Click(Sender: TObject);
begin
  btnExchangeModuleClick(btnExchangeModule);
end;

procedure TfrmMain_JiDiao.N35Click(Sender: TObject);
begin
  TfrmConfig.EditConfig;
end;

procedure TfrmMain_JiDiao.N7Click(Sender: TObject);
begin
  TfrmTrainNo.ManageTrainNo;
end;

procedure TfrmMain_JiDiao.NextFocus;
var
  selectCol : integer;
begin
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if selectCol < COL_PLANKAICHETIME_INDEX then
    strGridTrainPlan.Col := strGridTrainPlan.Col + 1
  else
  if selectCol = COL_PLANKAICHETIME_INDEX then
  begin
    if strGridTrainPlan.Row < strGridTrainPlan.RowCount - 1 then
      strGridTrainPlan.Row := strGridTrainPlan.Row + 0;
    strGridTrainPlan.Col := strGridTrainPlan.DisplColIndex(COL_TRAINNO_INDEX);
  end;
end;

procedure TfrmMain_JiDiao.OnAppVersionChange(Sender: TObject);
begin
  statusAppVersion.Caption := '有新程序发布,请及时更新!';
end;

procedure TfrmMain_JiDiao.OnTFMessage(TFMessages: TTFMessageList);
var
  i,J: Integer;
  GUIDS: TStringList;
  trainPlan: RRsTrainPlan;
  strMessageType: string;
  item : TListitem;
begin
  GUIDS := TStringList.Create;
  try
    for I := 0 to TFMessages.Count - 1 do
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
      if not m_DBTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
      GlobalDM.SiteInfo.strSiteGUID) then
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;
      case TFMessages.Items[i].msg of
        TFM_PLAN_RENYUAN_PUBLISH,
        TFM_PLAN_RENYUAN_RECIEVE,
        TFM_PLAN_RENYUAN_UPDATE,
        TFM_PLAN_RENYUAN_DELETE,
        TFM_PLAN_RENYUAN_RMTRAINMAN,
        TFM_PLAN_RENYUAN_RMGROUP
        :
        begin
          GUIDS.Text := TFMessages.Items[i].StrField['GUIDS'];
          case TFMessages.Items[i].msg of
            TFM_PLAN_RENYUAN_PUBLISH: strMessageType := '已发布';
            TFM_PLAN_RENYUAN_UPDATE: strMessageType := '更新计划';
            TFM_PLAN_RENYUAN_DELETE: strMessageType := '撤销计划';
            TFM_PLAN_RENYUAN_RECIEVE: strMessageType := '已接收';
            TFM_PLAN_RENYUAN_RMTRAINMAN: strMessageType := '移除人员';
            TFM_PLAN_RENYUAN_RMGROUP: strMessageType := '移除机组';
          end;
          for J := 0 to GUIDS.Count - 1 do
          begin
            if m_DBTrainPlan.GetPlan(GUIDS.Strings[j], trainPlan) then
            begin
              item := lstviewMsg.Items.Insert(0);
              item.Caption := strMessageType;
              item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',now));
              item.SubItems.Add(trainPlan.strTrainJiaoluName);
              item.SubItems.Add(trainPlan.strTrainNo);
              item.SubItems.Add(Format('该计划于"%s"时开车!',[
                FormatDateTime('yyyy-MM-dd HH:nn:ss',trainPlan.dtStartTime)
              ]));
            end;
          end;
        end;
        TFM_WORK_BEGIN:
        begin
          if m_DBTrainPlan.GetPlan(TFMessages.Items[i].StrField['planGuid'], trainPlan) then
          begin
            strMessageType := '出勤';
            item := lstviewMsg.Items.Insert(0);
            item.Caption := strMessageType;
            item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',now));
            item.SubItems.Add(TFMessages.Items[i].StrField['jiaoLuName']);
            item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNo']);
            item.SubItems.Add(Format('乘务员%s已出勤!',[TFMessages.Items[i].StrField['tmname']
            ]));
          end;
        end
      ELSE
        Continue;
      end;

    end;

  finally
    GUIDS.Free;
  end;

    
end;
procedure TfrmMain_JiDiao.PostPlanMessage(TFMessage: TTFMessage);
begin
  GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
end;

procedure TfrmMain_JiDiao.PopupMenuPopup(Sender: TObject);
var
  i: Integer;
  Item: TMenuItem;
begin

  PopupMenu.Items.Items[0].Clear;
  for I := 0 to Length(m_TrainjiaoluArray) - 1 do
  begin
    Item := TMenuItem.Create(self);
    Item.Caption := m_TrainjiaoluArray[i].strTrainJiaoluName;
    Item.Hint := m_TrainjiaoluArray[i].strTrainJiaoluGUID;
    Item.Tag := i;
    Item.OnClick := JiaoLuChangeMenuClick;
    PopupMenu.Items.Items[0].Add(Item);
  end;
    
end;

procedure TfrmMain_JiDiao.PostPlanMessage(TFMessageList: TTFMessageList);
var
  I: Integer;
begin
  for I := 0 to TFMessageList.Count - 1 do
  begin
    GlobalDM.TFMessageCompnent.PostMessage(TFMessageList.Items[i]);
  end;

end;

procedure TfrmMain_JiDiao.rzchckbxChuQinClick(Sender: TObject);
begin
  InitTrainPlan;
end;

function TfrmMain_JiDiao.SendPlan(PlanList: TStrings): Boolean;
var
  i: integer;
  planGUID: string;
  trainPlan: RRsTrainPlan;
  TFMessageList: TTFMessageList;
  TFMessage: TTFMessage;
  strError:string;
begin
  TFMessageList := TTFMessageList.Create;
  try
    //检测是否需要添加消息
    for i := 0 to PlanList.Count - 1 do
    begin
      planGUID := PlanList[i];
      trainPlan.strTrainPlanGUID := planGUID;
      m_DBTrainPlan.GetPlan(planGUID, trainPlan);

      TFMessage := TTFMessage.Create;
      TFMessage.msg := TFM_PLAN_TRAIN_PUBLISH;
      FillMessageWithPlan(TFMessage,trainPlan);
      TFMessageList.Add(TFMessage);
    end;

    if not m_webTrainPlan.SendTrainPlan(PlanList, GlobalDM.DutyUser.strDutyGUID,strError) then
    //if not m_DBTrainPlan.SendPlan(PlanList,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
    begin
      result := False ;
      GlobalDM.ADOConnection.RollbackTrans;
      exit;
    end
    else
    begin
      if TFMessageList.Count > 0 then
        PostPlanMessage(TFMessageList);
    end;  
  finally
    TFMessageList.Free;
  end;
  Result := True ;
end;

procedure TfrmMain_JiDiao.UpdatePlan(nRow: Integer);
begin
  if nRow > strGridTrainPlan.RowCount - 1 then
    Exit;

  GridRowToTrainPlan(nRow,m_TrainmanPlanArray[nRow - 1].TrainPlan);
  //限定不能修改
  UpdatePlan(m_TrainmanPlanArray[nRow - 1].TrainPlan);
end;


procedure TfrmMain_JiDiao.strGridTrainPlanCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if (Length(m_TrainmanPlanArray) = 0) or (ARow = 0) then
    Exit;

    
  if Integer(m_TrainmanPlanArray[ARow - 1].
      TrainPlan.nPlanState) >= Integer(psEndWork) then
  begin
    Exit;
  end;
  CanEdit :=
    (ACol = COL_TRAINNO_INDEX) OR
    (ACol = COL_TRAINTYPE_INDEX) OR
    (ACol = COL_CHECI_INDEX) OR
    (ACol = COL_PLANKAICHETIME_INDEX) OR
    (ACol = COL_STARTSTATION_INDEX) OR
    (ACol = COL_ENDSTATION_INDEX) OR
    (ACol = COL_PLANTYPE_INDEX) OR
    (ACol = COL_DRAGSTATE_INDEX) OR
    (ACol = COL_REMARKTYPE_INDEX) OR
    (ACol = COL_REMARK_INDEX) OR
    (ACol = COL_KEHUO_INDEX) or
    (ACol = COL_DUTYPLACE_INDEX) or
    ( ACol = COL_BEGINWORKTIME_INDEX );
end;

procedure TfrmMain_JiDiao.strGridTrainPlanCellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: string; var Valid: Boolean);
var
  strTime: string;
  dtTime: TDateTime;
begin
  if (Length(m_TrainmanPlanArray) = 0)  then Exit;

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
    strGridTrainPlan.Cells[ACol,ARow]  := Value;
    if ACol = COL_PLANKAICHETIME_INDEX then
    begin
      strGridTrainPlan.Cells[COL_REALKAICHETIME_INDEX,strGridTrainPlan.Row]
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
    strGridTrainPlan.Cells[ACol,ARow]  := Value;

  end;

  //验证车次和车型
  if (ACol = COL_CHECI_INDEX) or (ACol = COL_TRAINTYPE_INDEX) then
  begin
    Value := UpperCase(Value);
  end;
  m_bModifyed := True;
end;

procedure TfrmMain_JiDiao.strGridTrainPlanEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  nMinute,nRealCol:Integer ;
  nRemarkType:Integer;
  strPlaceID:string;
  dtTime : TDateTime ;
  strValue:string;

begin
  nRealCol := strGridTrainPlan.RealColIndex(ACol);
  
  if nRealCol = COL_CHECI_INDEX then
  begin
    strGridTrainPlan.Cells[COL_KEHUO_INDEX,ARow] :=
        GetKehuoByCheCi(strGridTrainPlan.Cells[ACol,ARow],GlobalDM.ADOConnection);
  end;



  if nRealCol = COL_REMARKTYPE_INDEX then
  begin
    ;
  end;
  

  if not m_bModifyed then exit;
  if ( nRealCol = COL_BEGINWORKTIME_INDEX )  then
  begin
    strValue := strGridTrainPlan.Cells[COL_BEGINWORKTIME_INDEX,ARow] + ':00' ;
    dtTime :=  StrToDateTime(strValue);

    nRemarkType := Integer ( m_TrainmanPlanArray[ARow -1 ].TrainPlan.nRemarkType );
    strPlaceID := m_TrainmanPlanArray[ARow -1 ].TrainPlan.strPlaceID;

    nMinute := 60 ;
    case nRemarkType of
      //库接 90分钟
      1 : nMinute := 90;
      //站接
      2 : nMinute := 60;
    end;

    //计算间隔
    m_DBTrainPlan.GetPlanTimes(nRemarkType,strPlaceID,nMinute) ;
    dtTime := IncMinute(dtTime,-nMinute)  ;
    strValue := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    strGridTrainPlan.Cells[COL_PLANKAICHETIME_INDEX,ARow]  := strValue;
  end;

  UpdatePlan(ARow);
  m_bModifyed := False;

  if nRealCol = COL_PLANKAICHETIME_INDEX then
  begin
    InitTrainPlan;
  end else begin
    InitTrainPlan;
    //m_DBTrainPlan.RefreshTrainmanPlan(m_TrainmanPlanArray[ARow - 1]);
    //AddRTrainmanPlanToControl(m_TrainmanPlanArray[ARow - 1],ARow - 1);
  end;
end;

procedure TfrmMain_JiDiao.strGridTrainPlanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_JiDiao.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = 1 then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;
  end;
end;

procedure TfrmMain_JiDiao.strGridTrainPlanGetEditorType(Sender: TObject; ACol,
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
      for i := 0 to Length(m_dutyPlaceList) - 1  do
      begin
        TAdvStringGrid(Sender).AddComboString(m_dutyPlaceList[i].placeName);
      end;
    end;
  end;
end;

procedure TfrmMain_JiDiao.strGridTrainPlanKeyPress(Sender: TObject;
  var Key: Char);
var
  selectCol : integer;
begin
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
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

procedure TfrmMain_JiDiao.strGridTrainPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col,row : integer;
  pt : TPoint;
begin
  if Button = mbRight then
  begin
    strGridTrainPlan.MouseToCell(X,Y,col,row);
    if Row = 0 then
    begin
      pt := Point(X,Y);
      pt := strGridTrainPlan.ClientToScreen(pt);
      pMenuColumn.Popup(pt.X,pt.y);
    end
    else
    begin
      if (strGridTrainPlan.Row > 0)  and (Length(m_TrainmanPlanArray) > 0)then
      begin
        pt := Point(X,Y);
        pt := strGridTrainPlan.ClientToScreen(pt);
        PopupMenu.Popup(pt.X,pt.Y);
      end;
    end;
  end;
end;

procedure TfrmMain_JiDiao.tabTrainJiaoluChange(Sender: TObject);
begin
  InitStations();
  InitTrainPlan();
end;



procedure TfrmMain_JiDiao.TimerCheckUpdateTimer(Sender: TObject);
begin
  if GlobalDM.GetUpdateInfo then
  begin
    statusUpdate.Caption := '客户端需要更新，请重启系统';
    statusUpdate.Font.Color := clRed;
  end
  else
  begin
    statusUpdate.Caption := '客户端已是最新版本';
    statusUpdate.Font.Color := clBlack;
  end;
end;

procedure TfrmMain_JiDiao.tmrRefreshTimeTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    if GlobalDM.ADOConnection.Connected then
    begin
      statusPanelDBState.Caption := '数据库已连接!';
      statusPanelDBState.Font.Color := clBlack;
    end else begin
      statusPanelDBState.Caption := '数据库已断开!';
      statusPanelDBState.Font.Color := clRed;
    end;
    m_dtNow := GlobalDM.GetNow;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', m_dtNow);  
    statusMessage.Caption := Format('消息缓存：%d条', [GlobalDM.TFMessageCompnent.MessageBufferCount]);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TfrmMain_JiDiao.UpdatePlan(Plan: RRsTrainPlan);
var
  TFMessage: TTFMessage;
  sourcePlan : RRsTrainPlan;
begin
  TFMessage := TTFMessage.Create;
  try
    //此处不允许调度室修改值乘类型
    m_DBTrainPlan.GetPlan(Plan.strTrainPlanGUID,sourcePlan);
    Plan.nTrainmanTypeID := sourcePlan.nTrainmanTypeID;
    m_DBTrainPlan.Update(Plan,GlobalDM.GetNow,
      GlobalDM.SiteInfo.strSiteGUID,GlobalDM.DutyUser.strDutyGUID);
    if Plan.nPlanState >= psSent then
    begin
      TFMessage.msg := TFM_PLAN_TRAIN_UPDATE;
      FillMessageWithPlan(TFMessage,Plan);
      PostPlanMessage(TFMessage);
    end;

  finally
    TFMessage.Free;
  end;

end;

procedure TfrmMain_JiDiao.InitData;
begin
  GlobalDM.OnDBConnected := DBConnected;
  GlobalDM.OnDBDisconnected := DBDisconnected;
  InitTrainJiaolus;
  InitStations();
  GlobalDM.OnAppVersionChange := OnAppVersionChange;
end;

procedure TfrmMain_JiDiao.InitSendLog;
begin
  lstviewMsg.Items.Clear;
end;

procedure TfrmMain_JiDiao.InitStations;
var
  trainJiaoluGUID : string;
  strError:string;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;

  SetLength(m_StationArray,0);

  RsLCBaseDict.LCStation.GetStationsOfJiaoJu(trainJiaoluGUID,m_StationArray,strError);

  SetLength(m_dutyPlaceList,0);
  m_webDutyPlace.GetDutyPlaceByJiaoLu(trainJiaoluGUID,m_dutyPlaceList,strError);
end;

procedure TfrmMain_JiDiao.InitTrainJiaolus;
var
  i,tempIndex:Integer;
  tab:TRzTabCollectionItem;
begin
  tempIndex := tabTrainJiaolu.TabIndex;
  m_DBTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);

  tabTrainJiaolu.Tabs.Clear;
  for I := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    tab := tabTrainJiaolu.Tabs.Add;
    tab.Caption := m_TrainJiaoluArray[i].strTrainJiaoluName;
  end;
  if length(m_TrainJiaoluArray) > 0 then
  begin
    tabTrainJiaolu.TabIndex := 0;
    if (tempIndex > -1) and (tempIndex < tabTrainJiaolu.Tabs.Count) then
      tabTrainJiaolu.TabIndex := tempIndex;
  end;

  InitTrainPlan;   
end;

end.


