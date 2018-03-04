unit uTFTabletop;

interface
uses Windows,Graphics,Forms,Classes,Contnrs,Controls,Messages,SysUtils ,
    ExtCtrls,ufrmTabletopDrag,uTFSystem,Consts,pngimage;


const
  {�̶��п��}
  FIXEDWIDTH = 60;
  {�̶��и߶�}
  FIXEDHEIGHT = 40;

type
  TViewList = class;
  TView = class;



  {TActionType ��������}
  TActionType = (atMouse{������},atClick{���},atDragOver{����},
      atDragDrop{����},atSelected{ѡ��});
  {TLayoutType ��������}
  TLayoutType = (ltVertical{��ֱ����,������ˮƽ������},ltGrid{��񲼾�});
  //�������ͼ���
  TActionTypeSet = set of TActionType;
  {TOnViewChange ��ͼ���ݱ仯֪ͨ�¼�}
  TOnViewChange = procedure(View : TView)of Object;
  {TOnGetBackBitmap ��ȡ�����¼�֪ͨ}
  TOnGetBackgroundBitmap = procedure(View:TView;Bitmap:TBitmap)of Object;
  {TOnNeedReComposition ��Ҫ���¼���λ���¼�֪ͨ}
  TOnNeedReComposition = procedure(View:TView) of Object;


  /////////////////////////////////////////////////////////////////////////////
  /// ����:TView
  /// ˵��:��ʾ����
  ///  ��Ҫע�����,View��������View��Ҫ���뵽Childs��,�����������Ϣ��Click��Ϣ��
  ///  �Ż��Զ�֪ͨ����View
  /////////////////////////////////////////////////////////////////////////////
  TView = class
  public
    constructor Create(vParent:TView = nil);virtual;
    destructor Destroy();override;
  public
    {֧�ֵ���Ϊ}
    ActionTypeSet : TActionTypeSet;
  public
    {����:��������}
    function GetRect():TRect;
    {����:���View����ʾ����,backBitmap�����洫�ݹ���ʹ��,
        ��������viewBitmap����}
    {����:������������}
    function GetOuterRect():TRect;

    procedure getBitmap(viewBitmap:TBitmap);virtual;
    {�����ק��Ҫ��Bitmap,Ĭ�ϻ���ʹ��getBitmap,���Լ̳��޸�}
    procedure getDragBitmap(viewBitmap:TBitmap);virtual;
    {����:�ͻ�����ת��Ļ����}
    function ClientToScreen(Point: TPoint):TPoint;
    {����:��ʼ��������}
    procedure BeginUpdate();
    {����:������������}
    procedure EndUpdate();
    {����:��¡}
    procedure Clone(view:TView);virtual;
  protected
    m_nLeft : Integer;
    m_nTop : Integer;
    m_nWidth : Integer;
    m_nHeight : Integer;
    //�Ƿ�������ק,Ĭ����True
    m_bAllowDrag : Boolean;
    //�к�
    m_nRow : Integer;
    //�к�
    m_nCol : Integer;
    //��߾�
    m_Margins : TMargins;

    {����ͼ}
    m_Childs : TViewList;
    {�����ݷ����仯����Ҫ���»��Ƶ�ʱ�����}
    m_OnViewChange : TOnViewChange;
    {��ȡ�����¼�֪ͨ,��View���ݱ仯����Ҫ���»���ʱ����}
    m_OnGetBackgroundBitmap : TOnGetBackgroundBitmap;
    {��View}
    m_Parent : TView;
    {�Ƿ����ڸ���}
    m_bIsUpdate : Boolean;
    {��Ҫ���¼���λ���¼�֪ͨ}
    m_OnNeedReComposition : TOnNeedReComposition;
    {�Ƿ�ѡ��}
    m_bSelected : Boolean;
        {�Ƿ�˫��ѡ��}
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
    {����:����View�����仯�Ļ�,��Ҫ�Լ����»�����View}
    procedure OnChildViewChange(View: TView);virtual;
    {����:����¼�}
    procedure Click();
        {����:˫��}
    procedure DblClick();virtual;
    {����:���ݱ䶯}
    procedure ViewChange();
    {����:����Ƿ��������}
    function CheckViewDrop(View:TView):Boolean;virtual;
    {����:��View��������,��û���£����������������ʾһЩ��Ϣ�ȵ�}
    procedure ViewDrag(View:TView);virtual;
    {����:��View����}
    procedure ViewDragDrop(View:TView);virtual;
    {����:��View����ѡ��Ч��}
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
  /// ����:TViewList
  /// ˵��:��ʾ�����б�
  /////////////////////////////////////////////////////////////////////////////
  TViewList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TView;
    procedure SetItem(Index: Integer; View: TView);
  protected
    {��������Ͳ������ͣ�����View}
    function FindView(X,Y:Integer;ActionType:TActionType):TView;
    {����:��õ�ǰѡ���View}
    function FindSelectedView():TView;
    {����:����Selected״̬}
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
    {λͼ������Ҳ����ʵ����ʾ������}
    m_BitmapCanvas : TBitmap;
    m_OnPaint: TNotifyEvent;
  protected
    procedure Paint; override;
    procedure Resize; override;
    {����:���λͼ����}
    function GetBitmapCanvas():TCanvas;
  public
    property Canvas;
    property BitmapCanvas:TCanvas read GetBitmapCanvas;
  end;

  /////////////////////////////////////////////////////////////////////////////
  /// ����:TFixedCol
  /// ˵��:�̶���Ԫ��Ϣ
  /////////////////////////////////////////////////////////////////////////////
  TFixedCell = class
  public
    //������
    Row : Integer;
    //������
    Col : Integer;
    //����
    Text : String;
  end;

  /////////////////////////////////////////////////////////////////////////////
  /// ����:TFixedCellList
  /// ˵��:�̶���Ԫ��Ϣ�б�
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
  /// ����:TTFTabletop
  /// ˵��:������ʾ��
  /////////////////////////////////////////////////////////////////////////////
  TTFTabletop = class(TScrollBox)
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy();override;
  public
    {����:�����ͼ}
    procedure AddView(View:TView);
    {����:ɾ����ͼ}
    procedure DeleteView(View:TView);overload;
    {����:ɾ����ͼ}
    procedure DeleteView(nIndex:Integer);overload;
    {����:������ͼ}
    procedure ExchangeView(DesView, OptView:TView);overload;
    procedure ExchangeView(nDesIndex, nOptIndex:Integer);overload;  
    {����:����һ������ͼ}
    procedure InsertNewViewBefore(DesView, NewView:TView);overload;
    procedure InsertNewViewBefore(nDesIndex:Integer; NewView:TView);overload;   
    procedure InsertNewViewAfter(DesView, NewView:TView);overload;
    procedure InsertNewViewAfter(nDesIndex:Integer; NewView:TView);overload;
    {����:һ���Ѵ�����ͼ���뵽��һ���Ѵ�����ͼ��ǰ������}
    procedure InsertExistViewBefore(DesView, OptView:TView);overload;
    procedure InsertExistViewBefore(nDesIndex, nOptIndex:Integer);overload;
    procedure InsertExistViewAfter(DesView, OptView:TView);overload;
    procedure InsertExistViewAfter(nDesIndex, nOptIndex:Integer);overload;

    {����:��������,���View}
    function FindView(X,Y:Integer):TView;
    {����:��õ�ǰѡ���View}
    function GetSelectedView():TView;
    {����:������ͼ}
    procedure ClearView();
    {����:�����ͼ����}
    function GetViewCount():Integer;
    {����:���»���}
    procedure ReComposition();
    {����:���ò�������}
    procedure SetLayoutType(Value:TLayoutType);
    {����:��ȡView}
    function GetView(Index:Integer):TView;
    {����:����View}
    procedure SetView(Index:Integer;View:TView);
    {����:��ʼ��������}
    procedure BeginUpdate();
    {����:������������}
    procedure EndUpdate();
    {����:ˢ�»���}
    procedure ReCanvas();
  protected
    {��ק����}
    m_frmTabletopDrag : TfrmTabletopDrag;
    {�̶�����Ϣ}
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
    //�Ƿ����ڸ���
    m_bIsUpdate : Boolean;
    //��ͼ�б�
    m_ViewList : TViewList;
    //��������
    m_LayoutType : TLayoutType;
   //����
    m_CanvasCenter : TCanvasCenter;

    {�Ƿ���}
    m_bIsDown : Boolean;
    {�Ƿ��Ѿ���ק}
    m_bIsDrag : Boolean;
    {�������ƶ���������ʱ��}
    m_tmrAutoMoveToUpDown : TTimer;
    {�������ƶ���������ʱ��}
    m_tmrAutoMoveToLeftRight : TTimer;
    {������}
    m_nRowCount : Integer;
    {������}
    m_nColCount : Integer;
    {�и�}
    m_nRowHeight : Integer;
    {�п�}
    m_nColWidth : Integer;
    {������ɫ}
    m_nGridLineColor : TColor;
    {��ǰ��ק��View}
    m_DragView : TView;
    {��ǰ����View,������View��Ϊnil,��ô���������ϣ���һ�����
        ��ʾ��ק��View��������}
    m_SuspendedView : TView;
    {����View֮ǰ��Bitmap}
    m_SuspendedOldBitmap : TBitmap;
    {��ק��ʽ}
    m_DragFocusEffect : TPngObject;
    {��ק��ʽ��ɫ}
    m_DragFocusEffectColor : TColor;
    {��ק��ʽ��ɫ͸����,0-255,Ĭ��200}
    m_DragFocusEffectColorAPPend : Integer;
  private
    //------------------------�������-----------------------------------
    {����:�����ػ��¼�}
    procedure OnPaint(Sender:TObject);
    {����:����VIEW}
    function DrawView(View:TView):Boolean;
    {����:���Ʊ���ק��View}
    procedure DrawDragView();
    {����:������ק����}
    procedure DrawDragFocusEffect();
    {����:���Ʊ�񱳾�}
    procedure DrawGrid();
    {����:���ƹ̶���}
    procedure DrawFixedCells();
    {����:����SuspendedView}
    procedure BackupSuspendedView(SuspendedView:TView);
    {����:��ԭSuspendedView}
    procedure ReductionSuspendedView();
  private
    //--------------------------������-----------------------------------
    {����:��ʼ��ViewBitmap}
    procedure InitViewBitmap(View:TView;viewBitmap:TBitmap);
    {����:���View�Ƿ��ڵ�ǰ��ʾ����}
    function ViewIsDisplayRect(View:TView):Boolean;
    {����:���ݹ�������������}
    procedure CalcScrollBarRect(var Rect:TRect);
    {����:ת��View,������������ק��View���ౣ��һ��}
    function TransformView(View:TView):TView;
    {����:��VIEW���ư�͸��ͼ��}
    procedure DrawAlphaView(View: TView;Color:TColor;nAPPend:Integer);
  private
    {����:��קview}
    procedure DragView(View:TView;X,Y:Integer);
    {����:��ק����}
    procedure ViewDragDrop(ScreenX,ScreenY:Integer);
    {����:���ָ���еĸ߶���ߵ�View}
    function GetRowMaxHeightView(nRow:Integer):TView;
    {����:��������,����View��List�е�����}
    procedure SetVerticalViewPoint(nViewIndex:Integer);
    {����:��������,������Ͳ���}
    procedure SetGridViewPoint(nViewIndex:Integer);
    {����:�����ƶ����ڷ�Χ}
    procedure LimitDragRange(var ScreenX,ScreenY:Integer);
    {����:��ʾ��ק����}
    procedure ShowDragFocusEffect(ScreenX,ScreenY:Integer);
    {����:���ݱ�����óߴ�}
    procedure FillGridRect();
  private
    //-----------------------------�¼����-------------------------------
    {����:View�仯֪ͨ}
    procedure OnViewChange(View : TView);
    {����:��ק���ڹر��¼�}
    procedure OnDragClose(Sender: TObject; var Action: TCloseAction);
    {����:��ק�����ƶ��¼�}
    procedure OnDragMoveing(var ScreenX,ScreenY:Integer;var bIsMove:Boolean);
    {����:��ͼ��Ҫ���¼���λ���¼�֪ͨ}
    procedure OnNeedReComposition(View:TView);
    {����:�Զ��������ƶ���������ʱ���¼�}
    procedure OntmrAutoMoveToUpDown(Sender:TObject);
    {����:�Զ��������ƶ���������ʱ���¼�}
    procedure OntmrAutoMoveToLeftRight(Sender:TObject);
  private
    //----------------------�����������---------------------------------
    {����:��ù̶���Ԫ}
    function GetFixedCellText(nRow,nCol:Integer):String;
    {����:���ù̶���Ԫ}
    procedure SetFixedCellText(nRow,nCol:Integer;const strText:String);
    procedure SetRowCount(nRowCount:Integer);
    procedure SetColCount(nColCount:Integer);
    procedure SetRowHeight(nHeight:Integer);
    procedure SetColWidth(nWidth:Integer);
    procedure SetGridLineColor(nColor : TColor);
    procedure SetDragFocusEffectImage(Value: TPngObject);    
    {����:��ȫ����Viewȥ��Selected״̬}
    procedure SetViewsSelected(Value:Boolean;ignored: TView = nil);
  public
    //��ͼ�б�
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
{����:����Ƿ��������,Ĭ��������һ�����Ͳ��������}
begin
  Result := False;
  if ClassName <> View.ClassName then Exit;
  Result := True;
end;

procedure TView.Click;
{����:����¼�}
begin

end;


function TView.ClientToScreen(Point: TPoint): TPoint;
{����:�ͻ�����ת��Ļ����}
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
  //Ĭ����ȫ֧��
  ActionTypeSet := [atMouse,atClick,atDragOver,atDragDrop,atSelected];
  m_Margins := TMargins.Create(nil);
  m_nWidth := 50;
  m_nHeight := 50;

end;

procedure TView.DblClick();
{����:˫���¼�}
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
{����:��View����ѡ��Ч��}
begin
  DrawAlphaBackground(ViewBitmap,clBlue,ViewBitmap.Canvas.ClipRect,100);
end;

procedure TView.EndUpdate;
begin
  m_bIsUpdate := False;
end;

procedure TView.getBitmap(viewBitmap: TBitmap);
{����:���View����ʾ����,backBitmap�����洫�ݹ���ʹ��,
  ��������viewBitmap����}
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
{����:������������}
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
{����:��������}
begin
  Result.Left := Left;
  Result.Top := Top;
  Result.Right := Left+Width;
  Result.Bottom := Top + Height;
end;



procedure TView.OnChildViewChange(View: TView);
{����:����View�����仯�Ļ�,��Ҫ�Լ����»�����View}
begin
  //��ʵ����֪ͨ��View������
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
{����:���ݱ䶯}
begin
  //������ڸ����򲻴���
  if m_bIsUpdate then exit;

  if Assigned(m_OnViewChange) then
    m_OnViewChange(self);
end;

procedure TView.ViewDrag(View: TView);
{����:��View��������}
begin

end;

procedure TView.ViewDragDrop(View: TView);
{����:��View����}
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
{��������Ͳ������ͣ�����View}
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
{����:����Selected״̬}
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
{����:����SuspendedView}
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
{����:ɾ����ͼ}
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
  if nDesIndex = nOptIndex then exit;   //ͬһλ�ã�����������
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
  if nDesIndex = nOptIndex then exit;   //ͬһλ�ã�����������
  if nDesIndex = nOptIndex+1 then exit; //�Ѿ��Ǵ�λ���ˣ��������
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
  if nDesIndex = nOptIndex then exit;   //ͬһλ�ã�����������
  if nDesIndex = nOptIndex-1 then exit; //�Ѿ��Ǵ�λ���ˣ��������
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
    //���¹���
    VertScrollBar.Position := VertScrollBar.Position  + 20;
  end
  else
  begin
    //���Ϲ���
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
  //���Ȼ���VIEW������ʽ
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
{����:��VIEW���ư�͸��ͼ��}
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
{����:������ק����}
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
{����:���Ʊ���ק��View}
begin
  if m_DragView = nil then Exit;
  //ֻ��View����ʾ�����ڣ��Ż����
  if ViewIsDisplayRect(m_DragView) = False then Exit;
  DrawAlphaView(m_DragView,clblack,100);
end;

procedure TTFTabletop.DrawFixedCells;
{����:���ƹ̶���}
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
  m_CanvasCenter.Canvas.Font.Name := '����';

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
    nTextHeight := m_CanvasCenter.Canvas.TextHeight('��');
    
    X := FixedRect.Left + ((FixedRect.Right - FixedRect.Left) -
        m_CanvasCenter.Canvas.TextWidth('��')) div 2;

    Y := FixedRect.Top + ((FixedRect.Bottom - FixedRect.Top) -
        (nTextHeight * length(strText))) div 2;

    for j := 1 to LengTh(strText) do
    begin
      m_CanvasCenter.Canvas.TextOut(X,Y,strText[j]);
      Y := Y + nTextHeight + 2;
    end;
  end;
  m_CanvasCenter.Canvas.Brush.Style := bsClear;
  //�������
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
{����:���Ʊ�񱳾�}
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
{����:����VIEW}
var
  tmpBitmap : TBitmap;
begin
  Result := False;
  if VertScrollBar.Range < View.GetRect.Bottom then
  begin
    VertScrollBar.Range :=
        View.GetRect.Bottom + View.Margins.Bottom +Padding.Bottom;
  end;
  //ֻ��View����ʾ�����ڣ��Ż����
  if ViewIsDisplayRect(View) = False then
  begin
    Exit;
  end;

  Result := True;
  //��ʼ������
  tmpBitmap := TBitmap.Create;
  try
    InitViewBitmap(View,tmpBitmap);
    {����View�������������}
    View.getBitmap(tmpBitmap);
    {��View��������ݻ�������,����ִ����2�λ���,����Ϊһ����ֱ������Ļ���ƣ�
    һ���ǻ��Ƶ�Bitmap����������ˢ�µ�ʱ��,�Ͳ������}
    //���View����Ļ��,��ô��ֱ�ӻ��������������ϳ�����Ч��
    //���View��һ��ѡ��״̬,��ô����ѡ��Ч��

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
{����:���ݱ�����óߴ�}
begin
  if m_LayoutType = ltGrid then
  begin
    HorzScrollBar.Range := FIXEDWIDTH + m_nColCount * m_nColWidth;
    VertScrollBar.Range := FIXEDHEIGHT + m_nRowCount * m_nRowHeight;
  end;
end;

function TTFTabletop.FindView(X, Y: Integer): TView;
{����:��������,���View}
begin
  Result := m_ViewList.FindView(HorzScrollBar.Position + X,
        VertScrollBar.Position + Y,atMouse);
end;

function TTFTabletop.GetView(Index: Integer): TView;
begin
  Result := m_ViewList.Items[Index];
end;

function TTFTabletop.GetViewCount: Integer;
{����:�����ͼ����}
begin
  Result := m_ViewList.Count;
end;

procedure TTFTabletop.InitViewBitmap(View: TView;viewBitmap:TBitmap);
begin
  //��View���Ƶ�������
  viewBitmap.Width := View.Width;
  viewBitmap.Height := View.Height;
  {��ΪĿǰ����ֻ֧����ɫ,���Ҳ�֧�ֶ��View���า�ǵĹ���,
  ����viewBitmapֻ����ɫ����ˢһ�¾Ϳ�����}
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
    //�������ƶ�������
    m_tmrAutoMoveToUpDown.Tag := Ord(akDown);
    m_tmrAutoMoveToUpDown.Enabled := True;
  end
  else
  begin
    //�ر������ƶ�������
    if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akDown  then
      m_tmrAutoMoveToUpDown.Enabled := False;
  end;

  if ScreenY < ScreenPt.Y then
  begin
    ScreenY := ScreenPt.Y;
    //�������ƶ�������
    m_tmrAutoMoveToUpDown.Tag := Ord(akUp);
    m_tmrAutoMoveToUpDown.Enabled := True;
  end
  else
  begin
    //�ر������ƶ�������
    if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akUp  then
      m_tmrAutoMoveToUpDown.Enabled := False;
  end;  

  if (ScreenX + m_frmTabletopDrag.Width) > (ScreenPt.X + width) then
  begin
    ScreenX :=  (ScreenPt.X + width) - m_frmTabletopDrag.Width;
    //�������ƶ�������
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
    //�������ƶ�������
    m_tmrAutoMoveToLeftRight.Tag := Ord(akLeft);
    m_tmrAutoMoveToLeftRight.Enabled := True;
  end
  else
  begin
    //�ر������ƶ�������
    if TArrowKey(m_tmrAutoMoveToLeftRight.Tag) = akLeft  then
      m_tmrAutoMoveToLeftRight.Enabled := False;
  end;


end;

function TTFTabletop.GetFixedCellText(nRow, nCol: Integer): String;
{����:��ù̶���Ԫ}
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
{����:���ָ���еĸ߶���ߵ�View}
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
{����:��õ�ǰѡ���View}
begin
  Result := m_ViewList.FindSelectedView();
end;

procedure TTFTabletop.CalcScrollBarRect(var Rect: TRect);
{����:���ݹ�������������}
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
    //�Ƚ����е�Selected����ΪFalse
    if View.Selected then    
      SetViewsSelected(False,View)
    else
      SetViewsSelected(False,nil);
      
    View.Selected := True;
  end;
  //����View,����ΪSelect
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
        //��������,���View
        View := m_ViewList.FindView(X + HorzScrollBar.Position,
            Y+VertScrollBar.Position,atDragOver);
        if View <> nil then
        begin
          //����ק����
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
    //��Ϊ��ק��̫�죬���ڻ������,�������������������ק���ڲ�һ�£���ô��FREE
    if PtInRect(winRect,mouse.CursorPos) = false then
    begin
      //����ֻclose���ɣ��ڸô��ڵ�onclose��ʵ���Զ�free
      m_frmTabletopDrag.Close;
    end;
  end;
end;


procedure TTFTabletop.ClearView;
{����:������ͼ}
begin
  m_ViewList.Clear;
  ReComposition;
end;

procedure TTFTabletop.OnDragClose(Sender: TObject; var Action: TCloseAction);
begin
  ReductionSuspendedView();
//  //���»���m_DragView,����קЧ����ԭ
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
 {����:��ק�����ƶ��¼�}
begin
  if m_frmTabletopDrag = nil then Exit;
  //�����ƶ�����
  LimitDragRange(ScreenX,ScreenY);
  //��ʾ��ק��Ӧ��Ч��
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
    //����Ǳ����ʽ,���Ȼ��Ʊ�񱳾�
    DrawGrid();
    //Ȼ����ƹ̶���
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
{����:�Զ��������ƶ���������ʱ���¼�,tmrAutoMoveToUpDownΪ0��ʾ����1Ϊ����}
var
  n : Integer;
begin
  if TArrowKey(m_tmrAutoMoveToLeftRight.Tag) = akRight then
  begin
    //���ҹ���
    HorzScrollBar.Position := HorzScrollBar.Position  + 20;
    if m_frmTabletopDrag = nil then Exit;
  end
  else
  begin
    n := HorzScrollBar.Position  - 20;
    if n < 0 then
      n := 0;
    //�������
    HorzScrollBar.Position := n;
  end;
  m_CanvasCenter.Left := 0;

end;

procedure TTFTabletop.OntmrAutoMoveToUpDown(Sender: TObject);
{����:�Զ������ƶ���������ʱ���¼�}
var
  n : Integer;
begin
  if TArrowKey(m_tmrAutoMoveToUpDown.Tag) = akDown then
  begin
    //���¹���
    VertScrollBar.Position := VertScrollBar.Position  + 20;
    if m_frmTabletopDrag = nil then Exit;
  end
  else
  begin
    n := VertScrollBar.Position  - 20;
    if n < 0 then
      n := 0;
    //���Ϲ���
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
{����:���»���}
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
{����:��ԭSuspendedView}
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
{����:��ȫ����Viewȥ��Selected״̬}
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
{����:��������,������Ͳ���}
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
{����:��������,����View��List�е�����}
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
      //��ñ�����ߵ�View
      tmpView := GetRowMaxHeightView(PrevView.Row);
      //����
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
{����:��ʾ��ק����}
var
  ClientPt,ScreenPt : TPoint;
  View : TView;
begin
  ScreenPt.X := ScreenX;
  ScreenPt.Y := ScreenY;
  ClientPt := m_CanvasCenter.ScreenToClient(ScreenPt);

  View := m_ViewList.FindView(ClientPt.X + HorzScrollBar.Position,
      ClientPt.Y + VertScrollBar.Position,atDragDrop);



  //�������δ����Ǿ�����Ŀ��Viewͨ��Parentת�ɺ��Լ�һ������,����,����View,
  //�ƶ�������һ����View����View���棬���ȷ��ش�View
  View := TransformView(View);
  if View = m_DragView then Exit;
  if View = m_SuspendedView then Exit;

  //����õ���ǰ��View,������ק��View������nil,�ͱȽ�һ���Ƿ��ܷŵ�����
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
    //������ק����
    DrawDragFocusEffect();
    //֪ͨVIEW�ж�����������
    View.ViewDrag(m_DragView);
  end;
end;

function TTFTabletop.TransformView(View: TView):TView;
{����:ת��View,������������ק��View���ౣ��һ��}
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
{����:��ק����}
var
  ClientPt,ScreenPt : TPoint;
  View : TView;
begin
  ScreenPt.X := ScreenX;
  ScreenPt.Y := ScreenY;
  ClientPt := m_CanvasCenter.ScreenToClient(ScreenPt);
  View := m_ViewList.FindView(ClientPt.X + HorzScrollBar.Position,
      ClientPt.Y+VertScrollBar.Position,atDragDrop);

  //�������δ����Ǿ�����Ŀ��Viewͨ��Parentת�ɺ��Լ�һ������,����,����View,
  //�ƶ�������һ����View����View���棬���ȷ��ش�View
  View := TransformView(View);
  if View = m_DragView then Exit;
  

  if (View <> nil) And (m_DragView <> nil) then
  begin
    //�������Ժ���������Ż��������ĳ��View�Ƿ���Ӧ�ض���View
    if View.CheckViewDrop(m_DragView) = False then
    begin
      Exit;
    end;
    //����֪ͨ
    View.ViewDragDrop(m_DragView);
  end;

end;

function TTFTabletop.ViewIsDisplayRect(View: TView): Boolean;
{����:���View�Ƿ��ڵ�ǰ��ʾ����}
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

