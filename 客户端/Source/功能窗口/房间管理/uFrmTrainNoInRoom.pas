unit uFrmTrainNoInRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type
  TfrmTrainNosInRoom = class(TForm)
    ListBox1: TListBox;
    Label1: TLabel;
    Label2: TLabel;
    ListBox2: TListBox;
    btnSave: TSpeedButton;
    btnCancel: TSpeedButton;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    procedure ListBox1DblClick(Sender: TObject);
    procedure ListBox2DblClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnDeleteClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    m_strRoomNumber : string;
    procedure SetRoomNumber(const Value: string);
    //添加车次
    procedure AddTrainNo;
    //删除车次
    procedure DeleteTrainNo;
  public
    { Public declarations }
    property RoomNumber : string read m_strRoomNumber write SetRoomNumber;
  end;

var
  frmTrainNosInRoom: TfrmTrainNosInRoom;

implementation

{$R *.dfm}
uses
  ADODB,uTrainNoOpt,uRoom,uGlobalDM;
{ TfrmTrainNosInRoom }

procedure TfrmTrainNosInRoom.AddTrainNo;
var
  i:integer;
begin
  for i := ListBox1.Items.Count - 1 downto 0 do
  begin
    if ListBox1.Selected[i] then
    begin
      ListBox2.Items.Add(ListBox1.Items[i]);
    end;
  end;
  ListBox1.DeleteSelected;
end;

procedure TfrmTrainNosInRoom.btnAddClick(Sender: TObject);
begin
  AddTrainNo;
end;

procedure TfrmTrainNosInRoom.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmTrainNosInRoom.btnDeleteClick(Sender: TObject);
begin
  DeleteTrainNo;
end;

procedure TfrmTrainNosInRoom.btnSaveClick(Sender: TObject);
begin
  TRoomOpt.SetTrainNosInRoom(m_strRoomNumber,ListBox2.Items);
  ModalResult := mrOk;
end;

procedure TfrmTrainNosInRoom.DeleteTrainNo;
var
  i:integer;
begin
  for i := ListBox2.Items.Count - 1 downto 0 do
  begin
    if ListBox2.Selected[i] then
    begin
      ListBox1.Items.Add(ListBox2.Items[i]);
    end;
  end;
  ListBox2.DeleteSelected;
end;

procedure TfrmTrainNosInRoom.ListBox1DblClick(Sender: TObject);
begin
  AddTrainNo;
end;

procedure TfrmTrainNosInRoom.ListBox2DblClick(Sender: TObject);
begin
  DeleteTrainNo;
end;

procedure TfrmTrainNosInRoom.SetRoomNumber(const Value: string);
var
  i : Integer;
  adoQuery : TADOQuery;
  strsTrainNos : TStrings;
begin

  adoQuery := nil;
  if Value <> m_strRoomNumber then
  begin
    m_strRoomNumber := Value;
    label2.Caption := Format('%s房间的车次',[RoomNumber]);
    ListBox2.Items.Clear;
    TRoomOpt.GetTrainNosInRoom(m_strRoomNumber,strsTrainNos);
    try
      for i := 0 to strsTrainNos.Count - 1 do
      begin
        ListBox2.Items.Add(strsTrainNos[i]);
      end;
      try
        ListBox1.Items.Clear;
        TTrainNoOpt.GetTrainNos(GlobalDM.LocalArea,adoquery);
        with adoQuery do
        begin
          while not eof  do
          begin
            if strsTrainNos.IndexOf(FieldByName('strTrainNo').AsString) < 0 then
              ListBox1.Items.Add(FieldByName('strTrainNo').AsString);
            next;
          end;
        end;
      finally
        if Assigned(adoQuery) then
          adoQuery.Free;
      end;
    finally
      if Assigned(strsTrainNos) then
        strsTrainNos.Free;
    end;
  end;
end;

end.
