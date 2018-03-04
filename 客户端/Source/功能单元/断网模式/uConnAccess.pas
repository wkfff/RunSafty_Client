unit uConnAccess;

interface

uses
  Windows, SysUtils, Variants, Classes, Forms, ShellApi, DB, ADODB, DateUtils,
  ZKFPEngXUtils, uTrainman, uSite, RzPrgres,uRoomSign,utfsystem;

type
  //�����Ϣ
  RRsDrinkInfo = record
    //��Ƽ�¼GUID
    strGUID:string ;
    //��Ƽ�¼ID
    nDrinkInfoID : integer;
    //����ԱGUID
    strTrainmanGUID : string;
    //����Ա����
    strTrainmanNumber : string;    
    //����Ա����
    strTrainmanName: string;
    //��ƽ��
    nDrinkResult : integer;
    //���ʱ��
    dtCreateTime : TDateTime;
    //ʶ��ʽ
    nVerifyID : integer;
    //ֵ��Ա����
    strDutyNumber : string;
    //�������ID
    nWorkTypeID : integer;
    //�����Ƭ������nilʱ������Ƭ
    DrinkImage : OleVariant;
    strPictureURL: string;
    nDelFlag: integer;

    //�ƾ���(mg/100ml)
    dwAlcoholicity : Integer ;
     //��������
    strTrainTypeName : string;
    //������
    strTrainNumber : string;
    {����}
    strTrainNo : String;

  end;
  TRsDrinkInfoArray = array of RRsDrinkInfo;

  //�����Ϣ��ѯ����
  RRsDrinkQuery = record
    //�������ID
    nWorkTypeID : integer;   
    //����Ա����
    strTrainmanNumber : string;
    //���ʱ��-��ʼ
    dtBeginTime : TDateTime;   
    //���ʱ��-����
    dtEndTime : TDateTime;
    
    //����Ա����1
    //strTrainmanNumber1 : string;
    //����Ա����2
    //strTrainmanNumber2 : string;
    //����Ա����3
    //strTrainmanNumber3 : string;
  end;

  //˾����Ϣ
  RRsLocalTrainman = record
    //˾��nID
    nID: integer;
    //˾��GUID
    strTrainmanGUID: string;
    //˾������
    strTrainmanName: string;
    //˾������
    strTrainmanNumber: string;
    //��ϵ�绰
    strTelNumber: string;
    //�ֻ���
    strMobileNumber : string;
   {ָ��1}
    //FingerPrint1 : OleVariant;
    {ָ��2}
    //FingerPrint2 : OleVariant;
    //�����Ƭ
    //Picture : OleVariant;
    //������ƴ
    strJP : string;
  end;
  TRsLocalTrainmanArray = array of RRsLocalTrainman;



type
  TConnAccess = class(TADOConnection)
  private
    { Private declarations }
  protected
    { Protected declarations }
  public
    { Public declarations }
    m_adoQuery:     TAdoQuery; 
    
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;             
    function ConnectAccess(strDatabase: WideString=''): boolean;
    function ConnectSqlSrv(strConnection: WideString): boolean;
    procedure AlertTable();

    function ConnectLocalDB(strDatabase: WideString=''):Boolean;

    //���ܣ���ѯ�����Ϣ
    procedure QueryDrinkInfo(DrinkQuery: RRsDrinkQuery; out DrinkInfoArray: TRsDrinkInfoArray);
    //���ܣ��õ�ָ��ID�Ĳ����Ϣ
    function GetDrinkInfo(nDrinkInfoID: integer; out DrinkInfo: RRsDrinkInfo): boolean;
    //���ܣ����Ӳ����Ϣ
    function AddDrinkInfo(DrinkInfo: RRsDrinkInfo): boolean;
    //���ܣ�ɾ��ָ��ID�Ĳ����Ϣ����ɾ�����
    procedure UpdateDrinkState(nDrinkInfoID: integer; nDelFlag: integer = 1);
    //���ܣ�ɾ���Ѿ����Ե��Ĳ�Ƽ�¼
    procedure DeleteIgnoreRecord();
    //���ܣ��õ��ɵ���Ĳ����Ϣ��
    function GetDrinkInfoCount: integer;

    //���ܣ��޸ĳ���Ա
    procedure UpdateTrainman(Trainman: RRsTrainman);
    procedure UpdateTrainmans(TrainmanArray: TRsTrainmanArray; ProgressBar: TRzProgressBar);
    //���ܣ��޸�վ��
    procedure UpdateSites(SiteArray: TRsSiteArray);
  published
    { Published declarations }
  end;

implementation

{ TConnAccess }

constructor TConnAccess.Create(AOwner: TComponent);
begin
  inherited;
  self.LoginPrompt := false;
  self.KeepConnection := true;
  self.CursorLocation := clUseClient; 

  self.m_adoQuery := TAdoQuery.Create(self);
  self.m_adoQuery.Connection := self;
  self.m_adoQuery.ParamCheck := false;
end;

procedure TConnAccess.DeleteIgnoreRecord;
var
  strSql: String;
begin
  strSql := Format('delete from TAB_Drink_Information where nDelFlag=%d', [2]);

  with m_adoQuery do
  begin
    Close;
    SQL.Text := strSql;
    ExecSQL;
  end;

end;



destructor TConnAccess.Destroy;
begin
  if Assigned(self.m_adoQuery) then
  begin
    if self.m_adoQuery.Active then self.m_adoQuery.Close;
    self.m_adoQuery.Free;
  end;
  
  if Assigned(self) then if self.Connected then self.Close;
  inherited;
end;

function TConnAccess.ConnectAccess(strDatabase: WideString): boolean;
var
  strConnection: string;
begin
  result := false;
  if self.Connected then self.Connected := false;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'RunSafty.mdb';
  strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  try
    self.Close;
    self.ConnectionString := strConnection;
    self.Open;

    AlertTable;
  except
  end;

  if self.Connected then result := true;
end;
      
function TConnAccess.ConnectLocalDB(strDatabase: WideString=''): Boolean;
var
  strConnection: string;
begin
  result := false;
  if self.Connected then self.Connected := false;

  if strDatabase = '' then strDatabase := ExtractFilePath(Application.ExeName)+'RunSafty.mdb';
  strConnection := 'Provider=Microsoft.Jet.OLEDB.4.0;Persist Security Info=False;Data Source='+strDatabase+';User Id=admin;Jet OLEDB:Database Password=thinkfreely;';
  try
    self.Close;
    self.ConnectionString := strConnection;
    self.Open;
  except
  end;
end;

function TConnAccess.ConnectSqlSrv(strConnection: WideString): boolean;
begin
  result:=false;
  if strConnection='' then exit;

  try
    self.Close;
    self.ConnectionString:=strConnection;
    self.ConnectionTimeout := 10;
    self.CommandTimeout := 5;
    self.Open;
  except
  end;

  if self.Connected then result:=true;
end;

procedure TConnAccess.AlertTable();
var
  i: integer;
  strName: string;
  blnExist: boolean;
begin      
  if not self.Connected then exit;

  blnExist := false;
  with m_adoQuery do
  begin
    Close;
    SQL.Text := 'select * from TAB_Drink_Information where 1=2';
    Open;
    for i := 0 to FieldCount - 1 do
    begin
      strName := m_adoQuery.Fields[i].FieldName;
      windows.OutputDebugString(PChar(strName));
      if strName = 'strTrainmanName' then
      begin
        blnExist := true;
        break;
      end;
    end;
  end;

  if not blnExist then
  begin
    Execute('ALTER TABLE TAB_Drink_Information ADD COLUMN strTrainmanName TEXT(50)');
  end;
end;

procedure TConnAccess.QueryDrinkInfo(DrinkQuery: RRsDrinkQuery; out DrinkInfoArray: TRsDrinkInfoArray);
var
  i: integer;
  strSql, strWhere: String;
  strBeginTime, strEndTime: string;
  ms : TMemoryStream;
begin
  strWhere := ' where (nDelFlag=0 or nDelFlag=2)';
  if DrinkQuery.nWorkTypeID > 0 then
  begin
    //strWhere := strWhere + Format(' and nWorkTypeID=%d', [DrinkQuery.nWorkTypeID]);
  end;
  if DrinkQuery.strTrainmanNumber <> '' then
  begin
    strWhere := strWhere + Format(' and strTrainmanNumber=''%s''', [DrinkQuery.strTrainmanNumber]);
  end;
  strBeginTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', DrinkQuery.dtBeginTime);
  strWhere := strWhere + Format(' and (dtCreateTime>=#%s#)', [strBeginTime, strEndTime]);
//  if (DrinkQuery.dtBeginTime >= OneSecond) and (DrinkQuery.dtEndTime >= OneSecond) then
//  begin
//    strBeginTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', DrinkQuery.dtBeginTime);
//    strEndTime := FormatDateTime('yyyy-mm-dd hh:nn:ss', DrinkQuery.dtEndTime);
//    strWhere := strWhere + Format(' and (dtCreateTime>=#%s# and dtCreateTime<=#%s#)', [strBeginTime, strEndTime]);
//  end;
  strSql := Format('select * From TAB_Drink_Information %s order by dtCreateTime desc', [strWhere]);

  with m_adoQuery do
  begin
    Close;
    SQL.Text := strSql;
    Open;
    SetLength(DrinkInfoArray, RecordCount);
    i := 0;
    while not eof do
    begin
      //��Ա��Ϣ
      DrinkInfoArray[i].nDrinkInfoID := FieldByName('nDrinkInfoID').AsInteger;
      DrinkInfoArray[i].strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
      DrinkInfoArray[i].strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
      DrinkInfoArray[i].strTrainmanName := FieldByName('strTrainmanName').AsString;
      //������Ϣ
      DrinkInfoArray[i].strTrainNo := FieldByName('strTrainNo').AsString;
      DrinkInfoArray[i].strTrainTypeName := FieldByName('strTrainTypeName').AsString;
      DrinkInfoArray[i].strTrainNumber := FieldByName('strTrainNumber').AsString;
      //�ƾ���
      DrinkInfoArray[i].dwAlcoholicity := FieldByName('dwAlcoholicity').AsInteger;

      DrinkInfoArray[i].nWorkTypeID :=  FieldByName('nWorkTypeID').AsInteger;
      DrinkInfoArray[i].nDrinkResult := FieldByName('nDrinkResult').AsInteger;
      DrinkInfoArray[i].dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
      DrinkInfoArray[i].nVerifyID := FieldByName('nVerifyID').AsInteger;
      DrinkInfoArray[i].strDutyNumber := FieldByName('strDutyNumber').AsString;
      DrinkInfoArray[i].nDelFlag := FieldByName('nDelFlag').AsInteger;

      ms := TMemoryStream.Create;
      try
         TBlobField(FieldByName('DrinkImage')).SaveToStream(ms);
         DrinkInfoArray[i].DrinkImage := StreamToTemplateOleVariant(ms);
      finally
        ms.Free;
      end;
      inc(i);
      next;
    end;
  end;
end;

function TConnAccess.GetDrinkInfo(nDrinkInfoID: integer; out DrinkInfo: RRsDrinkInfo): boolean;
var 
  Stream: TMemoryStream;
begin
  result := false;
  if nDrinkInfoID <= 0 then exit;

  with m_adoQuery do
  begin
    Close;
    SQL.Text := Format('select * From TAB_Drink_Information where nDrinkInfoID=%d', [nDrinkInfoID]);
    Open;
    if not eof then
    begin
      DrinkInfo.nDrinkInfoID := FieldByName('nDrinkInfoID').AsInteger;
      //
      DrinkInfo.strTrainmanGUID := FieldByName('strTrainmanGUID').AsString;
      DrinkInfo.strTrainmanNumber := FieldByName('strTrainmanNumber').AsString;
      DrinkInfo.strTrainmanName := FieldByName('strTrainmanName').AsString;

      //������Ϣ
      DrinkInfo.strTrainNo := FieldByName('strTrainNo').AsString;
      DrinkInfo.strTrainTypeName := FieldByName('strTrainTypeName').AsString;
      DrinkInfo.strTrainNumber := FieldByName('strTrainNumber').AsString;
      //�ƾ���
      DrinkInfo.dwAlcoholicity := FieldByName('dwAlcoholicity').AsInteger;


      DrinkInfo.nDrinkResult := FieldByName('nDrinkResult').AsInteger;
      DrinkInfo.dtCreateTime := FieldByName('dtCreateTime').AsDateTime;
      DrinkInfo.nVerifyID := FieldByName('nVerifyID').AsInteger;
      DrinkInfo.strDutyNumber := FieldByName('strDutyNumber').AsString;
      DrinkInfo.nWorkTypeID := FieldByName('nWorkTypeID').AsInteger;

      if not FieldByName('DrinkImage').IsNull then
      begin
        Stream := TMemoryStream.Create;
        try
          TBlobField(FieldByName('DrinkImage')).SaveToStream(Stream);
          if Stream.Size > 0 then DrinkInfo.DrinkImage := StreamToTemplateOleVariant(Stream);
        finally
          Stream.Free;
        end;
      end;
      result := true;
    end;
  end;
end;

function TConnAccess.AddDrinkInfo(DrinkInfo: RRsDrinkInfo): boolean;
var
  strSql: String;     
  adoQuery : TADOQuery; 
  Stream: TMemoryStream;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      strSql := 'select * from TAB_Drink_Information where  1=2 ';
      Connection := self;
      Sql.Text := strSql;
      Open;
      Append;

      //��Ա��Ϣ
      FieldByName('strTrainmanGUID').AsString := DrinkInfo.strTrainmanGUID;
      FieldByName('strTrainmanNumber').AsString := DrinkInfo.strTrainmanNumber;
      FieldByName('strTrainmanName').AsString := DrinkInfo.strTrainmanName;
      //������Ϣ
      FieldByName('strTrainNo').AsString := DrinkInfo.strTrainNo;
      FieldByName('strTrainTypeName').AsString := DrinkInfo.strTrainTypeName;
      FieldByName('strTrainNumber').AsString := DrinkInfo.strTrainNumber;
      //�ƾ���
      FieldByName('dwAlcoholicity').AsInteger := DrinkInfo.dwAlcoholicity;

      FieldByName('nDrinkResult').AsInteger := DrinkInfo.nDrinkResult;
      FieldByName('dtCreateTime').AsDateTime := DrinkInfo.dtCreateTime;
      FieldByName('nVerifyID').AsInteger := DrinkInfo.nVerifyID;
      FieldByName('strDutyNumber').AsString := DrinkInfo.strDutyNumber;   
      FieldByName('nWorkTypeID').AsInteger := DrinkInfo.nWorkTypeID;
      
      Stream := TMemoryStream.Create;
      try
        if not (VarIsEmpty(DrinkInfo.DrinkImage) or VarIsNull(DrinkInfo.DrinkImage)) then
          TemplateOleVariantToStream(DrinkInfo.DrinkImage, Stream);
        if Stream.Size > 0 then TBlobField(FieldByName('DrinkImage')).LoadFromStream(Stream);
      finally
        Stream.Free;
      end;

      Post;
      result := true;
    end;
  finally
    adoQuery.Free;
  end;
end;
         
procedure TConnAccess.UpdateDrinkState(nDrinkInfoID: integer; nDelFlag: integer);
var
  strSql: String;
begin
  strSql := Format('update TAB_Drink_Information Set nDelFlag=%d where nDrinkInfoID=%d', [nDelFlag, nDrinkInfoID]);

  with m_adoQuery do
  begin
    Close;
    SQL.Text := strSql;
    ExecSQL;
  end;
end;

function TConnAccess.GetDrinkInfoCount(): integer;
begin
  result := 0;
  with m_adoQuery do
  begin
    Close;
    SQL.Text := 'select count(*) From TAB_Drink_Information where (nDelFlag=0)';
    Open;
    if not eof then result := m_adoQuery.Fields[0].AsInteger;
  end;
end;


procedure TConnAccess.UpdateTrainman(Trainman: RRsTrainman);
var
  strSql: String;     
  adoQuery : TADOQuery;
  Stream : TMemoryStream;
begin      
  if not self.Connected then exit;

  try
    adoQuery := TADOQuery.Create(nil);
    try
      with adoQuery do
      begin
        Connection := self;
        ParamCheck := false;
        strSql := 'select * from TAB_Org_Trainman where  strTrainmanGUID=''%s''';
        Sql.Text := Format(strSql, [Trainman.strTrainmanGUID]);
        Open;
        if eof then Append else Edit;
        FieldByName('strTrainmanGUID').AsString := Trainman.strTrainmanGUID;
        FieldByName('strTrainmanNumber').AsString := Trainman.strTrainmanNumber;
        FieldByName('strTrainmanName').AsString := Trainman.strTrainmanName;
        FieldByName('strTelNumber').AsString := Trainman.strTelNumber;
        FieldByName('strMobileNumber').AsString := Trainman.strMobileNumber;
        FieldByName('strJP').AsString := Trainman.strJP;
        FieldByName('nID').AsInteger := Trainman.nID;

        Stream := TMemoryStream.Create;
        try
          {��ȡָ��1}
          if not (VarIsNull(Trainman.FingerPrint1) or VarIsEmpty(Trainman.FingerPrint1)) then
          begin
            TemplateOleVariantToStream(Trainman.FingerPrint1,Stream);
            (FieldByName('FingerPrint1') As TBlobField).LoadFromStream(Stream);
            Stream.Clear;
          end;

          {��ȡָ��2}
          if not (VarIsNull(Trainman.FingerPrint2)  or VarIsEmpty(Trainman.FingerPrint2)) then
            begin
            TemplateOleVariantToStream(Trainman.FingerPrint2,Stream);
            (FieldByName('FingerPrint2') As TBlobField).LoadFromStream(Stream);
            Stream.Clear;
          end;
        finally
          Stream.Free;
        end;
        Post;
      end;
    finally
      adoQuery.Free;
    end;
  except
  end;
end;

procedure TConnAccess.UpdateTrainmans(TrainmanArray: TRsTrainmanArray; ProgressBar: TRzProgressBar);
var
  i: integer;
  adoQuery : TADOQuery;
  Stream : TMemoryStream;
begin      
  if not self.Connected then exit;

  ProgressBar.TotalParts := Length(TrainmanArray);
  ProgressBar.Visible := true;
  Application.ProcessMessages;
  adoQuery := TADOQuery.Create(nil); 
  try
    self.BeginTrans;
    try
      with adoQuery do
      begin
        Connection := self;
        ParamCheck := false;

        Sql.Text := 'delete from TAB_Org_Trainman';
        ExecSQL;

        Close;
        Sql.Text := 'select * from TAB_Org_Trainman where 1=2';
        Open;
        for i := 0 to Length(TrainmanArray) - 1 do
        begin
          Append;
          FieldByName('strTrainmanGUID').AsString := TrainmanArray[i].strTrainmanGUID;
          FieldByName('strTrainmanNumber').AsString := TrainmanArray[i].strTrainmanNumber;
          FieldByName('strTrainmanName').AsString := TrainmanArray[i].strTrainmanName;
          FieldByName('strWorkShopGUID').AsString := TrainmanArray[i].strWorkShopGUID;
          FieldByName('strTelNumber').AsString := TrainmanArray[i].strTelNumber;
          FieldByName('strMobileNumber').AsString := TrainmanArray[i].strMobileNumber;
          FieldByName('strJP').AsString := TrainmanArray[i].strJP;
          FieldByName('nID').AsInteger := TrainmanArray[i].nID;
          //��ȡָ��
          Stream := TMemoryStream.Create;
          try
            if not (VarIsNull(TrainmanArray[i].FingerPrint1) or VarIsEmpty(TrainmanArray[i].FingerPrint1)) then
            begin
              TemplateOleVariantToStream(TrainmanArray[i].FingerPrint1,Stream);
              (FieldByName('FingerPrint1') As TBlobField).LoadFromStream(Stream);
              Stream.Clear;
            end;
            if not (VarIsNull(TrainmanArray[i].FingerPrint2)  or VarIsEmpty(TrainmanArray[i].FingerPrint2)) then
              begin
              TemplateOleVariantToStream(TrainmanArray[i].FingerPrint2,Stream);
              (FieldByName('FingerPrint2') As TBlobField).LoadFromStream(Stream);
              Stream.Clear;
            end;
          finally
            Stream.Free;
          end;
          Post;
          
          ProgressBar.PartsComplete := i + 1;  
          Application.ProcessMessages;
        end;
      end;
      self.CommitTrans;
    except
      self.RollbackTrans;
    end;
  finally           
    ProgressBar.Visible := false;
    adoQuery.Free;
  end;
end;


procedure TConnAccess.UpdateSites(SiteArray: TRsSiteArray);
var
  i: integer;  
  adoQuery : TADOQuery;
begin
  if not self.Connected then exit;
     
  adoQuery := TADOQuery.Create(nil);
  try  
    self.BeginTrans;
    try
      with adoQuery do
      begin
        Connection := self;
        ParamCheck := false;
        
        Sql.Text := 'delete from TAB_Base_Site';
        ExecSQL;

        Close;
        Sql.Text := 'select * from TAB_Base_Site where 1=2';
        Open;
        for i := 0 to Length(SiteArray) - 1 do
        begin
          Append;
          FieldByName('nID').AsInteger := i + 1;
          FieldByName('strSiteGUID').AsString := SiteArray[i].strSiteGUID;
          FieldByName('strSiteName').AsString := SiteArray[i].strSiteName;
          FieldByName('strSiteIP').AsString := SiteArray[i].strSiteIP;
          FieldByName('strWorkShopGUID').AsString := SiteArray[i].strWorkShopGUID;
          FieldByName('nSiteJob').AsInteger := SiteArray[i].nSiteJob;
          Post;
        end;
      end; 
      self.CommitTrans;
    except
      self.RollbackTrans;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
