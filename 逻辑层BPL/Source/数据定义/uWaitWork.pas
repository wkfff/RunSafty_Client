unit uWaitWork;

interface
uses
  Classes,SysUtils,Contnrs,uSaftyEnum,uTFSystem,superobject,uPubFun,uTrainman,
  StrUtils;
type

  TWaitWorkPlanType =(TWWPT_ASSIGN{�ɰ�},TWWPT_SIGN{ǩ��},TWWPT_LOCAL{����});

  TInOutRoomType = (TInRoom{�빫Ԣ},TOutRoom{����Ԣ}) ;

  //////////////////////////////////////////////////////////////////////////////
  /// ����:TSyncPlanIDInfo
  /// ����:��ͬ�����˼ƻ�ID�Լ��ƻ�������Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TSyncPlanIDInfo = class
    //�ƻ�GUID
    strPlanGUID:string;
    //�ƻ����
    ePlanType: TWaitWorkPlanType;
  end;

  {��ͬ�����˼ƻ� id,������Ϣ�б�}
  TSyncPlanIDInfoList  = class(TObjectList)
  protected
    function GetItem(Index: Integer): TSyncPlanIDInfo;
    procedure SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
  public
    function Add(AObject: TSyncPlanIDInfo): Integer;
    property Items[Index: Integer]: TSyncPlanIDInfo read GetItem write SetItem; default;
  end;

  /////////////////////////////////////////////////////////////////////////////
  ///�ṹ����:RRSInOutRoomInfo
  ///����:����Ա���빫Ԣ��Ϣ
  /////////////////////////////////////////////////////////////////////////////
  RRSInOutRoomInfo= record
  public
    //��¼GUID
    strGUID:string;
    //��Ԣ��¼GUID
    strInRoomGUID:string;
    //�г��ƻ�GUID
    strTrainPlanGUID  :string;
    //���ƻ�GUID
    strWaitPlanGUID:string;
    //���빫Ԣʱ��
    dtInOutRoomTime:TDateTime;
    //�����֤����
    eVerifyType :TRsRegisterFlag;
    //ֵ��ԱGUID
    strDutyUserGUID:string;
    //˾��GUID
    strTrainmanGUID:string;
    //˾������
    strTrainmanNumber:string;
    //˾������
    strTrainmanName:string;
    //��¼����ʱ��
    dtCreatetTime  :TDateTime;
    //�ͻ���guid
    strSiteGUID  :string;
    //�����
    strRoomNumber :string;
    //��λ��
    nBedNumber :Integer;
    //�Ƿ�ͬ��
    bUploaded:Boolean;
    //���ƻ�����
    eWaitPlanType:TWaitWorkPlanType;
    //���ʱ��
    dtArriveTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //���빫Ԣ���
    eInOutType:TInOutRoomType;
  public
    {����:ת��Ϊjson����}
    function ToJsonStr(inOutType:TInOutRoomType):string;
  end;
  //���빫Ԣ��Ϣ����
  RRsInOutRoomInfoArray= array of RRSInOutRoomInfo;


  (*
  //////////////////////////////////////////////////////////////////////////////
  ///����:TInOutRoomInfo
  ///����:��Ա���빫Ԣ��Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfo = class
  public
    {����:����ֵ}
    procedure SetValues(strGUID,strPlanGUID,strTrainmanGUID:string;
        eType:TInOutRoomType;dtTime:TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
    {����:����}
    procedure Reset();
       {����:ת��ΪJSON����}
    function ToJsonStr():string;

  public
    //��¼GUID
    strGUID:string;
    //���ƻ�GUID
    strPlanGUID:string;
    //��ԱGUID
    strTrainmanGUID:string;
    //���빫Ԣ����
    eType:TInOutRoomType;
    //���빫Ԣʱ��
    dtTime:TDateTime;
    //���ʱ��
    dtArriveTime:TDateTime;
    // �Ƿ��ϴ�
    bUpload :Boolean;
    //�ƻ�����
    ePlanType:TWaitWorkPlanType;
  end;
  *)

  (*
  //////////////////////////////////////////////////////////////////////////////
  ///����:TInOutRoomInfoList
  ///����:��Ա���빫Ԣ��Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TInOutRoomInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TInOutRoomInfo;
    procedure SetItem(Index: Integer; AObject: TInOutRoomInfo);
  public
    function Add(AObject: TInOutRoomInfo): Integer;
    property Items[Index: Integer]: TInOutRoomInfo read GetItem write SetItem; default;
    {����:ת��Ϊjson��}
    function ToJsonStr():string;

  end;
  *)

  //////////////////////////////////////////////////////////////////////////////
  ///����:TWaitWorkTrainmanInfo
  ///����:��Ա���ƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfo = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //���
    nIndex:Integer;
    //��¼guid
    strGUID:string;
    //�ƻ�guid
    strPlanGUID:string;
    //��ԱGUID
    strTrainmanGUID:string;
    //��Ա����
    strTrainmanNumber:string;
    //��Ա����
    strTrainmanName:string;
    //�ƻ�״̬
    eTMState:TRsPlanState;
    //ʵ�ʷ���
    strRealRoom:string;
    //��Ԣ��¼
    InRoomInfo:RRSInOutRoomInfo;
    //����Ԣ��¼
    OutRoomInfo:RRSInOutRoomInfo;
  public
    {����:��ȡ״̬}
    function GetStateStr():string;
  end;
  //////////////////////////////////////////////////////////////////////////////
  ///����:TWaitWorkTrainmanList
  ///����:��Ա���ƻ���Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkTrainmanInfoList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitWorkTrainmanInfo;
    procedure SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
  public
    {����:������Ա}
    function findTrainman(strTrainmanGUID:string): TWaitWorkTrainmanInfo;
    {����:������Ա���չ���}
    function FindTrainman_GH(strGH:string):TWaitWorkTrainmanInfo;
    {����:�ҵ���һ����ȱ��Ա}
    function FindEmptyTrainman():TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitWorkTrainmanInfo): Integer;
    property Items[Index: Integer]: TWaitWorkTrainmanInfo read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  ///  ������TWaitWorkPlan
  ///  ���������ƻ�
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlan = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //���
    nIndex:Integer;
    //���ƻ�GUID
    strPlanGUID:string;
    //ǩ��ƻ�GUID
    strSignPlanGUID:string;
    //����GUID
    strCheJianGUID:string;
    //��������
    strCheJianName:string;
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��·����
    strTrainJiaoLuName:string;
    //��·���
    strTrainJiaoLuNickName:string;
    //�Ƿ�����

    nNeedRest:Integer;
    //�ƻ�״̬
    ePlanState: TRsPlanState;
    //�ƻ�GUID
    strTrainPlanGUID:string ;
    //����
    strCheCi:string;
    //���ʱ��
    dtWaitWorkTime:TDateTime;
    //�а�ʱ��
    dtCallWorkTime:TDateTime;
    //����ʱ��
    dtBeginWorkTime:TDateTime ;
    //����ʱ��
    dtKaiCheTime : TDateTime ;
    //�����
    strRoomNum:string;
    //����
    ePlanType:TWaitWorkPlanType;
    //��Ҫͬ���а�
    nNeedSyncCall:Boolean;
    //��Ա�ƻ��б�
    tmPlanList : TWaitWorkTrainmanInfoList;
  public
    {����:��ȡʵ����Ա����}
    function GetTrainmanCount():Integer;
    {����:��ȡδ��Ԣ��Ա����}
    function GetUnOutRoomTrainmanCount():Integer;
    {����:�ж��Ƿ��ѳ���Ԣ}
    function bAllOutRoom():Boolean;
    {����:�ж��Ƿ�����Ԣ}
    function bAllInRoom():Boolean;
    {����:������Ա��Ԣ�ƻ�}
    function AddTrainman(Trainman:RRsTrainman;var strResult:string):TWaitWorkTrainmanInfo;
    {����:������Ա}
    procedure AddNewTrianman(strGUID,strNumber,strName:string);
    {����:��ȡ״̬����}
    function GetStateStr():string;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ������TWaitWorkPlanList
  ///  ���������ƻ��б�
  //////////////////////////////////////////////////////////////////////////////
  TWaitWorkPlanList = class(TObjectList)

  protected
    function GetItem(Index: Integer): TWaitWorkPlan;
    procedure SetItem(Index: Integer; AObject: TWaitWorkPlan);
  public
    {����:���ݼƻ�id���Ҽƻ�}
    function Find(strPlanGUID:string):TWaitWorkPlan;
    {����:���ݷ���Ų��Ҷ���}
    function FindByRoomNum(strRoomNum:string):TWaitWorkPlan;
    {����:���Ҹ��ݳ���}
    function findByCheCi(strCheCi:string):TWaitWorkPlan;
    
    property Items[Index: Integer]: TWaitWorkPlan read GetItem write SetItem; default;
    function Add(AObject: TWaitWorkPlan): Integer;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TWaitRoom
  ///  ����:���˷�����Ϣ
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoom = class
  public
    constructor Create();
    destructor Destroy();override;
  public
    //�����
    strRoomNum:string;

    //������Ա�б�
    waitManList:TWaitWorkTrainmanInfoList;
  end;

  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TRoomWaitManList
  ///  ����:���˷�����ס��Ϣ�б�
  //////////////////////////////////////////////////////////////////////////////
  TWaitRoomList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TWaitRoom;
    procedure SetItem(Index: Integer; AObject: TWaitRoom);
  public
    {����:���ݷ���Ų���}
    function Find(strRoomNum:string):TWaitRoom;
    {����:������ԱGUID������Ա��ס��Ϣ}
    function FindTrainman(strTrainmanGUID:string):TWaitWorkTrainmanInfo;
    function Add(AObject: TWaitRoom): Integer;
    property Items[Index: Integer]: TWaitRoom read GetItem write SetItem; default;
  end;


  //////////////////////////////////////////////////////////////////////////////
  /// ����:RWaitTime
  /// ����:���ʱ�̱��¼
  ///  /////////////////////////////////////////////////////////////////////////
  RWaitTime = record
    //��¼GUID
    strGUID:string;
    //����GUID
    strWorkshopGUID:string;
    //��������
    strWorkShopName:string;
    //��·GUID
    strTrainJiaoLuGUID:string;
    //��·����
    strTrainJiaoLuName:string;
    //��·����
    strTrainJiaoLuNickName:string;
    //����
    strTrainNo:string;
    //�����
    strRoomNum:string;
    //���ʱ��
    dtWaitTime:TDateTime;
    //�а�ʱ��
    dtCallTime:TDateTime;
    //����ʱ��
    dtChuQinTime:TDateTime;
    //����ʱ��
    dtKaiCheTime: TDateTime;
  public
    {����:��ʼ��}
    procedure New();
  end;

  {��෿��ʱ�̱�}
  TWaitTimeAry = array of RWaitTime;

const
  TWaitWorkPlanTypeName : array[TWaitWorkPlanType] of string = ('�ɰ�','ǩ��','����');

implementation

{ TWaitWorkPlanList }

function TWaitWorkPlanList.Add(AObject: TWaitWorkPlan): Integer;
begin
  AObject.nIndex := self.Count;
  Result := inherited Add (AObject);
end;

function TWaitWorkPlanList.Find(strPlanGUID: string): TWaitWorkPlan;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strPlanGUID = strPlanGUID then
    begin
      Result := Items[i];
      Break;
    end;
  end;
end;

function TWaitWorkPlanList.findByCheCi(strCheCi:string):TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if UpperCase(Self.Items[i].strCheCi) = UpperCase(strCheCi) then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;
function TWaitWorkPlanList.FindByRoomNum(strRoomNum: string): TWaitWorkPlan;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Self.Items[i].strRoomNum = strRoomNum then
    begin
      result := Self.Items[i];
      Exit;
    end;
  end;
end;

function TWaitWorkPlanList.GetItem(Index: Integer): TWaitWorkPlan;
begin
  Result := TWaitWorkPlan( inherited GetItem(Index));
end;

procedure TWaitWorkPlanList.SetItem(Index: Integer; AObject: TWaitWorkPlan);
begin
  inherited SetItem(Index,AObject);
end;

{ TWaitWorkPlan }



procedure TWaitWorkPlan.AddNewTrianman(strGUID,strNumber,strName:string);
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  tmPlan:=TWaitWorkTrainmanInfo.Create;
  tmPlan.strGUID := NewGUID;
  tmPlan.strTrainmanGUID := strGUID;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanNumber := strNumber;
  tmPlan.strTrainmanName := strName;
  if tmPlan.strTrainmanGUID <> '' then
    tmPlan.eTMState := psPublish
  else
    tmPlan.eTMState := psEdit;
  self.tmPlanList.Add(tmPlan);
end;

function TWaitWorkPlan.AddTrainman(Trainman:RRsTrainman;var strResult:string): TWaitWorkTrainmanInfo;
var
  tmPlan:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  tmPlan := Self.tmPlanList.findTrainman(Trainman.strTrainmanGUID);
  if Assigned(tmPlan) then //���ҵ�
  begin
    strResult := '�ƻ��ڲ��������ظ��ĳ���Ա!';
    Exit;
  end;

  tmPlan := Self.tmPlanList.FindEmptyTrainman();
  if not Assigned(tmPlan) then
  begin
    strResult := '�ƻ���������������λ����Ա!';
    Exit;
  end;
  tmPlan.strPlanGUID := self.strPlanGUID;
  tmPlan.strTrainmanGUID := Trainman.strTrainmanGUID;
  tmPlan.strTrainmanNumber := Trainman.strTrainmanNumber;
  tmPlan.strTrainmanName := Trainman.strTrainmanName;
  tmPlan.eTMState := psPublish;

  Result := tmPlan;
end;

function TWaitWorkPlan.bAllInRoom():Boolean;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState = psPublish) then
    begin
      result := False;
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.bAllOutRoom: Boolean;
var
  i,nEmptCount:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result:= True;
  if Self.GetTrainmanCount = 0 then
  begin
    result := False;
    Exit;
  end;
  
  for i := 0 to Self.tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.strTrainmanGUID <> '') and (tmInfo.eTMState < psOutRoom) then
    begin
      result := False;
      Exit;
    end;
  end;
  
end;

constructor TWaitWorkPlan.Create;
begin
  tmPlanList := TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitWorkPlan.Destroy;
begin
  tmPlanList.Free;
  inherited;
end;


function TWaitWorkPlan.GetStateStr: string;
var
  i:Integer;
begin
  result := '�ѷ���';
  if Self.bAllOutRoom then
  begin
    result := '����Ԣ';
  end;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    if tmPlanList.Items[i].InRoomInfo.strGUID <>'' then
    begin
      result := '����Ԣ';
      Exit;
    end;
  end;
end;

function TWaitWorkPlan.GetTrainmanCount: Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if tmInfo.strTrainmanGUID <> '' then
      Inc(result);
  end;
end;
function TWaitWorkPlan.GetUnOutRoomTrainmanCount():Integer;
var
  i:Integer;
  tmInfo:TWaitWorkTrainmanInfo;
begin
  result := 0;
  for i := 0 to tmPlanList.Count - 1 do
  begin
    tmInfo := tmPlanList.Items[i];
    if (tmInfo.eTMState > psPublish) and (tmInfo.eTMState < psOutRoom) then
      Inc(Result);
  end;

end;

{ TWaitWorkTrainmanList }

function TWaitWorkTrainmanInfoList.Add(AObject: TWaitWorkTrainmanInfo): Integer;
begin
  AObject.nIndex := self.Count ;
  result := inherited Add(AObject);
end;

function TWaitWorkTrainmanInfoList.FindEmptyTrainman(
  ): TWaitWorkTrainmanInfo;
var
  i:Integer;
  info:TWaitWorkTrainmanInfo;
begin
  Result := nil;
  if Self.Count <4 then
  begin
    info := TWaitWorkTrainmanInfo.Create;
    Self.Add(info);
  end;

  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = '' then
    begin
      Result := Items[i];
      Break;
    end;
  end;


end;

function TWaitWorkTrainmanInfoList.findTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  Result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strTrainmanGUID = strTrainmanGUID then
    begin
      Result := items[i];
      Break;
    end;
  end;
end;

function TWaitWorkTrainmanInfoList.FindTrainman_GH(
  strGH: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    if Items[i].strTrainmanNumber = strGH then
    begin
      result := Items[i];
    end;    
  end;
end;

function TWaitWorkTrainmanInfoList.GetItem(Index: Integer): TWaitWorkTrainmanInfo;
begin
  result := TWaitWorkTrainmanInfo(inherited GetItem(Index));
end;

procedure TWaitWorkTrainmanInfoList.SetItem(Index: Integer; AObject: TWaitWorkTrainmanInfo);
begin
  SetItem(Index,AObject);
end;
(*
{ TInOutRoomInfoList }

function TInOutRoomInfoList.Add(AObject: TInOutRoomInfo): Integer;
begin
  Result := inherited Add(AObject);
end;

function TInOutRoomInfoList.GetItem(Index: Integer): TInOutRoomInfo;
begin
  result := TInOutRoomInfo(inherited GetItem(Index));
end;

procedure TInOutRoomInfoList.SetItem(Index: Integer; AObject: TInOutRoomInfo);
begin
  inherited SetItem(Index,AObject);
end;

function TInOutRoomInfoList.ToJsonStr: string;
var
  i:Integer;
  iJson: ISuperObject;
  infoJson:ISuperObject;
begin
  for i := 0 to self.Count - 1 do
  begin
    infoJson := so(Self.Items[i].ToJsonStr);
    iJson.AsArray.Add(infoJson);
  end;
  result := iJson.asstring;
  iJson := nil;
end;
 *)
{ TWaitWorkTrainmanInfo }

constructor TWaitWorkTrainmanInfo.Create;
begin
end;

destructor TWaitWorkTrainmanInfo.Destroy;
begin
  inherited;
end;

{ TInOutRoomInfo }

function TWaitWorkTrainmanInfo.GetStateStr: string;
begin
  result := '';
  if Self.strTrainmanGUID <> '' then
    Result := 'δ��Ԣ';
  if Self.eTMState > psPublish then
    result := TRsPlanStateNameAry[Self.eTMState];
  Exit;

  if strTrainmanGUID = '' then Exit;
  
  result := 'δ��Ԣ';
  if Self.InRoomInfo.strGUID <> '' then
  begin
    result := '����Ԣ';
  end;
  if Self.OutRoomInfo.strGUID <> '' then
  begin
    result := '����Ԣ';
  end;
  
end;
 (*
procedure TInOutRoomInfo.Reset;
begin
  Self.strGUID := '';
  Self.strPlanGUID := '';
  Self.strTrainmanGUID := '';
  self.eType := TInRoom;
  Self.dtTime := 0;
  Self.dtArriveTime := 0;
  bUpload := False;
end;

procedure TInOutRoomInfo.SetValues(strGUID, strPlanGUID, strTrainmanGUID: string;
    eType: TInOutRoomType; dtTime: TDateTime;dtArriveTime:TDateTime;ePlanType:TWaitWorkPlanType);
begin
  Self.strGUID := strGUID;
  Self.strPlanGUID := strPlanGUID;
  Self.strTrainmanGUID := strTrainmanGUID;
  self.eType := eType;
  Self.dtTime := dtTime;
  self.dtArriveTime := dtArriveTime;
  Self.ePlanType := ePlanType;
  bUpload := False;
end;


function TInOutRoomInfo.ToJsonStr: string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  jso.S['strGUID'] := strGUID;
  jso.s['strWaitPlanGUID'] := strPlanGUID;
  jso.s['strTrainmanGUID'] := strTrainmanGUID;
  jso.I['InOutRoomType'] := Ord(eType);
  jso.s['dtArriveTime']:= FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  jso.s['dtTime'] := FormatDateTime('yyyy-mm-dd HH:mm:ss',dtTime);
  if ePlanType = TWWPT_ASSIGN then
    jso.S['strTrainPlanGUID'] := strPlanGUID;
  Result := jso.AsString;
  jso := nil;
end;
  *)

{ TSyncPlanIDInfoList }

function TSyncPlanIDInfoList.Add(AObject: TSyncPlanIDInfo): Integer;
begin
  result := inherited Add(AObject);
end;

function TSyncPlanIDInfoList.GetItem(Index: Integer): TSyncPlanIDInfo;
begin
  result := TSyncPlanIDInfo(inherited GetItem(Index));
end;

procedure TSyncPlanIDInfoList.SetItem(Index: Integer; AObject: TSyncPlanIDInfo);
begin
  inherited SetItem(Index,AObject);
end;



{ TWaitRoomList }

function TWaitRoomList.Add(AObject: TWaitRoom): Integer;
begin
  Result:= inherited Add(AObject);
end;

function TWaitRoomList.Find(strRoomNum: string): TWaitRoom;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to Self.Count - 1 do
  begin
    if Items[i].strRoomNum = strRoomNum then
    begin
      result := Items[i];
      Exit;
    end;
  end;
end;

function TWaitRoomList.FindTrainman(
  strTrainmanGUID: string): TWaitWorkTrainmanInfo;
var
  i:Integer;
begin
  result := nil;
  for i := 0 to self.Count - 1 do
  begin
    result := self.Items[i].waitManList.findTrainman(strTrainmanGUID);
    if Assigned(Result) then Exit;
  end;
end;

function TWaitRoomList.GetItem(Index: Integer): TWaitRoom;
begin
  result := TWaitRoom(inherited GetItem(index) );
end;

procedure TWaitRoomList.SetItem(Index: Integer;
  AObject: TWaitRoom);
begin
  inherited SetItem(index,AObject);
end;

{ TWaitWorkRoomInfo }

constructor TWaitRoom.Create;
begin
  waitManList:=TWaitWorkTrainmanInfoList.Create;
end;

destructor TWaitRoom.Destroy;
begin
  waitManList.Free;
  inherited;
end;



{ RRSInOutRoomInfo }

function RRSInOutRoomInfo.ToJsonStr(inOutType:TInOutRoomType): string;
var
  jso:ISuperObject;
begin
  jso  := so('{}');
  if inOutType = TInRoom then
  begin
    jso.S['strInRoomGUID'] := strGUID;
    jso.S['dtInRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nInRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  if inOutType = TOutRoom then
  begin
    jso.S['strOutRoomGUID'] := strGUID;
    jso.S['dtOutRoomTime'] := TPubFun.dateTime2Str(dtInOutRoomTime)   ;
    jso.I['nOutRoomVerifyID'] := ord(eVerifyType)   ;
  end;
  jso.S['strTrainPlanGUID'] := strTrainPlanGUID;
  jso.S['strTrainmanNumber'] := strTrainmanNumber;
  jso.S['strTrainmanGUID'] := strTrainmanGUID ;
  jso.S['strDutyUserGUID'] := strDutyUserGUID   ;
  jso.S['strSiteGUID'] := strSiteGUID  ;
  jso.S['strRoomNumber'] := strRoomNumber  ;
  jso.I['nBedNumber'] := nBedNumber  ;
  jso.S['dtCreateTime'] := TPubFun.dateTime2Str(dtCreatetTime)  ;
  jso.S['strWaitPlanGUID'] := strWaitPlanGUID  ;
  jso.I['ePlanType']  := Ord(eWaitPlanType) ;
  jso.S['dtArriveTime'] := TPubFun.DateTime2Str(dtArriveTime);
  //jso.I['bUpLoaded'] := TPubFun.Bool2Int(bUploaded)  ;
  Result := jso.AsString;
  jso := nil;
end;

{ RWaitTime }

procedure RWaitTime.New;
begin
  strGUID := NewGUID();
  strWorkshopGUID:='';
  strWorkShopName:='';
  strTrainJiaoLuGUID:='';
  strTrainJiaoLuName:='';
  strTrainJiaoLuNickName:='';
  strTrainNo:='';
  strRoomNum:='';
  dtWaitTime:=0;
  dtCallTime:=0;
  dtChuQinTime:=0;
  dtKaiCheTime:=0;
end;

end.
