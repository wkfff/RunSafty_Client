unit uFrmSelectSite;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx;

type
  TfrmSelectSite = class(TForm)
    Label1: TLabel;
    btnConfirm: TButton;
    btnCancel: TButton;
    comboSite: TRzComboBox;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnConfirmClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    IsFirst : boolean;
  public
    { Public declarations }
  end;

implementation

{$R *.dfm}
uses
  uSite,uDBSite,uGlobalDM;
procedure TfrmSelectSite.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmSelectSite.btnConfirmClick(Sender: TObject);
begin
  if comboSite.ItemIndex < 0 then
  begin
    Application.MessageBox('请选择客户端','提示',MB_OK+MB_ICONINFORMATION);
    exit;
  end;
  ModalResult := mrOk;
end;

procedure TfrmSelectSite.FormCreate(Sender: TObject);
begin
  IsFirst := true;
end;

procedure TfrmSelectSite.FormShow(Sender: TObject);
var
  siteArray : TRsSiteArray;
  i: Integer;
begin
  if not IsFirst then exit;
  IsFirst := false;
  
  if not TRsDBSite.GetTrainmanSites(GlobalDM.ADOConnection,siteArray) then
  begin
    btnConfirm.Enabled := false;
    exit;
  end;
  comboSite.Items.Clear;
  for i := 0 to Length(siteArray) - 1 do
  begin
    comboSite.AddItemValue(siteArray[i].strSiteName,siteArray[i].strSiteGUID);
  end;
  if comboSite.Count > 0 then
    comboSite.ItemIndex := 0
  else begin
    btnConfirm.Enabled := false;
    exit;
  end;
end;

end.
