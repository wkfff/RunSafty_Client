unit uFrmGetDateTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls,utfsystem;

type
  TFrmGetDateTime = class(TForm)
    dtpDate: TDateTimePicker;
    btnOk: TButton;
    btnCancel: TButton;
    dtpTime: TDateTimePicker;
    lb1: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    procedure InitData(Date:TDateTime);
  private
    { Private declarations }
    m_dtDate:TDateTime ;
  public
    { Public declarations }
    class function GetDateTime(var DateTime:TDateTime):Boolean;
  end;

var
  FrmGetDateTime: TFrmGetDateTime;

implementation

{$R *.dfm}

procedure TFrmGetDateTime.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmGetDateTime.btnOkClick(Sender: TObject);
begin
  m_dtDate := AssembleDateTime(dtpDate.Date,dtpTime.Time) ;
  ModalResult := mrOk ;
end;

class function TFrmGetDateTime.GetDateTime(var DateTime:TDateTime):boolean;
var
  frm : TFrmGetDateTime ;
begin
  Result := false ;
  frm := TFrmGetDateTime.Create(nil);
  try
    frm.InitData(DateTime);
    if frm.ShowModal  = mrOk then
    begin
      DateTime := frm.m_dtDate  ;
      Result := True ;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmGetDateTime.InitData(Date: TDateTime);
begin
  dtpDate.Date := Date ;
  dtpTime.Time := Date ;
end;

end.
