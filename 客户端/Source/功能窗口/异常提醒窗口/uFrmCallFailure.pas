unit uFrmCallFailure;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, pngimage, ExtCtrls;

type
  TfrmCallFailure = class(TForm)
    Panel1: TPanel;
    lblErrorMsg: TLabel;
    Image1: TImage;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCallFailure: TfrmCallFailure;

implementation

{$R *.dfm}

procedure TfrmCallFailure.Button1Click(Sender: TObject);
begin
  cLOSE;
end;

procedure TfrmCallFailure.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

end.
