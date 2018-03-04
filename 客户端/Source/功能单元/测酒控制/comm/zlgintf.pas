{*
 ************************************************************************
 *
 *  Copyright(c) 2005 读卡器接口单元
 *                   
 *
 *     文   件: ICIntf
 *
 *     摘   要: 本程序主要是垃圾演示genfunction.dll API函数参数方法
 *
 *
 *     创建日期:  2003年11月27日
 *
 *************************************************************************
 *}
 
unit zlgintf;

interface

uses
  windows, Classes;

type
  TICReader = (crNone, crZlg, crOv);

  TZlgStrList = array of array[0..49] of char;

  TICReader0 = class

  public
    //支持得读卡器种类
    //该读卡器识别的卡的所有类型
    //该类型卡的特性描述

    //读卡的数据，部分或全部
    //写卡的数据，部分或全部
  end;
  
const
  ZlgICIntf = 'genfunction.dll';

  //打开读卡器
  function CreateReader(Reader: TICReader): Cardinal;
  procedure DestroyReader(IcDev: Cardinal);



  function gen_Beep(): SmallInt; stdcall;

  function gen_Read(CType:smallint;
                    command:pchar;
                    addr:pchar;
                    recbuff:pchar;
                    nreclen:smallint): SmallInt; stdcall;

  function gen_Write(ctype:smallint;
                     command:pchar;
                     addr:pchar;
                     sendbuff:pchar;
                     nsendlen:smallint): SmallInt; stdcall;

  function auto_init(port:smallint; baud:longint):longint; stdcall;
  function ic_init(port:smallint; baud:longint):longint; stdcall;

  function ic_exit(icdev:longint): SmallInt; stdcall;

  //卡类型
  function gen_GetCardTypeNum(): integer; stdcall;
  procedure gen_GetAllCardType(szName: TZlgStrList); stdcall;

  //卡型号
  function gen_GetCardNameNum(): integer; stdcall;
  procedure gen_GetAllCardName(szname: TZlgStrList); stdcall;

  //卡AB
  procedure gen_GetAllCardAB(szname: TZlgStrList);

  function gen_GetHexInfo(ctype: smallint;
                          cardtype: PChar;
                          updatadate: PChar;
							            author: PChar;
                          description: PChar): integer; stdcall;
  //IC卡插入状态
  function get_status(icdev:longint; state: pSmallInt): SmallInt; stdcall;

  // 


implementation


function gen_Beep; external ZlgICIntf;
function gen_Read; external ZlgICIntf;
function gen_Write; external ZlgICIntf;

function auto_init; external ZlgICIntf;
function ic_init; external ZlgICIntf;
function ic_exit;external ZlgICIntf;


function gen_GetCardTypeNum; external ZlgICIntf;
procedure gen_GetAllCardType; external ZlgICIntf;

function gen_GetCardNameNum; external ZlgICIntf;
procedure gen_GetAllCardName; external ZlgICIntf;

procedure gen_GetAllCardAB; external ZlgICIntf;

function gen_GetHexInfo; external ZlgICIntf;

function get_status; external ZlgICIntf;


function CreateReader(Reader: TICReader): Cardinal;
begin
  result := ic_init(0, 0);
end;

procedure DestroyReader(IcDev: Cardinal);
begin
  if IcDev <= 0 then exit;

  ic_exit(IcDev);
end;


end.
