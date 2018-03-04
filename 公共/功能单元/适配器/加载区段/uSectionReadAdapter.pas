unit uSectionReadAdapter;

interface
uses Classes, uTFSystem ,uTableOperate, uWriteICCarSoftDefined, uSection, uArea,
    SysUtils;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  类名:TSectionReadAdapter
  ///  说明:区段加载适配器
  //////////////////////////////////////////////////////////////////////////////
  TSectionReadAdapter = class
  public
    {功能:设置XKSet.ini}
    procedure SetXKSetIniFile(XKSetFileName,strWriteCardSoftPath:String;
        ICCorpration:TICCorpration);
    {功能:读取区段}
    procedure ReadSection(var SectionList:TSectionList;Area:TArea);
  end;




implementation

  {功能：获取运用区段信息}
  function GetYyqdInfos(var YunYongQuDuanBaseInfos: Tlist):Boolean; stdcall;
      external 'PjtKDXKInterface.dll';
  {功能：初始化动态库}
  procedure Initialize(); stdcall; external 'PjtKDXKInterface.dll';
  {功能：卸载动态库}
  procedure UnInitialize(); stdcall; external 'PjtKDXKInterface.dll';

{ TSectionReadAdapter }

procedure TSectionReadAdapter.ReadSection(var SectionList: TSectionList;Area:TArea);
{功能:读取区段}
var
  i : Integer;
  ltSections : TList;
  nJWDID : Integer;
  Section : TSection;
begin
  ltSections := TList.Create;
  SectionList.Clear;
  try
    Initialize();
    if GetYyqdInfos(ltSections) then
    begin
      for I := 0 to ltSections.Count - 1 do
      begin
        if TryStrToInt(Area.JWDNumber,nJWDID) = False then Continue;
        if PYunYongQuDuanBaseInfo(ltSections.Items[i]).m_nJWDID = nJWDID then
        begin
          Section := TSection.Create;
          Section.SectionGUID := NewGUID;
          Section.SectionName :=
              PYunYongQuDuanBaseInfo(ltSections.Items[i]).m_strName;
          Section.AreaGUID := Area.AreaGUID;
          Section.AreaName := Area.AreaName;
          SectionList.Add(Section);
        end;
      end;
    end;
  finally
    while ltSections.Count > 0 do
    begin
      Dispose(PYunYongQuDuanBaseInfo(ltSections.Items[0]));
      ltSections.Delete(0);
    end;
    ltSections.Free;
    UnInitialize();
  end;
end;

procedure TSectionReadAdapter.SetXKSetIniFile(
      XKSetFileName,strWriteCardSoftPath:String;ICCorpration:TICCorpration);
begin
  case ICCorpration of
    SiWeiKDXK :
    begin
      WriteIniFile(XKSetFileName,'基本信息','版本','1');
    end;
    ZZKDXK :
    begin
      WriteIniFile(XKSetFileName,'基本信息','版本','2');
    end
  else
    Exit;
  end;
  if strWriteCardSoftPath <> '' then
  begin
    if strWriteCardSoftPath[length(strWriteCardSoftPath)] <> '\' then
      strWriteCardSoftPath := strWriteCardSoftPath + '\';
  end;
  WriteIniFile(XKSetFileName,'基本信息','机务段',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'基本信息','运用区段',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'基本信息','调度命令',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'基本信息','揭示文件',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'基本信息','启用机务段','1');
  WriteIniFile(XKSetFileName,'基本信息','启用运用区段','1');
  WriteIniFile(XKSetFileName,'基本信息','启用调度命令','1');
  WriteIniFile(XKSetFileName,'基本信息','启用揭示文件','0');
  WriteIniFile(XKSetFileName,'基本信息','单机版MDB数据库','1');
  WriteIniFile(XKSetFileName,'基本信息','SQLSERVER数据库','0');
  WriteIniFile(XKSetFileName,'基本信息','服务器IP','.');
  if ICCorpration = SiWeiKDXK then
    WriteIniFile(XKSetFileName,'基本信息','数据库名','swkdxk')
  else
    WriteIniFile(XKSetFileName,'基本信息','数据库名','kdxk');
  WriteIniFile(XKSetFileName,'基本信息','用户名','sa');
  WriteIniFile(XKSetFileName,'基本信息','密码','');
end;

end.
