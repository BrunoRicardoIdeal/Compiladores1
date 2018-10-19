unit uEstadoLFA;

interface

uses uClassesBase, System.Generics.Collections;

type
   TEstadoLFA = class(TEstado)
      private
         //Token representativo do estado (ex: o estado teQ3 representa EOF)
         FToken: string;

         //Lista das transições que o estado possui
         FListaTransicoes: TObjectList<TTransicao>;
      public
         destructor Destroy; override;
         constructor Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
         function Transitar(pCadeia: string): TEstadoLFA;
         function PosCuringa: Integer;

         property Token: string read FToken write FToken;
         property ListaTransicoes: TObjectList<TTransicao> read FListaTransicoes write FListaTransicoes;
   end;

   TPEstadoLFA = ^TEstadoLFA;

implementation

uses
  System.SysUtils;


function TEstadoLFA.PosCuringa: Integer;
var
   lTra: TTransicao;
   lIndex : integer;
begin
   Result := -1;
   //Procura o item curinga na lista de transições
   for lIndex := 0 to Pred(FListaTransicoes.Count) do
   begin
      lTra := FListaTransicoes[lIndex];
      if lTra.Elemento.Equals(CHAR_CURINGA) then
      begin
         Result := lIndex;
         Break;
      end;
   end;
end;

constructor TEstadoLFA.Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
begin
   inherited Create(pId, pFinal);
   FListaTransicoes := TObjectList<TTransicao>.Create();
   FToken := EmptyStr;
end;

destructor TEstadoLFA.Destroy;
begin
   FListaTransicoes.Free;
   inherited;
end;

function TEstadoLFA.Transitar(pCadeia: string): TEstadoLFA;
var
   lElemento: string;
   lIndex: Integer;
begin
   Result := nil;
   //Procura a transição que corresponde ao elemento recebido
   //ex: se eu recebo um 'L' e estou no estado tqe0, qual é meu estado destino
   for lIndex := 0 to Pred(FListaTransicoes.Count) do
   begin
      lElemento := FListaTransicoes[lIndex].Elemento;
      if SameText(pCadeia, lElemento) then
      begin
         Result := TEstadoLFA(FListaTransicoes[lIndex].EstadoDestino);
         Exit;
      end;
   end;

   //Verificação se o estado possui elemento curinga
   lIndex := Self.PosCuringa;
   if lIndex > -1 then
   begin
      //Aceita qualquer entrada
      Result := TEstadoLFA(FListaTransicoes[lIndex].EstadoDestino);
      Exit;
   end;
   
   //Provoca exceção tipada referente ao elemento não encontrado
   raise TEItemDesconhecido.Create('Elemento desconhecido:' + pCadeia);
end;

end.
