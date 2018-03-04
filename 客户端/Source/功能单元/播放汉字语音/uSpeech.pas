unit uSpeech;

interface
uses Classes, SysUtils, SpeechLib_TLB, OleServer, Registry, Windows, MMSystem;

const
    REG_SPEECH = 'SOFTWARE\Microsoft\Speech\Voices\Tokens\';
type
  {TPlayMode ���ŷ�ʽ}
  TPlayMode = (pmAuto{�Զ�ѡ��},pmWavFile{wav�ļ�},pmStringToSpeech{�ı�ת����});
////////////////////////////////////////////////////////////////////////////////
/// ������TSpeech
/// ���ܣ���������,�������������������������ļ�ʱ�򲥷��ļ�
///  ///////////////////////////////////////////////////////////////////////////
  TSpeech = class
  public
    constructor Create();
    destructor Destroy(); override;
  public
    {����:��������}
    procedure Play(strPlay: string;PlayMode: TPlayMode = pmAuto);
    {����:�ж��������Ƿ����}
    function VoiceIsValid(): Boolean;
    {����:�ж��������ļ��Ƿ����}
    function VoiceFileExist(): Boolean;
    {����:��ͣ}
    procedure Pause();
    {����:��������}
    procedure Resume();
    {����:ֹͣ}
    procedure Stop();
  private
    {�������}
    m_SpVoice: TSpVoice;
    {�����ļ�����·��}
    m_SoundFilePath: string;
    {�Ƿ�Ϊ��ͣ״̬}
    m_bPause: Boolean;
    function TextToSpeech(strText: string): Boolean;
  public
    property SoundFilePath: string read m_SoundFilePath write m_SoundFilePath;
  end;

procedure TFPlaySound(strText: string;PlayMode: TPlayMode = pmAuto);
var
  g_Speech: TSpeech = nil;
implementation
procedure TFPlaySound(strText: string;PlayMode: TPlayMode);
begin
  if not Assigned(g_Speech) then
  begin
    g_Speech := TSpeech.Create;
    g_Speech.SoundFilePath := ExtractFilePath(ParamStr(0)) + 'Sound\';
  end;


  g_Speech.Play(strText,PlayMode);  
end;
{ TSpeech }

constructor TSpeech.Create;
begin
  m_SpVoice := TSpVoice.Create(nil);
  m_SpVoice.ConnectKind := ckRunningOrNew;
end;

destructor TSpeech.Destroy;
begin
  m_SpVoice.free;
end;

procedure TSpeech.Pause;
begin
  m_SpVoice.Pause;
  m_bPause := True;
end;

procedure TSpeech.Play(strPlay: string;PlayMode: TPlayMode);
{����:��������}
begin
  case PlayMode of
    pmAuto:
      begin
        if not (VoiceIsValid and TextToSpeech(strPlay)) then
        begin
          if FileExists(m_SoundFilePath + strPlay + '.wav') then
            PlaySound(PChar(m_SoundFilePath + strPlay + '.wav'), 0,
              SND_FILENAME or SND_ASYNC);
        end;

      end;
    pmWavFile:
      begin
        if FileExists(strPlay) then
          PlaySound(PChar(strPlay), 0,
            SND_FILENAME or SND_SYNC);
      end;
    pmStringToSpeech:
      begin
        if VoiceIsValid then
        begin
          TextToSpeech(strPlay);
        end;
      end;
  end;

end;

procedure TSpeech.Resume;
begin
  if m_bPause then
  begin
    m_SpVoice.Resume;
    m_bPause := False;
  end;

end;

procedure TSpeech.Stop;
begin
  m_SpVoice.Disconnect();
end;


function TSpeech.TextToSpeech(strText: string): Boolean;
begin
  Result := False;
  try
    m_SpVoice.Speak(strText, SVSFDefault);
    Result := True;
  except
  end;
end;

function TSpeech.VoiceFileExist: Boolean;
{����:�ж��������ļ��Ƿ����}
const
  DllFile1 = 'vt_chi_lily16.dll';
  DllFile2 = 'vtchisapi50.dll';
var
  Registry: TRegistry;
  strVoicePath: string;
begin
  Registry := TRegistry.Create;
  try
    Registry.RootKey := HKEY_LOCAL_MACHINE;
    Registry.OpenKey(REG_SPEECH + 'VW Lily', False);

    strVoicePath := Registry.ReadString('VoiceData');

    Result := DirectoryExists(strVoicePath);

    if not Result then
      Exit;

    strVoicePath := strVoicePath + 'lib\';

    Result := FileExists(strVoicePath + DllFile1);

    if not Result then
      Exit;

    Result := FileExists(strVoicePath + DllFile2);
  finally
    Registry.Free;
  end;
end;

function TSpeech.VoiceIsValid: Boolean;
{����:�ж��������Ƿ����}
var
  SpeechObjectTokens: ISpeechObjectTokens;
  SpeechToken: ISpeechObjectToken;
  i: Integer;
begin
  Result := False;
  SpeechObjectTokens := m_SpVoice.GetVoices('','');
  for I := 0 to SpeechObjectTokens.Count - 1 do
  begin
    SpeechToken := nil;
    SpeechToken := SpeechObjectTokens.Item(i);
    if SpeechToken.GetAttribute('Name') = 'VW Lily' then
    begin
      m_SpVoice.Voice := SpeechToken;
      Result := VoiceFileExist();
      Break;
    end;

  end;
  SpeechObjectTokens := nil;
  SpeechToken := nil;

end;
initialization
finalization
  if Assigned(g_Speech) then
    FreeAndNil(g_Speech);
end.


