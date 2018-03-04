unit ufrmTabletopDrag;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uTFSystem, ActnList;


const
  //��ק��ʼƫ����
  DRAG_OFFSET_LEFT = 40;
  //��ק��ʼƫ����
  DRAG_OFFSET_TOP = 40;

type
  {TOnMoveing ��ק�����ƶ�֪ͨ}
  TOnMoveing = procedure(var ScreenX,ScreenY:Integer;var bIsMove:Boolean) of object;

  TfrmTabletopDrag = class(TForm)
    ActionList1: TActionList;
    Action1: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure Action1Execute(Sender: TObject);
    procedure FormMouseLeave(Sender: TObject);
  private
    {ͼƬ}
    m_viewBitmap : TBitmap;
    {��ʼ����}
    m_nStartX,m_nStartY : Integer;
    {��ק�����ƶ�֪ͨ}
    m_OnMoveing : TOnMoveing;
  public
    {�Ƿ�ȡ��}
    bIsCancel : Boolean;
    {����:������ʾ����}
    procedure SetBitmap(Bitmap:TBitmap);
    {����:������ʼ����}
    procedure SetStartPoint(X,Y:Integer);
  public
    property OnMoveing : TOnMoveing read m_OnMoveing write m_OnMoveing; 
  end;


implementation

{$R *.dfm}

procedure TfrmTabletopDrag.Action1Execute(Sender: TObject);
begin
  bIsCancel := True;
  Close;
end;

procedure TfrmTabletopDrag.FormCreate(Sender: TObject);
begin
  m_viewBitmap := TBitmap.Create;
  bIsCancel := False;
  SetCapture(self.Handle);
end;

procedure TfrmTabletopDrag.FormDestroy(Sender: TObject);
begin
  m_viewBitmap.Free;
  ReleaseCapture();
end;

procedure TfrmTabletopDrag.FormMouseLeave(Sender: TObject);
var
  newPoint : TPoint;
  ismove : Boolean;
begin

  newPoint := Mouse.CursorPos;
  newPoint.X := newPoint.X - m_nStartX;
  newPoint.Y := newPoint.Y - m_nStartY;
  ismove := True;  
  OnMoveing(newPoint.X,newPoint.Y,ismove);
  if ismove = False then Exit;
  Left := newPoint.X;
  Top := newPoint.Y;
end;

procedure TfrmTabletopDrag.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  newPoint : TPoint;
  ismove : Boolean;
//var
  xh: TTrackMouseEvent;
begin
// ����������ˣ���ʹ�����´�������
  xh.cbSize := sizeof(xh);
  xh.dwFlags := TME_LEAVE;
  xh.hwndTrack := Handle;
  xh.dwHoverTime := 0;
  TrackMouseEvent(xh);
  newPoint.X := Left + (X - m_nStartX);
  newPoint.Y := Top + (Y - m_nStartY);
  if Assigned(OnMoveing) then
  begin
    ismove := True;

    OnMoveing(newPoint.X,newPoint.Y,ismove);

    if ismove = false then exit;




    Left := newPoint.X;
    Top := newPoint.Y;
  end
  else
  begin
    Left := newPoint.X;
    Top := newPoint.Y;
  end;
end;

procedure TfrmTabletopDrag.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Close;
end;

procedure TfrmTabletopDrag.FormPaint(Sender: TObject);
begin
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.CopyRect(Canvas.ClipRect,m_viewBitmap.Canvas,m_viewBitmap.Canvas.ClipRect);
end;

procedure TfrmTabletopDrag.SetBitmap(Bitmap: TBitmap);
{����:������ʾ����}
begin
  Width := Bitmap.Width;
  Height := Bitmap.Height;
  m_viewBitmap.Width := Bitmap.Width;
  m_viewBitmap.Height := Bitmap.Height;
  m_viewBitmap.Canvas.CopyRect(Bitmap.Canvas.ClipRect,
      Bitmap.Canvas,m_viewBitmap.Canvas.ClipRect);
      
  OutputDebugString('1xx1');

end;

procedure TfrmTabletopDrag.SetStartPoint(X, Y: Integer);
begin
  m_nStartX := Mouse.CursorPos.X  - X;
  m_nStartY := Mouse.CursorPos.Y - Y;
  Left := X;
  Top := Y;
end;

end.

