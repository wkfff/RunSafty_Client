{*
 ************************************************************************
 *
 *  Copyright(c) 2005 �������ӿڵ�Ԫ
 *                   
 *
 *     ��   ��: ICIntf
 *
 *     ժ   Ҫ: ��������Ҫ��������ʾgenfunction.dll API������������
 *
 *
 *     ��������:  2003��11��27��
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
    //֧�ֵö���������
    //�ö�����ʶ��Ŀ�����������
    //�����Ϳ�����������

    //���������ݣ����ֻ�ȫ��
    //д�������ݣ����ֻ�ȫ��
  end;
  
const
  ZlgICIntf = 'genfunction.dll';

  //�򿪶�����
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

  //������
  function gen_GetCardTypeNum(): integer; stdcall;
  procedure gen_GetAllCardType(szName: TZlgStrList); stdcall;

  //���ͺ�
  function gen_GetCardNameNum(): integer; stdcall;
  procedure gen_GetAllCardName(szname: TZlgStrList); stdcall;

  //��AB
  procedure gen_GetAllCardAB(szname: TZlgStrList);

  function gen_GetHexInfo(ctype: smallint;
                          cardtype: PChar;
                          updatadate: PChar;
							            author: PChar;
                          description: PChar): integer; stdcall;
  //IC������״̬
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
