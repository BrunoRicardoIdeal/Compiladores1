unit uDmAux;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Comp.BatchMove.DataSet,
  FireDAC.Comp.BatchMove, FireDAC.Stan.Intf, FireDAC.Comp.BatchMove.Text,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.UI.Intf, FireDAC.VCLUI.Wait, FireDAC.Comp.UI,
  Data.FMTBcd, Data.SqlExpr;

type
  TDmAux = class(TDataModule)
    BatchReader: TFDBatchMoveTextReader;
    BatchMove: TFDBatchMove;
    BatchWriter: TFDBatchMoveDataSetWriter;
    memTblAction: TFDMemTable;
    memTblActionESTADO: TIntegerField;
    memTblActionTOKEN: TStringField;
    memTblGoto: TFDMemTable;
    IntegerField1: TIntegerField;
    StringField1: TStringField;
    memTblActionVALOR: TStringField;
    memTblGotoVALOR: TStringField;
    memTblGramatica: TFDMemTable;
    memTblGramaticaID: TIntegerField;
    memTblGramaticaORIGEM: TStringField;
    memTblGramaticaDESTINO: TStringField;
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DmAux: TDmAux;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDmAux.DataModuleCreate(Sender: TObject);
begin
   memTblAction.CreateDataSet;
   memTblGoto.CreateDataSet;
   memTblGramatica.CreateDataSet;
end;

end.
