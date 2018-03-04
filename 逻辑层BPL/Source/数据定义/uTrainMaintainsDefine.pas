unit uTrainMaintainsDefine;

interface
uses
  Classes,SysUtils,Contnrs;
Type
  {TTrainZBState ��������״̬}
  TRsTrainZBState = (zbsOther{����},zbsChangBei{����},zbsDuanBei{�̱�},zbsLinXiu{����},
    zbsXiuCheng{�޳�},zbsZhengBei{����},zbsDaiYong{����});

  {TTrainMaintainInfo ����������Ϣ}
  TRsTrainMaintainInfo = class
  public
    strGUID: string;
    {��������}
    strTrainTypeName: string;
    {������}
    strTrainNumber: string;
    {�ɵ���}
    nGDH: Integer;
    {��������X}
    CoordX: Double;
    {��������Y}
    CoordY: Double;
    {����״̬}
    TrainState: TRsTrainZBState;
    {վ�����}
    GroundWidth: Double;
    {վ���߶�}
    GroundHeight: Double;
  end;

  {TTrainMaintainInfoList ����������Ϣ�б�}
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
