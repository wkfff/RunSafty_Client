unit uFrmDrinkDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,uLCDrink,uDrink;

type
  TFrmDrinkDebug = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    m_drinkInfoArray: TRsDrinkArray;
    m_RsDrink: RRsDrink;
    RsLCDrink: TRsLCDrink;
    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
  published
    //功能:1.9.1    获取测酒信息
    procedure QueryDrink();
    //功能:1.9.2    上传测酒记录
    procedure AddDrinkInfo();
    //功能:1.9.3    获取测酒明细
    procedure GetDrinkInfo();
    //功能:1.9.4    根据车次和客户端获取测酒记录
    procedure GetTrainNoDrinkInfo();
    //功能:1.9.5    获取没有出勤计划的测酒记录
    procedure QueryNoPlanDrink();
    //功能:1.9.6    据客户端获取从某个时间开始的某个人的最后一条测酒记录
    procedure GetTMLastDrinkInfo();
    //功能:获取测酒记录
    procedure GetTrainmanDrinkInfo();
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
{ TFrmDrinkDebug }

procedure TFrmDrinkDebug.AddDrinkInfo;
begin
  RsLCDrink.AddDrinkInfo(m_RsDrink);
end;

procedure TFrmDrinkDebug.Button1Click(Sender: TObject);
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


procedure TFrmDrinkDebug.FormCreate(Sender: TObject);
begin
  RsLCDrink := TRsLCDrink.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmDrinkDebug.FormDestroy(Sender: TObject);
begin
  RsLCDrink.Free;
end;

procedure TFrmDrinkDebug.GetDrinkInfo;
begin
  RsLCDrink.GetDrinkInfo('',m_RsDrink);
end;

procedure TFrmDrinkDebug.GetTMLastDrinkInfo;
var
  strSiteNumber, strTrainmanNumber: String;
  dtStartTime: TDateTime;
  drinkInfo: RRsDrink;
  strErr: string;
begin
  strSiteNumber := '';
  strTrainmanNumber := '';
  dtStartTime := Now;
  strErr := '';

  RsLCDrink.GetTMLastDrinkInfo(strSiteNumber, strTrainmanNumber,
  dtStartTime,
  drinkInfo,
  strErr)
end;

procedure TFrmDrinkDebug.GetTrainmanDrinkInfo;
var
  strTrainmanGUID,
  strTrainPlanGUID: String; WorkType: Integer;
  drinkInfo: RRsDrink;
begin
  WorkType := 0;
  RsLCDrink.GetTrainmanDrinkInfo(strTrainmanGUID,
  strTrainPlanGUID,WorkType,
  drinkInfo)
end;

procedure TFrmDrinkDebug.GetTrainNoDrinkInfo;
var
  dtBeginTime: TDateTime;
  strTrainNo,SiteNumebr: String; nCount: Integer;
  ErrInfo: string;
  drinkInfoArray: TRsDrinkArray;
begin
  dtBeginTime := Now;
  nCount := 10;

  RsLCDrink.GetTrainNoDrinkInfo(dtBeginTime,strTrainNo,SiteNumebr,nCount,drinkInfoArray,ErrInfo)
end;

procedure TFrmDrinkDebug.OnRevHttpData(const data: string);
begin
  WriteLog('收到HTTP数据：');
  WriteLog(data);
end;

procedure TFrmDrinkDebug.QueryDrink;
var
  QueryParam: TDrinkQueryParam;
begin
  QueryParam := TDrinkQueryParam.Create;
  try
    RsLCDrink.QueryDrink(QueryParam,m_drinkInfoArray);
  finally
    QueryParam.Free;
  end;

end;

procedure TFrmDrinkDebug.QueryNoPlanDrink;
var
  dtBeginTime,dtEndTime: TDateTime;
  TrainmanNumber: String; DrinkTypeID: Integer;
  drinkInfoArray: TRsDrinkArray;
begin
  dtBeginTime := Now;
  dtEndTime := Now;
  TrainmanNumber := '';
  DrinkTypeID := 0;
  RsLCDrink.QueryNoPlanDrink(dtBeginTime,dtEndTime,
  TrainmanNumber,DrinkTypeID,
  drinkInfoArray);
end;

procedure TFrmDrinkDebug.WriteLog(const log: string);
begin
  memo1.Lines.Add(log);
end;

initialization
  ChildFrmMgr.Reg(TFrmDrinkDebug);
end.
