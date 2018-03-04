unit uFrmRoomInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,uRoomSign,uBaseDBRoomSign,uDBAccessRoomSign,utfsystem,
  RzTabs;

type
  TFrmRoomInfo = class(TForm)
    lvRecord: TListView;
    Label1: TLabel;
    edtTrainmanNumber: TEdit;
    edtTrainmanName: TEdit;
    btnFind: TButton;
    Label2: TLabel;
    PageCtrlMain: TRzPageControl;
    tsTrainman: TRzTabSheet;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure lvRecordChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
    procedure lvRecordClick(Sender: TObject);
  private
    { Private declarations }
    //初始化数据
    procedure InitData();
    //创建子窗体
    procedure CreateSubForms();
    //显示到列表
    procedure RoomInfoToList(RoomInfoList:TRsRoomInfoArray);
    //获取房间号
    function GetSelRoomNumber():string;
  private
    m_dbRoomInfo : TRsBaseDBRoomInfo ;
    m_listRoomInfo : TRsRoomInfoArray ;
  public
    { Public declarations }
    class procedure Manager();
  end;

var
  FrmRoomInfo: TFrmRoomInfo;

implementation

uses
  uGlobalDM ,uFrmTrainmanRoomInfo;

{$R *.dfm}

procedure TFrmRoomInfo.btnFindClick(Sender: TObject);
var
  strTrainmanNumber:string;
  strTrainmanName:string;
  strRoomNumber:string;
begin
  strTrainmanNumber := Trim(edtTrainmanNumber.Text);
  strTrainmanName := Trim(edtTrainmanName.Text) ;
  if ( strTrainmanNumber = '')  and ( strTrainmanName = '') then
    Exit ;
  if m_dbRoomInfo.QueryTrainmanRoomRelation(strTrainmanNumber,strTrainmanName,strRoomNumber) then
  begin
    Box('房间号: ' + strRoomNumber);
  end;
end;



procedure TFrmRoomInfo.CreateSubForms;
begin
    {入寓离寓登记}
  FrmTrainmanRoomInfo := TFrmTrainmanRoomInfo.Create(nil);
  FrmTrainmanRoomInfo.Parent := tsTrainman ;
  FrmTrainmanRoomInfo.Show ;
end;

procedure TFrmRoomInfo.FormCreate(Sender: TObject);
var
  i : Integer ;
begin
  m_dbRoomInfo := TRsDBAccessRoomInfo.Create(GlobalDM.LocalADOConnection);

  for I := 0 to PageCtrlMain.PageCount - 1 do
    PageCtrlMain.Pages[i].TabVisible := False;
  CreateSubForms ;
end;

procedure TFrmRoomInfo.FormDestroy(Sender: TObject);
begin
  m_dbRoomInfo.Free ;
end;

function TFrmRoomInfo.GetSelRoomNumber: string;
begin
   Result := lvRecord.Selected.SubItems[0];
end;

procedure TFrmRoomInfo.InitData;
begin
  SetLength(m_listRoomInfo,0);
  m_dbRoomInfo.GetAllRoom(m_listRoomInfo);
  RoomInfoToList(m_listRoomInfo) ;
end;

procedure TFrmRoomInfo.lvRecordChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  ;
end;



procedure TFrmRoomInfo.lvRecordClick(Sender: TObject);
var
  strRoomNumber:string;
begin
  try
    if lvRecord.Items.Count = 0 then
      Exit ;
    if lvRecord.Selected = nil then
    begin
      BoxErr('请选中一条数据');
      Exit;
    end;
    if lvRecord.Selected.Data = nil then
      Exit;
    strRoomNumber := GetSelRoomNumber ;
    FrmTrainmanRoomInfo.InitData(strRoomNumber);
  except
   on e:Exception do
   begin
     ShowMessage(e.Message);
   end;
  end;
end;

class procedure TFrmRoomInfo.Manager;
var
  frm : TFrmRoomInfo ;
begin
  frm := TFrmRoomInfo.Create(nil);
  try
    frm.InitData;
    frm.ShowModal;
  finally
    frm.Free ;
  end;

end;

procedure TFrmRoomInfo.RoomInfoToList(
  RoomInfoList: TRsRoomInfoArray);
var
  i:Integer;
  listItem:TListItem;
  strText:string;
begin
  lvRecord.Items.Clear;
  for I := 0 to Length(RoomInfoList) - 1 do
  begin
    listItem := lvRecord.Items.Add;
    with listItem do
    begin
      Caption := inttostr(i+1) ;
      SubItems.Add(RoomInfoList[i].strRoomNumber);
    end;
    listItem.Data := Addr(RoomInfoList[i]);
  end; 
end;

end.
