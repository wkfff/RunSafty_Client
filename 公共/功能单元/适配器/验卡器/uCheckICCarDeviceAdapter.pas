unit uCheckICCarDeviceAdapter;

interface
uses
  uTFSystem,SysUtils,Classes,uCheckICCarRecord,uDBTrainman,ADODB,DB;
type
  /////////////////////////////////
  /// ����:TCheckICCarDeviceAdapter
  /// ˵��:�鿨���豸��
  /////////////////////////////////
  TCheckICCarDeviceAdapter = Class(TDBOperate)
  public
    constructor Create(ADOConnection:TADOConnection);override;
    destructor Destroy();override;
  private
    {�鿨����������Connection}
    m_CheckICCarDeviceConnection : TADOConnection;
    {�鿨��Query}
    m_CheckICCarDeviceQuery : TADOQuery;
    {�鿨���������Ӳ���}
    m_CheckJSSQLServerConfig : RSQLServerConfig;
  private
    procedure SetCheckJSSQLServerConfig(SQLConfig:RSQLServerConfig);
  public
    {����:��ȡ�鿨���е����½�ʾ}
    procedure GetNewCheckICCarRecordByMaxID(nMaxRecordID:Integer;
        var CheckICCarRecordList : TCheckICCarRecordList);
  public
    {������ID}
    AreaGUID : String;
    property CheckJSSQLServerConfig : RSQLServerConfig
        read  m_CheckJSSQLServerConfig write SetCheckJSSQLServerConfig;
  end;

implementation

{ TCheckICCarDeviceAdapter }

constructor TCheckICCarDeviceAdapter.Create(ADOConnection: TADOConnection);
begin
  inherited Create(ADOConnection);
  m_CheckICCarDeviceConnection := TADOConnection.Create(nil);
  m_CheckICCarDeviceQuery := TADOQuery.Create(nil);
  m_CheckICCarDeviceQuery.Connection := m_CheckICCarDeviceConnection;
end;

destructor TCheckICCarDeviceAdapter.Destroy;
begin
  m_CheckICCarDeviceQuery.Free;
  m_CheckICCarDeviceConnection.Free;
  inherited;
end;

procedure TCheckICCarDeviceAdapter.GetNewCheckICCarRecordByMaxID(nMaxRecordID: Integer;
    var CheckICCarRecordList: TCheckICCarRecordList);
{����:��ȡ�鿨���е����½�ʾ}
var
  Item : TCheckICCarRecord;
  DBTrainman : TDBTrainman;
  nTrainmanNumber : Integer;
  strTrainmanGUID : String;
  strText : String;
  strDate,strTime : String;
  dtCreateTime : TDateTime;
begin
  m_CheckICCarDeviceConnection.Open();
  m_CheckICCarDeviceQuery.SQL.Text := 'Select * from ExamRst where ID > ' +
      IntToStr(nMaxRecordID);
  m_CheckICCarDeviceQuery.Open;

  CheckICCarRecordList.Clear;
  DBTrainman := TDBTrainman.Create(m_ADOConnection);
  try
    while m_CheckICCarDeviceQuery.Eof = False do
    begin
      strText := m_CheckICCarDeviceQuery.FieldByName('Gonghao').AsString;
      if TryStrToInt(strText,nTrainmanNumber) = False then
      begin
        m_CheckICCarDeviceQuery.Next;
        Continue;
      end;
      strDate := m_CheckICCarDeviceQuery.FieldByName('TestDate').AsString;
      strTime := m_CheckICCarDeviceQuery.FieldByName('TestTime').AsString;
      if TryStrToDateTime(strDate +' '+ strTime,dtCreateTime) = False then
      begin
        m_CheckICCarDeviceQuery.Next;
        Continue;
      end;
      if DBTrainman.GetTrainmanGUIDByNumber(nTrainmanNumber,strTrainmanGUID) = False then
      begin
        m_CheckICCarDeviceQuery.Next;
        Continue;
      end;
      Item := TCheckICCarRecord.Create;
      Item.GUID := NewGUID();
      Item.strTrainmanGUID := strTrainmanGUID;
      Item.dtCreateTime := dtCreateTime;
      Item.strCheckResult := m_CheckICCarDeviceQuery.FieldByName('TestRst').AsString;
      Item.nJSCount := m_CheckICCarDeviceQuery.FieldByName('JieShiCount').AsInteger;
      Item.nTsJsCount := m_CheckICCarDeviceQuery.FieldByName('SpecialCount').AsInteger;
      Item.strAreaGUID := AreaGUID;
      Item.nRecordID := m_CheckICCarDeviceQuery.FieldByName('ID').AsInteger;
      CheckICCarRecordList.Add(Item);
      m_CheckICCarDeviceQuery.Next;
    end;
  finally
    m_CheckICCarDeviceConnection.Close;
    m_CheckICCarDeviceQuery.Close;
    DBTrainman.Free;
  end;
end;

procedure TCheckICCarDeviceAdapter.SetCheckJSSQLServerConfig(
  SQLConfig: RSQLServerConfig);
begin
  m_CheckJSSQLServerConfig := SQLConfig;
  m_CheckICCarDeviceConnection.ConnectionString :=
      GenerateSQLConnectionString(SQLConfig);
end;

end.
