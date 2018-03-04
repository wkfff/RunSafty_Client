unit ufrmOutDuty;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ADODB,DateUtils, Buttons, ActnList,JPEG,
  uApparatusCommon,uTrainman;

type
  TfrmOutDuty = class(TForm)
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    rzgrpbx2: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblMainDriver: TLabel;
    Label4: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    btnMainInput: TSpeedButton;
    btnMainFinger: TSpeedButton;
    Label7: TLabel;
    btnMainDrink: TSpeedButton;
    edtTrainNo: TEdit;
    edtStartTime: TEdit;
    edtMainDriver: TEdit;
    edtMainDriverState: TEdit;
    edtCallTime: TEdit;
    edtTrainmanTypeName: TEdit;
    CombMainDrinkResult: TComboBox;
    Panel1: TPanel;
    Panel2: TPanel;
    Label6: TLabel;
    edtMainDriverRestLength: TEdit;
    lblMainVerifyResult: TLabel;
    lblMainRestHint: TLabel;
    Label8: TLabel;
    edtSigninTime: TEdit;
    Label9: TLabel;
    edtOutDutyTime: TEdit;
    edtMainInTime: TEdit;
    Label10: TLabel;
    edtMainOutTime: TEdit;
    Label11: TLabel;
    pSubDriver: TPanel;
    lblSubDriver: TLabel;
    Label12: TLabel;
    edtSubDriver: TEdit;
    edtSubInTime: TEdit;
    Label13: TLabel;
    lblSubDriverState: TLabel;
    edtSubDriverState: TEdit;
    edtSubOutTime: TEdit;
    lblSubDriverRestLength: TLabel;
    lblSubDrinkResult: TLabel;
    CombSubDrinkResult: TComboBox;
    edtSubDriverRestLength: TEdit;
    lblSubRestHint: TLabel;
    btnSubInput: TSpeedButton;
    btnSubDrink: TSpeedButton;
    btnSubFinger: TSpeedButton;
    lblSubVerifyResult: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure btnMainInputClick(Sender: TObject);
    procedure btnMainFingerClick(Sender: TObject);
    procedure btnSubInputClick(Sender: TObject);
    procedure btnSubFingerClick(Sender: TObject);
    procedure btnMainDrinkClick(Sender: TObject);
    procedure btnSubDrinkClick(Sender: TObject);
  private
    { Private declarations }
    m_strPlanGUID : string;
   m_MainTrainman: RTrainman;
    m_nMainVerify: Integer;

    m_SubTrainman: RTrainman;
    m_nSubVerify: Integer;
    procedure SetPlanGUID(const Value: string);
  public
    { Public declarations }
    property PlanGUID : string read m_strPlanGUID write SetPlanGUID;
  end;
var
  frmOutDuty: TfrmOutDuty;

implementation

{$R *.dfm}
uses
  uPlan,uFrmFingerVerify,uDataModule,uFrmTestDrink,uDrink;
procedure TfrmOutDuty.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmOutDuty.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmOutDuty.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmOutDuty.btnMainDrinkClick(Sender: TObject);
var
  drink: RDrink;
begin
  if m_MainTrainman.GUID = '' then
  begin
    Application.MessageBox('请先录入指纹或输入工号', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  CombMainDrinkResult.ItemIndex := 0;
  drink.Init;
  try
    drink.TrainmanGUID :=  m_MainTrainman.GUID;
    drink.VerifyID := m_nMainVerify;
    drink.DutyGUID := DMGlobal.DutyUser.DutyGUID;
    drink.AreaGUID := DMGlobal.LocalArea;
    drink.TrainNo := edtTrainNo.Text;
    drink.DrinkResult := 0;
    drink.IsLocal := 1;
    if DMGlobal.StartDrink(m_MainTrainman.TrainmanNumber, m_MainTrainman.TrainmanName, drink) then
    begin
      drink.DrinkType := dteChuQin;
      
      //(闫)
      drink.TrainmanNumber := m_MainTrainman.TrainmanNumber;

      TDrinkOpt.AddDrink(drink);
      CombMainDrinkResult.ItemIndex := drink.DrinkResult;
    end;
  finally
    drink.Free;
  end;
end;

procedure TfrmOutDuty.btnMainFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
      try
        if ado.FieldByName('strMainDriverGUID').AsString <> frmFingerVerify.TrainmanGUID then
        begin
          Application.MessageBox('错误的乘务员工号','提示',MB_OK);
          exit;
        end;
        lblMainVerifyResult.Caption := '验证结果：通过';
        m_MainTrainman.GUID := frmFingerVerify.TrainmanGUID;
        m_MainTrainman.TrainmanNumber := frmFingerVerify.edtTrainmanNumber.Text;
        m_MainTrainman.TrainmanName := frmFingerVerify.edtTrainmanName.Text;
        m_nMainVerify := 1;
        CombMainDrinkResult.ItemIndex := 0;
      finally
        ado.Free;
      end;
    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmOutDuty.btnMainInputClick(Sender: TObject);
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
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strMainDriverGUID').AsString <> trainman.GUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblMainVerifyResult.Caption := '验证结果：通过';
    m_MainTrainman := trainman;
    m_nMainVerify := 2;
    CombMainDrinkResult.ItemIndex := 0;
  finally
    ado.Free;
  end;
end;

procedure TfrmOutDuty.btnSaveClick(Sender: TObject);
begin
  if (m_MainTrainman.GUID = '') and (m_SubTrainman.GUID = '') then
  begin
    Application.MessageBox('没有签到的司机。','提示',MB_OK);
    exit;
  end;

   if (m_MainTrainman.GUID <> '') then
  begin
    if (CombMainDrinkResult.ItemIndex <= 0) then
    begin
      if Application.MessageBox('正司机还未测酒，确定要继续吗?','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
        exit;
    end;

  end;

  if (m_SubTrainman.GUID <> '') then
  begin
    if (CombSubDrinkResult.ItemIndex <= 0) then
    if Application.MessageBox('副司机还未测酒，确定要继续吗?','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  end;

  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  if not TDBPlan.OutDuty(m_strPlanGUID,m_MainTrainman.GUID,m_nMainVerify,CombMainDrinkResult.ItemIndex,m_SubTrainman.GUID,m_nSubVerify,CombSubDrinkResult.ItemIndex) then
  begin
    Application.MessageBox('出勤失败。','提示',MB_OK);
    exit;
  end;
  Application.MessageBox('出勤成功。','提示',MB_OK);
  ModalResult := mrOk;
end;

procedure TfrmOutDuty.btnSubDrinkClick(Sender: TObject);
var
  drink: RDrink;
begin
  if m_SubTrainman.GUID = '' then
  begin
    Application.MessageBox('请先录入指纹或输入工号', '提示', MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  CombSubDrinkResult.ItemIndex := 0;
  drink.Init;
  try
    drink.TrainmanGUID := m_SubTrainman.GUID;
    drink.VerifyID := m_nSubVerify;
    drink.DutyGUID := DMGlobal.DutyUser.DutyGUID;
    drink.AreaGUID := DMGlobal.LocalArea;
    drink.TrainNo := edtTrainNo.Text;
    drink.DrinkResult := 0;
    drink.IsLocal := 1;
    if DMGlobal.StartDrink(m_SubTrainman.TrainmanNumber, m_SubTrainman.TrainmanName, drink) then
    begin
      drink.DrinkType := dteChuQin;

      //(闫)
      drink.TrainmanNumber := m_SubTrainman.TrainmanNumber;
      
      TDrinkOpt.AddDrink(drink);
      CombSubDrinkResult.ItemIndex := drink.DrinkResult;
    end;
  finally
    drink.Free;
  end;
end;

procedure TfrmOutDuty.btnSubFingerClick(Sender: TObject);
var
  ado : TADOQuery;
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
      try
        if ado.FieldByName('strSubDriverGUID').AsString <> frmFingerVerify.TrainmanGUID then
        begin
          Application.MessageBox('错误的乘务员工号','提示',MB_OK);
          exit;
        end;
        lblSubVerifyResult.Caption := '验证结果：通过';
        m_SubTrainman.GUID := frmFingerVerify.TrainmanGUID;
        m_SubTrainman.TrainmanNumber := frmFingerVerify.edtTrainmanNumber.Text;
        m_SubTrainman.TrainmanName := frmFingerVerify.edtTrainmanName.Text;
        m_nSubVerify := 1;
        CombSubDrinkResult.ItemIndex := 0;
      finally
        ado.Free;
      end;

    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmOutDuty.btnSubInputClick(Sender: TObject);
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
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  try
    if ado.FieldByName('strSubDriverGUID').AsString <> trainman.GUID then
    begin
      Application.MessageBox('错误的乘务员工号','提示',MB_OK);
      exit;
    end;
    lblSubVerifyResult.Caption := '验证结果：通过';
    m_SubTrainman := trainman;
    m_nSubVerify := 2;
    CombSubDrinkResult.ItemIndex := 0;
  finally
    ado.Free;
  end;
end;

procedure TfrmOutDuty.FormCreate(Sender: TObject);
begin
  m_strPlanGUID := '';

  m_MainTrainman.Init;
  m_nMainVerify := 0;

  m_SubTrainman.Init;
  m_nSubVerify := 0;
  
  btnSave.Enabled := false;
end;

procedure TfrmOutDuty.SetPlanGUID(const Value: string);
var
  ado,adoInOutRoom : TADOQuery;
  inroomTime,outroomTime,tempTime : TDateTime;
begin
  if m_strPlanGUID = Value then exit;
  m_strPlanGUID := value;
  TDBPlan.GetOutDutyByGUID(m_strPlanGUID, ado);
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

        edtMainDriverRestLength.Text := Format('%d时%d分',[HourOf(FieldByName('nMainDriverRestLength').AsDateTime),MinuteOf(FieldByName('nMainDriverRestLength').AsDateTime)]);
        TDBPlan.GetCallsByGUID(FieldByName('strGUID').AsString,adoInOutRoom);
        try
          inRoomTime := adoInOutRoom.FieldByName('dtMainInTime').AsDateTime;
          outRoomTime := adoInOutRoom.FieldByName('dtMainOutTime').AsDateTime;
          tempTime := IncHour(inRoomTime,HourOf(FieldByName('dtCallTime').AsDateTime-FieldByName('dtSigninTime').AsDateTime));
          tempTime :=  IncMinute(tempTime,MinuteOf(FieldByName('dtCallTime').AsDateTime-FieldByName('dtSigninTime').AsDateTime));
          if tempTime <= outRoomTime then
          begin
            lblMainRestHint.Caption := '休息充足';
            lblMainRestHint.Font.Color := clBlack;
          end
          else begin
            lblMainRestHint.Font.Color := clMaroon;
            lblMainRestHint.Caption := '休息不足';
          end;
        
          edtMainDriver.Text := FieldByName('strMainDriverName').AsString + '[' +FieldByName('strMainDriverNumber').AsString+ ']';
          edtMainDriverState.Text := FieldByName('strMainDriverStateName').AsString;
          CombMainDrinkResult.ItemIndex := FieldByName('nMainDrinkResult').AsInteger;

          edtMainInTime.Text := adoInOutRoom.FieldByName('dtMainInTime').AsString;
          edtMainOutTime.Text := adoInOutRoom.FieldByName('dtMainOutTime').AsString;

          edtSubDriver.Text := FieldByName('strSubDriverName').AsString + '[' +FieldByName('strSubDriverNumber').AsString+ ']';
          edtSubDriverState.Text := FieldByName('strSubDriverStateName').AsString;
          CombSubDrinkResult.ItemIndex := FieldByName('nSubDrinkResult').AsInteger;
          edtSubDriverRestLength.Text := Format('%d时%d分',[HourOf(FieldByName('nSubDriverRestLength').AsDateTime),MinuteOf(FieldByName('nSubDriverRestLength').AsDateTime)]);

          edtSubInTime.Text := adoInOutRoom.FieldByName('dtSubInTime').AsString;
          edtSubOutTime.Text := adoInOutRoom.FieldByName('dtSubOutTime').AsString;

          inRoomTime := adoInOutRoom.FieldByName('dtSubInTime').AsDateTime;
          outRoomTime := adoInOutRoom.FieldByName('dtSubOutTime').AsDateTime;
          tempTime := IncHour(inRoomTime,HourOf(FieldByName('dtCallTime').AsDateTime-FieldByName('dtSigninTime').AsDateTime));
          tempTime :=  IncMinute(tempTime,MinuteOf(FieldByName('dtCallTime').AsDateTime-FieldByName('dtSigninTime').AsDateTime));
          if tempTime <= outRoomTime then
          begin
            lblSubRestHint.Caption := '休息充足';
            lblSubRestHint.Font.Color := clBlack;
          end
          else begin
            lblSubRestHint.Font.Color := clMaroon;
            lblSubRestHint.Caption := '休息不足';
          end;
        finally
          adoInOutRoom.Free;
        end;

        btnMainInput.Visible := true;
        btnMainFinger.Visible := true;
        lblMainVerifyResult.Visible := true;
        lblSubVerifyResult.Visible := true;
        btnMainDrink.Visible := true;
        if (FieldByName('nMainDriverState').AsInteger <> 4) then
        begin
          btnMainInput.Visible := false;
          lblMainVerifyResult.Visible := false;
          lblMainRestHint.Visible := false;
          btnMainFinger.Visible := false;
          btnMainDrink.Visible := false;
          CombMainDrinkResult.Enabled := false;
        end;

        btnSubDrink.Visible := true;
        if FieldByName('nTrainmanTypeID').AsInteger = 2 then
        begin
          btnSubInput.Visible := true;
          btnSubFinger.Visible := true;
          lblSubVerifyResult.Visible := true;
          if FieldByName('nSubDriverState').AsInteger <> 4 then
          begin
            btnSubInput.Visible := false;
            btnSubFinger.Visible := false;
            lblSubVerifyResult.Visible := false;
            btnSubDrink.Visible := false;
            lblSubDriverRestLength.Visible := false;
            CombSubDrinkResult.Enabled := false;
            lblSubRestHint.Visible := false;
          end;
          btnSave.Enabled := true;
          if (FieldByName('nMainDriverState').AsInteger <> 4) and (FieldByName('nSubDriverState').AsInteger <> 4) then
              btnSave.Enabled := false;
        end
        else begin
          pSubDriver.Visible := false;
          btnSave.Enabled := false;
          if (FieldByName('nMainDriverState').AsInteger =4) then
             btnSave.Enabled := true;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

end.
