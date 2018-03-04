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
    //�г��������ݿ����
    m_DBTrainJiaolu : TRsDBTrainJiaolu;
    //�����ƻ����ݿ������
    m_DBTrainPlan : TRsDBTrainPlan;
    //�г���������
    m_TrainjiaoluArray : TRsTrainJiaoluArray;
    //�����ƻ���Ϣ
    m_TrainmanPlanArray : TRsTrainmanPlanArray;
    //���ڵ�
    m_dutyPlaceList:TRsDutyPlaceList;
     //��վ�б�
    m_StationArray: TRsStationArray;
    m_dtNow: TDateTime;
    m_bModifyed: Boolean;
    //ͼ������
    m_webTrainnos : TRsLCTrainnos;
    //��Ա�ƻ�
    m_webTrainPlan : TRsLCTrainPlan ;
    //���ڵ�
    m_webDutyPlace:TRsLCDutyPlace ;
  private
    { Private declarations }
    //��ʼ������
    procedure InitData;
    //��ʼ���г�������Ϣ
    procedure InitTrainJiaolus;
    //��ʼ�������ƻ�����
    procedure InitTrainPlan();
    //��ʼ����·��վ
    procedure InitStations();
    //����б�����־��Ϣ
    procedure InitSendLog();

    //���ݿ�������
    procedure DBConnected(Sender : TObject);
    //���ݿ��ѶϿ�
    procedure DBDisconnected(Sender : TObject);
    //����״̬��Ӧ�ó�������°汾��Ϣ
    procedure OnAppVersionChange(Sender: TObject);

    //��ȡ���мƻ�
    procedure GetAllPlan(PlanList:TStrings);
    //��ȡѡ�мƻ�
    procedure GetSelPlan(PlanList:TStrings);
    //����һ���µĻ����ƻ�������Ϊ��,����ͨ��GRID���
    procedure AddNewPlan(var TrainPlan: RRsTrainPlan);
  //�����ƻ���ӵ����ݿ�
    procedure AddPlan(Plan: RRsTrainPlan);
    //���»����ƻ���ͬʱ���͸�����Ϣ
    procedure UpdatePlan(Plan: RRsTrainPlan);overload;
    procedure UpdatePlan(nRow: Integer); overload;
    //ɾ�������ƻ�  ,����ֵΪ�ɹ������� ,����ΪҪɾ���б�
    function  DeletePlan(PlanList:TStrings):Integer;
    //�·��ƻ�
    function  SendPlan(PlanList:TStrings):Boolean;
    //�����ƻ�
    function  CancelPlan(PlanList:TStrings):Boolean;


    //����ָ�����кţ���GRIDת��һ�������ƻ��ṹ��
    procedure GridRowToTrainPlan(nRow: Integer; var Plan: RRsTrainPlan);overload;
    //��һ��ָ�������ƻ��ṹ����ӵ�ָ����GRID������
    procedure AddRTrainmanPlanToControl(TrainmanPlan: RRsTrainmanPlan;
        nRow: Integer);
    //grid����
    procedure NextFocus();

    //Ͷ����Ϣ
    procedure PostPlanMessage(TFMessageList: TTFMessageList);overload;
    procedure PostPlanMessage(TFMessage: TTFMessage);overload;
    
    procedure OnTFMessage(TFMessages: TTFMessageList);
    //�ѻ����ƻ���䵽��Ϣ�ṹ������
    procedure FillMessageWithPlan(TFMessage: TTFMessage;Plan: RRsTrainPlan);


    {����������}
    //�Բ�������(4)���ȵ�ǰ�油��0��ȱ�������伸��
    function FormatTrainNumber(TrainNumber: string): string;
    //��ȡѡ�е��г�������Ϣ
    function GetSelectedTrainJiaolu(out TrainJiaoluGUID : string):boolean;

    //�˵����
    procedure JiaoLuChangeMenuClick(Sender: TObject);
  public
    //�����������
    class procedure EnterJiDiao;
    //�뿪��������
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
    Box('���ݿ������ѶϿ������Ժ�����');
    exit;
  end;
  
  if tabTrainJiaolu.TabIndex > -1 then
    strTrainJiaoluGUID := m_TrainjiaoluArray[tabTrainJiaolu.TabIndex].strTrainJiaoluGUID;


  if not m_webDutyPlace.GetDutyPlaceByJiaoLu(strTrainJiaoluGUID,listDutyPlace,strError) then
  begin
    BoxErr('��ȡ���ڵ���Ϣ����');
    Exit;
  end;

  if Length(listDutyPlace)  = 0 then
  begin
    BoxErr('�ý�·����û�г��ڵ�,���Ӽƻ�ʧ��');
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
      Application.MessageBox('û��Ҫ�����ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    if not m_DBTrainPlan.CanCanlePlan(guids,strError) then
    begin
      Box(strError);
      Exit;
    end;

    if not TBox('��ȷ��Ҫ����ѡ�еļƻ���Ϣ��') then exit;

    if not m_DBTrainPlan.CancelPlan(guids,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
    begin
      Application.MessageBox('�����ƻ�ʧ�ܣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
  Application.MessageBox('�����ƻ��ɹ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
      Application.MessageBox('û��Ҫ�����ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      exit;
    end;

    //���ƻ��ܷ�ɾ��
    if not TBox('��ȷ��Ҫ����ѡ�еļƻ���Ϣ��') then exit;

    try
      if CancelPlan(planList) then
        Application.MessageBox('�����ƻ��ɹ���', '��ʾ', MB_OK + MB_ICONINFORMATION)
      else
        Application.MessageBox('�����ƻ�ʧ�ܣ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
      InitTrainPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('�·��ƻ�ʧ��,������Ϣ:%s��', [e.Message])));
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
    //���ѡ���е�������Ч��
    trainPlanGUID := strGridTrainPlan.Cells[99, strGridTrainPlan.selectedrow[i]];
    trainPlan.strTrainPlanGUID := trainPlanGUID;
    if trainPlanGUID = '' then continue;

    if not m_DBTrainPlan.GetPlan(trainPlanGUID, trainPlan) then
    begin
      Box('���мƻ��ѱ�ɾ������ˢ�º�����');
      exit;
    end;

    if trainPlan.nPlanState <> psEdit then
    begin
      Box('ֻ��ɾ�����ڱ༭״̬�ļƻ���');
      exit;
    end;
    nTotalCount := nTotalCount + 1;
  end;

  if nTotalCount = 0 then
  begin
    Application.MessageBox('û��Ҫɾ���ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox('��ȷ��Ҫɾ���˻����ƻ���', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  strGridTrainPlan.BeginUpdate;
  try
    nSucceedCount := 0;
    for i := 0 to strGridTrainPlan.SelectedRowCount - 1 do
    begin
      m_DBTrainPlan.Delete(trainPlanGUID);
      nSucceedCount := nSucceedCount + 1;
    end;
    Application.MessageBox(PChar(Format('�ɹ�ɾ��%d���ƻ���ʧ��%d����',
      [nSucceedCount, nTotalCount - nSucceedCount])), '��ʾ', MB_OK + MB_ICONINFORMATION);
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
  //��ȡҪɾ��������
  GetSelPlan(planList);
  
  //����Ƿ�û��ѡ��һ��
  if planList.Count = 0 then
  begin
    Application.MessageBox('û��Ҫɾ���ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  if Application.MessageBox('��ȷ��Ҫɾ���˻����ƻ���', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;

  strGridTrainPlan.BeginUpdate;
  //��ʼɾ��
  try
    try
      nSucceedCount := DeletePlan(planList);
      Application.MessageBox(PChar(Format('�ɹ�ɾ��%d���ƻ���ʧ��%d����',
        [nSucceedCount, planList.Count - nSucceedCount])), '��ʾ', MB_OK + MB_ICONINFORMATION);
      InitTrainPlan;
    except
    on e: exception do
      begin
        Box(PChar(Format('ɾ��ʧ��,������Ϣ:%s��', [e.Message])));
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

  strMsg := 'ȷ��Ҫ��ͼ�����α��м��ز���%s��%s�ļƻ���?';
  strMsg := Format(strMsg, [FormatDateTime('yyyy-MM-dd hh:nn', dtBeginTime), FormatDateTime('yyyy-MM-dd hh:nn', dtEndTime)]);

  if Application.MessageBox(PChar(strMsg), '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
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
      Box(Format('��ͼ�����α��м��ؼƻ�����%s', [e.Message]));
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
  //��ȡѡ�мƻ���GUID�����ж�ѡ�еļƻ��Ƿ����Ҫ��
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
      Application.MessageBox('û��Ҫ�·��ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    if not TBox('��ȷ��Ҫ�·��ƻ���Ϣ��') then exit;
    

    try
      if not m_DBTrainPlan.SendPlan(guids,GlobalDM.SiteInfo.strSiteGUID, GlobalDM.DutyUser.strDutyGUID) then
      begin
        Application.MessageBox('�·��ƻ�ʧ�ܣ�', '��ʾ', MB_OK + MB_ICONERROR);
        GlobalDM.ADOConnection.RollbackTrans;
        exit;
      end
      else
      begin
        if TFMessageList.Count > 0 then
          PostPlanMessage(TFMessageList);
      end;  
      //ˢ�¼ƻ���ʾ
      InitTrainPlan;
      Box('�·��ƻ��ɹ���');
    except on e: exception do
      begin
        Box(PChar(Format('�·��ƻ�ʧ��,������Ϣ:%s��', [e.Message])));
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
  //��ȡѡ�мƻ���GUID�����ж�ѡ�еļƻ��Ƿ����Ҫ��
  planList := TStringList.Create;
  try
    GetAllPlan(planList);
    if planList.Count = 0 then
    begin
      Application.MessageBox('û��Ҫ�·��ļƻ���', '��ʾ', MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    
    if not TBox('��ȷ��Ҫ�·��ƻ���Ϣ��') then exit;
    try
      if not SendPlan(planList) then
        Application.MessageBox('�·��ƻ�ʧ�ܣ�', '��ʾ', MB_OK + MB_ICONERROR) 
      else
         Box('�·��ƻ��ɹ���'); 
      //ˢ�¼ƻ���ʾ
      InitTrainPlan;
    except on e: exception do
      begin
        Box(PChar(Format('�·��ƻ�ʧ��,������Ϣ:%s��', [e.Message])));
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

  //����Ƿ���Ҫ�����Ϣ
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
    //����ʧ��
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
  statusPanelDBState.Caption := '���ݿ�������!';
  statusPanelDBState.Font.Color := clBlack;
end;

procedure TfrmMain_JiDiao.DBDisconnected(Sender: TObject);
begin
  statusPanelDBState.Caption := '���ݿ��ѶϿ�!';
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

    //����Ǳ�ɾ��
    if not m_DBTrainPlan.GetPlan(trainPlanGUID, trainPlan) then
    begin
      Box('���мƻ��ѱ�ɾ������ˢ�º�����');
      Continue
    end;
    //����Ƿ���ɾ��
    if trainPlan.nPlanState <> psEdit then
    begin
      Box('ֻ��ɾ�����ڱ༭״̬�ļƻ���');
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
    //��ʼ����Ҫ��Ӳ������
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
    CanClose := MessageBox(Handle,'��ȷ��Ҫ�˳���?','����',
      MB_ICONQUESTION or MB_YESNO or MB_DEFBUTTON2) = mrYes;
end;

procedure TfrmMain_JiDiao.FormCreate(Sender: TObject);
begin
  //strGrid��ѡ�п���ɫ
  strGridTrainPlan.SelectionRectangleColor := clRed;
  //���ݿ������
  m_DBTrainJiaolu := TRsDBTrainJiaolu.Create(GlobalDM.ADOConnection);
  m_DBTrainPlan := TRsDBTrainPlan.Create(GlobalDM.ADOConnection);
  //ͼ������WEB
  m_webTrainnos := TRsLCTrainnos.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webTrainPlan := TRsLCTrainPlan.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  m_webDutyPlace := TRsLCDutyPlace.Create(GlobalDM.GetWebUrl,GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  //��¼strGrid���п�
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
    Box('��ǰû��ѡ�е��г�������Ϣ');
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

    //�Ƿ�ˢ���ж�
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
      Box('��ȡ�ƻ���Ϣʧ�ܣ�' + e.Message);
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
    Box('�Ѿ������ļƻ������޸��г�����');
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
  //�ͷ���Ӳ������
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
  statusAppVersion.Caption := '���³��򷢲�,�뼰ʱ����!';
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
            TFM_PLAN_RENYUAN_PUBLISH: strMessageType := '�ѷ���';
            TFM_PLAN_RENYUAN_UPDATE: strMessageType := '���¼ƻ�';
            TFM_PLAN_RENYUAN_DELETE: strMessageType := '�����ƻ�';
            TFM_PLAN_RENYUAN_RECIEVE: strMessageType := '�ѽ���';
            TFM_PLAN_RENYUAN_RMTRAINMAN: strMessageType := '�Ƴ���Ա';
            TFM_PLAN_RENYUAN_RMGROUP: strMessageType := '�Ƴ�����';
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
              item.SubItems.Add(Format('�üƻ���"%s"ʱ����!',[
                FormatDateTime('yyyy-MM-dd HH:nn:ss',trainPlan.dtStartTime)
              ]));
            end;
          end;
        end;
        TFM_WORK_BEGIN:
        begin
          if m_DBTrainPlan.GetPlan(TFMessages.Items[i].StrField['planGuid'], trainPlan) then
          begin
            strMessageType := '����';
            item := lstviewMsg.Items.Insert(0);
            item.Caption := strMessageType;
            item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',now));
            item.SubItems.Add(TFMessages.Items[i].StrField['jiaoLuName']);
            item.SubItems.Add(TFMessages.Items[i].StrField['strTrainNo']);
            item.SubItems.Add(Format('����Ա%s�ѳ���!',[TFMessages.Items[i].StrField['tmname']
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
    //����Ƿ���Ҫ�����Ϣ
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
  //�޶������޸�
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
  
  //��֤����ʱ���ʵ�ʿ���ʱ��
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


  //���ݿ���ʱ��������ʱ��
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

  //��֤���κͳ���
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
      //��� 90����
      1 : nMinute := 90;
      //վ��
      2 : nMinute := 60;
    end;

    //������
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
    statusUpdate.Caption := '�ͻ�����Ҫ���£�������ϵͳ';
    statusUpdate.Font.Color := clRed;
  end
  else
  begin
    statusUpdate.Caption := '�ͻ����������°汾';
    statusUpdate.Font.Color := clBlack;
  end;
end;

procedure TfrmMain_JiDiao.tmrRefreshTimeTimer(Sender: TObject);
begin
  TTimer(Sender).Enabled := false;
  try
    if GlobalDM.ADOConnection.Connected then
    begin
      statusPanelDBState.Caption := '���ݿ�������!';
      statusPanelDBState.Font.Color := clBlack;
    end else begin
      statusPanelDBState.Caption := '���ݿ��ѶϿ�!';
      statusPanelDBState.Font.Color := clRed;
    end;
    m_dtNow := GlobalDM.GetNow;
    statusSysTime.Caption := formatDateTime('yyyy-mm-dd hh:nn:ss', m_dtNow);  
    statusMessage.Caption := Format('��Ϣ���棺%d��', [GlobalDM.TFMessageCompnent.MessageBufferCount]);
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
    //�˴�������������޸�ֵ������
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
    Box('��ǰû��ѡ�е��г�������Ϣ');
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


