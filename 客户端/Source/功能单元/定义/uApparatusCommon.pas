unit uApparatusCommon;

interface
uses Classes;

type
  {TTestAlcoholResult ��ƽ��}
  TTestAlcoholResult = (taNormal{�������},taAlcoholContentMiddling{�ƾ�������},
      taAlcoholContentHeight{�ƾ�������},taNoTest{δ����},tsError{���Թ���});

  {RTestAlcoholInfo �����Ϣ�ṹ��}
  RTestAlcoholInfo = Record
    taTestAlcoholResult : TTestAlcoholResult;//��ƽ��
    Picture : TMemoryStream;//��Ƭ
    dtTestTime : TDateTime;//����ʱ��
  end;

function TestAlcoholResultToString(TestAlcoholResult : TTestAlcoholResult):String;
{����:��ƽ������ת���ַ���}

implementation

function TestAlcoholResultToString(TestAlcoholResult : TTestAlcoholResult):String;
{����:��ƽ������ת���ַ���}
begin
  Result := '';
  case TestAlcoholResult of
    taNormal : Result := '����';
    taAlcoholContentMiddling : Result := '����';
    taAlcoholContentHeight : Result := '���';
    taNoTest : Result := 'δ����';
    tsError : Result := '���Թ���';
  end;
end;


end.
