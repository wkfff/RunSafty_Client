unit uFrmGetInput;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFrmGetInput = class(TForm)
    mmoText: TMemo;
    btnOk: TButton;
    btnCancel: TButton;
    lb1: TLabel;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure InitData();
  private
    { Private declarations }
      m_strText:string;
  public
    { Public declarations }
    class function GetInputText(var Text:string):Boolean;
  end;

var
  FrmGetInput: TFrmGetInput;

implementation

uses
  utfsystem;

{$R *.dfm}

procedure TFrmGetInput.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmGetInput.btnOkClick(Sender: TObject);
begin
  m_strText := mmoText.Text ;
  ModalResult := mrOk ;
end;

procedure TFrmGetInput.FormCreate(Sender: TObject);
begin
  ;
end;

class function TFrmGetInput.GetInputText(var Text: string):Boolean;
var
  frm : TFrmGetInput;
begin
  Result := False ;
  frm := TFrmGetInput.Create(nil);
  try
    frm.InitData ;
    if frm.ShowModal = mrOk then
    begin
      Text := frm.m_strText ;
      Result := True ;
    end;
  finally
    frm.Free ;
  end;
end;

procedure TFrmGetInput.InitData;
begin
  mmoText.Text := '全部按时休息!';
end;

end.
