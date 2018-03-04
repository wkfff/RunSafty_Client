unit nFrmInRomm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel,ADODB;

type
  TfrmInRoom = class(TForm)
    rzgrpbx2: TRzGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    lblMainDriver: TLabel;
    Label4: TLabel;
    lblSubDriver: TLabel;
    Label6: TLabel;
    edtTrainNo: TEdit;
    edtStartTime: TEdit;
    edtMainDriver: TEdit;
    edtMainDriverState: TEdit;
    edtSubDriver: TEdit;
    edtSubDriverState: TEdit;
    btnCancel: TButton;
    btnSave: TButton;
    RzGroupBox1: TRzGroupBox;
    Label3: TLabel;
    CombRoom: TComboBox;
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_strDriverGUID : string;
    procedure SetDriverGUID(const Value: string);
  public
    { Public declarations }
    property DriverGUID : string read m_strDriverGUID write SetDriverGUID;
  end;

var
  frmInRoom: TfrmInRoom;

implementation

{$R *.dfm}

{ TfrmInRoom }
uses
  uTrainMan,uPlan;
procedure TfrmInRoom.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmInRoom.btnSaveClick(Sender: TObject);
var
  trainMan : RTrainman;
begin
  trainMan := TTrainmanOpt.GetTrainman(m_strDriverGUID);
  if trainMan.GUID = '' then exit;
  if not TPlanOpt.InRoom(trainMan.GUID) then
  begin
    Application.MessageBox('入寓失败。','提示',MB_OK);
    exit;
  end;
  Application.MessageBox('入寓成功。','提示',MB_OK);
  ModalResult := mrOk;
end;

procedure TfrmInRoom.FormCreate(Sender: TObject);
begin
  btnSave.Enabled := false;
  CombRoom.Enabled := false;
end;

procedure TfrmInRoom.SetDriverGUID(const Value: string);
var
  trainMan : RTrainman;
  ado : TADOQuery;
begin
  if m_strDriverGUID = Value then exit;
  m_strDriverGUID := value;
  trainMan := TTrainmanOpt.GetTrainman(Value);
  if trainMan.GUID <> '' then
  begin
    ado := TPlanOpt.GetTrainmanPlan(trainman.GUID);
    try
      with ado do
      begin
        if RecordCount > 0 then
        begin
          edtTrainNo.Text := FieldByName('strTrainNo').AsString;
          edtStartTime.Text := FormatDateTime('yyyy-MM-dd HH:mm',FieldByName('dtStartTime').AsDateTime);
          edtMainDriver.Text := FieldByName('strMainDriverName').AsString + '[' +FieldByName('strMainDriverNumber').AsString+ ']';
          edtMainDriverState.Text := FieldByName('strMainDriverStateName').AsString;
          edtSubDriver.Text := FieldByName('strSubDriverName').AsString + '[' +FieldByName('strSubDriverNumber').AsString+ ']';
          edtSubDriverState.Text := FieldByName('strSubDriverStateName').AsString;
          if trainMan.GUID = FieldByName('strMainDriverGUID').AsString then
          begin
            lblMainDriver.Font.Color := clRed;
          end;
          if trainMan.GUID = FieldByName('strSubDriverGUID').AsString then
          begin
            lblSubDriver.Font.Color := clRed;
          end;
          btnSave.Enabled := true;
        end;
      end;
    finally
      ado.Free;
    end;
  end;
end;

end.
