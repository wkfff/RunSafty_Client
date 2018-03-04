unit uMealTicket;

interface
{��Ʊ�ṹ��}

uses
  SysUtils;

const
  //��͵�ʱ��
  BREAKFAST_MIN_HOUR = 6 ;
  BREAKFAST_MAX_HOUR = 9 ;
  {
  LUNCH_MIN_HOUR = 09:00;
  LUNCH_MAX_HOUR = 23:59  ;

  DINNER_MIN_HOUR = 00:00;
  DINNER_MAX_HOUR = 05:59;
  }



type
  {��Ʊ�ṹ��}
  RRsMealTicket = record
    ID: integer;
    CANJUAN_INFO_ID :Integer;
    PAIBAN_INFO_ID:Integer;
    PAIBAN_STR:string;            //ʱ��+����

    DRIVER_CODE:string;
    DRIVER_NAME:string;
    CHEJIAN_NAME:string;

    CANQUAN_A:SmallInt;             //��ͷ�Ʊ����
    CANQUAN_B:SmallInt;             //���ͷ�Ʊ����
    CANQUAN_C:SmallInt;             //��ͷ�Ʊ����
    
    PAIBAN_CHECI :string;
    CHUQIN_TIME :string;
    CHUQIN_YEAR :Integer;
    CHUQIN_MONTH :SmallInt;
    CHUQIN_DAY :SmallInt;
    CHUQIN_YMD:Integer;
    CHUQIN_DEPART :string;

    SHENHEREN_CODE:string;
    SHENHEREN_NAME:string;
    CHECK_FLAG :SmallInt;

    REC_TIME :string;
  end;

  PMealTicket = ^RRsMealTicket;
  TRsMealTicketList = array of RRsMealTicket;


  {
    [����]//����    �����6--9�� : 3 ������ȯ + 1 �����ȯ      ����4������ȯ
    [����]//����    �����6--9�� : 2 ������ȯ + 1 �����ȯ      ����3������ȯ
    [С��]   �����6--9�� : 1 ������ȯ + 1 �����ȯ      ����2������ȯ
    [�ͳ�]  3��
  }

  TRsMealType = (mtBreakFast{���},mtLunch{���},mtDinner{���},mtOther);

  TMealTicketOperate = class
  public
    //��ȡ��Ʊ����
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);virtual;abstract;
  end;



  {������Ʊ������}
  THuoCheMealTicketOperate = class(TMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;

  //���߻���
  TEastHuoCheMealTicketOperate = class(THuoCheMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;

  //���߻���
  TWeastHuoCheMealTicketOperate = class(THuoCheMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;


  {�ͳ���Ʊ������}
  TKeCheMealTicketOperate = class(TMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;


  {С����Ʊ������}
  TDiaoCheMealTicketOperate = class(TMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;



implementation

{ THuoCheMealTicket }

procedure THuoCheMealTicketOperate.GetTicket(MealType:TRsMealType;
  var MealTicket: RRsMealTicket);
begin
   ;
end;

{ TDiaoCheMealTicket }

procedure TDiaoCheMealTicketOperate.GetTicket(MealType:TRsMealType;
  var MealTicket: RRsMealTicket);
begin
  case MealType of
  mtBreakFast :
    begin
      MealTicket.CANQUAN_A := 1 ;
      MealTicket.CANQUAN_B := 1 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtLunch :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 2 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtDinner :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 2 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  else
    ;
  end;
end;

{ TEastHuoCheMealTicket }

procedure TEastHuoCheMealTicketOperate.GetTicket(MealType:TRsMealType;
  var MealTicket: RRsMealTicket);
begin
  case MealType of
  mtBreakFast :
    begin
      MealTicket.CANQUAN_A := 1 ;
      MealTicket.CANQUAN_B := 3 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtLunch :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 4 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtDinner :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 4 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  else
    ;
  end;
end;

{ TWeastHuoCheMealTicket }

procedure TWeastHuoCheMealTicketOperate.GetTicket(MealType:TRsMealType;
  var MealTicket: RRsMealTicket);
begin
  case MealType of
  mtBreakFast :
    begin
      MealTicket.CANQUAN_A := 1 ;
      MealTicket.CANQUAN_B := 2 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtLunch :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 3 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  mtDinner :
    begin
      MealTicket.CANQUAN_A := 0 ;
      MealTicket.CANQUAN_B := 3 ;
      MealTicket.CANQUAN_C := 0 ;
    end;
  else
    ;
  end;
end;

{ TKeCheMealTicket }

procedure TKeCheMealTicketOperate.GetTicket(MealType:TRsMealType;
  var MealTicket: RRsMealTicket);
begin
  MealTicket.CANQUAN_A := 0 ;
  MealTicket.CANQUAN_B := 3 ;
  MealTicket.CANQUAN_C := 0 ;
end;

end.
