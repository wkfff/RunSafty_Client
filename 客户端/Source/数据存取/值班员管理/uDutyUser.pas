unit uDutyUser;

interface
uses
  Classes,SysUtils,Forms,windows,adodb;
type
  //////////////////////////////////////////////////////////////////////////////
  //ֵ��Ա��Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RDutyUser = record
    DutyGUID : string;      //ֵ��ԱGUID
    DutyNumber : string;    //ֵ��Ա����
    DutyName : string;      //ֵ��Ա����
    DutyPWD : string;       //ֵ��Ա����
    DeleteState : integer;  //�ʺ�״̬
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///ֵ��Ա��Ϣ������
  //////////////////////////////////////////////////////////////////////////////
  TDutyUserOpt = class
  public
    //�Ƿ��Ѿ�����ָ����ֵ��Ա����
    class function ExistDutyUser(dutyNumber:string) : boolean;
    //���ݹ��Ż�ȡֵ��Ա��Ϣ
    class function GetDutyUser(dutyNumber:string) : RDutyUser;
    //���ݱ�Ż�ȡֵ��Ա��Ϣ
    class function GetDutyUserByGUID(dutyGUID:string) : RDutyUser;
    //��ȡ����ֵ��Ա��Ϣ
    class PROCEDURE GetDutyUsers(out Rlt: TADOQuery);
    //���ֵ��Ա
    class function AddDutyUser(dutyUser:RDutyUser):string;
    //�޸�ֵ��Ա
    class function UpdateDutyUser(dutyUser:RDutyUser):boolean;
    //ɾ��ֵ��Ա
    class function DeleteDutyUser(dutyGUID:string):boolean;
    //���ֵ��Ա����
    class function ClearPWD(dutyGUID:string):boolean;
    //��������
    class function ResetPWD(dutyGUID,newPWD:string):boolean;
  end;
implementation

{ TDutyUserOpt }
uses
  udataModule;
class function TDutyUserOpt.AddDutyUser(dutyUser: RDutyUser): string;
var
  guid : string;
  ado : TADOQuery;
begin
  Result := '';
  guid := TDMGlobal.NewGUID;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'insert into Tab_Org_DutyUser (strDutyGUID,strDutyNumber,'+
        ' strDutyName,strPassword,nDeleteState) values '+
        ' (%s,%s,%s,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(guid),QuotedStr(dutyUser.DutyNumber),
        QuotedStr(dutyUser.DutyName),
        QuotedStr(''),1]);
      if ExecSQL > 0 then
      begin
        Result := guid;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class function TDutyUserOpt.ClearPWD(dutyGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update Tab_Org_DutyUser set strPassword = %s where ' +
        'strDutyGUID=%s ' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(''),QuotedStr(dutyGUID)]);
      Result := (ExecSQL > 0);
    end;
  finally
    ado.Free;
  end;

end;

class function TDutyUserOpt.DeleteDutyUser(dutyGUID: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update Tab_Org_DutyUser set nDeleteState = 0 where ' +
        'strDutyGUID=%s ' ;
      Sql.Text := Format(Sql.Text,[QuotedStr(dutyGUID)]);

      Result := (ExecSQL > 0);
    end;
  finally
    ado.Free;
  end;

end;

class function TDutyUserOpt.ExistDutyUser(dutyNumber: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select top 1 * from VIEW_Org_DutyUser where strDutyNumber=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(dutyNumber)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TDutyUserOpt.GetDutyUser(dutyNumber: string): RDutyUser;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select * from VIEW_Org_DutyUser where strDutyNumber=%s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(dutyNumber)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.DutyGUID := FieldByName('strDutyGUID').AsString;
        Result.DutyNumber := FieldByName('strDutyNumber').AsString;
        Result.DutyName := FieldByName('strDutyName').AsString;
        Result.DutyPWD := FieldByName('strPassword').AsString;
        Result.DeleteState := FieldByName('nDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TDutyUserOpt.GetDutyUserByGUID(dutyGUID: string): RDutyUser;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'select * from VIEW_Org_DutyUser where strDutyGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(dutyGUID)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.DutyGUID := FieldByName('strDutyGUID').AsString;
        Result.DutyNumber := FieldByName('strDutyNumber').AsString;
        Result.DutyName := FieldByName('strDutyName').AsString;
        Result.DutyPWD := FieldByName('strPassword').AsString;
        Result.DeleteState := FieldByName('nDeleteState').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TDutyUserOpt.GetDutyUsers(out Rlt: TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := DMGlobal.ADOConn;
    Close;
    Sql.Text := 'select * from VIEW_Org_DutyUser order by strDutyNumber';
    Open;
  end;
end;

class function TDutyUserOpt.ResetPWD(dutyGUID, newPWD: string): boolean;
var
  ado : TADOQuery;
begin
  Result := false;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_DutyUser set '+
        ' strPassword=%s where strDutyGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(newPWD),QuotedStr(dutyGUID)]);
      if ExecSQL > 0 then
      begin
        Result := true;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class function TDutyUserOpt.UpdateDutyUser(dutyUser: RDutyUser): boolean;
var
  ado : TADOQuery;
begin
  Result := false;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := DMGlobal.ADOConn;
      Close;
      Sql.Text := 'update TAB_Org_DutyUser set strDutyNumber=%s,strDutyName=%s,'+
        ' strPassword=%s,nDeleteState=%d where strDutyGUID=%s';
      Sql.Text := Format(Sql.Text,[QuotedStr(dutyUser.DutyNumber),QuotedStr(dutyUser.DutyName),
        QuotedStr(dutyUser.DutyPWD),dutyUser.DeleteState,
        QuotedStr(dutyUser.DutyGUID)]);
      if ExecSQL > 0 then
      begin
        Result := true;
      end;
    end;
  finally
    ado.Free;
  end;

end;

end.
