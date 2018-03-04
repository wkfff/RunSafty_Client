unit uLCDict_GanBu;

interface
uses
  uTrainType,Classes,SysUtils,uBaseWebInterface,superobject,Contnrs,
  uJsonSerialize;
type

  TGanBuType = class(TPersistent)
  private
    m_TypeID: string;
    m_strWorkShopGUID: string;
    m_strTypeName: string;
  published
    property TypeID: string read m_TypeID write m_TypeID;
    property WorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property TypeName: string read m_strTypeName write m_strTypeName;
  end;

  TGanBuTypeList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TGanBuType;
    procedure SetItem(Index: Integer; AObject: TGanBuType);
  public
    property Items[Index: Integer]: TGanBuType read GetItem write SetItem; default;
  end;

                        

  TGanBu = class(TPersistent)
  private
    m_RecID: integer;
    m_TypeID: string;
    m_strTypeName: string;
    m_strTrainmanGUID: string;
    m_strTrainmanNumber: string;
    m_strTrainmanName: string;
    m_strWorkShopGUID: string;
    m_strWorkShopName: string;
  published
    property RecID: integer read m_RecID write m_RecID;
    property TypeID: string read m_TypeID write m_TypeID;
    property TypeName: string read m_strTypeName write m_strTypeName;
    property TrainmanGUID: string read m_strTrainmanGUID write m_strTrainmanGUID;
    property TrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property TrainmanName: string read m_strTrainmanName write m_strTrainmanName;
    property WorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
    property WorkShopName: string read m_strWorkShopName write m_strWorkShopName;
  end;

  TGanBuList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TGanBu;
    procedure SetItem(Index: Integer; AObject: TGanBu);
  public
    property Items[Index: Integer]: TGanBu read GetItem write SetItem; default;
  end;


                    


  TRsLCGanBuType = class(TBaseWebInterface)
  public
    function Get(TypeID: string;GanBuType: TGanBuType): Boolean;
    procedure Add(GanBuType: TGanBuType);
    procedure Update(GanBuType: TGanBuType);
    procedure Delete(TypeID: string);
    procedure Query(WorkShopGUID: string;TypeList: TGanBuTypeList);
    procedure ExchangeOrder(WorkShopGUID: string;TypeID1,TypeID2: string);
  end;

  TGanBuQueryParam = class(TPersistent)
  private
    m_TypeID: string;
    m_strTrainmanNumber: string;
    m_strWorkShopGUID: string;
  published
    property TypeID: string read m_TypeID write m_TypeID;
    property TrainmanNumber: string read m_strTrainmanNumber write m_strTrainmanNumber;
    property WorkShopGUID: string read m_strWorkShopGUID write m_strWorkShopGUID;
  end;
  
  //干部管理接口
  TRsLCGanBu = class(TBaseWebInterface)
  public
    constructor Create(AUrl:string;ClientID:string;SiteID:string);
    destructor  Destroy();override;
  private
    m_LCGanBuType: TRsLCGanBuType;
  public
    procedure SetConnConfig(ConnConfig: RInterConnConfig);
    function Get(RecID: integer;GanBu: TGanBu): Boolean;
    procedure Add(GanBu: TGanBu);
    procedure Update(GanBu: TGanBu);
    procedure Delete(RecID: integer);
    procedure Query(GanBuList: TGanBuList;QueryParam: TGanBuQueryParam);
    property LCGanBuType: TRsLCGanBuType read m_LCGanBuType;
  end;

implementation

function TGanBuTypeList.GetItem(Index: Integer): TGanBuType;
begin
  result := TGanBuType(inherited GetItem(Index));
end;
procedure TGanBuTypeList.SetItem(Index: Integer; AObject: TGanBuType);
begin
  Inherited SetItem(Index,AObject);
end;


function TGanBuList.GetItem(Index: Integer): TGanBu;
begin
  result := TGanBu(inherited GetItem(Index));
end;
procedure TGanBuList.SetItem(Index: Integer; AObject: TGanBu);
begin
  Inherited SetItem(Index,AObject);
end;         
{ TRsLCGanBuType }

procedure TRsLCGanBuType.Add(GanBuType: TGanBuType);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := TJsonSerialize.Serialize(GanBuType);
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.Add',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;
procedure TRsLCGanBuType.Delete(TypeID: string);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['TypeID'] := TypeID;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.Delete',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;
procedure TRsLCGanBuType.ExchangeOrder(WorkShopGUID: string; TypeID1,
  TypeID2: string);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['WorkShopGUID'] := WorkShopGUID;
  json.S['TypeID1'] := TypeID1;
  json.S['TypeID2'] := TypeID2;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.ExchangeOrder',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;
end;

function TRsLCGanBuType.Get(TypeID: string;GanBuType: TGanBuType): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.S['TypeID'] := TypeID;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.Get',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;


  Result := json.DataType <> stNull;
  if Result then  
    TJsonSerialize.DeSerialize(json,GanBuType);
end;

procedure TRsLCGanBuType.Query(WorkShopGUID: string;TypeList: TGanBuTypeList);
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
  GanBuType: TGanBuType;
begin
  TypeList.Clear;
  json := CreateInputJson;
  json.S['WorkShopGUID'] := WorkShopGUID;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.Query',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  for I := 0 to json.AsArray.Length - 1 do
  begin
    GanBuType := TGanBuType.Create;
    TypeList.Add(GanBuType);
    TJsonSerialize.DeSerialize(json.AsArray[i],GanBuType);
  end;
end;

procedure TRsLCGanBuType.Update(GanBuType: TGanBuType);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := TJsonSerialize.Serialize(GanBuType);
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.GanBuType.Update',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;
{ TRsLCGanBu }

procedure TRsLCGanBu.Add(GanBu: TGanBu);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := TJsonSerialize.Serialize(GanBu);
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.Add',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;

constructor TRsLCGanBu.Create(AUrl, ClientID, SiteID: string);
begin
  inherited Create(AUrl,ClientID,SiteID);
  m_LCGanBuType := TRsLCGanBuType.Create(AUrl,ClientID,SiteID);
end;

procedure TRsLCGanBu.Delete(RecID: integer);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.I['RecID'] := RecID;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.Delete',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;

destructor TRsLCGanBu.Destroy;
begin
  m_LCGanBuType.Free;
  inherited;
end;

function TRsLCGanBu.Get(RecID: integer;GanBu: TGanBu): Boolean;
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := CreateInputJson;
  json.I['RecID'] := RecID;
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.Get',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;


  Result := json.DataType <> stNull;
  if Result then  
    TJsonSerialize.DeSerialize(json,GanBu);
end;

procedure TRsLCGanBu.Query(GanBuList: TGanBuList; QueryParam: TGanBuQueryParam);
var
  json: ISuperObject;
  strResult : string ;
  i:Integer;
  ErrStr: string;
  GanBu: TGanBu;
begin
  GanBuList.Clear;
  json := TJsonSerialize.Serialize(QueryParam);
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.Query',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

  for I := 0 to json.AsArray.Length - 1 do
  begin
    GanBu := TGanBu.Create;
    GanBuList.Add(GanBu);
    TJsonSerialize.DeSerialize(json.AsArray[i],GanBu);
  end;
end;


procedure TRsLCGanBu.SetConnConfig(ConnConfig: RInterConnConfig);
begin
  Inherited SetConnConfig(ConnConfig);
  m_LCGanBuType.SetConnConfig(ConnConfig);  
end;

procedure TRsLCGanBu.Update(GanBu: TGanBu);
var
  json: ISuperObject;
  strResult : string ;
  ErrStr: string;
begin
  json := TJsonSerialize.Serialize(GanBu);
  strResult := Post('TF.RunSafty.BaseDict.LCGanBu.Update',json.AsString);

  json.Clear();

  if not GetJsonResult(strResult,json,ErrStr) then
  begin
    raise Exception.Create(ErrStr);
  end;

end;
end.
