unit uFrmGeXingChuQin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs,superobject, OleCtrls, AcroPDFLib_TLB, StdCtrls, ExtCtrls,
  RzPanel,uTrainPlan,uLCGeXingCheQin,uGlobalDM, SHDocVw,ComCtrls,Printers,
  idhttp,uTFSystem,Word_TLB,ComObj,excelxp;

type

  
  TFrmGeXingChuQin = class(TForm)
    rzpnl1: TRzPanel;
    rzpnl2: TRzPanel;
    btnPrint: TButton;
    btnExit: TButton;
    dlgPnt1: TPrintDialog;
    dlgPntSet1: TPrinterSetupDialog;    
    tmr1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //���ڼƻ�
    m_chuqinPlan: RRsChuQinPlan;
    //pdf�ļ�·��
    m_strPDFFilePath:string;
    //excel�ļ�·��
    m_strExcelFilePath:string;

    m_acrpdf: TAcroPDF;
  private
    {����:��ȡ���Գ���URL}
    procedure GetURL(var strPDFURL,strExcelURL:string);
    {����:����PDF�ļ�}
    function DoDownloadFile(url:string; ASaveName: string): Boolean;
  public
    {����:��ӡ����}
    procedure SetPrintPage;
    {����:��ȡ�ؼ�ͼ��}
    procedure GetControlImage(ControlHandle : THandle;Bmp : TBitmap);
    class procedure ShowGeXingChuQin(chuqinPlan: RRsChuQinPlan);
  end;

function PrintWindow(hWnd: HWND; hDCBlt: HWND; nFlags: Word): Bool; stdcall; external 'user32.dll';
implementation

{$R *.dfm}


procedure TFrmGeXingChuQin.SetPrintPage;
VAR
  Device:array [0..cchDeviceName-1] of Char;
  Driver:array [0..(MAX_PATH-1)] of Char;
  Port:array [0..32] of Char;
  hDMode:THandle;
  pDMode:PDevMode;
begin
  Printer.GetPrinter(Device,Driver,Port,hDMode);
  if hDMode<>0  then
  begin
    pDMode:=GlobalLock(hDMode);
    if pDMode<> nil   then
    begin
      //ֽ������
      pDMode^.dmPaperSize:= DMPAPER_B5;
      //���
      pDMode^.dmPaperLength:=1820; //ָ���L114mm
      pDMode^.dmPaperWidth:=2570;  //ָ����190mm
      //ֽ�ŷ���DMORIENT_LANDSCAPE����DMORIENT_PORTRAIT����
      pDMode^.dmOrientation := DMORIENT_PORTRAIT;
      pDMode^.dmFields:=pDMode^.dmFields or DM_PAPERSIZE;
      pDMode^.dmFields:=pDMode^.dmFields or DM_PAPERLENGTH;
      pDMode^.dmFields:=pDMode^.dmFields or DM_PAPERWIDTH;
      ResetDC(Printer.Handle,pDMode^);
      GlobalUnlock(hDMode);
    end;
  end;
end;
procedure TFrmGeXingChuQin.btnExitClick(Sender: TObject);
begin
  Self.ModalResult := mrOk;
end;

procedure TFrmGeXingChuQin.btnPrintClick(Sender: TObject);
var
   MSExcel, MSExcelWorkBook, MSExcelWorkSheet: Variant;
begin
  //self.acrpdf2.LoadFile(m_StrFilePath);
  //self.acrpdf2.Print;
   MSExcel := CreateOleObject('Excel.Application');
  try
    MSExcel.WorkBooks.Open(m_StrExcelFilePath);
    MSExcel.DisplayAlerts := False;
    MSExcelWorkBook :=MSExcel.Workbooks[1];
    MSExcelWorkSheet := MSExcelWorkBook.WorkSheets.Item[1];
    MSExcelWorkSheet.Activate ;
    MSExcelWorkSheet.PageSetup.PaperSize := 13;
    MSExcelWorkSheet.PageSetup.LeftMargin := 0;
    MSExcelWorkSheet.PageSetup.RightMargin := 0;
    MSExcelWorkSheet.PageSetup.LeftMargin := 0;
    MSExcelWorkSheet.PageSetup.RightMargin := 0;
    MSExcelWorkSheet.PageSetup.TopMargin := 0;
    MSExcelWorkSheet.PageSetup.BottomMargin := 0;
    MSExcelWorkSheet.PageSetup.HeaderMargin := 0;
    MSExcelWorkSheet.PageSetup.FooterMargin := 0;
    MSExcelWorkSheet.PageSetup.CenterHorizontally := 1;
    MSExcelWorkSheet.PageSetup.CenterVertically := 0 ;
    //MSExcelWorkSheet.PrintPreview ;
    MSExcelWorkSheet.PrintOut ;
  finally
    MSExcel.Quit;
  end;
end;

{procedure TFrmGeXingChuQin.btnPrintClick(Sender: TObject);
var
  bmp : TBitmap;
  r : TRect;
  temhi,temwd : integer;
  strect : TRect;
begin
  SetPrintPage;
  bmp := TBitmap.Create;
  try
    GetControlImage(wb1.Handle,bmp);
    printer.BeginDoc;
    r := Rect(0,0,printer.PageWidth,printer.PageHeight);
    printer.canvas.StretchDraw(r,bmp);
    printer.EndDoc;
  finally
    bmp.Free;
  end;
end;  }

procedure TFrmGeXingChuQin.GetControlImage(ControlHandle : THandle;Bmp : TBitmap);
var
  lhDC, lhBmp, lhMemDC: Integer;
  lRect: TRect;
begin
  lhDC := GetWindowDC(ControlHandle);
  if lhDC <> 0 then
  begin
    lhMemDC := CreateCompatibleDC(lhDC);
    if lhMemDC <> 0 then
    begin
      GetWindowRect(ControlHandle, lRect);
      lhBmp := CreateCompatibleBitmap(lhDC, lRect.Right-lRect.Left, lRect.Bottom-lRect.Top);
      if lhBmp <> 0 then
      begin
        SelectObject(lhMemDC, lhBmp);
        if not PrintWindow(ControlHandle, lhMemDC, 0) then
          ShowMessage('���ɹ���'); { ������ʾ���ɹ� }
        Bmp.Handle := lhBmp;
      end;
      DeleteObject(lhMemDC);
    end;
    ReleaseDC(Handle, lhDC);
  end;
end;

procedure TFrmGeXingChuQin.FormCreate(Sender: TObject);
begin
  m_acrpdf := TAcroPDF.Create(self);
  m_acrpdf.Parent := rzpnl2;
  m_acrpdf.Align := alClient;

end;

procedure TFrmGeXingChuQin.FormShow(Sender: TObject);
var
  strPDFURL,strExcelURL:string;
begin
  GetURL(strPDFURL,strExcelURL);
  
  m_strPDfFilePath := GlobalDM.AppPath + '���Գ���.pdf';
  m_strExcelFilePath := GlobalDM.AppPath + '���Գ���.xls';

  if DoDownloadFile(strPDFURL,m_strPDfFilePath) = False then Exit;
  if DoDownloadFile(strExcelURL,m_strExcelFilePath) = False then Exit;
  m_acrpdf.LoadFile(m_strPDfFilePath);
  
end;

function TFrmGeXingChuQin.DoDownloadFile(url:string; ASaveName: string): Boolean;
var
  fs: TFileStream;
  Http:TIdHTTP;
begin
  fs := TFileStream.Create(ASaveName, fmCreate);
  Http:=TIdHTTP.Create(nil);
  try
    try
      Http.Get(url, fs);
    except
      on e: Exception do
      begin
        ShowMessage('���ظ��Ի�����pdf����,:' + e.Message);
      end;
    end;
  finally
    fs.Free;
    Http.Free;
  end;
  Result := True;
end;
procedure TFrmGeXingChuQin.GetURL(var strPDFURL,strExcelURL:string);
var
   //web�ӿڲ���
   webIF:TRsLCGeXingCheQin;
   planInfo: TGeXingChuQinPlanInfo;
begin
  webIF:=TRsLCGeXingCheQin.create(GlobalDM.WebAPIUtils);
  planInfo := TGeXingChuQinPlanInfo.create;
  try
    planInfo.strRemarkTypeName := m_chuqinPlan.TrainPlan.strRemarkTypeName;
    planInfo.strTrainType := m_chuqinPlan.TrainPlan.strTrainTypeName;
    planInfo.strTrainNumber := m_chuqinPlan.TrainPlan.strTrainNumber;
    planInfo.strTrainJiaoLu := m_chuqinPlan.TrainPlan.strTrainJiaoluName;
    planInfo.strTrainNo := m_chuqinPlan.TrainPlan.strTrainNo;

    with m_chuqinPlan.ChuQinGroup.Group do
    begin
      if Trainman1.strTrainmanNumber <> '' then
        planInfo.TmNumbers.Add(Trainman1.strTrainmanNumber);

      if Trainman2.strTrainmanNumber <> '' then
        planInfo.TmNumbers.Add(Trainman2.strTrainmanNumber);

      if Trainman3.strTrainmanNumber <> '' then
        planInfo.TmNumbers.Add(Trainman3.strTrainmanNumber);

      if Trainman4.strTrainmanNumber <> '' then
        planInfo.TmNumbers.Add(Trainman4.strTrainmanNumber);
    end;

    webIF.GetURL(planInfo,strPDFUrl,strExcelUrl);
  finally
    webIF.Free;
    planInfo.Free;
  end;
end;
  
class procedure TFrmGeXingChuQin.ShowGeXingChuQin(chuqinPlan: RRsChuQinPlan);
var
  FrmGeXingChuQin: TFrmGeXingChuQin;
begin
  FrmGeXingChuQin := TFrmGeXingChuQin.Create(nil);
  try
    FrmGeXingChuQin.m_chuqinPlan := chuqinPlan;
    FrmGeXingChuQin.ShowModal();
  finally
    FrmGeXingChuQin.Free;
  end;
end;

end.
