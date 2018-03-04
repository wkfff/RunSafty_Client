unit uFrmSelect;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TfrmSelect = class(TForm)
    btnConfig: TButton;
    btnCancel: TButton;
    procedure btnConfigClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
function ShowFrmSelect():Boolean;

implementation
function ShowFrmSelect():Boolean;
var
  FrmSelect: TfrmSelect;
begin
  FrmSelect := TfrmSelect.Create(nil);
  try
    if FrmSelect.ShowModal = mrOk then
      Result := True
    else
      Result := False;
  finally
    FrmSelect.Free;
  end;
end;  
{$R *.dfm}

procedure TfrmSelect.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelect.btnConfigClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
