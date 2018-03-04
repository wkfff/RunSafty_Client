unit uFrmAddXY;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, uTrainman,  ExtCtrls, DB, ADODB,
   StdCtrls, utfLookupEdit,utfPopTypes,uSaftyEnum,uLCTrainmanMgr;

type
  TFrmAddXY = class(TForm)
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    Label1: TLabel;
    edtTrainman1: TtfLookupEdit;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtTrainman1Change(Sender: TObject);
    procedure edtTrainman1Selected(SelectedItem: TtfPopupItem;
      SelectedIndex: Integer);
    procedure edtTrainman1NextPage(Sender: TObject);
    procedure edtTrainman1PrevPage(Sender: TObject);
  private
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    UserInfo: RRsTrainman;
    m_strWorkShopGUID : string;
    procedure IniColumns(LookupEdit : TtfLookupEdit);
    //设置弹出下拉框数据
    procedure SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
  public
    class function InputTrainman(WorkShopGUID : string;out Trainman : RRsTrainman) : boolean;
  end;

implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TFrmAddXY }

procedure TFrmAddXY.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrcancel;
end;

procedure TFrmAddXY.btnOkClick(Sender: TObject);
begin
  if UserInfo.strTrainmanGUID = '' then
  begin
    Application.MessageBox(PChar('请选择人员'),'提示',MB_OK+MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmAddXY.edtTrainman1Change(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
  nCount: Integer;
begin
  with edtTrainman1 do
  begin
    PopStyle.PageIndex := 1;
    nCount := m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    PopStyle.PageCount := nCount div PopStyle.MaxViewCol;
    if nCount mod PopStyle.MaxViewCol > 0 then PopStyle.PageCount := PopStyle.PageCount + 1;
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddXY.edtTrainman1NextPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtTrainman1 do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex + 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddXY.edtTrainman1PrevPage(Sender: TObject);
var
  TrainmanArray : TRsTrainmanArray;
begin
  with edtTrainman1 do
  begin
    PopStyle.PageIndex := PopStyle.PageIndex - 1;
    m_RsLCTrainmanMgr.GetPopupTrainmans(GlobalDM.SiteInfo.WorkShopGUID, Text, PopStyle.PageIndex, TrainmanArray);
    SetPopupData(edtTrainman1, TrainmanArray);
  end;
end;

procedure TFrmAddXY.edtTrainman1Selected(SelectedItem: TtfPopupItem;
  SelectedIndex: Integer);
begin
  edtTrainman1.OnChange := nil;
  try
   UserInfo.strTrainmanGUID := SelectedItem.StringValue;
   edtTrainman1.Text := Format('%s[%s]',[SelectedItem.SubItems[2],SelectedItem.SubItems[1]]);
  finally
    edtTrainman1.OnChange := edtTrainman1Change;
  end;
end;

procedure TFrmAddXY.FormCreate(Sender: TObject);
begin
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  IniColumns(edtTrainman1);
end;

procedure TFrmAddXY.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TFrmAddXY.IniColumns(LookupEdit: TtfLookupEdit);
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

class function TFrmAddXY.InputTrainman(WorkShopGUID : string;
  out Trainman: RRsTrainman): boolean;
var
  FrmAddXY : TFrmAddXY; 
begin
  result := false;
  FrmAddXY := TFrmAddXY.Create(nil);
  try
    FrmAddXY.m_strWorkShopGUID := WorkShopGUID;
    if FrmAddXY.ShowModal = mrCancel then exit;
    Trainman := FrmAddXY.UserInfo;
    result := true;
  finally
    FrmAddXY.Free;
  end;
end;

procedure TFrmAddXY.SetPopupData(LookupEdit: TtfLookupEdit; TrainmanArray : TRsTrainmanArray);
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
