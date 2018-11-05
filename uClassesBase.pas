unit uClassesBase;

interface
   uses
      System.Generics.Collections, uTransicao, strutils, Sysutils,
      System.Character;

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
         FTipo: Char;
      public
         constructor Create(const pToken, pLexema: string; const pTipo: Char);
         property Token: string read FToken;
         property Lexema: string read FLexema;
         property Tipo: Char read FTipo;
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
      class function EstaoIsFinal(const pEstado: TEstadoAutomatoMGOL): Boolean;
   end;


const
   CHAR_CURINGA = '§';
   CHAR_EOF = '¢';
   TIPO_NULO = 'N';
   CAMINHO_FONTE = 'Fonte.txt';


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

constructor TItemDic.Create(const pToken, pLexema: string; const pTipo: Char);
begin
   FToken := pToken;
   FTipo := pTipo;
   FLexema := pLexema;
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

end.
