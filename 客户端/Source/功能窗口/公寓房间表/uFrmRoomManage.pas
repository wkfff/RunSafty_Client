unit uFrmRoomManage;

interface

uses
  CommCtrl, 
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, ComCtrls, RzListVw, Buttons, PngSpeedButton, Menus,
  ActnList,uRoomSign,uBaseDBRoomSign,uDBRoomSign,uDBAccessRoomSign,utfsystem,uTrainman,uDBTrainman, RzStatus,
  Grids, StdCtrls, PngCustomButton, frxClass, frxDBSet, pngimage;

type
  TFrmRoomManage = class(TForm)
    rzpnl1: TRzPanel;
    pMenu1: TPopupMenu;
    actlst1: TActionList;
    actInsertRoom: TAction;
    actDeleteRoom: TAction;
    actExchangeRoom: TAction;
    actRemoveWoker: TAction;
    mniExchangeRoom: TMenuItem;
    mniRemoveWoker: TMenuItem;
    actClearAllRoom: TAction;
    timer2: TTimer;
    strGridRoom: TStringGrid;
    rzpnl2: TRzPanel;
    lb2: TLabel;
    lbInTime: TLabel;
    actPrint: TAction;
    frxUserDataSet: TfrxUserDataSet;
    frxReport1: TfrxReport;
    btnAddRoom: TPngCustomButton;
    btnPrint: TPngCustomButton;
    btnRefresh: TPngCustomButton;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    lb1: TLabel;
    lbCount: TLabel;
    procedure actInsertRoomExecute(Sender: TObject);
    procedure actDeleteRoomExecute(Sender: TObject);
    procedure actExchangeRoomExecute(Sender: TObject);
    procedure actRemoveWokerExecute(Sender: TObject);
    procedure mniE1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actClearAllRoomExecute(Sender: TObject);
    procedure timer2Timer(Sender: TObject);
    procedure strGridRoomDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure strGridRoomSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure strGridRoomMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure btnAddRoomClick(Sender: TObject);
    procedure btnDelRoomClick(Sender: TObject);
    procedure btnClearAllRoomClick(Sender: TObject);
    procedure frxUserDataSetGetValue(const VarName: string; var Value: Variant);
    procedure actPrintExecute(Sender: TObject);
    procedure frxReport1Preview(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
  private
    //
    function GetTrainmanNumber(NumberName:String):string;
    //获取选中行的房号
    function  GetSelectRoomNumber():string;
    procedure RoomInfoToList(RoomInfoList:TRsRoomInfoArray);
  public
    //清空STRING_GRID
    procedure ClearGrid();
    //初始化
    procedure InitData();
    //让所有人员离寓
    procedure AllSignOut();
    //打印
    procedure ShowReport();
  private
    { Private declarations }
    m_dbTrainman:TRsDBAccessTrainman ;
    m_dbRoomSign:TRsBaseDBRoomSign;
    m_dbRoomInfo : TRsBaseDBRoomInfo ;
    m_listRoomInfo : TRsRoomInfoArray ;
  public
    { Public declarations }
    procedure RefreshData;
  end;

var
  FrmRoomManage: TFrmRoomManage;

implementation

{$R *.dfm}

uses
  uGlobalDM,
  ufrmTextInput;

{ TFrmRoomManage }

procedure TFrmRoomManage.actClearAllRoomExecute(Sender: TObject);
begin
  if TBox('确认清空所有房间吗?') then
  begin
    //让人员离寓
    AllSignOut();
    //清空所有的人员
    m_dbRoomInfo.ClearAllRoom();
    Box('清空完毕');
    InitData;
  end;
end;

procedure TFrmRoomManage.actDeleteRoomExecute(Sender: TObject);
var
  strText:string;
  strRoomNumber:string;
begin
  strRoomNumber := GetSelectRoomNumber;
  if not m_dbRoomInfo.IsRoomEmpty(strRoomNumber) then
  begin
    BoxErr('不能删除有人住的房间');
    Exit ;
  end;

  strText := Format('确认删除该房间[%s]吗?',[strRoomNumber]);
  if TBox(strText) then
  begin
    m_dbRoomInfo.DeleteRoom(strRoomNumber);
    Box('删除房间成功!');
    InitData;
  end;
end;

procedure TFrmRoomManage.actExchangeRoomExecute(Sender: TObject);
var
  nNewBedNumber:Integer ;
  strOldRoomNumber:string;
  strNewRoomNumber:string;
  strNumber : string;
  trainman : RRsTrainman;
  strQuestion:string;
  aCol,aRow:Integer ;
  strRoomSignGUID:string;
begin
  if  ( strGridRoom.Col = 0 ) then
    Exit ;

  aCol := strGridRoom.Col;
  aRow := strGridRoom.Row ;

  //获取工号
  strNumber :=  GetTrainmanNumber(strGridRoom.Cells[aCol,aRow]) ;
  if strNumber = '空' then
    exit ;

  //确认是否更换
  strQuestion := Format('确定为: %s 更换房间吗?',[ strGridRoom.Cells[aCol,aRow]]);
  if not TBox(strQuestion) then
    Exit ;


  strOldRoomNumber := GetSelectRoomNumber ;

  if TextInput('房间号输入', '请输入房间号:', strNewRoomNumber) = False then
    Exit;

  if strNewRoomNumber = strOldRoomNumber then
  begin
    BoxErr('调换房间号不能和原房间号一样!');
    Exit ;
  end;
    //检查是否存在
  if not m_dbRoomInfo.IsRoomExist(strNewRoomNumber) then
  begin
      BoxErr('房间号不存在,请先创建房间') ;
      Exit;
  end;
  //检查是否满员
  if m_dbRoomInfo.IsRoomFull(strNewRoomNumber) then
  begin
    BoxErr('已经满员,请更换别的房间');
    Exit;
  end;

  if not TBox('确认更换吗?') then
    exit ;

  //获取一个空的床位号
  nNewBedNumber := m_dbRoomInfo.GetEmptyBedNumber(strNewRoomNumber) ;
  if nNewBedNumber = 0 then
  begin
    BoxErr('获取床位号错误');
    Exit ;
  end;

  if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('错误的乘务员工号');
    exit;
  end;

  strRoomSignGUID := m_dbRoomSign.GetLastInGUID(trainman.strTrainmanNumber);

  //更新入寓信息里面的房间号
  m_dbRoomSign.UpdateSignInRoomNumber(strRoomSignGUID,strNewRoomNumber,nNewBedNumber);

  //从原先房间删除
  m_dbRoomInfo.DelTrainmanFromRoom(trainman.strTrainmanGUID);
  //添加到新房间
  m_dbRoomInfo.AddTrainmanToRoom(trainman.strTrainmanGUID,strNewRoomNumber,nNewBedNumber);


  InitData;
end;



procedure TFrmRoomManage.actInsertRoomExecute(Sender: TObject);
var
  strRoomNumber:string;
begin
  if TextInput('房间号输入', '请输入房间号:', strRoomNumber) = False then
    Exit;
  //检查是否存在
  if m_dbRoomInfo.IsRoomExist(strRoomNumber) then
  begin
    BoxErr('房间号已经存在!');
    Exit;
  end;
  m_dbRoomInfo.InsertRoom(strRoomNumber) ;
  Box('房间:[ '+strRoomNumber +' ]创建完毕');
  InitData;
end;

procedure TFrmRoomManage.actPrintExecute(Sender: TObject);
begin
  ShowReport ;
end;

procedure TFrmRoomManage.actRemoveWokerExecute(Sender: TObject);
var
  strNumber : string;
  trainman : RRsTrainman;
  strQuestion : string ;
  aCol,aRow:Integer ;
  strRoomSignGUID:string;
  roomSign:TRsRoomSign ;
begin

  if  ( strGridRoom.Col = 0 ) then
    Exit ;

  aCol := strGridRoom.Col;
  aRow := strGridRoom.Row ;


  //检查是否有人
  strNumber :=  GetTrainmanNumber( strGridRoom.Cells[aCol,aRow] ) ;
  if strNumber = '空' then
    exit ;

  //确定是否要离寓
  strQuestion := Format('确定移除人员: %s ?',[strGridRoom.Cells[aCol,aRow]] );
  if not TBox(strQuestion) then
    Exit ;

  //获取人员的详细信息
  if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('错误的乘务员工号');
    exit;
  end;


  //强行离寓
  roomSign := TRsRoomSign.Create;
  try
    strRoomSignGUID := m_dbRoomSign.GetLastInGUID(trainman.strTrainmanNumber);
    roomSign.strOutRoomGUID := NewGUID ;
    roomSign.strTrainmanGUID := trainman.strTrainmanGUID ;
    roomSign.strTrainmanNumber := trainman.strTrainmanNumber ;
    roomSign.strInRoomGUID := strRoomSignGUID ;
    roomSign.nOutRoomVerifyID := 0 ;
    roomSign.dtOutRoomTime := GlobalDM.GetNow ;
    m_dbRoomSign.GetSignInRecordByID(strRoomSignGUID,roomSign);
    m_dbRoomSign.InsertSignOut(roomSign);

    //从房间移除人员
    m_dbRoomInfo.DelTrainmanFromRoom(trainman.strTrainmanGUID);
    Box('移除成功');
    InitData;
  finally
    roomSign.Free ;
  end;

end;



procedure TFrmRoomManage.btnAddRoomClick(Sender: TObject);
begin
  actInsertRoomExecute(Sender);
end;

procedure TFrmRoomManage.btnClearAllRoomClick(Sender: TObject);
begin
  actClearAllRoomExecute(Sender);
end;

procedure TFrmRoomManage.btnDelRoomClick(Sender: TObject);
begin
  actDeleteRoomExecute(Sender);
end;


procedure TFrmRoomManage.btnRefreshClick(Sender: TObject);
begin
  InitData;
end;

procedure TFrmRoomManage.AllSignOut;
var
  i,j : Integer ;
  strRoomSignGUID:string;
  roomSign:TRsRoomSign ;
  strNumber:string;
  trainman : RRsTrainman;
begin
  roomSign := TRsRoomSign.Create;
  try
    with strGridRoom do
    begin
      for I := 1 to RowCount - 1 do
      begin
        for j := 1 to 3 do
        begin
          Application.ProcessMessages;
          
          if strGridRoom.Cells[j,i]  = '空' then
              Continue;
          strNumber :=  GetTrainmanNumber( strGridRoom.Cells[j,i] ) ;
          if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
            Continue ;
          strRoomSignGUID := m_dbRoomSign.GetLastInGUID(trainman.strTrainmanNumber);
          if strRoomSignGUID = '' then
            Continue ;
          roomSign.strOutRoomGUID := NewGUID ;
          roomSign.strInRoomGUID := strRoomSignGUID ;
          roomSign.nOutRoomVerifyID := 0 ;
          roomSign.dtOutRoomTime := Now ;
          roomSign.strTrainmanGUID := trainman.strTrainmanGUID ;
          roomSign.strTrainmanNumber := trainman.strTrainmanNumber ;
          m_dbRoomSign.GetSignInRecordByID(strRoomSignGUID,roomSign);
          m_dbRoomSign.InsertSignOut(roomSign);
        end;
      end;
    end;
  finally
    roomSign.Free ;
  end;
end;


procedure TFrmRoomManage.ClearGrid;
var
  i : Integer ;
begin
  with strGridRoom do
  begin
    for I := 1 to RowCount - 1 do
    begin
      Rows[i].Clear;
    end;
  end;

end;

procedure TFrmRoomManage.FormCreate(Sender: TObject);
const
  STR_GRID_HEAD = 0 ;
begin
  m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_dbRoomSign := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);

  strGridRoom.Cells[0,STR_GRID_HEAD] := '房号';
  strGridRoom.Cells[1,STR_GRID_HEAD] := '床位一';
  strGridRoom.Cells[2,STR_GRID_HEAD] := '床位二';
  strGridRoom.Cells[3,STR_GRID_HEAD] := '床位三';
  //strGridRoom.Cells[4,STR_GRID_HEAD] := '房号';
  InitData;
end;

procedure TFrmRoomManage.FormDestroy(Sender: TObject);
begin
  m_dbRoomInfo.Free ;
  m_dbTrainman.Free ;
  m_dbRoomSign.Free ;
end;

procedure TFrmRoomManage.frxReport1Preview(Sender: TObject);
begin
    frxUserDataSet.RangeEndCount := strGridRoom.RowCount - 1 ;
end;

procedure TFrmRoomManage.frxUserDataSetGetValue(const VarName: string;
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


function TFrmRoomManage.GetSelectRoomNumber: string;
var
  aRow:Integer ;
begin
  aRow := Self.strGridRoom.Row ;
  Result := strGridRoom.Cells[0,aRow] ;
end;


function TFrmRoomManage.GetTrainmanNumber(NumberName: String): string;
var
  i : Integer ;
begin
  i := Pos(']',NumberName);
  Result := Copy(NumberName,2,i-2);
end;

procedure TFrmRoomManage.InitData;
begin
  SetLength(m_listRoomInfo,0);
  m_dbRoomInfo.GetEnterRoomList(m_listRoomInfo);
  RoomInfoToList(m_listRoomInfo);
end;


procedure TFrmRoomManage.mniE1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmRoomManage.RefreshData;
begin
  InitData;
end;

procedure TFrmRoomManage.RoomInfoToList(RoomInfoList: TRsRoomInfoArray);
var
  strTrainman:string;
  i : Integer ;
  j : Integer ;
  nPersonCount :Integer ;
begin

  nPersonCount := 0 ;
  ClearGrid;

  with strGridRoom do
  begin
    if Length(RoomInfoList) > 0 then
      RowCount := Length( RoomInfoList) + 1
    else begin
      RowCount := 2;
    end;


    for I := 0 to Length(RoomInfoList) - 1 do
    begin
      Cells[0,i+1] :=  RoomInfoList[i].strRoomNumber;
      for j := 0 to 2 do
      begin
        strTrainman := '';
        if RoomInfoList[i].listBedInfo[j].strTrainmanGUID <> '' then
        begin
          strTrainman := Format('[%s]%s',[RoomInfoList[i].listBedInfo[j].strTrainmanNumber,
            RoomInfoList[i].listBedInfo[j].strTrainmanName,
            FormatDateTime('HH:mm',RoomInfoList[i].listBedInfo[j].dtInRoomTime)]);
          Inc(nPersonCount);
        end
        else
          strTrainman := '空' ;
        Cells[j+1,i+1] :=  strTrainman;
      end;
      //Cells[4,i+1] :=  RoomInfoList[i].strRoomNumber;
    end;
  end;
  //显示总人数
  lbCount.Caption := Format(' %d 个',[nPersonCount])  ;
end;

procedure TFrmRoomManage.ShowReport;
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

  self.frxReport1.ShowReport(True);
end;


procedure TFrmRoomManage.strGridRoomDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  FIRST_BED_NUMBER = 0 ;
  SECOND_BED_NUMBER = 1 ;
  THIRD_BED_NUMBER = 1 ;
var
  strTxt:string ;
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

procedure TFrmRoomManage.strGridRoomMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if mbRight = Button  then

    strGridRoom.Perform(WM_LBUTTONDOWN,0,MakelParam(x,y));
end;

procedure TFrmRoomManage.strGridRoomSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
var
  dtTime:TDateTime ;
  strTrainmanNumber:string;
begin
  if ( ACol = 1 )  or
     ( ACol = 2 )or
    ( ACol = 3 )
  then
  begin
    strTrainmanNumber := strGridRoom.Cells[ACol,ARow];
    if strTrainmanNumber = '空' then
    begin
      lbInTime.Caption := '';
      Exit;
    end;
    strTrainmanNumber := GetTrainmanNumber(strTrainmanNumber) ;
    m_dbRoomSign.GetSignInTime(strTrainmanNumber,dtTime) ;
    lbInTime.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtTime);
  end
  else
    lbInTime.Caption := '';

end;

procedure TFrmRoomManage.timer2Timer(Sender: TObject);
begin
  InitData();
end;

end.
