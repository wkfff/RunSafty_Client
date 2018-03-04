unit uFrmQueryCallRecord;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, ComCtrls, StdCtrls, Buttons, ExtCtrls,ADODB,
  PngCustomButton, MPlayer, DSPack, ImgList, PngImageList, RzPanel;

type
  TfrmQueryCallRecord = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    btnQuery: TSpeedButton;
    btnCancel: TSpeedButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    dtpBeginDate: TDateTimePicker;
    dtpEndDate: TDateTimePicker;
    CombArea: TComboBox;
    edtTrainmanName: TEdit;
    edtTrainmanNumber: TEdit;
    lvDrink: TListView;
    ActionList1: TActionList;
    actEsc: TAction;
    ProgressBar1: TProgressBar;
    btnPlay: TPngCustomButton;
    btnStop: TPngCustomButton;
    Filter1: TFilter;
    FilterGraph1: TFilterGraph;
    DSTrackBar1: TDSTrackBar;
    btnPause: TPngCustomButton;
    Timer1: TTimer;
    CombQXCount: TComboBox;
    Label6: TLabel;
    procedure btnCancelClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure PngCustomButton2Click(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnPauseClick(Sender: TObject);
  public
    { Public declarations }
  end;

var
  frmQueryCallRecord: TfrmQueryCallRecord;

implementation
uses
  uCallRecord, uGlobalDM,MMSystem, uCallRoomDM;
{$R *.dfm}

procedure TfrmQueryCallRecord.actEscExecute(Sender: TObject);
begin
  btnCancel.Click;
end;

procedure TfrmQueryCallRecord.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmQueryCallRecord.btnQueryClick(Sender: TObject);
var
  ado : TADOQuery;
  item : TListItem;
  i : Integer;
  strTemp  : string;
begin
  lvDrink.Items.Clear;
  TCallRecordOpt.QueryRecord(GlobalDM.LocalADOConnection,'',dtpBeginDate.DateTime,dtpEndDate.DateTime,edtTrainmanName.Text,edtTrainmanNumber.Text,-1,-1,(CombQXCount.ItemIndex-1),ado);
  try
    i :=0;
    with ado do
    begin
      while not eof do
      begin
        Inc(i);
        item := lvDrink.Items.Add;
        item.Caption := IntToStr(i);
        item.SubItems.Add(FieldByName('strAreaName').AsString);
        item.SubItems.Add(FieldByName('strTrainNo').AsString);
        item.SubItems.Add(FieldByName('strRoomNumber').AsString);
        strTemp := '�׽�';
        if FieldByName('bIsRecall').AsInteger = 1 then
        begin
          strTemp := '�߽�';
        end;
        item.SubItems.Add(strTemp);
        strTemp := 'ʧ��';
        if FieldByName('bCallSucceed').AsInteger = 1 then
        begin
          strTemp := '�ɹ�';
        end;
        item.SubItems.Add(strTemp);
        item.SubItems.Add(FieldByName('dtCreateTime').AsString);
        item.SubItems.Add(FieldByName('strDutyName').AsString);
        if (FieldByName('QXCount').asInteger > 0) then
          item.SubItems.Add('���˼ƻ�')
        else
          item.SubItems.Add('ǿ�ݼƻ�');
        item.SubItems.Add(FieldByName('strGUID').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmQueryCallRecord.FormCreate(Sender: TObject);
var
  ado : TADOQuery;
begin
  dtpBeginDate.Date := GlobalDM.GetNow;
  dtpEndDate.Date := GlobalDM.GetNow;

end;

procedure TfrmQueryCallRecord.btnPauseClick(Sender: TObject);
begin
  FilterGraph1.Pause;
end;

procedure TfrmQueryCallRecord.btnPlayClick(Sender: TObject);
var
  recordGUID : string;
  callRecord : RCallRecord;
  fileName : string;
begin
  btnPlay.Enabled := false;
  if FilterGraph1.State = gsPaused then
  begin
    FilterGraph1.Play;
    exit;
  end;

  if lvDrink.Selected = nil then
  begin
    Application.MessageBox('��ѡ��а��¼��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  recordGUID := lvDrink.Selected.SubItems[8];
  callRecord := TCallRecordOpt.GetRecord(GlobalDM.LocalADOConnection,recordGUID);
  try

    //���ƣ�
    //fileName := DMGlobal.AppPath + 'temp\record.wav';
    fileName := GlobalDM.AppPath + 'temp\' + callRecord.strRoomNumber +
      FormatDateTime('yyyymmddhhnn',callRecord.dtCreateTime) + '.wav';

    if not DirectoryExists(GlobalDM.AppPath + 'temp') then
    begin
      ForceDirectories(GlobalDM.AppPath + 'temp');
    end;

    //(��)
    //callRecord.CallRecord.SaveToFile(fileName);
    if not FileExists(fileName) then
    begin
      if not DMCallRoom.FTPCon.DownLoad(callRecord.strRoomNumber +
        FormatDateTime('yyyymmddhhnn',callRecord.dtCreateTime) + '.wav',False) then
      begin
        if FileExists(fileName) then DeleteFile(fileName);
      end;
    end;

  finally
    //(��)
    //callRecord.CallRecord.Free;
  end;

  if FilterGraph1.State = gsPlaying then
  begin
    FilterGraph1.Stop;
  end;
  if not FilterGraph1.Active then
  begin
    FilterGraph1.Active := true;
  end;
  
  //(��)
  if not FileExists(fileName) then Exit;
  
  FilterGraph1.RenderFile(fileName);
  DMCallRoom.CallControl.SetPlayMode(2);
  FilterGraph1.Play;
end;

procedure TfrmQueryCallRecord.PngCustomButton2Click(Sender: TObject);
begin
 FilterGraph1.Pause;
end;

procedure TfrmQueryCallRecord.Timer1Timer(Sender: TObject);
begin
  btnPlay.Enabled := true;
  btnPause.Enabled := false;
  btnStop.Enabled := false;
  if FilterGraph1.Active then
  begin
    if FilterGraph1.State = gsPlaying then
    begin
      btnPlay.Enabled := false;
      btnPause.Enabled := true;
      btnStop.Enabled := true;
    end;
    if FilterGraph1.State = gsStopped then
    begin
      btnPlay.Enabled := true;
      btnPause.Enabled := false;
      btnStop.Enabled := false;
    end;
    if FilterGraph1.State = gsPaused then
    begin
      btnPlay.Enabled := true;
      btnPause.Enabled := false;
      btnStop.Enabled := true;
    end;
  end;
end;

procedure TfrmQueryCallRecord.btnStopClick(Sender: TObject);
begin
  FilterGraph1.Stop;
  FilterGraph1.ClearGraph;
end;

end.
