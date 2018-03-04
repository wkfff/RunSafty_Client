unit uFrmKeyTrainmanEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzDTP, utfLookupEdit,
  uTrainman,uTFSystem,uLCTrainmanMgr,uGlobalDM,utfPopTypes,
  uLCTeamGuide,uGuideSign, RzCmboBx,uLCBaseDict,uWorkShop,uLCKeyMan, ExtCtrls,
  DateUtils, RzBorder;

type

  TFrmKeyTrainmanEdit = class(TForm)
    lbl1: TLabel;
    edtKeyTrainman: TtfLookupEdit;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    edtRegister: TtfLookupEdit;
    btnConfig: TButton;
    btnCancel: TButton;
    dtpStart: TRzDateTimePicker;
    lbl6: TLabel;
    lbl7: TLabel;
    dtpEnd: TRzDateTimePicker;
    mmoReason: TMemo;
    mmoAnnouncements: TMemo;
    Bevel1: TBevel;
    Label1: TLabel;
    cbbCheDui: TRzComboBox;
    RzBorder1: TRzBorder;
    RzBorder2: TRzBorder;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtKeyTrainmanChange(Sender: TObject);
    procedure edtKeyTrainmanExit(Sender: TObject);
    procedure edtKeyTrainmanSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtRegisterChange(Sender: TObject);
    procedure edtRegisterExit(Sender: TObject);
    procedure edtRegisterSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtRegisterNextPage(Sender: TObject);
    procedure edtRegisterPrevPage(Sender: TObject);
    procedure edtKeyTrainmanNextPage(Sender: TObject);
    procedure edtKeyTrainmanPrevPage(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //操作类型
    m_eOpt:EKeyTrainmanOpt;
    //原纪录
    m_S_KeyMan:TKeyTrainman;
    //新纪录
    m_d_KeyMan:TKeyTrainman;
    //关键人
    m_trainman_key:RRSTrainman;
    //登记人
    m_trainman_Reg:RRsTrainman;
    //人员管理IF
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //关键人Db
    m_LCKeyMan: TRsLCKeyMan;
    //车队接口
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //车队数组
    m_GuideGroupArray : TRsSimpleInfoArray;
    m_WorkShopArray: TRsWorkShopArray;
  private
    //显示原数据
    procedure ShowSData();
    //校验数据
    function CheckData():Boolean;
    //保存数据
    procedure FillData();
    //解析工号
    function GetTrainmanID(strNameNumber :string): string;
    //获取人员信息
    function CheckTrainman(strTrainmanNumber:string;var trainman:RRSTrainman):Boolean;
    //设置下拉列表
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
        //初始司机选择下拉框
    procedure IniColumns(LookupEdit : TtfLookupEdit);
        //初始化指导对
    procedure InitCheDui();
    procedure InitWorkShop();
    function GetWorkShopName(WorKShopID: string): string;
  public
    //增加关键人
    class function Add(keyTrainman:TKeyTrainman):Boolean;
    //修改关键人
    class function Modity(keyTrainman:TKeyTrainman):Boolean;
    //注销关键人
    class function Cancel(keyTrainman:TKeyTrainman):Boolean;
  end;

implementation

{$R *.dfm}

{ TFrmKeyTrainmanEdit }

class function TFrmKeyTrainmanEdit.Add(keyTrainman: TKeyTrainman): Boolean;
var
  Frm: TFrmKeyTrainmanEdit;
begin
  result := False;
  Frm:= TFrmKeyTrainmanEdit.create(nil);
  try
    Frm.m_eOpt := KTMAdd;
    if Frm.ShowModal = mrOk then
      result := true;
  finally
    Frm.free;
  end;

end;

procedure TFrmKeyTrainmanEdit.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmKeyTrainmanEdit.btnConfigClick(Sender: TObject);
begin
  if Self.CheckData = false then Exit;
  self.FillData;
  case self.m_eOpt of
    KTMAdd:
      m_LCKeyMan.Add(m_d_KeyMan);
    KTMModify:
      m_LCKeyMan.Update(m_d_KeyMan);
    KTMdel:
      m_LCKeyMan.Del(m_d_KeyMan);
  end;
  self.ModalResult := mrOk;
end;

class function TFrmKeyTrainmanEdit.Cancel(keyTrainman: TKeyTrainman): Boolean;
var
  Frm: TFrmKeyTrainmanEdit;
begin
  result := False;
  Frm:= TFrmKeyTrainmanEdit.create(nil);
  try
    Frm.m_eOpt := KTMDel;
    Frm.m_S_KeyMan.clone(keyTrainman);
    if Frm.ShowModal = mrOk then
      result := true;
  finally
    Frm.free;
  end;
end;

function TFrmKeyTrainmanEdit.CheckData: Boolean;
begin
  result := False;
  if Trim(edtKeyTrainman.Text) = '' then
  begin
    Box('关键人不能为空!');
    edtKeyTrainman.SetFocus;
    Exit;
  end;


  if cbbCheDui.ItemIndex < 0 then
  begin
    Box('车队不能为空!');
    cbbCheDui.SetFocus;
    Exit;
  end;

  result := true;


end;

procedure TFrmKeyTrainmanEdit.edtKeyTrainmanChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtKeyTrainman do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtKeyTrainman, TrainmanArray);
  end;
end;

function TFrmKeyTrainmanEdit.GetTrainmanID(strNameNumber: string): string;
var
  intPos1, intPos2: integer;
begin
  strNameNumber := trim(strNameNumber);
  result := strNameNumber;
  
  intPos1 := Pos('[', strNameNumber);
  intPos2 := Pos(']', strNameNumber);
  if (intPos1 > 0) and (intPos2 > intPos1) then
    result := Copy(strNameNumber, intPos1+1, intPos2-intPos1-1);
end;

function TFrmKeyTrainmanEdit.GetWorkShopName(WorKShopID: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Length(m_WorkShopArray) - 1 do
  begin
    if m_WorkShopArray[i].strWorkShopGUID = WorKShopID then
    begin
      Result := m_WorkShopArray[i].strWorkShopName;
      break;
    end;
  end;
end;

procedure TFrmKeyTrainmanEdit.IniColumns(LookupEdit: TtfLookupEdit);
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

procedure TFrmKeyTrainmanEdit.InitCheDui;
var
  i:Integer;
begin
  m_RsLCGuideGroup.GetGroupArray(GlobalDM.SiteInfo.WorkShopGUID, m_GuideGroupArray);
  cbbCheDui.Items.Clear;
  cbbCheDui.Values.Clear;
  for i := 0 to length(m_GuideGroupArray) - 1 do
  begin
    cbbCheDui.AddItemValue(m_GuideGroupArray[i].strName, m_GuideGroupArray[i].strGUID);
  end;
  cbbCheDui.ItemIndex := 0;
end;


procedure TFrmKeyTrainmanEdit.InitWorkShop;
var
  Error: string;
begin
  RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(GlobalDM.SiteInfo.strAreaGUID,m_WorkShopArray,Error)
end;

procedure TFrmKeyTrainmanEdit.edtKeyTrainmanExit(Sender: TObject);
begin
  if trim(edtKeyTrainman.Text) = '' then exit;

  if not CheckTrainman(GetTrainmanID(edtKeyTrainman.Text),self.m_trainman_key) then
  begin
    Box('您输入的关键人工号不正确!');
    edtKeyTrainman.SelectAll;
    edtKeyTrainman.SetFocus;
    exit;
  end;

end;
procedure TFrmKeyTrainmanEdit.edtKeyTrainmanNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  //if edtAskerID.PopStyle.PageIndex >= edtAskerID.PopStyle.PageCount then exit;
  with edtKeyTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtKeyTrainman, TrainmanArray);
  end;
end;

procedure TFrmKeyTrainmanEdit.edtKeyTrainmanPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtKeyTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtKeyTrainman, TrainmanArray);
  end;
end;

function TFrmKeyTrainmanEdit.CheckTrainman(strTrainmanNumber:string;var trainman:RRSTrainman):Boolean;
begin
  result := false;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman) then exit;
  result := true;
end;
  
procedure TFrmKeyTrainmanEdit.edtKeyTrainmanSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtKeyTrainman.OnChange := nil;
  try
   edtKeyTrainman.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);

  finally
    edtKeyTrainman.OnChange := edtKeyTrainmanChange;
  end;
end;

procedure TFrmKeyTrainmanEdit.FormCreate(Sender: TObject);
begin
  m_S_KeyMan := TKeyTrainman.Create;
  m_d_KeyMan := TKeyTrainman.Create;

  IniColumns(edtKeyTrainman);
  IniColumns(edtRegister);

  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);

  m_LCKeyMan := TRsLCKeyMan.Create(GlobalDM.WebAPIUtils);
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);

end;

procedure TFrmKeyTrainmanEdit.edtRegisterChange(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtRegister do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtRegister, TrainmanArray);
  end;
end;

procedure TFrmKeyTrainmanEdit.edtRegisterExit(Sender: TObject);
begin 
  if trim(edtRegister.Text) = '' then exit;

  if not CheckTrainman(GetTrainmanID(edtRegister.Text),self.m_trainman_Reg) then
  begin
    Box('您输入的登记人工号不正确!');
    edtRegister.SelectAll;
    edtRegister.SetFocus;
    exit;
  end;
end;

procedure TFrmKeyTrainmanEdit.edtRegisterNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  //if edtAskerID.PopStyle.PageIndex >= edtAskerID.PopStyle.PageCount then exit;
  with edtRegister do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtRegister, TrainmanArray);
  end;
end;

procedure TFrmKeyTrainmanEdit.edtRegisterPrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtRegister do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtRegister, TrainmanArray);
  end;
end;

procedure TFrmKeyTrainmanEdit.edtRegisterSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtRegister.OnChange := nil;
  try
    edtRegister.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtRegister.OnChange := edtKeyTrainmanChange;
  end;
end;

procedure TFrmKeyTrainmanEdit.FormDestroy(Sender: TObject);
begin
  m_S_KeyMan.Free;
  m_d_KeyMan.Free;
  m_LCKeyMan.Free;
  m_RsLCGuideGroup.Free;
end;

procedure TFrmKeyTrainmanEdit.FormShow(Sender: TObject);
begin
  edtKeyTrainman.OnChange := nil;
  edtRegister.OnChange := nil;
  InitWorkShop();
  InitCheDui();
  self.ShowSData();

  edtKeyTrainman.OnChange := edtKeyTrainmanChange;
  edtKeyTrainman.IsAutoPopup := true;
  edtRegister.OnChange := edtRegisterChange;
  edtRegister.IsAutoPopup := true;
end;

class function TFrmKeyTrainmanEdit.Modity(keyTrainman: TKeyTrainman): Boolean;
var
  Frm: TFrmKeyTrainmanEdit;
begin
  result := False;
  Frm:= TFrmKeyTrainmanEdit.create(nil);
  try
    Frm.m_eOpt := KTMModify;
    Frm.m_S_KeyMan.clone(keyTrainman);
    if Frm.ShowModal = mrOk then
      result := true;
  finally
    Frm.free;
  end;
end;

procedure TFrmKeyTrainmanEdit.FillData;
begin
  m_d_KeyMan.Clone(m_S_KeyMan);
  m_d_KeyMan.KeyTMNumber := self.m_trainman_key.strTrainmanNumber;
  m_d_KeyMan.KeyTMName := self.m_trainman_key.strTrainmanName;

  m_d_KeyMan.RegisterNumber := self.m_trainman_Reg.strTrainmanNumber;
  m_d_KeyMan.RegisterName := self.m_trainman_Reg.strTrainmanName;

  m_d_KeyMan.ClientNumber := GlobalDM.SiteInfo.strSiteIP;
  m_d_KeyMan.ClientName := GlobalDM.SiteInfo.strSiteName;


  m_d_KeyMan.KeyTMWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  m_d_KeyMan.KeyTMWorkShopName := GetWorkShopName(GlobalDM.SiteInfo.WorkShopGUID);
  m_d_KeyMan.KeyTMCheDuiGUID := cbbCheDui.Values[cbbCheDui.ItemIndex];
  m_d_KeyMan.KeyTMCheDuiName := cbbCheDui.Text;

  m_d_KeyMan.RegisterTime := GlobalDM.GetNow;
  m_d_KeyMan.KeyStartTime := dtpStart.DateTime;
  m_d_KeyMan.KeyEndTime := dtpEnd.DateTime;
  m_d_KeyMan.KeyReason := mmoReason.Text;
  m_d_KeyMan.KeyAnnouncements := mmoAnnouncements.Text;
  if m_d_KeyMan.ID = '' then
     m_d_KeyMan.ID := NewGUID;

end;

procedure TFrmKeyTrainmanEdit.SetPopupData(LookupEdit: TtfLookupEdit;
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

procedure TFrmKeyTrainmanEdit.ShowSData;
var
  dtNow: TDateTime;
begin
  if self.m_S_KeyMan.ID ='' then
  begin
    dtNow := GlobalDM.GetNow();
    dtpStart.DateTime := StartOfTheMonth(dtNow);
    dtpEnd.DateTime := EndOfTheMonth(dtNow);
    Exit;
  end;
  with m_S_KeyMan do
  begin
    edtKeyTrainman.Text := Format('%s[%s]',[KeyTMName,KeyTMNumber]);
    edtRegister.Text := Format('%s[%s]',[RegisterName,RegisterNumber]);
    self.m_trainman_key.strTrainmanNumber := KeyTMNumber;
    self.m_trainman_key.strTrainmanName := KeyTMName;
    self.m_trainman_Reg.strTrainmanNumber := RegisterNumber;
    self.m_trainman_Reg.strTrainmanName := RegisterName;

    dtpStart.DateTime := KeyStartTime;
    dtpEnd.DateTime := KeyEndTime;
    mmoReason.Text := KeyReason;
    mmoAnnouncements.Text := KeyAnnouncements;
    mmoAnnouncements.SetFocus;

    cbbCheDui.ItemIndex := cbbCheDui.Values.IndexOf(KeyTMCheDuiGUID);

  end;

  Self.Caption := '增加关键人' ;
  if Self.m_eOpt = KTMModify then
  begin
    self.Caption := '修改关键人';
    edtKeyTrainman.Enabled := false;
  end;
  if Self.m_eOpt = KTMdel then
  begin
    self.Caption:= '撤销关键人';
    edtKeyTrainman.Enabled := false;
    dtpStart.Enabled := false;
    dtpEnd.Enabled := false;
    mmoAnnouncements.Enabled := false;
  end;
  
end;

end.
