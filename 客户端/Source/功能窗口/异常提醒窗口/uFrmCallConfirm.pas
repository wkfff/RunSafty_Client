unit uFrmCallConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmCallConfirm = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    lblHint: TLabel;
    lblCountTime: TLabel;
    Timer: TTimer;
    procedure btnOKClick(Sender: TObject);
    procedure TimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    m_strRoomNumber : string;
    m_nTick : Cardinal;
    procedure SetRoomNumber(const Value: string);
  public
    { Public declarations }
    property RoomNumber : string read m_strRoomNumber write SetRoomNumber;
  end;
  procedure WaitforConfirm(RoomNumber : string);
implementation
uses
  uCallRoomDM;
  procedure WaitforConfirm(RoomNumber : string);
  var
    frmCallConfirm: TfrmCallConfirm;
  begin
    frmCallConfirm:= TfrmCallConfirm.Create(nil);
    try
      frmCallConfirm.RoomNumber := RoomNumber;
      frmCallConfirm.ShowModal;
    finally
      DMCallRoom.WaitingForConfirm := false;
      frmCallConfirm.Free;
    end;
  end;
{$R *.dfm}

procedure TfrmCallConfirm.btnOKClick(Sender: TObject);
begin
  Timer.Enabled := false;  
  ModalResult := mrOk;
end;

procedure TfrmCallConfirm.FormCreate(Sender: TObject);
begin
  m_nTick := GetTickCount;
  lblCountTime.Caption := Format('����ͨ���Զ��Ҷϻ�ʣ��%d/60��',[60]);
end;

procedure TfrmCallConfirm.SetRoomNumber(const Value: string);
begin
  m_strRoomNumber := Value;
  lblHint.Caption := Format('��ʾ����ǰ������%s����ͨ��������ͨ����Ϻ�Ҷ����ӣ�',[m_strRoomNumber]);
end;

procedure TfrmCallConfirm.TimerTimer(Sender: TObject);
var
  nTimeOffset : Integer;
begin
  nTimeOffset := GetTickCount - m_nTick;
  nTimeOffset := nTimeOffset div 1000;
  nTimeOffset := 60 - nTimeOffset;
  lblCountTime.Caption := Format('����ͨ���Զ��Ҷϻ�ʣ��%d/60��',[nTimeOffset]);
  if nTimeOffset <=0 then
  begin
    Timer.Enabled := false;  
    ModalResult := mrOk;
  end;
end;

end.
