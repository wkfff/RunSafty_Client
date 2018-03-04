unit uFrmShowText;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzEdit;

type
  TfrmShowText = class(TForm)
    RzMemo1: TRzMemo;
    btnCancel: TButton;
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowText(Content : string);
  end;



implementation

{$R *.dfm}

{ TfrmShowText }

procedure TfrmShowText.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrcancel;
end;

class procedure TfrmShowText.ShowText(Content: string);
var
  frmShowText: TfrmShowText;
begin
  frmShowText:= TfrmShowText.Create(nil);
  try
    frmShowText.RzMemo1.Text := Content;
    frmShowText.ShowModal;
  finally
    frmShowText.Free;
  end;
end;

end.
