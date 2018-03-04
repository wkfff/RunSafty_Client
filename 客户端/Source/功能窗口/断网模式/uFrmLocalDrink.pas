unit uFrmLocalDrink;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, Menus, ExtCtrls, RzTabs, pngimage, StdCtrls, RzStatus,
  RzPanel, Grids, AdvObj, BaseGrid, AdvGrid, PngSpeedButton, Buttons,
  uTrainmanJiaolu, ufrmReadFingerprintTemplates, uTFSystem,
  uFrmTrainmanIdentity, uFrmChuQin, RzSplit, RzButton, RzRadChk, ComCtrls,
  RzEdit,uTFVariantUtils, SyncObjs,uTrainman,
  uSaftyEnum,uTrainPlan,
  ActnList, PngImageList, jpeg,
  AdvMenus,uFrmSelectColumn,uStrGridUtils, uConnAccess,
  uGlobalDM, RzDTP, uApparatusCommon,OleCtrls, AdvSplitter, Mask,
  RzLabel, ImgList;
   
const
  TESTPICTURE_DEFAULT = 'Images\测酒照片\nophoto.jpg';
  TESTPICTURE_CURRENT = 'Images\测酒照片\DrinkTest.jpg';
const
  WM_Message_DrinkCheck = WM_User + 100;
  WM_Message_DBDiscontect = WM_User + 1001;
type
  TFrmLocalDrink = class(TForm)
    RzPanel1: TRzPanel;
    Panel2: TPanel;
    RzPanel3: TRzPanel;
    RzPanel2: TRzPanel;
    RzStatusBar1: TRzStatusBar;
    RzPanel4: TRzPanel;
    tabTrainJiaolu: TRzTabControl;
    btnExit: TPngSpeedButton;
    statusSysTime: TRzGlyphStatus;
    statusDutyUser: TRzGlyphStatus;
    statusDrink: TRzGlyphStatus;
    statusFinger: TRzGlyphStatus;
    tmrReadTime: TTimer;
    Panel4: TPanel;
    btnRefreshPaln: TPngSpeedButton;
    btnDrinkTest: TPngSpeedButton;
    ActionList1: TActionList;
    Action1: TAction;
    RzPanel6: TRzPanel;
    RzPanel5: TRzPanel;
    RzGroupBox1: TRzGroupBox;
    Label3: TLabel;
    lblDrinkNumber: TLabel;
    Label6: TLabel;
    lblDrinkName: TLabel;
    Label8: TLabel;
    lblDrinkResult: TLabel;
    Label1: TLabel;
    lblDrinkTime: TLabel;
    RzGroupBox2: TRzGroupBox;
    dtpPlanStartDate: TRzDateTimePicker;
    dtpPlanStartTime: TRzDateTimePicker;
    DrkImage: TImage;
    RzPanel7: TRzPanel;
    strGridTrainDrink: TAdvStringGrid;
    Label2: TLabel;
    edtNumber: TRzEdit;
    TimerScroll: TTimer;
    pnlScrollInfo: TRzPanel;
    statusPanelDBState: TRzGlyphStatus;
    ImageList1: TImageList;
    Action2: TAction;
    Label4: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    procedure btnExitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tmrReadTimeTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormShow(Sender: TObject);
    procedure dtpPlanStartTimeChange(Sender: TObject);
    procedure dtpPlanStartDateKeyPress(Sender: TObject; var Key: Char);
    procedure strGridTrainDrinkSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strGridTrainDrinkGetAlignment(Sender: TObject; ARow,
      ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure TimerScrollTimer(Sender: TObject);
    procedure pnlScrollInfoPaint(Sender: TObject);
    procedure statusPanelDBStateDblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtNumberKeyPress(Sender: TObject; var Key: Char);
    procedure Action2Execute(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
  private
    { Private declarations }
    //本地数据库连接对象
    m_dbConnAccess: TConnAccess;
    //本地工作站名
    m_strLocalSiteName: string;


    m_RightBottomPopWindow: Boolean;
    //断网或连网开始时间
    m_nTickCount: Cardinal;
    //气泡提示句柄
    m_hBallHint: Cardinal;
  private
    //初始化数据
    procedure InitData;
    //执行出勤
    procedure ExecChuQin(Trainman : RRsTrainman;Verify : TRsRegisterFlag);

    //读取指纹状态
    procedure ReadFingerprintState;
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    {功能：测酒仪连接OK}
    procedure WMMessageDrinkCheck(var Message: TMessage); message WM_Message_DrinkCheck;
    procedure RefreshRecords;
  public
    { Public declarations }
    class procedure ShowForm;
    class procedure CloseForm;
  end;

implementation
uses
  DateUtils, StrUtils, ZKFPEngXUtils, uSite,  uDrink,uFrmTestDrinkSelect,
  uFrmTestDrinking, uFrmTextInput, utfPopBox, uFrmDrinkTestQuery;

var
  FrmLocalDrink: TFrmLocalDrink;

{$R *.dfm}

{ TFrmLocalDrink }

class procedure TFrmLocalDrink.ShowForm;
begin
  if FrmLocalDrink = nil then
  begin
    //初始化需要的硬件驱动
    Application.CreateForm(TFrmLocalDrink, FrmLocalDrink);
    FrmLocalDrink.InitData;
  end;
  FrmLocalDrink.Show;
end;

class procedure TFrmLocalDrink.CloseForm;
begin
  if FrmLocalDrink <> nil then
  begin
    FreeAndNil(FrmLocalDrink);
  end;
end;

procedure TFrmLocalDrink.FormCreate(Sender: TObject);
begin
  m_nTickCount := 0;
  GlobalDM.FingerPrintCtl.EventHolder.Hold();
  GlobalDM.FingerPrintCtl.OnTouch := OnFingerTouching;

  dtpPlanStartTime.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime);
  dtpPlanStartDate.DateTime :=  StrToDateTime(GlobalDM.ShowPlanStartTime); 
  m_RightBottomPopWindow := GlobalDM.BeginWorkRightBottomShow;

  m_dbConnAccess := TConnAccess.Create(Application);
end;

procedure TFrmLocalDrink.FormDestroy(Sender: TObject);
begin
  tmrReadTime.Enabled := false;
  if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
  GlobalDM.FingerPrintCtl.EventHolder.Restore;
end;

procedure TFrmLocalDrink.FormShow(Sender: TObject);
begin
  if not m_dbConnAccess.Connected then
  begin
    if not m_dbConnAccess.ConnectAccess then
    begin
      Box('连接本地数据库失败，请检查后重试！');
      exit;
    end;
  end;

  RefreshRecords;
end;
 
procedure TFrmLocalDrink.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_dbConnAccess.Free;
end;

procedure TFrmLocalDrink.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  if (not Showing) then
    CanClose := True
  else
    CanClose := MessageBox(Handle,'您确定要退出吗?','请问', MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TFrmLocalDrink.Action1Execute(Sender: TObject);
var
  strNumber: string;
  trainman : RRsTrainman;  
  Verify: TRsRegisterFlag;
begin
  if TextInput('开始测酒', '请输入乘务员工号:', strNumber) = False then Exit;

  if not GlobalDM.FingerPrintCtl.FindTmByNumber(strNumber, trainman) then
  begin
    trainman.strTrainmanNumber := strNumber;
  end;

  Verify := rfInput;
  ExecChuQin(trainman, Verify);
end;

procedure TFrmLocalDrink.Action2Execute(Sender: TObject);
begin
  RefreshRecords;
end;

procedure TFrmLocalDrink.InitData;
begin
  //当前登录用户
  statusDutyUser.Caption := '值班员: 管理员';
  statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);  
  m_strLocalSiteName := GlobalDm.LocalSiteName;
  tabTrainJiaolu.Tabs[0].Caption := m_strLocalSiteName + '端 - 测酒';
  strGridTrainDrink.ColumnHeaders[2] := m_strLocalSiteName + '时间';
  DrkImage.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
               

  GlobalDM.FingerPrintCtl.UseLocalTM := True;
  //查看指纹仪状态
  ReadFingerprintState();
end;


procedure TFrmLocalDrink.ExecChuQin(Trainman : RRsTrainman; Verify : TRsRegisterFlag);
var
  strTrainNo ,strTrainNumber,strTrainTypeName : string  ;
  testAlcoholInfo : RTestAlcoholInfo;
  DrinkInfo: RRsDrinkInfo;
var
  nWorkTypeID : Integer ;
begin
  strTrainNo :=  '测试车次' ;
  strTrainNumber :=  '测试车号'  ;
  strTrainTypeName :=  '测试车型'  ;

  if m_strLocalSiteName = '出勤' then
  begin

    DrinkInfo.nWorkTypeID := 2;
  end;
  if m_strLocalSiteName = '退勤' then
  begin
    DrinkInfo.nWorkTypeID := 3;
  end;
  nWorkTypeID := DrinkInfo.nWorkTypeID ;

  //获取车次
  if not TFrmTestDrinkSelect.GetDrinkInfo(DrinkInfo.nWorkTypeID,nWorkTypeID,strTrainNo ,strTrainNumber,strTrainTypeName) then
  begin
    BoxErr('取消测酒');
    Exit ;
  end;

  DrinkInfo.nWorkTypeID := nWorkTypeID ;

  TestDrinking(trainman,strTrainTypeName,strTrainNumber,strTrainNo,testAlcoholInfo);
  if testAlcoholInfo.taTestAlcoholResult <> taNormal then
  begin
    //??? if not TFrmChuQin.ShowChuQinForm(Trainman,Verify,Post,testAlcoholInfo,trainmanPlan) then exit;
  end;


  try
    DrinkInfo.nDrinkInfoID := 0;
    DrinkInfo.strTrainmanGUID :=  trainman.strTrainmanGUID ;
    DrinkInfo.strTrainmanNumber := trainman.strTrainmanNumber;
    DrinkInfo.strTrainmanName := trainman.strTrainmanName;
    DrinkInfo.strTrainNo := strTrainNo ;
    DrinkInfo.strTrainTypeName := strTrainTypeName ;
    DrinkInfo.strTrainNumber := strTrainNumber ;

    DrinkInfo.nDrinkResult := Ord(testAlcoholInfo.taTestAlcoholResult);
    DrinkInfo.dtCreateTime := testAlcoholInfo.dtTestTime;
    DrinkInfo.dwAlcoholicity := testAlcoholInfo.nAlcoholicity ;
    DrinkInfo.nVerifyID := Ord(Verify);
    DrinkInfo.strDutyNumber := GlobalDM.DutyUser.strDutyNumber ;
    DrinkInfo.DrinkImage := testAlcoholInfo.Picture;
    if m_dbConnAccess.AddDrinkInfo(DrinkInfo) then
    begin
      GlobalDM.PlaySoundFile('保存测酒记录成功.wav');
      TtfPopBox.ShowBox('保存测酒记录成功');
      RefreshRecords;
    end
    else
    begin
      GlobalDM.PlaySoundFile('保存测酒记录失败.wav');
      TtfPopBox.ShowBox('保存测酒记录失败');
    end;
  except on e : exception do
    begin
      GlobalDM.PlaySoundFile('保存测酒记录失败.wav');
      BoxErr('保存测酒记录失败:' + e.Message);
    end;
  end;
end;

procedure TFrmLocalDrink.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmLocalDrink.dtpPlanStartDateKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key = #13 then RefreshRecords;
end;

procedure TFrmLocalDrink.dtpPlanStartTimeChange(Sender: TObject);
begin
  GlobalDM.ShowPlanStartTime := FormatDateTime('yyyy-MM-dd HH:nn:00', Dateof(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime));
end;

procedure TFrmLocalDrink.edtNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
    btnRefreshPaln.Click;
end;

procedure TFrmLocalDrink.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not IdentfityTrainman(Sender,TrainMan,Verify, '', '', '', '') then exit;
  ExecChuQin(TrainMan,verify);
end;

procedure TFrmLocalDrink.pnlScrollInfoPaint(Sender: TObject);
var                       
  w, h, x, y: integer;
  nBorderWidth, nTextWidth, nTextHeight: integer;
begin                 
  SetBkMode(pnlScrollInfo.Canvas.Handle, TRANSPARENT);
  pnlScrollInfo.Canvas.Font.Assign(pnlScrollInfo.Font);

  w := pnlScrollInfo.Width;   
  h := pnlScrollInfo.Height;
  nBorderWidth := pnlScrollInfo.BorderWidth;
  nTextWidth := pnlScrollInfo.Canvas.TextWidth(pnlScrollInfo.Hint);
  nTextHeight := pnlScrollInfo.Canvas.TextHeight(pnlScrollInfo.Hint);

  if pnlScrollInfo.Tag <= (-nTextWidth) then pnlScrollInfo.Tag := w - nBorderWidth * 2;
  x := nBorderWidth + pnlScrollInfo.Tag;
  y := (h - nTextHeight) div 2;

  pnlScrollInfo.Canvas.TextOut(x, y, pnlScrollInfo.Hint);
  pnlScrollInfo.Canvas.Brush.Color := pnlScrollInfo.BorderColor;
  pnlScrollInfo.Canvas.Rectangle(0, 0, nBorderWidth, h);
  pnlScrollInfo.Canvas.Rectangle(w - nBorderWidth, 0, w, h);
end;

procedure TFrmLocalDrink.ReadFingerprintState;
begin
  if GlobalDM.FingerPrintCtl.InitSuccess then
  begin
    statusFinger.Font.Color := clBlack;
    statusFinger.Caption := '指纹仪连接正常';
  end
  else
  begin
    statusFinger.Font.Color := clRed;
    statusFinger.Caption := '指纹仪连接失败';
  end;
end;

procedure TFrmLocalDrink.RefreshRecords;
var
  i: integer;
  DrinkQuery: RRsDrinkQuery;
  DrinkInfoArray: TRsDrinkInfoArray;
  strTrain : string ;
begin
  try
    DrinkQuery.nWorkTypeID := 2;
    DrinkQuery.strTrainmanNumber := trim(edtNumber.Text);
    DrinkQuery.dtBeginTime := DateOf(dtpPlanStartDate.DateTime) + TimeOf(dtpPlanStartTime.DateTime);
    DrinkQuery.dtEndTime := Now();
    m_dbConnAccess.QueryDrinkInfo(DrinkQuery, DrinkInfoArray);

    with strGridTrainDrink do
    begin
      ClearRows(1, RowCount - 1); 
      ClearCols(99, 99);
      if length(DrinkInfoArray) > 0 then
        RowCount := length(DrinkInfoArray) + 1
      else
      begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(DrinkInfoArray) - 1 do
      begin
        RowColor[i + 1] := clWhite;

        Cells[0, i + 1] := IntToStr(i + 1);
        Cells[1, i + 1] := '已' + m_strLocalSiteName;
        Cells[2, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',DrinkInfoArray[i].dtCreateTime);
        Cells[3, i + 1] := Format('%6s[%s]', [DrinkInfoArray[i].strTrainmanName, DrinkInfoArray[i].strTrainmanNumber]);
        FontStyles[3,i+1] := [fsBold];
        Cells[4, i + 1] := TestAlcoholResultToString(TTestAlcoholResult(DrinkInfoArray[i].nDrinkResult));
        Cells[5, i + 1] := TRsRegisterFlagNameAry[TRsRegisterFlag(DrinkInfoArray[i].nVerifyID)];


        strTrain :=  Format('[%s-%s]%s',[DrinkInfoArray[i].strTrainTypeName,
          DrinkInfoArray[i].strTrainNumber,DrinkInfoArray[i].strTrainNo]) ;

        Cells[6, i + 1] := strTrain ;
        Cells[7, i + 1] :=  IntToStr(DrinkInfoArray[i].dwAlcoholicity);
        Cells[8, i + 1] := DrinkInfoArray[i].strDutyNumber ;

        Cells[99, i + 1] := IntToStr(DrinkInfoArray[i].nDrinkInfoID);
      end;
    end;
  except on e : exception do
    begin
      BoxErr('查询信息失败:' + e.Message);
    end;
  end;
end;

procedure TFrmLocalDrink.statusPanelDBStateDblClick(Sender: TObject);
begin
  if statusPanelDBState.Font.Color = clRed then
  begin
    PostMessage(GlobalDM.MsgHandle, WM_MSG_ReloginSystem, 0, 0);
  end;
end;

procedure TFrmLocalDrink.strGridTrainDrinkGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter; 
end;

procedure TFrmLocalDrink.strGridTrainDrinkSelectCell(Sender: TObject; ACol, ARow: Integer; var CanSelect: Boolean);
var
  strDrinkInfoID: string;
  DrinkInfo: RRsDrinkInfo;
  mem: TMemoryStream;
  strText: string;
begin
  lblDrinkNumber.Caption := '-';
  lblDrinkName.Caption := '-';
  lblDrinkTime.Caption := '-';
  lblDrinkResult.Caption := '-';
  DrkImage.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_DEFAULT);
  if ARow < 1 then Exit;

  strDrinkInfoID := trim(strGridTrainDrink.Cells[99, ARow]);
  if strDrinkInfoID = '' then exit;

  strText := strGridTrainDrink.Cells[3, ARow];
  lblDrinkNumber.Caption := Copy(strText, Pos('[', strText)+1, Pos(']', strText)-Pos('[', strText)-1);
  lblDrinkName.Caption := Copy(strText, 1, Pos('[', strText) - 1);;
  lblDrinkTime.Caption := strGridTrainDrink.Cells[2, ARow];
  lblDrinkResult.Caption := strGridTrainDrink.Cells[4, ARow];

  mem := TMemoryStream.Create;
  try
    if m_dbConnAccess.GetDrinkInfo(StrToIntDef(strDrinkInfoID,0), DrinkInfo) then
    begin
      if not VarIsEmpty(DrinkInfo.DrinkImage) then
      begin
        TTFVariantUtils.TemplateOleVariantToStream(DrinkInfo.DrinkImage,mem);
        IF mem.Size > 0 then
        begin
          mem.SaveToFile(GlobalDM.AppPath + TESTPICTURE_CURRENT);
          DrkImage.Picture.LoadFromFile(GlobalDM.AppPath + TESTPICTURE_CURRENT);
        end;
      end;
    end;
  finally
    mem.Free;
  end;
end;

procedure TFrmLocalDrink.TimerScrollTimer(Sender: TObject);
begin
  pnlScrollInfo.Tag := pnlScrollInfo.Tag - 10;
  pnlScrollInfo.Repaint;
end;

procedure TFrmLocalDrink.tmrReadTimeTimer(Sender: TObject); 
var
  pt: TPoint;
begin
  TTimer(Sender).Enabled := false;
  try
    if true then
    begin
      if m_nTickCount > 0 then
      begin
        if GetTickCount - m_nTickCount >= 10000 then
        begin
          m_nTickCount := GetTickCount;
          statusPanelDBState.ImageIndex := 0;
          statusPanelDBState.Caption := '服务器已连接，请双击切换到正常模式！';
          statusPanelDBState.Font.Color := clRed;
          
          pt.X := statusPanelDBState.Left + statusPanelDBState.Width div 2;
          pt.Y := statusPanelDBState.Top + 4;
          pt := RzStatusBar1.ClientToScreen(pt);
          if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
          m_hBallHint := GlobalDM.CreateHint(statusPanelDBState.Parent.Handle, statusPanelDBState.Caption, pt);
        end;
      end;
    end else begin
      if m_nTickCount > 0 then
      begin
        if GetTickCount - m_nTickCount >= 10000 then
        begin
          m_nTickCount := GetTickCount;
          statusPanelDBState.ImageIndex := 1;
          statusPanelDBState.Caption := '服务器已断开!';
          statusPanelDBState.Font.Color := clBlack;
          
          if m_hBallHint > 0 then GlobalDM.DestroyHint(m_hBallHint);
        end;
      end;
    end;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', GlobalDM.GetNow);
  finally
    TTimer(Sender).Enabled := true;
  end;
end;

procedure TFrmLocalDrink.WMMessageDrinkCheck(var Message: TMessage);
begin
  if Message.WParam = 0 then
  begin
    statusDrink.Font.Color := clRed;
    statusDrink.Caption := '测酒仪：工作异常';
  end else begin
    statusDrink.Font.Color := clBlack;
    statusDrink.Caption := '测酒仪：工作正常';
  end;
end;

end.


