unit ufrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uChildFrmMgr, XPMan, ComCtrls;

type
  TFrmMain = class(TForm)
    PageControl: TPageControl;
    XPManifest1: TXPManifest;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure CreateChildFrms();
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

{$R *.dfm}

procedure TFrmMain.CreateChildFrms;
var
  I: Integer;
  frm: TForm;
  Sheet: TTabSheet;
begin
  for I := 0 to ChildFrmMgr.Frms.Count - 1 do
  begin
    frm := TFromClass(ChildFrmMgr.Frms.Items[i]).Create(Self);

    Sheet := TTabSheet.Create(Self);
    Sheet.Caption := frm.Caption;
    Sheet.PageControl := PageControl;
    frm.BorderStyle := bsNone;
    frm.Name := 'FrmChild' + IntToStr(self.ComponentCount);
    frm.Parent := Sheet;

    frm.Align := alClient;
    frm.Show;
  end;
end;


procedure TFrmMain.FormShow(Sender: TObject);
begin
  CreateChildFrms();
end;

end.
