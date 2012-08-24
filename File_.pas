unit File_;

interface

uses
  SysUtils, Classes;

procedure FindFileToList(Patch: string; FL: TStringList);

implementation

const
  ExtBeforeImage = '.bmp';
  Separators = ['(', ')', '[', ']', '{', '}'];
  //mn = [break, continue];

procedure FindFileToList(Patch: string; FL: TStringList);
var
  FileList: TStringList;
  SearchRec: TSearchRec;
begin
  FileList := TStringList.Create;
  if Patch[Length(Patch)] <> '\' then
    Patch := Patch + '\';
  try
    if FindFirst(Patch + '*.*', faAnyFile, SearchRec) = 0
    then
      try
        while FindNext(SearchRec) = 0 do
          begin
            // для проверки с ExtBeforeImage
            if CompareText( ExtractFileExt(SearchRec.FindData.cFileName),
                ExtBeforeImage) = 0
            then
              // из FileList мы перенесем получившие названия в Мемо
              FileList.Add(SearchRec.FindData.cFileName);
          end;
      finally
        FindClose(SearchRec);
      end;
    //FileList.Sort;
    //Memo1.Lines.Assign(FileList);
    FL.Assign(FileList); // := FileList;
  finally
    FileList.Free;
  end;
end;

end.
