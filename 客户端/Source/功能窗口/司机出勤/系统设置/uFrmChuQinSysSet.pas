unit uFrmChuQinSysSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzTabs, uFrmChuQinBaseSet;

type
  TFrmChuQinSysSet = class(TForm)
    rzpgcntrlSys: TRzPageControl;
    rztbshtBaseSet: TRzTabSheet;
    rzbtbtnOK: TRzBitBtn;
    rzbtbtnClose: TRzBitBtn;
    frmBaseSet: TFrmChuQinBaseSet;
    procedure rzbtbtnOKClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    function GetBaseConfigInfo: RChuQinBaseSet;
    { Private declarations }
  public
    procedure ReadConfig;
  published
    property BaseConfigInfo:RChuQinBaseSet read GetBaseConfigInfo;
  end;
  
implementation

{$R *.dfm}

procedure TFrmChuQinSysSet.FormCreate(Sender: TObject);
begin
  frmBaseSet.ReadConfig;
end;

procedure TFrmChuQinSysSet.FormShow(Sender: TObject);
begin
  frmBaseSet.UpdateUIInfo(frmBaseSet.ReadConfig);
end;

function TFrmChuQinSysSet.GetBaseConfigInfo: RChuQinBaseSet;
begin
  Result := frmBaseSet.ConfigInfo;
end;

procedure TFrmChuQinSysSet.ReadConfig;
begin
  frmBaseSet.ReadConfig;
end;

procedure TFrmChuQinSysSet.rzbtbtnOKClick(Sender: TObject);
begin
  frmBaseSet.SaveConfig;
end;

end.
