unit uFrmDisconnectHint;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, pngimage, ActnList;

type
  TFrmDisconnectHint = class(TForm)
    Panel1: TPanel;
    Bevel1: TBevel;
    btnExit: TBitBtn;
    btnChange: TBitBtn;
    lblInfo1: TLabel;
    lblInfo2: TLabel;
    lblInfo3: TLabel;
    Image1: TImage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnChangeClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FOnChangeMode: TNotifyEvent;
    FOnExitSystem: TNotifyEvent;
    blnClose: boolean;
  public
    { Public declarations }
    class function ShowForm(): TModalResult;
    procedure CloseForm;
    property OnChangeMode: TNotifyEvent read FOnChangeMode write FOnChangeMode;
    property OnExitSystem: TNotifyEvent read FOnExitSystem write FOnExitSystem;
  end;

var
  FrmDisconnectHint: TFrmDisconnectHint;

implementation

{$R *.dfm}

{ TFrmDisconnectHint }
           
class function TFrmDisconnectHint.ShowForm: TModalResult;
begin
  result:= mrOk;
  if FrmDisconnectHint = nil then
  begin
    FrmDisconnectHint := TFrmDisconnectHint.Create(nil);
    FrmDisconnectHint.Show;
  end
  else
  begin
    FrmDisconnectHint.Show;
  end;
end;

procedure TFrmDisconnectHint.FormCreate(Sender: TObject);
begin
  blnClose := false;
end;

procedure TFrmDisconnectHint.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  action := caFree;
  FrmDisconnectHint := nil;
end;

procedure TFrmDisconnectHint.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := blnClose;
end;

procedure TFrmDisconnectHint.btnChangeClick(Sender: TObject);
begin
  if Assigned(OnChangeMode) then OnChangeMode(self);
  CloseForm;
end;

procedure TFrmDisconnectHint.btnExitClick(Sender: TObject);
begin   
  if Assigned(FOnExitSystem) then FOnExitSystem(self);  
  CloseForm;
end;
     
procedure TFrmDisconnectHint.CloseForm;
begin
  blnClose := true;
  Close;
end;

end.
