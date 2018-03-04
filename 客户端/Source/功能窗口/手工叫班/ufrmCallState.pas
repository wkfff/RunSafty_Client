unit ufrmCallState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uCallControl, Buttons, StdCtrls, ExtCtrls;

type
  TfrmCallState = class(TForm)
    btnStop: TSpeedButton;
    btnClose: TSpeedButton;
    lblState: TLabel;
    tmr: TTimer;
    procedure tmrTimer(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
    m_CallControl: TCallControl;
    m_nDeveiceID: Integer;
    m_nRoomID: Integer;
  private
    function GetCallState(): string;
  public
    { Public declarations }
  published
    property CallControl: TCallControl read m_CallControl write m_CallControl;
    property DeveiceID: Integer read m_nDeveiceID write m_nDeveiceID;
    property RoomID: Integer read m_nRoomID write m_nRoomID;
  end;

var
  frmCallState: TfrmCallState;

implementation

{$R *.dfm}

procedure TfrmCallState.btnCloseClick(Sender: TObject);
begin
  tmr.Enabled := false;
  Close;
end;

procedure TfrmCallState.btnStopClick(Sender: TObject);
begin
  if m_CallControl.Hangup(m_nDeveiceID) = 1 then
  begin
    Application.MessageBox('�һ��ɹ�', '��ʾ', MB_OK +
      MB_ICONINFORMATION);
    Close;
  end
  else
  begin
    Application.MessageBox('�һ�ʧ��', '��ʾ', MB_OK +
      MB_ICONINFORMATION);
  end;
end;

function TfrmCallState.GetCallState: string;
var
  rst: integer;
  devnum: word;
begin
  rst := CallControl.QueryCallDevState(devnum);
  if (rst = 1) and (devnum = 0) then
  begin
    Result := 'û�к���';
  end
  else
  begin
    case rst of
      1: Result := '���� ' + IntToStr(m_nRoomID) + ' ����ͨ����';
      2: Result := '���� ' + IntToStr(m_nRoomID) + ' �Ҷ�';
      3: Result := '���� ' + IntToStr(m_nRoomID) + ' ���ں���';
    else
      Result := 'Serial Port error:' + IntToStr(rst);
    end;
  end;
end;

procedure TfrmCallState.tmrTimer(Sender: TObject);
begin
  lblState.Caption := GetCallState;
end;

end.

