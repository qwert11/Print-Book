unit Option;

interface

uses
  BookOption_;

type

  ForTask = record
    CountPages,
    FirstPage,
    EndPage: Integer;
    All, // ���
    LAll, RAll, // ����� ������
    BAll, FAll, // ������ ��������
    LFront, LBack, // ����� ������ �������� ������
    RFront, RBack: TPageOption;

  end;

  TOption = class
  // ����� ������ ����� �������� ���������� ������ � ����

  end;

implementation

end.
