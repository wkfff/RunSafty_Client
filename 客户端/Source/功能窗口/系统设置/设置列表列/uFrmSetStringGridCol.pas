unit uFrmSetStringGridCol;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, RzButton, StdCtrls, RzLabel, RzLstBox, RzChkLst, RzCommon;

type
  TFrmSetStringGridCol = class(TForm)
    rzbtbtnOK: TRzBitBtn;
    rzbtbtnCancel: TRzBitBtn;
    lstGridColumn: TRzCheckList;
    lbl1: TRzLabel;
    rzbtbtnSelAll: TRzBitBtn;
    rzbtbtnUnSel: TRzBitBtn;
    procedure FormShow(Sender: TObject);
    procedure rzbtbtnSelAllClick(Sender: TObject);
    procedure rzbtbtnUnSelClick(Sender: TObject);
    procedure rzbtbtnOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure WriteConfigFile(strSection:string;lstHideIndex: TStringList);
  private
    m_strGridCaption:string;
    /// <summary>列表标题</summary>
    m_lstAllHeaders:TStringList;
    /// <summary>需要隐藏的列索引号</summary>
    m_lstHideColumnIndex:TStringList;
  published
    property GridCaption:string read m_strGridCaption write m_strGridCaption;
    property ListAllHeaders:TStringList read m_lstAllHeaders write m_lstAllHeaders;
    property ListHideColumnIndex:TStringList read m_lstHideColumnIndex
      write m_lstHideColumnIndex;
  end;

implementation
uses
  uRunSaftyDefine;

{$R *.dfm}

procedure TFrmSetStringGridCol.FormCreate(Sender: TObject);
begin
  m_lstAllHeaders := nil;
  m_lstHideColumnIndex := nil;
  m_strGridCaption := '';
end;

procedure TFrmSetStringGridCol.FormShow(Sender: TObject);
var
  I:Integer;
begin
  if not Assigned(m_lstAllHeaders) then
    raise Exception.Create('请指定列表的表头项');
  if not Assigned(m_lstHideColumnIndex) then
    raise Exception.Create('请指定保存显示表头项索引列表');
  if Trim(m_strGridCaption) = '' then
    raise Exception.Create('请指定列表名称,用于在配置文件中保存信息');
    
  lstGridColumn.Items.BeginUpdate;
  try
    lstGridColumn.Items.Clear;
    for I := 0 to m_lstAllHeaders.Count - 1 do
    begin
      lstGridColumn.Items.Add(m_lstAllHeaders[I]);
      lstGridColumn.ItemChecked[I] := True;
    end;
    for I := 0 to m_lstHideColumnIndex.Count - 1 do
    begin
      lstGridColumn.ItemChecked[StrToInt(m_lstHideColumnIndex[I])] := False;
    end;
      
  finally
    lstGridColumn.Items.EndUpdate;
  end;
end;

procedure TFrmSetStringGridCol.rzbtbtnOKClick(Sender: TObject);
var
  I:Integer;
begin
  m_lstHideColumnIndex.Clear;
  for I := 0 to lstGridColumn.Items.Count - 1 do
  begin
    if not lstGridColumn.ItemChecked[I] then
    begin
      m_lstHideColumnIndex.Add(IntToStr(I));
    end;
  end;
  WriteConfigFile(m_strGridCaption,m_lstHideColumnIndex);
end;

procedure TFrmSetStringGridCol.rzbtbtnSelAllClick(Sender: TObject);
var
  I:Integer;
begin
  lstGridColumn.Items.BeginUpdate;
  try
    for I := 0 to lstGridColumn.Items.Count - 1 do
    begin
      lstGridColumn.ItemChecked[I] := True;
    end;
  finally
    lstGridColumn.Items.EndUpdate;
  end;
end;

procedure TFrmSetStringGridCol.rzbtbtnUnSelClick(Sender: TObject);
var
  I:Integer;
begin
  lstGridColumn.Items.BeginUpdate;
  try
    for I := 0 to lstGridColumn.Items.Count - 1 do
    begin
      lstGridColumn.ItemChecked[I] := not lstGridColumn.ItemChecked[I];
    end;
  finally
    lstGridColumn.Items.EndUpdate;
  end;
end;

procedure TFrmSetStringGridCol.WriteConfigFile(strSection: string;
  lstHideIndex: TStringList);
var
  I,nCount:Integer;
  iniCfg:TRzRegIniFile;
begin
  Assert(Trim(strSection) <> '');
  Assert(Assigned(lstHideIndex));

  iniCfg := TRzRegIniFile.Create(nil);
  try
    iniCfg.Path := ExtractFilePath(Application.ExeName) + C_CONFIG_FILENAME;

    nCount := iniCfg.ReadInteger(strSection,'数量',0);
    for I := 0 to nCount - 1 do
    begin
      iniCfg.DeleteKey(strSection,IntToStr(I));
    end;
  
    iniCfg.WriteInteger(strSection,'数量',lstHideIndex.Count);

    for I := 0 to lstHideIndex.Count - 1 do
    begin
      iniCfg.WriteString(strSection,IntToStr(I),lstHideIndex[I]);    
    end;
  finally
    FreeAndNil(iniCfg);
  end;
end;

end.
