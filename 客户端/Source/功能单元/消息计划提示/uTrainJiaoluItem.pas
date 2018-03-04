unit uTrainJiaoluItem;

interface

uses
  SysUtils,Classes,Graphics,Contnrs,uTrainPlan ;

type
  //一个交路的信息
  TRsTrainJiaoluItem = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    //交路GUID
    m_strJiaoLuGUID:string;
    //交路名称
    m_strJiaoLuName:string;
  public
    //交路下面的plan
    PlanList:TStrings;
  public
    property JiaoLuGUID:string read  m_strJiaoLuGUID write m_strJiaoLuGUID ;
    property JiaoLuName:string read  m_strJiaoLuName write m_strJiaoLuName ;
  end;


  //交路列表的信息
  TRsTrainJiaoluItemList =class(TObjectList)
  public
    //获取
    function GetItem(Index: Integer): TRsTrainJiaoluItem;
    //设置
    procedure SetItem(Index: Integer; AObject: TRsTrainJiaoluItem);
    //添加
    function Add(AObject: TRsTrainJiaoluItem): Integer;
    //删除
    function Remove(AObject: TRsTrainJiaoluItem): Integer;
  public
    property Items[Index: Integer]: TRsTrainJiaoluItem read GetItem write SetItem;
  end;


implementation

{ TRsTrainJiaoluItem }

constructor TRsTrainJiaoluItem.Create;
begin
  PlanList := TStringList.Create ;
end;

destructor TRsTrainJiaoluItem.Destroy;
begin
  PlanList.Free;
  inherited;
end;



{ TRsTrainJiaoluItemList }

function TRsTrainJiaoluItemList.Add(AObject: TRsTrainJiaoluItem): Integer;
begin
  Result := inherited Add(AObject) ;
end;

function TRsTrainJiaoluItemList.GetItem(Index: Integer): TRsTrainJiaoluItem;
begin
  Result := TRsTrainJiaoluItem (inherited GetItem(index)) ;
end;


function TRsTrainJiaoluItemList.Remove(AObject: TRsTrainJiaoluItem): Integer;
begin
  Result := inherited Remove(AObject)  ;
end;

procedure TRsTrainJiaoluItemList.SetItem(Index: Integer;
  AObject: TRsTrainJiaoluItem);
begin
  inherited SetItem(Index,AObject);
end;

end.
