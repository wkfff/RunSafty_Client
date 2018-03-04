unit uFrmRoomStateConfig;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, StdCtrls,IniFiles,uGlobalDM, ExtCtrls,uTFSystem;

type
  TfrmRoomStateConfig = class(TForm)
    Panel1: TPanel;
    btnOK: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label3: TLabel;
    mmoText: TMemo;
    edtSpeed: TEdit;
    edtScorllFont: TEdit;
    edtInterval: TEdit;
    TabSheet2: TTabSheet;
    Label8: TLabel;
    edtRoomMaxCount: TEdit;
    Label4: TLabel;
    edtRoomWidth: TEdit;
    Label5: TLabel;
    edtRoomFont: TEdit;
    clrbxRoomFont: TColorBox;
    Label15: TLabel;
    clrbxRoomBK: TColorBox;
    Label14: TLabel;
    Label6: TLabel;
    edtTrainmanWidth: TEdit;
    Label7: TLabel;
    edtTrainmanFont: TEdit;
    clrbxTrainmanFont: TColorBox;
    Label17: TLabel;
    clrbxTrainmanBK: TColorBox;
    Label16: TLabel;
    Label12: TLabel;
    edtRefresh: TEdit;
    Label13: TLabel;
    Label1: TLabel;
    edtColCount: TEdit;
    TabSheet3: TTabSheet;
    clrbxScorlFontCL: TColorBox;
    clrbxScorlBKCL: TColorBox;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    edtTimeFontSize: TEdit;
    Label21: TLabel;
    clrbxTimeBKCL: TColorBox;
    Label22: TLabel;
    clrbxTimeFontCL: TColorBox;
    Label23: TLabel;
    edtSafeFontSize: TEdit;
    Label24: TLabel;
    clrbxSafeFontCL: TColorBox;
    Label25: TLabel;
    clrbxSafeBKCL: TColorBox;
    Label26: TLabel;
    edtSafeDays: TEdit;
    btnConfig: TButton;
    Label27: TLabel;
    edtTimeWidth: TEdit;
    Label28: TLabel;
    edtSafeWidth: TEdit;
    Label29: TLabel;
    edtColWidth: TEdit;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnConfigClick(Sender: TObject);
  private
    { Private declarations }
    {功能：读取ini文件}
    procedure ReadIni();
    {功能：写入ini文件}
    procedure WriteIni();
  public
    { Public declarations }
  end;
function ShowFrmRoomStateConfig(): Boolean;

implementation

uses uCallRoomDM;

{$R *.dfm}
function ShowFrmRoomStateConfig(): Boolean;
var
  FrmRoomStateConfig: TfrmRoomStateConfig;
begin
  FrmRoomStateConfig := TfrmRoomStateConfig.Create(nil);
  try
    if FrmRoomStateConfig.ShowModal = mrOk then
      Result := True
    else
      Result := False;
  finally
    FrmRoomStateConfig.Free;
  end;
end;  
procedure TfrmRoomStateConfig.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmRoomStateConfig.btnConfigClick(Sender: TObject);
var
  ini: TIniFile;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
  try
    try
      ini.WriteInteger('RoomState','SafeDays',StrToInt(edtSafeDays.Text));
      ini.WriteString('RoomState','SetSafeTime',FormatDateTime('yyyy-mm-dd hh:nn:ss',GlobalDM.GetNow));
      Box('设置成功');
    except
      on e: Exception do
      begin
        Box('请确认输入是否正确' + e.Message);
        Exit;
      end;  
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrmRoomStateConfig.btnOKClick(Sender: TObject);
begin
  WriteIni();
  ModalResult := mrOk;
end;

procedure TfrmRoomStateConfig.FormShow(Sender: TObject);
begin
  ReadIni();
end;

procedure TfrmRoomStateConfig.ReadIni;
var
  ini: TIniFile;
  i: Integer;
begin
  ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');
  try
    mmoText.Lines.Add(ini.ReadString('RoomState','Text',''));
    edtSpeed.Text := IntToStr(ini.ReadInteger('RoomState','Speed',2));
    edtScorllFont.Text := IntToStr(ini.ReadInteger('RoomState','ScorllFont',38));
    edtInterval.Text := IntToStr(ini.ReadInteger('RoomState','Interval',200));

    edtRoomMaxCount.Text := IntToStr(ini.ReadInteger('RoomState','RoomMaxCount',2));
    edtRoomWidth.Text := IntToStr(ini.ReadInteger('RoomState','RoomWidth',20));
    edtRoomFont.Text := IntToStr(ini.ReadInteger('RoomState','RoomFont',16));

    edtTrainmanWidth.Text := IntToStr(ini.ReadInteger('RoomState','TrainmanWidth',20));
    edtTrainmanFont.Text := IntToStr(ini.ReadInteger('RoomState','TrainmanFont',16));

    edtRefresh.Text := IntToStr(ini.ReadInteger('RoomState','Refresh',30));
    edtColCount.Text := IntToStr(ini.ReadInteger('RoomState','ColCount',10));
    edtColWidth.Text := IntToStr(ini.ReadInteger('RoomState','ColWidth',80));

    edtTimeWidth.Text := IntToStr(ini.ReadInteger('RoomState','TimeWidth',185));
    edtTimeFontSize.Text := IntToStr(ini.ReadInteger('RoomState','TimeFont',20));

    edtSafeFontSize.Text := IntToStr(ini.ReadInteger('RoomState','SafeFont',20));
    edtSafeWidth.Text := IntToStr(ini.ReadInteger('RoomState','SafeWidth',185));

    for I := 0 to clrbxRoomBK.Items.Count - 1 do
    begin
      if clrbxRoomBK.Colors[i] =
        StringToColor(ini.Readstring('RoomState','RoomBKCL','clHighlight')) then
      begin
        clrbxRoomBK.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxRoomFont.Items.Count - 1 do
    begin
      if clrbxRoomFont.Colors[i] =
        StringToColor(ini.Readstring('RoomState','RoomFontCL','clWindow')) then
      begin
        clrbxRoomFont.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxTrainmanBK.Items.Count - 1 do
    begin
      if clrbxTrainmanBK.Colors[i] =
        StringToColor(ini.Readstring('RoomState','TrainmanBKCL','clWindow')) then
      begin
        clrbxTrainmanBK.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxTrainmanFont.Items.Count - 1 do
    begin
      if clrbxTrainmanFont.Colors[i] =
        StringToColor(ini.Readstring('RoomState','TrainmanFontCL','clWindowText')) then
      begin
        clrbxTrainmanFont.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxScorlFontCL.Items.Count - 1 do
    begin
      if clrbxScorlFontCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','ScorlFontCL','clRed')) then
      begin
        clrbxScorlFontCL.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxScorlBKCL.Items.Count - 1 do
    begin
      if clrbxScorlBKCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','ScorlBKCL','clScrollBar')) then
      begin
        clrbxScorlBKCL.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxTimeBKCL.Items.Count - 1 do
    begin
      if clrbxTimeBKCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','TimeBKCL','clScrollBar')) then
      begin
        clrbxTimeBKCL.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxTimeFontCL.Items.Count - 1 do
    begin
      if clrbxTimeFontCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','TimeFontCL','clRed')) then
      begin
        clrbxTimeFontCL.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxSafeFontCL.Items.Count - 1 do
    begin
      if clrbxSafeFontCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','SafeFontCL','clRed')) then
      begin
        clrbxSafeFontCL.ItemIndex := i;
        Break;
      end;
    end;
    for I := 0 to clrbxSafeBKCL.Items.Count - 1 do
    begin
      if clrbxSafeBKCL.Colors[i] =
        StringToColor(ini.Readstring('RoomState','SafeBKCL','clScrollBar')) then
      begin
        clrbxSafeBKCL.ItemIndex := i;
        Break;
      end;
    end;
  finally
    ini.Free;
  end;
end;

procedure TfrmRoomStateConfig.WriteIni;
var
  ini: TIniFile;
begin
  try
    ini := TIniFile.Create(GlobalDM.AppPath + 'config.ini');

    ini.WriteString('RoomState','Text',Trim(mmoText.Text));
    ini.WriteInteger('RoomState','Speed',StrToInt(edtSpeed.Text));
    ini.WriteInteger('RoomState','ScorllFont',StrToInt(edtScorllFont.Text));
    ini.WriteInteger('RoomState','Interval',StrToInt(edtInterval.Text));
    ini.WriteString('RoomState','ScorlFontCL',ColorToString(clrbxScorlFontCL.Colors[clrbxScorlFontCL.ItemIndex]));
    ini.WriteString('RoomState','ScorlBKCL',ColorToString(clrbxScorlBKCL.Colors[clrbxScorlBKCL.ItemIndex]));

    ini.WriteInteger('RoomState','RoomMaxCount',StrToInt(edtRoomMaxCount.Text));
    ini.WriteInteger('RoomState','RoomWidth',StrToInt(edtRoomWidth.Text));
    ini.WriteInteger('RoomState','RoomFont',StrToInt(edtRoomFont.Text));
    ini.WriteString('RoomState','RoomBKCL',ColorToString(clrbxRoomBK.Colors[clrbxRoomBK.itemindex]));
    ini.WriteString('RoomState','RoomFontCL',ColorToString(clrbxRoomFont.Colors[clrbxRoomFont.ItemIndex]));

    ini.WriteInteger('RoomState','TrainmanWidth',StrToInt(edtTrainmanWidth.Text));
    ini.WriteInteger('RoomState','TrainmanFont',StrToInt(edtTrainmanFont.Text));
    ini.WriteString('RoomState','TrainmanBKCL',ColorToString(clrbxTrainmanBK.Colors[clrbxTrainmanBK.ItemIndex]));
    ini.WriteString('RoomState','TrainmanFontCL',ColorToString(clrbxTrainmanFont.Colors[clrbxTrainmanFont.ItemIndex]));

    ini.WriteInteger('RoomState','Refresh',StrToInt(edtRefresh.Text));
    ini.WriteInteger('RoomState','ColCount',StrToInt(edtColCount.Text));
    ini.WriteInteger('RoomState','ColWidth',StrToInt(edtColWidth.Text));

    ini.WriteInteger('RoomState','TimeWidth',StrToInt(edtTimeWidth.Text));
    ini.WriteInteger('RoomState','TimeFont',StrToInt(edtTimeFontSize.Text));
    ini.WriteString('RoomState','TimeFontCL',ColorToString(clrbxTimeFontCL.Colors[clrbxTimeFontCL.ItemIndex]));
    ini.WriteString('RoomState','TimeBKCL',ColorToString(clrbxTimeBKCL.Colors[clrbxTimeBKCL.ItemIndex]));

    ini.WriteString('RoomState','SafeFontCL',ColorToString(clrbxSafeFontCL.Colors[clrbxSafeFontCL.ItemIndex]));
    ini.WriteString('RoomState','SafeBKCL',ColorToString(clrbxSafeBKCL.Colors[clrbxSafeBKCL.ItemIndex]));
    ini.WriteInteger('RoomState','SafeWidth',StrToInt(edtSafeWidth.Text));
    ini.WriteInteger('RoomState','SafeFont',StrToInt(edtSafeFontSize.Text));
  finally
    ini.Free;
  end;
end;


end.
