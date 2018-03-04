unit ufrmGanBuAdd;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Mask, RzEdit,uLCDict_GanBu, RzCmboBx,uLCTrainmanMgr,
  uTrainman,uTFSystem;

type
  TFrmGanbuAdd = class(TForm)
    edtNumber: TRzEdit;
    Label1: TLabel;
    Bevel1: TBevel;
    Label2: TLabel;
    btnOk: TButton;
    Button2: TButton;
    cbbZhiWu: TRzComboBox;
    procedure Button2Click(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure edtNumberKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    m_GanBu: TGanBu;
    m_LCTrainmanMgr: TRsLCTrainmanMgr;
    procedure SetTypelist(TypeList: TGanBuTypeList);
  public
    { Public declarations }
    class function AddGanBu(TypeList: TGanBuTypeList;GanBu: TGanBu): Boolean;
    class function EditZhiWu(TypeList: TGanBuTypeList;GanBu: TGanBu): Boolean;
  end;



implementation

uses uGlobalDM;

{$R *.dfm}

class function TFrmGanbuAdd.AddGanBu(TypeList: TGanBuTypeList;GanBu: TGanBu): Boolean;
var
  FrmGanbuAdd: TFrmGanbuAdd;
begin
  FrmGanbuAdd := TFrmGanbuAdd.Create(nil);
  try
    FrmGanbuAdd.m_GanBu := GanBu;
    FrmGanbuAdd.SetTypelist(TypeList);

    Result := FrmGanbuAdd.ShowModal = mrok;
  finally
    FrmGanbuAdd.Free;
  end;

end;

procedure TFrmGanbuAdd.btnOkClick(Sender: TObject);
var
  Trainman: RRsTrainman;
begin
  if cbbZhiWu.ItemIndex = -1 then
  begin
    Box('请选择职务!');
    Exit;
  end;

  if Caption = '添加干部' then
  begin
    if Trim(edtNumber.Text) = '' then
    begin
      Box('请输入工号!');
      Exit;
    end;



    if not m_LCTrainmanMgr.GetTrainmanByNumber(edtNumber.Text,Trainman) then
    begin
      Box(Format('工号为:%s的人员不存在!',[edtNumber.Text]));
      Exit;
    end;
  end;

  m_GanBu.TrainmanGUID := Trainman.strTrainmanGUID;
  m_GanBu.TrainmanName := Trainman.strTrainmanName;
  m_GanBu.TrainmanNumber := Trainman.strTrainmanNumber;
  m_GanBu.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  m_GanBu.TypeID := cbbZhiWu.Value;
  m_GanBu.TypeName := cbbZhiWu.Text;

  ModalResult := mrOk;
end;

procedure TFrmGanbuAdd.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

class function TFrmGanbuAdd.EditZhiWu(TypeList: TGanBuTypeList;GanBu: TGanBu): Boolean;
var
  FrmGanbuAdd: TFrmGanbuAdd;
begin
  FrmGanbuAdd := TFrmGanbuAdd.Create(nil);
  try
    FrmGanbuAdd.Caption := '修改职务';
    FrmGanbuAdd.SetTypelist(TypeList);
    FrmGanbuAdd.edtNumber.Text := GanBu.TrainmanNumber;
    FrmGanbuAdd.edtNumber.Enabled := False;
    FrmGanbuAdd.cbbZhiWu.ItemIndex := FrmGanbuAdd.cbbZhiWu.Items.IndexOf(GanBu.TypeName);
    Result := FrmGanbuAdd.ShowModal = mrOk;
  finally
    FrmGanbuAdd.Free;
  end;
end;

procedure TFrmGanbuAdd.edtNumberKeyPress(Sender: TObject; var Key: Char);
begin
  if key = #13 then
  begin
    key := #0;
    btnOk.SetFocus;
  end;
  
end;

procedure TFrmGanbuAdd.FormCreate(Sender: TObject);
begin
  m_LCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmGanbuAdd.FormDestroy(Sender: TObject);
begin
  m_LCTrainmanMgr.Free;
end;

procedure TFrmGanbuAdd.SetTypelist(TypeList: TGanBuTypeList);
var
  I: Integer;
begin
  cbbZhiWu.Clear();
  for I := 0 to TypeList.Count - 1 do
  begin
    cbbZhiWu.AddItemValue(TypeList.Items[i].TypeName,TypeList.Items[i].TypeID);
  end;
  cbbZhiWu.ItemIndex := 0;
end;

end.
