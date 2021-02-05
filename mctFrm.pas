unit mctFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, smp2mp3Utils;

type

  TTagType = (ttNone = -1, ttSalvat = 0, ttLidl = 1, ttMigros = 2);

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
    procedure cboTipoChange(Sender: TObject);
  private
    FLanguage: TLanguage;
    { Private declarations }
    function IncHex(AnHex : string; ACount : integer = 1) : string;
    function IncValue(AValue : string; ACount : integer = 1) : string;
    procedure ValuesChanged;
    function PaddedValueIndex(AValue : string; ALength : integer) : string;
    procedure SetLanguage(const Value: TLanguage);
    function GetTagType: TTagType;
    procedure SetTagType(const Value: TTagType);
    function DirIndexPadding : integer;
    function FileIndexPadding : integer;
  public
    { Public declarations }
    property Language : TLanguage read FLanguage write SetLanguage;
    property TagType : TTagType read GetTagType write SetTagType;
  end;

var
  frmMCT: TfrmMCT;

const
  SALVAT_FILE_INDEX_PADDING = 4;
  SALVAT_DIR_INDEX_PADDING = 2;
  LIDL_FILE_INDEX_PADDING = 4;
  MIGROS_FILE_INDEX_PADDING = 2;

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
const
  EMPTY_BLOCK  = '00000000000000000000000000000000';
  EMPTY_SECTOR = EMPTY_BLOCK+#13+
                 EMPTY_BLOCK+#13+
                 EMPTY_BLOCK+#13+
                 'FFFFFFFFFFFFFF078069FFFFFFFFFFFF';
  //**************************************************************************//
  procedure lCreateSalvatTagFile(ADirIndex, AFileIndex, aSavetoDir : string);
  var
    lCompleteDirIndex, lCompleteFileIndex : string;
    lTEXTFILE : TextFile;
  begin
    if RightStr(aSavetoDir,1) <> '\' then
      aSavetoDir := aSavetoDir + '\';
    lCompleteDirIndex := PaddedValueIndex(ADirIndex,DirIndexPadding);
    lCompleteFileIndex := PaddedValueIndex(AFileIndex,FileIndexPadding);
    AssignFile(lTEXTFILE,aSavetoDir + lCompleteDirIndex + '-' + lCompleteFileIndex + '.mct');
    try
      Rewrite(lTEXTFILE);
      Write(lTEXTFILE,'+Sector: 0'                                                            +#13);
      Write(lTEXTFILE,'4A41554D452B4D4952493D444152494F'                                      +#13);
      Write(lTEXTFILE,'00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex   +#13);
      Write(lTEXTFILE,EMPTY_BLOCK                                                             +#13);
      Write(lTEXTFILE,'FFFFFFFFFFFFFF078069FFFFFFFFFFFF'                                      +#13);
      Write(lTEXTFILE,'+Sector: 1'                                                            +#13);
      Write(lTEXTFILE,'00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex   +#13);
      Write(lTEXTFILE,'00000000000000000002200101' + lCompleteDirIndex + lCompleteFileIndex   +#13);
      Write(lTEXTFILE,EMPTY_BLOCK                                                             +#13);
      Write(lTEXTFILE,'FFFFFFFFFFFFFF078069FFFFFFFFFFFF'                                      +#13);
      Write(lTEXTFILE,'+Sector: 2'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 3'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 4'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 5'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 6'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 7'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 8'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 9'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 10'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 11'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 12'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 13'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 14'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 15'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                                );
    finally
      CloseFile(lTEXTFILE);
    end;
  end;
  //**************************************************************************//
  procedure lCreateMigrosTagFile(AFileIndex, aSavetoDir : string);
  var
    lCompleteFileIndex : string;
    lTEXTFILE : TextFile;
  begin
    if RightStr(aSavetoDir,1) <> '\' then
      aSavetoDir := aSavetoDir + '\';
    lCompleteFileIndex := PaddedValueIndex(AFileIndex,FileIndexPadding);
    AssignFile(lTEXTFILE,aSavetoDir + lCompleteFileIndex + '.mct');
    try
      Rewrite(lTEXTFILE);
      Write(lTEXTFILE,'+Sector: 0'                                                            +#13);
      Write(lTEXTFILE,'4A41554D452B4D4952493D444152494F'                                      +#13);
      Write(lTEXTFILE,'011706180110' + lCompleteFileIndex + '000000000000000000'              +#13);
      Write(lTEXTFILE,EMPTY_BLOCK                                                             +#13);
      Write(lTEXTFILE,'FFFFFFFFFFFFFF078069FFFFFFFFFFFF'                                      +#13);
      Write(lTEXTFILE,'+Sector: 1'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 2'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 3'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 4'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 5'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 6'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 7'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 8'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 9'                                                            +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 10'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 11'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 12'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 13'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 14'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                            +#13);
      Write(lTEXTFILE,'+Sector: 15'                                                           +#13);
      Write(lTEXTFILE,EMPTY_SECTOR                                                                );
    finally
      CloseFile(lTEXTFILE);
    end;
  end;
  //**************************************************************************//
  procedure lCreateLidlFile(AFileIndex, aSavetoDir : string);
  var
    lCompleteFileIndex : string;
    lTEXTFILE : TextFile;
  begin
    lCompleteFileIndex := PaddedValueIndex(AFileIndex,FileIndexPadding);
    AssignFile(lTEXTFILE,aSavetoDir + lCompleteFileIndex + '.csv');
    try
      Rewrite(lTEXTFILE);
      Write(lTEXTFILE,'Type (Link, Text);Content (http://....);URI type (URI, URL, File...);Description;Interaction counter;UID mirror;Interaction counter mirror'  +#13#10);
      Write(lTEXTFILE,'Text;02200408' + lCompleteFileIndex + '00;en;L' + lCompleteFileIndex + ';no;no;no'                                                           +#13#10);
    finally
      CloseFile(lTEXTFILE);
    end;
  end;
  //**************************************************************************//
  procedure lCreateTagFile(ADirIndex, AFileIndex, aSavetoDir : string);
  begin
    if RightStr(aSavetoDir,1) <> '\' then
      aSavetoDir := aSavetoDir + '\';
    if TagType = ttSalvat then
      lCreateSalvatTagFile(ADirIndex,AFileIndex,aSavetoDir)
    else if TagType = ttLidl then
      lCreateLidlFile(AFileIndex,aSavetoDir)
    else if TagType = ttMigros then
      lCreateMigrosTagFile(AFileIndex,aSavetoDir);
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
      lCreateTagFile(lDirIndex,lCurrentFileIndex,lDestDir);
      if not chkMultiple.Checked then
        lFinished := true
      else
      begin
        lCurrentFileIndex := IncValue(lCurrentFileIndex);
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

procedure TfrmMCT.cboTipoChange(Sender: TObject);
begin
  lblDir.Visible := TagType = ttSalvat;
  edDir.Visible := TagType = ttSalvat;
  sbDir.Visible := TagType = ttSalvat;
  edDir.Text := PaddedValueIndex(edDir.Text,DirIndexPadding);
  edFromFile.Text := PaddedValueIndex(edFromFile.Text,FileIndexPadding);
  edToFile.Text := PaddedValueIndex(edToFile.Text,FileIndexPadding);
  ValuesChanged;
end;

procedure TfrmMCT.chkMultipleClick(Sender: TObject);
begin
  lblToFile.Visible := chkMultiple.Checked;
  edToFile.Visible := chkMultiple.Checked;
  sbToFile.Visible := chkMultiple.Checked;
  ValuesChanged;
end;

function TfrmMCT.DirIndexPadding: integer;
begin
  result := SALVAT_DIR_INDEX_PADDING;
end;

function TfrmMCT.PaddedValueIndex(AValue : string; ALength : integer) : string;
begin
  result := Uppercase(RightStr(StringOfChar('0',ALength) + AValue,ALength));
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

function TfrmMCT.FileIndexPadding: integer;
begin
  result := 0;
  case TagType of
    ttSalvat : Result := SALVAT_FILE_INDEX_PADDING;
    ttLidl : Result := LIDL_FILE_INDEX_PADDING;
    ttMigros : Result := MIGROS_FILE_INDEX_PADDING;
  end;
end;

procedure TfrmMCT.FormShow(Sender: TObject);
begin
  ValuesChanged;
end;

function TfrmMCT.GetTagType: TTagType;
begin
  result := TTagType(cboTipo.ItemIndex);
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
  if lIntValue < 0 then
    lIntValue := 0;
  result := IntToHex(lIntValue,4);
end;

function TfrmMCT.IncValue(AValue: string; ACount : integer = 1): string;
var
  lIntValue : integer;
begin
  if chkUseHex.Checked then
    result := IncHex(AValue,ACount)
  else
  begin
    lIntValue := StrToInt(AValue);
    inc(lIntValue,ACount);
    if lIntValue < 0 then
      lIntValue := 0;
    
    result := IntToStr(lIntValue);
  end;
end;

procedure TfrmMCT.sbDirDownClick(Sender: TObject);
begin
  edDir.Text := PaddedValueIndex(IncValue(edDir.Text,-1),DirIndexPadding);
end;

procedure TfrmMCT.sbDirUpClick(Sender: TObject);
var
  lPadding : integer;
begin
  lPadding := SALVAT_DIR_INDEX_PADDING;
  edDir.Text := PaddedValueIndex(IncValue(edDir.Text),DirIndexPadding);
end;

procedure TfrmMCT.sbFromFileDownClick(Sender: TObject);
begin
  edFromFile.Text := PaddedValueIndex(IncValue(edFromFile.Text,-1),FileIndexPadding);
end;

procedure TfrmMCT.sbFromFileUpClick(Sender: TObject);
begin
  edFromFile.Text := PaddedValueIndex(IncValue(edFromFile.Text),FileIndexPadding);
end;

procedure TfrmMCT.sbToFileDownClick(Sender: TObject);
begin
  edToFile.Text := PaddedValueIndex(IncValue(edToFile.Text,-1),FileIndexPadding);
end;

procedure TfrmMCT.sbToFileUpClick(Sender: TObject);
begin
  edToFile.Text := PaddedValueIndex(IncValue(edToFile.Text),FileIndexPadding);
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

procedure TfrmMCT.SetTagType(const Value: TTagType);
begin
  if cboTipo.ItemIndex <> ord(Value) then
    cboTipo.ItemIndex := ord(Value);
end;

procedure TfrmMCT.ValuesChanged;
var
  lFirstFile, lLastFile, lDirFile : string;
  lLine1, lLine2 : string;
begin
  memExample.Clear;
  if TagType = ttSalvat then
  begin
    lDirFile := 'TMB' + PaddedValueIndex(edDir.Text,DirIndexPadding);
    lFirstFile := 'T' + PaddedValueIndex(edFromFile.Text,FileIndexPadding) + '.smp';
    lLastFile := 'T' + PaddedValueIndex(edToFile.Text,FileIndexPadding) + '.smp';
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
  end
  else
  if TagType = ttLidl then
  begin
    lFirstFile := 'L' + PaddedValueIndex(edFromFile.Text,FileIndexPadding) + '.smp';
    lLastFile := 'L' + PaddedValueIndex(edToFile.Text,FileIndexPadding) + '.smp';
    lLine1 := lFirstFile;
    if chkMultiple.Checked then
      lLine1 := lLine1 + ' - ' + lLastFile;
    memExample.Lines.Add('');
    memExample.Lines.Add(lLine1);
  end
  else
  if TagType = ttMigros then
  begin
    lFirstFile := 'M' + PaddedValueIndex(edFromFile.Text,FileIndexPadding) + '.smp';
    lLastFile := 'M' + PaddedValueIndex(edToFile.Text,FileIndexPadding) + '.smp';
    lLine1 := lFirstFile;
    if chkMultiple.Checked then
      lLine1 := lLine1 + ' - ' + lLastFile;
    memExample.Lines.Add('');
    memExample.Lines.Add(lLine1);
  end;
end;

end.
