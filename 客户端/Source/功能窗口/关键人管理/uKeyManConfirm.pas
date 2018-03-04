unit uKeyManConfirm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzEdit, ExtCtrls, RzPanel,uLCKeyMan;

type
  TFrmKeyManConfirm = class(TForm)
    RzMemo1: TRzMemo;
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    Button1: TButton;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    
  public
    { Public declarations }
    class procedure ShowKeyMan(Name,Number,Remind: string);overload;
    class procedure ShowKeyMan(TrainmanNumber: string);overload;
    class function GetKeyMan(TrainmanNumber: string;KeyTrainman: TKeyTrainman): Boolean;
  end;


implementation

uses uGlobalDM;

{$R *.dfm}

procedure TFrmKeyManConfirm.Button1Click(Sender: TObject);
begin
  Close;
end;

class procedure TFrmKeyManConfirm.ShowKeyMan(Name,Number,Remind: string);
var
  FrmKeyManConfirm: TFrmKeyManConfirm;
begin
  FrmKeyManConfirm := TFrmKeyManConfirm.Create(nil);
  try
    FrmKeyManConfirm.Label1.Caption :=
      Format('[%s]%s 为重点人',[Number,Name]);
    FrmKeyManConfirm.RzMemo1.Lines.Clear;
    FrmKeyManConfirm.RzMemo1.Lines.Add('注意事项：');
    FrmKeyManConfirm.RzMemo1.Lines.Add(Remind);
    FrmKeyManConfirm.ShowModal;
  finally
    FrmKeyManConfirm.Free;
  end;
end;

class function TFrmKeyManConfirm.GetKeyMan(TrainmanNumber: string;KeyTrainman: TKeyTrainman): Boolean;
var
  cdt:TKeyTM_QC;
  KeymanList:TKeyTrainmanList;
  LCKeyMan: TRsLCKeyMan;
begin
  cdt := TKeyTM_QC.Create;
  LCKeyMan := TRsLCKeyMan.Create(GlobalDM.WebAPIUtils);
  KeymanList := TKeyTrainmanList.Create;
  try
    cdt.KeyTMNumber := TrainmanNumber;
    LCKeyMan.Get(cdt,KeymanList);
    Result := KeymanList.Count > 0;
    if Result then
    begin
      KeyTrainman.clone(KeymanList.Items[0]);
    end;

  finally
    cdt.Free;
    LCKeyMan.Free;
    KeymanList.Free;
  end;

end;

class procedure TFrmKeyManConfirm.ShowKeyMan(TrainmanNumber: string);
var
  KeyTrainman: TKeyTrainman;
begin
  KeyTrainman := TKeyTrainman.Create;
  try
    if GetKeyMan(TrainmanNumber,KeyTrainman) then
    begin
      ShowKeyMan(KeyTrainman.KeyTMNumber,KeyTrainman.KeyTMName,KeyTrainman.KeyAnnouncements);
    end;
  finally
    KeyTrainman.Free;
  end;

end;

end.
