unit ufrmRsXyOprLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, RzListVw, PngSpeedButton, RzDTP,
  StdCtrls, ExtCtrls, Buttons, PngCustomButton, DB, ADODB,
  uXYRelation, ActnList,uLCXYRelation;

type
  TfrmXYLog = class(TForm)
    StatusBar1: TStatusBar;
    pnlTools: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    dtBeginPicker: TRzDateTimePicker;
    dtEndPicker: TRzDateTimePicker;
    btnQuery: TPngSpeedButton;
    lstViewLog: TRzListView;
    ActionList1: TActionList;
    actEsc: TAction;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnQueryClick(Sender: TObject);
    procedure actEscExecute(Sender: TObject);
    procedure lstViewLogCustomDrawSubItem(Sender: TCustomListView;
      Item: TListItem; SubItem: Integer; State: TCustomDrawState;
      var DefaultDraw: Boolean);
    procedure lstViewLogCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
  private
    { Private declarations }
    m_RsLCXYRelation: TRsLCXYRelation;
    m_LogArray: TRsXyOperateLogArray;

    function FormatPersonName(Name,Number: string): string;
  public
    { Public declarations }
  end;

procedure XYLogQuery();
implementation

uses uGlobalDM;
procedure XYLogQuery();
var
  frmXYLog: TfrmXYLog;
begin
  frmXYLog := TfrmXYLog.Create(nil);
  try
    frmXYLog.ShowModal;
  finally
    frmXYLog.Free;
  end;
end;
{$R *.dfm}

procedure TfrmXYLog.actEscExecute(Sender: TObject);
begin
  Close;  
end;

procedure TfrmXYLog.btnQueryClick(Sender: TObject);
var
  Item: TListItem;
  I: Integer;
begin
  m_RsLCXYRelation.GetLogs(dtBeginPicker.DateTime,dtEndPicker.DateTime,m_LogArray);


  lstViewLog.Items.Clear;

  for I := 0 to Length(m_LogArray) - 1 do
  begin
    Item := lstViewLog.Items.Add;
    Item.Caption := IntToStr(i + 1);
    Item.Data := @m_LogArray[i];
    Item.SubItems.Add(TRsXyOperateTypeName[m_LogArray[i].RelationOP]);

    case m_LogArray[i].RelationOP of
      xotAddTeacher,xotDelTeacher: Item.SubItems.Add(
        FormatPersonName(m_LogArray[i].strTeacherName,m_LogArray[i].strTeacherNumber));
      xotAddStudent,xotDelStudent: Item.SubItems.Add(
        FormatPersonName(m_LogArray[i].strStudentName,m_LogArray[i].strStudentNumber));
    end;

    Item.SubItems.Add(FormatPersonName(m_LogArray[i].strDutyUserName,m_LogArray[i].strDutyUserNumber));

    Item.SubItems.Add(FormatDateTime('yy-mm-dd hh:nn:ss',m_LogArray[i].dtCreateTime));
  end;

end;

function TfrmXYLog.FormatPersonName(Name, Number: string): string;
begin
  Result := Format('%6s[%s]',[Name,Number]);
end;

procedure TfrmXYLog.FormCreate(Sender: TObject);
begin
  m_RsLCXYRelation := TRsLCXYRelation.Create(GlobalDM.WebAPIUtils);
  dtBeginPicker.Date := Now;
  dtEndPicker.Date := Now;
end;

procedure TfrmXYLog.FormDestroy(Sender: TObject);
begin
  m_RsLCXYRelation.Free;
end;

procedure TfrmXYLog.lstViewLogCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;

end;

procedure TfrmXYLog.lstViewLogCustomDrawSubItem(Sender: TCustomListView;
  Item: TListItem; SubItem: Integer; State: TCustomDrawState;
  var DefaultDraw: Boolean);
begin
  Sender.Canvas.Font.Color := clBlack;
  
  if SubItem = 1 then
  begin
    case PRsXyOperateLog(Item.Data).RelationOP of
      xotAddTeacher,xotAddStudent: Sender.Canvas.Font.Color := $00BD5633;
      xotDelTeacher,xotDelStudent: Sender.Canvas.Font.Color := $00797779;
    end;

  end;

  if Item.Index mod 2 > 0 then
  begin
    Sender.Canvas.Brush.Color := $00E4E2B8;
  end
  else
    Sender.Canvas.Brush.Color := clWindow;
end;

end.
