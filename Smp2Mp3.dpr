program Smp2Mp3;

uses
  Forms,
  Smp2Mp3Frm in 'Smp2Mp3Frm.pas' {frmSmp2MP3},
  KeyFrm in 'KeyFrm.pas' {frmKey};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmSmp2MP3, frmSmp2MP3);
  Application.Run;
end.
