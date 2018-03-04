unit uFrmEditSignTrainman;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uTrainman,uGlobalDM,uTFSystem,uLCSignPlan,
  uSignPlan,uTrainmanJiaolu,uLCTrainmanMgr;

type
  TFrmEditSignTrainman = class(TForm)
    lbl1: TLabel;
    edtS_Number: TEdit;
    Label1: TLabel;
    edtD_Number: TEdit;
    mmoRemark: TMemo;
    lbl2: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    edtS_Name: TEdit;
    lbl3: TLabel;
    Label2: TLabel;
    edtD_Name: TEdit;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure edtD_NumberChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //ԭ˾��
    m_S_Trainman:RRsTrainman;
    //��˾��
    m_D_Trainman:RRsTrainman;
    //˾����Ϣ�ӿ�
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //ǩ��web�ӿڲ���
    m_webOp: TRSLCSignPlan;
    //ǩ��ƻ�
    m_SignPlan:TSignPlan;
    //˾������
    m_nTrainmanIndex:Integer;
    //���ս�·ǩ��ƻ��б�
    m_DaySignPlanJiaoLu:TDaySignPlanJiaoLu;
      //�г���·����Ӧ����Ա��·�б�
    m_TrainmanJiaoluArray: TRsTrainmanJiaoluArray ;
  private
    {����:У����������}
    function CheckInput():Boolean;
    {����:�����޸�}
    function SaveModify():Boolean;
    {����:�ж���Ա�Ƿ���ڱ��г���·ǩ��}
    function bCanWorkThisTrainJiaoLu(trainman:RRsTrainman):Boolean;

  end;

  function EditSignTrainman(DaySignPlanJiaoLu:TDaySignPlanJiaoLu; signPlan:TSignPlan; s_Trainman: RRsTrainman;nTraimanIndex:Integer):Boolean;


implementation
uses
  uLCBaseDict;

{$R *.dfm}
function EditSignTrainman(DaySignPlanJiaoLu:TDaySignPlanJiaoLu; signPlan:TSignPlan;s_Trainman: RRsTrainman;nTraimanIndex:Integer):Boolean;
var
  frm:TFrmEditSignTrainman;
begin
  result := False;
  frm:= TFrmEditSignTrainman.create(nil);
  frm.m_SignPlan.Clone(signPlan);
  frm.m_S_Trainman := s_Trainman;
  frm.m_nTrainmanIndex := nTraimanIndex;
  frm.m_DaySignPlanJiaoLu := DaySignPlanJiaoLu;
  try
    if frm.ShowModal = mrOk then
    begin
      signPlan.Clone(frm.m_SignPlan);
      result := True;
    end;
  finally
    frm.Free;
  end;
end;


function TFrmEditSignTrainman.bCanWorkThisTrainJiaoLu(
  trainman: RRsTrainman): Boolean;
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

procedure TFrmEditSignTrainman.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmEditSignTrainman.btnOKClick(Sender: TObject);
begin
  if CheckInput = False  then Exit;
  if SaveModify = True then ModalResult := mrOk;
end;

function TFrmEditSignTrainman.CheckInput: Boolean;
begin
  result := False;
  {if edtD_Number.Text = '' then
  begin
    Box('��˾�����Ų���Ϊ��!');
    Exit;
  end;}
  if mmoRemark.Text ='' then
  begin
    Box('����ԭ����Ϊ��!');
    Exit;
  end;
  if m_SignPlan.FindTrainmanIndex(Trim(m_D_Trainman.strTrainmanGUID)) <> -1 then
  begin
    Box('ͬһǩ��ƻ���˾�������ظ�');
    Exit;
  end;
  if m_D_Trainman.strTrainmanGUID <> '' then
  begin
    if bCanWorkThisTrainJiaoLu(m_D_Trainman) = False then
    begin
      Box('��Ա����ִ�˴��г���·!');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TFrmEditSignTrainman.edtD_NumberChange(Sender: TObject);

begin
  if Trim(edtD_Number.Text) <>''  then
  begin
    if m_RsLCTrainmanMgr.GetTrainmanByNumber(Trim(edtD_Number.Text),m_D_Trainman) = True then
    begin
      edtD_Name.Text := m_D_Trainman.strTrainmanName;
    end;
  end
  else
  begin
    edtD_Name.Text := '';
    ZeroMemory(@m_D_Trainman,SizeOf(m_D_Trainman));
  end;
end;


procedure TFrmEditSignTrainman.FormCreate(Sender: TObject);
begin
  m_RsLCTrainmanMgr :=TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_WebOP:=TRSLCSignPlan.Create(GlobalDM.GetWebUrl,
  GlobalDM.SiteInfo.strSiteIP,GlobalDM.SiteInfo.strSiteGUID);
  m_SignPlan:=TSignPlan.create;
end;

procedure TFrmEditSignTrainman.FormDestroy(Sender: TObject);
begin
   m_RsLCTrainmanMgr.Free;
   m_WebOP.Free;
   m_SignPlan.Free;
end;

procedure TFrmEditSignTrainman.FormShow(Sender: TObject);
begin
  edtS_Number.Text := m_S_Trainman.strTrainmanNumber;
  edtS_Name.Text := m_S_Trainman.strTrainmanName;

  RsLCBaseDict.SetConnConfig(GlobalDM.HttpConnConfig);

  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual(GlobalDM.SiteInfo.strSiteGUID, m_SignPlan.strTrainJiaoLuGUID,
    m_TrainmanJiaoluArray);
end;

function TFrmEditSignTrainman.SaveModify: Boolean;
var
  signModifyTrainman: TSignModifyTrainman ;
  strErrMsg:string;
  nIndex:Integer;
begin

  Result := False;
  signModifyTrainman:= TSignModifyTrainman.Create;
  signModifyTrainman.strSignPlanGUID := m_SignPlan.strGUID;
  signModifyTrainman.strSouceTMGUID := m_S_Trainman.strTrainmanGUID;
  signModifyTrainman.strDestTMGUID := m_D_Trainman.strTrainmanGUID;
  signModifyTrainman.strReason := Trim(mmoRemark.Text);
  signModifyTrainman.dtModifyTime := GlobalDM.GetNow();
  signModifyTrainman.nIndex := m_nTrainmanIndex;

  if m_DaySignPlanJiaoLu.SignPlanList.FindPlanByTM(signModifyTrainman.strDestTMGUID,nIndex) <> nil then
  begin
    Box('˾�����ܶ��ǩ��');
    Exit;
  end;
  
  
  m_SignPlan.ModifyTrainman(m_nTrainmanIndex,m_D_Trainman);
  signModifyTrainman.strWorkGroupGUID := m_SignPlan.strWorkGrouGUID;
  signModifyTrainman.ePlanState := m_SignPlan.eState;
  try
    if m_webOp.ModifyTrainman(signModifyTrainman,strErrMsg) = True then
    begin
      Result := True;;
    end
    else
    begin
      Box('�޸ĳ���Աʧ��,ԭ��:' + strErrMsg);
    end;
  finally
    signModifyTrainman.Free;
  end;

end;

end.
