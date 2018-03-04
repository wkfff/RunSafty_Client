unit uWriteCardControler;

interface
uses uSiWeiICKGLControler, uZZKDXKControler,uSiWeiKDXKControler,
    uCardControlerBase,uWriteICCarSoftDefined;


{���ܣ�ͨ����ͬ��������Ҳ�����������Ӧ�Ĳ���������ʵ��}
function WriteCardContorler(ICCorpration:TICCorpration):TCardContorler;

implementation

function WriteCardContorler(ICCorpration:TICCorpration):TCardContorler;
{���ܣ�ͨ����ͬ��������Ҳ�����������Ӧ�Ĳ���������ʵ��}
begin
  Result := Nil;
  case ICCorpration of
    SiWeiIckgl: Result := TSiWeiIckglControler.Create;
    SiWeiKDXK: Result := TSiWeiKDXKControler.create ;
    ZZKDXK: Result := TZZKDXKControler.create;
  end;
end;


end.
