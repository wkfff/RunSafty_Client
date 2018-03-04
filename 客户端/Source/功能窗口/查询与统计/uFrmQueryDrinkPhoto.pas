unit uFrmQueryDrinkPhoto;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, ActnList,uDataModule;

type
  TfrmQueryDrinkPhoto = class(TForm)
    Image1: TImage;
    ActionList1: TActionList;
    actEsc: TAction;
    procedure actEscExecute(Sender: TObject);
  private
    { Private declarations }
    m_strDrinkGUID : string;
    procedure SetDrinkGUID(const Value: string);
  public
    { Public declarations }
    property DrinkGUID : string read m_strDrinkGUID write SetDrinkGUID;
  end;

var
  frmQueryDrinkPhoto: TfrmQueryDrinkPhoto;

implementation
uses
  uDrink;
{$R *.dfm}

procedure TfrmQueryDrinkPhoto.actEscExecute(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfrmQueryDrinkPhoto.SetDrinkGUID(const Value: string);
var
  drink : RDrink;
  filename: string;
begin
  m_strDrinkGUID := Value;
  drink := TDrinkOpt.GetDrink(m_strDrinkGUID);

  //(ãÆ)
  filename := drink.TrainmanNumber +
      FormatDateTime('yyyymmddhhnnss',drink.CreateTime) + '.jpg';
  try
    if not FileExists(DMGlobal.AppPath + '\temp\' + filename) then
    begin
      if not DMGlobal.FTPCon.DownLoad(filename,True) then
      begin
        if FileExists(DMGlobal.AppPath + '\temp\' + filename) then
          DeleteFile(DMGlobal.AppPath + '\temp\' + filename);
      end;
    end;
    Image1.Picture.Assign(nil);
    if not FileExists(DMGlobal.AppPath + '\temp\' + filename) then Exit;
    Image1.Picture.LoadFromFile(DMGlobal.AppPath + '\temp\' + filename);
    //Image1.Picture.Assign(drink.DrinkImage);
  finally
    drink.Free;
  end;
end;

end.
