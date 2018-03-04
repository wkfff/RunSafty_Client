unit uLendingDefine;

interface
uses
  Classes,SysUtils,Contnrs;
type
  {TReturnState  物品归还状态}
  TRsReturnState = class(TPersistent)
  private
    m_nReturnStateID: Integer;
    {状态名称}
    m_strStateName: string;
  published
    {状态ID}
    property nReturnStateID: Integer read m_nReturnStateID write m_nReturnStateID;
    {状态名称}
    property strStateName: string read m_strStateName write m_strStateName;
  end;

  {TReturnStateList  物品归还状态列表}
  TRsReturnStateList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsReturnState;
    procedure SetItem(Index: Integer; AObject: TRsReturnState);
  public
    property Items[Index: Integer]: TRsReturnState read GetItem write SetItem; default;
  end;



  TRsLendingType = class(TPersistent)
  private
    {类型ID}
    m_nLendingTypeID: Integer;
    {借出物品名称}
    m_strLendingTypeName: string;
    {物品别名}
    m_strAlias: string;
  published
    property nLendingTypeID: Integer read m_nLendingTypeID write m_nLendingTypeID;
    property strLendingTypeName: string read m_strLendingTypeName write m_strLendingTypeName;
    property strAlias: string read m_strAlias write m_strAlias;
  end;
  
  {TLendingTypeList  借出物品类型列表}
  TRsLendingTypeList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingType;
    procedure SetItem(Index: Integer; AObject: TRsLendingType);
  public
    function FindTypeByAlias(strAlias: string): TRsLendingType;
    function FindAliasByID(ID: Integer): string;
    property Items[Index: Integer]: TRsLendingType read GetItem write SetItem; default;
  end;

  {TLendingDetail 借出物品详细信息}
  TRsLendingDetail = class(TPersistent)
  private
    {记录GUID}
    m_strGUID: string;
    {借出记录GUID}
    m_strLendingInfoGUID: string;
    {借用人GUID}
    m_strTrainmanGUID: string;
    {借用人工号}
    m_strTrainmanNumber: string;
    {借用人姓名}
    m_strTrainmanName: string;
    {借出办理人GUID}
    m_strLenderGUID: string;
    {借出办理人工号}
    m_strLenderNumber: string;
    {借出办理人姓名}
    m_strLenderName: string;
    {归还办理人GUID}
    m_strGiveBackTrainmanGUID: string;
    {归还办理人工号} 
    m_strGiveBackTrainmanNumber: string;
    {归还办理人姓名}
    m_strGiveBackTrainmanName: string;
    {借出物品类型}
    m_nLendingType: integer;
    {物品名称}
    m_strLendingTypeName: string;
    {物品别名}
    m_strLendingTypeAlias: string;
    {物品附加信息，编号}
    m_strLendingExInfo: integer;
    {领用登记验证方式}
    m_nBorrowVerifyType: integer;
    {归还登记验证方式}
    m_nGiveBackVerifyType: integer;
    {领用登记验证方式名称}
    m_strBorrowVerifyTypeName: string;
    {归还验证方式}
    m_strGiveBackVerifyTypeName: string;
    {物品归还状态}
    m_nReturnState: integer;
    {归还状态名称}
    m_strStateName: string;
    {借出时间}
    m_dtBorrwoTime: tdatetime;
    {归还时间}
    m_dtGiveBackTime: tdatetime;
    {最后修改时间}
    m_dtModifyTime: tdatetime;
    {已借时长}
    m_nKeepMunites: integer;  
  public
    {功能:复制数据}
    procedure Clone(LendingDetail: TRsLendingDetail);
    {功能:组合字符串}
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


  {TLendingDetailList 借出物品列表}
  TRsLendingDetailList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TRsLendingDetail;
    procedure SetItem(Index: Integer; AObject: TRsLendingDetail);
  public
    function CombineExInfoToString(TypeID: Integer): string;
    
    function IndexByContent(LendingDetail: TRsLendingDetail): Integer;
    {功能:复制数据}
    procedure Clone(LendingDetailList: TRsLendingDetailList);
    {功能:判断是否包含指定物品列表}
    function Include(LendingDetailList: TRsLendingDetailList): Boolean;
    property Items[Index: Integer]: TRsLendingDetail read GetItem write SetItem; default;
  end;


  {TLendingInfo  出借记录}
  TRsLendingInfo = class(TPersistent)
  public
    constructor Create();
  private
    {记录ID}
    m_strGUID: string;
    {归还状态}
    m_nReturnState: integer;
    {归还状态名称}
    m_strStateName: string;
    {借用人GUID}
    m_strBorrowTrainmanGUID: string;
    {借用人姓名}
    m_strBorrowTrainmanName: string;
    {借用人工号}
    m_strBorrowTrainmanNumber: string;
    {借用登记方式}
    m_nBorrowLoginType: integer;
    {借用登记方式名称}
    m_strBorrowLoginName: string;
    {借用时间}
    m_dtBorrowTime: tdatetime;
    {借出办理人GUID}
    m_strLenderGUID: string;
    {借出办理人工号}
    m_strLenderNumber: string;
    {借出办理人姓名}
    m_strLenderName: string;
    {归还办理人GUID}
    m_strGiveBackTrainmanGUID: string;
    {归还办理人姓名}
    m_strGiveBackTrainmanName: string;
    {归还办理人工事情}
    m_strGiveBackTrainmanNumber: string;
    {归还登记方式}
    m_nGiveBackLoginType: integer;
    {归还登记方式名称}
    m_strGiveBackLoginName: string;
    {归还时间}
    m_dtGiveBackTime: tdatetime;
    {记录最后修改时间}
    m_dtModifyTime: tdatetime;
    {借用物品详细}
    m_strDetails: string;
    {备注}                 
    m_strRemark: string;    
  public
    {功能:复制数据}
    procedure Clone(LendingInfo: TRsLendingInfo);
    {功能:判断是否为一个有效的记录}
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
    {功能:复制数据}
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



  
  {功能:拆分用物品字符串}
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
{功能:复制数据}
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
{功能:复制数据}
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
{功能:判断是否包含指定物品列表}
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
{功能:复制数据}
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
{功能:复制数据}
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
{功能:组合字符串}
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
