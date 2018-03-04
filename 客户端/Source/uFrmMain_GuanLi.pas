unit uFrmMain_GuanLi;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Menus, StdCtrls, RzPanel, Grids, AdvObj, BaseGrid, AdvGrid,
  ADODB, Buttons, RzStatus, pngimage,RzCmboBx, RzTabs, DB, PngSpeedButton,
  RzButton,RzLabel, RzSplit, RzRadChk, ComCtrls,RzListVw,uTFMessageDefine,
  uTrainPlan, uSite,uTrainJiaolu,uTrainman,
  uTFSystem,uSaftyEnum, RzLstBox, RzChkLst,
  uRoomSign,AdvSplitter, AdvDateTimePicker,uRunSaftyMessageDefine,ActnList, ImgList,
  PngImageList, AdvListV,RzDTP,uGlobalDM, Mask, RzEdit,uRSCommonFunctions,
  uTrainmanJiaolu,ComObj, uFrmProgressEx,
  uLeaveListInfo,  uGuideGroup, TeeProcs, TeEngine, Chart, Series,
   RzRadGrp,uFrmPaiBanRecord,ufrmViewGroupOrder,uFrmNameBoardChangeLog,
  uLCAskLeave,uLCBaseDict,uLCTrainPlan,uLCBeginWork,uLCLocalRoom,uLCTrainmanMgr;
const
  COL_XUHAO_INDEX = 0;
  COL_STATE_INDEX = 1;
  COL_TRAINJIAOLU_INDEX = 2;
  COL_TRAINTYPE_INDEX = 3;
  COL_TRAINNO_INDEX = 4;
  COL_CHECI_INDEX = 5;
  COL_PLANKAICHETIME_INDEX = 6;
  COL_REALKAICHETIME_INDEX = 7;
  COL_BEGINWORKTIME_INDEX = 8;

  COL_TRAINMAN_INDEX = 9;
  COL_SUBTRAINMAN_INDEX = 10;
  COL_XUEYUAN_INDEX = 11;
  COL_XUEYUAN2_INDEX = 12;

  COL_STARTSTATION_INDEX = 13;
  COL_ENDSTATION_INDEX = 14;
  COL_TRAINMANTYPE_INDEX = 15;
  COL_PLANTYPE_INDEX = 16;
  COL_DRAGSTATE_INDEX = 17;
  COL_KEHUO_INDEX = 18;
  COL_REMARKTYPE_INDEX = 19;
  COL_REMARK_INDEX = 20;

  COL_HOUBAN_INDEX = 21;
  COL_HOUBANTIME_INDEX = 22;
  COL_JIAOBAN_INDEX = 23;
  
type
  TfrmMain_GuanLi = class(TForm)
    tmrRefreshSendLog: TTimer;
    statusBar1: TRzStatusBar;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    miModifyPassword: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    mmExit: TMenuItem;
    N4: TMenuItem;
    mTrainmanManage: TMenuItem;
    N6: TMenuItem;
    N36: TMenuItem;
    statusFinger: TRzStatusPane;
    statusSysTime: TRzGlyphStatus;
    statusPanelDBState: TRzStatusPane;
    statusAppVersion: TRzGlyphStatus;
    TimerCheckUpdate: TTimer;
    statusUpdate: TRzStatusPane;
    OpenDialog1: TOpenDialog;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    IC1: TMenuItem;
    N7: TMenuItem;
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    RzPanel1: TRzPanel;
    btnRefreshPaln: TPngSpeedButton;
    Label4: TLabel;
    btnDelBeginWork: TPngSpeedButton;
    btnCancelPlan: TPngSpeedButton;
    dtpPlanStartDate: TRzDateTimePicker;
    dtpPlanStartTime: TRzDateTimePicker;
    RzPanel4: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    RzPanel8: TRzPanel;
    Panel4: TPanel;
    RzPanel3: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    TabSheet2: TRzTabSheet;
    RzPanel2: TRzPanel;
    btnRefreshRoomInfo: TPngSpeedButton;
    Label1: TLabel;
    dtRoomStartDate: TRzDateTimePicker;
    dtRoomStartTime: TRzDateTimePicker;
    RoomInfoGrid: TAdvStringGrid;
    TabSheet3: TRzTabSheet;
    RzPanel5: TRzPanel;
    Label3: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    btnQuery: TPngSpeedButton;
    btnViewDetail: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    btnCancelLeave: TPngSpeedButton;
    edtNumber: TRzEdit;
    cmbType: TRzComboBox;
    cmbStatus: TRzComboBox;
    cmbPost: TRzComboBox;
    cmbGroup: TRzComboBox;
    checkDataRange: TRzCheckBox;
    dtpBeginDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    strGridLeaveInfo: TAdvStringGrid;
    tbsTabSheet4: TRzTabSheet;
    PageControl1: TRzPageControl;
    tbsTabSheet5: TRzTabSheet;
    chartPerson: TChart;
    Series1: TBarSeries;
    tbsTabSheet6: TRzTabSheet;
    chartJiaolu: TChart;
    Series2: TBarSeries;
    tbsTabSheet7: TRzTabSheet;
    chartXiuJia: TChart;
    Series3: TBarSeries;
    tbsTabSheet8: TRzTabSheet;
    rzpnl2: TRzPanel;
    AdvSplitter1: TAdvSplitter;
    rzpnl1: TRzPanel;
    rzpnl4: TRzPanel;
    chartYunZhuan: TChart;
    Label9: TLabel;
    lblTotalCount: TLabel;
    Series4: TPieSeries;
    RzPanel6: TRzPanel;
    strGridTrainman: TAdvStringGrid;
    panel1: TRzPanel;
    lvJiaoLu: TRzListView;
    RzRadioGroup1: TRzRadioGroup;
    N8: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    miPaibanRecord: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    miBoardChangeLog: TMenuItem;
    cbkShowAllUnEnd: TRzCheckBox;
    N9: TMenuItem;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N19: TMenuItem;
    N20: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure NExitClick(Sender: TObject);
    procedure strGridTrainPlanGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure FormCreate(Sender: TObject);
    procedure mTrainmanManageClick(Sender: TObject);
    procedure advstrngrdLogGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure miModifyPasswordClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure tmrRefreshSendLogTimer(Sender: TObject);
    procedure strGridTrainPlanCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure tabTrainJiaoluChange(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure btnDelBeginWorkClick(Sender: TObject);
    procedure btnRefreshRoomInfoClick(Sender: TObject);
    procedure btnCancelPlanClick(Sender: TObject);
    procedure TimerCheckUpdateTimer(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnViewDetailClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnCancelLeaveClick(Sender: TObject);
    procedure cmbTypeChange(Sender: TObject);
    procedure checkDataRangeClick(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure RzRadioGroup1Click(Sender: TObject);
    procedure lvJiaoLuClick(Sender: TObject);
    procedure chartYunZhuanClickSeries(Sender: TCustomChart;
      Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure miPaibanRecordClick(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure miBoardChangeLogClick(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N18Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
  private
    m_RsRoomSignList: TRsRoomSignList;
    m_LCLocalRoom: TLCLocalRoom;
    m_LCBeginWork: TLCBeginwork;
    m_RsLCAskLeave: TRsLCAskLeave;
    m_RsLCTrainPlan: TRsLCTrainPlan;
    m_RsLCTrainmamMgr: TRsLCTrainmanMgr;
    //行车区段数组
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //数据刷新的计划数组
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    //当前时间
    m_dtNow : TDateTime;
    m_TrainmanRunStateCountArray:TRTrainmanRunStateCountArray;
  private
    //
    //获取人员统计
    procedure GetTrainmanState();
    //获取交路统计
    procedure GetTrainmanJiaoLu();
    //获取休假统计
    procedure GetTrainmanHolidy();
    //获取运行统计
    procedure GetTrainmanRun();
    //跟新运用清空到列表
    procedure UpdateGrid(TrainmanRunStateCount:RTrainmanRunStateCount;AType:Integer);

   { Private declarations }
   //初始化所有的数据
    procedure InitData;
    //初始化行车区段信息
    procedure InitTrainJiaolus;
    //初始化人员计划
    procedure InitTrainmanPlan;
    //判断指定列是否为司机列
    function IsTrainmanCol(nCol: Integer): Boolean;
    //判断指定列是否为副司机列
    function IsSubTrainmanCol(nCol: Integer): Boolean;
    //判断是否为学员列
    function IsXueYuanTrainmanCol(nCol: Integer): Boolean;
    //判断是否为学员列
    function IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
    //获取选中的行车区段信息
    function GetSelectedTrainJiaolu(out TrainJiaoluGUID : string):boolean;
    //获取选择的计划信息
    function GetSelectedTrainmanPlan(out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //获取选中的司机工号
    function GetSelectedTrainman(var Trainman: RRsTrainman;out TrainmanIndex : integer): Boolean;
    {功能:添加一条计划到界面}
    procedure AddRTrainmanPlanToControl(TrainmanPlan: RRsTrainmanPlan;
        nRow: Integer);
    {功能:刷新显示计划}
    procedure RefreshTrainmanPlan();
    procedure RefreshRoomInfo();
    function RemovePlan(guids: TStringList): Boolean;

    function FormatGroupName(Group: RRsGroup): string;


    procedure PostPlanRenYuanMessage(msg: Integer;GUIDS: TStrings);overload;
    procedure OnAppVersionChange(Sender: TObject);
    
    //查询请假信息
    procedure QueryLeaveInfo;
    //获取当前选中的请假信息
    function GetSelectRowIndex(out rowIndex: integer): boolean;
    //导出请假信息
    procedure ExportLeaveInfo;
    //设置日期范围的初始值及是否可用
    procedure SetDateRange();
    //初始化界面
    procedure InitLeave;
  public
    //进入派班功能模块
    class procedure EnterGuanLi;
    //离开派班功能模块
    class procedure LeaveGuanLi;
  end;
  
var
  frmMain_GuanLi: TfrmMain_GuanLi;

implementation
{$R *.dfm}
uses
  dateUtils, uFrmTrainmanManage,
  uFrmSetStringGridCol,uFrmExchangeModule,ufrmModifyPassWord,
  uFrmLogin,utfPopBox,uFrmAskLeaveDetail,uFrmViewMealTicket,uFrmTuiqinTimeLog,
  uFrmGoodsManage,uFrmGoodsRangeManage, ufrmGanBuMgr,
  ufrmGanBuType, uFrmAnnualLeave, uFrmKeyTrainmanMgr, uFrmMealticketServerCfg,
  uFrmViewMealTicketLog,ufrmTQRelZhuanChu,RsLibHelper;




procedure TfrmMain_GuanLi.dtpPlanStartTimeChange(Sender: TObject);
begin
  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
end;



class procedure TfrmMain_GuanLi.EnterGuanLi;
begin
  if frmMain_GuanLi = nil then
  begin
    Application.CreateForm(TfrmMain_GuanLi, frmMain_GuanLi);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,frmMain_GuanLi);
    frmMain_GuanLi.InitData;
  end;
  frmMain_GuanLi.Show;
end;

procedure TfrmMain_GuanLi.ExportLeaveInfo;
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
begin
  if strGridLeaveInfo.RowCount <= 1 then
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;
  if (strGridLeaveInfo.RowCount = 2) and (strGridLeaveInfo.Cells[999, 1] = '') then 
  begin
    Box('请先查询出您要导出的请假信息！');
    exit;
  end;

  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel,请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    if FileExists(excelFile) then
    begin
      excelApp.workBooks.Open(excelFile);
      workSheet := excelApp.Worksheets[1];
      workSheet.activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;

    m_nIndex := 1;
    excelApp.Cells[m_nIndex,1] := '工号';
    excelApp.Cells[m_nIndex,2] := '姓名';
    excelApp.Cells[m_nIndex,3] := '请假类型';
    excelApp.Cells[m_nIndex,4] := '请假开始时间';
    excelApp.Cells[m_nIndex,5] := '请假结束时间';
    excelApp.Cells[m_nIndex,6] := '当前状态';
    excelApp.Cells[m_nIndex,7] := '请假批准人';
    excelApp.Cells[m_nIndex,8] := '操作员';
    excelApp.Cells[m_nIndex,9] := '备注信息';
    excelApp.Cells[m_nIndex,10] := '职位';
    excelApp.Cells[m_nIndex,11] := '指导队';
    
    Inc(m_nIndex);
    for i := 1 to strGridLeaveInfo.RowCount - 1 do
    begin
      if strGridLeaveInfo.Cells[999, i] <> '' then
      begin
        excelApp.Cells[m_nIndex,1] := strGridLeaveInfo.Cells[1, i];
        excelApp.Cells[m_nIndex,2] := strGridLeaveInfo.Cells[2, i];
        excelApp.Cells[m_nIndex,3] := strGridLeaveInfo.Cells[3, i];
        excelApp.Cells[m_nIndex,4] := strGridLeaveInfo.Cells[4, i];
        excelApp.Cells[m_nIndex,5] := strGridLeaveInfo.Cells[5, i];
        excelApp.Cells[m_nIndex,6] := strGridLeaveInfo.Cells[6, i];
        excelApp.Cells[m_nIndex,7] := strGridLeaveInfo.Cells[7, i];
        excelApp.Cells[m_nIndex,8] := strGridLeaveInfo.Cells[8, i];
        excelApp.Cells[m_nIndex,9] := strGridLeaveInfo.Cells[9, i];
        excelApp.Cells[m_nIndex,10] := strGridLeaveInfo.Cells[10, i];
        excelApp.Cells[m_nIndex,11] := strGridLeaveInfo.Cells[11, i];
      end;
      TfrmProgressEx.ShowProgress('正在导出请假信息，请稍后',i,strGridLeaveInfo.RowCount-1);
      Inc(m_nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Box('导出完毕！');
end;

function TfrmMain_GuanLi.FormatGroupName(Group: RRsGroup): string;
begin
  Result := '';

  if Group.Trainman1.strTrainmanName <> '' then
  begin
    if Result = '' then
      Result := Group.Trainman1.strTrainmanName
    else
      Result := Result + ',' + Group.Trainman1.strTrainmanName;
  end;

  if Group.Trainman2.strTrainmanName <> '' then
  begin
    if Result = '' then
      Result := Group.Trainman2.strTrainmanName
    else
      Result := Result + ',' + Group.Trainman2.strTrainmanName;
  end;

  if Group.Trainman3.strTrainmanName <> '' then
  begin
    if Result = '' then
      Result := Group.Trainman3.strTrainmanName
    else
      Result := Result + ',' + Group.Trainman3.strTrainmanName;
  end;

  if Group.Trainman4.strTrainmanName <> '' then
  begin
    if Result = '' then
      Result := Group.Trainman4.strTrainmanName
    else
      Result := Result + ',' + Group.Trainman4.strTrainmanName;
  end;

end;

procedure TfrmMain_GuanLi.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not Showing then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_GuanLi.FormCreate(Sender: TObject);
begin

  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  strGridTrainPlan.SelectionRectangleColor := clRed;


  m_RsLCAskLeave:= TRsLCAskLeave.Create(GlobalDM.WebAPIUtils);
  m_LCLocalRoom := TLCLocalRoom.Create(GlobalDM.WebAPIUtils);

  m_RsRoomSignList:= TRsRoomSignList.Create;
  m_LCBeginWork:= TLCBeginwork.Create(GlobalDM.WebAPIUtils);
  m_RsLCTrainPlan:= TRsLCTrainPlan.Create('','','');
  m_RsLCTrainPlan.SetConnConfig(GlobalDM.HttpConnConfig);
  m_RsLCTrainmamMgr:= TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);



  //记录strGrid的列宽
  strGridTrainPlan.ColumnSize.Key := 'FormColWidths.ini';
  strGridTrainPlan.ColumnSize.Section := 'GuanLiPlanInfo';
  strGridTrainPlan.ColumnSize.Save := false;
  strGridTrainPlan.ColumnSize.Location := clIniFile;
  GlobalDM.SetGridColumnWidth(strGridTrainPlan);    
  GlobalDM.SetGridColumnVisible(strGridTrainPlan);
  dtpPlanStartTime.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  m_dtNow := GlobalDM.GetNow;
  RzPageControl1.ActivePageIndex := 0;
  PageControl1.ActivePageIndex := 0 ;
  GetTrainmanState;
  //GetTrainmanRun;
end;

procedure TfrmMain_GuanLi.FormDestroy(Sender: TObject);
begin         
  GlobalDM.SaveGridColumnWidth(strGridTrainPlan);
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
  GlobalDM.FingerPrintCtl.EventHolder.Restore();
  tmrRefreshSendLog.Enabled := False;
  TimerCheckUpdate.Enabled := False;
  m_LCLocalRoom.Free;
  m_RsLCAskLeave.Free;
  m_RsRoomSignList.Free;
  m_LCBeginWork.Free;
  m_RsLCTrainPlan.Free;
  m_RsLCTrainmamMgr.Free;
end;

procedure TfrmMain_GuanLi.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Open();
  tmrRefreshSendLog.Enabled := true;
end;

function TfrmMain_GuanLi.GetSelectedTrainJiaolu(
  out TrainJiaoluGUID: string): boolean;
begin
  result := false;
  if tabTrainJiaolu.TabIndex < 0 then
    Exit;
  if length(m_TrainjiaoluArray) < tabTrainJiaolu.Tabs.Count then exit;
  TrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;
  result := true;
end;

function TfrmMain_GuanLi.GetSelectedTrainman(var Trainman: RRsTrainman;
  out TrainmanIndex: integer): Boolean;
begin
  TrainmanIndex := 0;
  Result := False;

  if strGridTrainPlan.Row > Length(m_TrainmanPlanArray) then
      Exit;
      
  if IsTrainmanCol(strGridTrainPlan.Col) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman1;
    TrainmanIndex := 1;
    Result := True;
  end
  else
  if IsSubTrainmanCol(strGridTrainPlan.Col) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman2;
    TrainmanIndex := 2;
    Result := True;
  end;
  if IsXueYuanTrainmanCol(strGridTrainPlan.Col) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman3;
    TrainmanIndex := 3;
    Result := True;
  end;
  if IsXueYuan2TrainmanCol(strGridTrainPlan.Col) then
  begin
    Trainman := m_TrainmanPlanArray[strGridTrainPlan.Row - 1].Group.Trainman4;
    TrainmanIndex := 4;
    Result := True;
  end;
end;


function TfrmMain_GuanLi.GetSelectedTrainmanPlan(
  out TrainmanPlan : RRsTrainmanPlan): boolean;
begin
  result := false;
  if strGridTrainPlan.Row < 1 then Exit;;
  if strGridTrainPlan.Row > length(m_TrainmanPlanArray) then exit;
  TrainmanPlan := m_TrainmanPlanArray[strGridTrainPlan.row - 1];
  result := true;
end;

function TfrmMain_GuanLi.GetSelectRowIndex(out rowIndex: integer): boolean;
begin
  result := false;
  if (strGridLeaveInfo.Row = 0) or (strGridLeaveInfo.Row = strGridLeaveInfo.RowCount - 1) then exit;
  rowIndex := strGridLeaveInfo.Row;
  result := true;
end;


procedure TfrmMain_GuanLi.InitData;
begin
  strGridTrainPlan.ColWidths[COL_TRAINJIAOLU_INDEX] := 0;
  strGridTrainPlan.ColWidths[COL_REALKAICHETIME_INDEX] := 0;
  dtRoomStartDate.Date := dtpPlanStartDate.DateTime;
  dtRoomStartTime.DateTime := dtpPlanStartTime.DateTime;
  InitTrainJiaolus;
  InitTrainmanPlan;
  InitLeave;
  GlobalDM.OnAppVersionChange := OnAppVersionChange;
end;



procedure TfrmMain_GuanLi.InitLeave;
var
  i: integer;
  LeaveTypeArray: TRsLeaveTypeArray;
  GuideGroupArray : TRsGuideGroupArray;
  ErrMsg : string;
begin
  dtpBeginDate.DateTime := DateUtils.StartOfTheMonth(Now);
  dtpEndDate.DateTime := DateUtils.EndOfTheMonth(Now);
  //载入请假类型列表
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('查询请假类型列表失败:' + ErrMsg);
    exit;
  end;

  cmbType.Items.Clear;
  cmbType.Values.Clear;
  cmbType.AddItemValue('全部','');
  for i := 0 to length(LeaveTypeArray) - 1 do
  begin
    cmbType.AddItemValue(LeaveTypeArray[i].strTypeName,LeaveTypeArray[i].strTypeGUID);
  end;
  cmbType.ItemIndex := 0;

  cmbStatus.Items.Clear;
  cmbStatus.Values.Clear;
  cmbStatus.AddItemValue('全部','');
  cmbStatus.AddItemValue('请假','1');
  cmbStatus.AddItemValue('销假','3');
  cmbStatus.AddItemValue('撤销','10000');
  cmbStatus.ItemIndex := 1;

  cmbPost.Items.Clear;
  cmbPost.Values.Clear;
  cmbPost.AddItemValue('全部','');
  cmbPost.AddItemValue('司机','1');
  cmbPost.AddItemValue('副司机','2');
  cmbPost.AddItemValue('学员','3');
  cmbPost.ItemIndex := 0;

  //添加指导队信息
  RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop(GlobalDM.SiteInfo.WorkShopGUID, GuideGroupArray);
  cmbGroup.Items.Clear;
  cmbGroup.Values.Clear;
  cmbGroup.AddItemValue('全部','');
  for i := 0 to length(GuideGroupArray) - 1 do
  begin
    cmbGroup.AddItemValue(GuideGroupArray[i].strGuideGroupName, GuideGroupArray[i].strGuideGroupGUID);
  end;
  cmbGroup.ItemIndex := 0;
  SetDateRange;
  QueryLeaveInfo;
end;

procedure TfrmMain_GuanLi.InitTrainJiaolus;
var
  i,tempIndex:Integer;
  tab:TRzTabCollectionItem;
begin
  tempIndex := tabTrainJiaolu.TabIndex;

  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(GlobalDM.SiteInfo.strSiteGUID,m_TrainJiaoluArray);
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
end;

procedure TfrmMain_GuanLi.InitTrainmanPlan;
var
  dtBeginTime,dtEndTime : TDateTime;
  trainJiaoluGUID : string;
  trainmanPlanArray : TRsTrainmanPlanArray;
  ErrInfo: string;
begin
  if not GetSelectedTrainJiaolu(trainJiaoluGUID) then
  begin
    Box('当前没有选中的行车区段信息');
    exit;
  end;

  dtBeginTime := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
  dtEndTime := dtBeginTime + 2;

  try
    if not m_RsLCTrainPlan.GetTrainmanPlanFromSent(trainJiaoluGUID,dtBeginTime,dtEndTime,trainmanPlanArray,ErrInfo) then
    begin
      Raise Exception.Create(ErrInfo);
    end;

    m_TrainmanPlanArray := trainmanPlanArray;

    RefreshTrainmanPlan();
  except on e: exception do
    begin
      Box('获取计划信息失败：' + e.Message);
    end;
  end;
end;


function TfrmMain_GuanLi.IsSubTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '副司机');
end;

function TfrmMain_GuanLi.IsTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '司机');
end;

function TfrmMain_GuanLi.IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员2');
end;

function TfrmMain_GuanLi.IsXueYuanTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '学员');
end;

class procedure TfrmMain_GuanLi.LeaveGuanLi;
begin
  GlobalDM.OnAppVersionChange := nil;
  if frmMain_GuanLi <> nil then
    FreeAndNil(frmMain_GuanLi);
end;




procedure TfrmMain_GuanLi.lvJiaoLuClick(Sender: TObject);
var
  i :integer;
begin
  if lvJiaoLu.Selected = nil then Exit;
  
  i := lvJiaoLu.ItemIndex ;
  chartYunZhuan.RemoveAllSeries;
  chartYunZhuan.Title.Text.Text := lvJiaoLu.Items[i].SubItems[0] + ': 运转人员分布';
  Series4.Clear;
  chartPerson.Title.Text.Text := m_TrainmanRunStateCountArray[i].strJiaoLuName ;
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nRuningCount,'运行中',clRed);
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nLocalCount,'本段休息',clGreen);
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nSiteCount,'外段休息',clBlue);
  chartYunZhuan.AddSeries(Series4);

  with m_TrainmanRunStateCountArray[i] do
  begin
    lblTotalCount.Caption := IntToStr(nRuningCount + nLocalCount  + nSiteCount ) + '个机组';
  end
end;

procedure TfrmMain_GuanLi.miBoardChangeLogClick(Sender: TObject);
begin
  TfrmNameBoardChangeLog.Open;
end;

procedure TfrmMain_GuanLi.miModifyPasswordClick(Sender: TObject);
begin
  TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;



procedure TfrmMain_GuanLi.miPaibanRecordClick(Sender: TObject);
begin
  TfrmPaibanRecord.Open;
end;

procedure TfrmMain_GuanLi.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_GuanLi.mTrainmanManageClick(Sender: TObject);
begin
  TfrmTrainmanManage.OpenTrainmanQuery;
end;



procedure TfrmMain_GuanLi.N10Click(Sender: TObject);
begin
  TFrmGoodsRangeManage.ShowForm ;
end;

procedure TfrmMain_GuanLi.N24Click(Sender: TObject);
begin
  TFrmTQRelZhuanChu.ShowTQRelFileEnd;
end;

procedure TfrmMain_GuanLi.N12Click(Sender: TObject);
begin
  RsLibHelper.TRsLibHelperFactory.Helper.NameplateLib.ShowNameplate(false,true);
end;

procedure TfrmMain_GuanLi.N14Click(Sender: TObject);
begin
  TfrmViewGroupOrder.Open;
end;

procedure TfrmMain_GuanLi.N16Click(Sender: TObject);
begin
  TFrmGanBuTypeMgr.ShowForm();
end;

procedure TfrmMain_GuanLi.N18Click(Sender: TObject);
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

procedure TfrmMain_GuanLi.N20Click(Sender: TObject);
begin
  TFrmKeyTrainmanMgr.Show;
end;

procedure TfrmMain_GuanLi.N21Click(Sender: TObject);
begin
  TFrmMealTicketServerCfg.ShowCfg;
end;

procedure TfrmMain_GuanLi.N22Click(Sender: TObject);
begin
    TFrmViewMealTicketLog.showForm(True);
end;

procedure TfrmMain_GuanLi.N23Click(Sender: TObject);
begin
  TFrmTQRelZhuanChu.ShowTQRelZC;
end;

procedure TfrmMain_GuanLi.N29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_GuanLi.N2Click(Sender: TObject);
begin
  TFrmViewMealTicket.ShowForm;
end;

procedure TfrmMain_GuanLi.N31Click(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  Exit;
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
end;

procedure TfrmMain_GuanLi.N5Click(Sender: TObject);
begin
  TFrmTuiqinTimeLog.ShowForm;
end;

procedure TfrmMain_GuanLi.N7Click(Sender: TObject);
begin
  LengingManage();
end;

procedure TfrmMain_GuanLi.N9Click(Sender: TObject);
begin
  TfrmGanBuMgr.ShowForm;
end;

procedure TfrmMain_GuanLi.NExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_GuanLi.OnAppVersionChange(Sender: TObject);
begin
  statusAppVersion.Caption := '有新程序发布,请及时更新!';
end;


procedure TfrmMain_GuanLi.QueryLeaveInfo;
var
  i: integer;
  strBeginDateTime: string;
  strDueDateTime: string;
  askLeaveWithTypeArray: TRsAskLeaveWithTypeArray;
begin
  try
    strBeginDateTime := '';
    strDueDateTime := '';
    if checkDataRange.Checked then
    begin
      strBeginDateTime := FormatDateTime('YYYY-MM-DD 00:00:00', DateOf(dtpBeginDate.DateTime));
      strDueDateTime := FormatDateTime('YYYY-MM-DD 23:59:59', DateOf(dtpEndDate.DateTime));
    end;
    m_RsLCAskLeave.GetLeaves(strBeginDateTime,strDueDateTime,trim(edtNumber.Text),cmbType.Values[cmbType.itemindex],
      cmbStatus.Values[cmbStatus.itemindex], GlobalDM.SiteInfo.WorkShopGUID, cmbPost.Values[cmbPost.itemindex],
      cmbGroup.Values[cmbGroup.itemindex],cbkShowAllUnEnd.Checked,askLeaveWithTypeArray);
    with strGridLeaveInfo do
    begin
      ClearRows(1, RowCount - 1);
      RowCount := length(askLeaveWithTypeArray) + 2;
      for i := 0 to length(askLeaveWithTypeArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);
        Cells[1, i + 1] := askLeaveWithTypeArray[i].AskLeave.strTrainManID;
        Cells[2, i + 1] := askLeaveWithTypeArray[i].AskLeave.strTrainmanName;
        Cells[3, i + 1] := askLeaveWithTypeArray[i].strTypeName;
        Cells[4, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',askLeaveWithTypeArray[i].AskLeave.dtBeginTime);
        if askLeaveWithTypeArray[i].AskLeave.dtEndTime > 0 then
          Cells[5, i + 1] := FormatDateTime('yyyy-MM-dd HH:nn:ss',askLeaveWithTypeArray[i].AskLeave.dtEndTime);

        case askLeaveWithTypeArray[i].AskLeave.nStatus of
          1: Cells[6, i + 1] := '请假中';
          2: Cells[6, i + 1] := '续假中'; //暂未使用
          3: Cells[6, i + 1] := '已销假';
          10000: Cells[6, i + 1] := '已撤销';
        end;

        Cells[7, i + 1] := Format('%s[%.4s]', [askLeaveWithTypeArray[i].AskLeave.strAskProverName,
          askLeaveWithTypeArray[i].AskLeave.strAskProverID]);
        Cells[8, i + 1] := askLeaveWithTypeArray[i].AskLeave.strAskDutyUserName;
        Cells[9, i + 1] := askLeaveWithTypeArray[i].AskLeave.strMemo;
        Cells[10, i + 1] := TRsPostNameAry[askLeaveWithTypeArray[i].AskLeave.nPostID];
        Cells[11, i + 1] := askLeaveWithTypeArray[i].AskLeave.strGuideGroupName;

        Cells[999, i + 1] := askLeaveWithTypeArray[i].AskLeave.strAskLeaveGUID;
      end;
    end;
  except on e : exception do
    begin
      Box('查询信息失败:' + e.Message);
    end;
  end;
end;

procedure TfrmMain_GuanLi.GetTrainmanState();
var
  TrainmanStateCount: RTrainmanStateCount;
begin

  ZeroMemory(@TrainmanStateCount,SizeOf(TrainmanStateCount));
  m_RsLCTrainmamMgr.GetTrainmanStateCount(GlobalDM.SiteInfo.WorkShopGUID,TrainmanStateCount);
  
  chartPerson.RemoveAllSeries;
  chartPerson.Title.Text.Text := '人员状态统计';
  chartPerson.LeftAxis.Automatic := True ;
  chartPerson.AxisVisible := True ;

  Series1.Clear;
  Series1.AddBar(TrainmanStateCount.nUnRuning,'非运转',clGray);
  Series1.AddBar(TrainmanStateCount.nReady, '预备', clGreen);
  Series1.AddBar(TrainmanStateCount.nNormal, '运转中', clRed);
  Series1.AddBar(TrainmanStateCount.nNil, '空人员', clWhite);
  chartPerson.AddSeries(Series1);

end;

procedure TfrmMain_GuanLi.GetTrainmanJiaoLu();
var
  RsTrainJiaoLuCountArray:TRsTrainJiaoLuCountArray;
  color :DWORD;
  i :Integer ;
begin
  SetLength(RsTrainJiaoLuCountArray,0);
  m_RsLCTrainmamMgr.GetTrainmanJiaoLuCount(GlobalDM.SiteInfo.WorkShopGUID,RsTrainJiaoLuCountArray);

  chartJiaolu.RemoveAllSeries;
  chartJiaolu.Title.Text.Text := '交路人员分布';
  Series2.Clear;
  for I := 0 to Length(RsTrainJiaoLuCountArray) - 1 do
  begin
    color   := rgb(random(255),random(255),random(255));
    Series2.AddBar(RsTrainJiaoLuCountArray[i].nCount,RsTrainJiaoLuCountArray[i].strJiaoLuName,color);
  end;
  chartJiaolu.AddSeries(Series2);
end;

procedure TfrmMain_GuanLi.GetTrainmanHolidy();
  function RGBToColor(R,G,B: byte): Tcolor;
  begin
    Result := B Shl 16 or G  shl 8 or R;
  end;

  function GetRandomColor(): TColor;
  begin
    Randomize;
    Result := RGBToColor(Random(255),Random(255),Random(255));
  end;

var
  EnumSumArray: TEnumSumArray;
  I: Integer;
begin
  m_RsLCTrainmamMgr.GetTrainmanLeaveCount(GlobalDM.SiteInfo.WorkShopGUID,EnumSumArray);

  chartXiuJia.RemoveAllSeries;
  chartXiuJia.Title.Text.Text := '休假人员分布';
  Series3.Clear;
  for I := 0 to Length(EnumSumArray) - 1 do
  begin
    Series3.AddBar(EnumSumArray[i].EnumCount,EnumSumArray[i].EnumName,GetRandomColor);
  end;

  chartXiuJia.AddSeries(Series3);

end;

procedure TfrmMain_GuanLi.GetTrainmanRun();
var
  i:Integer;
begin
  SetLength(m_TrainmanRunStateCountArray,0);
  m_RsLCTrainmamMgr.GetTrainmanRunStateCount(GlobalDM.SiteInfo.WorkShopGUID,m_TrainmanRunStateCountArray);

  lvJiaoLu.Items.Clear;
  for I := 0 to Length(m_TrainmanRunStateCountArray) - 1 do
  begin
    with lvJiaoLu.Items.Add do
    begin
      Caption := IntToStr(i+1);
      SubItems.Add(m_TrainmanRunStateCountArray[i].strJiaoLuName);
    end;
  end;
  lvJiaoLu.ItemIndex := 0 ;
  lvJiaoLuClick(Self);
end;

procedure TfrmMain_GuanLi.PostPlanRenYuanMessage(msg: Integer;GUIDS: TStrings);
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


procedure TfrmMain_GuanLi.RefreshRoomInfo;
var
  i: Integer;
begin
  with RoomInfoGrid do
  begin
    ClearRows(1,10000);

    if m_RsRoomSignList.Count > 0  then
      RowCount := m_RsRoomSignList.Count + 1
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
    for i := 0 to m_RsRoomSignList.Count - 1 do
    begin
      RoomInfoGrid.Cells[0,i + 1] := IntToStr(i + 1);
      RoomInfoGrid.Cells[1,i + 1] := Format('%6s[%s]',
        [m_RsRoomSignList.Items[i].strTrainmanName,m_RsRoomSignList.Items[i].strTrainmanNumber]);
      RoomInfoGrid.Cells[2,i + 1] := FormatDateTime('yy-mm-dd hh:nn:ss',m_RsRoomSignList.Items[i].dtInRoomTime);
    end;

    RoomInfoGrid.Row := 1;
  end;
end;


procedure TfrmMain_GuanLi.RefreshTrainmanPlan();
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
  end;
end;



function TfrmMain_GuanLi.RemovePlan(guids: TStringList): Boolean;
var
  trainmanPlan : RRsTrainmanPlan;
  I: Integer;
  ErrInfo: string;
begin
  Result := False;
  for I := 0 to guids.Count - 1 do
  begin
    if not m_RsLCTrainPlan.GetTrainmanPlanByGUID(guids.Strings[i], trainmanPlan,ErrInfo) then
    begin
      Box('已有计划已被删除，请刷新后重试:' + ErrInfo);
      Exit;
    end;
  end;


  if not TBox('您确认要撤销选中的计划信息吗？') then exit;


  if not m_RsLCTrainPlan.CancelTrainPlan(guids,GlobalDM.DutyUser.strDutyGUID,
    True,ErrInfo) then
  begin
    Application.MessageBox(PChar('撤销计划失败:' + ErrInfo), '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  Result := True;
end;

procedure TfrmMain_GuanLi.RzRadioGroup1Click(Sender: TObject);
var
  index : Integer ;
begin
  PageControl1.ActivePageIndex :=  RzRadioGroup1.ItemIndex;
  index := PageControl1.ActivePageIndex ;
  case index of
   0 : GetTrainmanState;
   1 : GetTrainmanJiaoLu;
   2 : GetTrainmanHolidy;
   3 : GetTrainmanRun ;
  end;
end;

procedure TfrmMain_GuanLi.SetDateRange;
begin
  dtpBeginDate.Enabled := checkDataRange.Checked;
  dtpEndDate.Enabled := checkDataRange.Checked;
end;

procedure TfrmMain_GuanLi.btnRefreshPalnClick(Sender: TObject);
begin

  InitTrainmanPlan();
end;

procedure TfrmMain_GuanLi.btnRefreshRoomInfoClick(Sender: TObject);
begin
  m_RsRoomSignList.Clear;
  m_LCLocalRoom.QueryInRoomRecord(
  AssembleDateTime(dtRoomStartDate.Date,dtRoomStartTime.Time),
  now,
  GlobalDM.SiteInfo.WorkShopGUID,
  m_RsRoomSignList);

  RefreshRoomInfo();
  
end;

procedure TfrmMain_GuanLi.btnViewDetailClick(Sender: TObject);
var
  iRow: integer;
begin
  if not GetSelectRowIndex(iRow) then
  begin
    Box('您没有选中有效记录!');
    exit;
  end;
  TFrmAskLeaveDetail.ShowForm(strGridLeaveInfo.Cells[999, iRow], strGridLeaveInfo.Cells[3, iRow], strGridLeaveInfo.Cells[1, iRow], strGridLeaveInfo.Cells[2, iRow]);
end;

procedure TfrmMain_GuanLi.chartYunZhuanClickSeries(Sender: TCustomChart;
  Series: TChartSeries; ValueIndex: Integer; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  i : Integer ;
  nType : Integer ;
begin
  i := lvJiaoLu.ItemIndex ;
  if i < 0 then
    Exit ;
  nType := Ord(tsRuning);
  case ValueIndex of
   0 : nType := Ord(tsRuning);
   1 : nType := Ord(tsInRoom);
   2 : nType := Ord(tsOutRoom);
  end;
  UpdateGrid(m_TrainmanRunStateCountArray[i],nType);
end;

procedure TfrmMain_GuanLi.checkDataRangeClick(Sender: TObject);
begin
  SetDateRange;
end;





procedure TfrmMain_GuanLi.cmbTypeChange(Sender: TObject);
begin
  QueryLeaveInfo;
end;

procedure TfrmMain_GuanLi.strGridTrainPlanCanEditCell(Sender: TObject; ARow,
  ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
end;


procedure TfrmMain_GuanLi.strGridTrainPlanGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_GuanLi.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
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

procedure TfrmMain_GuanLi.AddRTrainmanPlanToControl(
  TrainmanPlan: RRsTrainmanPlan;nRow: Integer);
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
      Cells[COL_SUBTRAINMAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman2);
      Cells[COL_XUEYUAN_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman3);
      Cells[COL_XUEYUAN2_INDEX, nRow + 1] := GetTrainmanText(TrainmanPlan.Group.Trainman4);
    end;

    if TrainmanPlan.RestInfo.nNeedRest > 0 then
    begin
      Cells[COL_HOUBAN_INDEX, nRow + 1] := '侯班';
      Cells[COL_HOUBANTIME_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.RestInfo.dtArriveTime);
      Cells[COL_JIAOBAN_INDEX, nRow + 1] := FormatDateTime('yy-MM-dd hh:nn', TrainmanPlan.RestInfo.dtCallTime);
    end;
    Cells[99, nRow + 1] := TrainmanPlan.TrainPlan.strTrainPlanGUID;

  end;

end;



procedure TfrmMain_GuanLi.advstrngrdLogGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

procedure TfrmMain_GuanLi.btnCancelLeaveClick(Sender: TObject);
var
  iRow: integer;
  strLeaveGUID : string;
begin
  if not GetSelectRowIndex(iRow) then
  begin
    Box('请先选择您要撤销的请假记录!');
    exit;
  end;
  if not TBox('您确定要撤销选择的请假记录吗?') then exit;
  try
    strLeaveGUID := strGridLeaveInfo.Cells[999, iRow];
    m_RsLCAskLeave.CancelLeave(strLeaveGUID);
    QueryLeaveInfo;
  except on e : exception do
    Box('撤销失败:' + e.Message);
  end;
end;

procedure TfrmMain_GuanLi.btnCancelPlanClick(Sender: TObject);
var
  guids: TStringList;
  bCancleSuccess: Boolean;
  nIndex: integer;
  planGUID: string;
begin

  if strGridTrainPlan.SelectedRowCount = 0 then
  begin
    Box('请选中要撤销的计划!');
    Exit;
  end;
  nIndex := strGridTrainPlan.SelectedRow[0];
  planGUID := strGridTrainPlan.Cells[99,nIndex];
  if planGUID = '' then
  begin
    Box('请选择计划!');
    Exit;  
  end;
  guids := TStringList.Create;
  try

    if not TBox(
      Format('您确定要撤销由“%s”担当的计划吗?',
      [FormatGroupName(m_TrainmanPlanArray[nIndex - 1].Group)])) then
      Exit;
    guids.Add(planGUID);
    bCancleSuccess := RemovePlan(guids);

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
procedure TfrmMain_GuanLi.btnDelBeginWorkClick(Sender: TObject);
var
  TrainmanPlan: RRsTrainmanPlan;
  Trainman: RRsTrainman;
  nTrainmanIndex: Integer;
begin
  if not GetSelectedTrainman(Trainman,nTrainmanIndex) then
  begin
    Box('请先选中乘务员!');
    Exit;
  end;

  if Trainman.strTrainmanGUID = '' then
  begin
    Box('没有乘务员!');
    Exit;
  end;
  if not GetSelectedTrainmanPlan(TrainmanPlan) then
  begin
    Box('请选中要修改的计划!');
    Exit;
  end;
  if (TrainmanPlan.TrainPlan.nPlanState >= psEndWork) then
  begin
    Box('不能撤销已退勤的出勤计划!');
    Exit;
  end;

  if (dateUtils.IncHour(TrainmanPlan.TrainPlan.dtStartTime,6) < GlobalDM.GetNow) then
  begin
    Box('计划出勤时间已过6个小时，不能撤销!');
    Exit;
  end;
  if not TBox(
    Format('确定要清除[%s]的出勤记录吗?',[Trainman.strTrainmanName])) then
    Exit;

  try

    m_LCBeginWork.Clear(TrainmanPlan.TrainPlan.strTrainPlanGUID,Trainman.strTrainmanNumber);
    InitTrainmanPlan();
    Box('清除完毕!');
  except
    on E: Exception do
    begin
      Box('清除失败:' + E.Message);
    end;

  end;



end;

procedure TfrmMain_GuanLi.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
end;


procedure TfrmMain_GuanLi.btnExportClick(Sender: TObject);
begin
  ExportLeaveInfo;
end;

procedure TfrmMain_GuanLi.btnQueryClick(Sender: TObject);
begin
  edtNumber.SetFocus;
  QueryLeaveInfo;
end;

procedure TfrmMain_GuanLi.tabTrainJiaoluChange(Sender: TObject);
begin
  InitTrainmanPlan;
end;

procedure TfrmMain_GuanLi.TimerCheckUpdateTimer(Sender: TObject);
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

procedure TfrmMain_GuanLi.tmrRefreshSendLogTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
   
    m_dtNow := GlobalDM.GetNow;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', m_dtNow);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TfrmMain_GuanLi.UpdateGrid(TrainmanRunStateCount:RTrainmanRunStateCount;AType:Integer);
var
  i :Integer;
  n :Integer ;
  str:string;
begin
  strGridTrainman.ClearRows(1,10000);
  n := 0 ;
  case AType of
   ord(tsRuning):
    begin
      str:='运行中';
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nRuningCount + 1 ;
    end;
   ord(tsInRoom):
    begin
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nLocalCount + 1 ;
      str:='本段休息';
    end;
   ord(tsOutRoom):
    begin
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nSiteCount + 1 ;
      str:='外段休息';
    end
  else
    str := '其他状态';
  end;


  for I := 0 to Length(TrainmanRunStateCount.group) - 1 do
  begin
    with  strGridTrainman do
    begin
      if Integer(TrainmanRunStateCount.group[i].GroupState) = AType then
      begin
        Cells[0, n+1] := IntToStr(n+1);
        Cells[1, n+1] := str;
        if Length(TrainmanRunStateCount.group[i].Trainman1.strTrainmanName) <> 0 then
          Cells[2, n+1] := TrainmanRunStateCount.group[i].Trainman1.strTrainmanName+
            '[' + TrainmanRunStateCount.group[i].Trainman1.strTrainmanNumber+ ']';
            
        if Length(TrainmanRunStateCount.group[i].Trainman2.strTrainmanName) <> 0  then
          Cells[3, n+1] := TrainmanRunStateCount.group[i].Trainman2.strTrainmanName  +
           '[' + TrainmanRunStateCount.group[i].Trainman2.strTrainmanNumber+ ']';

        if  Length(TrainmanRunStateCount.group[i].Trainman3.strTrainmanName) <> 0 then
          Cells[4, n+1] := TrainmanRunStateCount.group[i].Trainman3.strTrainmanName  +
            '[' + TrainmanRunStateCount.group[i].Trainman3.strTrainmanNumber + ']';

        if Length(TrainmanRunStateCount.group[i].Trainman4.strTrainmanName) <> 0 then
          Cells[5, n+1] := TrainmanRunStateCount.group[i].Trainman4.strTrainmanName +
          '[' + TrainmanRunStateCount.group[i].Trainman4.strTrainmanNumber + ']';

        inc(n);
      end;
    end;
  end;
end;




end.



