unit uDBTrainman;

interface

uses
  SysUtils,Windows,Classes,ADODB,DB,uTrainman,ZKFPEngXUtils,Variants,
  uTFSystem,ZKFPEngXControl_TLB;

type

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TRelatiionDB
  /// 说明:组织结果操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBTrainman = class(TObject)
  public
    constructor Create(ADOConnection : TADOConnection);
    destructor Destroy();override;
  protected
    m_ADOConnection : TADOConnection;
    {功能:将数据源中的内容拷贝到乘务员对象中}
    procedure LoadTrainman(Trainman:TTrainman;ADOQuery : TADOQuery);
    {功能:将乘务员对象信息拷贝到数据源中}
    procedure SaveTrainmanToDB(Trainman:TTrainman;ADOQuery : TADOQuery);
  public
    {功能:根据GUID获取乘务员信息}
    function GetTrainmanByGUID(strGUID: string;
        var Trainman:TTrainman):Boolean;

    {功能:根据工号获取乘务员信息}
    function GetTrainmanByNumber(strTrainmanNumber: String;
        var Trainman:TTrainman): Boolean;overload;

    {功能:根据工号获取乘务员信息}
    function GetTrainmanByNumber(nTrainmanNumber: Integer;
        var Trainman:TTrainman): Boolean;overload;

    {功能:根据工号获取乘务员GUID}
    function GetTrainmanGUIDByNumber(nTrainmanNumber: Integer;
        var strTrainmanNumber:String):Boolean;


    {功能:根据ID获取乘务员信息}
    function GetTrainmanByID(nID: Integer;
        var Trainman:TTrainman): Boolean;overload;

    {功能:获取全部的乘务员信息}
    procedure GetTrainmans(var TrainmanList:TTrainmanList);

    {功能:保存乘务员信息}
    procedure SaveTrainman(Trainman:TTrainman);
  public
    {功能:删除乘务员}
    procedure DeleteTrainman(strGUID :String);
    {功能:判断指定工号的乘务员是否已经存在}
    function ExistTrainmanByNumber(strTrainmanNumber : String): Boolean;
  end;

implementation

{ TTrainmanDB }

constructor TDBTrainman.Create(ADOConnection: TADOConnection);
begin
  m_ADOConnection := ADOConnection;
end;

procedure TDBTrainman.DeleteTrainman(strGUID: String);
{功能:删除乘务员}
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  strSQLText := 'Delete From TAB_Org_Trainman '+
      'Where strGUID = %s';
  strSQLText := Format(strSQLText, [QuotedStr(strGUID)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQUERY.Connection := m_ADOConnection;
    adoQUERY.SQL.Text := strSQLText;
    adoQUERY.ExecSQL;;
  finally
    adoQuery.Free;
  end;
end;

destructor TDBTrainman.Destroy;
begin
  inherited;
end;

function TDBTrainman.ExistTrainmanByNumber(strTrainmanNumber: String): Boolean;
{功能:判断指定工号的乘务员是否已经存在}
var
  strSQLText : String;
   adoQuery : TADOQuery; 
begin
  strSQLText := 'Select Top 1 strGUID From VIEW_Org_Trainman '+
      'Where strTrainmanNumber = %s';
  strSQLText := Format(strSQLText, [QuotedStr(strTrainmanNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQUERY.Connection := m_ADOConnection;
    adoQUERY.SQL.Text := strSQLText;
    adoquery.Open;
    Result := adoQUERY.RecordCount > 0;
  finally
    adoQuery.Free;
  end;
end;



function TDBTrainman.GetTrainmanByGUID(strGUID: string;
  var Trainman: TTrainman): Boolean;
{功能:根据GUID获取乘务员信息}
var
  strSQLText : String;
  adoQUERY : TADOQuery;
begin
  Result := False;
  strSQLText := 'Select Top 1 * From VIEW_Org_Trainman '+
      'Where strGUID = %s';
  strSQLText := Format(strSQLText, [QuotedStr(strGUID)]);
  adoQUERY := TADOQuery.Create(nil);
  try
    adoQUERY.Connection := m_ADOConnection;
    adoQUERY.SQL.Text := strSQLText;
    adoQUERY.Open;
    if adoQUERY.RecordCount > 0 then
    begin
      LoadTrainman(Trainman,adoQUERY);
      Result := True;
    end;
  finally
    adoQUERY.Free;
  end;
end;

function TDBTrainman.GetTrainmanByID(nID: Integer;
  var Trainman: TTrainman): Boolean;
{功能:根据ID获取乘务员信息}
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSQLText := 'Select Top 1 * From VIEW_Org_Trainman Where nID = %d';
  strSQLText := Format(strSQLText, [nID]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSQLText;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      LoadTrainman(Trainman,adoQuery);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;


end;

function TDBTrainman.GetTrainmanByNumber(nTrainmanNumber: Integer;
  var Trainman: TTrainman): Boolean;
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSQLText := 'Select Top 1 * From VIEW_Org_Trainman '+
      'Where CAST(strTrainmanNumber As int) = %d';
  strSQLText := Format(strSQLText, [nTrainmanNumber]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSQLText;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      LoadTrainman(Trainman,ADOQuery);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBTrainman.GetTrainmanGUIDByNumber(nTrainmanNumber: Integer;
  var strTrainmanNumber: String): Boolean;
{功能:根据工号获取乘务员GUID}
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSQLText := 'Select Top 1 strGUID From VIEW_Org_Trainman '+
      'Where CAST(strTrainmanNumber As int) = %d';
  strSQLText := Format(strSQLText, [nTrainmanNumber]);
  adoQuery := TADOQuery.Create(nil);
  try
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSQLText;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      strTrainmanNumber :=  adoQuery.Fields[0].AsString;
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;

end;

function TDBTrainman.GetTrainmanByNumber(strTrainmanNumber: String;
  var Trainman: TTrainman): Boolean;
{功能:根据工号获取乘务员信息}
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  Result := False;
  strSQLText := 'Select Top 1 * From VIEW_Org_Trainman '+
      'Where strTrainmanNumber = %s';
  adoQuery := TADOQuery.Create(m_ADOConnection);
  try
    strSQLText := Format(strSQLText, [QuotedStr(strTrainmanNumber)]);
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSQLText;
    adoQuery.Open;
    if adoQuery.RecordCount > 0 then
    begin
      LoadTrainman(Trainman,ADOQuery);
      Result := True;
    end;
  finally
    adoQuery.Free;
  end;
end;

procedure TDBTrainman.LoadTrainman(Trainman: TTrainman;ADOQuery : TADOQuery);
var
  StreamObject : TMemoryStream;
begin
  Trainman.nID := ADOQuery.FieldByName('nID').AsInteger;
  Trainman.GUID := ADOQuery.FieldByName('strGUID').AsString;
  Trainman.TrainmanNumber := ADOQuery.FieldByName('strTrainmanNumber').AsString;
  Trainman.TrainmanName := ADOQuery.FieldByName('strTrainmanName').AsString;
  Trainman.Duty := ADOQuery.FieldByName('strDuty').AsString;
  StreamObject := TMemoryStream.Create;
  try
    {读取指纹1}
    if ADOQuery.FieldByName('FingerPrint1').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint1 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;

    {读取指纹2}
    if ADOQuery.FieldByName('FingerPrint2').IsNull = False then
    begin
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).SaveToStream(StreamObject);
      Trainman.FingerPrint2 := StreamToTemplateOleVariant(StreamObject);
      StreamObject.Clear;
    end;
    
    {读取照片}
    if ADOQuery.FieldByName('Picture').IsNull = False then
    begin
      Trainman.Picture.Position := 0;
      (ADOQuery.FieldByName('Picture') As TBlobField).SaveToStream(Trainman.Picture);
    end;
    
    Trainman.TelNumber := ADOQuery.FieldByName('strTelNumber').AsString;
    Trainman.Remark := ADOQuery.FieldByName('strRemark').AsString;
    Trainman.RelationID := ADOQuery.FieldByName('strRelationID').AsString;
  finally
    StreamObject.Free;
  end;
end;

procedure TDBTrainman.SaveTrainman(Trainman: TTrainman);
{功能:保存乘务员信息}
var
  strSQLText : String;
  adoQuery : TADOQuery;
begin
  if Trainman.GUID = '' then
    Trainman.GUID := NewGUID();

  strSQLText := 'Select Top 1 * From TAB_Org_Trainman '+
      'Where strGUID = %s';
  adoQuery := TADOQuery.Create(nil);
  try
    strSQLText := Format(strSQLText, [QuotedStr(Trainman.GUID)]);
    adoQuery.Connection := m_ADOConnection;
    adoQuery.SQL.Text := strSQLText;
    adoQuery.Open;
    if adoQuery.RecordCount = 0 then
      adoQuery.Append
    else
      adoQuery.Edit;
    SaveTrainmanToDB(Trainman,adoQuery);
    adoQuery.Post;
  finally
    adoQuery.Free;
  end;
end;

procedure TDBTrainman.SaveTrainmanToDB(Trainman: TTrainman;ADOQuery : TADOQuery);
var
  StreamObject : TMemoryStream;
begin
  ADOQuery.FieldByName('strGUID').AsString := Trainman.GUID;
  ADOQuery.FieldByName('strTrainmanNumber').AsString := Trainman.TrainmanNumber;
  ADOQuery.FieldByName('strTrainmanName').AsString := Trainman.TrainmanName;
  ADOQuery.FieldByName('strDuty').AsString := Trainman.Duty;
  StreamObject := TMemoryStream.Create;
  try

    {保存指纹1}
    if Trainman.FingerPrint1 <> unassigned then
    begin
      TemplateOleVariantToStream(Trainman.FingerPrint1,StreamObject);
      StreamObject.Position := 0;
      (ADOQuery.FieldByName('FingerPrint1') As TBlobField).LoadFromStream(StreamObject);
    end;

    {保存指纹2}
    if Trainman.FingerPrint2 <> unassigned then
    begin
      TemplateOleVariantToStream(Trainman.FingerPrint2,StreamObject);
      StreamObject.Position := 0;
      (ADOQuery.FieldByName('FingerPrint2') As TBlobField).LoadFromStream(StreamObject);
    end;

    {保存照片}

    Trainman.Picture.Position := 0;
    (ADOQuery.FieldByName('Picture') As TBlobField).LoadFromStream(Trainman.Picture);

    ADOQuery.FieldByName('strTelNumber').AsString := Trainman.TelNumber;
    ADOQuery.FieldByName('strRemark').AsString := Trainman.Remark;
    ADOQuery.FieldByName('strRelationID').AsString := Trainman.RelationID;
  finally
    StreamObject.Free;
  end;
end;

procedure TDBTrainman.GetTrainmans(var TrainmanList: TTrainmanList);
var
  strSQLText : String;
  Trainman : TTrainman;
  ADOQuery : TADOQuery;
begin
  strSQLText := 'Select * From VIEW_Org_Trainman ';
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.Connection := m_ADOConnection;
    ADOQuery.SQL.Text := strSQLText;
    ADOQuery.Open;
    while ADOQuery.Eof = False do
    begin
      Trainman := TTrainman.Create;
      LoadTrainman(Trainman,ADOQuery);
      TrainmanList.Add(Trainman);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
