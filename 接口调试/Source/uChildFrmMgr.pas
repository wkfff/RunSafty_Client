unit uChildFrmMgr;

interface
uses
  Classes,SysUtils,IniFiles,Forms;
type
  TFromClass = class of TForm;
  TChildFrmMgr = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_Frms: TList;
  public
    procedure Reg(FromClass: TFromClass);
    procedure UnReg(FromClass: TFromClass);
    property Frms: TList read m_Frms;
  end;
function ChildFrmMgr: TChildFrmMgr;
implementation
var
  g_ChildFrmMgr: TChildFrmMgr = nil;
function ChildFrmMgr: TChildFrmMgr;
begin
  if g_ChildFrmMgr = nil then  
    g_ChildFrmMgr := TChildFrmMgr.Create;

  Result := g_ChildFrmMgr;
end;
{ TChildFrmMgr }

constructor TChildFrmMgr.Create;
begin
  m_Frms := TList.Create;
end;

destructor TChildFrmMgr.Destroy;
begin
  m_Frms.Free;
  inherited;
end;

procedure TChildFrmMgr.Reg(FromClass: TFromClass);
begin
  if m_Frms.IndexOf(FromClass) = -1 then
    m_Frms.Add(FromClass);
end;

procedure TChildFrmMgr.UnReg(FromClass: TFromClass);
begin
  m_Frms.Remove(FromClass);
end;

initialization

finalization
  if g_ChildFrmMgr <> nil then
    FreeAndNil(g_ChildFrmMgr);

end.
