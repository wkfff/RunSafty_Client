unit uFrmSelectStation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk;

type
  TFrmSelectStation = class(TForm)
    rbUp: TRzRadioButton;
    rbDown: TRzRadioButton;
    rzbtbtnOk: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
  private
    function GetEndStation: string;
    function GetSelectStation: string;
    function GetStartStation: string;
    procedure SetEndStation(const Value: string);
    procedure SetStartStation(const Value: string);
    { Private declarations }
  published
    property StartStation:string read GetStartStation write SetStartStation;
    property EndStation:string read GetEndStation write SetEndStation;
    property SelectStation:string read GetSelectStation;
  end;


implementation

{$R *.dfm}

{ TFrmSelectStation }

function TFrmSelectStation.GetEndStation: string;
begin
  Result := rbDown.Caption;
end;

function TFrmSelectStation.GetSelectStation: string;
begin
  Result := rbUp.Caption;
  if rbDown.Checked then
    Result := rbDown.Caption;
end;

function TFrmSelectStation.GetStartStation: string;
begin
  Result := rbUp.Caption;
end;

procedure TFrmSelectStation.SetEndStation(const Value: string);
begin
  rbDown.Caption := Value;
end;

procedure TFrmSelectStation.SetStartStation(const Value: string);
begin
  rbUp.Caption := Value;
end;

end.
