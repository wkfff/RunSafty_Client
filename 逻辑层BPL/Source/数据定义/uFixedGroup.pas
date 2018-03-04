unit uFixedGroup;

interface
uses
  uTrainman,Classes,Contnrs;
type

  //�̶���ṹ��
  RFixedGroup = record
    //����guid
    strGroupGUID:string;
    //�������
    nGroupIndex:Integer;
    //��������
    strGroupName:string;
    //����id
    strWorkShopGUID:string;
    //��������
    strWorkShopName:string;
    //����id
    strCheDuiGUID:string;
    //��������
    strCheDuiName:string;
  end;

  //�̶���
  TFixedGroup= class
  public
    rFixedGroup: RFixedGroup;
    //˾��1
    trainman1:RRsTrainman;
    //˾��2
    trainman2:RRsTrainman;
    //˾��3
    trainman3:RRsTrainman;
    //˾��4
    trainman4:RRsTrainman;

  public
    procedure clone(sGroup:TFixedGroup);
  end;

  //�̶����б�
  TFixedGroupList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TFixedGroup;
    procedure SetItem(Index: Integer; AObject: TFixedGroup);
  public
    function Add(AObject: TFixedGroup): Integer;
    property Items[Index: Integer]: TFixedGroup read GetItem write SetItem; default;
    //����
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
  //˾��1
  trainman1:=sGroup.trainman1;
  //˾��2
  trainman2:=sGroup.trainman2;
  //˾��3
  trainman3:=sGroup.trainman3;
  //˾��4
  trainman4:=sGroup.trainman4;
end;

end.
