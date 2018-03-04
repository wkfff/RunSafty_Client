unit uRuntimeFilesTime;

interface
uses
  Classes,SysUtils,DateUtils,ADODB,uTFSystem,Contnrs;
type
  {运行记录时间信息}
  RRsRuntimeInfo = record
  public
    {停车时间}
    dtStopTime: TDateTime;
    {文件终止时间}
    dtFileEnd: TDateTime;
    {司机1工号}
    strTrainmanNumber1: string;
    {司机2工号}
    strTrainmanNumber2: string;
    
    {功能:判断是否有停车时间}
    function IsHaveStopTime(): Boolean;
    {功能:判断是否有文件结束时间}
    function IsHaveFileEndTime(): Boolean;
  end;

  {TRuntimeFileTimeReader 运行记录时间信息提取类，依靠退勤时间取运行记录文件信息，
  在退勤时间以前10个小时内结束的文件}
  TRsRuntimeFileTimeReader = class(TDBOperate)
  public
    function GetRuntimeInfo(dtEndWorkTime: TDateTime;strNumber: string;
        var RuntimeInfo: RRsRuntimeInfo): boolean;
  end;

implementation
{ TRuntimeFileTimeReader }
function TRsRuntimeFileTimeReader.GetRuntimeInfo(dtEndWorkTime: TDateTime;
    strNumber: string;var RuntimeInfo: RRsRuntimeInfo): Boolean;
const
  QUERY_SQL = 'select fid,jg02 as dtKaiCheTime,jg38 as strTrainmanNumber1,'
      + 'jg39 as strTrainmanNumber2,jg70 as dtFileStartTime,'
      + 'jg71 as dtFileEndTime, (select sum(Sjbd10) from sjbd where fid = '
      + 'cljg.fid) as nWorkTime from cljg where jg38 = %s or jg39 = %s and jg71 > '
      + '%s and jg71 < %s order by dtFileEndTime';
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    RuntimeInfo.dtStopTime := 0;
    RuntimeInfo.dtFileEnd := 0;
    RuntimeInfo.strTrainmanNumber1 := '';
    RuntimeInfo.strTrainmanNumber2 := '';

    
    ADOQuery.SQL.Text := Format(QUERY_SQL,[strNumber,strNumber,
        FormatDateTime('yyyy-MM-dd hh:nn:ss',IncHour(dtEndWorkTime,-10)),
        FormatDateTime('yyyy-MM-dd hh:nn:ss',dtEndWorkTime)]);

    ADOQuery.Open();
    
    Result := ADOQuery.RecordCount > 0;
    if ADOQuery.RecordCount > 0 then
    begin
      RuntimeInfo.dtFileEnd :=
          ADOQuery.FieldByName('dtFileEndTime').AsDateTime;
      RuntimeInfo.strTrainmanNumber1 :=
          ADOQuery.FieldByName('strTrainmanNumber1').AsString;
      RuntimeInfo.strTrainmanNumber2 :=
          ADOQuery.FieldByName('strTrainmanNumber').AsString;
    end;

      
    while not ADOQuery.Eof do
    begin
      if not ADOQuery.FieldByName('nWorkTime').IsNull then
      begin
        RuntimeInfo.dtStopTime :=
          IncSecond(ADOQuery.FieldByName('dtKaiCheTime').AsDateTime,
          ADOQuery.FieldByName('nWorkTime').AsInteger);
        Break;
      end;
      ADOQuery.Next;
    end;


  finally
    ADOQuery.Free;
  end;
end;


{ RRuntimeInfo }

function RRsRuntimeInfo.IsHaveFileEndTime: Boolean;
begin
  Result := dtFileEnd > 1;
end;

function RRsRuntimeInfo.IsHaveStopTime: Boolean;
begin
  Result := dtStopTime > 1; 
end;

end.
