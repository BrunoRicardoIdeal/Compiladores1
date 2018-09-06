program AnalisadorLexico;

uses
  Vcl.Forms,
  uFrmPrinc in 'uFrmPrinc.pas' {frmPrincipal},
  uClassesBase in 'uClassesBase.pas',
  uAnalisadorLexico in 'uAnalisadorLexico.pas',
  uAutomatoLexico in 'uAutomatoLexico.pas',
  uEstadoLFA in 'uEstadoLFA.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
