unit uFrmImportDrinkInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  ExtCtrls, RzPanel, StdCtrls, Buttons, PngCustomButton, ComCtrls,
  Grids, AdvObj, BaseGrid, AdvGrid, PngSpeedButton, uApparatusCommon, DateUtils,
  uTFSystem, uConnAccess, uSaftyEnum, uTrainman, uDrink,  uTrainPlan;

type
  TFrmImportDrinkInfo = class(TForm)
    RzPanel1: TRzPanel;
    RzPanel2: TRzPanel;
    PngCustomButton1: TPngCustomButton;
    Label1: TLabel;
    grdMain: TAdvStringGrid;
    statusMain: TStatusBar;
    btnExit: TPngSpeedButton;
    btnOK: TPngSpeedButton;
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnOKClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure grdMainGetAlignment(Sender: TObject; ARow, ACol: Integer;
      var HAlign: TAlignment; var VAlign: TVAlignment);
    procedure grdMainCanEditCell(Sender: TObject; ARow, ACol: Integer;
      var CanEdit: Boolean);
    procedure grdMainGetEditorType(Sender: TObject; ACol, ARow: Integer;
      var AEditor: TEditorType);
    procedure grdMainComboChange(Sender: TObject; ACol, ARow,
      AItemIndex: Integer; ASelection: string);
  private
    { Private declarations }
    //�������ݿ���������
    m_dbConnAccess: TConnAccess;
    m_DrinkInfoArray: TRsDrinkInfoArray;
    m_ImportPlanArray: TRsImportPlanArray;

    //��ѯ���ز����Ϣ
    procedure QueryLocalDrinkInfo(ImportPlanArray: TRsImportPlanArray);
    //�õ�ƥ��ƻ�������
    function GetMatchPlanIndex(DrinkInfo: RRsDrinkInfo): integer;
  public
    { Public declarations }
    //�ṩ��ӿڣ���ʾ������͹�����
    class function ShowForm(ImportPlanArray: TRsImportPlanArray): TModalResult;
  end;

implementation

uses uGlobalDM;

{$R *.dfm}

class function TFrmImportDrinkInfo.ShowForm(ImportPlanArray: TRsImportPlanArray): TModalResult;
var
  FrmImportDrinkInfo: TFrmImportDrinkInfo;
begin                          
  result := mrNone;
  FrmImportDrinkInfo := TFrmImportDrinkInfo.Create(nil);
  FrmImportDrinkInfo.QueryLocalDrinkInfo(ImportPlanArray);
  if FrmImportDrinkInfo.ShowModal = mrOK then result := mrOK;
  FrmImportDrinkInfo.Free;
end;

procedure TFrmImportDrinkInfo.FormCreate(Sender: TObject);
begin
  m_dbConnAccess := TConnAccess.Create(Application);
end;

procedure TFrmImportDrinkInfo.FormDestroy(Sender: TObject);
begin
  m_dbConnAccess.Free;
end;

procedure TFrmImportDrinkInfo.btnOKClick(Sender: TObject);
var
  nRow, nCol, nIndex, nDelete, nImport: integer;
  strFlag: string;
  function GetPlanIndex(strInfo: string): integer;
  var
    i: integer;
    strLine: string;
  begin
    result := -1;
    if strInfo = '' then exit;
    for i := 0 to Length(m_ImportPlanArray) - 1 do
    begin
      strLine := '';
      strLine := strLine + Format('����=%s��', [m_ImportPlanArray[i].TrainPlan.strTrainNo]);
      strLine := strLine + Format('����ʱ��=%s��', [FormatDateTime('MM-dd hh:nn', m_ImportPlanArray[i].TrainPlan.dtStartTime)]);
      strLine := strLine + Format('˾��=%s��', [GetTrainmanText(m_ImportPlanArray[i].Trainman)]);
      if strInfo = strLine then
      begin
        result := i;
        break;
      end;
    end;
  end;
begin
  nDelete := 0;
  nImport := 0;
  nCol := grdMain.Col;
  grdMain.Col := 1;   
  grdMain.Col := nCol;
  for nRow := 1 to grdMain.RowCount - 1 do
  begin
    strFlag := grdMain.Cells[5, nRow];
    if strFlag = 'ɾ��' then
    begin
      nDelete := nDelete + 1;
      Continue;
    end;
    if strFlag = 'ƥ��' then
    begin
      nIndex := GetPlanIndex(grdMain.Cells[6, nRow]);
      if nIndex >= 0 then nImport := nImport + 1;
      Continue;
    end;
  end;
  if not TBox(Format('��ɾ������%d������ƥ�����%d������ȷ��Ҫ����������', [nDelete, nImport])) then exit;

  for nRow := 1 to grdMain.RowCount - 1 do
  begin
    strFlag := grdMain.Cells[5, nRow];
    
    if strFlag = 'ɾ��' then
    begin
      m_dbConnAccess.UpdateDrinkState(m_DrinkInfoArray[nRow-1].nDrinkInfoID);
      Continue;
    end;
    
    if strFlag = 'ƥ��' then
    begin
      nIndex := GetPlanIndex(grdMain.Cells[6, nRow]);
      if nIndex >= 0 then
      begin
        m_ImportPlanArray[nIndex].blnMatched := true;
        m_ImportPlanArray[nIndex].nVerifyID := TRsRegisterFlag(m_DrinkInfoArray[nRow-1].nVerifyID);
        m_ImportPlanArray[nIndex].TestAlcoholInfo.dtTestTime := m_DrinkInfoArray[nRow-1].dtCreateTime;
        m_ImportPlanArray[nIndex].TestAlcoholInfo.taTestAlcoholResult := TTestAlcoholResult(m_DrinkInfoArray[nRow-1].nDrinkResult);
        m_ImportPlanArray[nIndex].TestAlcoholInfo.Picture := m_DrinkInfoArray[nRow-1].DrinkImage;
        m_ImportPlanArray[nIndex].nDrinkInfoID := m_DrinkInfoArray[nRow-1].nDrinkInfoID;
      end;
      Continue;
    end;
  end;

  self.ModalResult := mrOk;
end;

procedure TFrmImportDrinkInfo.btnExitClick(Sender: TObject);
begin
  Close;
end;
    
procedure TFrmImportDrinkInfo.grdMainCanEditCell(Sender: TObject; ARow, ACol: Integer; var CanEdit: Boolean);
begin
  CanEdit := False;
  if ACol = 5 then CanEdit := True;
  if ACol = 6 then CanEdit := True;
end;

procedure TFrmImportDrinkInfo.grdMainGetAlignment(Sender: TObject; ARow,
  ACol: Integer; var HAlign: TAlignment; var VAlign: TVAlignment);
begin
  HAlign := taCenter;
  if ACol = 6 then HAlign := taLeftJustify;
end;

procedure TFrmImportDrinkInfo.grdMainComboChange(Sender: TObject; ACol, ARow, AItemIndex: Integer; ASelection: string);
begin
  if ACol = 5 then
  begin
    if ASelection <> 'ƥ��' then grdMain.Cells[6, ARow] := '';
    
    if ASelection = 'ɾ��' then
      grdMain.RowFontColor[ARow] := clRed
    else
      grdMain.RowFontColor[ARow] := clBlack;
  end;
  
  if ACol = 6 then
  begin                                          
    if AItemIndex = 0 then if grdMain.Cells[5, ARow] = 'ƥ��' then grdMain.Cells[5, ARow] := '';
    if AItemIndex > 0 then grdMain.Cells[5, ARow] := 'ƥ��';
    
    if grdMain.Cells[5, ARow] = 'ɾ��' then
      grdMain.RowFontColor[ARow] := clRed
    else
      grdMain.RowFontColor[ARow] := clBlack;
  end;
end;

procedure TFrmImportDrinkInfo.grdMainGetEditorType(Sender: TObject; ACol, ARow: Integer; var AEditor: TEditorType);
var
  i: integer;
  strLine: string;
  function IsSelected(strInfo: string; ExcludeRow: integer): boolean;
  var
    i: integer;
  begin
    result := false;
    for i := 1 to grdMain.RowCount - 1 do
    begin
      if i = ExcludeRow then Continue;
      if grdMain.Cells[6, i] = strInfo then
      begin
        result := true;
        break;
      end;
    end;
  end;
begin
  if ACol = 5 then
  begin
    AEditor := edComboList;
    TAdvStringGrid(Sender).ClearComboString;
    TAdvStringGrid(Sender).AddComboString('');
    TAdvStringGrid(Sender).AddComboString('ɾ��');
    TAdvStringGrid(Sender).AddComboString('ƥ��');
  end;

  if ACol = 6 then
  begin
    AEditor := edComboList;
    TAdvStringGrid(Sender).ClearComboString;  
    TAdvStringGrid(Sender).AddComboString('');
    for i := 0 to Length(m_ImportPlanArray) - 1 do
    begin
      strLine := '';
      strLine := strLine + Format('����=%s��', [m_ImportPlanArray[i].TrainPlan.strTrainNo]);
      strLine := strLine + Format('����ʱ��=%s��', [FormatDateTime('MM-dd hh:nn', m_ImportPlanArray[i].TrainPlan.dtStartTime)]);
      strLine := strLine + Format('˾��=%s��', [GetTrainmanText(m_ImportPlanArray[i].Trainman)]);

      if m_ImportPlanArray[i].Trainman.strTrainmanNumber <> grdMain.Cells[102, ARow] then Continue;
      //if grdMain.Cells[6, ARow] = strLine
      if IsSelected(strLine, ARow) then Continue;
      TAdvStringGrid(Sender).AddComboString(strLine);
    end;
  end;
end;

//==============================================================================

procedure TFrmImportDrinkInfo.QueryLocalDrinkInfo(ImportPlanArray: TRsImportPlanArray);
var
  i, j: integer;
  DrinkQuery: RRsDrinkQuery;  
  strLine: string;
begin
  if not m_dbConnAccess.ConnectAccess then
  begin
    Box('�������ݿ�ʧ�ܣ���������ԣ�');
    exit;
  end;
  
  m_ImportPlanArray := ImportPlanArray;
  try
    DrinkQuery.nWorkTypeID := 0;
    DrinkQuery.strTrainmanNumber := '';
    DrinkQuery.dtBeginTime := 0;
    DrinkQuery.dtEndTime := 0;
    m_dbConnAccess.QueryDrinkInfo(DrinkQuery, m_DrinkInfoArray);
    with grdMain do
    begin
      ClearRows(1, RowCount - 1); 
      ClearCols(99, 99);     
      ClearCols(102, 102);
      RowCount := Length(m_DrinkInfoArray) + 1;
      statusMain.Panels[0].Text := Format(' ��¼������%d ��', [RowCount-1]);
      if RowCount = 1 then
      begin
        RowCount := 2;
        FixedRows := 1;
      end;
      for i := 0 to Length(m_DrinkInfoArray) - 1 do
      begin
        Cells[0, i + 1] := inttoStr(i + 1);   
        Cells[1, i + 1] := FormatDateTime('yyyy-mm-dd hh:nn:ss',m_DrinkInfoArray[i].dtCreateTime);
        Cells[2, i + 1] := Format('%6s[%s]', [m_DrinkInfoArray[i].strTrainmanName, m_DrinkInfoArray[i].strTrainmanNumber]);
        Cells[3, i + 1] := TestAlcoholResultToString(TTestAlcoholResult(m_DrinkInfoArray[i].nDrinkResult));
        Cells[4, i + 1] := TRsRegisterFlagNameAry[TRsRegisterFlag(m_DrinkInfoArray[i].nVerifyID)];
        Cells[99, i + 1] := IntToStr(m_DrinkInfoArray[i].nDrinkInfoID); 
        Cells[102, i + 1] := m_DrinkInfoArray[i].strTrainmanNumber;

        j := GetMatchPlanIndex(m_DrinkInfoArray[i]);
        if j >= 0 then
        begin
          strLine := '';
          strLine := strLine + Format('����=%s��', [m_ImportPlanArray[j].TrainPlan.strTrainNo]);
          strLine := strLine + Format('����ʱ��=%s��', [FormatDateTime('MM-dd hh:nn', m_ImportPlanArray[j].TrainPlan.dtStartTime)]);
          strLine := strLine + Format('˾��=%s��', [GetTrainmanText(m_ImportPlanArray[j].Trainman)]);
          Cells[5, i + 1] := 'ƥ��';
          Cells[6, i + 1] := strLine;
          m_ImportPlanArray[j].blnSelected := True;
        end;
      end;
    end;
  except on e : exception do
    begin
      BoxErr('��ѯ��Ϣʧ��:' + e.Message);
    end;
  end;
end;

function TFrmImportDrinkInfo.GetMatchPlanIndex(DrinkInfo: RRsDrinkInfo): integer;
var
  i: integer;
begin
  result := -1;
  for i := 0 to Length(m_ImportPlanArray) - 1 do
  begin
    if m_ImportPlanArray[i].blnSelected then Continue;
    if m_ImportPlanArray[i].Trainman.strTrainmanNumber <> DrinkInfo.strTrainmanNumber then Continue;
    if MinutesBetween(m_ImportPlanArray[i].TrainPlan.dtStartTime, DrinkInfo.dtCreateTime) <= 90 then
    begin
      result := i;
      break;
    end;
  end;
end;

end.

