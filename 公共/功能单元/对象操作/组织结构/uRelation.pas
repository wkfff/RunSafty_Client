unit uRelation;

interface
uses Contnrs;

Type

  TRelationObjectList = class;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRelationObject
  ///  说明:组织结构对象
  //////////////////////////////////////////////////////////////////////////////
  TRelation = class(TObject)
  public
    constructor Create();
    destructor Destroy();override;
  protected
    {上级组织结构}
    m_ParentRelation : TRelation;
    {包含子组织结构}
    m_ChildRelations : TRelationObjectList;
  public
    {组织结构ID}
    RelationID : String;
    {组织结构名称}
    RelationName : String;
    property ChildRelations : TRelationObjectList read m_ChildRelations;
    property ParentRelation : TRelation
        read m_ParentRelation write m_ParentRelation;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TRelationObjectList
  ///  说明:组织结构列表对象
  //////////////////////////////////////////////////////////////////////////////
  TRelationObjectList = class(TObjectList)
  protected
    procedure SetItem(nIndex:Integer;Item:TRelation);
    function GetItem(nIndex:Integer):TRelation;
  public
    {功能:删除组织结构信息}
    function DeleteRelation(Relation:TRelation):Boolean;
    function Add(Item: TRelation): Integer;
  public
    property Items[Index:Integer]:TRelation read GetItem write SetItem;
  end;



implementation

{ TRelationObjectList }

function TRelationObjectList.Add(Item: TRelation): Integer;
begin
  Result := inherited Add(Item);
end;

function TRelationObjectList.GetItem(nIndex: Integer): TRelation;
begin
  Result := TRelation(inherited GetItem(nIndex));
end;

procedure TRelationObjectList.SetItem(nIndex: Integer; Item: TRelation);
begin
  inherited SetItem(nIndex,Item);
end;

{ TRelationObject }

constructor TRelation.Create;
begin
  m_ChildRelations := TRelationObjectList.Create;
end;

function TRelationObjectList.DeleteRelation(Relation: TRelation):Boolean;
var
  i : Integer;
  nIndex : Integer;
begin
  nIndex := IndexOf(Relation);
  if nIndex <> -1 then
  begin
    Delete(nIndex);
    Result := True;
  end
  else
  begin
    for I := 0 to Count - 1 do
    begin
      Result := Items[i].ChildRelations.DeleteRelation(Relation);
      if Result then Break;
    end;
  end;
end;

destructor TRelation.Destroy;
begin
  m_ChildRelations.Free;
  inherited;
end;

end.
