unit uFrmAnnualLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzEdit;

type
  TFrmAnnualLog = class(TForm)
    memLog: TRzMemo;
    Bevel1: TBevel;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function InputLog(var log: string): Boolean;
  end;


implementation

uses uGlobalDM;

{$R *.dfm}

{ TFrmAnnualLog }

procedure TFrmAnnualLog.Button1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

procedure TFrmAnnualLog.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

class function TFrmAnnualLog.InputLog(var log: string): Boolean;
var
  FrmAnnualLog: TFrmAnnualLog;
begin
  FrmAnnualLog := TFrmAnnualLog.Create(NIL);
  try
    Result := FrmAnnualLog.ShowModal = mrOk;

    if Result then
      log := FrmAnnualLog.memLog.Text;      
  finally
    FrmAnnualLog.Free;
  end;
end;

end.
