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
    //原司机
    m_S_Trainman:RRsTrainman;
    //新司机
    m_D_Trainman:RRsTrainman;
    //司机信息接口
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //签点web接口操作
    m_webOp: TRSLCSignPlan;
    //签点计划
    m_SignPlan:TSignPlan;
    //司机索引
    m_nTrainmanIndex:Integer;
    //单日交路签点计划列表
    m_DaySignPlanJiaoLu:TDaySignPlanJiaoLu;
      //行车交路所对应的人员交路列表
    m_TrainmanJiaoluArray: TRsTrainmanJiaoluArray ;
  private
    {功能:校验输入数据}
    function CheckInput():Boolean;
    {功能:保存修改}
    function SaveModify():Boolean;
    {功能:判断人员是否可在本行车交路签点}
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
    Box('新司机工号不能为空!');
    Exit;
  end;}
  if mmoRemark.Text ='' then
  begin
    Box('调整原因不能为空!');
    Exit;
  end;
  if m_SignPlan.FindTrainmanIndex(Trim(m_D_Trainman.strTrainmanGUID)) <> -1 then
  begin
    Box('同一签点计划内司机不能重复');
    Exit;
  end;
  if m_D_Trainman.strTrainmanGUID <> '' then
  begin
    if bCanWorkThisTrainJiaoLu(m_D_Trainman) = False then
    begin
      Box('人员不可执乘此行车交路!');
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
    Box('司机不能多次签点');
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
      Box('修改乘务员失败,原因:' + strErrMsg);
    end;
  finally
    signModifyTrainman.Free;
  end;

end;

end.
