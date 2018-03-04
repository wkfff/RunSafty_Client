unit uDayPlan;

interface
uses
  Windows,ComObj,Forms,Variants,Classes,SysUtils,ADODB,uTFSystem,DateUtils,StrUtils;

const
  DAY_FLAG = '��' ;    //���յı�Ƿ�
type
  //
  TDayPlanCols = array[0..3] of string;
  //�հ�ƻ�������
  TDayPlanItem = record
    OrginData : TDayPlanCols;
    FormatedCheCi:string ; //���ĳ���
    FormatedRemark:string ; //��ע
    FormatedCC : string;    //�������ó���
    FormatedCC1 : string;    //�ɰ����ó���
    FormatedCX : string;
    FormatedCH : string;
    FormatedDay : string ;  //��������
  end;
  //�հ�ƻ��������б�
  TDayPlanArray = array of TDayPlanItem;
  
  //�հ�ƻ�����
  RDayPlanRect = record
    //�������
    Caption : string;
    //������������(�С���)
    LeftTop : TPoint;
    //������������(�С���)
    RightTop : TPoint;
    //������������(�С���)
    LeftBottom : TPoint;
    //������������(�С���)
    RightBottom : TPoint;
    //�ƻ�����(0:�ƻ�;1:����)
    PlanType : integer;
    //�ƻ�����
    Rows : TDayPlanArray;
  end;
  //�ƻ������б�
  TDayPlanRectArray = array of RDayPlanRect;

  //���λ�����Ϣ��ϵ
  RTrainRelation = Record
    strCheCi:string ; //���ĳ���
    strRemark:string ; //��ע
    Caption : string;
    CC : string;
    CX : string;
    CH : string;
  end;
  
  //���λ�����Ϣ��ϵ�б�
  TTrainRelationArray = array of RTrainRelation;
  
  //�����¼�
  TProgressEvent = procedure(Position,Max : integer) of object;
  //�հ����ݷ�����
  TDayPlanAnalysis = class
  public
    constructor Create;
    destructor Destroy();override;
  public
    //�Ƿ��Ǻ���
    //����Ǻ�����ô������ True��������Ǻ��֣���ô���� False
    function IsMBCSChar(const ch: Char): Boolean;
  private
    //�����ƻ�����ͷ
    m_JHCol : TDayPlanCols;
    //���¼ƻ����б�
    m_DWCol : TDayPlanCols;
    //�����
    m_nMaxRow : integer;
    //�����
    m_nMaxCol : integer;
    //����
    m_OnProgress : TProgressEvent;
    //�ƻ�����
    m_strPlanTitle:string;
    //�ƻ�ʱ��
    m_strPlanName:string;
  public
    //����������б�
    MatchedRectArray : TDayPlanRectArray;
    //���λ�����ϵ�б�
    MatchedRelationArray : TTrainRelationArray;
    //��������
    procedure Analysis(ExcelFile : string);
    //�������
    procedure ClearData();
    //��ʽ������
    function FormatData(planRect : RDayPlanRect) : RDayPlanRect;
    //�Ƿ��Ѿ���������
    function HasRead(Row,Col : integer) : boolean;
    //�Ƿ���ƥ������
    function MatchRect(Row,Col : integer;excelApp: Variant;out planRect : RDayPlanRect) : boolean;
    //�Ƿ�Ϊƥ����ͷ
    function MatchHead(Row,Col : integer;excelApp: Variant;PlanHead : TDayPlanCols) : boolean;
    //��ʽ������
    function FormatCC(SourceString : string) : string ;
    //��ʽ������
    function FormatCX(SourceString : string) : string ;
    //��ʽ������
    function FormatCH(SourceString : string) : string ;
  public
    property  OnProgress : TProgressEvent read m_OnProgress write m_OnProgress;
    //�����ƻ�����ͷ
    property  JHCol : TDayPlanCols read m_JHCol;
    //���¼ƻ����б�
    property DWCol : TDayPlanCols read  m_DWCol;
    //�����
    property MaxRow : integer read m_nMaxRow;
    //�����
    property MaxCol : integer read m_nMaxCol;
    //�ƻ�����
    property  PlanTitle:string read m_strPlanTitle ;
    //�ƻ�ʱ��
    property PlanName:string read m_strPlanName;
  end;
  //�ռƻ����ݿ����
  TDBDayPlan = class(TDBOperate)
  public
    //�������ݿ�
    procedure ImportToDB(DayPlanDate : TDateTime;DayOrNight : integer; strDutyPlaceID:string;FileName:string;
      MatchedRectArray : TDayPlanRectArray;MatchedRelationArray : TTrainRelationArray;ShowProgress:TProgressEvent);
    //�����ݿ����
    function LoadFromDB(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;
      out MatchedRectArray : TDayPlanRectArray;out MatchedRelationArray : TTrainRelationArray) : boolean;
    //����
    function SaveToFile(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;FileName:string):Boolean;
    //����Ƿ���ڵ����¼
    function IsExist(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string):Boolean;
  public
    function SaveToStream(DayPlanDate : TDateTime;DayOrNight : integer;strDutyPlaceID:string;Stream:TStream):Boolean;
  end;




implementation

uses
  DB;

{ TDayPlanAnalysis }

procedure TDayPlanAnalysis.Analysis(ExcelFile: string);
var
  excelApp: Variant;
  nCurRow,nCurCol : integer;
  planRect :RDayPlanRect;
  relation : RTrainRelation;
  i: Integer;
  k: Integer;
begin
  try
    excelApp := CreateOleObject('Excel.Application');
  except
    Application.MessageBox('�㻹û�а�װMicrosoft Excel,���Ȱ�װ��','��ʾ',MB_OK + MB_ICONINFORMATION);
    exit;
  end;

  try


    SetLength(MatchedRectArray,0);
    SetLength(MatchedRelationArray,0);

    excelApp.Visible := false;
    excelApp.Caption := 'Ӧ�ó������ Microsoft Excel';
    excelApp.workBooks.Open(ExcelFile);
    excelApp.Worksheets[1].activate;
    //��ȡͷ��
    m_strPlanTitle :=  excelApp.Cells[1,1].Value  ;
    m_strPlanName  :=  excelApp.Cells[2,1].Value  ;
    //��������
    for nCurRow := 1 to m_nMaxRow do
    begin
      for nCurCol := 1 to m_nMaxCol do
      begin
        if assigned(m_OnProgress) then
          m_OnProgress((nCurRow-1) * m_nMaxCol + nCurCol - 1,m_nMaxRow*m_nMaxCol);
        //�����ǰ�����Ѿ��ڱ��������������������һ����
        if HasRead(nCurRow,nCurCol) then continue;
        //�����ǰ���в��Ǳ�ƥ��������������һ����
        if MatchRect(nCurRow,nCurCol,excelApp,planRect) then
        begin
          planRect := FormatData(planRect);
          SetLength(MatchedRectArray,length(MatchedRectArray) + 1);
          MatchedRectArray[length(MatchedRectArray) - 1] := planRect;
        end;
      end;
    end;
    for i := 0 to length(MatchedRectArray) - 1 do
    begin
      for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
      begin
        //�ų��Ǵ��յĳ���
        if Trim(MatchedRectArray[i].Rows[k].FormatedDay) = ''  then
        begin
          relation.strCheCi := MatchedRectArray[i].Rows[k].FormatedCheCi ;
          relation.strRemark := MatchedRectArray[i].Rows[k].FormatedRemark ;

          relation.Caption := MatchedRectArray[i].Caption;

          relation.CX := MatchedRectArray[i].Rows[k].FormatedCX;
          relation.CH := MatchedRectArray[i].Rows[k].FormatedCH;
          relation.CC := MatchedRectArray[i].Rows[k].FormatedCC;

          SetLength(MatchedRelationArray,length(MatchedRelationArray) + 1);
          MatchedRelationArray[length(MatchedRelationArray) - 1] := relation;
        end ;
      end;  
    end;
  finally
    excelApp.Quit;
    excelApp := Unassigned;
  end;  
end;

procedure TDayPlanAnalysis.ClearData;
begin
  SetLength(MatchedRectArray,0);
  SetLength(MatchedRelationArray,0);
end;

constructor TDayPlanAnalysis.Create;
begin
  m_JHCol[0] := '����';
  m_JHCol[1] := '����';
  m_JHCol[2] := '����';
  m_JHCol[3] := '��ע';

  m_DWCol[0] := '����';
  m_DWCol[1] := '����';
  m_DWCol[2] := '����';
  m_DWCol[3] := '��ע';
  
  m_nMaxRow := 200;
  m_nMaxCol := 20;
end;

destructor TDayPlanAnalysis.Destroy;
begin

  inherited;
end;


function TDayPlanAnalysis.FormatCC(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;
  if b > 0 then
  begin
    e := b;
    for i := b+1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-']) then
      begin
        e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if (e <b) or (e*b = 0) then
    result := SourceString;
end;




function TDayPlanAnalysis.FormatCH(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b;
    for i := b + 1 to length(SourceString) do
    begin
      if (SourceString[i] in ['0'..'9','+','-']) then
      begin
         e := i;
      end else begin
        break;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  if length(result) = 1 then
    result := '000' + result;
   if length(result) = 2 then
    result := '00' + result;
  if length(result) = 3 then
    result := '0' + result;
end;

function TDayPlanAnalysis.FormatCX(SourceString: string): string;
var
  i: Integer;
  b,e : integer;
begin
  result := '';
  b :=0;
  e :=0;
  for i := 1 to length(SourceString) do
  begin
    if SourceString[i] in ['0'..'9','A'..'Z','a'..'z','+','-'] then
    begin
      b := i;
      break;
    end;
  end;

  if b > 0 then
  begin
    e := b - 1;
    if SourceString[b] in ['A'..'Z','a'..'z'] then
    begin
      for i := b  to length(SourceString) do
      begin
        if (SourceString[i] in ['A'..'Z','a'..'z']) then
        begin
          e := i;
        end else begin
          break;
        end;
      end;
    end;
  end;
  result := Copy(SourceString,b,e-b + 1);
  IF SourceString <> '' then
  begin
  if UpperCase(result) = 'C' then
    result := 'HDX3C';
  if UpperCase(result) = 'H' then
    result := 'HDX3D';
  if UpperCase(result) = 'G' then
    result := 'DF11G';
  if UpperCase(result) = '' then
    result := 'SS8';
   if UpperCase(result) = 'S' then
    result := 'SS9';
  end;
end;

function TDayPlanAnalysis.FormatData(planRect: RDayPlanRect): RDayPlanRect;
const
  FORMATED_CHECI = 0 ;
  FORMATED_CX = 1 ;
  FORMATED_CH = 1 ;
  FORMATED_CC = 2 ;
  FORMATED_REMARK = 3 ;
var
  i: Integer;
  nFind : Integer ;
begin
  result := planRect;
  if planRect.PlanType = 1  then exit;
  for i := 0 to length(planRect.Rows) - 1 do
  begin
    Result.Rows[i].FormatedCheCi :=  planRect.Rows[i].OrginData[FORMATED_CHECI] ;
    result.Rows[i].FormatedCX := FormatCX(planRect.Rows[i].OrginData[FORMATED_CX]);
    result.Rows[i].FormatedCH := FormatCH(planRect.Rows[i].OrginData[FORMATED_CH]);
    result.Rows[i].FormatedCC := FormatCC(planRect.Rows[i].OrginData[FORMATED_CC]) ;
    Result.Rows[i].FormatedRemark :=  planRect.Rows[i].OrginData[FORMATED_REMARK] ;

    if ( Length( result.Rows[i].FormatedCC )  = 5  ) and
    (  LeftStr(result.Rows[i].FormatedCC,2)  = '50'  )
    then
    begin
      Result.Rows[i].FormatedCC1 := FormatCC(planRect.Rows[i].OrginData[FORMATED_REMARK]) ;
      result.Rows[i].FormatedCC := Result.Rows[i].FormatedCC1 ;
    end;

    nFind := Pos(DAY_FLAG,planRect.Rows[i].OrginData[FORMATED_REMARK]);
    if nFind <> 0  then
      Result.Rows[i].FormatedDay :=  '����'
    else
      Result.Rows[i].FormatedDay :=  '' ;
  end;
end;

function TDayPlanAnalysis.HasRead(Row, Col : integer): boolean;
var
  i: Integer;
  r : TRect;
  pt : TPoint;
begin
  result := false;
  for i := 0 to length(MatchedRectArray) - 1 do
  begin
    r := Rect(MatchedRectArray[i].LeftTop.X,MatchedRectArray[i].LeftTop.Y,
      MatchedRectArray[i].RightBottom.X,MatchedRectArray[i].RightBottom.Y);
    if PtInRect(r,pt) then
    begin
      result := true;
      exit;    
    end;
  end;
end;



function TDayPlanAnalysis.IsMBCSChar(const ch: Char): Boolean;
begin
  Result := (ByteType(ch, 1) <> mbSingleByte);
end;

function TDayPlanAnalysis.MatchHead(Row, Col: integer; excelApp: Variant;
  PlanHead: TDayPlanCols): boolean;
var
  i : integer;  
begin
  result := true;
  for i := 0 to length(PlanHead) - 1 do
  begin
    if VarToStr(Trim( excelApp.Cells[Row,Col + i].Value ) ) <> PlanHead[i] then
    begin
      result := false;
      exit;
    end;    
  end;
end;

function TDayPlanAnalysis.MatchRect(Row, Col: integer;
  excelApp: Variant;out planRect : RDayPlanRect): boolean;
var
  i,k,nullCount: Integer;
  nullRow : boolean;
begin
  result := false;
  //ƥ��ƻ��������ͷ
  if MatchHead(Row,Col,excelApp,m_JHCol) then
  begin
    //���ò������������
    planRect.Caption := excelApp.Cells[Row-1,Col].Value;
    planRect.PlanType := 0;
    //��¼������������λ��
    planRect.LeftTop := Point(Row-1,Col);
    planRect.RightTop := Point(Row-1,Col + length(m_JHCol) - 1);
    planRect.LeftBottom := Point(m_nMaxRow,Col);
    planRect.RightBottom := Point(m_nMaxRow,Col + length(m_JHCol) - 1);
    nullCount := 0;
    //���¿�ʼ����������
    for i := Row + 1 to m_nMaxRow do
    begin
      //�������ٴβ���ʱ���Ϊ��һ�β����˳�
      if MatchHead(i,Col,excelApp,m_JHCol) or MatchHead(i,Col,excelApp,m_DWCol) then
      begin
        //��¼��һ�β��������������
        planRect.LeftBottom := Point(i-2,Col);
        planRect.RightBottom := Point(i-2,Col + length(m_JHCol) - 1);
        //��ȥ��һ�β����ж��ಿ��
        setlength(planRect.Rows,length(planRect.Rows) -1);
        break;
      end;
      nullRow := true;
      //��Ӳ����������
      Setlength(planRect.Rows,length(planRect.Rows) +  1);
      for k := 0 to length(m_JHCol) - 1 do
      begin
        planRect.Rows[length(planRect.Rows) - 1].OrginData[k] := excelApp.Cells[i,col + k];
        if planRect.Rows[length(planRect.Rows) - 1].OrginData[k] <> '' then
          nullRow := false;
      end;
      planRect.LeftBottom := Point(i,Col);
      planRect.RightBottom := Point(i,Col + length(m_JHCol) - 1);
      if nullRow then
        nullCount := nullCount + 1;
      if nullCount > 10 then break;
    end;
    result := true;
    exit;
  end;

  //ƥ��ƻ������������ͷ
  if MatchHead(Row,Col,excelApp,m_DWCol) then
  begin
    //���ò������������
    planRect.Caption := excelApp.Cells[Row-1,Col].Value;
    planRect.PlanType := 1;
    //��¼������������λ��
    planRect.LeftTop := Point(Row-1,Col);
    planRect.RightTop := Point(Row-1,Col + length(m_JHCol) - 1);
    planRect.LeftBottom := Point(m_nMaxRow,Col);
    planRect.RightBottom := Point(m_nMaxRow,Col + length(m_JHCol) - 1);
    nullCount := 0;
    //���¿�ʼ����������
    for i := Row + 1 to m_nMaxRow do
    begin
      //�������ٴβ���ʱ���Ϊ��һ�β����˳�
      if MatchHead(i,Col,excelApp,m_JHCol) or MatchHead(i,Col,excelApp,m_DWCol) then
      begin
        //��¼��һ�β��������������
        planRect.LeftBottom := Point(i-2,Col);
        planRect.RightBottom := Point(i-2,Col + length(m_JHCol) - 1);
        //��ȥ��һ�β����ж��ಿ��
        setlength(planRect.Rows,length(planRect.Rows) -1);
        break;
      end;
      nullRow := true;
      //��Ӳ����������
      Setlength(planRect.Rows,length(planRect.Rows) +  1);
      for k := 0 to length(m_JHCol) - 1 do
      begin
        planRect.Rows[length(planRect.Rows) - 1].OrginData[k] := excelApp.Cells[i,col + k];
        if planRect.Rows[length(planRect.Rows) - 1].OrginData[k] <> '' then
          nullRow := false;
      end;
      planRect.LeftBottom := Point(i,Col);
      planRect.RightBottom := Point(i,Col + length(m_JHCol) - 1);
      if nullRow then
        nullCount := nullCount + 1;
      if nullCount > 10 then break;
    end;
    result := true;
    exit;
  end;

end;




procedure TDBDayPlan.ImportToDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
FileName:string; MatchedRectArray: TDayPlanRectArray;
  MatchedRelationArray: TTrainRelationArray;ShowProgress:TProgressEvent);
var
  i,k : integer;
  adoQuery : TADOQuery;
  strDayGUID,strRectGUID,strUpdateCode : string;
  strDayOrNight : string;
  dtBeginTime,dtEndTime : TDateTime;
begin
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      strDayGUID := NewGUID;
      strDayOrNight := 'ҹ��';

      dtBeginTime := IncHour(DateOf(DayPlanDate),18);
      dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);

      if DayOrNight = 1 then
      begin
        strDayOrNight := '�װ�';
        dtBeginTime := IncHour(DateOf(DayPlanDate),8);
        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate),18),-1);
      end;
      
      //��Ӽƻ���Ϣ
      if RecordCount = 0 then
      begin
        Append;
        FieldByName('strDayPlanGUID').Value := strDayGUID;
        FieldByName('strDayPlanName').Value := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight;
        FieldByName('strDutyPlaceID').Value := strDutyPlaceID ;
        FieldByName('dtDay').Value := DateOf(DayPlanDate);
        FieldByName('nDayOrNight').Value := DayOrNight;
        FieldByName('dtBeginTime').Value := dtBeginTime;
        FieldByName('dtEndTime').Value := dtEndTime;
        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
        Post;
      end
      else
      begin
        Edit ;
        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
        Post;
        strDayGUID  := FieldByName('strDayPlanGUID').AsString;
      end;
      //���֮ǰ�ļ�¼
      Sql.Text := 'delete from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      ExecSQL;
      //��ӳ��λ�������
      for i := 0 to length(MatchedRelationArray) - 1 do
      begin
        if (MatchedRelationArray[i].CC + MatchedRelationArray[i].CX + MatchedRelationArray[i].CH) = '' then continue;

        begin
          Sql.Text := 'insert into TAB_DayPlan_TrainRelation (strDayPlanGUID,' +
            'dtBeginTime,dtEndTime,dtCreateTime,strTrainNo,strTrainTypeName,' +
            'strTrainNumber,strRemark  ) values (:strDayPlanGUID,:dtBeginTime,' +
            ':dtEndTime,getdate(),:strTrainNo,:strTrainTypeName,:strTrainNumber,:strRemark)';
          Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
          Parameters.ParamByName('dtBeginTime').Value := dtBeginTime;
          Parameters.ParamByName('dtEndTime').Value := dtEndTime;
          Parameters.ParamByName('strTrainNo').Value := MatchedRelationArray[i].CC;
          Parameters.ParamByName('strTrainTypeName').Value := MatchedRelationArray[i].CX;
          Parameters.ParamByName('strTrainNumber').Value := MatchedRelationArray[i].CH;
          Parameters.ParamByName('strRemark').Value := MatchedRelationArray[i].strRemark;
          ExecSQL;
        end;
      end;
      strUpdateCode := NewGUID;
      for i := 0 to length(MatchedRectArray) - 1 do
      begin
        //��ӳ��λ�������
        Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID and strRectName=:RectName';
        Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
        Parameters.ParamByName('RectName').Value := MatchedRectArray[i].Caption;
        Open;
        strRectGUID := NewGUID;
        if RecordCount = 0 then
        begin
          Append;
          FieldByName('strRectGUID').Value :=  strRectGUID;
        end else begin
          strRectGUID := FieldByName('strRectGUID').AsString;
          Edit;
        end;
        FieldByName('strDayPlanGUID').Value :=  strDayGUID;
        FieldByName('strRectName').Value :=  MatchedRectArray[i].Caption;
        FieldByName('nLeftTopX').Value :=  MatchedRectArray[i].LeftTop.X;
        FieldByName('nLeftTopY').Value :=  MatchedRectArray[i].LeftTop.Y;
        FieldByName('nRightTopX').Value :=  MatchedRectArray[i].RightTop.X;
        FieldByName('nRightTopY').Value :=  MatchedRectArray[i].RightTop.Y;
        FieldByName('nLeftBottomX').Value :=  MatchedRectArray[i].LeftBottom.X;
        FieldByName('nLeftBotoomY').Value :=  MatchedRectArray[i].LeftBottom.Y;
        FieldByName('nRightBottomX').Value :=  MatchedRectArray[i].RightBottom.X;
        FieldByName('nRightBottomY').Value :=  MatchedRectArray[i].RightBottom.Y;
        FieldByName('nRectType').Value :=  MatchedRectArray[i].PlanType;
        FieldByName('strUpdateCode').Value :=  strUpdateCode;
        Post;
        for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
        begin
          Sql.Text := 'insert into TAB_DayPlan_Item (strRectItemGUID,strRectGUID, ' +
            ' nRow,strFormatedTrainNo,strTrainNo,strTrainNo1,nDay,strArriveTrainNo,strTrain, ' +
            ' strBrief,nChanged,strUpdateCode) values (:strRectItemGUID,' +
            ' :strRectGUID,:nRow,:strFormatedTrainNo,:strTrainNo,:strTrainNo1,:nDay,:strArriveTrainNo,' +
            ' :strTrain,:strBrief,:nChanged,:strUpdateCode)';
          Parameters.ParamByName('strRectItemGUID').Value := NewGUID;
          Parameters.ParamByName('strRectGUID').Value := strRectGUID;
          Parameters.ParamByName('nRow').Value := k + 1;
          Parameters.ParamByName('strFormatedTrainNo').Value := MatchedRectArray[i].Rows[k].FormatedCC;
          Parameters.ParamByName('strTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[2];
          Parameters.ParamByName('strArriveTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[0];
          Parameters.ParamByName('strTrain').Value := MatchedRectArray[i].Rows[k].OrginData[1];
          Parameters.ParamByName('strTrainNo1').Value := '';
          Parameters.ParamByName('nDay').Value := 0;
          Parameters.ParamByName('strBrief').Value := MatchedRectArray[i].Rows[k].OrginData[3];
          Parameters.ParamByName('nChanged').Value := 0;
          Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;   
          ExecSQL;
        end;
        //ɾ�������������
        SQL.Text := 'delete from TAB_DayPlan_Item where strRectGUID=:strRectGUID and strUpdateCode <> :strUpdateCode';
        Parameters.ParamByName('strRectGUID').Value := strRectGUID;
        Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;
        ExecSQL;
      end;
      //������θ��º��Ѿ�û���˵����������
      Sql.Text := 'delete from TAB_DayPlan_Item where strRectGUID in (select strRectGUID from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID and strUpdateCode <> :strUpdateCode)';
      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
      Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
      ExecSQL;
      //������θ��º��Ѿ�û���˵�����
      Sql.Text := 'delete from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID and strUpdateCode <> :strUpdateCode';
      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
      Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
      ExecSQL;
    end;
  finally
    adoQuery.Free;
  end;
end;


//procedure TDBDayPlan.ImportToDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
//FileName:string; MatchedRectArray: TDayPlanRectArray;
//  MatchedRelationArray: TTrainRelationArray);
//var
//  i,k : integer;
//  adoQuery : TADOQuery;
//  strDayGUID,strRectGUID,strUpdateCode : string;
//  strDayOrNight : string;
//  dtBeginTime,dtEndTime : TDateTime;
//begin
//  adoQuery := TADOQuery.Create(nil);
//  try
//    with adoQuery do
//    begin
//      Connection := m_ADOConnection;
//      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
//      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
//      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
//      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
//      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate) + 1,-1);
//      Parameters.ParamByName('DayOrNight').Value := DateOf(DayOrNight);
//      Open;
//      strDayGUID := NewGUID;
//      strDayOrNight := '�װ�';
//      dtBeginTime := IncHour(DateOf(DayPlanDate),18);
//      dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,8),-1);
//
//      if DayOrNight = 2 then
//      begin
//        strDayOrNight := 'ҹ��';
//        dtBeginTime := IncHour(DateOf(DayPlanDate)+1,8);
//        dtEndTime := IncSecond(IncHour(DateOf(DayPlanDate)+1,18),-1);
//      end;
//      
//      //��Ӽƻ���Ϣ
//      if RecordCount = 0 then
//      begin
//        Append;
//        FieldByName('strDayPlanGUID').Value := strDayGUID;
//        FieldByName('strDayPlanName').Value := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight;
//        FieldByName('strDutyPlaceID').Value := strDutyPlaceID ;
//        FieldByName('dtDay').Value := DateOf(DayPlanDate);
//        FieldByName('nDayOrNight').Value := DayOrNight;
//        FieldByName('dtBeginTime').Value := dtBeginTime;
//        FieldByName('dtEndTime').Value := dtEndTime;
//        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
//        Post;
//      end
//      else
//      begin
//        Edit ;
//        ( FieldByName('oleDayPlan') As TBlobField).LoadFromFile(FileName);
//        Post;
//        strDayGUID  := FieldByName('strDayPlanGUID').AsString;
//      end;
//      //���֮ǰ�ļ�¼
//      Sql.Text := 'delete from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
//      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//      ExecSQL;
//
//      //ɾ����ʷ��¼
//      //������θ��º��Ѿ�û���˵����������
//      Sql.Text := 'delete from TAB_DayPlan_Item where strRectGUID in (select strRectGUID from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID )';
//      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
//      //Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
//      ExecSQL;
//      //������θ��º��Ѿ�û���˵�����
//      Sql.Text := 'delete from TAB_DayPlan_Rect where strDayPlanGUID = :strDayPlanGUID ';
//      Parameters.ParamByName('strDayPlanGUID').Value :=  strDayGUID;
//      //Parameters.ParamByName('strUpdateCode').Value :=  strUpdateCode;
//      ExecSQL;
//
//      //��ӳ��λ�������
//      for i := 0 to length(MatchedRelationArray) - 1 do
//      begin
//        if (MatchedRelationArray[i].CC + MatchedRelationArray[i].CX + MatchedRelationArray[i].CH) = '' then continue;
//
//        //�κ;��˵���ӵ���ϵ��
//        if  ( MatchedRelationArray[i].strCheCi  = '����' ) or
//          ( MatchedRelationArray[i].strCheCi  =   '��' )
//        then
//        begin
//          Sql.Text := 'insert into TAB_DayPlan_TrainRelation (strDayPlanGUID,' +
//            'dtBeginTime,dtEndTime,dtCreateTime,strTrainNo,strTrainTypeName,' +
//            'strTrainNumber  ) values (:strDayPlanGUID,:dtBeginTime,' +
//            ':dtEndTime,getdate(),:strTrainNo,:strTrainTypeName,:strTrainNumber)';
//          Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//          Parameters.ParamByName('dtBeginTime').Value := dtBeginTime;
//          Parameters.ParamByName('dtEndTime').Value := dtEndTime;
//          Parameters.ParamByName('strTrainNo').Value := MatchedRelationArray[i].CC;
//          Parameters.ParamByName('strTrainTypeName').Value := MatchedRelationArray[i].CX;
//          Parameters.ParamByName('strTrainNumber').Value := MatchedRelationArray[i].CH;
//          ExecSQL;
//        end;
//      end;
//      strUpdateCode := NewGUID;
//      for i := 0 to length(MatchedRectArray) - 1 do
//      begin
//
//        //��ӳ��λ�������
//        Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID and strRectName=:RectName';
//        Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
//        Parameters.ParamByName('RectName').Value := MatchedRectArray[i].Caption;
//        Open;
//        strRectGUID := NewGUID;
//        if RecordCount = 0 then
//        begin
//          Append;
//          FieldByName('strRectGUID').Value :=  strRectGUID;
//        end else begin
//          strRectGUID := FieldByName('strRectGUID').AsString;
//          Edit;
//        end;
//        FieldByName('strDayPlanGUID').Value :=  strDayGUID;
//        FieldByName('strRectName').Value :=  MatchedRectArray[i].Caption;
//        FieldByName('nLeftTopX').Value :=  MatchedRectArray[i].LeftTop.X;
//        FieldByName('nLeftTopY').Value :=  MatchedRectArray[i].LeftTop.Y;
//        FieldByName('nRightTopX').Value :=  MatchedRectArray[i].RightTop.X;
//        FieldByName('nRightTopY').Value :=  MatchedRectArray[i].RightTop.Y;
//        FieldByName('nLeftBottomX').Value :=  MatchedRectArray[i].LeftBottom.X;
//        FieldByName('nLeftBotoomY').Value :=  MatchedRectArray[i].LeftBottom.Y;
//        FieldByName('nRightBottomX').Value :=  MatchedRectArray[i].RightBottom.X;
//        FieldByName('nRightBottomY').Value :=  MatchedRectArray[i].RightBottom.Y;
//        FieldByName('nRectType').Value :=  MatchedRectArray[i].PlanType;
//        FieldByName('strUpdateCode').Value :=  strUpdateCode;
//        Post;
//
//
//
//
//        for k := 0 to length(MatchedRectArray[i].Rows) - 1 do
//        begin
//          Sql.Text := 'insert into TAB_DayPlan_Item (strRectItemGUID,strRectGUID, ' +
//            ' nRow,strFormatedTrainNo,strTrainNo,nDay,strArriveTrainNo,strTrain, ' +
//            ' strBrief,strPlaceName,nChanged,strUpdateCode) values (:strRectItemGUID,' +
//            ' :strRectGUID,:nRow,:strFormatedTrainNo,:strTrainNo,:nDay,:strArriveTrainNo,' +
//            ' :strTrain,:strBrief,:strPlaceName,:nChanged,:strUpdateCode)';
//          Parameters.ParamByName('strRectItemGUID').Value := NewGUID;
//          Parameters.ParamByName('strRectGUID').Value := strRectGUID;
//          Parameters.ParamByName('nRow').Value := k + 1;
//          Parameters.ParamByName('strFormatedTrainNo').Value := MatchedRectArray[i].Rows[k].FormatedCC;
//          Parameters.ParamByName('strTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[2];
//          Parameters.ParamByName('strArriveTrainNo').Value := MatchedRectArray[i].Rows[k].OrginData[0];
//          Parameters.ParamByName('strTrain').Value := MatchedRectArray[i].Rows[k].OrginData[1];
//          Parameters.ParamByName('strBrief').Value := MatchedRectArray[i].Rows[k].OrginData[3];
//          Parameters.ParamByName('nChanged').Value := 0;
//          Parameters.ParamByName('strUpdateCode').Value := strUpdateCode;   
//          ExecSQL;
//        end;
//      end;
//    end;
//  finally
//    adoQuery.Free;
//  end;
//end;


function TDBDayPlan.IsExist(DayPlanDate: TDateTime;
  DayOrNight: integer;strDutyPlaceID:string): Boolean;
var
  adoQuery: TADOQuery;
  strDayOrNight : string ;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    strDayOrNight := 'ҹ��';
    if DayOrNight = 1 then
       strDayOrNight := '�װ�' ;
    strDayOrNight := FormatDateTime('yyyy-MM-dd',DayPlanDate) + strDayOrNight ;
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and ( strDayPlanName = :strDayPlanName  )and nDayOrNight=:DayOrNight';

      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('strDayPlanName').Value := strDayOrNight;
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;

      Open;
      //��Ӽƻ���Ϣ
      if RecordCount = 0 then
      begin
        exit;
      end;
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBDayPlan.LoadFromDB(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  out MatchedRectArray: TDayPlanRectArray;
  out MatchedRelationArray: TTrainRelationArray) : boolean;
var
  i,k : integer;
  adoQuery,adoQuery2 : TADOQuery;
  strDayGUID,strRectGUID : string;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1 ,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight;
      Open;
      //��Ӽƻ���Ϣ
      if RecordCount = 0 then
      begin
        exit;
      end;
      strDayGUID  := FieldByName('strDayPlanGUID').AsString;

      //��ӳ��λ�������
      Sql.Text := 'select * from TAB_DayPlan_TrainRelation where strDayPlanGUID = :strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      Open;
      SetLength(MatchedRelationArray,RecordCount);
      i := 0 ;
      while not eof do
      begin
        MatchedRelationArray[i].CC := FieldByName('strTrainNo').Value;
        MatchedRelationArray[i].CX := FieldByName('strTrainTypeName').Value;
        MatchedRelationArray[i].CH := FieldByName('strTrainNumber').Value;
        MatchedRelationArray[i].strCheCi := FieldByName('strTrainNo').Value;
        //MatchedRelationArray[i].Caption := FieldByName('strTrainNumber').Value;
        MatchedRelationArray[i].strRemark :=  FieldByName('strRemark').Value;
        Inc(i);
        next;
      end;

      Sql.Text := 'select * from TAB_DayPlan_Rect where strDayPlanGUID=:strDayPlanGUID';
      Parameters.ParamByName('strDayPlanGUID').Value := strDayGUID;
      Open;
      i := 0;
      SetLength(MatchedRectArray,RecordCount);
      while not eof do
      begin
        MatchedRectArray[i].Caption := FieldByName('strRectName').Value;
        MatchedRectArray[i].LeftTop.X := FieldByName('nLeftTopX').Value;
        MatchedRectArray[i].LeftTop.Y := FieldByName('nLeftTopY').Value;
        MatchedRectArray[i].RightTop.X := FieldByName('nRightTopX').Value;
        MatchedRectArray[i].RightTop.Y := FieldByName('nRightTopY').Value;
        MatchedRectArray[i].LeftBottom.X := FieldByName('nLeftBottomX').Value;
        MatchedRectArray[i].LeftBottom.Y := FieldByName('nLeftBotoomY').Value;
        MatchedRectArray[i].RightBottom.X := FieldByName('nRightBottomX').Value;
        MatchedRectArray[i].RightBottom.Y := FieldByName('nRightBottomY').Value;
        MatchedRectArray[i].PlanType := FieldByName('nRectType').Value;
        strRectGUID := FieldByName('strRectGUID').Value;
        adoQuery2 := TADOQuery.Create(nil);
        try
          adoQuery2.Connection := m_ADOConnection;
          //��ӳ��λ�������
          adoQuery2.Sql.Text := 'select * from TAB_DayPlan_Item where strRectGUID=:strRectGUID order by nRow';
          adoQuery2.Parameters.ParamByName('strRectGUID').Value := strRectGUID;
          adoQuery2.Open;
          k := 0;
          SetLength(MatchedRectArray[i].Rows,adoQuery2.RecordCount);
          while not adoQuery2.Eof do
          begin
            MatchedRectArray[i].Rows[k].OrginData[0] := adoQuery2.FieldByName('strArriveTrainNo').AsString;
            MatchedRectArray[i].Rows[k].OrginData[1] := adoQuery2.FieldByName('strTrain').AsString;
            MatchedRectArray[i].Rows[k].OrginData[2] := adoQuery2.FieldByName('strTrainNo').AsString;
            MatchedRectArray[i].Rows[k].OrginData[3] := adoQuery2.FieldByName('strBrief').AsString;
            Inc(k);
            adoQuery2.Next;
          end;
        finally
          adoQuery2.Free;
        end;
        Inc(i);
        next;
      end;
    end;
  finally
    adoQuery.Free;
  end;
end;



function TDBDayPlan.SaveToFile(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  FileName: string): Boolean;
var
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      //��Ӽƻ���Ϣ
      if RecordCount = 0 then
      begin
        exit;
      end;
      ( FieldByName('oleDayPlan') As TBlobField).SaveToFile(FileName);
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

function TDBDayPlan.SaveToStream(DayPlanDate: TDateTime; DayOrNight: integer;strDutyPlaceID:string;
  Stream:TStream): Boolean;
var
  adoQuery: TADOQuery;
begin
  result := false;
  adoQuery := TADOQuery.Create(nil);
  try
    with adoQuery do
    begin
      Connection := m_ADOConnection;
      Sql.Text := 'select * from TAB_DayPlan_Information  where ' +
      ' strDutyPlaceID =:strDutyPlaceID  and dtDay Between :BeginTime and :EndTime and nDayOrNight=:DayOrNight';
      Parameters.ParamByName('strDutyPlaceID').Value := strDutyPlaceID ;
      Parameters.ParamByName('BeginTime').Value := DateOf(DayPlanDate);
      Parameters.ParamByName('EndTime').Value := IncSecond(DateOf(DayPlanDate)+1,-1);
      Parameters.ParamByName('DayOrNight').Value := DayOrNight ;
      Open;
      //��Ӽƻ���Ϣ
      if RecordCount = 0 then
      begin
        exit;
      end;
      ( FieldByName('oleDayPlan') As TBlobField).SaveToStream(Stream);
      Result := True ;
    end;
  finally
    adoQuery.Free;
  end;
end;

end.
