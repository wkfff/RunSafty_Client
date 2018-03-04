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
    WriteLog('��ѡ��Ҫ���Եķ���');
    Exit;
  end;
  if TreeView1.Selected.HasChildren then
  begin
    WriteLog('�ýڵ㲻��Ҷ�ӽڵ�');
    Exit;
  end;


  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;

  WriteLog('--------------------------------');



  p := MethodAddress(TreeView1.Selected.Text);

  if p = nil then
    WriteLog(Format('û���ҵ�[%s]����',[TreeView1.Selected.Text]))
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
  WriteLog('�յ�HTTP���ݣ�');
  WriteLog(data);
end;

procedure TFrmDebugBase.WriteLog(const log: string);
begin
  Memo1.Lines.Add(log);
end;

end.
