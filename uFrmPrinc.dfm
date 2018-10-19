object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Analisador l'#233'xico'
  ClientHeight = 538
  ClientWidth = 1036
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 10
    Top = 11
    Width = 62
    Height = 13
    Caption = 'C'#243'digo fonte'
  end
  object Label2: TLabel
    Left = 354
    Top = 8
    Width = 91
    Height = 13
    Caption = 'Itens reconhecidos'
  end
  object Label3: TLabel
    Left = 706
    Top = 8
    Width = 90
    Height = 13
    Caption = 'Tabela de s'#237'mbolos'
  end
  object Label4: TLabel
    Left = 351
    Top = 470
    Width = 54
    Height = 13
    Caption = 'Mensagens'
  end
  object memoFonte: TMemo
    Left = 8
    Top = 32
    Width = 337
    Height = 433
    Lines.Strings = (
      '')
    ReadOnly = True
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 471
    Width = 337
    Height = 62
    Caption = 'Analisar'
    TabOrder = 1
    OnClick = Button1Click
  end
  object DBGrid1: TDBGrid
    Left = 351
    Top = 32
    Width = 349
    Height = 433
    DataSource = dsPrinc
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    ReadOnly = True
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TOKEN'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LEXEMA'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TIPO'
        Visible = True
      end>
  end
  object DBGrid2: TDBGrid
    Left = 706
    Top = 32
    Width = 314
    Height = 433
    DataSource = DataSource1
    ReadOnly = True
    TabOrder = 3
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'TOKEN'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LEXEMA'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'TIPO'
        Visible = True
      end>
  end
  object memoLog: TMemo
    Left = 351
    Top = 489
    Width = 669
    Height = 44
    Lines.Strings = (
      '')
    ReadOnly = True
    TabOrder = 4
  end
  object memTblPrinc: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 136
    Top = 216
    object memTblPrincTOKEN: TStringField
      FieldName = 'TOKEN'
    end
    object memTblPrincLEXEMA: TStringField
      FieldName = 'LEXEMA'
      Size = 100
    end
    object memTblPrincTIPO: TStringField
      FieldName = 'TIPO'
      Size = 1
    end
  end
  object dsPrinc: TDataSource
    DataSet = memTblPrinc
    Left = 136
    Top = 160
  end
  object MemTblSimb: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 792
    Top = 288
    object MemTblSimbTOKEN: TStringField
      FieldName = 'TOKEN'
    end
    object MemTblSimbLEXEMA: TStringField
      FieldName = 'LEXEMA'
      Size = 100
    end
    object MemTblSimbTIPO: TStringField
      FieldName = 'TIPO'
      Size = 1
    end
  end
  object DataSource1: TDataSource
    DataSet = MemTblSimb
    Left = 792
    Top = 240
  end
end
