unit uDBSJBD;

interface
uses
  ADODB,Contnrs,uTFSystem;
type
  TTFSJBD = class
  public
    //文件ID
    strFileID : string;
    //开始时间
    dtCreateTime : TDateTime;
    //sjbd02
    strStation :string;
    //,sjbd03
    dtArriveTime: integer;
    //sjbd04
    dtPassTime: integer;
    //,sjbd05
    nStepMinutes: integer;
    //Sjbd10
    nRunMinutes: integer;
    //实际起始时间,日期加时间
    dtStartTime : TDateTime;
    //车号
    strTrainNumber : string;
    //车次
    strTrainNo : string;
  end;
  TTFSJBDList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTFSJBD;
    procedure SetItem(Index: Integer; AObject: TTFSJBD);
  public
    property Items[Index: Integer]: TTFSJBD read GetItem write SetItem; default;
  end;
  TTFSJBDSection = class
  public
    SJBD : TTFSJBD;
    BeginTime : TDateTime;
    EndTime : TDateTime;
  end;
  TTFSJBDSectionList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTFSJBDSection;
    procedure SetItem(Index: Integer; AObject: TTFSJBDSection);
  public
    property Items[Index: Integer]: TTFSJBDSection read GetItem write SetItem; default;
  end;
  TDBSJBD = class(TDBOperate)
  public
    //获取人员在指定时间范围的司机报单
    procedure GetTrainmanSJBD(BeginTime,EndTime : TDateTime;TrainmanNumber : string;
      SJBDList : TTFSJBDList);
    //按照事件先后顺序重新排列司机报单
    procedure ReorderSJBD(SJBDList : TTFSJBDList);
    //根据4小时阶段将司机报单放在不同的区间里
    procedure SortSJBD(SJBDList : TTFSJBDList;SJBDSectionList: TTFSJBDSectionList);
  end;
  function FormatDT(DateTime: TDateTime): string;
  function FormatSeconds(Seconds: Integer): string;
implementation
uses
  DateUtils,SysUtils;
function FormatDT(DateTime: TDateTime): string;
begin
  result := '-';
  if datetime = 0 then exit;
  result := FormatDateTime('yyyy-MM-dd HH:nn',DateTime);
end;

function FormatSeconds(Seconds: Integer): string;
var
  datetime : TDateTime;
begin
  datetime := 0;
  datetime := IncSecond(datetime,seconds);
  result := Formatdatetime('hh:nn:ss',datetime);
end;

function GetTime(SourceTime: Int64;DestTime,StandardTime : TDateTime) : TDateTime;
var
  tmpTime,tmpTime2 : TDateTime;
begin
  tmpTime := 0;
  tmpTime := IncSecond(tmpTime,SourceTime);
  tmpTime := StrToTime(FormatDateTime('HH:nn:ss',tmpTime));
  tmpTime2 := StrToTime(FormatDateTime('HH:nn:ss',DestTime));
  if (tmpTime < TimeOf(tmpTime2)) then
  begin
    result := DateOf(StandardTime) + 1 + TimeOf(tmpTime);
  end else begin
    result := DateOf(StandardTime) + TimeOf(tmpTime);  
  end;
end;
{ TTFSJBDList }

function TTFSJBDList.GetItem(Index: Integer): TTFSJBD;
begin
  result := TTFSJBD(inherited GetItem(Index));
end;

procedure TTFSJBDList.SetItem(Index: Integer; AObject: TTFSJBD);
begin
  inherited SetItem(Index,AObject);
end;

{ TDBSJBD }

procedure TDBSJBD.GetTrainmanSJBD(BeginTime, EndTime: TDateTime;
  TrainmanNumber: string; SJBDList: TTFSJBDList);
var
  strSql : string;
  adoQuery : TADOQuery;
  sjbdItem : TTFSJBD;
begin

  strSql := 'select (select jg70 from cljg where cljg.fid=sjbd.fid) as dtCreateTime, ' +
      ' (select jg05 from cljg where cljg.fid=sjbd.fid) as strTrainNumber, ' +
       ' (select jg08 from cljg where cljg.fid=sjbd.fid) as strTrainNo, ' +
      ' * from sjbd ' +
      ' where fid in(select fid from cljg where jg02 > %s and jg02 <  %s  and ' +
      ' ((jg39=%s ) or (jg38=%s  ))) '  +
      ' order by dtCreateTime,sjbd01 ';
  strSql := Format(strSql,[QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',BeginTime)),
    QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndTime)),
    QuotedStr(TrainmanNumber),QuotedStr(TrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := strSql;
      Open;

      while not eof do
      begin
        sjbdItem := TTFSJBD.Create;
        SJBDList.Add(sjbdItem);
        sjbdItem.strStation := FieldByName('Sjbd02').AsString;
        sjbdItem.dtCreateTime :=  FieldByName('dtCreateTime').AsDateTime;
        sjbdItem.dtArriveTime := FieldByName('Sjbd03').AsInteger;
        sjbdItem.dtPassTime := FieldByName('Sjbd04').AsInteger;
        sjbdItem.nStepMinutes := FieldByName('Sjbd05').AsInteger;
        sjbdItem.nRunMinutes := FieldByName('Sjbd10').AsInteger;
        sjbdItem.strFileID := FieldByName('fid').AsString;
        sjbdItem.strTrainNumber := FieldByName('strTrainNumber').AsString;
        sjbdItem.strTrainNo := FieldByName('strTrainNo').AsString;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TDBSJBD.ReorderSJBD(SJBDList: TTFSJBDList);
var
  i: Integer;
  strLastFID : string;
  orderSJBDList : TTFSJBDList;
  tmpSJBD : TTFSJBD;
  k: Integer;
  bFLag : boolean;
begin
  //计算实际时间
  strLastFID := '';
  for i := 0 to SJBDList.Count - 1 do
  begin
    if (strLastFID = '') or (strLastFID <> SJBDList.Items[i].strFileID) then
    begin
      strLastFID := SJBDList.Items[i].strFileID;
      if (SJBDList.Items[i].dtPassTime > 0) then
      begin
        SJBDList.Items[i].dtStartTime := GetTime(SJBDList.Items[i].dtPassTime,
          SJBDList.Items[i].dtCreateTime,SJBDList.Items[i].dtCreateTime);
      end else begin
        SJBDList.Items[i].dtStartTime := GetTime(SJBDList.Items[i].dtArriveTime,
          SJBDList.Items[i].dtCreateTime,SJBDList.Items[i].dtCreateTime);
      end;
      continue;
    end;
    if (SJBDList.Items[i].dtPassTime > 0) then
    begin
      SJBDList.Items[i].dtStartTime := GetTime(SJBDList.Items[i].dtPassTime,
        SJBDList.Items[i-1].dtStartTime,SJBDList.Items[i-1].dtStartTime);
    end else begin
      SJBDList.Items[i].dtStartTime := GetTime(SJBDList.Items[i].dtArriveTime,
        SJBDList.Items[i-1].dtStartTime,SJBDList.Items[i-1].dtStartTime);
    end;
  end;
  exit;
  //排序
  orderSJBDList := TTFSJBDList.Create;
  try
    for i := SJBDList.Count - 1 downto 0 do
    begin
      bFlag := false;
      for k := 0 to orderSJBDList.Count - 1 do
      begin
        if orderSJBDList.Items[k].dtStartTime > SJBDList.Items[i].dtStartTime then
        begin
          tmpSJBD := TTFSJBD.Create;
          tmpSJBD.strFileID := SJBDList.Items[i].strFileID;
          tmpSJBD.dtCreateTime := SJBDList.Items[i].dtCreateTime;
          tmpSJBD.strStation := SJBDList.Items[i].strStation;
          tmpSJBD.dtArriveTime := SJBDList.Items[i].dtArriveTime;
          tmpSJBD.dtPassTime := SJBDList.Items[i].dtPassTime;
          tmpSJBD.nStepMinutes := SJBDList.Items[i].nStepMinutes;
          tmpSJBD.nRunMinutes := SJBDList.Items[i].nRunMinutes;
          tmpSJBD.dtStartTime := SJBDList.Items[i].dtStartTime;
          tmpSJBD.strTrainNumber := SJBDList.Items[i].strTrainNumber;
          tmpSJBD.strTrainNo := SJBDList.Items[i].strTrainNo;

          orderSJBDList.Insert(k,tmpSJBD);
          bFlag := true;
          break;
        end;
      end;
      if not bFlag then
      begin
        tmpSJBD := TTFSJBD.Create;
        tmpSJBD.strFileID := SJBDList.Items[i].strFileID;
        tmpSJBD.dtCreateTime := SJBDList.Items[i].dtCreateTime;
        tmpSJBD.strStation := SJBDList.Items[i].strStation;
        tmpSJBD.dtArriveTime := SJBDList.Items[i].dtArriveTime;
        tmpSJBD.dtPassTime := SJBDList.Items[i].dtPassTime;
        tmpSJBD.nStepMinutes := SJBDList.Items[i].nStepMinutes;
        tmpSJBD.nRunMinutes := SJBDList.Items[i].nRunMinutes;
        tmpSJBD.dtStartTime := SJBDList.Items[i].dtStartTime;
        tmpSJBD.strTrainNumber := SJBDList.Items[i].strTrainNumber;
        tmpSJBD.strTrainNo := SJBDList.Items[i].strTrainNo;

        orderSJBDList.Add(tmpSJBD);
      end;
    end;
    SJBDList.Clear;
    for i := 0 to orderSJBDList.Count - 1 do
    begin
      tmpSJBD := TTFSJBD.Create;
      tmpSJBD.strFileID := orderSJBDList.Items[i].strFileID;
      tmpSJBD.dtCreateTime := orderSJBDList.Items[i].dtCreateTime;
      tmpSJBD.strStation := orderSJBDList.Items[i].strStation;
      tmpSJBD.dtArriveTime := orderSJBDList.Items[i].dtArriveTime;
      tmpSJBD.dtPassTime := orderSJBDList.Items[i].dtPassTime;
      tmpSJBD.nStepMinutes := orderSJBDList.Items[i].nStepMinutes;
      tmpSJBD.nRunMinutes := orderSJBDList.Items[i].nRunMinutes;
      tmpSJBD.dtStartTime := orderSJBDList.Items[i].dtStartTime;
      tmpSJBD.strTrainNumber := orderSJBDList.Items[i].strTrainNumber;
      tmpSJBD.strTrainNo := SJBDList.Items[i].strTrainNo;

      SJBDList.Add(tmpSJBD)
    end;
  finally
    orderSJBDList.Free;
  end;
end;

procedure TDBSJBD.SortSJBD(SJBDList: TTFSJBDList;
  SJBDSectionList: TTFSJBDSectionList);
var
  i: Integer;
  sjbdSection : TTFSJBDSection;
  dtLastBegin,dtLastEnd : TDateTime;
  strLastTrainNumber : string;
begin
  dtLastBegin := 0;
  dtLastEnd := 0;
  strLastTrainNumber := '';
  for i := 0 to SJBDList.Count - 1 do
  begin
    if dtLastBegin = 0 then
    begin
      dtLastBegin := SJBDList[i].dtStartTime;
      dtLastEnd := SJBDList[i].dtStartTime;
      strLastTrainNumber := SJBDList[i].strTrainNo;

      continue;
    end;


      if (IncSecond(IncHour(dtLastEnd,3),SJBDList[i].nRunMinutes + SJBDList[i].nStepMinutes)
         <  SJBDList[i].dtStartTime)  and (strLastTrainNumber <>SJBDList[i].strTrainNo) then
      begin
        sjbdSection := TTFSJBDSection.Create;
        //开始计算中断区间
        sjbdSection.BeginTime := dtLastBegin;
        sjbdSection.EndTime := dtLastEnd;
        SJBDSectionList.Add(sjbdSection);
        dtLastBegin := SJBDList[i].dtStartTime;
        dtLastEnd := SJBDList[i].dtStartTime;
        strLastTrainNumber := SJBDList[i].strTrainNo;
      end else begin
        dtLastEnd := SJBDList[i].dtStartTime;
        strLastTrainNumber := SJBDList[i].strTrainNo;
      end;

  end;
   if dtLastBegin <> dtLastEnd then
  begin
     sjbdSection := TTFSJBDSection.Create;
      //开始计算中断区间
    sjbdSection.BeginTime := dtLastBegin;
    sjbdSection.EndTime := dtLastEnd;
    SJBDSectionList.Add(sjbdSection);
      
  end;
end;

{ TTFSJBDSectionList }

function TTFSJBDSectionList.GetItem(Index: Integer): TTFSJBDSection;
begin
  result := TTFSJBDSection(inherited GetItem(Index));
end;

procedure TTFSJBDSectionList.SetItem(Index: Integer; AObject: TTFSJBDSection);
begin
 inherited SetItem(Index,AObject);
end;

end.
