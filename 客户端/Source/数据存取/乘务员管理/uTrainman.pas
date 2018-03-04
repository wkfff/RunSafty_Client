unit uTrainman;

interface
uses
  Classes, SysUtils, Forms, windows, adodb, DB, ZKFPEngXControl_TLB, uTFSystem;
type
  RTrainman = record
    GUID: string;
    TrainmanNumber: string;
    TrainmanName: string;
    AreaGUID : string;
    FingerPrint1: string;
    FingerPrint2: string;
    DeleteState: Integer;
    TrainmanID : Integer;
    AreaName : string;
    public
  procedure Init;
  end;
  TTrainmanArray = array of RTrainman;
  
  TTrainmanOpt = class
  public
    class function ADOQueryToTrainman(ADOQuery: TADOQuery): RTrainMan; static;
    //��RTrainmanд�뵽���ݿ���
    class function TrainmanToADOQuery(ADOQuery:TADOQuery;TrainmanGUID : string;Trainman:RTrainMan):RTrainMan;
    //�ж�ָ�����ŵĳ���Ա�Ƿ��Ѿ�����
    class function ExistTrainman(trainmanNumber: string): boolean;
    //��ȡ���еĳ���Ա��Ϣ
    class procedure GetTrainmans(strAreaGUID,strTrainmanNumber,strTrainamName : string;FingerCount : integer;out TrainmanArray : TTrainmanArray);
    //����GUID��ȡ����Ա��Ϣ
    class function GetTrainman(guid: string): RTrainman;
    //��������ID��ȡ����Ա��Ϣ
    class function GetTrainmanByID(trainmanID : integer) : RTrainman;
    //���ݹ��Ż�ȡ����Ա��Ϣ
    class function GetTrainmanByNumber(trainmanNumber: string): RTrainman;
    //����ָ�ƻ�ȡ����Ա��Ϣ
    class function GetTrainmanByFinger(ZKFPEngX: TZKFPEngX; strFinger: OleVariant): RTrainman;
    //��ӳ���Ա
    class function AddTrainman(trainman: RTrainman): string;
    //�޸ĳ���Ա
    class function UpdateTrainman(trainman: RTrainman): boolean;
    //ɾ������Ա
    class function DeleteTrainman(guid: string): boolean;
    //��ȫɾ������Ա
    class function ClearTrainman(guid: string): boolean;
  end;
implementation

{ RTrainman }
uses
  uGlobalDM,utfsystem;

procedure RTrainman.Init;
begin
  TrainmanNumber := '';
  TrainmanName := '';
  FingerPrint1 := '';
  FingerPrint2 := '';
  DeleteState := 0;
end;

{ TTrainmanOpt }

class function TTrainmanOpt.AddTrainman(trainman: RTrainman): string;
var
  ado: TADOQuery;
  guid: string;
begin
  Result := '';
  guid := NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select * from TAB_Org_Trainman where 1=2';
      Open;
      Append;
      TrainmanToADOQuery(ado,guid,trainman);
      Post;
      result := guid;
    end;
  finally
    ado.Free;
  end;
end;

class function TTrainmanOpt.ADOQueryToTrainman(ADOQuery: TADOQuery): RTrainMan;
var
  ms : TStringStream;
begin
  with adoQuery do
  begin
    Result.GUID := FieldByName('strGUID').AsString;
    Result.TrainmanNumber := FieldByName('strTrainmanNumber').AsString;
    Result.TrainmanName := FieldByName('strTrainmanName').AsString;
    Result.AreaGUID := FieldByName('strAreaGUID').AsString;
    ms := TStringStream.Create('');
    try
      TBlobField(FieldByName('FingerPrint1')).SaveToStream(ms);
      Result.FingerPrint1 := ms.DataString;
    finally
      ms.Free;
    end;
    ms := TStringStream.Create('');
    try
      TBlobField(FieldByName('FingerPrint2')).SaveToStream(ms);
      Result.FingerPrint2 := ms.DataString;
    finally
      ms.Free;
    end;
    Result.DeleteState := FieldByName('nDeleteState').AsInteger;
    Result.TrainmanID := FieldByName('nTrainmanID').AsInteger;
    if Fields.FindField('strAreaName') <> nil then
    begin
      Result.AreaName := FieldByName('strAreaName').AsString;
    end;
  end;
end;


class function TTrainmanOpt.ClearTrainman(guid: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'delete from TAB_Org_Trainman where strGUID = %s';
      Sql.Text := Format(Sql.Text, [QuotedStr(guid)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TTrainmanOpt.TrainmanToADOQuery(ADOQuery: TADOQuery;
  TrainmanGUID: string; Trainman: RTrainMan): RTrainMan;
var
  ms : TStringStream;
begin
  with adoQuery do
  begin
    FieldByName('strGUID').AsString := TrainmanGUID;
    FieldByName('strTrainmanNumber').AsString := trainman.TrainmanNumber;
    FieldByName('strTrainmanName').AsString := trainman.TrainmanName;
    FieldByName('strAreaGUID').AsString := trainman.AreaGUID;

    ms := TStringStream.Create(trainman.FingerPrint1);
    try
      ms.Position := 0;
      TBlobField(FieldByName('FingerPrint1')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
    ms := TStringStream.Create(trainman.FingerPrint2);
    try
      ms.Position := 0;
      TBlobField(FieldByName('FingerPrint2')).LoadFromStream(ms);
    finally
      ms.Free;
    end;
    FieldByName('nDeleteState').AsInteger := trainman.DeleteState;
  end;
end;

class function TTrainmanOpt.DeleteTrainman(guid: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'update TAB_Org_Trainman set nDeleteState=0 ' +
        ' where strGUID = %s';
      Sql.Text := Format(Sql.Text, [QuotedStr(guid)]);
      Result := ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TTrainmanOpt.ExistTrainman(trainmanNumber: string): boolean;
var
  ado: TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Trainman  where strTrainmanNumber = %s';
      Sql.Text := Format(Sql.Text, [QuotedStr(trainmanNumber)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TTrainmanOpt.GetTrainman(guid: string): RTrainman;
var
  ado: TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Trainman  where strGUID = %s';
      Sql.Text := Format(Sql.Text, [QuotedStr(guid)]);
      Open;
      if RecordCount > 0 then
      begin
        Result := ADOQueryToTrainman(ado);
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TTrainmanOpt.GetTrainmanByFinger(ZKFPEngX: TZKFPEngX; strFinger: OleVariant): RTrainman;
var
  nTrainmanID : integer;
begin
  //nTrainmanID := DMGlobal.IdentificationTemplate(strFinger);
  Result := TTrainmanOpt.GetTrainmanByID(nTrainmanID);
end;

class function TTrainmanOpt.GetTrainmanByID(trainmanID: integer): RTrainman;
var
  ado: TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Trainman  where nTrainmanID = %d';
      Sql.Text := Format(Sql.Text, [trainmanID]);
      Open;
      if RecordCount > 0 then
      begin
        Result := ADOQueryToTrainman(ado);
      end;
    end;
  finally
    ado.Free;
  end;

end;

class function TTrainmanOpt.GetTrainmanByNumber(
  trainmanNumber: string): RTrainman;
var
  ado: TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_Trainman  where strTrainmanNumber = %s';
      Sql.Text := Format(Sql.Text, [QuotedStr(trainmanNumber)]);
      Open;
      if RecordCount > 0 then
      begin
        Result := ADOQueryToTrainman(ado);
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TTrainmanOpt.GetTrainmans(strAreaGUID,strTrainmanNumber,strTrainamName : string;FingerCount : integer;out TrainmanArray : TTrainmanArray);
var
  adoQuery : TADOQuery;
  i : integer;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select * from VIEW_Org_Trainman  where 1=1 ';
      if strAreaGUID <> '' then
      begin
        Sql.Text := Sql.Text + ' and strAreaGUID=%s ';
        Sql.Text := Format(Sql.Text,[QuotedStr(strAreaGUID)]);
      end;
      if strTrainmanNumber <> '' then
      begin
        Sql.Text := Sql.Text + ' and strTrainmanNumber = %s ';
        Sql.Text := Format(Sql.Text,[QuotedStr(strTrainmanNumber)]);
      end;
      if strTrainamName <> '' then
      begin
        Sql.Text := Sql.Text + ' and strTrainmanName like %s ';
        Sql.Text := Format(Sql.Text,[QuotedStr('%' + strTrainamName+ '%') ]);
      end;
      if FingerCount = 0 then
      begin
        Sql.Text := Sql.Text + ' and ((FingerPrint1 is null) and (FingerPrint2 is null)) ';
        Sql.Text := Format(Sql.Text,[QuotedStr('%' + strTrainamName+ '%') ]);
      end;

      if FingerCount = 1 then
      begin
        Sql.Text := Sql.Text + ' and ((FingerPrint1 is null) and not(FingerPrint2 is null)) or (not(FingerPrint1 is null) and (FingerPrint2 is null)) ';
        Sql.Text := Format(Sql.Text,[QuotedStr('%' + strTrainamName+ '%') ]);
      end;

      if FingerCount = 2 then
      begin
        Sql.Text := Sql.Text + ' and (not(FingerPrint1 is null) and not(FingerPrint2 is null)) ';
        Sql.Text := Format(Sql.Text,[QuotedStr('%' + strTrainamName+ '%') ]);
      end;
      Sql.Text := Sql.Text + ' order by strAreaName,strTrainmanName';
      Open;
      i := 0;
      SetLength(TrainmanArray,RecordCount);
      while not eof do
      begin
        TrainmanArray[i] := ADOQueryToTrainman(adoQuery);
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class function TTrainmanOpt.UpdateTrainman(trainman: RTrainman): boolean;
var
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Sql.Text := 'select * from TAB_Org_Trainman where strGUID=%s';      
      Sql.Text := Format(Sql.Text,[QuotedStr(trainman.GUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Edit;
        TrainmanToADOQuery(adoQuery,trainman.GUID,trainman);
        Post;
        result := true;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.

