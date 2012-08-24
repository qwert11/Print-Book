unit BookOption_;

interface

uses
  SysUtils, Printers, Windows, WinSpool, Graphics, ExtCtrls, Classes, StdCtrls;


type
  EMyError = class (Exception);

  TSideSheet = (FASE, BACK, FromBack); // ������� �����
  TSideSheet2 = (sAll = 0, sFASE, sBACK, sFromBack);
  TSidePage = (LSidePage, RSidePage); // ������� ��������
  MSidesSheet = set of TSideSheet; // ��������� ������ �����

  TPageOption = record
    zoom: Integer; // % * 10
    shift: TPoint; // �� * 10
  end;

  TGeneralPageOption = record
    All, // ���
    LAll, RAll, // ����� ������
    BAll, FAll, // ������ ��������
    LFront, LBack, // ����� ������ �������� ������
    RFront, RBack: TPageOption;
  end;


  TSheetOption = record
    fLeft,
    fRight,
    bLeft,
    bRight: TPageOption;
  end;

  TMargins = record
    Left,
    Top,
    Right,
    Bottom: Double
  end;

  TKitUserOption = record
    phis_pages: Integer;
    ifBook: Boolean;
    firstpage,
    endpage,
    SheetsInNoteBook: Integer;
    GeneralPageOption: TGeneralPageOption;
    ifReversPrint,
    ifPallet: Boolean;
    PagesInPallet: Integer;
    //NamePrinter: string;
    NPageFcs,
    MinPage,
    MaxPage: Integer;

    begPagesToPrint,
    endPagesToPrint: Integer;
    SidesSheet: TSideSheet2;
    //fileNamePageInTask: string;
    // ��������� ������
    DensityOfThePaper: Integer;
  end;

  TPrinterParameter = record
    //DriverVersion - ������� ������ ��������
    //Texnology - ���������� ������, �� �����, ��������
    //dt_Plotter - �������
    //dt_RasPrinter - ��������� �������
    //dt_Display - �������
    HorzSize_: Integer; // - �������������� ������ ����� (� ��)
    VertSize_: Integer; // - ������������ ������ ����� (� ��)
    HorzRes_: Integer; // - �������������� ������ ����� (� ��������)
    VertRes_: Integer;
    LogPixelX_: Integer; // - ���������� �� ��� � � dpi (������ /����)
    LogPixelY_: Integer; // - ���������� �� ��� Y � dpi (������ /����)

    Margins: TMargins;
  end;

  {TJobPrinting = record
    physicalPages, // ���������� �������

    firstPage, // ������ � ��������� ��������
    finishPage,

    firstPrintPage, // ������, ��������� � ���������� ��������
    finishPrintPage,
    printedPage: Integer;

    ifBook: Boolean; // ����� ��� �������
    SidesSheet: MSidesSheet
  end;}



  TInfoPrinter = class
  private
    Printer_: TPrinter;
    ListPrinters: TComboBox;
    FirstPageOfPrint,
    FinishPageOfPrint: Integer;
    SSheetOfPnt: MSidesSheet;
    //JobPrinting: TJobPrinting;
    density_paper_for_printing: Integer;
    procedure GetPrinterParameter(hPrinter: THandle);
    procedure SetDensityOfThePaper(Density: Integer);
    function GetDensityOfThePaper(): Integer;
  public
    PrinterParameter: TPrinterParameter;
    // ��������� ������
    property DensityOfThePaper: Integer read GetDensityOfThePaper write SetDensityOfThePaper;
    procedure SetPrinter();
    procedure SetLOrientation; // ��������� ����������
    procedure exists(obj: TPersistent);
    procedure Printing(option: TPageOption; img: TBitmap);
    procedure SetOptionOfPrint(first, finish: Integer; SidesSheet: MSidesSheet);
    property Prntr: TPrinter read Printer_;
    constructor Create(ListPrinters: TComboBox);
  end;

  TInfoViewer = class (TInfoPrinter)
  private
    Viever: TImage;
    ScrollBar: TScrollBar;
    //FIDX: Integer; // ������ ������ ���-�� ������ * 2
    function GetMax(): Integer;
    function GetMin(): Integer;
    function GetNumberFocusPage(): Integer;
    function GetNumberFocusSheet(): Integer;
    //function GetNumberFocusSheetOfNoteBook(): Integer;
    function GetSideSheet(): TSideSheet;
    procedure ResizeTo_(Point: TPoint);
    procedure SetNumberFocusPage(IDX: Integer);
  public
    procedure ClearView();
    procedure PreviewInf(PageOption: TPageOption; ABitmap: TBitmap);
    procedure SetPageScrollBar(const min, max: Integer);
    //property NPageFcs: Integer read GetNumberFocusPage;
    property NPageFcs: Integer read GetNumberFocusPage write SetNumberFocusPage;
    property NSheetFcs: Integer read GetNumberFocusSheet;
    //property NSheetFcsNoteBook
    property SideSheet: TSideSheet read GetSideSheet;

    property Min: Integer read GetMin;
    property Max: Integer read GetMax;
  public
    constructor Create(Image: TImage; ScrlB: TScrollBar;
        ListPrinters: TComboBox);
    destructor Destroy; override;
  end;

      //TValueKoef = (ZOOM, WIDTH, HEIGHT); // ����������, ������ , ������
  TIndexKoef = (idLF, idLB, idRF, idRB, idAll, idLAll, idRAll, idFAll, idBAll); // ����� ��������, ����� ������
                            // ������ ��������, ������ ������
      {3� ����������� ������� �������� � ����������
        1 - ��� �����
        2 - ��� ����� ��� ������
        3 - ��� ������� (�����, ������) ��� �������� (�����, ������)
      }

  TSheetGlobalOption = class(TInfoViewer)
  private
    GeneralPageOption: TGeneralPageOption;

  {
    // ���
    property All: TPageOption read GeneralPageOption.All
        write GeneralPageOption.All;
    // ����� ������
    property LAll: TPageOption read GeneralPageOption.LAll
        write GeneralPageOption.LAll;
    property RAll: TPageOption read GeneralPageOption.RAll
        write GeneralPageOption.RAll;
    // ������ ��������
    property BAll: TPageOption read GeneralPageOption.BAll
        write GeneralPageOption.BAll;
    property FAll: TPageOption read GeneralPageOption.FAll
        write GeneralPageOption.FAll;
    // ����� ������ �������� ������
    property LFront: TPageOption read GeneralPageOption.LFront
        write GeneralPageOption.LFront;
    property LBack: TPageOption read GeneralPageOption.LBack
        write GeneralPageOption.LBack;
    property RFront: TPageOption read GeneralPageOption.RFront
        write GeneralPageOption.RFront;
    property RBack: TPageOption read GeneralPageOption.RBack
        write GeneralPageOption.RBack;
  }

    // ������� ��� ��������� ����� GET � SET
    function GetPage(IndexKoef: TIndexKoef): TPageOption;
    procedure SetPages(IndexKoef: TIndexKoef; PageOption: TPageOption);

  protected
    // ������ ����� ������������� �����
    property LFnt: TPageOption index idLF read GetPage write SetPages;
    property LBk: TPageOption index idLB read GetPage write SetPages;
    property RFnt: TPageOption index idRF read GetPage write SetPages;
    property RBk: TPageOption index idRB read GetPage write SetPages;

    // ������������� �����
    property AllP: TPageOption index idAll read GetPage write SetPages;
    property LAllP: TPageOption index idLAll read GetPage write SetPages;
    property RAllP: TPageOption index idRAll read GetPage write SetPages;
    property BAllP: TPageOption index idBAll read GetPage write SetPages;
    property FAllP: TPageOption index idFAll read GetPage write SetPages;
  public
    procedure SetDefault(); // ����� �� ���������
    constructor Create(Image: TImage; ScrlB: TScrollBar;
        ListPrinters: TComboBox);
    destructor Destroy; override;
  end;

  TNumberSheet = record
    fLeft, fRight,
    bLeft, bRight: Integer;
  end;

//  TTypeBook = (nbBrochure, nbBook);

  TNumberBook = class
  private
    // ������ ������
    book: array of TNumberSheet;
    SheetsB, // ���-�� ������
    FirstPage,  // // ����� ������ ��������
    SheetsNoteBook: Integer; // ���-�� ��� � �������
//    nbFisicalPages: Integer;
//    TypeBook: TTypeBook;
    function GetSheet(IDX: Integer): TNumberSheet;
  public
    function SetBook(FirstPage, EndPage: Integer;
        SheetsNoteBook: Integer): Boolean;
    property Sheet[IDX: Integer]: TNumberSheet read GetSheet;
//     property nbTypeBook: TTypeBook read TypeBook; // ��� ����� // �������
    property Sheets: Integer read SheetsB;
    //property Pages: Integer read nbFisicalPages;
    property FstPg: Integer read FirstPage;
    property ShsNbk: Integer read SheetsNoteBook;
  public
    constructor Create(Pages: Integer);
    destructor Destroy; override;
  end;

  TBookOption = class(TSheetGlobalOption)
  private
    SheetOption: array of TSheetOption;
    NumberBook: TNumberBook; // ������ �������
    function GetSheetsCount():Integer; // ���-�� ���
    function Get_nb_FisrtPage():Integer;
    function Get_nb_SheetsNoteBook(): Integer;
    function GetSheetOption(IDX: Integer): TSheetOption;
    //procedure SetSheetOption(IDX: Integer; SheetOption: TSheetOption);

    // �������� � ������ �� Viewer
    function GetNumberPagesOfSheet: TNumberSheet;
    function GetNumberFocusSheetOfNoteBook: Integer;

    //��� ��������� � ��������� �����
    function GetPageAllOption(IDX: Integer; IndexKoef: TIndexKoef): TPageOption;
    procedure SetOptionPage(IDX: Integer; IndexKoef: TIndexKoef; PageOption: TPageOption);

    // ������� ��� ���������
    procedure SetBookOptionDefault;
  public
    // ������
    property sheets: Integer read GetSheetsCount;
    property FstPg: Integer read Get_nb_FisrtPage;
    property StsNtBk: Integer read Get_nb_SheetsNoteBook; // ����� � �������

    // ������ ������� �� ����� ������
    property SheetFcs: TNumberSheet read GetNumberPagesOfSheet;
    property NSheetFcsNoteBook: Integer read GetNumberFocusSheetOfNoteBook;

    // ����� ����� �� �������
    property SheetOpt[IDXSheet: Integer]: TSheetOption read GetSheetOption;

  protected
    // ���������� �����
    procedure SetBook(FirstPage, EndPage: Integer;
        SheetsNoteBook: Integer = 0);

    // ��������� ����� �������
    property PageLB[IDXSheet: Integer]: TPageOption index idLB
        read GetPageAllOption write SetOptionPage;
    property PageLF[IDXSheet: Integer]: TPageOption index idLF
        read GetPageAllOption write SetOptionPage;
    property PageRF[IDXSheet: Integer]: TPageOption index idRF
        read GetPageAllOption write SetOptionPage;
    property PageRB[IDXSheet: Integer]: TPageOption index idRB
        read GetPageAllOption write SetOptionPage;
  public        {idLF, idLB, idRF, idRB}
    constructor Create(PageCount: Integer; Image: TImage;
        ScrlB: TScrollBar; ListPrinters: TComboBox);
    destructor Destroy; override;
  end;

  TControlPageOption = class
    KitUserOption: TKitUserOption;
    ListNamePageInTask: TStringList;
    if_exists_task: Boolean;
    function initial_(way_to_file_task: string): Boolean;
    function SaveTask(way_to_file_task: string): Boolean; overload;
    function SaveTask(): Boolean; overload;
  public
    property UserOption: TKitUserOption read KitUserOption;
    property existsTask: Boolean read if_exists_task;
    constructor Create();
    destructor Destroy;
  end;

implementation

uses
  Graphic_, Types, IniFiles, Messages, Globals;
{
const
  SidesPageC = [LSidePage, RSidePage];   }

{ TNumberBook }

function TNumberBook.SetBook(FirstPage, EndPage,
    SheetsNoteBook: Integer): Boolean;

  procedure SET_FirstEndSheetsInTetradSheetsInBook(
      var FirstPage, EndPage, SheetInTetrad, SheetsB: Integer);
    function AutoSelectOnSizeOfTheBook(const SheetsB: Integer): Integer;
    begin
      case SheetsB of
        1..3 : Result := 1;
        4..7: Result := 2;
        8..15: Result := 3;
        16..31: Result := 4;
        32..63: Result := 5;
      else
        Result := 6;
      end;
    end;
  begin
  {����� FirstPage � EndPage �������� 4}
    if FirstPage <= 4 then
      FirstPage := 1
    else
      while((FirstPage - 1) mod 4 <> 0) do
        Dec(FirstPage);
    if EndPage <= FirstPage then
      EndPage := FirstPage + 1;
    while(EndPage mod 4 <> 0) do
      Inc(EndPage);

  // ������������� ���-�� ������ � �����
    SheetsB := Round((EndPage - FirstPage + 1) / 4);

  { 0   ��������� (-1 ��� -2)
    -1  ����� � ����������� ������� �������
    -2  ������ �������
    ����� �����
    }
    case SheetsNoteBook of
      0:
        if SheetsB > 35 then
          SheetInTetrad := AutoSelectOnSizeOfTheBook(SheetsB)
        else
          SheetsNoteBook := SheetsB;
      -1:
        SheetInTetrad := AutoSelectOnSizeOfTheBook(SheetsB);
      -2:
        SheetsNoteBook := SheetsB;
    else
      // ���-�� �������� �� ������ ��������� ���������� ���-�� ������
      // (- 2) ��������� ����� �� ���������
      if (SheetsNoteBook < 1) or (SheetInTetrad > SheetsB) then
        SheetInTetrad := AutoSelectOnSizeOfTheBook(SheetsB)
      else
        if SheetInTetrad <= 0 then
          SheetInTetrad := SheetsB;
    end;

    if (SheetsNoteBook < 1) or
        (SheetsNoteBook > SheetsB) then
      EMyError.Create('SheetsNoteBook Out Limit');

  end;

  procedure InsTetrads(FirstPage, EndPage: Integer; var IDX: Integer); overload;
  begin
    repeat
      with book[IDX]do
      begin
        bLeft := EndPage;         // � ���� ����� ���������� ��� ����!!!
        bRight := FirstPage;      // �������� ������ ������ �������� ������� ������ � �����
        Inc(FirstPage);
        Dec(EndPage);
        fLeft := FirstPage;
        fRight := EndPage;
        Inc(FirstPage);
        Dec(EndPage);
      end;
      Inc(IDX);
    until FirstPage > EndPage;
  end;

  procedure InsTetrads(FirstPage, EndPage: Integer); overload;
  var
    IDX: Integer;
  begin
    IDX := 0;
    InsTetrads(FirstPage, EndPage, IDX);
  end;
var
  IDX: Integer;
  SheetsB: Integer;
begin
  Result := False;

  SET_FirstEndSheetsInTetradSheetsInBook(FirstPage, EndPage,
      SheetsNoteBook, SheetsB);

  // �������� ������� ����� ����� �� ������
  if (FirstPage = Self.FirstPage) and (SheetsNoteBook = Self.SheetsNoteBook) and
      (SheetsB = Self.SheetsB) then
    Exit;

  // �������� ��� ����� �����
  Self.SheetsNoteBook := SheetsNoteBook;
  Self.FirstPage := FirstPage;
  Self.SheetsB := SheetsB;
  if book <> nil then
      book := nil;
  SetLength(book, SheetsB);

  // ������������������ �������
  IDX := 0;
  if (SheetsNoteBook = SheetsB) or (SheetsNoteBook = 0) then
      // ���������
      InsTetrads(FirstPage, EndPage)
    else
      // ������
      repeat
        if (IDX + SheetsNoteBook > SheetsB)
          then SheetsNoteBook := SheetsB - IDX;
        InsTetrads(4 * IDX + FirstPage, 4 * (IDX + SheetsNoteBook) +
            FirstPage - 1, IDX);
      until IDX >= SheetsB;
      
  Result := True;
end;

constructor TNumberBook.Create(Pages: Integer);
begin
  SheetsNoteBook := -1; // �������������� ������ 
  SetBook(1, Pages, -1);
end;

destructor TNumberBook.Destroy;
begin
  if book <> nil then
      book := nil;
  inherited;
end;

function TNumberBook.GetSheet(IDX: Integer): TNumberSheet;
begin
  Result := book[IDX - 1];
end;

{ TInfoPrinter }

constructor TInfoPrinter.Create(ListPrinters: TComboBox);
var
  cbBuf,
  pcbNeeded,
  pcReturned: DWORD;
begin

  // �� ��������� ��������� ������
  DensityOfThePaper := 80;

  // ����� ����� �������� � ���������� �� ���� ������
  Printer_ := Printer;

  // ������ ���������
  Self.ListPrinters := ListPrinters;
  Self.ListPrinters.Items.Assign(Printer_.Printers);
  Self.ListPrinters.ItemIndex := 0;

  SetPrinter;

  Self.ListPrinters.Refresh;

  // ��������� �������� �� ���������
  GetPrinterParameter(Printer_.Handle);

  // ��������� � �������� �������� ��� ������
  FirstPageOfPrint := 1;
  FinishPageOfPrint := 1;
  SSheetOfPnt := [FASE, BACK];
end;

procedure TInfoPrinter.exists(obj: TPersistent);
begin
  if obj = nil then
    raise EMyError.Create('������ ' + obj.GetNamePath + ' �� ���������');
end;

function TInfoPrinter.GetDensityOfThePaper: Integer;
begin
  Result := density_paper_for_printing;
end;

procedure TInfoPrinter.GetPrinterParameter(hPrinter: THandle);
var
  PixelsPerInch: TPoint;
  PhysPageSize: TPoint;
  OffsetStart: TPoint;
  PageRes: TPoint;
begin
  with PrinterParameter do
  begin
    HorzSize_ := GetDeviceCaps(hPrinter, HorzSize);
    VertSize_ := GetDeviceCaps(hPrinter, VertSize);
    HorzRes_ := GetDeviceCaps(hPrinter, HorzRes);
    VertRes_ := GetDeviceCaps(hPrinter, VertRes);
    LogPixelX_ := GetDeviceCaps(hPrinter, LogPixelsX);
    LogPixelY_ := GetDeviceCaps(hPrinter, LogPixelsY);

    Escape(hPrinter, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
    Escape(hPrinter, GETPRINTINGOFFSET, 0, nil, @OffsetStart);

    // Top Margin
    Margins.Top := OffsetStart.y / VertSize_;
    // Left Margin
    Margins.Left := OffsetStart.x / HorzSize_;
    // Bottom Margin
    Margins.Bottom := ((PhysPageSize.y - VertRes_) / VertSize_) -
       (OffsetStart.y / VertSize_);
    // Right Margin
    Margins.Right := ((PhysPageSize.x - HorzRes_) / HorzSize_) -
       (OffsetStart.x / HorzSize_);
  end;
end;

procedure TInfoPrinter.Printing(option: TPageOption; img: TBitmap);
begin
  Draw(Prntr.Canvas, option, img);
end;

procedure TInfoPrinter.SetDensityOfThePaper(Density: Integer);
begin
  if Density > 100 then
    raise EMyError.Create('������� ��������� ������');
  if Density < 30 then
    raise EMyError.Create('����� ��������� ������');
  density_paper_for_printing := Density;
end;

procedure TInfoPrinter.SetLOrientation;
begin
  Prntr.Orientation := poLandscape;
end;

procedure TInfoPrinter.SetOptionOfPrint(first, finish: Integer;
    SidesSheet: MSidesSheet);
begin
  SSheetOfPnt := SidesSheet;
  FirstPageOfPrint := first;
  FinishPageOfPrint := finish;
end;

procedure TInfoPrinter.SetPrinter;
begin
  Prntr.PrinterIndex := ListPrinters.ItemIndex;
  SetLOrientation;
  GetPrinterParameter(Prntr.Handle);
end;

{ TInfoViewer }

procedure TInfoViewer.ClearView();
begin
  Graphic_.Clear(Viever);
  Viever.Refresh;
end;

constructor TInfoViewer.Create(Image: TImage; ScrlB: TScrollBar;
    ListPrinters: TComboBox);
begin
  inherited Create(ListPrinters);
  exists(Image);
  exists(ScrlB);
  ScrollBar := ScrlB;
  Viever := Image;
  //ResizeTo_();
end;

destructor TInfoViewer.Destroy;
begin

  inherited;
end;

{function TInfoViewer.GetNumberFocusPage: Integer;
begin
  Result := 0;
end;}

function TInfoViewer.GetMax: Integer;
begin
  Result := ScrollBar.Max;
end;

function TInfoViewer.GetMin: Integer;
begin
  Result := ScrollBar.Min;
end;

function TInfoViewer.GetNumberFocusPage: Integer;
var
  SideSheet: TSideSheet;
begin
  // �������� � ��������� ������
  Result := ScrollBar.Position;
  if ScrollBar.Position < FirstPageOfPrint then
    Result := FirstPageOfPrint;
  if ScrollBar.Position > FinishPageOfPrint then
    Result := FinishPageOfPrint;

  if Result mod 2 = 0 then
    SideSheet := BACK
  else
    SideSheet := FASE;
  if not (SideSheet in SSheetOfPnt) then
    case SideSheet of
      FASE: Inc(Result);
      BACK: Dec(Result);
    end;
end;

function TInfoViewer.GetNumberFocusSheet: Integer;
begin
  if NPageFcs mod 2 = 0 then
    Result := Round(NPageFcs / 2)
  else
    Result := Round((NPageFcs + 1) / 2)
end;

//function TInfoViewer.GetNumberFocusSheetOfNoteBook: Integer;
//begin
//  //NSheetFcs
//end;

function TInfoViewer.GetSideSheet: TSideSheet;
begin
  if NPageFcs mod 2 = 0 then
    Result := BACK // ��� - ��� ������ ��
  else
    Result := FASE; // ����� - ��� �������� ��
end;

procedure TInfoViewer.PreviewInf(PageOption: TPageOption; ABitmap: TBitmap);
begin
  Draw(Viever.Canvas, PageOption, ABitmap);
  Viever.Refresh;
end;

procedure TInfoViewer.ResizeTo_(Point: TPoint);
begin
  // �-� �� ���������� �� ������������ !!!
  //raise EMyError.Create('������� ResizeTo_ �� ����������');
  Viever.Width := Point.X;
  Viever.Height := Point.Y;
  Viever.Refresh;
end;

procedure TInfoViewer.SetNumberFocusPage(IDX: Integer);
begin
  if (IDX < Min) or (IDX > Max) then
    raise EMyError.Create('Out of borders!');

  ScrollBar.Position := IDX;
  ScrollBar.Refresh;
end;

procedure TInfoViewer.SetPageScrollBar(const min, max: Integer);
begin
  ScrollBar.Min := Min;
  ScrollBar.Max := Max;
  ScrollBar.Position := Min;
  ScrollBar.Refresh;
end;

{ TSheetGlobalOption }

constructor TSheetGlobalOption.Create(Image: TImage; ScrlB: TScrollBar;
    ListPrinters: TComboBox);
begin
  inherited ;
  SetDefault;
end;

destructor TSheetGlobalOption.Destroy;
begin
  inherited;
end;

function TSheetGlobalOption.GetPage(IndexKoef: TIndexKoef): TPageOption;
begin
  with GeneralPageOption do
    case IndexKoef of
      idAll: Result := All;
      idLAll: Result := LAll;
      idRAll: Result := RAll;
      idFAll: Result := FAll;
      idBAll: Result := BAll;

      idLF:
        Result := LFront;
      idLB:
        Result := LBack;
      idRF:
        Result := RFront;
      idRB:
        Result := RBack;
    end;
end;

procedure TSheetGlobalOption.SetDefault;
  procedure SetParm_0(var PageOption: TPageOption);
  begin
    with PageOption do
    begin
      zoom := 0; // �� ��������� ���������� 0 %
      shift := Point(0, 0);
    end;
  end;
begin
  with GeneralPageOption do
  begin
    // 1 � �������
    SetParm_0(All);

    // 2 � �������
    SetParm_0(LAll);

    RAll.zoom := 0;
    RAll.shift := Point(500, 0);


    SetParm_0(BAll);
    SetParm_0(FAll);

    // 3� �������
    SetParm_0(LFront);
    SetParm_0(LBack);
    SetParm_0(RFront);
    SetParm_0(RBack);

  end;

  //DensityOfThePaper := 80;
end;

procedure TSheetGlobalOption.SetPages(IndexKoef: TIndexKoef;
    PageOption: TPageOption);
  procedure SetOpt(var POpt: TPageOption);
  begin
    POpt.zoom := PageOption.zoom;
    POpt.shift.X := PageOption.shift.X;
    POpt.shift.Y := PageOption.shift.Y;
  end;
begin
  with GeneralPageOption do
    case IndexKoef of
      idLF: SetOpt(LFront);
      idLB: SetOpt(LBack);
      idRF: SetOpt(RFront);
      idRB: SetOpt(RBack);

      idAll: SetOpt(All);
      idLAll: SetOpt(LAll);
      idRAll: SetOpt(RAll);
      idFAll: SetOpt(FAll);
      idBAll: SetOpt(BAll);
    end;
end;

{ TBookOption }

constructor TBookOption.Create(PageCount: Integer; Image: TImage;
    ScrlB: TScrollBar; ListPrinters: TComboBox);
begin
  inherited Create(Image, ScrlB, ListPrinters);
  NumberBook := TNumberBook.Create(PageCount);
  SetBookOptionDefault;
end;

destructor TBookOption.Destroy;
begin
  if SheetOption <> nil then
    SheetOption := nil;
  NumberBook.Destroy;
  inherited;
end;

function TBookOption.GetSheetsCount: Integer;
begin
  if NumberBook.Sheets < 1 then
    raise EMyError.Create('GetSheetCount ������ ������ 1');
  Result := NumberBook.Sheets;
end;

procedure TBookOption.SetBookOptionDefault;
var
  IDX: Integer;
begin

  if SheetOption <> nil then
    SheetOption := nil;
  SetDefault; // ���������� �������� �� ���������
  SetPageScrollBar(1, sheets * 2);
  SetOptionOfPrint(1, sheets * 2, [FASE, BACK]);
  SetLength(SheetOption, sheets);
  for IDX := 0 to sheets - 1 do
    with SheetOption[IDX] do
    begin
      fLeft.zoom := 0;
      fLeft.shift := Point(0, 0);

      fRight.zoom := 0;
      fRight.shift := Point(0, 0);

      bLeft.zoom := 0;
      bLeft.shift := Point(0, 0);

      bRight.zoom := 0;
      bRight.shift := Point(0, 0);
    end;
end;

function TBookOption.GetSheetOption(IDX: Integer): TSheetOption;
begin
  if IDX > sheets then
    raise EMyError.Create('TBookOption.GetSheetOption');
  Result := SheetOption[IDX - 1];
end;

function TBookOption.GetPageAllOption(IDX: Integer;
    IndexKoef: TIndexKoef): TPageOption;
  function GetSummAll(first, second: TPageOption;
      ShiftOverDensityOfThePaper: Integer): TPageOption;
  begin
    Result.zoom := (first.zoom + second.zoom);
    Result.shift.X := 1000 - (first.shift.X + second.shift.X) +
        ShiftOverDensityOfThePaper;
    Result.shift.Y := 1000 - (first.shift.Y + second.shift.Y);
  end;
  function GetSumm(first, second, third, fourth: TPageOption): TPageOption;
  begin
    Result.zoom := first.zoom + second.zoom + third.zoom + fourth.zoom;
    Result.shift.X := first.shift.X + second.shift.X +
        third.shift.X + fourth.shift.X;
    Result.shift.Y := first.shift.Y + second.shift.Y +
        third.shift.Y + fourth.shift.Y;
  end;

  {������� ������ ������� ��:
    ������������ ����� � ������ - NSheetFcsBook
    ��������� ������ - DensityOfThePaper
    ��������� 1 ����� bmp �� �����
      �������� (1 ���� - 4 �����) - idLF, idLB, idRF, idRB


  function ShiftOverDensityOfThePaper}
  function ShiftOverDensityOfThePaper(): Integer;
  begin
    Result := Round(1.7 * DensityOfThePaper * NSheetFcsNoteBook / 100);
    if Result < 0 then EMyError.Create('ShiftOverDensityOfThePaper');
  end;
begin
//////////////////////////

/////////////////////
  with GeneralPageOption do
    case IndexKoef of
      idLF:
        Result := GetSummAll(SheetOpt[IDX].fLeft,
            GetSumm(All, LAll, FAll, LFront), - ShiftOverDensityOfThePaper);
      idLB:
        Result := GetSummAll(SheetOpt[IDX].bLeft,
            GetSumm(All, LAll, BAll, LBack), - ShiftOverDensityOfThePaper);
      idRF:
        Result := GetSummAll(SheetOpt[IDX].fRight,
            GetSumm(All, RAll, FAll, RFront), ShiftOverDensityOfThePaper);
      idRB:
        Result := GetSummAll(SheetOpt[IDX].bRight,
            GetSumm(All, RAll, BAll, RBack), ShiftOverDensityOfThePaper);
    end;
end;

procedure TBookOption.SetOptionPage(IDX: Integer; IndexKoef: TIndexKoef;
  PageOption: TPageOption);
  procedure SetOpt(POpt: TPageOption);
  begin
    POpt.zoom := PageOption.zoom;
    POpt.shift.X := PageOption.shift.X;
    POpt.shift.Y := PageOption.shift.Y;
  end;
begin
  case IndexKoef of
    idLF: SetOpt(SheetOpt[IDX].fLeft);
    idLB: SetOpt(SheetOpt[IDX].bLeft);
    idRF: SetOpt(SheetOpt[IDX].fRight);
    idRB: SetOpt(SheetOpt[IDX].bRight);
  end;    
end;

function TBookOption.GetNumberPagesOfSheet: TNumberSheet;
begin
  Result := NumberBook.Sheet[NSheetFcs];
end;

function TBookOption.Get_nb_FisrtPage: Integer;
begin
  Result := NumberBook.FirstPage;
end;

function TBookOption.Get_nb_SheetsNoteBook: Integer;
begin
  Result := NumberBook.ShsNbk;
end;

procedure TBookOption.SetBook(FirstPage, EndPage,
  SheetsNoteBook: Integer);
begin
  if NumberBook.SetBook(FirstPage, EndPage, SheetsNoteBook) then
    SetBookOptionDefault;
end;

function TBookOption.GetNumberFocusSheetOfNoteBook: Integer;
var
  remainder: Integer;
begin
  remainder := NSheetFcs mod StsNtBk;
  if remainder = 0 then
    Result := StsNtBk - 1
  else
    Result := remainder - 1;
end;

{ TControlPageOption }

constructor TControlPageOption.Create;
begin
  ListNamePageInTask := TStringList.Create;
  if_exists_task := False;
  initial_(PathToPages + '\task.pbp');
end;

destructor TControlPageOption.Destroy;
begin
  ListNamePageInTask.Free;
end;

function TControlPageOption.initial_(way_to_file_task: string): Boolean;
var
  F: file of TKitUserOption;
begin
  Result := False;
  if_exists_task := False;
  if not FileExists(way_to_file_task) then
    Exit;
  AssignFile(F, way_to_file_task);
  try
    try
      Reset(F);
      read(F, KitUserOption);
      Result := True;
      if_exists_task := True;
    except
      Erase(F);
      raise EMyError.Create('�������� �������. ������� ����� �������!');

    end;
  finally
    CloseFile(F);
  end;
end;


function TControlPageOption.SaveTask(way_to_file_task: string): Boolean;
var
  F: file of TKitUserOption;
begin
  Result := False;
  AssignFile(F, way_to_file_task);
  try
    Rewrite(F);
    write(F, KitUserOption);
    Result := True;
    if_exists_task := True;
  finally
    CloseFile(F);
  end;
end;

function TControlPageOption.SaveTask: Boolean;
begin
  SaveTask(PathToPages + '\task.pbp')
end;

end.
