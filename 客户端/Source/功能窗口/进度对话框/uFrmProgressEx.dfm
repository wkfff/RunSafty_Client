object frmProgressEx: TfrmProgressEx
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  Caption = #36827#24230
  ClientHeight = 155
  ClientWidth = 510
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #23435#20307
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poDesktopCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object RzPanel1: TRzPanel
    Left = 0
    Top = 0
    Width = 510
    Height = 155
    Align = alClient
    BorderOuter = fsGroove
    BorderWidth = 1
    GradientColorStyle = gcsCustom
    GradientColorStart = 13413521
    GradientColorStop = 16118250
    TabOrder = 0
    VisualStyle = vsGradient
    object ProgressBar: TRzProgressBar
      Left = 40
      Top = 80
      Width = 425
      BorderWidth = 0
      InteriorOffset = 0
      PartsComplete = 0
      Percent = 0
      TotalParts = 0
    end
    object LblText: TLabel
      Left = 93
      Top = 43
      Width = 63
      Height = 16
      Caption = 'LblText'
      Font.Charset = GB2312_CHARSET
      Font.Color = 4934475
      Font.Height = -16
      Font.Name = #23435#20307
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
    end
    object TFRotationPicture1: TTFRotationPicture
      Left = 40
      Top = 32
      Width = 40
      Height = 40
      Algle = 42312
      Animate = True
      Delay = 50
      AutoSize = True
      Picture.Data = {
        0A54504E474F626A65637489504E470D0A1A0A0000000D494844520000002800
        00002808060000008CFEB86D0000001974455874536F6674776172650041646F
        626520496D616765526561647971C9653C000001D24944415478DAD5988155C2
        301086AF1B3842D900265037C009AC1BC004E204BA8130016C204E001BC0086C
        80F7DBCBF3286D932BE579FCEFFD8FB624E9D75CAE49931D8F47F2AC0C805996
        F5D1562EBFFBCAF1BF018ED9F7EC07F650AEBDB167E257B9B665AFD9DFECD5B5
        01EFD813F6B3EA25AD3A40AD3D7BC1FE601FFA062CD8EF02D9A4186010E0A6EC
        791F8000FAA432A431A5020621E42FD4D29B29805F548EB3145901A135FBF112
        C0A140B685B62BE041E0B65640C02CA91C275B03A40550C3A17D8CEF27AA84BB
        091070E39A4662909624A96B772590AD80059549116BAC2B60AC3D24CDBC0910
        05773500A99031C09476506620BF6780973C790CB04B24CE00D17B3935ABEE26
        242159D06936E27FCC38859C5BC6F25E7AF1041049B1A4B8AA90076A5F14E402
        63791B4048969506449A4F122A562153658183305F4F35E086FE5625298023B2
        2DA772B9472A201E7EA4012D2BD7DFA733940FB24409CA02209E6E67A838225B
        788310A18DA1FC400316868AB30E705DEACEFB5CF25F4537D38300743D0671E2
        3A8B896EE03DE87E26713F1743AE5733D08C9CAF07DDAFA8899C7F9304B9FEAA
        23BA81EF622D973B0B5AEEF766DCEF6E0515E4747F50CBF50E6B552EF7A8DB94
        AB5ED2C717E907888266B5CE1DDC1A0000000049454E44AE426082}
    end
  end
end
