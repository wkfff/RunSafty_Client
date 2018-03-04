unit uDBTrainNo;

interface

uses SysUtils,Windows,Classes,ADODB,DB,uTrainman,ZKFPEngXUtils,Variants,
    uTFSystem,uTrainNo;

type
  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TDBTrainNo
  /// 说明:车次数据操作类
  //////////////////////////////////////////////////////////////////////////////
  TDBTrainNo = class(TDBOperate)
  private
    {功能:将数据拷贝到对象中}
    procedure CopyDataToObject(ADOQuery:TADOQuery;Item:TTrainNo);
    {功能:将数据拷贝到数据源中}
    procedure CopyDataToDB(ADOQuery:TADOQuery;Item:TTrainNo);
  public
    {功能:判断车次信息是否存在}
    function TrainNoExist(strTrainNo,strAreaGUID:String) : Boolean;
    {功能:根据ID判断记录是否存在}
    function TrainNoExistByGUID(strGUID:String):Boolean;
    {功能:根据车次号获得车次详细信息}
    function GetTrainNo(strTrainNo,strAreaGUID : String ;
        var TrainNo:TTrainNo):Boolean;
    {功能:根据车次GUID获得车次详细信息}
    function GetTrainNoByGUID(strGUID:String;var TrainNo:TTrainNo):Boolean;
    {功能:获取车次列表}
    procedure GetTrainNoList(strAreaGUID:String;var TrainNoList:TTrainNoList);
    {功能:保存车次信息}
    procedure SaveTrainNo(TrainNo:TTrainNo);
    {功能:根据GUID删除车次信息}
    procedure DeleteTrainNoByGUID(strGUID:String);
    {功能:根据车次号删除车次信息}
    procedure DeleteTrainNo(strTrainNo,strAreaGUID:String);
  end;
implementation

{ TDBTrainNo }

procedure TDBTrainNo.CopyDataToDB(ADOQuery: TADOQuery; Item: TTrainNo);
{功能:将数据拷贝到数据源中}
begin
  ADOQuery.FieldByName('strGUID').AsString := Item.strGUID;
  ADOQuery.FieldByName('strTrainNo').AsString := Item.strTrainNo;
  ADOQuery.FieldByName('strSectionName').AsString := Item.strSectionName;
  ADOQuery.FieldByName('strJiaoLuNumber').AsString := Item.strJiaoLuNumber;
  ADOQuery.FieldByName('strCheZhanNumber').AsString := Item.strCheZhanNumber;
  ADOQuery.FieldByName('dtRestTime').AsDateTime := Item.dtRestTime;
  ADOQuery.FieldByName('dtCallTime').AsDateTime := Item.dtCallTime;
  ADOQuery.FieldByName('dtOutDutyTime').AsDateTime := Item.dtOutDutyTime;
  ADOQuery.FieldByName('dtStartTime').AsDateTime := Item.dtStartTime;
  ADOQuery.FieldByName('nTrainmanTypeID').AsInteger := Item.nTrainmanTypeID;
  ADOQuery.FieldByName('nIsEnforceRest').AsInteger := Item.nIsEnforceRest;
  ADOQuery.FieldByName('strAreaGUID').AsString := Item.strAreaGUID;
  ADOQuery.FieldByName('dtCreateTime').AsDateTime := Item.dtCreateTime;
  ADOQuery.FieldByName('nIsEnforceRest').AsInteger := Item.nIsEnforceRest;
  ADOQuery.FieldByName('strKeHuo').AsString := Item.strKeHuo;
  ADOQuery.FieldByName('strStartStation').AsString := Item.strStartStation;
  ADOQuery.FieldByName('strEndStation').AsString := Item.strEndStation;


end;

procedure TDBTrainNo.CopyDataToObject(ADOQuery: TADOQuery; Item: TTrainNo);
{功能:将数据拷贝到对象中}
begin
  Item.strGUID := ADOQuery.FieldByName('strGUID').AsString;
  Item.strTrainNo := ADOQuery.FieldByName('strTrainNo').AsString;
  Item.strSectionName := ADOQuery.FieldByName('strSectionName').AsString;
  Item.strJiaoLuNumber := ADOQuery.FieldByName('strJiaoLuNumber').AsString;
  Item.strCheZhanNumber := ADOQuery.FieldByName('strCheZhanNumber').AsString;
  Item.dtRestTime := ADOQuery.FieldByName('dtRestTime').AsDateTime;
  Item.dtCallTime := ADOQuery.FieldByName('dtCallTime').AsDateTime;
  Item.dtOutDutyTime := ADOQuery.FieldByName('dtOutDutyTime').AsDateTime;
  Item.dtStartTime := ADOQuery.FieldByName('dtStartTime').AsDateTime;
  Item.nTrainmanTypeID := ADOQuery.FieldByName('nTrainmanTypeID').AsInteger;
  Item.nIsEnforceRest := ADOQuery.FieldByName('nIsEnforceRest').AsInteger;
  Item.strAreaGUID := ADOQuery.FieldByName('strAreaGUID').AsString;
  Item.dtCreateTime := ADOQuery.FieldByName('dtCreateTime').AsDateTime;
  Item.nIsEnforceRest := ADOQuery.FieldByName('nIsEnforceRest').AsInteger;
  Item.strKeHuo := ADOQuery.FieldByName('strKeHuo').AsString;
  Item.strStartStation := ADOQuery.FieldByName('strStartStation').AsString;
  Item.strEndStation := ADOQuery.FieldByName('strEndStation').AsString;
end;

procedure TDBTrainNo.DeleteTrainNo(strTrainNo,strAreaGUID: String);
{功能:根据车次号删除车次信息}
var
  ADOQuery : TADOQuery;
  strSQLText:string;
begin
  ADOQuery := NewADOQuery();
  strSQLText := 'Delete from TAB_Base_TrainNo Where strTrainNo = %s '+
      ' And strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),
      QuotedStr(strAreaGUID)]);

  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBTrainNo.DeleteTrainNoByGUID(strGUID: String);
{功能:根据GUID删除车次信息}
var
  ADOQuery : TADOQuery;
  strSQLText:string;
begin
  ADOQuery := NewADOQuery();
  strSQLText := 'Delete from TAB_Base_TrainNo  where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strGUID)]);
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

function TDBTrainNo.GetTrainNo(strTrainNo,strAreaGUID: String;
  var TrainNo: TTrainNo): Boolean;
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Base_TrainNo where strTrainNo = %s '+
      ' And strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      CopyDataToObject(ADOQuery,TrainNo);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;

function TDBTrainNo.GetTrainNoByGUID(strGUID: String;
  var TrainNo: TTrainNo): Boolean;
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select * from TAB_Base_TrainNo where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      CopyDataToObject(ADOQuery,TrainNo);
      Result := True;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBTrainNo.GetTrainNoList(strAreaGUID: String;
  var TrainNoList: TTrainNoList);
var
  ADOQuery : TADOQuery;
  strSQLText : string;
  Item : TTrainNo;
begin
  strSQLText := 'Select * from TAB_Base_TrainNo where strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    TrainNoList.Clear;
    while ADOQuery.Eof = False do
    begin
      Item := TTrainNo.Create;
      CopyDataToObject(ADOQuery,Item);
      TrainNoList.Add(Item);
      ADOQuery.Next;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBTrainNo.SaveTrainNo(TrainNo: TTrainNo);
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  if TrainNo.strGUID = '' then
    TrainNo.strGUID := NewGUID;
    
  strSQLText := 'Select * from TAB_Base_TrainNo where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(TrainNo.strGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      ADOQuery.Edit
    else
      ADOQuery.Append;
    CopyDataToDB(ADOQuery,TrainNo);
    ADOQuery.Post;
  finally
    ADOQuery.Free;
  end;

end;

function TDBTrainNo.TrainNoExist(strTrainNo,strAreaGUID: String): Boolean;
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select strGUID from TAB_Base_TrainNo where strTrainNo = %s '+
      ' And strAreaGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strTrainNo),QuotedStr(strAreaGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Free;
  end;
end;

function TDBTrainNo.TrainNoExistByGUID(strGUID: String): Boolean;
var
  ADOQuery : TADOQuery;
  strSQLText : string;
begin
  Result := False;
  strSQLText := 'Select strGUID from TAB_Base_TrainNo where strGUID = %s';
  strSQLText := Format(strSQLText,[QuotedStr(strGUID)]);
  ADOQuery := NewADOQuery();
  ADOQuery.SQL.Text := strSQLText;
  try
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
      Result := True;
  finally
    ADOQuery.Free;
  end;
end;

end.
