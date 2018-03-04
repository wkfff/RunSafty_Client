unit uFrmKeyTrainmanView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzDTP, utfLookupEdit,uLCKeyMan,
  uTrainman,uTFSystem,uLCTrainmanMgr,uGlobalDM,utfPopTypes,
  uLCTeamGuide,uGuideSign, RzCmboBx,uLCBaseDict,uWorkShop, ExtCtrls;

type

  TFrmKeyTrainmanView = class(TForm)
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    btnCancel: TButton;
    dtpStart: TRzDateTimePicker;
    lbl6: TLabel;
    lbl7: TLabel;
    dtpEnd: TRzDateTimePicker;
    mmoReason: TMemo;
    lbl8: TLabel;
    mmoAnnouncements: TMemo;
    lbl9: TLabel;
    lbl10: TLabel;
    edtKeyTrainman: TEdit;
    edtCheDui: TEdit;
    lblClient: TLabel;
    lblWorkShop: TLabel;
    lblRegisterTime: TLabel;
    lblRegister: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    //原纪录
    m_S_KeyMan:TKeyTrainman;
    //人员列表
    m_KeymanList:TKeyTrainmanList;
    //人员管理IF
    m_RsLCTrainmanMgr: TRsLCTrainmanMgr;
    //关键人Db
    m_LCKeyMan: TRsLCKeyMan;
    //人员工号
    m_strTrainmanNumber:string;
  private
    //显示原数据
    procedure ShowSData();

  public
    //查看关键人
    class function View(strTrainmanNumber:string):Boolean;
  end;

implementation

{$R *.dfm}

{ TFrmKeyTrainmanEdit }

procedure TFrmKeyTrainmanView.btnCancelClick(Sender: TObject);
begin
  self.ModalResult := mrOk;
end;

procedure TFrmKeyTrainmanView.FormCreate(Sender: TObject);
begin
  m_S_KeyMan := TKeyTrainman.Create;
  m_RsLCTrainmanMgr := TRsLCTrainmanMgr.Create(GlobalDM.WebAPIUtils);
  m_LCKeyMan := TRsLCKeyMan.Create(GlobalDM.WebAPIUtils);
  m_KeymanList:=TKeyTrainmanList.Create;
end;

procedure TFrmKeyTrainmanView.FormDestroy(Sender: TObject);
begin
  m_S_KeyMan.Free;
  m_RsLCTrainmanMgr.Free;
  m_LCKeyMan.Free;
  m_KeymanList.Free;
end;

procedure TFrmKeyTrainmanView.FormShow(Sender: TObject);
var
  cdt:TKeyTM_QC;
begin
  cdt := TKeyTM_QC.Create;
  try
    cdt.KeyTMNumber := m_strTrainmanNumber;
    m_LCKeyMan.Get(cdt,m_KeymanList);
    if m_KeymanList.Count > 0 then
      self.m_S_KeyMan.clone(m_KeymanList.Items[0]);
    ShowSData;
  finally
    cdt.Free;
  end;

end;

procedure TFrmKeyTrainmanView.ShowSData;
begin
  with m_S_KeyMan do
  begin
    edtKeyTrainman.Text := Format('%s[%s]',[KeyTMName,KeyTMNumber]);
    lblClient.Caption := format('%s[%s]',[ClientName,ClientNumber] );
    lblRegister.Caption := Format('%s[%s]',[RegisterName,RegisterNumber]);

    lblRegisterTime.Caption := FormatDateTime('yyyy-mm-dd hh:nn',RegisterTime);

    dtpStart.DateTime := KeyStartTime;
    dtpEnd.DateTime := KeyEndTime;
    mmoReason.Text := KeyReason;
    mmoAnnouncements.Text := KeyAnnouncements;
    lblWorkShop.Caption := KeyTMWorkShopName;
    edtCheDui.Text := KeyTMCheDuiName;
  end;
end;

class function TFrmKeyTrainmanView.View(strTrainmanNumber:string): Boolean;
var
  Frm: TFrmKeyTrainmanView;
begin
  result := False;
  Frm:= TFrmKeyTrainmanView.create(nil);
  try
    Frm.m_strTrainmanNumber := strTrainmanNumber;
    if Frm.ShowModal = mrOk then
      result := true;
  finally
    Frm.free;
  end;

end;


end.
