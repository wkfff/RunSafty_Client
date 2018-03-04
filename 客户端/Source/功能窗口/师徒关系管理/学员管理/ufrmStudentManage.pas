unit ufrmStudentManage;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, RzButton, ExtCtrls, RzBorder, StdCtrls, Buttons,
  PngBitBtn,uXYRelation,uTrainman,uTFSystem,uLCXYRelation;

type
  TfrmStudentManage = class(TForm)
    RzBorder1: TRzBorder;
    lstStudentView: TRzListView;
    RzBitBtn1: TRzBitBtn;
    RzBitBtn2: TRzBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure RzBitBtn1Click(Sender: TObject);
    procedure RzBitBtn2Click(Sender: TObject);
    procedure lstStudentViewCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstStudentViewCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    m_strTeacherGUID: string;
    m_RsLCXYRelation: TRsLCXYRelation;
    m_XYStudentArray: TRsXYStudentArray;
    procedure InitStudentInfo();
  public
    { Public declarations }
  end;

procedure StudentManage(strTeacherGUID: string);
implementation

uses uGlobalDM, uFrmAddXY;
procedure StudentManage(strTeacherGUID: string);
var
  frmStudentManage: TfrmStudentManage;
begin
  frmStudentManage := TfrmStudentManage.Create(nil);
  try
    frmStudentManage.m_strTeacherGUID := strTeacherGUID;
    frmStudentManage.InitStudentInfo();
    frmStudentManage.ShowModal;
  finally
    frmStudentManage.Free;
  end;
end;
{$R *.dfm}

procedure TfrmStudentManage.FormCreate(Sender: TObject);
begin
  m_RsLCXYRelation := TRsLCXYRelation.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmStudentManage.FormDestroy(Sender: TObject);
begin
  m_RsLCXYRelation.Free;
end;

procedure TfrmStudentManage.InitStudentInfo;
var
  I: Integer;
  Item: TListItem;
begin
  m_RsLCXYRelation.GetStudents(m_strTeacherGUID,m_XYStudentArray);

  lstStudentView.Items.Clear;


  for I := 0 to Length(m_XYStudentArray) - 1 do
  begin
    Item := lstStudentView.Items.Add;
    Item.Caption := IntToStr(i+1);
    Item.SubItems.Add(TXyRelationStrFormat.GetStudentText(m_XYStudentArray[i]));
    Item.Data := @m_XYStudentArray[i];
  end;

end;

procedure TfrmStudentManage.lstStudentViewCustomDrawItem(
  Sender: TCustomListView; Item: TListItem; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

procedure TfrmStudentManage.lstStudentViewCustomDrawSubItem(
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

procedure TfrmStudentManage.RzBitBtn1Click(Sender: TObject);
var
  trainman : RRsTrainman;
begin
  if not TFrmAddXY.InputTrainman('',trainman) then exit;
  try
    m_RsLCXYRelation.AddStudent(GlobalDM.DutyUser.strDutyGUID,
      m_strTeacherGUID,trainman.strTrainmanGUID);
    InitStudentInfo();
  except on e : exception do
    begin
      Boxerr('添加学员失败:' + e.Message);
    end;
  end;
end;

procedure TfrmStudentManage.RzBitBtn2Click(Sender: TObject);
begin
  if lstStudentView.Selected = nil then
  begin
    Box('请先选择一条记录!');
    Exit;
  end;

  if not TBox('确定要删除学员"'+PRsXYStudent(lstStudentView.Selected.Data).strStudentName +'"吗?') then
    Exit;

  m_RsLCXYRelation.DeleteStudent(GlobalDM.DutyUser.strDutyGUID,
    m_strTeacherGUID,PRsXYStudent(lstStudentView.Selected.Data).strStudentGUID);

  InitStudentInfo();
end;

end.
