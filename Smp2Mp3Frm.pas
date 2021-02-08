unit Smp2Mp3Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Bass, ExtCtrls, Menus, ComCtrls, Buttons, Gauges,
  Contnrs, smp2mp3Utils;

type

  TfrmSmp2MP3 = class(TForm)
    gbSingleFile: TGroupBox;
    lblSOrigen: TLabel;
    btnConvertSingle: TButton;
    gbConvertBatch: TGroupBox;
    lblBOrigen: TLabel;
    btnBatchConvert: TButton;
    rbBatchSmp2Mp3: TRadioButton;
    rbBatchMp32Smp: TRadioButton;
    tmrAudioLevel: TTimer;
    chkNormalizar: TCheckBox;
    MainMenu: TMainMenu;
    mnuConfig: TMenuItem;
    mnuChangeKey: TMenuItem;
    mnuChangelanguage: TMenuItem;
    rbSingleSmp2Mp3: TRadioButton;
    rbSingleMp32Smp: TRadioButton;
    pbAudioLevel: TProgressBar;
    btnPlay: TSpeedButton;
    btnStop: TSpeedButton;
    edFileName: TEdit;
    sbSelectFile: TSpeedButton;
    edDirName: TEdit;
    sbSelectDirectory: TSpeedButton;
    OpenDialog: TOpenDialog;
    pnlprogress: TPanel;
    mniGenerateMCT: TMenuItem;
    tbVol: TTrackBar;
    mniLanguageEng: TMenuItem;
    mniLanguageSpa: TMenuItem;
    mniLanguageOther: TMenuItem;
    N1: TMenuItem;
    procedure btnConvertSingleClick(Sender: TObject);
    procedure edFileNameChange(Sender: TObject);
    procedure rbBatchSmp2Mp3Click(Sender: TObject);
    procedure rbBatchMp32SmpClick(Sender: TObject);
    procedure btnBatchConvertClick(Sender: TObject);
    procedure btnPlayClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
    procedure tmrAudioLevelTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mnuChangeKeyClick(Sender: TObject);
    procedure sbSelectFileClick(Sender: TObject);
    procedure sbSelectDirectoryClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure mniGenerateMCTClick(Sender: TObject);
    procedure tbVolChange(Sender: TObject);
    procedure mniLanguageOtherClick(Sender: TObject);
    procedure mniLanguageEngClick(Sender: TObject);
    procedure mniLanguageSpaClick(Sender: TObject);
  private
    { Private declarations }
    FFilesFound : TStringList;
    FProgressBars : TObjectList;
    FProgressLabels : TObjectList;
    FProgressRowCount : integer;
    Language : TLanguage;
    FmniChangeKeyOther : TMenuItem;
    procedure InitKey;
    procedure ConvertSingleFile(ASourceFileName, ADestFileName : string; AEncrypt : boolean);
    function ConvertExt(AFileName : string) : string;
    procedure LoadLanguage(AFilename : string); overload;
    procedure LoadLanguage(ALanguage : TLanguage); overload;
    function ChangeLanguageFile : string;
    function NormalizeAudio(AFile: string): boolean;
    procedure ChangeCaptions;
    procedure FileFound(AFilename : string);
    procedure mniChangeKeyShortcut(Sender: TObject);
    //Functions for progressbars
    function AddProgress( AMaxValue : integer; ACaption : string = ''): integer;
    procedure DelProgress( AnIndex : integer );
    procedure IncProgress( AnIndex : integer; AnAmount : integer = 1);
    procedure SetProgress( AnIndex, AProgress : integer);
    function ProgressOf(AnIndex : integer) : integer;
    procedure SetVolume(const Value: integer);
    function GetAlgorithm: TAlgorithm;
    procedure SetAlgorithm(const Value: TAlgorithm);
    property Algorithm : TAlgorithm read GetAlgorithm write SetAlgorithm;
  public
    { Public declarations }
    procedure DoOnStopPlay;
  end;

  procedure BassFileCloseProc(user: Pointer); stdcall;
  function BassFileLenProc(user: Pointer): QWORD; stdcall;
  function BassFileReadProc(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
  function BassFileSeekProc(offset: QWORD; user: Pointer): BOOL; stdcall;
  function BassErrorToString(AnErrorCode : integer) : string;
  function ProcessByte(AByte : Byte; aByteIndex : integer; AEncrypt : boolean) : Byte;
  procedure AddHourGlassCursor;
  procedure RemoveHourGlassCursor;

var
  frmSmp2MP3: TfrmSmp2MP3;
  GlobalAlgorithm: TAlgorithm;
  PlayerKeyIndex : integer;
  GSourceFile : TFileStream;
  Player: HSTREAM;
  gHourGlassLevel : Integer = 0;
  gLastCursor : TCursor;



implementation

uses
  StrUtils, Math, IniFiles, KeyFrm, FileCtrl, mctFrm;

{$R *.dfm}

procedure EndSyncProc(hSync: Thandle; hChan: DWORD; data: DWORD; MyObject: Pointer); stdcall;
//Call audio stop actions when audio reaches end of file
var
  lForm : TfrmSmp2MP3;
begin
  lForm := TfrmSmp2MP3(MyObject);
  lForm.DoOnStopPlay;
end;


procedure AddHourGlassCursor;
begin
  inc(gHourGlassLevel);
  if gHourGlassLevel = 1 then
    gLastCursor := Screen.Cursor;
  Screen.Cursor := crHourGlass;
end;

procedure RemoveHourGlassCursor;
begin
  dec(gHourGlassLevel);
  if gHourGlassLevel <= 0 then
  begin
    gHourGlassLevel := 0;
    Screen.Cursor := gLastCursor;
  end;
end;

function BassErrorToString(AnErrorCode : integer) : string;
// Error codes returned by BASS_ErrorGetCode()
begin
  case AnErrorCode of
    BASS_OK                 : result := 'all is OK';
    BASS_ERROR_MEM          : result := 'memory error';
    BASS_ERROR_FILEOPEN     : result := 'can''t open the file';
    BASS_ERROR_DRIVER       : result := 'can''t find a free sound driver';
    BASS_ERROR_BUFLOST      : result := 'the sample buffer was lost';
    BASS_ERROR_HANDLE       : result := 'invalid handle';
    BASS_ERROR_FORMAT       : result := 'unsupported sample format';
    BASS_ERROR_POSITION     : result := 'invalid position';
    BASS_ERROR_INIT         : result := 'BASS_Init has not been successfully called';
    BASS_ERROR_START        : result := 'BASS_Start has not been successfully called';
    BASS_ERROR_ALREADY      : result := 'already initialized/paused/whatever';
    BASS_ERROR_NOCHAN       : result := 'can''t get a free channel';
    BASS_ERROR_ILLTYPE      : result := 'an illegal type was specified';
    BASS_ERROR_ILLPARAM     : result := 'an illegal parameter was specified';
    BASS_ERROR_NO3D         : result := 'no 3D support';
    BASS_ERROR_NOEAX        : result := 'no EAX support';
    BASS_ERROR_DEVICE       : result := 'illegal device number';
    BASS_ERROR_NOPLAY       : result := 'not playing';
    BASS_ERROR_FREQ         : result := 'illegal sample rate';
    BASS_ERROR_NOTFILE      : result := 'the stream is not a file stream';
    BASS_ERROR_NOHW         : result := 'no hardware voices available';
    BASS_ERROR_EMPTY        : result := 'the MOD music has no sequence data';
    BASS_ERROR_NONET        : result := 'no internet connection could be opened';
    BASS_ERROR_CREATE       : result := 'couldn''t create the file';
    BASS_ERROR_NOFX         : result := 'effects are not available';
    BASS_ERROR_NOTAVAIL     : result := 'requested data is not available';
    BASS_ERROR_DECODE       : result := 'the channel is/isn''t a "decoding channel"';
    BASS_ERROR_DX           : result := 'a sufficient DirectX version is not installed';
    BASS_ERROR_TIMEOUT      : result := 'connection timedout';
    BASS_ERROR_FILEFORM     : result := 'unsupported file format';
    BASS_ERROR_SPEAKER      : result := 'unavailable speaker';
    BASS_ERROR_VERSION      : result := 'invalid BASS version (used by add-ons)';
    BASS_ERROR_CODEC        : result := 'codec is not available/supported';
    BASS_ERROR_ENDED        : result := 'the channel/file has ended';
    BASS_ERROR_BUSY         : result := 'the device is busy';
    BASS_ERROR_UNKNOWN      : result := 'some other mystery problem';
  else
    result := 'Unknown';
  end;

end;

function ProcessByte(AByte : Byte; aByteIndex : integer; AEncrypt : boolean) : Byte;
//Encode/Decodes a Byte
  //**************************************************************************//
  function lROR(AValue : Byte; N : integer) : Byte;
  //Rotate bits right N times
  begin
     Result := (AValue shr N) or (AValue shl ((SizeOf(AValue)*8)-n));
  end;
  //**************************************************************************//
  function lROL(AValue : Byte; N : integer) : Byte;
  //Rotate bits left N times
  begin
    Result := (AValue shl N) or (AValue shr ((SizeOf(AValue)*8)-n));
  end;
  //**************************************************************************//
  function lRotateByte(AValue : Byte; ARotateDirection : TRotateDirection; ACount : integer) : Byte;
  //Rotate byte
  begin
    result := AValue;
    if ARotateDirection = rdNone then
      result := AValue
    else if ARotateDirection = rdRight then
      result := lROR(AValue,ACount)
    else if ARotateDirection = rdLeft then
      result := lROL(AValue,ACount);
  end;
  //**************************************************************************//
var
  lXORKeyLength : integer;
  lXORKeyIndex : integer;
  i : integer;
  lOperations : TAlgorithmOperationArray;
begin
  result := AByte;
  if AEncrypt then
    lOperations := GlobalAlgorithm.Operations
  else  //if is decrypting, operations must be inverted
    lOperations := InvertOperations(GlobalAlgorithm.Operations);

  for i := 0 to Length(lOperations) - 1 do
  begin
    if lOperations[i].OperationType = otXOR then
    begin //XOR
      lXORKeyLength := length(lOperations[i].XorKey);
      if lXORKeyLength > 0 then //if length of XOR key = 0, do nothing
      begin
        lXORKeyIndex := aByteIndex mod lXORKeyLength;
        result := result xor lOperations[i].XorKey[lXORKeyIndex];
      end;
    end
    else if lOperations[i].OperationType = otRotate then
    begin //Rotate Byte
      result := lRotateByte(result,lOperations[i].RotateDirection,lOperations[i].RotateCount);
    end;
  end;
end;


procedure BassFileCloseProc(user: Pointer); stdcall;
//Bass callback to close encrypted file
begin
  GSourceFile.Free;
end;

function BassFileLenProc(user: Pointer): QWORD; stdcall;
//Bass callback to get encrypted file size
begin
  result := GSourceFile.Size;
end;

function BassFileReadProc(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
//Bass callback to read encrypted file
var
  lBuffer : array [0 .. 1023] of byte;
  lDecodedBuffer : array [0 .. 1023] of Byte;
  i : integer;
begin
  //reads a maximum of 1024 bytes and stores them in a buffer
  result := GSourceFile.Read(lBuffer, min(1024,length));
  //iterates the buffer applying the encryption/decryption to each byte and stoes it in DecodedBuffer
  for i := 0 to result - 1 do
  begin
    lDecodedBuffer[i] := ProcessByte(lBuffer[i],PlayerKeyIndex,False);
    inc(PlayerKeyIndex);
  end;
  //Saves decoded buffer to function result
  move(lDecodedBuffer,buffer^,result);
end;

function BassFileSeekProc(offset: QWORD; user: Pointer): BOOL; stdcall;
//Bass callback to change position in encrypted file
begin
  result := true;
  GSourceFile.Position := offset;
  //sets PlayerKeyIndex to the right value according to the new position
  PlayerKeyIndex := offset;
end;


function TfrmSmp2MP3.AddProgress(AMaxValue: integer; ACaption: string): integer;
//adds a progressbar to the progressbars panel and shows panel if necessary
const
  TOP_MARGIN = 8;
  BOTTOM_MARGIN = 16;
  LEFT_MARGIN = 16;
  RIGHT_MARGIN = 16;
  ROW_HEIGHT = 40;
  LABEL_HEIGHT = 15;
  MAX_BARS = 3;
var
  lProgressBar : TGauge;
  lLabel : TLabel;
  lClientHeight : integer;
  lControlsHeight : integer;
begin
  Assert( AMaxValue >= 0);

  result := FProgressRowCount;
  inc(FProgressRowCount);

  // show only a defined amout of bars
  if FProgressBars.Count >= MAX_BARS then
    exit;

  pnlprogress.BringToFront;
  lProgressBar := TGauge.Create(pnlprogress);
  with lProgressBar do
  begin
    height := 16;
    ForeColor := clNavy;
    Top := TOP_MARGIN + ( ROW_HEIGHT * FProgressBars.Count ) + LABEL_HEIGHT;
    left := LEFT_MARGIN;
    Width := pnlprogress.Width - LEFT_MARGIN - RIGHT_MARGIN;
    MaxValue := AMaxValue;
    Parent := pnlprogress;
    Anchors := [akTop,akLeft,akRight];
  end;
  FProgressBars.Add( lProgressBar );

  lLabel := TLabel.Create(pnlprogress);
  with lLabel do
  begin
    Top := TOP_MARGIN + ( ROW_HEIGHT * FProgressLabels.Count );
    left := LEFT_MARGIN;
    Caption := ACaption;
    Parent := pnlprogress;
  end;

//  if (lLabel.Width + LEFT_MARGIN + RIGHT_MARGIN) > ClientWidth then
//  begin
//    ClientWidth := MIN(lLabel.Width + LEFT_MARGIN + RIGHT_MARGIN,Screen.Width);
//    Left := (Screen.Width - ClientWidth) div 2;
//  end;

  FProgressLabels.Add( lLabel );

  lClientHeight := pnlprogress.ClientHeight;
  lControlsHeight := TOP_MARGIN + ( ROW_HEIGHT * FProgressBars.Count ) + BOTTOM_MARGIN;
  pnlprogress.ClientHeight := Max( lClientHeight, lControlsHeight);
  pnlprogress.Top := (ClientHeight - pnlprogress.ClientHeight) div 2;
  pnlprogress.Visible := true;;

  if result = 0 then
    Application.ProcessMessages;
end;

procedure TfrmSmp2MP3.btnBatchConvertClick(Sender: TObject);
//Convert all files in a directory
var
  lSourceDir : string;
  lDestDir : string;
  lSourceExt : string;
  i: Integer;
  lDestFileName : string;
  lp : integer;
begin
  Enabled := false;
  AddHourGlassCursor;
  try
    lSourceDir := edDirname.Text;
    if RightStr(lSourceDir,1) <> '\' then
      lSourceDir := lSourceDir + '\';
    if not DirectoryExists(lSourceDir) then
    begin
      MessageDlg(Language.MESSAGES_SOURCE_DIR_NOT_FOUND, mtError, [mbOK], 0);
      exit;
    end;
    if not (rbBatchSmp2Mp3.Checked or rbBatchMp32Smp.Checked) then
    begin
      MessageDlg(Language.MESSAGES_CONVERTION_TYPE_NOT_SELECTED, mtError, [mbOK], 0);
      exit;
    end;
    //select destination directory
    lDestDir := lSourceDir;
    if not SelectDirectory(Language.CAPTION_SAVE_TO,'', lDestDir,[sdNewFolder],nil) then
      Exit;
    if RightStr(lDestDir,1) <> '\' then
      lDestDir := lDestDir + '\';

    if (UpperCase(Algorithm.SourceExt) = UpperCase(Algorithm.DestExt)) and (uppercase(lSourceDir) = UpperCase(lDestDir)) then
    begin
      MessageDlg('Source and destination directories are the same.', mtError, [mbOK], 0);
      exit;
    end;


    if rbBatchMp32Smp.Checked then
      lSourceExt := Algorithm.SourceExt
    else
      lSourceExt := Algorithm.DestExt;


    if (MessageDlg(Format(Language.MESSAGES_REPLACE_FILES_WARNING,[ConvertExt(lSourceExt)]), mtWarning, [mbYes, mbNo], 0) in [mrNo, mrNone]) then
      exit;

    FFilesFound := TStringList.Create;
    try
      //get files list (to be able to show a files progress bar)
      FindFiles(lSourceDir,lSourceExt,FileFound);
      if FFilesFound.Count = 0 then
      begin
        MessageDlg(Format(Language.MESSAGES_FILES_OF_TYPE_NOT_FOUND,[lSourceExt]), mtError, [mbOK], 0);
        exit;
      end;
      lp := AddProgress(FFilesFound.Count,Language.CAPTION_PROCESSING + '...');
      try
        //Iterate through files list and process each file
        for i := 0 to FFilesFound.Count - 1 do
        begin
          lDestFileName := lDestDir + ChangeFileExt(ExtractFileName(FFilesFound[i]),ConvertExt(FFilesFound[i]));
          ConvertSingleFile(FFilesFound[i],lDestFileName, rbBatchMp32Smp.Checked);
          IncProgress(lp);
        end;
      finally
        DelProgress(lp);
      end;
    finally
      FFilesFound.Free;
    end;
    MessageDlg(Language.MESSAGES_CONVERSION_ENDED, mtInformation, [mbOK], 0);
  finally
    RemoveHourGlassCursor;
    Enabled := true;
  end;
end;

procedure TfrmSmp2MP3.btnConvertSingleClick(Sender: TObject);
//Convert one file
var
  lDestExt: string;
  lSourceFileName, lDestFileName: string;
  lEncrypt : boolean;
begin
  Enabled := false;
  try
    lSourceFileName := edFileName.Text;
    if not FileExists(lSourceFileName) then
    begin
      MessageDlg(Language.MESSAGES_SELECTED_FILE_DONT_EXISTS, mtError, [mbOK], 0);
      exit;
    end;

    lDestExt := ConvertExt(lSourceFileName);
    //Ask for new file name
    lDestFileName := ExtractFileName(ChangeFileExt(lSourceFileName,lDestExt));
    if not PromptForFileName(lDestFileName,'',lDestExt,Format(Language.MESSAGES_CONVERT_TO,[lDestExt]),'',true) then
      exit;

    if FileExists(lDestFileName) then
    begin
      if (MessageDlg(Language.MESSAGES_OVERWRITE_PROMPT, mtWarning, [mbYes, mbNo], 0) in [mrNo, mrNone]) then
        exit;
    end;
    //Call conversion procedure
    btnPlay.Enabled := false;
    try
      if uppercase(Algorithm.SourceExt) <> uppercase(Algorithm.DestExt) then
        lEncrypt := uppercase(ExtractFileExt(lSourceFileName)) = uppercase(Algorithm.SourceExt)
      else
        lEncrypt := rbSingleMp32Smp.Checked;
      ConvertSingleFile(lSourceFileName,lDestFileName, lEncrypt);
    finally
      btnPlay.Enabled := true;
    end;
  finally
    Enabled := true;
  end;
end;

procedure TfrmSmp2MP3.ChangeCaptions;
//change component captions according to current languge and values.
var
  lDestExt : string;
begin
  caption := Language.frmSmp2Mp3_caption + ' v' + VersionString;

  mnuConfig.Caption := Language.mnuConfig_caption;
  mnuChangeKey.Caption := Language.mnuChangeKey_caption;
  mnuChangelanguage.Caption := Language.mnuChangelanguage_caption;
  mniGenerateMCT.Caption := Language.mniGenerateMCT_caption;
  if assigned(FmniChangeKeyOther) then
    FmniChangeKeyOther.Caption :=Language.mnuChangeKey_other_caption;
  mniLanguageOther.Caption :=Language.mnuChangeKey_other_caption;

  if Algorithm.Name <> '' then
  begin
    gbSingleFile.Caption := Language.gbSingleFile_caption + ' (' + ExtractFileName(Algorithm.Name) + ')';
    gbConvertBatch.Caption := Language.gbConvertBatch_caption + ' (' + ExtractFileName(Algorithm.Name) + ')';
  end
  else
  begin
    gbSingleFile.Caption := Language.gbSingleFile_caption;
    gbConvertBatch.Caption := Language.gbConvertBatch_caption;
  end;
  lblSOrigen.Caption := Language.lblSOrigen_caption;
  if lDestExt <> '' then
    btnConvertSingle.Caption := Format(Language.MESSAGES_CONVERT_TO,[lDestExt])
  else
    btnConvertSingle.Caption := Language.MESSAGES_CONVERT;
  rbSingleSmp2Mp3.Visible := AlgorithmHasRotation(Algorithm);
  rbSingleMp32Smp.Visible := AlgorithmHasRotation(Algorithm);
  lblBOrigen.Caption := Language.lblBOrigen_caption;
  rbBatchMp32Smp.Caption := Language.CAPTION_ENCRYPT + '(' + Algorithm.SourceExt + ' -> ' + Algorithm.DestExt + ')';
  rbBatchSmp2Mp3.Caption := Language.CAPTION_DECRYPT + '(' + Algorithm.DestExt + ' -> ' + Algorithm.SourceExt + ')';
  rbSingleMp32Smp.Caption := Language.CAPTION_ENCRYPT + '(' + Algorithm.SourceExt + ' -> ' + Algorithm.DestExt + ')';
  rbSingleSmp2Mp3.Caption := Language.CAPTION_DECRYPT + '(' + Algorithm.DestExt + ' -> ' + Algorithm.SourceExt + ')';
  btnBatchConvert.Caption := Language.btnBatchConvert_caption;

  lDestExt := ConvertExt(edFileName.Text);

  chkNormalizar.Enabled := uppercase(Algorithm.SourceExt) <> uppercase(Algorithm.DestExt);
  if chkNormalizar.Enabled then
  begin
    if lDestExt = '.mp3' then
      chkNormalizar.Caption := Language.CAPTION_NORMALIZE_AFTER
    else
      chkNormalizar.Caption := Language.CAPTION_NORMALIZE_BEFORE;
  end
  else
    chkNormalizar.Caption := Language.chkNormalizar_caption;
end;

function TfrmSmp2MP3.ChangeLanguageFile : string;
//asks for langujage file and loads it.
begin
  result := '';
  if Language.mnuChangelanguage_caption <> '' then
    OpenDialog.Title := Language.mnuChangelanguage_caption
  else
    OpenDialog.Title := 'Select language file';
  OpenDialog.Filter := '*.lan|*.lan';
  OpenDialog.InitialDir := LanguagesPath;
  OpenDialog.FileName := 'eng.lan';
  if OpenDialog.Execute(Handle) then
  begin
    if FileExists(OpenDialog.FileName) then
      result := OpenDialog.FileName
    else
      exit;
    with TIniFile.Create(IniFileName) do
    try
      WriteString('LANGUAGE','FILE',result);
    finally
      free;
    end;
    LoadLanguage(result);
    result := result;
  end;
end;

function TfrmSmp2MP3.ConvertExt(AFileName: string): string;
//Destination extension according to source filename
var
  lSourceExt : string;
begin
  lSourceExt := UpperCase(ExtractFileExt(AFileName));

  if uppercase(Algorithm.SourceExt) <> uppercase(Algorithm.DestExt) then
  begin
    if lSourceExt = uppercase(Algorithm.SourceExt) then
      Result := Algorithm.DestExt
    else if lSourceExt = uppercase(Algorithm.DestExt) then
      Result := Algorithm.SourceExt
    else
      Result := '';
  end
  else
    result := lSourceExt;
end;

procedure TfrmSmp2MP3.ConvertSingleFile(ASourceFileName, ADestFileName: string; AEncrypt : boolean);
//Encrypts/Decrypts a single file
const
  BUFFER_MAX = 1023;
var
  lSourceFile, lDestFile: TFileStream;
  lBuffer, lDecodedBuffer : array [0 .. BUFFER_MAX] of byte;
  lReadBytes : integer;
  i : integer;
  lKeyIndex : integer;
  lp : integer;
begin
  if uppercase(ASourceFileName) = UpperCase(ADestFileName) then
  begin
    MessageDlg('Source and destination filename are the same.', mtError, [mbOK], 0);
    exit;
  end;
  AddHourGlassCursor;
  try
    //If it must normalize before encrypting
    if chkNormalizar.Checked and (UpperCase(ExtractFileExt(ASourceFileName)) = '.MP3') then
      NormalizeAudio(ASourceFileName);
    lKeyIndex := 0;
    //create file streams
    lSourceFile := TFileStream.Create(ASourceFileName, fmOpenRead);
    lDestFile := TFileStream.Create(ADestFileName, fmCreate);
    try
      lp := AddProgress(ceil(lSourceFile.Size/(BUFFER_MAX + 1)),Language.CAPTION_PROCESSING + ' ' + ExtractFileName(ASourceFileName) + '...');
      try
        while lSourceFile.Position < lSourceFile.Size do    //read while the end of file has not being reached
        begin
          //read source file in 1024 Byte chunks
          lReadBytes := lSourceFile.Read(lBuffer, (BUFFER_MAX + 1));
          //Encrypt/Decrypt all bytes read all by
          for i := 0 to lReadBytes - 1 do
          begin
            lDecodedBuffer[i] := ProcessByte(lBuffer[i],lKeyIndex,AEncrypt);
            inc(lKeyIndex);
          end;
          //Write decoded chunk
          lDestFile.Write(lDecodedBuffer,lReadBytes);
          IncProgress(lp);
        end;
      finally
        DelProgress(lp);
      end;
    finally
      //free filestreams
      lDestFile.Free;
      lSourceFile.Free;
    end;
    //If it must normalize after decrypting
    if chkNormalizar.Checked and (UpperCase(ExtractFileExt(ADestFileName)) = '.MP3') then
      NormalizeAudio(ADestFileName);
  finally
    RemoveHourGlassCursor;
  end;
end;

procedure TfrmSmp2MP3.DelProgress(AnIndex: integer);
begin
  // Deletes progres in AnIndex and all below
  While FProgressBars.Count >= AnIndex + 1 do
  begin
    FProgressBars.Delete( FProgressBars.Count -1 );
    FProgressLabels.Delete( FProgressLabels.Count -1 );
    Application.ProcessMessages;
  end;
  FProgressRowCount := AnIndex;
  if FProgressRowCount = 0 then
  begin
    pnlprogress.Visible := false;
    pnlProgress.ClientHeight := 10;
  end;
end;

procedure TfrmSmp2MP3.DoOnStopPlay;
//Actions to do when reproduction stops
begin
  BASS_StreamFree(Player);
  btnConvertSingle.Enabled := true;
  Player := 0;
end;

procedure TfrmSmp2MP3.edFileNameChange(Sender: TObject);
//change button caption when the filename changes
begin
  ChangeCaptions;
end;

procedure TfrmSmp2MP3.FileFound(AFilename: string);
begin
  FFilesFound.Add(AFilename);
end;

procedure TfrmSmp2MP3.FormCreate(Sender: TObject);
//Initialize program
var
  lDevice : integer;
  lLanguageFile : string;
  lMenuItem : TMenuItem;
begin
  ForceDirectories(LanguagesPath);
  ForceDirectories(KeysPath);
  Player := 0;
  lLanguageFile := '';
  LoadLanguage(InitLanguageEng);
  if not FileExists(LanguagesPath + 'spa.lan') then
    WriteLanguageToFile(LanguagesPath + 'spa.lan', InitLanguageSpa);
  if not FileExists(LanguagesPath + 'eng.lan') then
    WriteLanguageToFile(LanguagesPath + 'eng.lan', InitLanguageEng);
  chkNormalizar.Visible := FileExists(ExtractFilePath(Application.ExeName) + 'mp3gain.exe');
  with TIniFile.Create(IniFileName) do
  try
    if not ValueExists('AUDIO','DEVICE') then
      WriteInteger('AUDIO','DEVICE',-1);
    lDevice := ReadInteger('AUDIO','DEVICE',-1);
    if ValueExists('LANGUAGE','FILE') then
      lLanguageFile := ReadString('LANGUAGE','FILE','spa.lan');
  finally
    free;
  end;
  BASS_Init(lDevice,44100,0,Handle, nil);
  if FileExists(lLanguageFile) then
    LoadLanguage(lLanguageFile)
  else
    ChangeLanguageFile;
  InitKey;
  FProgressBars := TObjectList.Create;
  FProgressLabels := TObjectList.Create;
  FProgressRowCount := 0;
  //add encryption Key shortcuts
  AddFilesToMenuItem(KeysPath,'.key',mnuChangeKey,mniChangeKeyShortcut);
  lMenuItem := TMenuItem.Create(mnuChangeKey);
  lMenuItem.Caption := '-';;
  mnuChangeKey.Add(lMenuItem);
  FmniChangeKeyOther := TMenuItem.Create(mnuChangeKey);
  FmniChangeKeyOther.Caption := Language.mnuChangeKey_other_caption;
  FmniChangeKeyOther.OnClick := mnuChangeKeyClick;
  mnuChangeKey.Add(FmniChangeKeyOther);
end;

procedure TfrmSmp2MP3.FormDestroy(Sender: TObject);
begin
  FProgressBars.Free;
  FProgressLabels.Free;
end;

function TfrmSmp2MP3.GetAlgorithm: TAlgorithm;
begin
  result := GlobalAlgorithm;
end;

procedure TfrmSmp2MP3.IncProgress(AnIndex, AnAmount: integer);
var
  lProgress : TGauge;
begin
  // IF index is higher that bars shown
  if AnIndex >= FProgressBars.Count then
    exit;

  // Inc progressbar.
  lProgress := (FProgressBars[AnIndex] as TGauge);

  lProgress.Progress := lProgress.Progress + AnAmount;
  Application.ProcessMessages;
end;

procedure TfrmSmp2MP3.InitKey;
  //**************************************************************************//
  //Initialize the GlobalAlgorithm to Encrypt/decrypt smp files with the "audiocuentos" format.
  function lDefaultAlgorithm : TAlgorithm;
  begin
    Result.Name := 'Audiocuentos';
    Result.SourceExt := '.mp3';
    Result.DestExt := '.smp';
    SetLength(result.Operations,0);
    AddOperationToAlgorithm(result, otXOR, CommaTextToXorKey('0x51,0x23,0x98,0x56'), rdNone, 0);
  end;
  //**************************************************************************//
var
  lSectionExists : boolean;
  lAlgorithmFilename : string;
begin
  lAlgorithmFilename := IniFileName;
  with TIniFile.Create(lAlgorithmFilename) do
  try
    lSectionExists := SectionExists('ALGORITHM');
  finally
    Free;
  end;

  if lSectionExists then
    Algorithm := LoadKeyFromFile(lAlgorithmFilename)
  else
  begin
    OpenDialog.Title := Language.mnuChangeKey_caption;
    OpenDialog.Filter := '*.key|*.key';
    OpenDialog.InitialDir := KeysPath;
    OpenDialog.FileName := '';
    if OpenDialog.Execute(Handle) then
    begin
      if FileExists(OpenDialog.FileName) then
        Algorithm := LoadKeyFromFile(OpenDialog.FileName)
      else
        Algorithm := lDefaultAlgorithm;
    end
    else
      Algorithm := lDefaultAlgorithm;
    SaveKeyToFile(lAlgorithmFilename,Algorithm);
  end;

  PlayerKeyIndex := 0;

  ChangeCaptions;
end;

procedure TfrmSmp2MP3.LoadLanguage(ALanguage: TLanguage);
begin
  Language := ALanguage;
  ChangeCaptions;
end;

procedure TfrmSmp2MP3.LoadLanguage(AFilename: string);
//Load language from file and apply values
begin
  LoadLanguage(LoadLanguageFromFile(AFilename));
end;

procedure TfrmSmp2MP3.mniChangeKeyShortcut(Sender: TObject);
begin
  Algorithm := FindAndLoadKey((TMenuItem(Sender).Caption));
  SaveKeyToFile(IniFileName,Algorithm);
  ChangeCaptions;
end;

procedure TfrmSmp2MP3.mniGenerateMCTClick(Sender: TObject);
begin
  with TfrmMCT.Create(nil) do
  try
    Language := self.Language;
    ShowModal;
  finally
    Free;
  end;
end;

procedure TfrmSmp2MP3.mniLanguageEngClick(Sender: TObject);
begin
  LoadLanguage(InitLanguageEng);
  with TIniFile.Create(IniFileName) do
  try
    WriteString('LANGUAGE','FILE',ExtractFilePath(Application.ExeName) + 'Languages\eng.lan');
  finally
    free;
  end;
end;

procedure TfrmSmp2MP3.mniLanguageOtherClick(Sender: TObject);
begin
  ChangeLanguageFile;
end;

procedure TfrmSmp2MP3.mniLanguageSpaClick(Sender: TObject);
begin
  LoadLanguage(InitLanguageSpa);
  with TIniFile.Create(IniFileName) do
  try
    WriteString('LANGUAGE','FILE',ExtractFilePath(Application.ExeName) + 'Languages\spa.lan');
  finally
    free;
  end;
end;

procedure TfrmSmp2MP3.mnuChangeKeyClick(Sender: TObject);
//Show form to change encryption keys
begin
  with TfrmKey.Create(nil) do
  try
    Language := self.Language;
    Algorithm := self.Algorithm;
    if ShowModal = mrOk then
    begin
      self.Algorithm := Algorithm;
      SaveKeyToFile(IniFileName,Algorithm);
      ChangeCaptions;
    end;
  finally
    Free;
  end;
end;

function TfrmSmp2MP3.NormalizeAudio(AFile: string): boolean;
//Normalize audio file
  //****************************************************************************//
  function GetDosOutput(const CommandLine: string): string;
  //Execute a program from command line
  var
    SA: TSecurityAttributes;
    SI: TStartupInfo;
    PI: TProcessInformation;
    StdOutPipeRead, StdOutPipeWrite: THandle;
    WasOK: Boolean;
    Buffer: array[0..255] of Char;
    BytesRead: Cardinal;
    WorkDir, Line: String;
    i : integer;
    lp : integer;
  begin
    with SA do
    begin
      nLength := SizeOf(SA);
      bInheritHandle := True;
      lpSecurityDescriptor := nil;
    end;
    lp := AddProgress(100,Language.CAPTION_NORMALIZING + ' ' + ExtractFileName(AFile) + '...');
    // create pipe for standard output redirection
    CreatePipe(StdOutPipeRead,  // read handle
               StdOutPipeWrite, // write handle
               @SA,             // security attributes
               0                // number of bytes reserved for pipe - 0 default
               );
    try
      // Make child process use StdOutPipeWrite as standard out,
      // and make sure it does not show on screen.
      with SI do
      begin
        FillChar(SI, SizeOf(SI), 0);
        cb := SizeOf(SI);
        dwFlags := STARTF_USESHOWWINDOW or STARTF_USESTDHANDLES;
        wShowWindow := SW_HIDE;
        hStdInput := GetStdHandle(STD_INPUT_HANDLE); // don't redirect stdinput
        hStdOutput := StdOutPipeWrite;
        hStdError := StdOutPipeWrite;
      end;

      //WorkDir := 'C:\'; //if you want
      WorkDir := '';
      WasOK := CreateProcess(nil, PChar(CommandLine), nil, nil, True, 0, nil, nil, SI, PI);
      // Now that the handle has been inherited, close write to be safe.
      // We don't want to read or write to it accidentally.
      CloseHandle(StdOutPipeWrite);
      // if process could be created then handle its output
      if not WasOK then
        raise Exception.Create('Could not execute command line!')
      else
        try
          // get all output until dos app finishes
          Line := '';
          repeat
            // read block of characters (might contain carriage returns and line feeds)
            WasOK := ReadFile(StdOutPipeRead, Buffer, 255, BytesRead, nil);
            // has anything been read?
            if BytesRead > 0 then
            begin
              // finish buffer to PChar
              Line := Copy(Buffer,0,BytesRead);
              Buffer[BytesRead] := #0;
              i := Pos('%',Line);
              if i > 0 then
              begin
                Line := Trim(MidStr(Line,i-3,3));
                if StrToInt(Line) > ProgressOf(lp) then
                  SetProgress(lp,StrToInt(Line));
              end;
            end;
            Application.ProcessMessages;
          until not WasOK or (BytesRead = 0);
          // wait for console app to finish (should be already at this point)
          WaitForSingleObject(PI.hProcess, INFINITE);
        finally
          // Close all remaining handles
          CloseHandle(PI.hThread);
          CloseHandle(PI.hProcess);
        end;
    finally
      DelProgress(lp);
      result:=Line;
      CloseHandle(StdOutPipeRead);
    end;
  end;
  //****************************************************************************//
var
  lAudioExt : string;
  lAttrs    : Integer;
  lQuotedFile : string;
begin
  lQuotedFile := AFile;
  Result := False;
  try
    if FileExists(AFile) then
    begin
      //Revisa que el archivo no sea de solo lectura
      lAttrs := FileGetAttr(AFile);
      if lAttrs and faReadOnly > 0 then
      begin
        MessageDlg(AFile + ' is read only.', mtError, [mbOK], 0);
        result := false
      end
      else
      begin
        lAudioExt := UpperCase(ExtractFileExt(AFile));
        lQuotedFile := '"' + AFile + '"';
        if lAudioExt = '.MP3' then
        begin
          if FileExists(ExtractFilePath(Application.ExeName) + 'mp3gain.exe') then
          begin
            GetDosOutput('mp3gain.exe /r /c ' + lQuotedFile);
            result := True;
          end
          else
            MessageDlg('File not found: mp3gain.exe', mtError, [mbOK], 0);
        end;
      end;
    end
    else
      result := false; //File not found
  except
    result := false; //Other error
  end;
end;

function TfrmSmp2MP3.ProgressOf(AnIndex: integer): integer;
var
  lProgress : TGauge;
begin
  result := 0;
  // If there are less progress than index
  if AnIndex >= FProgressBars.Count then
    exit;

  // Set progress
  lProgress := (FProgressBars[AnIndex] as TGauge);

  result := lProgress.Progress;
end;

procedure TfrmSmp2MP3.btnPlayClick(Sender: TObject);
//Play file
var
  lprocs : BASS_FILEPROCS;
  lUser : integer;
begin
  lUser := 0;
  PlayerKeyIndex := 0;
  Player := 0;
  //If file is not encrypted play normally, else use callback
  if UpperCase(ExtractFileExt(edFileName.Text)) = '.MP3' then
    Player := BASS_StreamCreateFile(False,PChar(edFileName.Text),0,0,0)
  else
  begin
    GSourceFile := TFileStream.Create(edFileName.Text, fmOpenRead);
    lprocs.close := BassFileCloseProc;
    lprocs.length := BassFileLenProc;
    lprocs.read := BassFileReadProc;
    lprocs.seek := BassFileSeekProc;
    Player := BASS_StreamCreateFileUser(STREAMFILE_BUFFER,0,lprocs,pointer(lUser));
  end;
  btnConvertSingle.Enabled := false;
  if Player = 0 then
    ShowMessage(format(Language.MESSAGES_COULD_NOT_CREATE_STREAM,[BassErrorToString(BASS_ErrorGetCode)]))
  else
  begin
    BASS_ChannelSetSync(Player, BASS_SYNC_END, 0, EndSyncProc , Self);
    SetVolume(100 - tbVol.Position);
    if not BASS_ChannelPlay(Player, true) then
      ShowMessage(format(Language.MESSAGES_COULD_NOT_PLAY_FILE,[BassErrorToString(BASS_ErrorGetCode)]))
  end;
end;

procedure TfrmSmp2MP3.btnStopClick(Sender: TObject);
//Stop playing file
begin
  BASS_ChannelStop(Player);
  DoOnStopPlay;
end;

procedure TfrmSmp2MP3.rbBatchMp32SmpClick(Sender: TObject);
begin
  ChangeCaptions;
end;

procedure TfrmSmp2MP3.rbBatchSmp2Mp3Click(Sender: TObject);
begin
  ChangeCaptions;
end;

procedure TfrmSmp2MP3.sbSelectFileClick(Sender: TObject);
begin
  OpenDialog.Filter := '*' + Algorithm.SourceExt + ';*' + Algorithm.DestExt + '|*' + Algorithm.SourceExt + ';*' + Algorithm.DestExt + '';
  OpenDialog.InitialDir := '';
  OpenDialog.FileName := '';
  if OpenDialog.Execute(Handle) then
  begin
    if FileExists(OpenDialog.FileName) then
      edFileName.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmSmp2MP3.SetAlgorithm(const Value: TAlgorithm);
begin
  GlobalAlgorithm := Value;
  btnPlay.Enabled := uppercase(Value.SourceExt) = '.MP3';  
end;

procedure TfrmSmp2MP3.SetProgress(AnIndex, AProgress: integer);
var
  lProgress : TGauge;
begin
  // If there are less progress than index
  if AnIndex >= FProgressBars.Count then
    exit;

  // Set progress
  lProgress := (FProgressBars[AnIndex] as TGauge);

  lProgress.Progress := AProgress;
  Application.ProcessMessages;
end;

procedure TfrmSmp2MP3.SetVolume(const Value: integer);
var
  lVol : integer;
begin
  if player = 0 then
    exit;
  if Value > 90 then
    lVol := 90
  else if Value < 0 then
    lVol := 0
  else
    lVol := Value;

//  if lVol <> 0 then
//    lVol := round(20 * Log10(lVol / 32768)) + 90;

  if player <> 0 then
    BASS_ChannelSetAttribute(Player,BASS_ATTRIB_VOL,lVol / 90);

end;

procedure TfrmSmp2MP3.sbSelectDirectoryClick(Sender: TObject);
var
  lDirectory : string;
begin
  lDirectory := '';
  if SelectDirectory(Language.CAPTION_SELECT_DIR,'', lDirectory,[],nil) then
    edDirName.Text := lDirectory;
end;

procedure TfrmSmp2MP3.tbVolChange(Sender: TObject);
begin
  SetVolume(100 - tbVol.Position);
end;

procedure TfrmSmp2MP3.tmrAudioLevelTimer(Sender: TObject);
//Check audio level and update display
var
  lLevels : Int64;
  lLevelRight : Word;
  lRightdB : Shortint;
begin
  btnPlay.Enabled := (Player = 0) or (not BASS_ChannelIsActive(Player) = BASS_ACTIVE_PLAYING);
  btnStop.Enabled := not btnPlay.Enabled;

  if Player > 0 then
  begin
    lLevels := BASS_ChannelGetLevel(Player);
    if lLevels >= 0 then
      lLevelRight := HIWORD(lLevels)
    else
      lLevelRight := 0;
  end
  else
  begin
    lLevelRight := 0;
  end;

  //Get the logaritmic value for an adecuate representation
  if lLevelRight = 0 then
    lRightdB := 0
  else
    lRightdB :=  round(20 * Log10(lLevelRight / 32768)) + 90;

  //Actualiza los niveles de audio de los RLeds independientes
  try
    pbAudioLevel.Position := trunc(lRightdB * ((100 - tbVol.Position) / 100));
  except
  end;
end;

end.
