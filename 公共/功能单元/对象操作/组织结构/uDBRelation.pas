unit uDBRelation;

interface
uses SysUtils,Windows,Classes,ADODB,DB,uRelation, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// ����:TRelatiionDB
  /// ˵��:��֯�ṹ���ݲ�����
  //////////////////////////////////////////////////////////////////////////////
  TDBRelatiion = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
    destructor Destroy();override;
  public
    {����:���ȫ������֯�ṹ��Ϣ}
    procedure GetRelations(RelationObjectList : TRelationObjectList);
    {����:������֯�ṹ��Ϣ}
    procedure SaveRelation(Relation:TRelation);
    {����:ɾ����֯�ṹ��Ϣ}
    procedure DeleteRelation(Relation:TRelation);
  private
    {����:��ȡһ���������е��Ӳ���}
    procedure GetChildRelation(ParentRelation:TRelation;
        RelationObjectList: TRelationObjectList);
  protected
    m_ADOQuery : TADOQuery;
    m_ADOConnection : TADOConnection;

  published
    { published declarations }
  end;


implementation

{ TRelatiionDB }

procedure TDBRelatiion.SaveRelation(Relation: TRelation);
{����:���һ����֯�ṹ��Ϣ}
begin
  if Relation.RelationID = '' then
    Relation.RelationID := NewGUID();

  m_ADOQuery.SQL.Text := 'Select * from TAB_Org_Relation where strGUID = '+
      QuotedStr(Relation.RelationID);
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount = 0 then
    m_ADOQuery.Append
  else
    m_ADOQuery.Edit;

  m_ADOQuery.FieldByName('strGUID').AsString := Relation.RelationID;
  m_ADOQuery.FieldByName('strRelationName').AsString := Relation.RelationName;
  if Relation.ParentRelation <> nil then
  begin
    m_ADOQuery.FieldByName('strParentRelationGUID').AsString :=
        Relation.ParentRelation.RelationID;
  end
  else
  begin
    m_ADOQuery.FieldByName('strParentRelationGUID').AsString := '';
  end;

  m_ADOQuery.Post;
end;

constructor TDBRelatiion.Create(ADOConnection : TADOConnection);
begin
  m_ADOConnection := ADOConnection;
  m_ADOQuery := TADOQuery.Create(nil);
  m_ADOQuery.Connection := m_ADOConnection;
end;

procedure TDBRelatiion.DeleteRelation(Relation: TRelation);
{����:ɾ����֯�ṹ��Ϣ}
begin
  m_ADOQuery.SQL.Text := 'Delete from TAB_Org_Relation where strGUID = '+
      Quotedstr(Relation.RelationID);
  m_ADOQuery.ExecSQL;
end;

destructor TDBRelatiion.Destroy;
begin
  m_ADOQuery.Free;
  inherited;
end;

procedure TDBRelatiion.GetChildRelation(ParentRelation:TRelation;
    RelationObjectList: TRelationObjectList);
{����:��ȡһ���������е��Ӳ���}
var
  i : Integer;
  Item : TRelation;
  strParentRelationID : String;
begin
  strParentRelationID := '';
  if ParentRelation <> nil then
    strParentRelationID := ParentRelation.RelationID;

  m_ADOQuery.Filtered := False;
  m_ADOQuery.Filter := 'strParentRelationGUID = '+QuotedStr(strParentRelationID);
  try
    RelationObjectList.Clear;
    m_ADOQuery.Filtered := True;
    while m_ADOQuery.Eof = False do
    begin
      Item := TRelation.Create;
      Item.RelationID := m_ADOQuery.FieldByName('strGUID').AsString;
      Item.RelationName := m_ADOQuery.FieldByName('strRelationName').AsString;
      Item.ParentRelation := ParentRelation;
      RelationObjectList.Add(Item);
      m_ADOQuery.Next;
    end;
    for I := 0 to RelationObjectList.Count - 1 do
    begin
      GetChildRelation(RelationObjectList.Items[i],
          RelationObjectList.Items[i].ChildRelations);
    end;
  finally
    m_ADOQuery.Filtered := False;
  end;
end;

procedure TDBRelatiion.GetRelations(RelationObjectList: TRelationObjectList);
{����:���ȫ������֯�ṹ��Ϣ}
begin
  m_ADOQuery.SQL.Text := 'Select * from TAB_Org_Relation';
  m_ADOQuery.Open;
  try
    GetChildRelation(nil,RelationObjectList);
  finally
    m_ADOQuery.Close;
  end;
end;

end.
