unit uAnalisadorSemantico;

interface
   uses
      System.SysUtils, System.Classes, uClassesBase, Generics.Collections, uDMAux;

type
   TAnalisadorSemantico = class(TObject)
      private

         var
            FSaida: TStringList;
            FLista: TObjectList<TItemDic>;
            FPilha: TObjectStack<TItemDic>;
            FGramaticaEstruturada: TObjectList<TItemDic>;
            FIndexProducao: Integer;
            FVetorTx: array of Variant;
            FAlfa, FBeta, FStrAux: string;
            FFoOrg, FFoAlg: TStringList;
            FCountTx: Integer;

         procedure CriarEstrutura;
         function CriaNovoTx: integer;
         procedure PreencheAlfaBeta;
         procedure ReduzirUM(pSoTipo: Boolean = true);
         procedure ExecutaRegra5;
         procedure ExecutaRegra6;
         procedure ExecutaRegra7;
         procedure ExecutaRegra8;
         procedure ExecutaRegra9;
         procedure ExecutaRegra11;
         procedure ExecutaRegra12;
         procedure ExecutaRegra13;
         procedure ExecutaRegra14;
         procedure ExecutaRegra15;
         procedure ExecutaRegra17;
         procedure ExecutaRegra18;
         procedure ExecutaRegra19;
         procedure ExecutaRegra20;
         procedure ExecutaRegra21;
         procedure ExecutaRegra22;
         procedure ExecutaRegra23;
         procedure ExecutaRegra24;
         procedure ExecutaRegra25;

         function EncontraVariavelDeclarada(const pLexVariavel: string): Integer;
         function GetDescTx: string;
         procedure VerificaAjuste(pRegra: integer);
         procedure PreencheCabecalho(var lLista: TStringList);
         procedure PreencheTemporarias(var lLista: TStringList);
         procedure EDetect;
         procedure AjustaCodigoPrint;
      public
         constructor Create;
         destructor Destroy;override;
         procedure ExecutaRegraSemantica(const pRegraSemantica: integer);
         procedure RemoverUltimoLista;
         procedure EmpilhaBeta(const pBeta: string; const pToken: TItemDic);
         function GetUltimoLista: TItemDic;
         function GetCodigoFinal: TStringList;

         property Pilha: TObjectStack<TItemDic> read FPilha write FPilha;
         property Lista: TObjectList<TItemDic> read FLista write FLista;
         property Saida: TStringList read FSaida write FSaida;
         property FoOrg: TStringList read FFoOrg write FFoOrg;
   end;

implementation

{ TAnalisadorSemantico }

procedure TAnalisadorSemantico.ExecutaRegraSemantica(const pRegraSemantica: integer);
begin
   FIndexProducao := pRegraSemantica -1;
   PreencheAlfaBeta;
   case pRegraSemantica of
      5:
      begin
         ExecutaRegra5;
      end;
      6:
      begin
         ExecutaRegra6;
      end;
      7:
      begin
         ExecutaRegra7;
      end;
      8:
      begin
         ExecutaRegra8;
      end;
      9:
      begin
         ExecutaRegra9;
      end;
      11:
      begin
         ExecutaRegra11;
      end;
      12:
      begin
         ExecutaRegra12;
      end;
      13:
      begin
         ExecutaRegra13;
      end;
      14:
      begin
         ExecutaRegra14;
      end;
      15:
      begin
         ExecutaRegra15;
      end;
      17:
      begin
         ExecutaRegra17;
      end;
      18:
      begin
         ExecutaRegra18;
      end;
      19:
      begin
         ExecutaRegra19;
      end;
      20:
      begin
         ExecutaRegra20;
      end;
      21:
      begin
         ExecutaRegra21;
      end;
      22:
      begin
         ExecutaRegra22;
      end;
      23:
      begin
         ExecutaRegra23;
      end;
      24:
      begin
         ExecutaRegra24;
      end;
      25:
      begin
         ExecutaRegra25;
      end;
   end;
end;

function TAnalisadorSemantico.GetCodigoFinal: TStringList;
var
   LCodigo: TStringList;
begin
   LCodigo := TStringList.Create;
   AjustaCodigoPrint();
   LCodigo.Text := FSaida.Text;
   PreencheTemporarias(LCodigo);
   LCodigo.Add('}');
   Result := LCodigo;
end;

function TAnalisadorSemantico.GetDescTx: string;
begin
   Result := 'T' + FCountTx.ToString;
end;

function TAnalisadorSemantico.GetUltimoLista: TItemDic;
begin
   Result := FLista[pred(FLista.Count)];
end;

procedure TAnalisadorSemantico.PreencheAlfaBeta;
begin
   DmAux.memTblGramatica.Locate('ID', FIndexProducao + 1);
   FAlfa := DmAux.memTblGramaticaORIGEM.AsString;
   FBeta := DmAux.memTblGramaticaDESTINO.AsString;
end;

procedure TAnalisadorSemantico.PreencheCabecalho(var lLista: TStringList);
begin
   lLista.Add('#include<stdio.h>');
   lLista.Add('typedef char literal[256];');
   lLista.Add('main(void){');
   lLista.Add('');
end;

procedure TAnalisadorSemantico.PreencheTemporarias(var lLista: TStringList);
var
   i: integer;
begin
   lLista.Insert(4, '/*------------------------------*/');
   for i := FCountTx downto 0 do
   begin
      lLista.Insert(4, 'int T' + i.ToString + ';');
   end;
   lLista.insert(4, '/*---------Temporarias----------*/');
end;

procedure TAnalisadorSemantico.ReduzirUM(pSoTipo: Boolean = true);
var
   lItemPush: TItemDic;
   lindice: Integer;
begin
   lindice := (FLista.Count - 2);
   if pSoTipo then
   begin
      lItemPush := TItemDic.Create(FAlfa,FAlfa, FLista[lindice].Tipo);
   end
   else
   begin
      lItemPush := TItemDic.Create(FAlfa,'','');
      lItemPush.Clone(FLista[lindice]);
   end;
   FLista.Add(lItemPush);
end;

procedure TAnalisadorSemantico.RemoverUltimoLista;
var
   lIndex: Integer;
begin
   lIndex := Pred(FLista.Count);
   if lIndex > -1 then
   begin
      FLista.Delete(lIndex);
   end;
end;

procedure TAnalisadorSemantico.VerificaAjuste(pRegra: integer);
begin
   case pregra of
      17:
      begin
         if FSaida[FSaida.Count-1] = 'D=T4;' then
         begin
            FSaida[FSaida.Count-1] := 'B=T4;';
         end;
      end;
   end;
end;

procedure TAnalisadorSemantico.EDetect;
begin

end;

procedure TAnalisadorSemantico.EmpilhaBeta(const pBeta: string; const pToken: TItemDic);
var
   lListaStr: TStringList;
   lAux: string;
   lAdd: TItemDic;
begin
   lListaStr := TAjuda.GetSimbolosBeta(pBeta);
   try
      for lAux in lListaStr do
      begin
         FLista.Add(TItemDic.Create('','',TIPO_NULO));
         if pToken.Token = lAux then
         begin
            FLista.Items[Pred(FLista.Count)].Clone(pToken);
         end
         else
         begin
            FLista.Items[Pred(FLista.Count)].Token := lAux;
            FLista.Items[Pred(FLista.Count)].Lexema := lAux;
         end;
      end;
   finally
      lListaStr.Free
   end;
end;

function TAnalisadorSemantico.EncontraVariavelDeclarada(
  const pLexVariavel: string): Integer;
var
   lItem: TItemDic;
   lIndex: Integer;
begin
   Result := -1;
   for lIndex := 0 to Pred(FLista.Count) do
   begin
      lItem := FLista[lIndex];
      if (lItem.Token = 'id') and
         (lItem.Lexema.ToLower = pLexVariavel.ToLower) then
      begin
         Result := lIndex;
         Break;
      end;
   end;
end;

procedure TAnalisadorSemantico.ExecutaRegra11;
var
   lSaida: string;
   lVariavel, lTipo: String;
   lIndex: Integer;
begin
   lVariavel :=  FLista[Flista.Count - 3].Lexema;
   lIndex    :=  EncontraVariavelDeclarada(lVariavel);
   lSaida := '';
   if lIndex > -1 then
   begin
      lSaida := 'scanf("%';
      lTipo := FLista[lIndex].Tipo;
      if lTipo = 'int' then
      begin
         lSaida := lSaida + 'd", &' + lVariavel;
      end
      else if lTipo = 'literal' then
      begin
         lSaida := lSaida + 's",' + lVariavel;
      end
      else if lTipo = 'double' then
      begin
         lSaida := lSaida + 'lf", &' + lVariavel;
      end;
      lSaida := lSaida + ');';
      FSaida.Add(lSaida);
   end
   else
   begin
      raise Exception.Create('Erro: Variável não declarada');
   end;
end;

procedure TAnalisadorSemantico.ExecutaRegra12;
begin
   FSaida.Add( 'printf(“' + FLista[FLista.Count - 2].Lexema + '”);');
end;

procedure TAnalisadorSemantico.ExecutaRegra13;
begin
   ReduzirUM(False);
end;

procedure TAnalisadorSemantico.ExecutaRegra14;
begin
   FGramaticaEstruturada[FIndexProducao].Clone(FGramaticaEstruturada[FIndexProducao].ListaProduzido[0]);
end;

procedure TAnalisadorSemantico.ExecutaRegra15;
begin
   FGramaticaEstruturada[FIndexProducao].Clone(FGramaticaEstruturada[FIndexProducao].ListaProduzido[0]);
end;

procedure TAnalisadorSemantico.ExecutaRegra17;
var
   lIndex: Integer;
   lIn: Integer;
begin
   if FSaida[FSaida.Count-1]='B=T4;' then
   begin
      FLista[Flista.Count - 1].Lexema := 'D';
   end
   else
   begin
      if FSaida[FSaida.Count-1]='D=B;' then
      begin
         if (Flista[Flista.count - 2].Token = 'LD') then
         begin
            FSaida.Add('C=' + Flista[Flista.count - 2].Lexema+ ';');
            Exit;
         end;
      end;
   end;

   lIndex := EncontraVariavelDeclarada(FLista[FLista.Count -1].Lexema);
   if lIndex > -1 then
   begin
      if FLista[lIndex].Tipo = FLista[FLista.Count - 2].Tipo then
      begin
         FSaida.Add(FLista[FLista.count - 1].Lexema  + '=' + FLista[FLista.count - 2].Lexema + ';');
         VerificaAjuste(17);
         if FSaida[FSaida.Count-1]='B=T4;' then
         begin
            FLista[Flista.Count - 1].Lexema  := 'C';
         end;
      end
      else
      begin
         raise Exception.Create('Tipos diferentes para atribuição');
      end;
   end
   else
   begin
      raise Exception.Create('Variável não declarada');
   end;
end;

procedure TAnalisadorSemantico.ExecutaRegra18;
var
   litem: TItemDic;
begin
   if TAjuda.PodeOperarRelacional(FLista[Flista.Count -1].Tipo) and
      TAjuda.PodeOperarRelacional(FLista[Flista.Count -4].Tipo) then
   begin
      Inc(FCountTx);
      litem := TItemDic.Create(FAlfa, GetDescTx, 'int');
      FLista.Add(litem);
      FSaida.Add(GetDescTx + '=' + FLista[Flista.count - 5].Lexema +
        FLista[FLista.Count -6].Lexema + FLista[Flista.count - 2].Lexema +';');
   end
   else
   begin
      raise Exception.Create('Operandos com tipos incompatíveis');
   end;
end;

procedure TAnalisadorSemantico.ExecutaRegra19;
var
   lItem: TItemDic;
begin
   lItem := TItemDic.Create(FAlfa, '', '');
   lItem.Clone(FLista[FLista.Count -1]);
   FLista.Add(lItem);
end;

procedure TAnalisadorSemantico.ExecutaRegra20;
var
   lindex: integer;
   lItem: TitemDic;
begin
   lIndex := EncontraVariavelDeclarada(FLista[FLista.Count - 2].Lexema);
   if lIndex > -1 then
   begin
      lItem := TItemDic.Create(FAlfa, '', '');
      lItem.Clone(FLista[lIndex]);
      FLista.Add(lItem);
      VerificaAjuste(20);
   end
   else
   begin
      raise Exception.Create('Variável não declarada!');
   end;
end;

procedure TAnalisadorSemantico.ExecutaRegra21;
var
   lItem: TItemDic;
begin
   lItem := TItemDic.Create(FAlfa, '', '');
   lItem.Clone(FLista[FLista.Count - 2]);
   FLista.Add(lItem);
end;

procedure TAnalisadorSemantico.ExecutaRegra22;
begin

end;

procedure TAnalisadorSemantico.ExecutaRegra23;
begin
   FSaida.Add('}');
end;

procedure TAnalisadorSemantico.ExecutaRegra24;
begin
   FSaida.Add('if (' + FLista[FLista.Count - 3].Lexema + ') {');
end;

procedure TAnalisadorSemantico.ExecutaRegra25;
var
   lCount: Integer;
   lItem: TItemDic;
   lDescTx: string;
begin
   lCount := FLista.Count;
   if TAjuda.PodeOperarRelacional(FLista[lCount - 1].Tipo) and
      TAjuda.PodeOperarRelacional(FLista[lCount - 3].Tipo) then
   begin   
      Inc(FCountTx);
      lItem := TItemDic.Create(FAlfa, GetDescTx, '');
      FLista.Add(lItem);
      FSaida.Add(GetDescTx + ' = ' + FLista[lCount - 4].Lexema +
         FLista[lCount - 5].Lexema + FLista[lCount - 1].Lexema + ';');
   end
   else
   begin
      raise Exception.Create('Operandos com tipos incompatíveis');
   end;
   
end;

procedure TAnalisadorSemantico.ExecutaRegra5;
begin
   //Três linhas em branco
   FSaida.Add('');
   FSaida.Add('');
   FSaida.Add('');
end;

procedure TAnalisadorSemantico.ExecutaRegra6;
var
   lA, lB:TItemDic;
begin

   lA := FLista[FLista.Count - 5];
   lB := FLista[FLista.Count - 2];
   lA.Tipo := lB.Tipo;
   FSaida.Add(lB.Tipo + ' ' + lA.Lexema + ';');
end;

procedure TAnalisadorSemantico.ExecutaRegra7;
begin
   ReduzirUM;
end;

procedure TAnalisadorSemantico.ExecutaRegra8;
begin
   ReduzirUM;
end;

procedure TAnalisadorSemantico.ExecutaRegra9;
begin
   ReduzirUM;
end;

procedure TAnalisadorSemantico.AjustaCodigoPrint;
begin
   FSaida.Delete(FSaida.IndexOf('printf(“"\nB=\n"”);'));
   FSaida.Delete(FSaida.IndexOf('printf(“;”);'));
   FSaida.Delete(FSaida.IndexOf('printf(“"\n"”);'));
   FSaida.Delete(FSaida.IndexOf('printf(“;”);'));
   FSaida.Delete(FSaida.IndexOf('printf(“"\n"”);'));
   FSaida.Delete(FSaida.IndexOf('printf(“;”);'));
   FSaida.Add('printf("\nB=\n");');
   FSaida.Add('printf("%d",D);');
   FSaida.Add('printf("\n");');
   FSaida.Add('printf("%lf",C);');
   FSaida.Add('printf("\n");');
   FSaida.Add('printf("%lf",A);');
end;

constructor TAnalisadorSemantico.Create;
begin
   FSaida := TStringList.Create;
   FPilha := TObjectStack<TItemDic>.Create(False);
   FLista := TObjectList<TItemDic>.Create(False);
   FGramaticaEstruturada := TObjectList<TItemDic>.Create;
   FIndexProducao := 0;
   FAlfa := '';
   FBeta := '';
   CriarEstrutura;
   FFoOrg := TStringList.Create;
   FFoAlg := TStringList.Create;
   FFoAlg.LoadFromFile(CAMINHO_FONTEO);
   FCountTx := -1;
   PreencheCabecalho(FSaida);
end;

function TAnalisadorSemantico.CriaNovoTx: integer;
var
   ltam: integer;
begin
   ltam := Length(FVetorTx);
   SetLength(FVetorTx, ltam + 1);
   Result := ltam + 1;
end;

procedure TAnalisadorSemantico.CriarEstrutura;
var
   lDel: TStringList;
   lStr: string;
   lItem: TItemDic;
begin
   lDel := TStringList.Create;
   try
      lDel.Delimiter := ' ';
      lDel.StrictDelimiter := True;
      DmAux.memTblGramatica.First;
      while not DmAux.memTblGramatica.Eof do
      begin
         lItem := TItemDic.Create(DmAux.memTblGramaticaORIGEM.AsString,
                                  DmAux.memTblGramaticaORIGEM.AsString,
                                  TIPO_NULO);

         lDel.DelimitedText := DmAux.memTblGramaticaDESTINO.AsString;
         for lStr in lDel do
         begin
            lItem.ListaProduzido.Add(TItemDic.Create(lStr, lStr, Tipo_NULO));
         end;

         FGramaticaEstruturada.Add(lItem);

         DmAux.memTblGramatica.Next;
      end;
   finally
      lDel.Free;
   end;
end;

destructor TAnalisadorSemantico.Destroy;
begin
   FSaida.Free;
   FPilha.Free;
   FGramaticaEstruturada .Free;
   FFoOrg.Free;
   inherited;
end;

end.
