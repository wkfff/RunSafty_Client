unit uFrmMain_WaiQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,utfsystem,
  Dialogs, Menus, ComCtrls, RzDTP, ExtCtrls, StdCtrls, Buttons, PngSpeedButton,
  RzPanel,uSite,uTFMessageDefine,uRunSaftyMessageDefine, ImgList,
  PngImageList, RzTabs,uTrainJiaolu, Grids, AdvObj, BaseGrid, AdvGrid,uSaftyEnum,
  ActnList, DateUtils, RzCmboBx,uTemplateDayPlan,RzStatus,
  AdvSplitter,uLCDayPlan;

CONST
  DAY_NIGHT_START = 18 ;  //夜班开始时间
  DAY_NIGHT_END = 8 ;      //夜班截止时间
  COL_TRAIN_STATE = 1 ;     //状态
  COL_TRAIN_TRAINNO1_INDEX =2 ;//车次1
  COL_TRAIN_INFO_INDEX = 3 ;
  COL_TRAIN_TYPE_INDEX = 4 ;
  COL_TRAIN_NUMBER_INDEX = 5 ;
  COL_TRAIN_TRAINNO2_INDEX  = 6 ;   //车次2
  COL_TRAIN_TRAINNO_INDEX  = 7 ;
  COL_TRAIN_REMARK_INDEX  = 8 ;

type

  TFrmMain_WaiQin = class(TForm)
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
    N6: TMenuItem;
    N36: TMenuItem;
    RzPanel1: TRzPanel;
    btnRefreshPaln: TPngSpeedButton;
    Label4: TLabel;
    btnAcceptPlan: TPngSpeedButton;
    btnExchangeModule: TPngSpeedButton;
    Panel3: TPanel;
    Panel2: TPanel;
    dtpPlanStartDate: TRzDateTimePicker;
    tmrSharkIcon: TTimer;
    PngImageList1: TPngImageList;
    btnExportPlan: TPngSpeedButton;
    SaveDialog: TSaveDialog;
    RzPanel3: TRzPanel;
    RzPanel5: TRzPanel;
    RzPanel6: TRzPanel;
    Label1: TLabel;
    lstGroup: TListBox;
    RzPanel2: TRzPanel;
    strGridTrainPlan: TAdvStringGrid;
    RzPanel7: TRzPanel;
    Label3: TLabel;
    cmbDayPlanType: TRzComboBox;
    Label2: TLabel;
    RzStatusBar1: TRzStatusBar;
    statuspanelSum: TRzStatusPane;
    RzStatusPane1: TRzStatusPane;
    ProgressStatus1: TRzProgressStatus;
    strGridDaWen: TAdvStringGrid;
    AdvSplitter1: TAdvSplitter;
    procedure miModifyPasswordClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure mmExitClick(Sender: TObject);
    procedure btnExchangeModuleClick(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tmrSharkIconTimer(Sender: TObject);
    procedure btnAcceptPlanClick(Sender: TObject);
    procedure btnExportPlanClick(Sender: TObject);
    procedure lstGroupClick(Sender: TObject);
    procedure lstGroupDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure AdvSplitter1Moved(Sender: TObject);
    procedure lstGroupMeasureItem(Control: TWinControl; Index: Integer;
      var Height: Integer);
    procedure strGridDaWenGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure strGridTrainPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
  private
    m_nDayPlanID:Integer ;    //所管计划
    m_dtStartDate:TDateTime ; //开始时间
    m_DayPlan : TRsDayPlan ;                    //机车计划信息
    m_DayPlanInfoArray:RsDayPlanInfoArray;      //车次列表
    m_RsLCDayTemplate: TRsLCDayTemplate;
  private
    //消息列表
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //初始化数据
    procedure InitData();
    //初始化计划
    procedure InitTrainPlan();
    //初始化当前区段的计划
    procedure InitPlan(QuDuanID,QuDuanType:Integer);
    //获取选中的计划班次
    function GetSelDayPlanType : Integer ;
    //获取选中的区段的ID
    function GetSelGoupID:Integer;
    //获取选中区段的类型
    function GetSelGroupType:Integer ;
    //获取当前的类型和日期
    procedure GetDayPlanDate(out DayOrNight : Integer ; out dtBeginTime,dtEndTime : TDateTime);
    //初始化时间
    procedure InitDateTime();
    //初始化指定的计划的包含的区段
    procedure InitGroup();
    //把一个指定机车计划结构体添加到指定的GRID行里面
    procedure AddPlanToControl(DayPlanInfo:RsDayPlanInfo;nRow: Integer);
        //进度回调
//    procedure OnProgress(nCompleted, nTotal: integer);
  public
    { Public declarations }
    //进入外勤功能模块
    class procedure EnterWaiQin;
    //离开外勤功能模块
    class procedure LeaveWaiQin;
  end;

var
  FrmMain_WaiQin: TFrmMain_WaiQin;

implementation

uses
  uGlobalDM,ufrmModifyPassWord,utfPopBox,
  uFrmLogin,ufrmExchangeModule, uDayPlanExportToXls;

{$R *.dfm}



procedure TFrmMain_WaiQin.AddPlanToControl(DayPlanInfo: RsDayPlanInfo;
  nRow: Integer);
begin
  with strGridTrainPlan do
  begin
    Cells[0, nRow + 1] := IntToStr( nRow + 1 ) ;
    Cells[COL_TRAIN_STATE, nRow + 1] := TRsPlanStateNameAry[DayPlanInfo.nPlanState];
    Cells[COL_TRAIN_TRAINNO1_INDEX, nRow + 1] := DayPlanInfo.strTrainNo1 ;
    Cells[COL_TRAIN_INFO_INDEX, nRow + 1] := DayPlanInfo.strTrainInfo ;
    Cells[COL_TRAIN_TYPE_INDEX, nRow + 1] := DayPlanInfo.strTrainTypeName ;
    Cells[COL_TRAIN_NUMBER_INDEX, nRow + 1] := DayPlanInfo.strTrainNumber ;
    Cells[COL_TRAIN_TRAINNO2_INDEX, nRow + 1] := DayPlanInfo.strTrainNo2 ;
    Cells[COL_TRAIN_REMARK_INDEX,nRow+1] := DayPlanInfo.strTrainNo ;
    Cells[COL_TRAIN_REMARK_INDEX, nRow + 1] := DayPlanInfo.strRemark ;
    Cells[99, nRow + 1] := DayPlanInfo.strDayPlanGUID ;
  end;
end;

procedure TFrmMain_WaiQin.AdvSplitter1Moved(Sender: TObject);
begin
  lstGroup.Repaint ;
end;

procedure TFrmMain_WaiQin.btnAcceptPlanClick(Sender: TObject);
begin
  //RecieveTrainPlan();
  GlobalDM.TFMessageCompnent.CancelRecievedMessages();
  //关闭声音
  GlobalDM.StopPlaySound;


  tmrSharkIcon.Enabled := false;
  btnAcceptPlan.PngImage := PngImageList1.PngImages[0].PngImage;
  btnAcceptPlan.Font.Style := [];

  InitData ;
end;

procedure TFrmMain_WaiQin.btnExchangeModuleClick(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

procedure TFrmMain_WaiQin.btnExportPlanClick(Sender: TObject);
  function GetPlanTitle(BeginDate, EndDate: TDateTime;
    DayOrNight: integer): string;
  var
    strTtitle : string ;
    strDateBegin : string ;
    strDateEnd : string ;
    strPlan : string;
  begin
    strDateBegin := FormatDateTime('yyyy-MM-dd',BeginDate) ;
    strDateEnd :=  FormatDateTime('yyyy-MM-dd',IncDay(BeginDate,1)) ;
    case DayOrNight  of
    ord(dptDay) :
      begin
        strPlan := ' 白班计划';
        strTtitle :=strDateBegin + strPlan ;
      end;
    ord(dptNight) :
      begin
        strPlan := ' 夜班计划';
        strTtitle := strDateBegin + strPlan ;
      end;
    ord(dtpAll) :
      begin
        strPlan := ' 全天计划';
        strTtitle := strDateBegin + strPlan;
      end;
    else
      begin
        ;
      end;
    end;
    Result := strTtitle ;
  end;
var
  strFileName:string;
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
  DayPlanXls: TDayPlanXls;
  ExportData: TRsDayPlanExportData;
begin
  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime);
  SaveDialog.FileName := GetPlanTitle(dtBeginTime,dtEndTime,DayOrNight);
  if not SaveDialog.Execute(Self.Handle)  then
    exit ;
  strFileName := SaveDialog.FileName ;
  ExportData := TRsDayPlanExportData.Create;
  DayPlanXls := TDayPlanXls.Create;
  try
    m_RsLCDayTemplate.LCPlan.ExportPlan(dtBeginTime,dtEndTime,m_nDayPlanID,DayOrNight,ExportData);
    DayPlanXls.ExportToXls(dtBeginTime,dtEndTime,DayOrNight,ExportData,SaveDialog.FileName);
    TtfPopBox.ShowBox('导出完毕!',1000);
  finally
    ExportData.Free;
    DayPlanXls.Free;
  end;

end;

procedure TFrmMain_WaiQin.btnRefreshPalnClick(Sender: TObject);
begin
  InitData ;
end;

class procedure TFrmMain_WaiQin.EnterWaiQin;
begin
  if FrmMain_WaiQin = nil then
  begin
    Application.CreateForm(TFrmMain_WaiQin, FrmMain_WaiQin);
    GlobalDM.EmbeddedCtl.EmbeddedForm(GlobalDM.SiteInfo.nSiteJob,FrmMain_WaiQin);
    FrmMain_WaiQin.InitData;
  end;
  FrmMain_WaiQin.Show;
end;

procedure TFrmMain_WaiQin.FormCreate(Sender: TObject);
var
  strDutyPlaceID : string ;
begin

  lstGroup.Style := lbOwnerDrawVariable ;
  lstGroup.ItemHeight := 30 ;

  strGridTrainPlan.Visible := True ;
  strGridDaWen.Visible := False ;


  m_dtStartDate := GlobalDM.GetNow ;

  m_RsLCDayTemplate := TRsLCDayTemplate.Create(GlobalDM.WebAPIUtils);
//  m_dbTemplateDayPlan.OnExportPlanProgress :=  OnProgress ;
  m_DayPlan := TRsDayPlan.Create();
  //获取出勤点
  strDutyPlaceID := GlobalDM.DutyPlaceID ;
  if strDutyPlaceID = '' then
    raise Exception.Create('该端所管计划为空,请检查设置!');

  m_nDayPlanID := StrToInt(strDutyPlaceID)  ;
  InitDateTime ;
  InitGroup ;
end;

procedure TFrmMain_WaiQin.FormDestroy(Sender: TObject);
begin

  m_DayPlan.Free ;


  GlobalDM.TFMessageCompnent.OnMessage := nil;
  GlobalDM.TFMessageCompnent.Close;
end;

procedure TFrmMain_WaiQin.FormShow(Sender: TObject);
begin
  GlobalDM.TFMessageCompnent.OnMessage := OnTFMessage;
  GlobalDM.TFMessageCompnent.Open();
end;


procedure TFrmMain_WaiQin.GetDayPlanDate(out DayOrNight: Integer;
  out dtBeginTime, dtEndTime: TDateTime);
var
  DayPlanDate : TDateTime ;
begin
  DayOrNight := GetSelDayPlanType ;
  DayPlanDate :=  dtpPlanStartDate.DateTime ;

  if DayOrNight = Ord(dptDay) then  //白班
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),8);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
  end
  else if DayOrNight = Ord(dptNight)  then  //夜班
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),18);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
  end
  else                            //全天
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),18);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
  end;
end;

function TFrmMain_WaiQin.GetSelDayPlanType: Integer;
begin
  Result := cmbDayPlanType.ItemIndex ;
end;

function TFrmMain_WaiQin.GetSelGoupID: Integer;
var
  nIndex : Integer ;
begin
  Result := 0;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].ID ;
end;

function TFrmMain_WaiQin.GetSelGroupType: Integer;
var
  nIndex : Integer ;
begin
  Result := 0;
  nIndex := lstGroup.ItemIndex ;
  if nIndex < 0 then
    Exit ;
  Result :=  m_DayPlan.GoupList.Items[nIndex].IsDaWen ;
end;

procedure TFrmMain_WaiQin.InitData;
begin
  InitTrainPlan;
end;



procedure TFrmMain_WaiQin.InitDateTime;
var
  nHour : Word ;
begin
  dtpPlanStartDate.DateTime := m_dtStartDate ;
  nHour := HourOf(Now) ;
    //是否是夜班
  //白天导入夜班的计划
  //夜晚导入白天的计划
  if ( nHour >= DAY_NIGHT_END )  and ( nHour < DAY_NIGHT_START  ) then
  begin
    cmbDayPlanType.ItemIndex := 1 ;
  end
  else if ( nHour >= DAY_NIGHT_START )  or ( nHour < DAY_NIGHT_END ) then
  begin
    cmbDayPlanType.ItemIndex := 0 ;
  end;
end;

procedure TFrmMain_WaiQin.InitPlan(QuDuanID,QuDuanType: Integer);
var
  dtBeginTime,dtEndTime : TDateTime ;
  DayOrNight : Integer ;
  i,index : Integer ;
begin

  GetDayPlanDate(DayOrNight,dtBeginTime,dtEndTime) ;

  SetLength(m_DayPlanInfoArray,0);
  m_RsLCDayTemplate.LCPlan.QueryPublishPlans(dtBeginTime,
    dtEndTime,QuDuanID,m_DayPlanInfoArray);

  if QuDuanType = 0 then
  begin
    strGridTrainPlan.Visible := True ;
    strGridDaWen.Visible := False ;
    with strGridTrainPlan do
    begin
      ClearRows(1, 10000);

      if length(m_DayPlanInfoArray) > 0 then
        RowCount := length(m_DayPlanInfoArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_DayPlanInfoArray) - 1 do
      begin
        AddPlanToControl(m_DayPlanInfoArray[i], i);
      end;

      strGridTrainPlan.Repaint();
    end;
  end
  else
  begin
    strGridTrainPlan.Visible := False ;
    strGridDaWen.Visible := True ;
    with strGridDaWen do
    begin
      ClearRows(1, 10000);

      if length(m_DayPlanInfoArray) > 0 then
        RowCount := length(m_DayPlanInfoArray) + 1
      else begin
        RowCount := 2;
        Cells[99,1] := ''
      end;
      for i := 0 to length(m_DayPlanInfoArray) - 1 do
      begin
          index := 0 ;
          Cells[index, i + 1] := IntToStr(i + 1);
          Inc(index);

          with  m_DayPlanInfoArray[i] do
          begin
            Cells[index, i + 1] := TRsPlanStateNameAry[nPlanState];;
            Inc(index);


            Cells[index, i + 1] := strDaWenCheXing;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao1;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao2;
            Inc(index);

            Cells[index, i + 1] :=  strDaWenCheHao3;


            Cells[99, i + 1] := m_DayPlanInfoArray[i].strDayPlanGUID;
          end;
      end;

      strGridDaWen.Repaint();
    end;

  end;

end;

procedure TFrmMain_WaiQin.InitGroup;
var
  DayPlanID: Integer  ;
  i : Integer ;
begin

  DayPlanID :=  m_nDayPlanID ;
  m_DayPlan.GoupList.Clear ;
  m_RsLCDayTemplate.LCPlanGroup.QueryGroups(DayPlanID,m_DayPlan.GoupList);

  lstGroup.Clear ;
  for I := 0 to m_DayPlan.GoupList.Count - 1 do
  begin
    lstGroup.AddItem(m_DayPlan.GoupList.Items[i].Name,m_DayPlan.GoupList.Items[i]);
  end;
end;

procedure TFrmMain_WaiQin.InitTrainPlan;
var
  nSelGroupId,nSelGroupType: Integer ;
begin
  nSelGroupId := GetSelGoupID ;
  if nSelGroupId < 0  then
    exit ;
  
  nSelGroupType := GetSelGroupType ;
  InitPlan(nSelGroupId,nSelGroupType);
end;

class procedure TFrmMain_WaiQin.LeaveWaiQin;
begin
  GlobalDM.OnAppVersionChange := nil;
  //释放已硬件驱动
  if FrmMain_WaiQin <> nil then
    FreeAndNil(FrmMain_WaiQin);
end;

procedure TFrmMain_WaiQin.lstGroupClick(Sender: TObject);
begin
  InitTrainPlan ;
end;

procedure TFrmMain_WaiQin.lstGroupDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  strTemp: String;
  rectText : TRect ;
begin
  //分别绘出行文字
  strTemp := m_DayPlan.GoupList.Items[Index].Name;
  with lstGroup do
  begin
    //设置背景颜色并填充背景
    lstGroup.Canvas.Brush.Color := clWhite;
    lstGroup.Canvas.FillRect (Rect);

    //设置圆角矩形颜色并画出圆角矩形
    lstGroup.Canvas.Brush.Color := TColor($00FFF7F7);
    lstGroup.Canvas.Pen.Color := TColor($00131315);

    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 2, Rect.Bottom - 2, 8, 8);
    //以不同的宽度和高度再画一次，实现立体效果
    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //文字颜色
    lstGroup.Canvas.Font.Color := clBlack;
    CopyRect(rectText,Rect);
    //如果是当前选中项
    if(odSelected in State) then
    begin
        //以不同的背景色画出选中项的圆角矩形
        lstGroup.Canvas.Brush.Color := TColor($00FFB2B5);
        lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //选中项的文字颜色
        lstGroup.Canvas.Font.Color := clBlue;
        //如果当前项拥有焦点，画焦点虚框，当系统再绘制时变成XOR运算从而达到擦除焦点虚框的目的
        if(odFocused in State) then
        begin
          DrawFocusRect(lstGroup.Canvas.Handle, Rect);
          OffsetRect(rectText,0,1);
        end;
    end;

    lstGroup.Canvas.TextRect(rectText,strTemp,[tfSingleLine,tfCenter,tfVerticalCenter]);
  end;
end;

procedure TFrmMain_WaiQin.lstGroupMeasureItem(Control: TWinControl;
  Index: Integer; var Height: Integer);
begin
  ;
end;

procedure TFrmMain_WaiQin.miModifyPasswordClick(Sender: TObject);
begin
 TfrmModifyPassWord.ModifyPassWord(GlobalDM.DutyUser.strDutyNumber);
end;

procedure TFrmMain_WaiQin.mmExitClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain_WaiQin.N29Click(Sender: TObject);
begin
  frmLogin := TfrmLogin.Create(nil);
  try
    frmLogin.ShowModal;
  finally
    frmLogin.Free;
  end;
end;

procedure TFrmMain_WaiQin.N31Click(Sender: TObject);
var
  newjob : TRsSiteJob;
begin
  if not TfrmExchangeModule.SelectModule(newjob) then exit;
  PostMessage(GlobalDM.MsgHandle,WM_MSG_ExchangeModule,Ord(GlobalDM.CurrentModule),Ord(newjob));
  GlobalDM.TFMessageCompnent.MsgDataComm.LastMsgID := 0 ;
end;

//procedure TFrmMain_WaiQin.OnProgress(nCompleted, nTotal: integer);
//begin
//  ProgressStatus1.TotalParts := nTotal;
//  ProgressStatus1.PartsComplete := nCompleted;
//end;

procedure TFrmMain_WaiQin.OnTFMessage(TFMessages: TTFMessageList);
var
  i: Integer;
  strMessageType: string;
  bPlaySound: Boolean;
  bIsUpdate : Boolean ;
begin
  bIsUpdate := False ;
  bPlaySound := False;
  for I := 0 to TFMessages.Count - 1 do
  begin
    TFMessages.Items[i].nResult := TFMESSAGE_STATE_RECIEVED;
    
    if  TFMessages.Items[i].IntField['DayPlanID'] <> m_nDayPlanID  then
    begin
      TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
      Continue;
    end;

    case TFMessages.Items[i].msg of
    TFM_PLAN_WAIQIN_PUBLISH :
      //接收到发布外勤计划
      begin
        strMessageType :='发布';
        tmrSharkIcon.Enabled := true;
        bPlaySound := True ;
      end ;
    TFM_PLAN_WAIQIN_UPDATE :
      //接收到更新外勤计划
      begin
        strMessageType :='更新';
        tmrSharkIcon.Enabled := true;
        bIsUpdate := True ;
      end ;
    TFM_PLAN_WAIQIN_INSERT :
      //接收到增加外勤计划
      begin
        strMessageType :='增加';
        tmrSharkIcon.Enabled := true;
        bIsUpdate := True ;
      end ;
    TFM_PLAN_WAIQIN_DELETE :
      //接收到删除外勤计划
      begin
        strMessageType :='删除';
        tmrSharkIcon.Enabled := true;
        bIsUpdate := True ;
      end ;
    ELSE
      begin
        TFMessages.Items[i].nResult := TFMESSAGE_STATE_CANCELD;
        Continue;
      end;
    end;

  end;

  if bPlaySound then
  begin
    GlobalDM.PlaySoundFileLoop('接收计划.wav');
  end;

  if bIsUpdate then
  begin
    GlobalDM.PlaySoundFileLoop('更新计划.wav');
    InitTrainPlan ;       //刷新一下界面
  end;
  //如果计划有改动则播放更新计划音乐
end;

procedure TFrmMain_WaiQin.strGridDaWenGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = COL_TRAIN_STATE then
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

procedure TFrmMain_WaiQin.strGridTrainPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = COL_TRAIN_STATE then
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

procedure TFrmMain_WaiQin.tmrSharkIconTimer(Sender: TObject);
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

end.
