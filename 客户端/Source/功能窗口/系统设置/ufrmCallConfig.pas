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
    checkCheckAudioLine: TCheckBox;
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
uses uCallRoomDM,MMSystem,uGlobalDM;
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
  
  DMCallRoom.Port := StrToInt(edtPort.Text);
  DMCallRoom.CallWaiting := StrToInt(edtCallWaiting.Text);
  DMCallRoom.RecallSpace := StrToInt(edtRecallSpace.Text);
  DMCallRoom.MinSound := StrToInt(edtMinSound.Text);
  DMCallRoom.DialDelay := StrToInt(edtDialDelay.Text);
  DMCallRoom.MaxSound := StrToInt(edtMaxSound.Text);
  DMCallRoom.CommTypeID := ComboBox1.ItemIndex + 1;
  DMCallRoom.OutTimeDelay := StrToInt(edtOutTimeDelay.Text);

  DMCallRoom.ColorOutTime := pColorOutTime.Color;
  DMCallRoom.ColorUnenter := pColorUnenter.Color;
  DMCallRoom.ColorWaitingCall := pColorWaitingCall.Color;
  DMCallRoom.ColorCalling := pColorCalling.Color ;
  DMCallRoom.ColorOutDutyAlarm := pColorOutDutyAlarm.Color;


  DMCallRoom.MaxSoundNight := StrToInt(edtMaxSoundNight.Text);
  DMCallRoom.NightBegin := edtNightBegin.Time;
  DMCallRoom.NightEnd := edtNightEnd.Time ;

  DMCallRoom.CheckAudioLine := checkCheckAudioLine.Checked;
  DMCallRoom.WaitforConfirm := CheckWaitforConfirm.Checked;
  DMCallRoom.SaveConfig;
  ModalResult := mrOk;
end;

procedure TfrmCallConfig.btnTestLineClick(Sender: TObject);
begin
  btnTestLine.Caption := '测试中...';
  btnTestLine.Enabled := false;
  DMCallRoom.CallControl.SetRecordMode(2);
  PlaySound(PChar(ExtractFilePath(Application.ExeName) + '\Sounds\testline.wav'),0,SND_ASYNC);
  m_TestRecord := TMixerRecord.Create;
  m_TestRecord.Start;
  timerTestLine.Enabled := true;
end;

procedure TfrmCallConfig.FormCreate(Sender: TObject);
begin
  edtMinSound.Text := IntToStr(DMCallRoom.MinSound);
  edtPort.Text := IntToStr(DMCallRoom.Port);
  edtCallWaiting.Text := IntToStr(DMCallRoom.CallWaiting);
  edtRecallSpace.Text := IntToStr(DMCallRoom.RecallSpace);
  edtDialDelay.Text := IntToStr(DMCallRoom.DialDelay);
  ComboBox1.ItemIndex := DMCallRoom.CommTypeID - 1;
  edtMaxSound.Text := IntToStr(DMCallRoom.MaxSound);
  edtOutTimeDelay.Text := IntToStr(DMCallRoom.OutTimeDelay);

  pColorOutTime.Color := DMCallRoom.ColorOutTime;
  pColorUnenter.Color := DMCallRoom.ColorUnenter;
  pColorWaitingCall.Color := DMCallRoom.ColorWaitingCall;
  pColorCalling.Color := DMCallRoom.ColorCalling;
  pColorOutDutyAlarm.Color := DMCallRoom.ColorOutDutyAlarm;

  edtMaxSoundNight.Text := IntToStr(DMCallRoom.MaxSoundNight);
  edtNightBegin.Time := DMCallRoom.NightBegin;
  edtNightEnd.Time := DMCallRoom.NightEnd;

  checkCheckAudioLine.Checked := DMCallRoom.CheckAudioLine;
  CheckWaitforConfirm.Checked := DMCallRoom.WaitforConfirm;
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
    DMCallRoom.CallControl.SetRecordMode(1);
    btnTestLine.Enabled := true;
    btnTestLine.Caption := '通讯线路检查';
  end;

end;

end.

