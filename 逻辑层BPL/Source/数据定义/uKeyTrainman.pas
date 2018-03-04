unit uKeyTrainman;

interface
uses sysutils,classes,contnrs;
type

  //关键人操作类型
   EKeyTrainmanOpt  = (KTMAdd{增加},KTMModify{修改},KTMdel{删除});

  //关键人结构体值属性封装
  RKeyTrainman = record
  public
    //id
    strGUID:string;
    //关键人工号
    strKeyTMNumber:string;
    //关键人姓名
    strKeyTMName:string;
    //关键人所属车间id
    strKeyTMWorkShopGUID:string;
    //关键人所属车间名称
    strKeyTMWorkShopName:string;
    //关键人所属车队id
    strKeyTMCheDuiGUID:string;
    //关键人所属车队名称
    strKeyTMCheDuiName:string;
    //关键人开始时间
    dtKeyStartTime:TDatetime;
    //关键人截止时间
    dtKeyEndTime:TDatetime;
    //登记原因
    strKeyReason:string;
    //登记注意事项
    strKeyAnnouncements:string;
    //登记人工号
    strRegisterNumber:string;
    //登记人姓名
    strRegisterName:string;
    //登记日期
    dtRegisterTime:TDateTime;
    //客户端编号
    strClientNumber:string;
    //客户端名称
    strClientName:string;
    //操作类型
    eOpt:EKeyTrainmanOpt;
  end;
  //关键人对象
  TKeyTrainman = class
  public
    //关键人值字段结构体
    rKeyTM :RKeyTrainman;
  public
    //克隆
    procedure Clone(keyMan:TKeyTrainman);
  end;

  //关键人列表
  TKeyTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TKeyTrainman;
    procedure SetItem(Index: Integer; AObject: TKeyTrainman);
  public
    function Add(AObject: TKeyTrainman): Integer;
    property Items[Index: Integer]: TKeyTrainman read GetItem write SetItem; default;
  end;




implementation

{ TKeyTrainmanList }

function TKeyTrainmanList.Add(AObject: TKeyTrainman): Integer;
begin
  result := inherited Add(AObject);
end;

function TKeyTrainmanList.GetItem(Index: Integer): TKeyTrainman;
begin
  result := TKeyTrainman(inherited GetItem(Index));
end;

procedure TKeyTrainmanList.SetItem(Index: Integer; AObject: TKeyTrainman);
begin
  inherited SetItem(Index,AObject);
end;

{ TKeyTrainman }

procedure TKeyTrainman.Clone(keyMan: TKeyTrainman);
begin
  Self.rKeyTM := keyMan.rKeyTM;
end;

end.
