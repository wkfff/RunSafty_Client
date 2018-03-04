unit uDBSystemDict;

interface
uses
  ADODB,uSystemDict,uTFSystem;
type
  //ϵͳ�ֵ����ݿ������
  TRsDBSystemDict  = class(TDBOperate)
  public
    //��ȡ�����������
    procedure GetDrinkTypeArray(out DrinkTypeArray : TRsDrinkTypeArray);
    //��ȡ��֤��ʽ����
    procedure GetVerifyArray(out VerifyArray : TRsVerifyArray);
    //��ȡ��ƽ������
    procedure GetDrinkResult(out DrinkResultArray : TRsDrinkResultArray);

  end;
implementation

{ TDBSystemDict }

procedure TRsDBSystemDict.GetDrinkResult(out DrinkResultArray: TRsDrinkResultArray);
var
  adoQuery : TADOQuery;
  i : integer;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_System_DrinkResult order by nDrinkResult';
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(DrinkResultArray,RecordCount);
      while not eof do
      begin
        DrinkResultArray[i].nDrinkResult := FieldByName('nDrinkResult').AsInteger;
        DrinkResultArray[i].strDrinkResultName := FieldByName('strDrinkResultName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBSystemDict.GetDrinkTypeArray(out DrinkTypeArray: TRsDrinkTypeArray);
var
  adoQuery : TADOQuery;
  i : integer;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_System_DrinkType order by nDrinkTypeID';
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(DrinkTypeArray,RecordCount);
      while not eof do
      begin
        DrinkTypeArray[i].nDrinkTypeID := FieldByName('nDrinkTypeID').AsInteger;
        DrinkTypeArray[i].strDrinkTypeName := FieldByName('nDrinkTypeName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TRsDBSystemDict.GetVerifyArray(out VerifyArray: TRsVerifyArray);
var
  adoQuery : TADOQuery;
  i : integer;
  strSql : string;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_System_Verify order by nVerifyID';
      Connection := m_ADOConnection;
      SQL.Text := strSql;
      Open;
      i := 0;
      SetLength(VerifyArray,RecordCount);
      while not eof do
      begin
        VerifyArray[i].nVerifyID := FieldByName('nVerifyID').AsInteger;
        VerifyArray[i].strVerifyName := FieldByName('strVerifyName').AsString;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
