unit uFrmMealticketServerCfg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, StdCtrls, ExtCtrls, RzCmboBx;

type
  TFrmMealTicketServerCfg = class(TForm)
    Bevel1: TBevel;
    btnOk: TButton;
    btnCancel: TButton;
    RzCheckBox1: TRzCheckBox;
    RzCheckBox2: TRzCheckBox;
    procedure btnOkClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    class procedure ShowCfg();
  end;


implementation

uses uGlobalDM,uMealTicketFacade;

{$R *.dfm}

{ TFrmMealTicketServerCfg }

procedure TFrmMealTicketServerCfg.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmMealTicketServerCfg.btnOkClick(Sender: TObject);
begin
  TMealCfg.ManualSend[GlobalDM.SiteInfo.WorkShopGUID] := RzCheckBox1.Checked;
  TMealCfg.TicketEnable[GlobalDM.SiteInfo.WorkShopGUID] := RzCheckBox2.Checked;
  ModalResult := mrOk;
end;

procedure TFrmMealTicketServerCfg.FormShow(Sender: TObject);
begin
  RzCheckBox1.Checked := TMealCfg.ManualSend[GlobalDM.SiteInfo.WorkShopGUID];
  RzCheckBox2.Checked := TMealCfg.TicketEnable[GlobalDM.SiteInfo.WorkShopGUID];
end;

class procedure TFrmMealTicketServerCfg.ShowCfg;
begin
  with TFrmMealTicketServerCfg.Create(nil) do
  begin
    ShowModal;
    Free;
  end;
end;

end.
