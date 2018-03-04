unit uFrmSignin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, ADODB, Buttons, ActnList, JPEG,
  uApparatusCommon, uTrainMan;

type
  TfrmSignin = class(TForm)
    rzgrpbx2: TRzGroupBox;
    Label1: TLabel;
    edtTrainNo: TEdit;
    edtStartTime: TEdit;
    Label2: TLabel;
    edtMainDriver: TEdit;
    lblMainDriver: TLabel;
    edtMainDriverState: TEdit;
    Label4: TLabel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    actLstLogin: TActionList;
    actCancel: TAction;
    actEnter: TAction;
    Label3: TLabel;
    edtCallTime: TEdit;
    Label5: TLabel;
    edtTrainmanTypeName: TEdit;
    btnMainInput: TSpeedButton;
    btnMainFinger: TSpeedButton;
    Label7: TLabel;
    CombMainDrinkResult: TComboBox;
    btnMainDrink: TSpeedButton;
    Panel1: TPanel;
    Panel2: TPanel;
    Label6: TLabel;
    edtSigninTime: TEdit;
    Label8: TLabel;
    edtOutDutyTime: TEdit;
    Label9: TLabel;
    edtMainSigninTime: TEdit;
    pSubDriver: TPanel;
    edtSubDriver: TEdit;
    lblSubDriver: TLabel;
    Label10: TLabel;
    edtSubSigninTime: TEdit;
    lblSubDrinkResult: TLabel;
    CombSubDrinkResult: TComboBox;
    edtSubDriverState: TEdit;
    lblSubDriverState: TLabel;
    btnSubFinger: TSpeedButton;
    btnSubDrink: TSpeedButton;
    btnSubInput: TSpeedButton;
    lblEditTrainman: TLabel;
    btnMainCancel: TSpeedButton;
    btnSubCancel: TSpeedButton;
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actEnterExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure btnMainInputClick(Sender: TObject);
    procedure btnSubInputClick(Sender: TObject);
    procedure btnMainFingerClick(Sender: TObject);
    procedure btnSubFingerClick(Sender: TObject);
    procedure btnMainDrinkClick(Sender: TObject);
    procedure btnSubDrinkClick(Sender: TObject);
    procedure lblEditTrainmanClick(Sender: TObject);
    procedure btnMainCancelClick(Sender: TObject);
    procedure btnSubCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_strPlanGUID: string;

    m_MainTrainman: RTrainman;
    m_nMainVerify: Integer;

    m_SubTrainman: RTrainman;
    m_nSubVerify: Integer;
    procedure SetPlanGUID(const Value: string);
  public
    { Public declarations }
    property PlanGUID: string read m_strPlanGUID write SetPlanGUID;
  end;

var
  frmSignin: TfrmSignin;

implementation

{$R *.dfm}
uses
  uPlan, uFrmFingerVerify, uDataModule, uFrmTestDrink, uDrink;
{ TfrmSignin }

procedure TfrmSignin.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmSignin.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmSignin.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSignin.btnMainFingerClick(Sender: TObject);
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      lblMainDriver.Color := clRed;
      edtMainDriver.Text := frmFingerVerify.edtTrainmanName.Text + '[' + frmFingerVerify.edtTrainmanNumber.Text + ']';
      edtMainDriverState.Text := '����';
      m_MainTrainman.GUID := frmFingerVerify.TrainmanGUID;
      m_MainTrainman.TrainmanNumber := frmFingerVerify.edtTrainmanNumber.Text;
      m_MainTrainman.TrainmanName := frmFingerVerify.edtTrainmanName.Text;
      m_nMainVerify := 1;
      CombMainDrinkResult.ItemIndex := 0;
    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmSignin.btnMainInputClick(Sender: TObject);
var
  mainNumber: string;
  trainman: RTrainman;
begin
  if Application.MessageBox('��ȷ��Ҫ������֤��', '��ʾ', MB_OKCANCEL) = mrCancel then exit;
  mainNumber := InputBox('�����빤��', '��������˾������', '');
  if mainNumber = '' then exit;
  trainman := TTrainmanOpt.GetTrainmanByNumber(mainNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('����ĳ���Ա����', '��ʾ', MB_OK);
    exit;
  end;
  lblMainDriver.Color := clRed;
  edtMainDriver.Text := trainman.TrainmanName + '[' + trainman.TrainmanNumber + ']';
  edtMainDriverState.Text := '����';
  m_MainTrainman := trainman;
  CombMainDrinkResult.ItemIndex := 0;
  m_nMainVerify := 2;
end;

procedure TfrmSignin.btnSaveClick(Sender: TObject);
begin
  if (m_MainTrainman.GUID = '') and (m_SubTrainman.GUID = '') then
  begin
    Application.MessageBox('û��ǩ����˾����', '��ʾ', MB_OK);
    exit;
  end;

  if (m_MainTrainman.GUID <> '') then
  begin
    if (CombMainDrinkResult.ItemIndex <= 0) then
    begin
      if Application.MessageBox('��˾����δ��ƣ�ȷ��Ҫ������?', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
        exit;
    end;

  end;

  if (m_SubTrainman.GUID <> '') then
  begin
    if (CombSubDrinkResult.ItemIndex <= 0) then
      if Application.MessageBox('��˾����δ��ƣ�ȷ��Ҫ������?', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
        exit;
  end;

  if Application.MessageBox('��ȷ��Ҫ������', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  if not TDBPlan.Signin(m_strPlanGUID, m_MainTrainman.GUID, m_nMainVerify, CombMainDrinkResult.ItemIndex, m_SubTrainman.GUID, m_nSubVerify, CombSubDrinkResult.ItemIndex) then
  begin
    Application.MessageBox('ǩ��ʧ�ܡ�', '��ʾ', MB_OK);
    exit;
  end;
  Application.MessageBox('ǩ���ɹ���', '��ʾ', MB_OK);
  ModalResult := mrOk;
end;

procedure TfrmSignin.btnSubCancelClick(Sender: TObject);
var
  adoQuery: TADOQuery;
  errorMsg: string;
begin
  if m_strPlanGUID = '' then exit;
  if Application.MessageBox('��ȷ��Ҫ������˾����ǩ����Ϣ��', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  TDBPlan.GetSigninByGUID(m_strPlanGUID, adoQuery);
  try
    if adoQuery.RecordCount = 0 then
    begin
      Application.MessageBox('��Ч��ǿ�ݼƻ�', '����', MB_OK + MB_ICONERROR);
      exit;
    end;
    if not TDBPlan.CancelSignin(m_strPlanGUID, adoQuery.FieldByName('strSubDriverGUID').AsString, errorMsg) then
    begin
      Application.MessageBox(Pchar(errorMsg), '����ʧ��', MB_OK + MB_ICONERROR);
      exit;
    end;
    Application.MessageBox('�����ɹ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    SetPlanGUID(m_strPlanGUID);
  finally
    adoQuery.Free;
  end;
end;

procedure TfrmSignin.btnSubDrinkClick(Sender: TObject);
var
  drink: RDrink;
begin
  if m_SubTrainman.GUID = '' then
  begin
    Application.MessageBox('����¼��ָ�ƻ����빤��', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
      drink.DrinkType := dteSignin;
      //(��)
      drink.TrainmanNumber := m_SubTrainman.TrainmanNumber;
      
      TDrinkOpt.AddDrink(drink);
      CombSubDrinkResult.ItemIndex := drink.DrinkResult;
    end;
  finally
    drink.Free;
  end;
end;

procedure TfrmSignin.btnSubFingerClick(Sender: TObject);
begin
  frmFingerVerify := TfrmFingerVerify.Create(nil);
  try
    if frmFingerVerify.ShowModal = mrOk then
    begin
      lblSubDriver.Color := clRed;
      edtSubDriver.Text := frmFingerVerify.edtTrainmanName.Text + '[' + frmFingerVerify.edtTrainmanNumber.Text + ']';
      edtSubDriverState.Text := '����';
      m_SubTrainman.GUID := frmFingerVerify.TrainmanGUID;
      m_SubTrainman.TrainmanNumber := frmFingerVerify.edtTrainmanNumber.Text;
      m_SubTrainman.TrainmanName := frmFingerVerify.edtTrainmanName.Text;
      m_nSubVerify := 1;
      CombSubDrinkResult.ItemIndex := 0;
    end;
  finally
    frmFingerVerify.Free;
  end;
end;

procedure TfrmSignin.btnSubInputClick(Sender: TObject);
var
  subNumber: string;
  trainman: RTrainman;
begin
  if Application.MessageBox('��ȷ��Ҫ������֤��', '��ʾ', MB_OKCANCEL) = mrCancel then exit;
  subNumber := InputBox('�����빤��', '�����븱˾������', '');
  if subNumber = '' then exit;

  trainman := TTrainmanOpt.GetTrainmanByNumber(subNumber);
  if trainman.GUID = '' then
  begin
    Application.MessageBox('����ĳ���Ա����', '��ʾ', MB_OK);
    exit;
  end;
  lblSubDriver.Color := clRed;
  edtSubDriver.Text := trainman.TrainmanName + '[' + trainman.TrainmanNumber + ']';
  edtSubDriverState.Text := '����';
  m_SubTrainman := trainman;
  CombSubDrinkResult.ItemIndex := 0;
  m_nSubVerify := 2;
end;

procedure TfrmSignin.FormCreate(Sender: TObject);
begin
  m_strPlanGUID := '';

  m_MainTrainman.Init;
  m_nMainVerify := 0;

  m_SubTrainman.Init;
  m_nSubVerify := 0;

  btnSave.Enabled := false;
end;


procedure TfrmSignin.lblEditTrainmanClick(Sender: TObject);
var
  bUserCancel: boolean;
begin
  bUserCancel := false;
  if DMGlobal.EditTrainmanInfo(bUserCancel) then
  begin

  end;
end;

procedure TfrmSignin.SetPlanGUID(const Value: string);
var
  ado: TADOQuery;
begin
  m_strPlanGUID := value;

  btnMainCancel.Visible := false;
  btnSubCancel.Visible := false;

  edtMainDriver.Text := '';
  edtMainDriverState.Text := '';
  edtMainSigninTime.Text := '';
  CombMainDrinkResult.ItemIndex := 0;

  edtSubDriver.Text := '';
  edtSubDriverState.Text := '';
  edtSubSigninTime.Text := '';
  CombSubDrinkResult.ItemIndex := 0;

  btnMainInput.Visible := false;
  btnMainFinger.Visible := false;
  btnMainDrink.Visible := false;

  btnSubInput.Visible := false;
  btnSubFinger.Visible := false;
  btnSubDrink.Visible := false;

  btnSave.Enabled := false;
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  try
    with ado do
    begin
      if RecordCount > 0 then
      begin
        //������Ϣ
        edtTrainNo.Text := FieldByName('strTrainNo').AsString;
        edtTrainmanTypeName.Text := FieldByName('strTrainmanTypeName').AsString;
        edtSigninTime.Text := FormatDateTime('yyyy-MM-dd HH:nn', FieldByName('dtSigninTime').AsDateTime);
        edtCallTime.Text := FormatDateTime('yyyy-MM-dd HH:nn', FieldByName('dtCallTime').AsDateTime);
        edtOutDutyTime.Text := FormatDateTime('yyyy-MM-dd HH:nn', FieldByName('dtOutDutyTime').AsDateTime);
        edtStartTime.Text := FormatDateTime('yyyy-MM-dd HH:nn', FieldByName('dtStartTime').AsDateTime);
        btnMainInput.Visible := true;
        btnMainFinger.Visible := true;
        btnMainDrink.Visible := true;
        if FieldByName('strMainDriverGUID').AsString <> '' then
        begin
          edtMainDriver.Text := FieldByName('strMainDriverName').AsString + '[' + FieldByName('strMainDriverNumber').AsString + ']';
          edtMainDriverState.Text := FieldByName('strMainDriverStateName').AsString;
          edtMainSigninTime.Text := FieldByName('dtMainSigninTime').AsString;
          CombMainDrinkResult.ItemIndex := FieldByName('nMainDrinkResult').AsInteger;
          btnMainInput.Visible := false;
          btnMainFinger.Visible := false;
          btnMainDrink.Visible := false;
          //ֻ�д�����ǩ����˾�����ܳ���ǩ��
          if FieldByName('nMainDriverState').AsInteger = Ord(pseSignin) then
          begin
            btnMainCancel.Visible := true;
          end;
          CombMainDrinkResult.Enabled := false;
        end;
        if FieldByName('nTrainmanTypeID').AsInteger = 2 then
        begin
          btnSubInput.Visible := true;
          btnSubFinger.Visible := true;
          btnSubDrink.Visible := true;
          if FieldByName('strSubDriverGUID').AsString <> '' then
          begin
            edtSubDriver.Text := FieldByName('strSubDriverName').AsString + '[' + FieldByName('strSubDriverNumber').AsString + ']';
            edtSubDriverState.Text := FieldByName('strSubDriverStateName').AsString;
            edtSubSigninTime.Text := FieldByName('dtSubSigninTime').AsString;
            CombSubDrinkResult.ItemIndex := FieldByName('nSubDrinkResult').AsInteger;
            btnSubInput.Visible := false;
            btnSubFinger.Visible := false;
            btnSubDrink.Visible := false;
            //ֻ�д�����ǩ����˾�����ܳ���ǩ��
            if FieldByName('nSubDriverState').AsInteger = Ord(pseSignin) then
            begin
              btnSubCancel.Visible := true;
            end;
            CombSubDrinkResult.Enabled := false;
          end;
          btnSave.Enabled := true;
          if (FieldByName('strMainDriverGUID').AsString <> '') and (FieldByName('strSubDriverGUID').AsString <> '') then
            btnSave.Enabled := false;
        end
        else begin
          pSubDriver.Visible := false;
          btnSave.Enabled := true;
          if (FieldByName('strMainDriverGUID').AsString <> '') then
            btnSave.Enabled := false;
        end;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmSignin.btnMainCancelClick(Sender: TObject);
var
  adoQuery: TADOQuery;
  errorMsg: string;
begin
  if m_strPlanGUID = '' then exit;
  if Application.MessageBox('��ȷ��Ҫ������˾����ǩ����Ϣ��', '��ʾ', MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  TDBPlan.GetSigninByGUID(m_strPlanGUID, adoQuery);
  try
    if adoQuery.RecordCount = 0 then
    begin
      Application.MessageBox('��Ч��ǿ�ݼƻ�', '����', MB_OK + MB_ICONERROR);
      exit;
    end;
    if not TDBPlan.CancelSignin(m_strPlanGUID, adoQuery.FieldByName('strMainDriverGUID').AsString, errorMsg) then
    begin
      Application.MessageBox(Pchar(errorMsg), '����ʧ��', MB_OK + MB_ICONERROR);
      exit;
    end;
    Application.MessageBox('�����ɹ�', '��ʾ', MB_OK + MB_ICONINFORMATION);
    SetPlanGUID(m_strPlanGUID);
  finally
    adoQuery.Free;
  end;
end;

procedure TfrmSignin.btnMainDrinkClick(Sender: TObject);
var
  drink: RDrink;
begin
  if m_MainTrainman.GUID = '' then
  begin
    Application.MessageBox('����¼��ָ�ƻ����빤��', '��ʾ', MB_OK + MB_ICONINFORMATION);
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
      drink.DrinkType := dteSignin;
      //(��)
      drink.TrainmanNumber := m_MainTrainman.TrainmanNumber;
      
      TDrinkOpt.AddDrink(drink);
      CombMainDrinkResult.ItemIndex := drink.DrinkResult;
    end;
  finally
    drink.Free;
  end;
end;

end.

