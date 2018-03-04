unit uFrmPlanDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ExtCtrls, StdCtrls, RzPanel, Buttons,ADODB,DateUtils;

type
  TfrmPlanDetail = class(TForm)
    actLstLogin: TActionList;
    actCancel: TAction;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    edtTrainNo: TEdit;
    Label8: TLabel;
    edtSigninTime: TEdit;
    Label3: TLabel;
    edtCallTime: TEdit;
    edtStartTime: TEdit;
    Label2: TLabel;
    edtOutDutyTime: TEdit;
    Label9: TLabel;
    edtTrainmanTypeName: TEdit;
    Label5: TLabel;
    edtMainDriver: TEdit;
    lblMainDriver: TLabel;
    Label4: TLabel;
    edtMainDriverState: TEdit;
    Label6: TLabel;
    edtMainSigninTime: TEdit;
    Label7: TLabel;
    edtMainSigninVerifyName: TEdit;
    Label10: TLabel;
    edtMainSigninDutyUser: TEdit;
    Label11: TLabel;
    edtMainInTime: TEdit;
    Label12: TLabel;
    edtMainInVerifyName: TEdit;
    Label13: TLabel;
    edtMainInDutyUser: TEdit;
    Label14: TLabel;
    edtMainOutTime: TEdit;
    Label15: TLabel;
    edtMainOutVerifyName: TEdit;
    Label16: TLabel;
    edtMainOutDutyUser: TEdit;
    Label17: TLabel;
    edtMainOutDutyTime: TEdit;
    Label18: TLabel;
    edtMainOutDutyVerifyName: TEdit;
    Label19: TLabel;
    edtMainOutDutyDutyUser: TEdit;
    edtMainSigninDrinkResult: TEdit;
    Label20: TLabel;
    Label23: TLabel;
    edtMainOutDutyDrinkResult: TEdit;
    GroupSubDriver: TGroupBox;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label41: TLabel;
    edtSubDriver: TEdit;
    edtSubDriverState: TEdit;
    edtSubSigninTime: TEdit;
    edtSubSigninVerifyName: TEdit;
    edtSubSigninDutyUser: TEdit;
    edtSubInTime: TEdit;
    edtSubInVerifyName: TEdit;
    edtSubInDutyUser: TEdit;
    edtSubOutTime: TEdit;
    edtSubOutVerifyName: TEdit;
    edtSubOutDutyUser: TEdit;
    edtSubOutDutyTime: TEdit;
    edtSubOutDutyVerifyName: TEdit;
    edtSubOutDutyDutyUser: TEdit;
    edtSubSigninDrinkResult: TEdit;
    edtSubRoomNumber: TEdit;
    edtSubOutDutyDrinkResult: TEdit;
    Label42: TLabel;
    edtSubRestLength: TEdit;
    Label43: TLabel;
    edtMainRestLength: TEdit;
    btnCancel: TSpeedButton;
    edtRestLength: TEdit;
    Label44: TLabel;
    edtMainRoomNumber: TEdit;
    Label22: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
    m_strPlanGUID : string;
    procedure SetPlanGUID(const Value: string);
  public
    { Public declarations }
     property PlanGUID : string read m_strPlanGUID write SetPlanGUID;
  end;

var
  frmPlanDetail: TfrmPlanDetail;

implementation

{$R *.dfm}
uses
  uTrainMan,uPlan,uDataModule, DB;
  
procedure TfrmPlanDetail.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmPlanDetail.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPlanDetail.SetPlanGUID(const Value: string);
var
  ado,adoInOutRoom,adoOutDuty : TADOQuery;
  tempTime : TDateTime;
begin
  if m_strPlanGUID = Value then exit;
  m_strPlanGUID := value;
  TDBPlan.GetSigninByGUID(m_strPlanGUID, ado);
  TDBPlan.GetCallsByGUID(m_strPlanGUID,adoInOutRoom);
  TDBPlan.GetOutDutyByGUID(m_strPlanGUID,adoOutDuty);
  try
    with ado do
    begin
      if RecordCount > 0 then
      begin
        {$region '车次信息'}
        edtTrainNo.Text := FieldByName('strTrainNo').AsString;
        edtTrainmanTypeName.Text := FieldByName('strTrainmanTypeName').AsString;
        edtSigninTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtSigninTime').AsDateTime);
        edtCallTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtCallTime').AsDateTime);
        edtOutDutyTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtOutDutyTime').AsDateTime);
        edtStartTime.Text := FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtStartTime').AsDateTime);
        tempTime := FieldByName('dtCallTime').AsDateTime - FieldByName('dtSigninTime').AsDateTime;
        edtRestLength.Text := Format('%d时%d分',[HourOf(tempTime),MinuteOf(tempTime)]);
        {$endregion '车次信息'}

        {$region '正司机信息'}
        if FieldByName('nMainDriverState').AsInteger > 1 then
        begin
          edtMainDriver.Text := Format('%s[%s]',[FieldByName('strMainDriverName').AsString,FieldByName('strMainDriverNumber').AsString]);
          edtMainDriverState.Text := FieldByName('strMainDriverStateName').AsString;
          edtMainSigninTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',FieldByName('dtMainSignInTime').AsDateTime);
          edtMainSigninVerifyName.Text := FieldByName('strMainVerifyName').AsString;
          edtMainSigninDrinkResult.Text := FieldByName('strMainDrinkResultName').AsString;
          edtMainSigninDutyUser.Text := Format('%s[%s]',[FieldByName('strMainSigninDutyName').AsString,FieldByName('strMainSigninDutyNumber').AsString]) ;
        end;

        if FieldByName('nMainDriverState').AsInteger > 2 then
        begin
          edtMainInTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoInOutRoom.FieldByName('dtMainInTime').AsDateTime);
          edtMainInVerifyName.Text := adoInOutRoom.FieldByName('strMainInVerifyName').AsString;
          edtMainRoomNumber.Text := adoInOutRoom.FieldByName('strRoomNumber').AsString;
          edtMainInDutyUser.Text := Format('%s[%s]',[adoInOutRoom.FieldByName('strMainInDutyName').AsString,adoInOutRoom.FieldByName('strMainInDutyNumber').AsString]) ;
        end;

        if FieldByName('nMainDriverState').AsInteger > 3 then
        begin
          edtMainOutTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoInOutRoom.FieldByName('dtMainOutTime').AsDateTime);
          edtMainOutVerifyName.Text := adoInOutRoom.FieldByName('strMainOutVerifyName').AsString;
          tempTime := adoInOutRoom.FieldByName('dtMainOutTime').AsDateTime - adoInOutRoom.FieldByName('dtMainInTime').AsDateTime;
          edtMainRestLength.Text := Format('%d时%d分',[HourOf(tempTime),MinuteOf(tempTime)]);
          edtMainOutDutyUser.Text := Format('%s[%s]',[adoInOutRoom.FieldByName('strMainOutDutyName').AsString,adoInOutRoom.FieldByName('strMainOutDutyNumber').AsString]) ;
        end;
        if FieldByName('nMainDriverState').AsInteger > 4 then
        begin
          edtMainOutDutyTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoOutDuty.FieldByName('dtMainDriverOutDutyTime').AsDateTime);
          edtMainOutDutyVerifyName.Text := adoOutDuty.FieldByName('strMainVerifyName').AsString;
          edtMainOutDutyDrinkResult.Text := adoOutDuty.FieldByName('strMainDrinkResultName').AsString;
          edtMainOutDutyDutyUser.Text := Format('%s[%s]',[adoOutDuty.FieldByName('strMainOutDutyDutyName').AsString,adoOutDuty.FieldByName('strMainOutDutyDutyNumber').AsString]) ;
        end;
        {$endregion '正司机信息'}


        {$region '副司机信息'}
        if FieldByName('nTrainmanTypeID').AsInteger = 1 then
        begin

          GroupSubDriver.Visible := false;
           exit;
        end;
        
        if FieldByName('nSubDriverState').AsInteger > 1 then
        begin
          edtSubDriver.Text := Format('%s[%s]',[FieldByName('strSubDriverName').AsString,FieldByName('strSubDriverNumber').AsString]);
          edtSubDriverState.Text := FieldByName('strSubDriverStateName').AsString;
          edtSubSigninTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',FieldByName('dtSubSignInTime').AsDateTime);
          edtSubSigninVerifyName.Text := FieldByName('strSubVerifyName').AsString;
          edtSubSigninDrinkResult.Text := FieldByName('strSubDrinkResultName').AsString;
          edtSubSigninDutyUser.Text := Format('%s[%s]',[FieldByName('strSubSigninDutyName').AsString,FieldByName('strSubSigninDutyNumber').AsString]) ;
        end;

        if FieldByName('nSubDriverState').AsInteger > 2 then
        begin
          edtSubInTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoInOutRoom.FieldByName('dtSubInTime').AsDateTime);
          edtSubInVerifyName.Text := adoInOutRoom.FieldByName('strSubInVerifyName').AsString;
          edtSubRoomNumber.Text := adoInOutRoom.FieldByName('strRoomNumber').AsString;
          edtSubInDutyUser.Text := Format('%s[%s]',[adoInOutRoom.FieldByName('strSubInDutyName').AsString,adoInOutRoom.FieldByName('strSubInDutyNumber').AsString]) ;
        end;

        if FieldByName('nSubDriverState').AsInteger > 3 then
        begin
          edtSubOutTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoInOutRoom.FieldByName('dtSubOutTime').AsDateTime);
          edtSubOutVerifyName.Text := adoInOutRoom.FieldByName('strSubOutVerifyName').AsString;
          tempTime := adoInOutRoom.FieldByName('dtSubOutTime').AsDateTime - adoInOutRoom.FieldByName('dtSubInTime').AsDateTime;
          edtSubRestLength.Text := Format('%d时%d分',[HourOf(tempTime),MinuteOf(tempTime)]);
          edtSubOutDutyUser.Text := Format('%s[%s]',[adoInOutRoom.FieldByName('strSubOutDutyName').AsString,adoInOutRoom.FieldByName('strSubOutDutyNumber').AsString]) ;
        end;

        if FieldByName('nSubDriverState').AsInteger > 4 then
        begin
          edtSubOutDutyTime.Text := FormatDateTime('yyyy-MM-dd HH:nn:ss',adoOutDuty.FieldByName('dtSubDriverOutDutyTime').AsDateTime);
          edtSubOutDutyVerifyName.Text := adoOutDuty.FieldByName('strSubVerifyName').AsString;
          edtSubOutDutyDrinkResult.Text := adoOutDuty.FieldByName('strSubDrinkResultName').AsString;
          edtSubOutDutyDutyUser.Text := Format('%s[%s]',[adoOutDuty.FieldByName('strSubOutDutyDutyName').AsString,adoOutDuty.FieldByName('strSubOutDutyDutyNumber').AsString]) ;
        end;
        {$endregion '副司机信息'}

      end;
    end;
  finally
    ado.Free;
    adoInOutRoom.Free;
    adoOutDuty.Free;
  end;
end;

end.
