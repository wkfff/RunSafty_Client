unit uFrmFindRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ComCtrls, Buttons, ActnList,uRoom;

type
  TfrmFindRoom = class(TForm)
    lvRoom: TListView;
    Panel1: TPanel;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    ActionList1: TActionList;
    actEnter: TAction;
    actCancel: TAction;
    procedure actEnterExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvRoomDblClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
        m_dbRoom : TDBRoomOperate ;
  private
      procedure InitData();
  public
    { Public declarations }

  end;

var
  frmFindRoom: TfrmFindRoom;

implementation

{$R *.dfm}
uses
   uGlobalDM;
procedure TfrmFindRoom.actCancelExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmFindRoom.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmFindRoom.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmFindRoom.btnSaveClick(Sender: TObject);
begin
  if lvRoom.Selected = nil then exit;       
  ModalResult := mrOk;
end;

procedure TfrmFindRoom.FormCreate(Sender: TObject);
begin
  m_dbRoom := TDBRoomOperate.Create(GlobalDM.LocalADOConnection);
  InitData;
end;

procedure TfrmFindRoom.FormDestroy(Sender: TObject);
begin
  m_dbRoom.Free ;
end;

procedure TfrmFindRoom.InitData;
var
  roomArray : RRoomArray ;
  item : TListItem;
  i : Integer;
begin
  m_dbRoom.QueryRooms('',roomArray);
  lvRoom.Items.Clear;
  for I := 0 to Length(roomArray) - 1 do
  begin
    with roomArray[i] do
    begin
      item := lvRoom.Items.Add;
      item.Caption := IntToStr(i+1);
      item.SubItems.Add(RoomArray[i].RoomNumber);
      item.SubItems.Add(IntToStr( RoomArray[i].nDeveiveID ));
      item.SubItems.Add(IntToStr( RoomArray[i].MaxCount ) );
    end;
  end;
end;

procedure TfrmFindRoom.lvRoomDblClick(Sender: TObject);
begin
  btnSaveClick(Sender);
end;

end.
