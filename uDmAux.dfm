object DmAux: TDmAux
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 236
  Width = 391
  object BatchReader: TFDBatchMoveTextReader
    DataDef.Fields = <>
    DataDef.Delimiter = '"'
    DataDef.Separator = ';'
    DataDef.RecordFormat = rfCustom
    Left = 88
    Top = 112
  end
  object BatchMove: TFDBatchMove
    Reader = BatchReader
    Writer = BatchWriter
    Mappings = <>
    LogFileName = 'Data.log'
    Left = 88
    Top = 64
  end
  object BatchWriter: TFDBatchMoveDataSetWriter
    DataSet = memTblGramatica
    Left = 88
    Top = 160
  end
  object memTblAction: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 64
    object memTblActionESTADO: TIntegerField
      FieldName = 'ESTADO'
    end
    object memTblActionTOKEN: TStringField
      FieldName = 'TOKEN'
      Size = 15
    end
    object memTblActionVALOR: TStringField
      FieldName = 'VALOR'
    end
  end
  object memTblGoto: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 120
    object IntegerField1: TIntegerField
      FieldName = 'ESTADO'
    end
    object StringField1: TStringField
      FieldName = 'TOKEN'
      Size = 15
    end
    object memTblGotoVALOR: TStringField
      FieldName = 'VALOR'
    end
  end
  object memTblGramatica: TFDMemTable
    IndexFieldNames = 'ID'
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 176
    Top = 176
    object memTblGramaticaID: TIntegerField
      FieldName = 'ID'
      Required = True
    end
    object memTblGramaticaORIGEM: TStringField
      FieldName = 'ORIGEM'
      Required = True
    end
    object memTblGramaticaDESTINO: TStringField
      FieldName = 'DESTINO'
      Required = True
    end
  end
  object FDGUIxWaitCursor1: TFDGUIxWaitCursor
    Provider = 'Forms'
    Left = 88
    Top = 16
  end
end
