unit uEmbeddedPageInMenu;

interface
uses
  classes,SysUtils,Forms,uLCBaseDict,uLCDict_EmbeddedPage,Menus,ShellApi,
  windows;
type
  TEmbeddedCtl = class
  public
    procedure ClickMenuItem(Sender: TObject);
    procedure EmbeddedMenu(nSiteJob: integer;MainMenu: TMainMenu);
    procedure EmbeddedForm(nSiteJob: integer;Form: TForm);
  end;
implementation

{ TEmbeddedCtl }

procedure TEmbeddedCtl.ClickMenuItem(Sender: TObject);
begin
  if Sender is TMenuItem then
  begin
    if (Sender as TMenuItem).Hint = '' then Exit;
    ShellExecute(Application.Handle,'open',PCHAR((Sender as TMenuItem).Hint),nil,nil,SW_SHOWMAXIMIZED);
  end;
end;

procedure TEmbeddedCtl.EmbeddedForm(nSiteJob: integer; Form: TForm);
var
  I: Integer;
begin
  for I := 0 to Form.ComponentCount - 1 do
  begin
    if Form.Components[i] is TMainMenu then
    begin
      EmbeddedMenu(nSiteJob,Form.Components[i] as TMainMenu);
      break;
    end;
  end;

end;

procedure TEmbeddedCtl.EmbeddedMenu(nSiteJob: integer;MainMenu: TMainMenu);
  function FindMenuItem(Caption: string): TMenuItem;
  var
    itemIndex: integer;
  begin
    Result := nil;
    for itemIndex := 0 to MainMenu.Items.Count - 1 do
    begin
      if SameText(MainMenu.Items.Items[itemIndex].Caption,Caption) then
      begin
        Result := MainMenu.Items.Items[itemIndex];
        break;
      end;
    end;
  end;
var
  PageList: TEmbeddedPageList;
  I: Integer;
  Item: TMenuItem;
  SubItem: TMenuItem;
begin
  PageList := TEmbeddedPageList.Create;
  try
    RsLCBaseDict.LCEmbeddedPage.GetPageItems(nSiteJob,PageList);
    for I := 0 to PageList.Count - 1 do
    begin
      Item := FindMenuItem(PageList.Items[i].Catalog);
      if Item <> nil then
      begin
        SubItem := TMenuItem.Create(MainMenu);
        SubItem.Caption := PageList.Items[i].Caption;
        SubItem.Hint := PageList.Items[i].URL;
        SubItem.OnClick := ClickMenuItem;
        Item.Add(SubItem);
      end;
    end;
  finally
    PageList.Free;
  end;

end;

end.
