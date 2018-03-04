unit uFrmQueryDetail;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Buttons;

type
  TfrmQueryPlanDetail = class(TForm)
    Panel1: TPanel;
    ListView1: TListView;
    StatusBar1: TStatusBar;
    Label1: TLabel;
    DateTimePicker1: TDateTimePicker;
    DateTimePicker2: TDateTimePicker;
    Label2: TLabel;
    btnQuery: TSpeedButton;
    btnCancel: TSpeedButton;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmQueryPlanDetail: TfrmQueryPlanDetail;

implementation

{$R *.dfm}

end.
