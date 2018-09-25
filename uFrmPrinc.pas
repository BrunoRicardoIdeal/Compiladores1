unit uFrmPrinc;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, uAutomatoLexico, uAnalisadorLexico,
  Vcl.StdCtrls;

type
  TfrmPrincipal = class(TForm)
    memoFonte: TMemo;
    MemoReconhecido: TMemo;
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
     FAnaLexico: TAnalisadorLexico;
     FFonte: TStringList;
     procedure AnalisarCodigoLexicamente;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

uses
  uClassesBase;

{$R *.dfm}

procedure TfrmPrincipal.AnalisarCodigoLexicamente;
var
   lLinha: string;
   lPalavra: string;
   lChar: Char;
   lItemAnalisado, lItemAnterior: TitemDic;
   lIndex: Integer;
   lErro: boolean;
begin
   for lLinha in FFonte do
   begin
      lItemAnterior := nil;
      lItemAnalisado := nil;
      if lLinha.IsEmpty then
      begin
         Continue;
      end;

      lPalavra := '';
      lIndex := 1;
      repeat
         lChar := lLinha[lIndex];
         lPalavra := lPalavra + lChar;
         try
            lErro := False;
            lItemAnalisado := FAnaLexico.AnalisarLexema(lPalavra);
         except
            on e: TEItemDesconhecido do
            begin
               lErro := True;
               if Assigned(lItemAnterior) then
               begin
                  MemoReconhecido.Lines.Add(lItemAnterior.Token + '-' + lItemAnterior.Lexema);
                  lPalavra := '';
                  lItemAnterior := nil;
               end
               else
               begin
                  MemoReconhecido.Lines.Add(e.message +  ' linha ' + memoFonte.Lines.IndexOf(lLinha).ToString);
                  Abort;
               end;
            end;
         end;

         if Assigned(lItemAnalisado) then
         begin
            lItemAnterior :=  TItemDic.Create(lItemAnalisado.Token, lItemAnalisado.Lexema, lItemAnalisado.Tipo);
         end;
         Inc(lIndex);
      until (lItemAnalisado = nil) or (lIndex > lLinha.Length);

      if (lIndex > lLinha.Length) then
      begin
         if Assigned(lItemAnalisado) and (not lErro) then
         begin
            MemoReconhecido.Lines.Add(lItemAnterior.Token + '-' + lItemAnterior.Lexema);
         end;
      end;
   end;
end;

procedure TfrmPrincipal.Button1Click(Sender: TObject);
begin
   MemoReconhecido.Clear;
   AnalisarCodigoLexicamente;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
   memoFonte.Lines.LoadFromFile('Fonte.txt');
   FAnaLexico := TAnalisadorLexico.Create(memoFonte.Lines.Text);
end;

procedure TfrmPrincipal.FormDestroy(Sender: TObject);
begin
   FAnaLexico.Free;
end;

end.
