unit uFrmSetOrg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uLCTrainmanMgr,uTrainman,uLCBaseDict,uJWD,
  uTFSystem,uTrainJiaolu,uWorkShop;

type
  TfrmSetOrg = class(TForm)
    Label4: TLabel;
    comboWorkShop: TRzComboBox;
    comboArea: TRzComboBox;
    Label7: TLabel;
    btnOK: TButton;
    btnCancel: TButton;
    comboTrainJiaolu: TRzComboBox;
    Label5: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure comboAreaChange(Sender: TObject);
    procedure comboWorkShopChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
     m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_JWDArray:TRsJWDArray;
    m_Trainman : RRsTrainman;
    //初始化机务段
    procedure InitJWD();
    //初始化车间
    procedure InitWorkShop();
    //初始化车间
    procedure InitTrainJiaoLu();
    //初始化人员
    procedure InitData(TrainmanGUID : string);

  public
    { Public declarations }
    class function ShowDialog(TrainmanGUID : string):boolean;
  end;



implementation
uses
  uGlobalDM,StrUtils;
var
  frmSetOrg: TfrmSetOrg;
{$R *.dfm}

{ TfrmSetOrg }

procedure TfrmSetOrg.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSetOrg.btnOKClick(Sender: TObject);
begin
  if not TBox('您确定要修改该乘务员所属的组织结构吗?') then exit;
  m_RsLCTrainmanMgr.UpdateTrainmanOrg(m_Trainman.strTrainmanNumber,
    comboArea.Value,comboWorkShop.Value,comboTrainJiaolu.Value,
    GlobalDM.LogUserInfo.strDutyUserGUID,GlobalDM.LogUserInfo.strDutyNumber,
    GlobalDM.LogUserInfo.strDutyUserName);
  ModalResult := mrOk;
end;

procedure TfrmSetOrg.comboAreaChange(Sender: TObject);
begin
  InitWorkShop;
end;

procedure TfrmSetOrg.comboWorkShopChange(Sender: TObject);
begin
  InitTrainJiaoLu;
end;

procedure TfrmSetOrg.FormCreate(Sender: TObject);
begin
 m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmSetOrg.FormDestroy(Sender: TObject);
begin
  m_RsLCTrainmanMgr.Free;
end;

procedure TfrmSetOrg.InitData(TrainmanGUID: string);
//功能:读取乘务员信息
begin

  if not m_RsLCTrainmanMgr.GetTrainman(TrainmanGUID,m_Trainman,3) then
  begin
    Box('没有找到指定的司机信息');
    exit;
  end;
  if comboArea.Values.IndexOf(m_Trainman.strAreaGUID) > -1 then
  begin
    comboArea.ItemIndex := comboArea.Values.IndexOf(m_Trainman.strAreaGUID);
    comboArea.OnChange(Self);
  end;

  if comboWorkShop.Values.IndexOf(m_Trainman.strWorkShopGUID) > -1 then
  begin
    comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(m_Trainman.strWorkShopGUID);
    comboWorkShop.OnChange(Self);
  end;

  
  comboTrainJiaolu.ItemIndex := comboTrainJiaolu.Values.IndexOf(m_Trainman.strTrainJiaoluGUID);

  if comboTrainJiaolu.ItemIndex = -1 then
    comboTrainJiaolu.ItemIndex := 0;
    
 
end;

procedure TfrmSetOrg.InitJWD;
var
  i:Integer;  
  strError : string;
begin
  if not (RsLCBaseDict.LCJwd.GetAllJwdList(m_JWDArray,strError)) then
  begin
    box(strError);
    exit;
  end;
  comboArea.Items.Clear;
  comboArea.Values.Clear;
  comboArea.AddItemValue('全部人员','');
  for i := 0 to length(m_JWDArray) - 1 do
  begin
    comboArea.AddItemValue(m_JWDArray[i].strName,m_JWDArray[i].strUserCode);
  end;
  comboArea.ItemIndex := comboArea.Values.IndexOf(LeftStr(GlobalDM.SiteInfo.strSiteIP,2));
end;

procedure TfrmSetOrg.InitTrainJiaoLu;
var
  trainJiaoluArray : TRsTrainJiaoluArray;
  i: Integer;
  workShopGUID : string;
begin
  comboTrainJiaolu.Items.Clear;
  comboTrainJiaolu.Values.Clear;
  comboTrainJiaolu.AddItemValue('请选择区段','');
  comboTrainJiaolu.ItemIndex := 0;

  //未选择车间就不继续初始化区段了
  if comboWorkShop.ItemIndex < 0 then exit;
  workShopGUID := comboWorkShop.Values[comboWorkShop.ItemIndex];
    
 //添加区段信息
  RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(workShopGUID,trainJiaoluArray);
  for i := 0 to length(trainJiaoluArray) - 1 do
  begin
    comboTrainJiaolu.AddItemValue(trainJiaoluArray[i].strTrainJiaoluName,
        trainJiaoluArray[i].strTrainJiaoluGUID);
  end; 
end;

procedure TfrmSetOrg.InitWorkShop;
var
  i:integer;
  workshopArray : TRsWorkShopArray;
  strAreaGUID:string;
  Error: string;
begin
  if leftStr(GlobalDM.SiteInfo.strSiteIP,2) = comboArea.Values[comboArea.ItemIndex] then
    strAreaGUID := GlobalDM.SiteInfo.strAreaGUID
  else
    strAreaGUID := comboArea.Values[comboArea.ItemIndex];
  if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(strAreaGUID,workshopArray,Error) then
  begin
    Box(Error);
  end;
  comboWorkShop.Items.Clear;
  comboWorkShop.Values.Clear;
  comboWorkShop.AddItemValue('全部车间','');
  for i := 0 to length(workshopArray) - 1 do
  begin
    comboWorkShop.AddItemValue(workshopArray[i].strWorkShopName,workshopArray[i].strWorkShopGUID);
  end;
  if comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID) >0 then
    comboWorkShop.ItemIndex := comboWorkShop.Values.IndexOf(GlobalDM.SiteInfo.WorkShopGUID)
  else
    comboWorkShop.ItemIndex := 0;

  comboWorkShopChange(nil);
end;

class function TfrmSetOrg.ShowDialog(TrainmanGUID: string): boolean;
begin
  frmSetOrg := TfrmSetOrg.Create(nil);
  try
    frmSetOrg.InitJWD;
    frmSetOrg.InitWorkShop;
    frmSetOrg.InitTrainJiaoLu;
    frmSetOrg.InitData(TrainmanGUID);
    result := false;
    if frmSetOrg.ShowModal = mrCancel then exit;
    result := true;
  finally
    frmSetOrg.Free;
  end;
end;

end.
