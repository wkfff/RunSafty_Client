unit uFrmMain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, XPMan, StdCtrls, Buttons,uBaseWebInterface;

type
  TFrmMain = class(TForm)
    XPManifest1: TXPManifest;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    Memo1: TMemo;
    procedure SpeedButton3Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    ConnConfig: RInterConnConfig;
  public
    { Public declarations }
  end;

var
  FrmMain: TFrmMain;

implementation

uses uLCDict_Station,uLCDict_TrainJiaoLu, uTrainJiaolu;

{$R *.dfm}

procedure TFrmMain.FormCreate(Sender: TObject);
begin
  ConnConfig.URL := 'http://192.168.1.30:8000/AshxService/QueryProcess.ashx?';
  ConnConfig.ClientID := '2030001';
  ConnConfig.SiteID := '285178c2-9d5c-469a-8419-a7d588ffcc1d';
end;

procedure TFrmMain.SpeedButton3Click(Sender: TObject);
begin
  TRsLCStation;
end;

end.
