unit uEstadoLFA;

interface

uses uClassesBase, System.Generics.Collections;

type
   TEstadoLFA = class(TEstado)
      private
         FToken: string;
         FListaTransicoes: TObjectList<TTransicao>;
      public
         destructor Destroy; override;
         constructor Create(pId: TEstadoAutomatoMGOL; pFinal: boolean);
         function Transitar(pCadeia: string): TEstadoLFA;

         property Token: string read FToken write FToken;
         property ListaTransicoes: TObjectList<TTransicao> read FListaTransicoes write FListaTransicoes;
   end;

   TPEstadoLFA = ^TEstadoLFA;

implementation

uses
  System.SysUtils;


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
   for lIndex := 0 to Pred(FListaTransicoes.Count) do
   begin
      lElemento := FListaTransicoes[lIndex].Elemento;
      if SameText(pCadeia, lElemento) then
      begin
         Result := TEstadoLFA(FListaTransicoes[lIndex].EstadoDestino);
         Exit;
      end;
   end;
   raise TEItemDesconhecido.Create('Elemento desconhecido:' + pCadeia);
end;

end.
