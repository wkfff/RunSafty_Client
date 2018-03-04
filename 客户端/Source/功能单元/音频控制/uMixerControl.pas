////////////////////////////////////////////////////////////////////////////////
//混音器依据层次分为 设备---目标线路---源线路 三层。由于概念的理解和封装的需要
//将目标线路和设备和成一个概念，目前结构为两次  设备---源线路
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
  /// 混音设备类
  //////////////////////////////////////////////////////////////////////////////
  TMixerDevice = class
  public
    destructor Destroy; override;
    //初始化数据
    procedure Init;
    
  private
    //包含的目标线路，一般一个设备包含一个目标线路，为了调用者方便此处这样封装
    m_DestLines: TDestLineArray;
    m_SystemData: TMixerCaps;
    m_nHandle: integer;
    m_nIndex: Integer;
    function GetDeviceName: string;
  public

    //存储系统的数据
    property SystemData: TMixerCaps read m_SystemData write m_SystemData;
    //设备名称
    property DeviceName: string read GetDeviceName;
    //包含的目标线路
    //property SourceLines: TSourceLineArray read m_SourceLines;
    property DestLines : TDestLineArray read m_DestLines;
    //设备句柄
    property Handle: integer read m_nHandle write m_nHandle;
    //设备序号
    property Index: integer read m_nIndex write m_nIndex;
  end;

  //目标线路类
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
    //系统数据
    property SystemData: TMixerLine read m_SystemData write m_SystemData;
    //线路名称
    property LineName: string read GetLineName;
    //是否为录音设备，如不是则为放音设备
    property IsRecord: boolean read GetIsRecord;
    //录音设备的序号
    property RecordIndex: integer read GetRecordIndex write SetRecordIndex;
    //包含的源线路集合
    property SourceLines: TSourceLineArray read m_SourceLines;
    //所属设备
    property Parent: TMixerDevice read m_Parent write m_Parent;
    //线路序号
    property Index: integer read m_nIndex write m_nIndex;
  end;
  //均衡值类型
  TBalanceValue = array[0..1] of Integer;

  //////////////////////////////////////////////////////////////////////////////
  /// 混音源线路类
  //////////////////////////////////////////////////////////////////////////////
  TMixerSourceLine = class
  public
    //将左右声道的音量转换为可显示的值
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
    //通过设备ID和控件ID设置音量
    class procedure SetVolumeEx(hDevice : Cardinal;nControlID : Cardinal);
    //声音
    property Volume: Integer read GetVolume write SetVolume;
    //是否静音，如果所属目标线路为录音设备则表示为是否被选择
    property Mute: boolean read GetMute write SetMute;
    //左右声道音量（此值的最大值为音量）
    property Balance: TBalanceValue read GetBalance write SetBalance;
    //源线路名称
    property LineName: string read GetLineName;
    //源线路控件ID
    property ControlID: integer read GetControlID;
    //系统数据
    property SystemData: TMixerLine read m_SystemData write m_SystemData;
    //所属目标线路
    property Parent: TMixerDestLine read m_Parent write m_Parent;
    //源线路序号
    property Index: Integer read m_nIndex write m_nIndex;
  end;

  TMixerNotifyEvent = procedure(SourceLine: TMixerSourceLine) of object;
  //混音器控制类
  TMixerControl = class
  private
    m_Devices: TDeviceArray;
    m_OnMuteChange: TMixerNotifyEvent;
    m_OnVolumeChange: TMixerNotifyEvent;
    m_OnRecordIndexChange: TMixerNotifyEvent;
    //音频设备的线发生变化
    procedure WMMixmLineChange(var Message: TMessage);
  public
    constructor Create;
    destructor Destroy; override;
    //判断当前录音设备是否为麦克风
    function IsRecordMic(out MirEnable : boolean) : boolean;
    //判断当前录音设备是否为LINEIN
    function IsRecordLineIn(out LineInEnable : boolean) : boolean;
    //获取音频输出的主音量0-65535
    function GetMasterVolumn : Word;
    //获取音频输出的音量0-65535
    function GetWaveOutVolumn : Word;
    //获取主音量是否静音
    function GetMasterMute : boolean;
    //获取当前waveout是否静音
    function GetWaveOutMute : boolean;
    //获取当前LineIn的音量
    function GetRecordLineInVolumn : Word;
  public
    property Devices: TDeviceArray read m_Devices write m_Devices;
    property OnMuteChange: TMixerNotifyEvent read m_OnMuteChange write m_OnMuteChange;
    property OnVolumeChange: TMixerNotifyEvent read m_OnVolumeChange write m_OnVolumeChange;
    property OnRecordIndexChange: TMixerNotifyEvent read m_OnRecordIndexChange write m_OnRecordIndexChange;
  end;
implementation
function GetVolume(DN: TDeviceName): Word; //参数Master为主音量
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
function GetMute(DN: TDeviceName): Boolean; //参数Master为主音量
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
  //静音变化
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
              //发送事件
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
    //录音选择变化
    if ctrlID = 0 then
    begin
      m_OnRecordIndexChange(nil);
      exit;
    end;
    //音量，平衡变化
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
                //发送事件
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

    //获取左右声道的值
    //左右声道的值根据音量的值来判断
    //最大值为主音量
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

    //获取左右声道的值
    //左右声道的值根据音量的值来判断
    //最大值为主音量
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
  //获取线路信息
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
    //获取线路详细信息
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
  //获取线路信息
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
    //获取线路详细信息
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

