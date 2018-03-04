unit ufrmGanBuMgr;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzPanel, RzButton, ImgList, ExtCtrls, ComCtrls, RzListVw, StdCtrls,
  Mask, RzEdit, RzCmboBx, Buttons,uLCBaseDict,uLCDict_GanBu,ufrmGanBuAdd,uTFSystem,
  uGanbuXlsExport,ufrmHint,uLCTrainmanMgr,uTrainman;

type
  TfrmGanBuMgr = class(TForm)
    RzListView: TRzListView;
    ImageList1: TImageList;
    RzToolbar1: TRzToolbar;
    BtnInsertRecord: TRzToolButton;
    BtnDelete: TRzToolButton;
    BtnImport: TRzToolButton;
    BtnExport: TRzToolButton;
    BtnView: TRzToolButton;
    BtnExit: TRzToolButton;
    RzSpacer1: TRzSpacer;
    RzSpacer2: TRzSpacer;
    RzSpacer3: TRzSpacer;
    RzSpacer4: TRzSpacer;
    Label1: TLabel;
    Label2: TLabel;
    cbbTypes: TRzComboBox;
    edtNumber: TRzEdit;
    RzStatusBar1: TRzStatusBar;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure BtnViewClick(Sender: TObject);
    procedure BtnInsertRecordClick(Sender: TObject);
    procedure BtnDeleteClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BtnExportClick(Sender: TObject);
    procedure BtnImportClick(Sender: TObject);
  private
    { Private declarations }
    m_TypeList: TGanBuTypeList;
    m_GanBuList: TGanBuList;
    m_LCTrainmanMgr: TRsLCTrainmanMgr;
    function FindGanbuType(TypeName: string): string;
    procedure Init();
  public
    { Public declarations }
    class procedure ShowForm();
  end;



implementation

uses uGlobalDM;

{$R *.dfm}

{ TfrmGanBuMgr }

procedure TfrmGanBuMgr.BtnDeleteClick(Sender: TObject);
begin
  if RzListView.Selected = nil then
  begin
    Box('请选择要删除的记录!');
    Exit;
  end;

  if not TBox('确定要删除选中干部吗？') then EXIT;

  RsLCBaseDict.LCGanBu.Delete(TGanBu(RzListView.Selected.Data).RecID);
  RzListView.DeleteSelected;
end;

procedure TfrmGanBuMgr.BtnExitClick(Sender: TObject);
begin
  CLOSE;
end;

procedure TfrmGanBuMgr.BtnExportClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
  begin
    TfrmHint.ShowHint('正在导出数据……');
    try
      TGanBuXlsExport.ExportToXls(m_GanBuList,SaveDialog1.FileName);
    finally
      TfrmHint.CloseHint();
    end;

    Box('导出完毕!');
  end;

end;

procedure TfrmGanBuMgr.BtnImportClick(Sender: TObject);
var
  GanBuList: TGanBuList;
  I: Integer;
  Trainman: RRsTrainman;
begin
  if OpenDialog1.Execute then
  begin
    GanBuList := TGanBuList.Create;
    TfrmHint.ShowHint('正在导入数据……');
    TRY
      TGanBuXlsExport.ImportFromXls(GanBuList,OpenDialog1.FileName);
      for I := 0 to GanBuList.Count - 1 do
      begin
        GanBuList.Items[i].WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;

        GanBuList.Items[i].TypeID := FindGanbuType(GanBuList.Items[i].TypeName);
        if GanBuList.Items[i].TypeID = '' then
        begin
          Box(format('职务类型[%s]不存在!',[GanBuList.Items[i].TypeName]));
          Exit;
        end;

        if not m_LCTrainmanMgr.GetTrainmanByNumber(GanBuList.Items[i].TrainmanNumber,Trainman) then
        begin
          Box(Format('工号为[%s]的人员不存在!',[GanBuList.Items[i].TrainmanNumber]));
          EXIT;
        end;
        GanBuList.Items[i].TrainmanGUID := Trainman.strTrainmanGUID;
      end;

      for I := 0 to GanBuList.Count - 1 do
      begin
        RsLCBaseDict.LCGanBu.Add(GanBuList.Items[i]);
      end;
    FINALLY
      TfrmHint.CloseHint;
      GanBuList.Free;
    END;

    Box('导入完毕!');
  end;
end;

procedure TfrmGanBuMgr.BtnInsertRecordClick(Sender: TObject);
var
  GanBu: TGanBu;
begin
  GanBu := TGanBu.Create;
  try
    if TFrmGanbuAdd.AddGanBu(m_TypeList,GanBu) then
    begin
      RsLCBaseDict.LCGanBu.Add(GanBu);
      BtnViewClick(nil);
    end;
  finally
    GanBu.Free;
  end;

end;

procedure TfrmGanBuMgr.BtnViewClick(Sender: TObject);
var
  QueryParam: TGanBuQueryParam;
  I: Integer;
  Item: TListItem;
begin
  QueryParam := TGanBuQueryParam.Create;
  try
    QueryParam.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
    QueryParam.TrainmanNumber := edtNumber.Text;
    QueryParam.TypeID := cbbTypes.Value;
    RsLCBaseDict.LCGanBu.Query(m_GanBuList,QueryParam);


    RzListView.Items.Clear;

    for I := 0 to m_GanBuList.Count - 1 do
    begin
      Item := RzListView.Items.Add;
      Item.Caption := IntToStr(i + 1);
      Item.SubItems.Add(m_GanBuList.Items[i].TypeName);
      Item.SubItems.Add(Format('[%s]%s',[m_GanBuList.Items[i].TrainmanNumber,m_GanBuList.Items[i].TrainmanName]));
      Item.Data := m_GanBuList.Items[i];
    end;
    
  finally
    QueryParam.Free;
  end;

end;

function TfrmGanBuMgr.FindGanbuType(TypeName: string): string;
var
  I: Integer;
begin
  Result:= '';
  for I := 0 to m_TypeList.Count - 1 do
  begin
    if m_TypeList.Items[i].TypeName = TypeName then
    begin
      Result := m_TypeList.Items[i].TypeID;
      break;
    end;
  end;
end;

procedure TfrmGanBuMgr.FormCreate(Sender: TObject);
begin
  m_TypeList := TGanBuTypeList.Create;
  m_GanBuList := TGanBuList.Create;
  m_LCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmGanBuMgr.FormDestroy(Sender: TObject);
begin
  m_TypeList.Free;
  m_GanBuList.Free;
  m_LCTrainmanMgr.Free;
end;

procedure TfrmGanBuMgr.FormShow(Sender: TObject);
begin
  Init();

  BtnViewClick(nil);
end;

procedure TfrmGanBuMgr.Init;
var
  I: Integer;
begin
  RsLCBaseDict.LCGanBu.LCGanBuType.Query(GlobalDM.SiteInfo.WorkShopGUID,m_TypeList);
  cbbTypes.AddItemValue('全部','0');

  for I := 0 to m_TypeList.Count - 1 do
  begin
    cbbTypes.AddItemValue(m_TypeList.Items[i].TypeName,m_TypeList.Items[i].TypeID);
  end;
  
end;

class procedure TfrmGanBuMgr.ShowForm;
var
  frmGanBuMgr: TfrmGanBuMgr;
begin
  frmGanBuMgr := TfrmGanBuMgr.Create(nil);
  try
    frmGanBuMgr.ShowModal;
  finally
    frmGanBuMgr.Free;
  end;
end;

end.
