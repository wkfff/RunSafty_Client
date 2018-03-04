unit uFrmErrorAlarm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TfrmErrorAlarm = class(TForm)
    Panel1: TPanel;
    lblErrorMsg: TLabel;
    Image1: TImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmErrorAlarm: TfrmErrorAlarm;

implementation

{$R *.dfm}

procedure TfrmErrorAlarm.Button1Click(Sender: TObject);
begin
  Close;
  ModalResult := mrNone;
end;

end.
