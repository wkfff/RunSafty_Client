unit uTrainman;

interface
uses
  Classes, SysUtils, Forms, windows, adodb, DB,uTFSystem,Contnrs,
  CustomProperties;


const
  //��ƽ����������
  PROPERTIES_TESTALCOHOLRESULT = 'TestResult';
  //������ID
  PROPERTIES_WORKID = 'WorkID';
  PROPERTIES_PlanID = 'PlanID';

  PROPERTIES_WorkOver = 'WorkOver';

  PROPERTIES_RequireTrainman = 'RequireTrainman';
  //��·��
  PROPERTIES_JIAOLU = 'JiaoLuNumber';
  //��վ��
  PROPERTIES_STATION = 'CheZhanNumber';
  //ְ��
  PROPERTIES_DUTY = 'Duty';
  //�ͻ�
  PROPERTIES_KEHUO = 'KeHuo';
  //����
  PROPERTIES_CHEXING = 'CheXing';
  //����
  PROPERTIES_CHEHAO = 'CheHao';
  //����
  PROPERTIES_CHECI = 'CheCi';
  //����ͷ
  PROPERTIES_CHECIHEAD = 'CheCiHead';
  //����ʱ��
  PROPERTIES_FaCheShiJian = 'FaCheShiJian';
  //����ʱ��
  PROPERTIES_DaoDaShiJian = 'DaoDaShiJian';
  //����
  PROPERTIES_SECTION = 'Section';

  {��վ��}
  PROPERTIES_STATIONNUMBER = 'StationNumber';
  {��·��}
  PROPERTIES_JIAOLUNUMBER = 'JiaoLuNumber';
  {�ǼǷ�ʽ}
  PROPERTIES_REGISTERFLAG = 'RegisterFlag';
  {ֵ��ԱID}
  PROPERTIES_DUTYUSERID = 'DutyUserID';
  {���ڵص�ID}
  PROPERTIES_AREAGUID = 'AreaGUID';
  {д��ȷ�Ϸ�ʽ}
  PROPERTIES_WRITECARDCONFIRMTYPE = 'WriteCardConfirmType';

type

  {TRegisterFlag ����Ա��ݵǼ����}
  TRegisterFlag  = (rfInput{�ֶ�����},rfFingerprint{ָ��});

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTrainman
  /// ˵��:����Ա��Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TTrainman = class
  public
    constructor Create();
    destructor Destroy();override;
    procedure Copy(Trainman:TTrainman);
  private
    {����Ա״̬��Ϣ}
    m_StateInfo : TCustomProperties;
  public
    nID : Integer;
    {ID}
    GUID: string;
    {����}
    TrainmanNumber: string;
    {����}
    TrainmanName: string;
    {ְ��}
    Duty : String;
    {ָ��1}
    FingerPrint1 : OleVariant;
    {ָ��2}
    FingerPrint2 : OleVariant;
    {��Ƭ}
    Picture : TMemoryStream;
    {��ϵ�绰}
    TelNumber : String;
    {��ע}
    Remark : String;
    {������֯�ṹID}
    RelationID : String;
    property StateInfo : TCustomProperties read m_StateInfo;
  end;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TTrainmanList
  /// ˵��:����Ա��Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TTrainman;
    procedure SetItem(Index: Integer; Trainman: TTrainman);
  public
    {����:���ݹ��Ż�ó���Ա����}
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
  {����}
  TrainmanNumber:=Trainman.TrainmanNumber;
  {����}
  TrainmanName:= Trainman.TrainmanName;
  {ְ��}
  Duty := Trainman.Duty;
  {ָ��1}
  FingerPrint1 := Trainman.FingerPrint1;
  {ָ��2}
  FingerPrint2 := Trainman.FingerPrint2;
  {��Ƭ}
  Picture.LoadFromStream(Trainman.Picture);
  {��ϵ�绰}
  TelNumber := trainman.TelNumber;
  {��ע}
  Remark := trainman.Remark;
  {������֯�ṹID}
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

