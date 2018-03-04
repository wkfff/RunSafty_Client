unit uDBRelation;

interface
uses SysUtils,Windows,Classes,ADODB,DB,uRelation, uTFSystem;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TRelatiionDB
  /// 说明:组织结构数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBRelatiion = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
    destructor Destroy();override;
  public
    {功能:获得全部的组织结构信息}
    procedure GetRelations(RelationObjectList : TRelationObjectList);
    {功能:保存组织结构信息}
    procedure SaveRelation(Relation:TRelation);
    {功能:删除组织结构信息}
    procedure DeleteRelation(Relation:TRelation);
  private
    {功能:读取一个部门所有的子部门}
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
{功能:添加一个组织结构信息}
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
{功能:删除组织结构信息}
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
{功能:读取一个部门所有的子部门}
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
{功能:获得全部的组织结构信息}
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
