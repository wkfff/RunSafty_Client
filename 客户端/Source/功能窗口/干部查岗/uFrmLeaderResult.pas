unit uFrmLeaderResult;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel, ComCtrls, RzDTP,
  Buttons, PngSpeedButton, StdCtrls, ActnList, Menus,utfsystem,uRoomSign,uDBRoomSign,
  uTrainman,uSaftyEnum,uLeaderExam,uDBLeaderExam,uDBTrainman,uTrainPlan,
  frxClass,uBaseDBRoomSign,uDBAccessRoomSign,ufrmTimeRange;

type
  TFrmLeaderResult = class(TForm)
    rzpnl2: TRzPanel;
    strGridRoomSign: TAdvStringGrid;
    rzpnl3: TRzPanel;
    lb1: TLabel;
    lb2: TLabel;
    lb6: TLabel;
    lbCount: TLabel;
    mm1: TMainMenu;
    mniN1: TMenuItem;
    mniE1: TMenuItem;
    mniV1: TMenuItem;
    mniF1: TMenuItem;
    actlst1: TActionList;
    actFind: TAction;
    frxReport1: TfrxReport;
    frxUserDataSet: TfrxUserDataSet;
    actPrint: TAction;
    mniPrint: TMenuItem;
    btnPrint: TButton;
    lbStartDate: TLabel;
    lbEndDate: TLabel;
    procedure mniE1Click(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure frxUserDataSetGetValue(const VarName: string;
      var Value: Variant);
    procedure frxReport1Preview(Sender: TObject);
    procedure actPrintExecute(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
  private

      //按下指纹仪
    m_OldFingerTouch : TNotifyEvent;
    procedure OnFingerTouching(Sender: TObject);
    //执行插入查岗记录
    procedure ExcuteInspect(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
    //获取入住时间 小时分钟
    function  GetIntakeTime(StartDate,EndDate:TDateTime):string;
    //初始化
    procedure InitData(StartDate,EndDate:TDateTime);
    //刷新界面
    procedure Refresh();
    //打印
    procedure Print();
    //数据显示到界面上
    procedure RoomSginToGrid(var RoomSignList:TRsRoomSignList);
  private
    { Private declarations }
    m_roomSignList:  TRsRoomSignList ;
    m_dbRoomSgin:TRsBaseDBRoomSign;
    m_dbLeaderInspect:TRsBaseDBLeaderInspect;
    m_dbTrainman:TRsDBAccessTrainman ;
    
    m_dtStart:TDateTime ;
    m_dtEnd:TDateTime ;
  public
    { Public declarations }
    class  procedure GetLeaderResult(StartDate,EndDate:TDateTime);
  end;

var
  FrmLeaderResult: TFrmLeaderResult;

implementation

uses
  uGlobalDM,
  ufrmTrainmanIdentityAccess
  ;

{$R *.dfm}

procedure TFrmLeaderResult.actFindExecute(Sender: TObject);
begin
  Refresh ;
end;

procedure TFrmLeaderResult.actPrintExecute(Sender: TObject);
begin
  Print;
end;

procedure TFrmLeaderResult.btnPrintClick(Sender: TObject);
begin
  Print ;
end;

procedure TFrmLeaderResult.btnRefreshClick(Sender: TObject);
begin
  Refresh  ;
end;

procedure TFrmLeaderResult.ExcuteInspect(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
var
  strText:string;
  leaderInspect:RRsLeaderInspect ;
begin

  strText := '' ;
  leaderInspect.strContext := strText ;
  leaderInspect.LeaderGUID := Trainman.strTrainmanGUID ;
  leaderInspect.GUID := NewGUID ;
  leaderInspect.strTrainmanNumber := Trainman.strTrainmanNumber ;
  leaderInspect.VerifyID := ord(Verify);
  leaderInspect.CreateTime := Now ;
  leaderInspect.DutyGUID := '' ;
  m_dbLeaderInspect.AddLeaderInspect(leaderInspect) ;

end;

procedure TFrmLeaderResult.FormCreate(Sender: TObject);
begin
  m_roomSignList := TRsRoomSignList.Create();
  m_dbRoomSgin := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);

  m_dbLeaderInspect := TRsAccessDBLeaderInspect.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);

      //挂接指纹仪点击事件
  m_OldFingerTouch := GlobalDM.OnFingerTouching;
  GlobalDM.OnFingerTouching := OnFingerTouching;
end;

procedure TFrmLeaderResult.FormDestroy(Sender: TObject);
begin
  m_roomSignList.Free;
  m_dbRoomSgin.Free;

  m_dbLeaderInspect.Free;
  m_dbTrainman.Free;

  GlobalDM.OnFingerTouching := m_OldFingerTouch ;
end;

procedure TFrmLeaderResult.frxReport1Preview(Sender: TObject);
begin
  frxUserDataSet.RangeEndCount := m_roomSignList.Count ;
end;

procedure TFrmLeaderResult.frxUserDataSetGetValue(const VarName: string;
  var Value: Variant);
var
  strVerify:string;
  bIsOut:Boolean ;
begin
  bIsOut := False ;

  if m_roomSignList.Items[frxUserDataSet.RecNo].dtOutRoomTime <> 0 then
    bIsOut := True ;


  if VarName ='1' then
  begin
    Value := Format('[%s]%s',[
      m_roomSignList.Items[frxUserDataSet.RecNo].strTrainmanNumber,
      m_roomSignList.Items[frxUserDataSet.RecNo].strTrainmanName]) ;
  end
  else  if VarName='2' then
  begin
    Value := m_roomSignList.Items[frxUserDataSet.RecNo].strRoomNumber ;
  end
  else  if VarName='3' then
  begin
    if m_roomSignList.Items[frxUserDataSet.RecNo].nInRoomVerifyID = 0 then
      strVerify := '手工'
    else
      strVerify := '指纹' ;
    Value :=  strVerify;
  end
  else  if VarName='4' then
  begin
    Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',m_roomSignList.Items[frxUserDataSet.RecNo].dtInRoomTime) ;
  end
  else  if VarName='6' then
  begin
  {
    if bIsOut then
      Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',m_roomSignList.Items[frxUserDataSet.RecNo].dtOutRoomTime)
    else
    }
      Value := '' ;
  end
  else  if VarName='5' then
  begin
    strVerify := '' ;
    Value :=  strVerify;
  end
  else  if VarName='7' then
  begin
    Value := ''//m_roomSignList.Items[frxUserDataSet.RecNo].strDutyUserName ;
  end
end;

function TFrmLeaderResult.GetIntakeTime(StartDate, EndDate: TDateTime): string;
var
  dtDiff:TDateTime ;
  nMinute:Integer ;

begin
  dtDiff := EndDate - StartDate ;
  nMinute := Round ( dtDiff * 24 * 60 ) ;

  Result := Format('%d小时%d分钟',[nMinute div 60, nMinute mod 60] ) ;
end;

class procedure TFrmLeaderResult.GetLeaderResult(StartDate, EndDate: TDateTime);
var
  frm : TFrmLeaderResult ;
begin
  frm := TFrmLeaderResult.Create(nil);
  try
    frm.InitData(StartDate,EndDate);
    frm.ShowModal;
  finally
    frm.Free ;
  end;
end;

procedure TFrmLeaderResult.InitData(StartDate, EndDate: TDateTime);
begin
  m_dtStart := StartDate ;
  m_dtEnd := EndDate ;

  lbStartDate.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss',StartDate) ;
  lbEndDate.Caption := FormatDateTime('yyyy-MM-dd HH:mm:ss',EndDate) ;
  Refresh ;
end;

procedure TFrmLeaderResult.mniE1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmLeaderResult.OnFingerTouching(Sender: TObject);
var
  trainmanPlan: RRsTrainmanPlan;
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,Verify,
    trainmanPlan.Group.Trainman1.strTrainmanGUID,
    trainmanPlan.Group.Trainman2.strTrainmanGUID,
    trainmanPlan.Group.Trainman3.strTrainmanGUID,
    trainmanPlan.Group.Trainman4.strTrainmanGUID) then
  begin
    exit;
  end;

  ExcuteInspect(TrainMan,verify)
end;



procedure TFrmLeaderResult.Print;
var
  mv: TfrxMemoView;
begin

  mv := frxReport1.FindObject('mmoStart') as TfrxMemoView;
  if mv <> nil then
    mv.Text := FormatDateTime('yyyy-MM-dd HH:mm:ss',m_dtStart) ;

  mv := frxReport1.FindObject('mmoEnd') as TfrxMemoView;
  if mv <> nil then
    mv.Text := FormatDateTime('yyyy-MM-dd HH:mm:ss',m_dtEnd) ;

  mv := frxReport1.FindObject('memoName') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '乘务员' ;

  mv := frxReport1.FindObject('memoRoomNumber') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '房间号' ;

  mv := frxReport1.FindObject('memoIn') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '入寓方式' ;

  mv := frxReport1.FindObject('memoInTime') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '入寓时间' ;

  mv := frxReport1.FindObject('memoOut') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '离寓方式' ;

  mv := frxReport1.FindObject('memoOutTime') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '离寓时间' ;

  mv := frxReport1.FindObject('memoDutyName') as TfrxMemoView;
  if mv <> nil then
    mv.Text := '值班员' ;

  mv := frxReport1.FindObject('MemoCount') as TfrxMemoView;
  if mv <> nil then
    mv.Text := Format('%d 个',[m_roomSignList.Count]) ;
    
  frxReport1.ShowReport(True);
end;

procedure TFrmLeaderResult.Refresh;
var
  strSiteGUID:string;
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
  strRoomNumber,strTrainmanNumber,strTrainmanName:string;
begin
  dtStart := m_dtStart;
  dtEnd := m_dtEnd ;


  strRoomNumber := '' ;
  strTrainmanNumber := '' ;
  strTrainmanName := '' ;

  strSiteGUID := '' ;
  m_roomSignList.Clear;

  m_dbRoomSgin.QuerySignListLessThanTime(strRoomNumber,strTrainmanNumber,
    strTrainmanName,dtStart,dtEnd,Now,strSiteGUID,m_roomSignList);
  RoomSginToGrid(m_roomSignList);

  lbCount.Caption := Format('%d 个',[m_roomSignList.Count]);

end;

procedure TFrmLeaderResult.RoomSginToGrid(var RoomSignList: TRsRoomSignList);
var
  i : Integer ;
  strText:string;
  RsRoomSign: TRsRoomSign;
begin
  with strGridRoomSign do
  begin
    ClearRows(1, 10000);
    if RoomSignList.Count > 0 then
      RowCount := RoomSignList.Count + 1
    else begin
      RowCount := 2;
      Cells[99,1] := ''
    end;
    for I := 0 to RoomSignList.Count - 1 do
    begin
      RsRoomSign := RoomSignList.Items[i];
      Cells[0, i + 1] := inttoStr( i + 1 );
      Cells[1, i + 1] := Format('[%s]%s',[RsRoomSign.strTrainmanNumber,RsRoomSign.strTrainmanName]);
      Cells[2, i + 1] := RoomSignList.Items[i].strRoomNumber;


      Cells[3, i + 1] := FormatDateTime('yyyy-MM-dd HH:mm:ss',RoomSignList.Items[i].dtInRoomTime);

      if roomSignList.Items[i].nInRoomVerifyID = 0 then
        strText := '手工'
      else
        strText := '指纹' ;
      Cells[4, i + 1] := strText;

      //已入住时间
      Cells[5, i + 1 ] := GetIntakeTime(RoomSignList.Items[i].dtInRoomTime,m_dtEnd) ;


      if RoomSignList.Items[i].dtOutRoomTime <> 0 then
      begin
        Cells[6, i + 1] := FormatDateTime('yyyy-MM-dd HH:mm:ss',RoomSignList.Items[i].dtOutRoomTime)  ;

        if RoomSignList.Items[i].nOutRoomVerifyID = 0 then
          strText := '手工'
        else
          strText := '指纹' ;
        Cells[7, i + 1] := strText;
      end
      else
      begin
        Cells[6, i + 1] := '' ;
        Cells[7, i + 1] := '' ;
      end;
      Cells[8 , i+1 ] := RoomSignList.Items[i].strDutyUserName  ;
      Cells[99,i+1] := RoomSignList.Items[i].strInRoomGUID ;
    end;
  end;
end;

end.
