unit uFrmPBFromPrepare;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx,uTFSystem,uLCNameBoardEx,uLCDict_TrainmanJiaoLu,
  uTrainmanJiaolu,uSaftyEnum, ComCtrls, ExtCtrls, RzPanel,uLCNameBoard;

type
  TfrmPBFromPrepare = class(TForm)
    Panel1: TPanel;
    btnCancel: TButton;
    btnOK: TButton;
    RzPanel1: TRzPanel;
    Label4: TLabel;
    comboTrainmanJiaolu: TRzComboBox;
    comboTrainman1: TRzComboBox;
    Label2: TLabel;
    lblPlanInfo: TLabel;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure comboTrainmanJiaoluKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure comboTrainmanJiaoluChange(Sender: TObject);
  private
    { Private declarations }
    m_jlArray: TRsSiteTMJLArray;
    m_TrainNo : string;
    m_strTrainTypeName : string;
    m_strTrainNumber : string;
    m_strTrainmanNumber1 : string;
    m_strTrainmanNumber2 : string;
    m_strTMOrder1 : integer;
    m_strTMOrder2 : integer;
    
    m_strTMJiaoluGUID : string;
    m_strTMJiaoluName : string;
    m_nTMJiaoluType : integer;

    m_strGroupGUID : string;
    m_LCBoardTrainman : TRsLCBoardTrainman;
    m_LCNameBoard : TRsLCNameBoard;
    m_LCTMJiaolu : TRsLCTrainmanJiaolu;

    m_TMOrders : TRsPrepareTMOrderArray;
    m_SelectedTMOrder : RRsPrepareTMOrder;
    m_SelectedSubTMOrder : RRsPrepareTMOrder;
    procedure Init;
    procedure InitOrderPrepareTrainman(TMJiaoluGUID : string);
    procedure InitTogetherTrainTrainman(TMJiaoluGUID : string);

  public
    { Public declarations }
    class function SelectPrepareToGroup(TrainNo,TrainTypeName,TrainNumber : string;
    var TMJiaoluGUID:string;var TMJiaoluName : string;var TMJiaoluType : integer ;
    var TrainmanNumber1 : string ; var TrainmanNumber1Order : integer;
    var TrainmanNumber2 : string;var TrainmanNumber2Order : integer;var GroupGUID : string) : boolean;
  end;

var
  frmPBFromPrepare: TfrmPBFromPrepare;

implementation
uses
  uGlobalDM;
{$R *.dfm}

procedure TfrmPBFromPrepare.btnOKClick(Sender: TObject);
begin
  if comboTrainmanJiaolu.ItemIndex < 0 then
  begin
    Box('没有可用的人员交路');
    exit;
  end;
  if comboTrainman1.ItemIndex < 0 then
  begin
    Box('请选择乘务员');
    exit;
  end;

  if not TBox('您确定要安排这两个乘务员吗?') then exit;

  m_nTMJiaoluType := Ord(m_jlArray[comboTrainmanJiaolu.ItemIndex].JlType);
  
  if m_nTMJiaoluType = Ord(jltOrder) then
  begin
    m_strTrainmanNumber1 := m_SelectedTMOrder.TrainmanNumber;
    if length(m_strTrainmanNumber1) = 0 then
    begin
      Box('司机1工号不能为空');
      exit;
    end;
    m_strTrainmanNumber2 := m_SelectedSubTMOrder.TrainmanNumber;
    if length(m_strTrainmanNumber2) = 0 then
    begin
      Box('司机1工号不能为空');
      exit;
    end;

    m_strTMOrder1 := m_SelectedTMOrder.TrainmanOrder;
    m_strTMOrder2 := m_SelectedSubTMOrder.TrainmanOrder;
  end;
  if m_nTMJiaoluType = Ord(jltTogether) then
  begin
    m_strGroupGUID := comboTrainman1.Value;
  end;

  m_strTMJiaoluGUID := comboTrainmanJiaolu.Values[comboTrainmanJiaolu.itemindex];
  m_strTMJiaoluName := comboTrainmanJiaolu.Text;
  ModalResult := mrOk;
end;

procedure TfrmPBFromPrepare.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmPBFromPrepare.comboTrainmanJiaoluChange(Sender: TObject);
begin
  comboTrainman1.Items.Clear;

  comboTrainman1.Values.Clear;

  if (comboTrainmanJiaolu.ItemIndex < 0) then exit;
  if (m_jlArray[comboTrainmanJiaolu.ItemIndex].JlType = jltOrder) then
  begin
    InitOrderPrepareTrainman(comboTrainmanJiaolu.Value);
  end;
  if (m_jlArray[comboTrainmanJiaolu.ItemIndex].JlType = jltTogether) then
  begin
    InitTogetherTrainTrainman(comboTrainmanJiaolu.Value);
    m_strGroupGUID := '';
  end;
  
end;

procedure TfrmPBFromPrepare.comboTrainmanJiaoluKeyPress(Sender: TObject;
  var Key: Char);
begin
 if Key = #13 then
  begin

    if Sender = comboTrainmanJiaolu then
    begin
      btnOK.SetFocus;
      exit;
    end;

    if Sender = btnOK then
    begin
      btnOK.Click;
      exit;
    end;
  end;
end;

procedure TfrmPBFromPrepare.FormCreate(Sender: TObject);
begin
  m_LCBoardTrainman := TRsLCBoardTrainman.Create(GlobalDM.WebAPIUtils);
  m_LCNameBoard := TRsLCNameBoard.Create('','','');
  m_LCNameBoard.SetConnConfig(GlobalDM.HttpConnConfig);
  
  m_LCTMJiaolu := TRsLCTrainmanJiaolu.Create('','','');
  m_LCTMJiaolu.SetConnConfig(GlobalDM.HttpConnConfig);
  SetLength(m_jlArray,0);
    
end;

procedure TfrmPBFromPrepare.FormDestroy(Sender: TObject);
begin
  m_LCBoardTrainman.Free;
  m_LCTMJiaolu.Free;
  m_LCNameBoard.Free;
end;

procedure TfrmPBFromPrepare.Init;
var
  i,nIndex: Integer;
begin
  lblPlanInfo.Caption := Format('请为车次为%s，机车为%s-%s的计划安排值乘的乘务员',
    [m_TrainNo,m_strTrainTypeName,m_strTrainNumber]);
  m_LCTMJiaolu.GetTMJLOfSite(GlobalDM.SiteInfo.strSiteIP,m_jlArray);
  nIndex := -1;
  for i := 0 to length(m_jlArray) - 1 do
  begin
    comboTrainmanJiaolu.AddItemValue(m_jlArray[i].JlName,m_jlArray[i].JlGUID);
    if (m_jlArray[i].JlType = jltOrder) then
    begin
      nIndex := i;
    end;
  end;
  if comboTrainmanJiaolu.Count > 0 then
  begin
    if nIndex > -1 then
      comboTrainmanJiaolu.ItemIndex := nIndex
    else
      comboTrainmanJiaolu.ItemIndex := 0;
    comboTrainmanJiaoluChange(comboTrainmanJiaolu);
  end;
end;


procedure TfrmPBFromPrepare.InitOrderPrepareTrainman(TMJiaoluGUID : string);
var
  i: integer;
  strTMView : string;
  tmOrder,subTMOrder : RRsPrepareTMOrder;
begin
  
  m_LCBoardTrainman.GetPrepareOrder(GlobalDM.SiteInfo.strSiteGUID,TMJiaoluGUID,m_TMOrders);
  for i := 0 to length(m_TMOrders) - 1 do
  begin
    if (m_TMOrders[i].PostID = 1) and (m_TMOrders[i].TrainmanOrder = 1) then
    begin
      tmOrder := m_TMOrders[i];
    end;
    if (m_TMOrders[i].PostID = 2) and (m_TMOrders[i].TrainmanOrder = 1) then
    begin
      subTMOrder :=   m_TMOrders[i];
    end;
  end;

  strTMView := Format('%s[%s]--------%s[%s]',[tmOrder.TrainmanName,tmOrder.TrainmanNumber,
  subTMOrder.TrainmanName,subTMOrder.TrainmanNumber]);
  comboTrainman1.AddItemValue(strTMView,'');
  if (comboTrainman1.Count > 0) then
  begin
    comboTrainman1.ItemIndex := 0;
    m_SelectedTMOrder := tmOrder;
    m_SelectedSubTMOrder := subTMOrder;
  end;
end;

procedure TfrmPBFromPrepare.InitTogetherTrainTrainman(TMJiaoluGUID: string);
var
  trainArray : TRsTogetherTrainArray;
  strError,strTMView : string;
  i,k: Integer;
  orderGroup : RRsOrderGroupInTrain;
begin

  if not m_LCNameBoard.GetTogetherGroup(TMJiaoluGUID,trainArray,strError) then
    exit;
  for i := 0 to length(trainArray) - 1 do
  begin
    if (trainArray[i].strTrainNumber = m_strTrainNumber) then
    begin
      for k := 0 to length(trainArray[i].Groups) - 1 do
      begin
        orderGroup := trainArray[i].Groups[k];
        strTMView := '';
        if (orderGroup.Group.Trainman1.strTrainmanNumber <> '') then
        strTMView := Format('%s[%s]--------%s[%s]',[orderGroup.Group.Trainman1.strTrainmanName,
            orderGroup.Group.Trainman1.strTrainmanNumber,
            orderGroup.Group.Trainman2.strTrainmanName,
            orderGroup.Group.Trainman2.strTrainmanNumber]);
        comboTrainman1.AddItemValue(strTMView,trainArray[i].Groups[k].Group.strGroupGUID);      

        if (comboTrainman1.Count > 0) then
          comboTrainman1.ItemIndex := 0;
      end;
    end;
  end;
end;

class function TfrmPBFromPrepare.SelectPrepareToGroup(TrainNo,TrainTypeName,TrainNumber : string;
  var TMJiaoluGUID,TMJiaoluName: string; var TMJiaoluType: integer;
  var TrainmanNumber1: string;var TrainmanNumber1Order: integer;
  var TrainmanNumber2: string;var TrainmanNumber2Order: integer;var GroupGUID:string): boolean;
begin
  result := false;
  frmPBFromPrepare:= TfrmPBFromPrepare.Create(nil);
  try
    frmPBFromPrepare.m_TrainNo := TrainNo;
    frmPBFromPrepare.m_strTrainTypeName := TrainTypeName;
    frmPBFromPrepare.m_strTrainNumber := TrainNumber;
    
    frmPBFromPrepare.Init;
    if frmPBFromPrepare.ShowModal = mrCancel then exit;

    TMJiaoluGUID := frmPBFromPrepare.m_strTMJiaoluGUID;
    TMJiaoluName := frmPBFromPrepare.m_strTMJiaoluName;
    TMJiaoluType := frmPBFromPrepare.m_nTMJiaoluType;

    TrainmanNumber1 := frmPBFromPrepare.m_strTrainmanNumber1;
    TrainmanNumber1Order := frmPBFromPrepare.m_strTMOrder1;
    TrainmanNumber2 := frmPBFromPrepare.m_strTrainmanNumber2;
    TrainmanNumber2Order := frmPBFromPrepare.m_strTMOrder2;
    GroupGUID := frmPBFromPrepare.m_strGroupGUID;
    
    result := true;
  finally
    frmPBFromPrepare.Free;
  end;

end;

end.
