unit uAnalisadorLexico;

interface

uses uClassesBase, System.Generics.Collections, uAutomatoLexico, Classes;

type
   TAnalisadorLexico = class(TObject)
      private
         const
            //defini��o dos s�bolos reservados
            SIMBOLOS_INICIAIS: array[1..12] of string =
               ('varinicio', 'varfim', 'inicio', 'escreva', 'leia',
                'se', 'entao', 'fimse', 'fim', 'inteiro', 'literal',
                'real');
         var
            //Dicion�rio da tabela de s�mbolos
            FDicTabelaSimbolos: TDictionary<string, TItemDic>;

            //Aut�mato da an�lise l�xica
            FAutomato: TAutomatoLexico;

            //Programa fonte
            FFonte: TStringList;

            //Sa�da com os itens reconhecidos
            FSaida: TStringList;

            //Log de erros/mensagens
            FLog: TStringList;

            //Linha e coluna da leitura do c�digo
            FLinha, FColuna: Integer;

            //Palavra a ser analisada
            FPalavra: string;
         function IsSImboloInicial(const pSimbolo: string): boolean;
      public
         constructor Create(const pFonte: string);
         destructor Destroy;override;

         //Percorrer a defini�ao de elementos reservados e adicion�-los ao dicion�rio de s�mbolos
         procedure IniciarDicSimbolos;

         //Adicionar item ao dicion�rio de s�mbolos
         procedure AdicionarItemDic(pValor: TItemDic; pSomID: boolean = false);

         //Analisar um determinado lexema informado, retornando o item resultante
         function AnalisarLexema(const pLexema: string): TItemDic;

         //Chamar o m�todo principal da an�lise geral
         procedure AnalisarCodigoLexicamente;

         property DicTabelaSimbolos: TDictionary<string, TItemDic> read FDicTabelaSimbolos write FDicTabelaSimbolos;
         property Saida: TStringList read FSaida;
         property Log: TStringList read FLog;
         property Linha: integer read FLinha;
         property Coluna: integer read FColuna;
         property Fonte: TStringList write FFonte;
   end;


implementation

uses
  System.SysUtils, uEstadoLFA;

{ TAnalisadorLexico }

procedure TAnalisadorLexico.AdicionarItemDic(pValor: TItemDic; pSomID: boolean = false);
var
   lChave: string;
begin
   //Mediante par�metro de controle, impedir que elementos que n�o sejam "id"
   //fa�am parte da tabela de s�mbolos
   if (pSomID) and (pValor.Token <> 'id') then
   begin
      Exit;
   end;

   //o lexema como chave
   lChave := pValor.Lexema;

   //Se n�o tiveer a chave determinada, adicionar item
   if not FDicTabelaSimbolos.ContainsKey(lChave) then
   begin
      FDicTabelaSimbolos.Add(lChave, pValor);
   end;
end;

function TAnalisadorLexico.AnalisarLexema(const pLexema: string): TItemDic;
var
   lChar: Char;
   lTok: string;
   lItemDic: TItemDic;
begin
   Result := nil;

   //Percorrer o lexema(no caso presente, h� somente um char) e executar a transi��o
   //retornando qual o token resultante
   for lChar in pLexema do
   begin
      lTok := FAutomato.Transitar(lChar).Token;
   end;

   //incrementar na palavra analizada o char referente
   FPalavra := FPalavra + pLexema;

   // caso for id, e s�mbolo inicial, j� retornar o token como a pr�pria palavra
   // mediante defini��o da atividade
   if lTok = 'id' then
   begin
      if IsSImboloInicial(FPalavra) then
      begin
         lTok := FPalavra;
      end;
      lItemDic := TItemDic.Create(lTok, FPalavra, TIPO_NULO);
   end
   else
   begin
      lItemDic := TItemDic.Create(lTok, FPalavra, TIPO_NULO);
   end;
   //retornar o item resultante da transi��o(nil se n�o houver transi��o)
   Result := lItemDic;
end;

constructor TAnalisadorLexico.Create(const pFonte: string);
var
   lindex: integer;
begin
   inherited Create;
   FDicTabelaSimbolos := TDictionary<string, TItemDic>.Create;
   FAutomato          := TAutomatoLexico.Create;
   FSaida             := TStringList.Create;
   FLog               := TStringList.Create;
   FLinha             := 0;
   FColuna            := 0;
   FFonte             := TStringList.Create;
   FFonte.Text        := pFonte;
   for lindex := 0 to FFonte.Count - 1 do
   begin
      FFonte[lindex] := FFonte[lindex].TrimLeft;
   end;

   IniciarDicSimbolos;
end;

destructor TAnalisadorLexico.Destroy;
begin
   FDicTabelaSimbolos.Destroy;
   FAutomato.Free;
   FFonte.Free;
   FLog.Free;
   FSaida.Free;
   inherited;
end;

procedure TAnalisadorLexico.IniciarDicSimbolos;
var
   lElemento: string;
begin
   for lElemento in SIMBOLOS_INICIAIS do
   begin
      AdicionarItemDic(TitemDic.Create(lElemento, lElemento, TIPO_NULO));
   end;
end;

function TAnalisadorLexico.IsSImboloInicial(const pSimbolo: string): boolean;
var
   lIndice: integer;
begin
   Result := False;
   for lIndice := Low(SIMBOLOS_INICIAIS) to High(SIMBOLOS_INICIAIS) do
   begin
      if pSimbolo.ToLower.Equals(SIMBOLOS_INICIAIS[lIndice]) then
      begin
         Result := true;
         Break;
      end;
   end;
end;

procedure TAnalisadorLexico.AnalisarCodigoLexicamente;
var
   lLinha, lLinhaAux: string;
   lPalavra: string;
   lChar: Char;
   lItemAnalisado, lItemAnterior: TitemDic;
   lIndex: Integer;
   lErro: boolean;
begin
   FPalavra := '';
   FLinha := 0;
   lErro := False;
   //para cada linha do c�digo fonte
   for lLinha in FFonte do
   begin
      Inc(FLinha);
      //Restaura-se o automato para o estado inical
      FAutomato.RestaurarEstadoInicial;

      //anula os itens de an�lise, afinal trata-se de uma nova tarefa
      lItemAnterior := nil;
      lItemAnalisado := nil;

      //se a linha estiver vazia, n�o analisar
      if lLinha.IsEmpty then
      begin
         Continue;
      end;

      //iniciar var�aveis de controle
      lLinhaAux := lLinha.TrimLeft;
      FColuna := 0;
      lPalavra := '';
      FPalavra := '';
      lIndex := 1;

      //percorrer cada caracter da linha correspondente
      repeat
         //incrementar coluna da an�lise(controle)
         Inc(FColuna);

         //caracter atual da an�lise
         lChar    := lLinhaAux[lIndex];

         //incrementar vari�vel de controle
         lPalavra := lPalavra + lChar;
         try
            lErro := False;

            //analisar o caractere lexicamente
            lItemAnalisado := Self.AnalisarLexema(lChar);
         except
            //se o elemento n�o foi reconhecido, h� duas possibilidades:
            //....1: a an�lise do item reconhecido acabou, e inicia-se a cadeia de um outro elemento
            //....2: realmente n�o h� transi��o para o elemento passado, tornando-o desocnhecido
            on e: TEItemDesconhecido do
            begin
               lErro := True;
               //restaurar estado do automato
               FAutomato.RestaurarEstadoInicial;

               //identificar se o elemento de analisado anteriormente � v�lido
               if Assigned(lItemAnterior) then
               begin
                  //adicionar o item de an�lise como reconhecido
                  FSaida.Add(lItemAnterior.Token + '@' + lItemAnterior.Lexema);
                  AdicionarItemDic(lItemAnterior, True);
                  lPalavra := '';
                  FPalavra := '';
                  lItemAnterior := nil;
               end
               else
               begin
                  //logar um erro de elemento desconhecido
                  FLog.Add(e.message +  ' linha ' + Pred(Flinha).ToString +  ' coluna ' + FColuna.ToString);
                  Exit;
               end;
            end;
         end;

         //atribuir o elemento anterior como o atual
         if Assigned(lItemAnalisado) then
         begin
            lItemAnterior :=  TItemDic.Create(lItemAnalisado.Token, lItemAnalisado.Lexema, lItemAnalisado.Tipo);
         end;

         Inc(lIndex);
      until (lItemAnalisado = nil) or (lIndex > lLinhaAux.Length);

      //fim da an�lise da linha:
      //....nesse ponto ainda pode haver a necessidade de analisar o �ltimo item
      //....adicionar o item propriamente analizado como um elemento valido
      if (lIndex > lLinhaAux.Length) then
      begin
         if Assigned(lItemAnalisado) and (not lErro) then
         begin
            FSaida.Add(lItemAnterior.Token + '@' + lItemAnterior.Lexema);
            AdicionarItemDic(lItemAnterior, True);
         end
         else
         begin
            lItemAnalisado := Self.AnalisarLexema(lChar);
            if Assigned(lItemAnalisado) then
            begin
               FSaida.Add(lItemAnalisado.Token + '@' + lItemAnalisado.Lexema);
               AdicionarItemDic(lItemAnalisado, True);
            end;
         end;
      end;
   end;
end;

end.

