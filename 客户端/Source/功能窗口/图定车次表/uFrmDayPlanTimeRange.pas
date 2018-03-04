unit uFrmDayPlanTimeRange;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, RzPanel, RzCmboBx, ComCtrls, RzDTP,uTFSystem,
  DateUtils;

type
  TFrmDayPlanTimeRange = class(TForm)
    GroupBoxDT: TRzGroupBox;
    btnSave: TButton;
    btnCancel: TButton;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    dtpPlanStartDate: TRzDateTimePicker;
    cmbDayPlanType: TRzComboBox;
    Panel2: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    dtBeginDatePicker: TRzDateTimePicker;
    dtEndDatePicker: TRzDateTimePicker;
    dtBeginTimePicker: TRzDateTimePicker;
    dtEndTimePicker: TRzDateTimePicker;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cmbDayPlanTypeChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    //初始化一些数据
    procedure InitData();
    // 该表日期里面的数据
    procedure ChangeDateTime(AType:Integer);
  public
    { Public declarations }
    class function GetTimeRange(var dtBegin: TDateTime;var dtEnd: TDateTime): Boolean;
  end;

var
  FrmDayPlanTimeRange: TFrmDayPlanTimeRange;

implementation

uses
  uGlobalDM ;

{$R *.dfm}

{ TFrmDayPlanTimeRange }

procedure TFrmDayPlanTimeRange.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrOk ;
end;

procedure TFrmDayPlanTimeRange.ChangeDateTime(AType: Integer);
var
  dt : TDateTime ;
begin
  dt := dtpPlanStartDate.DateTime ;
  case AType of
  0 :
      begin    //白班
        dtBeginDatePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 08:00');
        dtBeginTimePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 08:00');

        dtEndDatePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 17:59');
        dtEndTimePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 17:59');

        GroupBoxDT.Enabled := False ;
      end;
  1 :
      begin    //夜班
        dtBeginDatePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');
        dtBeginTimePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');

        dtEndDatePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 07:59');
        dtEndTimePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 07:59');

        GroupBoxDT.Enabled := False ;
      end;
  2 :           //全天
      begin
        dtBeginDatePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');
        dtBeginTimePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');

        dtEndDatePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 17:59');
        dtEndTimePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 17:59');

        GroupBoxDT.Enabled := False ;
      end;
  else         //其他
      begin
        dtBeginDatePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 00:00');
        dtBeginTimePicker.DateTime := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 00:00');

        dtEndDatePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 17:59');
        dtEndTimePicker.DateTime :=  StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 23:59');

        GroupBoxDT.Enabled := True ;
      end;
  end;
end;

procedure TFrmDayPlanTimeRange.cmbDayPlanTypeChange(Sender: TObject);
begin
  ChangeDateTime(cmbDayPlanType.ItemIndex);
end;

procedure TFrmDayPlanTimeRange.FormCreate(Sender: TObject);
begin
  ;
end;

procedure TFrmDayPlanTimeRange.FormDestroy(Sender: TObject);
begin
  ;
end;

class function TFrmDayPlanTimeRange.GetTimeRange(var dtBegin,
  dtEnd: TDateTime): Boolean;
var
  frm: TFrmDayPlanTimeRange;
begin
  result := false;
  frm := TFrmDayPlanTimeRange.Create(nil);
  try
    frm.InitData ;
    if frm.ShowModal = mrOk then
    begin
      dtBegin := AssembleDateTime(frm.dtBeginDatePicker.DateTime,frm.dtBeginTimePicker.DateTime);
      dtEnd := AssembleDateTime(frm.dtEndDatePicker.DateTime,frm.dtEndTimePicker.DateTime);
      result := true;
    end;
  finally
    frm.Free;
  end;
end;

procedure TFrmDayPlanTimeRange.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel ;
end;

procedure TFrmDayPlanTimeRange.InitData();
const
  DAY_NIGHT_START = 18 ;  //夜班开始时间
  DAY_NIGHT_END = 8 ;      //夜班截止时间
var
  dt, dtBegin,dtEnd: TDateTime ;
  nHour : Word ;
begin
  dt := DateOf(GlobalDM.GetNow);
  nHour := HourOf(GlobalDM.GetNow) ;
  dtpPlanStartDate.DateTime := GlobalDM.GetNow ;
  if ( nHour >= DAY_NIGHT_END )  and ( nHour < DAY_NIGHT_START  ) then
  begin
    dtBegin := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 18:00');
    dtEnd := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt + 1) + ' 07:59');
    cmbDayPlanType.ItemIndex := 1 ;
  end
  else
  begin
    dtBegin := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 08:00');
    dtEnd := StrToDateTime(FormatDateTime('yyyy-MM-dd', dt) + ' 17:59');
    cmbDayPlanType.ItemIndex := 0 ;
  end;

  
  dtBeginDatePicker.DateTime := dtBegin;
  dtBeginTimePicker.DateTime := dtBegin;

  dtEndDatePicker.DateTime := dtEnd;
  dtEndTimePicker.DateTime := dtEnd;

  ChangeDateTime(cmbDayPlanType.ItemIndex);
end;

end.
