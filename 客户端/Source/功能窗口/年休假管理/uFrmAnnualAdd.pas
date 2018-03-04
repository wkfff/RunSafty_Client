unit uFrmAnnualAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzDTP, utfLookupEdit,
  uTrainman,uTFSystem,uLCTrainmanMgr,uGlobalDM,utfPopTypes,
  uLCTeamGuide,uGuideSign, RzCmboBx,uLCBaseDict,uWorkShop,uLCKeyMan, ExtCtrls,
  DateUtils,uLCAnnualLeave, Spin;

type

  TFrmAnnualAdd = class(TForm)
    lbl1: TLabel;
    edtKeyTrainman: TtfLookupEdit;
    btnConfig: TButton;
    btnCancel: TButton;
    Bevel1: TBevel;
    cbbMonth: TRzComboBox;
    cbbYear: TRzComboBox;
    Label1: TLabel;
    edtNeedDays: TSpinEdit;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure edtKeyTrainmanChange(Sender: TObject);
    procedure edtKeyTrainmanExit(Sender: TObject);
    procedure edtKeyTrainmanSelected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtKeyTrainmanNextPage(Sender: TObject);
    procedure edtKeyTrainmanPrevPage(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //人员管理IF
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_trainman: RRsTrainman;
    m_AnnualLeave: TAnnualLeave;
    procedure Init();
  private
    //校验数据
    function CheckData():Boolean;
    //解析工号
    function GetTrainmanID(strNameNumber :string): string;
    //获取人员信息
    function CheckTrainman(strTrainmanNumber:string;var trainman:RRSTrainman):Boolean;
    //设置下拉列表
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
        //初始司机选择下拉框
    procedure IniColumns(LookupEdit : TtfLookupEdit);
  
  public
    //增加年休假记录
    class function Add(AnnualLeave: TAnnualLeave):Boolean;
  end;

implementation

{$R *.dfm}

{ TFrmAnnualAdd }

class function TFrmAnnualAdd.Add(AnnualLeave: TAnnualLeave): Boolean;
var
  Frm: TFrmAnnualAdd;
begin
  result := False;
  Frm:= TFrmAnnualAdd.create(nil);
  try
    Frm.m_AnnualLeave := AnnualLeave;
    if Frm.ShowModal = mrOk then
      result := true;
  finally
    Frm.free;
  end;

end;

procedure TFrmAnnualAdd.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmAnnualAdd.btnConfigClick(Sender: TObject);
begin
  if Self.CheckData = false then Exit;

  m_AnnualLeave.TrainmanNumber:= m_trainman.strTrainmanNumber;
  m_AnnualLeave.TrainmanName:= m_trainman.strTrainmanName;
  m_AnnualLeave.Year:= strToInt(cbbYear.Text);
  m_AnnualLeave.Month:= cbbMonth.ItemIndex + 1;
  m_AnnualLeave.NeedDays := edtNeedDays.Value;
  
  self.ModalResult := mrOk;
end;



function TFrmAnnualAdd.CheckData: Boolean;
begin
  result := False;
  if Trim(edtKeyTrainman.Text) = '' then
  begin
    Box('人员不能为空!');
    edtKeyTrainman.SetFocus;
    Exit;
  end;




  result := true;


end;

procedure TFrmAnnualAdd.edtKeyTrainmanChange(Sender: TObject);
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

function TFrmAnnualAdd.GetTrainmanID(strNameNumber: string): string;
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


procedure TFrmAnnualAdd.IniColumns(LookupEdit: TtfLookupEdit);
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



procedure TFrmAnnualAdd.Init;
var
  I: Integer;
begin
  cbbYear.Clear();

  for I := YearOf(Now) - 3 to YearOf(Now) do
  begin
    cbbYear.Add(IntToStr(i));
  end;

  cbbYear.ItemIndex := cbbYear.Items.IndexOf(IntToStr(YearOf(Now)));

  cbbMonth.Clear();
  for I := 1 to 12 do
  begin
    cbbMonth.Add(IntToStr(i));
  end;


  cbbMonth.ItemIndex := MonthOf(Now) - 1;
end;

procedure TFrmAnnualAdd.edtKeyTrainmanExit(Sender: TObject);
begin
  if trim(edtKeyTrainman.Text) = '' then exit;

  if not CheckTrainman(GetTrainmanID(edtKeyTrainman.Text),self.m_trainman) then
  begin
    Box('您输入的人员工号不正确!');
    edtKeyTrainman.SelectAll;
    edtKeyTrainman.SetFocus;
    exit;
  end;

end;
procedure TFrmAnnualAdd.edtKeyTrainmanNextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtKeyTrainman do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtKeyTrainman, TrainmanArray);
  end;
end;

procedure TFrmAnnualAdd.edtKeyTrainmanPrevPage(Sender: TObject);
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

function TFrmAnnualAdd.CheckTrainman(strTrainmanNumber:string;var trainman:RRSTrainman):Boolean;
begin
  result := false;

  if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strTrainmanNumber,trainman) then exit;
  result := true;
end;
  
procedure TFrmAnnualAdd.edtKeyTrainmanSelected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtKeyTrainman.OnChange := nil;
  try
   edtKeyTrainman.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);

  finally
    edtKeyTrainman.OnChange := edtKeyTrainmanChange;
  end;
end;

procedure TFrmAnnualAdd.FormCreate(Sender: TObject);
begin
  IniColumns(edtKeyTrainman);

  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmAnnualAdd.FormShow(Sender: TObject);
begin
  edtKeyTrainman.OnChange := nil;

  edtKeyTrainman.OnChange := edtKeyTrainmanChange;
  edtKeyTrainman.IsAutoPopup := true;
  Init();
end;

procedure TFrmAnnualAdd.SetPopupData(LookupEdit: TtfLookupEdit;
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


end.
