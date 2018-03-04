unit uCallUtils;

interface
uses
  Classes, Windows, uCallRecord;
type
  TCallThread = class(TThread)
  private
    m_CallData: TCallData;
    m_bIsRecall: boolean;
  protected
    procedure Execute(); override;
    procedure CallRoom(callData: TCallData; recall: boolean);
  public
    property CallData: TCallData read m_CallData write m_CallData;
    property IsRecall: boolean read m_bIsRecall write m_bIsRecall;
  end;

  TCallFunction = class
  public
    //�жϵ�ǰ�Ƿ������һ�νа���
    class function InCallWaitingTime(lastCallTime, dtNow: TDateTime; callWaiting: Cardinal): boolean;
    //�жϽа������Ƿ��ѹ���
    class function HasExpired(callTime,appTime : TDateTime;ExpiredDelay:Word) : boolean;
    //�ܷ�а�
    class function CanCall(callData : TCallData;nowTime : TDateTime;callDelay:Word) : boolean;
    class function CalRecall(callData : TCallData;nowTime : TDateTime;callDelay:Word) : boolean;
  end;
implementation

{ TCallThread }
uses
  uDataModule, SysUtils, MMSystem, uFrmMain, uLogs, DateUtils,uFrmCallConfirm;

procedure TCallThread.CallRoom(callData: TCallData; recall: boolean);
//���ܣ��Զ��а�
var
  i, devID, maxCallCount, errorCode, lParam: Integer;
  callSucceed: boolean;
begin
  lParam := 0;
  if recall then lParam := 1;

  PostMessage(frmMain.Handle, WM_MSGCallBegin, 0, lParam);
  devID := callData.nDeviceID;
  maxCallCount := 0;
  callSucceed := false;
  try
    DMGlobal.CloseMic;
    errorCode := 1;
    TLog.SaveLog(now, '��ʼ�򿪴���');
    {$REGION '���Ӻ��У����ʧ�����ظ�10��'}
    repeat
      Sleep(500);
      try
        errorCode := DMGlobal.CallRoom(devID);
        if errorCode > 0 then
        begin
          Inc(maxCallCount);
        end else begin
          maxCallCount := 1000;
          callSucceed := true;
        end;
      except
        Inc(maxCallCount);
      end;
    until (maxCallCount >= 10);
    {$ENDREGION '���Ӻ��У����ʧ�����ظ�10��'}
    if not callSucceed then
    begin
      TLog.SaveLog(now, '��ʼ��ʧ��');
      PostMessage(frmMain.Handle, WM_MSGCallEnd, errorCode, lParam);
      exit;
    end;
    PostMessage(frmMain.Handle, WM_MSGRecordBegin, 0, 0);
    try
      {$REGION '���Žа�����'}
      if callSucceed then
      begin
        if not recall then
        begin
          TLog.SaveLog(now, '��ʼ���Žа�����');
          DMGlobal.PlayFirstCall(callData.strRoomNumber, callData.strTrainNo);
          TLog.SaveLog(now, '���Žа����ֽ���');
          if DMGlobal.WaitforConfirm then
          begin
            DMGlobal.WaitingForConfirm := true;
            PostMessage(frmMain.Handle,WM_MSGWaitingForConfirm,StrToInt(callData.strRoomNumber),0);
            while DMGlobal.WaitingForConfirm do
            begin
              Sleep(10);
            end;
          end else begin
            //�ȴ�˾���ش�6��ȴ�
            for i := 1 to 30 do
            begin
              Sleep(200);
            end;
          end;
        end
        else
          DMGlobal.PlaySecondCall(callData.strRoomNumber, callData.strTrainNo);
      end
      else begin
        DMGlobal.CallControl.SetPlayMode(2);
        PlaySound(PChar(DMGlobal.AppPath + 'Sounds\�а�ʧ��.wav'), 0, SND_FILENAME or SND_SYNC);
      end;
    finally
      PostMessage(frmMain.Handle, WM_MSGRecordEnd, 0, 0);
      PostMessage(frmMain.Handle, WM_MSGCallEnd, 0, lParam);
    end;
    {$ENDREGION '���Žа�����'}
  finally
    DMGlobal.HangCall();
    DMGlobal.OpenMic;
  end;
end;

procedure TCallThread.Execute;
begin
  CallRoom(m_CallData, m_bIsRecall);
end;

{ TCallFunction }

class function TCallFunction.CalRecall(callData: TCallData; nowTime: TDateTime;
  callDelay: Word): boolean;
begin
  Result := false;
end;

class function TCallFunction.CanCall(callData : TCallData; nowTime: TDateTime;
  callDelay: Word): boolean;
begin
  Result := false;
  if callData.nCallState <> 0 then exit;
  if nowTime < callData.dtCallTime then exit;
  if (MinutesBetween(callData.dtCallTime, nowTime) < callDelay)  then
    Result := true;
end;

class function TCallFunction.HasExpired(callTime,appTime: TDateTime;
  ExpiredDelay: Word): boolean;
begin
  Result := (IncMinute(callTime,ExpiredDelay) < appTime);
end;

class function TCallFunction.InCallWaitingTime(
  lastCallTime, dtNow: TDateTime; callWaiting: Cardinal): boolean;
begin
  Result := false;
  if YearOf(lastCallTime) = 9999 then
  begin
    Result := true;
    exit;
  end;

  if IncSecond(lastCallTime, callWaiting) >= now then
  begin
    Result := true;
  end;
end;

end.

