unit uDBTrainMaintanInfo;

interface
uses
  Classes,ADODB,uTFSystem,uTrainMaintainsDefine,SysUtils;
type
  TRsDBTrainMaintain = class(TDBOperate)
  public
    procedure GetTrainMaintainInfo(InfoList: TRsTrainMaintainInfoList);
  end;
implementation

{ TDBTrainMaintain }

procedure TRsDBTrainMaintain.GetTrainMaintainInfo(
  InfoList: TRsTrainMaintainInfoList);
var
  ADOQuery: TADOQuery;
  MaintainInfo: TRsTrainMaintainInfo;
begin
  InfoList.Clear;
  
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'select * from TAB_TrainMaintains_Train';
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      MaintainInfo := TRsTrainMaintainInfo.Create;
      MaintainInfo.strGUID := Trim(ADOQuery.FieldByName('strGUID').AsString);
      MaintainInfo.strTrainTypeName := Trim(ADOQuery.FieldByName('strTrainTypeName').AsString);
      MaintainInfo.strTrainNumber := Trim(ADOQuery.FieldByName('strTrainNumber').AsString);
      MaintainInfo.nGDH := ADOQuery.FieldByName('nGDH').AsInteger;
      MaintainInfo.CoordX := ADOQuery.FieldByName('CoordX').AsFloat;
      MaintainInfo.CoordY := ADOQuery.FieldByName('CoordY').AsFloat;
      MaintainInfo.TrainState := TRsTrainZBState(ADOQuery.FieldByName('TrainState').AsInteger);
      MaintainInfo.GroundWidth := ADOQuery.FieldByName('GroundWidth').AsFloat;
      MaintainInfo.GroundHeight := ADOQuery.FieldByName('GroundHeight').AsFloat;
      InfoList.Add(MaintainInfo);
      ADOQuery.Next;
    end;

  finally
    ADOQuery.Free;
  end;
end;

end.
