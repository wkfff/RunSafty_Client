unit uLendingDefine;

interface
uses
  Classes,SysUtils,Contnrs;
type
  {TReturnState  ��Ʒ�黹״̬}
  TRsReturnState = class(TPersistent)
  private
    m_nReturnStateID: Integer;
    {״̬����}
    m_strStateName: string;
  published
    {״̬ID}
    property nReturnStateID: Integer read m_nReturnStateID write m_nReturnStateID;
    {״̬����}
    property strStateName: string read m_strStateName write m_strStateName;
  end;

  {TReturnStateList  ��Ʒ�黹״̬�б�}
  TRsReturnStateList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsReturnState;
    procedure SetItem(Index: Integer; AObject: TRsReturnState);
  public
    property Items[Index: Integer]: TRsReturnState read GetItem write SetItem; default;
  end;



  TRsLendingType = class(TPersistent)
  private
    {����ID}
    m_nLendingTypeID: Integer;
    {�����Ʒ����}
    m_strLendingTypeName: string;
    {��Ʒ����}
    m_strAlias: string;
  published
    property nLendingTypeID: Integer read m_nLendingTypeID write m_nLendingTypeID;
    property strLendingTypeName: string read m_strLendingTypeName write m_strLendingTypeName;
    property strAlias: string read m_strAlias write m_strAlias;
  end;
  
  {TLendingTypeList  �����Ʒ�����б�}
  TRsLendingTypeList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingType;
    procedure SetItem(Index: Integer; AObject: TRsLendingType);
  public
    function FindTypeByAlias(strAlias: string): TRsLendingType;
    function FindAliasByID(ID: Integer): string;
    property Items[Index: Integer]: TRsLendingType read GetItem write SetItem; default;
  end;

  {TLendingDetail �����Ʒ��ϸ��Ϣ}
  TRsLendingDetail = class(TPersistent)
  private
    {��¼GUID}
    m_strGUID: string;
    {�����¼GUID}
    m_strLendingInfoGUID: string;
    {������GUID}
    m_strTrainmanGUID: string;
    {�����˹���}
    m_strTrainmanNumber: string;
    {����������}
    m_strTrainmanName: string;
    {���������GUID}
    m_strLenderGUID: string;
    {��������˹���}
    m_strLenderNumber: string;
    {�������������}
    m_strLenderName: string;
    {�黹������GUID}
    m_strGiveBackTrainmanGUID: string;
    {�黹�����˹���} 
    m_strGiveBackTrainmanNumber: string;
    {�黹����������}
    m_strGiveBackTrainmanName: string;
    {�����Ʒ����}
    m_nLendingType: integer;
    {��Ʒ����}
    m_strLendingTypeName: string;
    {��Ʒ����}
    m_strLendingTypeAlias: string;
    {��Ʒ������Ϣ�����}
    m_strLendingExInfo: integer;
    {���õǼ���֤��ʽ}
    m_nBorrowVerifyType: integer;
    {�黹�Ǽ���֤��ʽ}
    m_nGiveBackVerifyType: integer;
    {���õǼ���֤��ʽ����}
    m_strBorrowVerifyTypeName: string;
    {�黹��֤��ʽ}
    m_strGiveBackVerifyTypeName: string;
    {��Ʒ�黹״̬}
    m_nReturnState: integer;
    {�黹״̬����}
    m_strStateName: string;
    {���ʱ��}
    m_dtBorrwoTime: tdatetime;
    {�黹ʱ��}
    m_dtGiveBackTime: tdatetime;
    {����޸�ʱ��}
    m_dtModifyTime: tdatetime;
    {�ѽ�ʱ��}
    m_nKeepMunites: integer;  
  public
    {����:��������}
    procedure Clone(LendingDetail: TRsLendingDetail);
    {����:����ַ���}
    function CombineAliasName(): string;
  published
    property strGUID: string read m_strGUID write m_strGUID;
    property strLendingInfoGUID: string read m_strLendingInfoGUID write m_strLendingInfoGUID;
    property strTrainmanGUID: string read m_strTrainmanGUID write m_strTrainmanGUID;
    property strTrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property strTrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property strLenderGUID: string read m_strLenderGUID write m_strLenderGUID;
    property strLenderNumber: string read m_strLenderNumber write m_strLenderNumber;
    property strLenderName: string read m_strLenderName write m_strLenderName;
    property strGiveBackTrainmanGUID: string read m_strGiveBackTrainmanGUID write m_strGiveBackTrainmanGUID;
    property strGiveBackTrainmanNumber: string read m_strGiveBackTrainmanNumber write m_strGiveBackTrainmanNumber;
    property strGiveBackTrainmanName: string read m_strGiveBackTrainmanName write m_strGiveBackTrainmanName;
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strLendingTypeName: string read m_strLendingTypeName write m_strLendingTypeName;
    property strLendingTypeAlias: string read m_strLendingTypeAlias write m_strLendingTypeAlias;
    property strLendingExInfo: integer read m_strLendingExInfo write m_strLendingExInfo;
    property nBorrowVerifyType: integer read m_nBorrowVerifyType write m_nBorrowVerifyType;
    property nGiveBackVerifyType: integer read m_nGiveBackVerifyType write m_nGiveBackVerifyType;
    property strBorrowVerifyTypeName: string read m_strBorrowVerifyTypeName write m_strBorrowVerifyTypeName;
    property strGiveBackVerifyTypeName: string read m_strGiveBackVerifyTypeName write m_strGiveBackVerifyTypeName;
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property strStateName: string read m_strStateName write m_strStateName;
    property dtBorrwoTime: tdatetime read m_dtBorrwoTime write m_dtBorrwoTime;
    property dtGiveBackTime: tdatetime read m_dtGiveBackTime write m_dtGiveBackTime;
    property dtModifyTime: tdatetime read m_dtModifyTime write m_dtModifyTime;
    property nKeepMunites: integer read m_nKeepMunites write m_nKeepMunites;      
  end;


  {TLendingDetailList �����Ʒ�б�}
  TRsLendingDetailList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingDetail;
    procedure SetItem(Index: Integer; AObject: TRsLendingDetail);
  public
    function CombineExInfoToString(TypeID: Integer): string;
    
    function IndexByContent(LendingDetail: TRsLendingDetail): Integer;
    {����:��������}
    procedure Clone(LendingDetailList: TRsLendingDetailList);
    {����:�ж��Ƿ����ָ����Ʒ�б�}
    function Include(LendingDetailList: TRsLendingDetailList): Boolean;
    property Items[Index: Integer]: TRsLendingDetail read GetItem write SetItem; default;
  end;


  {TLendingInfo  �����¼}
  TRsLendingInfo = class(TPersistent)
  public
    constructor Create();
  private
    {��¼ID}
    m_strGUID: string;
    {�黹״̬}
    m_nReturnState: integer;
    {�黹״̬����}
    m_strStateName: string;
    {������GUID}
    m_strBorrowTrainmanGUID: string;
    {����������}
    m_strBorrowTrainmanName: string;
    {�����˹���}
    m_strBorrowTrainmanNumber: string;
    {���õǼǷ�ʽ}
    m_nBorrowLoginType: integer;
    {���õǼǷ�ʽ����}
    m_strBorrowLoginName: string;
    {����ʱ��}
    m_dtBorrowTime: tdatetime;
    {���������GUID}
    m_strLenderGUID: string;
    {��������˹���}
    m_strLenderNumber: string;
    {�������������}
    m_strLenderName: string;
    {�黹������GUID}
    m_strGiveBackTrainmanGUID: string;
    {�黹����������}
    m_strGiveBackTrainmanName: string;
    {�黹�����˹�����}
    m_strGiveBackTrainmanNumber: string;
    {�黹�ǼǷ�ʽ}
    m_nGiveBackLoginType: integer;
    {�黹�ǼǷ�ʽ����}
    m_strGiveBackLoginName: string;
    {�黹ʱ��}
    m_dtGiveBackTime: tdatetime;
    {��¼����޸�ʱ��}
    m_dtModifyTime: tdatetime;
    {������Ʒ��ϸ}
    m_strDetails: string;
    {��ע}                 
    m_strRemark: string;    
  public
    {����:��������}
    procedure Clone(LendingInfo: TRsLendingInfo);
    {����:�ж��Ƿ�Ϊһ����Ч�ļ�¼}
    function IsValid(): Boolean;
  published
    property strGUID: string read m_strGUID write m_strGUID;
    property nReturnState: integer read m_nReturnState write m_nReturnState;
    property strStateName: string read m_strStateName write m_strStateName;
    property strBorrowTrainmanGUID: string read m_strBorrowTrainmanGUID write m_strBorrowTrainmanGUID;
    property strBorrowTrainmanName: string read m_strBorrowTrainmanName write m_strBorrowTrainmanName;
    property strBorrowTrainmanNumber: string read m_strBorrowTrainmanNumber write m_strBorrowTrainmanNumber;
    property nBorrowLoginType: integer read m_nBorrowLoginType write m_nBorrowLoginType;
    property strBorrowLoginName: string read m_strBorrowLoginName write m_strBorrowLoginName;
    property dtBorrowTime: tdatetime read m_dtBorrowTime write m_dtBorrowTime;
    property strLenderGUID: string read m_strLenderGUID write m_strLenderGUID;
    property strLenderNumber: string read m_strLenderNumber write m_strLenderNumber;
    property strLenderName: string read m_strLenderName write m_strLenderName;
    property strGiveBackTrainmanGUID: string read m_strGiveBackTrainmanGUID write m_strGiveBackTrainmanGUID;
    property strGiveBackTrainmanName: string read m_strGiveBackTrainmanName write m_strGiveBackTrainmanName;
    property strGiveBackTrainmanNumber: string read m_strGiveBackTrainmanNumber write m_strGiveBackTrainmanNumber;
    property nGiveBackLoginType: integer read m_nGiveBackLoginType write m_nGiveBackLoginType;
    property strGiveBackLoginName: string read m_strGiveBackLoginName write m_strGiveBackLoginName;
    property dtGiveBackTime: tdatetime read m_dtGiveBackTime write m_dtGiveBackTime;
    property dtModifyTime: tdatetime read m_dtModifyTime write m_dtModifyTime;
    property strDetails: string read m_strDetails write m_strDetails;
    property strRemark: string read m_strRemark write m_strRemark;   
  end;

  TRsLendingInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingInfo;
    procedure SetItem(Index: Integer; AObject: TRsLendingInfo);
  public
    {����:��������}
    procedure Clone(LendingInfoList: TRsLendingInfoList);
    property Items[Index: Integer]: TRsLendingInfo read GetItem write SetItem; default;
  end;


  TRsLendingTongJi = class(TPersistent)
  private
    m_nLendingType: integer;
    m_strLendingTypeName: string;
    m_strTypeAlias: string;
    m_nTotalCount: integer;
    m_nNoReturnCount: integer;
  published
    property nLendingType: integer read m_nLendingType write m_nLendingType;
    property strLendingTypeName: string read m_strLendingTypeName write m_strLendingTypeName;
    property strTypeAlias: string read m_strTypeAlias write m_strTypeAlias;
    property nTotalCount: integer read m_nTotalCount write m_nTotalCount;
    property nNoReturnCount: integer read m_nNoReturnCount write m_nNoReturnCount;

  end;


  TRslendingToJiList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingTongJi;
    procedure SetItem(Index: Integer; AObject: TRsLendingTongJi);
  public
    property Items[Index: Integer]: TRsLendingTongJi read GetItem write SetItem; default;
  end;



  
  {����:�������Ʒ�ַ���}
  procedure SplitLendingString(strLendings: string;LendingsList: TStringList);
implementation
procedure SplitLendingString(strLendings: string;LendingsList: TStringList);
begin
  LendingsList.Delimiter := '+';
  LendingsList.DelimitedText := strLendings;
end;
{ TReturnStateList }

function TRsReturnStateList.GetItem(Index: Integer): TRsReturnState;
begin
  Result := TRsReturnState(inherited GetItem(Index));
end;

procedure TRsReturnStateList.SetItem(Index: Integer; AObject: TRsReturnState);
begin
  inherited SetItem(Index,AObject);
end;

{ TLendingTypeList }

function TRsLendingTypeList.FindAliasByID(ID: Integer): string;
var
  i: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
  begin
    if Items[i].nLendingTypeID = ID then
    begin
      Result := Items[i].strAlias;
      Break;
    end;
  end;
end;

function TRsLendingTypeList.FindTypeByAlias(strAlias: string): TRsLendingType;
var
  i: Integer;
begin
  Result := nil;
  for I := 0 to Count - 1 do
  begin
    if UpperCase(strAlias) = UpperCase(Items[i].strAlias) then
    begin
      Result := Items[i];
      Break;
    end;
    
  end;
end;

function TRsLendingTypeList.GetItem(Index: Integer): TRsLendingType;
begin
  Result := TRsLendingType(inherited GetItem(Index));
end;

procedure TRsLendingTypeList.SetItem(Index: Integer; AObject: TRsLendingType);
begin
  inherited SetItem(Index,AObject);
end;

{ TLendingInfoList }

procedure TRsLendingInfoList.Clone(LendingInfoList: TRsLendingInfoList);
{����:��������}
var
  i: Integer;
  LendingInfo: TRsLendingInfo;
begin
  Clear();
  for I := 0 to LendingInfoList.Count - 1 do
  begin
    LendingInfo := TRsLendingInfo.Create;
    LendingInfo.Clone(LendingInfoList.Items[i]);
    Add(LendingInfoList);
  end;    
end;

function TRsLendingInfoList.GetItem(Index: Integer): TRsLendingInfo;
begin
  Result := TRsLendingInfo(inherited GetItem(Index));
end;


procedure TRsLendingInfoList.SetItem(Index: Integer; AObject: TRsLendingInfo);
begin
  inherited SetItem(Index,AObject);
end;

{ TLendingDetailList }

procedure TRsLendingDetailList.Clone(LendingDetailList: TRsLendingDetailList);
{����:��������}
var
  i: Integer;
  Detail: TRsLendingDetail;
begin
  Clear();
  for I := 0 to LendingDetailList.Count - 1 do
  begin
    Detail := TRsLendingDetail.Create;
    Detail.Clone(LendingDetailList.Items[i]);
    Add(Detail);
  end;
    
end;

function TRsLendingDetailList.CombineExInfoToString(TypeID: Integer): string;
var
  I: Integer;
begin
  Result := '';
  for I := 0 to Count - 1 do
  begin
    if Items[i].nLendingType = typeid then
      Result := Result + '+' +  IntToStr(Items[i].strLendingExInfo);
  end;

  Result := Copy(Result,2,Length(Result) - 1);
end;

function TRsLendingDetailList.GetItem(Index: Integer): TRsLendingDetail;
begin
  Result := TRsLendingDetail(inherited GetItem(Index));
end;

function TRsLendingDetailList.Include(
  LendingDetailList: TRsLendingDetailList): Boolean;
{����:�ж��Ƿ����ָ����Ʒ�б�}
var
  i,j: Integer;
  bFind: Boolean;
begin
  Result := True;
  for I := 0 to LendingDetailList.Count - 1 do
  begin
    bFind := False;
    for j := 0 to Self.Count - 1 do
    begin
      if (LendingDetailList.Items[i].nLendingType = Items[j].nLendingType)
        and (LendingDetailList.Items[i].strLendingExInfo = Items[j].strLendingExInfo) then
      begin
        bFind := True;
        Break;
      end;
      
    end;

    if not bFind then
    begin
      Result := False;
      Break;
    end;
  end;
    
end;


function TRsLendingDetailList.IndexByContent(
  LendingDetail: TRsLendingDetail): Integer;
var
  i: Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if (Items[i].nLendingType = LendingDetail.nLendingType)
      and (Items[i].strLendingExInfo = LendingDetail.strLendingExInfo) then
    begin
     Result := i;
     Exit;
    end;


  end;
end;

procedure TRsLendingDetailList.SetItem(Index: Integer; AObject: TRsLendingDetail);
begin
  inherited SetItem(Index,AObject);
end;
{ TLendingInfo }

procedure TRsLendingInfo.Clone(LendingInfo: TRsLendingInfo);
{����:��������}
begin
  Self.strGUID := LendingInfo.strGUID;
  Self.nReturnState := LendingInfo.nReturnState;
  Self.strStateName := LendingInfo.strStateName;
  Self.strBorrowTrainmanGUID := LendingInfo.strBorrowTrainmanGUID;
  Self.strBorrowTrainmanName := LendingInfo.strBorrowTrainmanName;
  Self.strBorrowTrainmanNumber := LendingInfo.strBorrowTrainmanNumber;
  Self.nBorrowLoginType := LendingInfo.nBorrowLoginType;
  Self.dtBorrowTime := LendingInfo.dtBorrowTime;
  Self.strLenderGUID := LendingInfo.strLenderGUID;
  Self.strLenderNumber := LendingInfo.strLenderNumber;
  Self.strLenderName := LendingInfo.strLenderName;
  Self.strGiveBackTrainmanGUID := LendingInfo.strGiveBackTrainmanGUID;
  Self.strGiveBackTrainmanName := LendingInfo.strGiveBackTrainmanName;
  Self.strGiveBackTrainmanNumber := LendingInfo.strGiveBackTrainmanNumber;
  Self.nGiveBackLoginType := LendingInfo.nGiveBackLoginType;
  Self.dtGiveBackTime := LendingInfo.dtGiveBackTime;
  Self.dtModifyTime := LendingInfo.dtModifyTime;
  Self.strRemark := LendingInfo.strRemark;
  Self.strDetails := LendingInfo.strDetails;
end;

constructor TRsLendingInfo.Create;
begin
  nBorrowLoginType := -1;
  nGiveBackLoginType := -1;
end;

function TRsLendingInfo.IsValid: Boolean;
begin
  Result := strGUID <> '';
end;

{ TLendingDetail }

procedure TRsLendingDetail.Clone(LendingDetail: TRsLendingDetail);
{����:��������}
begin
  strGUID := LendingDetail.strGUID;
  strLendingInfoGUID := LendingDetail.strLendingInfoGUID;
  nLendingType := LendingDetail.nLendingType;
  strLendingTypeName := LendingDetail.strLendingTypeName;
  strLendingTypeAlias := LendingDetail.strLendingTypeAlias;
  strLendingExInfo := LendingDetail.strLendingExInfo;
  nReturnState := LendingDetail.nReturnState;
end;

function TRsLendingDetail.CombineAliasName: string;
{����:����ַ���}
begin
  Result := strLendingTypeAlias + IntToStr(strLendingExInfo);
end;

{ TlendingToJiList }

function TRslendingToJiList.GetItem(Index: Integer): TRsLendingTongJi;
begin
  Result := TRsLendingTongJi(inherited GetItem(Index));
end;

procedure TRslendingToJiList.SetItem(Index: Integer; AObject: TRsLendingTongJi);
begin
  inherited SetItem(Index,AObject);
end;

end.
