////////////////////////////////////////////////////////////////////////////////
//���������ݲ�η�Ϊ �豸---Ŀ����·---Դ��· ���㡣���ڸ�������ͷ�װ����Ҫ
//��Ŀ����·���豸�ͳ�һ�����Ŀǰ�ṹΪ����  �豸---Դ��·
////////////////////////////////////////////////////////////////////////////////
unit uMixerControl;

interface

uses
  Messages, MMSystem, Forms;
type

  TMixerDevice = class;
  TMixerDestLine = class;
  TMixerSourceLine = class;

  TDeviceArray = array of TMixerDevice;
  TDestLineArray = array of TMixerDestLine;
  TSourceLineArray = array of TMixerSourceLine;
  TDeviceName = (Master, Microphone, WaveOut, Synth);
  //////////////////////////////////////////////////////////////////////////////
  /// �����豸��
  //////////////////////////////////////////////////////////////////////////////
  TMixerDevice = class
  public
    destructor Destroy; override;
    //��ʼ������
    procedure Init;
    
  private
    //������Ŀ����·��һ��һ���豸����һ��Ŀ����·��Ϊ�˵����߷���˴�������װ
    m_DestLines: TDestLineArray;
    m_SystemData: TMixerCaps;
    m_nHandle: integer;
    m_nIndex: Integer;
    function GetDeviceName: string;
  public

    //�洢ϵͳ������
    property SystemData: TMixerCaps read m_SystemData write m_SystemData;
    //�豸����
    property DeviceName: string read GetDeviceName;
    //������Ŀ����·
    //property SourceLines: TSourceLineArray read m_SourceLines;
    property DestLines : TDestLineArray read m_DestLines;
    //�豸���
    property Handle: integer read m_nHandle write m_nHandle;
    //�豸���
    property Index: integer read m_nIndex write m_nIndex;
  end;

  //Ŀ����·��
  TMixerDestLine = class
  public
    destructor Destroy; override;
  private
    m_SystemData: TMixerLine;
    m_SourceLines: TSourceLineArray;
    m_nIndex: integer;
    m_Parent: TMixerDevice;
    function GetLineName: string;
    function GetRecordIndex: integer;
    procedure SetRecordIndex(const Value: integer);
    function GetIsRecord: boolean;
  public
    procedure Init;
    //ϵͳ����
    property SystemData: TMixerLine read m_SystemData write m_SystemData;
    //��·����
    property LineName: string read GetLineName;
    //�Ƿ�Ϊ¼���豸���粻����Ϊ�����豸
    property IsRecord: boolean read GetIsRecord;
    //¼���豸�����
    property RecordIndex: integer read GetRecordIndex write SetRecordIndex;
    //������Դ��·����
    property SourceLines: TSourceLineArray read m_SourceLines;
    //�����豸
    property Parent: TMixerDevice read m_Parent write m_Parent;
    //��·���
    property Index: integer read m_nIndex write m_nIndex;
  end;
  //����ֵ����
  TBalanceValue = array[0..1] of Integer;

  //////////////////////////////////////////////////////////////////////////////
  /// ����Դ��·��
  //////////////////////////////////////////////////////////////////////////////
  TMixerSourceLine = class
  public
    //����������������ת��Ϊ����ʾ��ֵ
    function ExchangeBalance(MainVolume, LeftVolume, RightVolume: integer): integer;
  private
    m_SystemData: TMixerLine;
    m_Parent: TMixerDestLine;
    m_nIndex: Integer;
    procedure SetMute(const Value: boolean);
    procedure SetVolume(const Value: Integer);
    procedure SetBalance(const Value: TBalanceValue);

    function GetMute: boolean;
    function GetVolume: Integer;
    function GetBalance: TBalanceValue;

    function GetLineName: string;
    function GetControlID: integer;
  public
    //ͨ���豸ID�Ϳؼ�ID��������
    class procedure SetVolumeEx(hDevice : Cardinal;nControlID : Cardinal);
    //����
    property Volume: Integer read GetVolume write SetVolume;
    //�Ƿ������������Ŀ����·Ϊ¼���豸���ʾΪ�Ƿ�ѡ��
    property Mute: boolean read GetMute write SetMute;
    //����������������ֵ�����ֵΪ������
    property Balance: TBalanceValue read GetBalance write SetBalance;
    //Դ��·����
    property LineName: string read GetLineName;
    //Դ��·�ؼ�ID
    property ControlID: integer read GetControlID;
    //ϵͳ����
    property SystemData: TMixerLine read m_SystemData write m_SystemData;
    //����Ŀ����·
    property Parent: TMixerDestLine read m_Parent write m_Parent;
    //Դ��·���
    property Index: Integer read m_nIndex write m_nIndex;
  end;

  TMixerNotifyEvent = procedure(SourceLine: TMixerSourceLine) of object;
  //������������
  TMixerControl = class
  private
    m_Devices: TDeviceArray;
    m_OnMuteChange: TMixerNotifyEvent;
    m_OnVolumeChange: TMixerNotifyEvent;
    m_OnRecordIndexChange: TMixerNotifyEvent;
    //��Ƶ�豸���߷����仯
    procedure WMMixmLineChange(var Message: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    //�жϵ�ǰ¼���豸�Ƿ�Ϊ��˷�
    function IsRecordMic(out MirEnable : boolean) : boolean;
    //�жϵ�ǰ¼���豸�Ƿ�ΪLINEIN
    function IsRecordLineIn(out LineInEnable : boolean) : boolean;
    //��ȡ��Ƶ�����������0-65535
    function GetMasterVolumn : Word;
    //��ȡ��Ƶ���������0-65535
    function GetWaveOutVolumn : Word;
    //��ȡ�������Ƿ���
    function GetMasterMute : boolean;
    //��ȡ��ǰwaveout�Ƿ���
    function GetWaveOutMute : boolean;
    //��ȡ��ǰLineIn������
    function GetRecordLineInVolumn : Word;
  public
    property Devices: TDeviceArray read m_Devices write m_Devices;
    property OnMuteChange: TMixerNotifyEvent read m_OnMuteChange write m_OnMuteChange;
    property OnVolumeChange: TMixerNotifyEvent read m_OnVolumeChange write m_OnVolumeChange;
    property OnRecordIndexChange: TMixerNotifyEvent read m_OnRecordIndexChange write m_OnRecordIndexChange;
  end;
implementation
function GetVolume(DN: TDeviceName): Word; //����MasterΪ������
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  vol: TMIXERCONTROLDETAILS_UNSIGNED;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
begin
  Result := 0;
    //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then Exit;
    //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
    end;
    mxl.cbStruct := SizeOf(mxl);
        //   get   line   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);
    if intRet = MMSYSERR_NOERROR then begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);
      mxlc.pamxctrl := @mxc;
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
      if intRet = MMSYSERR_NOERROR then begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cbStruct := SizeOf(mxcd);
        mxcd.cMultipleItems := 0;
        mxcd.cbDetails := SizeOf(Vol);
        mxcd.paDetails := @vol;
        mxcd.cChannels := 1;
        mixerGetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
        Result := vol.dwValue;
      end;
    end;
    mixerClose(hMix);
  end;
end;
function GetMute(DN: TDeviceName): Boolean; //����MasterΪ������
var
  hMix: HMIXER;
  mxlc: MIXERLINECONTROLS;
  mxcd: TMIXERCONTROLDETAILS;
  vol: TMIXERCONTROLDETAILS_UNSIGNED;
  mxc: MIXERCONTROL;
  mxl: TMixerLine;
  intRet: Integer;
  nMixerDevs: Integer;
begin

  Result := false;
    //   Check   if   Mixer   is   available
  nMixerDevs := mixerGetNumDevs();
  if (nMixerDevs < 1) then Exit;
    //   open   the   mixer
  intRet := mixerOpen(@hMix, 0, 0, 0, 0);
  if intRet = MMSYSERR_NOERROR then begin
    case DN of
      Master: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_DST_SPEAKERS;
      Microphone: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE;
      WaveOut: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_WAVEOUT;
      Synth: mxl.dwComponentType := MIXERLINE_COMPONENTTYPE_SRC_SYNTHESIZER;
    end;
    mxl.cbStruct := SizeOf(mxl);
        //   get   line   info
    intRet := mixerGetLineInfo(hMix, @mxl, MIXER_GETLINEINFOF_COMPONENTTYPE);
    if intRet = MMSYSERR_NOERROR then begin
      FillChar(mxlc, SizeOf(mxlc), 0);
      mxlc.cbStruct := SizeOf(mxlc);
      mxlc.dwLineID := mxl.dwLineID;
      mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
      mxlc.cControls := 1;
      mxlc.cbmxctrl := SizeOf(mxc);
      mxlc.pamxctrl := @mxc;
      intRet := mixerGetLineControls(hMix, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
      if intRet = MMSYSERR_NOERROR then begin
        FillChar(mxcd, SizeOf(mxcd), 0);
        mxcd.dwControlID := mxc.dwControlID;
        mxcd.cbStruct := SizeOf(mxcd);
        mxcd.cMultipleItems := 0;
        mxcd.cbDetails := SizeOf(Vol);
        mxcd.paDetails := @vol;
        mxcd.cChannels := 1;
        mixerGetControlDetails(hMix, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
        Result := vol.dwValue > 0;
      end;
    end;
    mixerClose(hMix);
  end;
end;
{ TMixerControl }

constructor TMixerControl.Create;
var
  nDevIndex, nDevCount: Integer;
  mixerCaps: TMixerCaps;
  dev: TMixerDevice;
begin
  nDevCount := mixerGetNumDevs();
  SetLength(m_Devices, nDevCount);
  for nDevIndex := 0 to nDevCount - 1 do
  begin
    if (MMSYSERR_NOERROR = mixerGetDevCaps(nDevIndex, @mixerCaps, SizeOf(TMixerCaps))) then
    begin
      dev := TMixerDevice.Create;
      dev.SystemData := mixerCaps;
      dev.Index := nDevIndex;
      m_Devices[nDevIndex] := dev;
      mixerOpen(@(dev.Handle), nDevIndex, AllocateHWnd(WMMixmLineChange), 0, CALLBACK_WINDOW or MIXER_OBJECTF_MIXER);
      dev.Init;
    end;
  end;
end;

destructor TMixerControl.Destroy;
var
  i: integer;
begin
  for i := 0 to length(m_Devices) - 1 do
  begin
    mixerClose(m_Devices[i].Handle);
    m_Devices[i].Free;
  end;
  inherited;
end;

function TMixerControl.GetMasterMute: boolean;
begin
  Result := GetMute(Master);
end;

function TMixerControl.GetMasterVolumn: Word;
begin
  Result := GetVolume(Master);
end;

function TMixerControl.GetRecordLineInVolumn: Word;
var
  nDevIndex,nDestLineIndex,nSourceLineIndex: Integer;
  dev : TMixerDevice;
  dest : TMixerDestLine;
  src : TMixerSourceLine;
begin

  Result := 0;
  for nDevIndex := 0 to Length(Devices) - 1 do
  begin
    dev := Devices[nDevIndex];
    for nDestLineIndex := 0 to Length(dev.DestLines) - 1 do
    begin
      dest := dev.DestLines[nDestLineIndex];
      if dest.IsRecord then
      begin
        for nSourceLineIndex := 0 to Length(dest.SourceLines) - 1 do
        begin
          src := dest.SourceLines[nSourceLineIndex];
          if src.SystemData.dwComponentType = MIXERLINE_COMPONENTTYPE_SRC_LINE then
          begin
            Result := src.Volume;
          end;
        end;
      end;
    end;
  end;
end;

function TMixerControl.GetWaveOutMute: boolean;
begin
 Result := GetMute(WaveOut);
end;

function TMixerControl.GetWaveOutVolumn: Word;
begin
  Result := GetVolume(WaveOut);
end;

function TMixerControl.IsRecordLineIn(out LineInEnable : boolean): boolean;
var
  nDevIndex,nDestLineIndex,nSourceLineIndex: Integer;
  dev : TMixerDevice;
  dest : TMixerDestLine;
  src : TMixerSourceLine;
begin
  LineInEnable := false;
  Result := false;
  for nDevIndex := 0 to Length(Devices) - 1 do
  begin
    dev := Devices[nDevIndex];
    for nDestLineIndex := 0 to Length(dev.DestLines) - 1 do
    begin
      dest := dev.DestLines[nDestLineIndex];
      if dest.IsRecord then
      begin
        for nSourceLineIndex := 0 to Length(dest.SourceLines) - 1 do
        begin
          src := dest.SourceLines[nSourceLineIndex];
          if src.SystemData.dwComponentType = MIXERLINE_COMPONENTTYPE_SRC_LINE then
          begin
            LineInEnable := true;
            if Length(dest.SourceLines) - 1 -  nSourceLineIndex = dest.RecordIndex then
            begin
              Result := true;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMixerControl.IsRecordMic(out MirEnable : boolean): boolean;
var
  nDevIndex,nDestLineIndex,nSourceLineIndex: Integer;
  dev : TMixerDevice;
  dest : TMixerDestLine;
  src : TMixerSourceLine;
begin
  MirEnable := false;
  Result := false;
  for nDevIndex := 0 to Length(Devices) - 1 do
  begin
    dev := Devices[nDevIndex];
    for nDestLineIndex := 0 to Length(dev.DestLines) - 1 do
    begin
      dest := dev.DestLines[nDestLineIndex];
      if dest.IsRecord then
      begin
        for nSourceLineIndex := 0 to Length(dest.SourceLines) - 1 do
        begin
          src := dest.SourceLines[nSourceLineIndex];
          if src.SystemData.dwComponentType = MIXERLINE_COMPONENTTYPE_SRC_MICROPHONE then
          begin
            MirEnable := true;
            if Length(dest.SourceLines) - 1 -  nSourceLineIndex = dest.RecordIndex then
            begin
              Result := true;   
            end;
          end;
        end;
      end;
    end;
  end;
end;

procedure TMixerControl.WMMixmLineChange(var Message: TMessage);
var
  devID,lineID, ctrlID: Integer;
  nDeviceIndex,nDestLineIndex, nSourceLineIndex: Integer;
  dev: TMixerDevice;
  dest : TMixerDestLine;
  src: TMixerSourceLine;
begin
  //�����仯
  if (Message.Msg = MM_MIXM_LINE_CHANGE) then
  begin
    lineID := Message.LParam;
    if m_Devices = nil then exit;
    
    for nDeviceIndex := 0 to Length(m_Devices) - 1 do
    begin
      dev := m_Devices[nDeviceIndex];
      if dev.DestLines = nil then continue;

      if Length(dev.DestLines) = 0 then continue;
      
      for nSourceLineIndex := 0 to Length(dev.m_DestLines[0].m_SourceLines) - 1 do
      begin
        src := dev.m_DestLines[0].m_SourceLines[nSourceLineIndex];
        if not src.Parent.IsRecord then
        begin
          if Integer(src.m_SystemData.dwLineID) = lineID then
          begin
              //�����¼�
            if assigned(m_OnMuteChange) then
            begin
              m_OnMuteChange(src);
            end;
          end;
        end;

      end;
    end;
  end;
  if (Message.Msg = MM_MIXM_CONTROL_CHANGE) then
  begin
    ctrlID := Message.LParam;
    devID := Message.WParam;
    //¼��ѡ��仯
    if ctrlID = 0 then
    begin
      m_OnRecordIndexChange(nil);
      exit;
    end;
    //������ƽ��仯
    for nDeviceIndex := 0 to Length(m_Devices) - 1 do
    begin
      dev := m_Devices[nDeviceIndex];
      if dev.Handle = devID then
      begin
        for nDestLineIndex := 0 to Length(dev.m_DestLines) - 1 do
        begin
          dest := dev.DestLines[nDestLineIndex];
          for nSourceLineIndex := 0 to Length(dest.m_SourceLines) - 1 do
          begin
            src := dest.m_SourceLines[nSourceLineIndex];
            if src.ControlID = ctrlID then
            begin
                //�����¼�
              if assigned(m_OnVolumeChange) then
              begin
                m_OnVolumeChange(src);
              end;
            end;
          end;
        end;
      end;
    end;
  end;
end;

{ TMixerSourceLine }



function TMixerSourceLine.ExchangeBalance(MainVolume, LeftVolume,
  RightVolume: integer): integer;
begin
  Result := MainVolume;
  if LeftVolume < MainVolume then
  begin
    Result := MainVolume * 2 - LeftVolume;
  end;
  if RightVolume < MainVolume then
  begin
    Result := RightVolume;
  end;
end;

function TMixerSourceLine.GetBalance: TBalanceValue;
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: array[0..1] of MIXERCONTROLDETAILS_UNSIGNED;
begin
  Result[0] := 0;
  Result[1] := 0;
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  //   Get   the   mute   control
  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 2;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_UNSIGNED);
    mxcd.paDetails := @mcdMute;

    //��ȡ����������ֵ
    //����������ֵ����������ֵ���ж�
    //���ֵΪ������
    intRet := mixerGetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
    if intRet = MMSYSERR_NOERROR then
    begin
      Result[0] := mcdMute[0].dwValue;
      Result[1] := mcdMute[1].dwValue;
    end;
  end;
end;

function TMixerSourceLine.GetControlID: integer;
var
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
begin
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
  Result := mxc.dwControlID;
end;

function TMixerSourceLine.GetLineName: string;
begin
  Result := m_SystemData.szName;
end;

function TMixerSourceLine.GetMute: boolean;
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin
  Result := false;
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 1;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.paDetails := @mcdMute;
    intRet := mixerGetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
    if intRet = MMSYSERR_NOERROR then
      Result := (mcdMute.fValue <> 0);
  end;
end;

function TMixerSourceLine.GetVolume: Integer;
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin
  Result := -1;
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 1;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.paDetails := @mcdMute;
    intRet := mixerGetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
    if intRet = MMSYSERR_NOERROR then
      Result := mcdMute.fValue;
  end;
end;



procedure TMixerSourceLine.SetBalance(const Value: TBalanceValue);
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: array[0..1] of MIXERCONTROLDETAILS_UNSIGNED;

begin
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  //   Get   the   mute   control
  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 2;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_UNSIGNED);
    mxcd.paDetails := @mcdMute;
    mcdMute[0].dwValue := Value[0];
    mcdMute[1].dwValue := Value[1];

    //��ȡ����������ֵ
    //����������ֵ����������ֵ���ж�
    //���ֵΪ������
    mixerSetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
  end;
end;

procedure TMixerSourceLine.SetMute(const Value: boolean);
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin

  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUTE;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 1;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.paDetails := @mcdMute;
    mcdMute.fValue := 0;
    if Value then
      mcdMute.fValue := 1;
    mixerSetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
  end;
end;

procedure TMixerSourceLine.SetVolume(const Value: Integer);
var
  intRet: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: MIXERCONTROLDETAILS_BOOLEAN;
begin

  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_VOLUME;
  mxlc.cControls := 1;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;


  intRet := mixerGetLineControls(Parent.Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);

  if intRet = MMSYSERR_NOERROR then
  begin
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cChannels := 1;
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.paDetails := @mcdMute;
    mcdMute.fValue := Value;
    mixerSetControlDetails(Parent.Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);

  end;
end;

class procedure TMixerSourceLine.SetVolumeEx(hDevice, nControlID: Cardinal);
begin
//
end;

{ TMixerDestLine }

destructor TMixerDestLine.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(m_SourceLines) - 1 do
  begin
    m_SourceLines[i].Free;
  end;
  inherited;
end;

function TMixerDestLine.GetIsRecord: boolean;
begin
  Result := (m_SystemData.cControls = 1);
end;

function TMixerDestLine.GetLineName: string;
begin
  Result := m_SystemData.szName;
end;

function TMixerDestLine.GetRecordIndex: integer;
var
  intRet, tempInt: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: array of MIXERCONTROLDETAILS_BOOLEAN;
begin
  Result := -1;
  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUX;
  mxlc.cControls := 0;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;
  //��ȡ��·��Ϣ
  intRet := mixerGetLineControls(Parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
  if intRet = MMSYSERR_NOERROR then
  begin
    SetLength(mcdMute, mxc.cMultipleItems);
    for tempInt := 0 to mxc.cMultipleItems - 1 do
    begin
      mcdMute[tempInt].fValue := 0;
    end;
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.cChannels := 1;
    mxcd.cMultipleItems := 0;
    mxcd.paDetails := mcdMute;
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cMultipleItems := mxc.cMultipleItems;
    //��ȡ��·��ϸ��Ϣ
    intRet := mixerGetControlDetails(Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
    if intRet = MMSYSERR_NOERROR then
    begin
      for tempInt := 0 to Length(mcdMute) - 1 do
      begin
        if mcdMute[tempInt].fValue > 0 then
        begin
          Result := tempInt;
        end;
      end;
    end;
  end;
end;



procedure TMixerDestLine.Init;
var
  i: integer;
  sourceLine: TMixerSourceLine;
  lineData: TMixerLine;
begin

  SetLength(m_SourceLines, m_SystemData.cConnections);
  for i := 0 to m_SystemData.cConnections - 1 do
  begin
    sourceLine := TMixerSourceLine.Create;
    lineData.cbStruct := sizeof(MIXERLINE);
    lineData.dwDestination := Index;
    lineData.dwSource := i;
    if (MMSYSERR_NOERROR = mixerGetLineInfo(Parent.Index, @lineData, MIXER_GETLINEINFOF_SOURCE)) then
    begin
      sourceLine.SystemData := lineData;
      sourceLine.m_Parent := Self;
      sourceLine.Index := i;
      m_SourceLines[i] := sourceLine;
    end;
  end;

end;

procedure TMixerDestLine.SetRecordIndex(const Value: integer);
var
  intRet, tempInt: Integer;
  mxlc: MIXERLINECONTROLS;
  mxc: MIXERCONTROL;
  mxcd: TMIXERCONTROLDETAILS;
  mcdMute: array of MIXERCONTROLDETAILS_BOOLEAN;
begin

  FillChar(mxlc, SizeOf(mxlc), 0);
  mxlc.cbStruct := SizeOf(mxlc);
  mxlc.dwLineID := m_SystemData.dwLineID;
  mxlc.dwControlType := MIXERCONTROL_CONTROLTYPE_MUX;
  mxlc.cControls := 0;
  mxlc.cbmxctrl := SizeOf(mxc);
  mxlc.pamxctrl := @mxc;
  //��ȡ��·��Ϣ
  intRet := mixerGetLineControls(parent.Index, @mxlc, MIXER_GETLINECONTROLSF_ONEBYTYPE);
  if intRet = MMSYSERR_NOERROR then
  begin
    SetLength(mcdMute, mxc.cMultipleItems);
    for tempInt := 0 to mxc.cMultipleItems - 1 do
    begin
      mcdMute[tempInt].fValue := 0;
    end;
    FillChar(mxcd, SizeOf(mxcd), 0);
    mxcd.cbStruct := SizeOf(TMIXERCONTROLDETAILS);
    mxcd.cbDetails := SizeOf(MIXERCONTROLDETAILS_BOOLEAN);
    mxcd.cChannels := 1;
    mxcd.cMultipleItems := 0;
    mxcd.paDetails := mcdMute;
    mxcd.dwControlID := mxc.dwControlID;
    mxcd.cMultipleItems := mxc.cMultipleItems;
    for tempInt := 0 to Length(mcdMute) - 1 do
    begin
      mcdMute[tempInt].fValue := 0;
      if tempInt = Value then
      begin
        mcdMute[tempInt].fValue := 1;
      end;
    end;
    //��ȡ��·��ϸ��Ϣ
    mixerSetControlDetails(Parent.Index, @mxcd, MIXER_SETCONTROLDETAILSF_VALUE);
  end;
end;

{ TMixerDevice }

destructor TMixerDevice.Destroy;
var
  i: integer;
begin
  for i := 0 to Length(m_DestLines) - 1 do
  begin
    m_DestLines[i].Free;
  end;
  inherited;
end;

function TMixerDevice.GetDeviceName: string;
begin
  Result := m_SystemData.szPname;
end;

procedure TMixerDevice.Init;
var
  i: integer;
  destLine : TMixerDestLine;
  lineData: TMixerLine;
begin
  SetLength(m_DestLines, m_SystemData.cDestinations);
  for i := 0 to m_SystemData.cDestinations - 1 do
  begin
    lineData.cbStruct := sizeof(TMixerLine);
    lineData.dwDestination := i;
    if (MMSYSERR_NOERROR = mixerGetLineInfo(Index, @lineData, MIXER_GETLINEINFOF_DESTINATION)) then
    begin
      destLine := TMixerDestLine.Create;
      destLine.Index := i;
      destLine.Parent := Self;
      destLine.SystemData := lineData;
      m_DestLines[i] := destLine;
      destLine.Init;
    end;
  end;

end;



end.

