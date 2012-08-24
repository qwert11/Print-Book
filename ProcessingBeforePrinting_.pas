unit ProcessingBeforePrinting_;

interface

uses
  BookOption_, ExtCtrls, Graphics, Classes, StdCtrls, Dialogs, Controls;

type
  TPartSheet = (AllPart, AllPartsSide, AllBkFt, SeparatePart);

  TOptionPrint = (AllSideOfPrint, AllLeftOfPrint, AllRightOfPrint,
      ContinuePrintFromBack);

  TPlaceOutput = procedure(PageOption: TPageOption;
      ABitmap: TBitmap) of object; // место вывода: принтер / предпросмотр

  TProcessingBeforePrinting = class(TBookOption)
  private
    FileNameList: TStrings; // список имен файлов
    BMLeft, BMRight,
    LImgForMove,
    RImgForMove: TBitmap;
    procedure Assign(FileName: TStrings);
    function GetNameImage(SidePage: TSidePage): String;
    procedure CopyRealImg_To_ImgForMove(Bitmap: TBitmap);

  public
    ControlPageOption: TControlPageOption;
    procedure Print(beg_: Integer; const SheetAtPallet: Integer;
        ifReversPrint: Boolean; SidesSheet: MSidesSheet = [FASE, BACK]);
    procedure LoadImgToPrw();
    procedure SetOption(PageOption: TPageOption;
        PartSheet: TPartSheet; SidePagFcs: TSidePage);
    procedure LoadTask(GeneralPageOption: TGeneralPageOption);
    procedure SaveTask(GeneralPageOption: TGeneralPageOption);
    property CSmallImg: TBitmap write CopyRealImg_To_ImgForMove;
    //опции печати

    //procedure Abort(); // приостановить задание

    procedure Preview(SidePage: TSidePage); overload;
    procedure Preview(SidePage: TSidePage; BMLeft, BMRight: TBitmap;
        PlaceOutput: TPlaceOutput); overload;
    procedure PreviewSmall();

    property NameList: TStrings read FileNameList;
  public
    constructor Create(FileName: TStrings; Image: ExtCtrls.TImage;
        ScrlB: TScrollBar; ListPrinters: TComboBox);
    destructor Destroy; override;
  end;

  //SList = TStringList

implementation

uses
  Unit1, Printers, Globals;

const
  SidesPageC = [LSidePage, RSidePage];

{ TProcessingBeforePrinting }

procedure TProcessingBeforePrinting.Assign(FileName: TStrings);
begin
  FileNameList.Assign(FileName);
end;

procedure TProcessingBeforePrinting.CopyRealImg_To_ImgForMove(
  Bitmap: TBitmap);

  procedure CopyImg_ToImgForMove;
  begin
    LImgForMove.Canvas.CopyRect(LImgForMove.Canvas.ClipRect,
      BMLeft.Canvas, BMLeft.Canvas.ClipRect);
    RImgForMove.Canvas.CopyRect(RImgForMove.Canvas.ClipRect,
      BMRight.Canvas, BMRight.Canvas.ClipRect);
  end;

  procedure SetSize_ImgForMove(LWidth, RWidth, Height: Cardinal);
  begin
    RImgForMove.Height := Height;
    LImgForMove.Height := Height;

    RImgForMove.Width := RWidth;
    LImgForMove.Width := LWidth;
  end;

var
  RelationPrinterToSourceL,
  RelationPrinterToSourceR: Real;

begin
  if not BMLeft.Empty then
    RelationPrinterToSourceL := Bitmap.Height / BMLeft.Height;
  if not BMRight.Empty then
    RelationPrinterToSourceR := Bitmap.Height / BMRight.Height;

  if BMRight.Empty and BMLeft.Empty then
    EMyError.Create('BMRirght and BMLeft the empty');

  if BMRight.Empty then
    RelationPrinterToSourceR := RelationPrinterToSourceL;
  if BMLeft.Empty then
    RelationPrinterToSourceL := RelationPrinterToSourceR;


  SetSize_ImgForMove(
      Trunc(BMLeft.Width * RelationPrinterToSourceL),
        Trunc(BMRight.Width * RelationPrinterToSourceR),
        Bitmap.Height);
  CopyImg_ToImgForMove;
end;

constructor TProcessingBeforePrinting.Create(FileName: TStrings;
    Image: ExtCtrls.TImage; ScrlB: TScrollBar; ListPrinters: TComboBox);
begin
  exists(Image);
  exists(FileName);
  exists(ScrlB);
  ControlPageOption := TControlPageOption.Create;
  //inherited Create(FileName.Count, Image, ScrlB, ListPrinters);
  inherited Create(1, Image, ScrlB, ListPrinters);
  FileNameList := FileName; //TStringList.Create;
  BMLeft := TBitmap.Create;
  BMRight := TBitmap.Create;
  LImgForMove := TBitmap.Create;
  RImgForMove := TBitmap.Create;
  //Assign(FileName);
end;

destructor TProcessingBeforePrinting.Destroy;
begin
  BMLeft.Free;
  BMRight.Free;
  LImgForMove.Free;
  RImgForMove.Free;
  ControlPageOption.Free;
  inherited;
end;

function TProcessingBeforePrinting.GetNameImage(SidePage: TSidePage): String;
begin
  case SidePage of
    LSidePage:
      case SideSheet of
        FASE:
          Result := FileNameList[SheetFcs.fLeft - 1];
        BACK:
          Result := FileNameList[SheetFcs.bLeft - 1];
      end;
      //Result := Sheet[NSheetFcs];
    RSidePage:
      case SideSheet of
        FASE:
          Result := FileNameList[SheetFcs.fRight - 1];
        BACK:
          Result := FileNameList[SheetFcs.bRight - 1];
      end;
  end;
end;

procedure TProcessingBeforePrinting.LoadImgToPrw();
begin
  ClearView;
  case SideSheet of // узнать сторону (перед, зад) листа
    FASE: // лицевая сторона листа
      begin
        // Левая сторона страницы
        if SheetFcs.fLeft <= FileNameList.Count then
        begin
          BMLeft.Assign(nil);  // не проверено
          BMLeft.LoadFromFile(PathToPages + GetNameImage(LSidePage));
          PreviewInf(PageLF[NSheetFcs], BMLeft);
          //BMLeft.Assign(nil);
        end;

        // Правая сторона страницы
        if SheetFcs.fRight <= FileNameList.Count then
        begin
          BMRight.Assign(nil);
          BMRight.LoadFromFile(PathToPages + GetNameImage(RSidePage));
          PreviewInf(PageRF[NSheetFcs], BMRight);
          //BMRight.Assign(nil);
        end;
      end;
    BACK: // задняя сторона листа
      begin
        // Левая сторона страницы
        if SheetFcs.bLeft <= FileNameList.Count then
        begin
          BMLeft.Assign(nil);
          BMLeft.LoadFromFile(PathToPages + GetNameImage(LSidePage));
          PreviewInf(PageLB[NSheetFcs], BMLeft);
          //BMLeft.Assign(nil);
        end;

        // Правая сторона страницы
        if SheetFcs.bRight <= FileNameList.Count then
        begin
          BMRight.Assign(nil);
          BMRight.LoadFromFile(PathToPages + GetNameImage(RSidePage));
          PreviewInf(PageRB[NSheetFcs], BMRight);
          //BMRight.Assign(nil);
        end;
      end;
  end;
end;

procedure TProcessingBeforePrinting.Preview(SidePage: TSidePage);
begin
  Preview(SidePage, BMLeft, BMRight, PreviewInf);
end;

procedure TProcessingBeforePrinting.LoadTask(GeneralPageOption: TGeneralPageOption);
begin
  with GeneralPageOption do
  begin
    // все
    AllP := All;

    // все части стороны фокуса
    LAllP := LAll;
    RAllP := RAll;


    // все задние передние
    FAllP := FAll;
    BAllP := BAll;

    // все раздельные части

    // левые

    LFnt := LFront; // лицевые
    LBk := LBack; // задние

    // правые

    RFnt := RFront; // лицевые
    RBk := RBack; // задние

    Self.NPageFcs := NPageFcs; 
  end;

end;

procedure TProcessingBeforePrinting.Preview(SidePage: TSidePage; BMLeft,
  BMRight: TBitmap; PlaceOutput: TPlaceOutput);
begin
  // ClearView;
  case SideSheet of // узнать сторону (перед, зад) листа
    FASE: // лицевая сторона листа
      case SidePage of
        LSidePage:
          if SheetFcs.fLeft <= FileNameList.Count then
            PlaceOutput(PageLF[NSheetFcs], BMLeft);
        RSidePage:
          if SheetFcs.fRight <= FileNameList.Count then
            PlaceOutput(PageRF[NSheetFcs], BMRight);
      end;
    BACK:
      case SidePage of
        LSidePage:
          if SheetFcs.bLeft <= FileNameList.Count then
            PlaceOutput(PageLB[NSheetFcs], BMLeft);
        RSidePage:
          if SheetFcs.bRight <= FileNameList.Count then
            PlaceOutput(PageRB[NSheetFcs], BMRight);
      end;
  end;
end;

procedure TProcessingBeforePrinting.PreviewSmall;
begin
  Preview(LSidePage, LImgForMove, RImgForMove, PreviewInf);
  Preview(RSidePage, LImgForMove, RImgForMove, PreviewInf);
end;

procedure TProcessingBeforePrinting.Print(beg_: Integer; const SheetAtPallet: Integer;
    ifReversPrint: Boolean; SidesSheet: MSidesSheet);

  procedure PrintFocusPage();
  begin
    LoadImgToPrw;
    Preview(LSidePage, BMLeft, BMRight, Printing);
    Preview(RSidePage, BMLeft, BMRight, Printing);
  end;

  {печатаем в обычном порядке}
  procedure PrintOnOrder(const EndPage: Integer);
    function ifNewPage(): Boolean; // попытка установить новую страницу
    var
      i: Integer;
    begin
      Result := False;
      // новая страница
      if NPageFcs + 2 <= Max then
        begin
          NPageFcs := NPageFcs + 2;
          Prntr.NewPage;
          Result := True;
        end;
    end;
  begin
    repeat
      PrintFocusPage; // печатаем фокусную страницу
    until (NPageFcs + 2 > EndPage) or not ifNewPage;
  end;

  {печатаем в обратном порядке}
  procedure PrintReverse(const BeginPage: Integer);
    function ifNewPage(): Boolean;
    begin
      Result := False;
      if NPageFcs - 2 > Min then
        begin
          NPageFcs := NPageFcs - 2;
          Prntr.NewPage;
          Result := True;
        end;
    end;
  begin
    repeat
      PrintFocusPage; // печатаем фокусную страницу
    until (NPageFcs - 2 < BeginPage) or not ifNewPage;
  end;

  function ifNewPallet(var fstPage: Integer;
      const sndPage: Integer): Boolean; overload;
  begin
    Result := False;
    if sndPage + SheetAtPallet <= Max then
    begin
      fstPage := sndPage + SheetAtPallet;
      if fstPage mod 2 <> 0 then
        Dec(fstPage);
      Result := True;
    end else
      if sndPage < Max then
      begin
        fstPage := Max;
        Result := True;
      end;
  end;

  function ifNewPallet(var BeginPage: Integer): Boolean; overload;
  begin
    Result := False;
    if BeginPage + SheetAtPallet < Max then
    begin
      BeginPage := BeginPage + SheetAtPallet;
      if BeginPage mod 2 = 0 then
        EMyError.Create('Начальная страница не может быть четной');
        //Dec(fstPage);
      Result := True;
    end;
  end;

  function ifEndPrinting(BeginPage: Integer;
      Side_Of_Sheet: TSideSheet): Boolean;  // Side_Of_Sheet - показывает отпечатанное
  begin
    Result := False;
    case Side_Of_Sheet of
      FASE:
        if not(BACK in SidesSheet) then
          Result := not ifNewPallet(BeginPage);
      BACK:
        Result := not ifNewPallet(BeginPage);
    end;
  end;

  function SaveBeginPage(BegPage: Integer): Boolean;
  begin
    Result := False;
    ControlPageOption.KitUserOption.begPagesToPrint := BegPage;
    ControlPageOption.SaveTask;
    Result := True;
  end;

  function SaveBeginPage_for_NewPallet(BegPage:
      Integer): Boolean;
  begin
    Result := False;
    if not ifNewPallet(BegPage) then
      Exit;
    Result := SaveBeginPage(BegPage);
  end;

var
  BeginPage,
  EndPage,
  tmpBeginPage: Integer;
begin
  BeginPage := beg_;
  SetLOrientation;


  with Prntr do
  begin
    repeat
      NPageFcs := BeginPage; // начало лотка

      // установить конечную страницу
      ifNewPallet(EndPage, BeginPage);

      // печать лицевой стороны
      if FASE in SidesSheet then
      begin
        BeginDoc;
          PrintOnOrder(EndPage); // лоток передних
        EndDoc; // конец печати

        if ifEndPrinting(BeginPage, FASE) then
          Exit;

        if BACK in SidesSheet then
          begin
            SidesSheet := [FromBack];
            ControlPageOption.KitUserOption.SidesSheet := sFromBack;
          end;

        SaveBeginPage(BeginPage);

        repeat
          case MessageDlg('Лицевая сторона лотка распечатана', mtInformation,
              mbOKCancel, 0) of
            mrOk:
              Break;
            mrCancel:
              Exit;
          else
            Continue;
          end;
        until True;

      end;

      SaveBeginPage(BeginPage);

      // печать обратной стороны
      if (BACK in SidesSheet) or
          (FromBack in SidesSheet) then
      begin
        BeginDoc;
          case ifReversPrint of // печать лотка задних
            True: // обратная печать
              begin
                NPageFcs := EndPage;
                PrintReverse(BeginPage);
              end;
            False: // по порядку
              begin
                NPageFcs := BeginPage + 1;
                PrintOnOrder(EndPage);
              end;
          end;
        EndDoc; // конец печати

        if FromBack in SidesSheet then
          begin
            SidesSheet := [BACK, FASE];
            ControlPageOption.KitUserOption.SidesSheet := sAll;
          end;

        if ifEndPrinting(BeginPage, BACK) then
          Exit;

        SaveBeginPage_for_NewPallet(BeginPage);

        repeat
          case MessageDlg('Задняя сторона лотка распечатана', mtInformation,
              mbOKCancel, 0) of
            mrOk:
              Break;
            mrCancel:
              Exit;
          else
            Continue;
          end;
        until True;
      end;

      if ifEndPrinting(BeginPage, BACK) then
        Exit;

      SaveBeginPage_for_NewPallet(BeginPage);

    until not ifNewPallet(BeginPage);
  end;
end;

procedure TProcessingBeforePrinting.SetOption(PageOption: TPageOption;
  PartSheet: TPartSheet; SidePagFcs: TSidePage);
  function AddOpt(old, new: TPageOption): TPageOption;
  begin
    Result.zoom := old.zoom + new.zoom;
    Result.shift.X := old.shift.X +
        Round(new.shift.X / {k}1); // можно менять k
    Result.shift.Y := old.shift.Y +
        Round(new.shift.Y / {k}1); // можно менять k
  end;
begin
  case PartSheet of
    // все
    AllPart: AllP := AddOpt(AllP, PageOption);

    // все части стороны фокуса
    AllPartsSide:
      case SidePagFcs of
        LSidePage: LAllP := AddOpt(LAllP, PageOption);
        RSidePage: RAllP := AddOpt(RAllP, PageOption);
      end;

    // все задние передние
    AllBkFt:
      case SideSheet of
        FASE: FAllP := AddOpt(FAllP, PageOption);
        BACK: BAllP := AddOpt(BAllP, PageOption);
      end;

    // все раздельные части
    SeparatePart:
      case SidePagFcs of

          // левые
        LSidePage:
          case SideSheet of
            FASE: LFnt := AddOpt(LFnt, PageOption); // лицевые
            BACK: LBk := AddOpt(LBk, PageOption); // задние
          end;

          // правые
        RSidePage:
          case SideSheet of
            FASE: RFnt := AddOpt(RFnt, PageOption); // лицевые
            BACK: RBk := AddOpt(RBk, PageOption); // задние
          end;
      end;
  end;
end;

procedure TProcessingBeforePrinting.SaveTask(
  GeneralPageOption: TGeneralPageOption);
begin
  with ControlPageOption.UserOption.GeneralPageOption do
    begin
      // все
      All := AllP;

      // все части стороны фокуса
      LAll := LAllP;
      RAll := RAllP;


      // все задние передние
      FAll := FAllP;
      BAll := BAllP;

      // все раздельные части

      // левые

      LFront := LFnt; // лицевые
      LBack := LBk; // задние

      // правые

      RFront := RFnt; // лицевые
      RBack := RBk; // задние

      NPageFcs := Self.NPageFcs;
    end;
  ControlPageOption.SaveTask(PathToPages + '\task.pbp');
end;

end.
