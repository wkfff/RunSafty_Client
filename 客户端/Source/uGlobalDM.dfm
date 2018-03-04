object GlobalDM: TGlobalDM
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 550
  Width = 957
  object FrameController: TRzFrameController
    Color = clWhite
    FocusColor = clWhite
    FrameColor = 7960953
    FrameHotColor = clGradientActiveCaption
    FrameHotTrack = True
    FrameVisible = True
    FramingPreference = fpCustomFraming
    Left = 144
    Top = 16
  end
  object tmrAppVersion: TTimer
    Enabled = False
    Interval = 300000
    OnTimer = tmrAppVersionTimer
    Left = 48
    Top = 96
  end
  object GSCLConnection: TADOConnection
    LoginPrompt = False
    Left = 160
    Top = 88
  end
  object TicketConnection: TSQLConnection
    ConnectionName = 'IBCONNECTION'
    DriverName = 'Interbase'
    GetDriverFunc = 'getSQLDriverINTERBASE'
    LibraryName = 'dbxint30.dll'
    LoginPrompt = False
    Params.Strings = (
      'BlobSize=-1'
      'CommitRetain=False'
      'Database=database.gdb'
      'DriverName=Interbase'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Password=masterkey'
      'RoleName=RoleName'
      'ServerCharSet='
      'SQLDialect=3'
      'Interbase TransIsolation=ReadCommited'
      'User_Name=sysdba'
      'WaitOnLocks=True')
    VendorLib = 'GDS32.DLL'
    Left = 320
    Top = 16
  end
  object LocalADOConnection: TADOConnection
    LoginPrompt = False
    Left = 232
    Top = 16
  end
  object RzLauncher: TRzLauncher
    Action = 'Open'
    Timeout = -1
    Left = 320
    Top = 80
  end
end
