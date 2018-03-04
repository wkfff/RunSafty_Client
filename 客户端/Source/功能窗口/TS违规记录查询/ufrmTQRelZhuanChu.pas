unit ufrmTQRelZhuanChu;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, RzEdit, ComCtrls, RzDTP, Buttons, PngSpeedButton,
  ExtCtrls, RzPanel, RzCommon, RzStatus, ImgList, RzListVw,uLCPlanQuery;

type
  TQueryMode = (qmZC,qmFileEnd);
  
  TFrmTQRelZhuanChu = class(TForm)
    rzpnl1: TRzPanel;
    lb1: TLabel;
    lb2: TLabel;
    dtpStartDate: TRzDateTimePicker;
    dtpEndDate: TRzDateTimePicker;
    RzFrameController1: TRzFrameController;
    PngSpeedButton1: TPngSpeedButton;
    RzStatusBar1: TRzStatusBar;
    RzStatusPane1: TRzStatusPane;
    lstView: TRzListView;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    m_TQDataObjectList: TTQDataObjectList;
    m_QueryMode: TQueryMode;
    procedure BindData();
  public
    { Public declarations }
    class procedure ShowTQRelZC();
    class procedure ShowTQRelFileEnd();
  end;


implementation

uses uGlobalDM,DateUtils;

{$R *.dfm}
function CompareItem(item1,item2: Pointer): integer;
begin
  Result := CompareDateTime(TTQDataObject(item1).PlanTime,
  TTQDataObject(item2).PlanTime);
end;

procedure TFrmTQRelZhuanChu.BindData;
  function FormatTime(v: TDateTime): string;
  begin
    Result := FormatDateTime('yyyy-mm-dd hh:nn',v);
  end;

  function FormatTM(number,name: string): string;
  begin
    Result := Format('[%s]%s',[number,name]);
  end;
var
  Item: TListItem;
  I: Integer;
begin
  lstView.Items.Clear;
  m_TQDataObjectList.Sort(CompareItem);
  for I := 0 to m_TQDataObjectList.Count - 1 do
  begin
    Item := lstView.Items.Add;
    Item.Data := m_TQDataObjectList[i];
    Item.Caption := IntToStr(i + 1);


    with m_TQDataObjectList[i] do
    begin
      Item.SubItems.Add(TrainTypeName + '-' + TrainNumber);
      Item.SubItems.Add(TrainNo);
      Item.SubItems.Add(FormatTime(PlanTime));
      Item.SubItems.Add(FormatTM(TmNumber1,TmName1));
      Item.SubItems.Add(FormatTM(TmNumber2,TmName2));
      Item.SubItems.Add(FormatTime(TQTime));
      case m_QueryMode of
        qmZC: Item.SubItems.Add(FormatTime(ZCTime));
        qmFileEnd: Item.SubItems.Add(FormatTime(FileEndTime));
      end;

    end;
  end;

end;

procedure TFrmTQRelZhuanChu.FormCreate(Sender: TObject);
begin
  m_TQDataObjectList := TTQDataObjectList.Create;
  dtpStartDate.Date := IncDay(Now,-1);
  dtpEndDate.Date := Now;
end;

procedure TFrmTQRelZhuanChu.FormDestroy(Sender: TObject);
begin
  m_TQDataObjectList.Free;
end;

procedure TFrmTQRelZhuanChu.FormShow(Sender: TObject);
begin
  case m_QueryMode of
    qmZC: lstView.Column[lstView.Columns.Count - 1].Caption := '转储时间';
    qmFileEnd: lstView.Column[lstView.Columns.Count - 1].Caption := '文件结束时间';
  end;
end;

procedure TFrmTQRelZhuanChu.PngSpeedButton1Click(Sender: TObject);
begin
  with TLCPlanQuery.Create(GlobalDM.WebAPIUtils) do
  begin
    try
      case m_QueryMode of
        qmZC: TQRelZC(GlobalDM.SiteInfo.WorkShopGUID,
        dtpStartDate.DateTime,
        dtpEndDate.DateTime,
        m_TQDataObjectList);

        
        qmFileEnd: TQRelFileEnd(GlobalDM.SiteInfo.WorkShopGUID,
        dtpStartDate.DateTime,
        dtpEndDate.DateTime,
        m_TQDataObjectList);
      end;


      BindData();
    finally
      Free;
    end;
  end;
end;

class procedure TFrmTQRelZhuanChu.ShowTQRelFileEnd;
begin
  with TFrmTQRelZhuanChu.Create(nil) do
  begin
    Caption := '文件结束早于退勤(n)小时';
    m_QueryMode := qmFileEnd;
    ShowModal;
    Free;
  end;
end;

class procedure TFrmTQRelZhuanChu.ShowTQRelZC;
begin
  with TFrmTQRelZhuanChu.Create(nil) do
  begin
    Caption := '转储晚于退勤';
    m_QueryMode := qmZC;
    ShowModal;
    Free;
  end;
end;

end.
