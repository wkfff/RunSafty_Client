unit uSection;

interface
uses Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TSection
  ///  说明:区段对象
  //////////////////////////////////////////////////////////////////////////////
  TSection = class(TObject)
  public
    {区段ID}
    SectionGUID : String;
    {区段名称}
    SectionName : String;
    {所属区域ID}
    AreaGUID : String;
    {所属区域名称}
    AreaName : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TSectionList
  ///  说明:区段对象列表
  //////////////////////////////////////////////////////////////////////////////
  TSectionList = class(TObjectList)
  protected
    procedure SetItem(nIndex:Integer;Item:TSection);
    function GetItem(nIndex:Integer):TSection;
  public
    function Add(Item: TSection): Integer;
  public
    property Items[Index:Integer]:TSection read GetItem write SetItem;
  end;

implementation

{ TSectionList }

function TSectionList.Add(Item: TSection): Integer;
begin
  Result := inherited Add(Item);
end;

function TSectionList.GetItem(nIndex: Integer): TSection;
begin
  Result := TSection(inherited GetItem(nIndex));
end;

procedure TSectionList.SetItem(nIndex: Integer; Item: TSection);
begin
  inherited SetItem(nIndex,Item);
end;

end.

