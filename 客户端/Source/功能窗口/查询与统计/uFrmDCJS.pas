unit uFrmDCJS;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, asgprev, Grids, AdvObj, BaseGrid, AdvGrid, ExtCtrls, RzPanel,
  Buttons, PngSpeedButton, ComCtrls, RzDTP, StdCtrls, AdvDateTimePicker;

type
  TfrmDCJS = class(TForm)
    RzPanel1: TRzPanel;
    AdvPreviewDialog: TAdvPreviewDialog;
    RzPanel2: TRzPanel;
    Panel1: TPanel;
    AdvStringGrid1: TAdvStringGrid;
    Label1: TLabel;
    Label2: TLabel;
    btnPrint: TPngSpeedButton;
    btnFind: TPngSpeedButton;
    btnToExcel: TPngSpeedButton;
    dtpPrintDateTime: TAdvDateTimePicker;
    Label3: TLabel;
    dtpBeginTime: TAdvDateTimePicker;
    dtpEndTime: TAdvDateTimePicker;
    SaveDialog1: TSaveDialog;
    procedure btnPrintClick(Sender: TObject);
    procedure btnFindClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure AdvStringGrid1GetCellPrintBorder(Sender: TObject; ARow,
      ACol: Integer; APen: TPen; var Borders: TCellBorders);
    procedure AdvStringGrid1GetCellBorder(Sender: TObject; ARow, ACol: Integer;
      APen: TPen; var Borders: TCellBorders);
    procedure FormCreate(Sender: TObject);
    procedure btnToExcelClick(Sender: TObject);
    procedure AdvStringGrid1SaveCell(Sender: TObject; ACol, ARow: Integer;
      var Value: string);
  private
    { Private declarations }
    procedure InitHEAD;
    function GetHTML2(SourceString: WideString): string;
    function GetHTMLContent(SourceString: WideString): string;
  public
    { Public declarations }
  end;



implementation
uses
  adodb, uPlan, DB,dateUtils;
{$R *.dfm}

procedure TfrmDCJS.AdvStringGrid1GetCellBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
begin
  if ARow > 1 then
  begin
    borders := [cbTop];
    if ARow = AdvStringGrid1.RowCount - 1 then
    begin
      borders := borders + [cbBottom];
    end;
    if ACol = 0 then
    begin
      borders := borders + [cbLeft, cbRight];
    end else begin
      borders := borders + [cbRight];
    end;
  end;
end;

procedure TfrmDCJS.AdvStringGrid1GetCellPrintBorder(Sender: TObject; ARow,
  ACol: Integer; APen: TPen; var Borders: TCellBorders);
begin
  if ARow > 1 then
  begin
    borders := [cbTop];
    if ARow = AdvStringGrid1.RowCount - 1 then
    begin
      borders := borders + [cbBottom];
    end;
    if ACol = 0 then
    begin
      borders := borders + [cbLeft, cbRight];
    end else begin
      borders := borders + [cbRight];
    end;
  end;
end;

procedure TfrmDCJS.AdvStringGrid1SaveCell(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
begin
  Value :=  stringReplace(Value,'&nbsp;','',[rfReplaceAll]);
end;

procedure TfrmDCJS.btnFindClick(Sender: TObject);
var
  i: integer;
  adoQuery: TADOQuery;
  bt,et : TDateTime;
begin
  bt := StrToDateTime(FormatDateTime('yyyy-MM-dd HH:00:00',dtpBeginTime.DateTime));
  et := StrToDateTime(FormatDateTime('yyyy-MM-dd HH:59:59',dtpEndTime.DateTime));
  InitHEAD;
  with AdvStringGrid1 do
  begin
    i := 3;
    adoQuery := TADOQuery.Create(nil);
    try
      TDBPlan.GetDCJLs(bt, et, adoQuery);
      RowCount := RowCount + adoQuery.RecordCount;
      while not adoQuery.Eof do
      begin
        Cells[0, i] := GetHTMLContent(Trim(adoQuery.FieldByName('strTrainNo').AsString));
        Cells[1, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtSignInTime').AsDateTime));
        Cells[2, i] := GetHTMLContent(Trim(adoQuery.FieldByName('strMainDriverName').AsString));

        if not adoQuery.FieldByName('dtMainInTime').IsNull then
          Cells[3, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtMainInTime').AsDateTime));

        Cells[4, i] := GetHTMLContent(Trim(adoQuery.FieldByName('strSubDriverName').AsString));

        if not adoQuery.FieldByName('dtSubInTime').IsNull then
          Cells[5, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtSubInTime').AsDateTime));
          
        Cells[6, i] := '';
        Cells[7, i] := '';
        Cells[8, i] := GetHTMLContent(Trim(adoQuery.FieldByName('strRoomNumber').AsString));

        if not adoQuery.FieldByName('dtRealCallTime').IsNull then
          Cells[9, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtRealCallTime').AsDateTime));

        if (adoQuery.FieldByName('dtMainOUTTime').IsNull and adoQuery.FieldByName('dtSubOUTTime').IsNull) then
        begin

        end else begin
          if (not adoQuery.FieldByName('dtMainOUTTime').IsNull and (not adoQuery.FieldByName('dtSubOUTTime').IsNull)) then
          begin
            if adoQuery.FieldByName('dtMainOUTTime').AsDateTime >= adoQuery.FieldByName('dtSubOUTTime').AsDateTime then
            begin
              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtSubOUTTime').AsDateTime));
            end else begin
              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtMainOUTTime').AsDateTime));
            end;
          end else begin
//            if not adoQuery.FieldByName('dtMainOUTTime').IsNull then
//              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtSubOUTTime').AsDateTime));
//            if not adoQuery.FieldByName('dtMainOUTTime').IsNull then
//              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtMainOUTTime').AsDateTime));
            if not adoQuery.FieldByName('dtMainOUTTime').IsNull then
              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtMainOUTTime').AsDateTime));
            if not adoQuery.FieldByName('dtSubOUTTime').IsNull then
              Cells[10, i] := GetHTMLContent(FormatDateTime('MM-dd hh:nn', adoQuery.FieldByName('dtSubOUTTime').AsDateTime));
          end;
        end;

        inc(i);
        adoQuery.Next;
      end;
    finally
      adoQuery.Free;
    end;
  end;

end;

procedure TfrmDCJS.btnPrintClick(Sender: TObject);
begin
  //AdvStringGrid1.ColCount := 5;
  AdvPreviewDialog.Execute;
  //btnFind.Click;
end;

procedure TfrmDCJS.btnToExcelClick(Sender: TObject);
var
  FileName: string;
begin
  if SaveDialog1.Execute then
  begin
    AdvStringGrid1.SaveWithHTML := false;
    FileName := SaveDialog1.FileName;
    if FileExists(FileName) then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName) then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    if FileExists(FileName + '.xls') then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName + '.xls') then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    if FileExists(FileName + '.xlsx') then
    begin
      if Application.MessageBox('该文件已经存在，确定要将其覆盖吗','警告',MB_OKCANCEL)=ID_OK  then
      begin
        if not DeleteFile(FileName + '.xlsx') then
        begin
          ShowMessage('文件被占用，无法覆盖！');
          Exit;
        end;
      end
      else Exit;
    end;
    AdvStringGrid1.SaveToXLS(SaveDialog1.FileName);
    Application.MessageBox('保存成功','提示',MB_OK + MB_ICONINFORMATION);
  end;
end;

procedure TfrmDCJS.Button1Click(Sender: TObject);
var
  ps: TPrinterSetupDialog;
  res: Boolean;
begin
  ps := TPrinterSetupDialog.Create(Self);
  res := ps.Execute;
  if not res then Exit;
end;

procedure TfrmDCJS.FormCreate(Sender: TObject);
begin
  dtpPrintDateTime.DateTime := Now;
  dtpBeginTime.DateTime :=Now;
  dtpEndTime.DateTime := Now;
  InitHEAD;
end;

function TfrmDCJS.GetHTML2(SourceString: WideString): string;
var
  i: integer;
begin
  Result := '';
  if length(SourceString) mod 2 = 0 then
  begin
    if length(SourceString) div 2 = 1 then
    begin
      Result := Result + '<p align="center"><font size="10">' +
        sourceString[1] +
        '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
        sourceString[2] + '</font></p>';
      Result := '<p></p>' + Result;
    end;

    if length(SourceString) div 2 = 2 then
    begin
      for i := 1 to length(SourceString)div 2 do
      begin
        Result := Result + '<p align="center"><font size="10">' +
          sourceString[(i-1) * 2 + 1] +
          '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
          sourceString[(i-1) * 2 + 2] + '</font></p>';
        if i = 1 then
        begin
          Result := Result + '<p></p>';
        end;
      end;
    end;
    if length(SourceString) div 2 = 3 then
    begin
      for i := 1 to length(SourceString)div 2 do
      begin
        Result := Result + '<p align="center"><font size="10">' +
          sourceString[(i-1) * 2 + 1] +
          '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' +
          sourceString[(i-1) * 2 + 2] + '</font></p>';
      end;
    end;
  end else begin
    Result := Result + '<p></p><p align="center"><font size="10">' +
      sourceString[1] +
      '&nbsp;&nbsp;&nbsp;' +
      sourceString[2] +
       '&nbsp;&nbsp;&nbsp;' +
      sourceString[3] + '</font></p>';
  end;
end;


function TfrmDCJS.GetHTMLContent(SourceString: WideString): string;
begin
  Result := '<p align="center"><font size="12">'+SourceString+'</font></p>';
end;

procedure TfrmDCJS.InitHEAD;
var
  i: integer;
begin
  with AdvStringGrid1 do
  begin
    EnableHTML := true;
    FixedCols := 0;
    FixedRows := 0;
    Font.Size := 12;
    //清除记录
    ClearAll;
    RowCount := 3;
    ColCount := 11;
    for i := 0 to ColCount - 1 do
    begin
      ColWidths[i] := 110;
    end;
    //标题
    MergeCells(0, 0, 11, 1);
    RowHeights[0] := 100;
    Cells[0, 0] := '<p align="center"><br/><br/><b><font size="20">机车乘务员待乘记录薄</Font></b></p>';
    FontStyles[0, 0] := [fsBold];

    //日期
    MergeCells(0, 1, 11, 1);
    Cells[0, 1] := '<font size="12">&nbsp;&nbsp;&nbsp;'+FormatDateTime('yyyy年MM月dd日 HH时',dtpPrintDateTime.DateTime)+'</font>';

    RowHeights[2] := 70;
    //打印头
    Cells[0, 2] := GetHTML2('待乘车次');//GetHTML2('待乘车次');
    Cells[1, 2] := GetHTML2('段定待乘时间');//GetHTML2('段定待乘时间');
    Cells[2, 2] := GetHTML2('司机');//GetHTML2('司机');
    Cells[3, 2] := GetHTML2('入寓时间');//GetHTML2('入寓时间');
    Cells[4, 2] := GetHTML2('副司机');//GetHTML2('副司机');
    Cells[5, 2] := GetHTML2('入寓时间');//GetHTML2('入寓时间');
    Cells[6, 2] := GetHTML2('学员');//GetHTML2('学员');
    Cells[7, 2] := GetHTML2('入寓时间');//GetHTML2('入寓时间');
    Cells[8, 2] := GetHTML2('待乘房号');//GetHTML2('待乘房号');
    Cells[9, 2] := GetHTML2('叫班时间');//GetHTML2('叫班时间');
    Cells[10, 2] := GetHTML2('离班时间');//GetHTML2('离班时间');
  end;
end;

end.

