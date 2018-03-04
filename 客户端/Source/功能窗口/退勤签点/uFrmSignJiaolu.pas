unit uFrmSignJiaolu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, Buttons, PngSpeedButton, StdCtrls, ComCtrls, Grids, AdvObj,
  BaseGrid, AdvGrid, ExtCtrls, RzPanel,ufrmSelectColumn,uGlobalDM, RzTabs,uSignPlan,
  uTrainman,uLCSignPlan,uTrainJiaolu,uTFSystem,DateUtils,
  uTrainmanJiaolu,ufrmTextInput,uFrmEditSignTrainman,uSaftyEnum,
  uTFMessageDefine,uRunSaftyMessageDefine,uTrainPlan, RzDTP,uPubFun,uFrmEditSignPlan,
  uLCTrainmanMgr,uLCBaseDict,uLCNameBoardEx,uTFSkin;
const
  TFinishedTypeNameAry : array[0..1] of string =('否','是');
type
   TGridCol =(cl_Index,cl_State,cl_TrainNo,cl_dtChuQinTime,cl_dtStartTrain,cl_dtArriveTime,
    cl_dtCallTime,cl_tm1,cl_tm2,cl_tm3,cl_tm4,cl_Finish);
  //签点窗体类型
  TSignFormType = (TSF_TuiQin{退勤},TSF_PaiBan{派班}) ;

  TFrmSignJiaolu = class(TForm)
    PMTuiQin: TPopupMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    pmPaiBan: TPopupMenu;
    MenuItem1: TMenuItem;
    pMenuColumn: TPopupMenu;
    miSelectColumn: TMenuItem;
    N11: TMenuItem;
    rzpnl1: TRzPanel;
    rbDay1: TRadioButton;
    rbDay2: TRadioButton;
    rbDay3: TRadioButton;
    rbDay4: TRadioButton;
    btnSign: TPngSpeedButton;
    btnRefreshPaln: TPngSpeedButton;
    btnAdd: TPngSpeedButton;
    btnModify: TPngSpeedButton;
    btnDel: TPngSpeedButton;
    chkShowFinished: TCheckBox;
    rzpnl2: TRzPanel;
    GridSignPlan: TAdvStringGrid;
    procedure miSelectColumnClick(Sender: TObject);
    procedure GridSignPlanMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnSignClick(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure chkShowFinishedClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure GridSignPlanGetCellColor(Sender: TObject; ARow, ACol: Integer;
      AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
    procedure PMTuiQinPopup(Sender: TObject);
    procedure GridSignPlanMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure cbbTimeSectionChange(Sender: TObject);
    procedure GridSignPlanClickCell(Sender: TObject; ARow, ACol: Integer);
    procedure rbFirstDayClick(Sender: TObject);
    procedure rbSecondDayClick(Sender: TObject);
    procedure chkFirstDayClick(Sender: TObject);
    procedure chkSecondDayClick(Sender: TObject);
    procedure rbDay1Click(Sender: TObject);
    procedure rbDay2Click(Sender: TObject);
    procedure rbDay3Click(Sender: TObject);
    procedure rbDay4Click(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnRefreshPalnClick(Sender: TObject);
    procedure btnDelClick(Sender: TObject);
    procedure btnModifyClick(Sender: TObject);
  private
    { Private declarations }
  public
    {功能:签点}
    procedure Sign(trainman:RRsTrainman);
  private
    {功能:获取查询开始时间}
    function GetSearchStartTime(dtDay:TDateTime):TDateTime;
    {功能:获取查询截止时间}
    function GetSearchEndTime(dtDay:TDateTime):TDateTime;
    {功能:获取选中的日期}
    function GetSelDay():TDateTime;
    {功能:按天显示人员签点计划}
    procedure ShowSignPlanList(dtDay:TDateTime);
    {功能:查询某天的签点计划}
    function QeuryDaySignPlan(dtDay:TDateTime):Boolean;
    {功能:签点}
    procedure SignPlan(nPlanIndex:Integer;trainman:RRsTrainman);
     {功能:显示某天的签点信息}
    procedure Refresh();
    {功能:填充表格}
    procedure FillGrid();
    {功能:初始化表格}
    procedure InitGrid(nCount:Integer);
    {功能:填充列}
    procedure FillLine(row :Integer;signPlan:TSignPlan);
    {功能:判断是否隐藏结束记录}
    function bHideFinishedPlan(plan:TSignPlan):Boolean;
    {功能:格式化日期}
    function FormatTime(dtTime:TDateTime):string;
    {功能:格式化输入人员姓名工号}
    function FormatTMNameNum(strName,strGH: string): string;


    {功能:设置签点计划人员机组信息}
    procedure SetSignPlanGroup(index:Integer;group:RRSGroup);
    {功能:获取选中司机}
    function GetSelectedTrainman(var trainman: RRsTrainman):Boolean;
    {功能:获取选中司机索引}
    function GetSelectedTrainmanIndex():Integer;

    {功能:获取选中计划}
    function GetSelectedPlan():TSignPlan;
    {功能:获取选中计划行}
    function GetSelectedPlanIndex():Integer;
    {功能:通过消息组件发送候班消息}
    procedure PostSignMsg(signPlan:TSignPlan);
    {功能:初始化工作时间}
    procedure InitWorkTime();
    {功能:判断人员是否可在本行车交路签点}
    function bCanWorkThisTrainJiaoLu(trainman:RRsTrainman):Boolean;
  private
    //系统时间配置
    m_TimeConfig:RRsKernelTimeConfig;
    //人员信息接口
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //签点web接口操作
    m_WebOP:TRSLCSignPlan;
    //行车交路所对应的人员交路列表
    m_TrainmanJiaoluArray: TRsTrainmanJiaoluArray ;
    //窗体类型
    m_FormType:TSignFormType;
    //几天的签点计划列表
    m_MutilDaySignPlanList:TMutilDaySignPlanJiaoLuList;
    //所选天的签点计划列表
    m_DaySignPlanJiaoLu:TDaySignPlanJiaoLu;
    //交路信息
    m_TrainJiaoLu:RRsTrainJiaolu;
    //
    m_LCNameBoard : TRsLCNameBoardEx;
  public
    property TrainJiaoLu:RRsTrainJiaolu read m_TrainJiaoLu write m_TrainJiaoLu;
    property FormType:TSignFormType read m_FormType write m_FormType;

  end;
implementation
{$R *.dfm}
procedure TFrmSignJiaolu.InitWorkTime;
var
  dtToday:TDateTime;
begin
  //获取白班夜班时间范围
  RsLCBaseDict.LCSysDict.GetKernelTimeConfig(m_TimeConfig);
  dtToday := DateOf(GlobalDM.GetNow);
  rbDay1.Caption := FormatDateTime('yyyy-mm-dd',dtToday);
  rbDay2.Caption := FormatDateTime('yyyy-mm-dd',dtToday+1);
  rbDay3.Caption := FormatDateTime('yyyy-mm-dd',dtToday+2);
  rbDay4.Caption := FormatDateTime('yyyy-mm-dd',dtToday+3);
end;

procedure TFrmSignJiaolu.MenuItem1Click(Sender: TObject);
var
  signPlan:TSignPlan;
  strErrMsg:string;
  sState:TRsPlanState;
begin
  signPlan := GetSelectedPlan;
  if Assigned(signPlan) then
  begin
    sState := signPlan.eState;
    signPlan.nFinished := 1;
    if m_WebOP.Sign(signPlan,strErrMsg)= False then
    begin
      Box('修改状态失败,原因:' + strErrMsg);
      signPlan.eState := sState;
      Exit;
    end;
    FillLine(GetSelectedPlanIndex,signPlan);
  end;
  
end;

function TFrmSignJiaolu.bCanWorkThisTrainJiaoLu(trainman: RRsTrainman): Boolean;
var
  i:Integer;
begin
  result := False;
  for i := 0 to Length(m_TrainmanJiaoluArray)- 1 do
  begin
    if m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID = trainman.strTrainmanJiaoluGUID then
    begin
      result := True;
      Exit;
    end;
  end;
end;

function TFrmSignJiaolu.bHideFinishedPlan(plan: TSignPlan): Boolean;
begin
  result := False;
  if chkShowFinished.Checked= False then//不显示已结束
  begin
    if plan.nFinished  =1  then//计划已结束
      result := True;
  end;
end;

procedure TFrmSignJiaolu.btnAddClick(Sender: TObject);
var
  plan:TSignPlan;
  strCheCi:string;
begin
  if TFrmEditSignPlan.CreateSignPlan(m_TrainJiaoLu,plan) = False then Exit;
  try
    strCheCi := plan.strTrainNo;
    Refresh();
  finally
    if Assigned(plan) then
      plan.Free;
  end;

end;

procedure TFrmSignJiaolu.btnDelClick(Sender: TObject);
var
  plan:TSignPlan;
  strErrMsg:string;
begin
  if TBox('您确定要删除签点计划么?') = False then Exit;
  if TBox('请再次确定要删除签点计划么?') = False  then Exit;
  plan := GetSelectedPlan;
  if plan = nil then
  begin
    Box('未选中有效数据行!');
    Exit;
  end;
  if m_WebOP.DelSignPlan(plan,strErrMsg) = False then
  begin
    Box('删除失败,原因:' + strErrMsg);
  end;
  Refresh();
end;

procedure TFrmSignJiaolu.btnModifyClick(Sender: TObject);
var
  sPlan:TSignPlan;
  strCheCi:string;
begin
  sPlan := GetSelectedPlan;
  if sPlan = nil then
  begin
    Box('未选择有效的数据行!');
    Exit;
  end;
  if TFrmEditSignPlan.ModifySignPlan(m_TrainJiaoLu,sPlan) = False then Exit;
  strCheCi := sPlan.strTrainNo;
  Refresh();
end;

procedure TFrmSignJiaolu.btnRefreshPalnClick(Sender: TObject);
begin
  Refresh();
end;

procedure TFrmSignJiaolu.btnSignClick(Sender: TObject);
var
  strNumber:string;
  trainman:RRsTrainman;
begin
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber,7) = False then
      Exit;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('错误的乘务员工号');
    exit;
  end;
    //if trainman.strTrainJiaoluGUID <> m_TrainJiaoLu.strTrainJiaoLuGUID then
  if bCanWorkThisTrainJiaoLu(trainman) = False then
  begin
    Box('人员不可执乘此行车交路!');
    Exit;
  end;
  Sign(trainman);
  Refresh();
end;

procedure TFrmSignJiaolu.cbbTimeSectionChange(Sender: TObject);
begin
  FillGrid();
end;

procedure TFrmSignJiaolu.chkFirstDayClick(Sender: TObject);
begin
  FillGrid();
end;

procedure TFrmSignJiaolu.chkSecondDayClick(Sender: TObject);
begin
  FillGrid();
end;

procedure TFrmSignJiaolu.chkShowFinishedClick(Sender: TObject);
begin
   FillGrid();
end;

procedure TFrmSignJiaolu.InitGrid(nCount: Integer);
begin
  with gridsignPlan do
  begin
    ClearRows(1,10000);
    if  nCount > 0  then
      RowCount := nCount + 2
    else
    begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
  end;
end;

procedure TFrmSignJiaolu.FillGrid();
var
  i: Integer;
begin
  with gridsignPlan do
  begin
    InitGrid(m_DaySignPlanJiaoLu.SignPlanList.Count);
    //ShowMessage(IntToStr(GetTickCount - t1));
    for i := m_DaySignPlanJiaoLu.SignPlanList.Count - 1 downto 0 do
    //for i := 0 to m_SignPlanJiaoLu.SignPlanList.Count - 1  do
    begin
      FillLine(i,m_DaySignPlanJiaoLu.SignPlanList.Items[i]);
    end;
     //ShowMessage(IntToStr(GetTickCount - t1));
    Invalidate;
  end;
end;
function TFrmSignJiaolu.FormatTMNameNum(strName,strGH: string): string;
begin
  result :='';
  if strGH <> '' then
  begin
    result := Format('%s[%s]',[strName,strGH]);
  end;
end;


procedure TFrmSignJiaolu.FillLine(row:Integer;signPlan: TSignPlan);
var
  nRow :Integer;
begin
  nRow := row + 1;
  with GridSignPlan do
  begin
    Cells[Ord(cl_Index),nRow] := IntToStr(nRow);
    Cells[Ord(cl_State),nRow] := TRsPlanStateNameAry[signPlan.eState];
    Cells[Ord(cl_TrainNo), nRow] := signPlan.strTrainNo;
    Cells[Ord(cl_dtStartTrain), nRow ] :=FormatTime( signPlan.dtStartTrainTime);
    Cells[Ord(cl_dtChuQinTime),nRow]:= FormatTime(signPlan.dtChuQinTime);
    if signPlan.nNeedRest = 1 then
    begin
      Cells[Ord(cl_dtArriveTime),nRow]:= FormatTime(signPlan.dtArriveTime);
      Cells[Ord(cl_dtCallTime), nRow ] := FormatTime(signPlan.dtCallTime);
    end;

    Cells[Ord(cl_tm1),nRow ] := FormatTMNameNum(signPlan.strTrainmanName1,signPlan.strTrainmanNumber1) ;
    Cells[Ord(cl_tm2),nRow ] := FormatTMNameNum(signPlan.strTrainmanName2,signPlan.strTrainmanNumber2) ;
    Cells[Ord(cl_tm3), nRow ]:= FormatTMNameNum(signPlan.strTrainmanName3,signPlan.strTrainmanNumber3) ;
    Cells[Ord(cl_tm4), nRow ]:= FormatTMNameNum(signPlan.strTrainmanName4,signPlan.strTrainmanNumber4) ;

    Cells[Ord(cl_Finish), nRow ]:= TFinishedTypeNameAry[signPlan.nFinished ];
    //if (bInShowTimeSection(signPlan.dtChuQinTime)= False )or (bHideFinishedPlan(signPlan) = True) then
    if(bHideFinishedPlan(signPlan) = True) then
    begin
       GridSignPlan.HideRow(GridSignPlan.RealRowIndex(nRow));
    end
  end;
end;

function TFrmSignJiaolu.FormatTime(dtTime:TDateTime): string;
begin
  Result := FormatDateTime('MM-DD HH:mm',dtTime);
end;

procedure TFrmSignJiaolu.FormCreate(Sender: TObject);
begin
  TtfSkin.InitAdvGrid(GridSignPlan);
  GridSignPlan.ColumnSize.Save := false;
  GlobalDM.SetGridColumnWidth(GridSignPlan);
  GlobalDM.SetGridColumnVisible(GridSignPlan);
  m_RsLCTrainmanMgr:=TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_WebOP:=TRSLCSignPlan.Create(GlobalDM.GetWebUrl,
  GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);

  RsLCBaseDict.LCSysDict.GetKernelTimeConfig(m_TimeConfig);
  m_MutilDaySignPlanList:=TMutilDaySignPlanJiaoLuList.Create;
  m_LCNameBoard := TRsLCNameBoardEx.Create(GlobalDM.WebAPIUtils);  
end;

procedure TFrmSignJiaolu.FormDestroy(Sender: TObject);
begin
   GlobalDM.SaveGridColumnWidth(GridSignPlan);
   m_RsLCTrainmanMgr.Free;
   m_WebOP.Free;
   m_MutilDaySignPlanList.Free;
   m_LCNameBoard.Free;
end;

procedure TFrmSignJiaolu.FormShow(Sender: TObject);
begin
  InitWorkTime();
 // UpdateJiaoLu();
  if Self.m_FormType = TSF_TuiQin then
  begin
    btnSign.Visible := True;
    //chkShowFinished.Visible := False;
    btnAdd.Visible := True;
    btnModify.Visible := True;
    btnDel.Visible := True;

  end;
  if Self.m_FormType = TSF_PaiBan then
  begin
    btnSign.Visible := False;
    //chkShowFinished.Visible := True;
    btnAdd.Visible := False;
    btnModify.Visible := False;
    btnDel.Visible := False;
  end;

  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.SiteInfo.strSiteGUID, m_TrainJiaoLu.strTrainJiaoluGUID,
      m_TrainmanJiaoluArray);
  
end;

procedure TFrmSignJiaolu.GridSignPlanClickCell(Sender: TObject; ARow, ACol: Integer);
begin
  ShowMessage(Format('显示行%d,实际行%d',[ARow,gridSignPlan.RealRowIndex(ARow)]));
end;

procedure TFrmSignJiaolu.GridSignPlanGetCellColor(Sender: TObject; ARow,
  ACol: Integer; AState: TGridDrawState; ABrush: TBrush; AFont: TFont);
var
  planstate:TRsPlanState;
begin
  if ACol = 1 then
  begin
    for planstate := Low(TRsPlanState) to High(TRsPlanState) do
    begin
      if GridSignPlan.Cells[ACol,ARow] = TRsPlanStateNameAry[planstate] then
      begin
        ABrush.Color := TRsPlanStateColorAry[planstate];
        Break;
      end;
    end;
  end;
end;


procedure TFrmSignJiaolu.GridSignPlanMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  col,row:Integer;
begin
  GridSignPlan.MouseToCell(X,Y,col,row);
  if Row = 0 then
  begin
    GridSignPlan.PopupMenu := pMenuColumn;
  end
  else
  begin
    if self.m_FormType = TSF_TuiQin  then
      GridSignPlan.PopupMenu := PMTuiQin
    else
      GridSignPlan.PopupMenu := pmPaiBan;
  end;
end;

procedure TFrmSignJiaolu.GridSignPlanMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  PT: TPoint;
  col,row : integer;
  signPlan:TSignPlan;
begin
  if mbRight <> Button then
    Exit;

  GridSignPlan.MouseToCell(X,Y,col,row);
  if (row = 0) then
  begin
    pt := Point(X,Y);
    pt := GridSignPlan.ClientToScreen(pt);
    pMenuColumn.Popup(pt.X,pt.y);
    GridSignPlan.PopupMenu := pMenuColumn;
    exit;
  end;
  Exit;
  signPlan := GetSelectedPlan;
  if not Assigned(signPlan) then  Exit;
  if self.m_FormType = TSF_TuiQin then
  begin
    GridSignPlan.PopupMenu := PMTuiQin;
    {GridSignPlan.PopupMenu.Items[0].Enabled := False;
    if GetSelectedTrainmanIndex <> -1 then
    begin
      if signPlan.bSigned = True then
      begin
        GridSignPlan.PopupMenu.Items[0].Enabled := True ;
      end;
    end; }
    Exit;
  end;

  if Self.m_FormType = TSF_PaiBan then
  begin
    GridSignPlan.PopupMenu := pmPaiBan;
  end;
end;

procedure TFrmSignJiaolu.miSelectColumnClick(Sender: TObject);
begin
  TfrmSelectColumn.SelectColumn(GridSignPlan,'SignPlan');
end;

procedure TFrmSignJiaolu.N1Click(Sender: TObject);
var
  S_Trainman:RRsTrainman;
  signPlan:TSignPlan;
begin
  signPlan := GetSelectedPlan();
  if signPlan = nil then Exit;
  GetSelectedTrainman(S_Trainman);


  if EditSignTrainman(m_DaySignPlanJiaoLu,signPlan,S_Trainman,GetSelectedTrainmanIndex) = False then Exit;
  PostSignMsg(signPlan);
  FillLine(GridSignPlan.GetRealRow -1,signPlan);

end;

procedure TFrmSignJiaolu.N3Click(Sender: TObject);
var
  strNumber:string;
  trainman:RRsTrainman;
  nIndex:Integer;

begin
  nIndex := GetSelectedPlanIndex();
  if nIndex = -1 then
  begin
    Box('未选择有效计划!');
    Exit;
  end;
  if m_DaySignPlanJiaoLu.SignPlanList.Items[nIndex].bSigned() then
  begin
    Box('此计划已签点');
    Exit;
  end;
  if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber,7) = False then
      Exit;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('错误的乘务员工号');
    exit;
  end;
  //if trainman.strTrainJiaoluGUID <> m_TrainJiaoLu.strTrainJiaoLuGUID then
  if bCanWorkThisTrainJiaoLu(trainman) = False then
  begin
    Box('人员不可执乘此行车交路!');
    Exit;
  end;
  
  SignPlan( nIndex,trainman);
end;




procedure TFrmSignJiaolu.SetSignPlanGroup(index:Integer;group: RRSGroup);
var
  nIndex:Integer;
begin
  with m_DaySignPlanJiaoLu.SignPlanList.Items[index] do
  begin
    strWorkGrouGUID := group.strGroupGUID;
    if  m_DaySignPlanJiaoLu.SignPlanList.FindPlanByTM(group.Trainman1.strTrainmanGUID,nIndex) = nil then
    begin
      strTrainmanGUID1 := group.Trainman1.strTrainmanGUID;
      strTrainmanName1 := group.Trainman1.strTrainmanName;
      strTrainmanNumber1 := group.Trainman1.strTrainmanNumber;
    end;
    if  m_DaySignPlanJiaoLu.SignPlanList.FindPlanByTM(group.Trainman2.strTrainmanGUID,nIndex) = nil then
    begin
      strTrainmanGUID2 := group.Trainman2.strTrainmanGUID;
      strTrainmanName2 := group.Trainman2.strTrainmanName;
      strTrainmanNumber2 := group.Trainman2.strTrainmanNumber;
    end;
    if  m_DaySignPlanJiaoLu.SignPlanList.FindPlanByTM(group.Trainman3.strTrainmanGUID,nIndex) = nil then
    begin
      strTrainmanGUID3 := group.Trainman3.strTrainmanGUID;
      strTrainmanName3 := group.Trainman3.strTrainmanName;
      strTrainmanNumber3 := group.Trainman3.strTrainmanNumber;
    end;
    if  m_DaySignPlanJiaoLu.SignPlanList.FindPlanByTM(group.Trainman4.strTrainmanGUID,nIndex) = nil then
    begin
      strTrainmanGUID4 := group.Trainman4.strTrainmanGUID;
      strTrainmanName4 := group.Trainman4.strTrainmanName;
      strTrainmanNumber4 := group.Trainman4.strTrainmanNumber;
    end;
  end;
end;

procedure TFrmSignJiaolu.ShowSignPlanList(dtDay: TDateTime);
begin
  if m_DaySignPlanJiaoLu <> nil then
  begin
     if m_DaySignPlanJiaoLu.dtDay = dtDay then Exit;
  end;

  m_DaySignPlanJiaoLu := m_MutilDaySignPlanList.FindByDay(dtDay);
  InitGrid(0);
  if m_DaySignPlanJiaoLu = nil then
  begin
    if QeuryDaySignPlan(dtDay) = False then Exit;
  end;
  FillGrid();
end;

procedure TFrmSignJiaolu.SignPlan(nPlanIndex:Integer;trainman:RRsTrainman);
var
  strErrMsg:string;
  group:rrsgroup;
  signPlan:TSignPlan;
begin
  signPlan := m_DaySignPlanJiaoLu.SignPlanList[nPlanIndex];

  if m_LCNameBoard.Group.GetGroup(trainman.strTrainmanNumber,0,group) = False then
  begin
    Box('未找到:'+ FormatTMNameNum(trainman.strTrainmanName ,trainman.strTrainmanNumber ) + '的机组信息');
    Exit ;
  end;
  if group.strTrainPlanGUID <>'' then
  begin
    Box('乘务员所属机组未全部退勤');
    Exit;
  end;
  {nIndex := m_DaySignPlanJiaoLu.SignPlanList.FindGroup(group.strGroupGUID);
  if nIndex <> -1 then
  begin
    box(Format('此人员所属机组已签第%d条计划',[nIndex+1]));
    Exit;
  end;
  }
  SetSignPlanGroup(nPlanIndex,group);
  m_DaySignPlanJiaoLu.SignPlanList.Items[nPlanIndex].dtSignTime := GlobalDM.GetNow();
  m_DaySignPlanJiaoLu.SignPlanList.Items[nPlanIndex].eState := psPublish;
  if m_WebOP.Sign(m_DaySignPlanJiaoLu.SignPlanList.Items[nPlanIndex],strErrMsg) = False then
  begin
    Box(strErrMsg);
    Exit;
  end;
  PostSignMsg(signPlan);
  
  FillLine(nPlanIndex,m_DaySignPlanJiaoLu.SignPlanList.Items[nPlanIndex]);
end;
procedure TFrmSignJiaolu.Sign(trainman: RRsTrainman);
var
  index:Integer;
  plan:TSignPlan;
begin
  //SetSelectedTrainJiaolu(trainman.strTrainJiaoluGUID);
  {if m_DaySignPlanJiaoLu.SignPlanList.GetFirstSignedPlanIndex = -1 then
  begin
    Box('首次签点,请选中一条签点计划后,在右键弹出菜单中使用[定向签点]完成首次签点!');
    Exit;
  end;  }
  if TBox('是否对鼠标所选计划执行签点') then
  begin
    index := GetSelectedPlanIndex();
    plan := GetSelectedPlan;
    if plan = nil then
    begin
      Box('请选中要签点的计划!');
      Exit;
    end;
    
    if plan.bSigned then
    begin
      Box('此计划已签点');
      Exit;
    end;
  end
  else
  begin
    index:= m_DaySignPlanJiaoLu.SignPlanList.FindNextSignPlanIndex();
  end;
  if index = -1 then
  begin
    Box('未找到待签点计划');
    Exit;
  end;
  
  SignPlan(index,trainman);

  //GridSignPlan.Invalidate;
end;
procedure TFrmSignJiaolu.PMTuiQinPopup(Sender: TObject);
var
  signPlan :TSignPlan;
begin
  signPlan := GetSelectedPlan;
  if not Assigned(signPlan) then  Exit;
  GridSignPlan.PopupMenu.Items[0].Enabled := False;
  if GetSelectedTrainmanIndex <> -1 then
  begin
    if signPlan.bSigned = True then
    begin
     PMTuiQin.Items[0].Enabled := True ;
     PMTuiQin.Items[2].Enabled := False;
    end
    else
    begin
      PMTuiQin.Items[0].Enabled := False ;
      PMTuiQin.Items[2].Enabled := True;
    end;
  end;
end;

procedure TFrmSignJiaolu.PostSignMsg(signPlan:TSignPlan);
var
  guids:TStrings;
  TFMessage: TTFMessage;
begin
  TFMessage := TTFMessage.Create;
  guids:=TStringList.Create;
  try
    guids.Add(signPlan.strGUID);
    TFMessage.msg := TFM_PLAN_SIGN_WAITWORK;
    TFMessage.StrField['GUIDS'] := GUIDS.Text;
    GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
    if signPlan.nNeedRest = 1 then
    begin
      TFMessage.msg := TFM_PLAN_SIGN;
      GlobalDM.TFMessageCompnent.PostMessage(TFMessage);
    end;
  finally
    guids.Free;
    TFMessage.Free;
  end;
end;

function TFrmSignJiaolu.QeuryDaySignPlan(dtDay: TDateTime):Boolean;
var
  dtStart,dtEnd:TDateTime;
  strMsg:string;
begin
  Result := False;
  dtStart := GetSearchStartTime(dtDay);
  dtEnd := GetSearchEndTime(dtDay);
  if m_DaySignPlanJiaoLu = nil then
  begin
    m_DaySignPlanJiaoLu:=TDaySignPlanJiaoLu.Create;
    m_DaySignPlanJiaoLu.dtDay := dtDay;
    m_MutilDaySignPlanList.Add(m_DaySignPlanJiaoLu);
  end;
  m_DaySignPlanJiaoLu.SignPlanList.Clear;
  m_DaySignPlanJiaoLu.strTrainJiaoLuGUID :=TrainJiaoLu.strTrainJiaoluGUID;
  if m_WebOP.GetSignPlan(dtStart,dtEnd,TSignPlanJiaoLu(m_DaySignPlanJiaoLu),strMsg)= False then
  begin
    m_DaySignPlanJiaoLu.Free;
    Box(strMsg);
    Exit;
  end;

  Result := True;
end;

procedure TFrmSignJiaolu.rbDay1Click(Sender: TObject);
begin
  ShowSignPlanList(StrToDateTime(rbDay1.Caption));
end;

procedure TFrmSignJiaolu.rbDay2Click(Sender: TObject);
begin
  ShowSignPlanList(StrToDateTime(rbDay2.Caption));
end;

procedure TFrmSignJiaolu.rbDay3Click(Sender: TObject);
begin
  ShowSignPlanList(StrToDateTime(rbDay3.Caption));
end;

procedure TFrmSignJiaolu.rbDay4Click(Sender: TObject);
begin
  ShowSignPlanList(StrToDateTime(rbDay4.Caption));
end;

procedure TFrmSignJiaolu.rbFirstDayClick(Sender: TObject);
begin
  FillGrid;
end;

procedure TFrmSignJiaolu.rbSecondDayClick(Sender: TObject);
begin
  FillGrid();
end;

procedure TFrmSignJiaolu.Refresh;
var
  dtDay:TDateTime;
begin
  dtDay := GetSelDay ;
  if dtDay = 0 then
  begin
    Box('未指定日期!');
    Exit;
  end;
  m_DaySignPlanJiaoLu := m_MutilDaySignPlanList.FindByDay(dtDay);
  InitGrid(0);
  if QeuryDaySignPlan(dtDay) = False then Exit;
  FillGrid();
end;

function TFrmSignJiaolu.GetSearchEndTime(dtDay:TDateTime): TDateTime;
begin
  result := uTFSystem.AssembleDateTime(dtDay+1,TimeOf(GlobalDM.ShowSignPlanStartTime));
  //result := DateUtils.IncMinute(dtDay+1,m_TimeConfig.nMinDayWorkStart);
end;

function TFrmSignJiaolu.GetSearchStartTime(dtDay:TDateTime): TDateTime;
begin
  result := uTFSystem.AssembleDateTime(dtDay,TimeOf(GlobalDM.ShowSignPlanStartTime));
  //result := DateUtils.IncMinute(dtDay,m_TimeConfig.nMinDayWorkStart);
end;


function TFrmSignJiaolu.GetSelDay: TDateTime;
begin
  Result := 0;
  if rbDay1.Checked then
  begin
    Result := StrToDateTime(rbDay1.Caption);
    Exit;
  end;
  if rbDay2.Checked then
  begin
    Result := StrToDateTime(rbDay2.Caption);
    Exit;
  end;
  if rbDay3.Checked then
  begin
    Result := StrToDateTime(rbDay3.Caption);
    Exit;
  end;
  if rbDay4.Checked then
  begin
    Result := StrToDateTime(rbDay4.Caption);
    Exit;
  end;
end;

function TFrmSignJiaolu.GetSelectedPlan: TSignPlan;
var
  index:Integer;
begin
  result := nil;
  index := GetSelectedPlanIndex;
  if index <> -1 then
  begin
    result := m_DaySignPlanJiaoLu.SignPlanList[index];
  end;
end;

function TFrmSignJiaolu.GetSelectedPlanIndex: Integer;
var
  row:Integer;
begin
  result := -1;
  if m_DaySignPlanJiaoLu = nil then 
  begin
    Exit;
  end;
  row := GridSignPlan.GetRealRow-1;
  //box(IntToStr(row));
  if (row >= 0) and (row <= m_DaySignPlanJiaoLu.SignPlanList.count-1) then
  begin
    result := row;
  end;
end;


function TFrmSignJiaolu.GetSelectedTrainmanIndex():Integer;
var
  realCol:Integer;
begin
  result := -1;
  realCol:=  GridSignPlan.GetRealCol;
  case realCol of
    ord(cl_tm1): result := 1;
    ord(cl_tm2): result := 2;
    ord(cl_tm3): result := 3;
    ord(cl_tm4): result := 4;
  end;
end;


function TFrmSignJiaolu.GetSelectedTrainman(var trainman: RRsTrainman):Boolean;
var
  signPlan:TSignPlan;
  nIndex:Integer;
  strTrainmanID:string;
begin
  result := False;
  nIndex := GetSelectedTrainmanIndex;
  signPlan := GetSelectedPlan;
  if not Assigned(signPlan) then Exit;
  strTrainmanID := signPlan.GetTrianmanID(nIndex) ;

  if strTrainmanID <> '' then
  begin
    if m_RsLCTrainmanMgr.GetTrainman(strTrainmanID,trainman) = True then result := True;
  end;
end;


end.
