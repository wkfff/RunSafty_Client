unit ufrmRemind;

interface
uses
  Forms,Messages,Windows,Types,Graphics,Controls,Classes,Contnrs,utfPopTypes,
  StdCtrls, ExtCtrls,  RzPanel, RzLstBox, Buttons;
type
  //////////////////////////////////////////////////////////////////////////////
  /// TfrmRemind
  //////////////////////////////////////////////////////////////////////////////
  TfrmRemind = class(TForm)
    lblMsg1: TLabel;
    lblClose: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure lblCloseMouseEnter(Sender: TObject);
    procedure lblCloseMouseLeave(Sender: TObject);
    procedure lblCloseClick(Sender: TObject);
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  protected
    //失去焦点时关闭
    procedure Deactivate; override;

  private
    //失去焦点的消息
    procedure WMActivate(var Message: TWMActivate); message WM_ACTIVATE;
    //获取或者失去焦点的消息
    procedure WMMOUSEACTIVATE(var Message : TWMMOUSEACTIVATE ); message WM_MOUSEACTIVATE;
  public
    class procedure ShowBox(Msg1 : string);
  end;
implementation
uses
  SysUtils;
{ TtfPopupWindow }
{$R *.dfm}

var
  popBox : TfrmRemind = nil;

  
constructor TfrmRemind.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  BorderStyle := bsNone;
  {$IFDEF VCL}
  DefaultMonitor := dmDesktop;
  {$ENDIF}
  FormStyle := fsStayOnTop;

end;

procedure TfrmRemind.Deactivate;
begin
  inherited;
end;

destructor TfrmRemind.Destroy;
begin
  //实际显示的数据木
  inherited;
end;


procedure TfrmRemind.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmRemind.lblCloseClick(Sender: TObject);
begin
  Hide;
end;

procedure TfrmRemind.lblCloseMouseEnter(Sender: TObject);
begin
  lblClose.Font.Style := [fsUnderline]
end;

procedure TfrmRemind.lblCloseMouseLeave(Sender: TObject);
begin
  lblClose.Font.Style := []
end;



class procedure TfrmRemind.ShowBox(Msg1: string);
begin
  if popBox = nil then
  begin
    popBox := TfrmRemind.Create(nil);
  end;

  popBox.lblMsg1.Caption := Msg1;
  popBox.Show;
end;

procedure TfrmRemind.WMActivate(var Message: TWMActivate);
begin

end;

procedure TfrmRemind.WMMOUSEACTIVATE(var Message: TWMMOUSEACTIVATE);
begin
 Message.result := MA_NOActivate;
end;

initialization

finalization
  if Assigned(popBox) then
    FreeAndNil(popBox) 
  
end.