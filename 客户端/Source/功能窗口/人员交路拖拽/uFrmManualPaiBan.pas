unit uFrmManualPaiBan;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzLstBox, StdCtrls, RzChkLst, ExtCtrls, AdvSplitter, RzPanel,
  uGroupDragObject,uTrainmanJiaolu, Buttons, PngSpeedButton,
  ComCtrls,uTrainman,uTrainPlan,uTFSystem;

type
  //轮乘派班通知事件
  TOnOrderDispatchEvent = procedure(TrainmanJiaoluGUID : string ;
    TrainmanJiaoluGUIDs : TStrings) of object;
    
  //手动派班窗口
  TfrmManualPaiban = class(TForm)
    Panel1: TPanel;
    RzPanel1: TRzPanel;
    btnPaiban: TPngSpeedButton;
    PngSpeedButton1: TPngSpeedButton;
    Label1: TLabel;
    RzPanel2: TRzPanel;
    AdvSplitter1: TAdvSplitter;
    checklstTrainmanJiaolu: TRzCheckList;
    viewGroup: TListView;
    procedure FormDestroy(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure viewGroupStartDrag(Sender: TObject; var DragObject: TDragObject);
    procedure checklstTrainmanJiaoluChange(Sender: TObject; Index: Integer;
      NewState: TCheckBoxState);
    procedure btnPaibanClick(Sender: TObject);
  private
    { Private declarations }
    //当前所在的行车区段GUID
    m_strTrainJiaoluGUID : string;
    //当前显示的人员交路数组
    m_TrainmanJiaoluArray : TRsTrainmanJiaoluArray;
    //当前选中的人员交路内的机组信息
    m_GroupArray : TRsGroupArray;
    //人员交路数据库操作类
    m_DBTrainmanJiaolu : TRsDBTrainmanJiaolu;
    //机车计划数据库操作类
    m_DBTrainPlan : TRsDBTrainPlan;
    //当轮乘派班时
    m_OnOrderDispatch : TOnOrderDispatchEvent;
    procedure InitData;
    procedure InitTrainmanJiaolus;
    procedure InitGroups;
    //获取可出勤时间
    function GetCanBeginWorkTime(Trainman: RRsTrainman;cqd : RRsChuQinDiDian ;
       CQDSet : boolean) : TDateTime;
  public
    { Public declarations }
    class procedure ShowManualPaiban(TrainJiaoluGUID : string;
      OrderDispatchProc : TOnOrderDispatchEvent);
    class procedure CloseManualPaiban;
    class procedure FreeManualPaiban;
  end;

implementation
uses
  uGlobalDM,DateUtils,uLCBaseDict;
 var
   frmManualPaiban : TfrmManualPaiban;
{$R *.dfm}

{ TfrmManualPaiban }

class procedure TfrmManualPaiban.CloseManualPaiban;
begin
 if frmManualPaiban <> nil then
    frmManualPaiban.Close;;
end;

procedure TfrmManualPaiban.FormDestroy(Sender: TObject);
begin
  m_DBTrainmanJiaolu.Free;
  m_DBTrainPlan.Free;
end;

class procedure TfrmManualPaiban.FreeManualPaiban;
begin
  if frmManualPaiban <> nil then
    FreeAndNil(frmManualPaiban);
end;

function TfrmManualPaiban.GetCanBeginWorkTime(Trainman: RRsTrainman;
  cqd: RRsChuQinDiDian; CQDSet: boolean): TDateTime;
begin
  Result := GlobalDM.GetNow;
  if CQDSet then
  begin
    if Trainman.dtLastEndworkTime = 0 then exit;
    if Trainman.strWorkShopGUID = cqd.strWorkShopGUID then
    begin
      Result := IncHour(Trainman.dtLastEndworkTime,cqd.nLocalRest);
    end else begin
      Result := IncHour(Trainman.dtLastEndworkTime,cqd.nOutRest);
    end;
  end;
end;

procedure TfrmManualPaiban.InitData;
begin
  InitTrainmanJiaolus;
  InitGroups;
end;

procedure TfrmManualPaiban.InitGroups;
var
  trainmanjiaolus : TStrings;
  groupArray : TRsGroupArray;
  item : TListItem;
  i: Integer;
  bCQDSet : boolean;
  cqd : RRsChuQinDiDian;
  dtTemp : TDateTime;
begin
  bCQDSet := false;
  if m_DBTrainPlan.GetChuQinDiDian(GlobalDM.SiteInfo.strStationGUID,cqd) then
    bCQDSet := true;
  trainmanjiaolus := TStringList.Create;
  try
    for i := 0 to checklstTrainmanJiaolu.Count - 1 do
    begin
      if checklstTrainmanJiaolu.ItemChecked[i] then
      begin
        trainmanjiaolus.Add(m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID);
      end;
    end;
    m_DBTrainmanJiaolu.GetGroupArrayInTrainmanJiaolus(trainmanjiaolus,
      GlobalDM.SiteInfo.strStationGUID,groupArray,jltAny);
    if (True) then
    begin
      viewGroup.Clear;
      m_GroupArray := groupArray;
      for i := 0 to length(m_GroupArray) - 1 do
      begin
        item := viewGroup.Items.Add;
        item.Caption := IntToStr(i+1);
        item.SubItems.Add(m_GroupArray[i].Trainman1.strTrainmanName);
        item.SubItems.Add(m_GroupArray[i].Trainman2.strTrainmanName);
        item.SubItems.Add(m_GroupArray[i].Trainman3.strTrainmanName);
        dtTemp := GetCanBeginWorkTime(m_GroupArray[i].Trainman1,cqd,bCQDSet);
        item.SubItems.Add(FormatDateTime('MM-dd HH:nn:ss',dtTemp));
      end;
    end;
  finally
    trainmanjiaolus.Free;
  end;
end;

procedure TfrmManualPaiban.InitTrainmanJiaolus;
var
  i : integer;
begin
  checklstTrainmanJiaolu.Items.Clear;


  RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJL(m_strTrainJiaoluGUID,m_TrainmanJiaoluArray);
  
  for i := 0 to length(m_TrainmanJiaoluArray) - 1 do
  begin
    checklstTrainmanJiaolu.Items.Add(m_TrainmanJiaoluArray[i].strTrainmanJiaoluName);
  end;
end;

procedure TfrmManualPaiban.PngSpeedButton1Click(Sender: TObject);
begin
  TfrmManualPaiban.CloseManualPaiban;
end;

procedure TfrmManualPaiban.btnPaibanClick(Sender: TObject);
var
  i : integer;
  trainmanJiaolus : TStrings;
begin
  trainmanJiaolus := TStringList.Create;
  try
    for i := 0 to checklstTrainmanJiaolu.Items.Count - 1 do
    begin
      if checklstTrainmanJiaolu.ItemChecked[i] then
        trainmanJiaolus.Add(m_TrainmanJiaoluArray[i].strTrainmanJiaoluGUID);
    end;
    if trainmanJiaolus.Count = 0 then
    begin
      Box('请选择要派班的人员交路!');
      exit;
    end;
    if Assigned(m_OnOrderDispatch) then
    begin
      m_OnOrderDispatch(m_strTrainJiaoluGUID,trainmanJiaolus);
    end;
  finally
    trainmanJiaolus.Free;
  end;
end;

procedure TfrmManualPaiban.checklstTrainmanJiaoluChange(Sender: TObject;
  Index: Integer; NewState: TCheckBoxState);
begin
  InitGroups;
end;

class procedure TfrmManualPaiban.ShowManualPaiban(TrainJiaoluGUID: string;
  OrderDispatchProc : TOnOrderDispatchEvent);
begin
  if frmManualPaiban = nil then
  begin
    frmManualPaiban := TfrmManualPaiban.Create(nil);
  end;
  if TrainJiaoluGUID <> frmManualPaiban.m_strTrainJiaoluGUID then
  begin
    frmManualPaiban.m_strTrainJiaoluGUID := TrainJiaoluGUID;
    frmManualPaiban.InitData;
  end;

  frmManualPaiban.m_OnOrderDispatch := OrderDispatchProc;
  if assigned(frmManualPaiban.m_OnOrderDispatch) then
  begin
    frmManualPaiban.btnPaiban.Visible := true;
  end else begin
    frmManualPaiban.btnPaiban.Visible := false;
  end;
  
  
  frmManualPaiban.Show;
end;

procedure TfrmManualPaiban.viewGroupStartDrag(Sender: TObject;
  var DragObject: TDragObject);
begin
  if viewGroup.Selected = nil then exit;  
  DragObject := TGroupDragObject.Create();
  TGroupDragObject(DragObject).GroupInfo := m_GroupArray[viewGroup.Selected.index];
end;

end.
