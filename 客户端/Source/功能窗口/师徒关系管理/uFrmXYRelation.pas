unit uFrmXYRelation;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, PngSpeedButton, ExtCtrls, RzStatus,
  RzPanel, Buttons, PngCustomButton,uXYRelation,uTrainman,uTFSystem,
  ufrmStudentManage,ufrmRsXyOprLog,ComObj,uFrmProgressEx,uLCXYRelation,
  uLCTrainmanMgr;

type
  //师徒关系
  RRsRealtion = record
    strTeacherNumber : string;
    strTeacherName : string;
    strStudentNumber : string;
    strStudentName : string;

    strTeacherGUID : string; 
    strStudentGUID : string;
  end;   
  TRsRealtionArray = array of RRsRealtion;
  
  TfrmXYRelation = class(TForm)
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    RzStatusBar1: TRzStatusBar;
    statusSum: TRzStatusPane;
    Panel1: TPanel;
    Label3: TLabel;
    btnQuery: TPngSpeedButton;
    edtTrainmanName: TEdit;
    Panel2: TPanel;
    lvTrainman: TListView;
    ActionList1: TActionList;
    actEnter: TAction;
    Label2: TLabel;
    edtTrainmanNumber: TEdit;
    btnDeleteTeacher: TPngSpeedButton;
    btnAddTeacher: TPngSpeedButton;
    btnXYRelation: TPngSpeedButton;
    Label4: TLabel;
    edtJp: TEdit;
    btnOprLog: TPngSpeedButton;
    actEsc: TAction;
    btnImport: TPngSpeedButton;
    btnExport: TPngSpeedButton;
    OpenDialog1: TOpenDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnAddTeacherClick(Sender: TObject);
    procedure btnDeleteTeacherClick(Sender: TObject);
    procedure btnXYRelationClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure btnOprLogClick(Sender: TObject);
    procedure lvTrainmanDblClick(Sender: TObject);
    procedure lvTrainmanCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lvTrainmanCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure btnImportClick(Sender: TObject);
    procedure btnExportClick(Sender: TObject);
  private
    { Private declarations }
    {师徒关系数据库操作}
    m_RsLCXYRelation: TRsLCXYRelation;
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_xyTeacherArray : TRsXYTeacherArray;
    function QueryXYRelations(): Integer;
    //导出师徒关系
    procedure ExportRelations;
    //导入师徒关系
    procedure ImportRelations;
  public
    { Public declarations }
  end;
procedure XYRelationManage(Trainman: RRsTrainman);overload;
procedure XYRelationManage();overload;
function GetStudentsArray(Trainman: RRsTrainman): TRsXYStudentArray;
implementation
uses
  uGlobalDM,uFrmAddXY;
function GetStudentsArray(Trainman: RRsTrainman): TRsXYStudentArray;
var
  frmXYRelation: TfrmXYRelation;
begin
  frmXYRelation := TfrmXYRelation.Create(nil);
  try
    frmXYRelation.edtTrainmanNumber.Text := Trainman.strTrainmanNumber;
    frmXYRelation.m_RsLCXYRelation.GetStudents(Trainman.strTrainmanGUID,Result);
  finally
    frmXYRelation.Free;
  end;
end;
procedure XYRelationManage(Trainman: RRsTrainman);
var
  frmXYRelation: TfrmXYRelation;
begin
  frmXYRelation := TfrmXYRelation.Create(nil);
  try
    frmXYRelation.edtTrainmanNumber.Text := Trainman.strTrainmanNumber;
    frmXYRelation.QueryXYRelations;

    frmXYRelation.ShowModal;
  finally
    frmXYRelation.Free;
  end;
end;
procedure XYRelationManage();
var
  frmXYRelation: TfrmXYRelation;
begin
  frmXYRelation := TfrmXYRelation.Create(nil);
  try
    frmXYRelation.ShowModal;
  finally
    frmXYRelation.Free;
  end;
end;
{$R *.dfm}

{ TForm3 }

procedure TfrmXYRelation.actEscExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmXYRelation.btnAddTeacherClick(Sender: TObject);
var
  trainman : RRsTrainman;
begin
  if not TFrmAddXY.InputTrainman('',trainman) then exit;
  try
    m_RsLCXYRelation.AddTeacher(GlobalDM.DutyUser.strDutyGUID,
      trainman.strTrainmanGUID);
    QueryXYRelations();
  except on e : exception do
    begin
      Boxerr('添加师傅失败:' + e.Message);
    end;
  end;
end;

procedure TfrmXYRelation.btnDeleteTeacherClick(Sender: TObject);
var
  strTrainmanGUID : string;
begin
  if lvTrainman.Selected = nil then exit;
  strTrainmanGUID := PRsXYTeacher(lvTrainman.Selected.Data).strTeacherGUID;
  try

    if not TBox('您确定要删除"' +
      TXyRelationStrFormat.GetTeacherText(PRsXYTeacher(lvTrainman.Selected.Data)^) + '"吗?') then
        Exit;

    m_RsLCXYRelation.DeleteTeacher(GlobalDM.DutyUser.strDutyGUID,strTrainmanGUID);
    QueryXYRelations();
  except on e : exception do
    begin
      BoxErr('删除师傅异常:' + e.Message);
    end;
  end;
end;

procedure TfrmXYRelation.btnExportClick(Sender: TObject);
begin
  ExportRelations;
end;

procedure TfrmXYRelation.btnImportClick(Sender: TObject);
begin
  //TfrmImportRealtion.ShowForm;
  ImportRelations; 
  QueryXYRelations();
end;

procedure TfrmXYRelation.btnOprLogClick(Sender: TObject);
begin
  XYLogQuery();
end;

procedure TfrmXYRelation.btnQueryClick(Sender: TObject);
begin
  QueryXYRelations();
end;

procedure TfrmXYRelation.btnXYRelationClick(Sender: TObject);
begin
  if lvTrainman.Selected = nil then
  begin
    Box('请先选择一条记录!');
    Exit;
  end;

  StudentManage(PRsXYTeacher(lvTrainman.Selected.Data).strTeacherGUID);
  QueryXYRelations();
end;

procedure TfrmXYRelation.ExportRelations;
var
  i: Integer;
  Condition: RRsXyQueryCondition;
  excelFile: string;
  excelApp,workBook,workSheet: Variant;
  nIndex : integer;
begin
  if not OpenDialog1.Execute then exit;
  excelFile := OpenDialog1.FileName;
  try
    TfrmProgressEx.ShowProgress('正在启动EXCEL，请稍后',0,1);
    excelApp := CreateOleObject('Excel.Application');
  except
    TfrmProgressEx.CloseProgress;
    Application.MessageBox('你还没有安装Microsoft Excel,请先安装！','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  try
    TfrmProgressEx.ShowProgress('正在初始化导出数据，请稍后',0,1);
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

    nIndex := 1;

    excelApp.Cells[nIndex,1].Value := '师傅工号';
    excelApp.Cells[nIndex,2].Value := '师傅姓名';
    excelApp.Cells[nIndex,3].Value := '学员1工号';
    excelApp.Cells[nIndex,4].Value := '学员1姓名';
    excelApp.Cells[nIndex,5].Value := '学员2工号';
    excelApp.Cells[nIndex,6].Value := '学员2姓名';
    excelApp.Cells[nIndex,7].Value := '学员3工号';
    excelApp.Cells[nIndex,8].Value := '学员3姓名';
    
    Inc(nIndex);
    m_RsLCXYRelation.GetRelations(Condition,m_xyTeacherArray);
    for i := 0 to Length(m_xyTeacherArray) - 1 do
    begin

      excelApp.Cells[nIndex,1].Value := m_xyTeacherArray[i].strTeacherNumber;
      excelApp.Cells[nIndex,2].Value := m_xyTeacherArray[i].strTeacherName;
      if (length(m_xyTeacherArray[i].StudentArray) > 0) then
      begin
        excelApp.Cells[nIndex,3].Value := m_xyTeacherArray[i].StudentArray[0].strStudentNumber;
        excelApp.Cells[nIndex,4].Value := m_xyTeacherArray[i].StudentArray[0].strStudentName;
        if (length(m_xyTeacherArray[i].StudentArray) > 1) then
        begin
          excelApp.Cells[nIndex,5].Value := m_xyTeacherArray[i].StudentArray[1].strStudentNumber;
          excelApp.Cells[nIndex,6].Value := m_xyTeacherArray[i].StudentArray[1].strStudentName;
        end;
        if (length(m_xyTeacherArray[i].StudentArray) > 2) then
        begin
          excelApp.Cells[nIndex,7].Value := m_xyTeacherArray[i].StudentArray[2].strStudentNumber;
          excelApp.Cells[nIndex,8].Value := m_xyTeacherArray[i].StudentArray[2].strStudentName;
        end;
      end;

      TfrmProgressEx.ShowProgress('正在导出司机信息，请稍后',i + 1,length(m_xyTeacherArray));
      Inc(nIndex);
    end;
    if not FileExists(excelFile) then
    begin
      workSheet.SaveAs(excelFile);
    end;
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
  Application.MessageBox('导出完毕！','提示',MB_OK + MB_ICONINFORMATION);
end;

procedure TfrmXYRelation.FormCreate(Sender: TObject);
begin
  m_RsLCXYRelation := TRsLCXYRelation.Create(GlobalDM.WebAPIUtils);
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmXYRelation.FormDestroy(Sender: TObject);
begin
  m_RsLCXYRelation.Free;
  m_RsLCTrainmanMgr.Free;
end;


procedure TfrmXYRelation.ImportRelations;
var
  excelApp: Variant;
  strFile: string;    
  i, k ,nSuccess: integer;
  strTeacherNumber, strTeacherName, strStudentNumber, strStudentName,
    strTeacherGUID,strStudentGUID: string;
  realtionArray : TRsRealtionArray;
  bNoStudent : boolean;
  trainman : RRsTrainman;
begin
  if not OpenDialog1.Execute then exit;
  strFile := OpenDialog1.FileName;

  try
    TfrmProgressEx.ShowProgress('正在启动Excel',0,1);
    excelApp := CreateOleObject('Excel.Application');
  except
    TfrmProgressEx.CloseProgress;
    Box('你还没有安装Microsoft Excel，请先安装！');
    exit;
  end;

  try
    TfrmProgressEx.ShowProgress('正在启动计算要导入的记录数',0,1);
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(strFile);
    excelApp.Worksheets[1].activate;

    for i := 2 to 999 do
    begin
      strTeacherNumber := trim(excelApp.Cells[i, 1].Value);
      strTeacherName := trim(excelApp.Cells[i, 2].Value);
      if Trim(strTeacherNumber) = '' then break;


      if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strTeacherNumber,trainman) then continue;
      strTeacherGUID := trainman.strTrainmanGUID;
      bNoStudent := false;
      for k := 1 to 999 do
      begin
        strStudentNumber := trim(excelApp.Cells[i, (k * 2) + 1].Value);
        strStudentName := trim(excelApp.Cells[i, (k * 2) + 2].Value);
        if not m_RsLCTrainmanMgr.GetTrainmanByNumber(strStudentNumber,trainman) then break;
        strStudentGUID := trainman.strTrainmanGUID;
        bNoStudent := true;
        setlength(realtionArray,length(realtionArray) + 1);
        realtionArray[length(realtionArray) - 1].strTeacherNumber := strTeacherNumber;
        realtionArray[length(realtionArray) - 1].strTeacherName := strTeacherName;
        realtionArray[length(realtionArray) - 1].strStudentNumber := strStudentNumber;
        realtionArray[length(realtionArray) - 1].strStudentName := strStudentName;

        realtionArray[length(realtionArray) - 1].strTeacherGUID := strTeacherGUID;
        realtionArray[length(realtionArray) - 1].strStudentGUID := strStudentGUID;
        TfrmProgressEx.ShowProgress('正在启动计算要导入的记录数:' + IntToStr(Length(realtionArray)),0,1);
      end;
      if not bNoStudent then
      begin
        setlength(realtionArray,length(realtionArray) + 1);
        realtionArray[length(realtionArray) - 1].strTeacherNumber := strTeacherNumber;
        realtionArray[length(realtionArray) - 1].strTeacherName := strTeacherName;
        realtionArray[length(realtionArray) - 1].strStudentNumber := '';
        realtionArray[length(realtionArray) - 1].strStudentName := '';
        realtionArray[length(realtionArray) - 1].strTeacherGUID := strTeacherGUID;
        realtionArray[length(realtionArray) - 1].strStudentGUID := '';
        TfrmProgressEx.ShowProgress('正在计算要导入的记录数:' + IntToStr(Length(realtionArray)),0,1);
      end;
    end;
    TfrmProgressEx.ShowProgress('正在清除之前的师徒关系:' + IntToStr(Length(realtionArray)),0,1);
    m_RsLCXYRelation.ClearXYRelations;
    nSuccess := 0;
    for i := 0 to Length(realtionArray) - 1 do
    begin
      m_RsLCXYRelation.AddTeacherAndStudent(realtionArray[i].strTeacherGUID, realtionArray[i].strStudentGUID);
      inc(nSuccess);
      TfrmProgressEx.ShowProgress('正在导入数据:',i + 1,length(realtionArray));
    end;
    Box('导入完毕，共成功导入(' + IntToStr(nSuccess) + ')条数据' );
  finally
    TfrmProgressEx.CloseProgress;
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

procedure TfrmXYRelation.lvTrainmanCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TfrmXYRelation.lvTrainmanCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TfrmXYRelation.lvTrainmanDblClick(Sender: TObject);
begin
  if lvTrainman.Selected = nil then
  begin
    Exit;
  end;

  StudentManage(PRsXYTeacher(lvTrainman.Selected.Data).strTeacherGUID);
end;

function TfrmXYRelation.QueryXYRelations(): Integer;
var
  i: Integer;
  item : TListItem;
  Condition: RRsXyQueryCondition;
begin
  Condition.Init;
  Condition.strTrainmanNumber := edtTrainmanNumber.Text;
  Condition.strTrainmanName := edtTrainmanName.Text;
  Condition.strJp := edtJp.Text;


  m_RsLCXYRelation.GetRelations(Condition,m_xyTeacherArray);
  lvTrainman.Items.Clear;
  statusSum.Caption := Format('共%d个师傅信息',[Length(m_xyTeacherArray)]);
  Result := length(m_xyTeacherArray); 
  for i := 0 to length(m_xyTeacherArray) - 1 do
  begin
    item := lvTrainman.Items.Add;
    item.Data := @m_xyTeacherArray[i];
    item.Caption := IntToStr(i + 1);
    item.SubItems.Add(TXyRelationStrFormat.GetTeacherText(m_xyTeacherArray[i]));
    item.SubItems.Add(TXyRelationStrFormat.GetStudentArrayText(m_xyTeacherArray[i].StudentArray));
    item.SubItems.Add(m_xyTeacherArray[i].strTeacherGUID);
  end;
end;

end.
