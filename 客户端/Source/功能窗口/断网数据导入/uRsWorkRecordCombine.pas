unit uRsWorkRecordCombine;

interface
uses
  Classes,ADODB,Contnrs,uGenericData,DateUtils,uDBTrainPlan,uTrainPlan,SysUtils,
  uSaftyEnum,uDrink,uDBTrainmanJiaolu,uTrainmanJiaolu,uDBDrink,uDBTrainPlanWork,
  DB,uRsDBInterfaceLogic,uRsInterfaceDefine,uDBRunEvent,uRunEvent,uTFSystem;
type
  TRsLocalDataType = (ldtBeginWorkRecord,ldtEndWorkRecord,ldtDrinkTest);
  TRsLocalData = class
  public
    constructor Create();
    destructor Destroy; override;
  protected
    m_GenericData: TGenericData;
    m_strGUID: string;
    m_dtEventTime: TDateTime;
    m_DataType: TRsLocalDataType;
    m_Stream: TMemoryStream;
  public
    property GenericData: TGenericData read m_GenericData;
    property EventTime: TDateTime read m_dtEventTime write m_dtEventTime;
    property DataType: TRsLocalDataType read m_DataType write m_DataType;
    property GUID: string read m_strGUID write m_strGUID;
    property Stream: TMemoryStream read m_Stream;
  end;
  TRsLocalDataList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLocalData;
    procedure SetItem(Index: Integer; AObject: TRsLocalData);
  public
    property Items[Index: Integer]: TRsLocalData read GetItem write SetItem; default;
  end;

  TRsLocalImport = class
  public
    constructor Create(ServerConnection,LocalConnection: TADOConnection);
    destructor Destroy; override;
  private
    m_ServerConnection: TADOConnection;
    m_LocalConnection: TADOConnection;
    m_DBRunEvent: TRsDBRunEvent;
    m_LocalDataList: TRsLocalDataList;
    m_DBTrainPlan: TRsDBTrainPlan;    
    m_DBTrainPlanWork: TRsDBTrainPlanWork;
    m_DBInterface: TRsDBInterface;
    m_DrinkImage: TRsDrinkImage;
    m_strStationGUID: string;
    m_nTmis: integer;
    m_strSiteGUID: string;
    m_strDutyGUID: string;
    m_OnReadChangeEvent: TOnReadChangeEvent;
    function NewADOQuery: TADOQuery;
    function NewLocalQuery: TADOQuery;

    function GetNeedTuiQinPlan(RsLocalData: TRsLocalData): Boolean;
    function GetNeedChuQinPlan(RsLocalData: TRsLocalData): Boolean;
  private
    procedure Progress(nMax,nPosition: Integer);
    procedure ExtractBeginWorkData(LocalDataList: TRsLocalDataList);
    procedure ExtractEndWorkData(LocalDataList: TRsLocalDataList);
    procedure ExtractForiegnTestData(LocalDataList: TRsLocalDataList);
    procedure SortDataListByTime(LocalDataList: TRsLocalDataList);
    procedure HandleDataList(LocalDataList: TRsLocalDataList);

    procedure GetTrainmanEventDetail(strTrainmanNumber: string;dtBeginWorkTime: TDateTime;
        EventList: TGenericDataList);

    procedure GetTrainEventDetail(strTrainmanNumber: string;dtBeginWorkTime: TDateTime;
        EventList: TGenericDataList);

    procedure UpdateTrainmanDetail(strGUID,RunEventGUID: string);
    procedure UpdateTrainDetail(strGUID,RunEventGUID: string);
    procedure SingleTrainmanEvent(strDetailGUID: string;EventID : TRunEventType;CWYEvent: RRSCWYEvent);
    procedure DoubleTrainmanEvent(strDetailGUID: string;JCEvent : RRSJCEvent);
  private
    procedure HandleEndWorkData(RsLocalData: TRsLocalData);
    procedure HandleBeginWorkData(RsLocalData: TRsLocalData);
    procedure HandleForiegnTestData(RsLocalData: TRsLocalData);

    procedure PostEvent(RsLocalData: TRsLocalData);
    procedure PostTrainmanEvent(EventData: TGenericData);
    procedure PostTrainEvent(EventData: TGenericData);

    procedure SignLocalRecord(LocalDataList: TRsLocalDataList);
  public
    procedure ExtractData(LocalDataList: TRsLocalDataList);
    procedure ImportData(LocalDataList: TRsLocalDataList);

    property StationGUID: string read m_strStationGUID write m_strStationGUID;
    property SiteGUID: string read m_strSiteGUID write m_strSiteGUID;
    property DutyGUID: string read m_strDutyGUID write m_strDutyGUID;
    property OnProgress: TOnReadChangeEvent read m_OnReadChangeEvent write m_OnReadChangeEvent;
  end;

  function CompareLocalData(Item1, Item2: Pointer): Integer;
implementation
function CompareLocalData(Item1, Item2: Pointer): Integer;
begin
  Result := CompareDateTime(TRsLocalData(Item1).EventTime,TRsLocalData(Item2).EventTime);
end;
{ TRsLocalImportFrame }

constructor TRsLocalImport.Create(ServerConnection,
  LocalConnection: TADOConnection);
begin
  m_ServerConnection := ServerConnection;
  m_LocalConnection := LocalConnection;
  m_DBTrainPlan := TRsDBTrainPlan.Create(ServerConnection);  
  m_DBTrainPlanWork := TRsDBTrainPlanWork.Create(ServerConnection);
  m_DBInterface := TRsDBInterface.Create(ServerConnection);
  m_DBRunEvent := TRsDBRunEvent.Create(ServerConnection);
  m_LocalDataList := TRsLocalDataList.Create;
  m_DrinkImage := TRsDrinkImage.Create('');
end;

destructor TRsLocalImport.Destroy;
begin
  m_LocalDataList.Free;
  m_DrinkImage.Free;
  m_DBTrainPlan.Free;   
  m_DBTrainPlanWork.Free;
  m_DBInterface.Free;
  m_DBRunEvent.Free;
  inherited;
end;

procedure TRsLocalImport.DoubleTrainmanEvent(strDetailGUID: string;JCEvent: RRSJCEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
  eventID : TRunEventType;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  eventID :=  eteNull;
  case   JCEvent.sjbz of
    jceChuKu: eventID := eteOutDepots;
    jceRuKu: eventID := eteInDepots;
    jceTingChe: eventID := eteEnterStation;
    jceKaiChe: eventID := eteLeaveStation;
  end;
  try
    try
      recordGUID := m_DBRunEvent.TrainSubmit(JCEvent.etime, JCEvent.tmid1,
        JCEvent.tmid2,JCEvent.stmis, 1, JCEvent.cc, JCEvent.cx,JCEvent.ch,
        0,'',eventID, nResult);
    except on e : exception do
      begin
        nResult := 2;
        strResult := e.message;
      end;
    end;
    if (nResult = 0) then
    begin
      UpdateTrainDetail(strDetailGUID,recordGUID);
      strResult := '添加成功';
    end;
  finally
  end;
end;

procedure TRsLocalImport.ExtractBeginWorkData(LocalDataList: TRsLocalDataList);
var
  ADOQuery: TADOQuery;
  LocalData: TRsLocalData;
begin
  ADOQuery := NewLocalQuery;
  try
    ADOQuery.SQL.Text := 'Select * from VIEW_Plan_BeginWork where nFlag = 0 or nFlag is null';
    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LocalData := TRsLocalData.Create;
      LocalData.GUID := ADOQuery.FieldByName('strBeginWorkGUID').AsString;
      LocalData.EventTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      LocalData.DataType := ldtBeginWorkRecord;
      LocalData.GenericData.StrField['strTrainmanGUID'] := ADOQuery.FieldByName('strTrainmanGUID').AsString;

      LocalData.GenericData.dtField['dtCreateTime'] := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      LocalData.GenericData.IntField['nVerifyID'] := ADOQuery.FieldByName('nVerifyID').AsInteger;
      LocalData.GenericData.StrField['strTrainmanNumber'] := ADOQuery.FieldByName('strTrainmanNumber').AsString;

      LocalData.GenericData.StrField['strTrainmanName'] := ADOQuery.FieldByName('strTrainmanName').AsString;
      LocalData.GenericData.IntField['nDrinkResult'] := ADOQuery.FieldByName('nDrinkResult').AsInteger;
      LocalData.GenericData.dtField['dtTestDrinkTime'] := ADOQuery.FieldByName('dtTestDrinkTime').AsDateTime;
      LocalData.Stream.Clear;
      TBlobField(ADOQuery.FieldByName('DrinkImage')).SaveToStream(LocalData.Stream);
      LocalDataList.Add(LocalData);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;


procedure TRsLocalImport.ExtractData(LocalDataList: TRsLocalDataList);
begin
  LocalDataList.Clear;
  ExtractBeginWorkData(LocalDataList);
  ExtractEndWorkData(LocalDataList);
  ExtractForiegnTestData(LocalDataList);
  SortDataListByTime(LocalDataList);
end;

procedure TRsLocalImport.ExtractEndWorkData(LocalDataList: TRsLocalDataList);
var
  ADOQuery: TADOQuery;
  LocalData: TRsLocalData;
begin
  ADOQuery := NewLocalQuery;
  try
    ADOQuery.SQL.Text := 'Select * from VIEW_Plan_EndWork where nFlag = 0 or nFlag is null';


    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LocalData := TRsLocalData.Create;
      LocalData.GUID := ADOQuery.FieldByName('strEndWorkGUID').AsString;
      LocalData.EventTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      LocalData.DataType := ldtEndWorkRecord;
      LocalData.GenericData.StrField['strTrainmanGUID'] := ADOQuery.FieldByName('strTrainmanGUID').AsString;

      LocalData.GenericData.dtField['dtCreateTime'] := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
      LocalData.GenericData.IntField['nVerifyID'] := ADOQuery.FieldByName('nVerifyID').AsInteger;
      LocalData.GenericData.StrField['strTrainmanNumber'] := ADOQuery.FieldByName('strTrainmanNumber').AsString;

      LocalData.GenericData.StrField['strTrainmanName'] := ADOQuery.FieldByName('strTrainmanName').AsString;
      LocalData.GenericData.IntField['nDrinkResult'] := ADOQuery.FieldByName('nDrinkResult').AsInteger;
      LocalData.GenericData.dtField['dtTestDrinkTime'] := ADOQuery.FieldByName('dtTestDrinkTime').AsDateTime;
      LocalData.Stream.Clear;
      TBlobField(ADOQuery.FieldByName('DrinkImage')).SaveToStream(LocalData.Stream);

      LocalDataList.Add(LocalData);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;



procedure TRsLocalImport.ExtractForiegnTestData(
  LocalDataList: TRsLocalDataList);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  LocaData: TRsLocalData;
begin
  ADOQuery := NewLocalQuery;
  try
    strSQL := 'Select * from TAB_Drink_Information where nWorkTypeID = 10 and (nFlag is null or nFlag = 0) order by dtCreateTime';

    ADOQuery.SQL.Text := strSQL;


    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      LocaData := TRsLocalData.Create;

      LocaData.DataType := ldtDrinkTest;

      LocaData.GUID := ADOQuery.FieldByName('strGUID').AsString;

      LocaData.EventTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;

      LocaData.GenericData.StrField['strGUID'] :=
          ADOQuery.FieldByName('strGUID').AsString;

      LocaData.GenericData.IntField['nDrinkResult'] :=
          ADOQuery.FieldByName('nDrinkResult').AsInteger;

      LocaData.GenericData.dtField['dtCreateTime'] :=
          ADOQuery.FieldByName('dtCreateTime').AsDateTime;

      LocaData.GenericData.StrField['strTrainmanGUID'] :=
        ADOQuery.FieldByName('strTrainmanGUID').AsString;

      LocaData.GenericData.StrField['strTrainmanNumber'] :=
        ADOQuery.FieldByName('strTrainmanGUID').AsString;

      LocaData.GenericData.StrField['nWorkTypeID'] :=
        ADOQuery.FieldByName('nWorkTypeID').AsString;

      LocaData.GenericData.IntField['nVerifyID'] :=
        ADOQuery.FieldByName('nVerifyID').AsInteger;

      TBlobField(ADOQuery.FieldByName('DrinkImage')).SaveToStream(LocaData.Stream);

      LocalDataList.Add(LocaData);
      
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;
procedure TRsLocalImport.GetTrainEventDetail(strTrainmanNumber: string;
  dtBeginWorkTime: TDateTime; EventList: TGenericDataList);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  GenericData: TGenericData;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'Select * from TAB_Plan_RunEvent_TrainDetail where ' +
      'dtEventTime > %s and (strTrainmanNumber1 = %s or strTrainmanNumber2 = %s) and (strRunEventGUID = '''' ' +
      'or strRunEventGUID is null)';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',
        dtBeginWorkTime)),QuotedStr(strTrainmanNumber),QuotedStr(strTrainmanNumber)]);

    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      GenericData := TGenericData.Create;
      GenericData.StrField['strGUID'] :=
          ADOQuery.FieldByName('strGUID').AsString;

      GenericData.IntField['nEventID'] :=
          ADOQuery.FieldByName('nEventID').AsInteger;

      GenericData.dtField['dtEventTime'] :=
          ADOQuery.FieldByName('dtEventTime').AsDateTime;

      GenericData.StrField['strTrainmanNumber1'] :=
        ADOQuery.FieldByName('strTrainmanNumber1').AsString;

      GenericData.StrField['strTrainmanNumber2'] :=
        ADOQuery.FieldByName('strTrainmanNumber2').AsString;

      GenericData.StrField['strTrainNo'] :=
        ADOQuery.FieldByName('strTrainNo').AsString;

      GenericData.StrField['strTrainTypeName'] :=
        ADOQuery.FieldByName('strTrainTypeName').AsString;

      GenericData.StrField['strTrainNumber'] :=
        ADOQuery.FieldByName('strTrainNumber').AsString;

      GenericData.IntField['nTMIS'] :=
        ADOQuery.FieldByName('nTMIS').AsInteger;

      GenericData.IntField['nKeHuo'] :=
        ADOQuery.FieldByName('nKeHuo').AsInteger;

      GenericData.StrField['strResult'] :=
        ADOQuery.FieldByName('strResult').AsString;

      EventList.Add(GenericData);

      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsLocalImport.GetTrainmanEventDetail(strTrainmanNumber: string;
  dtBeginWorkTime: TDateTime; EventList: TGenericDataList);
var
  ADOQuery: TADOQuery;
  strSQL: string;
  GenericData: TGenericData;
begin
  ADOQuery := NewADOQuery;
  try
    strSQL := 'Select * from TAB_Plan_RunEvent_TrainmanDetail where ' +
      'dtEventTime > %s and strTrainmanNumber = %s and (strRunEventGUID = '''' ' +
      'or strRunEventGUID is null)';
    ADOQuery.SQL.Text := Format(strSQL,[QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',
        dtBeginWorkTime)),QuotedStr(strTrainmanNumber)]);

    ADOQuery.Open();

    while not ADOQuery.Eof do
    begin
      GenericData := TGenericData.Create;
      GenericData.StrField['strGUID'] :=
          ADOQuery.FieldByName('strGUID').AsString;

      GenericData.IntField['nEventID'] :=
          ADOQuery.FieldByName('nEventID').AsInteger;

      GenericData.dtField['dtEventTime'] :=
          ADOQuery.FieldByName('dtEventTime').AsDateTime;

      GenericData.StrField['strTrainmanNumber'] :=
        ADOQuery.FieldByName('strTrainmanNumber').AsString;

      GenericData.IntField['nTMIS'] :=
        ADOQuery.FieldByName('nTMIS').AsInteger;

      GenericData.StrField['strResult'] :=
        ADOQuery.FieldByName('strResult').AsString;

      EventList.Add(GenericData);

      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TRsLocalImport.GetNeedChuQinPlan(
  RsLocalData: TRsLocalData): Boolean;
var
  strSql: string;
  ADOQuery: TADOQuery;
begin
  strSql := 'select top 1 * from VIEW_Plan_BeginWork where ' +
    ' (nPlanState = %0:d) and (strTrainmanGUID1 = %1:s or strTrainmanGUID2 = %1:s ' +
    ' or strTrainmanGUID3 = %1:s) AND dtStartTime < %2:s  and dtStartTime > %3:s order by dtStartTime ASC';

  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := Format(strSql,[ord(psPublish),
        QuotedStr(RsLocalData.GenericData.StrField['strTrainmanGUID']),
        QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',IncHour(RsLocalData.EventTime,3))),
        QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',IncHour(RsLocalData.EventTime,-3)))]);
    ADOQuery.Open();

    Result := ADOQuery.RecordCount > 0;

    if Result then
    begin
      RsLocalData.GenericData.StrField['strTrainPlanGUID'] := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
    end;


    
  finally
    ADOQuery.Free;
  end;
end;

function TRsLocalImport.GetNeedTuiQinPlan(RsLocalData: TRsLocalData): Boolean;
var
  strSql: string;
  ADOQuery: TADOQuery;
begin
  strSql := 'select top 1 * from VIEW_Plan_EndWork where' +
    ' nPlanState = %0:d AND (strTrainmanGUID1 = %1:s or strTrainmanGUID2 = %1:s ' +
    ' or strTrainmanGUID3 = %1:s) AND dtStartTime < %2:s order by dtStartTime desc';

  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := Format(strSql,[ord(psBeginWork),
        QuotedStr(RsLocalData.GenericData.StrField['strTrainmanGUID']),
        QuotedStr(FormatDateTime('yyyy-mm-dd hh:nn:ss',RsLocalData.EventTime))]);
    ADOQuery.Open();

    Result := ADOQuery.RecordCount > 0;

    if Result then
    begin
      RsLocalData.GenericData.StrField['strTrainPlanGUID'] := ADOQuery.FieldByName('strTrainPlanGUID').AsString;
    end;


    
  finally
    ADOQuery.Free;
  end;
end;

procedure TRsLocalImport.HandleBeginWorkData(RsLocalData: TRsLocalData);
var
  TrainmanPlan: RRsTrainmanPlan;
  RsDrink: RRsDrink;
begin
  RsLocalData.GenericData.bField['bDeal'] := False;
  if GetNeedChuQinPlan(RsLocalData) then
  begin
    if not m_DBTrainPlan.GetTrainmanPlan(RsLocalData.GenericData.StrField['strTrainPlanGUID'],TrainmanPlan) then
      Exit;

    RsDrink.strTrainmanGUID := RsLocalData.GenericData.StrField['strTrainmanGUID'];
    RsDrink.nDrinkResult := RsLocalData.GenericData.IntField['nDrinkResult'];
    RsDrink.strPictureURL := m_DrinkImage.Post(RsLocalData.GenericData.StrField['strTrainmanNumber'],RsLocalData.Stream);



    m_DBTrainPlanWork.BeginWork(RsLocalData.GenericData.StrField['strTrainmanGUID'],TrainmanPlan,
      TRsRegisterFlag(RsLocalData.GenericData.IntField['nVerifyID']),RsDrink,
      RsLocalData.GenericData.StrField['strDutyUserGUID'],
      m_strStationGUID,RsLocalData.EventTime);

    RsLocalData.GenericData.bField['bDeal'] := True;
  end;
end;


procedure TRsLocalImport.HandleDataList(LocalDataList: TRsLocalDataList);
var
  i: Integer;
begin
  for I := 0 to LocalDataList.Count - 1 do
  begin
    Progress(LocalDataList.Count,i+1);
    case LocalDataList.Items[i].DataType of
      ldtBeginWorkRecord: HandleBeginWorkData(LocalDataList.Items[i]);
      ldtEndWorkRecord: HandleEndWorkData(LocalDataList.Items[i]);
      ldtDrinkTest: HandleForiegnTestData(LocalDataList.Items[i]);
    end;
    if LocalDataList.Items[i].GenericData.bField['bDeal'] then
    begin
      if LocalDataList.Items[i].DataType <> ldtDrinkTest then
        PostEvent(LocalDataList.Items[i]);
    end;

  end;
end;

procedure TRsLocalImport.HandleEndWorkData(RsLocalData: TRsLocalData);
var
  TrainmanPlan: RRsTrainmanPlan;
  RsDrink: RRsDrink;
begin
  RsLocalData.GenericData.bField['bDeal'] := False;
  if GetNeedTuiQinPlan(RsLocalData) then
  begin
    if not m_DBTrainPlan.GetTrainmanPlan(RsLocalData.GenericData.StrField['strTrainPlanGUID'],TrainmanPlan) then
      Exit;

    RsDrink.strTrainmanGUID := RsLocalData.GenericData.StrField['strTrainmanGUID'];
    RsDrink.nDrinkResult := RsLocalData.GenericData.IntField['nDrinkResult'];
    RsDrink.dtCreateTime := RsLocalData.EventTime;
    RsDrink.strPictureURL := m_DrinkImage.Post(RsLocalData.GenericData.StrField['strTrainmanNumber'],RsLocalData.Stream);

    
    m_DBTrainPlanWork.EndWork(RsLocalData.GenericData.StrField['strTrainmanGUID'],TrainmanPlan,
      TRsRegisterFlag(RsLocalData.GenericData.IntField['nVerifyID']),RsDrink,
      RsLocalData.GenericData.StrField['strDutyUserGUID'],
      m_strStationGUID,RsLocalData.EventTime,RsLocalData.EventTime);

    RsLocalData.GenericData.bField['bDeal'] := True;
  end;
end;



procedure TRsLocalImport.HandleForiegnTestData(RsLocalData: TRsLocalData);
var
  DrinkInfo: RRsDrink;
begin
  with RsLocalData do
  begin
    GenericData.bField['bDeal'] := False;
    DrinkInfo.nDrinkResult := GenericData.IntField['nDrinkResult'];
    DrinkInfo.nVerifyID := GenericData.IntField['nVerifyID'];
        DrinkInfo.strPictureURL := m_DrinkImage.Post(GenericData.StrField['strTrainmanGUID'],
            RsLocalData.Stream);
    m_DBTrainPlanWork.AddForeignDrink(GenericData.StrField['strTrainmanGUID'],
      DrinkInfo,m_strDutyGUID,uSaftyEnum.rfInput);
    GenericData.bField['bDeal'] := True;
  end;
end;

function TRsLocalImport.NewADOQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := m_ServerConnection;
end;

function TRsLocalImport.NewLocalQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := m_LocalConnection;
end;

procedure TRsLocalImport.PostEvent(RsLocalData: TRsLocalData);
var
  CWYEvent: RRSCWYEvent;
  EventList: TGenericDataList;
  I: Integer;
begin
  EventList := TGenericDataList.Create;
  try
    CWYEvent.etime := RsLocalData.EventTime;
    CWYEvent.tmid := RsLocalData.GenericData.StrField['strTrainmanNumber'];
    CWYEvent.tmname := RsLocalData.GenericData.StrField['strTrainmanName'];
    CWYEvent.stmis := m_nTmis;
    CWYEvent.nVerify := RsLocalData.GenericData.IntField['nVerifyID'];

    case RsLocalData.DataType of
      ldtBeginWorkRecord:
        begin
          CWYEvent.sjbz := cweBeginWork;

          GetTrainEventDetail(CWYEvent.tmid,CWYEvent.etime,EventList);
          for I := 0 to EventList.Count - 1 do
          begin
            PostTrainEvent(EventList.Items[i]);
          end;
          GetTrainmanEventDetail(CWYEvent.tmid,CWYEvent.etime,EventList);
          for I := 0 to EventList.Count - 1 do
          begin
            PostTrainmanEvent(EventList.Items[i]);
          end;
          
          m_DBInterface.SaveWorkBeginEvent(CWYEvent);
        end;
      ldtEndWorkRecord:
        begin
          CWYEvent.sjbz := cweEndWork;
          m_DBInterface.SaveWorkEndEvent(CWYEvent);
        end;
    end;
  finally
    EventList.Free;
  end;

end;

procedure TRsLocalImport.PostTrainEvent(EventData: TGenericData);
var
  JCEvent: RRSJCEvent;
begin
  JCEvent.etime := EventData.dtField['dtEventTime'];
  JCEvent.tmid1 := EventData.StrField['strTrainmanNumber1'];
  JCEvent.tmid2 := EventData.StrField['strTrainmanNumber2'];
  JCEvent.stmis := EventData.IntField['nTMIS'];
  JCEvent.cx := EventData.strField['strTrainTypeName'];
  JCEvent.ch := EventData.StrField['strTrainNumber'];
  JCEvent.cc := EventData.StrField['strTrainNo'];

  case TRunEventType(EventData.IntField['nEventID']) of
    eteEnterStation: JCEvent.sjbz := jceTingChe;
    eteLeaveStation:JCEvent.sjbz := jceKaiChe;
    eteOutDepots:JCEvent.sjbz := jceChuKu;
    eteInDepots:JCEvent.sjbz := jceRuKu;
  end;

  DoubleTrainmanEvent(EventData.StrField['strGUID'],JCEvent);
end;

procedure TRsLocalImport.PostTrainmanEvent(EventData: TGenericData);
var
  CWYEvent: RRSCWYEvent;
begin
  CWYEvent.etime := EventData.dtField['dtEventTime'];
  CWYEvent.tmid := EventData.StrField['strTrainmanNumber'];
  CWYEvent.tmname := EventData.StrField['strTrainmanName'];
  CWYEvent.stmis := EventData.IntField['nTMIS'];
  CWYEvent.nVerify := EventData.IntField['nVerifyID'];
  CWYEvent.strResult := EventData.StrField['strResult'];
  
  SingleTrainmanEvent(EventData.StrField['strGUID'],TRunEventType(EventData.IntField['nEventID']),CWYEvent);
end;

procedure TRsLocalImport.Progress(nMax, nPosition: Integer);
begin
  if Assigned(m_OnReadChangeEvent) then
    m_OnReadChangeEvent(nMax,nPosition);
end;

procedure TRsLocalImport.SignLocalRecord(LocalDataList: TRsLocalDataList);
var
  i: Integer;
  strTableName: string;
  strKeyName: string;
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewLocalQuery;
  try
    for I := 0 to LocalDataList.Count - 1 do
    begin
      Progress(LocalDataList.Count,i+1);
      if not LocalDataList.Items[i].GenericData.bField['bDeal'] then
        Continue;
        
      case LocalDataList.Items[i].DataType of
        ldtBeginWorkRecord:
          begin
            strTableName := 'TAB_Plan_BeginWork';
            strKeyName := 'strBeginWorkGUID';
          end;
        ldtEndWorkRecord:
          begin
            strTableName := 'TAB_Plan_EndWork';
            strKeyName := 'strEndWorkGUID';
          end;
        ldtDrinkTest:
          begin
            strTableName := 'TAB_Drink_Information';
            strKeyName := 'strGUID';
          end;
      end;
      ADOQuery.SQL.Text := 'update %s set nFlag = 1 where %s = %s';

      ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[strTableName,strKeyName,
        QuotedStr(LocalDataList.Items[i].GUID)]);

      ADOQuery.ExecSQL;

    end;
  finally
    ADOQuery.Free;
  end;

end;

procedure TRsLocalImport.SingleTrainmanEvent(strDetailGUID: string;EventID: TRunEventType;
  CWYEvent: RRSCWYEvent);
var
  recordGUID : string;
  nResult : integer;
  strResult : string;
begin
  recordGUID := '';
  nResult := 0;
  strResult := '';
  try
      recordGUID := m_DBRunEvent.TrainmanSubmit(CWYEvent.etime,CWYEvent.tmid,
        CWYEvent.stmis,1, CWYEvent.nresult, CWYEvent.strResult, EventID, nResult);
  except on e : exception do
    begin
      nResult := 2;
      strResult := e.message;
    end;
  end;
  if (nResult = 0) then
  begin
    UpdateTrainmanDetail(strDetailGUID,recordGUID);
    strResult := '添加成功';
  end;
end;

procedure TRsLocalImport.SortDataListByTime(
  LocalDataList: TRsLocalDataList);
begin
  LocalDataList.Sort(CompareLocalData);
end;

procedure TRsLocalImport.ImportData(LocalDataList: TRsLocalDataList);
begin
  HandleDataList(LocalDataList);
  SignLocalRecord(LocalDataList); 
end;

procedure TRsLocalImport.UpdateTrainDetail(strGUID, RunEventGUID: string);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'Update TAB_Plan_RunEvent_TrainDetail set strRunEventGUID = %s where strGUID = %s';

    ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[QuotedStr(RunEventGUID),QuotedStr(strGUID)]);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;
procedure TRsLocalImport.UpdateTrainmanDetail(strGUID,
  RunEventGUID: string);
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := NewADOQuery;
  try
    ADOQuery.SQL.Text := 'Update TAB_Plan_RunEvent_TrainmanDetail set strRunEventGUID = %s where strGUID = %s';

    ADOQuery.SQL.Text := Format(ADOQuery.SQL.Text,[QuotedStr(RunEventGUID),QuotedStr(strGUID)]);
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

{ TRsLocalDataList }

function TRsLocalDataList.GetItem(Index: Integer): TRsLocalData;
begin
  Result := TRsLocalData(inherited GetItem(Index));
end;

procedure TRsLocalDataList.SetItem(Index: Integer; AObject: TRsLocalData);
begin
  inherited SetItem(Index,AObject);
end;

{ TRsLocalData }

constructor TRsLocalData.Create;
begin
  m_GenericData := TGenericData.Create;
  m_Stream := TMemoryStream.Create;
end;

destructor TRsLocalData.Destroy;
begin
  m_GenericData.Free;
  m_Stream.Free;
  inherited;
end;


end.
