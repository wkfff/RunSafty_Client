unit ufrmAskLeaveDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uChildFrmMgr,uHttpWebAPI,uLCAskLeave,uLeaveListInfo,uSaftyEnum,
  StdCtrls, ExtCtrls, ComCtrls,uTFSystem,DateUtils;

type
  TFrmAskLeaveDebug = class(TForm)
    TreeView1: TTreeView;
    Panel1: TPanel;
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RsLCLeaveType: TRsLCLeaveType;
    RsLCAskLeave: TRsLCAskLeave;

    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
    ErrInfo: string;
  published
    //查询所有请假类型
    procedure QueryLeaveTypes();

    //通过指定的请假类型名称获取请假类型信息
    procedure GetLeaveType();

    //获取全部请假类别
    procedure GetLeaveClasses();

    //添加请假类型
    procedure AddLeaveType();

    //判断是否存在某种请假类型组合
    procedure ExistLeaveType();

    //判断是否存在某种请假类型组合，在编辑请假类型时使用
    procedure ExistLeaveTypeWhenEdit();

    //删除请假类型
    procedure DeleteLeaveType();

    //更新请假类型
    procedure UpdateLeaveType();



    //给定一个工号，判断该职工是否有未销假的记录
    procedure CheckWhetherAskLeaveByID();

    //请假
    procedure AskLeave();

    //撤销请假记录
    procedure CancelLeave();

    //传入查询条件，该函数返回相应的请假记录
    procedure GetLeaves();

    //给定一个工号，返回该职工的请假信息以及所请假的请假类型名称
    procedure GetValidAskLeaveInfoByID();

    //获取清假详细
    procedure GetAskLeaveDetail();

    //获取销假详细
    procedure GetCancelLeaveDetail();

    //添加销假详情
    procedure AddCancelLeaveDetail();
  end;



implementation

uses uGlobalDM;

{$R *.dfm}
type
  TTestMethod = procedure of object;
procedure TFrmAskLeaveDebug.AddCancelLeaveDetail;
var
  CancelLeaveDetail: RRsCancelLeaveDetail;
begin
  CancelLeaveDetail.strCancelLeaveGUID := NewGUID;
  CancelLeaveDetail.strAskLeaveGUID := '6461ef88-fc40-447d-9641-a43630fe6920';
  CancelLeaveDetail.strTrainmanID := 'TestNumber';
  CancelLeaveDetail.dtCancelTime := Now;

  if not RsLCAskLeave.AddCancelLeaveDetail(CancelLeaveDetail,ErrInfo) then
    WriteLog(ErrInfo);
end;


procedure TFrmAskLeaveDebug.AddLeaveType;
var
  LeaveType: RRsLeaveType;
begin
  LeaveType.strTypeGUID := 'TestLeaveTypeGUID';
  LeaveType.strTypeName := '测试类型';
  LeaveType.nClassID := 1;
  
  if not RsLCLeaveType.AddLeaveType(LeaveType,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.AskLeave;
var
  LeaveApplyEntity: TLeaveApplyEntity;
begin
  LeaveApplyEntity := TLeaveApplyEntity.Create;
  try
    LeaveApplyEntity.strTrainmanGUID := 'TestTrainmanGUID';
    LeaveApplyEntity.strTrainmanNumber := 'TestNumber';
    LeaveApplyEntity.dtBeginTime := Now;
    LeaveApplyEntity.strTypeGUID := 'TestLeaveTypeGUID';
    LeaveApplyEntity.strRemark := 'remark';
    LeaveApplyEntity.strProverID := '';
    LeaveApplyEntity.strDutyUserID := '';
    LeaveApplyEntity.strSiteID := '';
  
    if not RsLCAskLeave.AskLeave(LeaveApplyEntity,ErrInfo) then
      WriteLog('ErrInfo');
  finally
    LeaveApplyEntity.Free;
  end;

end;

procedure TFrmAskLeaveDebug.Button1Click(Sender: TObject);
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

procedure TFrmAskLeaveDebug.CancelLeave;
begin
  RsLCAskLeave.CancelLeave('054c2cc9-10ed-4dd9-a3bb-becf9a9f84d3');
end;

procedure TFrmAskLeaveDebug.CheckWhetherAskLeaveByID;
var
  bExist: Boolean;
  strTrainManID: string;
begin
  strTrainManID := 'TestNumber';
  if not RsLCAskLeave.CheckWhetherAskLeaveByID(strTrainManID,bExist,ErrInfo) then
    WriteLog('ErrInfo');
end;

procedure TFrmAskLeaveDebug.DeleteLeaveType;
begin
  if not RsLCLeaveType.DeleteLeaveType('TestLeaveTypeGUID',ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.ExistLeaveType;
var
  LeaveType: RRsLeaveType;
begin
  LeaveType.strTypeGUID := NewGUID;
  LeaveType.strTypeName := '测试类型';
  LeaveType.nClassID := 1;
  
  if not RsLCLeaveType.ExistLeaveType(LeaveType) then
    WriteLog('不存在')
  else
    WriteLog('存在');
end;

procedure TFrmAskLeaveDebug.ExistLeaveTypeWhenEdit;
var
  LeaveType: RRsLeaveType;
begin
  LeaveType.strTypeGUID := NewGUID;
  LeaveType.strTypeName := '测试类型';
  LeaveType.nClassID := 1;
  
  if not RsLCLeaveType.ExistLeaveTypeWhenEdit(LeaveType) then
    WriteLog('不存在')
  else
    WriteLog('存在');
end;

procedure TFrmAskLeaveDebug.FormCreate(Sender: TObject);
begin
  RsLCLeaveType := TRsLCLeaveType.Create(GlobalDM.WebAPIUtils);
  RsLCAskLeave := TRsLCAskLeave.Create(GlobalDM.WebAPIUtils);

end;

procedure TFrmAskLeaveDebug.FormDestroy(Sender: TObject);
begin
  RsLCAskLeave.Free;
  RsLCLeaveType.Free;
end;

procedure TFrmAskLeaveDebug.GetAskLeaveDetail;
var
  strAskLeaveGUID: string;
  AskLeaveDetail: RRsAskLeaveDetail;
begin
  strAskLeaveGUID := '054c2cc9-10ed-4dd9-a3bb-becf9a9f84d3';
  if not RsLCAskLeave.GetAskLeaveDetail(strAskLeaveGUID,AskLeaveDetail,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.GetCancelLeaveDetail;
var
  strAskLeaveGUID: string;
  CancelLeaveDetail: RRsCancelLeaveDetail;
begin
  strAskLeaveGUID := '054c2cc9-10ed-4dd9-a3bb-becf9a9f84d3';
  if not RsLCAskLeave.GetCancelLeaveDetail(strAskLeaveGUID,CancelLeaveDetail,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.GetLeaveClasses;
var
  LeaveClassArray: TRsLeaveClassArray;
begin
  if not RsLCLeaveType.GetLeaveClasses(LeaveClassArray,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.GetLeaves;
var
  strBeginDateTime, strEndDateTime, strNumber,
  strType, strStatus, strWorkShopGUID, strPost, strGroup: string;
  AskLeaveWithTypeArray: TRsAskLeaveWithTypeArray;
begin
  strBeginDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss',IncDay(Now,-1));

  strEndDateTime := FormatDateTime('yyyy-mm-dd hh:nn:ss',IncDay(Now,1));

  strNumber := 'TestNumber';
  strType := '';
  strStatus := '';
  strWorkShopGUID := '';
  strPost := '';
  strGroup := '';
  RsLCAskLeave.GetLeaves(strBeginDateTime, strEndDateTime, strNumber,
  strType, strStatus, strWorkShopGUID, strPost, strGroup,AskLeaveWithTypeArray);
end;

procedure TFrmAskLeaveDebug.GetLeaveType;
var
  LeaveType: RRsLeaveType;
  bExist: Boolean;
begin
  if not RsLCLeaveType.GetLeaveType('测试类型',LeaveType,bExist,ErrInfo) then
    WriteLog(ErrInfo);
end;
procedure TFrmAskLeaveDebug.GetValidAskLeaveInfoByID;
var
  strTrainManID: string;
  AskLeave: RRsAskLeave;
  strTypeName: string;
  bExist: boolean;
begin
  strTrainManID := 'TestNumber';
  strTypeName := '测试类型';
  if not RsLCAskLeave.GetValidAskLeaveInfoByID(strTrainManID,AskLeave,strTypeName,bExist,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.OnRevHttpData(const data: string);
begin
  WriteLog('收到HTTP数据：');
  WriteLog(data);
end;

procedure TFrmAskLeaveDebug.QueryLeaveTypes;
var
  LeaveTypeArray: TRsLeaveTypeArray;
begin
  if not RsLCLeaveType.QueryLeaveTypes(LeaveTypeArray,ErrInfo) then
    WriteLog(ErrInfo);
end;

procedure TFrmAskLeaveDebug.UpdateLeaveType;
var
  LeaveType: RRsLeaveType;
begin
  LeaveType.strTypeGUID := 'TestLeaveTypeGUID';
  LeaveType.strTypeName := '测试类型';
  LeaveType.nClassID := 1;
  
  if not RsLCLeaveType.UpdateLeaveType(LeaveType,ErrInfo) then
    WriteLog(ErrInfo);
end;
procedure TFrmAskLeaveDebug.WriteLog(const log: string);
begin
  Memo1.Lines.Add(log);
end;

initialization
  ChildFrmMgr.Reg(TFrmAskLeaveDebug);

end.
