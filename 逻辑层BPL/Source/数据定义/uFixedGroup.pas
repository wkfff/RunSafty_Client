unit uFixedGroup;

interface
uses
  uTrainman,Classes,Contnrs;
type

  //固定班结构体
  RFixedGroup = record
    //班组guid
    strGroupGUID:string;
    //班组序号
    nGroupIndex:Integer;
    //班组名称
    strGroupName:string;
    //车间id
    strWorkShopGUID:string;
    //车间名称
    strWorkShopName:string;
    //车队id
    strCheDuiGUID:string;
    //车队名称
    strCheDuiName:string;
  end;

  //固定班
  TFixedGroup= class
  public
    rFixedGroup: RFixedGroup;
    //司机1
    trainman1:RRsTrainman;
    //司机2
    trainman2:RRsTrainman;
    //司机3
    trainman3:RRsTrainman;
    //司机4
    trainman4:RRsTrainman;

  public
    procedure clone(sGroup:TFixedGroup);
  end;

  //固定班列表
  TFixedGroupList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TFixedGroup;
    procedure SetItem(Index: Integer; AObject: TFixedGroup);
  public
    function Add(AObject: TFixedGroup): Integer;
    property Items[Index: Integer]: TFixedGroup read GetItem write SetItem; default;
    //查找
    function Find(strGroupGUID:string):TFixedGroup;
  end;

implementation

{ TFixedGroupList }

function TFixedGroupList.Add(AObject: TFixedGroup): Integer;
begin
  result := inherited Add(AObject);
end;

function TFixedGroupList.Find(strGroupGUID: string): TFixedGroup;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if self.Items[i].rFixedGroup.strGroupGUID = strGroupGUID then
    begin
      result := self.Items[i];
      Exit;
    end;
  end;
end;

function TFixedGroupList.GetItem(Index: Integer): TFixedGroup;
begin
  Result := TFixedGroup(inherited GetItem(Index));
end;

procedure TFixedGroupList.SetItem(Index: Integer; AObject: TFixedGroup);
begin
  inherited SetItem(Index,AObject);
end;

{ TFixedGroup }

procedure TFixedGroup.clone(sGroup: TFixedGroup);
begin
  rFixedGroup:= sGroup.rFixedGroup   ;
  //司机1
  trainman1:=sGroup.trainman1;
  //司机2
  trainman2:=sGroup.trainman2;
  //司机3
  trainman3:=sGroup.trainman3;
  //司机4
  trainman4:=sGroup.trainman4;
end;

end.
