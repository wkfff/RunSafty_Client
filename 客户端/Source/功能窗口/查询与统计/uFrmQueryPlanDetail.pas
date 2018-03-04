unit uFrmQueryPlanDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons,ADODB, ActnList, PngSpeedButton,
  asgprev, Grids, AdvObj, BaseGrid, AdvGrid;

type
  TfrmQueryPlanDetail = class(TForm)
    Panel1: TPanel;
    lvPlans: TListView;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    dtpBeginDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    Label2: TLabel;
    btnQuery: TSpeedButton;
    btnCancel: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Label3: TLabel;
    CombArea: TComboBox;
    ActionList1: TActionList;
    actEsc: TAction;
    OpenDialog1: TOpenDialog;
    AdvPreviewDialog: TAdvPreviewDialog;
    procedure btnQueryClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure lvPlansDblClick(Sender: TObject);
  private
    { Private declarations }
    m_AreaGUIDs : TStrings;

  public
    { Public declarations }
  end;

var
  frmQueryPlanDetail: TfrmQueryPlanDetail;

implementation
uses
  uDataModule,uPlan,uFrmPlanDetail,uOrg;
{$R *.dfm}

procedure TfrmQueryPlanDetail.actEscExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmQueryPlanDetail.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmQueryPlanDetail.btnQueryClick(Sender: TObject);
var
  ado : TADOQuery;
  item : TListItem;
  i : Integer;
begin

  lvPlans.Items.Clear;
  TDBPlan.QueryPlan(dtpBeginDate.DateTime,dtpEndDate.DateTime,m_AreaGUIDs[CombArea.ItemIndex], ado);
  try
    i :=0;
    with ado do
    begin
      while not eof do
      begin
        Inc(i);
        item := lvPlans.Items.Add;
        item.Caption := IntToStr(i);
        item.SubItems.Add(FieldByName('strAreaName').AsString);
        item.SubItems.Add(FieldByName('strTrainNo').AsString);
        item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtSigninTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtCallTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtOutDutyTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('yyyy-MM-dd HH:nn',FieldByName('dtStartTime').AsDateTime));
        if FieldByName('strMainDriverGUID').AsString <> '' then
          item.SubItems.Add('['+FieldByName('strMainDriverNumber').AsString+']' +FieldByName('strMainDriverName').AsString +  '['+FieldByName('strMainDriverStateName').AsString+']')
        else
          item.SubItems.Add('无');
        if FieldByName('strSubDriverGUID').AsString <> '' then
          item.SubItems.Add('['+FieldByName('strSubDriverNumber').AsString+']' +FieldByName('strSubDriverName').AsString +  '['+FieldByName('strSubDriverStateName').AsString+']')
        else
          item.SubItems.Add('无');
        item.SubItems.Add(FieldByName('strStateName').AsString);
        item.SubItems.Add(FieldByName('strGUID').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmQueryPlanDetail.FormCreate(Sender: TObject);
var
  ado : TADOQuery;
begin
  dtpBeginDate.Date := DMGlobal.GetNow;
  dtpEndDate.Date := DMGlobal.GetNow;
  m_AreaGUIDs := TStringList.Create;
  CombArea.Items.Add('请选择');
  m_AreaGUIDs.Add('');
  TAreaOpt.GetAreas(ado);
  try
    with ado do
    begin
      while not eof  do
      begin
        CombArea.Items.Add(FieldByName('strAreaName').AsString);
        m_AreaGUIDs.Add(FieldByName('strGUID').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
  CombArea.ItemIndex := m_AreaGUIDs.IndexOf(DMGlobal.LocalArea);
end;

procedure TfrmQueryPlanDetail.FormDestroy(Sender: TObject);
begin
  m_AreaGUIDs.Free;
end;

procedure TfrmQueryPlanDetail.lvPlansDblClick(Sender: TObject);
begin
  SpeedButton1.Click;
end;

procedure TfrmQueryPlanDetail.SpeedButton1Click(Sender: TObject);
begin
  if lvPlans.Selected = nil then
  begin
    Application.MessageBox('请选择要查看的计划。','提示',MB_OK + MB_ICONINFORMATION);
    exit;
  end;
  frmPlanDetail := TfrmPlanDetail.Create(nil);
  try
    frmPlanDetail.PlanGUID := lvPlans.Selected.SubItems[9];
    frmPlanDetail.ShowModal;
  finally
    frmPlanDetail.Free;
  end;
end;

end.
