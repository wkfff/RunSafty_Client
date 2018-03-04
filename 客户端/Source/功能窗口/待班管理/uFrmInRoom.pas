unit uFrmInRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ADODB,DateUtils, Buttons,uDBAccessRoomSign,
   ActnList,uGlobalDM,uSaftyEnum,uTrainman,uRoomSign,uBaseDBRoomSign;

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
      //前一个调用的事件
    m_OldFingerTouch : TNotifyEvent;
    //数据库登记
    m_dbRoomSgin:   TRsBaseDBRoomSign;
      //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    procedure ExecInRoom(Trainman : RRsTrainman;Verify : TRsRegisterFlag);

    //执入寓行登记 数据进入到 tab_plan_inroom
    procedure ExecRoomSignIn(strTrainmanGUID,strRoomNumber:string;Verify:Integer);
  private

      //人员管理
    m_dbTrainman:TRsDBAccessTrainman ;
    { Private declarations }
    m_strPlanGUID : string;

    m_strTrainPlanGUID:string ;

    m_strMainGUID : string;
    m_strMainNumber : string;
    m_nMainVerify : Integer;

    m_strSubGUID : string;
    m_strSubNumber :string;
    m_nSubVerify : Integer;
    m_bCapturing : boolean;
    procedure SetPlanGUID(const Value: string);

  public
    { Public declarations }
    procedure SetMainDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);
    procedure SetSubDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);

    property PlanGUID : string read m_strPlanGUID write SetPlanGUID;
    property TrainPlanGUID:string read m_strTrainPlanGUID write m_strTrainPlanGUID ;
  end;

var
  frmInRoom: TfrmInRoom;

implementation

{$R *.dfm}
{ TfrmInRoom }
uses
  uPlan,uRoom,uFrmFindRoom,MMSystem,uTrainNo, uFrmTrainmanIdentityAccess,utfsystem;


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
  ;
end;

procedure TfrmInRoom.btnMainInputClick(Sender: TObject);
var
  mainNumber : string;
  trainman : RRsTrainman;
  ado : TADOQuery;
begin
  GlobalDM.OnFingerTouching := nil;
  try
    mainNumber := InputBox('请输入工号','请输入正司机工号','');
    if mainNumber = '' then exit;

    if not m_DBTrainman.GetTrainmanByNumber(mainNumber,trainman) then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;;
    end;

    TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
    try
      if ado.FieldByName('strMainDriverGUID').AsString <> trainman.strTrainmanGUID then
      begin
        Application.MessageBox('错误的乘务员工号','提示',MB_OK);
        exit;
      end;
      lblMainVerifyResult.Caption := '验证结果：通过';
      m_strMainGUID := trainman.strTrainmanGUID;
      m_strMainNumber := mainNumber;
      m_nMainVerify := ord(rfInput);
    finally
      ado.Free;
    end;
  finally
    GlobalDM.OnFingerTouching := OnFingerTouching;
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
  if not TDBPlan.InRoom(m_strPlanGUID,edtRoom.Text,m_strMainGUID,m_nMainVerify,m_strSubGUID,m_nSubVerify) then
  begin
    Application.MessageBox('入寓失败。','提示',MB_OK);
    exit;
  end;

  //记录入寓标志
  ExecRoomSignIn(m_strMainGUID,edtRoom.Text,m_nMainVerify);
  ExecRoomSignIn(m_strSubGUID,edtRoom.Text,m_nSubVerify);

  Application.MessageBox('入寓成功。','提示',MB_OK);
  ModalResult := mrOk;
  Close;
end;

procedure TfrmInRoom.btnSubFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  ;
end;

procedure TfrmInRoom.btnSubInputClick(Sender: TObject);
var
  subNumber : string;
  trainman : RRsTrainman;
  ado : TADOQuery;
begin
  subNumber := InputBox('请输入工号','请输入副司机工号','');
  if subNumber = '' then exit;

  if not m_DBTrainman.GetTrainmanByNumber(subNumber,trainman) then
  begin
    Application.MessageBox('错误的乘务员工号','提示',MB_OK);
    exit;
  end;
  
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strSubDriverGUID').AsString <> trainman.strTrainmanGUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblSubVerifyResult.Caption := '验证结果：通过';
    m_strSubGUID := trainman.strTrainmanGUID;
    m_strSubNumber := subNumber;
    m_nSubVerify := ord (rfInput);
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.ExecInRoom(Trainman: RRsTrainman; Verify: TRsRegisterFlag);
var
  ado : TADOQuery ;
begin
  //获取签点计划
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strMainDriverGUID').AsString = trainman.strTrainmanGUID then
    begin
      lblMainVerifyResult.Caption := '验证结果：通过';
      m_strMainGUID := trainman.strTrainmanGUID;
      m_strMainNumber := trainman.strTrainmanNumber;
      m_nMainVerify := ord(Verify)  ;
    end
    else if ado.FieldByName('strSubDriverGUID').AsString = trainman.strTrainmanGUID then
    begin
      lblSubVerifyResult.Caption := '验证结果：通过';
      m_strSubGUID := trainman.strTrainmanGUID;
      m_strSubNumber := trainman.strTrainmanNumber;
      m_nSubVerify := ord(Verify)   ;
    end
    else
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmInRoom.ExecRoomSignIn(strTrainmanGUID:string;strRoomNumber:string;
  Verify: Integer);
var
  Trainman: RRsTrainman;
  roomSign : TRsRoomSign ;
begin
  if not m_dbTrainman.GetTrainman(strTrainmanGUID,Trainman) then
    Exit ;
  roomSign := TRsRoomSign.Create;
  try
    roomSign.strInRoomGUID := NewGUID ;
    roomSign.strTrainPlanGUID := m_strTrainPlanGUID ;
    roomSign.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID ;
    roomSign.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
    roomSign.strTrainmanGUID := Trainman.strTrainmanGUID ;
    roomSign.strTrainmanNumber := Trainman.strTrainmanNumber;
    roomSign.strTrainmanName := Trainman.strTrainmanName;
    roomSign.nInRoomVerifyID := Verify  ;
    roomSign.dtInRoomTime := GlobalDM.GetNow ;
    roomSign.strRoomNumber :=  strRoomNumber ;
    m_dbRoomSgin.InsertSignIn(roomSign);
  finally
    roomSign.Free;
  end;
end;

procedure TfrmInRoom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmInRoom.FormCreate(Sender: TObject);
begin
  m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_dbRoomSgin := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);
  m_strPlanGUID := '';
  m_bCapturing := false;
  m_strMainGUID := '';
  m_strMainNumber := '';
  m_nMainVerify := 0;


  m_strSubGUID := '';
  m_strSubNumber := '';
  m_nSubVerify := 0;
  btnSave.Enabled := false;

    //挂接指纹仪点击事件
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;

end;

procedure TfrmInRoom.FormDestroy(Sender: TObject);
begin
  m_dbTrainman.Free ;
  m_dbRoomSgin.Free ;
  GlobalDM.OnFingerTouching := m_OldFingerTouch;
end;

procedure TfrmInRoom.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,eVerifyFlag,
    '','','','') then
  begin
    exit;
  end;
  ExecInRoom(TrainMan,eVerifyFlag);
end;

procedure TfrmInRoom.SetMainDriver(driverGUID, driverName, driverNumber : string;
  nVerifyTypeID: integer);
var
  ado : TADOQuery;
begin
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
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
  TDBPlan.GetCallsByGUID(m_strPlanGUID, ado);
  try
    with ado do
    begin
      if RecordCount > 0 then
      begin
        edtTrainNo.Text := FieldByName('strTrainNo').AsString;
        edtRoom.Text := TDBPlan. GetTrainNosRoom(FieldByName('strTrainNo').AsString);
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
        lblMainVerifyResult.Visible := true;
        lblSubVerifyResult.Visible := true;
        //正司机不在可入寓状态
        if (FieldByName('nMainDriverState').AsInteger <> 2) then
        begin
          btnMainInput.Visible := false;
          lblMainVerifyResult.Visible := false;
          //正司机已经入寓过
          if (FieldByName('nMainDriverState').AsInteger > 2) then
            btnFind.Visible := false;
        end;

        //双司机情况
        if FieldByName('nTrainmanTypeID').AsInteger = 2 then
        begin
          btnSubInput.Visible := true;
          lblSubVerifyResult.Visible := true;
          //副司机不在可入寓状态
          if FieldByName('nSubDriverState').AsInteger <> 2 then
          begin
            btnSubInput.Visible := false;
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
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
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



end.
