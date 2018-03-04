unit ufrmBasicDicDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uChildFrmMgr, StdCtrls, ExtCtrls, ComCtrls;

type
  TFrmBasicDictDebug = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
  published
    procedure TestLC_GetAllJwdList();
    procedure TestLC_GetWorkShopOfArea();
    procedure TestLC_GetWorkShopGUIDByName();
    procedure TestLC_GetStationsOfJiaoJu();
    procedure TestLC_GetGuideGroupGUIDByName();
    procedure TestLC_GetGuideGroupOfWorkShop();

    //������·
    procedure TestLC_GetTrainJiaoluArrayOfSite();
    procedure TestLC_GetTrainJiaoluArrayOfWorkShop();
    procedure TestLC_GetAllTrainJiaolu();
    //ͨ����·����ȡ��·GUID
    procedure TestLC_GetTrainJiaoluGUIDByName();
    //��ȡ��·��Ϣ
    procedure TestLC_GetTrainJiaolu();
    //�жϽ�·�Ƿ����ڿͻ��˹�Ͻ
    procedure TestLC_IsJiaoLuInSite();

    //��Ա��·
    //��ȡ������·�µ���Ա��·��Ϣ
    procedure TestLC_GetTMJLByTrainJL();

    //��ȡ������·�µ���Ա��·�����������·Ϊ����ȡ�ͻ��˹�Ͻ�����н�·
    procedure TestLC_GetTMJLByTrainJLWithSite();
      
    //��ȡ������·�µ���Ա��·�����������·Ϊ����ȡ�ͻ��˹�Ͻ�����н�·(�������⽻·)
    procedure TestLC_GetTMJLByTrainJLWithSiteVirtual();

    //���ݿ�Ӻ�վ���Լ����ڵ�ȷ������ʱ��
    procedure TestLC_GetPlanTimes();
  end;


implementation

uses uLCBaseDict,uStation,uJwd,uWorkShop, uTrainJiaolu, uGuideGroup,
  uTrainmanJiaolu;

{$R *.dfm}
type
  TTestMethod = procedure of object;
procedure TFrmBasicDictDebug.Button1Click(Sender: TObject);
var
  p: pointer;
  PMethod: TMethod;
  TestMethod: TTestMethod;
begin
  if TreeView1.Selected = nil then
  begin
    WriteLog('��ѡ��Ҫ���Եķ���');
    Exit;
  end;
  if TreeView1.Selected.HasChildren then
  begin
    WriteLog('�ýڵ㲻��Ҷ�ӽڵ�');
    Exit;
  end;



  WriteLog('--------------------------------');



  p := MethodAddress('TestLC_' + TreeView1.Selected.Text);

  if p = nil then
    WriteLog(Format('û���ҵ�[%s]����',['TestLC_' + TreeView1.Selected.Text]))
  else
  begin
    PMethod.Data := Pointer(self);
    PMethod.Code := p;

    TestMethod := TTestMethod(PMethod);

    WriteLog('����TestLC_' + TreeView1.Selected.Text);
    
    TestMethod();
  end;
end;

procedure TFrmBasicDictDebug.OnRevHttpData(const data: string);
begin
  WriteLog('�յ�HTTP���ݣ�');
  WriteLog(data);
end;

procedure TFrmBasicDictDebug.TestLC_GetAllJwdList;
var
  JWDArray:TRsJWDArray;
  ErrInfo: string;
begin
  RsLCBaseDict.LCJwd.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    if not RsLCBaseDict.LCJwd.GetAllJwdList(JWDArray,ErrInfo) then
      WriteLog(ErrInfo);
  finally
    RsLCBaseDict.LCJwd.OnRecieveHttpDataEvent := nil;
  end;
end;
procedure TFrmBasicDictDebug.TestLC_GetAllTrainJiaolu;
var
  TrainJiaoluArray: TRsTrainJiaoluArray;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCTrainJiaolu.GetAllTrainJiaolu(TrainJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;
procedure TFrmBasicDictDebug.TestLC_GetGuideGroupGUIDByName;
begin
  RsLCBaseDict.LCGuideGroup.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCGuideGroup.GetGuideGroupGUIDByName('fff');
  finally
    RsLCBaseDict.LCGuideGroup.OnRecieveHttpDataEvent := nil;
  end;
end;
procedure TFrmBasicDictDebug.TestLC_GetGuideGroupOfWorkShop;
var
  GuideGroupArray: TRsGuideGroupArray;
begin
  RsLCBaseDict.LCGuideGroup.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCGuideGroup.GetGuideGroupOfWorkShop('ccc',GuideGroupArray);
  finally
    RsLCBaseDict.LCGuideGroup.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetPlanTimes;
var
  RemakType: Integer; PlaceID: string;
  ATime: Integer;
begin
  RemakType := 0;
  ATime := 0;
  RsLCBaseDict.LCWorkPlan.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCWorkPlan.GetPlanTimes(RemakType,PlaceID,ATime)
  finally
    RsLCBaseDict.LCWorkPlan.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetStationsOfJiaoJu;
var
  JLGUID: string;
  StationArray: TRsStationArray;
  ErrInfo: string;
begin
  RsLCBaseDict.LCStation.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    JLGUID := 'f01281aa-4ac5-4311-924e-4fd7213ff1cc';
    if not RsLCBaseDict.LCStation.GetStationsOfJiaoJu(JLGUID,StationArray,ErrInfo) then
      WriteLog(ErrInfo);
  finally
    RsLCBaseDict.LCStation.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTMJLByTrainJL;
var
  TrainmanJiaoluArray: TRsTrainmanJiaoluArray;
begin
  RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJL('f01281aa-4ac5-4311-924e-4fd7213ff1cc',TrainmanJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainmanJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTMJLByTrainJLWithSite;
var
  TrainmanJiaoluArray: TRsTrainmanJiaoluArray;
begin
  RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
//  SITEID '6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9'
//  TRAINJLID 'f01281aa-4ac5-4311-924e-4fd7213ff1cc' 
    RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSite('6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9',
    'f01281aa-4ac5-4311-924e-4fd7213ff1cc',TrainmanJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainmanJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTMJLByTrainJLWithSiteVirtual;
var
  TrainmanJiaoluArray: TRsTrainmanJiaoluArray;
begin
  RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
//  SITEID '6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9'
//  TRAINJLID 'f01281aa-4ac5-4311-924e-4fd7213ff1cc' 
    RsLCBaseDict.LCTrainmanJiaolu.GetTMJLByTrainJLWithSiteVirtual('6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9',
    'f01281aa-4ac5-4311-924e-4fd7213ff1cc',TrainmanJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainmanJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainmanJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTrainJiaolu;
var
  RsTrainJiaolu: RRsTrainJiaolu;
  JLID : string;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    JLID := '7b4d4377-3ef8-446d-aa04-515cc7a443f8';
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaolu(JLID,RsTrainJiaolu);
  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTrainJiaoluArrayOfSite;
var
  TrainJiaoluArray: TRsTrainJiaoluArray;
  SiteID : string;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    SiteID := '6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9';
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfSite(SiteID,TrainJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;
//
procedure TFrmBasicDictDebug.TestLC_GetTrainJiaoluArrayOfWorkShop;
var
  TrainJiaoluArray: TRsTrainJiaoluArray;
  SiteID : string;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    SiteID := 'caa268d3-aeb3-42c2-9b1b-4cd97d02d9eb';
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluArrayOfWorkShop(SiteID,TrainJiaoluArray);
    WriteLog(Format('��ȡ��%d��Ԫ��',[Length(TrainJiaoluArray)]));

  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetTrainJiaoluGUIDByName;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    RsLCBaseDict.LCTrainJiaolu.GetTrainJiaoluGUIDByName('����-����');
  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.TestLC_GetWorkShopGUIDByName;
var
  WorkShopName : string;
begin
  try
    RsLCBaseDict.LCWorkShop.OnRecieveHttpDataEvent := OnRevHttpData;
    try
      RsLCBaseDict.LCWorkShop.GetWorkShopGUIDByName(WorkShopName);
    finally
      RsLCBaseDict.LCWorkShop.OnRecieveHttpDataEvent := nil;
    end;
  except
    on E: exception do
    begin
      WriteLog(E.Message);
    end;

  end;

end;

procedure TFrmBasicDictDebug.TestLC_GetWorkShopOfArea;
var
  WorkShopArray : TRsWorkShopArray;
  ErrInfo: string;
  AreaGUID : string;
begin
  RsLCBaseDict.LCWorkShop.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    AreaGUID := '83ED3019-19DE-4BD4-BBE4-003FDE83A451';
    if not RsLCBaseDict.LCWorkShop.GetWorkShopOfArea(AreaGUID,WorkShopArray,ErrInfo) then
      WriteLog(ErrInfo);

    WriteLog(Format('��ȡ��%d��������Ϣ',[Length(WorkShopArray)]));

  finally
    RsLCBaseDict.LCWorkShop.OnRecieveHttpDataEvent := nil;
  end;
end;
procedure TFrmBasicDictDebug.TestLC_IsJiaoLuInSite;
var
  JLID : string;
  SiteID: string;
begin
  RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := OnRevHttpData;
  try
    JLID := '7b4d4377-3ef8-446d-aa04-515cc7a443f8';
    SiteID := '6c1e9cd8-69a6-441e-baf8-0a8cb936ebe9';
    RsLCBaseDict.LCTrainJiaolu.IsJiaoLuInSite(JLID,SiteID);
  finally
    RsLCBaseDict.LCTrainJiaolu.OnRecieveHttpDataEvent := nil;
  end;
end;

procedure TFrmBasicDictDebug.WriteLog(const log: string);
begin
  Memo1.Lines.Add(log);
end;

initialization
  ChildFrmMgr.Reg(TFrmBasicDictDebug);
end.
