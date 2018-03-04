unit uFrmRegionFilter;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzLstBox, ExtCtrls, RzChkLst, uLCJDPlan,XMLDoc,XMLIntf,
  Contnrs,uTrainJiaolu;

type
  TJlRegion = class;
  TFrmRegionFilter = class(TForm)
    chkLstRegions: TRzCheckList;
    Bevel1: TBevel;
    lstBoxJl: TRzListBox;
    Bevel2: TBevel;
    Label1: TLabel;
    Bevel3: TBevel;
    Label2: TLabel;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure lstBoxJlClick(Sender: TObject);
    procedure chkLstRegionsChange(Sender: TObject; Index: Integer;
      NewState: TCheckBoxState);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    m_AllRegions: TTMISSectionList;
    function SelectedJl(): TJlRegion;
    procedure ReloadRegions(Regions: TTMISSectionList);
  public
    { Public declarations }
    class function ConfigRegion(LCJDPlan: TLCJDPlan): Boolean;
  end;

  TJlRegion = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    m_JlID: string;
    m_JlName: string;
    m_Regions: TTMISSectionList;
    m_Node: IXMLNode;
  public
    procedure Save(Node: IXMLNode = nil);
    procedure Read(Node: IXMLNode);
    property JlID: string read m_JlID write m_JlID;
    property JlName: string read m_JlName write m_JlName;
    property Regions: TTMISSectionList read m_Regions;
  end;


  TJlRegionList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TJlRegion;
    procedure SetItem(Index: Integer; AObject: TJlRegion);
  public
    property Items[Index: Integer]: TJlRegion read GetItem write SetItem; default;
  end;


  TRegionFilter = class
  public
    constructor Create;
    destructor Destroy;override;
  private
    class var _RegionFilter: TRegionFilter;
  private
    m_XmlDoc: IXMLDocument;
    m_JlRegionList: TJlRegionList;
    function FindJl(const JlID: string): TJlRegion;
  public
    procedure GetJlRegions(const JlID: string;Regions: TTMISSectionList);
    procedure AddJl(JlArray: TRsTrainJiaoluArray);
    procedure LoadFilter();
    procedure SaveFilter();

    class property DefaultFlter: TRegionFilter read _RegionFilter;
  end;

  TTMISSectionListHelper = class helper for TTMISSectionList
  private
    procedure CopyRegion(src,dect: TTMISSection);
  public
    procedure CopyFrom(Src: TTMISSectionList);
    function FindRegion(const ID: string): TTMISSection;
    function Contain(const ID: string): Boolean;
    procedure RemoveByID(const ID: string);
    procedure AddByClone(Region: TTMISSection);
  end;
  function CompareJlRegionByName(item1,item2: Pointer): integer;
const
  RegionFilterFile = 'RegionFilter.xml';
implementation

{$R *.dfm}

function CompareJlRegionByName(item1,item2: Pointer): integer;
begin
  Result := CompareStr(TJlRegion(item1).JlName,TJlRegion(item2).JlName);
end;
{ TFrmRegionFilter }

function TFrmRegionFilter.SelectedJl(): TJlRegion;
var
  i: integer;
begin
  Result := Nil;
  for I := 0 to lstBoxJl.Items.Count - 1 do
  begin
    if lstBoxJl.Selected[i] then
    begin
      Result := TJlRegion(lstBoxJl.Items.Objects[i]);
      Break;
    end;
  end;
end;

procedure TFrmRegionFilter.Button1Click(Sender: TObject);
begin
  TRegionFilter.DefaultFlter.SaveFilter();
  ModalResult := mrOk;
end;

procedure TFrmRegionFilter.Button2Click(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmRegionFilter.chkLstRegionsChange(Sender: TObject; Index: Integer;
  NewState: TCheckBoxState);
var
  jlRegion: TJlRegion;
begin
  jlRegion := SelectedJl;
  if jlRegion = nil then Exit;

  case NewState of
    cbUnchecked:
      begin
        jlRegion.Regions.RemoveByID(TTMISSection(chkLstRegions.Items.Objects[index]).Section_id);
      end;
    cbChecked:
      begin
        jlRegion.Regions.AddByClone(TTMISSection(chkLstRegions.Items.Objects[index]));
      end;
    cbGrayed: ;
  end;
end;

class function TFrmRegionFilter.ConfigRegion(LCJDPlan: TLCJDPlan): Boolean;
begin
  with TFrmRegionFilter.Create(nil) do
  begin
    LCJDPlan.QuerySections(m_AllRegions);
    m_AllRegions.Sort(CompareJlRegionByName);
    Result := ShowModal = mrok;
    Free;
  end;
end;

{ TJlRegion }

constructor TJlRegion.Create;
begin
  m_Regions := TTMISSectionList.Create;
end;

destructor TJlRegion.Destroy;
begin
  m_Regions.Free;
  inherited;
end;

procedure TJlRegion.Read(Node: IXMLNode);
var
  I: Integer;
  region: TTMISSection;
begin
  m_Node := Node;

  m_Regions.Clear;
  for I := 0 to m_Node.ChildNodes.Count - 1 do
  begin
    region := TTMISSection.Create;
    m_Regions.Add(region);
    region.Section_id := m_Node.ChildNodes[i].Attributes['ID'];
    region.Section_name := m_Node.ChildNodes[i].Attributes['Name'];
  end;

end;

procedure TJlRegion.Save(Node: IXMLNode);
var
  destNode,subNode: IXMLNode;
  I: Integer;
begin
  if Node <> nil then
  begin
    destNode := Node;
  end
  else
  begin
    destNode := m_Node;
  end;


  destNode.ChildNodes.Clear;
  for I := 0 to m_Regions.Count - 1 do
  begin
    subNode := destNode.AddChild('region');
    subNode.Attributes['ID'] := m_Regions[i].Section_id;
    subNode.Attributes['Name'] := m_Regions[i].Section_name;
  end;

end;
            

function TJlRegionList.GetItem(Index: Integer): TJlRegion;
begin
  result := TJlRegion(inherited GetItem(Index));
end;
procedure TJlRegionList.SetItem(Index: Integer; AObject: TJlRegion);
begin
  Inherited SetItem(Index,AObject);                     
end;                       
{ TRegionFilter }

procedure TRegionFilter.AddJl(JlArray: TRsTrainJiaoluArray);
var
  I: Integer;
  Node: IXMLNode;
begin
  for I := 0 to Length(JlArray) - 1 do
  begin
    if FindJl(JlArray[i].strTrainJiaoluGUID) = nil then
    begin
      Node := m_XmlDoc.DocumentElement.AddChild('Jl');
      Node.Attributes['ID'] := JlArray[i].strTrainJiaoluGUID;
      Node.Attributes['Name'] := JlArray[i].strTrainJiaoluName;
    end;    
  end;
  
  SaveFilter();
  LoadFilter();
end;

constructor TRegionFilter.Create;
begin
  m_XmlDoc := NewXMLDocument();
  m_XmlDoc.DocumentElement := m_XmlDoc.CreateNode('root');
  m_JlRegionList := TJlRegionList.Create;
end;

destructor TRegionFilter.Destroy;
begin
  m_JlRegionList.Free;
  m_XmlDoc := nil;
  inherited;
end;


function TRegionFilter.FindJl(const JlID: string): TJlRegion;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to m_JlRegionList.Count - 1 do
  begin
    if m_JlRegionList[i].JlID = JlID then
    begin
      Result := m_JlRegionList[i];
      Break;
    end;
  end;
end;


procedure TRegionFilter.LoadFilter;
var
  I: integer;
  JlRegion: TJlRegion;
begin
  if not FileExists(ExtractFilePath(ParamStr(0)) + RegionFilterFile) then Exit;  

  m_XmlDoc.LoadFromFile(ExtractFilePath(ParamStr(0)) + RegionFilterFile);
  m_JlRegionList.Clear;
  with m_XmlDoc.DocumentElement do
  begin
    for I := 0 to ChildNodes.Count - 1 do
    begin
      JlRegion := TJlRegion.Create;
      JlRegion.JlID := ChildNodes[i].Attributes['ID'];
      JlRegion.JlName := ChildNodes[i].Attributes['Name'];
      JlRegion.Read(ChildNodes[i]);              
      m_JlRegionList.Add(JlRegion);
    end;
  end;

  m_JlRegionList.Sort(CompareJlRegionByName);
end;

procedure TRegionFilter.SaveFilter;
var
  I: Integer;
begin
  for I := 0 to m_JlRegionList.Count - 1 do
  begin
    m_JlRegionList[i].Save();
  end;
  
  m_XmlDoc.SaveToFile(ExtractFilePath(ParamStr(0)) + RegionFilterFile);
end;

procedure TRegionFilter.GetJlRegions(const JlID: string;Regions: TTMISSectionList);
var
  jlRegion: TJlRegion;
begin
  Regions.Clear;
  jlRegion := FindJl(JlID);
  if jlRegion <> nil then
  begin
    Regions.CopyFrom(jlRegion.Regions);
  end;
end;

{ TTMISSectionListHelper }

procedure TTMISSectionListHelper.AddByClone(Region: TTMISSection);
begin
  Add(TTMISSection.Create);
  CopyRegion(Region,Last as TTMISSection);
end;

function TTMISSectionListHelper.Contain(const ID: string): Boolean;
begin
  Result := FindRegion(ID) <> nil;
end;

procedure TTMISSectionListHelper.CopyFrom(Src: TTMISSectionList);
var
  I: Integer;
  Region: TTMISSection;
begin
  for I := 0 to Src.Count - 1 do
  begin
    Region := TTMISSection.Create;
    CopyRegion(Src[i],Region);
    Add(Region);
  end;
end;

procedure TTMISSectionListHelper.CopyRegion(src, dect: TTMISSection);
begin
  dect.Section_id := src.Section_id;
  dect.Section_name := src.Section_name;
end;

function TTMISSectionListHelper.FindRegion(const ID: string): TTMISSection;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if Items[i].Section_id = ID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

procedure TTMISSectionListHelper.RemoveByID(const ID: string);
begin
  Remove(FindRegion(ID))
end;

procedure TFrmRegionFilter.FormCreate(Sender: TObject);
begin
  m_AllRegions := TTMISSectionList.Create;
end;

procedure TFrmRegionFilter.FormDestroy(Sender: TObject);
begin
  m_AllRegions.Free;
end;

procedure TFrmRegionFilter.FormShow(Sender: TObject);
var
  I: Integer;
begin
  lstBoxJl.Clear;
  for I := 0 to TRegionFilter.DefaultFlter.m_JlRegionList.Count - 1 do
  begin
    lstBoxJl.Items.AddObject(
      TRegionFilter.DefaultFlter.m_JlRegionList[i].JlName,
      TRegionFilter.DefaultFlter.m_JlRegionList[i])
  end;

end;

procedure TFrmRegionFilter.lstBoxJlClick(Sender: TObject);
begin
  if SelectedJl <> nil then
  begin
    ReloadRegions(SelectedJl.Regions);
  end;
end;

procedure TFrmRegionFilter.ReloadRegions(Regions: TTMISSectionList);
var
  I: Integer;
begin
  chkLstRegions.Clear;
  for I := 0 to m_AllRegions.Count - 1 do
  begin
    chkLstRegions.AddItem(
      Format('%s(%s)',[m_AllRegions[i].Section_name,m_AllRegions[i].Section_id])
    ,m_AllRegions[i]);
  end;
  
  
  for I := 0 to chkLstRegions.Count - 1 do
  begin
    chkLstRegions.ItemChecked[i] :=
      Regions.Contain(TTMISSection(chkLstRegions.Items.Objects[i]).Section_id);
  end;
end;


initialization
  TRegionFilter._RegionFilter := TRegionFilter.Create;
  TRegionFilter._RegionFilter.LoadFilter();

finalization
  TRegionFilter._RegionFilter.Free;
end.
