unit Option;

interface

uses
  BookOption_;

type

  ForTask = record
    CountPages,
    FirstPage,
    EndPage: Integer;
    All, // все
    LAll, RAll, // левые правые
    BAll, FAll, // задние передние
    LFront, LBack, // левые правые передние задние
    RFront, RBack: TPageOption;

  end;

  TOption = class
  // класс должен иметь свойство считывания записи в файл

  end;

implementation

end.
