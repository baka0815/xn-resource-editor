object fmSpellChecker: TfmSpellChecker
  Left = 638
  Top = 203
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'Check Spelling'
  ClientHeight = 366
  ClientWidth = 542
  Color = clBtnFace
  Constraints.MinHeight = 316
  Constraints.MinWidth = 358
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = True
  Position = poMainFormCenter
  OnClose = FormClose
  OnDestroy = FormDestroy
  OnShow = FormShow
  DesignSize = (
    542
    366)
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 20
    Top = 20
    Width = 91
    Height = 16
    Caption = 'Unknown Word'
  end
  object lblSuggestions: TLabel
    Left = 20
    Top = 118
    Width = 75
    Height = 16
    Caption = 'Suggestions'
  end
  object btnChange: TButton
    Left = 431
    Top = 138
    Width = 92
    Height = 24
    Anchors = [akTop, akRight]
    Caption = '&Change'
    TabOrder = 1
    OnClick = btnChangeClick
  end
  object btnChangeAll: TButton
    Left = 431
    Top = 167
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Change A&ll'
    TabOrder = 2
    OnClick = btnChangeAllClick
  end
  object btnSkipAll: TButton
    Left = 431
    Top = 226
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Skip &All'
    TabOrder = 3
    OnClick = btnSkipAllClick
  end
  object btnSkip: TButton
    Left = 431
    Top = 197
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Skip'
    TabOrder = 4
    OnClick = btnSkipClick
  end
  object btnAdd: TButton
    Left = 431
    Top = 256
    Width = 92
    Height = 25
    Anchors = [akTop, akRight]
    Caption = '&Add'
    TabOrder = 5
    OnClick = btnAddClick
  end
  object btnCancel: TButton
    Left = 334
    Top = 309
    Width = 91
    Height = 31
    Anchors = [akRight, akBottom]
    Cancel = True
    Caption = 'Cancel'
    ModalResult = 2
    TabOrder = 6
  end
  object btnFinish: TButton
    Left = 431
    Top = 309
    Width = 92
    Height = 31
    Anchors = [akRight, akBottom]
    Caption = 'Finish'
    Default = True
    ModalResult = 1
    TabOrder = 7
  end
  object reText: TExRichEdit
    Left = 20
    Top = 39
    Width = 502
    Height = 61
    RightMargin = 0
    Anchors = [akLeft, akTop, akRight]
    AutoURLDetect = False
    AutoURLExecute = False
    BevelWidth = 0
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlack
    Font.Height = -15
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    HideSelection = False
    ParentFont = False
    TabOrder = 0
    WantReturns = False
    WordWrap = False
  end
  object lvSuggestions: TListView
    Left = 20
    Top = 138
    Width = 394
    Height = 150
    Anchors = [akLeft, akTop, akRight, akBottom]
    Columns = <
      item
        AutoSize = True
        Caption = 'Suggestions'
      end>
    ReadOnly = True
    RowSelect = True
    ShowColumnHeaders = False
    TabOrder = 8
    ViewStyle = vsReport
    OnDblClick = lvSuggestionsDblClick
  end
  object PersistentPosition1: TPersistentPosition
    Manufacturer = 'Woozle'
    Product = 'XanaNews'
    SubKey = 'Position\SpellChecker'
    Enabled = False
    Left = 32
    Top = 256
  end
end
