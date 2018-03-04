unit ufrmDebugBase;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls, ExtCtrls,TypInfo;

type
  TFrmDebugBase = class(TForm)
    Memo1: TMemo;
    Panel1: TPanel;
    Button1: TButton;
    TreeView1: TTreeView;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  protected
    procedure WriteLog(const log: string);
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
  end;


implementation

uses uGlobalDM, uChildFrmMgr;

{$R *.dfm}


procedure TFrmDebugBase.Button1Click(Sender: TObject);
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

function PropInfoName(PropInfo: PPropInfo): string;
begin
  Result := string(PropInfo^.Name);
end;




procedure TFrmDebugBase.OnRevHttpData(const data: string);
begin
  WriteLog('收到HTTP数据：');
  WriteLog(data);
end;

procedure TFrmDebugBase.WriteLog(const log: string);
begin
  Memo1.Lines.Add(log);
end;

end.
