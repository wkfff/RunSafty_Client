unit ufrmImportRealtion;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComObj, uTFSystem, RzButton, ComCtrls, RzListVw, RzBorder,
  uDBXYRelation, uXYRelation, uGlobalDM;

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
  
type
  TfrmImportRealtion = class(TForm)
    RzBorder1: TRzBorder;
    lvRealtion: TRzListView;
    btnOpen: TRzBitBtn;
    btnImport: TRzBitBtn;
    btnExit: TRzBitBtn;
    OpenDialog: TOpenDialog;
    procedure btnOpenClick(Sender: TObject);
    procedure btnImportClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure lvRealtionCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvRealtionCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
  private
    { Private declarations }        
    {师徒关系数据库操作}
    m_DBXYRealtion : TRsDBXURelation;

    //简单的司机信息数组
    m_SimpleTrainmanArray: TRsSimpleTrainmanArray;
    //师徒关系数组
    m_RealtionArray: TRsRealtionArray;

    //根据司机工号，获取司机GUID
    function GetTrainmanGUID(strTrainmanNumber: string): string;
  public
    { Public declarations }
    //提供类接口，显示窗口
    class procedure ShowForm;
  end;

implementation

{$R *.dfm}
     
procedure TfrmImportRealtion.FormCreate(Sender: TObject);
begin
  m_DBXYRealtion := TRsDBXURelation.Create(GlobalDM.ADOConnection);
end;

procedure TfrmImportRealtion.FormDestroy(Sender: TObject);
begin
  m_DBXYRealtion.Free;
end;

procedure TfrmImportRealtion.FormShow(Sender: TObject);
begin
  m_DBXYRealtion.GetSimpleTrainmans(m_SimpleTrainmanArray);
end;

class procedure TfrmImportRealtion.ShowForm;
var
  frmImportRealtion: TfrmImportRealtion;
begin
  frmImportRealtion := TfrmImportRealtion.Create(nil);
  frmImportRealtion.ShowModal;
  frmImportRealtion.Free;
end;
                  
procedure TfrmImportRealtion.lvRealtionCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TfrmImportRealtion.lvRealtionCustomDrawSubItem(
  Sender: TCustomListView; Item: TListItem; SubItem: Integer;
  State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TfrmImportRealtion.btnOpenClick(Sender: TObject);
var
  excelApp: Variant;  
  Item: TListItem;
  strFile: string;    
  i, n: integer;
  strTeacherNumber, strTeacherName, strStudentNumber, strStudentName: string;
begin
  if not OpenDialog.Execute then exit;
  strFile := OpenDialog.FileName;

  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Box('你还没有安装Microsoft Excel，请先安装！');
    exit;
  end;

  try
    excelApp.Visible := false;
    excelApp.Caption := '应用程序调用 Microsoft Excel';
    excelApp.workBooks.Open(strFile);
    excelApp.Worksheets[1].activate;

    SetLength(m_RealtionArray, 0);
    for i := 2 to 999 do
    begin
      strTeacherNumber := trim(excelApp.Cells[i, 1].Value);
      strTeacherName := trim(excelApp.Cells[i, 2].Value);
      strStudentNumber := trim(excelApp.Cells[i, 3].Value);
      strStudentName := trim(excelApp.Cells[i, 4].Value);
      if (strTeacherNumber = '') and (strStudentNumber = '') then break;

      n := Length(m_RealtionArray);
      SetLength(m_RealtionArray, n + 1);
      m_RealtionArray[n].strTeacherNumber := strTeacherNumber;
      m_RealtionArray[n].strTeacherName := strTeacherName;
      m_RealtionArray[n].strStudentNumber := strStudentNumber;
      m_RealtionArray[n].strStudentName := strStudentName;
    end;

    lvRealtion.Items.Clear;
    for i := 0 to Length(m_RealtionArray) - 1 do
    begin
      Item := lvRealtion.Items.Add;
      Item.Caption := IntToStr(i+1);
      Item.SubItems.Add(m_RealtionArray[i].strTeacherNumber);
      Item.SubItems.Add(m_RealtionArray[i].strTeacherName);
      Item.SubItems.Add(m_RealtionArray[i].strStudentNumber);
      Item.SubItems.Add(m_RealtionArray[i].strStudentName);
    end;
  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;
end;

procedure TfrmImportRealtion.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmImportRealtion.btnImportClick(Sender: TObject);
var
  i, nSuccess: integer;
begin
  for i := 0 to Length(m_RealtionArray) - 1 do
  begin
    m_RealtionArray[i].strTeacherGUID := GetTrainmanGUID(m_RealtionArray[i].strTeacherNumber);
    m_RealtionArray[i].strStudentGUID := GetTrainmanGUID(m_RealtionArray[i].strStudentNumber);
  end;

  nSuccess := 0;
  for i := 0 to Length(m_RealtionArray) - 1 do
  begin
    if m_DBXYRealtion.AddTeacherAndStudent(m_RealtionArray[i].strTeacherGUID, m_RealtionArray[i].strStudentGUID) then
    begin
      inc(nSuccess);
    end;
  end;

  Box(Format('导入完毕，共导入%d条数据！', [nSuccess]));
end;

function TfrmImportRealtion.GetTrainmanGUID(strTrainmanNumber: string): string;
var
  i: integer;
begin
  result := '';
  if strTrainmanNumber = '' then exit;
  
  for i := 0 to Length(m_SimpleTrainmanArray) - 1 do
  begin
    if m_SimpleTrainmanArray[i].strTrainmanNumber = strTrainmanNumber then
    begin
      result := m_SimpleTrainmanArray[i].strTrainmanGUID;
      break;
    end;
  end;
end;

end.
