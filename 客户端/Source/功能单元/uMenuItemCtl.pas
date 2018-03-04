unit uMenuItemCtl;

interface
uses
  Classes,SysUtils,xmldoc,XMLIntf,Menus;
type
  TMenuItemCtl = class
  private
    m_xml: IXMLDocument;
  public
    procedure InitMenu(Identifier: string;Menu: TMainMenu);
    procedure Load();
  end;
  
implementation

{ TMenuItemCtl }

procedure TMenuItemCtl.InitMenu(Identifier: string; Menu: TMainMenu);
  procedure InitMenuItems(nodeLst: IXMLNodeList;items: TMenuItem);
  var
    I: Integer;
    node: IXMLNode;
  begin
    for I := 0 to items.Count - 1 do
    begin
      node := nodeLst.FindNode(items.Items[i].Caption);
      if node = nil then Continue;
      if node.HasAttribute('visible') then
      begin
        if not node.Attributes['visible'] then
        begin
          items.Items[i].Visible := False;
        end
        else
        if items.Items[i].Count > 0 then
        begin
          InitMenuItems(node.ChildNodes,items.Items[i]);
        end;
      end;


    end;


  end;
var
  node: IXMLNode;
begin
  if m_xml = nil then Raise Exception.Create('未加载菜单配置信息!');

  node := m_xml.DocumentElement.ChildNodes.FindNode(Identifier);

  if node = nil then Exit;
  InitMenuItems(node.ChildNodes,Menu.Items);
end;

procedure TMenuItemCtl.Load;
var
  cfg: string;
begin
  m_xml := NewXMLDocument();

  cfg := ExtractFilePath(ParamStr(0)) + 'MenuItemCtl.xml';
  if FileExists(cfg) then
    m_xml.LoadFromFile(cfg)
  else
    m_xml.DocumentElement := m_xml.CreateNode('root');
end;

end.
