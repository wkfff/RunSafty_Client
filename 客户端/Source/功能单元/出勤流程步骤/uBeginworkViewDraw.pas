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
    //获取路程数据
    function GetData(TrainplanGUID : string ;
      WorkShopGUID : string ;out TrainmanPlan : RRsTrainmanPlan;
      out FlowArray : TRsBeginworkFlowArray; out StepArray : TRsTrainmanBeginworkStepArray;
      out TrainFlow : RRsTrainplanBeginworkFlow) : boolean;
    //画计划信息
    procedure DrawPlanInfo(Canvas : TCanvas ;PlanRect : TRect;TrainNo,TrainjiaoluName : string;
      StartTime : TDateTime;PlanState : TRsPlanState);
    //画步骤的名字
    procedure DrawStepName(Canvas : TCanvas ;PlanRect : TRect;FlowData: TRsBeginworkFlowArray);
    //画乘务员的出勤进度
    procedure DrawTrainmanStep(Canvas : TCanvas;PlanRect : TRect;Trainman : RRsTrainman;
      FlowData: TRsBeginworkFlowArray;TrainmanStep: TRsTrainmanBeginworkStepArray;
      PlanFlow: RRsTrainplanBeginworkFlow);
    //获取圆行的区域
    function GetESRect(PlanRect:TRect; i : integer) : TRect;

  public
    //在画布上画指定计划的流程
    function Draw(Canvas : TCanvas;DrawRect : TRect;TrainPlanGUID,WorkShopGUID : string;
       IsDrawStepName : boolean = false) : TRect;
    //允许出勤
    procedure AllowBeginwork( AllowInfo : RRsTrainplanBeginworkFlow;ADOConn : TADOConnection);
    //获取最新的步骤信息
    function GetLastStep(ADOConn :TADOConnection;WorkShopGUID : string;
      out StepInfo : RRsTrainmanBeginworkStep) : boolean;
  public
    //计划标题背景色
    TitleBgcolor : TColor;
    //计划标题字体
    TitleFont : TFont;
    //已出勤的计划的标头背景色
    TitleCQBgColor : TColor;
    //已出勤的计划的标头的文字
    TitleCQFont : TFont;
    //计划标题高度
    TitleHeight : integer;

    //每个人的步骤高度
    StepHeight : integer;
    //步骤的空白间距
    StepPadding : integer;
    //照片的高度(宽高为3*2比例)
    PicHeight : integer;
    //照片的宽度
    PicWidth : integer;
    //步骤名称宽度
    StepNameWidth : integer;
    //步骤名称高度
    StepNameHeight : integer;
    //步骤背景色
    StepNameBgcolor : TColor;
    //步骤文字
    StepNameFont : TFont;
    //步骤名称距顶端高度
    StepNameTop : integer;

    //已完成流程的颜色
    FinishColor : TColor;
    //
    FinishLightColor : TColor;

    //未完成流程的颜色
    NormalColor : TColor;
    NormalLightColor : TColor;

    FrameColor : TColor;
    //整个画布的背景色
    Color : TColor;
    //正常文字颜色
    Font : TFont;

    //点的半径
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
   //计划标题背景色
    TitleBgcolor :=  Rgb(0,77,131);   
    //标题文字
    TitleFont := TFont.Create;
    TitleFont.Name := '宋体';
    TitleFont.Size := 20;
    TitleFont.Color := clWhite;
    TitleFont.Style := [fsBold];
    //计划标题高度
    TitleHeight := 45;

    //已出勤的计划的标头背景色
    TitleCQBgColor := Rgb(100,100,100);
    //已出勤的计划的标头的文字
    TitleCQFont := TFont.Create;
    TitleCQFont.Name := '宋体';
    TitleCQFont.Size := 20;
    TitleCQFont.Color := clWhite;
    TitleCQFont.Style := [fsBold];
    

    //每个人的步骤高度
    StepHeight := 120;

    //步骤的空白间距
    StepPadding := 10;
    //照片的高度(宽高为3*2比例)
    PicHeight := 80;
    //照片的宽度
    PicWidth := 120;
    //步骤名称宽度
    StepNameWidth := 120;
    //步骤名称高度
    StepNameHeight := 38;
    //步骤背景色
    StepNameBgcolor := Rgb(0,128,192);
    //步骤文字
    StepNameFont := TFont.Create;
    StepNameFont.Color := clWhite;
    StepNameFont.Size := 16;

    StepNameTop := 20;

   //已完成流程的颜色
    FinishColor := Rgb(255,128,0);;
    FinishLightColor := Rgb(255,165,74);
    //未完成流程的颜色
    NormalColor := Rgb(100,100,100);
    NormalLightColor := Rgb(110,110,110);

    FrameColor := Rgb(128,128,128);
    //整个画布的背景色
    Color := clWhite;
    //正常文字颜色
    Font := TFont.Create;
    Font.Name := '宋体';
    Font.Size := 12;
    Font.Color := clBlack;

    //点的半径
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
  //整个背景区域,实际标头区域,流程区域
  stepRect : TRect;

begin
  //获取出勤计划的流程数据
  if not GetData(TrainPlanGUID,WorkShopGUID,trainmanPlan,flowData,
    trainmanStep,planFlow) then exit;
  if m_RsLCTrainmanMgr = nil then
    m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);

 
  //计算计划画布的区域
  stepRect := DrawRect;
  stepRect.Bottom := stepRect.Top + titleHeight;

//  //画计划的信息
  DrawPlanInfo(Canvas,stepRect,TrainmanPlan.TrainPlan.strTrainNo,
    TrainmanPlan.TrainPlan.strTrainJiaoluName,TrainmanPlan.TrainPlan.dtStartTime,TrainmanPlan.TrainPlan.nPlanState);

  //画司机及流程
  if TrainmanPlan.Group.Trainman1.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //画步骤的名字
    DrawStepName(Canvas,stepRect,flowData);
    //画人员的照片及步骤的完成情况及连线
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman1,FlowData,TrainmanStep,PlanFlow);

  end;

  //画司机及流程
  if TrainmanPlan.Group.Trainman2.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //画步骤的名字
    DrawStepName(Canvas,stepRect,flowData);
    //画人员的照片及步骤的完成情况及连线
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman2,FlowData,TrainmanStep,PlanFlow);

  end;


  //画司机及流程
  if TrainmanPlan.Group.Trainman3.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //画步骤的名字
    DrawStepName(Canvas,stepRect,flowData);
    //画人员的照片及步骤的完成情况及连线
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman3,FlowData,TrainmanStep,PlanFlow);
  end;


  //画司机及流程
  if TrainmanPlan.Group.Trainman4.strTrainmanGUID <> '' then
  begin
    stepRect.Top := stepRect.Bottom;
    stepRect.Bottom := stepRect.Top + StepHeight;

    //画步骤的名字
    DrawStepName(Canvas,stepRect,flowData);
    //画人员的照片及步骤的完成情况及连线
    DrawTrainmanStep(Canvas,stepRect,TrainmanPlan.Group.Trainman4,FlowData,TrainmanStep,PlanFlow);
  end;

  stepRect.Top := stepRect.Bottom;
  stepRect.Bottom := stepRect.Top + StepHeight;
  result := stepRect;
end;

procedure TBeginworkViewDraw.DrawPlanInfo(Canvas: TCanvas; PlanRect: TRect;
  TrainNo, TrainjiaoluName: string; StartTime: TDateTime;PlanState : TRsPlanState);
var
  //时间文字宽度，车次文字宽度
  r : TRect;
  strText : string;
begin
  //背景色蓝色，文字色白色  
  Canvas.Brush.Color := TitleBgcolor;
  Canvas.Font.Assign(TitleFont);
  if PlanState >= psBeginWork then
  begin
    Canvas.Brush.Color := TitleCQBgColor;
    Canvas.Font.Assign(TitleCQFont);
  end;

  try
    //填充背景色
    r := PlanRect;
    r.Right := r.Right + 40;
    Canvas.FillRect(r);

    r := Rect(PlanRect.Left + StepPadding,PlanRect.Top + StepPadding,PlanRect.Right - StepPadding,PlanRect.Bottom - StepPadding);

    //机车交路名称画在最右侧
    strText :=  TrainjiaoluName;
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfRIGHT,tfVerticalCenter]);

    //计划的出勤时间画在最左侧
    strText := FormatDateTime('MM-dd HH:nn',StartTime);
    r.Left := r.Left + StepPadding;
    r.Right := r.Left + Canvas.TextWidth(strText);
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfLeft,tfVerticalCenter]);

    //车次跟着出勤时间画
    strText :=   '    ' + TrainNo;
    r.Left := r.Right + StepPadding;
    r.Right := r.Left + Canvas.TextWidth(strText);
    Canvas.TextRect(r,strText,[tfSINGLELINE,tfLeft,tfVerticalCenter]);
  finally
    //字体画刷颜色还原
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
//背景色蓝色，文字色白色
  Canvas.Brush.Color := StepNameBgcolor;
  Canvas.Font.Assign(StepNameFont);
  penColor := Canvas.Pen.Color;
  try
    //填充背景色
    SetBkMode(Canvas.Handle,TRANSPARENT);
    for I := 0 to length(FlowData) - 1 do
    begin
      r := PlanRect;

      //去除照片的位置
      r.Left := PlanRect.Left + PicWidth + StepPadding *2;
      //计算第N个步骤左侧为为 n*2 + 1个间距 加上
      r.Left := r.Left +  StepPadding + (i * StepNameWidth) + i*2*StepPadding;
      //右侧等于左侧加上区域宽度
      r.Right := r.Left + StepNameWidth;
      //上方为区域上方加上制定距离
      r.Top := r.Top + StepNameTop;
      //下方为上方加上制定高度
      R.Bottom := r.Top + StepNameHeight;
      Canvas.Pen.Color := Color;
      Canvas.RoundRect(r.Left,r.Top,r.Right,r.Bottom,10,10);
      Canvas.TextRect(r,FlowData[i].strStepName,[tfSINGLELINE,tfCenter,tfVerticalCenter]);

    end;
  finally
    //字体画刷颜色还原
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
      //图片的区域
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
  //去除照片的位置
  r.Left := PlanRect.Left + PicWidth + StepPadding *2;
  //计算第N个步骤左侧为为 n*2 + 1个间距 加上
  r.Left := r.Left +  StepPadding + (i * StepNameWidth) + i*2*StepPadding;

  r.Left := r.Left + (StepNameWidth div 2) - DotWidth div 2;



  //右侧等于左侧加上区域宽度
  r.Right := r.Left + DotWidth ;

  //上方为区域上方加上制定距离
  r.Top := PlanRect.Top + StepNameTop + StepNameHeight + StepPadding;
  //下方为上方加上制定高度
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
        jpeg.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\测酒照片\nophoto.jpg');
        exit;
      end;
      ms.Position := 0;
      Jpeg.LoadFromStream(ms);


    except
      Jpeg.LoadFromFile(ExtractFilePath(Application.ExeName) + 'Images\测酒照片\nophoto.jpg');
    end;
  finally
    ms.Free;
  end;
end;

end.
