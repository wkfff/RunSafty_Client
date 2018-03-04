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
    //��ȡѡ���еķ���
    function  GetSelectRoomNumber():string;
    procedure RoomInfoToList(RoomInfoList:TRsRoomInfoArray);
  public
    //���STRING_GRID
    procedure ClearGrid();
    //��ʼ��
    procedure InitData();
    //��������Ա��Ԣ
    procedure AllSignOut();
    //��ӡ
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
  if TBox('ȷ��������з�����?') then
  begin
    //����Ա��Ԣ
    AllSignOut();
    //������е���Ա
    m_dbRoomInfo.ClearAllRoom();
    Box('������');
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
    BoxErr('����ɾ������ס�ķ���');
    Exit ;
  end;

  strText := Format('ȷ��ɾ���÷���[%s]��?',[strRoomNumber]);
  if TBox(strText) then
  begin
    m_dbRoomInfo.DeleteRoom(strRoomNumber);
    Box('ɾ������ɹ�!');
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

  //��ȡ����
  strNumber :=  GetTrainmanNumber(strGridRoom.Cells[aCol,aRow]) ;
  if strNumber = '��' then
    exit ;

  //ȷ���Ƿ����
  strQuestion := Format('ȷ��Ϊ: %s ����������?',[ strGridRoom.Cells[aCol,aRow]]);
  if not TBox(strQuestion) then
    Exit ;


  strOldRoomNumber := GetSelectRoomNumber ;

  if TextInput('���������', '�����뷿���:', strNewRoomNumber) = False then
    Exit;

  if strNewRoomNumber = strOldRoomNumber then
  begin
    BoxErr('��������Ų��ܺ�ԭ�����һ��!');
    Exit ;
  end;
    //����Ƿ����
  if not m_dbRoomInfo.IsRoomExist(strNewRoomNumber) then
  begin
      BoxErr('����Ų�����,���ȴ�������') ;
      Exit;
  end;
  //����Ƿ���Ա
  if m_dbRoomInfo.IsRoomFull(strNewRoomNumber) then
  begin
    BoxErr('�Ѿ���Ա,�������ķ���');
    Exit;
  end;

  if not TBox('ȷ�ϸ�����?') then
    exit ;

  //��ȡһ���յĴ�λ��
  nNewBedNumber := m_dbRoomInfo.GetEmptyBedNumber(strNewRoomNumber) ;
  if nNewBedNumber = 0 then
  begin
    BoxErr('��ȡ��λ�Ŵ���');
    Exit ;
  end;

  if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('����ĳ���Ա����');
    exit;
  end;

  strRoomSignGUID := m_dbRoomSign.GetLastInGUID(trainman.strTrainmanNumber);

  //������Ԣ��Ϣ����ķ����
  m_dbRoomSign.UpdateSignInRoomNumber(strRoomSignGUID,strNewRoomNumber,nNewBedNumber);

  //��ԭ�ȷ���ɾ��
  m_dbRoomInfo.DelTrainmanFromRoom(trainman.strTrainmanGUID);
  //��ӵ��·���
  m_dbRoomInfo.AddTrainmanToRoom(trainman.strTrainmanGUID,strNewRoomNumber,nNewBedNumber);


  InitData;
end;



procedure TFrmRoomManage.actInsertRoomExecute(Sender: TObject);
var
  strRoomNumber:string;
begin
  if TextInput('���������', '�����뷿���:', strRoomNumber) = False then
    Exit;
  //����Ƿ����
  if m_dbRoomInfo.IsRoomExist(strRoomNumber) then
  begin
    BoxErr('������Ѿ�����!');
    Exit;
  end;
  m_dbRoomInfo.InsertRoom(strRoomNumber) ;
  Box('����:[ '+strRoomNumber +' ]�������');
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


  //����Ƿ�����
  strNumber :=  GetTrainmanNumber( strGridRoom.Cells[aCol,aRow] ) ;
  if strNumber = '��' then
    exit ;

  //ȷ���Ƿ�Ҫ��Ԣ
  strQuestion := Format('ȷ���Ƴ���Ա: %s ?',[strGridRoom.Cells[aCol,aRow]] );
  if not TBox(strQuestion) then
    Exit ;

  //��ȡ��Ա����ϸ��Ϣ
  if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
  begin
    Box('����ĳ���Ա����');
    exit;
  end;


  //ǿ����Ԣ
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

    //�ӷ����Ƴ���Ա
    m_dbRoomInfo.DelTrainmanFromRoom(trainman.strTrainmanGUID);
    Box('�Ƴ��ɹ�');
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
          
          if strGridRoom.Cells[j,i]  = '��' then
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

  strGridRoom.Cells[0,STR_GRID_HEAD] := '����';
  strGridRoom.Cells[1,STR_GRID_HEAD] := '��λһ';
  strGridRoom.Cells[2,STR_GRID_HEAD] := '��λ��';
  strGridRoom.Cells[3,STR_GRID_HEAD] := '��λ��';
  //strGridRoom.Cells[4,STR_GRID_HEAD] := '����';
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
          strTrainman := '��' ;
        Cells[j+1,i+1] :=  strTrainman;
      end;
      //Cells[4,i+1] :=  RoomInfoList[i].strRoomNumber;
    end;
  end;
  //��ʾ������
  lbCount.Caption := Format(' %d ��',[nPersonCount])  ;
end;

procedure TFrmRoomManage.ShowReport;
var
  mv: TfrxMemoView;
begin
  mv := frxReport1.FindObject('mmoRoomNumber') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '�����' ;

  mv := frxReport1.FindObject('mmoBedNumber1') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λһ' ;

  mv := frxReport1.FindObject('mmoBedNumber2') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λ��' ;

  mv := frxReport1.FindObject('mmoBedNumber3') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '��λ��' ;

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
    if strTrainmanNumber = '��' then
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
