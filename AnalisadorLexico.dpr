program AnalisadorLexico;

uses
  Vcl.Forms,
  uFrmPrinc in 'uFrmPrinc.pas' {frmPrincipal},
  uClassesBase in 'uClassesBase.pas',
  uAnalisadorLexico in 'uAnalisadorLexico.pas',
  uAutomatoLexico in 'uAutomatoLexico.pas',
  uEstadoLFA in 'uEstadoLFA.pas',
  Vcl.Themes,
  Vcl.Styles,
  uAnalisadorSintatico in 'uAnalisadorSintatico.pas',
  uDmAux in 'uDmAux.pas' {DmAux: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Purple');
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.CreateForm(TDmAux, DmAux);
  Application.Run;
end.
