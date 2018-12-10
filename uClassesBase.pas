unit uClassesBase;

interface
   uses
      System.Generics.Collections, uTransicao, strutils, Sysutils,
      System.Character, Classes;

type

   //Enumerado de todos os estados possíveis no MGOL
   TEstadoAutomatoMGOL = ( teQ0, teQ1, teQ2, teQ3, teQ4, teQ5, teQ6, teQ7,
      teQ8, teQ9, teQ10, teQ11, teQ12, teQ13, teQ14, teQ15, teQ16, teQ17,
      teQ18, teQ19, teQ20, teQ21, teQ22, teQ23, teQ24, teQ25, teQ26, teQ27,
      teQ28, teQ29, teQ30, teQ31, teQ32, teQ33, teQ34,teQ35, teQ36,teQ37,teQ38,
      teQ39,teQ40, teQ41, teQ42,teQ43,teQ44,teQ45,teQ46,teQ47,teQ48,teQ49,teQ50,
      teQ51,teQ52,teQ53,teQ54,teQ55,teQ56,teQ57, teQ58);

   //Tipagem da classe de elemento desconhecido
   TEItemDesconhecido = class(Exception);

   //Tipos auxiliares
   TNumeros = array of Integer;
   TStringArray = array of string;

   //Classe pai de um estado de autômato
   TEstado = class(TObject)
      private
         FId: TEstadoAutomatoMGOL;
         FFinal: boolean;
         FSeguinte: string;
      public
         constructor Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
         property Id: TEstadoAutomatoMGOL read FId write FId;
         property Final : boolean read FFinal write FFinal default False;
         property Seguinte: string read FSeguinte write FSeguinte;
   end;

   //Classe de uma transição de autômato
   TTransicao = class(TObject)
      private
         FElemento: string;
         FEstadoDestino: TEstado;
      public
         constructor Create(pElemento: string; pEstadoDestino: TEstado);
         property Elemento: string read FElemento;
         property EstadoDestino: TEstado read FEstadoDestino;
   end;

   //Item de dicionáriio, o qual participará da tabela de símbolos
   TItemDic = class(TObject)
      private
         FToken: string;
         FLexema: string;
         FTipo: string;
         FListaProduzido: TObjectList<TItemDic>;
    procedure SetLexema(const Value: string);
    procedure SetTipo(const Value: string);
    procedure SetToken(const Value: string);
      public
         constructor Create(const pToken, pLexema: string; const pTipo: string);
         destructor Destroy;override;
         procedure Clone(pOrigem: TItemDic; pFull: boolean = False);
         property Token: string read FToken write SetToken;
         property Lexema: string read FLexema write SetLexema;
         property Tipo: string read FTipo write SetTipo;
         property ListaProduzido: TObjectList<TItemDic> read FListaProduzido write FListaProduzido;
   end;

   TProducao = class(TObject)
      private
         FID: integer;
         FSimbOrigem: string;
         FProduzido: string;
      public
         constructor Create(pId: integer; pOrigem, pProduzido: string);
   end;

   TPilhaSintatico  = TStack<TEstado>;

//   TPilhaSemantico = class(TObjectStack<TItemDic>)
//      private
//
//      public
//         function Popar: TItemDic;
//   end;

   TTipoAcaoSintatico = (ttaShift, ttaReduce, ttaAccept, ttaError);

   TAcaoSintatico = class(TObject)
      private
         FTipo: TTipoAcaoSintatico;
         FAlvo: TEstado;
      public
         constructor Create(const pTipo: TTipoAcaoSintatico; pAlvo: TEstado);

         property Tipo: TTipoAcaoSintatico read FTipo;
         property Alvo: TEstado read FAlvo;
   end;

   //Classe helper
   TAjuda = class
      class function CharToElemento(const pCaractere: string): string;
      class function CharTipoToStr(const pTipo: Char): string;
      class function EstaoIsFinal(const pEstado: TEstadoAutomatoMGOL): Boolean;
      class function GetTipoByItemDic(const pItemDic: TItemDic): string;
      class function PopObjectStack(var pObjStack: TObjectStack<TItemDic>): TItemDic;
      class function GetSimbolosBeta(pBeta: string): TStringList;
      class function PodeOperarRelacional(const pTipo: string): Boolean;
   end;

const
   CHAR_CURINGA = '§';
   CHAR_EOF = '¢';
   TIPO_NULO = 'N';
   TIPO_LITERAL = 'L';
   TIPO_INTEIRO = 'I';
   TIPO_REAL = 'R';
   CAMINHO_FONTE = 'Fonte.txt';
   CAMINHO_FONTEO = 'FonteO.txt';
   INDEX_PAI = 0;
   INDEX_FILHO1 = 1;
   INDEX_FILHO2 = 2;


   //Vetor com os estados úteis(recurso para laço)
   ARRAY_ESTADOS: array[1..27] of TEstadoAutomatoMGOL = (
      teQ0, teQ1, teQ2, teQ3, teQ4, teQ5, teQ6, teQ7,
      teQ8, teQ9, teQ10, teQ11, teQ12, teQ13, teQ14, teQ15, teQ16, teQ17,
      teQ18, teQ19, teQ20, teQ21, teQ22, teQ23, teQ24, teQ25, teQ26
   );

   //Vetor com todos os estados de aceitação
   ARRAY_ESTADOS_FINAIS: array[1..18] of TEstadoAutomatoMGOL = (
      teQ2, teQ3, teQ5, teQ6, teQ7, teQ8, teQ9, teQ10, teQ11, teQ12,
      teQ13,teQ14, teQ15, teQ16, teQ20, teQ21, teQ23, teQ26);


   ARRAY_ESTADOS_SINT: array[1..59] of TEstadoAutomatoMGOL = (
      teQ0, teQ1, teQ2, teQ3, teQ4, teQ5, teQ6, teQ7,
      teQ8, teQ9, teQ10, teQ11, teQ12, teQ13, teQ14, teQ15, teQ16, teQ17,
      teQ18, teQ19, teQ20, teQ21, teQ22, teQ23, teQ24, teQ25, teQ26, teQ27,
      teQ28, teQ29, teQ30, teQ31, teQ32, teQ33, teQ34,teQ35, teQ36,teQ37,teQ38,
      teQ39,teQ40, teQ41, teQ42,teQ43,teQ44,teQ45,teQ46,teQ47,teQ48,teQ49,teQ50,
      teQ51,teQ52,teQ53,teQ54,teQ55,teQ56,teQ57, teQ58
   );

implementation

{ TClassHelper }

class function TAjuda.CharTipoToStr(const pTipo: Char): string;
begin
   case pTipo of
      TIPO_NULO: Result := 'Nulo';
      TIPO_LITERAL: Result := 'Literal';
      TIPO_INTEIRO: Result := 'Inteiro';
      TIPO_REAL: Result := 'Real';
   end;
end;

class function TAjuda.CharToElemento(const pCaractere: string): string;
begin
   if not pCaractere.isEmpty then
   begin
      //Dígito
      if pCaractere[1].IsDigit then
      begin
         Result := 'D';
      end
      //Letra ou underline
      else if ((pCaractere[1].IsLetter) or (pCaractere[1] = '_')) then
      begin
         Result := 'L';
      end
      //Espaço
      else if pCaractere[1] = ' ' then
      begin
         Result := 'ESPAÇO';
      end
      //Tabulação
      else if pCaractere[1] = #09 then
      begin
         Result := 'TAB';
      end
      //Qualquer outro elemento
      else
      begin
         Result := pCaractere[1];
      end;
   end;
end;

{ TEstado }

constructor TEstado.Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
begin
   FId := pId;
   FFinal := pFinal;
end;

{ TTransicao }

constructor TTransicao.Create(pElemento: string; pEstadoDestino: TEstado);
begin
   inherited Create;
   FElemento := pElemento;
   FEstadoDestino := pEstadoDestino;
end;

{ TItemDic }

procedure TItemDic.Clone(pOrigem: TItemDic; pFull: boolean = False);
begin
   if pFull then
   begin
      Self.FToken := pOrigem.Token;
   end;

   Self.FLexema := pOrigem.Lexema;
   Self.FTipo := pOrigem.Tipo;
end;

constructor TItemDic.Create(const pToken, pLexema: string; const pTipo: string);
begin
   FToken := pToken;
   FTipo := pTipo;
   FLexema := pLexema;
   FListaProduzido := TObjectList<TItemDic>.Create();
end;

destructor TItemDic.Destroy;
begin
   FListaProduzido.Free;
   inherited;
end;

procedure TItemDic.SetLexema(const Value: string);
begin
  FLexema := Value;
end;

procedure TItemDic.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

procedure TItemDic.SetToken(const Value: string);
begin
  FToken := Value;
end;

class function TAjuda.EstaoIsFinal(const pEstado: TEstadoAutomatoMGOL): Boolean;
var
   lIndice: integer;
begin
   //Verifica se o estado está dentro da definição de estados finais
   Result := False;
   for lIndice := Low(ARRAY_ESTADOS_FINAIS) to High(ARRAY_ESTADOS_FINAIS) do
   begin
      if pEstado = ARRAY_ESTADOS_FINAIS[lIndice] then
      begin
         Result := True;
         break;
      end;
   end;
end;
class function TAjuda.GetSimbolosBeta(pBeta: string): TStringList;
begin
   Result                 := TStringList.Create;
   Result.Delimiter       := ' ';
   Result.StrictDelimiter := True;
   Result.DelimitedText   := pBeta;
end;

class function TAjuda.GetTipoByItemDic(const pItemDic: TItemDic): string;
var
   lToken: string;
begin
   if Assigned(pItemDic) then
   begin
      lToken := pItemDic.Token.ToUpper;

      case  AnsiIndexText(lToken.ToUpper.Trim, ['OPM', 'OPR', 'RCB',
         'INTEIRO', 'REAL', 'LITERAL', 'NUM']) of
         0,1,2, 5:  Result := pItemDic.Lexema.Trim;
         3, 6: Result := 'int';
         4: Result := 'double';
      end;
   end;
end;

class function TAjuda.PodeOperarRelacional(const pTipo: string): Boolean;
begin
   Result := (ptipo.ToLower = 'int') or (pTipo.ToLower = 'double');
end;

class function TAjuda.PopObjectStack(
  var pObjStack: TObjectStack<TItemDic>): TItemDic;
var
   lpeek: TItemDic;
begin
   lpeek := pObjStack.Peek;
   Result := TItemDic.Create(lpeek.Token, lpeek.Lexema, lpeek.Tipo);
   pObjStack.Pop;
end;

{ TAcaoSintatico }

constructor TAcaoSintatico.Create(const pTipo: TTipoAcaoSintatico;
  pAlvo: TEstado);
begin
   inherited Create;
   FTipo := pTipo;
   FAlvo := pAlvo;
end;

{ TProducao }

constructor TProducao.Create(pId: integer; pOrigem, pProduzido: string);
begin
   FID := pId;
   FSimbOrigem := pOrigem;
   FProduzido := pProduzido;
end;

{ TPilhaSemantico }

//function TPilhaSemantico.Popar: TItemDic;
//var
//   lpeek: TItemDic;
//begin
//   lpeek := Self.Peek;
//   Result := TItemDic.Create(lpeek.Token, lpeek.Lexema, lpeek.Tipo);
//   Self.Pop;
//end;

end.
