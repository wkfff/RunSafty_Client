unit uFrmAskLeave;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, AdvCombo, RzCmboBx, Mask, RzEdit, ComCtrls, RzDTP, RzLabel,
  RzButton, uDBTrainmanJiaolu, uAskForLeave;

type
  TFrmAskLeave = class(TForm)
    cbbType: TRzComboBox;
    lbl1: TRzLabel;
    lbl2: TRzLabel;
    rzLeaveDate: TRzDateTimePicker;
    rzLeaveTime: TRzDateTimePicker;
    lbl3: TRzLabel;
    edtDay: TRzEdit;
    edtReason: TRzRichEdit;
    lbl4: TRzLabel;
    rzbtbtnOk: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
    procedure FormShow(Sender: TObject);
    procedure edtDayChange(Sender: TObject);
    procedure rzbtbtnOkClick(Sender: TObject);
  private
    /// <summary>请假信息</summary>
    m_LeaveInfo:RAskForLeave;
    /// <summary>请假类型</summary>
    m_LeaveTypeArray : TLeaveTypeArray;
  private
    procedure InitLeaveTypeCtrl;
  published
    property LeaveInfo:RAskForLeave read m_LeaveInfo;
  end;
  
implementation
uses
  uDBLeaveType,uGlobalDM;

{$R *.dfm}

{ TFrmAskLeave }

procedure TFrmAskLeave.edtDayChange(Sender: TObject);
begin
  try
    StrToInt(edtDay.Text);
  except
    raise Exception.Create('天数不能为数值型');
  end;
end;

procedure TFrmAskLeave.FormShow(Sender: TObject);
begin
  InitLeaveTypeCtrl;
  rzLeaveDate.DateTime := Now;
  rzLeaveTime.DateTime := Now;
end;

procedure TFrmAskLeave.InitLeaveTypeCtrl;
var
  dbLeave:TDBLeaveType;
  I:Integer;
begin
  dbLeave := TDBLeaveType.Create;
  cbbType.Items.BeginUpdate;
  try
    cbbType.Items.Clear;
    
    dbLeave.GetAllLeaveType(GlobalDM.ADOConnection,m_LeaveTypeArray);
    for I := 0 to Length(m_LeaveTypeArray) - 1 do
    begin
      cbbType.AddItemValue(m_LeaveTypeArray[I].strLeaveTypeName,
        IntToStr(m_LeaveTypeArray[I].nLeaveTypeID));
    end;
    if Length(m_LeaveTypeArray) > 0 then
      cbbType.ItemIndex := 0;
  finally
    FreeAndNil(dbLeave);
    cbbType.Items.EndUpdate;
  end;
end;

procedure TFrmAskLeave.rzbtbtnOkClick(Sender: TObject);
begin
  if StrToIntDef(Trim(edtDay.Text),0) <= 0 then
  begin
    edtDay.SetFocus;
    MessageBox(Handle,'请假时长必须大于零','提示',MB_ICONINFORMATION);
    ModalResult := mrNone;
    Exit;
  end;
  if cbbtype.ItemIndex >= 0 then
    m_LeaveInfo.LeaveType := m_LeaveTypeArray[cbbType.ItemIndex];
  m_LeaveInfo.dtLeaveTime := rzLeaveDate.Date + rzLeaveTime.Time;
  m_LeaveInfo.nLeaveLength := StrToIntDef(Trim(edtDay.Text),1);
  m_LeaveInfo.strLeaveReason := Trim(edtReason.Text); 
end;

end.
