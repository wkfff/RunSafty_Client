unit ufrmShowWorkTime;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, RzPanel, StdCtrls, RzButton, Buttons, PngSpeedButton,
  uWorkTimeDefine, RzLine, RzLabel,uSaftyEnum,DateUtils;

type
  TfrmShowWorkTime = class(TForm)
    Bevel1: TBevel;
    RzButton1: TRzButton;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Bevel2: TBevel;
    RzFlowPanel1: TRzFlowPanel;
    lblTangTime: TLabel;
    lblBeginWorkFuShi: TLabel;
    lblEndWorkFuShi: TLabel;
    Label4: TLabel;
    procedure FormShow(Sender: TObject);
    procedure RzButton1Click(Sender: TObject);
  private
    { Private declarations }
    procedure AddInfo(strInfo: string);
    function GetInroomText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetOutroomText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetBeginWorkText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetEndText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetRuKuText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetChuKuText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetKaiCheText(WorkTimeInfo: RRsWorkTimeInfo): string;
    function GetTingCheText(WorkTimeInfo: RRsWorkTimeInfo): string;

    procedure DealEndWorkTime();
    function GetTimeText(dtBeginTime,dtEndTime: TDateTime): string;
    function GetEventTime(EventType: TRsEventType;var dtTime: TDateTime): Boolean;
  public
    { Public declarations }
    ArrayWorkTimeInfo: TRsArrayWorkTimeInfo;
  end;
procedure ShowWorkTimeForm(ArrayWorkTimeInfo: TRsArrayWorkTimeInfo);
implementation
procedure ShowWorkTimeForm(ArrayWorkTimeInfo: TRsArrayWorkTimeInfo);
var
  frmShowWorkTime: TfrmShowWorkTime;
begin
  frmShowWorkTime := TfrmShowWorkTime.Create(nil);
  try
    frmShowWorkTime.ArrayWorkTimeInfo := ArrayWorkTimeInfo;
    
    frmShowWorkTime.ShowModal;
  finally
    frmShowWorkTime.Free;
  end; 
end;
{$R *.dfm}

procedure TfrmShowWorkTime.AddInfo(strInfo: string);
var
  lbl: TLabel;
begin
  lbl := TLabel.Create(self);
  lbl.Caption := strInfo;
  lbl.Parent := RzFlowPanel1;
end;


procedure TfrmShowWorkTime.DealEndWorkTime;
var
  i: Integer;
  bFind: Boolean;
begin
  //如果没有记录，则不添加退勤时间
  if Length(ArrayWorkTimeInfo) = 0 then
    Exit;

    bFind := False;
  for I := 0 to Length(ArrayWorkTimeInfo) - 1 do
  begin
    if ArrayWorkTimeInfo[i].EventType = etEndWork then
    begin
      bFind := True;
      Break;
    end;
  end;

  if not bFind then
  begin
    SetLength(ArrayWorkTimeInfo,Length(ArrayWorkTimeInfo) + 1);
    ArrayWorkTimeInfo[Length(ArrayWorkTimeInfo) - 1].dtEventTime := Now;
    ArrayWorkTimeInfo[Length(ArrayWorkTimeInfo) - 1].EventType := etEndWork;
  end;


end;

procedure TfrmShowWorkTime.FormShow(Sender: TObject);
var
  i: Integer;
  strText: string;
  dtTime: TDateTime;
begin
  if Length(ArrayWorkTimeInfo) = 0 then
    Exit;

  DealEndWorkTime();

  
  lblTangTime.Caption := GetTimeText(
    ArrayWorkTimeInfo[0].dtEventTime,
    ArrayWorkTimeInfo[Length(ArrayWorkTimeInfo) - 1].dtEventTime
    );

  if GetEventTime(etEnterStation,dtTime) then
  begin
    lblBeginWorkFuShi.Caption := GetTimeText(dtTime,
      ArrayWorkTimeInfo[0].dtEventTime);
  end;

  if GetEventTime(etLeaveStation,dtTime) then
  begin
    lblEndWorkFuShi.Caption := GetTimeText(dtTime,
      ArrayWorkTimeInfo[Length(ArrayWorkTimeInfo) - 1].dtEventTime);
  end;

  for I := 0 to Length(ArrayWorkTimeInfo) - 1 do
  begin
    strText := '';
    case ArrayWorkTimeInfo[i].EventType of
      etInroom:  strText := GetInroomText(ArrayWorkTimeInfo[i]);
      etOutroom: strText := GetOutroomText(ArrayWorkTimeInfo[i]);
      etBeginWork: strText := GetBeginWorkText(ArrayWorkTimeInfo[i]);
      etEndWork: strText := GetEndText(ArrayWorkTimeInfo[i]);
      etRuKu: strText := GetRuKuText(ArrayWorkTimeInfo[i]);
      etChuKu: strText := GetChuKuText(ArrayWorkTimeInfo[i]);
      etEnterStation: strText := GetKaiCheText(ArrayWorkTimeInfo[i]);
      etLeaveStation: strText := GetTingCheText(ArrayWorkTimeInfo[i]);
    end;

    if strText <> '' then
      AddInfo(strText);
  end;
    
end;


function TfrmShowWorkTime.GetBeginWorkText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:出勤',WorkTimeInfo.dtEventTime);

  if WorkTimeInfo.strStationName <> '' then
    Result := Result + Format('(%s)',[WorkTimeInfo.strStationName]);
end;

function TfrmShowWorkTime.GetChuKuText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:出库',WorkTimeInfo.dtEventTime);
end;

function TfrmShowWorkTime.GetEndText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:退勤',WorkTimeInfo.dtEventTime);
end;


function TfrmShowWorkTime.GetInroomText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:入寓',WorkTimeInfo.dtEventTime);
end;

function TfrmShowWorkTime.GetKaiCheText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:开车',WorkTimeInfo.dtEventTime);
  if WorkTimeInfo.strCheCi <> '' then
    Result := Result + Format('(车次%s)',[WorkTimeInfo.strCheCi]);  
end;

function TfrmShowWorkTime.GetEventTime(EventType: TRsEventType;
    var dtTime: TDateTime): Boolean;
var
  i: Integer;
begin
  Result := False;
  for I := 0 to Length(ArrayWorkTimeInfo) - 1 do
  begin
    if ArrayWorkTimeInfo[i].EventType = EventType then
    begin
      dtTime := ArrayWorkTimeInfo[i].dtEventTime;
      Result := True;
      Break;
    end;
  end;

end;

function TfrmShowWorkTime.GetOutroomText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:离寓',WorkTimeInfo.dtEventTime);
end;

function TfrmShowWorkTime.GetRuKuText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:入库',WorkTimeInfo.dtEventTime);
end;

function TfrmShowWorkTime.GetTimeText(dtBeginTime,dtEndTime: TDateTime): string;
var
  nMinutes: Cardinal;
begin
  nMinutes := MinutesBetween(dtBeginTime,dtEndTime);

  Result := Format('%d小时%d分钟',[nMinutes div 60,nMinutes mod 60]);
end;

function TfrmShowWorkTime.GetTingCheText(WorkTimeInfo: RRsWorkTimeInfo): string;
begin
  Result := FormatDateTime('hh:nn:ss:停车',WorkTimeInfo.dtEventTime);
end;



procedure TfrmShowWorkTime.RzButton1Click(Sender: TObject);
begin
  ModalResult := mrOk;
end;

end.
