unit uAutomatoLexico;

interface
   uses uClassesBase, System.Generics.Collections, uEstadoLFA;

type
   TAutomatoLexico = class(TObject)
      private
         var
            FListaEstados: TObjectList<TEstadoLFA>;
            FEstadoInicialObj: TObject;
            FPEstadoAtual: TPEstadoLFA;
         procedure CriarEstados;
         procedure ConfigurarEstados;
         function EstadoByID(const pID: TEstadoAutomatoMGOL): TEstadoLFA;
      public
         constructor Create;
         destructor Destroy;override;
         procedure RestaurarEstadoInicial;
         function Transitar(pCadeia: string): TEstadoLFA;

         property PEstadoAtual: TPEstadoLFA read FPEstadoAtual;
   end;

implementation

{ TAutomatoLexico }

procedure TAutomatoLexico.ConfigurarEstados;
var
   lIndex: Integer;
   lEstado: TEstadoLFA;
begin
   for lIndex := 0 to  Pred(FListaEstados.Count) do
   begin
      lEstado := FListaEstados[lIndex];
      case lEstado.Id of
         teQ0:
         begin   
            lEstado.ListaTransicoes.Add(TTransicao.Create('L', EstadoByID(teq6)));         
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', EstadoByID(teq21)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('"', EstadoByID(teq4)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('{', EstadoByID(teq1)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('EOF', EstadoByID(teq3)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('<', EstadoByID(teq7)));            
            lEstado.ListaTransicoes.Add(TTransicao.Create('>', EstadoByID(teq11)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('=', EstadoByID(teq13)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('-', EstadoByID(teq9)));                                    
            lEstado.ListaTransicoes.Add(TTransicao.Create('+', EstadoByID(teq9)));            
            lEstado.ListaTransicoes.Add(TTransicao.Create('*', EstadoByID(teq9)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('/', EstadoByID(teq9)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('(', EstadoByID(teq15)));            
            lEstado.ListaTransicoes.Add(TTransicao.Create(')', EstadoByID(teq16)));
            lEstado.ListaTransicoes.Add(TTransicao.Create(';', EstadoByID(teq14)));            
         end;
         teQ1:
         begin   
            lEstado.ListaTransicoes.Add(TTransicao.Create('}', EstadoByID(teq2)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('.', lEstado));            
         end;         
         teQ4:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('"', EstadoByID(teq5)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('.', lEstado));            
         end;
         teQ6:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('L', lEstado));
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', lEstado));
            lEstado.ListaTransicoes.Add(TTransicao.Create('_', lEstado));
         end;
         teQ7:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('>', EstadoByID(teq9)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('=', EstadoByID(teq8)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('-', EstadoByID(teq20)));
         end;
         teQ11:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('=', EstadoByID(teq12)));         
         end;
         teQ21:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', lEstado));         
            lEstado.ListaTransicoes.Add(TTransicao.Create('e', EstadoByID(teq24)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('E', EstadoByID(teq24)));
            lEstado.ListaTransicoes.Add(TTransicao.Create('.', EstadoByID(teq22)));
         end;
         teQ22:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', EstadoByID(teq23)));         
         end;         
         teQ24:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', EstadoByID(teq23)));         
            lEstado.ListaTransicoes.Add(TTransicao.Create('-', EstadoByID(teq25)));            
            lEstado.ListaTransicoes.Add(TTransicao.Create('+', EstadoByID(teq25)));                        
         end;         
      end;
   end;
end;

constructor TAutomatoLexico.Create;
begin
   inherited Create;
   FListaEstados := TObjectList<TEstadoLFA>.Create;
   CriarEstados;
   ConfigurarEstados;
   RestaurarEstadoInicial;
end;

procedure TAutomatoLexico.CriarEstados;
var
   lEst: TEstadoAutomatoMGOL;
   lFinal: Boolean;
begin
   for lEst in ARRAY_ESTADOS do
   begin
      lFinal :=  (lEst in [teQ2, teQ3, teQ5, teQ6, teQ7, teQ8, teQ9, teQ10, teQ11, teQ12, 
                  teQ13,teQ14, teQ15, teQ16, teQ21, teQ23]);
      FListaEstados.Add(TEstadoLFA.Create(lEst, lFinal));
   end;
end;

destructor TAutomatoLexico.Destroy;
begin
   FListaEstados.Free;
   inherited;
end;

function TAutomatoLexico.EstadoByID(const pID: TEstadoAutomatoMGOL): TEstadoLFA;
var
   lIndex: Integer;
   lEstado: TEstadoLFA;
begin
   for lIndex := 0 to  Pred(FListaEstados.Count) do
   begin
      lEstado := FListaEstados[lIndex];
      if lEstado.Id = pID then
      begin
         Result := lEstado;
         Exit;
      end;
   end;
end;

procedure TAutomatoLexico.RestaurarEstadoInicial;
begin
   FEstadoInicialObj := FListaEstados.Items[0];
   FPEstadoAtual     := Addr(FEstadoInicialObj);
end;

function TAutomatoLexico.Transitar(pCadeia: string): TEstadoLFA;
begin
   pCadeia       := TAjudaLexema.CharToElemento(pCadeia);
   Result        := FPEstadoAtual^.Transitar(pCadeia);
   FPEstadoAtual := @Result;
end;

end.
