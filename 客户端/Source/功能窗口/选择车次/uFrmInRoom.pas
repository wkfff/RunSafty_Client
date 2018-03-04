unit uFrmInRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ADODB,DateUtils, Buttons, ActnList,uDataModule;

type
  TfrmInRoom = class(TForm)
    RzGroupBox1: TRzGroupBox;
    Label3: TLabel;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    rzgrpbx2: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblMainDriver: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnMainInput: TSpeedButton;
    btnMainFinger: TSpeedButton;
    edtTrainNo: TEdit;
    edtStartTime: TEdit;
    edtMainDriver: TEdit;
    edtMainDriverState: TEdit;
    edtCallTime: TEdit;
    edtTrainmanTypeName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    lblMainVerifyResult: TLabel;
    btnFind: TSpeedButton;
    edtRoom: TEdit;
    edtOutDutyTime: TEdit;
    edtSigninTime: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    edtMainInTime: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edtMainOutTime: TEdit;
    pSubDriver: TPanel;
    edtSubDriver: TEdit;
    lblSubDriver: TLabel;
    Label9: TLabel;
    edtSubInTime: TEdit;
    lblSubVerifyResult: TLabel;
    Label12: TLabel;
    lblSubDriverState: TLabel;
    edtSubDriverState: TEdit;
    edtSubOutTime: TEdit;
    btnSubFinger: TSpeedButton;
    btnSubInput: TSpeedButton;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure btnMainInputClick(Sender: TObject);
    procedure btnMainFingerClick(Sender: TObject);
    procedure btnSubInputClick(Sender: TObject);
    procedure btnSubFingerClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
    m_strPlanGUID : string;

    m_strMainGUID : string;
    m_strMainNumber : string;
    m_nMainVerify : Integer;

    m_strSubGUID : string;
    m_strSubNumber :string;
    m_nSubVerify : Integer;
    m_bCapturing : boolean;
    procedure SetPlanGUID(const Value: string);
    //捕获指纹仪消息
    procedure WMMSGFingerCapture(var Message: TMessage); message WM_MSGFingerCapture;
  public
    { Public declarations }
    procedure SetMainDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);
    procedure SetSubDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);

    property PlanGUID : string read m_strPlanGUID write SetPlanGUID;
  end;

var
  frmInRoom: TfrmInRoom;

implementation

{$R *.dfm}

{ TfrmInRoom }
uses
  uTrainMan,uPlan,uRoom,uFrmFingerVerify,uFrmFindRoom,MMSystem,uTrainNo;
procedure TfrmInRoom.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmInRoom.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmInRoom.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmInRoom.btnFindClick(Sender: TObject);
begin
  frmFindRoom := TfrmFindRoom.Create(nil);
  try
    if frmFindRoom.ShowModal = mrCancel then exit;
    edtRoom.Text := frmFindRoom.lvRoom.Selected.SubItems[0];
  finally
    frmFindRoom.Free;
  end;
end;

procedure TfrmInRoom.btnMainFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
      try
        if ado.FieldByName('strMainDriverGUID').AsString <> frmFingerVerify.TrainmanGUID then
        begin
          Application.MessageBox('错误的乘务员工号','提示',MB_OK);
          exit;
        end;
        lblMainVerifyResult.Caption := '验证结果：通过';
        m_strMainGUID := frmFingerVerify.TrainmanGUID;
        m_strMainNumber := frmFingerVerify.edtTrainmanNumber.Text;
        m_nMainVerify := 1;
      finally
        ado.Free;
      end;
    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmInRoom.btnMainInputClick(Sender: TObject);
var
  mainNumber : string;
  trainman : RTrainman;
  ado : TADOQuery;
begin
  if Application.MessageBox('您确认要工号验证吗？','提示',MB_OKCANCEL) = mrCancel then exit;
  mainNumber := InputBox('请输入工号','请输入正司机工号','');
  if mainNumber = '' then exit;

  trainman := TTrainmanOpt.GetTrainmanByNumber(mainNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('错误的乘务员工号','提示',MB_OK);
    exit;
  end;
  TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strMainDriverGUID').AsString <> trainman.GUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblMainVerifyResult.Caption := '验证结果：通过';
    m_strMainGUID := trainman.GUID;
    m_strMainNumber := mainNumber;
    m_nMainVerify := 2;
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.btnSaveClick(Sender: TObject);
begin
  if (m_strMainGUID = '') and (m_strSubGUID = '') then
  begin
    Application.MessageBox('没有入寓的司机。','提示',MB_OK);
    exit;
  end;

  if edtRoom.Text = '' then
  begin
    Application.MessageBox('请选择休息的房间。','提示',MB_OK);
    exit;
  end;
  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  if not TPlanOpt.InRoom(m_strPlanGUID,edtRoom.Text,m_strMainGUID,m_nMainVerify,m_strSubGUID,m_nSubVerify) then
  begin
    Application.MessageBox('入寓失败。','提示',MB_OK);
    exit;
  end;
  Application.MessageBox('入寓成功。','提示',MB_OK);
  ModalResult := mrOk;
  Close;
end;

procedure TfrmInRoom.btnSubFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
      try
        if ado.FieldByName('strSubDriverGUID').AsString <> frmFingerVerify.TrainmanGUID then
        begin
          Application.MessageBox('错误的乘务员工号','提示',MB_OK);
          exit;
        end;
        lblSubVerifyResult.Caption := '验证结果：通过';
        m_strSubGUID := frmFingerVerify.TrainmanGUID;
        m_strSubNumber := frmFingerVerify.edtTrainmanNumber.Text;
        m_nSubVerify := 1;
      finally
        ado.Free;
      end;

    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmInRoom.btnSubInputClick(Sender: TObject);
var
  subNumber : string;
  trainman : RTrainman;
  ado : TADOQuery;
begin
  if Application.MessageBox('您确认要工号验证吗？','提示',MB_OKCANCEL) = mrCancel then exit;
  subNumber := InputBox('请输入工号','请输入副司机工号','');
  if subNumber = '' then exit;

  trainman := TTrainmanOpt.GetTrainmanByNumber(subNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('错误的乘务员工号','提示',MB_OK);
    exit;
  end;
  TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strSubDriverGUID').AsString <> trainman.GUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblSubVerifyResult.Caption := '验证结果：通过';
    m_strSubGUID := trainman.GUID;
    m_strSubNumber := subNumber;
    m_nSubVerify := 2;
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmInRoom.FormCreate(Sender: TObject);
begin
  m_strPlanGUID := '';
  m_bCapturing := false;
  m_strMainGUID := '';
  m_strMainNumber := '';
  m_nMainVerify := 0;

  m_strSubGUID := '';
  m_strSubNumber := '';
  m_nSubVerify := 0;
  DMGlobal.FingerMsgList.Add(IntToStr(Handle));
  btnSave.Enabled := false;
end;

procedure TfrmInRoom.FormDestroy(Sender: TObject);
begin
  DMGlobal.FingerMsgList.Delete(DMGlobal.FingerMsgList.Count - 1);
end;

procedure TfrmInRoom.SetMainDriver(driverGUID, driverName, driverNumber : string;
  nVerifyTypeID: integer);
var
  ado : TADOQuery;
begin
  TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strMainDriverGUID').AsString <> driverGUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblMainVerifyResult.Caption := '验证结果：通过';
    m_strMainGUID := driverGUID;
    m_strMainNumber := driverName + '['+driverNumber+']';
    m_nMainVerify := nVerifyTypeID;
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.SetPlanGUID(const Value: string);
var
  ado : TADOQuery;
begin
  if m_strPlanGUID = Value then exit;
  m_strPlanGUID := value;
  TPlanOpt.GetCallsByGUID(m_strPlanGUID, ado);
  try
    with ado do
    begin
      if RecordCount > 0 then
      begin
        edtTrainNo.Text := FieldByName('strTrainNo').AsString;
        edtRoom.Text := TTrainNoOpt. GetTrainNosRoom(FieldByName('strTrainNo').AsString);
        edtTrainmanTypeName.Text := FieldByName('strTrainmanTypeName').AsString;
        edtSigninTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtSigninTime').AsDateTime);
        edtCallTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtCallTime').AsDateTime);
        edtOutDutyTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtOutDutyTime').AsDateTime);
        edtStartTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtStartTime').AsDateTime);
        

        edtMainDriver.Text := FieldByName('strMainDriverName').AsString + '[' +FieldByName('strMainDriverNumber').AsString+ ']';
        edtMainDriverState.Text := FieldByName('strMainDriverStateName').AsString;
        edtMainInTime.Text := FieldByName('dtMainInTime').AsString;
        edtMainOutTime.Text := FieldByName('dtMainOutTime').AsString;

        edtSubDriver.Text := FieldByName('strSubDriverName').AsString + '[' +FieldByName('strSubDriverNumber').AsString+ ']';
        edtSubDriverState.Text := FieldByName('strSubDriverStateName').AsString;
        edtSubInTime.Text := FieldByName('dtSubInTime').AsString;
        edtSubOutTime.Text := FieldByName('dtSubOutTime').AsString;

        if FieldByName('strRoomNumber').AsString  <> '' then
        begin
          edtRoom.Text := FieldByName('strRoomNumber').AsString;
        end;

        btnMainInput.Visible := true;
        btnMainFinger.Visible := true;
        lblMainVerifyResult.Visible := true;
        lblSubVerifyResult.Visible := true;
        //正司机不在可入寓状态
        if (FieldByName('nMainDriverState').AsInteger <> 2) then
        begin
          btnMainInput.Visible := false;
          lblMainVerifyResult.Visible := false;
          btnMainFinger.Visible := false;
          //正司机已经入寓过
          if (FieldByName('nMainDriverState').AsInteger > 2) then
            btnFind.Visible := false;
        end;

        //双司机情况
        if FieldByName('nTrainmanTypeID').AsInteger = 2 then
        begin
          btnSubInput.Visible := true;
          btnSubFinger.Visible := true;
          lblSubVerifyResult.Visible := true;
          //副司机不在可入寓状态
          if FieldByName('nSubDriverState').AsInteger <> 2 then
          begin
            btnSubInput.Visible := false;
            btnSubFinger.Visible := false;
            lblSubVerifyResult.Visible := false;
            //副司机已经入寓过
            if FieldByName('nSubDriverState').AsInteger > 2 then
              btnFind.Visible := false;
          end;
          btnSave.Enabled := true;
          if (FieldByName('nMainDriverState').AsInteger <> 2) and (FieldByName('nSubDriverState').AsInteger <> 2) then
              btnSave.Enabled := false;
        end
        else begin
          pSubDriver.Visible := false;
          btnSave.Enabled := false;
          if (FieldByName('nMainDriverState').AsInteger =2) then
             btnSave.Enabled := true;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.SetSubDriver(driverGUID, driverName, driverNumber : string;
  nVerifyTypeID: integer);
var
  ado : TADOQuery;
begin
  TPlanOpt.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strSubDriverGUID').AsString <> driverGUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblSubVerifyResult.Caption := '验证结果：通过';
    m_strSubGUID := driverGUID;
    m_strSubNumber := driverName + '['+driverNumber+']';
    m_nSubVerify := nVerifyTypeID;
  finally
    ado.Free;
  end;

end;


procedure TfrmInRoom.WMMSGFingerCapture(var Message: TMessage);
var
  trainman : RTrainman;
  plan : RPlan;
begin
  if m_bCapturing then exit;
  m_bCapturing := true;
  try
    trainman := TTrainmanOpt.GetTrainmanByFinger(DMGlobal.ZKFPEng,DMGlobal.ZKFPEng.GetTemplate);
    if trainman.GUID = '' then
    begin
      DMGlobal.CallControl.SetPlayMode(2);
      PlaySound(PChar(DMGlobal.AppPath + 'Sounds\错误的指纹信息或指纹没有登记.wav'),0,SND_FILENAME or SND_ASYNC);
      exit;
    end;
    plan := TPlanOpt.GetTrainmanPlanState(trainman.GUID,2);
    if plan.strGUID = '' then
    begin
      DMGlobal.CallControl.SetPlayMode(2);
      PlaySound(PChar(DMGlobal.AppPath + 'Sounds\错误的指纹信息或指纹没有登记.wav'),0,SND_FILENAME or SND_ASYNC);
      exit;
    end;

    if (plan.strMainDriverGUID = trainman.GUID)  then
    begin
      //正司机已签到
      if plan.nMainDriverState = 2 then
      begin
        SetMainDriver(trainman.GUID,trainman.TrainmanName,trainman.TrainmanNumber,1);
      end;
    end;

    if (plan.strSubDriverGUID = trainman.GUID)  then
    begin
      //副司机已签到
      if plan.nSubDriverState = 2 then
      begin
        SetSubDriver(trainman.GUID,trainman.TrainmanName,trainman.TrainmanNumber,1);
      end;
    end;
  finally
    m_bCapturing := false;
  end;
end;

end.
