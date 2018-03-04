unit uFrmOutWorkChoice;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, PngSpeedButton, ExtCtrls, RzPanel;

type
  TOnFingerOP =(TOF_NONE{取消},TOF_SIGN{签点},TOF_AlC);
  TFrmOutWorkChoice = class(TForm)
    lbl1: TLabel;
    rzpnl1: TRzPanel;
    btnDrinkTest: TPngSpeedButton;
    btnTuiQin: TPngSpeedButton;
    btnExit: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDrinkTestClick(Sender: TObject);
    procedure btnTuiQinClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
  private
     m_onFingerOp:TOnFingerOP;
  public

  end;

  {功能:退勤指纹识别后操作选择}
  function OutWorkOnFingerOP():TOnFingerOP ;


implementation
function OutWorkOnFingerOP():TOnFingerOP ;
var
  FrmOutWorkChoice: TFrmOutWorkChoice;
begin
  FrmOutWorkChoice := TFrmOutWorkChoice.Create(nil);
  FrmOutWorkChoice.ShowModal;
  Result := FrmOutWorkChoice.m_onFingerOp;
end;

{$R *.dfm}

procedure TFrmOutWorkChoice.btnDrinkTestClick(Sender: TObject);
begin
  m_onFingerOp := TOF_AlC;
  ModalResult := mrOk;
end;

procedure TFrmOutWorkChoice.btnExitClick(Sender: TObject);
begin
  m_onFingerOp := TOF_NONE;
  ModalResult := mrOk;
end;

procedure TFrmOutWorkChoice.btnTuiQinClick(Sender: TObject);
begin
  m_onFingerOp:= TOF_SIGN;
  ModalResult := mrOk;
end;

procedure TFrmOutWorkChoice.FormCreate(Sender: TObject);
begin
  m_onFingerOp:= TOF_NONE;
end;

end.
