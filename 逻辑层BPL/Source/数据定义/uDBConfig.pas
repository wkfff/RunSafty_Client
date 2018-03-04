unit uDBConfig;

interface
const
  DBConnFormat = 'Data Source=%s;User ID=%s;Password=%s;Initial Catalog=%s;Provider=SQLOLEDB.1;Persist Security Info=False';
type
  RDBConfig = record
    Host : string;
    User : string;
    PWD  : string;
    DBName : string;
  end;
implementation

end.
