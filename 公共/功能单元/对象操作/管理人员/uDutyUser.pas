unit uDutyUser;

interface
uses Contnrs;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TDutyUserObject
  ///  说明:管理人员对象
  //////////////////////////////////////////////////////////////////////////////
  TDutyUser = class(TObject)
  public
    {管理人员ID}
    DutyUserGUID : String;
    {管理人员工号}
    DutyNumber : String;
    {管理人员名称}
    DutyName : String;
    {密码}
    PassWord : String;
    {所属区域ID}
    AreaGUID : String;
    {所属区域名称}
    AreaName : String; 
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TAreaObjectList
  ///  说明:区域对象列表
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

