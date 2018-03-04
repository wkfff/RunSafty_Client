unit uKeyTrainman;

interface
uses sysutils,classes,contnrs;
type

  //�ؼ��˲�������
   EKeyTrainmanOpt  = (KTMAdd{����},KTMModify{�޸�},KTMdel{ɾ��});

  //�ؼ��˽ṹ��ֵ���Է�װ
  RKeyTrainman = record
  public
    //id
    strGUID:string;
    //�ؼ��˹���
    strKeyTMNumber:string;
    //�ؼ�������
    strKeyTMName:string;
    //�ؼ�����������id
    strKeyTMWorkShopGUID:string;
    //�ؼ���������������
    strKeyTMWorkShopName:string;
    //�ؼ�����������id
    strKeyTMCheDuiGUID:string;
    //�ؼ���������������
    strKeyTMCheDuiName:string;
    //�ؼ��˿�ʼʱ��
    dtKeyStartTime:TDatetime;
    //�ؼ��˽�ֹʱ��
    dtKeyEndTime:TDatetime;
    //�Ǽ�ԭ��
    strKeyReason:string;
    //�Ǽ�ע������
    strKeyAnnouncements:string;
    //�Ǽ��˹���
    strRegisterNumber:string;
    //�Ǽ�������
    strRegisterName:string;
    //�Ǽ�����
    dtRegisterTime:TDateTime;
    //�ͻ��˱��
    strClientNumber:string;
    //�ͻ�������
    strClientName:string;
    //��������
    eOpt:EKeyTrainmanOpt;
  end;
  //�ؼ��˶���
  TKeyTrainman = class
  public
    //�ؼ���ֵ�ֶνṹ��
    rKeyTM :RKeyTrainman;
  public
    //��¡
    procedure Clone(keyMan:TKeyTrainman);
  end;

  //�ؼ����б�
  TKeyTrainmanList = class(TObjectList)
  protected
    function GetItem(Index: Integer): TKeyTrainman;
    procedure SetItem(Index: Integer; AObject: TKeyTrainman);
  public
    function Add(AObject: TKeyTrainman): Integer;
    property Items[Index: Integer]: TKeyTrainman read GetItem write SetItem; default;
  end;




implementation

{ TKeyTrainmanList }

function TKeyTrainmanList.Add(AObject: TKeyTrainman): Integer;
begin
  result := inherited Add(AObject);
end;

function TKeyTrainmanList.GetItem(Index: Integer): TKeyTrainman;
begin
  result := TKeyTrainman(inherited GetItem(Index));
end;

procedure TKeyTrainmanList.SetItem(Index: Integer; AObject: TKeyTrainman);
begin
  inherited SetItem(Index,AObject);
end;

{ TKeyTrainman }

procedure TKeyTrainman.Clone(keyMan: TKeyTrainman);
begin
  Self.rKeyTM := keyMan.rKeyTM;
end;

end.
