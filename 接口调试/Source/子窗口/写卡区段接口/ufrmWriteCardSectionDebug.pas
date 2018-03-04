unit ufrmWriteCardSectionDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls,uWriteCardSection,uLCWriteCardSectionV2, ComCtrls, ExtCtrls;

type
  TFrmWriteCardSection = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    TreeView1: TTreeView;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RsLCWriteCardSection: TRsLCWriteCardSectionV2;
    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  published
    { Public declarations }
    //获取计划所有可选的写卡区段
    procedure GetPlanAllSections();
    //获取计划已经选定的写卡区段
    procedure GetPlanSelectedSections();
    //指定计划的写卡区段
    procedure SetPlanSections();
  end;



implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
{ TFrmWriteCardSection }

procedure TFrmWriteCardSection.Button1Click(Sender: TObject);
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
procedure TFrmWriteCardSection.FormCreate(Sender: TObject);
begin
  RsLCWriteCardSection := TRsLCWriteCardSectionV2.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmWriteCardSection.FormDestroy(Sender: TObject);
begin
  RsLCWriteCardSection.Free;
end;

procedure TFrmWriteCardSection.GetPlanAllSections;
var
  TrainPlanGUID : String;
  SectionArray : TRsWriteCardSectionArray;
begin
  RsLCWriteCardSection.GetPlanAllSections(TrainPlanGUID,SectionArray);
end;

procedure TFrmWriteCardSection.GetPlanSelectedSections();
var
  TrainPlanGUID: String;
  SectionArray: TRsWriteCardSectionArray;
begin
  RsLCWriteCardSection.GetPlanSelectedSections(TrainPlanGUID,SectionArray);
end;

procedure TFrmWriteCardSection.OnRevHttpData(const data: string);
begin
  Memo1.Lines.Add('收到http数据：');
  Memo1.Lines.Add(data);
end;

procedure TFrmWriteCardSection.SetPlanSections();
var
  TrainPlanGUID: String;
  SectionArray: TRsWriteCardSectionArray;
  DutyUserGUID, DutyUserNumber,
  DutyUserName: String;
begin
  RsLCWriteCardSection.SetPlanSections(TrainPlanGUID,SectionArray,DutyUserGUID,DutyUserNumber,DutyUserName);
end;

procedure TFrmWriteCardSection.WriteLog(const log: string);
begin
  Memo1.Lines.Add(log);
end;

initialization
  ChildFrmMgr.Reg(TFrmWriteCardSection);
end.
