unit uFrmGuideGroup;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, RzCmboBx, Buttons, Grids, RzGrids, ExtCtrls, RzPanel,
  IniFiles, uGlobalDM, uTFSystem, uSaftyEnum,
  uTrainman,  uGuideSign, PngSpeedButton,uLCTeamGuide;

type
  TFrmGuideGroup = class(TForm)
    Label10: TLabel;
    pnlLeft: TRzPanel;
    RzPanel2: TRzPanel;
    Label1: TLabel;
    grdSrc: TRzStringGrid;
    pnlRight: TRzPanel;
    RzPanel4: TRzPanel;
    Label2: TLabel;
    grdDes: TRzStringGrid;
    pnlMiddle: TRzPanel;
    btnSelOne: TBitBtn;
    btnSelAll: TBitBtn;
    btnDelOne: TBitBtn;
    btnDelAll: TBitBtn;
    btnSrcPY: TPngSpeedButton;
    edtSrcPY: TEdit;
    Label3: TLabel;
    edtDesPY: TEdit;
    btnDesPY: TPngSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure grdSrcDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect;
      State: TGridDrawState);
    procedure btnSelOneClick(Sender: TObject);
    procedure btnDelOneClick(Sender: TObject);
    procedure btnSrcPYClick(Sender: TObject);
    procedure btnDesPYClick(Sender: TObject);
  private
    { Private declarations } 
    //数据库操作类对象
    m_RsLCGuideGroup: TRsLCGuideGroup;
    //所在车间GUID
    m_strWorkShopGUID : string;
    //指导队GUID
    m_strGuideGroupGUID : string;
    //指导队名称
    m_strGuideGroupName : string;

    //显示待选的司机信息
    procedure ShowAllTrainman;
    //显示已选的司机信息   
    procedure ShowSelTrainman;
    //选择和反选
    procedure AddRow(grd: TRzStringGrid; txt: string);
    procedure DelRow(grd: TRzStringGrid; row: integer);
  public
    { Public declarations }  
    class function ShowForm: TModalResult;
  end;

implementation

uses uFrmMain_GuideSign;

{$R *.dfm}

{ TFrmGuideGroup }

class function TFrmGuideGroup.ShowForm: TModalResult;
var
  FrmGuideGroup: TFrmGuideGroup;
begin
  FrmGuideGroup := TFrmGuideGroup.Create(nil);
  result := FrmGuideGroup.ShowModal;
  FrmGuideGroup.Free;
end;

procedure TFrmGuideGroup.FormCreate(Sender: TObject);
begin
  m_RsLCGuideGroup := TRsLCGuideGroup.Create(GlobalDM.WebAPIUtils);
end;

procedure TFrmGuideGroup.FormDestroy(Sender: TObject);
begin
  m_RsLCGuideGroup.Free;
end;

procedure TFrmGuideGroup.FormResize(Sender: TObject);
begin
  self.pnlLeft.Width := (self.ClientWidth - self.pnlMiddle.Width) div 2;
end;

procedure TFrmGuideGroup.FormShow(Sender: TObject);
begin
  inherited;
  m_strWorkShopGUID := GlobalDM.SiteInfo.WorkShopGUID;    
  m_strGuideGroupGUID := GlobalDM.GuideGroupGUID;

  m_strGuideGroupName := m_RsLCGuideGroup.GetName(m_strGuideGroupGUID);
  //lblRightInfo.Caption := '当前车队：' + m_strGuideGroupName;

  grdSrc.RowCount := 1;
  grdSrc.ColCount := 5;
  grdSrc.RowHeights[0] := 24;
  grdSrc.ColWidths[0] := 16;
  grdSrc.ColWidths[1] := 80;
  grdSrc.ColWidths[2] := 100;
  grdSrc.ColWidths[3] := 80;
  grdSrc.ColWidths[4] := 0;
  grdSrc.Cells[1,0] := '工号';
  grdSrc.Cells[2,0] := '姓名';
  grdSrc.Cells[3,0] := '车队';
  
  grdDes.RowCount := 1;
  grdDes.ColCount := 5;
  grdDes.RowHeights[0] := 24;
  grdDes.ColWidths[0] := 16;
  grdDes.ColWidths[1] := 80;
  grdDes.ColWidths[2] := 100;
  grdDes.ColWidths[3] := 80;
  grdDes.ColWidths[4] := 0;
  grdDes.Cells[1,0] := '工号';
  grdDes.Cells[2,0] := '姓名';
  grdDes.Cells[3,0] := '车队';

  ShowAllTrainman;
  ShowSelTrainman;
end;
    
procedure TFrmGuideGroup.grdSrcDrawCell(Sender: TObject; ACol, ARow: Integer; Rect: TRect; State: TGridDrawState);
const
  WSpace = 2;
var
  T: string;
  W, H: integer;
begin
  inherited;
  T := (Sender as TStringGrid).Cells[ACol,ARow];
  with (Sender as TStringGrid).Canvas do
  begin
    if ARow = 0 then Font.Style := [fsBold];
    W := TextWidth(T);
    H := TextHeight(T);
    TextRect(Rect, Trunc((Rect.Right+Rect.Left-W)/2), Trunc((Rect.Bottom+Rect.Top-H)/2), T); //居中显示
  end;
end;

procedure TFrmGuideGroup.btnSelOneClick(Sender: TObject);
var
  i: integer;
  strTrainmanGUID: string;
begin
  inherited;
  i := grdSrc.Row;
  if i <= 0 then exit;
  strTrainmanGUID := grdSrc.Cells[4,i];
  if strTrainmanGUID = '' then exit;

  m_RsLCGuideGroup.Trainman.SetGroupByID(strTrainmanGUID, m_strGuideGroupGUID);

  grdSrc.Cells[3,i] := m_strGuideGroupName;
  AddRow(grdDes, grdSrc.Rows[i].Text);
  DelRow(grdSrc, i);
end;
    
procedure TFrmGuideGroup.btnSrcPYClick(Sender: TObject);
begin
  ShowAllTrainman;
end;
          
procedure TFrmGuideGroup.btnDesPYClick(Sender: TObject);
begin
  ShowSelTrainman;
end;

procedure TFrmGuideGroup.btnDelOneClick(Sender: TObject);
var
  i: integer; 
  strTrainmanGUID: string;
begin
  inherited;
  i := grdDes.Row;
  if i <= 0 then exit; 
  strTrainmanGUID := grdDes.Cells[4,i];
  if strTrainmanGUID = '' then exit;

  m_RsLCGuideGroup.Trainman.SetGroupByID(strTrainmanGUID, '');

  grdDes.Cells[3,i] := '';
  AddRow(grdSrc, grdDes.Rows[i].Text);
  DelRow(grdDes, i);
end;

procedure TFrmGuideGroup.ShowAllTrainman;
var
  QueryTrainman, FilterTrainman: RRsQueryTrainman;
  TrainmanArray, TrainmanArray2: TRsTrainmanArray;
  i, nRow: integer;
  strPY: string;
begin
  try
    QueryTrainman.strWorkShopGUID := m_strWorkShopGUID;
    FilterTrainman.strGuideGroupGUID := GlobalDM.GuideGroupGUID;

    m_RsLCGuideGroup.Trainman.GetList(QueryTrainman, FilterTrainman, TrainmanArray2);

    //根据拼音检索
    strPY := Trim(edtSrcPY.Text);
    if strPY = '' then
    begin
      TrainmanArray := TrainmanArray2;
    end
    else
    begin
      for i := 0 to Length(TrainmanArray2)-1 do
      begin
        if Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(TrainmanArray2[i].strTrainmanName))) > 0 then
        begin
          SetLength(TrainmanArray, Length(TrainmanArray)+1);
          TrainmanArray[Length(TrainmanArray)-1] := TrainmanArray2[i];
        end;
      end;
    end;
    //---------------

    grdSrc.RowCount := 1;
    for i := 0 to Length(TrainmanArray)-1 do
    begin
      nRow := grdSrc.RowCount;
      grdSrc.RowCount := nRow + 1;
      grdSrc.RowHeights[nRow] := 24;
      grdSrc.Cells[1,nRow] := TrainmanArray[i].strTrainmanNumber;
      grdSrc.Cells[2,nRow] := TrainmanArray[i].strTrainmanName;
      grdSrc.Cells[3,nRow] := TrainmanArray[i].strGuideGroupName;
      grdSrc.Cells[4,nRow] := TrainmanArray[i].strTrainmanGUID;
    end;
  finally
    if grdSrc.RowCount = 1 then
    begin
      grdSrc.RowCount := 2;
      grdSrc.RowHeights[1] := 24;
    end;
    grdSrc.FixedRows := 1;
  end;
end;
       
procedure TFrmGuideGroup.ShowSelTrainman;
var
  QueryTrainman, FilterTrainman: RRsQueryTrainman;
  TrainmanArray, TrainmanArray2: TRsTrainmanArray;
  i, nRow: integer;    
  strPY: string;
begin
  try
    if GlobalDM.GuideGroupGUID = '' then exit;

    QueryTrainman.strGuideGroupGUID := GlobalDM.GuideGroupGUID;

    m_RsLCGuideGroup.Trainman.GetList(QueryTrainman, FilterTrainman, TrainmanArray2);
                         
    //根据拼音检索
    strPY := Trim(edtDesPY.Text);
    if strPY = '' then
    begin
      TrainmanArray := TrainmanArray2;
    end
    else
    begin
      for i := 0 to Length(TrainmanArray2)-1 do
      begin
        if Pos(UpperCase(strPY),GlobalDM.GetHzPy(Trim(TrainmanArray2[i].strTrainmanName))) > 0 then
        begin
          SetLength(TrainmanArray, Length(TrainmanArray)+1);
          TrainmanArray[Length(TrainmanArray)-1] := TrainmanArray2[i];
        end;
      end;
    end;
    //---------------

    grdDes.RowCount := 1;
    for i := 0 to Length(TrainmanArray)-1 do
    begin
      nRow := grdDes.RowCount;
      grdDes.RowCount := nRow + 1;
      grdDes.RowHeights[nRow] := 24;
      grdDes.Cells[1,nRow] := TrainmanArray[i].strTrainmanNumber;
      grdDes.Cells[2,nRow] := TrainmanArray[i].strTrainmanName;
      grdDes.Cells[3,nRow] := TrainmanArray[i].strGuideGroupName;
      grdDes.Cells[4,nRow] := TrainmanArray[i].strTrainmanGUID;
    end;
  finally
    if grdDes.RowCount = 1 then
    begin
      grdDes.RowCount := 2;
      grdDes.RowHeights[1] := 24;
    end;
    grdDes.FixedRows := 1;
  end;
end;

procedure TFrmGuideGroup.AddRow(grd: TRzStringGrid; txt: string);
var
  i: integer;
begin
  inherited;
  i := grd.RowCount;

  if grd.RowCount = 1 then
  begin
    grd.RowCount := 2;
    grd.RowHeights[1] := 24;
    grd.FixedRows := 1;
  end;

  if grd.RowCount = 2 then
  begin
    if grd.Cells[4,1] = '' then
      i := 1
    else
      grd.RowCount := i+1;
  end
  else
  begin
    grd.RowCount := i+1;
  end;
  grd.RowHeights[i] := 24;

  grd.Rows[i].Text := txt;
end;

procedure TFrmGuideGroup.DelRow(grd: TRzStringGrid; row: integer);
var
  i, n: integer;
begin
  n := grd.RowCount;
  if n = 2 then
  begin
    grd.Rows[row].Text := '';
    exit;
  end;

  if n > 2 then
  begin
    for i := row+1 to n-1 do
    begin
      grd.Rows[i-1].Text := grd.Rows[i].Text;
    end;
    grd.RowCount := n-1;
  end;
end;

end.
