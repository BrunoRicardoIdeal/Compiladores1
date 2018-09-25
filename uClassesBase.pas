unit uClassesBase;

interface
   uses
      System.Generics.Collections, uTransicao, strutils, Sysutils,
      System.Character;

type
   TEstadoAutomatoMGOL = ( teQ0, teQ1, teQ2, teQ3, teQ4, teQ5, teQ6, teQ7,
      teQ8, teQ9, teQ10, teQ11, teQ12, teQ13, teQ14, teQ15, teQ16, teQ17,
      teQ18, teQ19, teQ20, teQ21, teQ22, teQ23, teQ24, teQ25, teQ26
   );

   TEItemDesconhecido = class(Exception);

   TEstado = class(TObject)
      private
         FId: TEstadoAutomatoMGOL;
         FFinal: boolean;
      public
         constructor Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
         property Id: TEstadoAutomatoMGOL read FId write FId;
         property Final : boolean read FFinal write FFinal default False;
   end;

   TTransicao = class(TObject)
      private
         FElemento: string;
         FEstadoDestino: TEstado;
      public
         constructor Create(pElemento: string; pEstadoDestino: TEstado);
         property Elemento: string read FElemento;
         property EstadoDestino: TEstado read FEstadoDestino;
   end;

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

   TAjuda = class
      class function CharToElemento(const pCaractere: string): string;
      class function EstaoIsFinal(const pEstado: TEstadoAutomatoMGOL): Boolean;
   end;

const
   ARRAY_ESTADOS: array[1..27] of TEstadoAutomatoMGOL = (
      teQ0, teQ1, teQ2, teQ3, teQ4, teQ5, teQ6, teQ7,
      teQ8, teQ9, teQ10, teQ11, teQ12, teQ13, teQ14, teQ15, teQ16, teQ17,
      teQ18, teQ19, teQ20, teQ21, teQ22, teQ23, teQ24, teQ25, teQ26
   );

   ARRAY_ESTADOS_FINAIS: array[1..17] of TEstadoAutomatoMGOL = (
      teQ2, teQ3, teQ5, teQ6, teQ7, teQ8, teQ9, teQ10, teQ11, teQ12,
      teQ13,teQ14, teQ15, teQ16, teQ21, teQ23, teQ26);

implementation

{ TClassHelper }

class function TAjuda.CharToElemento(const pCaractere: string): string;
begin
   if not pCaractere.isEmpty then
   begin
      if pCaractere[1].IsDigit then
      begin
         Result := 'D';
      end
      else if ((pCaractere[1].IsLetter) or (pCaractere[1] = '_')) then
      begin
         Result := 'L';
      end
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

end.
