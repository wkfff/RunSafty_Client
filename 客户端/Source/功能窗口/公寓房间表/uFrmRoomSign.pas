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
    //��¼�б�
    m_roomSignList:  TRsRoomSignList ;
    //��¼DB����
    m_dbRoomSgin:   TRsBaseDBRoomSign;
    //����DB����
    m_dbRoomInfo : TRsBaseDBRoomInfo ;
    //��ԱDB����
    m_dbTrainman:TRsDBAccessTrainman ;
    //��Ԣ����i
    m_obRoomSignConfig : TRoomSignConfigOper ;
  private
    //��ȡѡ�е���Ԣ��¼
    function GetSelRoomSign(var RoomGUID:string):Boolean;
    //��ȡ��Ԣ/��Ԣʱ��
    procedure GetSelInTime(var DateTime:TDateTime);
    procedure GetSelOutTime(var DateTime:TDateTime);
    //�޸���Ԣʱ��
    procedure ModifySignInTime();
    //�޸���Ԣʱ��
    procedure ModifySignOutTime();
    //ɾ����Ԣ��¼
    procedure DelSignInRecord();
    //ɾ����Ԣ��¼
    procedure DelSignOutRecord();
    //ɾ��������¼
    procedure DelSignInOutRecord();

    //ִ��Ԣ�еǼ�
    procedure ExecRoomSignIn(Trainman : RRsTrainman;Verify : TRsRegisterFlag);
    //ִ��Ԣ�еǼ�
    procedure ExecRoomSignOut(Trainman : RRsTrainman;Verify : TRsRegisterFlag; InRoomGUID: string; InRoomTime:TDateTime);
    //��Ԣ/��Ԣ�Ǽ�
    procedure InitRoomSign();
    //��Ϣչʾ
    procedure RoomSginToGrid(var RoomSignList:TRsRoomSignList);
    //��ʼ��
    procedure InitData();
    //��Ԣ
    procedure SignIn();
    //��Ԣ
    procedure SignOut();
  public
    procedure  ExportSginRecord();
    { Public declarations }
    //���ý�������Ԣ������Ԣ
    procedure SetSignCaption(AType:Integer);
    //ˢ�½���
    procedure RefreshData();
    //����ָ����
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
  if btnSign.Caption = '��Ԣ' then
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

  if not TBox('ȷ��ɾ��������¼��?') then
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

  if not TBox('ȷ��ɾ����Ԣ��¼��?') then
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


  if not TBox('ȷ��ɾ����Ԣ��¼��?') then
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
      if TextInput('���������', '�����뷿���:', strRoomNumber) = False then
        Exit;
      //����Ƿ����
      if not m_dbRoomInfo.IsRoomExist(strRoomNumber) then
      begin
        if TBox('����Ų�����,�Ƿ񴴽�?') then
          m_dbRoomInfo.InsertRoom(strRoomNumber)
        else
          Exit ;
      end;

      BedInfo.strRoomNumber := strRoomNumber ;
    end ;


    if m_dbRoomInfo.IsRoomFull(BedInfo.strRoomNumber) then
    begin
      if TBox('������Ա����,�Ƿ����跿���?') then
        goto retry
      else
        Exit ;
    end;

    nBedNumber := m_dbRoomInfo.GetEmptyBedNumber(BedInfo.strRoomNumber);
    if nBedNumber = 0 then
    begin
      BoxErr('��ȡ��λ����');
      exit ;
    end;
    BedInfo.nBedNumber := nBedNumber ;

    //��ʾ�û��Ƿ���ķ����
    if not TFrmRoomHint.ChangeBedInfo(BedInfo) then
      Exit ;
    strRoomNumber := BedInfo.strRoomNumber ;
    nBedNumber := BedInfo.nBedNumber ;

    roomSign.strRoomNumber :=   strRoomNumber ;
    roomSign.nBedNumber := nBedNumber ;

    m_dbRoomSgin.InsertSignIn(roomSign);
    m_dbRoomInfo.AddTrainmanToRoom(Trainman.strTrainmanGUID,strRoomNumber,nBedNumber) ;
    //������פ����
    //Box('��Ԣ�����������!');

    //��¼��Ա����������
    m_dbRoomInfo.SaveTrainmanRoomRelation(Trainman.strTrainmanGUID,BedInfo);

    strHint := Format('[%s]%s ��Ԣ�����������!',[roomSign.strTrainmanNumber,roomSign.strTrainmanName]);
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

    //�����
    m_obRoomSignConfig.ReadFromFile;
    if m_obRoomSignConfig.RoomSignConfigInfo.bEnableTimeLimit  then
    begin
      dtOutTime := Now ;
      dtDiff := dtOutTime - InRoomTime ;

      nMinute := Round ( dtDiff * 24 * 60 ) ;//������
        
      if   nMinute <= m_obRoomSignConfig.RoomSignConfigInfo.nSleepTime   then
      begin
        BoxErr('����Ϣ��ָ����ʱ������Ԣ!');
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
      //ɾ������פ����Ĺ�ϵ
      m_dbRoomInfo.DelTrainmanFromRoom(Trainman.strTrainmanGUID);
    end;

    strHint := Format('[%s]%s ��Ԣ�����������!',[roomSign.strTrainmanNumber,roomSign.strTrainmanName]);
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
      Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
      exit;
    end;
    try
      excelApp.Visible := false;
      excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
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


      //ҳ��
      excelApp.ActiveSheet.PageSetup.CenterFooter := '��&Pҳ';
      //��ӡ������
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
      excelApp.Cells[m_nIndex,1].Value := '����Ա���˵Ǽǲ�';
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A2:F2'].Merge(True);
      excelApp.ActiveSheet.Cells[m_nIndex, 1].HorizontalAlignment := 2 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Size := 12 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Bold := True;

      strText := Format('��ʼʱ��: %s',[
        FormatDateTime('yyyy-MM-dd HH:mm:ss', dtStart)]);
      excelApp.Cells[m_nIndex,1].Value := strText;
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A3:F3'].Merge(True);
      excelApp.ActiveSheet.Cells[m_nIndex, 1].HorizontalAlignment := 2 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Size := 12 ;
      excelApp.ActiveSheet.Rows[m_nIndex].Font.Bold := True;

      strText := Format('����ʱ��: %s',[
        FormatDateTime('yyyy-MM-dd HH:mm:ss', dtEnd)]);
      excelApp.Cells[m_nIndex,1].Value := strText;
      excelApp.Cells[m_nIndex,1].Value := strText;
      inc(m_nIndex);

      excelApp.ActiveSheet.range['A4:F4'].Merge(True);
      inc(m_nIndex);

      excelApp.Cells[m_nIndex,1].Value := '����Ա';
      excelApp.Cells[m_nIndex,2].Value := '�����';
      excelApp.Cells[m_nIndex,3].Value := '��Ԣʱ��';
      excelApp.Cells[m_nIndex,4].Value := '��Ԣ��ʽ';
      excelApp.Cells[m_nIndex,5].Value := '��Ԣʱ��';
      excelApp.Cells[m_nIndex,6].Value := '��Ԣ��ʽ';
      //excelApp.Cells[m_nIndex,7].Value := 'ֵ��Ա';



      Inc(m_nIndex);
      for i := 0 to listRecord.Count - 1 do
      begin
        with listRecord.Items[i] do
        begin
          excelApp.Cells[m_nIndex,1].Value := Format('[%s]%s',[strTrainmanNumber,strTrainmanName]);
          excelApp.Cells[m_nIndex,2].Value := strRoomNumber;
          excelApp.Cells[m_nIndex,3].Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtInRoomTime);

          if nInRoomVerifyID = 0 then
            strText := '�ֹ�'
          else
            strText := 'ָ��' ;
          excelApp.Cells[m_nIndex,4].Value := strText;
          if  dtOutRoomTime <> 0 then
          begin
            excelApp.Cells[m_nIndex,5].Value := FormatDateTime('yyyy-MM-dd HH:mm:ss',dtOutRoomTime)  ;

            if  nOutRoomVerifyID = 0 then
              strText := '�ֹ�'
            else
              strText := 'ָ��' ;
            excelApp.Cells[m_nIndex,6].Value := strText;
          end
          else
          begin
            excelApp.Cells[m_nIndex,5].Value := '';
            excelApp.Cells[m_nIndex,6].Value := '';
          end;
          //excelApp.Cells[m_nIndex,7].Value := strDutyUserName ;
        end;

        TfrmProgressEx.ShowProgress('���ڵ�����Ϣ�����Ժ�',i + 1,listRecord.Count);
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
   Application.MessageBox('������ϣ�','��ʾ',MB_OK + MB_ICONINFORMATION);
end;

procedure TFrmRoomSign.FormCreate(Sender: TObject);
begin

  m_roomSignList := TRsRoomSignList.Create();
  m_dbRoomSgin := TRsDBAccessRoomSign.Create(GlobalDM.LocalADOConnection);
  m_dbTrainman  := TRsDBAccessTrainman.Create(GlobalDM.LocalADOConnection);
  m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);

  m_obRoomSignConfig := TRoomSignConfigOper.Create(GlobalDM.AppPath + 'config.ini');
  m_obRoomSignConfig.ReadFromFile ;

    //��¼strGrid���п�
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

  if not TBox('ȷ���޸���Ԣʱ����?') then
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

  if not TBox('ȷ���޸���Ԣ��?') then
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
        strText := '�ֹ�'
      else
        strText := 'ָ��' ;

      Cells[4, i + 1] := strText;


      if RoomSignList.Items[i].dtOutRoomTime <> 0 then
      begin
        Cells[5, i + 1] := FormatDateTime('yyyy-MM-dd HH:mm:ss',RoomSignList.Items[i].dtOutRoomTime)  ;

        if RoomSignList.Items[i].nOutRoomVerifyID = 0 then
          strText := '�ֹ�'
        else
          strText := 'ָ��' ;
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
    btnSign.Caption := '��Ԣ'
  else
    btnSign.Caption := '��Ԣ' ;
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
      if TextInput('����Ա��������', '���������Ա����:', strNumber) = False then
        Exit;
      if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
      begin
        Box('����ĳ���Ա����');
        exit;
      end;

      //����Ƿ��Ѿ���Ԣ
      if  not m_dbRoomSgin.IsSignIn(Now,trainman.strTrainmanNumber,strInRoomGUID,dtInRoomTime) then
      begin
        BoxErr('�Ѿ����Ԣ!');
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
      if TextInput('����Ա��������', '���������Ա����:', strNumber) = False then
        Exit;
      if not m_DBTrainman.GetTrainmanByNumber(Trim(strNumber), trainman) then
      begin
        Box('����ĳ���Ա����');
        exit;
      end;

    end;
    strNumber := trainman.strTrainmanGUID;
    Verify :=  rfInput;

    //����Ƿ�����Ԣ��¼�����û����Ԣ��¼����ʾ
    if  not m_dbRoomSgin.IsSignIn(Now,Trainman.strTrainmanNumber,strInRoomGUID,dtInRoomTime) then
      ExecRoomSignOut(Trainman,Verify,strInRoomGUID,dtInRoomTime)
    else
      BoxErr('û���ҵ��������Ԣ��¼!');
  finally
    //GlobalDM.OnFingerTouching := OnFingerTouching;
  end;
end;

end.
