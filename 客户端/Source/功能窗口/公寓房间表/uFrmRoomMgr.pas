unit uFrmRoomMgr;

interface

uses
  CommCtrl, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, ComCtrls, RzListVw, Buttons, PngSpeedButton, Menus,
  ActnList,uRoomSign,uBaseDBRoomSign,uDBRoomSign,uDBAccessRoomSign,utfsystem,uTrainman,uDBTrainman, RzStatus,
  Grids, StdCtrls, PngCustomButton, frxClass, frxDBSet, pngimage,uWaitWork,uWaitWorkMgr,
  uSaftyEnum,uPubFun;

type


  TFrmRoomMgr = class(TForm)
    rzpnl1: TRzPanel;
    pMenu1: TPopupMenu;
    actlst1: TActionList;
    mniExchangeRoom: TMenuItem;
    timer2: TTimer;
    strGridRoom: TStringGrid;
    rzpnl2: TRzPanel;
    lb2: TLabel;
    lbInTime: TLabel;
    actPrint: TAction;
    frxUserDataSet: TfrxUserDataSet;
    frxReport1: TfrxReport;
    btnAddRoom: TPngCustomButton;
    btnDelRoom: TPngCustomButton;
    lb1: TLabel;
    lbCount: TLabel;
    btnChangeRoom: TPngCustomButton;
    procedure mniE1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure timer2Timer(Sender: TObject);
    procedure strGridRoomDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strGridRoomSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strGridRoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure frxUserDataSetGetValue(const VarName: string; var Value: Variant);
    procedure actPrintExecute(Sender: TObject);
    procedure frxReport1Preview(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnAddRoomClick(Sender: TObject);
    procedure mniExchangeRoomClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure pMenu1Popup(Sender: TObject);
    procedure btnDelRoomClick(Sender: TObject);
    procedure btnChangeRoomClick(Sender: TObject);
  private
    //
    function GetTrainmanNumber(NumberName:String):string;
    //获取选中行的房号
    function  GetSelectRoomNumber():string;
    //获取列号
    function  GetSelectColoumn():Integer ;
    //显示房间人员信息
    procedure RoomInfoToList(RoomList:TWaitRoomList);
    {功能:格式化显示计划人员信息}
    function FormatTrainmanNameNum(room: TWaitRoom;nIndex:Integer):string;
    {功能:获取选中房间记录}
    function GetSelectedRoomInfo():TWaitRoom;
    {功能:获取选中的人员}
    function GetSelectedWaitMan():TWaitWorkTrainmanInfo;
    {功能:获取行房间记录}
    function GetLineRoomInfo(nRow:Integer):TWaitRoom;
    {功能:显示人员入寓时间}
    procedure ShowInRoomTime(room: TWaitRoom;nTrainmanIndex:Integer);
    {功能:选中人员}
    procedure FocusManCell(strNameNum:string);
  public
    //清空STRING_GRID
    procedure ClearGrid();
    //初始化
    procedure InitData();
    //打印
    procedure ShowReport();
    {功能:删除房间}
    procedure DelRoom();
  private
    { Private declarations }
    //待乘管理
    m_WaitWorkMgr:TWaitWorkMgr;
    //房间信息列表
    m_RoomList :TWaitRoomList;
  public
    { Public declarations }
    procedure RefreshData;
  end;

var
  FrmRoomMgr: TFrmRoomMgr;

implementation

{$R *.dfm}

uses
  uGlobalDM,
  ufrmTextInput;

{ TFrmRoomMgr }


procedure TFrmRoomMgr.actPrintExecute(Sender: TObject);
begin
  ShowReport ;
end;



procedure TFrmRoomMgr.btnAddRoomClick(Sender: TObject);
var
  strRoomNum:string;
begin
  if TextInput('增加房间','输入房间号',strRoomNum) = True  then
  begin
    if m_WaitWorkMgr.bRoomExist(strRoomNum) then
    begin
      Box(Format('房间[%s]已存在!',[strRoomNum]));
      Exit;
    end;
    m_WaitWorkMgr.AddRoom(strRoomNum);
    InitData();
  end;
end;

procedure TFrmRoomMgr.btnChangeRoomClick(Sender: TObject);
begin
  mniExchangeRoomClick(nil);
end;

procedure TFrmRoomMgr.btnDelRoomClick(Sender: TObject);
begin
  DelRoom();
end;

procedure TFrmRoomMgr.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmRoomMgr.ClearGrid;
var
  i : Integer ;
begin
  with strGridRoom do
  begin
    for I := 1 to RowCount - 1 do
    begin
      Rows[i].Clear;
    end;
    for i  := 1 to ColCount - 1 do
    begin
      ColWidths[i] := 250;
    end;

  end;

end;

procedure TFrmRoomMgr.DelRoom;
var
  room:TWaitRoom;
begin
  room := GetSelectedRoomInfo;
  if not Assigned(room) then
  begin
    Box('所选行无房间信息');
    Exit;
  end;
  if room.waitManList.Count <> 0 then
  begin
    Box('所选房间有人员入住,不能删除!');
    Exit;
  end;
  m_WaitWorkMgr.DelRoom(room.strRoomNum);
  InitData();
end;

procedure TFrmRoomMgr.FocusManCell(strNameNum:string);
var
  nRow,nCol:Integer;
begin
  for nRow := 1 to strGridRoom.RowCount - 1 do
  begin
    for nCol := 1 to strGridRoom.ColCount - 1 do
    begin
      if strGridRoom.Cells[nCol,nRow] = strNameNum then
      begin
        strGridRoom.Col := nCol;
        strGridRoom.Row := nRow;
        Exit;
      end;
    end;
  end;
end;

function TFrmRoomMgr.FormatTrainmanNameNum(room: TWaitRoom;
  nIndex: Integer): string;
var
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := '空';
  if room.waitManList.Count <= nIndex  then Exit;

  tmInfo :=  room.waitManList.Items[nIndex];
  if tmInfo.eTMState <> psInRoom then Exit;

  result := Format('%s[%s]',[tmInfo.strTrainmanName,tmInfo.strTrainmanNumber]);

end;

procedure TFrmRoomMgr.FormCreate(Sender: TObject);
const
  STR_GRID_HEAD = 0 ;
begin


  strGridRoom.Cells[0,STR_GRID_HEAD] := '房号';
  strGridRoom.Cells[1,STR_GRID_HEAD] := '床位一';
  strGridRoom.Cells[2,STR_GRID_HEAD] := '床位二';
  strGridRoom.Cells[3,STR_GRID_HEAD] := '床位三';
  strGridRoom.Cells[4,STR_GRID_HEAD] := '床位四';

  
  m_WaitWorkMgr := TWaitWorkMgr.GetInstance(GlobalDM.LocalADOConnection);
  m_RoomList :=TWaitRoomList.create;
  //InitData;
end;

procedure TFrmRoomMgr.FormDestroy(Sender: TObject);
begin
  m_RoomList.Free;
end;

procedure TFrmRoomMgr.FormShow(Sender: TObject);
begin
  //InitData;
end;

procedure TFrmRoomMgr.frxReport1Preview(Sender: TObject);
begin
    frxUserDataSet.RangeEndCount := strGridRoom.RowCount - 1 ;
end;

procedure TFrmRoomMgr.frxUserDataSetGetValue(const VarName: string;
  var Value: Variant);
begin
  if VarName='1' then
  begin
    Value := strGridRoom.Cells[ 0,frxUserDataSet.RecNo + 1 ] ;
  end
  else  if VarName = '2' then
  begin
    Value := strGridRoom.Cells[ 1, frxUserDataSet.RecNo+ 1] ;
  end
  else  if VarName = '3' then
  begin
    Value := strGridRoom.Cells[ 2,frxUserDataSet.RecNo+ 1] ;
  end
  else  if VarName = '4' then
  begin
    Value := strGridRoom.Cells[ 3,frxUserDataSet.RecNo+ 1] ;
  end
end;

function TFrmRoomMgr.GetLineRoomInfo(nRow: Integer): TWaitRoom;
begin
  result := nil;
  if (nRow >0 )and  (nRow <= m_RoomList.Count )then
  begin
    result :=m_RoomList.Items[nRow-1];
    Exit;
  end;
end;

function TFrmRoomMgr.GetSelectColoumn: Integer;
begin
  Result := strGridRoom.Col ;
end;

function TFrmRoomMgr.GetSelectedRoomInfo: TWaitRoom;
var
  i:integer;
begin
  result := nil;
  i :=strGridRoom.Row-1;
  if (i >=0 )and  (i < m_RoomList.Count )then
  begin
    result :=m_RoomList.Items[i];
    Exit;
  end;


end;

function TFrmRoomMgr.GetSelectedWaitMan: TWaitWorkTrainmanInfo;
var
  room:TWaitRoom;
  nManCount:Integer;
  nIndex:Integer;
begin
  result := nil;
  room :=GetSelectedRoomInfo();
  if room = nil  then Exit;
  with strGridRoom do
  begin
    nIndex := Col -1;
    if (nIndex >= 0) and (nIndex < room.waitManList.Count) then
    begin
      result:= room.waitManList.Items[nIndex];
    end;
  end;
end;

function TFrmRoomMgr.GetSelectRoomNumber: string;
var
  aRow:Integer ;
begin
  aRow := Self.strGridRoom.Row ;
  Result := strGridRoom.Cells[0,aRow] ;
end;


function TFrmRoomMgr.GetTrainmanNumber(NumberName: String): string;
var
  i : Integer ;
begin
  i := Pos(']',NumberName);
  Result := Copy(NumberName,2,i-2);
end;

procedure TFrmRoomMgr.InitData;
begin
  m_RoomList.clear;
  m_WaitWorkMgr.GetRoomWaitInfo(m_RoomList);
  RoomInfoToList(m_RoomList);
end;


procedure TFrmRoomMgr.mniE1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmRoomMgr.mniExchangeRoomClick(Sender: TObject);
var
  NewRoom,OldRoom:TWaitRoom;
  strRoomNum:string;
  waitMan:TWaitWorkTrainmanInfo;
  strNameNum:string;
begin
  OldRoom:=GetSelectedRoomInfo;
  if not Assigned(OldRoom) then
  begin
    Box('所选行无房间信息,无法调换!');
    Exit;
  end;
  waitMan:= GetSelectedWaitMan;
  if waitMan = nil then
  begin
    Box('未选中入住人员,无法调换!');
    Exit;
  end;
  if TextInput('调整房间','输入新房间号码!',strRoomNum) = False then Exit;

  NewRoom := m_RoomList.Find(strRoomNum);

  if NewRoom.waitManList.Count = 4  then
  begin
    Box(Format('目标房间[%s]已满员,调换失败!',[strRoomNum]));
    Exit;
  end;
  if m_WaitWorkMgr.bRoomExist(strRoomNum) = False then
  begin
    if TBox(Format('未找到房间[%s],是否增加此房间',[strRoomNum]))= False then Exit;
    m_WaitWorkMgr.AddRoom(strRoomNum);
  end;
  waitMan.strRealRoom := strRoomNum;
  m_WaitWorkMgr.DBWaitMan.Modify(waitMan);
  strNameNum := TPubFun.FormatTMNameNum(waitMan.strTrainmanName,waitMan.strTrainmanNumber);
  InitData();
  Application.ProcessMessages;
  FocusManCell(strNameNum);
end;

procedure TFrmRoomMgr.N2Click(Sender: TObject);
var
  room:TWaitRoom;
begin
  room := GetSelectedRoomInfo;
  if not Assigned(room) then
  begin
    Box('所选行无房间信息');
    Exit;
  end;
  {if Assigned(room.waitPlan )then
  begin
    Box('所选房间有人员入住,不能删除!');
    Exit;
  end;   }
  m_WaitWorkMgr.DelRoom(room.strRoomNum);
  InitData();
end;

procedure TFrmRoomMgr.pMenu1Popup(Sender: TObject);
var
  room:TWaitRoom;
  waitMan:TWaitWorkTrainmanInfo;
begin
  room := GetSelectedRoomInfo;
  if not Assigned(room) then  //空行,
  begin
    pMenu1.Items[0].Enabled := False;
  end
  else
  begin
    waitMan := GetSelectedWaitMan;
    if waitMan <> nil then //有人,允许调整房间
    begin
      pMenu1.Items[0].Enabled := True;
    end
    else
    begin
      pMenu1.Items[0].Enabled := False;
    end; 
  end;
end;

procedure TFrmRoomMgr.RefreshData;
begin
  InitData;
end;

procedure TFrmRoomMgr.RoomInfoToList(RoomList:TWaitRoomList);
var
  strTrainman:string;
  i : Integer ;
  j : Integer ;
  nPersonCount :Integer ;
  room:TWaitRoom;
begin

  nPersonCount := 0 ;
  ClearGrid;

  with strGridRoom do
  begin
    if RoomList.Count > 0 then
      RowCount := RoomList.Count + 1
    else begin
      RowCount := 2;
    end;


    for I := 0 to RoomList.Count - 1 do
    begin

      room := RoomList.items[i];
      Cells[0,i+1] :=  room.strRoomNum;
      Cells[1,i+1] :=  FormatTrainmanNameNum(room,0);
      Cells[2,i+1] :=  FormatTrainmanNameNum(room,1);
      Cells[3,i+1] :=  FormatTrainmanNameNum(room,2);
      Cells[4,i+1] :=  FormatTrainmanNameNum(room,3);
      
      nPersonCount := nPersonCount + room.waitManList.Count;
    end;
  end;
  //显示总人数
  lbCount.Caption := Format(' %d 个',[nPersonCount])  ;
end;

procedure TFrmRoomMgr.ShowInRoomTime(room: TWaitRoom;
  nTrainmanIndex: Integer);
var
  inRoomInfo:RRSInOutRoomInfo;
  tmInfo:TWaitWorkTrainmanInfo;
begin


  if nTrainmanIndex >= room.waitManList.Count  then
  begin
    lbInTime.caption := '';
    Exit;
  end;

  tmInfo := room.waitManList.Items[nTrainmanIndex];

  m_WaitWorkMgr.GetInOutRoomInfo(tmInfo);
  inRoomInfo := tmInfo.InRoomInfo;
  if (inRoomInfo.strGUID = '') then
  begin
    lbInTime.Caption := '';
  end
  else
  begin
    lbInTime.Caption := FormatDateTime('yyyy-mm-dd HH:mm:ss',inRoomInfo.dtInOutRoomTime);
  end;
end;

procedure TFrmRoomMgr.ShowReport;
var
  mv: TfrxMemoView;
begin
  mv := frxReport1.FindObject('mmoRoomNumber') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '房间号' ;

  mv := frxReport1.FindObject('mmoBedNumber1') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '床位一' ;

  mv := frxReport1.FindObject('mmoBedNumber2') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '床位二' ;

  mv := frxReport1.FindObject('mmoBedNumber3') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '床位三' ;
  mv := frxReport1.FindObject('mmoBedNumber4') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '床位四' ;

  self.frxReport1.ShowReport(True);
end;


procedure TFrmRoomMgr.strGridRoomDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  FIRST_BED_NUMBER = 0 ;
  SECOND_BED_NUMBER = 1 ;
  THIRD_BED_NUMBER = 1 ;
var
  strTxt:string ;
  trainman:RRsTrainman;
begin
  with strGridRoom do
  begin
    if (ARow <> 0)  then
    begin
      case ACol of
        0 :
        begin
          Canvas.Brush.Color :=  clYellow;
        end;
        1:
        begin
          Canvas.Brush.Color :=  RGB(179,255,179);
        end;
        2:
        begin
          Canvas.Brush.Color :=  RGB(242,252,152);
        end;
        3:
        begin
          Canvas.Brush.Color := RGB(255,176,176) ;
        end;
        4:
        begin
          Canvas.Brush.Color := RGB(200,220,176) ;
        end;
        else
          begin
            Exit;
          end;

      end;
      Canvas.Pen.Style := psClear;

      if [gdFocused, gdSelected] * State<>[] then
      begin
        Canvas.Brush.Color := clHighlight;
      end;

      Canvas.Rectangle(Rect);
      Canvas.Brush.Style := bsClear;
      strTxt := Cells[acol,arow] ;
      Canvas.TextRect(Rect,strTxt,[tfCenter,tfSingleLine,tfVerticalCenter]);
    end;
   end;

end;

procedure TFrmRoomMgr.strGridRoomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if mbRight = Button  then

    strGridRoom.Perform(WM_LBUTTONDOWN,0,MakelParam(x,y));
end;

procedure TFrmRoomMgr.strGridRoomSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  room:TWaitRoom;
  strTrainmanNumber:string;
begin
  lbInTime.Caption := '';
  if ( ACol = 1 )  or
     ( ACol = 2 )or
    ( ACol = 3 )or
    (ACol = 4)
  then
  begin
    room := GetLineRoomInfo(ARow);
    if not Assigned(room) then Exit;
    ShowInRoomTime(room,ACol -1);
    Exit;
    
    strTrainmanNumber := strGridRoom.Cells[ACol,ARow];
    if strTrainmanNumber = '空' then
    begin
      lbInTime.Caption := '';
      Exit;
    end;
    strTrainmanNumber := GetTrainmanNumber(strTrainmanNumber) ;

  end
  

end;

procedure TFrmRoomMgr.timer2Timer(Sender: TObject);
begin
  InitData();
end;

end.
