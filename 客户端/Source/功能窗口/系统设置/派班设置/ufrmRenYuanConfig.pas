unit ufrmRenYuanConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzTabs,ADODB;

type
  TfrmRenYuanConfig = class(TForm)
    RzPageControl1: TRzPageControl;
    TabSheet1: TRzTabSheet;
    btnOk: TButton;
    btnCancel: TButton;
    chkSleepCheck: TCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure LoadConfig();
    procedure SetConfig();
  public
    { Public declarations }
  end;
function RenYuanConfig(): Boolean;
implementation

uses uGlobalDM;
function RenYuanConfig(): Boolean;
var
  frmRenYuanConfig: TfrmRenYuanConfig;
begin
  frmRenYuanConfig := TfrmRenYuanConfig.Create(nil);
  try
    Result := frmRenYuanConfig.ShowModal = mrOk;
  finally
    frmRenYuanConfig.Free;
  end;
end;
{$R *.dfm}

procedure TfrmRenYuanConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRenYuanConfig.btnOkClick(Sender: TObject);
begin
  SetConfig();
  ModalResult := mrOk;
end;

procedure TfrmRenYuanConfig.FormShow(Sender: TObject);
begin
  LoadConfig();
end;

procedure TfrmRenYuanConfig.LoadConfig;
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.SQL.Text := 'Select bEnableSleepCheck from TAB_Base_PlanParam  '
      + 'where strWorkShopGUID = ' + QuotedStr(GlobalDM.SiteInfo.WorkShopGUID);
    ADOQuery.Open;
    if ADOQuery.RecordCount > 0 then
    begin
      chkSleepCheck.Checked :=  ADOQuery.FieldByName('bEnableSleepCheck').AsBoolean;
    end
    else
      chkSleepCheck.Checked := True;
      
  finally
    ADOQuery.Free;
  end;
end;


procedure TfrmRenYuanConfig.SetConfig;
var
  ADOQuery: TADOQuery;
begin
  ADOQuery := TADOQuery.Create(nil);
  try
    ADOQuery.SQL.Text := 'Update TAB_Base_PlanParam set bEnableSleepCheck = :bEnableSleepCheck '
      + 'where strWorkShopGUID = ' + QuotedStr(GlobalDM.SiteInfo.WorkShopGUID);

    ADOQuery.Parameters.ParamByName('bEnableSleepCheck').Value := chkSleepCheck.Checked; 
    ADOQuery.ExecSQL;
  finally
    ADOQuery.Free;
  end;
end;

end.
