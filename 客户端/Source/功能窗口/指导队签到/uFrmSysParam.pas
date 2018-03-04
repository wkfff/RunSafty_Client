unit uFrmSysParam;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, RzRadChk, StdCtrls, Mask, RzEdit, RzCmboBx,
  IniFiles, uGlobalDM, uTFSystem, uSaftyEnum,
  uGuideSign,  ExtCtrls,uLCTeamGuide;

type
  TFrmSysParam = class(TForm)
    Label10: TLabel;
    cmbWorkShop: TRzComboBox;
    Label11: TLabel;
    cmbGuideGroup: TRzComboBox;
    edtSignSpanMinutes: TRzNumericEdit;
    Label14: TLabel;
    chkAutoFillGroupGUID: TRzCheckBox;
    btnSaveParam: TButton;
    btnClose: TButton;
    Label1: TLabel;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnSaveParamClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure cmbWorkShopChange(Sender: TObject);
  private
    { Private declarations } 
    //数据库操作类对象
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //INI文件-指导队GUID
    m_strGuideGroupGUID : string;
    //INI文件-当司机表中指导队为空时，第一次签到时自动填写标志：1填写 0不考虑
    m_nAutoFillGroupGUID : integer;
    //INI文件-签退与签到时间差（分钟）
    m_nSignSpanMinutes : integer;

    procedure ReadConfig();
    procedure WriteConfig();
  public
    { Public declarations }
    class function ShowForm: TModalResult;
  end;

implementation

{$R *.dfm}

{ TFrmSysParam }
          
class function TFrmSysParam.ShowForm: TModalResult;
var
  FrmSysParam: TFrmSysParam;
begin
  FrmSysParam := TFrmSysParam.Create(nil);
  result := FrmSysParam.ShowModal;
  FrmSysParam.Free;
end;

procedure TFrmSysParam.FormCreate(Sender: TObject);
begin
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
  ReadConfig;
end;

procedure TFrmSysParam.FormDestroy(Sender: TObject);
begin
  m_RsLCGuideGroup.Free;
end;

procedure TFrmSysParam.FormShow(Sender: TObject);  
var
  i, nItemIndex: integer;
  strWorkShopGUID: string;
  SimpleInfoArray: TRsSimpleInfoArray;
begin
  chkAutoFillGroupGUID.Checked :=  (m_nAutoFillGroupGUID = 1);
  edtSignSpanMinutes.Text := IntToStr(m_nSignSpanMinutes);

  strWorkShopGUID :=  m_RsLCGuideGroup.GetOwnerWorkShopID(m_strGuideGroupGUID);
//  strWorkShopGUID := m_dbGuideSign.GetWorkShopGUID(m_strGuideGroupGUID);
  nItemIndex := 0;

  cmbWorkShop.Items.Clear;
  cmbWorkShop.Values.Clear;
  m_RsLCGuideGroup.GetWorkShopArray(SimpleInfoArray);
//  m_dbGuideSign.GetWorkShop(SimpleInfoArray);
  for i := 0 to length(SimpleInfoArray) - 1 do
  begin
    cmbWorkShop.AddItemValue(SimpleInfoArray[i].strName,SimpleInfoArray[i].strGUID);
    if strWorkShopGUID = SimpleInfoArray[i].strGUID then nItemIndex := i;
  end;
  if cmbWorkShop.Count > 0 then
  begin
    cmbWorkShop.ItemIndex := nItemIndex;
    cmbWorkShopChange(nil);
  end;
end;
          
procedure TFrmSysParam.cmbWorkShopChange(Sender: TObject);
var
  i, nItemIndex: integer;
  strWorkShowGUID: string;
  SimpleInfoArray: TRsSimpleInfoArray;
begin
  strWorkShowGUID := cmbWorkShop.Values[cmbWorkShop.ItemIndex];
  nItemIndex := 0;

  cmbGuideGroup.Items.Clear;
  cmbGuideGroup.Values.Clear;
  m_RsLCGuideGroup.GetGroupArray(strWorkShowGUID, SimpleInfoArray);
//  m_dbGuideSign.GetGuideGroup(strWorkShowGUID, SimpleInfoArray);
  for i := 0 to length(SimpleInfoArray) - 1 do
  begin
    cmbGuideGroup.AddItemValue(SimpleInfoArray[i].strName,SimpleInfoArray[i].strGUID);
    if m_strGuideGroupGUID = SimpleInfoArray[i].strGUID then nItemIndex := i;
  end;
  if cmbGuideGroup.Count > 0 then cmbGuideGroup.ItemIndex := nItemIndex;
end;

procedure TFrmSysParam.btnSaveParamClick(Sender: TObject);
begin
  m_strGuideGroupGUID := cmbGuideGroup.Values[cmbGuideGroup.ItemIndex];
  if chkAutoFillGroupGUID.Checked then m_nAutoFillGroupGUID := 1
  else m_nAutoFillGroupGUID := 0;
  m_nSignSpanMinutes := StrToInt(edtSignSpanMinutes.Text);

  WriteConfig;     
  self.ModalResult := mrOk;
  //Close;
end;

procedure TFrmSysParam.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TFrmSysParam.ReadConfig();
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    m_strGuideGroupGUID := Ini.ReadString('SysConfig', 'GuideGroupGUID', '');
    m_nAutoFillGroupGUID := Ini.ReadInteger('SysConfig', 'AutoFillGroupGUID', 1);
    m_nSignSpanMinutes := Ini.ReadInteger('SysConfig', 'SignSpanMinutes', 20);
    if m_nSignSpanMinutes <= 0 then m_nSignSpanMinutes := 20;
  finally
    Ini.Free();
  end;
end;

procedure TFrmSysParam.WriteConfig();
var
  Ini:TIniFile;
begin
  Ini := TIniFile.Create(ExtractFilePath(Application.ExeName) + 'Config.ini');
  try
    Ini.WriteString('SysConfig', 'GuideGroupGUID', m_strGuideGroupGUID);
    Ini.WriteInteger('SysConfig', 'AutoFillGroupGUID', m_nAutoFillGroupGUID);
    Ini.WriteInteger('SysConfig', 'SignSpanMinutes', m_nSignSpanMinutes);
  finally
    Ini.Free();
  end;
end;

end.
