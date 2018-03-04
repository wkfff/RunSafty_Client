unit ufrmEventDebug;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uLCEvent,uRunEvent, StdCtrls;

type
  TFrmEventDebug = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    RsLCEvent: TRsLCEvent;
    procedure OnRevHttpData(const data: string);
  public
    { Public declarations }
  end;


implementation

uses uChildFrmMgr, uGlobalDM;

{$R *.dfm}
procedure TFrmEventDebug.Button1Click(Sender: TObject);
var
  RunEventArray: TRsRunEventArray;
begin
  GlobalDM.WebAPIUtils.OnRecieveHttpDataEvent := OnRevHttpData;
  RsLCEvent.GetPlanRunEvents('2B806629-BF4B-4C34-831E-02650561FB2D',RunEventArray);
end;

procedure TFrmEventDebug.FormCreate(Sender: TObject);
begin
  RsLCEvent := TRsLCEvent.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmEventDebug.FormDestroy(Sender: TObject);
begin
  RsLCEvent.Free;
end;

procedure TFrmEventDebug.OnRevHttpData(const data: string);
begin
  Memo1.Lines.Add(data);
end;

initialization
  ChildFrmMgr.Reg(TFrmEventDebug);
end.
