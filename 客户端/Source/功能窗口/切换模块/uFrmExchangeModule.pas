unit uFrmExchangeModule;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, PngCustomButton, StdCtrls, ExtCtrls, RzPanel, PngSpeedButton,
  uSite, ComCtrls, ImgList, PngImageList,uTFSystem,uLCBaseDict;

type
  TModuleButtonState = (mbsDisabled{不可用},mbsUnChecked{未选中},mbsChecked{选中});
  TfrmExchangeModule = class(TForm)
    RzPanel1: TRzPanel;
    btnOK: TButton;
    btnCancel: TButton;
    Panel1: TPanel;
    RzPanel2: TRzPanel;
    Label3: TLabel;
    PngImageList1: TPngImageList;
    btnJiHua: TPngSpeedButton;
    btnPaiBan: TPngSpeedButton;
    btnHouBan: TPngSpeedButton;
    btnChuQin: TPngSpeedButton;
    btnTuiQin: TPngSpeedButton;
    btnWaiQin: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure btnJiHuaClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
  private
    { Private declarations }
    m_SiteJob : TRsSiteJob;
    //设置按钮的状态
    procedure SetBtnState(Btn : TPNGSpeedButton;BtnState : TModuleButtonState);
    //初始化所有模块的显示
    procedure InitModules;
    //初始化一个模块的显示
    procedure InitModule(Btn : TpngSpeedButton;ModuleName : string;
      JobLimit:RRsJobLimit;Disabled : boolean);
  public
    { Public declarations }
    //选择模块，并返回是否选择成功，选择的结果放在GlobalDM中
    class function SelectModule(out SiteJob : TRsSiteJob) : boolean;
  end;

implementation
uses
  uGlobalDM;
{$R *.dfm}

{ TfrmExchangeModule }

procedure TfrmExchangeModule.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmExchangeModule.btnJiHuaClick(Sender: TObject);
begin
  if Sender = btnJiHua then
  begin
    if m_SiteJob <>sjDiaodu then
    begin
      m_SiteJob := sjDiaodu;
      InitModules;
    end;
  end;

  if Sender = btnPaiBan then
  begin
    if m_SiteJob <>sjPaiBan then
    begin
      m_SiteJob := sjPaiBan;
      InitModules;
    end;
  end;

  if Sender = btnHouBan then
  begin
    if m_SiteJob <>sjHouBan then
    begin
      m_SiteJob := sjHouBan;
      InitModules;
    end;
  end;

  if Sender = btnChuQin then
  begin
    if m_SiteJob <>sjChuQin then
    begin
      m_SiteJob := sjChuQin;
      InitModules;
    end;
  end;

  if Sender = btnTuiQin then
  begin
    if m_SiteJob <>sjTuiQin then
    begin
      m_SiteJob := sjTuiQin;
      InitModules;
    end;
  end;
end;

procedure TfrmExchangeModule.btnOKClick(Sender: TObject);
var
  SiteNumber : string ;
begin
  ModalResult := mrCancel;
  if GlobalDM.CurrentModule <> m_SiteJob then
  begin

    if  RsLCBaseDict.LCSite.GetSiteByRelationIP( GlobalDM.SiteNumberMem ,SiteNumber,Ord(m_SiteJob),GlobalDM.SiteInfo) then
    begin
      GlobalDM.SiteNumberMem := SiteNumber ;
    end ;
    ModalResult := mrOk;
  end;
end;

procedure TfrmExchangeModule.FormCreate(Sender: TObject);
begin
  m_SiteJob := GlobalDM.CurrentModule;
  panel1.DoubleBuffered := true;
end;

procedure TfrmExchangeModule.InitModule(Btn: TpngSpeedButton;
  ModuleName: string;JobLimit:RRsJobLimit;Disabled : boolean);
begin
  Btn.Enabled := false;
  Btn.Caption := ModuleName + '【无权】';
  SetBtnState(btn,mbsDisabled);
  if Disabled then exit;
  Btn.Enabled := true;
  if JobLimit.Limimt = jlBrowser then
    btn.Caption := ModuleName + '【浏览】'
  else
    btn.Caption := ModuleName + '【操作】';
    
  if JobLimit.Job = m_SiteJob then
  begin
    SetBtnState(Btn,mbsChecked);
  end else begin
    SetBtnState(Btn,mbsUnChecked);
  end;
end;

procedure TfrmExchangeModule.InitModules;
var
  i: Integer;
  jlimit : RRsJobLimit;
begin
  LockWindowUpdate(panel1.Handle);
  InitModule(btnJiHua,'计划调度台',jlimit,true);
  InitModule(btnPaiBan,'派班调度台',jlimit,true);
  InitModule(btnHouBan,'公寓侯班室',jlimit,true);  
  InitModule(btnChuQin,'出勤点',jlimit,true);
  InitModule(btnTuiQin,'退勤点',jlimit,true);
  InitModule(btnWaiQin,'外勤点',jlimit,true);
  for i := 0 to length(GlobalDM.SiteInfo.JobLimits) - 1 do
  begin
    jlimit := GlobalDM.SiteInfo.JobLimits[i];
    case jlimit.Job of
      sjDiaodu : begin
         InitModule(btnJiHua,'计划调度台',jlimit,false);
      end;
      sjPaiBan : begin
        InitModule(btnPaiBan,'派班调度台',jlimit,false);
      end;
      sjChuQin : begin
        InitModule(btnChuQin,'出勤点',jlimit,false);
      end;
      sjTuiQin : begin
         InitModule(btnTuiQin,'退勤点',jlimit,false);
      end;
      sjHouBan : begin
         InitModule(btnHouBan,'公寓侯班室',jlimit,false);
      end;
      sjWaiQin : begin
        InitModule(btnWaiQin,'外勤点',jlimit,false);
      end;
    end;
  end;
  LockWindowUpdate(0);
end;

class function TfrmExchangeModule.SelectModule(out SiteJob : TRsSiteJob): boolean;
var
  frmExchangeModule : TfrmExchangeModule;
begin
  result := false;
  frmExchangeModule := TfrmExchangeModule.Create(nil);
  try
    frmExchangeModule.InitModules;
    if frmExchangeModule.ShowModal = mrCancel then exit;
    SiteJob := frmExchangeModule.m_SiteJob;
    result := true;
  finally
    frmExchangeModule.Free;
  end;
end;

procedure TfrmExchangeModule.SetBtnState(Btn : TPNGSpeedButton;BtnState: TModuleButtonState);
begin
  case btnState of
    mbsDisabled: btn.PngImage := PngImageList1.PngImages.Items[0].PngImage;
    mbsUnChecked: Btn.PngImage := PngImageList1.PngImages[0].PngImage;
    mbsChecked: Btn.PngImage := PngImageList1.PngImages[1].PngImage;
  end;
end;

end.
