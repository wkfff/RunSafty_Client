unit uTrainJiaoluItem;

interface

uses
  SysUtils,Classes,Graphics,Contnrs,uTrainPlan ;

type
  //һ����·����Ϣ
  TRsTrainJiaoluItem = class
  public
    constructor Create();
    destructor Destroy();override;
  private
    //��·GUID
    m_strJiaoLuGUID:string;
    //��·����
    m_strJiaoLuName:string;
  public
    //��·�����plan
    PlanList:TStrings;
  public
    property JiaoLuGUID:string read  m_strJiaoLuGUID write m_strJiaoLuGUID ;
    property JiaoLuName:string read  m_strJiaoLuName write m_strJiaoLuName ;
  end;


  //��·�б����Ϣ
  TRsTrainJiaoluItemList =class(TObjectList)
  public
    //��ȡ
    function GetItem(Index: Integer): TRsTrainJiaoluItem;
    //����
    procedure SetItem(Index: Integer; AObject: TRsTrainJiaoluItem);
    //���
    function Add(AObject: TRsTrainJiaoluItem): Integer;
    //ɾ��
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
