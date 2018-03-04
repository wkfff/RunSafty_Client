unit uFrmMain_RenYuan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, RzPanel, Grids, AdvObj, BaseGrid, AdvGrid,
  ADODB, Buttons, RzStatus, pngimage,RzTabs,uTrainmanJiaolu, DB, PngSpeedButton,
  ComCtrls,uTFMessageDefine,
  uTrainPlan, uSite,
  uTrainJiaolu,uTrainman,uTFSystem,
  uSaftyEnum,uGroupDragObject,RzLstBox, RzChkLst,
  AdvSplitter,uStation,AdvDateTimePicker,uRunSaftyMessageDefine,
  uFrmSelectColumn,ActnList, ImgList, PngImageList, AdvListV,
  RzDTP,uGlobalDM, Mask, RzEdit,uXYRelation,uRSCommonFunctions,
  uLeaveListInfo, 
  frxClass,WideStrings, uCallNotify,
  uFrmMealTicketRule,uLCTrainPlan,uDutyPlace,uLCDutyPlace,
  uLCCallWork, utfLookupEdit,utfPopTypes,uLCNameBoard,uPlanManager,uPubFun,
  uTrainJiaoluItem,uThreadCheckPlan,uFrmSignMain,uFrmSignJiaolu,
  uFrmGetDateTime,uFrmViewGroupOrder,
  uFrmPaibanRecord,uFrmNameBoardChangeLog,uPrintTMReport,    uLCTrainnos,
  uFrmMainTemeplateTrainNo,uLCAskLeave,uLCCallNotify,uLCTrainmanMgr,uLCNameBoardEx,
  uLCPaiBan,uLCBeginwork,utfskin,uMealTicketFacade,uRoomCallRemind;
const
  WM_ROWCHANGE = WM_USER + 2032;
  WM_Input_Verify = WM_User + 3000;
  WM_Refresh_Group = WM_User + 3001;

  COL_XUHAO_INDEX = 0;
  COL_STATE_INDEX = 1;
  COL_TRAINJIAOLU_INDEX = 2;
  COL_WAIQIN_INDEX = 3 ;
  COL_TRAINTYPE_INDEX = 4;
  COL_TRAINNO_INDEX = 5;
  COL_CHECI_INDEX = 6;
  COL_REMARK_INDEX = 7;

  COL_PLAN_CHUQIN_TIME_INDEX = 8 ;
  COL_PLANKAICHETIME_INDEX = 9;
  COL_REALKAICHETIME_INDEX = 11;
  COL_BEGINWORKTIME_INDEX = 10;

  COL_TRAINMAN_INDEX = 12;
  COL_TRAINMAN_CALLWORK = 13 ;
  COL_SUBTRAINMAN_INDEX = 14;
  COL_SUBTRAINMAN_CALLWORK = 15 ;
  COL_XUEYUAN_INDEX = 16;
  COL_XUEYUAN_CALLWORK = 17 ;
  COL_XUEYUAN2_INDEX = 18;
  COL_XUEYUAN2_CALLWORK = 19 ;

  COL_STARTSTATION_INDEX = 20;
  COL_ENDSTATION_INDEX = 21;
  COL_TRAINMANTYPE_INDEX = 22;
  COL_PLANTYPE_INDEX = 23;
  COL_DRAGSTATE_INDEX = 24;
  COL_KEHUO_INDEX = 25;
  COL_REMARKTYPE_INDEX = 26;
  COL_HOUBAN_INDEX = 27;
  COL_HOUBANTIME_INDEX = 28;
  COL_JIAOBAN_INDEX = 29;
  COL_DUTYPLACE_INDEX = 30 ;
  COL_SendPlan_INDEX = 31;
  COL_RecPlan_INDEX = 32;


  //DrawGridGroup
  COLUMN_SEQNUMBER =  0 ;
  COLUMN_STATE      = 1 ;
  COLUMN_TRAINMAN1 = 2 ;
  COLUMN_TRAINMAN2 = 3 ;
  COLUMN_TRAINMAN3 = 4 ;
  COLUMN_TRAINMAN4 = 5 ;
  COLUMN_LAST_ARRIVE_TIME = 6 ;


  //东线/西线货车的车站名字 (打印)
  EAST_HUOCHE_NAME = '唐山东—山海关(货)' ;
  WEAST_HUOCHE_NAME = '唐山东-天津(货)' ;


type
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

  TfrmMain_RenYuan = class(TForm)
    RzPanel1: TRzPanel;
    btnPublishPlan: TPngSpeedButton;
    tmrRefreshSendLog: TTimer;
    Panel3: TPanel;
    statusBar1: TRzStatusBar;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    miModifyPassword: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    mmExit: TMenuItem;
    MenuItem2: TMenuItem;
    N20: TMenuItem;
    N4: TMenuItem;
    miNameplate: TMenuItem;
    miAskForLeave: TMenuItem;
    N24: TMenuItem;
    mTrainmanManage: TMenuItem;
    mSet: TMenuItem;
    N6: TMenuItem;
    N36: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Panel1: TPanel;
    btnNameplate: TPngSpeedButton;
    btnRefreshPaln: TPngSpeedButton;
    N5: TMenuItem;
    N10: TMenuItem;
    miLeaveType: TMenuItem;
    statusFinger: TRzStatusPane;
    statusSysTime: TRzGlyphStatus;
    statusPanelDBState: TRzStatusPane;
    RzPanel8: TRzPanel;
    RzPanel4: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    pGroup: TRzPanel;
    Panel4: TPanel;
    RzPanel2: TRzPanel;
    RzPanel3: TRzPanel;
    Label4: TLabel;
    PopupMenu: TPopupMenu;
    PopupMenu1: TPopupMenu;
    miClearTrainmanPlan: TMenuItem;
    miRemoveGroup: TMenuItem;
    miRemoveTrainman: TMenuItem;
    N15: TMenuItem;
    miTrainmanDetail: TMenuItem;
    btnCTQ: TPngSpeedButton;
    miAddSubPlan: TMenuItem;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    ActionList1: TActionList;
    actXYRelation: TAction;
    tmrSharkIcon: TTimer;
    btnAcceptPlan: TPngSpeedButton;
    Panel2: TPanel;
    Panel6: TPanel;
    PngImageList1: TPngImageList;
    lstviewMsg: TAdvListView;
    dtpPlanStartDate: TRzDateTimePicker;
    dtpPlanStartTime: TRzDateTimePicker;
    N11: TMenuItem;
    statusAppVersion: TRzGlyphStatus;
    miLoadPlan: TMenuItem;
    N14: TMenuItem;
    miTrainNo: TMenuItem;
    miRefreshPlan: TMenuItem;
    btnExchangeModule: TPngSpeedButton;
    TimerCheckUpdate: TTimer;
    statusMessage: TRzStatusPane;
    statusUpdate: TRzStatusPane;
    btnCancelPlan: TPngSpeedButton;
    PageControl1: TPageControl;
    tabRun: TTabSheet;
    RzPanel7: TRzPanel;
    AdvSplitter1: TAdvSplitter;
    checklstTrainmanJiaolu: TRzCheckList;
    RzPanel9: TRzPanel;
    RzPanel11: TRzPanel;
    RzPanel12: TRzPanel;
    RzPanel13: TRzPanel;
    tabLeave: TTabSheet;
    Panel5: TPanel;
    RzPanel6: TRzPanel;
    Label1: TLabel;
    btnQuery: TPngSpeedButton;
    Label3: TLabel;
    RzPanel14: TRzPanel;
    Label6: TLabel;
    btnQuery2: TPngSpeedButton;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    edtTrainmanNumber2: TRzEdit;
    edtTrainmanName2: TRzEdit;
    edtPY2: TRzEdit;
    RzPanel15: TRzPanel;
    AdvSplitter2: TAdvSplitter;
    checkLstLeaveType: TRzCheckList;
    lstBoxLeaveTrainmans: TListBox;
    RzPanel16: TRzPanel;
    RzPanel17: TRzPanel;
    RzPanel18: TRzPanel;
    RzPanel19: TRzPanel;
    RzPanel20: TRzPanel;
    DrawGridGroups: TDrawGrid;
    RzPanel10: TRzPanel;
    pmenuGroupRun: TPopupMenu;
    menuAskLeave: TMenuItem;
    menuCancelLeave: TMenuItem;
    frxReport1: TfrxReport;
    frxUserDataSet1: TfrxUserDataSet;
    N16: TMenuItem;
    menuTrainmanInfo: TMenuItem;
    PopupMenu3: TPopupMenu;
    pmenuPrepare: TPopupMenu;
    X1: TMenuItem;
    N17: TMenuItem;
    I1: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    frxReport2: TfrxReport;
    frxUserDataSet2: TfrxUserDataSet;
    actMealTicketConfig: TAction;
    N22: TMenuItem;
    mniMealTicketModify: TMenuItem;
    N25: TMenuItem;
    N28: TMenuItem;
    miExchangeGroupDir: TMenuItem;
    mniChangePrevGroup: TMenuItem;
    mniChangeNextGroup: TMenuItem;
    N23: TMenuItem;
    N40: TMenuItem;
    mniMealTicketConfig: TMenuItem;
    N38: TMenuItem;
    actMealTicketFaFang: TAction;
    actMealTicketView: TAction;
    AdvSplitter3: TAdvSplitter;
    S1: TMenuItem;
    chkIsAutoMatch: TCheckBox;
    N39: TMenuItem;
    N42: TMenuItem;
    N43: TMenuItem;
    miCallGroup: TMenuItem;
    edtTrainman1: TtfLookupEdit;
    PopupMenu7: TPopupMenu;
    C1: TMenuItem;
    N45: TMenuItem;
    miViewPlanLog: TMenuItem;
    C2: TMenuItem;
    pngmglst1: TPngImageList;
    mniHouBan: TMenuItem;
    mniJiaoBan: TMenuItem;
    mniXYRelation: TMenuItem;
    rzpnlSignForm: TRzPanel;
    advspltr1: TAdvSplitter;
    rzpnlTrainPlan: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    checklstTrainmanJiaoluPrepare: TRzCheckList;
    lstPrepare: TListBox;
    edtTrainmanNumber3: TRzEdit;
    edtTrainmanName3: TRzEdit;
    edtPY3: TRzEdit;
    menuSetTrainman: TMenuItem;
    miDeleteTrainmanFromGroup: TMenuItem;
    N34: TMenuItem;
    mniDelEmptyGroup: TMenuItem;
    miExchangeGroup: TMenuItem;
    miClearArriveTime: TMenuItem;
    miEditArriveTime: TMenuItem;
    mniSwapPrior: TMenuItem;
    mniSwapNext: TMenuItem;
    N47: TMenuItem;
    miClearFromBoard: TMenuItem;
    N37: TMenuItem;
    p1: TMenuItem;
    N41: TMenuItem;
    m1: TMenuItem;
    N46: TMenuItem;
    miPrintBD: TMenuItem;
    N49: TMenuItem;
    N50: TMenuItem;
    N35: TMenuItem;
    N53: TMenuItem;
    N54: TMenuItem;
    N55: TMenuItem;
    N51: TMenuItem;
    N52: TMenuItem;
    miShowKeyMan: TMenuItem;
    N21: TMenuItem;
    TimerRefreshData: TTimer;
    PngSpeedButton1: TPngSpeedButton;
    N26: TMenuItem;
    N27: TMenuItem;
    btnAddPlan: TPngSpeedButton;
    N56: TMenuItem;
    miPBFromPrepare: TMenuItem;



    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NExitClick(Sender: TObject);
    procedure btnPublishPlanClick(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormCreate(Sender: TObject);
    procedure mTrainmanManageClick(Sender: TObject);
    procedure advstrngrdLogGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure miModifyPasswordClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure btnNameplateClick(Sender: TObject);
    procedure tmrRefreshSendLogTimer(Sender: TObject);
    procedure miAskForLeaveClick(Sender: TObject);
    procedure miLeaveTypeClick(Sender: TObject);
    procedure checklstTrainmanJiaoluChange(Sender: TObject; Index: Integer;
      NewState: TCheckBoxState);
    procedure strGridTrainPlanGetEditorType(Sender: TObject; ACol,
      ARow: Integer; var AEditor: TEditorType);
    procedure strGridTrainPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure strGridTrainPlanKeyPress(Sender: TObject; var Key: Char);
    procedure strGridTrainPlanCellValidate(Sender: TObject; ACol, ARow: Integer;
      var Value: string; var Valid: Boolean);
    procedure tabTrainJiaoluChange(Sender: TObject);
    procedure btnCancelPlanClick(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);

    procedure edtTrainmanNumberKeyPress(Sender: TObject; var Key: Char);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure strGridTrainPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miPopManulBeginWorkClick(Sender: TObject);
    procedure strGridTrainPlanDblClickCell(Sender: TObject; ARow,
      ACol: Integer);
    procedure miTrainmanDetailClick(Sender: TObject);
    procedure miViewTrainmanClick(Sender: TObject);
    procedure viewGroupMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miRemoveGroupClick(Sender: TObject);
    procedure miRemoveTrainmanClick(Sender: TObject);

    procedure miAddSubPlanClick(Sender: TObject);
    procedure miSelectColumnClick(Sender: TObject);
    procedure btnCTQClick(Sender: TObject);
    procedure tmrSharkIconTimer(Sender: TObject);
    procedure btnAcceptPlanClick(Sender: TObject);
    procedure dtpPlanStartDateKeyPress(Sender: TObject; var Key: Char);
    procedure miTrainNoClick(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure TimerCheckUpdateTimer(Sender: TObject);
    procedure btnQuery2Click(Sender: TObject);
    procedure checkLstLeaveTypeChange(Sender: TObject; Index: Integer;
      NewState: TCheckBoxState);
    procedure edtPY2KeyPress(Sender: TObject; var Key: Char);
    procedure lstBoxLeaveTrainmansDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure DrawGridGroupsDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure btnPrintClick(Sender: TObject);
    procedure DrawGridGroupsDblClick(Sender: TObject);
    procedure DrawGridGroupsMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuCancelLeaveClick(Sender: TObject);
    procedure DrawGridGroupsMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuAskLeaveClick(Sender: TObject);
    procedure frxUserDataSet1GetValue(const VarName: string;
      var Value: Variant);
    procedure DrawGridGroupsStartDrag(Sender: TObject;
      var DragObject: TDragObject);
    procedure menuTrainmanInfoClick(Sender: TObject);
    procedure I1Click(Sender: TObject);
    procedure X1Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure frxUserDataSet2GetValue(const VarName: string;
      var Value: Variant);
    procedure actMealTicketConfigExecute(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure mniChangePrevGroupClick(Sender: TObject);
    procedure mniChangeNextGroupClick(Sender: TObject);
    procedure mniDelEmptyGroupClick(Sender: TObject);
    procedure DrawGridGroupsClick(Sender: TObject);
    procedure actMealTicketFaFangExecute(Sender: TObject);
    procedure actMealTicketViewExecute(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure S1Click(Sender: TObject);
    procedure chkIsAutoMatchClick(Sender: TObject);
    procedure strGridTrainPlanClick(Sender: TObject);
    procedure N42Click(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure edtTrainman1Change(Sender: TObject);
    procedure edtTrainman1NextPage(Sender: TObject);
    procedure edtTrainman1PrevPage(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure AdvSplitter3Moved(Sender: TObject);
    procedure lstviewMsgAdvancedCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; Stage: TCustomDrawStage;
      var DefaultDraw: Boolean);
    procedure C1Click(Sender: TObject);
    procedure T1Click(Sender: TObject);
    procedure miViewPlanLogClick(Sender: TObject);
    procedure C2Click(Sender: TObject);
    procedure tabTrainJiaoluPaintTabBackground(Sender: TObject;
      ACanvas: TCanvas; ATabIndex: Integer; const ARect: TRect;
      var Handled: Boolean);
    procedure mniHouBanClick(Sender: TObject);
    procedure mniJiaoBanClick(Sender: TObject);
    procedure mniXYRelationClick(Sender: TObject);
    procedure edtTrainmanNumber3KeyPress(Sender: TObject; var Key: Char);
        procedure checklstTrainmanJiaoluPrepareChange(Sender: TObject;
      Index: Integer; NewState: TCheckBoxState);
    procedure lstPrepareDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure lstPrepareMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure menuSetTrainmanClick(Sender: TObject);
    procedure miDeleteTrainmanFromGroupClick(Sender: TObject);
    procedure mniSwapPriorClick(Sender: TObject);
    procedure mniSwapNextClick(Sender: TObject);
    procedure miClearArriveTimeClick(Sender: TObject);
    procedure miEditArriveTimeClick(Sender: TObject);
    procedure N47Click(Sender: TObject);
    procedure miClearFromBoardClick(Sender: TObject);
    procedure btnQueryPrepareClick(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure p1Click(Sender: TObject);
    procedure m1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure miPrintBDClick(Sender: TObject);
    procedure N50Click(Sender: TObject);
    procedure strGridTrainPlanEditCellDone(Sender: TObject; ACol,
      ARow: Integer);
    procedure N35Click(Sender: TObject);
    procedure N53Click(Sender: TObject);
    procedure N55Click(Sender: TObject);
    procedure N51Click(Sender: TObject);
    procedure miShowKeyManClick(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure TimerRefreshDataTimer(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure btnAddPlanClick(Sender: TObject);
    procedure miLoadPlanClick(Sender: TObject);
    procedure miPBFromPrepareClick(Sender: TObject);
  private
    m_DutyUser: TRsLCBoardInputDuty;
    //检查计划线程
    m_threadCheckPlan:TThreadCheckPlan;
    //计划管理类
    m_planManager : TRsPlanManager ;
    //查询到的人员
    m_SelectUserInfo:RRsTrainman;
    //WEB短信接口
    m_webCallWork : TRsLCCallWork ;
    //出勤点
    m_webDutyPlace:TRsLCDutyPlace ;
    //WEB计划接口
    m_webTrainPlan:TRsLCTrainPlan;
    // web机组
    m_webNameBoard:TRsLCNameBoard;
    //图定车次
    m_webTrainnos : TRsLCTrainnos;
    m_LCPaiBan: TLCPaiBan;

    m_LCBeginwork: TLCBeginwork;

    m_nSelectCol : integer;
    //
    m_bValidateFail: Boolean;
    m_bModify: Boolean;
    m_RsLCTrainmamMgr: TRsLCTrainmanMgr;
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
    m_RsLCAskLeave: TRsLCAskLeave;
    //行车区段数组
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //当前显示的人员交路数组
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    //当前显示的预备人员交路数组
    m_TrainmanJiaoluPrepareArray : TRsTrainmanJiaoluArray;
    //当前选中的人员交路内的机组信息
    m_GroupArray : TRsGroupArray;
    //DrawGrid（当前选中的人员交路的组信息）
    m_arrayGroupGrid:TRsGroupArray;
    //打印用（当前选中的人员的交路信息（正常状态，不包括已安排计划））
    m_arrayGroupPrint:TRsGroupArray;
    //叫班接口
    m_RsLCCallNotify: TRsLCCallNotify;
    //请销假类型列表
    m_LeaveTypeArray : TRsLeaveTypeArray;
    //最后一次更新的下发记录时间
    m_dtLastSendTime : TDateTime;
    //数据刷新的计划数组
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    //出勤点列表
    m_dutyPlaceList:TRsDutyPlaceList;
    //车站列表
    m_StationArray: TRsStationArray;
    //非运转人员列表
    m_TrainmanLeaveArray : TRsTrainmanLeaveArray;
    //当前时间
    m_dtNow : TDateTime;
    m_bEditPlanEnable: Boolean;

  //add by  lyq 2014-6-30
  //班序针对货车而言，主要打印，唐山-天津
  //班序 东
    m_listGroupEast:TRsGroupArray;
    //班序西
    m_listGroupWeast:TRsGroupArray;

    //当前选中的交路序号
    m_nIndexSelectJiaolu:Integer;
    // 饭票管理
    m_MealTicket:TMealTicket;
    //单牌人员
    m_trainmanArrayPreapare : TRsTrainmanArray;   

    //签点计划窗体
    frmSign : TFrmSignMain;
    //日期计划关注编号
    m_nDayPlanID : integer;

    m_RemindCtl: TRemindCtl;

    m_bSortByPlanState: Boolean;
     //出勤点
    m_PlaceList:TRsDutyPlaceList;
    function GetSelectTmJL(out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
    function GetRunGroupSelectTM(var Trainman: RRsTrainman): Boolean;
  private
    {功能:显示签点计划窗体}
    procedure ShowSignForm();
    //刷新乜有处理的交路
    procedure WMRefreshJiaoLu(var Msg : TMessage) ; message WM_USER_REFRESH_JIAOLU;
    //初始化机组信息
    procedure InitDrawGridGroup();
    //打印当前的班序
    procedure ShowPrint();
    //获取东,西班序
    procedure GetHuoCheList(HuoJiaoluName:string;var GroupList:TRsGroupArray);
    procedure GetEastHuo(var GroupList:TRsGroupArray);
    procedure GetWeastHuo(var GroupList:TRsGroupArray);
    //打印货车班序
    procedure PrintHuoCheBanXu();
        //根据指定的行号,把相关列赋值给候班结构体
    procedure GridRowToRest(nRow: Integer;var restInfo: RRsRest);
    procedure UpdatePlan(nRow,nCol: Integer);
    procedure ModifyPlan(PlanID:string;nRow,nCol: Integer);
        //根据指定的行号，吧GRID转成一个机车计划结构体
    procedure GridRowToTrainPlan(nRow: Integer; var Plan: RRsTrainPlan);overload; 
  private

    procedure IniColumns(LookupEdit : TtfLookupEdit);
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
   { Private declarations }
   //初始化所有的数据
    procedure InitData;
    //初始化行车区段信息
    procedure InitTrainJiaolus;
    //初始化人员计划
    procedure InitTrainmanPlan;
    //初始化手工派班所需要的信息
    procedure InitManaulPaiBan;
    //初始化手工派班的人员交路信息
    procedure InitTrainmanJiaolus;
    //初始化休假类型
    procedure InitLeaveTypes;
    //初始化手工派班的人员交路下的机组信息
    procedure InitGroups;
    //初始化预备人员交路
    procedure InitPrepareTrainmanJiaolus;
    //初始化单牌
    procedure InitPrepare;
    //初始化请销假人员列表
    procedure InitLeaveTrainmans;
    //初始化交路车站
    procedure InitStations();
    //获取选中的行车区段信息
    function GetSelectedTrainJiaolu(out TrainJiaoluGUID : string):boolean;
    //选中一个行车区段
    procedure SetSelectedTrainJiaolu(TrainJiaoluName : string);
    //获取选择的计划信息
    function GetSelectedTrainmanPlan(out TrainmanPlan : RRsTrainmanPlan) : boolean;
    {功能:添加一条计划到界面}
    procedure AddRTrainmanPlanToControl(TrainmanPlan: RRsTrainmanPlan;
        nRow: Integer);
    {功能:添加一条新计划}
    procedure FillNewPlan(var TrainmanPlan: RRsTrainmanPlan);    
    {功能:刷新显示计划}
    procedure RefreshTrainmanPlan();
    {功能:定位下一个输入焦点}
    procedure NextFocus();

    procedure AddNewPlan(Plan: RRsTrainmanPlan);
   
    //是否是查询的人员所在机组
    function IsQueriedTrainmanGroup(Group : RRsGroup) : boolean;

    //是否是查询的人员所在的人员
    function IsQueriedTrainman(Trainman : RRsTrainman) : boolean;
        //是否是查询的人员所在的预备人员
    function IsQueriedPrepareTrainman(Trainman : RRsTrainman) : boolean;
    procedure WMInputVerify(var Msg : TMessage) ; message WM_Input_Verify;
    //检测人员是否正在值乘
    function IsTrainmanBusy(TrainmanNumber : string) : boolean;
        //检测机组是否正在值乘计划
    function IsGroupBusy(GroupGUID : string) : boolean;
    //检测增加的人员是否合格
    function CheckAddTrainman(Group : RRsGroup;Trainman:RRsTrainman) : boolean;
    function CheckTMBusy(TrainmanNumber : string) : boolean;
    //判断指定列是否为司机列
    function IsTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为副司机列
    function IsSubTrainmanCol(nCol: Integer): Boolean;
    //判断是否为学员列
    function IsXueYuanTrainmanCol(nCol: Integer): Boolean;
    function IsXueYuan2TrainmanCol(nCol: Integer) : Boolean;
    //获取选中的司机工号
    function GetSelectedTrainman(var Trainman: RRsTrainman;out TrainmanIndex : integer): Boolean;

    //检查机组是否是空机组
    function IsGroupEmpty(Group : RRsGroup):boolean;
    
    //刷新机组信息
    procedure WMRefreshGroup (var Message : TMessage); message WM_Refresh_Group;
    //画司机信息
    procedure DrawTrainmanInfo(Canvas : TCanvas;Rect:TRect;Trainman : RRsTrainman;InRoomTime,OutRoomTime : TDateTime);


     //画LSTBOX中的单个司机的信息
    procedure DrawLeaveTrainman(Canvas : TCanvas;StartTop : Integer;StartLeft : integer;
      Trainman : RRsTrainman);
    // 话LISTBOX里面的单牌司机
    procedure  DrawPrepareTrainman(Canvas : TCanvas;StartTop : Integer;StartLeft : integer;
      Trainman : RRsTrainman); 

    procedure AddPlan();
    procedure RecieveTrainPlan();
    procedure PostPlanRenYuanMessage(msg: Integer;GUIDS: TStrings);overload;
    procedure PostPlanRenYuanMessage(msg: Integer;Guid: string);overload;
    procedure SetEditPlanEnable(EditPlanEnable: Boolean);
    procedure OnTFMessage(TFMessages: TTFMessageList);
    procedure GetSelectePlanGUIDS(Guids: TStringList);

    //发送叫班信息
    procedure PostAddCallWorkMessage(Trainman:RRsTrainman;TrainmanPlan: RRsTrainmanPlan;eCallType:TCallType);

    //向短信猫发送叫班信息
    procedure SendCallCallWorkMessage(msg: Integer;CallWork:RRsCallNotify);
    //根据计划和人员填充CALLWORK
    procedure FillCallWork(TrainmanPlan: RRsTrainmanPlan;Trainman:RRsTrainman;var CallWork:RRsCallNotify);


    function RemovePlan(guids: TStringList): Boolean;

    function RemoveSubPlan(guids: TStringList): Boolean;

    //显示司机带的学员信息
    procedure ShowStudentInfo(trainman : RRsTrainman);overload;

    procedure ShowStudentInfo(Group : RRsGroup);overload;
      
    function FormatXYInfo(Teacher: RRsTrainman;StudentArray: TRsXYStudentArray): string;



    {功能:计算未发布计划数量及2小时内开车未发布数据}
    procedure CalcPlanNoPublishCount(PlanArray : TRsTrainmanPlanArray;var nTotalCount,nTwoHoursCount: Integer);

    procedure OnAppVersionChange(Sender: TObject);

    procedure AutoDispatchRenYuan();


    function SortPlan(PlanArray : TRsTrainmanPlanArray): TRsTrainmanPlanArray;
  public
    //进入派班功能模块
    class procedure EnterPaiBan;
    //离开派班功能模块
    class procedure LeavePaiBan;
  end;
  
var
  frmMain_RenYuan: TfrmMain_RenYuan;

implementation
{$R *.dfm}
uses
  dateUtils,{uFrmSetRest,} uFrmTrainmanManage,
  uFrmExchangeModule,ufrmModifyPassWord,
  uFrmLogin,{uFrmSetBeginWork,}uFrmLeaveQuery,
  uFrmLeaveTypeMgr,uFrmTrainmanDetail,utfPopBox,
  uFrmXYRelation,uFrmTrainNo,
  uFrmAskLeave,uFrmCancelLeave,uFrmSetRest,
  uFrmMealTicketConfig,ufrmHint,
  uFrmAddMealTicket,uFrmAddUser,uFrmTrainPlanChangeLog,StrUtils,
  uLCBaseDict
  , ufrmTrainplanExport, ufrmTmJlSelect, 
  uFrmViewMealTicket, uFrmAnnualLeave, uFrmKeyTrainmanView, uFrmTMRptSelect,
  ufrmRemind, uLCWebAPI, uFrmPrintTMRpt,uFrmViewMealTicketLog,RsLibHelper,
  uFrmTicketModify,ufrmTimeRange,uFrmPBFromPrepare,uFrmNameBoardPrepareChangeLog,
  uFrmCTQRecord;

  
procedure TfrmMain_RenYuan.btnAcceptPlanClick(Sender: TObject);
begin
  RecieveTrainPlan();
  GlobalDM.TFMessageCompnent.CancelRecievedMessages();
  //关闭声音
  GlobalDM.StopPlaySound;

  tmrSharkIcon.Enabled := false;
  btnAcceptPlan.PngImage := PngImageList1.PngImages[0].PngImage;
  btnAcceptPlan.Font.Style := []; 
end;


procedure TfrmMain_RenYuan.btnAddPlanClick(Sender: TObject);
begin
 AddPlan();
end;

procedure TfrmMain_RenYuan.btnCTQClick(Sender: TObject);
begin
  TFrmCTQRecord.ShowForm;
end;


procedure TfrmMain_RenYuan.checkLstLeaveTypeChange(Sender: TObject;
  Index: Integer; NewState: TCheckBoxState);
begin
  InitLeaveTrainmans;
end;

procedure TfrmMain_RenYuan.checklstTrainmanJiaoluChange(Sender: TObject;
  Index: Integer; NewState: TCheckBoxState);
var
  selectJiaolus : TStringArray;
  i: Integer;
  jiaoluType : TRsJiaoluType;
begin
  checklstTrainmanJiaolu.OnChange := nil;
  try
    m_nIndexSelectJiaolu := Index ;
    jiaoluType :=  m_TrainmanJiaoluArray[Index].nJiaoluType;
    case jiaoluType of
      //记名式交路只能单选
      jltNamed : begin
        for i  := 0 to checklstTrainmanJiaolu.Count - 1 do
        begin
          if i <> Index then
          begin
            checklstTrainmanJiaolu.ItemChecked[i] := false;
          end;
        end;
      end;
      //轮乘交路只能单选
      jltOrder : begin
        for i  := 0 to checklstTrainmanJiaolu.Count - 1 do
        begin
          if i <> Index then
          begin
            //if m_TrainmanJiaoluArray[i].nJiaoluType <> jiaoluType then
            begin
              checklstTrainmanJiaolu.ItemChecked[i] := false;
            end;
          end;
        end;
      end;
      //包乘交路只能单选
      jltTogether : begin
        for i  := 0 to checklstTrainmanJiaolu.Count - 1 do
        begin
          if i <> Index then
          begin
            checklstTrainmanJiaolu.ItemChecked[i] := false;
          end;
        end;
      end;
    end;

    SetLength(selectJiaolus,0);
    for i := 0 to checklstTrainmanJiaolu.Count - 1 do
    begin
      if checklstTrainmanJiaolu.ItemChecked[i] then
      begin
        SetLength(selectJiaolus,length(selectJiaolus) + 1);
        selectJiaolus[length(selectJiaolus) - 1] := m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID;
      end;
    end;
    GlobalDM.SelectedTrainmanJiaolus := selectJiaolus;
    InitGroups();
  finally
    checklstTrainmanJiaolu.OnChange := checklstTrainmanJiaoluChange;
  end;
end;




procedure TfrmMain_RenYuan.checklstTrainmanJiaoluPrepareChange(Sender: TObject;
  Index: Integer; NewState: TCheckBoxState);

var
  i : integer;
  bRet : Boolean ;
begin
  bRet := checklstTrainmanJiaoluPrepare.ItemChecked[Index] ;
  for i := 0 to checklstTrainmanJiaoluPrepare.Count - 1 do
  begin
    if Index = i then
      checklstTrainmanJiaoluPrepare.ItemChecked[i] :=  bRet
    else
      checklstTrainmanJiaoluPrepare.ItemChecked[i] := False ;
  end;
  InitPrepare ;
end;

function TfrmMain_RenYuan.CheckTMBusy(TrainmanNumber: string): boolean;
begin
  result := false;
  if IsTrainmanBusy(TrainmanNumber) then
  begin
    Box('该人员正在值乘别的计划不能添加人员');
    exit;
  end;

  result := true;
end;

procedure TfrmMain_RenYuan.C1Click(Sender: TObject);
begin
  if not TBox('确认清空消息列表吗?') then
    Exit;
  lstviewMsg.Items.Clear;
end;

procedure TfrmMain_RenYuan.C2Click(Sender: TObject);
var
  strTrainJiaoLuName:string;
begin

  if lstviewMsg.Items.Count = 0 then
    exit ;
  if lstviewMsg.Selected = nil  then
    Exit ;

  if lstviewMsg.Selected.Caption = '更新' then
    exit ;

  if not TBox('是否切换到该行车区段')  then
    Exit ;

  strTrainJiaoLuName :=  lstviewMsg.Selected.SubItems[2] ;
  SetSelectedTrainJiaolu(strTrainJiaoLuName);

end;

procedure TfrmMain_RenYuan.CalcPlanNoPublishCount(
  PlanArray: TRsTrainmanPlanArray; var nTotalCount, nTwoHoursCount: Integer);
var
  i: Integer;
  dtNow: TDateTime;
begin
  dtNow := GlobalDM.GetNow;
  nTotalCount := 0;
  nTwoHoursCount := 0;
  
  for I := 0 to Length(PlanArray) - 1 do
  begin
    if PlanArray[i].TrainPlan.nPlanState in [psSent,psReceive] then
    begin
      Inc(nTotalCount);

      if HoursBetween(dtNow,PlanArray[i].TrainPlan.dtStartTime) <= 2 then
        inc(nTwoHoursCount);        
    end;

  end;
end;

function TfrmMain_RenYuan.CheckAddTrainman(Group: RRsGroup;
  Trainman: RRsTrainman): boolean;
begin
  result := false;
  if IsGroupBusy(Group.strGroupGUID) then
  begin
    Box('该机组已安排计划，不能添加人员');
    exit;
  end;
  if IsTrainmanBusy(trainman.strTrainmanNumber) then
  begin
    Box('该人员正在值乘别的计划不能添加人员');
    exit;
  end;
  if trainman.nTrainmanState = tsUnRuning then
  begin
    Box('请现在请销假中为该人员执行销假操作再安排名牌');
    exit;
  end;
  result := true;
end;



procedure TfrmMain_RenYuan.chkIsAutoMatchClick(Sender: TObject);
begin
  InitGroups;
end;






procedure TfrmMain_RenYuan.dtpPlanStartDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then
  begin
    btnRefreshPaln.Click;
  end;
end;

procedure TfrmMain_RenYuan.dtpPlanStartTimeChange(Sender: TObject);
begin
  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
  m_threadCheckPlan.SetQueryTime( Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime) );
end;

procedure TfrmMain_RenYuan.edtPY2KeyPress(Sender: TObject; var Key: Char);
begin

  if Key = #13 then
  begin
     InitLeaveTrainmans;
  end;
end;

procedure TfrmMain_RenYuan.edtTrainman1Change(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
  strWorkShopGUID:string;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := 1;
    strWorkShopGUID := '' ;



    nCount := m_RsLCTrainmamMgr.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmMain_RenYuan.edtTrainman1NextPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID :string ;
begin
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    strWorkShopGUID := '' ;
    m_RsLCTrainmamMgr.GetPopupTrainmans(strWorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmMain_RenYuan.edtTrainman1PrevPage(Sender: TObject);
var
  edtTrainman: TtfLookupEdit;
  TrainmanArray : TRsTrainmanArray;
  strWorkShopGUID:string;
begin        
  edtTrainman := TtfLookupEdit(Sender);
  with edtTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    strWorkShopGUID := '' ;
    m_RsLCTrainmamMgr.GetPopupTrainmans(strWorkShopGUID , Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman, TrainmanArray);
  end;
end;

procedure TfrmMain_RenYuan.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman1.OnChange := nil;
  try
   if edtTrainman1.Text <> '' then
    m_RsLCTrainmamMgr.GetTrainman(SelectedItem.StringValue,m_SelectUserInfo)
   else
    m_RsLCTrainmamMgr.GetTrainman('',m_SelectUserInfo) ;

   edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
     edtTrainman1.OnChange := edtTrainman1Change;
  end;
end;

procedure TfrmMain_RenYuan.edtTrainmanNumber3KeyPress(Sender: TObject;
  var Key: Char);
begin

  if Key = #13 then
  begin
     InitPrepare;
  end;
end;

procedure TfrmMain_RenYuan.edtTrainmanNumberKeyPress(Sender: TObject;
  var Key: Char);
begin

  if Key = #13 then
  begin
     InitGroups;
  end;
end;

class procedure TfrmMain_RenYuan.EnterPaiBan;
begin
  if frmMain_RenYuan = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TfrmMain_RenYuan, frmMain_RenYuan);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,frmMain_RenYuan);

    frmMain_RenYuan.SetEditPlanEnable(GlobalDM.PlanEditEable);
    frmMain_RenYuan.miLoadPlan.Enabled := GlobalDM.PlanEditEable;
    frmMain_RenYuan.miTrainNo.Enabled := GlobalDM.PlanEditEable;
    frmMain_RenYuan.btnAddPlan.Enabled := GlobalDM.PlanEditEable;
    frmMain_RenYuan.btnCancelPlan.Enabled := GlobalDM.PlanEditEable;
    frmMain_RenYuan.btnAcceptPlan.Enabled := not GlobalDM.PlanEditEable;
    frmMain_RenYuan.InitData;
  end;
  frmMain_RenYuan.Show;
end;


function TfrmMain_RenYuan.FormatXYInfo(Teacher: RRsTrainman;
  StudentArray: TRsXYStudentArray): string;
var
  i: Integer;
begin
  Result := Format('%6s[%s]',[Teacher.strTrainmanName,Teacher.strTrainmanNumber])
  + '学员:';

  for I := 0 to Length(StudentArray) - 1 do
  begin
    Result := Result + Format('%6s[%s]',[StudentArray[i].strStudentName,
        StudentArray[i].strStudentNumber]) + ',';
  end;
    
  if Length(StudentArray) > 0 then
  begin
    Delete(Result,Length(Result),1);
  end;
end;

procedure TfrmMain_RenYuan.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_RenYuan.FormCreate(Sender: TObject);
var
  intArray: TIntArray;
begin
  m_MealTicket := TMealTicketFactory.CreateTicketSender;
  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  m_DutyUser := TRsLCBoardInputDuty.Create;
  m_DutyUser.strDutyGUID := GlobalDM.DutyUser.strDutyGUID;
  m_DutyUser.strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
  m_DutyUser.strDutyName := GlobalDM.DutyUser.strDutyName;

  m_bValidateFail := True;

  m_nIndexSelectJiaolu := 0 ;
  m_dtLastSendTime := 0;
  strGridTrainPlan.SelectionRectangleColor := clRed;



  m_RsLCTrainmamMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(GlobalDM.WebAPIUtils);
  m_RsLCCallNotify := TRsLCCallNotify.Create(GlobalDM.WebAPIUtils);
  m_LCBeginwork := TLCBeginwork.Create(GlobalDM.WebAPIUtils);
  m_webTrainnos := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);



  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webCallWork := TRsLCCallWork.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webNameBoard :=  TRsLCNameBoard.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_RsLCAskLeave := TRsLCAskLeave.Create(GlobalDM.WebAPIUtils);
  m_LCPaiBan := TLCPaiBan.Create(GlobalDM.WebAPIUtils);
  m_planManager := TRsPlanManager.Create(Self.Handle) ;

  //是否连接饭票服务器
  if GlobalDM.UsesMealTicket   then
  begin
    mniMealTicketModify.Visible := True ;
    mniMealTicketConfig.Visible :=  true ;
  end
  else
  begin
    mniMealTicketModify.Visible := False ;
    mniMealTicketConfig.Visible := False ;
  end;


  IniColumns(edtTrainman1);

  //记录strGrid的列宽
  GlobalDM.SetGridColumnWidth(strGridTrainPlan);                  
  GlobalDM.SetGridColumnVisible(strGridTrainPlan);
  dtpPlanStartTime.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);

  m_dtNow := GlobalDM.GetNow;

  InitDrawGridGroup;


  //开启检查计划线程

  m_threadCheckPlan := TThreadCheckPlan.Create(m_planManager);
  //休息时间 10秒
  m_threadCheckPlan.SetSleepTime( 30 );
  m_threadCheckPlan.SetQueryTime(dtpPlanStartTime.DateTime);
  m_threadCheckPlan.Resume;


  SetLength(intArray,2);
  intArray[0] := 20;
  intArray[1] := 60;
  m_RemindCtl := TRemindCtl.Create(intArray);
end;

procedure TfrmMain_RenYuan.FormDestroy(Sender: TObject);
begin
  TimerRefreshData.Enabled := false;
  
  GlobalDM.SaveGridColumnWidth(strGridTrainPlan);
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
  GlobalDM.FingerPrintCtl.EventHolder.Restore;
  tmrRefreshSendLog.Enabled := False;
  TimerCheckUpdate.Enabled := False;
  m_RsLCTrainmamMgr.Free;
  m_webTrainPlan.Free ;
  m_webDutyPlace.Free ;
  m_webCallWork.Free ;
  m_webNameBoard.Free ;
  m_planManager.Free ;
  m_RsLCCallNotify.Free;
  m_LCBeginwork.Free;

  m_MealTicket.Free ;

  m_threadCheckPlan.ExitThread;
  m_threadCheckPlan.Free;
  m_RsLCAskLeave.Free;

  m_RsLCNameBoardEx.Free;
  m_DutyUser.Free;
  m_LCPaiBan.Free;

  m_RemindCtl.Free;
  m_webTrainnos.Free ;
end;

procedure TfrmMain_RenYuan.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
  tmrRefreshSendLog.Enabled := true;
  strGridTrainPlan.SetFocus;
  ShowSignForm();
  //隐藏机组列表
  pGroup.Visible := false;
  AdvSplitter3.Visible := false;
  miRemoveTrainman.Visible := false;
  miExchangeGroupDir.Visible := false;
  miPrintBD.Visible := false;
  miAddSubPlan.Visible := false;
  mniMealTicketModify.Visible := false;
  miCallGroup.Visible := false;
  mniHouBan.Visible := false;
  mniJiaoBan.Visible := false;

  TimerRefreshData.Enabled := true;
end;



procedure TfrmMain_RenYuan.frxUserDataSet1GetValue(const VarName: string;
  var Value: Variant);
var
  group:RRsGroup ;
  nIndex:Integer ;
begin
  nIndex := frxUserDataSet1.RecNo ;
  group :=  m_arrayGroupPrint[nIndex] ;

  if CompareText(VarName,'id') = 0 then
  begin
    Value := IntToStr(nIndex);
  end;
  if CompareText(VarName,'trianman1') = 0 then
  begin
    if group.Trainman1.strTrainmanGUID <> '' then
    begin
      Value := Format('[%s]%s',[group.Trainman1.strTrainmanName,
      group.Trainman1.strTrainmanNumber]);
    end
    else
      Value := '空' ;
  end;
  if CompareText(VarName,'trianman2') = 0 then
  begin
    if group.Trainman2.strTrainmanGUID <> '' then
    begin
      Value := Format('[%s]%s',[group.Trainman2.strTrainmanName,
      group.Trainman2.strTrainmanNumber]);
    end
    else
      Value := '空' ;
  end;
  if CompareText(VarName,'trianman3') = 0 then
  begin
    if group.Trainman3.strTrainmanGUID <> '' then
    begin
      Value := Format('[%s]%s',[group.Trainman3.strTrainmanName,
      group.Trainman3.strTrainmanNumber]);
    end
    else
      Value := '空' ;
  end;
  if CompareText(VarName,'trianman4') = 0 then
  begin
    if group.Trainman4.strTrainmanGUID <> '' then
    begin
      Value := Format('[%s]%s',[group.Trainman4.strTrainmanName,
      group.Trainman4.strTrainmanNumber]);
    end
    else
      Value := '空' ;
  end;
end;

procedure TfrmMain_RenYuan.frxUserDataSet2GetValue(const VarName: string;
  var Value: Variant);
var
  nIndex:Integer ;
  groupEast:RRsGroup ;
  groupWeast:RRsGroup ;
begin
  nIndex := frxUserDataSet2.RecNo ;

  if  nIndex <= Length(m_listGroupWeast)-1 then
  begin
     {西线}
    //序列号
    groupWeast := m_listGroupWeast[nIndex];
    if CompareText(VarName,'E_sn') = 0 then
    begin
      Value := IntToStr(nIndex + 1);
    end;
    //司机1
    if CompareText(VarName,'E_1') = 0 then
    begin
      if groupWeast.Trainman1.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupWeast.Trainman1.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //司机2
    if CompareText(VarName,'E_2') = 0 then
    begin
      if groupWeast.Trainman2.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupWeast.Trainman2.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //司机3
    if CompareText(VarName,'E_3') = 0 then
    begin
      if groupWeast.Trainman3.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupWeast.Trainman3.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //退勤事件
    if CompareText(VarName,'E_tm') = 0 then
    begin
      Value := FormatDateTime('HH:mm',groupWeast.dtArriveTime);
    end;
  end
  else
  begin
    if CompareText(VarName,'E_sn') = 0 then
      Value := IntToStr(nIndex + 1 );
    //司机1
    if CompareText(VarName,'E_1') = 0 then
      Value := '' ;
    if CompareText(VarName,'E_2') = 0 then
      Value := '' ;
    if CompareText(VarName,'E_3') = 0 then
      Value := '' ;
    if CompareText(VarName,'E_tm') = 0 then
      Value := '' ;
  end;

  if nIndex <= Length(m_listGroupEast)-1 then
  begin
   {东线}
    //序列号
    groupEast := m_listGroupEast[nIndex];
    if CompareText(VarName,'W_sn') = 0 then
    begin
      Value := IntToStr(nIndex + 1 );
    end;
    //司机1
    if CompareText(VarName,'W_1') = 0 then
    begin
      if groupEast.Trainman1.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupEast.Trainman1.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //司机2
    if CompareText(VarName,'W_2') = 0 then
    begin
      if groupEast.Trainman2.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupEast.Trainman2.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //司机3
    if CompareText(VarName,'W_3') = 0 then
    begin
      if groupEast.Trainman3.strTrainmanGUID <> '' then
      begin
        Value := Format('%s',[groupEast.Trainman3.strTrainmanName]);
      end
      else
        Value := '' ;
    end;
    //退勤时间
    if CompareText(VarName,'W_tm') = 0 then
    begin
      Value := FormatDateTime('HH:mm',groupEast.dtArriveTime);
    end;
  end
  else
  begin
    if CompareText(VarName,'W_sn') = 0 then
      Value := IntToStr(nIndex + 1 );
    //司机1
    if CompareText(VarName,'W_1') = 0 then
      Value := '' ;
    if CompareText(VarName,'W_2') = 0 then
      Value := '' ;
    if CompareText(VarName,'W_3') = 0 then
      Value := '' ;
    if CompareText(VarName,'W_tm') = 0 then
      Value := '' ;
  end;
  


end;

procedure TfrmMain_RenYuan.GetEastHuo(var GroupList: TRsGroupArray);
begin
  GetHuoCheList(EAST_HUOCHE_NAME,GroupList);
end;

procedure TfrmMain_RenYuan.GetHuoCheList(HuoJiaoluName: string;
  var GroupList: TRsGroupArray);
var
  trainJiaolu :RRsTrainJiaolu;
  trainmanJiaoluArray:TRsTrainmanJiaoluArray;
  i : Integer;
  trainmanjiaolus : TStrings;
  groupArray : TRsGroupArray;
  njiaoluType:TRsJiaoluType;
  nLenPrint:integer;
begin
  //获取东线交路ID
  for I := 0 to Length(m_TrainjiaoluArray) - 1 do
  begin
    if m_TrainjiaoluArray[i].strTrainJiaoluName = HuoJiaoluName then
    begin
      trainJiaolu := m_TrainjiaoluArray[i] ;
      Break;
    end;
  end;

  if trainJiaolu.strTrainJiaoluGUID = '' then
    Exit ;
  
  //获取下属所有的人员交路
  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(
    GlobalDM.SiteInfo.strSiteGUID,trainJiaolu.strTrainJiaoluGUID,trainmanJiaoluArray);
  

  trainmanjiaolus := TStringList.Create();
  for I := 0 to Length(trainmanJiaoluArray) - 1 do
  begin
    trainmanjiaolus.Add(trainmanJiaoluArray[i].strTrainmanJiaoluGUID);
  end;

  //获取人员交路的人
  njiaoluType := jltOrder;

  m_RsLCNameBoardEx.Group.GetGroupArrayInTrainmanJiaolus(trainmanjiaolus.CommaText,Ord(njiaoluType),groupArray);


  for i := 0 to length(groupArray) - 1 do
  begin
    //获取要打印的人员班序  正常人员
    if groupArray[i].GroupState = tsNormal then
    begin
      if (groupArray[i].Trainman1.strTrainmanGUID = '') and
        (groupArray[i].Trainman2.strTrainmanGUID = '') and
        (groupArray[i].Trainman3.strTrainmanGUID = '') and
        (groupArray[i].Trainman4.strTrainmanGUID = '') then
      begin
        //排除空的机组信息
        ;
      end
      else
      begin
        nLenPrint := Length(GroupList);
        SetLength(GroupList,nLenPrint + 1 );
        GroupList[nLenPrint] := groupArray[i] ;
      end;
    end;
  end;
  trainmanjiaolus.Free;
end;

function TfrmMain_RenYuan.GetSelectedTrainJiaolu(
  out TrainJiaoluGUID: string): boolean;
begin
  result := false;
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  if length(m_TrainjiaoluArray) < tabTrainJiaolu.Tabs.Count then exit;
  TrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  result := true;
end;

function TfrmMain_RenYuan.GetSelectedTrainman(var Trainman: RRsTrainman;out TrainmanIndex : integer): Boolean;
var
  selectCol : integer;
begin
  TrainmanIndex := 0;
  Result := False;

  if strGridTrainPlan.Row > Length(m_TrainmanPlanArray) then
      Exit;
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if IsTrainmanCol(selectCol) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman1;
    TrainmanIndex := 1;
    Result := True;
  end
  else
  if IsSubTrainmanCol(selectCol) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman2;
    TrainmanIndex := 2;
    Result := True;
  end;
  if IsXueYuanTrainmanCol(selectCol) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman3;
    TrainmanIndex := 3;
    Result := True;
  end;
  if IsXueYuan2TrainmanCol(selectCol) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman4;
    TrainmanIndex := 4;
    Result := True;
  end;
  
end;

function TfrmMain_RenYuan.GetSelectedTrainmanPlan(
  out TrainmanPlan : RRsTrainmanPlan): boolean;
begin
  result := false;
  if strGridTrainPlan.Row < 1 then Exit;;
  if strGridTrainPlan.Row > length(m_TrainmanPlanArray) then exit;
  TrainmanPlan := m_TrainmanPlanArray[strGridTrainPlan.row - 1];
  result := true;
end;




procedure TfrmMain_RenYuan.GetSelectePlanGUIDS(Guids: TStringList);
var
  i, nIndex: integer;
  planGUID: string;
begin
  for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
  begin
    nIndex := strGridTrainPlan.SelectedRow[i];
    planGUID := strGridTrainPlan.Cells[99, nIndex];
    if planGUID = '' then
    begin
      continue;
    end;
    guids.Add(planGUID);
  end;
end;


function TfrmMain_RenYuan.GetSelectTmJL(
  out TrainmanJiaolu: RRsTrainmanJiaolu): boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to checklstTrainmanJiaolu.items.Count - 1 do
  begin
    if checklstTrainmanJiaolu.ItemChecked[i] then
    begin      
      TrainmanJiaolu := m_TrainmanJiaoluArray[i];
      Result := true;
      break;
    end;
  end;
end;

procedure TfrmMain_RenYuan.GetWeastHuo(var GroupList: TRsGroupArray);
begin
  GetHuoCheList(WEAST_HUOCHE_NAME,GroupList);
end;

procedure TfrmMain_RenYuan.GridRowToRest(nRow: Integer; var restInfo: RRsRest);
begin
if restInfo.nNeedRest = 1 then
    restInfo.dtCallTime :=  StrToDateTime(strGridTrainPlan.Cells[COL_JIAOBAN_INDEX,nRow] + ':00');
end;

procedure TfrmMain_RenYuan.GridRowToTrainPlan(nRow: Integer;
  var Plan: RRsTrainPlan);
var
  sValue: string;
begin
  Plan.strTrainTypeName :=
    strGridTrainPlan.Cells[COL_TRAINTYPE_INDEX,nRow];
  Plan.strTrainNumber :=
    strGridTrainPlan.Cells[COL_TRAINNO_INDEX,nRow];
  Plan.strTrainNo :=
    strGridTrainPlan.Cells[COL_CHECI_INDEX,nRow];
  Plan.dtStartTime :=
    StrToDateTime(strGridTrainPlan.Cells[COL_PLAN_CHUQIN_TIME_INDEX,nRow] + ':00');
  Plan.dtRealStartTime :=
    StrToDateTime(strGridTrainPlan.Cells[COL_REALKAICHETIME_INDEX,nRow]);

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
    DutyPlaceToGUID(strGridTrainPlan.Cells[COL_DUTYPLACE_INDEX,nRow],m_PlaceList);

  Plan.strRemark := strGridTrainPlan.Cells[COL_REMARK_INDEX, nRow];


  sValue := strGridTrainPlan.Cells[COL_WAIQIN_INDEX,nRow];
  Plan.strWaiqinClientGUID := TWaiQin.GetID(sValue);
  Plan.strWaiQinClientNumber := TWaiQin.GetNumber(sValue);
  Plan.strWaiQinClientName := sValue;
end;

procedure TfrmMain_RenYuan.I1Click(Sender: TObject);
var
  nIndex : integer;
  strTrainmanGUID:string;
begin
  nIndex := lstBoxLeaveTrainmans.ItemIndex ;
  if nIndex = -1 then
    Exit ;

  if m_TrainmanLeaveArray[nIndex].Trainman.strTrainmanGUID = '' then
    Exit;

  strTrainmanGUID := m_TrainmanLeaveArray[nIndex].Trainman.strTrainmanGUID ;

  if TfrmTrainmanDetail.ViewTrainmanDetail(strTrainmanGUID) then
    TtfPopBox.ShowBox('修改成功');
end;

procedure TfrmMain_RenYuan.IniColumns(LookupEdit: TtfLookupEdit);
var
  col : TtfColumnItem;
begin
  LookupEdit.Columns.Clear;
  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '序号';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '工号';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '姓名';
  col.Width := 60;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '职务';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '客货';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '关键人';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := 'ABCD';
  col.Width := 40;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '联系电话';
  col.Width := 80;

  col := TtfColumnItem(LookupEdit.Columns.Add);
  col.Caption := '状态';
  col.Width := 80;
end;

procedure TfrmMain_RenYuan.InitData;
var
  strDutyPlaceID : string;
begin
  TtfSkin.InitRzPanel(rzPanel1);
  TtfSkin.InitRzTab(tabTrainJiaolu);
  TtfSkin.InitAdvGrid(strGridTrainPlan);

  InitTrainJiaolus;
  InitLeaveTypes;
  PageControl1.ActivePageIndex := 0;
  GlobalDM.OnAppVersionChange := OnAppVersionChange;
  
  tmrSharkIcon.Enabled := False;

  m_bSortByPlanState := GlobalDM.DB_SysConfig('RenYuanPlan','PlanSortByState') = '1';
  //获取所管理的计划
  strDutyPlaceID := GlobalDM.DutyPlaceID ;
  if strDutyPlaceID = '' then
  begin
    Box('没有关注的外勤端,无法收到机车计划更新消息！');
  end else begin
    m_nDayPlanID := StrToInt(strDutyPlaceID)  ;
  end;

  Caption := '派班管理 ' + GetFileVersion(Application.ExeName);
end;

procedure TfrmMain_RenYuan.InitDrawGridGroup;
begin
  with DrawGridGroups do
  begin
    DefaultColWidth := 100 ;
    ColWidths[0] := 30 ;
    ColWidths[1] := 50 ;
    RowCount := 1 ;
  end;
end;



procedure TfrmMain_RenYuan.InitGroups;
var
  strPlaceID:string;
  strError:string;
  strTrainmanJiaoluGUID:string;
  groupArray : TRsGroupArray;
  i: Integer;
  nLenPrint,nLenGrid:Integer;
begin
  if edtTrainman1.Text = '' then
    m_SelectUserInfo.strTrainmanGUID := '' ;

  strPlaceID := '' ;
  for i := 0 to checklstTrainmanJiaolu.Count - 1 do
  begin
    if checklstTrainmanJiaolu.ItemChecked[i] then
    begin
      strTrainmanJiaoluGUID := m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID;
      Break ;
    end;
  end;


  if strTrainmanJiaoluGUID = '' then
  begin
    SetLength(m_GroupArray,0);
    SetLength(m_arrayGroupGrid,0);
    DrawGridGroups.RowCount := 1 ;
    DrawGridGroups.Invalidate;
    Exit ;
  end;

  m_webNameBoard.GetNormalGroup(strTrainmanJiaoluGUID,strPlaceID,'',groupArray,strError) ;

  m_GroupArray := groupArray;
  SetLength(m_arrayGroupGrid,0);
  SetLength(m_arrayGroupPrint,0);
  for i := 0 to length(m_GroupArray) - 1 do
  begin
    if not IsQueriedTrainmanGroup(m_GroupArray[i]) then Continue;
    //获取当前交路的所有机组
    nLenGrid := Length(m_arrayGroupGrid);
    SetLength(m_arrayGroupGrid,nLenGrid + 1 );
    m_arrayGroupGrid[nLenGrid] := m_GroupArray[i] ;

    //获取要打印的人员班序  正常人员
    if m_GroupArray[i].GroupState = tsNormal then
    begin
      if (m_GroupArray[i].Trainman1.strTrainmanGUID = '') and
        (m_GroupArray[i].Trainman2.strTrainmanGUID = '') and
        (m_GroupArray[i].Trainman3.strTrainmanGUID = '') and
        (m_GroupArray[i].Trainman4.strTrainmanGUID = '') then
      begin
        //排除空的机组信息
        ;
      end
      else
      begin
        nLenPrint := Length(m_arrayGroupPrint);
        SetLength(m_arrayGroupPrint,nLenPrint + 1 );
        m_arrayGroupPrint[nLenPrint] := m_GroupArray[i] ;
      end;
    end;
  end;


  if length(m_GroupArray) = 0 then
    DrawGridGroups.RowCount := 1
  else
    DrawGridGroups.RowCount :=  length(m_arrayGroupGrid) ;
  //更新GRID
  DrawGridGroups.Invalidate;
end;




procedure TfrmMain_RenYuan.InitLeaveTrainmans;
var
  leaveTypes : TStrings;
  trainmanLeaveArray : TRsTrainmanLeaveArray;
  i: Integer;
begin
  leaveTypes := TStringList.Create;
  try
    for i := 0 to checkLstLeaveType.Count - 1 do
    begin
      if checkLstLeaveType.ItemChecked[i] then
      begin
        leaveTypes.Add(m_LeaveTypeArray[i].strTypeGUID);
      end;
    end;


    m_RsLCNameBoardEx.Trainman.GetUnRunByType(GlobalDM.SiteInfo.WorkShopGUID,leaveTypes,
        trainmanLeaveArray);
    lstBoxLeaveTrainmans.Items.Clear;
    m_TrainmanLeaveArray := trainmanLeaveArray;
    for i := 0 to length(m_TrainmanLeaveArray) - 1 do
    begin
      if not IsQueriedTrainman(m_TrainmanLeaveArray[i].Trainman) then Continue;
      lstBoxLeaveTrainmans.Items.Add(IntToStr(i));
    end;
  finally
    leaveTypes.Free;
  end;
end;

procedure TfrmMain_RenYuan.InitLeaveTypes;
var
  i : integer;
  ErrMsg: string;
begin
  checkLstLeaveType.Items.Clear;
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(m_LeaveTypeArray, ErrMsg) then
  begin
    exit;
  end;
  for i := 0 to length(m_LeaveTypeArray) - 1 do
  begin
    checkLstLeaveType.Items.Add(m_LeaveTypeArray[i].strTypeName);
  end;
end;

procedure TfrmMain_RenYuan.InitManaulPaiBan;
var
  tick : Cardinal;
begin
  tick := GetTickCount;
  InitTrainmanJiaolus;
  GlobalDM.LogManage.InsertLog('获取人员交路时间:' + IntToStr(GetTickCount-tick));
  tick := GetTickCount;
  InitGroups;
  GlobalDM.LogManage.InsertLog('获取机组时间:' + IntToStr(GetTickCount-tick));
end;

procedure TfrmMain_RenYuan.InitPrepare;
var
  i : integer;
  TrainmanJiaoluGUID : string;
begin
  for i := 0 to checklstTrainmanJiaoluPrepare.Count - 1 do
  begin
    if checklstTrainmanJiaoluPrepare.ItemChecked[i]   then
    begin
      TrainmanJiaoluGUID := m_TrainmanJiaoluPrepareArray[i].strTrainmanJiaoluGUID ;
      Break;
    end;
  end;

  lstPrepare.Items.Clear ;
  if TrainmanJiaoluGUID <> '' then
  begin
    SetLength(m_trainmanArrayPreapare,0);

    m_RsLCNameBoardEx.Trainman.GetPrepare(GlobalDM.SiteInfo.WorkShopGUID,TrainmanJiaoluGUID,m_trainmanArrayPreapare);

    for i := 0 to length(m_trainmanArrayPreapare) - 1 do
    begin
      if not IsQueriedPrepareTrainman(m_trainmanArrayPreapare[i]) then Continue;
      lstPrepare.Items.Add(IntToStr(i))
    end;
  end
end;

procedure TfrmMain_RenYuan.InitPrepareTrainmanJiaolus;
var
  i : integer;
  trainJiaoluGUID : string;
begin
  if  not GetSelectedTrainJiaolu(trainJiaoluGUID) then exit;
  checklstTrainmanJiaoluPrepare.Items.Clear;

  SetLength(m_TrainmanJiaoluPrepareArray,0);

  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(
    GlobalDM.SiteInfo.strSiteGUID,trainJiaoluGUID,m_TrainmanJiaoluPrepareArray);
  for i := 0 to length(m_TrainmanJiaoluPrepareArray) - 1 do
  begin
    checklstTrainmanJiaoluPrepare.Items.Add(m_TrainmanJiaoluPrepareArray[i].strTrainmanJiaoluName);
  end;
end;

procedure TfrmMain_RenYuan.InitStations;
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
  if not RsLCBaseDict.LCStation.GetStationsOfJiaoJu(trainJiaoluGUID,m_StationArray,strError) then
  begin
    Box(strError);
  end;

  SetLength(m_dutyPlaceList,0);
  m_webDutyPlace.GetDutyPlaceByJiaoLu(trainJiaoluGUID,m_dutyPlaceList,strError);
end;

procedure TfrmMain_RenYuan.InitTrainJiaolus;
var
  i,tempIndex:Integer;
  tab:TRzTabCollectionItem;
  TrainJiaoluItem :TRsTrainJiaoluItem;
begin
  tempIndex := tabTrainJiaolu.TabIndex;

  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);

  tabTrainJiaolu.Tabs.Clear;


  //添加要被观察的交路
  m_planManager.ClearTrainJiaoLu;
  for I := 0 to length(m_TrainJiaoluArray) - 1 do
  begin
    tab := tabTrainJiaolu.Tabs.Add;
    tab.Caption := m_TrainJiaoluArray[i].strTrainJiaoluName;
    tabTrainJiaolu.Tabs[i].Color := clRed ;
    TrainJiaoluItem := TRsTrainJiaoluItem.Create();
    with TrainJiaoluItem do
    begin
      JiaoLuGUID:= m_TrainJiaoluArray[i].strTrainJiaoluGUID;
      JiaoLuName:= m_TrainJiaoluArray[i].strTrainJiaoluName ;
    end;
    m_planManager.AddTrainJiaoLu(TrainJiaoluItem);

  end;


  if length(m_TrainJiaoluArray) > 0 then
  begin
    tabTrainJiaolu.TabIndex := 0;
    if (tempIndex > -1) and (tempIndex < tabTrainJiaolu.Tabs.Count) then
      tabTrainJiaolu.TabIndex := tempIndex;
  end;


end;

procedure TfrmMain_RenYuan.InitTrainmanJiaolus;
var
  bSelect:Boolean ;
  i : integer;
  trainJiaoluGUID : string;
  k: integer;
  selectJiaolus : TStringArray;
begin
  bSelect := False ;
  checklstTrainmanJiaolu.Items.Clear;
  if  not GetSelectedTrainJiaolu(trainJiaoluGUID) then exit;

  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(
    GlobalDM.SiteInfo.strSiteGUID,trainJiaoluGUID,m_TrainmanJiaoluArray);
  selectJiaolus :=  GlobalDM.SelectedTrainmanJiaolus;
  for i := 0 to length(m_TrainmanJiaoluArray) - 1 do
  begin
    checklstTrainmanJiaolu.Items.Add(m_TrainmanJiaoluArray[i].strTrainmanJiaoluName);
    for k := 0 to length(selectJiaolus) - 1 do
    begin
      if selectJiaolus[k] = m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID then
      begin
        checklstTrainmanJiaolu.ItemChecked[i] := true;
        bSelect := True ;
        break;
      end;
    end;
  end;

  // 如果没有一个人员交路匹配的话就匹配第一个
  if not bSelect then
  begin
    if checklstTrainmanJiaolu.Items.Count >0 then
      checklstTrainmanJiaolu.ItemChecked[0] := true;
  end;

end;

procedure TfrmMain_RenYuan.InitTrainmanPlan;
var
  dtBeginTime,dtEndTime : TDateTime;
  trainJiaoluGUID : string;
  trainmanPlanArray : TRsTrainmanPlanArray;
  nTotalCount,nTowHoursCount: Integer;
  strError:string;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;


  dtBeginTime := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  dtEndTime := dtBeginTime + 2;

  try

    if not m_webTrainPlan.GetTrainmanPlanFromSent(TrainJiaoluGUID,dtBeginTime,dtEndTime,trainmanPlanArray,strError)  then
    begin
      BoxErr(strError);
      Exit ;
    end;

    if GlobalDM.RoomRemind  then
    m_RemindCtl.SetPlanArray(TrainJiaoluGUID,trainmanPlanArray);


    if m_bSortByPlanState then
      m_TrainmanPlanArray := SortPlan(trainmanPlanArray)
    else
      m_TrainmanPlanArray := trainmanPlanArray ;


    RefreshTrainmanPlan();

    CalcPlanNoPublishCount(m_TrainmanPlanArray,nTotalCount,nTowHoursCount);
    
    tabTrainJiaolu.Tabs[tabTrainJiaolu.TabIndex].Caption :=
      m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluName +
      '['+inttoStr(nTowHoursCount) + '/' + IntToStr(nTotalCount) +']';
  except on e: exception do
    begin
      Box('获取计划信息失败：' + e.Message);
    end;
  end;
end;


function TfrmMain_RenYuan.IsGroupBusy(GroupGUID: string): boolean;
var
  trainmanPlan : RRsTrainmanPlan;
begin
  result := false;

  if m_RsLCNameBoardEx.Group.GetPlan(GroupGUID,trainmanPlan) then
  begin
    result := true;
    Box(Format('该人员所在的机组正在值乘计划:%s[%s],不能操作',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',trainmanPlan.TrainPlan.dtStartTime),trainmanPlan.TrainPlan.strTrainNo]));
    exit;
  end;
end;

function TfrmMain_RenYuan.IsGroupEmpty(Group: RRsGroup): boolean;
begin
  result := false  ;
  if (Group.Trainman1.strTrainmanGUID = '') and (Group.Trainman2.strTrainmanGUID = '') and
     (Group.Trainman3.strTrainmanGUID = '') and (Group.Trainman4.strTrainmanGUID = '') then
  begin
    result := true ;
    exit;
  end;
end;

function TfrmMain_RenYuan.IsQueriedPrepareTrainman(
  Trainman: RRsTrainman): boolean;
var
  bFlag : boolean;
begin
  result := false;
  if (Trim(edtTrainmanNumber3.Text) <> '') or (Trim(edtTrainmanName3.Text) <> '') or (Trim(edtPY3.Text) <> '') then
  begin    
    if (Trim(edtTrainmanNumber3.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or (Pos(Trim(edtTrainmanNumber3.Text),Trainman.strTrainmanNumber) > 0);
      if not bFlag then exit;
    end;
    if (Trim(edtTrainmanName3.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or (Pos(Trim(edtTrainmanName3.Text),Trainman.strTrainmanName) > 0);
      if not bFlag then exit;
    end;
    if (Trim(edtPY3.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or  (Pos(UpperCase(Trim(edtPY3.Text)),GlobalDM.GetHzPy(Trim(Trainman.strTrainmanName))) > 0);
      if not bFlag then exit;
    end;
  end;
  result := true;
end;

function TfrmMain_RenYuan.IsQueriedTrainman(Trainman: RRsTrainman): boolean;
var
  bFlag : boolean;
begin
  result := false;
  if (Trim(edtTrainmanNumber2.Text) <> '') or (Trim(edtTrainmanName2.Text) <> '') or (Trim(edtPY2.Text) <> '') then
  begin    
    if (Trim(edtTrainmanNumber2.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or (Pos(Trim(edtTrainmanNumber2.Text),Trainman.strTrainmanNumber) > 0);
      if not bFlag then exit;
    end;
    if (Trim(edtTrainmanName2.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or (Pos(Trim(edtTrainmanName2.Text),Trainman.strTrainmanName) > 0);
      if not bFlag then exit;
    end;
    if (Trim(edtPY2.Text) <> '')  then
    begin
      bFlag := false;
      bFlag := bFlag or  (Pos(UpperCase(Trim(edtPY2.Text)),GlobalDM.GetHzPy(Trim(Trainman.strTrainmanName))) > 0);
      if not bFlag then exit;
    end;
  end;
  result := true;
end;


function TfrmMain_RenYuan.IsQueriedTrainmanGroup(Group: RRsGroup): boolean;
begin
  result := false;
  if m_SelectUserInfo.strTrainmanGUID = '' then
  begin
    result := true;
    exit;
  end;
  
  if  (Group.Trainman1.strTrainmanGUID = m_SelectUserInfo.strTrainmanGUID) then
  begin
    result := true;
    exit;
  end;

  if  (Group.Trainman2.strTrainmanGUID = m_SelectUserInfo.strTrainmanGUID) then
  begin
    result := true;
    exit;
  end;
  if  (Group.Trainman3.strTrainmanGUID = m_SelectUserInfo.strTrainmanGUID) then
  begin
    result := true;
    exit;
  end;
  if  (Group.Trainman4.strTrainmanGUID = m_SelectUserInfo.strTrainmanGUID) then
  begin
    result := true;
    exit;
  end;      
end;

function TfrmMain_RenYuan.IsSubTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '副司机');
end;

function TfrmMain_RenYuan.IsTrainmanBusy(TrainmanNumber: string): boolean;
var
  trainmanPlan : RRsTrainmanPlan;
begin
  result := false;

  if m_RsLCNameBoardEx.Trainman.GetPlan(TrainmanNumber,trainmanPlan) then
  begin
    result := true;
    Box(Format('该人员所在的机组正在值乘计划:%s[%s],不能操作',
      [FormatDateTime('yyyy-MM-dd HH:nn:ss',trainmanPlan.TrainPlan.dtStartTime),trainmanPlan.TrainPlan.strTrainNo]));
    exit;
  end;
end;

function TfrmMain_RenYuan.IsTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '司机');
end;


function TfrmMain_RenYuan.IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员2') ;
end;

function TfrmMain_RenYuan.IsXueYuanTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员') ;
end;



procedure TfrmMain_RenYuan.miViewPlanLogClick(Sender: TObject);
var
  trainmanPlanCur : RRsTrainmanPlan;
begin
  try
    if not GetSelectedTrainmanPlan(trainmanPlanCur) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;
    TFrmTrainPlanChangeLog.ShowForm(trainmanPlanCur.TrainPlan.strTrainPlanGUID);
  except

  end;
end;

class procedure TfrmMain_RenYuan.LeavePaiBan;
begin
  GlobalDM.OnAppVersionChange := nil;
  //释放已硬件驱动
  if frmMain_RenYuan <> nil then
    FreeAndNil(frmMain_RenYuan);
end;

function TfrmMain_RenYuan.GetRunGroupSelectTM(var Trainman: RRsTrainman): Boolean;
var
  aCol: Integer;
  aRow: Integer;
begin
  Result := False;
  aRow := DrawGridGroups.Row;
  aCol := DrawGridGroups.Col;
  if aRow < 0 then
  begin
    Exit;
  end;

  case aCol of
    COLUMN_TRAINMAN1:
      begin
        Result := True;
        Trainman := m_arrayGroupGrid[arow].Trainman1;
      end;
    COLUMN_TRAINMAN2:
      begin
        Result := True;
        Trainman := m_arrayGroupGrid[arow].Trainman2;
      end;
    COLUMN_TRAINMAN3:
      begin
        Result := True;
        Trainman := m_arrayGroupGrid[arow].Trainman3;
      end;
    COLUMN_TRAINMAN4:
      begin
        Result := True;
        Trainman := m_arrayGroupGrid[arow].Trainman4;
      end;
  end;
end;



procedure TfrmMain_RenYuan.DrawGridGroupsClick(Sender: TObject);
begin
 // menuTrainmanInfoClick(Sender);
end;

procedure TfrmMain_RenYuan.DrawGridGroupsDblClick(Sender: TObject);
var
  trainmanPlan : RRsTrainmanPlan;
  group : RRsGroup;
  nIndex : integer;
begin

  if DrawGridGroups.Row < 0 then Exit;
  if Length(m_GroupArray) = 0 then Exit ;
  if length(m_arrayGroupGrid) = 0 then exit;
  
  if not GetSelectedTrainmanPlan(trainmanPlan) then Exit;

  nIndex := DrawGridGroups.Row ;
  group := m_arrayGroupGrid[nIndex];


  if not TBOX('您确定要把此机组安排到这个计划中吗?') then exit;

  m_LCPaiBan.SetGroup(trainmanPlan.TrainPlan.strTrainPlanGUID,group.strGroupGUID,GlobalDM.DutyUser);

  strGridTrainPlan.Invalidate;


  ShowStudentInfo(group);

  m_MealTicket.AddByGrp(Group,trainmanPlan,GlobalDM.DutyUser);

  PostMessage(Handle,WM_Refresh_Group,NIndex,0);

  InitTrainmanPlan();
end;

procedure TfrmMain_RenYuan.DrawGridGroupsDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  rectLastTime:TRect;
  rectDutyPlace:TRect;
  canvas:TCanvas;
  strTemp : string;
  r:TRect ;
  i,nIndex : integer;
  group : RRsGroup ;
begin
  //排除空集
  if Length(m_arrayGroupGrid) = 0 then
    Exit ;

  nIndex := ARow + 1;
  group :=  m_arrayGroupGrid[ARow];
  for i := 0 to length(m_GroupArray) - 1 do
  begin
    if m_GroupArray[i].strGroupGUID = group.strGroupGUID then
    begin
      nIndex := i + 1;
      break;
    end;
  end;
  
  canvas := DrawGridGroups.Canvas;
  Canvas.Brush.Color := clWindow;
  if ARow mod 2 = 1 then
    Canvas.Brush.Color := RGB(235,235,235);

  if gdSelected in State then
  begin
    Canvas.Brush.Color := RGB(251,235,136);
  end;
  canvas.FillRect(Rect);

  with DrawGridGroups do
  begin
    case ACol of
      //序号
      COLUMN_SEQNUMBER:
      begin
          //-----------------------------------画序号----------------------------------
        SetBkMode(Canvas.Handle,TRANSPARENT);
        Canvas.Font.Color := clBlack;
        Canvas.Font.Size := 9;
        strTemp :=  IntToStr(nIndex);
        r := Rect ;
        Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
      end;
      COLUMN_STATE:
      begin
        SetBkMode(Canvas.Handle,TRANSPARENT);
        strTemp :=  TRsTrainmanStateNameAry[group.GroupState];
        Canvas.TextRect(Rect,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
      end;
      COLUMN_TRAINMAN1:
      begin
        DrawTrainmanInfo(Canvas,Rect,group.Trainman1,
          group.dtLastInRoomTime1,group.dtLastOutRoomTime1);
      end;
      COLUMN_TRAINMAN2:
      begin
        DrawTrainmanInfo(Canvas,Rect,group.Trainman2,
          group.dtLastInRoomTime2,group.dtLastOutRoomTime2);
      end;
      COLUMN_TRAINMAN3:
      begin
        DrawTrainmanInfo(Canvas,Rect,group.Trainman3,
          group.dtLastInRoomTime3,group.dtLastOutRoomTime3);
      end;
      COLUMN_TRAINMAN4:
      begin
        DrawTrainmanInfo(Canvas,Rect,group.Trainman4,
          group.dtLastInRoomTime4,group.dtLastOutRoomTime4);
      end;
      COLUMN_LAST_ARRIVE_TIME:
      begin
        SetBkMode(Canvas.Handle,TRANSPARENT);
        strTemp :=  FormatDateTime('yyyy-MM-dd HH:mm',group.dtArriveTime) ;

        rectDutyPlace := Rect;
        rectDutyPlace.Top := Rect.Top + 2;
        rectDutyPlace.Bottom := Rect.Top - 1  + ( Rect.Bottom - Rect.Top ) div  2;
        Canvas.TextRect(rectDutyPlace,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);

        strTemp := group.place.placeName ;
        rectLastTime := Rect;
        rectLastTime.Top := Rect.Top + 1 + ( Rect.Bottom - Rect.Top ) div  2;
        rectLastTime.Bottom := Rect.Bottom  ;
        Canvas.TextRect(rectLastTime,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
      end;
    end;
  end;
end;

procedure TfrmMain_RenYuan.DrawGridGroupsMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button = mbleft then
    ;//DrawGridGroups.BeginDrag(False, 10);
end;

procedure TfrmMain_RenYuan.DrawGridGroupsMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  col,row,i : integer;
  pt : TPoint;
  Trainman: RRsTrainman;
begin
  if Button = mbRight then
  begin
    DrawGridGroups.MouseToCell(X,Y,col,row);
    if col > 0 then
    begin
      DrawGridGroups.Col := col;
    end;
    if row > 0 then
      DrawGridGroups.Row := row;

    for I := 0 to pmenuGroupRun.Items.Count - 1 do
    begin
      pmenuGroupRun.Items.Items[i].Enabled := true;
    end;


    if ( DrawGridGroups.Col = COLUMN_TRAINMAN1 ) or
      ( DrawGridGroups.Col = COLUMN_TRAINMAN2 ) or
      ( DrawGridGroups.Col = COLUMN_TRAINMAN3 ) or
      ( DrawGridGroups.Col = COLUMN_TRAINMAN4 )
    then
    begin

      if GetRunGroupSelectTM(Trainman) then
      begin
        miShowKeyMan.Enabled := Trainman.bIsKey <> 0;
      end
      else
        miShowKeyMan.Enabled := False;
        
      DrawGridGroups.MouseToCell(X,Y,col,row);
      pt := Point(X,Y);
      pt := DrawGridGroups.ClientToScreen(pt);
      pmenuGroupRun.Popup(pt.X,pt.y);
    end;
  end;
end;

procedure TfrmMain_RenYuan.DrawGridGroupsStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin

  if DrawGridGroups.Row < 0 then exit;
  DragObject := TGroupDragObject.Create();
  TGroupDragObject(DragObject).GroupInfo := m_arrayGroupGrid[DrawGridGroups.Row];

end;

procedure TfrmMain_RenYuan.DrawLeaveTrainman(Canvas: TCanvas; StartTop,
  StartLeft: integer; Trainman: RRsTrainman);
var
  r : TRect;
  strTemp : string;
begin
  SetBkMode(Canvas.Handle,TRANSPARENT);
  Canvas.Pen.Color := clGray;
  Canvas.Pen.Style := psdot;
  Canvas.MoveTo(StartLeft,StartTop + 5);
  Canvas.LineTo(StartLeft,StartTop + 35);
  //画正司机名字
  Canvas.Font.Size := 12;
  Canvas.Font.Color := clBlack;
  r := classes.Rect(StartLeft +20,StartTop + 5,StartLeft + 180,StartTop + 35);
  strTemp := GetTrainmanText(Trainman);
  Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
end;


procedure TfrmMain_RenYuan.DrawPrepareTrainman(Canvas: TCanvas; StartTop,
  StartLeft: integer; Trainman: RRsTrainman);
var
  r : TRect;
  strTemp : string;
begin
  SetBkMode(Canvas.Handle,TRANSPARENT);
  //Canvas.Pen.Color := clGray;
  //Canvas.Pen.Style := psdot;
  //Canvas.MoveTo(StartLeft,StartTop + 5);
  //Canvas.LineTo(StartLeft,StartTop + 35);
  //画正司机名字
  Canvas.Font.Size := 12;
  Canvas.Font.Color := clBlack;
  r := classes.Rect(StartLeft +20,StartTop + 5,StartLeft + 180,StartTop + 35);
  strTemp := GetTrainmanText(Trainman);
  Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
end;

procedure TfrmMain_RenYuan.DrawTrainmanInfo(Canvas: TCanvas; Rect: TRect;
  Trainman: RRsTrainman;InRoomTime,OutRoomTime : TDateTime);
var
  r : TRect;
  rectMan:TRect;
  rectTime:TRect;
  strTemp,strInRoomTime : string;
begin
  SetBkMode(Canvas.Handle,TRANSPARENT);
  //画正司机名字
  Canvas.Font.Size := 9;
  Canvas.Font.Color := clBlack;
  r := Rect ;
  strTemp := GetTrainmanText(Trainman);
  rectMan := Rect;
  rectMan.Top := Rect.Top + 2;
  rectMan.Bottom := Rect.Top - 1  + ( Rect.Bottom - Rect.Top ) div  2;

  if Trainman.bIsKey <> 0 then
    Canvas.Font.Color := $005172F4
  else
    Canvas.Font.Color := clBlack;

  Canvas.TextRect(rectMan,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  //画正司机入寓时间
  strInRoomTime := '';

  if HourOf(m_dtNow) < 11 then
  begin
    if (InRoomTime > 0) and (InRoomTime > IncHour(m_dtNow,-24)) then
    begin
      if OutRoomTime > InRoomTime then
        strInRoomTime := '寓休:' + FormatDateTime('HH时nn',OutRoomTime - InRoomTime )
      else
       strInRoomTime := '入寓:'+   FormatDateTime('dd日HH时nn',InRoomTime) ;
    end;
  end else begin
    if (InRoomTime > 0) and (DateOf(InRoomTime) = DateOf(m_dtNow)) then
    begin
      if OutRoomTime > InRoomTime then
        strInRoomTime := '寓休:'+  FormatDateTime('HH时nn',OutRoomTime - InRoomTime )
      else
       strInRoomTime :=  '入寓:'+  FormatDateTime('dd日HH时nn',InRoomTime) ;
    end;

  end;

  if strInRoomTime <> '' then
  begin
    Canvas.Font.Color := clBlue;
    Canvas.Font.Size := 9;
    r := Rect;
    rectTime := Rect;
    rectTime.Top := Rect.Top + 1 + ( Rect.Bottom - Rect.Top ) div  2;
    rectTime.Bottom := Rect.Bottom  ;
    Canvas.TextRect(rectTime,strInRoomTime,[tfSingleLine,tfCenter,tfVerticalCenter]);
  end;
end;


procedure TfrmMain_RenYuan.lstBoxLeaveTrainmansDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  nIndex : integer;
  r : TRect;
  strTemp : string;
begin
  //获取当前数据的索引
  nIndex := StrToInt(lstBoxLeaveTrainmans.Items[Index]);
  //画背景色,隔行变色
  lstBoxLeaveTrainmans.Canvas.Brush.Color := clWindow;
  if (nIndex mod 2) = 1 then
  begin
    lstBoxLeaveTrainmans.Canvas.Brush.Color := RGB(235,235,235);
  end;
    if odSelected in State then
  begin
    lstBoxLeaveTrainmans.Canvas.Brush.Color := RGB(251,235,136);
  end;
  lstBoxLeaveTrainmans.Canvas.FillRect(Rect);

  //-----------------------------------画序号----------------------------------
  SetBkMode(lstBoxLeaveTrainmans.Canvas.Handle,TRANSPARENT);
  lstBoxLeaveTrainmans.Canvas.Font.Color := clBlack;
  lstBoxLeaveTrainmans.Canvas.Font.Size := 12;
  strTemp :=  IntToStr(nIndex + 1);
  r := classes.Rect(Rect.Left,Rect.Top,Rect.Left + 65,Rect.Bottom);
  lstBoxLeaveTrainmans.Canvas.Brush.Color := clBtnFace;
  lstBoxLeaveTrainmans.Canvas.FillRect(r);
  lstBoxLeaveTrainmans.Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  //-------------------------------画请假类型--------------------------------------
  SetBkMode(lstBoxLeaveTrainmans.Canvas.Handle,TRANSPARENT);
  strTemp :=  m_TrainmanLeaveArray[nIndex].strLeaveTypeName;
  r := classes.Rect(Rect.Left + 65,Rect.Top,Rect.Left + 180,Rect.Bottom);
  lstBoxLeaveTrainmans.Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  //-------------------------------画请假司机信息----------------------------
  DrawLeaveTrainman(lstBoxLeaveTrainmans.Canvas,Rect.Top,Rect.Left + 180,m_TrainmanLeaveArray[nIndex].Trainman);
  //画分割线
  lstBoxLeaveTrainmans.Canvas.Pen.Color := RGB(204,204,204);
  lstBoxLeaveTrainmans.Canvas.Pen.Style := psdot;
  lstBoxLeaveTrainmans.Canvas.MoveTo(Rect.Left +5,Rect.Bottom - 1);
  lstBoxLeaveTrainmans.Canvas.LineTo(Rect.Right -5,Rect.Bottom - 1);
end;

procedure TfrmMain_RenYuan.lstPrepareDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  nIndex : integer;
  r : TRect;
  strTemp : string;
begin
  //获取当前数据的索引
  nIndex := StrToInt(lstPrepare.Items[Index]);
  //画背景色,隔行变色
  lstPrepare.Canvas.Brush.Color := clWindow;
  if (nIndex mod 2) = 1 then
  begin
    lstPrepare.Canvas.Brush.Color := RGB(235,235,235);
  end;
    if odSelected in State then
  begin
    lstPrepare.Canvas.Brush.Color := RGB(251,235,136);
  end;
  lstPrepare.Canvas.FillRect(Rect);

  //-----------------------------------画序号----------------------------------
  SetBkMode(lstPrepare.Canvas.Handle,TRANSPARENT);
  lstPrepare.Canvas.Font.Color := clBlack;
  lstPrepare.Canvas.Font.Size := 12;
  strTemp :=  IntToStr(nIndex + 1);
  r := classes.Rect(Rect.Left,Rect.Top,Rect.Left + 65,Rect.Bottom);
  lstPrepare.Canvas.Brush.Color := clBtnFace;
  lstPrepare.Canvas.FillRect(r);
  lstPrepare.Canvas.TextRect(r,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);

  //-------------------------------画请假司机信息----------------------------
  DrawPrepareTrainman(lstPrepare.Canvas,Rect.Top,Rect.Left + 180,m_trainmanArrayPreapare[nIndex]);
  //画分割线
  lstPrepare.Canvas.Pen.Color := RGB(204,204,204);
  lstPrepare.Canvas.Pen.Style := psdot;
  lstPrepare.Canvas.MoveTo(Rect.Left +5,Rect.Bottom - 1);
  lstPrepare.Canvas.LineTo(Rect.Right -5,Rect.Bottom - 1);
end;

procedure TfrmMain_RenYuan.lstPrepareMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  pt : TPoint;
begin
  if Button = mbRight then
  begin
    //右键也选中状态
    lstPrepare.Perform(WM_LBUTTONDOWN,0,MakelParam(x,y));
    begin
      pt := Point(X,Y);
      pt := lstPrepare.ClientToScreen(pt);
      menuTrainmanInfo.Enabled := false;
      menuSetTrainman.Enabled := false;
      miDeleteTrainmanFromGroup.Enabled := false;
      mniDelEmptyGroup.Enabled := false;
      miEditArriveTime.Enabled := false;
      mniDelEmptyGroup.Enabled := false;
      miExchangeGroup.Enabled := false;
      miClearArriveTime.Enabled := false;
      miClearFromBoard.Enabled := true;
      miShowKeyMan.Enabled := False;
      pmenuGroupRun.Popup(pt.X,pt.y);
    end;
  end;
end;

procedure TfrmMain_RenYuan.lstviewMsgAdvancedCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  Stage: TCustomDrawStage; var DefaultDraw: Boolean);
begin
  if Item.Caption = '更新' then
  begin
    Sender.Canvas.Brush.Color := clRed ;
  end;
end;

procedure TfrmMain_RenYuan.miAskForLeaveClick(Sender: TObject);
begin
  TFrmLeaveQuery.ShowForm;
end;


procedure TfrmMain_RenYuan.miClearArriveTimeClick(Sender: TObject);
var
  group : RRsGroup;
  nIndex : integer;
  JLInput: TRsLCBoardInputJL;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin

  if DrawGridGroups.Row < 0 then Exit;

  if not GetSelectTmJL(TrainmanJiaolu) then
  begin
    Box('请选中人员交路!');
    Exit;
  end;

  nIndex := DrawGridGroups.Row ;
  group := m_arrayGroupGrid[nIndex];
  if not TBox('确认清除最近到达时间吗?') then
    Exit;



  JLInput := TRsLCBoardInputJL.Create;
  try
    JLInput.SetTrainmanJL(TrainmanJiaolu);

    m_RsLCNameBoardEx.Group.ClearArriveTime(group.strGroupGUID,group.dtArriveTime,m_DutyUser,JLInput);
  finally
    JLInput.Free;
  end;



  Box('修改成功!');
  InitGroups;
end;

procedure TfrmMain_RenYuan.miClearFromBoardClick(Sender: TObject);
begin
//  if PageControl1.ActivePageIndex = 2 then
//  begin
//    if lstPrepare.ItemIndex < 0 then exit;
//    if not TBox('您确定要将此人员从名牌中移出吗？') then exit;
//    m_RsLCNameBoardEx.Trainman.SetStateToNull(m_trainmanArrayPreapare[lstPrepare.ItemIndex].strTrainmanNumber);
//    InitPrepare;
//  end;
end;

procedure TfrmMain_RenYuan.miDeleteTrainmanFromGroupClick(Sender: TObject);
var
  nRow,nCol:Integer ;
  nTrainmanIndex : integer;
  trainman : RRsTrainman;
  group : RRsGroup;
  trainmanJiaoLu : RRsTrainmanJiaolu;
  Input: TRsLCTrainmanAddInput;  
begin
  nRow := DrawGridGroups.Row ;
  nCol := DrawGridGroups.Col ;
  if nRow < 0 then Exit ;
  group := m_arrayGroupGrid[nRow];
  nTrainmanIndex := 1;
  case nCol of
   COLUMN_TRAINMAN1 :
    begin
      trainman := m_arrayGroupGrid[nRow].Trainman1 ;
      nTrainmanIndex := 1;
    end;
   COLUMN_TRAINMAN2 :
    begin
      trainman := m_arrayGroupGrid[nRow].Trainman2 ;
      nTrainmanIndex := 2;
    end;
   COLUMN_TRAINMAN3 :
    begin
      trainman := m_arrayGroupGrid[nRow].Trainman3 ;
      nTrainmanIndex := 3;
    end;
   COLUMN_TRAINMAN4 :
    begin
      trainman := m_arrayGroupGrid[nRow].Trainman4 ;
      nTrainmanIndex := 4;
    end;
  end;

  if trainman.strTrainmanGUID = '' then Exit ;

  if IsTrainmanBusy(trainman.strTrainmanNumber) then exit;


  if not TBox('您确定要删除此乘务员吗？') then exit;

  Input := TRsLCTrainmanAddInput.Create;
  try
    m_RsLCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(group.strGroupGUID,trainmanjiaolu);
    Input.TrainmanJiaolu.SetTrainmanJL(trainmanjiaolu);
    Input.DutyUser.Assign(m_DutyUser);
    Input.TrainmanNumber := trainman.strTrainmanNumber;
    Input.TrainmanIndex := nTrainmanIndex;
    Input.GroupGUID :=  group.strGroupGUID;

    m_RsLCNameBoardEx.Group.DeleteTrainman(Input);
  finally
    Input.Free;
  end;

  InitGroups ;
end;

procedure TfrmMain_RenYuan.miEditArriveTimeClick(Sender: TObject);
var
  group : RRsGroup;
  nIndex : integer;
  LastArriveTime : TDateTime;
  JLInput: TRsLCBoardInputJL;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  if DrawGridGroups.Row < 0 then Exit;

  nIndex := DrawGridGroups.Row ;
  group := m_arrayGroupGrid[nIndex];
  LastArriveTime := Group.dtArriveTime ;

  if not GetSelectTmJL(TrainmanJiaolu) then
  begin
    Box('请选中人员交路!');
    Exit;
  end;


  if TFrmGetDateTime.GetDateTime(LastArriveTime) then
  begin
    if not TBox('确定修改退勤时间吗?') then
      Exit ;

      JLInput := TRsLCBoardInputJL.Create;
      try
        JLInput.SetTrainmanJL(TrainmanJiaolu);
        
        m_RsLCNameBoardEx.Group.UpdateArriveTime(group.strGroupGUID,group.dtArriveTime,LastArriveTime,m_DutyUser,JLInput);
      finally
        JLInput.Free;
      end;


      InitGroups;
      Box('修改成功');
  end;
end;

procedure TfrmMain_RenYuan.miLeaveTypeClick(Sender: TObject);
begin
  TFrmLeaveTypeMgr.ShowLeaveTypeMgrForm;
end;

procedure TfrmMain_RenYuan.miLoadPlanClick(Sender: TObject);
var
  dt, dtBeginTime, dtEndTime: TDateTime;
  strMsg: string;
  strTrainJiaoluGUID : string;
  error:string;
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
    if not m_webTrainnos.Load(strTrainJiaoluGUID,dtBeginTime,dtEndTime,Ord(psReceive),error) then
     begin
      BoxErr(error);
      Exit ;
    end;
    InitTrainmanPlan();
  except on e: exception do
    begin
      Box(Format('从图定车次表中加载计划错误：%s', [e.Message]));
    end;
  end;
end;

procedure TfrmMain_RenYuan.miModifyPasswordClick(Sender: TObject);
begin
 TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_RenYuan.miPopManulBeginWorkClick(Sender: TObject);
var
  trainman : RRsTrainman;
  trainmanIndex : integer;
  trainmanPlan : RRsTrainmanPlan;
  ErrInfo: string;
begin
  try
    if not GetSelectedTrainman(trainman,trainmanIndex) then exit;
    if not GetSelectedTrainmanPlan(trainmanPlan) then exit;
   
    if not TBox('您确定要移除此人员吗?') then exit;


    if not m_webTrainPlan.RemoveTrainman(trainman.strTrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,
    trainmanPlan.Group.strGroupGUID,trainmanIndex,ErrInfo) then
    begin
      Box(ErrInfo);
      Exit;
    end;

    InitTrainmanPlan();
    InitGroups;
  except on e : exception do
    begin
      BoxErr('操作异常：' + e.Message);
    end;
  end;
end;

procedure TfrmMain_RenYuan.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(strGridTrainPlan,'TrainmanPlan');
end;

procedure TfrmMain_RenYuan.miShowKeyManClick(Sender: TObject);
var
  Trainman: RRsTrainman;
begin
  if not GetRunGroupSelectTM(Trainman) then Exit;

    
  TFrmKeyTrainmanView.View(Trainman.strTrainmanNumber)
end;

procedure TfrmMain_RenYuan.miTrainmanDetailClick(Sender: TObject);
var
  trainman : RRsTrainman;
  trainmanIndex : integer;
  selectCol : Integer;
begin
  if (strGridTrainPlan.Row = 0) or (length(m_TrainmanPlanArray)  = 0) then exit;
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if IsTrainmanCol(selectCol) or
    IsSubTrainmanCol(selectCol) or
    IsXueYuanTrainmanCol(selectCol) or
    IsXueYuan2TrainmanCol(selectCol) then
  begin
    if not GetSelectedTrainman(trainman,trainmanIndex) then exit;
    if TfrmTrainmanDetail.ViewTrainmanDetail(trainman.strTrainmanGUID) then
      TtfPopBox.ShowBox('修改成功');
  end;
end;

procedure TfrmMain_RenYuan.miTrainNoClick(Sender: TObject);
begin
  TfrmTrainNo.ManageTrainNo;
end;

procedure TfrmMain_RenYuan.miViewTrainmanClick(Sender: TObject);
begin
//
end;

procedure TfrmMain_RenYuan.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_RenYuan.mTrainmanManageClick(Sender: TObject);
begin
  TfrmTrainmanManage.OpenTrainmanQuery;
end;


procedure TfrmMain_RenYuan.miAddSubPlanClick(Sender: TObject);
var
  TrainmanPlan: RRsTrainmanPlan;
  subPlan: RRsTrainmanPlan;
begin
  if Not GetSelectedTrainmanPlan(TrainmanPlan) then
  begin
    Box('请选择计划!');
    Exit;
  end;

  if not (TBox('您确认要添加附挂计划吗？')) then exit;
  
  subPlan.TrainPlan.Clone(TrainmanPlan.TrainPlan);
  subPlan.TrainPlan.strTrainPlanGUID := NewGUID;
  subPlan.TrainPlan.strMainPlanGUID := TrainmanPlan.TrainPlan.strTrainPlanGUID;
  subPlan.TrainPlan.nPlanState := psSent;
  subPlan.TrainPlan.nDragType := pdtFujia;
  
  AddNewPlan(subPlan);
  InitTrainmanPlan();
end;

procedure TfrmMain_RenYuan.miRemoveGroupClick(Sender: TObject);
var
  strError:string;
  trainmanPlan : RRsTrainmanPlan;
begin
  try
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请选择您要操作的计划！');
      exit;
    end;

    if not TBox('您确定要将此机组从计划中移除吗？') then exit;
    //移除机组
    if not  m_webTrainPlan.RemoveGroup(trainmanPlan.Group.strGroupGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,
      strError)  then
    begin
      BoxErr(strError);
      Exit ;
    end;

    m_MealTicket.DelByGrp(trainmanPlan.Group,trainmanPlan);

    PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_RMGROUP,trainmanPlan.TrainPlan.strTrainPlanGUID);
    TtfPopBox.ShowBox('移除机组成功！');
    InitTrainmanPlan;
    InitGroups;
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.miRemoveTrainmanClick(Sender: TObject);
var
  strError:string;
  trainman : RRsTrainman;
  trainmanIndex : integer;
  trainmanPlan : RRsTrainmanPlan;
begin
  try

    if not GetSelectedTrainman(trainman,trainmanIndex) then
    begin
      TtfPopBox.ShowBox('请先选择乘务员！');
      exit;
    end;
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;

    if not TBox('您确定移除人员吗？') then exit;

    //移除人员
    if not  m_webTrainPlan.RemoveTrainman(trainman.strTrainmanGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,
      trainmanPlan.Group.strGroupGUID,trainmanIndex,strError)  then
    begin
      BoxErr(strError);
      Exit ;
    end;

   m_MealTicket.DelByTM(trainman.strTrainmanNumber,trainmanPlan);
   

    PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_RMTRAINMAN,trainmanPlan.TrainPlan.strTrainPlanGUID);
    TtfPopBox.ShowBox('移除人员成功！');

    InitTrainmanPlan;
    InitGroups;
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.N19Click(Sender: TObject);
begin
  //清空
  SetLength(m_listGroupEast,0);
  SetLength(m_listGroupWeast,0);
  //重新获取
  GetEastHuo(m_listGroupEast);
  GetWeastHuo(m_listGroupWeast);

  //开始打印
  PrintHuoCheBanXu();

end;

procedure TfrmMain_RenYuan.N21Click(Sender: TObject);
begin
  TfrmTMRptSelect.Config;
end;

procedure TfrmMain_RenYuan.N25Click(Sender: TObject);
var
  trainman : RRsTrainman;
  trainmanIndex : integer;
  trainmanPlan : RRsTrainmanPlan;
begin
  try

    if not GetSelectedTrainman(trainman,trainmanIndex) then
    begin
      TtfPopBox.ShowBox('请先选择乘务员！');
      exit;
    end;
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;

    if m_LCBeginwork.IsBeginWorking(trainman.strTrainmanGUID,
      trainmanPlan.TrainPlan.strTrainPlanGUID) then
    begin
      TtfPopBox.ShowBox('该乘务员已经出勤不能移除！');
      exit;
    end;

    if not TBox('您确定移除该人员的饭票吗?') then exit;
    m_MealTicket.DelByTM(trainman.strTrainmanNumber,trainmanPlan);
    TtfPopBox.ShowBox('移除饭票成功！');
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.N26Click(Sender: TObject);
begin
  TFrmViewMealTicketLog.showForm();
end;

procedure TfrmMain_RenYuan.N27Click(Sender: TObject);
var
  trainman : RRsTrainman;
  trainmanIndex : integer;
  trainmanPlan : RRsTrainmanPlan;
  nCanQuanA:Integer;
  nCanQuanB:Integer;
  nCanQuanC:Integer;
  TrainmanNumber:string;
begin
  try

    if not GetSelectedTrainman(trainman,trainmanIndex) then
    begin
      TtfPopBox.ShowBox('请先选择乘务员！');
      exit;
    end;
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;


    nCanQuanA := 0;
    nCanQuanB := 0;
    nCanQuanC := 0 ;

    if m_MealTicket.IsGivedTicket(trainman.strTrainmanNumber,TrainmanPlan,nCanQuanA,nCanQuanB,nCanQuanC) then
    begin
      TtfPopBox.ShowBox('该乘务员已经领取过饭票不能修改！');
      exit;
    end;
    

    if not TFrmTicketModify.GetTicket(nCanQuanA,nCanQuanB,nCanQuanC) then Exit;
   //修改饭票
   TrainmanNumber:= trainman.strTrainmanNumber ;
    if m_MealTicket.ModifyMealTicket(TrainmanNumber,TrainmanPlan,nCanQuanA,nCanQuanB,nCanQuanC) then
    begin
     TtfPopBox.ShowBox('饭票修改成功！');
    end
    else
     TtfPopBox.ShowBox('不存在饭票信息！');
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.N29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_RenYuan.mniChangePrevGroupClick(Sender: TObject);
var
  trainmanPlanCur : RRsTrainmanPlan;
  trainmanPlanPrev:RRsTrainmanPlan;
begin
  try
    //如果是第一组就退出
    if strGridTrainPlan.Row = 1 then exit;
    trainmanPlanCur := m_TrainmanPlanArray[strGridTrainPlan.row - 1];
    trainmanPlanPrev := m_TrainmanPlanArray[strGridTrainPlan.row - 2 ];

    //是已经出勤状态或者退勤状态
    if ( trainmanPlanCur.TrainPlan.nPlanState = psBeginWork ) or
     ( trainmanPlanCur.TrainPlan.nPlanState = psEndWork  )   or
     ( trainmanPlanPrev.TrainPlan.nPlanState = psBeginWork ) or
     ( trainmanPlanPrev.TrainPlan.nPlanState = psEndWork  )
    then
    begin
      Exit;
    end;

    if IsGroupEmpty(trainmanPlanCur.Group) or IsGroupEmpty(trainmanPlanPrev.Group) then
      Exit ;


    if not TBox('确定和下面一组人员互换吗?') then
      Exit;

      m_LCPaiBan.ExchangeGroup(trainmanPlanCur.Group.strGroupGUID,trainmanPlanPrev.Group.strGroupGUID,GlobalDM.DutyUser);
      

    InitTrainmanPlan;
    InitGroups;
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.mniDelEmptyGroupClick(Sender: TObject);
var
  trainmanPlan : RRsTrainmanPlan;
  group : RRsGroup;
  nIndex : integer;
  strGroupGUID  : string;
  GruopOld:RRsGroup;
  trainmanjiaolu : RRsTrainmanJiaolu;
  ErrInfo: string;
  JLInput: TRsLCBoardInputJL;
begin

  if Length(GlobalDM.SelectedTrainmanJiaolus) <= 0then
    exit ;

  if DrawGridGroups.Row < 0 then Exit;

  nIndex := DrawGridGroups.Row ;
  group := m_arrayGroupGrid[nIndex];
  if  ( group.Trainman1.strTrainmanGUID = '' ) and
  ( group.Trainman2.strTrainmanGUID = '' ) and
  ( group.Trainman3.strTrainmanGUID = '' ) and
   ( group.Trainman4.strTrainmanGUID = '') then
  begin
    strGroupGUID := group.strGroupGUID;
    if strGroupGUID = '' then
    begin
      BoxErr('机组为空名字!');
      Exit ;
    end;
    if not TBox('确认删除空机组吗') then
      Exit;
    //删除已经安排计划的空机组
    if trainmanPlan.TrainPlan.strTrainPlanGUID <> '' then
    begin
      if not m_webTrainPlan.RemoveGroup(strGroupGUID,trainmanPlan.TrainPlan.strTrainPlanGUID,ErrInfo) then
      begin
        BoxErr(ErrInfo);
        Exit;
      end;
    end;



    if not m_RsLCNameBoardEx.Group.GetGroup(strGroupGUID,GruopOld) then
    begin
      BoxErr('获取机组信息失败!');
      Exit;
    end;


    m_RsLCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(group.strGroupGUID,trainmanjiaolu);

    JLInput := TRsLCBoardInputJL.Create;
    try
      JLInput.SetTrainmanJL(trainmanjiaolu);
      m_RsLCNameBoardEx.Group.Delete(JLInput,group.strGroupGUID,m_DutyUser);
    finally
      JLInput.Free;
    end;

    Box('删除成功!');
    InitGroups;
  end
  else
    BoxErr('不能非空机组');
end;

procedure TfrmMain_RenYuan.N35Click(Sender: TObject);
begin
  ExportTrainPlan(m_TrainjiaoluArray);
end;

procedure TfrmMain_RenYuan.N37Click(Sender: TObject);
begin
  TfrmViewGroupOrder.Open;
end;

procedure TfrmMain_RenYuan.N3Click(Sender: TObject);
var
  plan:RRsTrainmanPlan;
  guids:TStrings;
begin
  if GetSelectedTrainmanPlan(plan)= True then
  begin
    if( plan.TrainPlan.nPlanState >= psSent) and (plan.TrainPlan.nPlanState < psBeginWork) then
    begin
      if TfrmSetRest.SetPlanRestInfo(plan) = True then
      begin
        guids:=TStringList.Create;
        try
          m_TrainmanPlanArray[strGridTrainPlan.Row-1].RestInfo := plan.RestInfo;
          AddRTrainmanPlanToControl(plan,strGridTrainPlan.Row-1);
          guids.Add(plan.TrainPlan.strTrainPlanGUID);
          PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_WAITWORK,guids);
        finally
          guids.Free;
        end;
      end;
    end;
  end;
end;

procedure TfrmMain_RenYuan.N41Click(Sender: TObject);
var
  group : RRsGroup;
  nIndex : integer;
    JLInput: TRsLCBoardInputJL;
  TrainmanJiaolu: RRsTrainmanJiaolu;
begin
  if DrawGridGroups.Row < 0 then Exit;

  if not GetSelectTmJL(TrainmanJiaolu) then
  begin
    Box('请选中人员交路!');
    Exit;
  end;
  nIndex := DrawGridGroups.Row ;
  group := m_GroupArray[nIndex];
  if not TBox('确认清除最近到达时间吗?') then
    Exit;


    JLInput := TRsLCBoardInputJL.Create;
  try
    JLInput.SetTrainmanJL(TrainmanJiaolu);
    m_RsLCNameBoardEx.Group.ClearArriveTime(group.strGroupGUID,group.dtArriveTime,m_DutyUser,JLInput);
  finally
    JLInput.Free;
  end;



  Box('修改成功!');
  InitGroups;

end;

procedure TfrmMain_RenYuan.N42Click(Sender: TObject);
var
  trainman : RRsTrainman;
  trainmanIndex : integer;
  trainmanPlan : RRsTrainmanPlan;
begin
  try
    if not GetSelectedTrainman(trainman,trainmanIndex) then
    begin
      TtfPopBox.ShowBox('请先选择乘务员！');
      exit;
    end;
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;

    PostAddCallWorkMessage(trainman,trainmanPlan,TCT_PHONE);
    InitTrainmanPlan ;
  finally

  end;
end;

procedure TfrmMain_RenYuan.N43Click(Sender: TObject);
var
  trainmanPlan : RRsTrainmanPlan;
begin
  try
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;

    with trainmanPlan.Group do
    begin
      if Trainman1.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman1,trainmanPlan,TCT_PHONE);
      if Trainman2.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman2,trainmanPlan,TCT_PHONE);
      if Trainman3.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman3,trainmanPlan,TCT_PHONE);
      if Trainman4.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman4,trainmanPlan,TCT_PHONE);
    end;

    InitTrainmanPlan ;

  finally

  end;
end;

procedure TfrmMain_RenYuan.N47Click(Sender: TObject);
begin
 TFrmMealTicketConfig.Config;
end;

procedure TfrmMain_RenYuan.miPrintBDClick(Sender: TObject);
var
  tmplan:RRsTrainmanPlan;
  chuqinPlan1,chuqinPlan2:RRSChuQinPlan;
  strErr:string;
begin
  if GetSelectedTrainmanPlan(tmplan) = False then
  begin
    box('未选中有效计划');
    Exit;
  end;
  chuqinPlan1.TrainPlan := tmplan.TrainPlan;
  chuqinPlan1.ChuQinGroup.Group := tmplan.Group;
  
  if TPrintTMReport.PrintRpt(LeftStr(GlobalDM.SiteInfo.strSiteIP,2),chuqinPlan1,chuqinPlan2,strErr)= False then
  begin
    Box(strErr);
  end;

end;
procedure TfrmMain_RenYuan.N50Click(Sender: TObject);
begin
  TFrmMainTemeplateTrainNo.ManagerTemeplateTrainNo(True);
end;

procedure TfrmMain_RenYuan.N51Click(Sender: TObject);
var
  FrmAnnualLeave: TFrmAnnualLeave;
begin
  FrmAnnualLeave := TFrmAnnualLeave.Create(nil);
  try
    FrmAnnualLeave.ShowModal;
  finally
    FrmAnnualLeave.Free;
  end;
end;
procedure TfrmMain_RenYuan.N53Click(Sender: TObject);
var
  Input: TChangeGrpJLInput;
  TrainmanJL: RRsTrainmanJiaolu;
begin
  //获取客户端所有可用人员交路

  //弹出选择框，选择要目的交路
  if (DrawGridGroups.Row < 0) or (Length(m_arrayGroupGrid) = 0) then Exit;
  
  Input := TChangeGrpJLInput.Create;
  try
    Input.GroupGUID := m_arrayGroupGrid[DrawGridGroups.Row].strGroupGUID;

    if not GetSelectTmJL(TrainmanJL) then Exit;
  
    Input.SrcJiaolu.jiaoluID := TrainmanJL.strTrainmanJiaoluGUID;
    Input.SrcJiaolu.jiaoluType := Ord(TrainmanJL.nJiaoluType);
    Input.SrcJiaolu.jiaoluName := TrainmanJL.strTrainmanJiaoluName;
    
    Input.DutyUser.Assign(m_DutyUser);
    if not TfrmTmjlSelect.SelectJL(Input) then Exit;

    if Input.SrcJiaolu.jiaoluID = Input.DestJiaolu.jiaoluID then
    begin
      Box('机组当前所在交路和调整的目的交路相同!');
      Exit;
    end;
    
    m_RsLCNameBoardEx.ChangeGroupJL(Input);
    InitGroups;
  finally
    Input.Free;
  end;


  //轮乘交路
  //修改机组关联交路ID，修改机组上人员关联交路ID ,修改序号为最大序号
  //包乘交路
  //选择机车，修改机组关联机车ID，修改人员交路ID，修改序号为最大序号
  //记名式交路，插入车次记录，修改机组关联交路、人员关联交路，修改序号为最大序号
  //保存操作日志
  ;

  
end;

procedure TfrmMain_RenYuan.N55Click(Sender: TObject);
begin
  if GlobalDM.UsesMealTicket then
    TFrmViewMealTicket.ShowForm;
end;

procedure TfrmMain_RenYuan.miPBFromPrepareClick(Sender: TObject);
var
  tmNumber1,tmNumber2 : string;
  orderGroup : TRsLCOrderGrpInputParam;
  trainmanPlan,tmPlanNew : RRsTrainmanPlan;
  group : RRsGroup;
  jiaoluGUID,jiaoluName,strGroupGUID,strError : string;
  jiaoluType : integer;
  tmOrder1,tmOrder2 : integer;
begin
  if not GetSelectedTrainmanPlan(trainmanPlan) then
  begin
    Box('请先选择计划');
    Exit;
  end;
  //检测人员是否在值乘计划
  if not CheckTMBusy(tmNumber1) then
  begin
    exit;
  end;
  if not CheckTMBusy(tmNumber2) then
  begin
    exit;
  end;
  if not LCWebAPI.LCTrainPlan.GetTrainmanPlanByGUID(trainmanPlan.TrainPlan.strTrainPlanGUID,tmPlanNew,strError) then
  begin
    Box('计划不存在，请刷新');
    Exit;
  end;
  if (trainmanPlan.Group.strGroupGUID <> '') then
  begin
    Box('该计划已经安排机组了，请先移除机组后再安排新机组');
    Exit;
  end;
  
  strGroupGUID := '';   
  //从备班里安排人员
  if not TFrmPBFromPrepare.SelectPrepareToGroup(trainmanPlan.TrainPlan.strTrainNo,
    trainmanPlan.TrainPlan.strTrainTypeName,trainmanPlan.TrainPlan.strTrainNumber,
    jiaoluGUID,jiaoluName,jiaoluType,tmNumber1,tmOrder1,tmNumber2,tmOrder2,strGroupGUID) then
  begin
    exit;
  end;
  if (jiaoluType = Ord(jltOrder)) then
  begin
    //添加机组
    orderGroup := TRsLCOrderGrpInputParam.Create;
    try
      with orderGroup.TrainmanJiaolu do
      begin
        jiaoluID := jiaoluGUID;
        jiaoluName := jiaoluName;
        jiaoluType := jiaoluType;
      end;
      with orderGroup.DutyUser do
      begin
        strDutyGUID := GlobalDM.DutyUser.strDutyGUID;
        strDutyNumber := GlobalDM.DutyUser.strDutyNumber;
        strDutyName := GlobalDM.DutyUser.strDutyName;
      end;

      orderGroup.OrderGUID := NewGUID;
      orderGroup.PlaceID := trainmanPlan.TrainPlan.strPlaceID;
      orderGroup.TrainmanNumber1 := tmNumber1;
      orderGroup.TrainmanNumber2 := tmNumber2;

      LCWebAPI.LCNameBoardEx.Order.Group.Add(orderGroup);
      
      if not  LCWebAPI.LCNameBoardEx.Order.Group.GetGroup(tmNumber1,0,group) then
      begin
       Box('添加机组失败');
       exit;
      end;
    finally
      orderGroup.Free;
    end;
  end else begin
     if not  LCWebAPI.LCNameBoardEx.Order.Group.GetGroup(strGroupGUID,group) then
     begin
       Box('机组不存在');
       exit;
     end;
  end;



  //派班
  m_LCPaiBan.SetGroup(trainmanPlan.TrainPlan.strTrainPlanGUID,group.strGroupGUID,GlobalDM.DutyUser);

  strGridTrainPlan.Invalidate;
  ShowStudentInfo(group);
  m_MealTicket.AddByGrp(Group,trainmanPlan,GlobalDM.DutyUser);
  PostMessage(Handle,WM_Refresh_Group,0,0);
  InitTrainmanPlan();
end;

procedure TfrmMain_RenYuan.mniXYRelationClick(Sender: TObject);
var
  nCol: Integer;
  nRow: Integer;
  Trainman: RRsTrainman;
begin
  nCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  nRow := strGridTrainPlan.Row;

  Trainman.strTrainmanGUID := '';
  if nRow > 0 then
  begin
    if (nCol = COL_TRAINMAN_INDEX) or (nCol = COL_SUBTRAINMAN_INDEX) or (nCol = COL_XUEYUAN_INDEX) or (nCol = COL_XUEYUAN2_INDEX) then
    begin
      if COL_TRAINMAN_INDEX = nCol then
      begin
        Trainman := m_TrainmanPlanArray[nRow - 1].Group.Trainman1;
      end;
      if COL_SubTRAINMAN_INDEX = nCol then
      begin
        Trainman := m_TrainmanPlanArray[nRow - 1].Group.Trainman2;
      end;
      if COL_XUEYUAN_INDEX = nCol then
      begin
        Trainman := m_TrainmanPlanArray[nRow - 1].Group.Trainman3;
      end;
      if COL_XUEYUAN2_INDEX = nCol then
      begin
        Trainman := m_TrainmanPlanArray[nRow - 1].Group.Trainman4;
      end;
    end;
  end;
  if Trainman.strTrainmanGUID <> '' then
  begin
    XYRelationManage(Trainman)
  end
  else
    XYRelationManage();
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
    //计划开车
    COL_PLANKAICHETIME_INDEX  : strName := 'kaiCheTime';
    //计划出勤
    COL_PLAN_CHUQIN_TIME_INDEX  : strName := 'startTime';

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
procedure TfrmMain_RenYuan.ModifyPlan(PlanID: string; nRow, nCol: Integer);
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

  //修改计划开车列时同时要修改计划出勤列
  if nCol = COL_PLANKAICHETIME_INDEX then
  begin
    SetLength(JsonObjectArray,2);
    JsonObjectArray[0].strName := GetCloumnName(COL_PLAN_CHUQIN_TIME_INDEX);
    JsonObjectArray[0].strValue := strGridTrainPlan.Cells[COL_PLAN_CHUQIN_TIME_INDEX,nRow];

    JsonObjectArray[1].strName := GetCloumnName(COL_PLANKAICHETIME_INDEX);
    JsonObjectArray[1].strValue := strGridTrainPlan.Cells[COL_PLANKAICHETIME_INDEX,nRow];
  end
  else if nCol = COL_CHECI_INDEX then
  begin
    SetLength(JsonObjectArray,2);
    JsonObjectArray[0].strName := GetCloumnName(COL_CHECI_INDEX);
    JsonObjectArray[0].strValue := strGridTrainPlan.Cells[COL_CHECI_INDEX,nRow];

    JsonObjectArray[1].strName := GetCloumnName(COL_KEHUO_INDEX);
    JsonObjectArray[1].strValue := IntToStr( Ord (KeHuoNameToType ( strGridTrainPlan.Cells[COL_KEHUO_INDEX,nRow] ) ) );
  end else if nCol = COL_WAIQIN_INDEX then
  begin
    SetLength(JsonObjectArray,3);
    sValue := strGridTrainPlan.Cells[COL_WAIQIN_INDEX,nRow];

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
      COL_REMARKTYPE_INDEX :  sValue := inttostr( Ord ( PlanRemarkTypeNameToType (strGridTrainPlan.Cells[nCol,nRow]) ) );
      COL_DUTYPLACE_INDEX  :  sValue := GetDutyPlacIDFromName(m_PlaceList,strGridTrainPlan.Cells[nCol,nRow]);
      COL_STARTSTATION_INDEX : sValue := GetStationIDFromName(m_StationArray,strGridTrainPlan.Cells[nCol,nRow]);
      COL_ENDSTATION_INDEX : sValue := GetStationIDFromName(m_StationArray,strGridTrainPlan.Cells[nCol,nRow]);
      COL_TRAINMANTYPE_INDEX : sValue := inttostr( Ord (TrianmanTypeNameToType (strGridTrainPlan.Cells[nCol,nRow] ) ));
      COL_PLANTYPE_INDEX : sValue := inttostr( Ord (PlanTypeNameToType (strGridTrainPlan.Cells[nCol,nRow] ) ));
      COL_DRAGSTATE_INDEX : sValue := inttostr( Ord ( DragTypeNameToType (strGridTrainPlan.Cells[nCol,nRow] ) ));
      COL_KEHUO_INDEX : sValue := inttostr( Ord ( KeHuoNameToType (strGridTrainPlan.Cells[nCol,nRow] ) ));
    else
      sValue := strGridTrainPlan.Cells[nCol,nRow]  ;
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

procedure TfrmMain_RenYuan.mniHouBanClick(Sender: TObject);
var
  plan:RRsTrainmanPlan;
begin
  if GetSelectedTrainmanPlan(plan)= True then
  begin
    if( plan.TrainPlan.nPlanState >= psSent) and (plan.TrainPlan.nPlanState < psBeginWork) then
    begin
      if TfrmSetRest.SetPlanRestInfo(plan) = True then
      begin
        m_TrainmanPlanArray[strGridTrainPlan.Row-1].RestInfo := plan.RestInfo;
        AddRTrainmanPlanToControl(plan,strGridTrainPlan.Row-1);

        //向公寓端发送强休消息
        PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_PUBLISH,plan.TrainPlan.strTrainPlanGUID);
      end;
    end;
  end;
end;

procedure TfrmMain_RenYuan.mniJiaoBanClick(Sender: TObject);
var
  trainmanPlan : RRsTrainmanPlan;
begin
  try
    if not GetSelectedTrainmanPlan(trainmanPlan) then
    begin
      TtfPopBox.ShowBox('请先选择计划信息！');
      exit;
    end;
    if trainmanPlan.TrainPlan.nPlanState <> psPublish then
    begin
      TtfPopBox.ShowBox('仅限发布状态计划');
      Exit;
    end;
    
    {if trainmanPlan.RestInfo.nNeedRest = 0 then
    begin
      TtfPopBox.ShowBox('无候班信息');
      Exit;
    end; }
    

    with trainmanPlan.Group do
    begin
      if Trainman1.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman1,trainmanPlan,TCT_ROOM);
      if Trainman2.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman2,trainmanPlan,TCT_ROOM);
      if Trainman3.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman3,trainmanPlan,TCT_ROOM);
      if Trainman4.strTrainmanGUID <> '' then
        PostAddCallWorkMessage(Trainman4,trainmanPlan,TCT_ROOM);
    end;

    InitTrainmanPlan ;
  finally

  end;
end;

procedure TfrmMain_RenYuan.mniSwapNextClick(Sender: TObject);
var
  groupCurrent : RRsGroup;
  groupNext : RRsGroup;
  nIndex,nNextIndex : integer;
  strGroupGUID  : string;
  trainmanjiaolu : RRsTrainmanJiaolu;
  i: Integer;
  JLInput: TRsLCBoardInputJL;
begin
  if  DrawGridGroups.RowCount < 0  then Exit;
  if DrawGridGroups.Row = DrawGridGroups.RowCount-1 then   Exit ;


  nIndex := DrawGridGroups.Row ;

  groupCurrent := m_arrayGroupGrid[nIndex];
  strGroupGUID := groupCurrent.strGroupGUID;
  m_RsLCNameBoardEx.Group.GetGroup(strGroupGUID,groupCurrent);

  nNextIndex := length(m_GroupArray);
  for i := 0 to length(m_GroupArray) - 1 do
  begin
    if (m_GroupArray[i].strGroupGUID = strGroupGUID) then
    begin
      nNextIndex := i + 1;
      break;
    end;
  end;
  if (nNextIndex = length(m_GroupArray)) then
  begin
    Box('已经是最后一组');
    exit;
  end;
  groupNext := m_GroupArray[nNextIndex];
  strGroupGUID := groupNext.strGroupGUID;
  m_RsLCNameBoardEx.Group.GetGroup(strGroupGUID,groupNext);


  if ( groupCurrent.GroupState <> tsNormal ) or ( groupNext.GroupState <> tsNormal) then
    Exit ;

  m_RsLCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(groupCurrent.strGroupGUID,trainmanjiaolu);

  JLInput := TRsLCBoardInputJL.Create;
  try
    JLInput.SetTrainmanJL(trainmanjiaolu);
    m_RsLCNameBoardEx.Group.Swap(JLInput,m_DutyUser,groupCurrent.strGroupGUID,groupNext.strGroupGUID);
  finally
    JLInput.Free;
  end;


  InitGroups;
end;

procedure TfrmMain_RenYuan.mniSwapPriorClick(Sender: TObject);
var
  groupCurrent : RRsGroup;
  groupPrior : RRsGroup;
  nIndex,nPriorIndex : integer;
  strGroupGUID  : string;
  trainmanjiaolu : RRsTrainmanJiaolu;
  i: Integer;
  JLInput: TRsLCBoardInputJL;
begin
  if  DrawGridGroups.RowCount < 0  then Exit;
  if DrawGridGroups.Row <= 0 then   Exit ;


  nIndex := DrawGridGroups.Row ;
  groupCurrent := m_arrayGroupGrid[nIndex];
  strGroupGUID := groupCurrent.strGroupGUID;

  m_RsLCNameBoardEx.Group.GetGroup(strGroupGUID,groupCurrent);

  nPriorIndex := -1;
  for i := 0 to length(m_GroupArray) - 1 do
  begin
    if m_GroupArray[i].strGroupGUID = strGroupGUID then
    begin
      nPriorIndex := i - 1;
      break;
    end;
  end;
  if nPriorIndex < 0 then
  begin
    Box('已经是第一组了');
    exit;
  end;
  groupPrior := m_GroupArray[nPriorIndex];
  strGroupGUID := groupPrior.strGroupGUID;
  m_RsLCNameBoardEx.Group.GetGroup(strGroupGUID,groupPrior);


  if ( groupCurrent.GroupState <> tsNormal ) or ( groupPrior.GroupState <> tsNormal) then
    Exit ;


  m_RsLCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(groupCurrent.strGroupGUID,trainmanjiaolu);

  JLInput := TRsLCBoardInputJL.Create;
  try
    JLInput.SetTrainmanJL(trainmanjiaolu);

    m_RsLCNameBoardEx.Group.Swap(JLInput,m_DutyUser,groupCurrent.strGroupGUID,groupPrior.strGroupGUID);

  finally
    JLInput.Free;
  end;


  InitGroups;
end;

procedure TfrmMain_RenYuan.mniChangeNextGroupClick(Sender: TObject);
var
  trainmanPlanCur : RRsTrainmanPlan;
  trainmanPlanNext:RRsTrainmanPlan;
begin
  try
    //如果是最后一组
    if strGridTrainPlan.Row >= length(m_TrainmanPlanArray) then exit;
    trainmanPlanCur := m_TrainmanPlanArray[strGridTrainPlan.row - 1];
    trainmanPlanNext := m_TrainmanPlanArray[strGridTrainPlan.row ];

    //是已经出勤状态或者退勤状态
    if ( trainmanPlanCur.TrainPlan.nPlanState = psBeginWork ) or
     ( trainmanPlanCur.TrainPlan.nPlanState = psEndWork  )  or
     ( trainmanPlanNext.TrainPlan.nPlanState = psBeginWork ) or
     ( trainmanPlanNext.TrainPlan.nPlanState = psEndWork  )
    then
    begin
      Exit;
    end;

    if IsGroupEmpty(trainmanPlanCur.Group) or IsGroupEmpty(trainmanPlanNext.Group) then
      Exit ;

    if not TBox('确定和下面一组人员互换吗?') then
      Exit;

    m_LCPaiBan.ExchangeGroup(trainmanPlanCur.Group.strGroupGUID,trainmanPlanNext.Group.strGroupGUID,GlobalDM.DutyUser);



    TtfPopBox.ShowBox('调换成功！');

    InitTrainmanPlan;
    InitGroups;
  except on e : exception do
    Box('操作异常:' + e.Message);
  end;
end;

procedure TfrmMain_RenYuan.N9Click(Sender: TObject);
begin
  AutoDispatchRenYuan();
end;

procedure TfrmMain_RenYuan.NExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_RenYuan.NextFocus;
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
    strGridTrainPlan.Col := strGridTrainPlan.DisplRowIndex(COL_CHECI_INDEX);
  end;
end;
procedure TfrmMain_RenYuan.OnAppVersionChange(Sender: TObject);
begin
  statusAppVersion.Caption := '有新程序发布,请及时更新!';
end;

procedure TfrmMain_RenYuan.OnTFMessage(TFMessages: TTFMessageList);
var
  i: Integer;
  strMessageType: string;
  item : TListItem;
  bPlaySound: Boolean;
  bIsUpdate : Boolean ;
begin
  bIsUpdate := False ;
  bPlaySound := False;
  for I := 0 to TFMessages.Count - 1 do
  begin
    TFMessages.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;

    if not RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(TFMessages.Items[i].StrField['jiaoLuGUID'],
      GlobalDM.SiteInfo.strSiteGUID) then
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
      Continue;
    end;
      
    case TFMessages.Items[i].msg of
      TFM_PLAN_TRAIN_PUBLISH,
      TFM_PLAN_TRAIN_UPDATE,
      TFM_PLAN_TRAIN_CANCEL:
        begin
          case TFMessages.Items[i].msg of
            TFM_PLAN_TRAIN_PUBLISH:
            begin
              strMessageType :='下发';
              tmrSharkIcon.Enabled := true;
              bPlaySound := True;
            end;
            //外勤的更新接话和接受计划
            //接收到更新人员的叫班信息
            TFM_PLAN_WAIQIN_PUBLISH :
            begin
              if  TFMessages.Items[i].IntField['nDayPlanID'] = m_nDayPlanID  then
              begin
                bPlaySound := True ;
              end;
            end ;
            TFM_PLAN_WAIQIN_UPDATE :
            //接收到更新人员的叫班信息
            begin
              if  TFMessages.Items[i].IntField['nDayPlanID'] = m_nDayPlanID  then
              begin
                bIsUpdate := True ;
              end;
            end ;

            TFM_PLAN_TRAIN_UPDATE:
            begin
              strMessageType :='更新';
              tmrSharkIcon.Enabled := true;
              bIsUpdate := True ;
              TFMessages.Items[i].StrField['GUID'];
            end;
            TFM_PLAN_TRAIN_CANCEL:
            begin
              strMessageType :='撤销';
            end;
          end;

          item := lstviewMsg.Items.Insert(0);
          item.Caption := strMessageType;
          item.SubItems.Add(FormatDateTime('MM-dd HH:nn',GlobalDM.GetNow));
          item.SubItems.Add(TFMessages.Items[i].StrField['jiaoLuName']);
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainTypeName']);  //车型
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNumber']);    //车号
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNo']);
          item.SubItems.Add(Format('该计划于"%s"时开车!',[
            FormatDateTime('yyyy-MM-dd HH:nn:ss',TFMessages.Items[i].dtField['dtStartTime'])
          ]));
        end;

      TFM_WORK_BEGIN:
        begin
          item := lstviewMsg.Items.Insert(0);
          item.Caption := strMessageType;
          item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',GlobalDM.GetNow));
          item.SubItems.Add(TFMessages.Items[i].StrField['jiaoLuName']);
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainTypeName']);  //车型
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNumber']);    //车号
          item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNo']);
          item.SubItems.Add(Format('乘务员%s已出勤!',[TFMessages.Items[i].StrField['tmname']
          ]));
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;

        end ;
      TFM_CALLWORK_UPDATE :
      //接收到更新人员的叫班信息
        begin
          TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
          InitTrainmanPlan ;
        end
    ELSE
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;
    end;

  end;


  if bPlaySound then
    GlobalDM.PlaySoundFileLoop('接收计划.wav');
  //如果计划有改动则播放更新计划音乐
  if bIsUpdate then
  begin
    GlobalDM.PlaySoundFileLoop('更新计划.wav');
    InitTrainmanPlan ;
  end;
end;


procedure TfrmMain_RenYuan.p1Click(Sender: TObject);
begin
  TfrmPaibanRecord.Open;
end;

procedure TfrmMain_RenYuan.PngSpeedButton1Click(Sender: TObject);
begin
  TFrmPrintTMRpt.printTMRpt_NoPlan();
end;

procedure TfrmMain_RenYuan.PostAddCallWorkMessage(Trainman:RRsTrainman;
  TrainmanPlan: RRsTrainmanPlan;eCallType:TCallType);
var
  oldCallNotify,newCallNotify:RRsCallNotify ;
begin
  try
    newCallNotify.nCallWorkType := 0 ;
    newCallNotify.eCallType := eCallType;
    FillCallWork(TrainmanPlan,Trainman,newCallNotify);

    //发送叫班通知信息
    SendCallCallWorkMessage(TFM_CALLWORK_PUBLISH,newCallNotify);


    if m_RsLCCallNotify.FindUnCancel(Trainman.strTrainmanGUID,
        TrainmanPlan.TrainPlan.strTrainPlanGUID,oldCallNotify) = True then
    begin
      m_RsLCCallNotify.CancelNotify(oldCallNotify.strMsgGUID,GlobalDM.LogUserInfo.strDutyUserName
        ,GlobalDM.GetNow,'重新通知');
    end;
    m_RsLCCallNotify.AddNotify(newCallNotify);
  finally
    ;
  end;
end;



procedure TfrmMain_RenYuan.PostPlanRenYuanMessage(msg: Integer; Guid: string);
var
  GUIDS: TStringList;
begin
  GUIDS := TStringList.Create;
  try
    GUIDS.Add(Guid);
    PostPlanRenYuanMessage(msg,GUIDS);
  finally
    GUIDS.Free;
  end;
end;

procedure TfrmMain_RenYuan.PrintHuoCheBanXu;
var
  nLen1:Integer;
  nLen2:Integer;
  nMaxLen :Integer;
  mv:TfrxMemoView;
begin

  nLen1 := Length(m_listGroupEast);
  nLen2 := Length(m_listGroupWeast);
  nMaxLen := nLen1 ;
  if nLen2 > nLen1 then
    nMaxLen :=  nLen2 ;

  mv := frxReport2.FindObject('memoE_sn') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '序号' ;

  mv := frxReport2.FindObject('memoe') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '西线班序' ;

  mv := frxReport2.FindObject('memoe_time') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '退勤' ;

  mv := frxReport2.FindObject('memow_sn') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '序号' ;

  mv := frxReport2.FindObject('memoW') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '东线班序' ;

  mv := frxReport2.FindObject('memow_time') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '退勤' ;
    
  frxUserDataSet2.RangeEndCount := nMaxLen ;
  frxReport2.ShowReport();
end;

procedure TfrmMain_RenYuan.PostPlanRenYuanMessage(msg: Integer;GUIDS: TStrings);
var
  TFMessage: TTFMessage;
  strJiaoLuGUID: string;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := msg;
    TFMessage.StrField['GUIDS'] := GUIDS.Text;
    if GetSelectedTrainJiaolu(strJiaoLuGUID) then
    begin
      TFMessage.StrField['jiaoLuGUID'] := strJiaoLuGUID;
    end;

    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
  finally
    TFMessage.Free;
  end;

end;




procedure TfrmMain_RenYuan.RecieveTrainPlan;
var
  GUIDS: TStrings;
  strError:string;
begin
  GUIDS := TStringList.Create;
  try
    //接收计划
    if m_webTrainPlan.RecvPlan(GlobalDM.DutyUser.strDutyGUID,GUIDS,strError) then
    begin
      //发送消息
      PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_RECIEVE,GUIDS);
      //刷新列表
      InitTrainmanPlan();
    end

  finally
    GUIDS.Free;
  end;

end;


procedure TfrmMain_RenYuan.RefreshTrainmanPlan();
var
  i: Integer;
begin
  with strGridTrainPlan do
  begin
    ClearRows(1,10000);
    if length(m_TrainmanPlanArray) > 0  then
      RowCount := length(m_TrainmanPlanArray) + 1
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
    for i := 0 to length(m_TrainmanPlanArray) - 1 do
    begin
      AddRTrainmanPlanToControl(m_TrainmanPlanArray[i],i);
    end;
    Invalidate;
  end;
end;


function TfrmMain_RenYuan.RemovePlan(guids: TStringList): Boolean;
const
  MAIN_PLAN = 1 ;
var
  strError: string;
begin
  Result := False;

  if not TBox('您确认要撤销选中的计划信息吗？') then exit;

  if not m_webTrainPlan.CancelTrainPlan(guids, GlobalDM.DutyUser.strDutyGUID,MAIN_PLAN,strError) then

  begin
    Application.MessageBox('撤销计划失败！', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Result := True;
end;

function TfrmMain_RenYuan.RemoveSubPlan(guids: TStringList): Boolean;
var
  strError: string;
begin
  Result := False;

  if not TBox('您确认要撤销选中的计划信息吗？') then exit;

  if not m_webTrainPlan.CancelTrainPlan(guids, GlobalDM.DutyUser.strDutyGUID,0,strError) then
  begin
    BoxErr(strError);
    Application.MessageBox('撤销计划失败!' , '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Result := True;
end;

procedure TfrmMain_RenYuan.S1Click(Sender: TObject);
begin
  TFrmMealTicketRule.ShowForm;
end;

procedure TfrmMain_RenYuan.SendCallCallWorkMessage(msg: Integer;
  CallWork: RRsCallNotify);
var
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  try
    TFMessage.msg := msg;
    with callWork do
    begin
      TFMessage.StrField['strTrainPlanGUID'] := strTrainPlanGUID ;
      TFMessage.StrField['strMsgGUID'] := strMsgGUID ;
      TFMessage.StrField['dtSendTime'] := TPubFun.DateTime2Str(dtSendTime) ;
    end;
    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
  finally
    TFMessage.Free;
  end;
end;

procedure TfrmMain_RenYuan.SetEditPlanEnable(EditPlanEnable: Boolean);
begin
  m_bEditPlanEnable := EditPlanEnable;  
end;

procedure TfrmMain_RenYuan.SetPopupData(LookupEdit: TtfLookupEdit;
  TrainmanArray: TRsTrainmanArray);
var
  item : TtfPopupItem;
  i: Integer;
begin
  LookupEdit.Items.Clear;
  for i := 0 to Length(TrainmanArray) - 1 do
  begin
    item := TtfPopupItem.Create();
    item.StringValue := TrainmanArray[i].strTrainmanGUID;
    item.SubItems.Add(Format('%d', [(LookupEdit.PopStyle.PageIndex - 1) * 10 + i + 1]));
    item.SubItems.Add(TrainmanArray[i].strTrainmanNumber);
    item.SubItems.Add(TrainmanArray[i].strTrainmanName);
    item.SubItems.Add(TRsPostNameAry[TrainmanArray[i].nPostID]);
    item.SubItems.Add(TRsKeHuoNameArray[TrainmanArray[i].nKehuoID]);
    if TrainmanArray[i].bIsKey > 0 then
    begin
      item.SubItems.Add('是');
    end else begin
      item.SubItems.Add('');
    end;
    item.SubItems.Add(TrainmanArray[i].strABCD);
    item.SubItems.Add(TrainmanArray[i].strMobileNumber);
    item.SubItems.Add(TRsTrainmanStateNameAry[TrainmanArray[i].nTrainmanState]);
    LookupEdit.Items.Add(item);
  end;
  LookupEdit.PopStyle.PageInfo := Format('　第 %d 页，共 %d 页', [LookupEdit.PopStyle.PageIndex, LookupEdit.PopStyle.PageCount]);

end;

procedure TfrmMain_RenYuan.SetSelectedTrainJiaolu(TrainJiaoluName: string);
var
  i : Integer ;
begin
  for I := 0 to tabTrainJiaolu.Tabs.Count - 1 do
  begin
    if m_TrainjiaoluArray[i].strTrainJiaoluName = TrainJiaoluName then
    begin
      tabTrainJiaolu.TabIndex := i ;
      Break ;
    end;
  end;
end;

procedure TfrmMain_RenYuan.ShowPrint;
var
  mv: TfrxMemoView;
begin
  if Length(m_arrayGroupPrint) = 0 then
  begin
    TtfPopBox.ShowBox('空记录不能被打印！');
    Exit ;
  end;

  mv := frxReport1.FindObject('memoid') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '序号' ;

  mv := frxReport1.FindObject('memotrainman1') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '司机一' ;

  mv := frxReport1.FindObject('memotrainman2') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '司机二' ;

  mv := frxReport1.FindObject('memotrainman3') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '学员一' ;

  mv := frxReport1.FindObject('memotrainman4') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '学员二' ;

  frxUserDataSet1.RangeEndCount := Length(m_arrayGroupPrint) ;

  
  frxReport1.ShowReport();
end;

procedure TfrmMain_RenYuan.ShowSignForm;
begin
  if GlobalDM.UsesOutWorkSign then
  begin
    rzpnlSignForm.Visible := True;
    frmSign := ShowSignPlanForm(rzpnlSignForm,TSF_PaiBan);
    Exit;
  end;
  rzpnlTrainPlan.Align := alClient;
  strGridTrainPlan.Width :=  rzpnlTrainPlan.Width;
  rzpnlTrainPlan.Align := alClient;
  rzpnlSignForm.Visible := False;
  advspltr1.Visible := False;

end;

procedure TfrmMain_RenYuan.ShowStudentInfo(Group : RRsGroup);
var
  StudentArray: TRsXYStudentArray;
  strMsg1,strMsg2: string;
begin
  strMsg1 := '';
  strMsg2 := '';
  
  StudentArray := GetStudentsArray(Group.Trainman1);
  if Length(StudentArray) > 0 then
    strMsg1 := FormatXYInfo(Group.Trainman1,StudentArray);

  StudentArray := GetStudentsArray(Group.Trainman2);
  if Length(StudentArray) > 0 then
    strMsg2 := FormatXYInfo(Group.Trainman2,StudentArray);

  if (strMsg1 <> '') and (strMsg2 <> '')then
    TtfPopBox.ShowBox(strMsg1,strMsg2,0)
  else
  if (strMsg1 <> '') and (strMsg2 = '')then
    TtfPopBox.ShowBox(strMsg1,0)
  else
  if (strMsg1 = '') and (strMsg2 <> '')then
    TtfPopBox.ShowBox(strMsg2,0);
end;
function ComparePlan(Item1, Item2: Pointer): Integer;
begin
  if PRsTrainmanPlan(Item1).TrainPlan.nPlanState >
    PRsTrainmanPlan(Item2).TrainPlan.nPlanState then
    Result := 1
  else
  if PRsTrainmanPlan(Item1).TrainPlan.nPlanState <
    PRsTrainmanPlan(Item2).TrainPlan.nPlanState then
    Result := -1
  else
    Result := CompareDateTime(PRsTrainmanPlan(Item1).TrainPlan.dtStartTime,PRsTrainmanPlan(Item2).TrainPlan.dtStartTime);
end;

function TfrmMain_RenYuan.SortPlan(PlanArray : TRsTrainmanPlanArray): TRsTrainmanPlanArray;
var
  I: Integer;
  lst: TList;
begin
  lst := TList.Create;
  try
    SetLength(Result,Length(PlanArray));
    for I := 0 to Length(PlanArray) - 1 do
    begin
      lst.Add(@PlanArray[i]);
    end;

    lst.Sort(ComparePlan);

    for I := 0 to lst.Count - 1 do
    begin
      Result[i] := PRsTrainmanPlan(lst[i])^;
    end;
  finally
    lst.Free;
  end;

end;

procedure TfrmMain_RenYuan.ShowStudentInfo(trainman : RRsTrainman);
var
  StudentArray: TRsXYStudentArray;
begin
  StudentArray := GetStudentsArray(trainman);
  if Length(StudentArray) > 0 then
    TtfPopBox.ShowBox(FormatXYInfo(trainman,StudentArray),0);
end;



procedure TfrmMain_RenYuan.btnPrintClick(Sender: TObject);
begin
  ShowPrint;
end;

procedure TfrmMain_RenYuan.btnPublishPlanClick(Sender: TObject);
var
  i : integer;
  planGUID,trainJiaoluGUID : string;
  guids : TStrings;
  trainmanPlan : RRsTrainmanPlan;
  Plans: string;
  ErrInfo: string;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;
   //获取选中计划的GUID，并判断选中的计划是否符合要求
  guids := TStringList.Create;
  try
    try
      for i := 1 to strGridTrainPlan.RowCount - 1 do
      begin
        planGUID := strGridTrainPlan.Cells[99, i];
        if planGUID = '' then
        begin
          continue;
        end;
        if not m_webTrainPlan.GetTrainmanPlanByGUID(planGUID, trainmanPlan, ErrInfo) then
          Continue;
        
        if trainmanPlan.TrainPlan.nPlanState <> psReceive then
        begin
          continue;
        end;

        {liulin del 20131022
        trainmanPlan.TrainPlan.dtStartTime < dtOriginTime;
        }
        if trainmanPlan.Group.strGroupGUID = '' then
         continue;
        
        guids.Add(planGUID);
      end;


      if guids.Count = 0 then
      begin
        Application.MessageBox('没有要发布的计划！', '提示', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
      if not TBox('您确认要发布当前行车区段内的机车计划吗？') then exit;

      Plans := '';
      for I := 0 to guids.Count - 1 do
      begin
        Plans := Plans + guids[i] + ',';
      end;


      Plans := Copy(Plans,1,Length(Plans)-1);
      
      m_LCPaiBan.PublishPlan(Plans,GlobalDM.DutyUser.strDutyGUID,GlobalDM.SiteInfo.strSiteGUID);


      PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_PUBLISH,guids);
      InitTrainmanPlan;
    except on e : exception do
      begin
        Box('发布计划失败:' + e.Message);
      end;
    end;
  finally
    guids.Free;
  end;
end;

procedure TfrmMain_RenYuan.btnQuery2Click(Sender: TObject);
begin
  InitLeaveTrainmans;
end;

procedure TfrmMain_RenYuan.btnQueryClick(Sender: TObject);
begin
  InitGroups;
end;

procedure TfrmMain_RenYuan.btnQueryPrepareClick(Sender: TObject);
begin
  InitPrepare ;
end;

procedure TfrmMain_RenYuan.btnRefreshPalnClick(Sender: TObject);
begin
  InitTrainmanPlan();
  InitGroups;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanCanEditCell(Sender: TObject; ARow,
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
  //本版不支持人员操作
  if m_bEditPlanEnable then
    CanEdit :=
      (ACol = COL_TRAINNO_INDEX) OR
      (ACol = COL_TRAINTYPE_INDEX) OR
      (ACol = COL_CHECI_INDEX) OR
      (ACol = COL_PLANKAICHETIME_INDEX) OR
      (ACol = COL_REALKAICHETIME_INDEX) OR
      (ACol = COL_STARTSTATION_INDEX) OR
      (ACol = COL_ENDSTATION_INDEX) OR
      (ACol = COL_TRAINMANTYPE_INDEX) OR
      (ACol = COL_PLANTYPE_INDEX) OR
      (ACol = COL_DRAGSTATE_INDEX) OR
      (ACol = COL_REMARKTYPE_INDEX) OR
//      (ACol = COL_TRAINMAN_INDEX) OR
//      (ACol = COL_SUBTRAINMAN_INDEX) OR
//      (ACol = COL_XUEYUAN_INDEX) OR
//      (ACol = COL_XUEYUAN2_INDEX) OR
      (ACol = COL_KEHUO_INDEX)  or
      ( ACol = COL_PLAN_CHUQIN_TIME_INDEX )
  else    begin
//    if m_TrainmanPlanArray[ARow - 1].TrainPlan.nPlanState = psSent then
//    Exit;
//    CanEdit :=
//      (ACol = COL_TRAINMAN_INDEX) OR
//      (ACol = COL_SUBTRAINMAN_INDEX) OR
//      (ACol = COL_XUEYUAN_INDEX) OR
//      (ACol = COL_XUEYUAN2_INDEX);
  end;
end;


procedure TfrmMain_RenYuan.strGridTrainPlanCellValidate(Sender: TObject; ACol,
  ARow: Integer; var Value: string; var Valid: Boolean);
var
  strTime: string;
  dtTime: TDateTime;
  trainman : RRsTrainman;
  strTrainmanNumber: string;
  trainmanIndex : integer;
  Group: RRsGroup;
  trainmanPlan : RRsTrainmanPlan;
  srcTrainman: string;
begin
  m_bModify := False;
  if (Length(m_TrainmanPlanArray) = 0)  then Exit;

  if not GetSelectedTrainmanPlan(trainmanPlan) then Exit;

  m_bValidateFail := true;
  //验证开车时间和实际开车时间
  if (ACol = COL_PLANKAICHETIME_INDEX) or (ACOL = COL_PLAN_CHUQIN_TIME_INDEX) then
  begin
    strTime := Value;
    dtTime := strDecodeTime(strTime,m_dtNow);
    Value := FormatDateTime('yy-MM-dd hh:nn',dtTime);
    strGridTrainPlan.Cells[ACol,ARow]  := Value;
    if ACol = COL_PLANKAICHETIME_INDEX then
    begin
      strGridTrainPlan.Cells[COL_REALKAICHETIME_INDEX,strGridTrainPlan.Row]
       := Value;
    end;
  end;
  //验证车次和车型
  if (ACol = COL_CHECI_INDEX) or (ACol = COL_TRAINTYPE_INDEX) then
  begin
    Value := UpperCase(Value);
  end;


  //验证司机
  if (ACol = COL_TRAINMAN_INDEX) or (ACol = COL_SUBTRAINMAN_INDEX)
    or (ACol = COL_XUEYUAN_INDEX) or (ACol = COL_XUEYUAN2_INDEX)then
  begin
    try
      trainmanIndex := 0;
      if Value = '' then
      begin
        m_bValidateFail := false;
        Exit;
      end;


      strTrainmanNumber :=  Value;
      Group.strGroupGUID := '';
      m_RsLCNameBoardEx.Group.GetGroup(strTrainmanNumber,0,Group);
      
      if COL_TRAINMAN_INDEX = ACol then
      begin
        trainmanIndex := 1;

        srcTrainman := m_TrainmanPlanArray[ARow - 1].Group.Trainman1.strTrainmanNumber;
        trainman.strTrainmanNumber := Group.Trainman1.strTrainmanNumber;
        trainman.strTrainmanName := Group.Trainman1.strTrainmanName;
      end;
      if COL_SubTRAINMAN_INDEX = ACol then
      begin
        trainmanIndex := 2;
        srcTrainman := m_TrainmanPlanArray[ARow - 1].Group.Trainman2.strTrainmanNumber;
        trainman.strTrainmanNumber := Group.Trainman2.strTrainmanNumber;
        trainman.strTrainmanName := Group.Trainman2.strTrainmanName;
      end;
      if COL_XUEYUAN_INDEX = ACol then
      begin
        trainmanIndex := 3;
        srcTrainman := m_TrainmanPlanArray[ARow - 1].Group.Trainman3.strTrainmanNumber;
        trainman.strTrainmanNumber := Group.Trainman3.strTrainmanNumber;
        trainman.strTrainmanName := Group.Trainman3.strTrainmanName;
      end;
      if COL_XUEYUAN2_INDEX = ACol then
      begin
        trainmanIndex := 4;
        srcTrainman := m_TrainmanPlanArray[ARow - 1].Group.Trainman4.strTrainmanNumber;
        trainman.strTrainmanNumber := Group.Trainman4.strTrainmanNumber;
        trainman.strTrainmanName := Group.Trainman4.strTrainmanName;
      end;



      if (Group.strGroupGUID <> '') and (m_TrainmanPlanArray[ARow - 1].Group.strGroupGUID = '') then
      begin
        m_LCPaiBan.SetGroup(m_TrainmanPlanArray[ARow - 1].TrainPlan.strTrainPlanGUID,group.strGroupGUID,GlobalDM.DutyUser);

        m_bModify := true;
        Value := Format('%s[%s]',[trainman.strTrainmanName,trainman.strTrainmanNumber]);

        m_MealTicket.AddByGrp(Group,trainmanPlan,GlobalDM.DutyUser);
      end
      else
      begin
        if not m_RsLCTrainmamMgr.GetTrainmanByNumber(strTrainmanNumber,trainman) then
        begin
          m_bValidateFail := False;
          Valid := False;
          TtfPopBox.ShowBox(Format('没有找到工号为[%s]的人员',[strTrainmanNumber]),2000);
          Exit;
        end;


        m_LCPaiBan.SetTrainmanToPlan(m_TrainmanPlanArray[ARow - 1].TrainPlan.strTrainPlanGUID,
            Value,trainmanIndex,GlobalDM.DutyUser);
        m_bModify := true;
        Value := Format('%s[%s]',[trainman.strTrainmanName,trainman.strTrainmanNumber]);


        if srcTrainman <> '' then
        begin
          m_MealTicket.DelByTM(srcTrainman,trainmanPlan);
        end;

          m_MealTicket.AddForTM(trainman,m_TrainmanPlanArray[ARow - 1],GlobalDM.DutyUser);
      end;
    except
      on E: Exception do
      begin
        m_bValidateFail := false;
        Valid := False;
        TtfPopBox.ShowBox(E.Message,2000);
        Exit;
      end;
    end;

  end;

  m_bModify := true;
   m_nSelectCol := ACol ;
    if (ACol = COL_TRAINMAN_INDEX) or (ACol = COL_SUBTRAINMAN_INDEX) then
      ShowStudentInfo(trainman);
end;


procedure TfrmMain_RenYuan.strGridTrainPlanClick(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanDblClickCell(Sender: TObject; ARow,
  ACol: Integer);
var
  trainman : RRsTrainman;
  nIndex,SelectCol : integer;
begin
  if (ARow = 0) or (length(m_TrainmanPlanArray)  = 0) then exit;
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
  if IsTrainmanCol(selectCol) or IsSubTrainmanCol(selectCol)
    or IsXueYuanTrainmanCol(selectCol)  or IsXueYuan2TrainmanCol(selectCol) then
  begin
    if not GetSelectedTrainman(trainman,nIndex) then exit;
    if TfrmTrainmanDetail.ViewTrainmanDetail(trainman.strTrainmanGUID) then
      TtfPopBox.ShowBox('修改成功');
  end;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanEditCellDone(Sender: TObject; ACol,
  ARow: Integer);
var
  trainmanPlan : RRsTrainmanPlan;
  error: string;
  nKehuo : integer;
  sValue:string;
  nMinute,nRealCol,nMinuteCall:Integer ;
   dtTime : TDateTime ;

  nRemarkType:Integer;
  placeid:string;
begin
  if not m_bValidateFail then Exit;
  //不能编辑计划就不允许编辑了
  if not m_bEditPlanEnable then exit;
  //在已安排人员是，点击单元格后没有修改内容再离开单元格，会触发此事件，使用Modify变量确认是否修改了内容
  if not m_bModify then Exit;
  m_bModify := False;

   if m_nSelectCol <= 0  then
  begin
   m_nSelectCol := ACol ;
  end;
  nRealCol := m_nSelectCol ;

  PostMessage(Handle,WM_Refresh_Group,0,0);

  if (nRealCol in [COL_TRAINMAN_INDEX,COL_SUBTRAINMAN_INDEX,COL_XUEYUAN_INDEX ,COL_XUEYUAN2_INDEX]) then
  begin
    if m_webTrainPlan.GetTrainmanPlanByGUID(m_TrainmanPlanArray[ARow - 1].Trainplan.strTrainPlanGUID,trainmanPlan,error) then
    begin
      strGridTrainPlan.Cells[COL_TRAINMANTYPE_INDEX,ARow] := TRsTrainmanTypeName[TrainmanPlan.TrainPlan.nTrainmanTypeID];
      m_TrainmanPlanArray[ARow - 1] :=  trainmanPlan;
      AddRTrainmanPlanToControl(m_TrainmanPlanArray[ARow - 1],ARow - 1);
      m_TrainmanPlanArray[ARow - 1].Trainplan.nTrainmanTypeID := TrainmanPlan.TrainPlan.nTrainmanTypeID;
    end
    else
    begin
      TtfPopBox.ShowBox(error,2000);
      Exit;
    end;
  end
  else
  begin
    if nRealCol = COL_CHECI_INDEX then
    begin
      sValue := RsLCBaseDict.LCTrainType.GetKehuoByCheCi(strGridTrainPlan.Cells[strGridTrainPlan.RealColIndex(ACol),ARow]);
      if not TryStrToInt(sValue,nKehuo) then
      begin
        nKehuo := 1;
      end;
      strGridTrainPlan.Cells[(COL_KEHUO_INDEX),ARow] := TRsKeHuoNameArray[TRsKehuo(nKehuo)];
      UpdatePlan(ARow,COL_CHECI_INDEX);
      InitTrainmanPlan();
    end;

    if ( nRealCol = COL_PLANKAICHETIME_INDEX )  then
    begin
      sValue := strGridTrainPlan.Cells[COL_BEGINWORKTIME_INDEX,ARow] + ':00' ;
      dtTime :=  StrToDateTime(sValue);

      nRemarkType := Integer ( m_TrainmanPlanArray[ARow -1 ].TrainPlan.nRemarkType );
      placeid := m_TrainmanPlanArray[ARow -1 ].TrainPlan.strPlaceID;

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
      strGridTrainPlan.Cells[COL_PLANKAICHETIME_INDEX,ARow]  := sValue;


      if m_TrainmanPlanArray[ARow -1 ].RestInfo.nNeedRest = 1 then
      begin
        nMinuteCall := 0;
        dtTime := IncMinute(dtTime,-nMinuteCall)  ;
        sValue := FormatDateTime('yy-MM-dd hh:nn',dtTime);
        strGridTrainPlan.Cells[COL_JIAOBAN_INDEX,ARow]  := sValue;
      end;
    end;
    UpdatePlan(ARow,nRealCol);
    InitTrainmanPlan();
  end;
  strGridTrainPlan.Invalidate;
end;


procedure TfrmMain_RenYuan.strGridTrainPlanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  case ACol of
    COL_STATE_INDEX:
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
    COL_REMARKTYPE_INDEX:
      begin
        if strGridTrainPlan.Cells[ACol,ARow] = TRsPlanRemarkTypeName[prtKuJie] then
        begin
          ABrush.Color := $00969B64;
        end;
      end;
    
  end;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanGetEditorType(Sender: TObject; ACol,
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
    COL_DUTYPLACE_INDEX :
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

procedure TfrmMain_RenYuan.strGridTrainPlanKeyPress(Sender: TObject;
  var Key: Char);
var
  selectCol : integer;
begin
  selectCol := strGridTrainPlan.RealColIndex(TAdvStringGrid(Sender).Col);
  if (selectCol = COL_PLANKAICHETIME_INDEX) or
     (selectCol = COL_REALKAICHETIME_INDEX) OR
     (selectCol = COL_PLAN_CHUQIN_TIME_INDEX )
  then
  begin
     if not (Key in ['0'..'9',#8,#13]) then
      Key := #0;
  end;

  if Key = #13 then
  begin
    if m_bValidateFail then
    begin
      NextFocus();
      if NOT((selectCol = COL_TRAINMAN_INDEX) OR
        (selectCol = COL_SubTRAINMAN_INDEX) OR
        (selectCol = COL_XUEYUAN_INDEX)OR
        (selectCol = COL_XUEYUAN2_INDEX)) then
      BEGIN
        Key := #0;
      END;
    end;
  end;
end;

procedure TfrmMain_RenYuan.strGridTrainPlanMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
  i: Integer;
  col,row,selectCol : integer;
begin
  if mbRight <> Button then
    Exit;
       
  strGridTrainPlan.MouseToCell(X,Y,col,row);
  if (row = 0) then
  begin
    pt := Point(X,Y);
    pt := strGridTrainPlan.ClientToScreen(pt);
    pMenuColumn.Popup(pt.X,pt.y);
    exit;
  end;

  GetCursorPos(PT);
  strGridTrainPlan.MouseToCell(X,Y,col,row);

  if strGridTrainPlan.Row > Length(m_TrainmanPlanArray) then
    Exit;
  selectCol := strGridTrainPlan.RealColIndex(strGridTrainPlan.Col);
   
  if (IsTrainmanCol(selectCol) or
    IsSubTrainmanCol(selectCol) or
    IsXueYuanTrainmanCol(selectCol) or
    IsXueYuan2TrainmanCol(selectCol))  then
  begin
   if strGridTrainPlan.Cells[selectCol,strGridTrainPlan.ROW] = '' then
    begin
      miPBFromPrepare.Enabled := true;
    end else begin
    for I := 0 to PopupMenu.Items.Count - 1 do
    begin
      PopupMenu.Items.Items[i].Enabled := True;
    end;
    end;

  end
  else
  begin
    for I := 0 to PopupMenu.Items.Count - 1 do
    begin
      PopupMenu.Items.Items[i].Enabled := False;
    end;
    miAddSubPlan.Enabled := True;
    miViewPlanLog.Enabled := True ;
  end;

  PopupMenu.Popup(PT.X,PT.Y);
end;





procedure TfrmMain_RenYuan.T1Click(Sender: TObject);
begin
   ;
end;

procedure TfrmMain_RenYuan.FillCallWork(TrainmanPlan: RRsTrainmanPlan;
  Trainman: RRsTrainman; var CallWork: RRsCallNotify);
const
  ADD_MSG = 0 ;
  DEL_MSG = 1 ;
var
  strMsg:string;
begin
  case CallWork.nCallWorkType of
    ADD_MSG :
    begin
      strMsg := Format('【新的计划】%s[%s] 车次:[%s] 开车时间:[%s],出勤点:[%s]',[Trainman.strTrainmanName,Trainman.strTrainmanNumber,
        TrainmanPlan.TrainPlan.strTrainNo,FormatDateTime('yy-MM-dd hh:nn',TrainmanPlan.TrainPlan.dtStartTime),
        TrainmanPlan.TrainPlan.strPlaceName]);
    end;
    DEL_MSG :
    begin
      strMsg := Format('【取消计划】 %s[%s] 车次:[%s] 开车时间:[%s],出勤点:[%s]',[Trainman.strTrainmanName,Trainman.strTrainmanNumber,
        TrainmanPlan.TrainPlan.strTrainNo,FormatDateTime('yy-MM-dd hh:nn',TrainmanPlan.TrainPlan.dtStartTime),
        TrainmanPlan.TrainPlan.strPlaceName]);
    end;
  end;

  with callWork do
  begin
    strTrainPlanGUID :=  TrainmanPlan.TrainPlan.strTrainPlanGUID ;
    dtCallTime := TrainmanPlan.RestInfo.dtCallTime;
    strTrainNo := TrainmanPlan.TrainPlan.strTrainNo;
    dtStartTime := TrainmanPlan.TrainPlan.dtChuQinTime;
    dtChuQinTime := TrainmanPlan.TrainPlan.dtStartTime;
    dtSendTime := GlobalDM.GetNow;
    strSendUser := GlobalDM.LogUserInfo.strDutyUserName;
    eCallState := cwsNotify;
    strMsgGUID := NewGUID ;
    strSendMsgContent := strMsg ;
    nCancel := 0;

    strTrainmanGUID :=  Trainman.strTrainmanGUID ;
  end;
end;

procedure TfrmMain_RenYuan.FillNewPlan(var TrainmanPlan: RRsTrainmanPlan);
begin
with TrainmanPlan do
  begin
    TrainmanPlan.TrainPlan.nPlanState := psEdit;
    
    TrainPlan.strTrainPlanGUID := NewGUID;
    TrainPlan.strTrainTypeName := '';
    TrainPlan.strTrainNumber := '';
    TrainPlan.strTrainNo := '';
    TrainPlan.dtStartTime := strToDateTime('2000-01-01');
    TrainPlan.dtRealStartTime := strToDateTime('2000-01-01');
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

    TrainPlan.nPlanState := psSent;

    TrainPlan.strPlanStateName := TRsPlanStateNameAry[TrainPlan.nPlanState];

    TrainPlan.dtCreateTime := m_dtNow;

    TrainPlan.strCreateSiteGUID := GlobalDM.SiteInfo.strSiteGUID;

    TrainPlan.strCreateSiteName := GlobalDM.SiteInfo.strSiteName;

    TrainPlan.strCreateUserGUID := GlobalDM.DutyUser.strDutyGUID;

    TrainPlan.strCreateUserName := GlobalDM.DutyUser.strDutyName;
  end;
end;

procedure TfrmMain_RenYuan.m1Click(Sender: TObject);
begin
  //以前的名牌变动日志
  // TFrmNameBoardChangeLog.Open;
  //备班变动日志
  TFrmNameBoardPrepareChangeLog.Open;
end;

procedure TfrmMain_RenYuan.menuAskLeaveClick(Sender: TObject);
var
  aRow,aCol:Integer ;
  strTrainmanNumber:string;
  group:RRsGroup;
begin
  aRow := DrawGridGroups.Row ;
  aCol := DrawGridGroups.Col ;

  if Length(m_arrayGroupGrid) < 0 then
    Exit ;

  if aRow < 0 then
   Exit ;

  group := m_arrayGroupGrid[arow];

  case aCol of
   COLUMN_TRAINMAN1 :
    begin
      strTrainmanNumber := group.Trainman1.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN2 :
    begin
      strTrainmanNumber := group.Trainman2.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN3 :
    begin
      strTrainmanNumber := group.Trainman3.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN4 :
    begin
      strTrainmanNumber := group.Trainman4.strTrainmanNumber ;
    end;
  end;
  if strTrainmanNumber = '' then
    Exit ;
  TFrmAskLeave.ShowAskLeaveFormByNumber(strTrainmanNumber);

  InitGroups;

end;

procedure TfrmMain_RenYuan.actMealTicketConfigExecute(Sender: TObject);
begin
  TFrmMealTicketConfig.Config;
end;

procedure TfrmMain_RenYuan.actMealTicketFaFangExecute(Sender: TObject);
begin
  TFrmAddMealTicket.GiveTicket;
end;

procedure TfrmMain_RenYuan.actMealTicketViewExecute(Sender: TObject);
begin
  ;
end;

procedure TfrmMain_RenYuan.AddNewPlan(Plan: RRsTrainmanPlan);
var
  receivePlan:RRsReceiveTrainPlan;
  strError:string;
begin
  receivePlan.TrainPlan := Plan.TrainPlan  ;
  receivePlan.strUserID := GlobalDM.DutyUser.strDutyGUID ;
  receivePlan.strUserName := GlobalDM.DutyUser.strDutyName ;
  receivePlan.strSiteID := GlobalDM.SiteInfo.strSiteGUID ;
  receivePlan.strSiteName := GlobalDM.SiteInfo.strSiteName ;

  if not m_webTrainPlan.RecieveTrainPlan(receivePlan,strError) then
  begin
    BoxErr(strError);
    Exit;
  end;
end;

procedure TfrmMain_RenYuan.AddPlan;
var
  TrainmanPlan: RRsTrainmanPlan;
  strTrainJiaoluGUID : string;
  listDutyPlace:TRsDutyPlaceList ;
  strError : string;
begin
  if not GetSelectedTrainJiaolu(strTrainJiaoluGUID) then
  begin
    Box('您还为设置行车区段信息！');
    exit;
  end;

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

  TrainmanPlan.TrainPlan.strPlaceID :=   listDutyPlace[0].placeID ;
  TrainmanPlan.TrainPlan.strPlaceName := listDutyPlace[0].placeName ;
  
  FillNewPlan(TrainmanPlan);
  AddNewPlan(TrainmanPlan);
  InitTrainmanPlan;
end;

procedure TfrmMain_RenYuan.AddRTrainmanPlanToControl(
  TrainmanPlan: RRsTrainmanPlan;nRow: Integer);
begin
  with strGridTrainPlan do
  begin
    Cells[COL_XUHAO_INDEX, nRow + 1] := IntToStr(nRow + 1);
    Cells[COL_STATE_INDEX, nRow + 1] := TRsPlanStateNameAry[TrainmanPlan.TrainPlan.nPlanState];

    //如果是已下发或者以接受状态就高亮全行
    if TrainmanPlan.TrainPlan.nPlanState in [psSent,psReceive] then
    begin
      RowColor[nRow+1] :=   clYellow  ;
      //AddImageIdx(0,nRow+1,0,2,2)  ;
    end;

    Cells[COL_TRAINJIAOLU_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strTrainJiaoluName;
    Cells[COL_WAIQIN_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strWaiQinClientName;
    Cells[COL_TRAINTYPE_INDEX, nRow + 1] :=  TrainmanPlan.TrainPlan.strTrainTypeName;
    Cells[COL_TRAINNO_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strTrainNumber;
    Cells[COL_CHECI_INDEX, nRow + 1] :=  TrainmanPlan.TrainPlan.strTrainNo;
    Cells[COL_PLAN_CHUQIN_TIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtStartTime);
    Cells[COL_PLANKAICHETIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtChuQinTime);
    Cells[COL_REALKAICHETIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtRealStartTime);
    if TrainmanPlan.TrainPlan.dtRealBeginWorkTime <> 0 then
      Cells[COL_BEGINWORKTIME_INDEX,nRow + 1 ] :=   FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtRealBeginWorkTime)
    else
      Cells[COL_BEGINWORKTIME_INDEX,nRow + 1 ] := '' ;
    Cells[COL_STARTSTATION_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strStartStationName;
    Cells[COL_ENDSTATION_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strEndStationName;
    Cells[COL_TRAINMANTYPE_INDEX, nRow + 1] := TRsTrainmanTypeName[TrainmanPlan.TrainPlan.nTrainmanTypeID];
    Cells[COL_PLANTYPE_INDEX, nRow + 1] := TRsPlanTypeName[TrainmanPlan.TrainPlan.nPlanType];
    Cells[COL_DRAGSTATE_INDEX, nRow + 1] := TRsDragTypeName[TrainmanPlan.TrainPlan.nDragType];
    Cells[COL_KEHUO_INDEX, nRow + 1] := TRsKeHuoNameArray[TrainmanPlan.TrainPlan.nKeHuoID];
    Cells[COL_REMARKTYPE_INDEX, nRow + 1] := TRsPlanRemarkTypeName[TrainmanPlan.TrainPlan.nRemarkType];
    Cells[COL_REMARK_INDEX, nRow + 1] := TrainmanPlan.TrainPlan.strRemark;

    if TrainmanPlan.Group.strGroupGUID  <> '' then
    begin
      Cells[COL_TRAINMAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman1);
      Cells[COL_TRAINMAN_CALLWORK,nRow + 1]  := TRsCallWorkStateName[TrainmanPlan.Group.Trainman1.nCallWorkState] ;

      Cells[COL_SUBTRAINMAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman2);
      Cells[COL_SUBTRAINMAN_CALLWORK,nRow + 1]  := TRsCallWorkStateName[TrainmanPlan.Group.Trainman2.nCallWorkState] ;

      Cells[COL_XUEYUAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman3);
      Cells[COL_XUEYUAN_CALLWORK,nRow + 1]  := TRsCallWorkStateName[TrainmanPlan.Group.Trainman3.nCallWorkState] ;

      Cells[COL_XUEYUAN2_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman4);
      Cells[COL_XUEYUAN2_CALLWORK,nRow + 1]  := TRsCallWorkStateName[TrainmanPlan.Group.Trainman4.nCallWorkState] ;
    end;
    if TrainmanPlan.TrainPlan.nNeedRest > 0 then
    begin
      Cells[COL_HOUBAN_INDEX, nRow + 1] := '侯班';
      Cells[COL_HOUBANTIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtArriveTime);
      Cells[COL_JIAOBAN_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtCallTime);
    end;

    Cells[COL_DUTYPLACE_INDEX , nRow + 1 ] := TrainmanPlan.TrainPlan.strPlaceName ;
    Cells[COL_SendPlan_Index,nRow + 1] :=  FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtSendPlanTime);
    Cells[COL_RecPlan_INDEX,nRow + 1] :=  FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.TrainPlan.dtRecvPlanTime);
    Cells[99, nRow + 1] := TrainmanPlan.TrainPlan.strTrainPlanGUID;
  end;

end;



procedure TfrmMain_RenYuan.AdvSplitter3Moved(Sender: TObject);
begin
  AdvSplitter3.Left := pGroup.Left-1;
end;

procedure TfrmMain_RenYuan.advstrngrdLogGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_RenYuan.AutoDispatchRenYuan();
var
  i : integer;
  planGUID : string;
  trainmanPlan : RRsTrainmanPlan;
  trainJiaoluGUID : string;
  NeedPaibanPlans: TStringList;
  ErrInfo: string;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;

  NeedPaibanPlans := TStringList.Create;
  try
    try
      //获取选中计划的GUID，并判断选中的计划是否符合要求
      for i := 1 to strGridTrainPlan.RowCount - 1 do
      begin
        planGUID := strGridTrainPlan.Cells[99, i];
        if planGUID = '' then
        begin
          GlobalDM.LogManage.InsertLog('自动派班 planGUID 为空 ');
          continue;
        end;

        if not m_webTrainPlan.GetTrainmanPlanByGUID(planGUID,trainmanPlan,ErrInfo) then
        begin
          GlobalDM.LogManage.InsertLog('自动派班,获取计划失败：' + ErrInfo);
          Continue;
        end;

        if trainmanPlan.TrainPlan.nPlanState <> psReceive then
        begin
          GlobalDM.LogManage.InsertLog('自动派班 计划不是已接受状态 ');
          continue;
        end;
        if trainmanPlan.Group.strGroupGUID <> '' then
        begin
          GlobalDM.LogManage.InsertLog('自动派班 机组GUID为空 ');
         continue;
        end;

        NeedPaibanPlans.Add(planGUID);
      end;
      if NeedPaibanPlans.Count = 0 then
      begin
        Application.MessageBox('没有需要派班的计划！', '提示', MB_OK + MB_ICONINFORMATION);
        exit;
      end;
      if not TBox('您确认要对当前的行车区段进行自动派班吗？') then exit;

      m_LCPaiBan.AutoDispatch(trainJiaoluGUID,NeedPaibanPlans.CommaText,GlobalDM.DutyUser);
      InitTrainmanPlan;
      Box('派班成功！');
    finally
      NeedPaibanPlans.Free;
    end;
  except on e : exception do
    begin
      Box('自动派班失败:' + e.Message);
    end;
  end;
end;

procedure TfrmMain_RenYuan.btnCancelPlanClick(Sender: TObject);
var
  guids: TStringList;
  bCancleSuccess: Boolean;
begin
  guids := TStringList.Create;
  try
    GetSelectePlanGUIDS(guids);
    if (guids.Count = 0)  then
    begin
      Application.MessageBox('没有要撤销的计划！', '提示', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    if m_bEditPlanEnable then
      bCancleSuccess := RemovePlan(guids)
    else
      bCancleSuccess := RemoveSubPlan(guids);

    if bCancleSuccess then
    begin
      PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_DELETE,guids);
      InitTrainmanPlan();
      Application.MessageBox('撤销计划成功！', '提示', MB_OK + MB_ICONINFORMATION);
    end;

  finally
    guids.Free;
  end;

end;



procedure TfrmMain_RenYuan.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;




procedure TfrmMain_RenYuan.btnNameplateClick(Sender: TObject);
var
  bCanEdit : boolean;
begin
  bCanEdit :=  GlobalDM.SiteConfigs.Values['DelPlate'] = '1';
  RsLibHelper.TRsLibHelperFactory.Helper.NameplateLib.ShowNameplate(true,bCanEdit);
end;

procedure TfrmMain_RenYuan.tabTrainJiaoluChange(Sender: TObject);
var
  trainjiaoluguid : string;
  error : string;
begin
  try
    TfrmHint.ShowHint('正在加载计划,请稍等...');
    InitTrainmanPlan;
    InitPrepareTrainmanJiaolus ;
    InitManaulPaiBan;
    InitStations();

     if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;
    SetLength(m_PlaceList,0);
    if not m_webDutyPlace.GetDutyPlaceByJiaoLu(trainJiaoluGUID,m_PlaceList,error) then
    begin
      BoxErr('获取出勤点错误: '+ error);
      exit ;
    end;
  finally
    TfrmHint.CloseHint;
  end;
end;

procedure TfrmMain_RenYuan.tabTrainJiaoluPaintTabBackground(Sender: TObject;
  ACanvas: TCanvas; ATabIndex: Integer; const ARect: TRect;
  var Handled: Boolean);
var
  tabIndex : Char ;
begin
  tabIndex := char ( ATabIndex ) ;
  if tabIndex  in   m_planManager.GetUnHandledJiaoLu  then
  begin
    Handled := True ;
    ACanvas.Brush.Color := clYellow ;
    ACanvas.FillRect(ARect);
  end
  else
  begin
    Handled := True ;
    ACanvas.Brush.Color := clBtnFace ;
    ACanvas.FillRect(ARect);
  end;
end;

procedure TfrmMain_RenYuan.TimerCheckUpdateTimer(Sender: TObject);
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

procedure TfrmMain_RenYuan.TimerRefreshDataTimer(Sender: TObject);
var
  RemindString: string;
begin
  if not GlobalDM.RoomRemind  then Exit;

  RemindString := m_RemindCtl.GetRemindString();
  if Trim(RemindString) <> '' then
  begin
    TfrmRemind.ShowBox(RemindString);
  end;

end;
procedure TfrmMain_RenYuan.tmrRefreshSendLogTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    m_dtNow := GlobalDM.GetNow;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', m_dtNow);
    statusMessage.Caption := Format('消息缓存：%d条', [GlobalDM.TFMessageCompnent.MessageBufferCount]);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TfrmMain_RenYuan.tmrSharkIconTimer(Sender: TObject);
begin
  if Tag = 0 then
  begin
    Tag := 1;
    btnAcceptPlan.PngImage := PngImageList1.PngImages.Items[0].PngImage;
    btnAcceptPlan.Font.Style := [];
  end
  else begin
    Tag := 0;
    btnAcceptPlan.PngImage := PngImageList1.PngImages.Items[1].PngImage;
    btnAcceptPlan.Font.Style := [fsBold];
  end;
end;



procedure TfrmMain_RenYuan.UpdatePlan(nRow, nCol: Integer);
begin
  if nRow > strGridTrainPlan.RowCount - 1 then
    Exit;

  GridRowToTrainPlan(nRow,m_TrainmanPlanArray[nRow - 1].TrainPlan);
  GridRowToRest(nRow,m_TrainmanPlanArray[nRow -1].RestInfo);

  ModifyPlan(m_TrainmanPlanArray[nRow - 1].TrainPlan.strTrainPlanGUID,nRow,nCol);
end;

procedure TfrmMain_RenYuan.viewGroupMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if Button <> mbRight then exit;
  PopupMenu1.Popup(Mouse.CursorPos.X,Mouse.CursorPos.Y);
end;



procedure TfrmMain_RenYuan.WMInputVerify(var Msg: TMessage);
begin
end;

{
procedure TfrmMain_RenYuan.WMRefreshGroup(var Message: TMessage);
begin
  InitGroups;
  lstboxGroups.ItemIndex := message.WParam;
end;
}
procedure TfrmMain_RenYuan.WMRefreshGroup(var Message: TMessage);
begin
  InitGroups;
end;

procedure TfrmMain_RenYuan.WMRefreshJiaoLu(var Msg: TMessage);
begin
  tabTrainJiaolu.Invalidate;
end;

procedure TfrmMain_RenYuan.X1Click(Sender: TObject);
var
  strTrainmanNumber:string;
  nIndex : integer;
begin
  nIndex := lstBoxLeaveTrainmans.ItemIndex ;
  if nIndex = -1 then
    Exit ;

  if m_TrainmanLeaveArray[nIndex].Trainman.strTrainmanGUID = '' then
    Exit;

  strTrainmanNumber := m_TrainmanLeaveArray[nIndex].Trainman.strTrainmanNumber ;

  if strTrainmanNumber = '' then
    exit ;
  lstBoxLeaveTrainmans.ItemIndex ;
  TFrmCancelLeave.ShowCancelLeaveForm(strTrainmanNumber);

  InitLeaveTrainmans;

end;

procedure TfrmMain_RenYuan.menuCancelLeaveClick(Sender: TObject);
var
  aRow,aCol:Integer ;
  strTrainmanNumber:string;
begin
  aRow := DrawGridGroups.Row ;
  aCol := DrawGridGroups.Col ;

  if aRow < 0 then
   Exit ;
  case aCol of
   COLUMN_TRAINMAN1 :
    begin
      strTrainmanNumber := m_GroupArray[arow].Trainman1.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN2 :
    begin
      strTrainmanNumber := m_GroupArray[arow].Trainman2.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN3 :
    begin
      strTrainmanNumber := m_GroupArray[arow].Trainman3.strTrainmanNumber ;
    end;
   COLUMN_TRAINMAN4 :
    begin
      strTrainmanNumber := m_GroupArray[arow].Trainman4.strTrainmanNumber ;
    end;
  end;
  if strTrainmanNumber = '' then
    exit ;
  TFrmCancelLeave.ShowCancelLeaveForm(strTrainmanNumber);
end;

procedure TfrmMain_RenYuan.menuSetTrainmanClick(Sender: TObject);
var
  aRow,aCol:Integer ;
  trainman:rrstrainman;
  trainmanJiaoLu:RRsTrainmanJiaolu ;
  strTrainmanID:string;
  group:rrsgroup;
  TrainmanIndex : integer ;
  AddInput: TRsLCTrainmanAddInput;
begin
  aRow := DrawGridGroups.Row ;
  aCol := DrawGridGroups.Col ;

  if aRow < 0 then
   Exit ;
  case aCol of
   COLUMN_TRAINMAN1 :
    begin
      strTrainmanID := m_arrayGroupGrid[arow].Trainman1.strTrainmanGUID ;
      TrainmanIndex := 1 ;
    end;
   COLUMN_TRAINMAN2 :
    begin
      strTrainmanID := m_arrayGroupGrid[arow].Trainman2.strTrainmanGUID ;
      TrainmanIndex := 2 ;
    end;
   COLUMN_TRAINMAN3 :
    begin
      strTrainmanID := m_arrayGroupGrid[arow].Trainman3.strTrainmanGUID ;
      TrainmanIndex := 3 ;
    end;
   COLUMN_TRAINMAN4 :
    begin
      strTrainmanID := m_arrayGroupGrid[arow].Trainman4.strTrainmanGUID ;
      TrainmanIndex := 4 ;
    end;
   else
   begin
    TrainmanIndex := 0 ;
   end;
  end;
  if TrainmanIndex = 0 then
    Exit ;
  
  group := m_arrayGroupGrid[arow] ;

  if strTrainmanID <> '' then
  begin
    BoxErr('不能在已有人员的地方!');
    Exit ;
  end;

  //输入一个人员
  if not TFrmAddUser.InputTrainman('',Trainman) then exit;

  //检测该人员是否可以添加
  if not CheckAddTrainman(Group,trainman) then exit;

  m_RsLCNameBoardEx.Group.GetTrainmanJiaoluOfGroup(group.strGroupGUID,trainmanjiaolu);

  AddInput := TRsLCTrainmanAddInput.Create;
  try
    AddInput.TrainmanJiaolu.SetTrainmanJL(trainmanJiaoLu);
    AddInput.DutyUser.Assign(m_DutyUser);
    AddInput.TrainmanNumber := Trainman.strTrainmanNumber;
    AddInput.TrainmanIndex := TrainmanIndex;
    AddInput.GroupGUID := group.strGroupGUID;
    m_RsLCNameBoardEx.Group.AddTrainman(AddInput);
  finally
     AddInput.Free;
  end;
  InitGroups ;
end;

procedure TfrmMain_RenYuan.menuTrainmanInfoClick(Sender: TObject);
var
  aRow,aCol:Integer ;
  strTrainmanGUID:string;
begin
  aRow := DrawGridGroups.Row ;
  aCol := DrawGridGroups.Col ;

  if aRow < 0 then
   Exit ;
  case aCol of
   COLUMN_TRAINMAN1 :
    begin
      strTrainmanGUID := m_arrayGroupGrid[arow].Trainman1.strTrainmanGUID ;
    end;
   COLUMN_TRAINMAN2 :
    begin
      strTrainmanGUID := m_arrayGroupGrid[arow].Trainman2.strTrainmanGUID ;
    end;
   COLUMN_TRAINMAN3 :
    begin
      strTrainmanGUID := m_arrayGroupGrid[arow].Trainman3.strTrainmanGUID ;
    end;
   COLUMN_TRAINMAN4 :
    begin
      strTrainmanGUID := m_arrayGroupGrid[arow].Trainman4.strTrainmanGUID ;
    end;
  end;

  if strTrainmanGUID = '' then
    Exit ;

  if TfrmTrainmanDetail.ViewTrainmanDetail(strTrainmanGUID) then
    TtfPopBox.ShowBox('修改成功');

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




