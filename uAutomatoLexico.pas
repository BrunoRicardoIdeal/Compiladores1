unit uAutomatoLexico;

interface
   uses uClassesBase, System.Generics.Collections, uEstadoLFA;

type
   TAutomatoLexico = class(TObject)
      private
         var
            //Lista dos estados do autômato léxico
            FListaEstados: TObjectList<TEstadoLFA>;
            //Posição, na lista de estados, do estado atual
            FIndexEstadoAtual: integer;

         //Inicialização dos estados
         procedure CriarEstados;

         //Configuração de cada estado
         procedure ConfigurarEstados;
         function EstadoByID(const pID: TEstadoAutomatoMGOL): TEstadoLFA;
      public
         constructor Create;
         destructor Destroy;override;
         procedure RestaurarEstadoInicial;
         function IndexOf(const pEstado: TEstadoLFA): Integer;
         function Transitar(pCadeia: string): TEstadoLFA;

         property IndexEstadoAtual: integer read FIndexEstadoAtual;
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
            lEstado.ListaTransicoes.Add(TTransicao.Create(CHAR_EOF, EstadoByID(teq3)));
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
            lEstado.ListaTransicoes.Add(TTransicao.Create('ESPAÇO', lEstado));
            lEstado.ListaTransicoes.Add(TTransicao.Create('TAB', lEstado));
         end;
         teQ1:
         begin   
            lEstado.ListaTransicoes.Add(TTransicao.Create('}', EstadoByID(teq2)));
            lEstado.ListaTransicoes.Add(TTransicao.Create(CHAR_CURINGA, lEstado));
         end;
         teQ4:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('"', EstadoByID(teq5)));
            lEstado.ListaTransicoes.Add(TTransicao.Create(CHAR_CURINGA, lEstado));
         end;
         teQ6:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('L', lEstado));
            lEstado.ListaTransicoes.Add(TTransicao.Create('D', lEstado));
            lEstado.ListaTransicoes.Add(TTransicao.Create('_', lEstado));
         end;
         teQ7:
         begin
            lEstado.ListaTransicoes.Add(TTransicao.Create('>', EstadoByID(teq26)));
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
   lEst       : TEstadoAutomatoMGOL;
   lEstadoLFA : TEstadoLFA;
   lFinal     : Boolean;
begin
   //para cada estado no vetor de possíveis
   for lEst in ARRAY_ESTADOS do
   begin
      //Se final, receberá um token representativo
      lFinal := TAjuda.EstaoIsFinal(lEst);
      lEstadoLFA := TEstadoLFA.Create( lEst, lFinal);

      //Atribuição conforme estipulado pela atividade
      if lFinal then
      begin
         case lEst of
            teQ2: lEstadoLFA.Token := 'Comentário';
            teQ3: lEstadoLFA.Token := 'EOF';
//            teQ5: lEstadoLFA.Token := 'literal';
            teQ5: lEstadoLFA.Token := 'lit';
            teQ6: lEstadoLFA.Token := 'id';

            teQ7, teQ8, teQ11, teQ12, teQ13, teQ26:
            begin
               lEstadoLFA.Token := 'OPR';
            end;

            teQ9: lEstadoLFA.Token := 'OPM';
            teQ10: lEstadoLFA.Token := 'RCB';
            teQ14: lEstadoLFA.Token := 'PT_V';
            teQ15: lEstadoLFA.Token := 'AB_P';
            teQ16: lEstadoLFA.Token := 'FC_P';

//            teQ20: lEstadoLFA.Token := 'ATT';
            teQ20: lEstadoLFA.Token := 'RCB';
            teQ21, teQ23:
            begin
               lEstadoLFA.Token := 'NUM' ;
            end
         end;
      end;

      FListaEstados.Add(lEstadoLFA);
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
   //Encontrar o obj do estado mediante o ID
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

function TAutomatoLexico.IndexOf(const pEstado: TEstadoLFA): Integer;
var
   lIndice: integer;
begin
   for lIndice := 0 to pred(Self.FListaEstados.Count) do
   begin
      if pEstado.Id = Self.FListaEstados[lIndice].Id then
      begin
         Result := lIndice;
         Break;
      end;
   end;
end;

procedure TAutomatoLexico.RestaurarEstadoInicial;
begin
   FIndexEstadoAtual := 0;
end;

function TAutomatoLexico.Transitar(pCadeia: string): TEstadoLFA;
begin
   //Transformar o item lido em um elemento para transição, caso conveniente
   pCadeia           := TAjuda.CharToElemento(pCadeia);

   //provocar a transição do autômato mediante cadeia lida, retornando o índice do elemente atual
   //após transitar
   FIndexEstadoAtual := Self.IndexOf(FListaEstados.Items[FIndexEstadoAtual].Transitar(pCadeia));

   //retornar novo estado obj
   Result            := FListaEstados.Items[FIndexEstadoAtual];
end;

end.
