unit ufrmEditInRoomTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzDTP,uRoomSign,uTFSystem, RzEdit;

type
  TfrmRoomSignEdit = class(TForm)
    Label1: TLabel;
    lblTrainman: TLabel;
    Label3: TLabel;
    dtDatePicker: TRzDateTimePicker;
    dtTimePicker: TRzDateTimePicker;
    Button1: TButton;
    Button2: TButton;
    memRemark: TRzMemo;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class function EditRoomSignTime(var RoomSign: RRsRoomSign;var strRemark: string): Boolean;
  end;
implementation

{$R *.dfm}

{ TfrmRoomSignEdit }

procedure TfrmRoomSignEdit.Button1Click(Sender: TObject);
begin
  if TBox('确定要修改入寓时间吗?') then
  begin
    ModalResult := mrOk;
  end;
end;

procedure TfrmRoomSignEdit.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

class function TfrmRoomSignEdit.EditRoomSignTime(
  var RoomSign: RRsRoomSign;var strRemark: string): Boolean;
var
  frmRoomSignEdit: TfrmRoomSignEdit;
begin
  frmRoomSignEdit := TfrmRoomSignEdit.Create(nil);
  try
    frmRoomSignEdit.dtDatePicker.DateTime := RoomSign.dtInRoomTime;
    frmRoomSignEdit.dtTimePicker.DateTime := RoomSign.dtInRoomTime;
    frmRoomSignEdit.lblTrainman.Caption := Format('%s[%s]',[RoomSign.strTrainmanName,RoomSign.strTrainmanNumber]);
    Result := frmRoomSignEdit.ShowModal = mrOk;
    if Result then
    begin
      RoomSign.dtInRoomTime := AssembleDateTime(frmRoomSignEdit.dtDatePicker.Date,
        frmRoomSignEdit.dtTimePicker.Time);
      strRemark := frmRoomSignEdit.memRemark.Lines.Text;
    end;

  finally
    frmRoomSignEdit.Free;
  end;
end;

end.
