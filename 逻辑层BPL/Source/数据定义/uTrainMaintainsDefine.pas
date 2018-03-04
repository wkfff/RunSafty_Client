unit uTrainMaintainsDefine;

interface
uses
  Classes,SysUtils,Contnrs;
Type
  {TTrainZBState 机车整备状态}
  TRsTrainZBState = (zbsOther{其它},zbsChangBei{长备},zbsDuanBei{短备},zbsLinXiu{临修},
    zbsXiuCheng{修程},zbsZhengBei{整备},zbsDaiYong{待用});

  {TTrainMaintainInfo 机车整备信息}
  TRsTrainMaintainInfo = class
  public
    strGUID: string;
    {机车类型}
    strTrainTypeName: string;
    {机车号}
    strTrainNumber: string;
    {股道号}
    nGDH: Integer;
    {机车坐标X}
    CoordX: Double;
    {机车坐标Y}
    CoordY: Double;
    {机车状态}
    TrainState: TRsTrainZBState;
    {站场宽度}
    GroundWidth: Double;
    {站场高度}
    GroundHeight: Double;
  end;

  {TTrainMaintainInfoList 机车整备信息列表}
  TRsTrainMaintainInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsTrainMaintainInfo;
    procedure SetItem(Index: Integer; AObject: TRsTrainMaintainInfo);
  public
    property Items[Index: Integer]: TRsTrainMaintainInfo read GetItem write SetItem; default;
  end;
implementation

{ TTrainMaintainInfoList }

function TRsTrainMaintainInfoList.GetItem(Index: Integer): TRsTrainMaintainInfo;
begin
  Result :=TRsTrainMaintainInfo(inherited GetItem(Index));
end;

procedure TRsTrainMaintainInfoList.SetItem(Index: Integer;
  AObject: TRsTrainMaintainInfo);
begin
  inherited SetItem(Index,AObject);
end;

end.
