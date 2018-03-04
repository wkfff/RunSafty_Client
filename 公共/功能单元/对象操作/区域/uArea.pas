unit uArea;

interface
uses Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TAreaObject
  ///  ˵��:�������
  //////////////////////////////////////////////////////////////////////////////
  TArea = class(TObject)
  public
    {����ID}
    AreaGUID : String;
    {��������}
    AreaName : String;
    {����κ�}
    JWDNumber : String;
    {���������}
    JWDName : String;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TAreaObjectList
  ///  ˵��:��������б�
  //////////////////////////////////////////////////////////////////////////////
  TAreaList = class(TObjectList)
  protected
    procedure SetItem(nIndex:Integer;Item:TArea);
    function GetItem(nIndex:Integer):TArea;
  public
    function IndexOfByGUID(strGUID:String):Integer;
    function Add(Item: TArea): Integer;
  public
    property Items[Index:Integer]:TArea read GetItem write SetItem;
  end;

implementation

{ TAreaObjectList }

function TAreaList.Add(Item: TArea): Integer;
begin
  Result := (inherited Add(Item));
end;


function TAreaList.GetItem(nIndex: Integer): TArea;
begin
  Result := TArea(inherited GetItem(nIndex));
end;

function TAreaList.IndexOfByGUID(strGUID: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[i].AreaGUID = strGUID then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TAreaList.SetItem(nIndex: Integer; Item: TArea);
begin
  inherited SetItem(nIndex,Item);
end;

end.
