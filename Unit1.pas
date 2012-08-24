unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Spin, ComCtrls, Menus, StdActns, ActnList,
  Registry, WinSpool, AppEvnts, BookOption_, Buttons;

type
  TImage = class(ExtCtrls.TImage)
  private
    //procedure WMSising(var message: TWMSize);
  public
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  end;

  TForm1 = class(TForm)
    aAddAutoRun: TAction;
    aChekPallet: TAction;
    actlst1: TActionList;
    Addtoautorun1: TMenuItem;
    aplctnvnts1: TApplicationEvents;
    aPrint: TAction;
    aUnset: TAction;
    btnResetEditView: TButton;
    btnaPrint: TButton;
    cbbListPrinters: TComboBox;
    chkReversPrint: TCheckBox;
    chPallet: TCheckBox;
    File1: TMenuItem;
    FileOpen1: TFileOpen;
    FileSaveAs1: TFileSaveAs;
    grpNumbering: TGroupBox;
    grpOtionPrinting: TGroupBox;
    grpPalletOption: TGroupBox;
    grpVisual: TGroupBox;
    Help1: TMenuItem;
    img1: TImage;
    lbl1: TLabel;
    lbl2: TLabel;
    lbl3: TLabel;
    lbl4: TLabel;
    lbl5: TLabel;
    lblPhysicalPages: TLabel;
    lblSheets: TLabel;
    lblWholePages: TLabel;
    mm1: TMainMenu;
    Open1: TMenuItem;
    Option1: TMenuItem;
    pnl3: TPanel;
    pnl4: TPanel;
    pnl5: TPanel;
    pnlBookOption: TPanel;
    pnlCount: TPanel;
    pnlFirstEndPage: TPanel;
    pnlOption: TPanel;
    rg1: TRadioGroup;
    rgBkBre: TRadioGroup;
    SaveTask1: TMenuItem;
    ScrollBar1: TScrollBar;
    seEndPage: TSpinEdit;
    seFirstPage: TSpinEdit;
    seSheetAtPallet: TSpinEdit;
    seSheetsInTetrad: TSpinEdit;
    stat1: TStatusBar;
    sePrntBgnPg: TSpinEdit;
    sePrntEndPg: TSpinEdit;
    lbl6: TLabel;
    lbl7: TLabel;
    pnlFirstEndPageOfPrint: TPanel;
    rgSides: TRadioGroup;
    btn1: TButton;
    pnlForImg: TPanel;
    dlgPnt1: TPrintDialog;
    dlgPntSet1: TPrinterSetupDialog;
    btn2: TButton;
    dlgPageSetup1: TPageSetupDialog;
    btn3: TSpeedButton;
    pnl1: TPanel;
    lbl8: TLabel;
    seDensityOfThePaper: TSpinEdit;
    actlstUserOption: TActionList;
    aChBook: TAction;
    aSetFirstPage: TAction;
    aSetEndPage: TAction;
    aSetSheetInThetrad: TAction;
    procedure ScrollBar1Change(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure img1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure img1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure img1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure btnResetEditViewClick(Sender: TObject);
    procedure aPrintExecute(Sender: TObject);
    procedure cbbListPrintersChange(Sender: TObject);
    procedure aAddAutoRunExecute(Sender: TObject);
    procedure AfterChangePrinter;
    procedure aplctnvnts1Idle(Sender: TObject; var Done: Boolean);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure SetPagesOption(Sender: TObject);
    procedure ChekedOptionPrinting(Sender: TObject);
    procedure ResizeImage(Sender: TObject);
    procedure ResizePnlForImg(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn2Click(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure SaveTask(Sender: TObject);
    procedure FileSaveAs1BeforeExecute(Sender: TObject);
    procedure FileOpen1BeforeExecute(Sender: TObject);
    procedure seFirstPageKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure seFirstPageKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);

  private
    { Private declarations }
    FileList: TStringList;
    function GetNewPoint(X, Y: Integer; PointOld_: TPoint): TPoint;
    procedure CorrectPagesAndPrintingsOption();
    procedure SetDefaultPagesOption();
    procedure SetDefaultPrintingsOption();
    function FromTask(ControlPageOption: TControlPageOption): Boolean;
    procedure Registration();
    procedure WaitingThePrinter;
    procedure SetBook(FirstPage, EndPage: Integer;
        SheetsNoteBook: Integer = 0);
    procedure WMMouseWheel(var Message: TWMMouseWheel); message WM_MOUSEWHEEL;
  public
    //function Sort_StrIntegr(sList: TStringList; IDX1, IDX2: Integer): Integer;
    { Public declarations }
  end;

  function Sort_StrIntegr(sList: TStringList; IDX1,
    IDX2: Integer): Integer;

var
  Form1: TForm1;

implementation

uses
  ProcessingBeforePrinting_, Types, File_, Graphic_, Math, Globals;

{$R *.dfm}
var
  focused_: Boolean;
  ifMonitoring: Boolean;
  PointOld: TPoint;
  ProcessingBeforePrinting: TProcessingBeforePrinting;
  SidePagFcs: TSidePage;
  ifChangePagesOption,
  ifChangePrintingsOption,
  ifChangeScrool: Boolean;
  ifImgResize: Boolean;
  MaxPages: Integer;

// прокрутка страниц
procedure TForm1.ScrollBar1Change(Sender: TObject);
begin
  if ifChangeScrool then
    Exit;
  ifChangeScrool := True;

  Application.ProcessMessages;
  ProcessingBeforePrinting.LoadImgToPrw();

  ifChangeScrool := False;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ScrollBar1.SetFocus;
  FileList := TStringList.Create;
  FindFileToList(PathToPages, FileList);
  FileList.Sorted := False;
  FileList.CustomSort(Sort_StrIntegr);
  ProcessingBeforePrinting := TProcessingBeforePrinting.Create(FileList, img1,
      ScrollBar1, cbbListPrinters);
  with ProcessingBeforePrinting do
    if ControlPageOption.if_exists_task then
      FromTask(ControlPageOption)
    else
      if FileList.Count > 0 then
      begin
        SetBook(1, FileList.Count);
        LoadImgToPrw();  // это устанавливать
        //SetDefaultPagesOption;
        CorrectPagesAndPrintingsOption;         // здесь и поступление заданий
        SetPagesOption(Self);
        MessageDlg('Есть незавершенные задания', mtInformation, [mbOK], 0);

      end
      else
        ifMonitoring := True;

  ResizePnlForImg(Sender);
  //WaitingThePrinter;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ScrollBar1.SetFocus;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // для перемещения картинки
  PointOld := Point(0, 0);
  focused_ := False;
  ifMonitoring := False;
  ifChangePagesOption := False;
  ifChangePrintingsOption := False;
  ifChangeScrool := False;
  img1.OnResize := ResizeImage;
  ifImgResize := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FileList.Free;
  ProcessingBeforePrinting.Destroy;
end;

procedure TForm1.img1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  focused_ := True;
  PointOld := GetNewPoint(X, Y, PointOld);
  if X < img1.Width / 2 then
    SidePagFcs := LSidePage
  else
    SidePagFcs := RSidePage;

  ProcessingBeforePrinting.CSmallImg := img1.Picture.Bitmap;

end;

function TForm1.GetNewPoint(X, Y: Integer; PointOld_: TPoint): TPoint;
begin
  Result.X := - PointOld.X + X;
  Result.Y := - PointOld.Y + Y;
end;

procedure TForm1.img1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  PageOption: TPageOption;
begin
  focused_ := False;
//  PageOption.shift := GetNewPoint(X, Y, PointOld);
//  PageOption.zoom := 0;
//  with ProcessingBeforePrinting do
//    case rg1.ItemIndex of
//      0: SetOption(PageOption, AllPart, SidePagFcs); {все страницы}
//      1: SetOption(PageOption, AllPartsSide, SidePagFcs); {левые или правые}
//      2: SetOption(PageOption, AllBkFt, SidePagFcs); {передние или обратные}
//      3: SetOption(PageOption, SeparatePart, SidePagFcs);{отдельно}
//    end;
//  ProcessingBeforePrinting.ClearView;
//  ProcessingBeforePrinting.Preview(LSidePage);
//  ProcessingBeforePrinting.Preview(RSidePage);
  ProcessingBeforePrinting.Preview(LSidePage);
  ProcessingBeforePrinting.Preview(RSidePage);
  PointOld := Point(0, 0);
end;

procedure TForm1.img1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  PageOption: TPageOption;
begin
  Application.ProcessMessages;
  if GetKeyState(VK_CONTROL) and 128 = 128 then
    if X < img1.Width / 2 then
      SidePagFcs := LSidePage
    else
      SidePagFcs := RSidePage;

  if not focused_ then
    Exit;
  PageOption.shift := GetNewPoint(X, Y, PointOld);
  PageOption.zoom := 0;
  with ProcessingBeforePrinting do
  begin
    case rg1.ItemIndex of
      0: SetOption(PageOption, AllPart, SidePagFcs); {все страницы}
      1: SetOption(PageOption, AllPartsSide, SidePagFcs); {левые или правые}
      2: SetOption(PageOption, AllBkFt, SidePagFcs); {передние или обратные}
      3: SetOption(PageOption, SeparatePart, SidePagFcs);{отдельно}
    end;
    PointOld := Point(X, Y);
    ClearView;
    PreviewSmall;
//    Preview(LSidePage);
//    Preview(RSidePage);
  end;


end;

{ TImage }

procedure TImage.WMMouseWheel(var Message: TWMMouseWheel);
  procedure Zommed(I: Integer);
  var
    PageOption: TPageOption;
  begin
    PageOption.shift := Point(0, 0);
    PageOption.zoom := I;
    with ProcessingBeforePrinting do
      case Form1.rg1.ItemIndex of
        0: SetOption(PageOption, AllPart, SidePagFcs); {все страницы}
        1: SetOption(PageOption, AllPartsSide, SidePagFcs); {левые или правые}
        2: SetOption(PageOption, AllBkFt, SidePagFcs); {передние или обратные}
        3: SetOption(PageOption, SeparatePart, SidePagFcs);{отдельно}
      end;
    ProcessingBeforePrinting.ClearView;
    ProcessingBeforePrinting.Preview(LSidePage);
    ProcessingBeforePrinting.Preview(RSidePage);
    PointOld := Point(0, 0);
  end;
begin
  Application.ProcessMessages;
  if GetKeyState(VK_CONTROL) and 128 = 128 then
  begin
    if Message.WheelDelta > 0 then
      Zommed(10);
    if Message.WheelDelta < 0 then
      Zommed(-10);
  end;
end;

// сброс установок вида страниц
procedure TForm1.btnResetEditViewClick(Sender: TObject);
begin
  with ProcessingBeforePrinting do
  begin
    SetDefault;
    rg1.ItemIndex := 0;
    rg1.Refresh;
    ClearView;
    Preview(LSidePage);
    Preview(RSidePage);
  end;
end;

// опции по умолчанию зависят в основном от
// sheets
procedure TForm1.SetDefaultPagesOption;
begin
//  if ifChangePagesOption then
//    Exit;
  ifChangePagesOption := True;
  // панель pnlFirstEndPage
  with ProcessingBeforePrinting do
  begin
    with seFirstPage do
    begin
      MinValue := 1;
      MaxValue := FileList.Count;
      Value := FstPg;
    end;

    with seEndPage do
    begin
      MinValue := 1;
      MaxValue := FileList.Count;
      Value := FstPg - 1 + sheets * 4;
    end;
  end;
  ifChangePagesOption := False;
end;

// опции по умолчанию зависят в основном от
// sheets
procedure TForm1.SetDefaultPrintingsOption();
begin
//  if ifChangePagesOption then
//    Exit;
  ifChangePagesOption := True;
  // панель grpOtionPrinting - настройка печати
  with ProcessingBeforePrinting do
  begin
    case sheets of
    1..8:
      chPallet.Checked := False;
    else
      chPallet.Checked := True;
    end;

    with sePrntBgnPg do
      begin
        MinValue := 1;
        MaxValue := sheets * 2 - 1;
        Value := 1;
      end;

    with sePrntEndPg do
      begin
        MinValue := 2;
        MaxValue := sheets *2;
        Value := sheets * 2;
      end;
  end;
  ifChangePagesOption := False;
end;

// установка пользователем опций нумерации
procedure TForm1.SetPagesOption(Sender: TObject);
var
  ifInteger,
  code: Integer;
begin
  if ifChangePagesOption then
    Exit;
  ifChangePagesOption := True;

  // проверяем тип поля со стрелочками
  if (Sender is TSpinEdit) then
    begin
      Val(Trim((Sender as TSpinEdit).Text), ifInteger, code);
      if code <> 0 then
        begin
          ifChangePagesOption := False;
          Abort;
        end;
    end;


  with ProcessingBeforePrinting do
    begin
      if
//        (Sender.ClassName = 'TForm1')
//          or
          ((Sender is TSpinEdit) and ('seFirstPage' =
            (Sender as TSpinEdit).Name))
          or
            ((Sender is TSpinEdit) and ('seEndPage' =
              (Sender as TSpinEdit).Name))
          or
            ((Sender is TRadioGroup) and ('rgBkBre' =
              (Sender as TRadioGroup).Name))
          or
            ((Sender is TSpinEdit) and ('seSheetsInTetrad' =
              (Sender as TSpinEdit).Name))
          then
        begin
          ifChangeScrool := True;

          case rgBkBre.ItemIndex of // выбрана книга или брошюра
          0:
            with ProcessingBeforePrinting do
            begin
              pnlBookOption.Visible := False; // брошюра
              seSheetsInTetrad.Value := -1;
              SetBook(seFirstPage.Value, seEndPage.Value);
            end;
          1:
            with ProcessingBeforePrinting do
              if sheets > 1 then
                begin
                  pnlBookOption.Visible := True; //включаем панель книга
                  if seSheetsInTetrad.Value <= 0 then // если по умолчанию брошюра
                    seSheetsInTetrad.Value := -1;     // то пытаемся поставить книгу
                                                      // по умолчанию
                  SetBook(seFirstPage.Value, seEndPage.Value, seSheetsInTetrad.Value);
                end
              else
                pnlBookOption.Visible := False; // брошюра
          end;
          
          ifChangeScrool := False;
        end;


      //опции печати
      //проверяем и устанавливаем границы печати
      if not Odd(sePrntBgnPg.Value) then
        begin
          if (sePrntBgnPg.Value >= sePrntBgnPg.MinValue) and
              (sePrntBgnPg.Value <= sePrntBgnPg.MaxValue) then
            sePrntBgnPg.Value := sePrntBgnPg.Value - 1
          else
            sePrntBgnPg.Value := sePrntBgnPg.MinValue;
        end;

      if Odd(sePrntEndPg.Value) then
        begin
          if (sePrntEndPg.Value >= sePrntEndPg.MinValue) and
              (sePrntEndPg.Value <= sePrntEndPg.MaxValue) then
            sePrntEndPg.Value := sePrntEndPg.Value + 1
          else
            sePrntEndPg.Value := sePrntEndPg.MaxValue;
        end;

          
      if  ((Sender is TSpinEdit) and ('sePrntBgnPg' =
            (Sender as TSpinEdit).Name))
          or
          ((Sender is TSpinEdit) and ('sePrntEndPg' =
            (Sender as TSpinEdit).Name)) then
        begin
          if ((Sender is TSpinEdit) and ('sePrntBgnPg' =
                (Sender as TSpinEdit).Name)) then
            if sePrntBgnPg.Value >= sePrntEndPg.Value then
              sePrntBgnPg.Value := sePrntBgnPg.MinValue;

          if ((Sender is TSpinEdit) and ('sePrntEndPg' =
                  (Sender as TSpinEdit).Name)) then
            if sePrntEndPg.Value <= sePrntBgnPg.Value then
              sePrntEndPg.Value := sePrntEndPg.MaxValue;
        end
      else
        begin
          if sePrntBgnPg.Value >= sePrntEndPg.Value then
            sePrntBgnPg.Value := sePrntBgnPg.MinValue;
          if sePrntEndPg.Value <= sePrntBgnPg.Value then
            sePrntEndPg.Value := sePrntEndPg.MaxValue;
        end;





      // корректируем лотки по границам печати
      if (seSheetAtPallet.Value < 1) or
          (seSheetAtPallet.Value * 2 > sePrntEndPg.Value - sePrntBgnPg.Value
              + 1) then
        seSheetAtPallet.Value := Round((sePrntEndPg.Value - sePrntBgnPg.Value
            + 1) / 2);

      // корректируем фокус по границам печати
      SetPageScrollBar(sePrntBgnPg.Value, sePrntEndPg.Value);

      DensityOfThePaper := seDensityOfThePaper.Value;
    end;
  //SetOptionPrinting(Sender);

  ifChangePagesOption := False;

  CorrectPagesAndPrintingsOption;
end;

{ корректировка пользовательских опций
  настройки ProcessingBeforePrinting не меняются,
  меняется только GUI
}
procedure TForm1.CorrectPagesAndPrintingsOption;
begin
  // запрещаем обработку SetPagesOption(Sender: TObject);
  ifChangePagesOption := True;

  with ProcessingBeforePrinting do
  begin
    // панель pnlCount - информция о задании
    lblPhysicalPages.Caption := 'Страниц физических: ' + IntToStr(FileList.Count);
    lblWholePages.Caption := 'Страниц всего: ' +
        IntToStr(sheets * 4);
    lblSheets.Caption := 'Листов: ' + IntToStr(sheets);

    // панель pnlFirstEndPage
    with seFirstPage do
      if Value >= seEndPage.Value then
        Value := seEndPage.Value - 1;


    with seEndPage do
      if Value <= seFirstPage.Value then
        Value := seFirstPage.Value + 1;

    // панель seSheetsInTetrad
    // листов в тетради для брошюры должно быть (-1)  ?????????

    case StsNtBk of
      0: seSheetsInTetrad.Value := -1;

    else
      if sheets = StsNtBk then // если получилась тетрадь
        begin
          pnlBookOption.Visible := False;
          seSheetsInTetrad.Value := sheets;
          rgBkBre.ItemIndex := 0;
        end
      else // книга
        begin
          seSheetsInTetrad.Value := StsNtBk;
          pnlBookOption.Visible := True;
          rgBkBre.ItemIndex := 1;
        end;
    end;

    seDensityOfThePaper.Value := DensityOfThePaper;
  end;

  grpNumbering.Refresh;
  ProcessingBeforePrinting.LoadImgToPrw;

  ifChangePagesOption := False;
end;

// установка пользователем опций печати лотками
procedure TForm1.ChekedOptionPrinting(Sender: TObject);
begin
  if ifChangePagesOption then
    Exit;
  ifChangePagesOption := True;
  with ProcessingBeforePrinting do
    case chPallet.Checked of
      True:
        begin
          grpPalletOption.Visible := True;
          seSheetAtPallet.Value := Round(sheets / 2 + 1);
        end;
      False:
        begin
          grpPalletOption.Visible := False;
          seSheetAtPallet.Value := sheets;
        end;
    end;

  ifChangePagesOption := False;
end;

// выбор принтера для печати
procedure TForm1.cbbListPrintersChange(Sender: TObject);
begin
  with ProcessingBeforePrinting do
  begin
    SetPrinter;
  end;
end;

// печать подготовленного документа
procedure TForm1.aPrintExecute(Sender: TObject);
var
  SidesSheet: MSidesSheet;
begin
  case rgSides.ItemIndex of
    0: SidesSheet := [FASE, BACK];  // Все
    1: SidesSheet := [FASE];  // Передние
    2: SidesSheet := [BACK];  // Задние
    3: SidesSheet := [FromBack];  // Продолжить с задних
  else
    raise EMyError.Create('Not Index Sides');
  end;

  SaveTask(Sender);

  with ProcessingBeforePrinting do
  begin
    SaveTask(ControlPageOption.UserOption.GeneralPageOption);
    Print(sePrntBgnPg.Value, seSheetAtPallet.Value * 2,
        chkReversPrint.Checked, SidesSheet);
  end;

  ShowMessage('Печать окончена');
end;

procedure TForm1.Registration;
var
  // Переменная реестра
  h: TRegistry;
begin
  h := TRegistry.Create;
  try
    with h do
    begin
      RootKey := HKEY_LOCAL_MACHINE;
      OpenKey ('\Software\Microsoft\Windows\CurrentVersion\Run', true);
      WriteString('ProcessingBeforePrinting', Application.ExeName);
      CloseKey;
    end;
  finally
    h.Free;
  end;
end;

// монитор принтера
procedure TForm1.WaitingThePrinter;
var
  hPrinter, hChanges: THandle;
  NotifyOption: TPrinterNotifyOptions;
  NotifyTipes: TPrinterNotifyOptionsType;
  Field: TPrinterNotifyInfoData;
begin
  ifMonitoring := False;
  if OpenPrinter('Print To Picture printer', hPrinter, nil) then
  try
    NotifyTipes.wType := JOB_NOTIFY_TYPE;
    NotifyTipes.Reserved0 := 0;
    NotifyTipes.Reserved1 := 0;
    NotifyTipes.Reserved2 := 0;
    NotifyTipes.Count := 1;
    NotifyTipes.pFields := @Field;
    NotifyOption.Version := 2;
    NotifyOption.Flags := PRINTER_CHANGE_JOB;
    NotifyOption.Count := 1;                           //PRINTER_CHANGE_ALL
    NotifyOption.pTypes := @NotifyTipes;
    hChanges := FindFirstPrinterChangeNotification(
        hPrinter, PRINTER_CHANGE_JOB, 0, @NotifyOption);
    if hChanges = INVALID_HANDLE_VALUE then
      RaiseLastOSError
    else
    try
      case WaitForSingleObject(hChanges, INFINITE) of
        WAIT_OBJECT_0: AfterChangePrinter;
        //ShowMessage('Есть изменения');
        WAIT_FAILED: RaiseLastOSError;
      end;
    finally
      FindClosePrinterChangeNotification(hChanges);
    end;
  finally
    ClosePrinter(hPrinter);
  end;
end;

// добавление в автозагрузку
procedure TForm1.aAddAutoRunExecute(Sender: TObject);
begin
  Registration;
end;

procedure TForm1.AfterChangePrinter; // поступление нового задания на принтер
var
  i: Integer;
begin
  Form1.Show;
  Application.ProcessMessages;
  i := 0;
  while(i < 200) do
  begin
    Sleep(100);
    Application.ProcessMessages;
    Inc(i);
  end;

  FindFileToList(PathToPages, FileList);
  FileList.Sorted := False;
  FileList.CustomSort(Sort_StrIntegr);                  // это устанавливать
  SetBook(1, FileList.Count);  // в activae и здесь
  SetDefaultPagesOption;
  ProcessingBeforePrinting.LoadImgToPrw();
  CorrectPagesAndPrintingsOption;
end;

// для действий во время простоя
procedure TForm1.aplctnvnts1Idle(Sender: TObject; var Done: Boolean);
begin
  if ifMonitoring then
  begin
    Form1.Hide;
    Application.ProcessMessages;
    WaitingThePrinter;
  end;

  //
  if ProcessingBeforePrinting <> nil then
    begin
      stat1.Panels.Items[0].Text := 'Стр. ' + IntToStr(ProcessingBeforePrinting.NPageFcs);
    end;  
end;

// для числовой сортировки TStringList
function Sort_StrIntegr(sList: TStringList; IDX1,
  IDX2: Integer): Integer;

  function Sort(s1,s2: string): Integer;

    function PopInteger(var Beg_: Integer; const s: string): string;
      function ifGetNumber(Beg_: Integer; const s: string): string;
      begin
        Result := '';
        if s[Beg_] in ['0'..'9'] then
          Result := s[Beg_] + ifGetNumber(Beg_ + 1, s);
      end;
    begin
      repeat
        Result := ifGetNumber(Beg_, s);
        if Result <> '' then
          Break;
        Inc(Beg_);
      until Beg_ > Length(s);
    end;
  var
    Beg_1,
    Beg_2: Integer;
    chislo1,
    chislo2: string;
  begin
    Result := 0;
    Beg_1 := 0;
    Beg_2 := 0;
    chislo1 := PopInteger(Beg_1, s1);
    chislo2 := PopInteger(Beg_2, s2);
    if (chislo1 <> '') and (chislo2 <> '') and (Beg_1 = Beg_2) and
      (CompareText(Copy(s1, 0, Beg_1 - 1), Copy(s2, 0, Beg_2 - 1)) = 0) then
    begin
      if StrToInt(chislo1) > StrToInt(chislo2) then
      begin
        Result := 1;
        Exit;
      end;
      if StrToInt(chislo1) < StrToInt(chislo2) then
      begin
        Result := -1;
        Exit;
      end;
      if (StrToInt(chislo1) = StrToInt(chislo2)) and
          (Length(s1) - Length(chislo1) > 0) and
          (Length(s2) - Length(chislo2) > 0) then
      begin
        Result := Sort(
            PChar(s1) + Beg_1 + Length(chislo1) - 1,
            PChar(s2) + Beg_2 + Length(chislo2) - 1
        );
        Exit;
      end;
    end;
    Result := CompareText(s1, s2);
  end;
begin
  if IDX1 = IDX2 then
    Result := 0
  else
    Result := Sort(ChangeFileExt(sList.Strings[IDX1], ''),
        ChangeFileExt(sList.Strings[IDX2], ''))
end;

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
//  CanClose := False;
//  ifMonitoring := True;
end;

procedure TForm1.ResizeImage(Sender: TObject);
begin
  img1.Picture.Bitmap.Height := img1.Height;
  img1.Picture.Bitmap.Width := img1.Width;
end;

procedure TForm1.ResizePnlForImg(Sender: TObject);
var
  HorzRes_1,
  VertRes_1: Integer;
begin
  //
  Application.ProcessMessages;
  if ProcessingBeforePrinting <> nil then
  with ProcessingBeforePrinting, ProcessingBeforePrinting.PrinterParameter,
      pnlForImg do
  begin
    if RoundTo(HorzRes_ / VertRes_, - 2) > RoundTo(Width / Height, - 2) then
    begin
      HorzRes_1 := HorzRes_;
      VertRes_1 := VertRes_;

      img1.Align := alTop;
      img1.Refresh;
      img1.Height := Round(img1.Width / (HorzRes_ / VertRes_));
    end
    else
    begin
      img1.Align := alLeft;
      img1.Refresh;
      img1.Width := Round(img1.Height * (HorzRes_ / VertRes_));
    end;

    // перерисовываем картинки
    ClearView;
    Preview(LSidePage);
    Preview(RSidePage);

  end;
end;

procedure TForm1.btn1Click(Sender: TObject);

type
  TMargins = record
    Left,
      Top,
      Right,
      Bottom: Double
  end;

  procedure GetPrinterMargins(var Margins: TMargins);
  var
    PixelsPerInch: TPoint;
    PhysPageSize: TPoint;
    OffsetStart: TPoint;
    PageRes: TPoint;
  begin
    with ProcessingBeforePrinting do
    begin
      PixelsPerInch.y := GetDeviceCaps(Prntr.Handle, LOGPIXELSY);
      PixelsPerInch.x := GetDeviceCaps(Prntr.Handle, LOGPIXELSX);
      Escape(Prntr.Handle, GETPHYSPAGESIZE, 0, nil, @PhysPageSize);
      Escape(Prntr.Handle, GETPRINTINGOFFSET, 0, nil, @OffsetStart);
      PageRes.y := GetDeviceCaps(Prntr.Handle, VERTRES);
      PageRes.x := GetDeviceCaps(Prntr.Handle, HORZRES);
      // Top Margin
      Margins.Top := OffsetStart.y / PixelsPerInch.y;
      // Left Margin
      Margins.Left := OffsetStart.x / PixelsPerInch.x;
      // Bottom Margin
      Margins.Bottom := ((PhysPageSize.y - PageRes.y) / PixelsPerInch.y) -
        (OffsetStart.y / PixelsPerInch.y);
      // Right Margin
      Margins.Right := ((PhysPageSize.x - PageRes.x) / PixelsPerInch.x) -
        (OffsetStart.x / PixelsPerInch.x);
    end;

  end;

  function InchToCm(Pixel: Single): Single;
  // Convert inch to Centimeter
  begin
    Result := Pixel * 2.54
  end;

var
  Margins: TMargins;
begin
  //dlgPntSet1.Execute;
  if not dlgPageSetup1.Execute then
    Exit;
  GetPrinterMargins(Margins);
  with ProcessingBeforePrinting.PrinterParameter do
    ShowMessage(Format('Margins: (Left: %1.3f, Top: %1.3f, Right: %1.3f, Bottom: %1.3f)',
      [InchToCm(Margins.Left),
        InchToCm(Margins.Top),
          InchToCm(Margins.Right),
            InchToCm(Margins.Bottom)]));

  //img1.WMMouseWheel();
end;

procedure TForm1.WMMouseWheel(var Message: TWMMouseWheel);
begin
  img1.WMMouseWheel(Message);
end;

procedure TForm1.btn2Click(Sender: TObject);
begin
  //dlgPntSet1.Execute;
  if dlgPnt1.Execute then
    cbbListPrinters.ItemIndex := ProcessingBeforePrinting.Prntr.PrinterIndex;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
begin
  ScrollBar1.SetFocus
end;

function TForm1.FromTask(ControlPageOption: TControlPageOption): Boolean;
  function FromTask_(): Boolean;
  begin
    with ControlPageOption.UserOption, ProcessingBeforePrinting do
      with GeneralPageOption do
        begin
          SetBook(firstpage, endpage, SheetsInNoteBook);

          ifChangePagesOption := True;

//          ShowMessage(Format('firstpage: %d, endpage: %d, SheetsInNoteBook: %d, PagesInPallet: %d, begPagesToPrint: %d, endPagesToPrint: %d, DensityOfThePaper: %d, MinPage: %d, MaxPage: %d', [firstpage, endpage, SheetsInNoteBook, PagesInPallet, begPagesToPrint, endPagesToPrint, DensityOfThePaper, MinPage, MaxPage])
//          );
          seFirstPage.Value := firstpage;
          seEndPage.Value := endpage;
          seSheetsInTetrad.Value := SheetsInNoteBook;
          //LoadTask(GeneralPageOption);
          chkReversPrint.Checked := ifReversPrint;
          chPallet.Checked := ifPallet;
          seSheetAtPallet.Value := PagesInPallet;
          sePrntBgnPg.Value := begPagesToPrint;
          sePrntEndPg.Value := endPagesToPrint;
          rgSides.ItemIndex := Integer(SidesSheet);
          seDensityOfThePaper.Value := ControlPageOption.UserOption.DensityOfThePaper; //DensityOfThePaper;
          SetPageScrollBar(MinPage, MaxPage);
        end;
  end;
begin
  Result := False;
  // отмена обработчика события
  if ifChangePagesOption then
    Exit;
  ifChangePagesOption := True;
  //////////////
    FromTask_;
  //////////////
  ifChangePagesOption := False;
  Result := True;

  SetPagesOption(Self);
  // ставим LoadTask после SetPagesOption(Self);
  // потому что SetPagesOption(Self) обнуляет настройки вида
  with ProcessingBeforePrinting do
    LoadTask(ControlPageOption.UserOption.GeneralPageOption);

//  SetDefaultPrintingsOption;
//  SetDefaultPagesOption;
end;

procedure TForm1.SaveTask(Sender: TObject);
begin
  with ProcessingBeforePrinting,
      ProcessingBeforePrinting.ControlPageOption.UserOption do
    with GeneralPageOption do
      begin
        firstpage := seFirstPage.Value;
        endpage := seEndPage.Value;
        SheetsInNoteBook := seSheetsInTetrad.Value;
        ifReversPrint := chkReversPrint.Checked;
        ifPallet := chPallet.Checked;
        PagesInPallet := seSheetAtPallet.Value;
        begPagesToPrint := sePrntBgnPg.Value;
        endPagesToPrint := sePrntEndPg.Value;
        SidesSheet := TSideSheet2(rgSides.ItemIndex);
        DensityOfThePaper := seDensityOfThePaper.Value;
        MinPage := Min;
        MaxPage := Max;
        SaveTask(GeneralPageOption);
      end;
end;

procedure TForm1.FileSaveAs1BeforeExecute(Sender: TObject);
begin
  SaveTask(Sender);
end;

procedure TForm1.FileOpen1BeforeExecute(Sender: TObject);
begin
  ShowMessage('');
end;


type
  THAckProcessingBeforePrinting = class(TProcessingBeforePrinting);

procedure TForm1.SetBook(FirstPage, EndPage, SheetsNoteBook: Integer);

begin
  THAckProcessingBeforePrinting(ProcessingBeforePrinting).SetBook(FirstPage, EndPage, SheetsNoteBook);
  SetDefaultPrintingsOption;
  SetDefaultPagesOption;
  ChekedOptionPrinting(Self);
end;

procedure TForm1.seFirstPageKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    begin
      ifChangePagesOption := False;
      SetPagesOption(Sender);
    end
  else
    ifChangePagesOption := True;
end;

procedure TForm1.seFirstPageKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ifChangePagesOption := False;
end;

end.



