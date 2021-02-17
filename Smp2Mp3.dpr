program Smp2Mp3;

uses
  Forms,
  Smp2Mp3Frm in 'Smp2Mp3Frm.pas' {frmSmp2MP3},
  KeyFrm in 'KeyFrm.pas' {frmKey},
  mctFrm in 'mctFrm.pas' {frmMCT},
  smp2mp3Utils in 'smp2mp3Utils.pas',
  OperationFra in 'OperationFra.pas' {FraOperation: TFrame},
  ID3v2 in 'ID3v2.pas',
  ID3v1 in 'ID3v1.pas',
  RenameFilesFrm in 'RenameFilesFrm.pas' {FrmRenameFiles};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'Smp3Mp3';
  Application.CreateForm(TfrmSmp2MP3, frmSmp2MP3);
  Application.Run;
end.
