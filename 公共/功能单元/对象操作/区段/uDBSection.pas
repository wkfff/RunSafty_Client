unit uDBSection;

interface
uses SysUtils,Classes,ADODB,DB,uSection,Variants, uTFSystem;

type
  TDBSection = class(TDBOperate)
  public
    {����:����������Ϣ}
    procedure SaveSection(Section:TSection);
    {����:���������б�}
    procedure SaveSectionList(SectionList:TSectionList);

    {����:ɾ��������Ϣ}
    procedure DeleteSection(strSectionGUID:String);
    {����:�ж����������Ƿ��Ѿ������ݿ��д���}
    function ExistSectionByName(strName : String;strExcludeGUID:String=''): Boolean;
    {����:��������ID��ȡ���ζ���}
    function GetSectionByGUID(strSectionGUID:String;var Section:TSection):Boolean;
    {����:���ȫ����������Ϣ}
    procedure GetSectionList(SectionList:TSectionList;strAreaGUID:String='');


  end;

implementation

{ TDBSection }

procedure TDBSection.DeleteSection(strSectionGUID: String);
{����:ɾ��������Ϣ}
begin
  m_ADOQuery.SQL.Text := 'Delete from TAB_Base_Section where strGUID = '+
      QuotedStr(strSectionGUID);
  m_ADOQuery.ExecSQL;
end;

function TDBSection.ExistSectionByName(strName,
  strExcludeGUID: String): Boolean;
{����:�ж����������Ƿ��Ѿ������ݿ��д���}
begin
  Result := False;
  m_ADOQuery.SQL.Text := 'Select strGUID from VIEW_Base_Section where '+
      'strSectionName = '+QuotedStr(strName);
  if strExcludeGUID <> '' then
  begin
    m_ADOQuery.SQL.Text := m_ADOQuery.SQL.Text + ' And strGUID <> ' +
        QuotedStr(strExcludeGUID)
  end;
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount > 0 then
    Result := True;
  m_ADOQuery.Close;
end;

function TDBSection.GetSectionByGUID(strSectionGUID: String;
  var Section: TSection): Boolean;
{����:��������ID��ȡ���ζ���}
begin
  Result := False;
  m_ADOQuery.SQL.Text := 'Select * from VIEW_Base_Section where '+
      'strGUID = '+QuotedStr(strSectionGUID);
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount > 0 then
  begin
    Section.SectionGUID := Trim(m_ADOQuery.FieldByName('strGUID').AsString);
    Section.SectionName := Trim(m_ADOQuery.FieldByName('strSectionName').AsString);
    Section.AreaGUID := Trim(m_ADOQuery.FieldByName('strAreaGUID').AsString);
    Section.AreaName := Trim(m_ADOQuery.FieldByName('strAreaName').AsString);
    Result := True;
  end;
  m_ADOQuery.Close;
end;

procedure TDBSection.GetSectionList(SectionList: TSectionList;strAreaGUID:String);
{����:���ȫ����������Ϣ}
var
  Section : TSection;
begin
  SectionList.Clear;
  m_ADOQuery.SQL.Text := 'Select * from VIEW_Base_Section';
  if strAreaGUID <> '' then
    m_ADOQuery.SQL.Text := m_ADOQuery.SQL.Text + ' Where strAreaGUID = '+
        QuotedStr(strAreaGUID);
  m_ADOQuery.Open;
  while m_ADOQuery.Eof = False do
  begin
    Section := TSection.Create;
    Section.SectionGUID := Trim(m_ADOQuery.FieldByName('strGUID').AsString);
    Section.SectionName := Trim(m_ADOQuery.FieldByName('strSectionName').AsString);
    Section.AreaGUID := Trim(m_ADOQuery.FieldByName('strAreaGUID').AsString);
    Section.AreaName := Trim(m_ADOQuery.FieldByName('strAreaName').AsString);
    SectionList.Add(Section);
    m_ADOQuery.Next;
  end;
  m_ADOQuery.Close;
end;

procedure TDBSection.SaveSection(Section: TSection);
{����:����������Ϣ}
begin
  if Section.SectionGUID = '' then
    Section.SectionGUID := NewGUID();
  m_ADOQuery.SQL.Text := 'Select * from TAB_Base_Section where '+
      'strGUID = '+QuotedStr(Section.SectionGUID);
  m_ADOQuery.Open;
  if m_ADOQuery.RecordCount = 0 then
    m_ADOQuery.Append
  else
    m_ADOQuery.Edit;
  m_ADOQuery.FieldByName('strGUID').AsString := Section.SectionGUID;
  m_ADOQuery.FieldByName('strSectionName').AsString := Section.SectionName;
  m_ADOQuery.FieldByName('strAreaGUID').AsString := Section.AreaGUID;
  m_ADOQuery.Post;
  m_ADOQuery.Close;
end;

procedure TDBSection.SaveSectionList(SectionList: TSectionList);
{����:���������б�}
var
  i : Integer;
begin
  for I := 0 to SectionList.Count - 1 do
  begin
    m_ADOQuery.SQL.Text := 'Select * from TAB_Base_Section where (strSectionName = '+
        QuotedStr(SectionList.Items[i].SectionName)+' And strAreaGUID = '+
        Quotedstr(SectionList.Items[i].AreaGUID)+') OR (strGUID = '+
        QuotedStr(SectionList.Items[i].SectionGUID)+')';
    m_ADOQuery.Open;
    if m_ADOQuery.RecordCount = 0 then
      m_ADOQuery.Append
    else
      m_ADOQuery.Edit;
    m_ADOQuery.FieldByName('strGUID').AsString := SectionList.Items[i].SectionGUID;
    m_ADOQuery.FieldByName('strSectionName').AsString := SectionList.Items[i].SectionName;
    m_ADOQuery.FieldByName('strAreaGUID').AsString := SectionList.Items[i].AreaGUID;
    m_ADOQuery.Post;
  end;
end;

end.
