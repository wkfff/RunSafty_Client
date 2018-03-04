unit uRSCommonFunctions;

interface
uses
  uStation,Classes,SysUtils,DateUtils,uDutyPlace,uTrainType,uSaftyEnum,ADODB;

function DutyPlaceToGUID(strName: string;DutyPlaceList: TRsDutyPlaceList): string;
function StationNameToGUID(strName: string;StationArray: TRsStationArray): string;
function strDecodeTime(strTime: string;CurrentTime: TDateTime): TDateTime;

implementation


function strDecodeTime(strTime: string;CurrentTime: TDateTime): TDateTime;
var
  strTemp : string;
  i: Integer;
  strsTime : TStrings;
begin
  strsTime := TStringList.Create;
  try
    strsTime.Add(IntToStr(YearOf(CurrentTime)));
    strsTime.Add(IntToStr(MonthOf(CurrentTime)));
    strsTime.Add(IntToStr(DayOf(CurrentTime)));
    strsTime.Add(IntToStr(HourOf(CurrentTime)));
    strsTime.Add(IntToStr(MinuteOf(CurrentTime)));
    for i := 1 to (length(strTime)) div 2 do
    begin
      strTemp := Copy(StrTime,length(strTime) - i*2 + 1,2);
      strsTime[strsTime.Count - i] := strTemp;
    end;
    strTemp := Format('%s-%s-%s %s:%s:00',
      [strsTime[0],strsTime[1],strsTime[2],strsTime[3],strsTime[4]]);
    Result := strToDateTime(strTemp);


    if (length(strTime) <=4) and (IncHour(Result,3) < CurrentTime) and (Result + 1 > CurrentTime) then
    begin
      result := IncDay(result,1);
    end; 
  finally
    strsTime.Free;
  end;

end;
function StationNameToGUID(strName: string;StationArray: TRsStationArray): string;
var
  i: Integer;
begin
  Result := '';
  for I := 0 to Length(StationArray) - 1 do
  begin
    if StationArray[i].strStationName = strName then
    begin
      Result := StationArray[i].strStationGUID;
      Break;
    end;
  end;
end;


function DutyPlaceToGUID(strName: string;DutyPlaceList: TRsDutyPlaceList): string;
var
  i: Integer;
begin
  Result := '';
  for I := 0 to Length(DutyPlaceList) - 1 do
  begin
    if DutyPlaceList[i].placeName = strName then
    begin
      Result := DutyPlaceList[i].placeID;
      Break;
    end;
  end;
end;


end.
