unit uApparatusCommon;

interface
uses Classes;

type
  {TTestAlcoholResult 测酒结果}
  TTestAlcoholResult = (taNormal{测酒正常},taAlcoholContentMiddling{酒精含量中},
      taAlcoholContentHeight{酒精含量高},taNoTest{未测试},tsError{测试故障});

  {RTestAlcoholInfo 测酒信息结构体}
  RTestAlcoholInfo = Record
    taTestAlcoholResult : TTestAlcoholResult;//测酒结果
    Picture : TMemoryStream;//照片
    dtTestTime : TDateTime;//测试时间
  end;

function TestAlcoholResultToString(TestAlcoholResult : TTestAlcoholResult):String;
{功能:测酒结果类型转换字符串}

implementation

function TestAlcoholResultToString(TestAlcoholResult : TTestAlcoholResult):String;
{功能:测酒结果类型转换字符串}
begin
  Result := '';
  case TestAlcoholResult of
    taNormal : Result := '正常';
    taAlcoholContentMiddling : Result := '饮酒';
    taAlcoholContentHeight : Result := '酗酒';
    taNoTest : Result := '未测试';
    tsError : Result := '测试故障';
  end;
end;


end.
