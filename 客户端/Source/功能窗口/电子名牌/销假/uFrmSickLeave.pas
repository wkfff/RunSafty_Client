unit uFrmSickLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, ComCtrls, RzDTP, RzLabel, RzButton, uSickLeave,
  uStation;

type
  TFrmSickLeave = class(TForm)
    rzbtbtnOk: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
    lbl2: TRzLabel;
    rzdtmpckrDate: TRzDateTimePicker;
    rzdtmpckrTime: TRzDateTimePicker;
    lbl1: TRzLabel;
    cbbStation: TRzComboBox;
    procedure FormShow(Sender: TObject);
    procedure rzbtbtnOkClick(Sender: TObject);
  private
    m_StationAry:TRsStationArray;
    m_SickLeave:RRsSickLeave;
    m_strLineGUID:string;
  private
    procedure InitStationCtrl;
  published
    property SickLeave:RRsSickLeave read m_SickLeave;
    property strLineGUID:string read m_strLineGUID write m_strLineGUID;
  end;

implementation
uses
  uDBTrainmanJiaolu, ADODB, uGlobalDM;

{$R *.dfm}

{ TFrmSickLeave }

procedure TFrmSickLeave.FormShow(Sender: TObject);
begin
  InitStationCtrl;
  rzdtmpckrDate.Date := GlobalDM.GetNow;
  rzdtmpckrTime.Time := GlobalDM.GetNow;
end;

procedure TFrmSickLeave.InitStationCtrl;
var
  I:Integer;
  dbJL:TRsDBTrainmanJiaolu;
begin
  cbbStation.Items.BeginUpdate;
  try
    cbbStation.Items.Clear;
    dbJL := TRsDBTrainmanJiaolu.Create(GlobalDM.ADOConnection);
    try
      dbJL.GetLineStations(GlobalDM.ADOConnection,strLineGUID,m_StationAry);
      for I := 0 to Length(m_StationAry) - 1 do
      begin
        cbbStation.AddItemValue(m_StationAry[I].strStationName,
          m_StationAry[I].strStationGUID);
      end;
    finally
      dbJL.Free;
    end;
  finally
    cbbStation.Items.EndUpdate;
  end;
end;

procedure TFrmSickLeave.rzbtbtnOkClick(Sender: TObject);
begin
  m_SickLeave.strStationGUID := '';
  if cbbStation.ItemIndex >= 0 then
    m_SickLeave.strStationGUID  := cbbStation.Value
  else
  begin
    cbbStation.SetFocus;
    MessageBox(Handle,'请选择车站','提示',MB_ICONINFORMATION);
    ModalResult := mrNo;
    Exit;
  end;
  m_SickLeave.dtSickTime := rzdtmpckrDate.Date + rzdtmpckrTime.Time;
  ModalResult := mrOk;
end;

end.
