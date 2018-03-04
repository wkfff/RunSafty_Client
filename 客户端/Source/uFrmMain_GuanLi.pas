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
    //�г���������
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //����ˢ�µļƻ�����
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    //��ǰʱ��
    m_dtNow : TDateTime;
    m_TrainmanRunStateCountArray:TRTrainmanRunStateCountArray;
  private
    //
    //��ȡ��Աͳ��
    procedure GetTrainmanState();
    //��ȡ��·ͳ��
    procedure GetTrainmanJiaoLu();
    //��ȡ�ݼ�ͳ��
    procedure GetTrainmanHolidy();
    //��ȡ����ͳ��
    procedure GetTrainmanRun();
    //����������յ��б�
    procedure UpdateGrid(TrainmanRunStateCount:RTrainmanRunStateCount;AType:Integer);

   { Private declarations }
   //��ʼ�����е�����
    procedure InitData;
    //��ʼ���г�������Ϣ
    procedure InitTrainJiaolus;
    //��ʼ����Ա�ƻ�
    procedure InitTrainmanPlan;
    //�ж�ָ�����Ƿ�Ϊ˾����
    function IsTrainmanCol(nCol: Integer): Boolean;
    //�ж�ָ�����Ƿ�Ϊ��˾����
    function IsSubTrainmanCol(nCol: Integer): Boolean;
    //�ж��Ƿ�ΪѧԱ��
    function IsXueYuanTrainmanCol(nCol: Integer): Boolean;
    //�ж��Ƿ�ΪѧԱ��
    function IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
    //��ȡѡ�е��г�������Ϣ
    function GetSelectedTrainJiaolu(out TrainJiaoluGUID : string):boolean;
    //��ȡѡ��ļƻ���Ϣ
    function GetSelectedTrainmanPlan(out TrainmanPlan : RRsTrainmanPlan) : boolean;
    //��ȡѡ�е�˾������
    function GetSelectedTrainman(var Trainman: RRsTrainman;out TrainmanIndex : integer): Boolean;
    {����:���һ���ƻ�������}
    procedure AddRTrainmanPlanToControl(TrainmanPlan: RRsTrainmanPlan;
        nRow: Integer);
    {����:ˢ����ʾ�ƻ�}
    procedure RefreshTrainmanPlan();
    procedure RefreshRoomInfo();
    function RemovePlan(guids: TStringList): Boolean;

    function FormatGroupName(Group: RRsGroup): string;


    procedure PostPlanRenYuanMessage(msg: Integer;GUIDS: TStrings);overload;
    procedure OnAppVersionChange(Sender: TObject);
    
    //��ѯ�����Ϣ
    procedure QueryLeaveInfo;
    //��ȡ��ǰѡ�е������Ϣ
    function GetSelectRowIndex(out rowIndex: integer): boolean;
    //���������Ϣ
    procedure ExportLeaveInfo;
    //�������ڷ�Χ�ĳ�ʼֵ���Ƿ����
    procedure SetDateRange();
    //��ʼ������
    procedure InitLeave;
  public
    //�����ɰ๦��ģ��
    class procedure EnterGuanLi;
    //�뿪�ɰ๦��ģ��
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
    Box('���Ȳ�ѯ����Ҫ�����������Ϣ��');
    exit;
  end;
  if (strGridLeaveInfo.RowCount = 2) and (strGridLeaveInfo.Cells[999, 1] = '') then 
  begin
    Box('���Ȳ�ѯ����Ҫ�����������Ϣ��');
    exit;
  end;

  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
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
    excelApp.Cells[m_nIndex,1] := '����';
    excelApp.Cells[m_nIndex,2] := '����';
    excelApp.Cells[m_nIndex,3] := '�������';
    excelApp.Cells[m_nIndex,4] := '��ٿ�ʼʱ��';
    excelApp.Cells[m_nIndex,5] := '��ٽ���ʱ��';
    excelApp.Cells[m_nIndex,6] := '��ǰ״̬';
    excelApp.Cells[m_nIndex,7] := '�����׼��';
    excelApp.Cells[m_nIndex,8] := '����Ա';
    excelApp.Cells[m_nIndex,9] := '��ע��Ϣ';
    excelApp.Cells[m_nIndex,10] := 'ְλ';
    excelApp.Cells[m_nIndex,11] := 'ָ����';
    
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
      TfrmProgressEx.ShowProgress('���ڵ��������Ϣ�����Ժ�',i,strGridLeaveInfo.RowCount-1);
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
  Box('������ϣ�');
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
    CanClose := MessageBox(Handle,'��ȷ��Ҫ�˳���?','����',
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



  //��¼strGrid���п�
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
  //������������б�
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('��ѯ��������б�ʧ��:' + ErrMsg);
    exit;
  end;

  cmbType.Items.Clear;
  cmbType.Values.Clear;
  cmbType.AddItemValue('ȫ��','');
  for i := 0 to length(LeaveTypeArray) - 1 do
  begin
    cmbType.AddItemValue(LeaveTypeArray[i].strTypeName,LeaveTypeArray[i].strTypeGUID);
  end;
  cmbType.ItemIndex := 0;

  cmbStatus.Items.Clear;
  cmbStatus.Values.Clear;
  cmbStatus.AddItemValue('ȫ��','');
  cmbStatus.AddItemValue('���','1');
  cmbStatus.AddItemValue('����','3');
  cmbStatus.AddItemValue('����','10000');
  cmbStatus.ItemIndex := 1;

  cmbPost.Items.Clear;
  cmbPost.Values.Clear;
  cmbPost.AddItemValue('ȫ��','');
  cmbPost.AddItemValue('˾��','1');
  cmbPost.AddItemValue('��˾��','2');
  cmbPost.AddItemValue('ѧԱ','3');
  cmbPost.ItemIndex := 0;

  //���ָ������Ϣ
  RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop(GlobalDM.SiteInfo.WorkShopGUID, GuideGroupArray);
  cmbGroup.Items.Clear;
  cmbGroup.Values.Clear;
  cmbGroup.AddItemValue('ȫ��','');
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
    Box('��ǰû��ѡ�е��г�������Ϣ');
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
      Box('��ȡ�ƻ���Ϣʧ�ܣ�' + e.Message);
    end;
  end;
end;


function TfrmMain_GuanLi.IsSubTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '��˾��');
end;

function TfrmMain_GuanLi.IsTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = '˾��');
end;

function TfrmMain_GuanLi.IsXueYuan2TrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = 'ѧԱ2');
end;

function TfrmMain_GuanLi.IsXueYuanTrainmanCol(nCol: Integer): Boolean;
begin
  Result := False;

  if (nCol < 0) or (nCol >= strGridTrainPlan.ColumnHeaders.Count) then
    Exit;

  Result := (strGridTrainPlan.ColumnHeaders.Strings[nCol] = 'ѧԱ');
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
  chartYunZhuan.Title.Text.Text := lvJiaoLu.Items[i].SubItems[0] + ': ��ת��Ա�ֲ�';
  Series4.Clear;
  chartPerson.Title.Text.Text := m_TrainmanRunStateCountArray[i].strJiaoLuName ;
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nRuningCount,'������',clRed);
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nLocalCount,'������Ϣ',clGreen);
  Series4.AddPie(m_TrainmanRunStateCountArray[i].nSiteCount,'�����Ϣ',clBlue);
  chartYunZhuan.AddSeries(Series4);

  with m_TrainmanRunStateCountArray[i] do
  begin
    lblTotalCount.Caption := IntToStr(nRuningCount + nLocalCount  + nSiteCount ) + '������';
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
  statusAppVersion.Caption := '���³��򷢲�,�뼰ʱ����!';
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
          1: Cells[6, i + 1] := '�����';
          2: Cells[6, i + 1] := '������'; //��δʹ��
          3: Cells[6, i + 1] := '������';
          10000: Cells[6, i + 1] := '�ѳ���';
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
      Box('��ѯ��Ϣʧ��:' + e.Message);
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
  chartPerson.Title.Text.Text := '��Ա״̬ͳ��';
  chartPerson.LeftAxis.Automatic := True ;
  chartPerson.AxisVisible := True ;

  Series1.Clear;
  Series1.AddBar(TrainmanStateCount.nUnRuning,'����ת',clGray);
  Series1.AddBar(TrainmanStateCount.nReady, 'Ԥ��', clGreen);
  Series1.AddBar(TrainmanStateCount.nNormal, '��ת��', clRed);
  Series1.AddBar(TrainmanStateCount.nNil, '����Ա', clWhite);
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
  chartJiaolu.Title.Text.Text := '��·��Ա�ֲ�';
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
  chartXiuJia.Title.Text.Text := '�ݼ���Ա�ֲ�';
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
      Box('���мƻ��ѱ�ɾ������ˢ�º�����:' + ErrInfo);
      Exit;
    end;
  end;


  if not TBox('��ȷ��Ҫ����ѡ�еļƻ���Ϣ��') then exit;


  if not m_RsLCTrainPlan.CancelTrainPlan(guids,GlobalDM.DutyUser.strDutyGUID,
    True,ErrInfo) then
  begin
    Application.MessageBox(PChar('�����ƻ�ʧ��:' + ErrInfo), '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Box('��û��ѡ����Ч��¼!');
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
      Cells[COL_HOUBAN_INDEX, nRow + 1] := '���';
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
    Box('����ѡ����Ҫ��������ټ�¼!');
    exit;
  end;
  if not TBox('��ȷ��Ҫ����ѡ�����ټ�¼��?') then exit;
  try
    strLeaveGUID := strGridLeaveInfo.Cells[999, iRow];
    m_RsLCAskLeave.CancelLeave(strLeaveGUID);
    QueryLeaveInfo;
  except on e : exception do
    Box('����ʧ��:' + e.Message);
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
    Box('��ѡ��Ҫ�����ļƻ�!');
    Exit;
  end;
  nIndex := strGridTrainPlan.SelectedRow[0];
  planGUID := strGridTrainPlan.Cells[99,nIndex];
  if planGUID = '' then
  begin
    Box('��ѡ��ƻ�!');
    Exit;  
  end;
  guids := TStringList.Create;
  try

    if not TBox(
      Format('��ȷ��Ҫ�����ɡ�%s�������ļƻ���?',
      [FormatGroupName(m_TrainmanPlanArray[nIndex - 1].Group)])) then
      Exit;
    guids.Add(planGUID);
    bCancleSuccess := RemovePlan(guids);

    if bCancleSuccess then
    begin
      PostPlanRenYuanMessage(TFM_PLAN_RENYUAN_DELETE,guids);
      InitTrainmanPlan();
      Application.MessageBox('�����ƻ��ɹ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
    Box('����ѡ�г���Ա!');
    Exit;
  end;

  if Trainman.strTrainmanGUID = '' then
  begin
    Box('û�г���Ա!');
    Exit;
  end;
  if not GetSelectedTrainmanPlan(TrainmanPlan) then
  begin
    Box('��ѡ��Ҫ�޸ĵļƻ�!');
    Exit;
  end;
  if (TrainmanPlan.TrainPlan.nPlanState >= psEndWork) then
  begin
    Box('���ܳ��������ڵĳ��ڼƻ�!');
    Exit;
  end;

  if (dateUtils.IncHour(TrainmanPlan.TrainPlan.dtStartTime,6) < GlobalDM.GetNow) then
  begin
    Box('�ƻ�����ʱ���ѹ�6��Сʱ�����ܳ���!');
    Exit;
  end;
  if not TBox(
    Format('ȷ��Ҫ���[%s]�ĳ��ڼ�¼��?',[Trainman.strTrainmanName])) then
    Exit;

  try

    m_LCBeginWork.Clear(TrainmanPlan.TrainPlan.strTrainPlanGUID,Trainman.strTrainmanNumber);
    InitTrainmanPlan();
    Box('������!');
  except
    on E: Exception do
    begin
      Box('���ʧ��:' + E.Message);
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
    statusUpdate.Caption := '�ͻ�����Ҫ���£�������ϵͳ';
    statusUpdate.Font.Color := clRed;
  end
  else
  begin
    statusUpdate.Caption := '�ͻ����������°汾';
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
      str:='������';
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nRuningCount + 1 ;
    end;
   ord(tsInRoom):
    begin
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nLocalCount + 1 ;
      str:='������Ϣ';
    end;
   ord(tsOutRoom):
    begin
      strGridTrainman.RowCount :=  TrainmanRunStateCount.nSiteCount + 1 ;
      str:='�����Ϣ';
    end
  else
    str := '����״̬';
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



