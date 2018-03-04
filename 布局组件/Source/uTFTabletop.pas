unit uTFTabletop;

interface
uses Windows,Graphics,Forms,Classes,Contnrs,Controls,Messages,SysUtils ,
    ExtCtrls,ufrmTabletopDrag,uTFSystem,Consts,pngimage;


const
  {固定列宽度}
  FIXEDWIDTH = 60;
  {固定列高度}
  FIXEDHEIGHT = 40;

type
  TViewList = class;
  TView = class;



  {TActionType 操作类型}
  TActionType = (atMouse{鼠标操作},atClick{点击},atDragOver{拖起},
      atDragDrop{放下},atSelected{选择});
  {TLayoutType 布局类型}
  TLayoutType = (ltVertical{垂直布局,不出现水平滚动条},ltGrid{表格布局});
  //操作类型集合
  TActionTypeSet = set of TActionType;
  {TOnViewChange 视图内容变化通知事件}
  TOnViewChange = procedure(View : TView)of Object;
  {TOnGetBackBitmap 获取背景事件通知}
  TOnGetBackgroundBitmap = procedure(View:TView;Bitmap:TBitmap)of Object;
  {TOnNeedReComposition 需要重新计算位置事件通知}
  TOnNeedReComposition = procedure(View:TView) of Object;


  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TView
  /// 说明:显示基类
  ///  需要注意的是,View包含的子View需要加入到Childs中,这样在鼠标消息，Click消息，
  ///  才会自动通知到子View
  /////////////////////////////////////////////////////////////////////////////
  TView = class
  public
    constructor Create(vParent:TView = nil);virtual;
    destructor Destroy();override;
  public
    {支持的行为}
    ActionTypeSet : TActionTypeSet;
  public
    {功能:返回区域}
    function GetRect():TRect;
    {功能:获得View的显示内容,backBitmap由外面传递过来使用,
        最终生成viewBitmap即可}
    {功能:获得最外层区域}
    function GetOuterRect():TRect;

    procedure getBitmap(viewBitmap:TBitmap);virtual;
    {获得拖拽需要的Bitmap,默认还是使用getBitmap,可以继承修改}
    procedure getDragBitmap(viewBitmap:TBitmap);virtual;
    {功能:客户区域转屏幕区域}
    function ClientToScreen(Point: TPoint):TPoint;
    {功能:开始更新数据}
    procedure BeginUpdate();
    {功能:结束更新数据}
    procedure EndUpdate();
    {功能:克隆}
    procedure Clone(view:TView);virtual;
  protected
    m_nLeft : Integer;
    m_nTop : Integer;
    m_nWidth : Integer;
    m_nHeight : Integer;
    //是否允许拖拽,默认是True
    m_bAllowDrag : Boolean;
    //行号
    m_nRow : Integer;
    //列号
    m_nCol : Integer;
    //外边距
    m_Margins : TMargins;

    {子视图}
    m_Childs : TViewList;
    {当内容发生变化，需要重新绘制的时候调用}
    m_OnViewChange : TOnViewChange;
    {获取背景事件通知,当View内容变化后需要重新绘制时调用}
    m_OnGetBackgroundBitmap : TOnGetBackgroundBitmap;
    {父View}
    m_Parent : TView;
    {是否正在更新}
    m_bIsUpdate : Boolean;
    {需要重新计算位置事件通知}
    m_OnNeedReComposition : TOnNeedReComposition;
    {是否选择}
    m_bSelected : Boolean;
        {是否双击选择}
    m_bDblClicked:Boolean;
  protected
    procedure SetLeft(nValue:Integer);
    procedure SetTop(nValue:Integer);
    procedure SetHeight(nValue:Integer);
    procedure SetWidth(nValue:Integer);
    procedure SetAllowDrag(bValue:boolean);
    procedure SetRow(nValue:Integer);
    procedure SetCol(nValue:Integer);
    procedure SetMargins(Value:TMargins);
    procedure SetSelected(Value:Boolean);

    function GetClientOrigin: TPoint;
    {功能:当子View发生变化的话,需要自己重新绘制子View}
    procedure OnChildViewChange(View: TView);virtual;
    {功能:点击事件}
    procedure Click();
        {功能:双击}
    procedure DblClick();virtual;
    {功能:内容变动}
    procedure ViewChange();
    {功能:检查是否允许放下}
    function CheckViewDrop(View:TView):Boolean;virtual;
    {功能:有View拖上来了,还没放下，例如可以在这里显示一些信息等等}
    procedure ViewDrag(View:TView);virtual;
    {功能:有View放下}
    procedure ViewDragDrop(View:TView);virtual;
    {功能:对View绘制选择效果}
    procedure DrawSelectedView(ViewBitmap:TBitmap);virtual;
  public
    property Left : Integer read m_nLeft write setLeft;
    property Top : Integer read m_nTop write setTop;
    property Width : Integer read m_nWidth write setWidth;
    property Height : Integer read m_nHeight write setHeight;
    property Row : Integer read m_nRow write SetRow;
    property Col : Integer read m_nCol write SetCol;
    property Margins : TMargins read m_Margins write SetMargins;
    property OnViewChange : TOnViewChange read m_OnViewChange write m_OnViewChange;
    property OnNeedReComposition : TOnNeedReComposition
        read m_OnNeedReComposition write m_OnNeedReComposition;

    property Parent : TView read m_Parent write m_Parent;
    property ClientOrigin : TPoint read GetClientOrigin;
    property Childs : TViewList read m_Childs;
    property Selected : Boolean read m_bSelected write SetSelected;
    property DblClicked:Boolean read m_bDblClicked write m_bDblClicked;
  end;




  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TViewList
  /// 说明:显示基类列表
  /////////////////////////////////////////////////////////////////////////////
  TViewList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TView;
    procedure SetItem(Index: Integer; View: TView);
  protected
    {根据坐标和操作类型，查找View}
    function FindView(X,Y:Integer;ActionType:TActionType):TView;
    {功能:获得当前选择的View}
    function FindSelectedView():TView;
    {功能:设置Selected状态}
    procedure SetItemsSelected(Value:Boolean;ignored: TView = nil);
  public
    function Add(View: TView): Integer;
    property Items[Index: Integer]: TView read GetItem write SetItem; default;
  end;

  TCanvasCenter = class(TGraphicControl)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  private
    {位图画布，也就是实际显示的内容}
    m_BitmapCanvas : TBitmap;
    m_OnPaint: TNotifyEvent;
  protected
    procedure Paint; override;
    procedure Resize; override;
    {功能:获得位图画布}
    function GetBitmapCanvas():TCanvas;
  public
    property Canvas;
    property BitmapCanvas:TCanvas read GetBitmapCanvas;
  end;

  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TFixedCol
  /// 说明:固定单元信息
  /////////////////////////////////////////////////////////////////////////////
  TFixedCell = class
  public
    //所在行
    Row : Integer;
    //所在列
    Col : Integer;
    //内容
    Text : String;
  end;

  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TFixedCellList
  /// 说明:固定单元信息列表
  /////////////////////////////////////////////////////////////////////////////
  TFixedCellList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TFixedCell;
    procedure SetItem(Index: Integer; FixedCell: TFixedCell);
  public
    function Add(FixedCell: TFixedCell): Integer;
    property Items[Index: Integer]: TFixedCell read GetItem write SetItem; default;
  end;


  /////////////////////////////////////////////////////////////////////////////
  /// 类名:TTFTabletop
  /// 说明:布局显示类
  /////////////////////////////////////////////////////////////////////////////
  TTFTabletop = class(TScrollBox)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy();override;
  public
    {功能:添加视图}
    procedure AddView(View:TView);
    {功能:删除视图}
    procedure DeleteView(View:TView);overload;
    {功能:删除视图}
    procedure DeleteView(nIndex:Integer);overload;
    {功能:交换视图}
    procedure ExchangeView(DesView, OptView:TView);overload;
    procedure ExchangeView(nDesIndex, nOptIndex:Integer);overload;  
    {功能:插入一个新视图}
    procedure InsertNewViewBefore(DesView, NewView:TView);overload;
    procedure InsertNewViewBefore(nDesIndex:Integer; NewView:TView);overload;   
    procedure InsertNewViewAfter(DesView, NewView:TView);overload;
    procedure InsertNewViewAfter(nDesIndex:Integer; NewView:TView);overload;
    {功能:一个已存在视图插入到另一个已存在视图的前面或后面}
    procedure InsertExistViewBefore(DesView, OptView:TView);overload;
    procedure InsertExistViewBefore(nDesIndex, nOptIndex:Integer);overload;
    procedure InsertExistViewAfter(DesView, OptView:TView);overload;
    procedure InsertExistViewAfter(nDesIndex, nOptIndex:Integer);overload;

    {功能:根据坐标,获得View}
    function FindView(X,Y:Integer):TView;
    {功能:获得当前选择的View}
    function GetSelectedView():TView;
    {功能:清理视图}
    procedure ClearView();
    {功能:获得视图总数}
    function GetViewCount():Integer;
    {功能:重新绘制}
    procedure ReComposition();
    {功能:设置布局类型}
    procedure SetLayoutType(Value:TLayoutType);
    {功能:获取View}
    function GetView(Index:Integer):TView;
    {功能:设置View}
    procedure SetView(Index:Integer;View:TView);
    {功能:开始更新数据}
    procedure BeginUpdate();
    {功能:结束更新数据}
    procedure EndUpdate();
    {功能:刷新画布}
    procedure ReCanvas();
  protected
    {拖拽窗口}
    m_frmTabletopDrag : TfrmTabletopDrag;
    {固定列信息}
    m_FixedCellList : TFixedCellList;
  protected
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean;override;

    procedure CenterMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer) ;
    procedure CenterMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
    procedure CenterMouseUp(Sender: TObject;Button: TMouseButton; Shift: TShiftState;
        X, Y: Integer);

    procedure WMLButtonUp(var Message: TWMLButtonUp); message WM_LBUTTONUP;
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure WMVScroll(var Message: TWMVScroll); message WM_VSCROLL;
    procedure WMHScroll(var Message: TWMHScroll); message WM_HSCROLL;
    procedure Resize; override;


  private
    m_DragStartPoint: TPoint;
    //是否正在更新
    m_bIsUpdate : Boolean;
    //视图列表
    m_ViewList : TViewList;
    //布局类型
    m_LayoutType : TLayoutType;
   //画布
    m_CanvasCenter : TCanvasCenter;

    {是否按下}
    m_bIsDown : Boolean;
    {是否已经拖拽}
    m_bIsDrag : Boolean;
    {向上下移动滚动条定时器}
    m_tmrAutoMoveToUpDown : TTimer;
    {向左右移动滚动条定时器}
    m_tmrAutoMoveToLeftRight : TTimer;
    {总行数}
    m_nRowCount : Integer;
    {总列数}
    m_nColCount : Integer;
    {行高}
    m_nRowHeight : Integer;
    {列宽}
    m_nColWidth : Integer;
    {线条颜色}
    m_nGridLineColor : TColor;
    {当前拖拽的View}
    m_DragView : TView;
    {当前悬浮View,如果这个View不为nil,那么就在它身上，画一个虚框，
        表示拖拽的View在它上面}
    m_SuspendedView : TView;
    {悬浮View之前的Bitmap}
    m_SuspendedOldBitmap : TBitmap;
    {拖拽样式}
    m_DragFocusEffect : TPngObject;
    {拖拽样式颜色}
    m_DragFocusEffectColor : TColor;
    {拖拽样式颜色透明度,0-255,默认200}
    m_DragFocusEffectColorAPPend : Integer;
  private
    //------------------------绘制相关-----------------------------------
    {功能:画布重绘事件}
    procedure OnPaint(Sender:TObject);
    {功能:绘制VIEW}
    function DrawView(View:TView):Boolean;
    {功能:绘制被拖拽的View}
    procedure DrawDragView();
    {功能:绘制拖拽焦点}
    procedure DrawDragFocusEffect();
    {功能:绘制表格背景}
    procedure DrawGrid();
    {功能:绘制固定列}
    procedure DrawFixedCells();
    {功能:备份SuspendedView}
    procedure BackupSuspendedView(SuspendedView:TView);
    {功能:还原SuspendedView}
    procedure ReductionSuspendedView();
  private
    //--------------------------工具类-----------------------------------
    {功能:初始化ViewBitmap}
    procedure InitViewBitmap(View:TView;viewBitmap:TBitmap);
    {功能:检查View是否在当前显示区域}
    function ViewIsDisplayRect(View:TView):Boolean;
    {功能:根据滚动条计算区域}
    procedure CalcScrollBarRect(var Rect:TRect);
    {功能:转换View,让他尽量和拖拽的View的类保持一致}
    function TransformView(View:TView):TView;
    {功能:对VIEW绘制半透明图层}
    procedure DrawAlphaView(View: TView;Color:TColor;nAPPend:Integer);
  private
    {功能:拖拽view}
    procedure DragView(View:TView;X,Y:Integer);
    {功能:拖拽放下}
    procedure ViewDragDrop(ScreenX,ScreenY:Integer);
    {功能:获得指定行的高度最高的View}
    function GetRowMaxHeightView(nRow:Integer):TView;
    {功能:设置区域,传递View在List中的索引}
    procedure SetVerticalViewPoint(nViewIndex:Integer);
    {功能:设置区域,表格类型布局}
    procedure SetGridViewPoint(nViewIndex:Integer);
    {功能:限制移动窗口范围}
    procedure LimitDragRange(var ScreenX,ScreenY:Integer);
    {功能:显示拖拽焦点}
    procedure ShowDragFocusEffect(ScreenX,ScreenY:Integer);
    {功能:根据表格设置尺寸}
    procedure FillGridRect();
  private
    //-----------------------------事件相关-------------------------------
    {功能:View变化通知}
    procedure OnViewChange(View : TView);
    {功能:拖拽窗口关闭事件}
    procedure OnDragClose(Sender: TObject; var Action: TCloseAction);
    {功能:拖拽窗口移动事件}
    procedure OnDragMoveing(var ScreenX,ScreenY:Integer;var bIsMove:Boolean);
    {功能:视图需要重新计算位置事件通知}
    procedure OnNeedReComposition(View:TView);
    {功能:自动向上下移动滚动条定时器事件}
    procedure OntmrAutoMoveToUpDown(Sender:TObject);
    {功能:自动向左右移动滚动条定时器事件}
    procedure OntmrAutoMoveToLeftRight(Sender:TObject);
  private
    //----------------------属性设置相关---------------------------------
    {功能:获得固定单元}
    function GetFixedCellText(nRow,nCol:Integer):String;
    {功能:设置固定单元}
    procedure SetFixedCellText(nRow,nCol:Integer;const strText:String);
    procedure SetRowCount(nRowCount:Integer);
    procedure SetColCount(nColCount:Integer);
    procedure SetRowHeight(nHeight:Integer);
    procedure SetColWidth(nWidth:Integer);
    procedure SetGridLineColor(nColor : TColor);
    procedure SetDragFocusEffectImage(Value: TPngObject);    
    {功能:将全部的View去掉Selected状态}
    procedure SetViewsSelected(Value:Boolean;ignored: TView = nil);
  public
    //视图列表
    property ViewList : TViewList read m_ViewList write m_ViewList; 
      property FixedCells[nRow,nCol: Integer] : String read GetFixedCellText
        write SetFixedCellText;
  published
    property DragFocusEffect : TPngObject read m_DragFocusEffect
        write SetDragFocusEffectImage;

    property DragFocusEffectColor : TCOlor read m_DragFocusEffectColor
        write m_DragFocusEffectColor;

    property DragFocusEffectColorAPPend : integer
        read m_DragFocusEffectColorAPPend write m_DragFocusEffectColorAPPend;

    property RowCount : Integer read m_nRowCount write SetRowCount;
    property ColCount : Integer read m_nColCount write SetColCount;
    property RowHeight : Integer read m_nRowHeight write SetRowHeight;
    property ColWidth : Integer read m_nColWidth write SetColWidth;
    property GridLineColor : TColor read m_nGridLineColor write SetGridLineColor;
  end;

  procedure Register;

implementation

{ TView }

procedure Register;
begin
  RegisterComponents('TFUIControl', [TTFTabletop]);
end;

procedure TView.BeginUpdate;
begin
  m_bIsUpdate := True;
end;

function TView.CheckViewDrop(View: TView): Boolean;
{功能:检查是否允许放下,默认类名不一样，就不允许放下}
begin
  Result := False;
  if ClassName <> View.ClassName then Exit;
  Result := True;
end;

procedure TView.Click;
{功能:点击事件}
begin

end;


function TView.ClientToScreen(Point: TPoint): TPoint;
{功能:客户区域转屏幕区域}
var
  Origin: TPoint;
begin
  Origin := ClientOrigin;
  Result.X := Point.X + Origin.X;
  Result.Y := Point.Y + Origin.Y;
end;

procedure TView.Clone(view: TView);
begin
  //Self.m_bDblClicked := view.DblClicked;
end;

constructor TView.Create(vParent : TView = nil);
begin
  m_bIsUpdate := False;
  m_Childs := TViewList.Create;
  m_Parent := vParent;
  m_bSelected := False;
  //默认是全支持
  ActionTypeSet := [atMouse,atClick,atDragOver,atDragDrop,atSelected];
  m_Margins := TMargins.Create(nil);
  m_nWidth := 50;
  m_nHeight := 50;

end;

procedure TView.DblClick();
{功能:双击事件}
begin
  //m_bDblClicked := False;
end;

destructor TView.Destroy;
begin
  m_Margins.Free;
  m_Childs.Free;

  inherited;

end;



procedure TView.DrawSelectedView(ViewBitmap: TBitmap);
{功能:对View绘制选择效果}
begin
  DrawAlphaBackground(ViewBitmap,clBlue,ViewBitmap.Canvas.ClipRect,100);
end;

procedure TView.EndUpdate;
begin
  m_bIsUpdate := False;
end;

procedure TView.getBitmap(viewBitmap: TBitmap);
{功能:获得View的显示内容,backBitmap由外面传递过来使用,
  最终生成viewBitmap即可}
begin
  viewBitmap.Width := Width;
  viewBitmap.Height := Height;
  viewBitmap.Canvas.Brush.Color := clred;
  viewBitmap.Canvas.FillRect(viewBitmap.Canvas.ClipRect);
  if Selected then
    DrawSelectedView(viewBitmap);
end;

function TView.GetClientOrigin: TPoint;
begin
  if Parent <> nil then
  begin
    Result := Parent.ClientOrigin;
    Inc(Result.X, m_nLeft);
    Inc(Result.Y, m_nTop);
  end
  else
  begin
    Result.X := m_nLeft;
    Result.Y := m_nTop;
  end;
end;

procedure TView.getDragBitmap(viewBitmap: TBitmap);
begin
  getBitmap(viewBitmap);
end;

function TView.GetOuterRect: TRect;
{功能:获得最外层区域}
var
  pt : TPoint;
begin
  if Parent <> nil then
  begin
    pt := ClientOrigin;
    Result.Left := pt.x;
    Result.Top := pt.y;
    Result.Right := Result.Left + m_nWidth;
    Result.Bottom := Result.Top + m_nHeight;
  end
  else
  begin
    Result := GetRect;
  end;
end;

function TView.GetRect: TRect;
{功能:返回区域}
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Left+Width;
  Result.Bottom := Top + Height;
end;



procedure TView.OnChildViewChange(View: TView);
{功能:当子View发生变化的话,需要自己重新绘制子View}
begin
  //其实就是通知父View来绘制
  ViewChange();
end;

procedure TView.SetAllowDrag(bValue: boolean);
begin
  m_bAllowDrag := bValue;
end;

procedure TView.SetCol(nValue: Integer);
begin
  m_nCol := nValue;
  ViewChange();
end;

procedure TView.SetHeight(nValue: Integer);
begin
  m_nHeight := nValue;
end;

procedure TView.SetLeft(nValue: Integer);
begin
  m_nLeft := nValue;
end;

procedure TView.SetMargins(Value: TMargins);
begin
  m_Margins.Assign(Value);
end;

procedure TView.SetRow(nValue: Integer);
begin
  m_nRow := nValue;
  ViewChange();
end;


procedure TView.SetSelected(Value: Boolean);
begin
  if m_bSelected = Value then Exit;
  m_bSelected := Value;
  ViewChange();
end;

procedure TView.SetTop(nValue: Integer);
begin
  m_nTop := nValue;
end;

procedure TView.SetWidth(nValue: Integer);
begin
  m_nWidth := nValue;
end;



procedure TView.ViewChange;
{功能:内容变动}
begin
  //如果正在更新则不处理
  if m_bIsUpdate then exit;

  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TView.ViewDrag(View: TView);
{功能:有View拖上来了}
begin

end;

procedure TView.ViewDragDrop(View: TView);
{功能:有View放下}
begin

end;

{ TViewList }
function TViewList.Add(View: TView): Integer;
begin
  Result := inherited Add(View);
end;

function TViewList.FindSelectedView: TView;
var
  i : Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].Selected then
    begin
      Result := Items[i];
      Break;
    end;
    Result := Items[i].m_Childs.FindSelectedView;
    if Result <> nil then Break;
  end;
end;

function TViewList.FindView(X, Y: Integer; ActionType: TActionType): TView;
{根据坐标和操作类型，查找View}
var
  i : Integer;
  pt : TPoint;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin

    pt.X := X;
    pt.Y := Y;

    if PtInRect(Items[i].GetRect,pt) then
    begin
    
      Result := Items[i].m_Childs.FindView(
          X - Items[i].Left,
          Y - Items[i].Top,ActionType);

      if Result = nil then
      begin
        if ActionType in Items[i].ActionTypeSet then
        begin
          Result := Items[i];
        end;
      end;
      Exit;
    end;
  end;

end;

function TViewList.GetItem(Index: Integer): TView;
begin
  Result := TView(inherited GetItem(Index));
end;

procedure TViewList.SetItem(Index: Integer; View: TView);
begin
  inherited SetItem(Index,View);
end;

procedure TViewList.SetItemsSelected(Value: Boolean;ignored: TView);
{功能:设置Selected状态}
var
  i : Integer;
begin
  for I := 0 to Count - 1 do
  begin
    if Items[i] = ignored then
      Continue;
    
    Items[i].Selected := Value;
    Items[i].m_Childs.SetItemsSelected(Value,ignored);
  end;
end;

{ TTFTabletop }

procedure TTFTabletop.AddView(View: TView);
begin
  m_ViewList.Add(View);
  View.OnNeedReComposition := OnNeedReComposition;
  View.m_OnViewChange := OnViewChange;
  case m_LayoutType of
    ltVertical :
      begin
        SetVerticalViewPoint(m_ViewList.Count-1);
      end;
    ltGrid :
      begin
        SetGridViewPoint(m_ViewList.Count-1);
      end;
  end;
  DrawView(View);
end;


procedure TTFTabletop.BackupSuspendedView(SuspendedView: TView);
{功能:备份SuspendedView}
var
  tmpBitmap : TBitmap;
begin

  tmpBitmap := TBitmap.Create;
  try
    InitViewBitmap(SuspendedView,tmpBitmap);
    SuspendedView.getBitmap(tmpBitmap);

    m_SuspendedOldBitmap.Width := tmpBitmap.Width;
    m_SuspendedOldBitmap.Height := tmpBitmap.Height;
    m_SuspendedOldBitmap.Canvas.CopyRect(m_SuspendedOldBitmap.Canvas.ClipRect,
        tmpBitmap.Canvas,tmpBitmap.Canvas.ClipRect);
  finally
    tmpBitmap.Free;
  end;


end;

procedure TTFTabletop.BeginUpdate;
begin
  m_bIsUpdate := True;
end;

procedure TTFTabletop.CMColorChanged(var Message: TMessage);
begin
  inherited;
  m_CanvasCenter.Canvas.Brush.Color := Color;
  ReComposition();
end;

constructor TTFTabletop.Create(AOwner: TComponent);
begin
  inherited;
  m_bIsUpdate := False;
  TabStop := True;
  m_bIsDrag := False;
  m_bIsDown := False;
  m_ViewList := TViewList.Create;
  m_LayoutType := ltVertical;
  m_CanvasCenter := TCanvasCenter.Create(self);
  m_CanvasCenter.Parent := self;
  m_CanvasCenter.Left := 0;
  m_CanvasCenter.Top := 0;
  m_CanvasCenter.Width := Width;
  m_CanvasCenter.Height := Height;
  m_CanvasCenter.Canvas.Brush.Color := Color;
  m_CanvasCenter.OnMouseDown := CenterMouseDown;
  m_CanvasCenter.OnMouseMove := CenterMouseMove;
  m_CanvasCenter.OnMouseUp := CenterMouseUp;
  m_CanvasCenter.BitmapCanvas.Brush.Color := Color;
  m_CanvasCenter.m_OnPaint := OnPaint;
  m_tmrAutoMoveToUpDown := TTimer.Create(nil);
  m_tmrAutoMoveToUpDown.OnTimer := OntmrAutoMoveToUpDown;
  m_tmrAutoMoveToUpDown.Interval := 100;
  m_tmrAutoMoveToUpDown.Enabled := False;
  m_tmrAutoMoveToLeftRight := TTimer.Create(nil);
  m_tmrAutoMoveToLeftRight.OnTimer := OntmrAutoMoveToLeftRight;
  m_tmrAutoMoveToLeftRight.Interval := 100;
  m_tmrAutoMoveToLeftRight.Enabled := False;
  m_FixedCellList := TFixedCellList.Create;
  m_DragView := nil;
  m_SuspendedView := nil;
  m_SuspendedOldBitmap := TBitmap.create;
  m_DragFocusEffectColorAPPend := 200;
  m_DragFocusEffectColor := $001FC48F;
  m_DragFocusEffect := TPngObject.Create;

  m_nGridLineColor := $00311918;
  m_nRowHeight := 118;
  m_nColWidth := 60;

end;

destructor TTFTabletop.Destroy;
begin
  m_ViewList.Free;
  m_CanvasCenter.Free;
  m_tmrAutoMoveToUpDown.Free;
  m_tmrAutoMoveToLeftRight.Free;
  m_SuspendedOldBitmap.Free;
  m_DragFocusEffect.Free;
  m_FixedCellList.Free;
  inherited;
end;

procedure TTFTabletop.DeleteView(nIndex: Integer);
{功能:删除视图}
begin
  m_ViewList.Delete(nIndex);
  if m_LayoutType = ltVertical then
  begin
    ReComposition();
    ReCanvas;
  end
  else
    Repaint();

end;

procedure TTFTabletop.DeleteView(View: TView);
var
  nIndex : Integer;
begin
  nIndex := m_ViewList.IndexOf(View);
  if nIndex <> -1 then
  begin
    DeleteView(nIndex);
  end;

end;

procedure TTFTabletop.ExchangeView(DesView, OptView:TView);
var
  nDesIndex, nOptIndex: Integer;
begin
  nDesIndex := m_ViewList.IndexOf(DesView);
  nOptIndex := m_ViewList.IndexOf(OptView);
  ExchangeView(nDesIndex, nOptIndex);
end;

procedure TTFTabletop.ExchangeView(nDesIndex, nOptIndex:Integer);
begin
  if nDesIndex = nOptIndex then exit;   //同一位置，操作不合理
  if (nDesIndex < 0) or (nDesIndex >= m_ViewList.Count) then exit;
  if (nOptIndex < 0) or (nOptIndex >= m_ViewList.Count) then exit;

  m_ViewList.Exchange(nDesIndex, nOptIndex);
  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end
  else
    Repaint();
end;
      
procedure TTFTabletop.InsertNewViewBefore(DesView, NewView:TView);
begin
  InsertNewViewBefore(m_ViewList.IndexOf(DesView), NewView);
end;

procedure TTFTabletop.InsertNewViewBefore(nDesIndex:Integer; NewView:TView);
begin                         
  if (nDesIndex < 0) or (nDesIndex >= m_ViewList.Count) then exit;

  m_ViewList.Insert(nDesIndex, NewView);
  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end
  else
    Repaint();
end;
                      
procedure TTFTabletop.InsertNewViewAfter(DesView, NewView:TView);
begin
  InsertNewViewAfter(m_ViewList.IndexOf(DesView), NewView);
end;

procedure TTFTabletop.InsertNewViewAfter(nDesIndex:Integer; NewView:TView);
begin                         
  if (nDesIndex < 0) or (nDesIndex >= m_ViewList.Count) then exit;

  if m_ViewList.Count = nDesIndex+1 then
    m_ViewList.Add(NewView)
  else
    m_ViewList.Insert(nDesIndex+1, NewView);
    
  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end
  else
    Repaint();
end;

procedure TTFTabletop.InsertExistViewBefore(DesView, OptView:TView);
var
  nDesIndex, nOptIndex: Integer;
begin
  nDesIndex := m_ViewList.IndexOf(DesView);
  nOptIndex := m_ViewList.IndexOf(OptView);
  InsertExistViewBefore(nDesIndex, nOptIndex);
end;

procedure TTFTabletop.InsertExistViewBefore(nDesIndex, nOptIndex:Integer);
var
  FList: PPointerList;
  Item: Pointer;
begin
  if nDesIndex = nOptIndex then exit;   //同一位置，操作不合理
  if nDesIndex = nOptIndex+1 then exit; //已经是此位置了，无需插入
  if (nDesIndex < 0) or (nDesIndex >= m_ViewList.Count) then exit;
  if (nOptIndex < 0) or (nOptIndex >= m_ViewList.Count) then exit;

  FList := m_ViewList.List;
  Item := FList^[nOptIndex];

  if nDesIndex < nOptIndex then
  begin
    System.Move(FList^[nDesIndex], FList^[nDesIndex+1], (nOptIndex-nDesIndex) * SizeOf(Pointer));
    FList^[nDesIndex] := Item;
  end
  else
  begin
    System.Move(FList^[nOptIndex+1], FList^[nOptIndex], (nDesIndex-nOptIndex-1) * SizeOf(Pointer)); 
    FList^[nDesIndex-1] := Item;
  end;

  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end
  else
    Repaint();
end;

procedure TTFTabletop.InsertExistViewAfter(DesView, OptView:TView);
var
  nDesIndex, nOptIndex: Integer;
begin
  nDesIndex := m_ViewList.IndexOf(DesView);
  nOptIndex := m_ViewList.IndexOf(OptView);
  InsertExistViewAfter(nDesIndex, nOptIndex);
end;

procedure TTFTabletop.InsertExistViewAfter(nDesIndex, nOptIndex:Integer);
var
  FList: PPointerList;
  Item: Pointer;
begin
  if nDesIndex = nOptIndex then exit;   //同一位置，操作不合理
  if nDesIndex = nOptIndex-1 then exit; //已经是此位置了，无需插入
  if (nDesIndex < 0) or (nDesIndex >= m_ViewList.Count) then exit;
  if (nOptIndex < 0) or (nOptIndex >= m_ViewList.Count) then exit;

  FList := m_ViewList.List;
  Item := FList^[nOptIndex];

  if nDesIndex < nOptIndex then
  begin
    System.Move(FList^[nDesIndex+1], FList^[nDesIndex+2], (nOptIndex-nDesIndex-1) * SizeOf(Pointer));
    FList^[nDesIndex+1] := Item;
  end
  else
  begin
    System.Move(FList^[nOptIndex+1], FList^[nOptIndex], (nDesIndex-nOptIndex) * SizeOf(Pointer)); 
    FList^[nDesIndex] := Item;
  end;

  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end
  else
    Repaint();
end;

function TTFTabletop.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
begin
  Result := inherited DoMouseWheel(Shift,WheelDelta,MousePos);
  if  WheelDelta < 0   then
  begin
    //向下滚动
    VertScrollBar.Position := VertScrollBar.Position  + 20;
  end
  else
  begin
    //向上滚动
    VertScrollBar.Position := VertScrollBar.Position  - 20;
  end;
  m_CanvasCenter.Top := 0;
end;


procedure TTFTabletop.DragView(View: TView;X,Y:Integer);
var
  parentView : TView;
  PtWindow : TPoint;
  tmpBitmap : TBitmap;
begin
  if m_frmTabletopDrag <> nil then Exit;

  m_DragView := View;
  //首先绘制VIEW特殊样式
  DrawDragView();

  m_frmTabletopDrag := TfrmTabletopDrag.Create(nil);
  m_frmTabletopDrag.OnClose := OnDragClose;
  m_frmTabletopDrag.OnMoveing := OnDragMoveing;
  parentView := View;
  PtWindow.X :=  X;
  PtWindow.Y :=  Y;

  while parentView <> nil do
  begin
    PtWindow.X := PtWindow.X + parentView.Left;
    PtWindow.Y := PtWindow.Y + parentView.Top;
    parentView := parentView.Parent;
  end;
  PtWindow.Y := PtWindow.Y - VertScrollBar.Position;
  PtWindow.X := PtWindow.X - HorzScrollBar.Position;
  PtWindow := ClientToScreen(PtWindow);
  PtWindow.X := PtWindow.X - X;
  PtWindow.Y := PtWindow.Y - Y;

  tmpBitmap := TBitmap.Create;
  try
    InitViewBitmap(View,tmpBitmap);
    View.getDragBitmap(tmpBitmap);
    m_frmTabletopDrag.SetBitmap(tmpBitmap);
  finally
    tmpBitmap.Free;
  end;

  m_frmTabletopDrag.SetStartPoint(PtWindow.X,PtWindow.Y);
  m_frmTabletopDrag.Show;

  PostMessage(Handle,WM_LBUTTONUP,0,0);
end;

procedure TTFTabletop.DrawAlphaView(View: TView;Color:TColor;nAPPend:Integer);
{功能:对VIEW绘制半透明图层}
var
  Bitmap : TBitmap;
  OuterRect : TRect;
begin
  OuterRect := View.GetOuterRect;
  CalcScrollBarRect(OuterRect);
  Bitmap := TBitmap.Create;
  InitViewBitmap(View,Bitmap);
  try
    View.getBitmap(Bitmap);
    DrawAlphaBackground(Bitmap,Color,Bitmap.Canvas.ClipRect,nAPPend);
    m_CanvasCenter.Canvas.Draw(OuterRect.Left,OuterRect.Top,Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure TTFTabletop.DrawDragFocusEffect;
{功能:绘制拖拽焦点}
var
  OuterRect : TRect;
begin
  OuterRect := m_SuspendedView.GetOuterRect;
  CalcScrollBarRect(OuterRect);
  if m_DragFocusEffect.Width <> 0 then
  begin
    StretchDrawPicture(m_CanvasCenter.Canvas,OuterRect,m_DragFocusEffect);
  end
  else
  begin
    DrawAlphaView(m_SuspendedView,m_DragFocusEffectColor,m_DragFocusEffectColorAPPend);
  end;
end;

procedure TTFTabletop.DrawDragView;
{功能:绘制被拖拽的View}
begin
  if m_DragView = nil then Exit;
  //只有View在显示区域内，才会绘制
  if ViewIsDisplayRect(m_DragView) = False then Exit;
  DrawAlphaView(m_DragView,clblack,100);
end;

procedure TTFTabletop.DrawFixedCells;
{功能:绘制固定列}
var
  i,j,X,Y : Integer;
  strText : WideString;
  FixedRect : TRect;
  nTextWidth : Integer;
  nTextHeight : Integer;
begin

  m_CanvasCenter.Canvas.Font.Color := clWhite;
  m_CanvasCenter.Canvas.Font.Size := 14;
  m_CanvasCenter.Canvas.Font.Style := [fsBold];
  m_CanvasCenter.Canvas.Font.Name := '宋体';

  for I := 0 to m_FixedCellList.Count - 1 do
  begin

    FixedRect.Left := 0 ;
    FixedRect.Top := m_FixedCellList.Items[i].Row * m_nRowHeight + FIXEDHEIGHT ;
    FixedRect.Right := FixedRect.Left + FIXEDWIDTH;
    FixedRect.Bottom := FixedRect.Top + m_nRowHeight;

    FixedRect.Left := FixedRect.Left + 2;
    FixedRect.Top := FixedRect.Top + 2;
    FixedRect.Right := FixedRect.Right - 2;
    FixedRect.Bottom := FixedRect.Bottom - 2;
    CalcScrollBarRect(FixedRect);

    m_CanvasCenter.Canvas.Brush.Color := $002E1614;
    m_CanvasCenter.Canvas.FillRect(FixedRect);
    m_CanvasCenter.Canvas.Pen.Color := $00291413;
    m_CanvasCenter.Canvas.FrameRect(FixedRect);

    strText := m_FixedCellList.Items[i].Text;
    if strText = '' then continue;
    nTextHeight := m_CanvasCenter.Canvas.TextHeight('宋');
    
    X := FixedRect.Left + ((FixedRect.Right - FixedRect.Left) -
        m_CanvasCenter.Canvas.TextWidth('宋')) div 2;

    Y := FixedRect.Top + ((FixedRect.Bottom - FixedRect.Top) -
        (nTextHeight * length(strText))) div 2;

    for j := 1 to LengTh(strText) do
    begin
      m_CanvasCenter.Canvas.TextOut(X,Y,strText[j]);
      Y := Y + nTextHeight + 2;
    end;
  end;
  m_CanvasCenter.Canvas.Brush.Style := bsClear;
  //绘制序号
  m_CanvasCenter.Canvas.Font.Size := 9;
  for I := 0 to m_nColCount - 1 do
  begin
    FixedRect.Left := i * m_nColWidth + FIXEDWIDTH;
    FixedRect.Top :=  0;
    FixedRect.Right := FixedRect.Left + m_nColWidth;
    FixedRect.Bottom := FixedRect.Top + FIXEDHEIGHT;

    CalcScrollBarRect(FixedRect);

    strText := IntToStr(i+1);
    nTextHeight := m_CanvasCenter.Canvas.TextHeight(strText);
    nTextWidth := m_CanvasCenter.Canvas.TextWidth(strText);
    X := FixedRect.Left + ((FixedRect.Right - FixedRect.Left) - nTextWidth) div 2;
    Y := FixedRect.Top + ((FixedRect.Bottom - FixedRect.Top) - nTextHeight) div 2;    
    m_CanvasCenter.Canvas.TextOut(X,Y,strText);
  end;

end;

procedure TTFTabletop.DrawGrid;
{功能:绘制表格背景}
var
  i : Integer;
  X,Y : Integer;
  nGridWidth, nGridHeight: integer;
begin
  if (m_nRowCount = 0) or (m_nColCount = 0) then exit;

  X := FIXEDWIDTH - HorzScrollBar.Position;
  Y := FIXEDHEIGHT - VertScrollBar.Position;
  nGridWidth := X + m_nColWidth*m_nColCount;
  nGridHeight := Y + m_nRowHeight*m_nRowCount;
  m_CanvasCenter.Canvas.Pen.Color := m_nGridLineColor;

  for I := 0 to m_nRowCount do
  begin
    m_CanvasCenter.Canvas.MoveTo(0,Y-1);
    m_CanvasCenter.Canvas.LineTo(nGridWidth,Y-1); //liulin del m_CanvasCenter.Canvas.LineTo(m_CanvasCenter.Width,Y-1);
    Y := Y + m_nRowHeight;
  end;
  for I := 0 to m_nColCount do
  begin
    m_CanvasCenter.Canvas.MoveTo(X-1,0);
    m_CanvasCenter.Canvas.LineTo(X-1,nGridHeight); //liulin del m_CanvasCenter.Canvas.LineTo(X-1,m_CanvasCenter.Height);
    X := X + m_nColWidth;  
  end;
end;



function TTFTabletop.DrawView(View: TView):Boolean;
{功能:绘制VIEW}
var
  tmpBitmap : TBitmap;
begin
  Result := False;
  if VertScrollBar.Range < View.GetRect.Bottom then
  begin
    VertScrollBar.Range :=
        View.GetRect.Bottom + View.Margins.Bottom +Padding.Bottom;
  end;
  //只有View在显示区域内，才会绘制
  if ViewIsDisplayRect(View) = False then
  begin
    Exit;
  end;

  Result := True;
  //初始化画布
  tmpBitmap := TBitmap.Create;
  try
    InitViewBitmap(View,tmpBitmap);
    {调用View由自身绘制内容}
    View.getBitmap(tmpBitmap);
    {将View输出的内容绘制上来,下面执行了2次绘制,是因为一个是直接向屏幕绘制，
    一个是绘制到Bitmap这样当界面刷新的时候,就不会空了}
    //如果View在屏幕中,那么就直接画出来，到达马上出来的效果
    //如果View是一个选择状态,那么绘制选择效果

    m_CanvasCenter.Canvas.Draw(View.Left-HorzScrollBar.Position,
        View.Top-VertScrollBar.Position,tmpBitmap);

  finally
    tmpBitmap.Free;
  end;
end;

procedure TTFTabletop.EndUpdate;
begin
  m_bIsUpdate := False;
end;

procedure TTFTabletop.FillGridRect;
{功能:根据表格设置尺寸}
begin
  if m_LayoutType = ltGrid then
  begin
    HorzScrollBar.Range := FIXEDWIDTH + m_nColCount * m_nColWidth;
    VertScrollBar.Range := FIXEDHEIGHT + m_nRowCount * m_nRowHeight;
  end;
end;

function TTFTabletop.FindView(X, Y: Integer): TView;
{功能:根据坐标,获得View}
begin
  Result := m_ViewList.FindView(HorzScrollBar.Position + X,
        VertScrollBar.Position + Y,atMouse);
end;

function TTFTabletop.GetView(Index: Integer): TView;
begin
  Result := m_ViewList.Items[Index];
end;

function TTFTabletop.GetViewCount: Integer;
{功能:获得视图总数}
begin
  Result := m_ViewList.Count;
end;

procedure TTFTabletop.InitViewBitmap(View: TView;viewBitmap:TBitmap);
begin
  //将View绘制到画布中
  viewBitmap.Width := View.Width;
  viewBitmap.Height := View.Height;
  {因为目前背景只支持颜色,并且不支持多个View互相覆盖的功能,
  所以viewBitmap只用颜色重新刷一下就可以了}
  viewBitmap.Canvas.Brush.Color := Color;  
  viewBitmap.Canvas.FillRect(viewBitmap.Canvas.ClipRect);
end;

procedure TTFTabletop.LimitDragRange(var ScreenX, ScreenY: Integer);
var
  ClientPt,ScreenPt : TPoint;
begin
  ClientPt.X := Left;
  ClientPt.Y := Top;
  ScreenPt := Parent.ClientToScreen(ClientPt);
  
  if ScreenX < ScreenPt.X then
  begin
    ScreenX := ScreenPt.X;
  end;

  if (ScreenY + m_frmTabletopDrag.Height) > (ScreenPt.Y + height) then
  begin
    ScreenY :=  (ScreenPt.Y + height) - m_frmTabletopDrag.Height;
    //打开向下移动滚动条
    m_tmrAutoMoveToUpDown.Tag := Ord(akDown);
    m_tmrAutoMoveToUpDown.Enabled := True;
  end
  else
  begin
    //关闭向下移动滚动条
    if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akDown  then
      m_tmrAutoMoveToUpDown.Enabled := False;
  end;

  if ScreenY < ScreenPt.Y then
  begin
    ScreenY := ScreenPt.Y;
    //打开向上移动滚动条
    m_tmrAutoMoveToUpDown.Tag := Ord(akUp);
    m_tmrAutoMoveToUpDown.Enabled := True;
  end
  else
  begin
    //关闭向上移动滚动条
    if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akUp  then
      m_tmrAutoMoveToUpDown.Enabled := False;
  end;  

  if (ScreenX + m_frmTabletopDrag.Width) > (ScreenPt.X + width) then
  begin
    ScreenX :=  (ScreenPt.X + width) - m_frmTabletopDrag.Width;
    //打开向右移动滚动条
    m_tmrAutoMoveToLeftRight.Tag := Ord(akRight);
    m_tmrAutoMoveToLeftRight.Enabled := True;
  end
  else
  begin
    if TArrowKey(m_tmrAutoMoveToLeftRight.Tag) = akRight  then
      m_tmrAutoMoveToLeftRight.Enabled := False;
  end;


  if ScreenX <= ScreenPt.X then
  begin
    ScreenX := ScreenPt.X;
    //打开向左移动滚动条
    m_tmrAutoMoveToLeftRight.Tag := Ord(akLeft);
    m_tmrAutoMoveToLeftRight.Enabled := True;
  end
  else
  begin
    //关闭向左移动滚动条
    if TArrowKey(m_tmrAutoMoveToLeftRight.Tag) = akLeft  then
      m_tmrAutoMoveToLeftRight.Enabled := False;
  end;


end;

function TTFTabletop.GetFixedCellText(nRow, nCol: Integer): String;
{功能:获得固定单元}
var
  i : Integer;
begin
  Result := '';
  for I := 0 to m_FixedCellList.Count - 1 do
  begin
    if (m_FixedCellList.Items[i].Row = nRow) And
        (m_FixedCellList.Items[i].Col = nCol) then
    begin
      Result := m_FixedCellList.Items[i].Text;
      Break;
    end;
  end;
end;

function TTFTabletop.GetRowMaxHeightView(nRow: Integer): TView;
{功能:获得指定行的高度最高的View}
var
  i : Integer;
  nMaxViewPosiation : Integer;
  nHeight1,nHeight2 : Integer;
begin

  nMaxViewPosiation := -1;
  Result := nil;
  for I := 0 to m_ViewList.Count - 1 do
  begin
    if m_ViewList.Items[i].Row <> nRow then continue;
    
    if nMaxViewPosiation = -1 then
      nMaxViewPosiation := i
    else
    begin
      nHeight1 := m_ViewList.Items[i].Height +
          m_ViewList.Items[i].Margins.Top +
          m_ViewList.Items[i].Margins.Bottom;

      nHeight2 := m_ViewList.Items[nMaxViewPosiation].Height +
          m_ViewList.Items[nMaxViewPosiation].Margins.Top +
          m_ViewList.Items[nMaxViewPosiation].Margins.Bottom;

      if nHeight1 > nHeight2 then
      begin
        nMaxViewPosiation := i;
      end;
    end;
  end;
  if nMaxViewPosiation <> -1 then
  begin
    Result := m_ViewList.Items[nMaxViewPosiation];
  end;


end;


function TTFTabletop.GetSelectedView: TView;
{功能:获得当前选择的View}
begin
  Result := m_ViewList.FindSelectedView();
end;

procedure TTFTabletop.CalcScrollBarRect(var Rect: TRect);
{功能:根据滚动条计算区域}
begin
  Rect.Left := Rect.Left - HorzScrollBar.Position;
  Rect.Right := Rect.Right - HorzScrollBar.Position;
  Rect.Top := Rect.Top - VertScrollBar.Position;
  Rect.Bottom := Rect.Bottom - VertScrollBar.Position;
end;

procedure TTFTabletop.CenterMouseDown(Sender: TObject;
    Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
  View : TView;
begin
  SetFocus;
  View := m_ViewList.FindView(X + self.HorzScrollBar.Position,
      y+VertScrollBar.Position,atSelected);
  if View <> nil then
  begin
    //先将所有的Selected设置为False
    if View.Selected then    
      SetViewsSelected(False,View)
    else
      SetViewsSelected(False,nil);
      
    View.Selected := True;
  end;
  //查找View,设置为Select
  if Button = mbLeft then
  begin
    m_DragStartPoint.X := X;
    m_DragStartPoint.Y := Y;
    m_bIsDown := True;
  end;

end;

procedure TTFTabletop.CenterMouseMove(Sender: TObject;Shift: TShiftState; X, Y: Integer);
var
  View : TView;
begin
  if m_bIsDown then
  begin
    if (abs(x - m_DragStartPoint.X) >= 3) or (abs(y - m_DragStartPoint.Y) >= 3) then
    begin
      if m_bIsDrag = false then
      begin
        m_bIsDrag := True;
        //根据坐标,获得View
        View := m_ViewList.FindView(X + HorzScrollBar.Position,
            Y+VertScrollBar.Position,atDragOver);
        if View <> nil then
        begin
          //打开拖拽窗口
          DragView(View,X,Y);
        end;
      end;
    end;
  end;
end;

procedure TTFTabletop.CenterMouseUp(Sender: TObject;Button: TMouseButton;
    Shift: TShiftState; X,Y: Integer);
var
  winRect : TRect;
begin
  m_bIsDown := False;
  m_bIsDrag := False;
  if m_frmTabletopDrag <> nil then
  begin
    winRect.Left := m_frmTabletopDrag.Left;
    winRect.Top := m_frmTabletopDrag.Top;
    winRect.Right := m_frmTabletopDrag.Left + m_frmTabletopDrag.Width;
    winRect.Bottom := m_frmTabletopDrag.Top + m_frmTabletopDrag.Height;
    //因为拖拽的太快，窗口会跟不上,所以如果在这里鼠标和拖拽窗口不一致，那么则FREE
    if PtInRect(winRect,mouse.CursorPos) = false then
    begin
      //这里只close即可，在该窗口的onclose中实现自动free
      m_frmTabletopDrag.Close;
    end;
  end;
end;


procedure TTFTabletop.ClearView;
{功能:清理视图}
begin
  m_ViewList.Clear;
  ReComposition;
end;

procedure TTFTabletop.OnDragClose(Sender: TObject; var Action: TCloseAction);
begin
  ReductionSuspendedView();
//  //重新绘制m_DragView,让拖拽效果还原
  if m_DragView <> nil then
    m_DragView.ViewChange;

  if m_frmTabletopDrag.bIsCancel = false then
  begin
    ViewDragDrop(TForm(Sender).Left,TForm(Sender).Top);
  end;
  m_SuspendedView := nil;
  m_frmTabletopDrag := nil;
  m_tmrAutoMoveToUpDown.Enabled := False;
  m_tmrAutoMoveToLeftRight.Enabled := False;
  m_DragView := nil;
  m_bIsDrag := False;
  Action := caFree;    
  Repaint();
end;

procedure TTFTabletop.OnDragMoveing(var ScreenX, ScreenY: Integer; var bIsMove: Boolean);
 {功能:拖拽窗口移动事件}
begin
  if m_frmTabletopDrag = nil then Exit;
  //限制移动反馈
  LimitDragRange(ScreenX,ScreenY);
  //显示拖拽对应的效果
  ShowDragFocusEffect(ScreenX,ScreenY);
end;

procedure TTFTabletop.OnNeedReComposition(View: TView);
begin
  if m_bIsUpdate then Exit;
  ReComposition();
end;

procedure TTFTabletop.OnPaint(Sender: TObject);
var
  i : Integer;
begin
  if (m_LayoutType = ltGrid) then
  begin
    //如果是表格样式,则先绘制表格背景
    DrawGrid();
    //然后绘制固定列
    DrawFixedCells();
  end;
  for I := 0 to m_ViewList.Count - 1 do
  begin
    DrawView(m_ViewList.Items[i]);
  end;
  if m_SuspendedView <> nil then
  begin
    DrawDragFocusEffect();
  end;
  DrawDragView();
end;

procedure TTFTabletop.OntmrAutoMoveToLeftRight(Sender: TObject);
{功能:自动向左右移动滚动条定时器事件,tmrAutoMoveToUpDown为0表示向左，1为向右}
var
  n : Integer;
begin
  if TArrowKey(m_tmrAutoMoveToLeftRight.Tag) = akRight then
  begin
    //向右滚动
    HorzScrollBar.Position := HorzScrollBar.Position  + 20;
    if m_frmTabletopDrag = nil then Exit;
  end
  else
  begin
    n := HorzScrollBar.Position  - 20;
    if n < 0 then
      n := 0;
    //向左滚动
    HorzScrollBar.Position := n;
  end;
  m_CanvasCenter.Left := 0;

end;

procedure TTFTabletop.OntmrAutoMoveToUpDown(Sender: TObject);
{功能:自动向下移动滚动条定时器事件}
var
  n : Integer;
begin
  if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akDown then
  begin
    //向下滚动
    VertScrollBar.Position := VertScrollBar.Position  + 20;
    if m_frmTabletopDrag = nil then Exit;
  end
  else
  begin
    n := VertScrollBar.Position  - 20;
    if n < 0 then
      n := 0;
    //向上滚动
    VertScrollBar.Position := n;
  end;
  m_CanvasCenter.Top := 0;
end;

procedure TTFTabletop.OnViewChange(View: TView);
begin
  if m_bIsUpdate then exit;
  DrawView(View);
end;

procedure TTFTabletop.ReCanvas;
begin
  m_CanvasCenter.Top := 0;
end;

procedure TTFTabletop.ReComposition;
{功能:重新绘制}
var
  i : Integer;
begin
  VertScrollBar.Position := 0;
  for I := 0 to m_ViewList.Count - 1 do
  begin
    m_ViewList.Items[i].Left := 0;
    m_ViewList.Items[i].Top := 0;
  end;
  //VertScrollBar.Range := 0;
  for I := 0 to m_ViewList.Count - 1 do
  begin
    case m_LayoutType of
      ltVertical :
        begin
          SetVerticalViewPoint(i);
        end;
      ltGrid :
        begin
          SetGridViewPoint(i);
        end;
    end;

  end;
  if m_ViewList.Count > 0 then
  begin
    VertScrollBar.Range := m_ViewList.Items[m_ViewList.Count-1].GetRect.Bottom+
        m_ViewList.Items[m_ViewList.Count-1].Margins.Bottom;
  end
  else
     VertScrollBar.Range := 0;

  Repaint();
end;

procedure TTFTabletop.ReductionSuspendedView;
{功能:还原SuspendedView}
begin
  if  (m_SuspendedView <> nil) then
  begin
    m_CanvasCenter.Canvas.Draw(m_SuspendedView.ClientOrigin.X - HorzScrollBar.Position,
        m_SuspendedView.ClientOrigin.Y - VertScrollBar.Position,m_SuspendedOldBitmap);
  end;
end;

procedure TTFTabletop.Resize;
begin
  inherited;
  if m_LayoutType = ltVertical then
  begin
    ReComposition();
  end;
  m_CanvasCenter.Width := Width - 24;
  if m_LayoutType = ltGrid then m_CanvasCenter.Width := Width; //liulin add
  m_CanvasCenter.Height := Height;
  m_CanvasCenter.Top := 0;
  m_CanvasCenter.Left := 0;  

end;

procedure TTFTabletop.SetView(Index: Integer; View: TView);
begin
  m_ViewList.Items[Index] := View;
end;

procedure TTFTabletop.SetViewsSelected(Value: Boolean;ignored: TView);
{功能:将全部的View去掉Selected状态}
begin
  m_ViewList.SetItemsSelected(Value,ignored);
end;


procedure TTFTabletop.SetColCount(nColCount: Integer);
begin
  m_nColCount := nColCount;
  FillGridRect();
  Repaint;

end;

procedure TTFTabletop.SetColWidth(nWidth: Integer);
begin
  m_nColWidth := nWidth;
  FillGridRect();

  ReComposition;
end;

procedure TTFTabletop.SetDragFocusEffectImage(Value: TPngObject);
begin
  if Value = nil then
  begin
     m_DragFocusEffect.Free;
     m_DragFocusEffect := TPNGObject.Create;
  end
  else
    m_DragFocusEffect.Assign(Value);

  with m_DragFocusEffect do
  begin
    if Header.ColorType in [COLOR_RGB, COLOR_RGBALPHA, COLOR_PALETTE] then
     Chunks.RemoveChunk(Chunks.ItemFromClass(TChunkgAMA));
  end;
end;

procedure TTFTabletop.SetFixedCellText(nRow, nCol: Integer; const strText: String);
var
  i : Integer;
  nIndex : Integer;
  FixedCell : TFixedCell;
begin
  nIndex := -1;
  for I := 0 to m_FixedCellList.Count - 1 do
  begin
    if (m_FixedCellList.Items[i].Row = nRow) And
        (m_FixedCellList.Items[i].Col = nCol) then
    begin
      nIndex := i;
      Break;
    end;
  end;

  if nIndex = -1 then
  begin
    FixedCell := TFixedCell.Create;
    FixedCell.Row := nRow;
    FixedCell.Col := nCol;
    m_FixedCellList.Add(FixedCell);
  end
  else
  begin
    FixedCell := m_FixedCellList.Items[nIndex];
  end;
  FixedCell.Text := strText;
  Repaint;
end;

procedure TTFTabletop.SetGridLineColor(nColor: TColor);
begin
  m_nGridLineColor := nColor;
  Repaint;
end;

procedure TTFTabletop.SetGridViewPoint(nViewIndex: Integer);
{功能:设置区域,表格类型布局}
var
  View : TView;
begin
  if nViewIndex >= m_ViewList.Count then Exit;
  View := m_ViewList.Items[nViewIndex];
  View.Left := View.Col * m_nColWidth + FIXEDWIDTH;
  if m_nColWidth  > View.Width then
  begin
    View.Left := View.Left + (m_nColWidth - View.Width) div 2;
  end;
  View.Top := View.Row * m_nRowHeight + FIXEDHEIGHT;
  if m_nRowHeight > View.Height then
  begin
    View.Top := View.Top +  (m_nRowHeight - View.Height) div 2;
  end;
  
end;

procedure TTFTabletop.SetLayoutType(Value: TLayoutType);
begin
  m_LayoutType := Value;
  if m_LayoutType = ltVertical then
  begin
    m_CanvasCenter.Width := Width;
    ReComposition();
  end
  else
  begin
    FillGridRect();
  end;

end;

procedure TTFTabletop.SetRowCount(nRowCount: Integer);
begin
  m_nRowCount := nRowCount;
  FillGridRect();
  Repaint();
end;

procedure TTFTabletop.SetRowHeight(nHeight: Integer);
begin
  m_nRowHeight := nHeight;
  FillGridRect();

  ReComposition;
end;

procedure TTFTabletop.SetVerticalViewPoint(nViewIndex: Integer);
{功能:设置区域,传递View在List中的索引}
var
  PrevView,tmpView: TView;
  View : TView;
  nWidthCount : Integer;
begin
  if nViewIndex >= m_ViewList.Count then Exit;
  View := m_ViewList.Items[nViewIndex];
  View.BeginUpdate;
  try
    if nViewIndex = 0 then
    begin
      View.Left := Padding.Left + View.Margins.Left;
      View.Top := Padding.Top + View.Margins.Top;
      View.Row := 0;
      View.Col := 0;
      Exit;
    end;
    PrevView := m_ViewList.Items[nViewIndex-1];
    nWidthCount := PrevView.GetRect.Right + View.Width;
    if (nWidthCount + Padding.Left + Padding.Right) >  Width then
    begin
      //获得本行最高的View
      tmpView := GetRowMaxHeightView(PrevView.Row);
      //换行
      View.Left := Padding.Left + View.Margins.Left;
      View.Top := tmpView.GetRect().Bottom +
          tmpView.Margins.Bottom + Padding.Top + View.Margins.Top;
      View.Row := PrevView.Row + 1;
      View.Col := 0;
    end
    else
    begin
      View.Row := PrevView.Row;
      View.Col := PrevView.Col + 1;
      View.Top := PrevView.Top;
      View.Left := View.Margins.Left +
          m_ViewList.Items[nViewIndex-1].GetRect.Right +
          m_ViewList.Items[nViewIndex-1].Margins.Left;

    end;
  finally
    View.EndUpdate;
  end;


end;

procedure TTFTabletop.ShowDragFocusEffect(ScreenX, ScreenY: Integer);
{功能:显示拖拽反馈}
var
  ClientPt,ScreenPt : TPoint;
  View : TView;
begin
  ScreenPt.X := ScreenX;
  ScreenPt.Y := ScreenY;
  ClientPt := m_CanvasCenter.ScreenToClient(ScreenPt);

  View := m_ViewList.FindView(ClientPt.X + HorzScrollBar.Position,
      ClientPt.Y + VertScrollBar.Position,atDragDrop);



  //下面的这段处理，是尽量将目标View通过Parent转成和自己一样的类,这样,当大View,
  //移动到另外一个大View的子View上面，会先返回大View
  View := TransformView(View);
  if View = m_DragView then Exit;
  if View = m_SuspendedView then Exit;

  //如果得到当前的View,并且拖拽的View不等于nil,就比较一下是否能放到上面
  if (View <> nil) And (m_DragView <> nil) then
  begin
    if View.CheckViewDrop(m_DragView) = False then
    begin
      ReductionSuspendedView();
      m_SuspendedView := nil;
      Exit;
    end;
  end;
  
  ReductionSuspendedView();

  m_SuspendedView := View;
  if (View <> nil)  then
  begin
    BackupSuspendedView(m_SuspendedView);
    //绘制拖拽焦点
    DrawDragFocusEffect();
    //通知VIEW有东西放上来了
    View.ViewDrag(m_DragView);
  end;
end;

function TTFTabletop.TransformView(View: TView):TView;
{功能:转换View,让他尽量和拖拽的View的类保持一致}
var
  viewParent : TView;
begin
  Result := View;
  if (m_DragView <> nil) then
  begin
    viewParent := View;
    
    while viewParent <> nil do
    begin
      if (viewParent.ClassName = m_DragView.ClassName) then
      begin
        Result := viewParent;
        Break;
      end;
      viewParent := viewParent.Parent;
    end;
  end;
end;

procedure TTFTabletop.ViewDragDrop(ScreenX, ScreenY: Integer);
{功能:拖拽放下}
var
  ClientPt,ScreenPt : TPoint;
  View : TView;
begin
  ScreenPt.X := ScreenX;
  ScreenPt.Y := ScreenY;
  ClientPt := m_CanvasCenter.ScreenToClient(ScreenPt);
  View := m_ViewList.FindView(ClientPt.X + HorzScrollBar.Position,
      ClientPt.Y+VertScrollBar.Position,atDragDrop);

  //下面的这段处理，是尽量将目标View通过Parent转成和自己一样的类,这样,当大View,
  //移动到另外一个大View的子View上面，会先返回大View
  View := TransformView(View);
  if View = m_DragView then Exit;
  

  if (View <> nil) And (m_DragView <> nil) then
  begin
    //在这里以后可以升级优化，来针对某个View是否相应特定的View
    if View.CheckViewDrop(m_DragView) = False then
    begin
      Exit;
    end;
    //放下通知
    View.ViewDragDrop(m_DragView);
  end;

end;

function TTFTabletop.ViewIsDisplayRect(View: TView): Boolean;
{功能:检查View是否在当前显示区域}
var
  VRect : TRect;
begin
  Result := False;

  VRect := View.GetRect;
  VRect.Left := VRect.Left - HorzScrollBar.Position;
  VRect.Top := VRect.Top - VertScrollBar.Position;
  VRect.Right := VRect.Right - HorzScrollBar.Position;
  VRect.Bottom := VRect.Bottom - VertScrollBar.Position;

  if (((VRect.Left > 0) And (VRect.Left < Width)) or
  ((VRect.Right > 0) And (VRect.Right < Width))) And
  (((VRect.Top > 0) And (VRect.Top < Height)) or
  ((VRect.Bottom > 0) And (VRect.Bottom < Height))) then
  begin
    Result := True;
  end;

end;

procedure TTFTabletop.WMHScroll(var Message: TWMHScroll);
begin
  inherited;
  m_CanvasCenter.Left := 0;
end;

procedure TTFTabletop.WMLButtonUp(var Message: TWMLButtonUp);
var
  View : TView;
begin
  View := m_ViewList.FindView(Message.Pos.x + HorzScrollBar.Position,
      Message.Pos.y + VertScrollBar.Position,atClick);
  if View <> nil then
  begin
    if csCaptureMouse in ControlStyle then MouseCapture := False;
    if csClicked in ControlState then
    begin
      ControlState := ControlState - [csClicked];
      View.click;
    end;
    if not (csNoStdEvents in ControlStyle) then
    begin
      with Message do
      begin
        CenterMouseUp(self,mbLeft, KeysToShiftState(Keys), XPos, YPos);
      end;
    end;
  end
  else
  begin
    inherited;
  end;
end;

procedure TTFTabletop.WMVScroll(var Message: TWMVScroll);
begin
  inherited;
  m_CanvasCenter.Top := 0;
end;

{ TCanvasCenter }

constructor TCanvasCenter.Create(AOwner: TComponent);
begin
  inherited;
  m_BitmapCanvas := TBitmap.Create;
end;

destructor TCanvasCenter.Destroy;
begin
  m_BitmapCanvas.Free;
  inherited;
end;

function TCanvasCenter.GetBitmapCanvas: TCanvas;
begin
  Result := m_BitmapCanvas.Canvas;
end;

procedure TCanvasCenter.Paint;
begin
  inherited;
  if Assigned(m_OnPaint) then
    m_OnPaint(self);
end;

procedure TCanvasCenter.Resize;
begin
  inherited;
  m_BitmapCanvas.Width := Width;
  m_BitmapCanvas.Height := Height;
end;

{ TFixedCellList }

function TFixedCellList.Add(FixedCell: TFixedCell): Integer;
begin
  Result := inherited Add(FixedCell);
end;

function TFixedCellList.GetItem(Index: Integer): TFixedCell;
begin
  Result := TFixedCell(inherited GetItem(Index));
end;

procedure TFixedCellList.SetItem(Index: Integer; FixedCell: TFixedCell);
begin
  inherited SetItem(Index,FixedCell);
end;

end.

