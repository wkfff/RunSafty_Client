unit uWriteCardControler;

interface
uses uSiWeiICKGLControler, uZZKDXKControler,uSiWeiKDXKControler,
    uCardControlerBase,uWriteICCarSoftDefined;


{功能：通过不同的软件厂家参数，返回相应的操作制作类实例}
function WriteCardContorler(ICCorpration:TICCorpration):TCardContorler;

implementation

function WriteCardContorler(ICCorpration:TICCorpration):TCardContorler;
{功能：通过不同的软件厂家参数，返回相应的操作制作类实例}
begin
  Result := Nil;
  case ICCorpration of
    SiWeiIckgl: Result := TSiWeiIckglControler.Create;
    SiWeiKDXK: Result := TSiWeiKDXKControler.create ;
    ZZKDXK: Result := TZZKDXKControler.create;
  end;
end;


end.
