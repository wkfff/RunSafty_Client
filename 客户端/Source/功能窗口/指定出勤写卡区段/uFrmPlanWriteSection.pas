unit uFrmPlanWriteSection;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst,uWriteCardSection,uTFSystem,
  uLCWriteCardSectionV2;

type
  TfrmPlanWriteSection = class(TForm)
    checklstWriteSection: TCheckListBox;
    Button1: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
    m_strTrainPlanGUID : string;
    m_AllSectionArray : TRsWriteCardSectionArray;
    m_SelectedSectionArray : TRsWriteCardSectionArray;
    m_RltSectionArray : TRsWriteCardSectionArray;
    m_RsLCWriteCardSectionV2: TRsLCWriteCardSectionV2;
    procedure Init;
  public
    { Public declarations }
    //打开窗口
    class procedure Open(TrainPlanGUID : string);
  end;



implementation
uses
  uGlobalDM;

  
{$R *.dfm}

{ TfrmPlanWriteSection }

procedure TfrmPlanWriteSection.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmPlanWriteSection.Button1Click(Sender: TObject);
var
  i: Integer;
begin
  if not TBox('您确定要指定此计划的写卡区段吗？') then exit;
  
  SetLength(m_RltSectionArray,0);
  for i := 0 to checklstWriteSection.Items.Count - 1 do
  begin
    if checklstWriteSection.Checked[i] then
    begin
      SetLength(m_RltSectionArray,length(m_RltSectionArray) + 1);
      m_RltSectionArray[length(m_RltSectionArray) - 1] := m_AllSectionArray[i];
    end;
  end;

  m_RsLCWriteCardSectionV2.SetPlanSections(m_strTrainPlanGUID,m_RltSectionArray,
    GlobalDM.LogUserInfo.strDutyUserGUID,GlobalDM.LogUserInfo.strDutyNumber,
    GlobalDM.LogUserInfo.strDutyUserName);
  ModalResult := mrOk;  
end;

procedure TfrmPlanWriteSection.FormCreate(Sender: TObject);
begin
  m_RsLCWriteCardSectionV2 := TRsLCWriteCardSectionV2.Create(GlobalDM.WebAPIUtils);
end;

procedure TfrmPlanWriteSection.FormDestroy(Sender: TObject);
begin
  m_RsLCWriteCardSectionV2.Free;
end;

procedure TfrmPlanWriteSection.Init;
var
  i: Integer;
  k: Integer;
begin
  m_RsLCWriteCardSectionV2.GetPlanAllSections(m_strTrainPlanGUID,m_AllSectionArray);
  m_RsLCWriteCardSectionV2.GetPlanSelectedSections(m_strTrainPlanGUID,m_SelectedSectionArray);
  for i := 0 to length(m_AllSectionArray) - 1 do
  begin
    checklstWriteSection.Items.Add(Format('[%s],%s',
      [m_AllSectionArray[i].strSectionID,m_AllSectionArray[i].strSectionName]));
    for k := 0 to length(m_SelectedSectionArray) - 1 do
    begin
      if (m_AllSectionArray[i].strJWDNumber = m_SelectedSectionArray[k].strJWDNumber)
        and (m_AllSectionArray[i].strSectionID = m_SelectedSectionArray[k].strSectionID) then
      begin
        checklstWriteSection.Checked[i] := true;
      end;  
    end;
  end;

end;

class procedure TfrmPlanWriteSection.Open(TrainPlanGUID: string);
var
  frmPlanWriteSection: TfrmPlanWriteSection;
begin
  frmPlanWriteSection:= TfrmPlanWriteSection.Create(nil);
  try
    frmPlanWriteSection.m_strTrainPlanGUID := TrainplanGUID;
    frmPlanWriteSection.Init;
    frmPlanWriteSection.ShowModal;
  finally
    frmPlanWriteSection.Free;
  end;
end;

end.
