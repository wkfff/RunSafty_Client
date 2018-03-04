unit uFrmLocalArea;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, ActnList,ADODB;

type
  TfrmLocalArea = class(TForm)
    Label1: TLabel;
    CombArea: TComboBox;
    btnSave: TSpeedButton;
    btnClose: TSpeedButton;
    Label2: TLabel;
    ActionList1: TActionList;
    actEnter: TAction;
    actEsc: TAction;
    procedure actEnterExecute(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
    m_AreaGUIDs : TStrings;
    m_bIsFirst : boolean;
  public
    { Public declarations }
  end;

var
  frmLocalArea: TfrmLocalArea;

implementation

uses
  uOrg,uDataModule;
{$R *.dfm}

procedure TfrmLocalArea.actEnterExecute(Sender: TObject);
begin
  btnSave.Click;
end;

procedure TfrmLocalArea.actEscExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TfrmLocalArea.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmLocalArea.btnSaveClick(Sender: TObject);
begin
  if CombArea.ItemIndex <= 0 then
  begin
    Application.MessageBox('请选择当前工作区域','提示',mb_ok);
    exit;
  end;
  if Application.MessageBox('您确定要保存当前工作区域吗？','提示',MB_OKCANCEL) = mrCancel then exit;
  DMGlobal.LocalArea := m_AreaGUIDs[CombArea.ItemIndex];
  DMGlobal.SaveConfig;
  ModalResult := mrOk;  
end;

procedure TfrmLocalArea.FormActivate(Sender: TObject);
var
  ado : TADOQuery;
begin
  if not m_bIsFirst then  exit;
  m_bIsFirst := true;
  CombArea.Items.Add('请设置');
  m_AreaGUIDs.Add('');
  TAreaOpt.GetAreas(ado);
  try
    with ado do
    begin
      while not eof  do
      begin
        CombArea.Items.Add(FieldByName('strAreaName').AsString);
        m_AreaGUIDs.Add(FieldByName('strGUID').AsString);
        next;
      end;
    end;
    CombArea.ItemIndex := m_AreaGUIDs.IndexOf(DMGlobal.LocalArea);
    if CombArea.ItemIndex < 0 then
      CombArea.ItemIndex := 0;
  finally
    ado.Free;
  end;
end;

procedure TfrmLocalArea.FormCreate(Sender: TObject);
begin
  m_bIsFirst := true;
  m_AreaGUIDs := TStringList.Create;
end;

procedure TfrmLocalArea.FormDestroy(Sender: TObject);
begin
  m_AreaGUIDs.Free;
end;

end.

