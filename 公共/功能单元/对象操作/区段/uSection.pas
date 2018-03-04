unit uSection;

interface
uses Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TSection
  ///  ˵��:���ζ���
  //////////////////////////////////////////////////////////////////////////////
  TSection = class(TObject)
  public
    {����ID}
    SectionGUID : String;
    {��������}
    SectionName : String;
    {��������ID}
    AreaGUID : String;
    {������������}
    AreaName : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TSectionList
  ///  ˵��:���ζ����б�
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

