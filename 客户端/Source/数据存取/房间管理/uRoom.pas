unit uRoom;

interface
uses
  Classes,SysUtils,windows,adodb,utfsystem;
type

  PRoom = ^RRoom ;
  //////////////////////////////////////////////////////////////////////////////
  //������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  RRoom = record
    RoomNumber : string;    //�����
    MaxCount : Integer;     //�����������
    AreaGUID : string ;     //��������
    nDeveiveID:Integer;     //�豸ID
    nSound: Integer;        //���췿�䲥������
    nNightSound: Integer;   //���Ϸ��䲥������
    public
      procedure Init;
  end;

  RRoomArray = array of RRoom ;

  //////////////////////////////////////////////////////////////////////////////
  ///������Ϣ������
  //////////////////////////////////////////////////////////////////////////////
  TRoomOpt = class
  public
    //�Ƿ��Ѿ�����ָ���ķ����
    class function ExistRoom(areaGUID:string;roomNumber:string) : boolean;
    //���ݷ���Ż�ȡ������Ϣ
    class function GetRoom(areaGUID:string;roomNumber:string) : RRoom;
    //��ȡ���з�����Ϣ
    class procedure GetRooms(areaGUID : string;out Rlt : TADOQuery);

    //��ȡ���з�����Ϣ,������ס����Ϣ
    class procedure GetRoomsWithIn(areaGUID : string; out Rlt :  TADOQuery);
    //��ȡ���п��еķ���
    class procedure GetSpaceRooms(areaGUID : string;out Rlt : TADOQuery);    
    //��ӷ���
    class function AddRoom(room:RRoom):boolean;
    //�޸ķ���
    class function UpdateRoom(room:RRoom):boolean;
    //ɾ��������Ϣ
    class function DeleteRoom(roomNumber:string):boolean;
    //�Ƿ��Ѿ�����ָ�����豸ID
    class function ExistDeveice(areaGUID:string;nDeveiceID:Integer) : boolean;
    //��ȡָ����������г���
    class procedure GetTrainNosInRoom(strRoomNumber : string;out Rlt  : TStrings);
    class function GetTrainNosInRoomString(strRoomNumber : string) : string;
    class procedure SetTrainNosInRoom(strRoomNumber : string; trainNos:TStrings);
    //��ȡ��ǰ����ĳ���Ա
    class function GetTrainmanInRoom(areaGUID,roomNumber:string;ADOConn : TADOConnection) : string;

  end;


  TDBRoomOperate = class(TDBOperate)
  public
    //��ȡ���з�����Ϣ
    procedure QueryRooms(RoomNumber:string;out RoomArray : RRoomArray);
  private
    procedure AdoToData(ADOQuery:TADOQuery;var Room : RRoom);
  end;

implementation

{ TRoomOpt }
uses
  uCallRoomDM,uGlobalDM;
class function TRoomOpt.AddRoom(room: RRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Close;
      Sql.Text := 'insert into TAB_System_Room (strRoomNumber,nMaxCount,strAreaGUID,nDeveiceID) values '+
        ' (%s,%d,%s,%d)';
      Sql.Text := Format(Sql.Text,[QuotedStr(room.RoomNumber),
        room.MaxCount,QuotedStr(room.AreaGUID),room.nDeveiveID]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

class function TRoomOpt.DeleteRoom(roomNumber: string): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Close;
      Sql.Text := 'delete from TAB_System_Room where strRoomNumber = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(roomNumber)]);
      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;

end;

class function TRoomOpt.ExistDeveice(areaGUID: string;
  nDeveiceID: Integer): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection;
      Close;
      Sql.Text := 'select top 1 * from TAB_System_Room  where  nDeveiceID = %d';
      Sql.Text := Format(Sql.Text,[nDeveiceID]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;
class function TRoomOpt.ExistRoom(areaGUID:string;roomNumber:string) : boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from TAB_System_Room  where  strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(roomNumber)]);
      Open;
      Result := RecordCount > 0;
    end;
  finally
    ado.Free;
  end;
end;


class function TRoomOpt.GetRoom(areaGUID:string;roomNumber:string): RRoom;
var
  ado : TADOQuery;
begin
  Result.Init;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select top 1 * from tab_System_Room  where  strRoomNumber = %s';
      Sql.Text := Format(Sql.Text,[QuotedStr(roomNumber)]);
      Open;
      if RecordCount > 0 then
      begin
        Result.RoomNumber := FieldByName('strRoomNumber').AsString;
        Result.MaxCount := FieldByName('nMaxCount').AsInteger;
        Result.AreaGUID := FieldByName('strAreaGUID').AsString;
        Result.nDeveiveID := FieldByName('nDeveiceID').AsInteger;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class procedure TRoomOpt.GetRooms(areaGUID : string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Close;
    Sql.Text := 'select  * from tab_System_Room  order by strRoomNumber';
    Open;
  end;
end;

class procedure TRoomOpt.GetRoomsWithIn(areaGUID: string;out Rlt : TADOQuery);
begin
  Rlt := TADOQuery.Create(nil);
  with Rlt do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Close;
    Sql.Text := 'select * from tab_System_Room  order by strRoomNumber';
    Open;
  end;
end;

class procedure TRoomOpt.GetSpaceRooms(areaGUID : string;out RLT : TADOQuery);
begin
  RLT := TADOQuery.Create(nil);
  with RLT do
  begin
    Connection := GlobalDM.LocalADOConnection ;
    Close;
    Sql.Text := 'select  * from tab_System_Room  where (strRoomNumber not in (select strRoomNumber from VIEW_RestInWaiting_InOutRoom where nState > 1 and strAreaGUID=%s  and nState < 4 and (not strRoomNumber is null)))' +
      '  order by strRoomNumber';
    Sql.Text := Format(Sql.Text,[QuotedStr(areaGUID)]);
    Open;
  end;
end;

class function TRoomOpt.GetTrainmanInRoom(areaGUID,roomNumber : string;ADOConn : TADOConnection): string;
var
  strSql,strTemp : string;
  adoQuery : TADOQuery;
begin
  Result := '';
  strSql := 'select nMainDriverState,strMainDriverName,strMainDriverNumber,nSubDriverState,strSubDriverName,strSubDriverNumber,strTrainNo from VIEW_RestInWaiting_InOutRoom ' +
  ' where  strRoomNumber=%s and (nMainDriverState > 1 or nSubDriverState > 1) order by dtStarttime desc ';
  strSql := Format(strSql,[QuotedStr(roomNumber)]);
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := ADOConn;
      Sql.Text := strSql;
      Open;
      while not eof do
      begin
        strTemp := '';
        if (FieldByName('nMainDriverState').AsInteger = 3) then
        begin
          strTemp := strTemp + Format('%s[%s]',[FieldByName('strMainDriverName').AsString,FieldByName('strMainDriverNumber').AsString]);
        end;

        if (FieldByName('nSubDriverState').AsInteger = 3) then
        begin
          if strTemp = '' then
            strTemp := strTemp + Format('%s[%s]',[FieldByName('strSubDriverName').AsString,FieldByName('strSubDriverNumber').AsString])
          else
            strTemp := strTemp + ',' + Format('%s[%s]',[FieldByName('strSubDriverName').AsString,FieldByName('strSubDriverNumber').AsString]);
        end;
        if strTemp <> '' then
        begin
          strTemp := Format('%s��<%s>',[FieldByName('strTrainNo').AsString , strTemp]);
          if Result <> '' then
            Result := Result + ':' + strTemp
          else
            Result := Result + strTemp;
        end;
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;

class PROCEDURE TRoomOpt.GetTrainNosInRoom(strRoomNumber: string; out Rlt : TStrings );
var
  ado : TADOQuery;
begin
  Rlt := TStringList.Create;
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select * from TAB_Org_TrainNo where strRoomNumber = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber)]);
      Open;
      while not eof  do
      begin
        Rlt.Add(FieldByName('strTrainNo').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TRoomOpt.GetTrainNosInRoomString(strRoomNumber: string): string;
var
  ado : TADOQuery;
begin
  Result := '';
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text := 'select * from TAB_Org_TrainNo where strRoomNumber = %s ';
      Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber)]);
      Open;
      while not eof  do
      begin
        if Result = '' then
          Result := FieldByName('strTrainNo').AsString
        else
          Result := Result + ',' + FieldByName('strTrainNo').AsString;
        next;
      end;
    end;
  finally
    ado.Free;
  end;

end;

class procedure TRoomOpt.SetTrainNosInRoom(strRoomNumber: string;
  trainNos: TStrings);
var
  i : integer;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Connection.BeginTrans;
      try
        Close;
        Sql.Text := 'update TAB_Org_TrainNo Set strRoomNumber = %s where   strRoomNumber=%s ';
        Sql.Text := Format(Sql.Text,[QuotedStr(''),QuotedStr(strRoomNumber)]);
        ExecSQL;
          
        for i := 0 to trainNos.Count - 1 do
        begin
          Close;
          if Trim(trainNos[i]) = '' then continue;
          
          Sql.Text := 'update TAB_Org_TrainNo Set strRoomNumber = %s where strTrainNo = %s ';
          Sql.Text := Format(Sql.Text,[QuotedStr(strRoomNumber),QuotedStr(trainNos[i])]);
          ExecSQL;
        end;
        Connection.CommitTrans;
      except
        Connection.RollbackTrans;
      end;
    end;
  finally
    ado.Free;
  end;
end;

class function TRoomOpt.UpdateRoom(room: RRoom): boolean;
var
  ado : TADOQuery;
begin
  ado := TADOQuery.Create(nil);
  try
    with ado do
    begin
      Connection := GlobalDM.LocalADOConnection ;
      Close;
      Sql.Text :=
      'update TAB_System_Room set nMaxCount=%d,nDeveiceID=%d ' +
      '  where strRoomNumber = %s ';
      Sql.Text := Format(Sql.Text,[
        room.MaxCount,room.nDeveiveID,
        QuotedStr(room.RoomNumber)]);

      Result :=  ExecSQL > 0;
    end;
  finally
    ado.Free;
  end;
end;

{ RRoom }

procedure RRoom.Init;
begin
  RoomNumber := '';
  MaxCount := 2;
  nDeveiveID :=0 ;
  AreaGUID := '';
  nSound := 1000;
  nNightSound := 100;
end;

{ TDBRoomOperate }

procedure TDBRoomOperate.AdoToData(ADOQuery: TADOQuery; var Room: RRoom);
begin
  with Room do
  begin
    RoomNumber := ADOQuery.FieldByName('strRoomNumber').AsString;
    nDeveiveID := ADOQuery.FieldByName('nDeveiceID').asinteger;
    MaxCount := ADOQuery.FieldByName('nMaxCount').asinteger ;
    //nSound := ADOQuery.FieldByName('nSound').asinteger;        //���췿�䲥������
    //nNightSound := ADOQuery.FieldByName('nNightSound').asinteger ;   //���Ϸ��䲥������
  end;
end;

procedure TDBRoomOperate.QueryRooms(RoomNumber: string; out RoomArray: RRoomArray);
var
  adoQuery : TADOQuery ;
  strSql : string;
  i : Integer ;
begin
  i := 0 ;
  adoQuery := NewADOQuery ;
  strSql := 'select  * from tab_System_Room ' ;
  if RoomNumber <> '' then
  begin
    strSql := strSql + 'where  strRoomNumber like ' + QuotedStr( RoomNumber + '%')  ;
  end;
  strSql := strSql + ' order by strRoomNumber ' ;
  try
    adoQuery.Sql.Text := strSql ;
    adoQuery.Open;
    if adoQuery.recordCount > 0 then
    begin
      SetLength(RoomArray,adoQuery.recordCount);
      while not adoQuery.Eof do
      begin
        AdoToData(adoQuery,RoomArray[i]);
        adoQuery.Next ;
        Inc(i);
      end;
    end;
  finally
    adoQuery.Free ;
  end;
end;

end.
