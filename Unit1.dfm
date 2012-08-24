object Form1: TForm1
  Left = 172
  Top = 85
  Width = 981
  Height = 685
  Caption = #1060#1086#1088#1084#1072#1090#1080#1088#1086#1074#1072#1085#1080#1077' '#1087#1086#1090#1086#1082#1072' '#1087#1077#1095#1072#1090#1080
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm1
  OldCreateOrder = False
  OnActivate = FormActivate
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnKeyPress = FormKeyPress
  OnMouseDown = FormMouseDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlOption: TPanel
    Left = 0
    Top = 0
    Width = 185
    Height = 612
    Align = alLeft
    BevelInner = bvLowered
    TabOrder = 0
    object btn3: TSpeedButton
      Left = 24
      Top = 576
      Width = 33
      Height = 22
      Hint = 'Save As|Saves the active file with a new name'
      Caption = 'Save &As...'
      OnClick = SaveTask
    end
    object grpNumbering: TGroupBox
      Left = 2
      Top = 2
      Width = 181
      Height = 192
      Align = alTop
      Caption = #1056#1072#1089#1087#1086#1083#1086#1078#1077#1085#1080#1077' '#1089#1090#1088#1072#1085#1080#1094
      TabOrder = 0
      object rgBkBre: TRadioGroup
        Left = 2
        Top = 73
        Width = 177
        Height = 49
        Align = alTop
        ItemIndex = 0
        Items.Strings = (
          #1090#1077#1090#1088#1072#1076#1100
          #1082#1085#1080#1075#1072)
        TabOrder = 0
        OnClick = SetPagesOption
      end
      object pnlBookOption: TPanel
        Left = 2
        Top = 153
        Width = 177
        Height = 35
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 1
        Visible = False
        object lbl1: TLabel
          Left = 8
          Top = 0
          Width = 90
          Height = 13
          Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1082#1085#1080#1075#1080':'
        end
        object lbl2: TLabel
          Left = 6
          Top = 18
          Width = 92
          Height = 13
          Caption = #1051#1080#1089#1090#1086#1074' '#1074' '#1090#1077#1090#1088#1072#1076#1080':'
        end
        object seSheetsInTetrad: TSpinEdit
          Left = 133
          Top = 10
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
      end
      object pnlFirstEndPage: TPanel
        Left = 2
        Top = 122
        Width = 177
        Height = 31
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 2
        object lbl3: TLabel
          Left = 4
          Top = 10
          Width = 51
          Height = 13
          Caption = #1057#1090#1088#1072#1085#1080#1094' '#1089
        end
        object lbl4: TLabel
          Left = 103
          Top = 10
          Width = 12
          Height = 13
          Caption = #1087#1086
        end
        object seEndPage: TSpinEdit
          Left = 121
          Top = 4
          Width = 53
          Height = 22
          Increment = 4
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
        object seFirstPage: TSpinEdit
          Left = 61
          Top = 4
          Width = 41
          Height = 22
          Increment = 4
          MaxValue = 0
          MinValue = 0
          TabOrder = 1
          Value = 0
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
      end
      object pnlCount: TPanel
        Left = 2
        Top = 15
        Width = 177
        Height = 58
        Align = alTop
        BevelInner = bvLowered
        TabOrder = 3
        object lblPhysicalPages: TLabel
          Left = 8
          Top = 8
          Width = 103
          Height = 13
          Caption = #1057#1090#1088#1072#1085#1080#1094' '#1092#1080#1079#1080#1077#1089#1082#1080#1093':'
        end
        object lblWholePages: TLabel
          Left = 8
          Top = 24
          Width = 77
          Height = 13
          Caption = #1057#1090#1088#1072#1085#1080#1094' '#1074#1089#1077#1075#1086':'
        end
        object lblSheets: TLabel
          Left = 8
          Top = 40
          Width = 43
          Height = 13
          Caption = #1051#1080#1089#1090#1086#1074': '
        end
      end
    end
    object grpVisual: TGroupBox
      Left = 2
      Top = 194
      Width = 181
      Height = 113
      Align = alTop
      Caption = #1042#1080#1076' '#1089#1090#1088#1072#1085#1080#1094
      TabOrder = 1
      object rg1: TRadioGroup
        Left = 2
        Top = 15
        Width = 177
        Height = 72
        Align = alTop
        Caption = #1056#1077#1076#1072#1082#1090#1080#1088#1086#1074#1072#1090#1100' '#1087#1072#1082#1077#1090#1085#1086
        ItemIndex = 0
        Items.Strings = (
          #1074#1089#1077
          #1083#1077#1074#1099#1077' '#1080#1083#1080' '#1087#1088#1072#1074#1099#1077
          #1087#1077#1088#1077#1076#1085#1080#1077' '#1080#1083#1080' '#1086#1073#1088#1072#1090#1085#1099#1077
          #1086#1090#1076#1077#1083#1100#1085#1099#1077)
        TabOrder = 0
      end
      object btnResetEditView: TButton
        Left = 104
        Top = 86
        Width = 75
        Height = 25
        Caption = #1057#1073#1088#1086#1089
        TabOrder = 1
        OnClick = btnResetEditViewClick
      end
    end
    object grpOtionPrinting: TGroupBox
      Left = 2
      Top = 307
      Width = 181
      Height = 224
      Align = alTop
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1087#1077#1095#1072#1090#1080
      TabOrder = 2
      object grpPalletOption: TGroupBox
        Left = 2
        Top = 45
        Width = 177
        Height = 33
        Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1072' '#1083#1086#1090#1082#1086#1074
        TabOrder = 0
        Visible = False
        object lbl5: TLabel
          Left = 8
          Top = 15
          Width = 81
          Height = 13
          Caption = #1051#1080#1089#1090#1086#1074' '#1074' '#1083#1086#1090#1082#1077':'
        end
        object seSheetAtPallet: TSpinEdit
          Left = 111
          Top = 9
          Width = 41
          Height = 22
          Increment = 5
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
      end
      object chkReversPrint: TCheckBox
        Left = 8
        Top = 12
        Width = 147
        Height = 17
        Caption = #1054#1073#1088#1072#1090#1085#1072#1103' '#1087#1077#1095#1072#1090#1100' '#1079#1072#1076#1085#1080#1093
        TabOrder = 1
      end
      object cbbListPrinters: TComboBox
        Left = 2
        Top = 78
        Width = 178
        Height = 21
        ItemHeight = 13
        TabOrder = 2
        OnChange = cbbListPrintersChange
      end
      object pnlFirstEndPageOfPrint: TPanel
        Left = 2
        Top = 126
        Width = 177
        Height = 30
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 3
        object lbl6: TLabel
          Left = 2
          Top = 7
          Width = 62
          Height = 13
          Caption = #1057#1090#1088#1072#1085#1080#1094#1099' '#1089':'
        end
        object lbl7: TLabel
          Left = 108
          Top = 7
          Width = 15
          Height = 13
          Caption = #1087#1086':'
        end
        object sePrntBgnPg: TSpinEdit
          Left = 67
          Top = 5
          Width = 41
          Height = 22
          Increment = 2
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 1
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
        object sePrntEndPg: TSpinEdit
          Left = 125
          Top = 5
          Width = 49
          Height = 22
          Increment = 2
          MaxValue = 2
          MinValue = 1
          TabOrder = 1
          Value = 1
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
      end
      object rgSides: TRadioGroup
        Left = 2
        Top = 156
        Width = 177
        Height = 66
        Align = alBottom
        Caption = #1057#1090#1086#1088#1086#1085#1099
        ItemIndex = 0
        Items.Strings = (
          #1042#1089#1077
          #1055#1077#1088#1077#1076#1085#1080#1077
          #1047#1072#1076#1085#1080#1077
          #1055#1088#1086#1076#1086#1083#1078#1080#1090#1100' '#1089' '#1079#1072#1076#1085#1080#1093)
        TabOrder = 4
      end
      object chPallet: TCheckBox
        Left = 8
        Top = 28
        Width = 65
        Height = 17
        Caption = #1051#1086#1090#1082#1072#1084#1080
        TabOrder = 5
        OnClick = ChekedOptionPrinting
      end
      object pnl1: TPanel
        Left = 2
        Top = 99
        Width = 177
        Height = 27
        Align = alBottom
        BevelInner = bvLowered
        TabOrder = 6
        object lbl8: TLabel
          Left = 7
          Top = 8
          Width = 96
          Height = 13
          Caption = #1055#1083#1086#1090#1085#1086#1089#1090#1100' '#1073#1091#1084#1072#1075#1080':'
        end
        object seDensityOfThePaper: TSpinEdit
          Left = 133
          Top = 4
          Width = 41
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
          OnChange = SetPagesOption
          OnKeyDown = seFirstPageKeyDown
          OnKeyUp = seFirstPageKeyUp
        end
      end
    end
    object btn1: TButton
      Left = 128
      Top = 576
      Width = 51
      Height = 25
      Caption = 'btn1'
      TabOrder = 3
      OnClick = btn1Click
    end
    object btn2: TButton
      Left = 64
      Top = 544
      Width = 113
      Height = 25
      Caption = #1053#1072#1089#1090#1088#1086#1081#1082#1080' '#1087#1088#1080#1085#1090#1077#1088#1072
      TabOrder = 4
      OnClick = btn2Click
    end
  end
  object stat1: TStatusBar
    Left = 0
    Top = 612
    Width = 973
    Height = 19
    Panels = <
      item
        Width = 400
      end
      item
        Width = 50
      end>
  end
  object pnl3: TPanel
    Left = 185
    Top = 0
    Width = 788
    Height = 612
    Align = alClient
    BevelInner = bvLowered
    Caption = 'pnl3'
    TabOrder = 2
    object pnl4: TPanel
      Left = 2
      Top = 2
      Width = 784
      Height = 33
      Align = alTop
      BevelInner = bvLowered
      TabOrder = 0
    end
    object pnl5: TPanel
      Left = 2
      Top = 576
      Width = 784
      Height = 34
      Align = alBottom
      TabOrder = 1
      object ScrollBar1: TScrollBar
        Left = 3
        Top = 15
        Width = 614
        Height = 17
        LargeChange = 2
        Min = 1
        PageSize = 0
        Position = 1
        TabOrder = 0
        OnChange = ScrollBar1Change
      end
      object btnaPrint: TButton
        Left = 641
        Top = 8
        Width = 132
        Height = 25
        Action = aPrint
        TabOrder = 1
      end
    end
    object pnlForImg: TPanel
      Left = 2
      Top = 35
      Width = 784
      Height = 541
      Align = alClient
      BevelInner = bvLowered
      BevelOuter = bvLowered
      Caption = 'pnlForImg'
      TabOrder = 2
      OnResize = ResizePnlForImg
      object img1: TImage
        Left = 2
        Top = 2
        Width = 780
        Height = 537
        OnMouseDown = img1MouseDown
        OnMouseMove = img1MouseMove
        OnMouseUp = img1MouseUp
      end
    end
  end
  object mm1: TMainMenu
    Left = 312
    Top = 328
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Action = FileOpen1
      end
      object SaveTask1: TMenuItem
        Action = FileSaveAs1
      end
    end
    object Option1: TMenuItem
      Caption = 'Option'
      object Addtoautorun1: TMenuItem
        Action = aAddAutoRun
      end
    end
    object Help1: TMenuItem
      Caption = 'Help'
    end
  end
  object actlst1: TActionList
    Left = 273
    Top = 160
    object aUnset: TAction
      Caption = 'aUnset'
    end
    object aPrint: TAction
      Caption = #1056#1072#1089#1087#1077#1095#1072#1090#1072#1090#1100' '#1079#1072#1076#1072#1085#1080#1077
      OnExecute = aPrintExecute
    end
    object FileOpen1: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      BeforeExecute = FileOpen1BeforeExecute
    end
    object FileSaveAs1: TFileSaveAs
      Category = 'File'
      Caption = 'Save &As...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
    end
    object aChekPallet: TAction
      Caption = 'aChekPallet'
    end
    object aAddAutoRun: TAction
      Caption = 'aAddAutoRun'
      OnExecute = aAddAutoRunExecute
    end
  end
  object aplctnvnts1: TApplicationEvents
    OnIdle = aplctnvnts1Idle
    Left = 232
    Top = 480
  end
  object dlgPnt1: TPrintDialog
    Left = 99
    Top = 571
  end
  object dlgPntSet1: TPrinterSetupDialog
    Left = 11
    Top = 539
  end
  object dlgPageSetup1: TPageSetupDialog
    MinMarginLeft = 0
    MinMarginTop = 0
    MinMarginRight = 0
    MinMarginBottom = 0
    MarginLeft = 2500
    MarginTop = 2500
    MarginRight = 2500
    MarginBottom = 2500
    Options = [psoDefaultMinMargins, psoWarning]
    PageWidth = 21000
    PageHeight = 29700
    Left = 72
    Top = 568
  end
  object actlstUserOption: TActionList
    Left = 138
    Top = 234
    object aChBook: TAction
      Caption = 'aChBook'
    end
    object aSetFirstPage: TAction
      Caption = 'aSetFirstPage'
    end
    object aSetEndPage: TAction
      Caption = 'aSetEndPage'
    end
    object aSetSheetInThetrad: TAction
      Caption = 'aSetSheetInThetrad'
    end
  end
end
