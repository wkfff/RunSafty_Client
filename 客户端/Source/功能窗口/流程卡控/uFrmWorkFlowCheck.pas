unit uFrmWorkFlowCheck;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, RzLstBox,uWorkFlow,uTFSystem,uTrainPlan,uLCWorkFlowAPI,
  RzEdit;

type
  TFrmWorkFlowCheck = class(TForm)
    Bevel1: TBevel;
    lstBoxFlows: TRzListBox;
    btnSign: TButton;
    Label1: TLabel;
    RzMemo1: TRzMemo;
    procedure btnSignClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure lstBoxFlowsDrawItem(Control: TWinControl; Index: Integer;
      Rect: TRect; State: TOwnerDrawState);
    procedure FormShow(Sender: TObject);
    procedure lstBoxFlowsClick(Sender: TObject);
  private
    { Private declarations }
    m_FlowList: TWorkFlowList;
    m_tmid,m_tmName: string;
    m_plan: RRsTrainPlan;
    m_FlowType: string;
    function Check(const tmid,planid: string): Boolean;
    class function GetWorkFlowEnable: Boolean; static;
    class procedure SetWorkFlowEnable(const Value: Boolean); static;
  public
    { Public declarations }
    class function CheckBWFlow(tmid,tmName: string;plan: RRsTrainPlan): Boolean;
    class property WorkFlowEnable: Boolean read GetWorkFlowEnable write SetWorkFlowEnable;
  end;



implementation

uses ufrmTrainmanIdentity,uTrainman,uSaftyEnum, uGlobalDM, uLCWebAPI,
  uLCBaseDict;

{$R *.dfm}

procedure TFrmWorkFlowCheck.btnSignClick(Sender: TObject);
var
  Trainman:RRsTrainman;
  Verify: TRsRegisterFlag;
  ConfirmEntity: TConfirmEntity;
  I: Integer;
  strLst: TStringList;
begin
  if IdentfityTrainman(nil,Trainman,Verify,'','','','') then
  begin

      if not LCWebAPI.LCWorkFlow.IsUser(Trainman.strTrainmanNumber) then
      begin
        Box(Format('[%s]%s 没有确认权限!' ,[Trainman.strTrainmanNumber,Trainman.strTrainmanName]));
        Exit;
      end
      else
      begin
        ConfirmEntity := TConfirmEntity.Create;
        strLst := TStringList.Create;
        try
          ConfirmEntity.userNumber := Trainman.strTrainmanNumber;
          ConfirmEntity.userName := Trainman.strTrainmanName;
          ConfirmEntity.confirmTime := Now;
          ConfirmEntity.trainmanNumber := m_tmid;
          ConfirmEntity.trainmanName := m_tmName;
          ConfirmEntity.planID := m_plan.strTrainPlanGUID;
          ConfirmEntity.chuqinTime := m_plan.dtStartTime;
          ConfirmEntity.trainNo := m_plan.strTrainNo;
          ConfirmEntity.flowType := m_FlowType;

          ConfirmEntity.workShopID := GlobalDM.SiteInfo.WorkShopGUID;

          ConfirmEntity.workShopName := Trainman.strWorkShopName; 
          for I := 0 to m_FlowList.Count - 1 do
          begin
            if m_FlowList[i].success <> 0 then
            begin
              strLst.Add(m_FlowList[i].flowName);
            end;
          end;

          ConfirmEntity.confirmBrief := strLst.CommaText;
          LCWebAPI.LCWorkFlow.Confirm(ConfirmEntity);
          ModalResult := mrOk;
        finally
          ConfirmEntity.Free;
          strLst.Free;
        end;
      end;

  end;
end;

class function TFrmWorkFlowCheck.CheckBWFlow(tmid,tmName: string;plan: RRsTrainPlan): Boolean;
begin
  if not WorkFlowEnable then
  begin
    Result := True;
    Exit;
  end;
  
  with TFrmWorkFlowCheck.Create(nil) do
  begin
    try
      m_tmid := tmid;
      m_tmName := tmName;
      m_plan := plan;
      m_FlowType := WORKFLOW_BEGINWORK;
      
      if not Check(tmid,plan.strTrainPlanGUID) then
        Result := ShowModal = mrOk
      else
        Result := True;
    finally
      Free;
    end;
  end;
end;

procedure TFrmWorkFlowCheck.FormCreate(Sender: TObject);
begin
  m_FlowList := TWorkFlowList.Create;
  lstBoxFlows.Items.Clear;
  
end;

procedure TFrmWorkFlowCheck.FormDestroy(Sender: TObject);
begin
  m_FlowList.Free;
end;

procedure TFrmWorkFlowCheck.FormShow(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to m_FlowList.Count - 1 do
  begin
    lstBoxFlows.Items.AddObject('',m_FlowList[i]);
  end;
  if lstBoxFlows.Items.Count > 0 then
  begin
    lstBoxFlows.ItemIndex := 0;
    lstBoxFlowsClick(nil); 
  end;
  
end;

class function TFrmWorkFlowCheck.GetWorkFlowEnable: Boolean;
begin
  Result := ReadIniFile(ExtractFilePath(ParamStr(0)) + 'Config.ini','UserData','WorkFlowEnable') = '1';
end;

procedure TFrmWorkFlowCheck.lstBoxFlowsClick(Sender: TObject);
begin
  if lstBoxFlows.ItemIndex = -1 then Exit;

  RzMemo1.Lines.Text :=
    TWorkFlow(lstBoxFlows.Items.Objects[lstBoxFlows.ItemIndex]).description;
end;

procedure TFrmWorkFlowCheck.lstBoxFlowsDrawItem(Control: TWinControl;
  Index: Integer; Rect: TRect; State: TOwnerDrawState);
var
  Bitmap: TBitmap;
  r: TRect;
  Flow: TWorkFlow;
begin
  Bitmap := TBitmap.Create;
  try
    Bitmap.Width := Rect.Right - Rect.Left;
    Bitmap.Height := Rect.Bottom - Rect.Top;
    
    r.Left := 0;
    r.Top := 0;
    r.Right := Bitmap.Width;
    r.Bottom := Bitmap.Height;

    //绘制背景
    if odSelected in State then
    begin
      Bitmap.Canvas.Brush.Color := clHighlight;
      Bitmap.Canvas.Font.Color := clHighlightText;
    end
    else
    begin
      Bitmap.Canvas.Brush.Color := clWindow;
      Bitmap.Canvas.Font.Color := clBlack;
    end;
    Bitmap.Canvas.FillRect(r);




    Bitmap.Canvas.Font.Size := 14;

    Flow := TWorkFlow(TRzListBox(Control).Items.Objects[Index]);
    Bitmap.Canvas.Font.Style := [fsBold];
    Bitmap.Canvas.TextOut(5,5,Flow.flowName);


    if Flow.success = 0 then
      Bitmap.Canvas.Font.Color := $0000E12D
    else
      Bitmap.Canvas.Font.Color := $003D37FF;

    Bitmap.Canvas.Font.Style := [];
    Bitmap.Canvas.TextOut(5,30,Flow.description);
    TRzListBox(Control).Canvas.Draw(Rect.Left,Rect.Top,Bitmap);
  finally
    Bitmap.Free;
  end;

end;

class procedure TFrmWorkFlowCheck.SetWorkFlowEnable(const Value: Boolean);
begin

  if Value then
    WriteIniFile(ExtractFilePath(ParamStr(0)) + 'Config.ini','UserData','WorkFlowEnable','1')
  else
    WriteIniFile(ExtractFilePath(ParamStr(0)) + 'Config.ini','UserData','WorkFlowEnable','0');
end;

function TFrmWorkFlowCheck.Check(const tmid,planid: string): Boolean;
begin
    Result := LCWebAPI.LCWorkFlow.CheckBWFlow(GlobalDM.SiteInfo.WorkShopGUID,
    tmid,planid,m_FlowList);
end;

end.
