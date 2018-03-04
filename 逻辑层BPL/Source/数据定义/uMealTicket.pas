unit uMealTicket;

interface
{饭票结构体}

uses
  SysUtils;

const
  //早餐的时间
  BREAKFAST_MIN_HOUR = 6 ;
  BREAKFAST_MAX_HOUR = 9 ;
  {
  LUNCH_MIN_HOUR = 09:00;
  LUNCH_MAX_HOUR = 23:59  ;

  DINNER_MIN_HOUR = 00:00;
  DINNER_MAX_HOUR = 05:59;
  }



type
  {饭票结构体}
  RRsMealTicket = record
    ID: integer;
    CANJUAN_INFO_ID :Integer;
    PAIBAN_INFO_ID:Integer;
    PAIBAN_STR:string;            //时间+车次

    DRIVER_CODE:string;
    DRIVER_NAME:string;
    CHEJIAN_NAME:string;

    CANQUAN_A:SmallInt;             //早餐饭票张数
    CANQUAN_B:SmallInt;             //正餐饭票张数
    CANQUAN_C:SmallInt;             //晚餐饭票张数
    
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
    [货车]//东线    如果是6--9点 : 3 张正餐券 + 1 张早餐券      其他4张正餐券
    [货车]//西线    如果是6--9点 : 2 张正餐券 + 1 张早餐券      其他3张正餐券
    [小调]   如果是6--9点 : 1 张正餐券 + 1 张早餐券      晚上2张正餐券
    [客车]  3张
  }

  TRsMealType = (mtBreakFast{早餐},mtLunch{午餐},mtDinner{晚餐},mtOther);

  TMealTicketOperate = class
  public
    //获取饭票张数
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);virtual;abstract;
  end;



  {货车饭票操作类}
  THuoCheMealTicketOperate = class(TMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;

  //东线货车
  TEastHuoCheMealTicketOperate = class(THuoCheMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;

  //西线货车
  TWeastHuoCheMealTicketOperate = class(THuoCheMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;


  {客车饭票操作类}
  TKeCheMealTicketOperate = class(TMealTicketOperate)
  public
    procedure GetTicket(MealType:TRsMealType;var  MealTicket:RRsMealTicket);override;
  end;


  {小调饭票操作类}
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
