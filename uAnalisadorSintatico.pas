unit uAnalisadorSintatico;

interface
   uses
      System.classes, System.SysUtils, uClassesBase, uDmAux, uAnalisadorLexico,
      System.Generics.Collections, Firedac.comp.client, Firedac.comp.DataSet,
      uAnalisadorSemantico;

type
   TAnalisadorSintatico = class(TObject)
      private
         var
            FPilha: TStack<string>;
            FAnaLexico: TAnalisadorLexico;
            FAnaSemantico: TAnalisadorSemantico;
            FListaEstados: TObjectList<TEstado>;
            FSaida: TStringList;
            FLog: TStringList;
         const
            CSV_ACTION = 'action.csv';
            CSV_GOTO = 'goto.csv';
         function GetAcao(pEstado: TEstado; pToken: TItemDic): TAcaoSintatico;
         function GetGoto(pEstado: TEstado; pToken: TItemDic): TEstado;
         function GetProducaoDestino(pIndex: integer): string;
         function GetSimbolosBeta(pBeta: string): TStringList;
         procedure VerificaAjuste(var lToken: TItemDic);
      public
         constructor Create(pFonte: string);
         destructor Destroy;override;

         procedure CarregarTabelas(pArquivo: string; pTable: TFDMemTable);
         procedure CriarEstados;
         procedure CriarGramatica;
         procedure CarregarDeArquivos;
         procedure Exec;

         property AnaLexico: TAnalisadorLexico read FAnaLexico write FAnaLexico;
         property AnaSemantico: TAnalisadorSemantico read FAnaSemantico write FAnaSemantico;
         property Saida: TStringList read FSaida;
         property Log: TStringList read FLog;
   end;

implementation

uses
  System.Variants;

{ TAnalisadorSintatico }

procedure TAnalisadorSintatico.CarregarTabelas(pArquivo: string; pTable: TFDMemTable);
var
   lListaTokens, lListaLinhas: TStringList;
   lLinha: string;
   lArq: TStringList;
   lIndexA, lIndexB: integer;
   lEstado, lAcao: string;
begin
   pTable.EmptyDataSet;
   lArq := TStringList.Create;
   lListaLinhas := TStringList.Create;
   try
      lArq.LoadFromFile(pArquivo);
      lListaTokens := TStringList.Create;
      try
         //todo o arquivo
         for lIndexA := 0 to Pred(lArq.Count) do
         begin
            lLinha := lArq[lIndexA];

            if lIndexA = 0 then
            begin
               //Tokens
               lListaTokens.Delimiter := ';';
               lListaTokens.StrictDelimiter := True;
               lListaTokens.DelimitedText := lLinha;
            end
            else
            begin
               lListaLinhas.Delimiter := ';';
               lListaLinhas.StrictDelimiter := True;
               lListaLinhas.DelimitedText   := lLinha;
               lEstado := lListaLinhas[0];

               //linha atual
               for lIndexB := 1 to Pred(lListaLinhas.Count) do
               begin
                  lAcao := lListaLinhas[lIndexB];
                  pTable.Append;
                  pTable.FieldByName('ESTADO').AsString := lEstado;
                  pTable.FieldByName('TOKEN').AsString  := lListaTokens[lIndexB];
                  pTable.FieldByName('VALOR').AsString  := lListaLinhas[lIndexB];
                  pTable.Post;
               end;
            end;
         end;
      finally
         lListaTokens.Free;
      end;
   finally
      lArq.Free;
   end;
end;

procedure TAnalisadorSintatico.CarregarDeArquivos;
begin
   CarregarTabelas(CSV_ACTION, DmAux.memTblAction);
   CarregarTabelas(CSV_GOTO, DmAux.memTblGoto);   
end;

constructor TAnalisadorSintatico.Create(pFonte: string);
begin
   FPilha := TStack<string>.Create;
   FListaEstados := TObjectList<TEstado>.Create;
   FSaida        := TStringList.Create;
   FLog          := TStringList.Create;
   FAnaLexico    := TAnalisadorLexico.Create(pFonte);

   CriarEstados;
   CriarGramatica;
   FAnaSemantico := TAnalisadorSemantico.Create;
   CarregarDeArquivos;
   FAnaLexico.AnalisarCodigoLexicamente;
end;

procedure TAnalisadorSintatico.CriarEstados;
var
   lEst: TEstadoAutomatoMGOL;
begin
   for lEst in ARRAY_ESTADOS_SINT do
   begin
      FListaEstados.Add(TEstado.Create(lEst, false));
   end;
end;

procedure TAnalisadorSintatico.CriarGramatica;
begin
   DmAux.memTblGramatica.EmptyDataSet;
   DmAux.BatchReader.FileName := 'gramatica.csv';
   DmAux.BatchMove.Execute;
end;

destructor TAnalisadorSintatico.Destroy;
begin
   FAnaLexico.Free;
   FPilha.Free;
   FSaida.Free;
   FLog.Free;
   FAnaSemantico.Free;
   inherited;
end;

procedure TAnalisadorSintatico.Exec;
var
   lEstado, lGoto: TEstado;
   lToken: TItemDic;
   lTopo: string;
   lAcao: TAcaoSintatico;
   lA, lBeta, lAux: string;
   lSimbBeta: TStringList;
   lTry: Integer;
   lAcaoAlvo: integer;
begin
   FSaida.Clear;
   FLog.Clear;
   FPilha.Push('0');

   //Requisitar ao léxico o próximo token
   lToken := FAnaLexico.GetProximoToken;

   while True do
   begin
      try
         VerificaAjuste(lToken);
      except
         on e: Exception do
         begin
            raise;
         end;
      end;

      //Atribuição do topo da pilha
      lTopo := FPilha.Peek;
      if TryStrToInt(lTopo, lTry) then
      begin
         lEstado := TEstado.Create(ARRAY_ESTADOS_SINT[lTopo.ToInteger + 1], False);
      end
      else
      begin
         lEstado := nil;
      end;

      if lEstado <> nil then
      begin
         //Obter o par Estado - token na tabela ACTION
         lAcao := Self.GetAcao(lEstado, lToken);

         if lAcao.Tipo in [ttaShift, ttaReduce] then
         begin
            lAcaoAlvo := Ord(lAcao.Alvo.Id);
         end;

         case lAcao.Tipo of
            ttaShift:
            begin
               //empilha o alvo da ação
               FPilha.Push(lAcaoAlvo.ToString);

               //pedir próximo token
               lToken := FAnaLexico.GetProximoToken;

//               //obter a produção beta
//               lBeta := Self.GetProducaoDestino(lAcaoAlvo);
//               //obter a produção "A"(lado esquerdo)
//               lA    := DmAux.memTblGramaticaORIGEM.AsString;
//               FAnaSemantico.EmpilhaBeta(lBeta, lToken);

               FAnaSemantico.Lista.Add(lToken);
            end;

            ttaReduce:
            begin
               //obter a produção beta
               lBeta := Self.GetProducaoDestino(lAcaoAlvo);
               //obter a produção "A"(lado esquerdo)
               lA    := DmAux.memTblGramaticaORIGEM.AsString;

               //desempilhar módulo de beta elementos
               lSimbBeta := Self.GetSimbolosBeta(lBeta);
               try
                  for lAux in lSimbBeta do
                  begin
                     FPilha.Pop;
                  end;
               finally
                  lSimbBeta.Free;
               end;

               //Recuperar novo topo da pilha
               lTopo   := FPilha.Peek;
               lEstado := TEstado.Create(ARRAY_ESTADOS_SINT[lTopo.ToInteger + 1], false);

               //empilhe GOTO[topo, lado esquerdo da produção]
               lGoto   := GetGoto(lEstado, TItemDic.Create(lA, lA, TIPO_NULO));
               lAcaoAlvo    := Ord(lGoto.Id);
               FPilha.Push(lAcaoAlvo.ToString);

               //chamar semantico
               FAnaSemantico.ExecutaRegraSemantica(DmAux.memTblGramaticaID.AsInteger);

               //printar a produção referente ao reduce
               FSaida.Add(lA + ' -> ' + lBeta);
            end;

            ttaAccept:
            begin
               Break;
            end;

            ttaError:
            begin
               FLog.Add('Não encontrado ACTION ' + Ord(lEstado.Id).ToString + ' - ' + lToken.Token);
               Abort;
            end;
         end;
      end;
   end;
   FAnaSemantico.FoOrg.SaveToFile('Programa.c');
end;

function TAnalisadorSintatico.GetAcao(pEstado: TEstado;
  pToken: TItemDic): TAcaoSintatico;
var
   lEstado: string;
   lAcao: TTipoAcaoSintatico;
   lPos: integer;
   lIdEstado: TEstadoAutomatoMGOL;
begin
   DmAux.memTblAction.IndexFieldNames := 'ESTADO;TOKEN';
   if DmAux.memTblAction.FindKey([Ord(pEstado.Id), pToken.Token.ToLower]) then
   begin
      if not DmAux.memTblActionVALOR.AsString.IsEmpty then
      begin
         //estado de aceitação
         if DmAux.memTblActionVALOR.AsString.ToLower = 'acc' then
         begin
            lAcao := ttaAccept;
         end
         //estado de erro
         else if Pos('E', DmAux.memTblActionVALOR.AsString.ToUpper) > 0 then
         begin
            lAcao := ttaError;
         end
         else
         begin
            //Shift
            lPos := Pos('S', DmAux.memTblActionVALOR.AsString.ToUpper);
            if lPos > 0 then
            begin
               lAcao := ttaShift;
            end
            else
            begin
               //Reduce
               lPos := Pos('R', DmAux.memTblActionVALOR.AsString.ToUpper);
               if lPos > 0 then
               begin
                  lAcao := ttaReduce;
               end;
            end;
            if lAcao in [ttaShift, ttaReduce] then
            begin
               lEstado := Copy(DmAux.memTblActionVALOR.AsString.ToUpper, lPos + 1, DmAux.memTblActionVALOR.AsString.Length);
            end;
         end;
      end;

      if lEstado.IsEmpty then
      begin
         lIdEstado := teQ0;
      end
      else
      begin
         lIdEstado := ARRAY_ESTADOS_SINT[lEstado.ToInteger + 1];
      end;

      Result := TAcaoSintatico.Create(lAcao, TEstado.Create(lIdEstado, True));
   end
   else
   begin
      FLog.Add('Não encontrado o par ' + Ord(pEstado.Id).ToString + ' ' + pToken.Token);
      Abort;
   end;
end;

function TAnalisadorSintatico.GetGoto(pEstado: TEstado;
  pToken: TItemDic): TEstado;
var
   lId,lToken: variant;
begin
   DmAux.memTblGoto.IndexFieldNames := 'ESTADO;TOKEN';

   lId    := Ord(pEstado.Id);
   lToken := pToken.Token.ToUpper;

   if DmAux.memTblGoto.FindKey([lId, lToken]) then
   begin
      if not DmAux.memTblGotoVALOR.AsString.IsEmpty then
      begin
         Result := TEstado.Create(ARRAY_ESTADOS_SINT[DmAux.memTblGotoVALOR.AsInteger + 1], False);
      end;
   end
   else
   begin
      FLog.Add('Não encontrado GOTO ' + lId + ' - ' + lToken);
      Abort;
   end;
end;

function TAnalisadorSintatico.GetProducaoDestino(pIndex: integer): string;
begin
   DmAux.memTblGramatica.FindKey([pIndex]);
   Result := DmAux.memTblGramaticaDESTINO.AsString;
end;

function TAnalisadorSintatico.GetSimbolosBeta(pBeta: string): TStringList;
begin
   Result                 := TStringList.Create;
   Result.Delimiter       := ' ';
   Result.StrictDelimiter := True;
   Result.DelimitedText   := pBeta;
end;

procedure TAnalisadorSintatico.VerificaAjuste(var lToken: TItemDic);
begin
   if lToken.Token = '' then
   begin
      lToken := FAnaLexico.GetProximoToken;
   end;
end;

end.
