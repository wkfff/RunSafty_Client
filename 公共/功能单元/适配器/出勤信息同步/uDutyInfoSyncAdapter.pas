unit uDutyInfoSyncAdapter;

interface
uses Classes, uTFSystem , uWriteICCarSoftDefined,SysUtils;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TDutyInfoSyncAdapter
  ///  说明:出勤信息同步适配器
  //////////////////////////////////////////////////////////////////////////////
  TDutyInfoSyncAdapter = class
  public
    WriteICCarDutyInfo : RWriteICCarDutyInfo;
  public
    {功能:读取写卡信息}
    procedure SetWriteICCarDutyInfo(MapStrings:TStringList);
    {功能:保存写卡信息}
    procedure GetWriteICCarDutyInfo(MapStrings:TStringList);
  end; 

implementation

{ TDutyInfoSyncAdapter }

procedure TDutyInfoSyncAdapter.GetWriteICCarDutyInfo(MapStrings: TStringList);
{功能:保存写卡信息}
begin
  MapStrings.Clear;
  case WriteICCarDutyInfo.KeHuo of
    khKeChe : MapStrings.Add('KeHuo:客车');
    khHuoChe : MapStrings.Add('KeHuo:货车');
    khKeHuo : MapStrings.Add('KeHuo:客货');
  end;
  MapStrings.Add('Section:'+WriteICCarDutyInfo.QuDuan);
  MapStrings.Add('CheCiHead:'+WriteICCarDutyInfo.CheCiTou);
  MapStrings.Add('CheCi:'+WriteICCarDutyInfo.CheCiNumber);
  MapStrings.Add('TrainmanNumber:'+WriteICCarDutyInfo.TrainmanNumber);
  MapStrings.Add('SubTrainmanNumber:'+WriteICCarDutyInfo.SubTrainmanNumber);
  MapStrings.Add('JiaoLuNumber:'+WriteICCarDutyInfo.JiaoLuHao);
  MapStrings.Add('StationNumber:'+WriteICCarDutyInfo.CheZhanHao);
end;

procedure TDutyInfoSyncAdapter.SetWriteICCarDutyInfo(MapStrings: TStringList);
{功能:读取写卡信息}
var
  i,Index : Integer;
  strText : String;
  strHead : String;
begin
  for i := 0 to MapStrings.Count -1 do
  begin
    strText := MapStrings.Strings[i];
    Index := Pos(':',strText);
    strHead := Copy(strText,1,Index-1);
    Delete(strText,1,Index);
    if strHead = 'KeHuo' then
    begin
      if strText = '客车' then
        WriteICCarDutyInfo.KeHuo := khKeChe;
      if strText = '货车' then
        WriteICCarDutyInfo.KeHuo := khHuoChe;
      if strText = '客货' then
        WriteICCarDutyInfo.KeHuo := khKeHuo;
      Continue;
    end;
    if strHead = 'Section' then
    begin
      WriteICCarDutyInfo.QuDuan := strText;
      Continue;
    end;
    if strHead = 'CheCiHead' then
    begin
      WriteICCarDutyInfo.CheCiTou := strText;
      Continue;
    end;
    if strHead = 'CheCi' then
    begin
      WriteICCarDutyInfo.CheCiNumber := strText;
      Continue;
    end;
    if strHead = 'TrainmanNumber' then
    begin
      WriteICCarDutyInfo.TrainmanNumber := strText;
      Continue;
    end;
    if strHead = 'SubTrainmanNumber' then
    begin
      WriteICCarDutyInfo.SubTrainmanNumber := strText;
      Continue;
    end;
    if strHead = 'JiaoLuNumber' then
    begin
      WriteICCarDutyInfo.JiaoLuHao := strText;
      Continue;
    end;
    if strHead = 'StationNumber' then
    begin
      WriteICCarDutyInfo.CheZhanHao := strText;
      Continue;
    end;
  end;

end;

end.
