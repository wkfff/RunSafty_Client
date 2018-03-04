unit uFrmInputDutyTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, AdvDateTimePicker, StdCtrls,uCallRoomDM,uTFSystem,DateUtils;

type
  TfrmInputDutyTime = class(TForm)
    btnOK: TButton;
    btnCancel: TButton;
    lbl1: TLabel;
    dtpDutyTime: TAdvDateTimePicker;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    {����ʱ��}
    m_dtDutyTime: TDateTime;
  public
    { Public declarations }
  end;

function ShowFrmInPutDutyTime(out dtDutyTime: TDateTime): Boolean;

implementation

uses
  uGlobalDM ;

function ShowFrmInPutDutyTime(out dtDutyTime: TDateTime): Boolean;
var
  frmInputDutyTime: TfrmInputDutyTime;
begin
  Result := False;
  frmInputDutyTime := TfrmInputDutyTime.Create(nil);
  try
    if frmInputDutyTime.ShowModal = mrOk then
    begin
      dtDutyTime := frmInputDutyTime.m_dtDutyTime;
      Result := True;
    end;  
  finally
    frmInputDutyTime.Free;
  end;
end;
{$R *.dfm}

procedure TfrmInputDutyTime.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmInputDutyTime.btnOKClick(Sender: TObject);
begin
  if dtpDutyTime.DateTime <= GlobalDM.GetNow then
  begin
    Box('����ʱ�䲻��С�ڵ�ǰʱ��');
    Exit;
  end;
  m_dtDutyTime := dtpDutyTime.DateTime;
  ModalResult := mrOk;
end;

procedure TfrmInputDutyTime.FormShow(Sender: TObject);
begin
  dtpDutyTime.DateTime := IncMinute(GlobalDM.GetNow,10);
end;

end.
