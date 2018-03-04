unit uTrainman;

interface
uses
  Classes, SysUtils, Forms, windows, adodb, DB,uTFSystem,Contnrs,
  CustomProperties;


const
  //测酒结果属性名称
  PROPERTIES_TESTALCOHOLRESULT = 'TestResult';
  //工作流ID
  PROPERTIES_WORKID = 'WorkID';
  PROPERTIES_PlanID = 'PlanID';

  PROPERTIES_WorkOver = 'WorkOver';

  PROPERTIES_RequireTrainman = 'RequireTrainman';
  //交路号
  PROPERTIES_JIAOLU = 'JiaoLuNumber';
  //车站号
  PROPERTIES_STATION = 'CheZhanNumber';
  //职务
  PROPERTIES_DUTY = 'Duty';
  //客货
  PROPERTIES_KEHUO = 'KeHuo';
  //车型
  PROPERTIES_CHEXING = 'CheXing';
  //车号
  PROPERTIES_CHEHAO = 'CheHao';
  //车次
  PROPERTIES_CHECI = 'CheCi';
  //车次头
  PROPERTIES_CHECIHEAD = 'CheCiHead';
  //发车时间
  PROPERTIES_FaCheShiJian = 'FaCheShiJian';
  //到达时间
  PROPERTIES_DaoDaShiJian = 'DaoDaShiJian';
  //区段
  PROPERTIES_SECTION = 'Section';

  {车站号}
  PROPERTIES_STATIONNUMBER = 'StationNumber';
  {交路号}
  PROPERTIES_JIAOLUNUMBER = 'JiaoLuNumber';
  {登记方式}
  PROPERTIES_REGISTERFLAG = 'RegisterFlag';
  {值班员ID}
  PROPERTIES_DUTYUSERID = 'DutyUserID';
  {出勤地点ID}
  PROPERTIES_AREAGUID = 'AreaGUID';
  {写卡确认方式}
  PROPERTIES_WRITECARDCONFIRMTYPE = 'WriteCardConfirmType';

type

  {TRegisterFlag 乘务员身份登记类别}
  TRegisterFlag  = (rfInput{手动输入},rfFingerprint{指纹});

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTrainman
  /// 说明:乘务员信息
  //////////////////////////////////////////////////////////////////////////////
  TTrainman = class
  public
    constructor Create();
    destructor Destroy();override;
    procedure Copy(Trainman:TTrainman);
  private
    {乘务员状态信息}
    m_StateInfo : TCustomProperties;
  public
    nID : Integer;
    {ID}
    GUID: string;
    {工号}
    TrainmanNumber: string;
    {姓名}
    TrainmanName: string;
    {职务}
    Duty : String;
    {指纹1}
    FingerPrint1 : OleVariant;
    {指纹2}
    FingerPrint2 : OleVariant;
    {照片}
    Picture : TMemoryStream;
    {联系电话}
    TelNumber : String;
    {备注}
    Remark : String;
    {所属组织结构ID}
    RelationID : String;
    property StateInfo : TCustomProperties read m_StateInfo;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// 类名:TTrainmanList
  /// 说明:乘务员信息列表
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTrainman;
    procedure SetItem(Index: Integer; Trainman: TTrainman);
  public
    {功能:根据工号获得乘务员对象}
    function IndexOfByNumber(strTrainmanNumber:String):Integer;
  public
    function Add(Trainman: TTrainman): Integer;
    property Items[Index: Integer]: TTrainman read GetItem write SetItem; default;
  end;

implementation

{ TTrainmanList }

function TTrainmanList.Add(Trainman: TTrainman): Integer;
begin
  Result := inherited Add(Trainman);
end;

function TTrainmanList.GetItem(Index: Integer): TTrainman;
begin
  Result := TTrainman(inherited GetItem(Index));
end;

function TTrainmanList.IndexOfByNumber(strTrainmanNumber: String): Integer;
var
  i : Integer;
begin
  Result := -1;
  for I := 0 to Count - 1 do
  begin
    if Items[i].TrainmanNumber = strTrainmanNumber then
    begin
      Result := i;
      Break;
    end;
  end;
end;

procedure TTrainmanList.SetItem(Index: Integer; Trainman: TTrainman);
begin
  inherited SetItem(Index,Trainman);
end;

{ TTrainman }

procedure TTrainman.Copy(Trainman: TTrainman);
begin
  nID := Trainman.nID;
  {ID}
  GUID:= Trainman.GUID;
  {工号}
  TrainmanNumber:=Trainman.TrainmanNumber;
  {姓名}
  TrainmanName:= Trainman.TrainmanName;
  {职务}
  Duty := Trainman.Duty;
  {指纹1}
  FingerPrint1 := Trainman.FingerPrint1;
  {指纹2}
  FingerPrint2 := Trainman.FingerPrint2;
  {照片}
  Picture.LoadFromStream(Trainman.Picture);
  {联系电话}
  TelNumber := trainman.TelNumber;
  {备注}
  Remark := trainman.Remark;
  {所属组织结构ID}
  RelationID := trainman.RelationID;
end;

constructor TTrainman.Create;
begin
  Picture := TMemoryStream.Create;
  m_StateInfo := TCustomProperties.Create;
end;

destructor TTrainman.Destroy;
begin
  Picture.Free;
  m_StateInfo.Free;
  inherited;
end;

end.

