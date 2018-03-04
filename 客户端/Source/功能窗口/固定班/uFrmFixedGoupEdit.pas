unit uFrmFixedGoupEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uDBFixedGroup,uFixedGroup,uLCTeamGuide,uGuideSign,
  uWorkShop,uGlobalDM,uLCBaseDict,uTFSystem;


type
  //�༭����
  TFrmFixedGoupEditType = (FixedGroupAdd{����},FixedGroupModfy{�޸�});

  TFrmFixedGroupEdit = class(TForm)
    lbl7: TLabel;
    cbbWorkShop: TRzComboBox;
    lbl6: TLabel;
    cbbCheDui: TRzComboBox;
    lbl1: TLabel;
    lbl2: TLabel;
    edtGroupIndex: TEdit;
    edtGroupName: TEdit;
    btnOK: TButton;
    btnCancel: TButton;
    procedure FormShow(Sender: TObject);
    procedure cbbWorkShopChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    //��������
    m_EditType: TFrmFixedGoupEditType;
    //�̶������ݿ����
    m_dbFixedGroup:TDBFixedGroup;
    //�̶���
    m_fixedGroup:TFixedGroup;
    //���ӽӿ�
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //��������
    m_GuideGroupArray : TRsSimpleInfoArray;
    //��������
    m_WorkShopArray:TRsWorkShopArray;
  private
        //��ʼ��ָ����
    procedure InitCheDui();
    //��ʼ������
    procedure InitWorkShop();
    //��ʾ����
    procedure ShowData();
    //У������
    function CheckData():Boolean;
    //�Ѽ�����
    procedure GetData();
  public
    //�༭
    class function Add(var group:TFixedGroup):Boolean;
    //�޸�
    class function Modify(var group:TFixedGroup):Boolean;
  end;


implementation

{$R *.dfm}

{ TFrmFixedGoupEdit }

class function TFrmFixedGroupEdit.Add(var group:TFixedGroup): Boolean;
var
  frm: TFrmFixedGroupEdit;
begin
  result := False;
  frm:= TFrmFixedGroupEdit.Create(nil);
  try
    frm.m_EditType := FixedGroupAdd;
    frm.m_fixedGroup.rFixedGroup.strGroupGUID := NewGUID;
    if frm.ShowModal = mrOk then
    begin
      result := true;
      group.Clone(frm.m_fixedGroup);
    end;
  finally
    frm.Free;
  end;
end;

class function TFrmFixedGroupEdit.Modify(var group:TFixedGroup): Boolean;
var
  frm: TFrmFixedGroupEdit;
begin
  result := False;
  frm:= TFrmFixedGroupEdit.Create(nil);
  try
    frm.m_EditType := FixedGroupModfy;
    frm.m_fixedGroup.Clone(group);
    if frm.ShowModal = mrOk then
      result := true;
  finally
    frm.Free;
  end;
end;

procedure TFrmFixedGroupEdit.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrCancel;
end;

procedure TFrmFixedGroupEdit.btnOKClick(Sender: TObject);
begin
  if CheckData = false then Exit;
  GetData;

  if m_EditType = FixedGroupAdd then
  begin
    m_dbFixedGroup.AddGroup(m_fixedGroup);
  end;
  if m_EditType = FixedGroupModfy then
  begin
    m_dbFixedGroup.ModifyGroup(m_fixedGroup);
  end;
  self.ModalResult := mrOk;
end;

procedure TFrmFixedGroupEdit.cbbWorkShopChange(Sender: TObject);
begin
  InitCheDui;
end;

function TFrmFixedGroupEdit.CheckData: Boolean;
begin
  result := False;
  if cbbWorkShop.Text = '' then
  begin
    Box('��ѡ�񳵼�');
    cbbWorkShop.SetFocus;
    Exit;
  end;
  if cbbCheDui.Text = '' then
  begin
    Box('��ѡ�񳵶�');
    cbbCheDui.SetFocus;
    Exit;
  end;

  if edtGroupIndex.Text = '' then
  begin
    Box('������������');
    edtGroupIndex.SetFocus;
    Exit;
  end;

  if edtGroupName.Text = '' then
  begin
    Box('������������');
    edtGroupName.SetFocus;
    Exit;
  end;
  result := True;

end;

procedure TFrmFixedGroupEdit.ShowData;
begin
  edtGroupIndex.Text := IntToStr(m_fixedGroup.rFixedGroup.nGroupIndex);
  edtGroupName.Text := m_fixedGroup.rFixedGroup.strGroupName;
  cbbWorkShop.ItemIndex := cbbWorkShop.Values.IndexOf(m_fixedGroup.rFixedGroup.strWorkShopGUID);
  cbbWorkShopChange(nil);
  cbbCheDui.ItemIndex := cbbCheDui.Values.IndexOf(m_fixedGroup.rFixedGroup.strCheDuiGUID);

  if m_EditType = FixedGroupAdd then
  begin
    self.Caption := '���ӹ̶�����';
  end;
  if m_EditType = FixedGroupModfy then
  begin
    self.Caption := '�޸Ĺ̶�����';
  end;

end;

procedure TFrmFixedGroupEdit.FormCreate(Sender: TObject);
begin
  m_fixedGroup:=TFixedGroup.Create;
  globalDM.ConnectLocal_SQLDB();
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
  //�̶������ݿ����
  m_dbFixedGroup:=TDBFixedGroup.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmFixedGroupEdit.FormDestroy(Sender: TObject);
begin
  m_fixedGroup.Free;
  m_RsLCGuideGroup.Free;
  m_dbFixedGroup.Free;
end;

procedure TFrmFixedGroupEdit.FormShow(Sender: TObject);
begin
  //InitCheDui();
  InitWorkShop();
  self.ShowData();
end;

procedure TFrmFixedGroupEdit.GetData;
begin
  m_fixedGroup.rFixedGroup.strWorkShopGUID := cbbWorkShop.Values[cbbWorkShop.ItemIndex];
  m_fixedGroup.rFixedGroup.strWorkShopName := cbbWorkShop.Text;
  m_fixedGroup.rFixedGroup.strCheDuiGUID := cbbCheDui.Values[cbbCheDui.ItemIndex];
  m_fixedGroup.rFixedGroup.strCheDuiName := cbbCheDui.Text;
  m_fixedGroup.rFixedGroup.nGroupIndex := StrToInt( edtGroupIndex.Text);
  m_fixedGroup.rFixedGroup.strGroupName := edtGroupName.Text;

end;

procedure TFrmFixedGroupEdit.InitCheDui;
var
  i:Integer;
  workShopGUID:string;
begin
  workShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
  if cbbWorkShop.ItemIndex > -1 then
    workShopGUID := cbbWorkShop.Values[cbbWorkShop.ItemIndex];
  m_RsLCGuideGroup.GetGroupArray(workShopGUID, m_GuideGroupArray);
  cbbCheDui.Items.Clear;
  cbbCheDui.Values.Clear;
  for i := 0 to length(m_GuideGroupArray) - 1 do
  begin
    cbbCheDui.AddItemValue(m_GuideGroupArray[i].strName, m_GuideGroupArray[i].strGUID);
  end;
  cbbCheDui.ItemIndex := 0;
end;
procedure TFrmFixedGroupEdit.InitWorkShop;
var
  strAreaGUID:string;
  i:Integer;
  Error:string;
begin
  strAreaGUID := GlobalDM.SiteInfo.strAreaGUID;
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,m_workshopArray,Error) then
  begin
    Box(Error);
  end;
  cbbWorkShop.Items.Clear;
  cbbWorkShop.Values.Clear;
  for i := 0 to length(m_workshopArray) - 1 do
  begin
    cbbWorkShop.AddItemValue(m_workshopArray[i].strWorkShopName,m_workshopArray[i].strWorkShopGUID);
  end;
  if cbbWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID) >0 then
    cbbWorkShop.ItemIndex := cbbWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID)
  else
    cbbWorkShop.ItemIndex := 0;
  cbbWorkShopChange(nil);
end;

end.
