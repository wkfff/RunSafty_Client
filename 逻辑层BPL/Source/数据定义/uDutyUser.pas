unit uDutyUser;

interface
uses
  classes,Contnrs;
type
  TRsDutyUser = class(TPersistent)
  private
    m_strDutyGUID : string;
    m_strDutyNumber : string;
    m_strDutyName : string;
    m_strPassword : string;

    m_strTokenID : string;
  published
    property strDutyGUID : string read m_strDutyGUID write m_strDutyGUID;
    property strDutyNumber : string read m_strDutyNumber write m_strDutyNumber;
    property strDutyName : string read m_strDutyName write m_strDutyName;
    property strPassword : string read m_strPassword write m_strPassword;

    property strTokenID : string read m_strTokenID write m_strTokenID;
  end;

  
  TRsDutyUserList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsDutyUser;
    procedure SetItem(Index: Integer; AObject: TRsDutyUser);
  public
    property Items[Index: Integer]: TRsDutyUser read GetItem write SetItem; default;
  end;
          
implementation
function TRsDutyUserList.GetItem(Index: Integer): TRsDutyUser;
begin
  result := TRsDutyUser(inherited GetItem(Index));
end;
procedure TRsDutyUserList.SetItem(Index: Integer; AObject: TRsDutyUser);
begin
  Inherited SetItem(Index,AObject);
end;  
end.
