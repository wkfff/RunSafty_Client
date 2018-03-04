unit uFrmAskLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, ComCtrls, RzDTP, uLeaveListInfo,
  uGlobalDM, DateUtils, Types, uTFSystem, activex, uTrainman, Buttons,
  PngCustomButton, AdvDateTimePicker,uSaftyEnum, utfLookupEdit,
  utfPopTypes,  uTrainmanJiaolu,uLCAskLeave,
  uLCTrainmanMgr,uLCNameBoardEx;

type
  TFrmAskLeave = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label7: TLabel;
    RzPanel3: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    memoLog: TMemo;
    Label4: TLabel;
    Label2: TLabel;
    Label6: TLabel;
    cmbLeaveList: TComboBox;
    Label1: TLabel;
    Label5: TLabel;
    dtpBeginDate: TAdvDateTimePicker;
    edtAskerID: TtfLookupEdit;
    Label3: TLabel;
    edtProverID: TtfLookupEdit;
    Label8: TLabel;
    dtpEndDate: TAdvDateTimePicker;
    dtpBeginTime: TAdvDateTimePicker;
    dtpEndTime: TAdvDateTimePicker;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtAskerIDExit(Sender: TObject);
    procedure edtAskerIDChange(Sender: TObject);
    procedure edtAskerIDSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edtProverIDSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtProverIDExit(Sender: TObject);
    procedure edtProverIDChange(Sender: TObject);
    procedure edtAskerIDPrevPage(Sender: TObject);
    procedure edtAskerIDNextPage(Sender: TObject);
    procedure edtProverIDNextPage(Sender: TObject);
    procedure edtProverIDPrevPage(Sender: TObject);

  private
    { Private declarations }
    m_RsLCAskLeave: TRsLCAskLeave;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCNameBoardEx: TRsLCNameBoardEx;
  

    //保存请假类型数组
    m_LeaveTypeArray: TRsLeaveTypeArray;
    //保存职工信息，工号，姓名等
    //m_Trainman: RRsTrainman;
    //保存当前职工信息获取的方式
    m_Verify: TRsRegisterFlag;
    //保存请假人信息
    m_AskerPerson: RRsTrainman;
    m_Prover: RRsTrainman;

    //对对话框进行数据初始化
    function Init: boolean;
    function InitAskLeave(TrainmanNumber:string): boolean;
    //检查数据的输入
    function CheckInput: boolean;
    //校验请假人是否合法
    function CheckAskerID(strAskerID: string): boolean;
    function CheckProverID(strTrainmanNumber: string): Boolean;
    //初始司机选择下拉框
    procedure IniColumns(LookupEdit : TtfLookupEdit);
    //根据司机信息（如张三[1022]），提取司机工号
    function GetAskerID(strAsk: string): string;
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
  public
    { Public declarations }
    //显示对话框
    class function ShowAskLeaveForm : boolean;
    //对指定人员请假
    class function ShowAskLeaveFormByNumber(TrainmanNumber:string):Boolean;
  end;

implementation
uses
  ufrmTrainmanIdentity, ufrmTmJlSelect, ufrmLeaveJlSelect;
{$R *.dfm}

function TFrmAskLeave.CheckAskerID(strAskerID: string): boolean;
begin
  result := false;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strAskerID,m_AskerPerson) then exit;
  result := true;
end;

procedure TFrmAskLeave.edtAskerIDExit(Sender: TObject);
begin 
  if trim(edtAskerID.Text) = '' then exit;

  if not CheckAskerID(GetAskerID(edtAskerID.Text)) then
  begin
    Box('您输入的请假人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;

end;

procedure TFrmAskLeave.edtAskerIDNextPage(Sender: TObject);  
var
  TrainmanArray : TRsTrainmanArray;
begin
  //if edtAskerID.PopStyle.PageIndex >= edtAskerID.PopStyle.PageCount then exit;
  with edtAskerID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtAskerIDPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtAskerID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtAskerIDChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtAskerID do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtAskerID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtAskerIDSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtAskerID.OnChange := nil;
  try
   edtAskerID.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);

  finally
    edtAskerID.OnChange := edtAskerIDChange;
  end;
end;

procedure TFrmAskLeave.edtProverIDChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtProverIDExit(Sender: TObject);
begin
  if trim(edtProverID.Text) = '' then exit;

  if not CheckProverID(GetAskerID(edtProverID.Text)) then
  begin
    Box('您输入的批准人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;
end;

procedure TFrmAskLeave.edtProverIDNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtProverIDPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtProverID do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtProverID, TrainmanArray);
  end;
end;

procedure TFrmAskLeave.edtProverIDSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtProverID.OnChange := nil;
  try
   edtProverID.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtProverID.OnChange := edtProverIDChange;
  end
end;

procedure TFrmAskLeave.btnOKClick(Sender: TObject);
var
  i: integer;
  ErrMsg: string;
  bExist: boolean;
  group : RRsGroup;
  ApplyEntity: TLeaveApplyEntity;
  Input: TRsLCBoardInputJL;
begin
  if not CheckInput then exit;

  //验证该职工是否是本车间人员
  if m_AskerPerson.strWorkShopGUID <> GlobalDM.SiteInfo.WorkShopGUID then
  begin
    Box('该职工非本车间人员，不能办理请假!');
    exit;
  end;

  //验证该职工的状态是否是：已安排计划、已出勤
  if m_AskerPerson.nTrainmanState = tsPlaning then
  begin
    Box('该职工已安排计划，不能办理请假!');
    exit;
  end;
  if m_AskerPerson.nTrainmanState = tsRuning then
  begin
    Box('该职工已出勤，不能办理请假!');
    exit;
  end;
  if m_AskerPerson.nTrainmanState = tsNormal then
  begin

    m_RsLCNameBoardEx.Group.GetGroup(m_AskerPerson.strTrainmanNumber,0,group);


    //此乘务员已安排计划了
    if group.strTrainPlanGUID <> '' then
    begin
      Box('该职工在值乘别的计划，不能办理请假!');
      exit;
    end;
  end;

  //验证该职工是否存在没有销假的记录
  if not m_RsLCAskLeave.CheckWhetherAskLeaveByID(m_AskerPerson.strTrainmanNumber, bExist, ErrMsg) then
  begin
    BoxErr('检查是否有未销假的请假记录时失败:' + ErrMsg);
    exit;
  end;

  if bExist then
  begin
    Box('该职工之前的请假还没有销假，请销假之后再请假!');
    exit;
  end;

  if m_AskerPerson.strTrainmanJiaoluGUID = '' then
  begin
    Input := TRsLCBoardInputJL.create;
    try
      if TfrmLeaveJlSelect.SelectJL(Input) then
      begin
        m_RsLCTrainmanMgr.UpdateTrainmanJiaolu(m_AskerPerson.strTrainmanGUID,Input.jiaoluID);
      end;

    finally
      Input.Free;
    end;
  end;

  if not TBox('您确定要登记此条请假记录吗？') then exit;


  ApplyEntity := TLeaveApplyEntity.Create;
  try
    try
      for i := 0 to length(m_LeaveTypeArray) - 1 do
      begin
        if cmbLeaveList.Text = m_LeaveTypeArray[i].strTypeName then
        begin
          ApplyEntity.strTypeGUID := m_LeaveTypeArray[i].strTypeGUID;
          ApplyEntity.strTypeName := cmbLeaveList.Text;
          break;
        end;
      end;
      ApplyEntity.strTrainmanGUID := m_AskerPerson.strTrainmanGUID;
      ApplyEntity.strTrainmanNumber := m_AskerPerson.strTrainmanNumber;
      ApplyEntity.dtBeginTime := DateOf(dtpBeginDate.Date) + TimeOf(dtpBeginTime.Time);
      ApplyEntity.dtEndTime := DateOf(dtpEndDate.Date) + TimeOf(dtpEndTime.Time);

      ApplyEntity.strRemark := trim(memoLog.Text);
      ApplyEntity.strProverID := m_Prover.strTrainmanNumber;
      ApplyEntity.strProverName := m_Prover.strTrainmanName;
      ApplyEntity.strDutyUserID := GlobalDM.DutyUser.strDutyGUID;;
      ApplyEntity.strDutyUserName := GlobalDM.DutyUser.strDutyName;
      ApplyEntity.strSiteID := GlobalDM.SiteInfo.strSiteGUID;
      ApplyEntity.strSiteName := GlobalDM.SiteInfo.strSiteName;
      ApplyEntity.Verify := Ord(m_Verify);
      if not m_RsLCAskLeave.AskLeave(ApplyEntity,ErrMsg) then
      begin
        BoxErr('请假失败:' + ErrMsg);
        exit;
      end;

      Box('请假成功!');

      ModalResult := mrOk;
    except on e : exception do
      begin
        BoxErr('请假失败:' + e.Message);
      end;
    end;

  finally
    ApplyEntity.Free;
  end;

end;

function TFrmAskLeave.CheckInput: boolean;
begin
  result := false;
  
  if trim(edtAskerID.Text) = '' then
  begin
    Box('您没有输入批准人!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;

  if not CheckAskerID(GetAskerID(edtAskerID.Text)) then
  begin
    Box('您输入的批准人工号不正确!');
    edtAskerID.SelectAll;
    edtAskerID.SetFocus;
    exit;
  end;

  if cmbLeaveList.Text = '' then
  begin
    Box('您没有选择请假类型!');
    cmbLeaveList.SetFocus;
    exit;
  end;


  if length(memoLog.Text) > 200 then
  begin
    Box('备注信息不允许超过200字!');
    memoLog.SelectAll;
    memoLog.SetFocus;
    exit;
  end;

  result := true;

end;

function TFrmAskLeave.CheckProverID(strTrainmanNumber: string): Boolean;
begin
  result := false;
  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,m_Prover) then exit;
  result := true;
end;


class function TFrmAskLeave.ShowAskLeaveForm : boolean;
var
  frmAskLeave: TFrmAskLeave;
begin
  result := false;
  frmAskLeave := TFrmAskLeave.Create(nil);
  try
    if not frmAskLeave.Init then exit;
    if frmAskLeave.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmAskLeave.Free;
  end;
end;

class function TFrmAskLeave.ShowAskLeaveFormByNumber(
  TrainmanNumber: string): Boolean;
var
  frmAskLeave: TFrmAskLeave;
begin
  result := false;
  frmAskLeave := TFrmAskLeave.Create(nil);
  try
    if not frmAskLeave.InitAskLeave(TrainmanNumber) then exit;
    if frmAskLeave.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmAskLeave.Free;
  end;
end;

procedure TFrmAskLeave.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmAskLeave.FormCreate(Sender: TObject);
begin
  m_RsLCAskLeave := TRsLCAskLeave.Create(GlobalDM.WebAPIUtils);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_RsLCNameBoardEx := TRsLCNameBoardEx.Create(GlobalDM.WebAPIUtils);
  IniColumns(edtAskerID);
  IniColumns(edtProverID);
end;

procedure TFrmAskLeave.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
  m_RsLCAskLeave.Free;
  m_RsLCNameBoardEx.Free;
end;

procedure TFrmAskLeave.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
  begin
    if GetFocus() = memoLog.Handle then
    begin
      if not (ssCtrl in Shift) then
      begin
        PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
        Key := 0;
      end;
      exit;
    end;
    
    PostMessage(Handle, WM_KEYDOWN, VK_TAB, 0);
  end;
end;

function TFrmAskLeave.Init: boolean;
var
  i: integer;
  LeaveTypeArray: TRsLeaveTypeArray;
  ErrMsg: string;
begin
  result := false;
  dtpBeginDate.Date := DateOf(Now);
  dtpBeginTime.DateTime := IncHour(DateOf(Now) ,12);

  dtpEndDate.Date := DateOf(Now) + 1;
  dtpEndTime.DateTime := IncHour(IncDay(DateOf(Now) + 1),12);

  //载入请假类型列表
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('查询请假类型列表失败:' + ErrMsg);
    exit;
  end;
  for i := 0 to length(LeaveTypeArray) - 1 do
  begin
    cmbLeaveList.Items.Add(LeaveTypeArray[i].strTypeName);
  end;
  m_LeaveTypeArray := LeaveTypeArray;
  result := true;
end;

function TFrmAskLeave.InitAskLeave(TrainmanNumber: string): boolean;
var
  i: integer;
  LeaveTypeArray: TRsLeaveTypeArray;
  ErrMsg: string;
begin
  result := false;
  edtAskerID.Text := TrainmanNumber ;



  //载入请假类型列表
  if not m_RsLCAskLeave.LCLeaveType.QueryLeaveTypes(LeaveTypeArray, ErrMsg) then
  begin
    BoxErr('查询请假类型列表失败:' + ErrMsg);
    exit;
  end;
  for i := 0 to length(LeaveTypeArray) - 1 do
  begin
    cmbLeaveList.Items.Add(LeaveTypeArray[i].strTypeName);
  end;
  m_LeaveTypeArray := LeaveTypeArray;
  result := true;
end;

procedure TFrmAskLeave.IniColumns(LookupEdit: TtfLookupEdit);
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
    
function TFrmAskLeave.GetAskerID(strAsk: string): string;
var
  intPos1, intPos2: integer;
begin
  strAsk := trim(strAsk);
  result := strAsk;
  
  intPos1 := Pos('[', strAsk);
  intPos2 := Pos(']', strAsk);
  if (intPos1 > 0) and (intPos2 > intPos1) then
    result := Copy(strAsk, intPos1+1, intPos2-intPos1-1);
end;
     
procedure TFrmAskLeave.SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
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

end.
