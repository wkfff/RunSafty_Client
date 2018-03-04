unit uFrmRoomState;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, uScollCtrls, ExtCtrls, Grids, AdvObj, BaseGrid, AdvGrid,IniFiles,
  uGlobalDM,uRoom,ADODB,uRoomWaitDBOprate, uThreadTimer, StdCtrls, AdvSplitter,
  DateUtils;

type
  TfrmRoomState = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    AdvStringGrid1: TAdvStringGrid;
    Timer1: TTimer;
    pnlTime: TPanel;
    Panel4: TPanel;
    Timer2: TTimer;
    ScorllText1: TScorllText;
    lblTime: TLabel;
    AdvSplitter1: TAdvSplitter;
    pnlSafe: TPanel;
    lblSafe: TLabel;
    Label4: TLabel;
    Label2: TLabel;
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure AdvStringGrid1DblClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
  private
    { Private declarations }
    m_MainFormHandel: HWND;
    {显示房间所在行的宽度}
    m_RoomWidth: Integer;
    {显示房间所在行字体大小}
    m_RoomFont: Integer;
    {房间背景色}
    m_RoomBKCL: TColor;
    {房间字体颜色}
    m_RoomFontCL: TColor;
    {显示人员所在行的宽度}
    m_TrainmanWidth: Integer;
    {显示人员所在行字体大小}
    m_TrainmanFont: Integer;
    {人员背景颜色}
    m_TrainmanBKCL: TColor;
    {人员字体颜色}
    m_TrainmanFontCL: TColor;
    {房间最大人数}
    m_RoomMaxCount: Integer;
    {房间列表}
    m_RoomList: TStringList;
    {显示列数}
    m_ColWidth: Integer;
    m_Col: Integer;
    m_RoomTrainmanList: TRoomTrainmanList;
    m_Time: TDateTime;
    {功能：读取配置}
    procedure ReadIni();
    {功能：设置配置}
    procedure SetConfig();
    {功能；显示数据}
    procedure ShowToListView();
    {功能：获取房间信息}
    procedure GetRooms();
    {功能：获取房间人员信息}
    procedure GetRoomTrainmans();
  public
    { Public declarations }
  published
    property MainFormHandel: HWND read m_MainFormHandel write m_MainFormHandel;
  end;

procedure ShowFrmRoomState(MainFormHandel: THandle);

implementation
uses uFrmSelect,uFrmRoomStateConfig, uCallRoomDM;

procedure ShowFrmRoomState(MainFormHandel: THandle);
var
  FrmRoomState: TfrmRoomState;
begin
  try
    FrmRoomState := TfrmRoomState.Create(nil);
    FrmRoomState.MainFormHandel := MainFormHandel;
    FrmRoomState.ShowModal;
  finally
    FrmRoomState.Free;
  end;
end;  
{$R *.dfm}

procedure TfrmRoomState.AdvStringGrid1DblClick(Sender: TObject);
begin
  if ShowFrmSelect then
  begin
    if ShowFrmRoomStateConfig then
    begin
      ReadIni();
      ShowToListView();
      SetConfig();
    end;
  end
  else
    Application.Terminate;
end;

procedure TfrmRoomState.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //Action := caFree;
end;

procedure TfrmRoomState.FormCreate(Sender: TObject);
begin
  m_RoomList := TStringList.Create;
  m_RoomTrainmanList := TRoomTrainmanList.Create;
  DoubleBuffered := True;
end;

procedure TfrmRoomState.FormDestroy(Sender: TObject);
begin
  DoubleBuffered := False;
  m_RoomList.Free;
  m_RoomTrainmanList.Free;
  Application.Terminate;
end;

procedure TfrmRoomState.FormShow(Sender: TObject);
begin
  Self.WindowState := wsMaximized;
  ScorllText1.Top := 1;
  ScorllText1.Left := 1;
  ScorllText1.Width := Screen.Width - pnlTime.Width - pnlSafe.Width - 2;
  ScorllText1.Height := Panel4.Height;

  ReadIni();
  GetRooms();

  GetRoomTrainmans();
  ShowToListView();
  SetConfig();
  AdvStringGrid1.Refresh;
  ScorllText1.Scrolling := True;
end;

procedure TfrmRoomState.GetRooms;
var
  ado : TADOQuery;
  strRoomNumber: string;
begin
  TRoomOpt.GetRoomsWithIn('',ado);
  m_RoomList.Clear;
  try
    with ado do
    begin
      while not eof do
      begin
        strRoomNumber := Trim(FieldByName('strRoomNumber').AsString);
        try
          StrToInt(strRoomNumber);
        except
          Next;
          Continue;
        end;
        m_RoomList.Add(strRoomNumber);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmRoomState.GetRoomTrainmans;
var
  ado: TADOQuery;
  RoomTrainman: TRoomTrainman;
begin
  m_RoomTrainmanList.Clear;
  try
    TWaitPlanOpt.GetPlansByStateEx(GlobalDM.GetNow,ado);
    while not ado.Eof do
    begin
      RoomTrainman := TRoomTrainman.Create;
      RoomTrainman.RoomWaitingGUID := Trim(ado.FieldByName('strGUID').AsString);
      RoomTrainman.RoomNumber := Trim(ado.FieldByName('nRoomID').AsString);
      RoomTrainman.TrainmanArray := TWaitPlanOpt.GetRoomWaitingTrainman(RoomTrainman.RoomWaitingGUID);
      m_RoomTrainmanList.Add(RoomTrainman);
      ado.next;
    end;
  finally
    ado.Free;
  end;
end;

procedure TfrmRoomState.ReadIni;
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
  try
    ScorllText1.Lines.Clear;
    ScorllText1.Lines.Add(ini.ReadString('RoomState','Text',''));
    ScorllText1.ScorllSpeed := ini.ReadInteger('RoomState','Speed',2);
    ScorllText1.ScrollInterval := ini.ReadInteger('RoomState','Interval',200);
    ScorllText1.Font.Size := ini.ReadInteger('Roomstate','ScorllFont',38);
    ScorllText1.Color := StringToColor(ini.ReadString('RoomState','ScorlBKCL','clScrollBar'));
    ScorllText1.Font.Color := StringToColor(ini.ReadString('RoomState','ScorlFontCL','clRed'));
    lblTime.Color := StringToColor(ini.ReadString('RoomState','TimeBKCL','clScrollBar'));
    lblTime.Font.Color := StringToColor(ini.ReadString('RoomState','TimeFontCL','clRed'));
    lblTime.Font.Size := ini.ReadInteger('RoomState','TimeFont',22);
    pnlTime.Width := ini.ReadInteger('RoomState','TimeWidth',185);
    lblSafe.Color := StringToColor(ini.ReadString('RoomState','SafeBKCL','clScrollBar'));
    lblSafe.Font.Color := StringToColor(ini.ReadString('RoomState','SafeFontCL','clRed'));
    lblSafe.Font.Size := ini.ReadInteger('RoomState','SafeFont',22);
    pnlSafe.Width := ini.ReadInteger('RoomState','SafeWidth',185);
    m_RoomMaxCount := ini.ReadInteger('RoomState','RoomMaxCount',2);
    m_RoomWidth := ini.ReadInteger('RoomState','RoomWidth',20);
    m_RoomFont := ini.ReadInteger('RoomState','RoomFont',16);
    m_TrainmanWidth := ini.ReadInteger('RoomState','TrainmanWidth',20);
    m_TrainmanFont := ini.ReadInteger('RoomState','TrainmanFont',16);
    Timer1.Interval := ini.ReadInteger('RoomState','Refresh',30) * 1000;
    m_Col := ini.ReadInteger('RoomState','ColCount',10);
    m_ColWidth := ini.ReadInteger('RoomState','ColWidth',80);
    m_RoomBKCL := StringToColor(ini.ReadString('RoomState','RoomBKCL','clHighlight'));
    m_RoomFontCL := StringToColor(ini.ReadString('RoomState','RoomFontCL','clWindow'));
    m_TrainmanBKCL := StringToColor(ini.ReadString('RoomState','TrainmanBKCL','clWindow'));
    m_TrainmanFontCL := StringToColor(ini.ReadString('RoomState','TrainmanFontCL','clBlack'));
  finally
    ini.Free;
  end;
end;

procedure TfrmRoomState.SetConfig;
var
  i,j: Integer;
begin
  with AdvStringGrid1 do
  begin
    for I := 0 to RowCount - 1 do
    begin
      if i mod (m_RoomMaxCount + 1) = 0 then
      begin
        RowHeights[i] := m_RoomWidth;
        for j := 0 to m_Col - 1 do
        begin
          FontStyles[j,i] := [fsBold];
          FontSizes[j,i] := m_RoomFont;
          FontColors[j,i] := m_RoomFontCL;
          //RowColor[i] := clGrayText;
          RowColor[i] := m_RoomBKCL;
        end;
      end
      else
      begin
        RowHeights[i] := m_TrainmanWidth;
        for j := 0 to m_Col - 1 do
        begin
          //RowColor[i] := clWindow;
          FontSizes[j,i] := m_TrainmanFont;
          FontColors[j,i] := m_TrainmanFontCL;
          RowColor[i] := m_TrainmanBKCL;
        end;
      end;
    end;
    for i := 0 to m_Col - 1 do
    begin
      ColWidths[i] := m_ColWidth;
    end;

  end;
end;

procedure TfrmRoomState.ShowToListView;
var
  i,j,k,l,ARow,ACol: Integer;
begin
  AdvStringGrid1.ClearAll;
  AdvStringGrid1.RowCount := (m_RoomList.Count div m_Col + 1) * (m_RoomMaxCount + 1);
  AdvStringGrid1.ColCount := m_Col;
  ARow := 0;
  ACol := 0;
  for I := 0 to m_RoomList.Count - 1 do
  begin
    AdvStringGrid1.Cells[ACol,ARow] := m_RoomList[i];
    for j := 0 to m_RoomTrainmanList.Count - 1 do
    begin
      if m_RoomTrainmanList.Items[j].RoomNumber = m_RoomList[i] then
      begin
        for k  := 0 to m_RoomMaxCount - 1 do
        begin
          if k < Length(m_RoomTrainmanList.Items[j].TrainmanArray) then
            AdvStringGrid1.Cells[ACol,ARow + 1 + k]
            := m_RoomTrainmanList.Items[j].trainmanarray[k].strTrainmanName
          else
            AdvStringGrid1.Cells[ACol,ARow + 1 + k] := '';
        end;
      end;
    end;

    if (((i + 1) div m_Col) > 0) and ((i + 1) mod m_Col = 0) then
    begin
      ARow := ARow + m_RoomMaxCount + 1;
      ACol := 0;
      Continue;
    end;
    ACol := ACol + 1;
  end;
end;

procedure TfrmRoomState.Timer1Timer(Sender: TObject);
begin
  GetRooms();
  GetRoomTrainmans();
  ShowToListView();
  SetConfig();
end;

procedure TfrmRoomState.Timer2Timer(Sender: TObject);
var
  dtTemp,dtNow: TDateTime;
  ini: TIniFile;
  strTemp: string;
  i: Integer;
begin
  dtNow := GlobalDM.GetNow;
  lblTime.Caption := FormatDateTime('yyyy-mm-dd',dtNow) + #13
    + FormatDateTime('hh:nn:ss',dtNow);
  ScorllText1.Height := Panel4.Height;
  ScorllText1.Width := Panel4.Width;
  ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
  try
    strTemp := ini.ReadString('RoomState','SetSafeTime','2000-01-01 00:00:00)');
    i := DaysBetween(dtNow,StrToDateTime(strTemp));
    i := i + ini.ReadInteger('RoomState','SafeDays',0);
    lblSafe.Caption := '安全生产' + #13 + IntToStr(i) + '天';
  finally
    ini.Free;
  end;
end;

end.
