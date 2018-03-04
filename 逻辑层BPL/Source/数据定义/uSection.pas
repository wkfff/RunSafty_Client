unit uSection;

interface
uses Contnrs,Classes,superobject;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSection
  /// ˵��:������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TSection = Class
  public
    procedure Assign(Section:TSection);
  public
    {����GUID}
    strSectionGUID : String;
    {��������}
    strSectionName : String;
    {д������κ�}
    strDH : String;
    {д�����κ�}
    strQDH:string;
  public
    function AsString(): string;
    procedure FromString(Value: string);
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSectionList
  /// ˵��:������Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TSectionList = class(TObjectList)
  public
    {����:��������ID�������}
    function IndexOfGUID(strID:String):Integer;
    procedure Assign(SectionList:TSectionList);
  protected
    function GetItem(Index: Integer): TSection;
    procedure SetItem(Index: Integer; Section: TSection);
  public
    function AsString(): string;
    procedure FromString(Value: string);
    function Add(Section: TSection): Integer;
    property Items[Index: Integer]: TSection read GetItem write SetItem; default;
  end;

implementation

{ TSectionList }

function TSectionList.Add(Section: TSection): Integer;
begin
  Result := inherited Add(Section);
end;

procedure TSectionList.Assign(SectionList: TSectionList);
var
  i : Integer;
  Section : TSection;
begin
  Clear;
  for I := 0 to SectionList.Count - 1 do
  begin
    Section := TSection.Create;
    Section.Assign(SectionList.Items[i]);
    Add(Section);
  end;
end;

function TSectionList.AsString: string;
var
  js, secList: ISuperObject;
  I: Integer;
begin
  js := SO();
  secList := SO('[]');
  for I := 0 to self.Count - 1 do
  begin
    secList.AsArray.Add( SO(Items[I].AsString) );
  end;

  js.O['sectionList'] := secList;
  result := js.AsString;
end;

procedure TSectionList.FromString(Value: string);
var
  js, secList: ISuperObject;
  I,n: Integer;
  secItem: TSection;
begin
  self.Clear;

  js := SO(Value);
  secList := js.O['sectionList'];

  n := secList.AsArray.Length;
  for I := 0 to n - 1 do
  begin
    secItem := TSection.Create;
    secItem.FromString( secList.AsArray[I].AsString );
    self.Add(secItem);
  end;
end;

function TSectionList.GetItem(Index: Integer): TSection;
begin
  Result := TSection(inherited GetItem(Index));
end;

function TSectionList.IndexOfGUID(strID: String): Integer;
{����:��������ID�������}
var
  i : Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[i].strSectionGUID = strID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TSectionList.SetItem(Index: Integer; Section: TSection);
begin
  inherited SetItem(Index,Section);
end;

{ TSection }

procedure TSection.Assign(Section: TSection);
begin
  strSectionGUID := Section.strSectionGUID;
  strSectionName := Section.strSectionName;
  strDH := Section.strDH;
  strQDH := Section.strQDH;
end;

function TSection.AsString: string;
var
  js: ISuperObject;
begin
  js := SO();
  js.S['sectionName'] := self.strSectionName;
  js.S['sectionID'] := self.strSectionGUID;

  Result := js.AsString;
end;

procedure TSection.FromString(Value: string);
var
  js: ISuperObject;
begin
  js := SO(Value);
  self.strSectionName := js.S['sectionName'];
  self.strSectionGUID := js.S['sectionID'];
  self.strDH := js.S['strJWDNumber'];
  self.strQDH := js.S['strQDNumber'];
end;

end.
