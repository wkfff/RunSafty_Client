unit uFrmRoomSignSysConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzTabs, ExtCtrls, RzPanel, StdCtrls;

type
  TFrmRoomSignsSysConfig = class(TForm)
    RzPanel1: TRzPanel;
    PageCtrlMain: TRzPageControl;
    tsUpdate: TRzTabSheet;
    tsConfig: TRzTabSheet;
    tsMaintenance: TRzTabSheet;
    btnClose: TButton;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    procedure CreateSubForms();
    procedure DestorySubForms();
  public
    { Public declarations }
    //ø™ º…Ë÷√
    class procedure ShowConfig();
  end;

var
  FrmRoomSignsSysConfig: TFrmRoomSignsSysConfig;

implementation

uses
  uFrmRoomSign_Update,uFrmRoomSign_Config,uFrmRoomSign_Maintenance;

{$R *.dfm}

{ TFrmRoomSignConfig }

procedure TFrmRoomSignsSysConfig.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmRoomSignsSysConfig.CreateSubForms;
begin
  FrmRoomSign_Update := TFrmRoomSign_Update.Create(nil);
  FrmRoomSign_Update.Parent := tsUpdate ;
  FrmRoomSign_Update.Show ;

  FrmRoomSign_Config := TFrmRoomSign_Config.Create(nil);
  FrmRoomSign_Config.Parent := tsConfig ;
  FrmRoomSign_Config.Show ;

  FrmRoomSign_Maintenance := TFrmRoomSign_Maintenance.Create(nil);
  FrmRoomSign_Maintenance.Parent := tsMaintenance ;
  FrmRoomSign_Maintenance.Show ;
  
end;

procedure TFrmRoomSignsSysConfig.DestorySubForms;
begin
  FrmRoomSign_Update.Free ;
  FrmRoomSign_Config.Free ;
  FrmRoomSign_Maintenance.Free ;

end;

procedure TFrmRoomSignsSysConfig.FormCreate(Sender: TObject);
begin
  CreateSubForms;
end;

procedure TFrmRoomSignsSysConfig.FormDestroy(Sender: TObject);
begin
  DestorySubForms;
end;

class procedure TFrmRoomSignsSysConfig.ShowConfig;
var
  frm:TFrmRoomSignsSysConfig;
begin
  frm := TFrmRoomSignsSysConfig.Create(nil);
  try
    frm.ShowModal ;
  finally
    frm.Free ;
  end;
end;

end.
