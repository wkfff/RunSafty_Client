unit uFrmChuQinBaseSet;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, RzLabel, Mask, RzEdit, RzButton, RzRadChk, RzCommon,
  uRunSaftyDefine;

type
  RChuQinBaseSet = packed record
    /// <summary>�������Ѽ��</summary>
    ChuQinCheck:RItemUseConfig;
    /// <summary>��Ԣ���Ѽ��</summary>
    LiYuCheck:RItemUseConfig;
  end;

  TFrmChuQinBaseSet = class(TFrame)
    rzchckbxChuQinTip: TRzCheckBox;
    edtChuQin: TRzNumericEdit;
    lbl1: TRzLabel;
    rzchckbxLiYu: TRzCheckBox;
    edtLiYu: TRzNumericEdit;
    lbl2: TRzLabel;
  private
    m_ConfigInfo:RChuQinBaseSet;
  public
    procedure UpdateUIInfo(cfgInfo:RChuQinBaseSet);
    function ReadConfig:RChuQinBaseSet;
    procedure SaveConfig;
  published
    property ConfigInfo:RChuQinBaseSet read m_ConfigInfo;
  const C_CHUQIN_SET_SECTION = '��������';
  end;

implementation

{$R *.dfm}

{ TFrmChuQinBaseSet }

function TFrmChuQinBaseSet.ReadConfig:RChuQinBaseSet;
var
  iniCfg:TRzRegIniFile;
begin
  iniCfg := TRzRegIniFile.Create(nil);
  try
    Result.ChuQinCheck.bIsUsed := iniCfg.ReadBool(C_CHUQIN_SET_SECTION,'���ڳ�ʱ���',False);
    Result.ChuQinCheck.nValue := iniCfg.ReadInteger(C_CHUQIN_SET_SECTION,'���ڳ�ʱ���ֵ',20);
    Result.LiYuCheck.bIsUsed := iniCfg.ReadBool(C_CHUQIN_SET_SECTION,'��Ԣ��ʱ���',False);
    Result.LiYuCheck.nValue := iniCfg.ReadInteger(C_CHUQIN_SET_SECTION,'��Ԣ��ʱ���ֵ',20);
    m_ConfigInfo := Result;
  finally
    FreeAndNil(iniCfg);
  end;
end;

procedure TFrmChuQinBaseSet.SaveConfig;
var
  iniCfg:TRzRegIniFile;
begin
  iniCfg := TRzRegIniFile.Create(nil);
  try
    m_ConfigInfo.ChuQinCheck.bIsUsed := rzchckbxChuQinTip.Checked;
    m_ConfigInfo.ChuQinCheck.nValue := edtChuQin.IntValue;
    m_ConfigInfo.LiYuCheck.bIsUsed := rzchckbxLiYu.Checked;
    m_ConfigInfo.LiYuCheck.nValue := edtLiYu.IntValue;

    iniCfg.WriteBool(C_CHUQIN_SET_SECTION,'���ڳ�ʱ���',m_ConfigInfo.ChuQinCheck.bIsUsed);
    iniCfg.WriteInteger(C_CHUQIN_SET_SECTION,'���ڳ�ʱ���ֵ',m_ConfigInfo.ChuQinCheck.nValue); 
    iniCfg.WriteBool(C_CHUQIN_SET_SECTION,'��Ԣ��ʱ���',m_ConfigInfo.LiYuCheck.bIsUsed);
    iniCfg.WriteInteger(C_CHUQIN_SET_SECTION,'��Ԣ��ʱ���ֵ',m_ConfigInfo.LiYuCheck.nValue);
  finally
    FreeAndNil(iniCfg);
  end;
end;

procedure TFrmChuQinBaseSet.UpdateUIInfo(cfgInfo: RChuQinBaseSet);
begin   
  rzchckbxChuQinTip.Checked := cfgInfo.ChuQinCheck.bIsUsed;
  edtChuQin.IntValue := cfgInfo.ChuQinCheck.nValue;
  rzchckbxLiYu.Checked := cfgInfo.LiYuCheck.bIsUsed;
  edtLiYu.IntValue := cfgInfo.LiYuCheck.nValue;

end;

end.
