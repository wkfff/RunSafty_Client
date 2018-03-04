unit uRelation;

interface
uses Contnrs;

Type

  TRelationObjectList = class;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRelationObject
  ///  ˵��:��֯�ṹ����
  //////////////////////////////////////////////////////////////////////////////
  TRelation = class(TObject)
  public
    constructor Create();
    destructor Destroy();override;
  protected
    {�ϼ���֯�ṹ}
    m_ParentRelation : TRelation;
    {��������֯�ṹ}
    m_ChildRelations : TRelationObjectList;
  public
    {��֯�ṹID}
    RelationID : String;
    {��֯�ṹ����}
    RelationName : String;
    property ChildRelations : TRelationObjectList read m_ChildRelations;
    property ParentRelation : TRelation
        read m_ParentRelation write m_ParentRelation;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRelationObjectList
  ///  ˵��:��֯�ṹ�б����
  //////////////////////////////////////////////////////////////////////////////
  TRelationObjectList = class(TObjectList)
  protected
    procedure SetItem(nIndex:Integer;Item:TRelation);
    function GetItem(nIndex:Integer):TRelation;
  public
    {����:ɾ����֯�ṹ��Ϣ}
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
