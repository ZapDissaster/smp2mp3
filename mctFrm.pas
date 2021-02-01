unit mctFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, smp2mp3Utils;

type
  TfrmMCT = class(TForm)
    lblTipo: TLabel;
    cboTipo: TComboBox;
    gbExample: TGroupBox;
    memExample: TMemo;
    lblDir: TLabel;
    edDir: TEdit;
    sbDir: TSpinButton;
    lblFile: TLabel;
    edFromFile: TEdit;
    sbFromFile: TSpinButton;
    chkMultiple: TCheckBox;
    lblToFile: TLabel;
    edToFile: TEdit;
    sbToFile: TSpinButton;
    chkUseHex: TCheckBox;
    btnGenerate: TButton;
    btnClose: TButton;
    procedure sbDirUpClick(Sender: TObject);
    procedure sbDirDownClick(Sender: TObject);
    procedure sbFromFileUpClick(Sender: TObject);
    procedure sbToFileUpClick(Sender: TObject);
    procedure sbToFileDownClick(Sender: TObject);
    procedure sbFromFileDownClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure edDirChange(Sender: TObject);
    procedure edFromFileChange(Sender: TObject);
    procedure edToFileChange(Sender: TObject);
    procedure chkMultipleClick(Sender: TObject);
    procedure btnGenerateClick(Sender: TObject);
    procedure edDirKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edFromFileKeyUp(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edToFileKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
  private
    FLanguage: TLanguage;
    { Private declarations }
    function IncHex(AnHex : string; ACount : integer = 1) : string;
    function IncValue(AValue : string; AUseHex : boolean; ACount : integer = 1) : string;
    procedure ValuesChanged;
    function CompleteDirIndex(AValue : string) : string;
    function CompleteFileIndex(AValue : string) : string;
    procedure SetLanguage(const Value: TLanguage);
  public
    { Public declarations }
    property Language : TLanguage read FLanguage write SetLanguage;
  end;

var
  frmMCT: TfrmMCT;

implementation

uses
  StrUtils, FileCtrl, Smp2Mp3Frm, IniFiles;

{$R *.dfm}

{ TfrmMCT }

procedure TfrmMCT.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmMCT.btnGenerateClick(Sender: TObject);
  //**************************************************************************//
  procedure lCreateMct(ADirIndex, AFileIndex, aSavetoDir : string);
  var
    lCompleteDirIndex, lCompleteFileIndex : string;
  begin
    if RightStr(aSavetoDir,1) <> '\' then
      aSavetoDir := aSavetoDir + '\';
    lCompleteDirIndex := CompleteDirIndex(ADirIndex);
    lCompleteFileIndex := CompleteFileIndex(AFileIndex);
    //easy (lazy) way to save a text file
    with TStringList.Create do
    try
      Add('+Sector: 0');
      Add('6C377854770804006263646566676869');
      Add('00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex);
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 1');
      Add('00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex);
      Add('00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex);
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 2');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 3');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 4');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 5');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 6');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 7');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 8');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 9');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 10');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 11');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 12');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 13');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 14');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      Add('+Sector: 15');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('00000000000000000000000000000000');
      Add('FFFFFFFFFFFFFF078069FFFFFFFFFFFF');
      SaveToFile(aSavetoDir + lCompleteDirIndex + '-' + lCompleteFileIndex + '.mct');
    finally
      Free;
    end;
  end;
  //**************************************************************************//
var
  lDestDir : string;
  lFinished : boolean;
  lDirIndex, lFirstFileIndex, lLastFileIndex, lCurrentFileIndex : string;
begin
  AddHourGlassCursor;
  with TIniFile.Create(IniFileName) do
  try
    lDestDir := ReadString('PREVIOUSVALUES','MCTDIR','');
  finally
    Free;
  end;
  if not DirectoryExists(lDestDir) then
    lDestDir := '';
  try
    if not SelectDirectory(Language.CAPTION_SAVE_TO,'', lDestDir,[sdNewFolder],nil) then
      Exit;
    lDirIndex := edDir.Text;
    lFirstFileIndex := edFromFile.Text;
    lLastFileIndex := edToFile.Text;
    lCurrentFileIndex := lFirstFileIndex;
    repeat
      lCreateMct(lDirIndex,lCurrentFileIndex,lDestDir);
      if not chkMultiple.Checked then
        lFinished := true
      else
      begin
        lCurrentFileIndex := IncValue(lCurrentFileIndex,chkUseHex.Checked);
        lFinished := StrToInt('$' + lCurrentFileIndex) > StrToInt('$' + lLastFileIndex);
      end;
    until lFinished;
    with TIniFile.Create(IniFileName) do
    try
      WriteString('PREVIOUSVALUES','MCTDIR',lDestDir);
    finally
      Free;
    end;

  finally
    RemoveHourGlassCursor;
  end;
  MessageDlg(Language.MESSAGES_FILES_GENERATED, mtInformation, [mbOK], 0);
end;

procedure TfrmMCT.chkMultipleClick(Sender: TObject);
begin
  lblToFile.Visible := chkMultiple.Checked;
  edToFile.Visible := chkMultiple.Checked;
  sbToFile.Visible := chkMultiple.Checked;
  chkUseHex.Visible := chkMultiple.Checked;
  ValuesChanged;
end;

function TfrmMCT.CompleteDirIndex(AValue: string): string;
begin
  result := RightStr('00' + AValue,2);
end;

function TfrmMCT.CompleteFileIndex(AValue: string): string;
begin
  Result := RightStr('0000' + AValue,4);
end;

procedure TfrmMCT.edDirChange(Sender: TObject);
begin
  ValuesChanged;
end;

procedure TfrmMCT.edDirKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP : sbDirUpClick(sbDir);
    VK_DOWN : sbDirDownClick(sbDir);
  end;
end;

procedure TfrmMCT.edFromFileChange(Sender: TObject);
begin
  ValuesChanged;
end;

procedure TfrmMCT.edFromFileKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP : sbFromFileUpClick(sbDir);
    VK_DOWN : sbFromFileDownClick(sbDir);
  end;
end;

procedure TfrmMCT.edToFileChange(Sender: TObject);
begin
  ValuesChanged;

end;

procedure TfrmMCT.edToFileKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case key of
    VK_UP : sbToFileUpClick(sbDir);
    VK_DOWN : sbToFileDownClick(sbDir);
  end;
end;

procedure TfrmMCT.FormShow(Sender: TObject);
begin
  ValuesChanged;
end;

function TfrmMCT.IncHex(AnHex: string; ACount : integer = 1): string;
var
  lAddHexSimbol : boolean;
  lIntValue : integer;
begin
  anHex := trim(AnHex);
  result := AnHex;
  if anHex = '' then
    exit;

  lAddHexSimbol := false;
  if length(AnHex) > 2 then
  begin
    if (UpCase(AnHex[2]) <> 'X') and (AnHex[1] <> '$') then
      lAddHexSimbol := true;
  end
  else if AnHex[1] <> '$' then
    lAddHexSimbol := true;

  if lAddHexSimbol then
    AnHex := '$' + AnHex;

  lIntValue := StrToInt(AnHex);
  inc(lIntValue,ACount);
  result := IntToHex(lIntValue,4);
end;

function TfrmMCT.IncValue(AValue: string; AUseHex : boolean; ACount : integer = 1): string;
var
  lIntValue : integer;
begin
  if AUseHex then
    result := IncHex(AValue,ACount)
  else
  begin
    lIntValue := StrToInt(AValue);
    inc(lIntValue,ACount);
    result := IntToStr(lIntValue);
  end;  
end;

procedure TfrmMCT.sbDirDownClick(Sender: TObject);
begin
  edDir.Text := CompleteDirIndex(IncValue(edDir.Text,true,-1));
end;

procedure TfrmMCT.sbDirUpClick(Sender: TObject);
begin
  edDir.Text := CompleteDirIndex(IncValue(edDir.Text,true));
end;

procedure TfrmMCT.sbFromFileDownClick(Sender: TObject);
begin
  edFromFile.Text := CompleteFileIndex(IncValue(edFromFile.Text,true,-1));
end;

procedure TfrmMCT.sbFromFileUpClick(Sender: TObject);
begin
  edFromFile.Text := CompleteFileIndex(IncValue(edFromFile.Text,true));
end;

procedure TfrmMCT.sbToFileDownClick(Sender: TObject);
begin
  edToFile.Text := CompleteFileIndex(IncValue(edToFile.Text,true,-1));
end;

procedure TfrmMCT.sbToFileUpClick(Sender: TObject);
begin
  edToFile.Text := CompleteFileIndex(IncValue(edToFile.Text,true));
end;

procedure TfrmMCT.SetLanguage(const Value: TLanguage);
begin
  FLanguage := Value;
  Caption := FLanguage.frmMct_Caption;
  lblTipo.Caption := FLanguage.frmMct_lblTipo_Caption;
  lblDir.Caption := FLanguage.frmMct_lblDir_Caption;
  lblFile.Caption := FLanguage.frmMct_lblFile_Caption;
  lblToFile.Caption := FLanguage.frmMct_lblToFile_Caption;
  chkMultiple.Caption := FLanguage.frmMct_chkMultiple_Caption;
  chkUseHex.Caption := FLanguage.frmMct_chkUseHex_Caption;
  gbExample.Caption := FLanguage.frmMct_gbExample_Caption;
  btnGenerate.Caption := FLanguage.frmMct_btnGenerate_Caption;
  btnClose.Caption := FLanguage.frmMct_btnClose_Caption;
end;

procedure TfrmMCT.ValuesChanged;
var
  lFirstFile, lLastFile, lDirFile : string;
  lLine1, lLine2 : string;
begin
  memExample.Clear;
  lDirFile := 'TMB' + CompleteDirIndex(edDir.Text);
  lFirstFile := 'T' + CompleteFileIndex(edFromFile.Text) + '.smp';
  lLastFile := 'T' + CompleteFileIndex(edToFile.Text) + '.smp';
  lLine1 := lDirFile + '\' + lFirstFile;
  lLine2 := 'TMB-ABC\' + lFirstFile;
  if chkMultiple.Checked then
  begin
    lLine1 := lLine1 + ' - ' + lDirFile + '\' + lLastFile;
    lLine2 := lLine2 + ' - ' + 'TMB-ABC\' + lLastFile;
  end;
  memExample.Lines.Add('');
  memExample.Lines.Add(lLine1);
  memExample.Lines.Add(lLine2);
end;

end.
