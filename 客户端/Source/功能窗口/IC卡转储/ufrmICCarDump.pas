unit ufrmICCarDump;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,uTrainman,uDBTrainman, ExtCtrls, Buttons, PngSpeedButton, pngimage,
  StdCtrls, RzPanel, RzTabs, RzPrgres, ComCtrls, uICCardReader,uTFSystem,
  uICCDefines, uRunningRecordsFile,uDBRunRecord, uWriteICCarSoftDefined,
  ActnList,uTFVariantUtils;

type
  TfrmICCarDump = class(TForm)
    RzPanel4: TRzPanel;
    Label4: TLabel;
    Image2: TImage;
    btnClose: TPngSpeedButton;
    RzPanel6: TRzPanel;
    RzPageControl1: TRzPageControl;
    Panel1: TPanel;
    RzPanel5: TRzPanel;
    Label3: TLabel;
    Label2: TLabel;
    lblTrainmanNumber: TLabel;
    lblTrainmanName: TLabel;
    Image1: TImage;
    Label5: TLabel;
    imgTrainmanPicture1: TPaintBox;
    Label6: TLabel;
    btnListDir: TPngSpeedButton;
    btnICCarDump: TPngSpeedButton;
    TabSheet1: TRzTabSheet;
    ListView1: TListView;
    ICCardReader: TICCardReader;
    Panel2: TPanel;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    pnlDumpIng: TPanel;
    Label1: TLabel;
    ProgressBar: TRzProgressBar;
    ActionList1: TActionList;
    ActEsc: TAction;
    procedure btnListDirClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure imgTrainmanPicture1Paint(Sender: TObject);
    procedure btnICCarDumpClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure ICCardReaderReadProgressEvent(nCurrent, nTotal: Integer);
    procedure ActEscExecute(Sender: TObject);
  private
    { Private declarations }
    {乘务员信息}
    m_Trainman : RTrainman;

    {当前IC卡中的运行记录文件}
    m_RuntimeInfoArray : TRuntimeInfoArray;
  private
    {功能:保存转储记录}
    procedure SaveDumpRecord(RuntimeInfoArray : TRuntimeInfoArray);
    {功能:分析退勤信息}
    procedure AnalysisRecord(RuntimeInfoArray : TRuntimeInfoArray);
  public
    {功能:列目录}
    procedure ReadRuntimeInfo();
    { Public declarations }
  end;

  {功能:IC卡转储}
  procedure ICCarDump(Trainman : RTrainman);

implementation

uses uGlobalDM,ufrmReadICCarInfo;

{$R *.dfm}

procedure ICCarDump(Trainman : RTrainman);
{功能:IC卡转储}
var
  frmICCarDump : TfrmICCarDump;
begin
  frmICCarDump := TfrmICCarDump.Create(nil);
  try
    frmICCarDump.m_Trainman := Trainman;
    frmICCarDump.ShowModal;
  finally
    frmICCarDump.Free;
  end;
end;

procedure TfrmICCarDump.ActEscExecute(Sender: TObject);
begin
  Close;
end;

procedure TfrmICCarDump.AnalysisRecord(RuntimeInfoArray: TRuntimeInfoArray);
{功能:分析退勤信息}
var
  i : Integer;
  strFileName : String;
  FileList : TStringList;
  LKJHeaderInfo : RLKJHeaderInfo;
begin
  if GlobalDM.ICCardStorePath ='' then
  begin
    Box('您还未设置存储目录！');
    exit;
  end;
  
  if not FileExists(GlobalDM.ICCardStorePath) then
  begin
    if not ForceDirectories(GlobalDM.ICCardStorePath) then
    begin
      Box('创建存储目录失败，请检测指定的存储目录是否合法');
      exit;
    end;
  end;
  
  FileList := TStringList.Create;
  for I := 0 to length(RuntimeInfoArray) - 1 do
  begin
    strFileName :=
        GlobalDM.ICCardStorePath+RuntimeInfoArray[i].strFileName;
    FileList.Add(strFileName);
  end;
  try
    if GetLKJHeaderInfo(FileList,LKJHeaderInfo) then
    begin
//      if Pos('客车',LKJHeaderInfo.strKeHuo) > 0 then
//        m_Trainman.StateInfo.Properties[PROPERTIES_KEHUO] := khKeChe
//      else
//      begin
//        m_Trainman.StateInfo.Properties[PROPERTIES_KEHUO] := khHuoChe;
//      end;
//      m_Trainman.StateInfo.Properties[PROPERTIES_CHEXING] := LKJHeaderInfo.strCheXing;
//      m_Trainman.StateInfo.Properties[PROPERTIES_CHEHAO] := LKJHeaderInfo.strCheHao;
//      m_Trainman.StateInfo.Properties[PROPERTIES_CHECI] := LKJHeaderInfo.strCheCi;
//      m_Trainman.StateInfo.Properties[PROPERTIES_CHECIHEAD] := LKJHeaderInfo.strCheCiHead;
//      m_Trainman.StateInfo.Properties[PROPERTIES_FaCheShiJian] := LKJHeaderInfo.dtFileDateTime;
//      m_Trainman.StateInfo.Properties[PROPERTIES_DaoDaShiJian] := LKJHeaderInfo.dtDaoDaShiJian;
    end;
  finally
    FileList.Free;
  end;
end;

procedure TfrmICCarDump.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmICCarDump.btnICCarDumpClick(Sender: TObject);
var
  i : Integer;
  RuntimeInfoArray : TRuntimeInfoArray;
begin
  if ICCardReader.InitReaderDev(GlobalDM.ICardReaderType) = False then
  begin
    Box('初始化读卡器失败!请检查读卡器是否安装.');
    Exit;
  end;
  if GlobalDM.ICCardStorePath ='' then
  begin
    Box('您还未设置存储目录！');
    exit;
  end;
  
  if not FileExists(GlobalDM.ICCardStorePath) then
  begin
    if not ForceDirectories(GlobalDM.ICCardStorePath) then
    begin
      Box('创建存储目录失败，请检测指定的存储目录是否合法');
      exit;
    end;
  end;
  for I := 0 to ListView1.Items.Count - 1 do
  begin
    if ListView1.Items[i].Checked then
    begin
      SetLengTh(RuntimeInfoArray,LengTh(RuntimeInfoArray)+1);
      RuntimeInfoArray[length(RuntimeInfoArray)-1] :=
          m_RuntimeInfoArray[i];
    end;
  end;
  //ClearDirFile(GlobalDM.ICCardStorePath);
  btnICCarDump.Enabled := False;
  btnListDir.Enabled := False;
  try
    ProgressBar.PartsComplete := 0;
    pnlDumpIng.Visible := True;
    Application.ProcessMessages;
    ICCardReader.OutputSelectRuntimeFile(GlobalDM.ICCardStorePath,RuntimeInfoArray);
    SaveDumpRecord(RuntimeInfoArray);
    AnalysisRecord(RuntimeInfoArray);
    Box('转储成功!');
    Close;
  except
    on E: Exception do
    begin
      BoxErr('转储失败!错误:('+E.Message+')');
    end;
  end;
  pnlDumpIng.Visible := False;
  btnICCarDump.Enabled := True;
  btnListDir.Enabled := True;
  ICCardReader.CloseReaderDev;
end;

procedure TfrmICCarDump.btnListDirClick(Sender: TObject);
var
  ICCarAllInfo : RICCarAllInfo ;
begin
  if ReadIcCardInfo(ICCarAllInfo,[ciRuntimeInfo]) then
  begin
    m_RuntimeInfoArray := ICCarAllInfo.RuntimeInfoArray;
    ReadRuntimeInfo();
    if ListView1.Items.Count = 0 then
      Box('卡内无文件!')
    else
      btnICCarDump.Enabled := True;
  end;
end;

procedure TfrmICCarDump.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  ICCardReader.CloseReaderDev;
end;

procedure TfrmICCarDump.FormShow(Sender: TObject);
begin
  lblTrainmanName.Caption := m_Trainman.strTrainmanName;
  lblTrainmanNumber.Caption := m_Trainman.strTrainmanNumber;
end;

procedure TfrmICCarDump.ICCardReaderReadProgressEvent(nCurrent,
  nTotal: Integer);
begin
  ProgressBar.TotalParts := nTotal;
  ProgressBar.PartsComplete := nCurrent;
  Application.ProcessMessages;
end;

procedure TfrmICCarDump.imgTrainmanPicture1Paint(Sender: TObject);
begin
  TTFVariantUtils.CopyJPEGVariantToPaintBox(m_Trainman.Picture,TPaintBox(Sender));
end;

procedure TfrmICCarDump.ReadRuntimeInfo();
{功能:列目录}
var
  i : Integer;
  ListItem : TListItem;
begin
  ListView1.Items.Clear;
  for I := 0 to LengTh(m_RuntimeInfoArray) - 1 do
  begin
    ListItem := ListView1.Items.Add;
    ListItem.Checked := True;
    ListItem.Caption := m_RuntimeInfoArray[i].strFileName;
    ListItem.SubItems.Add(m_RuntimeInfoArray[i].strDriverNum);
    ListItem.SubItems.Add(m_RuntimeInfoArray[i].strTrianNum);
    ListItem.SubItems.Add(m_RuntimeInfoArray[i].strDriverNum);
    try
      ListItem.SubItems.Add(ByteUnitToString(m_RuntimeInfoArray[i].nFileLength));
    except on E: Exception do
    end;
  end;
end;

procedure TfrmICCarDump.SaveDumpRecord(RuntimeInfoArray : TRuntimeInfoArray);
{功能:保存转储记录}
begin
  TDBRunRecord.AddRecord(m_Trainman,RuntimeInfoArray,GlobalDM.ICCardStorePath);
end;

procedure TfrmICCarDump.SpeedButton1Click(Sender: TObject);
var
  i : Integer;
begin
  for I := 0 to ListView1.Items.Count - 1 do
    ListView1.Items[i].Checked := True;
end;

procedure TfrmICCarDump.SpeedButton2Click(Sender: TObject);
var
  i : Integer;
begin
  for I := 0 to ListView1.Items.Count - 1 do
    ListView1.Items[i].Checked := not ListView1.Items[i].Checked;
end;

end.
