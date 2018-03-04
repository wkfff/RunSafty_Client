unit ufrmTrainmanMgrDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uChildFrmMgr,superobject, StdCtrls,uJsonSerialize, ComCtrls, ExtCtrls,
  uLCTrainmanMgr,uTrainman,uTFSystem,uLLCommonFun;

type
  TFrmTrainmamMgrDebug = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    RsLCTrainmanMgr: TRsLCTrainmanMgr;
    m_RsTrainmanArray: TRsTrainmanArray;
    m_RsTrainman: RRsTrainman;
    procedure InitTrainman();
  public
    { Public declarations }
    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  published
    //功能：添加乘务员
    procedure AddTrainman();
    //功能：修改乘务员
    procedure UpdateTrainman();
    //功能：删除乘务员
    procedure DeleteTrainman();

    //获取指定ID的乘务员的信息
    procedure GetTrainmanByNumber();
    //分页查找
    procedure QueryTrainmans_blobFlag();
    //获取空闲人员
    procedure GetPopupTrainmans();
    //获取人员摘要信息
    procedure GetTrainmansBrief();

    //更新司机联系方式
    procedure UpdateTrainmanTel();

    //是否存在非GUID的司机工号  where GUID = TrainmanGUID and strTrainmanNumber <>  TrainmanNumber
    procedure ExistNumber();

    //根据GUID获取乘务员信息
    procedure GetTrainman();

    //清除指纹
    procedure ClearFinger();

    //更新指纹照片
    procedure UpdateFingerAndPic();
  end;


implementation

uses uGlobalDM;
type
  TTestMethod = procedure of object;
{$R *.dfm}
procedure TFrmTrainmamMgrDebug.AddTrainman;
begin
  RsLCTrainmanMgr.AddTrainman(m_RsTrainman);
end;

procedure TFrmTrainmamMgrDebug.Button1Click(Sender: TObject);
var
  p: pointer;
  PMethod: TMethod;
  TestMethod: TTestMethod;
begin
  if TreeView1.Selected = nil then
  begin
    WriteLog('请选中要测试的方法');
    Exit;
  end;
  if TreeView1.Selected.HasChildren then
  begin
    WriteLog('该节点不是叶子节点');
    Exit;
  end;


  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;

  WriteLog('--------------------------------');



  p := MethodAddress(TreeView1.Selected.Text);

  if p = nil then
    WriteLog(Format('没有找到[%s]方法',[TreeView1.Selected.Text]))
  else
  begin
    PMethod.Data := Pointer(self);
    PMethod.Code := p;

    TestMethod := TTestMethod(PMethod);

    WriteLog(TreeView1.Selected.Text);
    
    TestMethod();
  end;
end;


procedure TFrmTrainmamMgrDebug.ClearFinger;
begin
  RsLCTrainmanMgr.ClearFinger(m_RsTrainman.strTrainmanGUID);
end;

procedure TFrmTrainmamMgrDebug.DeleteTrainman;
begin
  RsLCTrainmanMgr.DeleteTrainman(m_RsTrainman.strTrainmanGUID);
end;

procedure TFrmTrainmamMgrDebug.ExistNumber;
begin
  RsLCTrainmanMgr.ExistNumber('sdfadff',m_RsTrainman.strTrainmanNumber);
end;

procedure TFrmTrainmamMgrDebug.FormCreate(Sender: TObject);
begin
  RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  InitTrainman();
end;

procedure TFrmTrainmamMgrDebug.FormDestroy(Sender: TObject);
begin
  RsLCTrainmanMgr.Free;
end;

procedure TFrmTrainmamMgrDebug.GetPopupTrainmans;
begin
  RsLCTrainmanMgr.GetPopupTrainmans('caa268d3-aeb3-42c2-9b1b-4cd97d02d9eb','l',0,m_RsTrainmanArray);
end;

procedure TFrmTrainmamMgrDebug.GetTrainman;
var
  Trainman: RRsTrainman;
begin
  RsLCTrainmanMgr.GetTrainman(m_RsTrainman.strTrainmanGUID,Trainman);
end;

procedure TFrmTrainmamMgrDebug.GetTrainmanByNumber;
var
  Trainman: RRsTrainman;
begin
  RsLCTrainmanMgr.GetTrainmanByNumber(m_RsTrainman.strTrainmanNumber,Trainman)
end;

procedure TFrmTrainmamMgrDebug.GetTrainmansBrief;
var
  nStart: integer;
  nTotalCount: integer;
begin
  nStart := 0;
  RsLCTrainmanMgr.GetTrainmansBrief(nStart,10,0,m_RsTrainmanArray,nTotalCount);
end;

procedure TFrmTrainmamMgrDebug.InitTrainman;
begin
  m_RsTrainman.strTrainmanGUID := 'TestGUID123';
  m_RsTrainman.strTrainmanName := 'TestName';
  m_RsTrainman.strTrainmanNumber := 'TestNumber';
  m_RsTrainman.strAreaGUID := '83ED3019-19DE-4BD4-BBE4-003FDE83A451';
  
  m_RsTrainman.strWorkShopGUID := '';
  m_RsTrainman.strTelNumber := '1234567';
  m_RsTrainman.strMobileNumber := '987654321';
  m_RsTrainman.strJP := 'abc';
end;

procedure TFrmTrainmamMgrDebug.OnRevHttpData(const data: string);
begin
  WriteLog('收到HTTP数据：');
  WriteLog(data);
end;

procedure TFrmTrainmamMgrDebug.QueryTrainmans_blobFlag;
var
  QueryTrainman: RRsQueryTrainman;
  nTotalCount: integer;
begin
//  QueryTrainman.strTrainmanNumber := m_RsTrainman.strTrainmanNumber;
  RsLCTrainmanMgr.QueryTrainmans_blobFlag(QueryTrainman,1,m_RsTrainmanArray,nTotalCount);
end;

procedure TFrmTrainmamMgrDebug.UpdateFingerAndPic;
var
  Trainman: RRsTrainman;
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    Trainman := m_RsTrainman;
    //随便写一些数据
    TreeView1.SaveToStream(Stream);
    Stream.Position := 0;
    TCF_VariantParse.StreamToOleVariant(Stream,Trainman.FingerPrint1);
    RsLCTrainmanMgr.UpdateFingerAndPic(Trainman);
  finally
    Stream.Free;
  end;

end;

procedure TFrmTrainmamMgrDebug.UpdateTrainman;
begin
  RsLCTrainmanMgr.UpdateTrainman(m_RsTrainman);

end;

procedure TFrmTrainmamMgrDebug.UpdateTrainmanTel;
begin
  RsLCTrainmanMgr.UpdateTrainmanTel(m_RsTrainman.strTrainmanGUID,m_RsTrainman.strMobileNumber,
  m_RsTrainman.strTelNumber,'','');
end;

procedure TFrmTrainmamMgrDebug.WriteLog(const log: string);
begin
  memo1.Lines.Add(log);
end;

initialization
  ChildFrmMgr.Reg(TFrmTrainmamMgrDebug);

end.
