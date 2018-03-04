unit uFrmRoom;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Buttons, ComCtrls, StdCtrls, ExtCtrls,ADODB, ImgList,
  uTFSystem;

type
  //操作状态
  TButtonState = (bsNormal{正常},bsAdd{添加},bsEdit{修改});
  TfrmRoom = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    edtRoomNumber: TEdit;
    Panel2: TPanel;
    lvRoom: TListView;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    ActionList1: TActionList;
    actEsc: TAction;
    Label3: TLabel;
    btnClose: TSpeedButton;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    btnUpdate: TSpeedButton;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    edtMaxCount: TEdit;
    Label5: TLabel;
    edtDeceiveID: TEdit;
    btnTrainNos: TSpeedButton;
    ImageList1: TImageList;
    btnClearRoomTrainman: TSpeedButton;
    lbl1: TLabel;
    lbl2: TLabel;
    udSound: TUpDown;
    edtSound: TEdit;
    edtNightSound: TEdit;
    udNightSound: TUpDown;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure lvRoomChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure FormActivate(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnTrainNosClick(Sender: TObject);
    procedure btnClearRoomTrainmanClick(Sender: TObject);
  private
    { Private declarations }
    isFirst : boolean;
    m_BtnState : TButtonState;
    //刷新值班员列表
    procedure RefreshRooms;
    //刷新选中的数据
    procedure RefreshSelectRoom;
    //设置窗体当前的操作状态
    procedure SetBtnState(bs : TButtonState);
  public
    { Public declarations }
  end;

var
  frmRoom: TfrmRoom;

implementation

{$R *.dfm}
uses
  uRoom,uFrmTrainNoInRoom,uRoomWaitDBOprate;
{ TfrmRoom }

procedure TfrmRoom.actEscExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TfrmRoom.btnAddClick(Sender: TObject);
begin
  edtRoomNumber.Text := '';
  edtMaxCount.Text := '2';
  edtDeceiveID.Text := '0';
  edtSound.Text := '1000';
  edtNightSound.Text := '100';
  SetBtnState(bsAdd);
end;

procedure TfrmRoom.btnCancelClick(Sender: TObject);
begin
  SetBtnState(bsNormal);
  RefreshSelectRoom;
end;

procedure TfrmRoom.btnClearRoomTrainmanClick(Sender: TObject);
var
  RoomWaitingGUID,roomNumber: string;
  nCallCount: Integer;
begin
  if lvRoom.Selected = nil then exit;
  roomNumber := lvRoom.Selected.SubItems[0];
  RoomWaitingGUID := TWaitPlanOpt.CheckRoomWaitingByRoom(roomNumber,nCallCount);
  if RoomWaitingGUID = '' then
  begin
    Box('该房间没有入住人员');
    Exit;
  end;
  if TBox('清除后将不再对原入住人员叫班') = False then Exit;
  
  if TWaitPlanOpt.SetRoomWaitingOver(RoomWaitingGUID,3) then
    Box('清除成功');
end;

procedure TfrmRoom.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRoom.btnDeleteClick(Sender: TObject);
var
  roomNumber : string;
begin
  if lvRoom.Selected = nil then exit;
  if Application.MessageBox('确定要删除此房间吗？','提示',MB_OKCANCEL)
     = mrCancel then
    exit;
  roomNumber := lvRoom.Selected.SubItems[0];
  if TRoomOpt.DeleteRoom(roomNumber) then
    Application.MessageBox('删除成功.','提示',MB_OK + MB_ICONINFORMATION)
  else
    Application.MessageBox('删除失败.','提示',MB_OK + MB_ICONINFORMATION);
  RefreshRooms;
end;

procedure TfrmRoom.btnSaveClick(Sender: TObject);
var
  room : RRoom;
  roomNumber : string;
  maxCount,nDeveiceID,nSound,nNightSound : Integer;
begin
  room.Init;
  if edtRoomNumber.Text = '' then
  begin
    Application.MessageBox('房间号不能为空。','提示',MB_OK+ MB_ICONINFORMATION);
    edtRoomNumber.SetFocus;
    exit;
  end;

  if not TryStrToInt(edtMaxCount.Text,maxCount) then
  begin
    Application.MessageBox('最大容纳人数必须为整数。','提示',MB_OK+ MB_ICONINFORMATION);
    edtMaxCount.SetFocus;
    exit;
  end;
  if maxCount < 1 then
  begin
    Application.MessageBox('最大容纳人数必须大于0。','提示',MB_OK+ MB_ICONINFORMATION);
    edtMaxCount.SetFocus;
    exit;
  end;

  if not TryStrToInt(edtDeceiveID.Text,nDeveiceID) then
  begin
    Application.MessageBox('设备ID必须为整数。','提示',MB_OK+ MB_ICONINFORMATION);
    edtMaxCount.SetFocus;
    exit;
  end;
  if nDeveiceID < 1 then
  begin
    Application.MessageBox('设备ID必须大于0。','提示',MB_OK+ MB_ICONINFORMATION);
    edtMaxCount.SetFocus;
    exit;
  end;
  if not TryStrToInt(edtSound.Text,nSound) then
  begin
    Application.MessageBox('白天音量必须为整数。','提示',MB_OK+ MB_ICONINFORMATION);
    edtSound.SetFocus;
    exit;
  end;
  if not TryStrToInt(edtNightSound.Text,nNightSound) then
  begin
    Application.MessageBox('晚上音量必须为整数。','提示',MB_OK+ MB_ICONINFORMATION);
    edtNightSound.SetFocus;
    exit;
  end;
  
  if Application.MessageBox('您确定要继续吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  try
    roomNumber := '';
    if lvRoom.Selected <> nil then
      roomNumber := lvRoom.Selected.SubItems[0];
    case m_BtnState of
      bsAdd:
      begin
        if TRoomOpt.ExistRoom('',edtRoomNumber.Text) then
        begin
          Application.MessageBox('房间号已经存在。','提示',MB_OK+ MB_ICONINFORMATION);
          exit;
        end;

        if TRoomOpt.ExistDeveice('',nDeveiceID) then
        begin
          Application.MessageBox('设备ID已经存在。','提示',MB_OK+ MB_ICONINFORMATION);
          exit;
        end;        

        room.RoomNumber := edtRoomNumber.Text;
        room.AreaGUID := '';
        room.MaxCount := maxCount;
        room.nDeveiveID := nDeveiceID;
        room.nSound := nSound;
        room.nNightSound := nNightSound;
        if TRoomOpt.AddRoom(room)  then
          Application.MessageBox('添加成功。','提示',MB_OK+ MB_ICONINFORMATION)
        else
          Application.MessageBox('添加失败。','提示',MB_OK+ MB_ICONINFORMATION);
        RefreshRooms;
      end;
      bsEdit:
      begin
        room := TRoomOpt.GetRoom('',roomNumber);
        room.AreaGUID := '' ;
        room.MaxCount := maxCount;
        room.nDeveiveID := nDeveiceID;
        room.nSound := nSound;
        room.nNightSound := nNightSound;
        if TRoomOpt.UpdateRoom(room) then
          Application.MessageBox('修改成功。','提示',MB_OK+ MB_ICONINFORMATION)
        else
          Application.MessageBox('修改失败。','提示',MB_OK+ MB_ICONINFORMATION);
        RefreshRooms;  
      end;
    end;
  finally
    SetBtnState(bsNormal);
  end;
end;

procedure TfrmRoom.btnTrainNosClick(Sender: TObject);
begin
  if lvRoom.Selected = nil then exit;
  frmTrainNosInRoom := TfrmTrainNosInRoom.Create(nil);
  frmTrainNosInRoom.RoomNumber := lvRoom.Selected.SubItems[0];
  try
    if frmTrainNosInRoom.ShowModal = mrOk then
    begin
      RefreshRooms;
    end;
  finally
    frmTrainNosInRoom.Free;
  end;
end;

procedure TfrmRoom.btnUpdateClick(Sender: TObject);
begin
  SetBtnState(bsEdit);
end;



procedure TfrmRoom.FormActivate(Sender: TObject);
begin
  if isFirst then exit;
  isFirst := true;
  RefreshRooms;
  SetBtnState(bsNormal);
end;

procedure TfrmRoom.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TfrmRoom.FormDestroy(Sender: TObject);
begin
  lvRoom.OnChange := nil;

end;




procedure TfrmRoom.lvRoomChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  RefreshSelectRoom;
end;

procedure TfrmRoom.RefreshRooms;
var
  ado : TADOQuery;
  i : Integer;
  item : TListItem;
begin
  lvRoom.OnChange := nil;
  try
    lvRoom.Items.Clear;
    i := 0;
    TRoomOpt.GetRooms('',ado);
    StatusBar1.Panels[0].Text := Format('共%d条',[ado.RecordCount]);
    try
      with ado do
      begin
        First;
        while not eof do
        begin
          i := i + 1;
          item := lvRoom.Items.Add;
          item.Caption := Format('%d',[i]);
          item.SubItems.Add(FieldByName('strRoomNumber').AsString);
          item.SubItems.Add(FieldByName('nMaxCount').AsString);
          item.SubItems.Add(FieldByName('nDeveiceID').AsString);
          item.SubItems.Add(TRoomOpt.GetTrainNosInRoomString(FieldByName('strRoomNumber').AsString));
          //item.SubItems.Add(IntToStr(FieldByName('nSound').AsInteger));
          //item.SubItems.Add(IntToStr(FieldByName('nNightSound').AsInteger));
          next;
        end;
      end;
    finally
      ado.Free;
    end;
  finally
    lvRoom.OnChange := lvRoomChange;
  end;
end;

procedure TfrmRoom.RefreshSelectRoom;
begin
  lvRoom.OnChange := nil;
  try
    edtRoomNumber.Text := '';

    if lvRoom.Selected = nil  then exit;
    edtRoomNumber.Text := lvRoom.Selected.SubItems[0];
    edtMaxCount.Text := lvRoom.Selected.SubItems[1] ;
    edtDeceiveID.Text := lvRoom.Selected.SubItems[2];
    //edtSound.Text := lvRoom.Selected.SubItems[3];
    //edtNightSound.Text := lvRoom.Selected.SubItems[4];
  finally
    lvRoom.OnChange := lvRoomChange;
  end;
end;

procedure TfrmRoom.SetBtnState(bs: TButtonState);
begin
   if bs = bsEdit then
  begin
    if lvRoom.Selected = nil then
    begin
       Application.MessageBox('请选择要修改的房间。','提示',
        MB_OK+ MB_ICONINFORMATION);
       exit;        
    end;
  end;
  m_BtnState := bs;
  //编辑框
  edtRoomNumber.Enabled := false;
  edtMaxCount.Enabled := false;
  edtDeceiveID.Enabled := False;
  edtSound.Enabled := False;
  edtNightSound.Enabled := False;
  udSound.Enabled := False;
  udNightSound.Enabled := False;
  //按钮
  btnAdd.Enabled :=false;
  btnUpdate.Enabled := false;
  btnDelete.Enabled := false;
  btnSave.Enabled := false;
  btnCancel.Enabled := false;
  btnTrainNos.Enabled := false;
  //列表
  lvRoom.Enabled := false;
  case bs of
    bsNormal:
    begin
      btnAdd.Enabled :=true;
      btnUpdate.Enabled := true;
      btnDelete.Enabled := true;
      lvRoom.Enabled := true;
      btnTrainNos.Enabled := true;
      StatusBar1.Panels[1].Text := '当前状态：浏览';
    end;
    bsAdd:
    begin
      edtRoomNumber.Enabled := true;
      edtMaxCount.Enabled := true;
      edtDeceiveID.Enabled := True;
      edtSound.Enabled := True;
      edtNightSound.Enabled := True;
      udSound.Enabled := True;
      udNightSound.Enabled := True;
      btnSave.Enabled := true;
      btnCancel.Enabled := true;
      btnTrainNos.Enabled := false;
      StatusBar1.Panels[1].Text := '当前状态：添加';
    end;
    bsEdit:
    begin
      edtMaxCount.Enabled := true;
      edtDeceiveID.Enabled := True;
      edtDeceiveID.Enabled := True;
      edtSound.Enabled := True;
      edtNightSound.Enabled := True;
      udSound.Enabled := True;
      udNightSound.Enabled := True;
      btnSave.Enabled := true;
      btnCancel.Enabled := true;
      btnTrainNos.Enabled := false;
      StatusBar1.Panels[1].Text := '当前状态：修改';
    end;
  end;
end;

end.
