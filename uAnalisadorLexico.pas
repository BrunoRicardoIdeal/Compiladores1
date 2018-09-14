unit uAnalisadorLexico;

interface

uses uClassesBase, System.Generics.Collections, uAutomatoLexico;

type
   TAnalisadorLexico = class(TObject)
      private
         const
            SIMBOLOS_INICIAIS: array[1..12] of string =
               ('varinicio', 'varfim', 'inicio', 'escreva', 'leia',
                'se', 'entao', 'fimse', 'fim', 'inteiro', 'lit',
                'real');
            TIPO_NULO = 'N';
         var
            FDicTabelaSimbolos: TDictionary<integer, TItemDic> ;
            FCadeiaAnalise: string;
            FAutomato: TAutomatoLexico;
      public
         constructor Create;
         destructor Destroy;override;

         procedure AnalisarLinha(const pLinha: string);
         procedure IniciarDicSimbolos;
         procedure AdicionarItemDic(pValor: TItemDic);
         function AnalisarLexema(const pLexema: string): TItemDic;

         property DicTabelaSimbolos: TDictionary<integer, TItemDic> read FDicTabelaSimbolos write FDicTabelaSimbolos;
   end;


implementation

uses
  System.SysUtils, uEstadoLFA;

{ TAnalisadorLexico }

procedure TAnalisadorLexico.AdicionarItemDic(pValor: TItemDic);
const
   LLIMITE = 10000;
var
   lChave: Integer;
   lCount: integer;
begin
   if not FDicTabelaSimbolos.ContainsValue(pValor) then
   begin
      lCount := 0;
      repeat
         lChave := Random(10000);
         Inc(lCount);
         if lCount >= LLIMITE then
         begin
            raise Exception.Create('Limite de itens atingido!');
         end;
      until (not FDicTabelaSimbolos.ContainsKey(lChave));
      FDicTabelaSimbolos.Add(lChave, pValor);
   end;
end;

function TAnalisadorLexico.AnalisarLexema(const pLexema: string): TItemDic;
var
   lChar: Char;
   lEstadoNovo, lEstadoAnterior: TEstadoLFA;
begin
   FAutomato.RestaurarEstadoInicial;
   for lChar in pLexema do
   begin
      lEstadoAnterior := lEstadoNovo;
      try
         lEstadoNovo := FAutomato.Transitar(lChar);
      except
         on e: Exception do
         begin
            raise Exception.Create(e.Message);
         end;
      end;
   end;
   if Assigned(lEstadoNovo) then
   begin
      if lEstadoNovo.Final then
      begin
         lEstadoNovo.
      end;

      Result := TItemDic.Create(lEstadoNovo.);
   end;
end;

procedure TAnalisadorLexico.AnalisarLinha(const pLinha: string);
var
   lChar: Char;
   lEstadoNovo, lEstadoAnterior: TEstadoLFA;
begin
   FAutomato.RestaurarEstadoInicial;
   FCadeiaAnalise := EmptyStr;
   lEstadoNovo := nil;
   for lChar in pLinha do
   begin
      FCadeiaAnalise.Insert(Pred(Length(FCadeiaAnalise)), lChar);
      lEstadoAnterior := lEstadoNovo;
      lEstadoNovo := FAutomato.Transitar(lChar);
      if not Assigned(lEstadoNovo) then
      begin
         lEstadoNovo := lEstadoAnterior;
         Break;
      end;
   end;
   if lEstadoAnterior.Final then
   begin

   end;
end;

constructor TAnalisadorLexico.Create;
begin
   inherited Create;
   FDicTabelaSimbolos := TDictionary<integer, TItemDic>.Create;
   FAutomato := TAutomatoLexico.Create;
   IniciarDicSimbolos;
end;

destructor TAnalisadorLexico.Destroy;
begin
   FDicTabelaSimbolos.Destroy;
   FAutomato.Free;
   inherited;
end;

procedure TAnalisadorLexico.IniciarDicSimbolos;
var
   lElemento: string;
begin
   for lElemento in SIMBOLOS_INICIAIS do
   begin
      AdicionarItemDic(TItemDic.Create(lElemento, lElemento, TIPO_NULO));
   end;
end;

end.

