unit ufrmGanBuType;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, Menus, ExtCtrls,uLCBaseDict,uLCDict_GanBu,uTFSystem,
  Buttons, PngSpeedButton;

type
  TFrmGanBuTypeMgr = class(TForm)
    RzListBox1: TRzListBox;
    Bevel1: TBevel;
    Button1: TButton;
    PopupMenu1: TPopupMenu;
    miAdd: TMenuItem;
    miEdit: TMenuItem;
    N3: TMenuItem;
    miDelete: TMenuItem;
    PngSpeedButton1: TPngSpeedButton;
    PngSpeedButton2: TPngSpeedButton;
    procedure PopupMenu1Popup(Sender: TObject);
    procedure miAddClick(Sender: TObject);
    procedure miEditClick(Sender: TObject);
    procedure miDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure PngSpeedButton2Click(Sender: TObject);
  private
    { Private declarations }
    m_TypeList: TGanBuTypeList;
    procedure Init();
    function GetSelectedIndex(): integer;
  public
    { Public declarations }
    class procedure ShowForm();
  end;


implementation

uses uGlobalDM, Contnrs;

{$R *.dfm}

{ TFrmGanBuTypeMgr }

procedure TFrmGanBuTypeMgr.Button1Click(Sender: TObject);
begin
  close;
end;

procedure TFrmGanBuTypeMgr.FormCreate(Sender: TObject);
begin
  m_TypeList := TGanBuTypeList.Create;
end;

procedure TFrmGanBuTypeMgr.FormDestroy(Sender: TObject);
begin
  m_TypeList.Free;
end;

function TFrmGanBuTypeMgr.GetSelectedIndex: integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to RzListBox1.Items.Count - 1 do
  begin
    if RzListBox1.Selected[i] then
    begin
      Result := i;
      break;
    end;
  end;
end;

procedure TFrmGanBuTypeMgr.Init;
var
  I: Integer;
begin
  RzListBox1.Items.Clear;
  RsLCBaseDict.LCGanBu.LCGanBuType.Query(GlobalDM.SiteInfo.WorkShopGUID,m_TypeList);
  for I := 0 to m_TypeList.Count - 1 do
  begin
    RzListBox1.Items.AddObject(m_TypeList.Items[i].TypeName,m_TypeList.Items[i])
  end;
end;

procedure TFrmGanBuTypeMgr.miAddClick(Sender: TObject);
var
  value: string;
  GanBuType: TGanBuType;
begin
  value := '';
  if InputQuery('输入','请输入干部职务类型:',value) then
  begin
    GanBuType := TGanBuType.Create;
    try
      GanBuType.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
      GanBuType.TypeName := value;
      
      RsLCBaseDict.LCGanBu.LCGanBuType.Add(GanBuType);

      Init();
    finally
      GanBuType.Free;
    end;

  end;
end;

procedure TFrmGanBuTypeMgr.miDeleteClick(Sender: TObject);
var
  I: Integer;
  index: integer;
begin
  index := -1;
  for I := 0 to RzListBox1.Items.Count - 1 do
  begin
    if RzListBox1.Selected[i] then
    begin
      index := i;
      break;
    end;
  end;

  if index = -1 then Exit;

  if not TBox('确定要删除选择项吗？') then Exit;
  

  RsLCBaseDict.LCGanBu.LCGanBuType.Delete(TGanBuType(RzListBox1.Items.Objects[index]).TypeID);

  m_TypeList.Remove(TGanBuType(RzListBox1.Items.Objects[index]));

  RzListBox1.DeleteSelected;
end;
procedure TFrmGanBuTypeMgr.miEditClick(Sender: TObject);
var
  value: string;
  GanBuType: TGanBuType;
  I: Integer;
  index: integer;
begin
  index := -1;
  for I := 0 to RzListBox1.Items.Count - 1 do
  begin
    if RzListBox1.Selected[i] then
    begin
      index := i;
      break;
    end;
  end;

  if index = -1 then Exit;


  value :=  TGanBuType(RzListBox1.Items.Objects[index]).TypeName;
  if InputQuery('输入','请输入干部职务类型:',value) then
  begin
    GanBuType := TGanBuType.Create;
    try
      GanBuType.WorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;
      GanBuType.TypeName := value;
      GanBuType.TypeID := TGanBuType(RzListBox1.Items.Objects[index]).TypeID;

      RsLCBaseDict.LCGanBu.LCGanBuType.Update(GanBuType);
      Init();
    finally
      GanBuType.Free;
    end;

  end;
end;
procedure TFrmGanBuTypeMgr.PngSpeedButton1Click(Sender: TObject);
var
  nIndex: integer;
begin
  nIndex := GetSelectedIndex();

  if nIndex > 0 then
  begin
    RzListBox1.Items.Exchange(nIndex,nIndex-1);
    RsLCBaseDict.LCGanBu.LCGanBuType.ExchangeOrder(GlobalDM.SiteInfo.WorkShopGUID,
    TGanBuType(RzListBox1.Items.Objects[nIndex]).TypeID,
    TGanBuType(RzListBox1.Items.Objects[nIndex - 1]).TypeID);
  end;  
end;

procedure TFrmGanBuTypeMgr.PngSpeedButton2Click(Sender: TObject);
var
  nIndex: integer;
begin
  nIndex := GetSelectedIndex();

  if nIndex < RzListBox1.Items.Count - 1 then
  begin
    RzListBox1.Items.Exchange(nIndex,nIndex+1);
    RsLCBaseDict.LCGanBu.LCGanBuType.ExchangeOrder(GlobalDM.SiteInfo.WorkShopGUID,
    TGanBuType(RzListBox1.Items.Objects[nIndex]).TypeID,
    TGanBuType(RzListBox1.Items.Objects[nIndex + 1]).TypeID);
  end;  
end;

procedure TFrmGanBuTypeMgr.PopupMenu1Popup(Sender: TObject);
begin
  miDelete.Enabled := RzListBox1.SelectedItem <> '';
  miEdit.Enabled := RzListBox1.SelectedItem <> '';
end;

class procedure TFrmGanBuTypeMgr.ShowForm;
var
  FrmGanBuTypeMgr: TFrmGanBuTypeMgr;
begin
  FrmGanBuTypeMgr := TFrmGanBuTypeMgr.Create(nil);
  try
    FrmGanBuTypeMgr.Init();
    FrmGanBuTypeMgr.ShowModal;
  finally
    FrmGanBuTypeMgr.Free;
  end;
end;

end.
