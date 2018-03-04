unit uFrmSetWork;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, cxGraphics, ExtCtrls, DB, ADODB, cxControls, cxContainer, cxEdit,
  cxTextEdit, cxMaskEdit, cxDropDownEdit, cxLookupEdit, cxDBLookupEdit,
  cxDBLookupComboBox, RzButton, StdCtrls, uTrainman, uDBTrainmanJiaolu;

type
  TFrmSetWork = class(TForm)
    lbl1: TLabel;
    lblHint: TLabel;
    btnOk: TRzBitBtn;
    btnCancel: TRzBitBtn;
    cxLookupComboBox1: TcxLookupComboBox;
    DataSource1: TDataSource;
    ADOQuery1: TADOQuery;
    Timer1: TTimer;
    btnFindUser1: TRzButton;
    procedure Timer1Timer(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFindUser1Click(Sender: TObject);
    procedure cxLookupComboBox1FocusChanged(Sender: TObject);
  public                
    UserInfo: RTrainman;
  private
    m_strTrainmanJiaoluGUID:string;
    m_DBOpt:TDBTrainmanJiaolu;
  private              
    procedure FillTrain(var Trainman: RTrainman; Value: variant);                                     
    procedure InitTrainmanLookup(loolup: TcxLookupComboBox);
    procedure EnableCtrls; 
    procedure DisableCtrls;
  published
    property TrainmanJiaoluGUID:string read m_strTrainmanJiaoluGUID write m_strTrainmanJiaoluGUID;
  end;

implementation
uses
  uGlobalDM, cxLookupDBGrid, uFrmTrainmanManage;

{$R *.dfm}

procedure TFrmSetWork.btnFindUser1Click(Sender: TObject);
var
  frmQry:TfrmTrainmanManage;
begin
  try
    frmQry := TfrmTrainmanManage.Create(nil);
    frmQry.bIsQueryForm := True;
    frmQry.ShowModal;
    if Trim(frmQry.SelectTrainMan.strTrainmanGUID) = '' then
      Exit;
    cxLookupComboBox1.Text := frmQry.SelectTrainMan.strTrainmanNumber;
    UserInfo := frmQry.SelectTrainMan;
  finally
    FreeAndNil(frmQry);
  end;
end;

procedure TFrmSetWork.btnOkClick(Sender: TObject);
begin
  if UserInfo.strTrainmanGUID = '' then  
    FillTrain(UserInfo, cxLookupComboBox1.EditValue);
  if UserInfo.strTrainmanGUID = '' then
  begin
    cxLookupComboBox1.SetFocus;
    Application.MessageBox(PChar('请选择人员'),'提示',MB_OK+MB_ICONINFORMATION);
    Exit;
  end;
  ModalResult := mrOk;
end;

procedure TFrmSetWork.cxLookupComboBox1FocusChanged(Sender: TObject);
begin
  UserInfo.strTrainmanGUID := '';
end;

procedure TFrmSetWork.DisableCtrls;
begin
  cxLookupComboBox1.Enabled := false;
  lblHint.Visible := true;
  btnOk.Enabled := false;
  btnCancel.Enabled := false;
end;

procedure TFrmSetWork.EnableCtrls;
begin
  cxLookupComboBox1.Enabled := true;
  lblHint.Visible := false;
  btnOk.Enabled := true;
  btnCancel.Enabled := true;
end;

procedure TFrmSetWork.FillTrain(var Trainman: RTrainman; Value: variant);
begin
  if VarIsNull(Value) then exit;

  if not VarIsNull(Value[0]) then
    Trainman.strTrainmanGUID := Value[0];
  if not VarIsNull(Value[1]) then
    Trainman.strTrainmanName := Value[1];
  if not VarIsNull(Value[2]) then
    Trainman.strTrainmanNumber := Value[2];
end;

procedure TFrmSetWork.FormCreate(Sender: TObject);
begin
  m_DBOpt := TDBTrainmanJiaolu.Create(GlobalDM.ADOConnection);
end;

procedure TFrmSetWork.FormDestroy(Sender: TObject);
begin
  FreeAndNil(m_DBOpt);
end;

procedure TFrmSetWork.FormShow(Sender: TObject);
begin
  DisableCtrls;
  Timer1.Enabled := TRUE;
end;

procedure TFrmSetWork.InitTrainmanLookup(loolup: TcxLookupComboBox);
var
  col: TcxLookupDBGridColumn;
begin
  with loolup do
  begin
    Properties.KeyFieldNames := 'strTrainmanGUID;strTrainmanName;strTrainmanNumber;strStationName';
    Properties.DropDownAutoSize := true;
    Properties.IncrementalFiltering := false;
    Properties.DropDownListStyle := lsEditList;

    col := Properties.ListColumns.Add;
    col.FieldName := 'strTrainmanNumber';
    col.Caption := '工号';
    col.Width := 80;

    col := Properties.ListColumns.Add;
    col.FieldName := 'strTrainmanName';
    col.Caption := '姓名';
    col.Width := 80;

    col := Properties.ListColumns.Add;
    col.FieldName := 'strStationName';
    col.Caption := '车站';
    col.Width := 80;
    Properties.ListFieldIndex := 1;
  end;
end;

procedure TFrmSetWork.Timer1Timer(Sender: TObject);
begin
  Timer1.Enabled := false;
  try
    m_DBOpt.GetOtherStationGroups(GlobalDM.ADOConnection,
      m_strTrainmanJiaoluGUID, '', ADOQuery1);
    cxLookupComboBox1.Properties.ListSource := DataSource1;
    InitTrainmanLookup(cxLookupComboBox1);
    EnableCtrls;
  except on e: exception do
    begin
      lblHint.Caption := '获取数据失败，请关闭后重试！';
      Application.MessageBox(PChar('获取数据失败:'+e.Message),'提示',MB_OK+MB_ICONINFORMATION);
      btnOk.Enabled := false;
    end;
  end;
end;

end.
