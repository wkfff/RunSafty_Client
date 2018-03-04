unit uFrmRoomSign_Maintenance;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, pngimage, ExtCtrls, StdCtrls,utfsystem,uDBAccessRoomSign;

type
  TFrmRoomSign_Maintenance = class(TForm)
    Image1: TImage;
    btnClearData: TButton;
    procedure btnClearDataClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_dbRoomSign:TRsDBAccessRoomSign;
    m_dbLeaderInspect:TRsAccessDBLeaderInspect;
  public
    { Public declarations }
  end;

var
  FrmRoomSign_Maintenance: TFrmRoomSign_Maintenance;

implementation

uses
  uGlobalDM;

{$R *.dfm}

procedure TFrmRoomSign_Maintenance.btnClearDataClick(Sender: TObject);
const
  THREE_MONTH = 90 ;
var
  dtEnd:TDateTime;
begin
  if  not TBox('ȷ�����3����֮ǰ��������?') then
    Exit ;
  dtEnd := Now - THREE_MONTH;
  //�����Ԣ����Ԣ��Ϣ
  m_dbRoomSign.DelOldInOutRecord(dtEnd);
  //��������Ϣ
  m_dbLeaderInspect.DelOldInpect(dtEnd);
  Box('������ϣ�');
end;

procedure TFrmRoomSign_Maintenance.FormCreate(Sender: TObject);
begin
  m_dbRoomSign := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);
  m_dbLeaderInspect := TRsAccessDBLeaderInspect.Create(GlobalDM.LocalADOConnection);
end;

procedure TFrmRoomSign_Maintenance.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_dbRoomSign);
  FreeAndNil(m_dbLeaderInspect);
end;

end.
