unit uSectionReadAdapter;

interface
uses Classes, uTFSystem ,uTableOperate, uWriteICCarSoftDefined, uSection, uArea,
    SysUtils;

type
  //////////////////////////////////////////////////////////////////////////////
  ///  ����:TSectionReadAdapter
  ///  ˵��:���μ���������
  //////////////////////////////////////////////////////////////////////////////
  TSectionReadAdapter = class
  public
    {����:����XKSet.ini}
    procedure SetXKSetIniFile(XKSetFileName,strWriteCardSoftPath:String;
        ICCorpration:TICCorpration);
    {����:��ȡ����}
    procedure ReadSection(var SectionList:TSectionList;Area:TArea);
  end;




implementation

  {���ܣ���ȡ����������Ϣ}
  function GetYyqdInfos(var YunYongQuDuanBaseInfos: Tlist):Boolean; stdcall;
      external 'PjtKDXKInterface.dll';
  {���ܣ���ʼ����̬��}
  procedure Initialize(); stdcall; external 'PjtKDXKInterface.dll';
  {���ܣ�ж�ض�̬��}
  procedure UnInitialize(); stdcall; external 'PjtKDXKInterface.dll';

{ TSectionReadAdapter }

procedure TSectionReadAdapter.ReadSection(var SectionList: TSectionList;Area:TArea);
{����:��ȡ����}
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
      WriteIniFile(XKSetFileName,'������Ϣ','�汾','1');
    end;
    ZZKDXK :
    begin
      WriteIniFile(XKSetFileName,'������Ϣ','�汾','2');
    end
  else
    Exit;
  end;
  if strWriteCardSoftPath <> '' then
  begin
    if strWriteCardSoftPath[length(strWriteCardSoftPath)] <> '\' then
      strWriteCardSoftPath := strWriteCardSoftPath + '\';
  end;
  WriteIniFile(XKSetFileName,'������Ϣ','�����',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'������Ϣ','��������',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'������Ϣ','��������',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'������Ϣ','��ʾ�ļ�',strWriteCardSoftPath+'data\');
  WriteIniFile(XKSetFileName,'������Ϣ','���û����','1');
  WriteIniFile(XKSetFileName,'������Ϣ','������������','1');
  WriteIniFile(XKSetFileName,'������Ϣ','���õ�������','1');
  WriteIniFile(XKSetFileName,'������Ϣ','���ý�ʾ�ļ�','0');
  WriteIniFile(XKSetFileName,'������Ϣ','������MDB���ݿ�','1');
  WriteIniFile(XKSetFileName,'������Ϣ','SQLSERVER���ݿ�','0');
  WriteIniFile(XKSetFileName,'������Ϣ','������IP','.');
  if ICCorpration = SiWeiKDXK then
    WriteIniFile(XKSetFileName,'������Ϣ','���ݿ���','swkdxk')
  else
    WriteIniFile(XKSetFileName,'������Ϣ','���ݿ���','kdxk');
  WriteIniFile(XKSetFileName,'������Ϣ','�û���','sa');
  WriteIniFile(XKSetFileName,'������Ϣ','����','');
end;

end.
