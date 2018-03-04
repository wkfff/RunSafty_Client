unit uFrmThirdInfo;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, RzLabel, StdCtrls, ExtCtrls, RzPanel;

type
  TframeThirdInfo = class(TFrame)
    RzPanel12: TRzPanel;
    lblContent: TLabel;
    RzPanel14: TRzPanel;
    Label39: TLabel;
    lblResult: TRzLabel;
    RzPanel13: TRzPanel;
    Label38: TLabel;
    lblItemName: TRzLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;
  procedure ShowThirdInfo(Parent:TWinControl;CtrlName,ItemName,ItemContent:string;
    IsOk : boolean;nIsHold: Integer = 1);
implementation
  procedure ShowThirdInfo(Parent:TWinControl;CtrlName,ItemName,ItemContent:string;
    IsOk : boolean;nIsHold: Integer = 1);
  var
    frameThirdInfo :TframeThirdInfo;
    h1,h2 : integer;
  begin
    frameThirdInfo :=TframeThirdInfo.Create(Parent);
    frameThirdInfo.Name := CtrlName;
    frameThirdInfo.lblItemName.Caption := ItemName;
    frameThirdInfo.lblContent.Caption := ItemContent;
    frameThirdInfo.Top := 10000;
    if IsOk then
    begin
      frameThirdInfo.lblResult.Caption := '验证通过';
      frameThirdInfo.lblResult.Font.Color := clGreen;
    end else begin
      frameThirdInfo.lblResult.Caption := '验证失败';
      if nIsHold > 0 then      
        frameThirdInfo.lblResult.Font.Color := clRed
      else
        frameThirdInfo.lblResult.Font.Color := clOlive;
    end;
    h1 :=  frameThirdInfo.lblItemName.Height;
    h1 := h1 + 20;

    h2 :=  frameThirdInfo.lblContent.Height;
    h2 := h2 + 20;

    if h1 > h2 then
      frameThirdInfo.Height := h1
    else
      frameThirdInfo.Height := h2;
      
    frameThirdInfo.Parent := Parent;
    frameThirdInfo.align := alTop;
  end;
{$R *.dfm}

end.
