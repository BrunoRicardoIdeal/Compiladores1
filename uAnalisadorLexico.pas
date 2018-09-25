unit uAnalisadorLexico;

interface

uses uClassesBase, System.Generics.Collections, uAutomatoLexico, Classes;

type
   TAnalisadorLexico = class(TObject)
      private
         const
            SIMBOLOS_INICIAIS: array[1..12] of string =
               ('varinicio', 'varfim', 'inicio', 'escreva', 'leia',
                'se', 'entao', 'fimse', 'fim', 'inteiro', 'literal',
                'real');
            TIPO_NULO = 'N';
         var
            FDicTabelaSimbolos: TDictionary<integer, TItemDic> ;
            FCadeiaAnalise: string;
            FAutomato: TAutomatoLexico;
            FFonte: TStringList;

         function IsSImboloInicial(const pSimbolo: string): boolean;
      public
         constructor Create(const pFonte: string);
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
   lEstadoNovo: TEstadoLFA;
   lTok: string;
   lItemDic, litemInicial: TItemDic;
begin
   Result := nil;
   FAutomato.RestaurarEstadoInicial;
   for lChar in pLexema do
   begin
      lTok := FAutomato.Transitar(lChar).Token;
   end;

   if lTok = 'id' then
   begin
      if IsSImboloInicial(pLexema) then
      begin
         lTok := pLexema;
      end;
      lItemDic := TItemDic.Create(lTok, pLexema, TIPO_NULO);
      AdicionarItemDic(lItemDic);
   end
   else
   begin
      lItemDic := TItemDic.Create(lTok, pLexema, TIPO_NULO);
   end;
   Result := lItemDic;
end;

procedure TAnalisadorLexico.AnalisarLinha(const pLinha: string);
var
   lChar: Char;
   lEstadoNovo, lEstadoAnterior: TEstadoLFA;
begin
//   FAutomato.RestaurarEstadoInicial;
//   FCadeiaAnalise := EmptyStr;
//   lEstadoNovo := nil;
//   for lChar in pLinha do
//   begin
//      FCadeiaAnalise.Insert(Pred(Length(FCadeiaAnalise)), lChar);
//      lEstadoAnterior := lEstadoNovo;
//      lEstadoNovo     := FAutomato.Transitar(lChar);
//      if not Assigned(lEstadoNovo) then
//      begin
//         lEstadoNovo := lEstadoAnterior;
//         Break;
//      end;
//   end;
//   if lEstadoAnterior.Final then
//   begin
//
//   end;
end;

constructor TAnalisadorLexico.Create(const pFonte: string);
begin
   inherited Create;
   FDicTabelaSimbolos := TDictionary<integer, TItemDic>.Create;
   FAutomato := TAutomatoLexico.Create;
   FFonte := TStringList.Create;
   FFonte.Text := pFonte;
   IniciarDicSimbolos;
end;

destructor TAnalisadorLexico.Destroy;
begin
   FDicTabelaSimbolos.Destroy;
   FAutomato.Free;
   FFonte.Free;
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

end.

