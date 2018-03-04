unit uFrmRestTrainNo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Buttons, ComCtrls, StdCtrls, Mask, RzEdit, ExtCtrls;

type

  //����״̬
  TButtonState = (bsNormal{����},bsAdd{���},bsEdit{�޸�});

  TFrmRestTrainNo = class(TForm)
    Panel1: TPanel;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    edtTrainNo: TEdit;
    edtStartTime: TRzDateTimeEdit;
    radioSingle: TRadioButton;
    radioDouble: TRadioButton;
    CombArea: TComboBox;
    edtSigninTime: TRzDateTimeEdit;
    edtOutDutyTime: TRzDateTimeEdit;
    edtCallTime: TRzDateTimeEdit;
    Panel2: TPanel;
    lvTrainNo: TListView;
    StatusBar1: TStatusBar;
    Panel3: TPanel;
    btnClose: TSpeedButton;
    btnCancel: TSpeedButton;
    btnSave: TSpeedButton;
    btnUpdate: TSpeedButton;
    btnAdd: TSpeedButton;
    btnDelete: TSpeedButton;
    ActionList1: TActionList;
    actClose: TAction;
    procedure btnDeleteClick(Sender: TObject);
    procedure btnAddClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure lvTrainNoChange(Sender: TObject; Item: TListItem;
      Change: TItemChange);
  private
    { Private declarations }
    isFirst : boolean;
    m_BtnState : TButtonState;
    //ˢ���б�
    procedure RefreshTrainNos;
    //ˢ��ѡ�е�����
    procedure RefreshSelectTrainNos;
    //���ô��嵱ǰ�Ĳ���״̬
    procedure SetBtnState(bs : TButtonState);
  end;

var
  FrmRestTrainNo: TFrmRestTrainNo;

implementation
uses
  ADODB,uTrainNoOpt,uGlobalDM,DateUtils;

{$R *.dfm}

procedure TFrmRestTrainNo.actCloseExecute(Sender: TObject);
begin
  btnClose.Click;
end;

procedure TFrmRestTrainNo.btnAddClick(Sender: TObject);
begin
  edtTrainNo.Text := '';
  edtSigninTime.text := '';
  edtCallTime.Text := '';
  edtOutDutyTime.Text := '';
  edtStartTime.Text := '';
  SetBtnState(bsAdd);
end;

procedure TFrmRestTrainNo.btnCancelClick(Sender: TObject);
begin
  SetBtnState(bsNormal);
  RefreshSelectTrainNos;
end;

procedure TFrmRestTrainNo.btnCloseClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TFrmRestTrainNo.btnDeleteClick(Sender: TObject);
var
  traino : string;
begin
  if lvTrainNo.Selected = nil then exit;
  if Application.MessageBox('ȷ��Ҫɾ���˳�����','��ʾ',MB_OKCANCEL)
     = mrCancel then
    exit;
  traino := lvTrainNo.Selected.SubItems[0];
  if TTrainNoOpt.DeleteTrainNo(traino) then
    Application.MessageBox('ɾ���ɹ�.','��ʾ',MB_OK + MB_ICONINFORMATION)
  else
    Application.MessageBox('ɾ��ʧ��.','��ʾ',MB_OK + MB_ICONINFORMATION);
  RefreshTrainNos;
end;

procedure TFrmRestTrainNo.btnSaveClick(Sender: TObject);
var
  trainNo : RTrainNo;
  strTrainNo : string;
  signinTime,callTime,outdutyTime,startTime : TDateTime;
begin
  if edtTrainNo.Text = '' then
  begin
    Application.MessageBox('���β���Ϊ�ա�','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtTrainNo.SetFocus;
    exit;
  end;

  if not TryStrToTime(edtSigninTime.Text,signinTime) then
  begin
    Application.MessageBox('ǿ��ʱ�䲻��Ϊ�ա�','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtSigninTime.SetFocus;
    exit;
  end;
  if not TryStrToTime(edtCallTime.Text,callTime) then
  begin
    Application.MessageBox('�а�ʱ�䲻��Ϊ�ա�','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtCallTime.SetFocus;
    exit;
  end;
  if not TryStrToTime(edtOutDutyTime.Text,outdutyTime) then
  begin
    Application.MessageBox('����ʱ�䲻��Ϊ�ա�','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtOutDutyTime.SetFocus;
    exit;
  end;
  if not TryStrToTime(edtStartTime.Text,startTime) then
  begin
    Application.MessageBox('����ʱ�䲻��Ϊ�ա�','��ʾ',MB_OK+ MB_ICONINFORMATION);
    edtStartTime.SetFocus;
    exit;
  end;

//  if IncMinute(signinTime,Round(DMGlobal.MinRestLength*60)) >  callTime then
//  begin
//    Application.MessageBox('��Ϣʱ��С����Сǿ��ʱ�䡣','��ʾ',MB_OK+ MB_ICONINFORMATION);
//    edtStartTime.SetFocus;
//    exit;
//  end;

  if Application.MessageBox('��ȷ��Ҫ������','��ʾ',MB_OKCANCEL + MB_ICONQUESTION) = mrCancel then
    exit;
  try
    if lvTrainNo.Selected <> nil then
      strTrainNo := lvTrainNo.Selected.SubItems[0];
    case m_BtnState of
      bsAdd:
      begin
        if TTrainNoOpt.IsExistTrainNo(edtTrainNo.Text) then
        begin
          Application.MessageBox('�����Ѿ����ڡ�','��ʾ',MB_OK+ MB_ICONINFORMATION);
          exit;
        end;
        trainNo.strTrainNo := edtTrainNo.Text;
        trainNo.dtSigninTime := StrToDateTime('1900-01-01 ' +  edtSigninTime.Text);
        trainNo.dtCallTime := StrToDateTime('1900-01-01 ' +  edtCallTime.Text);
        trainNo.dtOutDutyTime := StrToDateTime('1900-01-01 ' +  edtOutDutyTime.Text);
        trainNo.dtStartTime := StrToDateTime('1900-01-01 ' +  edtStartTime.Text);
        trainNo.nTrainmanType := 2;
        if radioSingle.Checked then
          trainNo.nTrainmanType := 1;
        trainNo.strAreaGUID := '' ;
        if TTrainNoOpt.AddTrainNo(trainNo) then
          Application.MessageBox('��ӳɹ���','��ʾ',MB_OK+ MB_ICONINFORMATION)
        else
          Application.MessageBox('���ʧ�ܡ�','��ʾ',MB_OK+ MB_ICONINFORMATION);
        RefreshTrainNos;
      end;
      bsEdit:
      begin
        trainNo.strTrainNo := edtTrainNo.Text;
        trainNo.dtSigninTime := StrToDateTime('1900-01-01 ' +  edtSigninTime.Text);
        trainNo.dtCallTime := StrToDateTime('1900-01-01 ' +  edtCallTime.Text);
        trainNo.dtOutDutyTime := StrToDateTime('1900-01-01 ' +  edtOutDutyTime.Text);
        trainNo.dtStartTime := StrToDateTime('1900-01-01 ' +  edtStartTime.Text);
        trainNo.nTrainmanType := 2;
        if radioSingle.Checked then
          trainNo.nTrainmanType := 1;
        trainNo.strAreaGUID := '' ;
        if TTrainNoOpt.UpdateTrainNo(trainNo) then
          Application.MessageBox('�޸ĳɹ���','��ʾ',MB_OK+ MB_ICONINFORMATION)
        else
          Application.MessageBox('�޸�ʧ�ܡ�','��ʾ',MB_OK+ MB_ICONINFORMATION);
        RefreshTrainNos;  
      end;
    end;
  finally
    SetBtnState(bsNormal);
  end;
end;

procedure TFrmRestTrainNo.btnUpdateClick(Sender: TObject);
begin
  SetBtnState(bsEdit);
end;

procedure TFrmRestTrainNo.FormActivate(Sender: TObject);
begin
  if isFirst then exit;
  isFirst := true;
  RefreshTrainNos;
  SetBtnState(bsNormal);
end;

procedure TFrmRestTrainNo.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TFrmRestTrainNo.FormDestroy(Sender: TObject);
begin
  ;
end;

procedure TFrmRestTrainNo.lvTrainNoChange(Sender: TObject; Item: TListItem;
  Change: TItemChange);
begin
  RefreshSelectTrainNos;
end;

procedure TFrmRestTrainNo.RefreshSelectTrainNos;
begin
  edtTrainNo.Text := '';
  edtSigninTime.Text := '';
  edtCallTime.Text := '';
  edtOutDutyTime.Text := '';
  edtStartTime.Text := '';
  if lvTrainNo.Selected = nil  then exit;
  edtTrainNo.Text := lvTrainNo.Selected.SubItems[0];
  edtSigninTime.Time := StrToTime(lvTrainNo.Selected.SubItems[1]);
  edtCallTime.Time := StrToTime(lvTrainNo.Selected.SubItems[2]);
  edtOutDutyTime.Time := StrToTime(lvTrainNo.Selected.SubItems[3]);
  edtStartTime.Time := StrToTime(lvTrainNo.Selected.SubItems[4]);
  radioDouble.Checked := true;
  if lvTrainNo.Selected.SubItems[3] = '��˾��' then
     radioSingle.Checked := true;
  //CombArea.ItemIndex := CombArea.Items.IndexOf(lvTrainNo.Selected.SubItems[6]);
end;

procedure TFrmRestTrainNo.RefreshTrainNos;
var
  ado : TADOQuery;
  i : Integer;
  item : TListItem;
begin
  lvTrainNo.Items.Clear;
  i := 0;
  TTrainNoOpt.GetTrainNos(GlobalDM.LocalArea,ado);
  try
    with ado do
    begin
      First;
      while not eof do
      begin
        i := i + 1;
        item := lvTrainNo.Items.Add;
        item.Caption := Format('%d',[i]);
        item.SubItems.Add(FieldByName('strTrainNo').AsString);
        item.SubItems.Add(FormatDateTime('HH:nn',FieldByName('dtSigninTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('HH:nn',FieldByName('dtCallTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('HH:nn',FieldByName('dtOutDutyTime').AsDateTime));
        item.SubItems.Add(FormatDateTime('HH:nn',FieldByName('dtStartTime').AsDateTime));                
        item.SubItems.Add(FieldByName('strTrainmanTypeName').AsString);
        next;
      end;
    end;
  finally
    ado.Free;
  end;
  StatusBar1.Panels[0].Text := '��'+IntToStr(lvTrainNo.Items.Count)+'��';
end;

procedure TFrmRestTrainNo.SetBtnState(bs: TButtonState);
begin
  if bs = bsEdit then
  begin
    if lvTrainNo.Selected = nil then
    begin
       Application.MessageBox('��ѡ��Ҫ�޸ĵĳ��Ρ�','��ʾ',
        MB_OK+ MB_ICONINFORMATION);
       exit;        
    end;
  end;
  m_BtnState := bs;
  //�༭��
  edtTrainNo.Enabled := false;
  edtTrainNo.Color := clBtnFace;
  edtSigninTime.Enabled :=false;
  edtCallTime.Enabled := false;
  edtOutDutyTime.Enabled := false;
  edtStartTime.Enabled := false;
  //��ť
  btnAdd.Enabled :=false;
  btnUpdate.Enabled := false;
  btnDelete.Enabled := false;
  btnSave.Enabled := false;
  btnCancel.Enabled := false;
  //�б�
  lvTrainNo.Enabled := false;
  case bs of
    bsNormal:
    begin
      btnAdd.Enabled :=true;
      btnUpdate.Enabled := true;
      btnDelete.Enabled := true;
      lvTrainNo.Enabled := true;
      StatusBar1.Panels[1].Text := '��ǰ״̬�����';
    end;
    bsAdd:
    begin
      edtTrainNo.Enabled := true;
      edtTrainNo.Color := clWhite;
      edtSigninTime.Enabled :=true;
      edtCallTime.Enabled := true;
      edtOutDutyTime.Enabled := true;
      edtStartTime.Enabled := true;
      btnSave.Enabled := true;
      btnCancel.Enabled := true;
      StatusBar1.Panels[1].Text := '��ǰ״̬�����';
    end;
    bsEdit:
    begin
      edtSigninTime.Enabled :=true;
      edtCallTime.Enabled := true;
      edtOutDutyTime.Enabled := true;
      edtStartTime.Enabled := true;
      btnSave.Enabled := true;
      btnCancel.Enabled := true;
      StatusBar1.Panels[1].Text := '��ǰ״̬���޸�';
    end;
  end;
end;

end.
