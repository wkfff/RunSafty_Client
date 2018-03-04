unit uTuiQinTime;

interface

uses
  SysUtils,db,ADODB,DateUtils,utfsystem;

type

  RRsTuiQinTimeLog = record
    strGroupGUID:string;        //����GUID
    strWorkShopGUID : string;  //��������GUID
    strTrainmanGUID1 : string; //GUID
    strTrainmanNumber1 : string; //����
    strTrainmanName1 : string; //����

    strTrainmanGUID2 : string; //GUID
    strTrainmanNumber2 : string; //����
    strTrainmanName2 : string; //����

    strTrainmanGUID3 : string; //GUID
    strTrainmanNumber3 : string; //����
    strTrainmanName3 : string; //����

    strTrainPlanGUID : string;//�ƻ�
    dtStartTime : TDateTime;//�ƻ�����ʱ��
    strTrainNo : string; //����
    
    dtOldArriveTime:TDateTime;  //��ʱ��
    dtNewArriveTime:TDateTime;  //��ʱ��
    strDutyUserNumber:string;   //�޸�������
    strDubyUserName:string;     //�޸�������
    dtCreateTime:TDateTime;     //�޸�ʱ��
    nType:Integer;              //����
  end;

  TRsTuiQinTimeLogList = array of  RRsTuiQinTimeLog ;

  TDBTuiQinTimeLog = class(TDBOperate)
  public
    procedure Query(StartDate,EndDate:TDateTime;out LogList:TRsTuiQinTimeLogList);
    procedure Log(TuiQinTimeLog:RRsTuiQinTimeLog);
  private
    procedure AdoToData(Ado:TADOQuery;var TuiQinTimeLog:RRsTuiQinTimeLog);
    procedure DataToAdo(Ado:TADOQuery;var TuiQinTimeLog:RRsTuiQinTimeLog);

  end;

implementation

{ TDBTuiQinTimeLog }

procedure TDBTuiQinTimeLog.AdoToData(Ado: TADOQuery;
  var TuiQinTimeLog: RRsTuiQinTimeLog);
begin
  with Ado do
  begin
    TuiQinTimeLog.strGroupGUID := FieldByName('strGroupGUID').AsString;
    TuiQinTimeLog.dtOldArriveTime := FieldByName('dtOldArriveTime').AsDateTime;
    TuiQinTimeLog.dtNewArriveTime := FieldByName('dtNewArriveTime').AsDateTime;
    TuiQinTimeLog.strDutyUserNumber := FieldByName('strDutyUserNumber').AsString;
    TuiQinTimeLog.strDubyUserName := FieldByName('strDubyUserName').AsString;
    TuiQinTimeLog.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
  end;
end;

procedure TDBTuiQinTimeLog.DataToAdo(Ado: TADOQuery;
  var TuiQinTimeLog: RRsTuiQinTimeLog);
begin
  with Ado do
  begin
     FieldByName('strGroupGUID').AsString := TuiQinTimeLog.strGroupGUID;
     FieldByName('nType').AsInteger := TuiQinTimeLog.nType;
     FieldByName('dtOldArriveTime').AsDateTime := TuiQinTimeLog.dtOldArriveTime;
     FieldByName('dtNewArriveTime').AsDateTime := TuiQinTimeLog.dtNewArriveTime;
     FieldByName('strDutyUserNumber').AsString := TuiQinTimeLog.strDutyUserNumber;
     FieldByName('strDubyUserName').AsString := TuiQinTimeLog.strDubyUserName;
     FieldByName('dtCreateTime').AsDateTime := TuiQinTimeLog.dtCreateTime;
  end;
end;

procedure TDBTuiQinTimeLog.Log(TuiQinTimeLog: RRsTuiQinTimeLog);
var
  ADOQuery:TADOQuery;
  strSql:string;
begin
  ADOQuery := NewADOQuery;
  try
    strSql := 'select * from Tab_Plan_ModifyLastArriveTime_Log where 1 = 2 ';
    with ADOQuery do
    begin
      SQL.Text := strSql ;
      Open;
      Append;
      DataToAdo(ADOQuery,TuiQinTimeLog);
      Post;
    end;
  finally
    ADOQuery.Free;
  end;
end;

procedure TDBTuiQinTimeLog.Query(StartDate, EndDate: TDateTime;
  out LogList: TRsTuiQinTimeLogList);
var
  ADOQuery:TADOQuery;
  strSql:string;
  i:Integer;
begin
  i := 0 ;
  ADOQuery := NewADOQuery;
  try
    strSql := Format('select * from Tab_Plan_ModifyLastArriveTime_Log where dtCreateTime between %s and %s',[
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',StartDate)),
      QuotedStr(FormatDateTime('yyyy-MM-dd HH:nn:ss',EndDate))]);
    with ADOQuery do
    begin
      SQL.Text := strSql ;
      Open;
      if ADOQuery.IsEmpty then
        Exit;
      SetLength(LogList,ADOQuery.RecordCount);
      while not ADOQuery.Eof do
      begin
        AdoToData(ADOQuery,LogList[i]);
        Inc(i);
        ADOQuery.Next;
      end;
    end;
  finally
    ADOQuery.Free;
  end;
end;

end.
