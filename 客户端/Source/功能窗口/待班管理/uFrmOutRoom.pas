unit uFrmOutRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ADODB,DateUtils, Buttons,uDBAccessRoomSign,
   ActnList,uGlobalDM,pngimage,uSaftyEnum,uTrainman,uRoomSign,uBaseDBRoomSign;

type
  TfrmOutRoom = class(TForm)
    RzGroupBox1: TRzGroupBox;
    Label3: TLabel;
    CombRoom: TComboBox;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    rzgrpbx2: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblMainDriver: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    btnMainInput: TSpeedButton;
    lblMainVerifyResult: TLabel;
    edtTrainNo: TEdit;
    edtStartTime: TEdit;
    edtMainDriver: TEdit;
    edtMainDriverState: TEdit;
    edtCallTime: TEdit;
    edtTrainmanTypeName: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Label7: TLabel;
    edtSigninTime: TEdit;
    edtOutDutyTime: TEdit;
    Label8: TLabel;
    edtMainInTime: TEdit;
    Label10: TLabel;
    Label11: TLabel;
    edtMainOutTime: TEdit;
    pSubDriver: TPanel;
    lblSubDriver: TLabel;
    Label9: TLabel;
    lblSubVerifyResult: TLabel;
    Label12: TLabel;
    lblSubDriverState: TLabel;
    btnSubInput: TSpeedButton;
    edtSubDriver: TEdit;
    edtSubInTime: TEdit;
    edtSubDriverState: TEdit;
    edtSubOutTime: TEdit;
    pAlarm: TPanel;
    lblErrorAlarm: TLabel;
    Image1: TImage;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure btnMainInputClick(Sender: TObject);
    procedure btnMainFingerClick(Sender: TObject);
    procedure btnSubInputClick(Sender: TObject);
    procedure btnSubFingerClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
        //前一个调用的事件
    m_OldFingerTouch : TNotifyEvent;
        //数据库登记
    m_dbRoomSgin:   TRsBaseDBRoomSign;
      //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
    procedure ExecOutRoom(Trainman : RRsTrainman;Verify : TRsRegisterFlag);

    //执离寓行登记
    procedure ExecRoomSignOut(strTrainmanGUID,strRoomNumber:string;Verify :Integer);

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

    procedure SetPlanGUID(const Value: string);
  public
    { Public declarations }
    procedure SetMainDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);
    procedure SetSubDriver(driverGUID,driverName,driverNumber : string; nVerifyTypeID : integer);
    property PlanGUID : string read m_strPlanGUID write SetPlanGUID;
    property TrainPlanGUID:string read m_strTrainPlanGUID write m_strTrainPlanGUID ;
  end;

var
  frmOutRoom: TfrmOutRoom;

implementation

{$R *.dfm}

{ TfrmOutRoom }
uses
  uPlan,uRoom,MMSystem,uFrmTrainmanIdentityAccess,utfsystem;
procedure TfrmOutRoom.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmOutRoom.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmOutRoom.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
  Close;
end;

procedure TfrmOutRoom.btnMainFingerClick(Sender: TObject);
begin
  ;
end;

procedure TfrmOutRoom.btnMainInputClick(Sender: TObject);
var
  mainNumber : string;
  trainman : RRsTrainman;
  ado : TADOQuery;
begin
  GlobalDM.OnFingerTouching := nil;
  try
    mainNumber := InputBox('请输入工号','请输入正司机工号','');
    if mainNumber = '' then exit;

    if not m_dbTrainman.GetTrainmanByNumber(mainNumber,trainman) then 
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
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

procedure TfrmOutRoom.btnSaveClick(Sender: TObject);
begin
  if (m_strMainGUID = '') and (m_strSubGUID = '') then
  begin
    Application.MessageBox('没有出寓的司机。','提示',MB_OK);
    exit;
  end;

  if CombRoom.Text = '' then
  begin
    Application.MessageBox('请选择休息的房间。','提示',MB_OK);
    exit;
  end;
  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  if not TDBPlan.OutRoom(m_strPlanGUID,CombRoom.Text,m_strMainGUID,m_nMainVerify,m_strSubGUID,m_nSubVerify) then
  begin
    Application.MessageBox('出寓失败。','提示',MB_OK);
    exit;
  end;

  //记录离寓标志
  ExecRoomSignOut(m_strMainGUID,CombRoom.Text,m_nMainVerify);
  ExecRoomSignOut(m_strSubGUID,CombRoom.Text,m_nSubVerify);

  Application.MessageBox('出寓成功。','提示',MB_OK);
  ModalResult := mrOk;
  Close;
end;

procedure TfrmOutRoom.btnSubFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  ;
end;

procedure TfrmOutRoom.btnSubInputClick(Sender: TObject);
var
  subNumber : string;
  trainman : RRsTrainman;
  ado : TADOQuery;
begin
  GlobalDM.OnFingerTouching := nil;
  try
    subNumber := InputBox('请输入工号','请输入副司机工号','');
    if subNumber = '' then exit;

    if not m_dbTrainman.GetTrainmanByNumber(subNumber,trainman) then
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
      m_nSubVerify := Ord (rfInput);
    finally
      ado.Free;
    end;
  finally
    GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

procedure TfrmOutRoom.ExecOutRoom(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
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
      m_nSubVerify := ord(Verify)  ;
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

procedure TfrmOutRoom.ExecRoomSignOut(strTrainmanGUID, strRoomNumber: string;
  Verify: Integer);
var
  Trainman: RRsTrainman;
  roomSign : TRsRoomSign ;
begin
  if not m_dbTrainman.GetTrainman(strTrainmanGUID,Trainman) then
    Exit ;
  roomSign := TRsRoomSign.Create;
  try
    roomSign.strOutRoomGUID := NewGUID ;
    roomSign.strTrainPlanGUID := m_strTrainPlanGUID ;
    roomSign.strDutyUserGUID := GlobalDM.DutyUser.strDutyGUID ;
    roomSign.strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
    roomSign.strTrainmanGUID := Trainman.strTrainmanGUID ;
    roomSign.strTrainmanNumber := Trainman.strTrainmanNumber;
    roomSign.strTrainmanName := Trainman.strTrainmanName;
    roomSign.nOutRoomVerifyID := ord(Verify)  ;
    roomSign.dtOutRoomTime := Now ;
    roomSign.dtOutRoomTime := GlobalDM.GetNow ;
    m_dbRoomSgin.InsertSignOut(roomSign);
  finally
    roomSign.Free;
  end;

end;

procedure TfrmOutRoom.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TfrmOutRoom.FormCreate(Sender: TObject);
begin
  m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_dbRoomSgin := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);
  m_strPlanGUID := '';

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

procedure TfrmOutRoom.FormDestroy(Sender: TObject);
begin
  m_dbTrainman.Free ;
  m_dbRoomSgin.Free ;
  GlobalDM.OnFingerTouching := m_OldFingerTouch;
end;

procedure TfrmOutRoom.OnFingerTouching(Sender: TObject);
var
  TrainMan: RRsTrainman;
  eVerifyFlag: TRsRegisterFlag;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,eVerifyFlag,
    '','','','') then
  begin
    exit;
  end;
  ExecOutRoom(TrainMan,eVerifyFlag);
end;

procedure TfrmOutRoom.SetMainDriver(driverGUID, driverName,
  driverNumber: string; nVerifyTypeID: integer);
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

procedure TfrmOutRoom.SetPlanGUID(const Value: string);
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
        
        CombRoom.Text := FieldByName('strRoomNumber').AsString;
        btnMainInput.Visible := true;

        lblMainVerifyResult.Visible := true;
        lblSubVerifyResult.Visible := true;
        if (FieldByName('nMainDriverState').AsInteger <> 3) then
        begin
          btnMainInput.Visible := false;
          lblMainVerifyResult.Visible := false;
        end;
        if FieldByName('nTrainmanTypeID').AsInteger = 2 then
        begin
          btnSubInput.Visible := true;
          lblSubVerifyResult.Visible := true;
          if FieldByName('nSubDriverState').AsInteger <> 3 then
          begin
            btnSubInput.Visible := false;
            lblSubVerifyResult.Visible := false;
          end;
          btnSave.Enabled := true;
          if (FieldByName('nMainDriverState').AsInteger <> 3) and (FieldByName('nSubDriverState').AsInteger <> 3) then
              btnSave.Enabled := false;
        end
        else begin
          pSubDriver.Visible := false;
          btnSave.Enabled := false;
          if (FieldByName('nMainDriverState').AsInteger =3) then
             btnSave.Enabled := true;
        end;
        pAlarm.Visible := false;
        if GlobalDM.GetNow < IncHour(StrToDateTime(edtCallTime.Text),-1) then
        begin
          pAlarm.Visible := true;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmOutRoom.SetSubDriver(driverGUID, driverName, driverNumber: string;
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
