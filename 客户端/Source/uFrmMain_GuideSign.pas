unit uFrmMain_GuideSign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, ExtCtrls, StdCtrls, RzPanel, RzStatus, RzCmboBx, RzDTP,
  Buttons, ComCtrls, Grids, Masks, BaseGrid, AdvGrid, PngSpeedButton,
  AdvObj, ComObj, DateUtils, IniFiles, uGlobalDM, uTFSystem, uSaftyEnum,
  uTrainman,  uGuideSign,  Menus,uFrmLeaveQuery,
  uFrmPaibanRecord,ufrmModifyPassWord,ufrmViewGroupOrder,uFrmNameBoardChangeLog,
  uLCTeamGuide,uLCTrainmanMgr,uFrmKeyTrainmanMgr,uFrmFixedGroupMgr;

type
  TfrmMain_GuideSign = class(TForm)
    RzPanel1: TRzPanel;
    TimerCheckFinger: TTimer;
    tmrReadTime: TTimer;
    btnSign: TPngSpeedButton;
    OpenDialog1: TOpenDialog;
    btnPhotoFingerUpdate: TPngSpeedButton;
    btnSysParam: TPngSpeedButton;
    btnGuideGroup: TPngSpeedButton;
    Label5: TLabel;
    dtpBeginDate: TRzDateTimePicker;
    Label2: TLabel;
    dtpEndDate: TRzDateTimePicker;
    RzPanel3: TRzPanel;
    RzPanel5: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    statusSysTime: TRzGlyphStatus;
    statusRecordNum: TRzGlyphStatus;
    statusPanelDBState: TRzStatusPane;
    statusFinger: TRzGlyphStatus;
    RzPanel4: TRzPanel;
    strGridInfo: TAdvStringGrid;
    RzPanel7: TRzPanel;
    RzPanel2: TRzPanel;
    Label3: TLabel;
    Label7: TLabel;
    Label4: TLabel;
    btnQuery: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    cmbSignFlag: TRzComboBox;
    RzPanel6: TRzPanel;
    RzPanel9: TRzPanel;
    lblNotSignInfo: TLabel;
    btnQueryPY2: TPngSpeedButton;
    edtPY: TEdit;
    strGridNotSign: TAdvStringGrid;
    RzPanel8: TRzPanel;
    btnDutyGroup: TPngSpeedButton;
    btnViewGroup: TPngSpeedButton;
    btnViewLeave: TPngSpeedButton;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    miModifyPassword: TMenuItem;
    N29: TMenuItem;
    N32: TMenuItem;
    mmExit: TMenuItem;
    N4: TMenuItem;
    N11: TMenuItem;
    miPaibanRecord: TMenuItem;
    N6: TMenuItem;
    N36: TMenuItem;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N7: TMenuItem;
    miBoardChangeLog: TMenuItem;
    btnKeyTrainman: TPngSpeedButton;
    btnExit: TPngSpeedButton;
    N8: TMenuItem;
    N9: TMenuItem;
    procedure FormDestroy(Sender: TObject);
    procedure tmrReadTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure statusFingerDblClick(Sender: TObject);
    procedure strGridInfoGetAlignment(Sender: TObject; ARow, ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure btnSignClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnQueryClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
    procedure btnPhotoFingerUpdateClick(Sender: TObject);
    procedure btnSysParamClick(Sender: TObject);
    procedure btnGuideGroupClick(Sender: TObject);
    procedure btnQueryPY2Click(Sender: TObject);
    procedure btnDutyGroupClick(Sender: TObject);
    procedure btnViewGroupClick(Sender: TObject);
    procedure btnViewLeaveClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure miPaibanRecordClick(Sender: TObject);
    procedure miModifyPasswordClick(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure miBoardChangeLogClick(Sender: TObject);
    procedure btnKeyTrainmanClick(Sender: TObject);
    procedure btnFixedGroupClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure N8Click(Sender: TObject);
  private
    { Private declarations }
    //乘务员信息操作类
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //INI文件-所在车间GUID
    m_strWorkShopGUID : string;
    //INI文件-指导队GUID
    m_strGuideGroupGUID : string;
    //INI文件-当司机表中指导队为空时，第一次签到时自动填写标志：1填写 0不考虑
    m_nAutoFillGroupGUID : integer;
    //INI文件-签退与签到时间差（分钟）
    m_nSignSpanMinutes : integer;
  private
    //初始化数据
    procedure InitData; 
    //初始化查询
    procedure InitQuery;
    //读取指纹状态
    procedure ReadFingerprintState;
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    //查询签到信息
    procedure QuerySignInfo;
    //查询未签到信息
    procedure QueryNotSignInfo;
    //导出签到信息
    procedure ExportSignInfo;
    //保存签到信息
    procedure SaveSignInfo(Trainman: RRsTrainman; Verify: TRsRegisterFlag);

    //
    function GetFormatSpanTime(dtBegin, dtEnd: TDateTime): string;
    function GetSpanDateTime(dtBegin, dtEnd: TDateTime): TDateTime;
    function GetSpanSeconds(dtBegin, dtEnd: TDateTime): integer;
    procedure ReadConfig();
//    procedure WriteConfig();
  public
    { Public declarations }
    //INI文件-所在车间GUID，指导队GUID
    property WorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property GuideGroupGUID: string read m_strGuideGroupGUID write m_strGuideGroupGUID;
    class procedure Enter;
    class procedure Leave;
  end;
         
var
  frmMain_GuideSign: TfrmMain_GuideSign;

implementation

uses
  uFrmTrainmanIdentity, ufrmReadFingerprintTemplates, 
  uFrmTextInput, utfPopBox, uFrmProgressEx, ufrmTrainmanPicFigEdit,
  uFrmSysParam, uFrmGuideGroup, uFrmDutyGroup, uFrmLogin,
  uFrmAnnualLeave,RsLibHelper;

{$R *.dfm}

{ TfrmMain_ChuQin }



procedure TfrmMain_GuideSign.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not IdentfityTrainman(Sender,TrainMan,Verify, '','','','') then exit;
  SaveSignInfo(TrainMan,verify);
end;

               
procedure TfrmMain_GuideSign.ReadFingerprintState;
begin
  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪连接正常';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪连接失败;双击重新连接！';
  end;
end;

//==============================================================================

procedure TfrmMain_GuideSign.FormCreate(Sender: TObject);
begin                   
  self.WindowState := wsMaximized;

  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;


  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  ReadConfig;
end;
       
procedure TfrmMain_GuideSign.FormDestroy(Sender: TObject);
begin
  TimerCheckFinger.Enabled := false;
  tmrReadTime.Enabled := false;

  GlobalDM.FingerPrintCtl.EventHolder.Restore();
  m_RsLCGuideGroup.Free;
  m_RsLCTrainmanMgr.Free;
end;

procedure TfrmMain_GuideSign.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := MessageBox(Handle,'您确定要退出吗?','请问',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;
               
procedure TfrmMain_GuideSign.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
  if Key = VK_F6 then btnSign.Click;
end;

procedure TfrmMain_GuideSign.tmrReadTimeTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
   
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);

    if (m_strWorkShopGUID = '') or (m_strGuideGroupGUID = '') then
    begin
      if btnSysParam.Tag = 0 then
      begin
        btnSysParam.Tag := 1;
        Box('请设置所在车间和指导队！');
        btnSysParam.Click;
      end;
    end;
  finally
    TTimer(Sender).Enabled := true;
  end;
end;
          
procedure TfrmMain_GuideSign.btnSignClick(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
begin
  GlobalDM.FingerPrintCtl.OnTouch := nil;
  try
    if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then Exit;

    if not m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
    begin
      Box('错误的乘务员工号');
      exit;
    end;

    strNumber := trainman.strTrainmanGUID;
    m_RsLCTrainmanMgr.GetTrainman(strNumber,trainman);
    Verify :=  rfInput;
    SaveSignInfo(Trainman,Verify);
  finally
    GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;
  end;
end;
           
procedure TfrmMain_GuideSign.btnGuideGroupClick(Sender: TObject);
begin
  if TFrmGuideGroup.ShowForm = mrOk then
  begin

  end;
end;
  
procedure TfrmMain_GuideSign.btnKeyTrainmanClick(Sender: TObject);
begin
  TFrmKeyTrainmanMgr.Show;
end;

procedure TfrmMain_GuideSign.btnDutyGroupClick(Sender: TObject);
begin
  TFrmDutyGroup.ShowForm;
end;

procedure TfrmMain_GuideSign.btnSysParamClick(Sender: TObject);
begin
  if TFrmSysParam.ShowForm = mrOk then
  begin
    ReadConfig;
    m_strWorkShopGUID := m_RsLCGuideGroup.GetOwnerWorkShopID(m_strGuideGroupGUID);
    self.Caption := '指导队签到平台    ' + m_RsLCGuideGroup.GetWorkShop_GuideGroup(m_strGuideGroupGUID);
  end;
end;

procedure TfrmMain_GuideSign.btnViewGroupClick(Sender: TObject);
begin
  RsLibHelper.TRsLibHelperFactory.Helper.NameplateLib.ShowNameplate(false,false);
end;

procedure TfrmMain_GuideSign.btnViewLeaveClick(Sender: TObject);
begin
  TFrmLeaveQuery.ShowForm(False);
end;

procedure TfrmMain_GuideSign.btnPhotoFingerUpdateClick(Sender: TObject);
var
  strNumber: string;
  trainman: RRsTrainman;
begin
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then Exit;
  if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    ModifyTrainmanPicFig(trainman.strTrainmanGUID);
  end
  else
  begin
    Box('该乘务员不存在');
  end;
end;

procedure TfrmMain_GuideSign.btnQueryClick(Sender: TObject);
begin
  QuerySignInfo;
  QueryNotSignInfo;
end;

procedure TfrmMain_GuideSign.btnQueryPY2Click(Sender: TObject);
begin
  QueryNotSignInfo;
end;

procedure TfrmMain_GuideSign.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMain_GuideSign.btnExportClick(Sender: TObject);
begin
  ExportSignInfo
end;

procedure TfrmMain_GuideSign.btnFixedGroupClick(Sender: TObject);
begin
  TFrmFixedGroupMgr.Show;
end;

procedure TfrmMain_GuideSign.statusFingerDblClick(Sender: TObject);
begin
  GlobalDM.ReinitFinger();
end;

procedure TfrmMain_GuideSign.strGridInfoGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
end;

//==============================================================================

procedure TfrmMain_GuideSign.InitData;
begin

  m_strWorkShopGUID := m_RsLCGuideGroup.GetOwnerWorkShopID(m_strGuideGroupGUID);
  self.Caption := '指导队签到平台    ' + m_RsLCGuideGroup.GetWorkShop_GuideGroup(m_strGuideGroupGUID);
  statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);

  InitQuery;
  QuerySignInfo;
  QueryNotSignInfo;

  //查看指纹仪状态
  ReadFingerprintState();

  tmrReadTime.Enabled := True;
end;

procedure TfrmMain_GuideSign.InitQuery;
begin
  dtpBeginDate.DateTime := Now;
  dtpEndDate.DateTime := Now;

  cmbSignFlag.Items.Clear;
  cmbSignFlag.Values.Clear;
  cmbSignFlag.AddItemValue('全部','0');
  cmbSignFlag.AddItemValue('手动','1');
  cmbSignFlag.AddItemValue('指纹','2');
  cmbSignFlag.ItemIndex := 0;
end;

class procedure TfrmMain_GuideSign.Leave;
begin
  //释放已硬件驱动
  if frmMain_GuideSign <> nil then
    FreeAndNil(frmMain_GuideSign);
end;

procedure TfrmMain_GuideSign.miBoardChangeLogClick(Sender: TObject);
begin
  TFrmNameBoardChangeLog.Open;
end;

procedure TfrmMain_GuideSign.miModifyPasswordClick(Sender: TObject);
begin
  TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TfrmMain_GuideSign.miPaibanRecordClick(Sender: TObject);
begin
  TfrmPaibanRecord.Open;
end;

procedure TfrmMain_GuideSign.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain_GuideSign.N1Click(Sender: TObject);
begin
  TFrmLeaveQuery.ShowForm(False);
end;

procedure TfrmMain_GuideSign.N29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TfrmMain_GuideSign.N2Click(Sender: TObject);
begin
  RsLibHelper.TRsLibHelperFactory.Helper.NameplateLib.ShowNameplate(false,false);
end;

procedure TfrmMain_GuideSign.N5Click(Sender: TObject);
begin
  TfrmViewGroupOrder.Open;
end;

procedure TfrmMain_GuideSign.N8Click(Sender: TObject);
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
procedure TfrmMain_GuideSign.QuerySignInfo;
var
  i: integer;
  QueryGuideSign: RRsQueryGuideSign;
  GuideSignArray: TRsGuideSignArray;
begin
  try
    QueryGuideSign.strTrainmanNumber := trim(edtTrainmanNumber.Text);
    QueryGuideSign.strTrainmanName := trim(edtTrainmanName.Text);
    QueryGuideSign.strWorkShopGUID := m_strWorkShopGUID; //cmbWorkShop.Values[cmbWorkShop.ItemIndex];
    QueryGuideSign.strGuideGroupGUID := m_strGuideGroupGUID; //cmbGuideGroup.Values[cmbGuideGroup.ItemIndex];
    QueryGuideSign.dtSignTimeBegin := DateOf(dtpBeginDate.DateTime) + EncodeTime(0,0,0,0);
    QueryGuideSign.dtSignTimeEnd := DateOf(dtpEndDate.DateTime) + EncodeTime(23,59,59,0);
    QueryGuideSign.nSignFlag := TRsSignFlag(StrToInt(cmbSignFlag.Values[cmbSignFlag.ItemIndex]));
    m_RsLCGuideGroup.GuideSign.QuerySignRecord(QueryGuideSign,GuideSignArray);

    with strGridInfo do
    begin
      ClearRows(1, RowCount - 1); 
      ClearCols(999, 999);
      RowCount := length(GuideSignArray) + 1; 
      statusRecordNum.Caption := Format('记录条数：%d 条', [RowCount - 1]);
      if RowCount = 1 then
      begin
        RowCount := 2;
        FixedRows := 1;
      end;
      for i := 0 to length(GuideSignArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);
        Cells[1, i + 1] := GuideSignArray[i].strTrainmanNumber;
        Cells[2, i + 1] := GuideSignArray[i].strTrainmanName;    
        Cells[3, i + 1] := GuideSignArray[i].strWorkShopName;
        Cells[4, i + 1] := GuideSignArray[i].strGuideGroupName;
        Cells[5, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',GuideSignArray[i].dtSignInTime);
        Cells[6, i + 1] := TRsSignFlagArray[GuideSignArray[i].nSignInFlag];      
        if GuideSignArray[i].dtSignOutTime > 0 then
        begin
          Cells[7, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',GuideSignArray[i].dtSignOutTime);
          Cells[8, i + 1] := TRsSignFlagArray[GuideSignArray[i].nSignOutFlag];
          Cells[9, i + 1] := GetFormatSpanTime(GuideSignArray[i].dtSignInTime, GuideSignArray[i].dtSignOutTime);
        end;
        Cells[999, i + 1] := GuideSignArray[i].strGuideSignGUID;
      end;
    end;
  except on e : exception do
    begin
      Box('查询信息失败:' + e.Message);
    end;
  end;
end;
     
procedure TfrmMain_GuideSign.QueryNotSignInfo;
var
  i: integer;
  QueryGuideSign: RRsQueryGuideSign;
  GuideSignArray, GuideSignArray2: TRsGuideSignArray;
  strPY: string;
begin
  try
    QueryGuideSign.strGuideGroupGUID := m_strGuideGroupGUID; //cmbGuideGroup.Values[cmbGuideGroup.ItemIndex];
    QueryGuideSign.dtSignTimeBegin := DateOf(dtpBeginDate.DateTime) + EncodeTime(0,0,0,0);
    QueryGuideSign.dtSignTimeEnd := DateOf(dtpEndDate.DateTime) + EncodeTime(23,59,59,0);
    m_RsLCGuideGroup.GuideSign.QueryNotSignRecord(QueryGuideSign,GuideSignArray2);

    //根据拼音检索
    strPY := Trim(edtPY.Text);
    if strPY = '' then
    begin
      GuideSignArray := GuideSignArray2;
    end
    else
    begin
      for i := 0 to Length(GuideSignArray2)-1 do
      begin
        if Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(GuideSignArray2[i].strTrainmanName))) > 0 then
        begin
          SetLength(GuideSignArray, Length(GuideSignArray)+1);
          GuideSignArray[Length(GuideSignArray)-1] := GuideSignArray2[i];
        end;
      end;
    end;

    with strGridNotSign do
    begin
      ClearRows(1, RowCount - 1); 
      ClearCols(999, 999);
      RowCount := length(GuideSignArray) + 1; 
      lblNotSignInfo.Caption := Format('未签到：%d人', [RowCount - 1]);
      if RowCount = 1 then
      begin
        RowCount := 2;
        FixedRows := 1;
      end;
      for i := 0 to length(GuideSignArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);
        Cells[1, i + 1] := GuideSignArray[i].strTrainmanNumber;
        Cells[2, i + 1] := GuideSignArray[i].strTrainmanName;
        Cells[999, i + 1] := GuideSignArray[i].strGuideSignGUID;
      end;
    end;
  except on e : exception do
    begin
      Box('查询信息失败:' + e.Message);
    end;
  end;
end;

class procedure TfrmMain_GuideSign.Enter;
begin
  GlobalDm.LocalSiteName := '车队管理';
  if frmMain_GuideSign = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TfrmMain_GuideSign, frmMain_GuideSign);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,frmMain_GuideSign);
    frmMain_GuideSign.InitData;
  end;
  frmMain_GuideSign.Show;
end;

procedure TfrmMain_GuideSign.ExportSignInfo;
var
  excelFile : string;
  excelApp,workBook,workSheet: Variant;
  m_nIndex : integer;
  i: Integer;
begin
  if strGridInfo.RowCount <= 1 then
  begin
    Box('请先查询出您要导出的签到信息！');
    exit;
  end;
  if (strGridInfo.RowCount = 2) and (strGridInfo.Cells[999, 1] = '') then 
  begin
    Box('请先查询出您要导出的签到信息！');
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
      excelApp.Worksheets[1].activate;
    end
    else begin
      excelApp.WorkBooks.Add;
      workBook:=excelApp.Workbooks.Add;
      workSheet:=workBook.Sheets.Add;
    end;

    m_nIndex := 1;
    excelApp.Cells[m_nIndex,1].Value := '工号';
    excelApp.Cells[m_nIndex,2].Value := '姓名';
    excelApp.Cells[m_nIndex,3].Value := '所属车间';
    excelApp.Cells[m_nIndex,4].Value := '指导队';  
    excelApp.Cells[m_nIndex,5].Value := '签到时间';
    excelApp.Cells[m_nIndex,6].Value := '签到方式';
    excelApp.Cells[m_nIndex,7].Value := '签退时间';
    excelApp.Cells[m_nIndex,8].Value := '签退方式';
    excelApp.Cells[m_nIndex,9].Value := '到场时长';
    
    Inc(m_nIndex);
    for i := 1 to strGridInfo.RowCount - 1 do
    begin
      if strGridInfo.Cells[999, i] <> '' then
      begin
        excelApp.Cells[m_nIndex,1].Value := strGridInfo.Cells[1, i];
        excelApp.Cells[m_nIndex,2].Value := strGridInfo.Cells[2, i];
        excelApp.Cells[m_nIndex,3].Value := strGridInfo.Cells[3, i];
        excelApp.Cells[m_nIndex,4].Value := strGridInfo.Cells[4, i];
        excelApp.Cells[m_nIndex,5].Value := strGridInfo.Cells[5, i];
        excelApp.Cells[m_nIndex,6].Value := strGridInfo.Cells[6, i];   
        excelApp.Cells[m_nIndex,7].Value := strGridInfo.Cells[7, i];
        excelApp.Cells[m_nIndex,8].Value := strGridInfo.Cells[8, i];
        excelApp.Cells[m_nIndex,9].Value := strGridInfo.Cells[9, i];
      end;
      TfrmProgressEx.ShowProgress('正在导出签到信息，请稍后',i,strGridInfo.RowCount-1);
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

procedure TfrmMain_GuideSign.SaveSignInfo(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
var
  GuideSign: RRsGuideSign;
  strSignType: string;
  dtNow: TDateTime;
begin
  //判断是签到还是签退
  strSignType := '签到';
  if m_RsLCGuideGroup.GuideSign.GetSignRecordByTrainmanNumber(
    Trainman.strTrainmanNumber, m_strGuideGroupGUID, GuideSign) then
  begin
    if GuideSign.dtSignOutTime = 0 then
    begin
      dtNow := GlobalDM.GetNow;
      //无论有无签退，只要大于1天就认为重新签到
      if GetSpanSeconds(GuideSign.dtSignInTime, dtNow) < 86400 then
      begin
        if dtNow >= IncMinute(GuideSign.dtSignInTime, m_nSignSpanMinutes) then
          strSignType := '签退'
        else
          strSignType := '询问';
      end;
    end;
  end;
  if strSignType = '询问' then
  begin
    if not TBox('您已签到，确定要签退吗?') then exit;
    strSignType := '签退';
  end;

  //根据配置文件，当司机表中指导队为空时，第一次签到时是否自动填写指导队GUID
  if m_strGuideGroupGUID <> '' then
  begin
    if m_nAutoFillGroupGUID = 1 then
    begin
      if Trainman.strGuideGroupGUID = '' then
      begin
        m_RsLCGuideGroup.Trainman.SetGroupByNumber(Trainman.strTrainmanNumber, m_strGuideGroupGUID);
      end;
    end;
  end;
  if Trainman.strGuideGroupGUID = '' then Trainman.strGuideGroupGUID := m_strGuideGroupGUID;

  if strSignType = '签到' then
  begin
    GuideSign.strGuideSignGUID := NewGUID;
    GuideSign.strTrainmanNumber := Trainman.strTrainmanNumber;
    GuideSign.strTrainmanName := Trainman.strTrainmanName;
    GuideSign.strWorkShopGUID := m_strWorkShopGUID; //Trainman.strWorkShopGUID;
    GuideSign.strGuideGroupGUID := m_strGuideGroupGUID; //Trainman.strGuideGroupGUID;
    GuideSign.dtSignInTime := GlobalDM.GetNow;
    GuideSign.nSignInFlag := sfInput;
    if Verify = rfFingerprint then GuideSign.nSignInFlag := sfFinger;
  end
  else
  begin
    GuideSign.dtSignOutTime := GlobalDM.GetNow;
    GuideSign.nSignOutFlag := sfInput;
    if Verify = rfFingerprint then GuideSign.nSignOutFlag := sfFinger;
  end;

  try
    if strSignType = '签到' then
      m_RsLCGuideGroup.GuideSign.SignIn(GuideSign);

    if strSignType = '签退' then
      m_RsLCGuideGroup.GuideSign.SignOut(GuideSign);

    TtfPopBox.ShowBox(strSignType+'成功！');
    QuerySignInfo;
    QueryNotSignInfo;
  except on e : exception do
    begin
      BoxErr(strSignType+'失败:' + e.Message);
    end;
  end;
end;
                
//==============================================================================

function TfrmMain_GuideSign.GetFormatSpanTime(dtBegin, dtEnd: TDateTime): string;
var
  dtSpanTime: TDateTime;
  nSpanSec: integer;
begin
  result := '';
  dtSpanTime := GetSpanDateTime(dtBegin, dtEnd);
  nSpanSec := Round(dtSpanTime * SecsPerDay);
  if nSpanSec < 59 then result := FormatDateTime('S秒', dtSpanTime)
  else if nSpanSec = 60 then result := '1分'
  else if nSpanSec < 3599 then result := FormatDateTime('N分S秒', dtSpanTime) 
  else if nSpanSec = 3600 then result := '1小时'
  else if nSpanSec < 86399 then result := FormatDateTime('H小时N分S秒', dtSpanTime)
  else if nSpanSec = 86400 then result := '1天'
  else result := '大于1天';
end;

function TfrmMain_GuideSign.GetSpanDateTime(dtBegin, dtEnd: TDateTime): TDateTime;
begin
  Result := 0;
  if dtEnd > dtBegin then Result := dtEnd - dtBegin;
end;

function TfrmMain_GuideSign.GetSpanSeconds(dtBegin, dtEnd: TDateTime): integer;
begin
  result := Round(GetSpanDateTime(dtBegin, dtEnd) * SecsPerDay);
end;
   
procedure TfrmMain_GuideSign.ReadConfig();
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    m_strGuideGroupGUID := Ini.ReadString('SysConfig', 'GuideGroupGUID', '');
    m_nAutoFillGroupGUID := Ini.ReadInteger('SysConfig', 'AutoFillGroupGUID', 1);
    m_nSignSpanMinutes := Ini.ReadInteger('SysConfig', 'SignSpanMinutes', 20);
    if m_nSignSpanMinutes <= 0 then m_nSignSpanMinutes := 20;
  finally
    Ini.Free();
  end;
end;

//procedure TfrmMain_GuideSign.WriteConfig();
//var
//  Ini:TIniFile;
//begin
//  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
//  try
//    Ini.WriteString('SysConfig', 'GuideGroupGUID', m_strGuideGroupGUID);
//    Ini.WriteInteger('SysConfig', 'AutoFillGroupGUID', m_nAutoFillGroupGUID);
//    Ini.WriteInteger('SysConfig', 'SignSpanMinutes', m_nSignSpanMinutes);
//  finally
//    Ini.Free();
//  end;
//end;

end.

