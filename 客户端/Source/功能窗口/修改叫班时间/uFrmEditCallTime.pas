unit uFrmEditCallTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, pngimage, Buttons, PngCustomButton,
  ComCtrls, AdvDateTimePicker;

type
  TfrmEditCallTime = class(TForm)
    RzPanel1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label3: TLabel;
    Label1: TLabel;
    dtpCallTime: TAdvDateTimePicker;
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    //可添加自定义函数
    class function EditForm(var CallTime : TDateTime) : boolean;
  end;

implementation
uses
  DateUtils;
{$R *.dfm}

procedure TfrmEditCallTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmEditCallTime.btnOKClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

class function TfrmEditCallTime.EditForm(var CallTime : TDateTime): boolean;
var
  frmEditCallTime: TFrmEditCallTime;
begin
  result := false;
  frmEditCallTime:= TFrmEditCallTime.Create(nil);
  try
    frmEditCallTime.dtpCallTime.DateTime := CallTime;
    if frmEditCallTime.ShowModal = mrCancel then exit;
    CallTime := frmEditCallTime.dtpCallTime.DateTime;
    Result := true;    
  finally
    frmEditCallTime.Free;
  end;
end;

end.
