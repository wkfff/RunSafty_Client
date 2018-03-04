unit uFrmRoomSign;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzDTP, StdCtrls, Buttons, PngCustomButton, ExtCtrls,
  RzPanel, Grids, AdvObj, BaseGrid, AdvGrid,uRoomSign,
  uTrainman,uSaftyEnum,uBaseDBRoomSign,uDBAccessRoomSign,uDBRoomSign,utfsystem, Menus,
  uTrainPlan,uRoomSignConfig,ComObj;

type
  TFrmRoomSign = class(TForm)
    rzpnl3: TRzPanel;
    lb3: TLabel;
    lb4: TLabel;
    lb1: TLabel;
    lb2: TLabel;
    btnQuery: TPngCustomButton;
    lb5: TLabel;
    edtRoomNumber: TEdit;
    edtTrainmanNumber: TEdit;
    dtpStartDate: TRzDateTimePicker;
    dtpStartTime: TDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    dtpEndTime: TDateTimePicker;
    edtTrainmanName: TEdit;
    rzpnl2: TRzPanel;
    strGridRoomSign: TAdvStringGrid;
    pMenu1: TPopupMenu;
    mniModiyInTime: TMenuItem;
    mniModiyOutTime: TMenuItem;
    mniN8: TMenuItem;
    mniDelInRecord: TMenuItem;
    mniDelOutRecord: TMenuItem;
    mniDelInOutRecord: TMenuItem;
    btnSign: TSpeedButton;
    SaveDialog1: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniModiyOutTimeClick(Sender: TObject);
    procedure mniDelInRecordClick(Sender: TObject);
    procedure mniDelOutRecordClick(Sender: TObject);
    procedure mniDelInOutRecordClick(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure mniModiyInTimeClick(Sender: TObject);
    procedure btnSignClick(Sender: TObject);

  private
    //记录列表
    m_roomSignList:  TRsRoomSignList ;
    //记录DB操作
    m_dbRoomSgin:   TRsBaseDBRoomSign;
    //房间DB操作
    m_dbRoomInfo : TRsBaseDBRoomInfo ;
    //人员DB操作
    m_dbTrainman:TRsDBAccessTrainman ;
    //公寓配置i
    m_obRoomSignConfig : TRoomSignConfigOper ;
  private
    //获取选中的入寓记录
    function GetSelRoomSign(var RoomGUID:string):Boolean;
    //获取入寓/离寓时间
    procedure GetSelInTime(var DateTime:TDateTime);
    procedure GetSelOutTime(var DateTime:TDateTime);
    //修改入寓时间
    procedure ModifySignInTime();
    //修改离寓时间
    procedure ModifySignOutTime();
    //删除入寓记录
    procedure DelSignInRecord();
    //删除离寓记录
    procedure DelSignOutRecord();
    //删除整个记录
    procedure DelSignInOutRecord();

    //执入寓行登记
    procedure ExecRoomSignIn(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
    //执离寓行登记
    procedure ExecRoomSignOut(Trainman : RRsTrainman;Verify : TRsRegisterFlag; InRoomGUID: string; InRoomTime:TDateTime);
    //入寓/离寓登记
    procedure InitRoomSign();
    //信息展示
    procedure RoomSginToGrid(var RoomSignList:TRsRoomSignList);
    //初始化
    procedure InitData();
    //入寓
    procedure SignIn();
    //离寓
    procedure SignOut();
  public
    procedure  ExportSginRecord();
    { Public declarations }
    //设置界面是入寓还是离寓
    procedure SetSignCaption(AType:Integer);
    //刷新界面
    procedure RefreshData();
    //按下指纹仪
    procedure OnFingerTouching(Sender: TObject);
  end;

var
  FrmRoomSign: TFrmRoomSign;

implementation

uses
  uGlobalDM ,
  utfPopBox ,
  ufrmTextInput,
  uFrmGetDateTime,
  ufrmTrainmanIdentityAccess,
  ufrmTimeRange,
  uFrmProgressEx,
  uFrmRoomHint;

{$R *.dfm}

{ TFrmRoomSign }


procedure TFrmRoomSign.btnQueryClick(Sender: TObject);
begin
  InitRoomSign;
end;

procedure TFrmRoomSign.btnSignClick(Sender: TObject);
begin
  if btnSign.Caption = '入寓' then
    SignIn
  else
    SignOut ;
end;

procedure TFrmRoomSign.DelSignInOutRecord();
var
  strRoomSignGUID:string;
begin
  if  not GetSelRoomSign(strRoomSignGUID) then
    exit ;

  if not TBox('确认删除整条记录吗?') then
    Exit ;

  m_dbRoomSgin.DelSignInOutRecord(strRoomSignGUID);
  InitData;
end;

procedure TFrmRoomSign.DelSignInRecord();
var
  strRoomSignGUID:string;
begin
  if  not GetSelRoomSign(strRoomSignGUID) then
    exit ;

  if not TBox('确认删除入寓记录吗?') then
    Exit ;

  m_dbRoomSgin.DelSignInRecord(strRoomSignGUID);
  InitData;
end;

procedure TFrmRoomSign.DelSignOutRecord();
var
  strRoomSignGUID:string;
begin
  if  not GetSelRoomSign(strRoomSignGUID) then
    exit ;

  if not m_dbRoomSgin.IsExistSignOutRecord(strRoomSignGUID) then
    Exit ;


  if not TBox('确认删除离寓记录吗?') then
    Exit ;

  m_dbRoomSgin.DelSignOutRecord(strRoomSignGUID);
  InitData;
end;

procedure TFrmRoomSign.ExecRoomSignIn(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag);
label
  retry;
var
  nBedNumber:Integer ;
  roomSign : TRsRoomSign ;
  strRoomNumber:string;
  strHint:string;
  BedInfo:RRsBedInfo;
begin

  roomSign := TRsRoomSign.Create;
  try
    roomSign.strInRoomGUID := NewGUID ;
    roomSign.strTrainPlanGUID := '';
    roomSign.strDutyUserGUID := '' ;
    roomSign.strSiteGUID := '' ;
    roomSign.strTrainmanGUID := Trainman.strTrainmanGUID ;
    roomSign.strTrainmanNumber := Trainman.strTrainmanNumber;
    roomSign.strTrainmanName := Trainman.strTrainmanName;
    roomSign.nInRoomVerifyID := ord(Verify);
    roomSign.dtInRoomTime := Now ;

    BedInfo.strTrainmanGUID := Trainman.strTrainmanGUID ;
    BedInfo.strTrainmanNumber := Trainman.strTrainmanNumber ;
    BedInfo.strTrainmanName := Trainman.strTrainmanName ;

    if not m_dbRoomInfo.GetTrainmanRoomRelation(Trainman.strTrainmanGUID,BedInfo) then
    begin
    retry:
      if TextInput('房间号输入', '请输入房间号:', strRoomNumber) = False then
        Exit;
      //检查是否存在
      if not m_dbRoomInfo.IsRoomExist(strRoomNumber) then
      begin
        if TBox('房间号不存在,是否创建?') then
          m_dbRoomInfo.InsertRoom(strRoomNumber)
        else
          Exit ;
      end;

      BedInfo.strRoomNumber := strRoomNumber ;
    end ;


    if m_dbRoomInfo.IsRoomFull(BedInfo.strRoomNumber) then
    begin
      if TBox('房间人员已满,是否重设房间号?') then
        goto retry
      else
        Exit ;
    end;

    nBedNumber := m_dbRoomInfo.GetEmptyBedNumber(BedInfo.strRoomNumber);
    if nBedNumber = 0 then
    begin
      BoxErr('获取床位错误');
      exit ;
    end;
    BedInfo.nBedNumber := nBedNumber ;

    //提示用户是否更改房间号
    if not TFrmRoomHint.ChangeBedInfo(BedInfo) then
      Exit ;
    strRoomNumber := BedInfo.strRoomNumber ;
    nBedNumber := BedInfo.nBedNumber ;

    roomSign.strRoomNumber :=   strRoomNumber ;
    roomSign.nBedNumber := nBedNumber ;

    m_dbRoomSgin.InsertSignIn(roomSign);
    m_dbRoomInfo.AddTrainmanToRoom(Trainman.strTrainmanGUID,strRoomNumber,nBedNumber) ;
    //增加入驻房间
    //Box('入寓手续办理完毕!');

    //记录人员的最近房间号
    m_dbRoomInfo.SaveTrainmanRoomRelation(Trainman.strTrainmanGUID,BedInfo);

    strHint := Format('[%s]%s 入寓手续办理完毕!',[roomSign.strTrainmanNumber,roomSign.strTrainmanName]);
    TtfPopBox.ShowBox(strHint);

  finally
    roomSign.Free;
  end;
  InitData ;
end;

procedure TFrmRoomSign.ExecRoomSignOut(Trainman: RRsTrainman;
  Verify: TRsRegisterFlag; InRoomGUID: string; InRoomTime: TDateTime);
label
  retry;
var
  roomSign : TRsRoomSign ;
  dtOutTime:TDateTime ;
  dtDiff:TDateTime ;
  nMinute:Integer ;
  strHint:string;
begin
  roomSign := TRsRoomSign.Create;
  try
    roomSign.strOutRoomGUID := NewGUID ;
    roomSign.strInRoomGUID := InRoomGUID ;
    roomSign.dtInRoomTime := InRoomTime ;

    //如果是
    m_obRoomSignConfig.ReadFromFile;
    if m_obRoomSignConfig.RoomSignConfigInfo.bEnableTimeLimit  then
    begin
      dtOutTime := Now ;
      dtDiff := dtOutTime - InRoomTime ;

      nMinute := Round ( dtDiff * 24 * 60 ) ;//分钟数
        
      if   nMinute <= m_obRoomSignConfig.RoomSignConfigInfo.nSleepTime   then
      begin
        BoxErr('请休息够指定的时间再离寓!');
        Exit ;
      end;
    end;

    roomSign.strDutyUserGUID := '' ;
    roomSign.strSiteGUID := '' ;
    roomSign.strTrainmanGUID := Trainman.strTrainmanGUID ;
    roomSign.strTrainmanNumber := Trainman.strTrainmanNumber;
    roomSign.strTrainmanName := Trainman.strTrainmanName;
    roomSign.nOutRoomVerifyID := ord(Verify);
    roomSign.dtOutRoomTime := Now ;

    if TRUE  then
    begin
      m_dbRoomSgin.InsertSignOut(roomSign);
      //删除与入驻房间的关系
      m_dbRoomInfo.DelTrainmanFromRoom(Trainman.strTrainmanGUID);
    end;

    strHint := Format('[%s]%s 离寓手续办理完毕!',[roomSign.strTrainmanNumber,roomSign.strTrainmanName]);
    TtfPopBox.ShowBox(strHint);
  finally
    roomSign.Free;
  end;

  InitData ;
end;

procedure TFrmRoomSign.ExportSginRecord;
var
  dtStart,dtEnd:TDateTime ;
  bShowUnnormal : Boolean ;
  listRecord:TRsRoomSignList;
  excelApp,workBook,workSheet: Variant;
  excelFile:string;
  m_nIndex:Integer ;
  strText:string;
  i: Integer;
begin

  dtStart := StrToDateTime(FormatDateTime('yyyy-MM-dd', Now) + ' 08:00');
  dtEnd := StrToDateTime(FormatDateTime('yyyy-MM-dd', Now) + ' 23:00');
  if not TuDingTimeRange(dtStart,dtEnd) then
    exit ;

//  SaveDialog1.FileName :=  FormatDateTime('yyyy-MM-dd HH:mm:ss', Now) + '.xls';
  if not SaveDialog1.Execute then exit;

  listRecord := TRsRoomSignList.Create;
  try
    bShowUnnormal := True ;
    m_dbRoomSgin.QuerySignList('','','',dtStart,dtEnd,'',listRecord,bShowUnnormal);

    excelFile := SaveDialog1.FileName;
    try
      excelApp := CreateOleObject('Excel.Application');
    except
      Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    try
      excelApp.Visible := false;
      excelApp.Caption := '应用程序调用 Microsoft Excel';
      if FileExists(excelFile) then
      begin
        excelApp.workBooks.Open(excelFile);
         excelApp.Worksheets[1].activate;
      end
      else begin
        excelApp.WorkBooks.Add;
        workBook:=excelApp.Workbooks.Add;
        workSheet:=workBook.Sheets.Add;
      end;
      m_nIndex := 1;


      //页脚
      excelApp.ActiveSheet.PageSetup.CenterFooter := '第&P页';
      //打印网格线
      excelApp.ActiveSheet.PageSetup.LeftMargin := 2/0.035;
      excelApp.ActiveSheet.PageSetup.RightMargin := 2/0.035;
      excelApp.ActiveSheet.PageSetup.TopMargin := 1/0.035;
      excelApp.ActiveSheet.PageSetup.BottomMargin := 1/0.035;

      //excelApp.ActiveSheet.PageSetup.CenterHorizontally := 2/0.035;
     // excelApp.ActiveSheet.PageSetup.CenterVertically := 2/0.035;

      excelApp.ActiveSheet.PageSetup.PrintGridLines := True;

      excelApp.ActiveSheet.Columns[1].ColumnWidth := 13;
      excelApp.ActiveSheet.Columns[2].ColumnWidth := 9;
      excelApp.ActiveSheet.Columns[3].ColumnWidth := 15;
      excelApp.ActiveSheet.Columns[4].ColumnWidth := 10;
      excelApp.ActiveSheet.Columns[5].ColumnWidth := 15;
      excelApp.ActiveSheet.Columns[6].ColumnWidth := 10;

      excelApp.ActiveSheet.Columns[1].HorizontalAlignment:=2;
      excelApp.ActiveSheet.Columns[2].HorizontalAlignment:=2;
      excelApp.ActiveSheet.Columns[3].HorizontalAlignment:=2;
      excelApp.ActiveSheet.Columns[4].HorizontalAlignment:=2;
      excelApp.ActiveSheet.Columns[5].HorizontalAlignment:=2;
      excelApp.ActiveSheet.Columns[6].HorizontalAlignment:=2;

      excelApp.ActiveSheet.range['A1:F1'].Merge(True);
      excelApp.ActiveSheet.Cells[m_nIndex, 1].HorizontalAlignment := 3 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Size := 15 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Bold := True;
      excelApp.Cells[m_nIndex,1].Value := '乘务员待乘登记簿';
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A2:F2'].Merge(True);
      excelApp.ActiveSheet.Cells[m_nIndex, 1].HorizontalAlignment := 2 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Size := 12 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Bold := True;

      strText := Format('起始时间: %s',[
        FormatDateTime('yyyy-MM-dd HH:mm:ss', dtStart)]);
      excelApp.Cells[m_nIndex,1].Value := strText;
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A3:F3'].Merge(True);
      excelApp.ActiveSheet.Cells[m_nIndex, 1].HorizontalAlignment := 2 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Size := 12 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Bold := True;

      strText := Format('结束时间: %s',[
        FormatDateTime('yyyy-MM-dd HH:mm:ss', dtEnd)]);
      excelApp.Cells[m_nIndex,1].Value := strText;
      excelApp.Cells[m_nIndex,1].Value := strText;
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A4:F4'].Merge(True);
      inc(m_nIndex);

      excelApp.Cells[m_nIndex,1].Value := '乘务员';
      excelApp.Cells[m_nIndex,2].Value := '房间号';
      excelApp.Cells[m_nIndex,3].Value := '入寓时间';
      excelApp.Cells[m_nIndex,4].Value := '入寓方式';
      excelApp.Cells[m_nIndex,5].Value := '离寓时间';
      excelApp.Cells[m_nIndex,6].Value := '离寓方式';
      //excelApp.Cells[m_nIndex,7].Value := '值班员';



      Inc(m_nIndex);
      for i := 0 to listRecord.Count - 1 do
      begin
        with listRecord.Items[i] do
        begin
          excelApp.Cells[m_nIndex,1].Value := Format('[%s]%s',[strTrainmanNumber,strTrainmanName]);
          excelApp.Cells[m_nIndex,2].Value := strRoomNumber;
          excelApp.Cells[m_nIndex,3].Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtInRoomTime);

          if nInRoomVerifyID = 0 then
            strText := '手工'
          else
            strText := '指纹' ;
          excelApp.Cells[m_nIndex,4].Value := strText;
          if  dtOutRoomTime <> 0 then
          begin
            excelApp.Cells[m_nIndex,5].Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtOutRoomTime)  ;

            if  nOutRoomVerifyID = 0 then
              strText := '手工'
            else
              strText := '指纹' ;
            excelApp.Cells[m_nIndex,6].Value := strText;
          end
          else
          begin
            excelApp.Cells[m_nIndex,5].Value := '';
            excelApp.Cells[m_nIndex,6].Value := '';
          end;
          //excelApp.Cells[m_nIndex,7].Value := strDutyUserName ;
        end;

        TfrmProgressEx.ShowProgress('正在导出信息，请稍后',i + 1,listRecord.Count);
        Inc(m_nIndex);
      end;
      if not FileExists(excelFile) then
        workSheet.SaveAs(excelFile);
    finally
      TfrmProgressEx.CloseProgress;
      excelApp.Quit;
      excelApp := Unassigned;
    end;
  finally
    listRecord.Free ;
  end;
   Application.MessageBox('导出完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TFrmRoomSign.FormCreate(Sender: TObject);
begin

  m_roomSignList := TRsRoomSignList.Create();
  m_dbRoomSgin := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman  := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);

  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  m_obRoomSignConfig.ReadFromFile ;

    //记录strGrid的列宽
  strGridRoomSign.ColumnSize.Key := 'FormColWidths.ini';
  strGridRoomSign.ColumnSize.Section := 'RoomSign';
  strGridRoomSign.ColumnSize.Save := false;
  strGridRoomSign.ColumnSize.Location := clIniFile;
  GlobalDM.SetGridColumnWidth(strGridRoomSign);
  GlobalDM.SetGridColumnVisible(strGridRoomSign);

  dtpStartDate.Date := Now ;
  dtpStartDate.Format := 'yyyy-MM-dd';
  dtpEndDate.Date := Now ;
  dtpEndDate.Format := 'yyyy-MM-dd';

  InitData ;

end;

procedure TFrmRoomSign.FormDestroy(Sender: TObject);
begin
  GlobalDM.SaveGridColumnWidth(strGridRoomSign);
  m_roomSignList.Free ;
  m_dbRoomSgin.Free ;
  m_dbTrainman.Free ;
  m_dbRoomInfo.Free ;
  m_obRoomSignConfig.Free ;
end;

procedure TFrmRoomSign.GetSelInTime(var DateTime: TDateTime);
var
  i : Integer;
  index :Integer ;
begin
  i := 0 ;
  if strGridRoomSign.SelectedRowCount < 0 then
    Exit ;

  index := strGridRoomSign.SelectedRow[i];
  DateTime := StrToDateTime(strGridRoomSign.Cells[3,index] );
end;

procedure TFrmRoomSign.GetSelOutTime(var DateTime: TDateTime);
var
  i : Integer;
  index :Integer ;
begin
  i := 0 ;
  if strGridRoomSign.SelectedRowCount < 0 then
    Exit ;

  index := strGridRoomSign.SelectedRow[i];
  DateTime := StrToDateTime(strGridRoomSign.Cells[5 ,index] );
end;

function TFrmRoomSign.GetSelRoomSign(var RoomGUID: string): Boolean;
var
  i : Integer;
  index :Integer ;
begin
  if strGridRoomSign.SelectedRowCount < 0 then
    Result := False ;
  i := 0 ;
  index := strGridRoomSign.SelectedRow[i];
  RoomGUID := strGridRoomSign.Cells[99, index];
  Result := True ;
end;

procedure TFrmRoomSign.InitData;
begin
  InitRoomSign ;
end;

procedure TFrmRoomSign.InitRoomSign;
var
  strSiteGUID:string;
  dtStart:TDateTime ;
  dtEnd:TDateTime ;
  strRoomNumber,strTrainmanNumber,strTrainmanName:string;
  bShowUnnormal:Boolean ;
begin

  dtStart := AssembleDateTime(dtpStartDate.Date,dtpStartTime.Time);
  dtEnd := AssembleDateTime(dtpEndDate.Date,dtpEndTime.Time) ;

  strRoomNumber := edtRoomNumber.Text ;
  strTrainmanNumber := edtTrainmanNumber.Text ;
  strTrainmanName := edtTrainmanName.Text ;

  if GlobalDM.SiteInfo = nil then
    strSiteGUID := '' 
  else
    strSiteGUID := GlobalDM.SiteInfo.strSiteGUID ;
  m_roomSignList.Clear;
  bShowUnnormal := True  ;
  m_dbRoomSgin.QuerySignList(strRoomNumber,strTrainmanNumber,strTrainmanName,dtStart,dtEnd,strSiteGUID,m_roomSignList,bShowUnnormal);
  RoomSginToGrid(m_roomSignList);
end;

procedure TFrmRoomSign.mniDelInOutRecordClick(Sender: TObject);
begin
  DelSignInOutRecord;
end;

procedure TFrmRoomSign.mniDelInRecordClick(Sender: TObject);
begin
  DelSignInRecord;
end;

procedure TFrmRoomSign.mniDelOutRecordClick(Sender: TObject);
begin
  DelSignOutRecord;
end;

procedure TFrmRoomSign.mniModiyInTimeClick(Sender: TObject);
begin
  ModifySignInTime;
end;

procedure TFrmRoomSign.mniModiyOutTimeClick(Sender: TObject);
begin
  ModifySignOutTime;
end;

procedure TFrmRoomSign.ModifySignInTime();
var
  strRoomSignGUID:string;
  date:TDateTime ;
begin
  if  not GetSelRoomSign(strRoomSignGUID) then
    exit ;

  GetSelInTime(date);

  if not TFrmGetDateTime.GetDateTime(date) then
    Exit ;

  if not TBox('确认修改入寓时间吗?') then
    Exit ;

  m_dbRoomSgin.UpdateSignInTime(strRoomSignGUID,date);
  InitData;
end;

procedure TFrmRoomSign.ModifySignOutTime();
var
  strRoomSignGUID:string;
  date:TDateTime ;
begin
  if  not GetSelRoomSign(strRoomSignGUID) then
    exit ;

  if not m_dbRoomSgin.IsExistSignOutRecord(strRoomSignGUID) then
    Exit ;

   GetSelOutTime(date);

  if not TFrmGetDateTime.GetDateTime(date) then
    Exit ;

  if not TBox('确认修改离寓吗?') then
    Exit ;

  m_dbRoomSgin.UpdateSignOutTime(strRoomSignGUID,date);
  InitData;
end;

procedure TFrmRoomSign.OnFingerTouching(Sender: TObject);
var
  trainmanPlan: RRsTrainmanPlan;
  TrainMan: RRsTrainman;
  Verify: TRsRegisterFlag;
  strInRoomGUID:string;
  dtInRoomTime:TDateTime ;
begin
  if not TFrmTrainmanIdentityAccess.IdentfityTrainman(Sender,TrainMan,Verify,
    trainmanPlan.Group.Trainman1.strTrainmanGUID,
    trainmanPlan.Group.Trainman2.strTrainmanGUID,
    trainmanPlan.Group.Trainman3.strTrainmanGUID,
    trainmanPlan.Group.Trainman4.strTrainmanGUID) then
  begin
    exit;
  end;

  if  m_dbRoomSgin.IsSignIn(Now,Trainman.strTrainmanNumber,strInRoomGUID,dtInRoomTime) then
    ExecRoomSignIn(TrainMan,verify)
  else
    ExecRoomSignOut(TrainMan,verify,strInRoomGUID,dtInRoomTime)
end;


procedure TFrmRoomSign.RefreshData();
begin
  InitRoomSign;
end;


procedure TFrmRoomSign.RoomSginToGrid(var RoomSignList: TRsRoomSignList);
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
      Cells[0, i + 1] := inttoStr( RoomSignList.Count - i ); //inttoStr( i + 1 );
      Cells[1, i + 1] := Format('[%s]%s',[RsRoomSign.strTrainmanNumber,RsRoomSign.strTrainmanName]);
      Cells[2, i + 1] := RoomSignList.Items[i].strRoomNumber;


      Cells[3, i + 1] := FormatDateTime('yyyy-MM-dd HH:mm:ss',RoomSignList.Items[i].dtInRoomTime);

      if roomSignList.Items[i].nInRoomVerifyID = 0 then
        strText := '手工'
      else
        strText := '指纹' ;

      Cells[4, i + 1] := strText;


      if RoomSignList.Items[i].dtOutRoomTime <> 0 then
      begin
        Cells[5, i + 1] := FormatDateTime('yyyy-MM-dd HH:mm:ss',RoomSignList.Items[i].dtOutRoomTime)  ;

        if RoomSignList.Items[i].nOutRoomVerifyID = 0 then
          strText := '手工'
        else
          strText := '指纹' ;
        Cells[6, i + 1] := strText;
      end
      else
      begin
        Cells[5, i + 1] := '' ;
        Cells[6, i + 1] := '' ;
      end;

      if ( RoomSignList.Items[i].dtOutRoomTime <> 0  ) and
          ( RoomSignList.Items[i].dtInRoomTime <> 0  )
      then
      begin
        Cells[7, i + 1] := FormatDateTime('HH:mm',RoomSignList.Items[i].dtOutRoomTime - RoomSignList.Items[i].dtInRoomTime );
      end;


      Cells[99,i+1] := RoomSignList.Items[i].strInRoomGUID ;
    end;
  end;
end;


procedure TFrmRoomSign.SetSignCaption(AType: Integer);
begin
  if AType = 0 then
    btnSign.Caption := '入寓'
  else
    btnSign.Caption := '离寓' ;
end;



procedure TFrmRoomSign.SignIn;
var
  strNumber : string;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
  strInRoomGUID:string;
  dtInRoomTime:TDateTime;
begin
  //GlobalDM.OnFingerTouching := nil;
  try
    begin
      if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
        Exit;
      if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
      begin
        Box('错误的乘务员工号');
        exit;
      end;

      //检查是否已经入寓
      if  not m_dbRoomSgin.IsSignIn(Now,trainman.strTrainmanNumber,strInRoomGUID,dtInRoomTime) then
      begin
        BoxErr('已经入过寓!');
        Exit;
      end;

    end;

    strNumber := trainman.strTrainmanGUID;
    Verify :=  rfInput;
    ExecRoomSignIn(Trainman,Verify);
  finally
    //GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

procedure TFrmRoomSign.SignOut;
var
  strNumber : string;
  trainman : RRsTrainman;
  Verify :  TRsRegisterFlag;
  strInRoomGUID:string;
  dtInRoomTime:TDateTime ;
begin
  //GlobalDM.OnFingerTouching := nil;
  try
    begin
      if TextInput('乘务员工号输入', '请输入乘务员工号:', strNumber) = False then
        Exit;
      if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
      begin
        Box('错误的乘务员工号');
        exit;
      end;

    end;
    strNumber := trainman.strTrainmanGUID;
    Verify :=  rfInput;

    //检查是否有入寓记录，如果没有入寓记录就提示
    if  not m_dbRoomSgin.IsSignIn(Now,Trainman.strTrainmanNumber,strInRoomGUID,dtInRoomTime) then
      ExecRoomSignOut(Trainman,Verify,strInRoomGUID,dtInRoomTime)
    else
      BoxErr('没有找到最近的入寓记录!');
  finally
    //GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

end.
