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
  DAY_NIGHT_START = 18 ;  //ҹ�࿪ʼʱ��
  DAY_NIGHT_END = 8 ;      //ҹ���ֹʱ��
  COL_TRAIN_STATE = 1 ;     //״̬
  COL_TRAIN_TRAINNO1_INDEX =2 ;//����1
  COL_TRAIN_INFO_INDEX = 3 ;
  COL_TRAIN_TYPE_INDEX = 4 ;
  COL_TRAIN_NUMBER_INDEX = 5 ;
  COL_TRAIN_TRAINNO2_INDEX  = 6 ;   //����2
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
    m_nDayPlanID:Integer ;    //���ܼƻ�
    m_dtStartDate:TDateTime ; //��ʼʱ��
    m_DayPlan : TRsDayPlan ;                    //�����ƻ���Ϣ
    m_DayPlanInfoArray:RsDayPlanInfoArray;      //�����б�
    m_RsLCDayTemplate: TRsLCDayTemplate;
  private
    //��Ϣ�б�
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //��ʼ������
    procedure InitData();
    //��ʼ���ƻ�
    procedure InitTrainPlan();
    //��ʼ����ǰ���εļƻ�
    procedure InitPlan(QuDuanID,QuDuanType:Integer);
    //��ȡѡ�еļƻ����
    function GetSelDayPlanType : Integer ;
    //��ȡѡ�е����ε�ID
    function GetSelGoupID:Integer;
    //��ȡѡ�����ε�����
    function GetSelGroupType:Integer ;
    //��ȡ��ǰ�����ͺ�����
    procedure GetDayPlanDate(out DayOrNight : Integer ; out dtBeginTime,dtEndTime : TDateTime);
    //��ʼ��ʱ��
    procedure InitDateTime();
    //��ʼ��ָ���ļƻ��İ���������
    procedure InitGroup();
    //��һ��ָ�������ƻ��ṹ����ӵ�ָ����GRID������
    procedure AddPlanToControl(DayPlanInfo:RsDayPlanInfo;nRow: Integer);
        //���Ȼص�
//    procedure OnProgress(nCompleted, nTotal: integer);
  public
    { Public declarations }
    //�������ڹ���ģ��
    class procedure EnterWaiQin;
    //�뿪���ڹ���ģ��
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
  //�ر�����
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
        strPlan := ' �װ�ƻ�';
        strTtitle :=strDateBegin + strPlan ;
      end;
    ord(dptNight) :
      begin
        strPlan := ' ҹ��ƻ�';
        strTtitle := strDateBegin + strPlan ;
      end;
    ord(dtpAll) :
      begin
        strPlan := ' ȫ��ƻ�';
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
    TtfPopBox.ShowBox('�������!',1000);
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
  //��ȡ���ڵ�
  strDutyPlaceID := GlobalDM.DutyPlaceID ;
  if strDutyPlaceID = '' then
    raise Exception.Create('�ö����ܼƻ�Ϊ��,��������!');

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

  if DayOrNight = Ord(dptDay) then  //�װ�
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),8);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
  end
  else if DayOrNight = Ord(dptNight)  then  //ҹ��
  begin
    dtBeginTime := IncHour(DateOf(DayPlanDate),18);
    dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
  end
  else                            //ȫ��
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
    //�Ƿ���ҹ��
  //���쵼��ҹ��ļƻ�
  //ҹ�������ļƻ�
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
  //�ͷ���Ӳ������
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
  //�ֱ���������
  strTemp := m_DayPlan.GoupList.Items[Index].Name;
  with lstGroup do
  begin
    //���ñ�����ɫ����䱳��
    lstGroup.Canvas.Brush.Color := clWhite;
    lstGroup.Canvas.FillRect (Rect);

    //����Բ�Ǿ�����ɫ������Բ�Ǿ���
    lstGroup.Canvas.Brush.Color := TColor($00FFF7F7);
    lstGroup.Canvas.Pen.Color := TColor($00131315);

    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 2, Rect.Bottom - 2, 8, 8);
    //�Բ�ͬ�Ŀ�Ⱥ͸߶��ٻ�һ�Σ�ʵ������Ч��
    lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //������ɫ
    lstGroup.Canvas.Font.Color := clBlack;
    CopyRect(rectText,Rect);
    //����ǵ�ǰѡ����
    if(odSelected in State) then
    begin
        //�Բ�ͬ�ı���ɫ����ѡ�����Բ�Ǿ���
        lstGroup.Canvas.Brush.Color := TColor($00FFB2B5);
        lstGroup.Canvas.RoundRect(Rect.Left + 2, Rect.Top + 2,Rect.Right - 3, Rect.Bottom - 3, 5, 5);
        //ѡ�����������ɫ
        lstGroup.Canvas.Font.Color := clBlue;
        //�����ǰ��ӵ�н��㣬��������򣬵�ϵͳ�ٻ���ʱ���XOR����Ӷ��ﵽ������������Ŀ��
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
      //���յ��������ڼƻ�
      begin
        strMessageType :='����';
        tmrSharkIcon.Enabled := true;
        bPlaySound := True ;
      end ;
    TFM_PLAN_WAIQIN_UPDATE :
      //���յ��������ڼƻ�
      begin
        strMessageType :='����';
        tmrSharkIcon.Enabled := true;
        bIsUpdate := True ;
      end ;
    TFM_PLAN_WAIQIN_INSERT :
      //���յ��������ڼƻ�
      begin
        strMessageType :='����';
        tmrSharkIcon.Enabled := true;
        bIsUpdate := True ;
      end ;
    TFM_PLAN_WAIQIN_DELETE :
      //���յ�ɾ�����ڼƻ�
      begin
        strMessageType :='ɾ��';
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
    GlobalDM.PlaySoundFileLoop('���ռƻ�.wav');
  end;

  if bIsUpdate then
  begin
    GlobalDM.PlaySoundFileLoop('���¼ƻ�.wav');
    InitTrainPlan ;       //ˢ��һ�½���
  end;
  //����ƻ��иĶ��򲥷Ÿ��¼ƻ�����
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
