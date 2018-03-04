unit uDutyUser;

interface
uses Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TDutyUserObject
  ///  ˵��:������Ա����
  //////////////////////////////////////////////////////////////////////////////
  TDutyUser = class(TObject)
  public
    {������ԱID}
    DutyUserGUID : String;
    {������Ա����}
    DutyNumber : String;
    {������Ա����}
    DutyName : String;
    {����}
    PassWord : String;
    {��������ID}
    AreaGUID : String;
    {������������}
    AreaName : String; 
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TAreaObjectList
  ///  ˵��:��������б�
  //////////////////////////////////////////////////////////////////////////////
  TDutyUserObjectList = class(TObjectList)
  protected
    procedure SetItem(nIndex:Integer;Item:TDutyUser);
    function GetItem(nIndex:Integer):TDutyUser;
  public
    function Add(Item: TDutyUser): Integer;
  public
    property Items[Index:Integer]:TDutyUser read GetItem write SetItem;
  end;

implementation

{ TDutyUserObjectList }

function TDutyUserObjectList.Add(Item: TDutyUser): Integer;
begin
  Result := (inherited Add(Item));
end;

function TDutyUserObjectList.GetItem(nIndex: Integer): TDutyUser;
begin
  Result := TDutyUser(inherited GetItem(nIndex));
end;

procedure TDutyUserObjectList.SetItem(nIndex: Integer; Item: TDutyUser);
begin
  inherited SetItem(nIndex,Item);
end;

end.

