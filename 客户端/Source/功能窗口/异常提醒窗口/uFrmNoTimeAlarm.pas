unit uFrmNoTimeAlarm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, pngimage, ExtCtrls, StdCtrls;

type
  TfrmNoTimeAlarm = class(TForm)
    lblErrorAlarm: TLabel;
    Image1: TImage;
    btnOK: TSpeedButton;
    btnCancel: TSpeedButton;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmNoTimeAlarm: TfrmNoTimeAlarm;

  function AlarmNoTime():boolean;
implementation
  function AlarmNoTime():boolean;
  begin
    Result := false;
    frmNoTimeAlarm := TfrmNoTimeAlarm.Create(nil);
    if frmNoTimeAlarm.ShowModal = mrCancel then exit;
    Result := true;
  end;
{$R *.dfm}

procedure TfrmNoTimeAlarm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmNoTimeAlarm.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
