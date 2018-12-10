{.............................ANALISADOR LÉXICO..............................................}
{.............................UFG: BRUNO RICARDO BUENO MEDEIROS..............................}
{.............................Compiladores 1.................................................}
{.............................Trabalho 1.....................................................}
//OBJETIVO
{Ler um código fonte em MGOL e identificar elementos, popular tab-}
{ela de símbolos, reconhecer erros.}

unit uFrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uAutomatoLexico, uAnalisadorLexico,
  Vcl.StdCtrls, Data.DB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Grids,
  Vcl.DBGrids, Vcl.WinXCtrls, uAnalisadorSintatico;

type
  TfrmPrincipal = class(TForm)
    memoFonte: TMemo;
    Button1: TButton;
    DBGrid1: TDBGrid;
    memTblPrinc: TFDMemTable;
    memTblPrincTOKEN: TStringField;
    memTblPrincLEXEMA: TStringField;
    memTblPrincTIPO: TStringField;
    dsPrinc: TDataSource;
    DBGrid2: TDBGrid;
    MemTblSimb: TFDMemTable;
    DataSource1: TDataSource;
    MemTblSimbTOKEN: TStringField;
    MemTblSimbLEXEMA: TStringField;
    MemTblSimbTIPO: TStringField;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    memoLog: TMemo;
    Label4: TLabel;
    Label5: TLabel;
    memoProducoes: TMemo;
    Label6: TLabel;
    memoCodInt: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     var
        FAnaSintatico: TAnalisadorSintatico;
     procedure PreencherReconhecidos;
     procedure PreencherTabelaSimbolos;
     procedure PreencherProducoes;
     procedure PreencherCodigoInt;
     procedure PreencheLog;
     procedure EnumeraLinhasFonte;
     procedure LimparDados;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uClassesBase, System.Generics.Collections;

{$R *.dfm}


procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
   //Limpa análise passada
   LimparDados;

   try
      //Processa a análise completa
      FAnaSintatico.Exec;
   except
      on e: Exception do
      begin
         PreencheLog;
         Exit;
      end;
   end;

   //Preenche visualizações
   PreencherReconhecidos;
   PreencherTabelaSimbolos;
   PreencherProducoes;
   PreencherCodigoInt;
end;

procedure TfrmPrincipal.EnumeraLinhasFonte;
var
   lindex: integer;
begin
   //Enumerar as linhas do fonte(somente visualização)
   for lindex := 0 to pred(memoFonte.Lines.Count) do
   begin
      memoFonte.Lines[lindex] := lIndex.ToString + ': ' + memoFonte.Lines[lindex];
   end;
   //Ao final, acrescentar caracter de fim de arquivo
   Inc(lindex);
   memoFonte.Lines.Add(lindex.ToString + ':' + CHAR_EOF);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
   //Carregar fonte para a visualização
   memoFonte.Lines.LoadFromFile(CAMINHO_FONTE);
   EnumeraLinhasFonte;
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
   if Assigned(FAnaSintatico) then
   begin
      FAnaSintatico.Free;
   end;
end;

procedure TfrmPrincipal.LimparDados;
var
   lFonte: TStringList;
begin
   {Limpar itens de visualização e recarregar o analizador léxico}

   if not memTblPrinc.IsEmpty then
   begin
      memTblPrinc.EmptyDataSet;
   end;

   if not MemTblSimb.IsEmpty then
   begin
      memTblPrinc.EmptyDataSet;
   end;

   lFonte := TStringList.Create;
   try
      lFonte.LoadFromFile(CAMINHO_FONTE);
      lFonte.Add(CHAR_EOF);
//      FAnaLexico := TAnalisadorLexico.Create(lFonte.Text);
      FAnaSintatico := TAnalisadorSintatico.Create(lFonte.Text);
   finally
      lFonte.Free;
   end;

   memoProducoes.Clear;
   memoLog.Clear;
   memoCodInt.Clear;
end;

procedure TfrmPrincipal.PreencheLog;
begin
   memoLog.Lines.Text := FAnaSintatico.AnaLexico.Log.Text;
   memoLog.Lines.AddStrings(FAnaSintatico.log);
end;

procedure TfrmPrincipal.PreencherCodigoInt;
begin
   memoCodInt.Text := FAnaSintatico.AnaSemantico.GetCodigoFinal.Text;
   memoCodInt.Lines.SaveToFile('programa.c');
end;

procedure TfrmPrincipal.PreencherProducoes;
begin
   memoProducoes.Clear;
   memoProducoes.Lines.Text := FAnaSintatico.Saida.Text;
end;

procedure TfrmPrincipal.PreencherReconhecidos;
var
   lLinha: string;
   lPosArroba: integer;
begin
   //Preencher o grid com todos os itens que foram reconhecidos pelo analizador léxico;

   memTblPrinc.DisableControls;
   memTblPrinc.Close;
   if memTblPrinc.IsEmpty then
   begin
      memTblPrinc.CreateDataSet;
   end
   else
   begin
      memTblPrinc.EmptyDataSet;
   end;

   for lLinha in FAnaSintatico.AnaLexico.Saida do
   begin
      //Artifício de cópia e separação de itens para visualização
      if not lLinha.Trim.IsEmpty then
      begin
         memTblPrinc.Append;
         lPosArroba := Pos('@', lLinha);
         memTblPrincTOKEN.AsString := copy(lLinha, 1, lPosArroba - 1);
         memTblPrincLEXEMA.AsString := copy(lLinha, lPosArroba + 1, lLinha.Length);
         memTblPrincTIPO.AsString := TIPO_NULO;
         memTblPrinc.Post;
      end;
   end;
   memTblPrinc.First;
   memTblPrinc.EnableControls;
end;

procedure TfrmPrincipal.PreencherTabelaSimbolos;
var
   lChave: string;
begin
   //Preencher visualização com a tabela de símbolos fornecidas pelo analizador léxico
   MemTblSimb.DisableControls;
   MemTblSimb.Close;
   if MemTblSimb.IsEmpty then
   begin
      MemTblSimb.CreateDataSet;
   end
   else
   begin
      MemTblSimb.EmptyDataSet;
   end;

   for lChave in FAnaSintatico.AnaLexico.DicTabelaSimbolos.Keys do
   begin
      MemTblSimb.Append;
      MemTblSimbTOKEN.AsString  := FAnaSintatico.AnaLexico.DicTabelaSimbolos[lChave].Token.Trim;
      MemTblSimbLEXEMA.AsString := FAnaSintatico.AnaLexico.DicTabelaSimbolos[lChave].Lexema.Trim;
      MemTblSimbTIPO.AsString   := FAnaSintatico.AnaLexico.DicTabelaSimbolos[lChave].Tipo;
      MemTblSimb.Post;
   end;
   MemTblSimb.First;
   MemTblSimb.EnableControls;
end;

end.
