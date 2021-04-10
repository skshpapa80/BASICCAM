program BASICCAM;

uses
  Vcl.Forms,
  uMain in 'uMain.pas' {frmMain},
  DSUtils in 'DSUtils.pas',
  uBaseDShow in 'uBaseDShow.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
