object DMCallRoom: TDMCallRoom
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 246
  Width = 409
  object ADOConn: TADOConnection
    LoginPrompt = False
    Left = 40
    Top = 16
  end
end
