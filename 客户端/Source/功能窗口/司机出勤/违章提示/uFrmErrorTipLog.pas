unit uFrmErrorTipLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, RzEdit, RzButton, SyncObjs;

type
  TFrmErrorTipLog = class(TForm)
    rzbtbtnRefresh: TRzBitBtn;
    edtResult: TRzRichEdit;
    rzbtbtnClose: TRzBitBtn;
    procedure rzbtbtnRefreshClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    /// <summary>到时还未出勤的司机提醒信息</summary>
    m_strUnChuQinList:TStringList;
    /// <summary>到时还未离寓的司机提醒信息</summary>
    m_strUnLiYuList:TStringList;
    m_strUnChuQinListCrt:TCriticalSection;
    m_strUnLiYuListCrt:TCriticalSection;
  private
    procedure UpdateResult;
  published
    property UnChuQinList:TStringList read m_strUnChuQinList write m_strUnChuQinList;
    property UnLiYuList:TStringList read m_strUnLiYuList write m_strUnLiYuList;
    property UnChuQinListCrt:TCriticalSection read m_strUnChuQinListCrt write m_strUnChuQinListCrt;
    property UnLiYuListCrt:TCriticalSection read m_strUnLiYuListCrt write m_strUnLiYuListCrt;
  end;

implementation

{$R *.dfm}

{ TFrmErrorTipLog }

procedure TFrmErrorTipLog.FormShow(Sender: TObject);
begin
  UpdateResult;
end;

procedure TFrmErrorTipLog.rzbtbtnRefreshClick(Sender: TObject);
begin
  UpdateResult;
end;

procedure TFrmErrorTipLog.UpdateResult;
var
  I:Integer;
begin
  edtResult.Lines.BeginUpdate;
  try
    edtResult.Lines.Clear;
    m_strUnLiYuListCrt.Enter;
    try
      for I := 0 to m_strUnLiYuList.Count - 1 do
      begin
        edtResult.Lines.Add(m_strUnLiYuList[I]);
      end;
    finally
      m_strUnLiYuListCrt.Leave;
    end;
    m_strUnChuQinListCrt.Enter;
    try
      for I := 0 to m_strUnChuQinList.Count - 1 do
      begin
        edtResult.Lines.Add(m_strUnChuQinList[I]);
      end;
    finally
      m_strUnChuQinListCrt.Leave;
    end;
  finally
    edtResult.Lines.EndUpdate;
  end;
end;

end.
