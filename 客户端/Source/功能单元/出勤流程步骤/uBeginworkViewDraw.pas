unit uBeginworkViewDraw;

interface
uses
  Windows,Classes,Graphics,ADODB,SysUtils,uTrainPlan,uTrainman,
  ZKFPEngXUtils,jpeg,Forms,GDIPOBJ, GDIPAPI,uSaftyEnum,uLCTrainmanMgr,
  uLCBeginwork,uLCTrainPlan;
type 
  TBeginworkViewDraw = class
  public
    constructor Create; virtual;
    destructor Destroy;override;
  private
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsLCBeginwork : TLCBeginwork;
  protected
    //��ȡ·������
    function GetData(TrainplanGUID : string ;
      WorkShopGUID : string ;out TrainmanPlan : RRsTrainmanPlan;
      out FlowArray : TRsBeginworkFlowArray; out StepArray : TRsTrainmanBeginworkStepArray;
      out TrainFlow : RRsTrainplanBeginworkFlow) : boolean;
    //���ƻ���Ϣ
    procedure DrawPlanInfo(Canvas : TCanvas ;PlanRect : TRect;TrainNo,TrainjiaoluName : string;
      StartTime : TDateTime;PlanState : TRsPlanState);
    //�����������
    procedure DrawStepName(Canvas : TCanvas ;PlanRect : TRect;FlowData: TRsBeginworkFlowArray);
    //������Ա�ĳ��ڽ���
    procedure DrawTrainmanStep(Canvas : TCanvas;PlanRect : TRect;Trainman : RRsTrainman;
      FlowData: TRsBeginworkFlowArray;TrainmanStep: TRsTrainmanBeginworkStepArray;
      PlanFlow: RRsTrainplanBeginworkFlow);
    //��ȡԲ�е�����
    function GetESRect(PlanRect:TRect; i : integer) : TRect;

  public
    //�ڻ����ϻ�ָ���ƻ�������
    function Draw(Canvas : TCanvas;DrawRect : TRect;TrainPlanGUID,WorkShopGUID : string;
       IsDrawStepName : boolean = false) : TRect;
    //�������
    procedure AllowBeginwork( AllowInfo : RRsTrainplanBeginworkFlow;ADOConn : TADOConnection);
    //��ȡ���µĲ�����Ϣ
    function GetLastStep(ADOConn :TADOConnection;WorkShopGUID : string;
      out StepInfo : RRsTrainmanBeginworkStep) : boolean;
  public
    //�ƻ����ⱳ��ɫ
    TitleBgcolor : TColor;
    //�ƻ���������
    TitleFont : TFont;
    //�ѳ��ڵļƻ��ı�ͷ����ɫ
    TitleCQBgColor : TColor;
    //�ѳ��ڵļƻ��ı�ͷ������
    TitleCQFont : TFont;
    //�ƻ�����߶�
    TitleHeight : integer;

    //ÿ���˵Ĳ���߶�
    StepHeight : integer;
    //����Ŀհ׼��
    StepPadding : integer;
    //��Ƭ�ĸ߶�(���Ϊ3*2����)
    PicHeight : integer;
    //��Ƭ�Ŀ��
    PicWidth : integer;
    //�������ƿ��
    StepNameWidth : integer;
    //�������Ƹ߶�
    StepNameHeight : integer;
    //���豳��ɫ
    StepNameBgcolor : TColor;
    //��������
    StepNameFont : TFont;
    //�������ƾඥ�˸߶�
    StepNameTop : integer;

    //��������̵���ɫ
    FinishColor : TColor;
    //
    FinishLightColor : TColor;

    //δ������̵���ɫ
    NormalColor : TColor;
    NormalLightColor : TColor;

    FrameColor : TColor;
    //���������ı���ɫ
    Color : TColor;
    //����������ɫ
    Font : TFont;

    //��İ뾶
    DotWidth : integer;
    procedure GetTrainmanJpeg(Trainman : RRsTrainman;Jpeg : TJPEGImage);
  end;
implementation

uses DB, uGlobalDM;

{ TBeginworkViewDraw }

procedure TBeginworkViewDraw.AllowBeginwork(
  AllowInfo: RRsTrainplanBeginworkFlow;ADOConn : TADOConnection);
var
  adoQuery : TADOQuery;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := 'select top 1 * from TAB_Plan_Beginwork_Flow where strTrainPlanGUID = :strTrainPlanGUID';
      Parameters.ParamByName('strTrainPlanGUID').Value := AllowInfo.strTrainPlanGUID;
      Open;
      if RecordCount > 0 then
      begin
        Edit;
      end else begin
        Append;
      end;
      FieldByName('strTrainPlanGUID').AsString := AllowInfo.strTrainPlanGUID;
      FieldByName('strWorkShopGUID').AsString := AllowInfo.strWorkShopGUID;
      FieldByName('nFlowState').AsInteger := AllowInfo.nFlowState;
      FieldByName('strDutyUserName').AsString := AllowInfo.strDutyUserName;
      FieldByName('strDutyUserGUID').AsString := AllowInfo.strDutyUserGUID;
      FieldByName('strDutyUserNumber').AsString := AllowInfo.strDutyUserNumber;
      FieldByName('dtCreateTime').AsDateTime := AllowInfo.dtCreateTime;
      FieldByName('dtConfirmTime').AsDateTime := AllowInfo.dtConfirmTime;
      FieldByName('strBrief').AsString := AllowInfo.strBrief;
      Post;
    end;
  finally
    adoQuery.Free;
  end;
end;

constructor TBeginworkViewDraw.Create;
begin
   //�ƻ����ⱳ��ɫ
    TitleBgcolor :=  Rgb(0,77,131);   
    //��������
    TitleFont := TFont.Create;
    TitleFont.Name := '����';
    TitleFont.Size := 20;
    TitleFont.Color := clWhite;
    TitleFont.Style := [fsBold];
    //�ƻ�����߶�
    TitleHeight := 45;

    //�ѳ��ڵļƻ��ı�ͷ����ɫ
    TitleCQBgColor := Rgb(100,100,100);
    //�ѳ��ڵļƻ��ı�ͷ������
    TitleCQFont := TFont.Create;
    TitleCQFont.Name := '����';
    TitleCQFont.Size := 20;
    TitleCQFont.Color := clWhite;
    TitleCQFont.Style := [fsBold];
    

    //ÿ���˵Ĳ���߶�
    StepHeight := 120;

    //����Ŀհ׼��
    StepPadding := 10;
    //��Ƭ�ĸ߶�(���Ϊ3*2����)
    PicHeight := 80;
    //��Ƭ�Ŀ��
    PicWidth := 120;
    //�������ƿ��
    StepNameWidth := 120;
    //�������Ƹ߶�
    StepNameHeight := 38;
    //���豳��ɫ
    StepNameBgcolor := Rgb(0,128,192);
    //��������
    StepNameFont := TFont.Create;
    StepNameFont.Color := clWhite;
    StepNameFont.Size := 16;

    StepNameTop := 20;

   //��������̵���ɫ
    FinishColor := Rgb(255,128,0);;
    FinishLightColor := Rgb(255,165,74);
    //δ������̵���ɫ
    NormalColor := Rgb(100,100,100);
    NormalLightColor := Rgb(110,110,110);

    FrameColor := Rgb(128,128,128);
    //���������ı���ɫ
    Color := clWhite;
    //����������ɫ
    Font := TFont.Create;
    Font.Name := '����';
    Font.Size := 12;
    Font.Color := clBlack;

    //��İ뾶
    DotWidth := 30;
end;

destructor TBeginworkViewDraw.Destroy;
begin
  Font.Free;
  TitleFont.Free;
  StepNameFont.Free;
  TitleCQFont.Free;
  if m_RsLCTrainmanMgr <> nil then
    FreeAndNil(m_RsLCTrainmanMgr);
  inherited;
end;

function TBeginworkViewDraw.Draw(Canvas: TCanvas; DrawRect: TRect;
  TrainPlanGUID,WorkShopGUID: string;
  IsDrawStepName : boolean = false) : TRect;
var
  trainmanPlan : RRsTrainmanPlan;
  flowData : TRsBeginworkFlowArray;
  trainmanStep : TRsTrainmanBeginworkStepArray;
  planFlow : RRsTrainplanBeginworkFlow;
  //������������,ʵ�ʱ�ͷ����,��������
  stepRect : TRect;

begin
  //��ȡ���ڼƻ�����������
  if not GetData(TrainPlanGUID,WorkShopGUID,trainmanPlan,flowData,
    trainmanStep,planFlow) then exit;
  if m_RsLCTrainmanMgr = nil then
    m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);

 
  //����ƻ�����������
  stepRect := DrawRect;
  stepRect.Bottom := stepRect.Top + titleHeight;

//  //���ƻ�����Ϣ
  DrawPlanInfo(Canvas,stepRect,TrainmanPlan.TrainPlan.strTrainNo,
    TrainmanPlan.TrainPlan.strTrainJiaoluName,TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.nPlanState);

  //��˾��������
  if TrainmanPlan.Group.Trainman1.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //�����������
    DrawStepName(Canvas,stepRect,flowData);
    //����Ա����Ƭ�������������������
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman1,FlowData,TrainmanStep,PlanFlow);

  end;

  //��˾��������
  if TrainmanPlan.Group.Trainman2.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //�����������
    DrawStepName(Canvas,stepRect,flowData);
    //����Ա����Ƭ�������������������
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman2,FlowData,TrainmanStep,PlanFlow);

  end;


  //��˾��������
  if TrainmanPlan.Group.Trainman3.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //�����������
    DrawStepName(Canvas,stepRect,flowData);
    //����Ա����Ƭ�������������������
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman3,FlowData,TrainmanStep,PlanFlow);
  end;


  //��˾��������
  if TrainmanPlan.Group.Trainman4.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //�����������
    DrawStepName(Canvas,stepRect,flowData);
    //����Ա����Ƭ�������������������
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman4,FlowData,TrainmanStep,PlanFlow);
  end;

  stepRect.Top := stepRect.Bottom;
  stepRect.Bottom := stepRect.Top + StepHeight;
  result := stepRect;
end;

procedure TBeginworkViewDraw.DrawPlanInfo(Canvas: TCanvas; PlanRect: TRect;
  TrainNo, TrainjiaoluName: string; StartTime: TDateTime;PlanState : TRsPlanState);
var
  //ʱ�����ֿ�ȣ��������ֿ��
  r : TRect;
  strText : string;
begin
  //����ɫ��ɫ������ɫ��ɫ  
  Canvas.Brush.Color := TitleBgcolor;
  Canvas.Font.Assign(TitleFont);
  if PlanState >= psBeginWork then
  begin
    Canvas.Brush.Color := TitleCQBgColor;
    Canvas.Font.Assign(TitleCQFont);
  end;

  try
    //��䱳��ɫ
    r := PlanRect;
    r.Right := r.Right + 40;
    Canvas.FillRect(r);

    r := Rect(PlanRect.Left + StepPadding,PlanRect.Top + StepPadding,PlanRect.Right - StepPadding,PlanRect.Bottom - StepPadding);

    //������·���ƻ������Ҳ�
    strText :=  TrainjiaoluName;
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfRIGHT,tfVerticalCenter]);

    //�ƻ��ĳ���ʱ�仭�������
    strText := FormatDateTime('MM-dd HH:nn',StartTime);
    r.Left := r.Left + StepPadding;
    r.Right := r.Left + Canvas.TextWidth(strText);
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfLeft,tfVerticalCenter]);

    //���θ��ų���ʱ�仭
    strText :=   '    ' + TrainNo;
    r.Left := r.Right + StepPadding;
    r.Right := r.Left + Canvas.TextWidth(strText);
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfLeft,tfVerticalCenter]);
  finally
    //���廭ˢ��ɫ��ԭ
    Canvas.Brush.Color := Color;
    Canvas.Font.Assign(Font);
  end;
end;

procedure TBeginworkViewDraw.DrawStepName(Canvas: TCanvas; PlanRect: TRect;
   FlowData: TRsBeginworkFlowArray);
var
  i : integer;
  r : TRect;
  penColor : TColor;
begin
//����ɫ��ɫ������ɫ��ɫ
  Canvas.Brush.Color := StepNameBgcolor;
  Canvas.Font.Assign(StepNameFont);
  penColor := Canvas.Pen.Color;
  try
    //��䱳��ɫ
    SetBkMode(Canvas.Handle,TRANSPARENT);
    for I := 0 to length(FlowData) - 1 do
    begin
      r := PlanRect;

      //ȥ����Ƭ��λ��
      r.Left := PlanRect.Left + PicWidth + StepPadding *2;
      //�����N���������ΪΪ n*2 + 1����� ����
      r.Left := r.Left +  StepPadding + (i * StepNameWidth) + i*2*StepPadding;
      //�Ҳ����������������
      r.Right := r.Left + StepNameWidth;
      //�Ϸ�Ϊ�����Ϸ������ƶ�����
      r.Top := r.Top + StepNameTop;
      //�·�Ϊ�Ϸ������ƶ��߶�
      R.Bottom := r.Top + StepNameHeight;
      Canvas.Pen.Color := Color;
      Canvas.RoundRect(r.Left,r.Top,r.Right,r.Bottom,10,10);
      Canvas.TextRect(r,FlowData[i].strStepName,[tfSINGLELINE,tfCenter,tfVerticalCenter]);

    end;
  finally
    //���廭ˢ��ɫ��ԭ
    Canvas.Brush.Color := Color;
    Canvas.Font.Assign(Font);
    Canvas.Pen.Color := penColor;
  end;
end;

procedure TBeginworkViewDraw.DrawTrainmanStep(Canvas: TCanvas; PlanRect: TRect;
  Trainman: RRsTrainman; FlowData: TRsBeginworkFlowArray;
  TrainmanStep: TRsTrainmanBeginworkStepArray;
  PlanFlow: RRsTrainplanBeginworkFlow);
var
  i,k : integer;
  r : TRect;
  tman : RRsTrainman;
  jpeg : TJPEGImage;
  strTrainmanText  :string;
  brushColor,penColor : TColor;
begin
  SetBkMode(Canvas.Handle,TRANSPARENT);

  brushColor := Canvas.Brush.Color;;
  penColor := Canvas.Pen.Color;
  try
    if m_RsLCTrainmanMgr.GetTrainmanByNumber(trainman.strTrainmanNumber,tman,2) then
    begin
      //ͼƬ������
      r := Rect(PlanRect.Left + StepPadding ,PlanRect.Top + StepPadding,PlanRect.Left + StepPadding + PicWidth,PlanRect.Top + StepPadding + PicHeight);
      jpeg := TJPEGImage.Create;
      try
        try
          GetTrainmanJpeg(tman,jpeg);
          InflateRect(r,4,4);
          Canvas.Pen.Color := FrameColor;
          Canvas.RoundRect(r.Left,r.Top,r.Right,r.Bottom,5,5);
          InflateRect(r,-4,-4);
          canvas.StretchDraw(r,jpeg);
        except

        end;
        finally
        jpeg.Free;
      end;
    end;

    r.Top := r.Bottom ;
    r.Bottom := r.Top + 20 + 3;
    strTrainmanText := GetTrainmanText(Trainman);
    Canvas.TextRect(r,strTrainmanText,[tfSINGLELINE,tfcenter,tfBottom]);


    for I := 0 to length(FlowData) - 1 do
    begin
      Canvas.Brush.Color := NormalLightColor;
      Canvas.Pen.Color := NormalLightColor;
      r := GetESRect(PlanRect,i);
      Canvas.Ellipse(r.Left,r.Top,r.Right,r.Bottom);

      InflateRect(r,-2,-2);
      Canvas.Brush.Color := NormalColor;
      Canvas.Pen.Color := NormalColor;
      Canvas.Ellipse(r.Left,r.Top,r.Right,r.Bottom);
          

      for k := 0 to length(TrainmanStep) - 1 do
      begin
        if Trainman.strTrainmanGUID = TrainmanStep[k].strTrainmanGUID then
        begin
          if FlowData[i].nStepID = TrainmanStep[k].nStepID then
          begin
            Canvas.Brush.Color := FinishLightColor;
            Canvas.Pen.Color := FinishLightColor;
            r := GetESRect(PlanRect,i);
            
            Canvas.Ellipse(r.Left,r.Top,r.Right,r.Bottom);

            InflateRect(r,-2,-2);
            Canvas.Brush.Color := FinishColor;
            Canvas.Pen.Color := FinishColor;
            Canvas.Ellipse(r.Left,r.Top,r.Right,r.Bottom);
            break;
          end;
        end;
      end;   
      

      if i <> 0 then
      begin
        Canvas.Pen.Color := FrameColor;
        r := GetESRect(PlanRect,i - 1);
        Canvas.MoveTo(r.Right,r.Top + (r.Bottom - r.Top) div 2);
        r := GetESRect(PlanRect,i);
        Canvas.LineTo(r.Left,r.Top + (r.Bottom - r.Top) div 2);
      end;
    end;
  finally
    Canvas.Brush.Color := brushColor;
    Canvas.Pen.Color := penColor;
  end;
end;

function TBeginworkViewDraw.GetData(
  TrainplanGUID : string;WorkShopGUID : string;
  out TrainmanPlan: RRsTrainmanPlan; out FlowArray: TRsBeginworkFlowArray;
  out StepArray: TRsTrainmanBeginworkStepArray;
  out TrainFlow: RRsTrainplanBeginworkFlow) : boolean;
var
  ErrorMsg : string;
  lcTrainPlan : TRsLCTrainPlan;
begin
  Result := False;
  lcTrainPlan := TRsLCTrainPlan.Create('','','');
  try
    lcTrainPlan.SetConnConfig(GlobalDM.HttpConnConfig);
    if not lcTrainPlan.GetTrainmanPlanByGUID(TrainPlanGUID,trainmanPlan,ErrorMsg) then
      exit;
    m_RsLCBeginwork := TLCBeginwork.Create(GlobalDM.WebAPIUtils);

    try
      m_RsLCBeginwork.GetPlanBeginworkFlow(TrainPlanGUID,WorkShopGUID,FlowArray,StepArray,TrainFlow);
      result := true;
    finally
      m_RsLCBeginwork.Free;
    end;
  finally
    lcTrainPlan.free;
  end;
end;

function TBeginworkViewDraw.GetESRect(PlanRect:TRect; i: integer): TRect;
var
 r : TRect;
begin
  //ȥ����Ƭ��λ��
  r.Left := PlanRect.Left + PicWidth + StepPadding *2;
  //�����N���������ΪΪ n*2 + 1����� ����
  r.Left := r.Left +  StepPadding + (i * StepNameWidth) + i*2*StepPadding;

  r.Left := r.Left + (StepNameWidth div 2) - DotWidth div 2;



  //�Ҳ����������������
  r.Right := r.Left + DotWidth ;

  //�Ϸ�Ϊ�����Ϸ������ƶ�����
  r.Top := PlanRect.Top + StepNameTop + StepNameHeight + StepPadding;
  //�·�Ϊ�Ϸ������ƶ��߶�
  r.Bottom := r.Top + DotWidth;
  result := r;
end;

function TBeginworkViewDraw.GetLastStep(ADOConn :TADOConnection;WorkShopGUID: string;
  out StepInfo: RRsTrainmanBeginworkStep): boolean;
var
  adoQuery : TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(ADOConn);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := 'select top 1 * from TAB_Plan_Beginwork_Step ' +
      ' where strTrainPlanGUID in (select strTrainPlanGUID from TAB_Plan_Train ' +
      ' where strTrainJiaoluGUID in (select strTrainJiaoluGUID From tab_Base_TrainJiaolu where strWorkShopGUID = :strWorkShopGUID)) ' +
      ' order by dtEventTime desc';
      Parameters.ParamByName('strWorkShopGUID').Value := WorkShopGUID;      
      Open;
      if(RecordCount > 0) then
      begin
        result := true;
        StepInfo.strTrainPlanGUID := FieldByName('strTrainPlanGUID').AsString;
        StepInfo.nStepID := FieldByName('nStepID').AsInteger;
        StepInfo.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
        StepInfo.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
        StepInfo.strTrainmanName := FieldByName('strTrainmanName').AsString;
        StepInfo.nStepResultID := FieldByName('nStepResultID').AsInteger;
        StepInfo.strStepResultText := FieldByName('strStepResultText').AsString;
        StepInfo.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
        StepInfo.dtEventTime := FieldByName('dtEventTime').AsDateTime;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TBeginworkViewDraw.GetTrainmanJpeg(Trainman: RRsTrainman;
  Jpeg: TJPEGImage);
var
  ms : TMemoryStream;  
begin
  ms := TMemoryStream.Create;
  try
    try
      TemplateOleVariantToStream(Trainman.Picture,ms);
      if (ms.Size = 0) then
      begin
        jpeg.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\�����Ƭ\nophoto.jpg');
        exit;
      end;
      ms.Position := 0;
      Jpeg.LoadFromStream(ms);


    except
      Jpeg.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\�����Ƭ\nophoto.jpg');
    end;
  finally
    ms.Free;
  end;
end;

end.
