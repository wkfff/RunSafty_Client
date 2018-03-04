unit uFrmFixedGroupView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uFixedGroup,uGlobalDM,uDBFixedGroup;

type
  TFrmFixedGroupView = class(TForm)
    lbl7: TLabel;
    lbl6: TLabel;
    lbl1: TLabel;
    lbl2: TLabel;
    edtGroupIndex: TEdit;
    edtGroupName: TEdit;
    btnOK: TButton;
    edtWorkShop: TEdit;
    edtCheDui: TEdit;
    lbl3: TLabel;
    edtTrainman1: TEdit;
    lbl4: TLabel;
    edtTrainman2: TEdit;
    lbl5: TLabel;
    edtTrainman3: TEdit;
    lbl8: TLabel;
    edtTrainman4: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //工号
    m_strTrainmanNumber:string;
    //固定班数据库操作
    m_dbFixedGroup:TDBFixedGroup;
    //固定班
    m_fixedGroup:TFixedGroup;
    //固定班列表
    m_FixedGroupList:TFixedGroupList;
  private
    //显示数据
    procedure ShowData();
  public
    class procedure View(strTrainmanNumber:string);
  end;


implementation

{$R *.dfm}

procedure TFrmFixedGroupView.FormCreate(Sender: TObject);
begin
  m_fixedGroup:=TFixedGroup.Create;
  m_FixedGroupList:=TFixedGroupList.Create;
  globalDM.ConnectLocal_SQLDB();
  m_dbFixedGroup:=TDBFixedGroup.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmFixedGroupView.FormDestroy(Sender: TObject);
begin
  m_fixedGroup.Free;
  m_dbFixedGroup.Free;
  m_FixedGroupList.Free;
end;

procedure TFrmFixedGroupView.FormShow(Sender: TObject);
var
  qc:RDBFixedGroup_QC;
begin
  m_FixedGroupList.Clear;
  System.FillChar(qc,SizeOf(RDBFixedGroup_QC),0);
  qc.strTMNumber := m_strTrainmanNumber;
  m_dbFixedGroup.Query(qc,m_FixedGroupList);
  if m_FixedGroupList.Count > 0 then
    m_fixedGroup := m_FixedGroupList.Items[0];
  ShowData();
end;

procedure TFrmFixedGroupView.ShowData;
begin
  edtWorkShop.Text := m_fixedGroup.rFixedGroup.strWorkShopName;
  edtCheDui.Text := m_fixedGroup.rFixedGroup.strCheDuiName;
  edtGroupIndex.Text := IntToStr(m_fixedGroup.rFixedGroup.nGroupIndex);
  edtGroupName.Text := m_fixedGroup.rFixedGroup.strGroupName;
  if m_fixedGroup.trainman1.strTrainmanNumber <> '' then
  begin
    edtTrainman1.Text := Format('%s[%s]',[m_fixedGroup.trainman1.strTrainmanNumber,m_fixedGroup.trainman1.strTrainmanName]);
  end;
  if m_fixedGroup.trainman2.strTrainmanNumber <> '' then
  begin
    edtTrainman2.Text := Format('%s[%s]',[m_fixedGroup.trainman2.strTrainmanNumber,m_fixedGroup.trainman2.strTrainmanName]);
  end;
  if m_fixedGroup.trainman3.strTrainmanNumber <> '' then
  begin
    edtTrainman3.Text := Format('%s[%s]',[m_fixedGroup.trainman3.strTrainmanNumber,m_fixedGroup.trainman3.strTrainmanName]);
  end;
  if m_fixedGroup.trainman4.strTrainmanNumber <> '' then
  begin
    edtTrainman4.Text := Format('%s[%s]',[m_fixedGroup.trainman4.strTrainmanNumber,m_fixedGroup.trainman4.strTrainmanName]);
  end;
end;

class procedure TFrmFixedGroupView.View(strTrainmanNumber: string);
var
  frm:TFrmFixedGroupView;
begin
  frm := TFrmFixedGroupView.Create(nil);
  try
    frm.m_strTrainmanNumber:= strTrainmanNumber;
    frm.ShowModal;
  finally
    frm.Free;
  end;
end;

end.
