unit ufrmCallConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, Mask, RzEdit, ComCtrls, ExtCtrls,uMixerRecord;

type
  TfrmCallConfig = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    edtPort: TRzNumericEdit;
    edtCallWaiting: TRzNumericEdit;
    edtRecallSpace: TRzNumericEdit;
    edtMinSound: TRzNumericEdit;
    edtDialDelay: TRzNumericEdit;
    ComboBox1: TComboBox;
    edtMaxSound: TRzNumericEdit;
    Label15: TLabel;
    edtOutTimeDelay: TRzNumericEdit;
    Label16: TLabel;
    Label18: TLabel;
    btnClose: TSpeedButton;
    btnSave: TSpeedButton;
    pColorOutTime: TPanel;
    pColorUnenter: TPanel;
    pColorWaitingCall: TPanel;
    pColorCalling: TPanel;
    pColorOutDutyAlarm: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label17: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    ColorDialog1: TColorDialog;
    edtMaxSoundNight: TRzNumericEdit;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    edtNightEnd: TRzDateTimeEdit;
    edtNightBegin: TRzDateTimeEdit;
    btnTestLine: TButton;
    timerTestLine: TTimer;
    CheckWaitforConfirm: TCheckBox;
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure pColorOutTimeDblClick(Sender: TObject);
    procedure btnTestLineClick(Sender: TObject);
    procedure timerTestLineTimer(Sender: TObject);
  private
    { Private declarations }
    m_TestRecord : TMixerRecord;
  public
    { Public declarations }
  end;

var
  frmCallConfig: TfrmCallConfig;

implementation
uses
  uGlobalDM,MMSystem;
{$R *.dfm}

procedure TfrmCallConfig.btnCloseClick(Sender: TObject);
begin
 Close;
end;

procedure TfrmCallConfig.btnSaveClick(Sender: TObject);
begin
  if ComboBox1.ItemIndex = 0 then
  begin
    if Application.MessageBox('"串口"通讯类型只适用于安装调试，您确定要这样设定吗？','提示',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then exit;
  end;
  
  GlobalDM.Port := StrToInt(edtPort.Text);
  GlobalDM.CallWaiting := StrToInt(edtCallWaiting.Text);
  GlobalDM.RecallSpace := StrToInt(edtRecallSpace.Text);
  GlobalDM.MinSound := StrToInt(edtMinSound.Text);
  GlobalDM.DialDelay := StrToInt(edtDialDelay.Text);
  GlobalDM.MaxSound := StrToInt(edtMaxSound.Text);
  GlobalDM.CommTypeID := ComboBox1.ItemIndex + 1;
  GlobalDM.OutTimeDelay := StrToInt(edtOutTimeDelay.Text);

  GlobalDM.ColorOutTime := pColorOutTime.Color;
  GlobalDM.ColorUnenter := pColorUnenter.Color;
  GlobalDM.ColorWaitingCall := pColorWaitingCall.Color;
  GlobalDM.ColorCalling := pColorCalling.Color ;
  GlobalDM.ColorOutDutyAlarm := pColorOutDutyAlarm.Color;


  GlobalDM.MaxSoundNight := StrToInt(edtMaxSoundNight.Text);
  GlobalDM.NightBegin := edtNightBegin.Time;
  GlobalDM.NightEnd := edtNightEnd.Time ;

  GlobalDM.WaitforConfirm := CheckWaitforConfirm.Checked;
  GlobalDM.SaveConfig;
  ModalResult := mrOk;
end;

procedure TfrmCallConfig.btnTestLineClick(Sender: TObject);
begin
  btnTestLine.Caption := '测试中...';
  btnTestLine.Enabled := false;
  GlobalDM.CallControl.SetRecordMode(2);
  PlaySound(PChar(ExtractFilePath(Application.ExeName) + '\Sounds\testline.wav'),0,SND_ASYNC);
  m_TestRecord := TMixerRecord.Create;
  m_TestRecord.Start;
  timerTestLine.Enabled := true;
end;

procedure TfrmCallConfig.FormCreate(Sender: TObject);
begin
  edtMinSound.Text := IntToStr(GlobalDM.MinSound);
  edtPort.Text := IntToStr(GlobalDM.Port);
  edtCallWaiting.Text := IntToStr(GlobalDM.CallWaiting);
  edtRecallSpace.Text := IntToStr(GlobalDM.RecallSpace);
  edtDialDelay.Text := IntToStr(GlobalDM.DialDelay);
  ComboBox1.ItemIndex := GlobalDM.CommTypeID - 1;
  edtMaxSound.Text := IntToStr(GlobalDM.MaxSound);
  edtOutTimeDelay.Text := IntToStr(GlobalDM.OutTimeDelay);

  pColorOutTime.Color := GlobalDM.ColorOutTime;
  pColorUnenter.Color := GlobalDM.ColorUnenter;
  pColorWaitingCall.Color := GlobalDM.ColorWaitingCall;
  pColorCalling.Color := GlobalDM.ColorCalling;
  pColorOutDutyAlarm.Color := GlobalDM.ColorOutDutyAlarm;

  edtMaxSoundNight.Text := IntToStr(GlobalDM.MaxSoundNight);
  edtNightBegin.Time := GlobalDM.NightBegin;
  edtNightEnd.Time := GlobalDM.NightEnd;
  CheckWaitforConfirm.Checked := GlobalDM.WaitforConfirm;
end;

procedure TfrmCallConfig.pColorOutTimeDblClick(Sender: TObject);
begin
  if ColorDialog1.Execute then
  begin
    TPanel(Sender).Color := ColorDialog1.Color;
  end;
end;

procedure TfrmCallConfig.timerTestLineTimer(Sender: TObject);
var
  i,nMidValue,nMaxValue: Integer;
begin
  TTimer(Sender).Enabled := false;
  try
    m_TestRecord.Stop;
    PlaySound(PChar(GlobalDM.AppPath + '\Sounds\nil'),0,SND_ASYNC);
    nMaxValue := 0;
    for i := 0 to Length(m_TestRecord.SaveBuf) - 1  do
    begin
      if i mod 2 = 1 then
      begin
        nMidValue := m_TestRecord.SaveBuf[i];
        if nMidValue > 127 then
        begin
          nMidValue :=  (not nMidValue) and $FF;
        end;
        if nMaxValue < nMidValue then
        begin
          nMaxValue := nMidValue;
        end;        
      end;
    end;
    
    if nMaxValue >120 then
    begin
      ShowMessage('通讯线路：正常');
    end
    else
    begin
      ShowMessage('通讯线路：断开');
    end;
  finally

    m_TestRecord.Free;
    GlobalDM.CallControl.SetRecordMode(1);
    btnTestLine.Enabled := true;
    btnTestLine.Caption := '通讯线路检查';
  end;

end;

end.

