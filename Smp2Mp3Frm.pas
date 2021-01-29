unit Smp2Mp3Frm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Mask, Bass, ExtCtrls, Menus, ComCtrls, Buttons, Gauges,
  Contnrs;

type

  TRotateDirection = (rdNone, rdRight, rdLeft);
  TRotateTime = (rtBeforeXOR, rtAfterXOR);

  TAlgorithm = record
    Name : string;
    XorKey : array of Byte;
    RotateDirection : TRotateDirection;
    RotateTime : TRotateTime;
    RotateCount : byte;
    ChangeFileExt : boolean;
  end;


  TLanguage = record
    frmSmp2Mp3_caption : string;
    gbSingleFile_caption : string;
    btnConvertSingle_caption : string;
    lblSOrigen_caption : string;
    gbConvertBatch_caption : string;
    lblBOrigen_caption : string;
    btnBatchConvert_caption : string;
    chkNormalizar_caption : string;
    mnuConfig_caption : string;
    mnuChangeKey_caption : string;
    frmKey_caption : string;
    frmKey_btnOK_caption : string;
    frmKey_btnCancel_caption : string;
    frmKey_gbRotate_caption : string;
    frmKey_gbXORkey_caption : string;
    frmKey_lblTimes_caption : string;
    frmKey_lblTime_caption : string;
    frmKey_chkChangeExt_Caption : string;
    frmKey_rgRotate_disabled : string;
    frmKey_rgRotate_right : string;
    frmKey_rgRotate_left : string;
    frmKey_cboTime_beforeXOR : string;
    frmKey_cboTime_afterXOR : string;
    frmKey_SaveToFile_caption : string;
    frmKey_LoadFromFile_caption : string;
    mnuChangelanguage_caption : string;
    MESSAGES_FILE_NOT_FOUND : string;
    MESSAGES_SOURCE_DIR_NOT_FOUND : string;
    MESSAGES_CONVERTION_TYPE_NOT_SELECTED : string;
    MESSAGES_REPLACE_FILES_WARNING : string;
    MESSAGES_FILES_OF_TYPE_NOT_FOUND : string;
    MESSAGES_CONVERTING_FILES : string;
    MESSAGES_PLEASE_WAIT : string;
    MESSAGES_CONVERTION_CANCELLED : string;
    MESSAGES_CONVERSION_ENDED : string;
    MESSAGES_SELECTED_FILE_DONT_EXISTS : string;
    MESSAGES_CONVERT : string;
    MESSAGES_CONVERT_TO : string;
    MESSAGES_CONVERTING_FILE : string;
    MESSAGES_OVERWRITE_PROMPT : string;
    MESSAGES_COULD_NOT_CREATE_STREAM : string;
    MESSAGES_COULD_NOT_PLAY_FILE : string;
    CAPTION_NORMALIZE_BEFORE : string;
    CAPTION_NORMALIZE_AFTER : string;
    CAPTION_ENCRYPT : string;
    CAPTION_DECRYPT : string;
    CAPTION_NORMALIZING : string;
    CAPTION_PROCESSING : string;
    CAPTION_SELECT_DIR : string;
    CAPTION_SAVE_TO : string;
  end;

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
    procedure mnuChangelanguageClick(Sender: TObject);
    procedure sbSelectFileClick(Sender: TObject);
    procedure sbSelectDirectoryClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    FFilesFound : TStringList;
    FLastSelectedKeyFile: string;
    FProgressBars : TObjectList;
    FProgressLabels : TObjectList;
    FProgressRowCount : integer;
    procedure InitKey;
    procedure ConvertSingleFile(ASourceFileName, ADestFileName : string; AEncrypt : boolean);
    procedure ChangeBatchConvertCaption;
    function ConvertExt(AFileName : string) : string;
    function InitLanguage : TLanguage;
    procedure LoadLanguage(AFilename : string);
    procedure WriteLanguage(AFilename : string; ALanguage : TLanguage);
    function ChangeLanguageFile : string;
    procedure FindFiles(ADirName : string; AFileExt: string);
    function NormalizeAudio(AFile: string): boolean;
    procedure SetLastSelectedKeyFile(const Value: string);
    property LastSelectedKeyFile : string read FLastSelectedKeyFile write SetLastSelectedKeyFile;
    procedure ChangeCaption;
    procedure ChangebtnConvertSingleCaption;
    //Functions for progressbars
    function AddProgress( AMaxValue : integer; ACaption : string = ''): integer;
    procedure DelProgress( AnIndex : integer );
    procedure IncProgress( AnIndex : integer; AnAmount : integer = 1);
    procedure SetProgress( AnIndex, AProgress : integer);
    function ProgressOf(AnIndex : integer) : integer;
  public
    { Public declarations }
    procedure ChangeEncryptCaptions;
  end;

  procedure BassFileCloseProc(user: Pointer); stdcall;
  function BassFileLenProc(user: Pointer): QWORD; stdcall;
  function BassFileReadProc(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
  function BassFileSeekProc(offset: QWORD; user: Pointer): BOOL; stdcall;
  function NextKey(var vKeyIndex : integer) : byte;
  function BassErrorToString(AnErrorCode : integer) : string;
  function ProcessByte(AByte : Byte; var vKeyIndex : integer; AEncrypt : boolean) : Byte;
  procedure AddHourGlassCursor;
  procedure RemoveHourGlassCursor;

var
  frmSmp2MP3: TfrmSmp2MP3;
  Key: TAlgorithm;
  PlayerKeyIndex : integer;
  GSourceFile : TFileStream;
  Player: HSTREAM;
  Language : TLanguage;
  gHourGlassLevel : Integer = 0;
  gLastCursor : TCursor;



implementation

uses
  StrUtils, Math, IniFiles, KeyFrm, FileCtrl;

{$R *.dfm}

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

function ProcessByte(AByte : Byte; var vKeyIndex : integer; AEncrypt : boolean) : Byte;
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
  function lRotateByte(AValue : Byte; ARotateDirection : TRotateDirection) : Byte;
  //Rotate byte
  begin
    result := AValue;
    if ARotateDirection = rdNone then
      result := AValue
    else if ARotateDirection = rdRight then
      result := lROR(AValue,key.RotateCount)
    else if ARotateDirection = rdLeft then
      result := lROL(AValue,key.RotateCount);
  end;
  //**************************************************************************//
var
  lRotateTime : TRotateTime;
  lRotateDirection : TRotateDirection;
begin
  lRotateTime := Key.RotateTime;
  lRotateDirection := Key.RotateDirection;

  //If is decrypting then the the bit rotation must be reversed in direction and time
  if (not AEncrypt) and (lRotateDirection <> rdNone) then
  begin
    //reverse time
    if lRotateTime = rtBeforeXOR then
      lRotateTime := rtAfterXOR
    else
      lRotateTime := rtBeforeXOR;
    //reverse direction
    if lRotateDirection = rdLeft then
      lRotateDirection := rdRight
    else
      lRotateDirection := rdLeft;
  end;

  //rotate bits before XOR encryption/decryption
  if lRotateTime = rtBeforeXOR then
    AByte := lRotateByte(AByte,lRotateDirection);

  //Apply XOR encryption/decryption
  if length(Key.XorKey) > 0 then
    result := AByte xor NextKey(vKeyIndex) //Nextkey returns the key at the index positon and increments the index position
  else
    result := AByte;

  //rotate bits after XOR encryption/decryption
  if lRotateTime = rtAfterXOR then
    result := lRotateByte(result,lRotateDirection);
end;


function NextKey(var vKeyIndex : integer) : byte;
//Return Byte key at index position and increment index
begin
  if Length(Key.XorKey) = 0 then
    result := 0
  else
    result := Key.XorKey[vKeyIndex];

  inc(vKeyIndex);
  //if Index gets over key length, reset index
  if vKeyIndex >= length(Key.XorKey) then
    vKeyIndex := 0;
end;

procedure BassFileCloseProc(user: Pointer); stdcall;
//Bass callback to close file
begin
  GSourceFile.Free;
end;

function BassFileLenProc(user: Pointer): QWORD; stdcall;
//Bass callback to get file size
begin
  result := GSourceFile.Size;
end;

function BassFileReadProc(buffer: Pointer; length: DWORD; user: Pointer): DWORD; stdcall;
//Bass callback to read file
var
  lBuffer : array [0 .. 1023] of byte;
  lDecodedBuffer : array [0 .. 1023] of Byte;
  i : integer;
begin
  //reads a maximum of 1024 bytes and stores them in a buffer
  result := GSourceFile.Read(lBuffer, min(1024,length));
  //iterates the buffer applying the encryption/decryption to each byte and stoes it in DecodedBuffer
  for i := 0 to result - 1 do
    lDecodedBuffer[i] := ProcessByte(lBuffer[i],PlayerKeyIndex,False);
  //Saves decoded buffer to function result
  move(lDecodedBuffer,buffer^,result);
end;

function BassFileSeekProc(offset: QWORD; user: Pointer): BOOL; stdcall;
//Bass callback to change position in file
begin
  result := true;
  GSourceFile.Position := offset;
  //sets PlayerKeyIndex to the right value according to the new position
  PlayerKeyIndex := offset mod length(Key.XorKey);
end;


function TfrmSmp2MP3.AddProgress(AMaxValue: integer; ACaption: string): integer;
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

    if (not Key.ChangeFileExt) and (uppercase(lSourceDir) = UpperCase(lDestDir)) then
    begin
      MessageDlg('Source and destination directories are the same.', mtError, [mbOK], 0);
      exit;
    end;


    if rbBatchSmp2Mp3.Checked then
      lSourceExt := '.smp'
    else
      lSourceExt := '.mp3';

    if (MessageDlg(Format(Language.MESSAGES_REPLACE_FILES_WARNING,[ConvertExt(lSourceExt)]), mtWarning, [mbYes, mbNo], 0) in [mrNo, mrNone]) then
      exit;

    FFilesFound := TStringList.Create;
    try
      //get files list (to be able to show a files progress bar)
      FindFiles(lSourceDir,lSourceExt);
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
    ConvertSingleFile(lSourceFileName,lDestFileName, rbSingleMp32Smp.Checked);
  finally
    Enabled := true;
  end;
end;

procedure TfrmSmp2MP3.ChangeBatchConvertCaption;
//change button caption according to convertion type selected
var
  lDestExt : string;
begin
  if rbBatchSmp2Mp3.Checked then
    lDestExt := '.mp3'
  else if rbBatchMp32Smp.Checked then
    lDestExt := '.smp'
  else
    lDestExt := '';
  if lDestExt <> '' then
    btnBatchConvert.Caption := Format(Language.MESSAGES_CONVERT_TO,[lDestExt])
  else
    btnBatchConvert.Caption := Language.MESSAGES_CONVERT;

  if lDestExt = '.mp3' then
    chkNormalizar.Caption := Language.CAPTION_NORMALIZE_AFTER
  else
    chkNormalizar.Caption := Language.CAPTION_NORMALIZE_BEFORE;
end;

procedure TfrmSmp2MP3.ChangebtnConvertSingleCaption;
var
  lDestExt : string;
begin
  lDestExt := ConvertExt(edFileName.Text);

  if lDestExt <> '' then
    btnConvertSingle.Caption := Format(Language.MESSAGES_CONVERT_TO,[lDestExt])
  else
    btnConvertSingle.Caption := Language.MESSAGES_CONVERT;
  chkNormalizar.Enabled := Key.ChangeFileExt;
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

procedure TfrmSmp2MP3.ChangeCaption;
begin
  caption := Language.frmSmp2Mp3_caption;
  if FLastSelectedKeyFile <> '' then
    caption := caption + ' (' + ExtractFileName(FLastSelectedKeyFile) + ')';
end;

procedure TfrmSmp2MP3.ChangeEncryptCaptions;
begin
  rbSingleSmp2Mp3.Visible := key.RotateDirection <> rdNone;
  rbSingleMp32Smp.Visible := key.RotateDirection <> rdNone;
  rbBatchSmp2Mp3.Caption := Language.CAPTION_DECRYPT;
  rbBatchMp32Smp.Caption := Language.CAPTION_ENCRYPT;
  rbSingleSmp2Mp3.Caption := Language.CAPTION_DECRYPT;
  rbSingleMp32Smp.Caption := Language.CAPTION_ENCRYPT;
end;

function TfrmSmp2MP3.ChangeLanguageFile : string;
//asks for langujage file and loads it.
begin
  result := '';
  OpenDialog.Filter := '*.lan|*.lan';
  OpenDialog.InitialDir := ExtractFileDir(Application.ExeName);
  OpenDialog.FileName := 'spa.lan';
  if OpenDialog.Execute(Handle) then
  begin
    if FileExists(OpenDialog.FileName) then
      result := OpenDialog.FileName
    else
      exit;
    with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
    try
      WriteString('LANGUAGE','FILE',ExtractFileName(result));
    finally
      free;
    end;
    LoadLanguage(result);
    result := ExtractFileName(result);
  end;
end;

function TfrmSmp2MP3.ConvertExt(AFileName: string): string;
//Destination extension according to source filename
var
  lSourceExt : string;
begin
  lSourceExt := UpperCase(ExtractFileExt(AFileName));

  if key.ChangeFileExt then
  begin
    if lSourceExt = '.SMP' then
      Result := '.mp3'
    else if lSourceExt = '.MP3' then
      Result := '.smp'
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
            lDecodedBuffer[i] := ProcessByte(lBuffer[i],lKeyIndex,AEncrypt);
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
//  pnlProgress.ClientHeight := TOP_MARGIN + ( ROW_HEIGHT * FProgressBars.Count ) + BOTTOM_MARGIN;
end;

procedure TfrmSmp2MP3.edFileNameChange(Sender: TObject);
//change button caption when the filename changes
begin
  ChangebtnConvertSingleCaption;
end;

procedure TfrmSmp2MP3.FindFiles(ADirName : string; AFileExt: string);
//adds files to FFilesFound that are in ADirName and have the extension AFileExt
  //**************************************************************************//
  procedure lAddFile(AFilename : string);
  begin
    if UpperCase(ExtractFileExt(AFilename)) = UpperCase(AFileExt) then
      FFilesFound.Add(AFilename);
  end;
  //**************************************************************************//
var
  SearchRec : TSearchRec;
begin
  if Application.Terminated then
    exit;
  if ADirName[length(ADirName)] <> '\' then
    ADirName := ADirName + '\';
  try
    if FindFirst(ADirName + '*.*',faAnyFile,SearchRec) = 0 then
    begin
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        if not (SearchRec.Attr and faDirectory > 0) then
          lAddFile(ADirName + SearchRec.Name);
      end;
      while FindNext(SearchRec) = 0 do
      begin
        if Application.Terminated then
          exit;
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if not (SearchRec.Attr and faDirectory > 0) then
            lAddFile(ADirName + SearchRec.Name);
        end;
      end;
    end;
  finally
    findclose(SearchRec);
  end;
end;

procedure TfrmSmp2MP3.FormCreate(Sender: TObject);
//Initialize program
var
  lDevice : integer;
  lLanguageFile : string;
begin
  lLanguageFile := '';
  InitKey;
  LastSelectedKeyFile := Key.Name;
  if not FileExists(ExtractFilePath(Application.ExeName) + 'spa.lan') then
    WriteLanguage(ExtractFilePath(Application.ExeName) + 'spa.lan', InitLanguage);
  chkNormalizar.Visible := FileExists(ExtractFilePath(Application.ExeName) + 'mp3gain.exe');
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
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
    LoadLanguage(ExtractFilePath(Application.ExeName) + lLanguageFile)
  else
    ChangeLanguageFile;
  FProgressBars := TObjectList.Create;
  FProgressLabels := TObjectList.Create;
  FProgressRowCount := 0;
end;

procedure TfrmSmp2MP3.FormDestroy(Sender: TObject);
begin
  FProgressBars.Free;
  FProgressLabels.Free;
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
//Initialize the Key to Encrypt/decrypt smp files with the "audiocuentos" format.
var
  lKeyFilename : string;
  i : integer;
  lKeys : tstringlist;
begin
  lKeyFilename := ChangeFileExt(Application.ExeName,'.ini');
  with TIniFile.Create(lKeyFilename) do
  try
    if not SectionExists('KEY') then
    begin
      WriteString('KEY','NAME','Audiocuentos.key');
      WriteInteger('KEY','ROTATEDIRECTION',ord(rdNone));
      WriteInteger('KEY','ROTATETIME',ord(rtBeforeXOR));
      WriteInteger('KEY','ROTATECOUNT',0);
      WriteString('KEY','XORKEY','0x51,0x23,0x98,0x56');
      WriteBool('KEY','CHANGEFILEEXT',true);
    end;

    Key.Name := ReadString('KEY','NAME','');
    key.RotateDirection := TRotateDirection(ReadInteger('KEY','ROTATEDIRECTION',ord(rdNone)));
    key.RotateTime := TRotateTime(ReadInteger('KEY','ROTATETIME',ord(rtBeforeXOR)));
    key.RotateCount := ReadInteger('KEY','ROTATECOUNT',0);
    key.ChangeFileExt := ReadBool('KEY','CHANGEFILEEXT',true);
    lKeys := TStringList.Create;
    try
      lKeys.CommaText := ReadString('KEY','XORKEY','0x51,0x23,0x98,0x56');
      SetLength(Key.XorKey,lKeys.Count);
      for i := 0 to lKeys.Count - 1 do
        Key.XorKey[i] := StrToInt(lKeys[i]);
    finally
      lKeys.Free;
    end;
  finally
    Free;
  end;
  PlayerKeyIndex := 0;

  ChangeEncryptCaptions;
end;

function TfrmSmp2MP3.InitLanguage: TLanguage;
//Default language values
begin
  result.frmSmp2Mp3_caption := 'Convertidor SMP <-> MP3';
  result.gbSingleFile_caption := 'Convertir un solo archivo';
  result.btnConvertSingle_caption := 'Convertir';
  result.lblSOrigen_caption := 'Origen:';
  result.gbConvertBatch_caption := 'Convertir todos los archivos de un directorio';
  result.lblBOrigen_caption := 'Origen:';
  result.btnBatchConvert_caption := 'Convertir';
  result.chkNormalizar_caption := 'Normalizar';
  result.MESSAGES_FILE_NOT_FOUND := 'No se encuentra el archivo: %s.';
  result.MESSAGES_SOURCE_DIR_NOT_FOUND := 'No existe el directorio origen.';
  result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED := 'No se ha seleccionado el tipo de conversión.';
  result.MESSAGES_REPLACE_FILES_WARNING := 'Este proceso reemplazará los archivos %s que puedan existir en el mismo directorio en que se encuentran los archivos origen. ¿Aún así desea continuar?';
  result.MESSAGES_FILES_OF_TYPE_NOT_FOUND := 'No se encontraron archivos %s a convertir.';
  result.MESSAGES_CONVERTING_FILES := 'Convirtiendo archivos ...';
  result.MESSAGES_PLEASE_WAIT := 'Por favor espere ...';
  result.MESSAGES_CONVERTION_CANCELLED := 'Se cancelo el proceso, no todos los archivos fueron convertidos.';
  result.MESSAGES_CONVERSION_ENDED := 'La conversión ha terminado.';
  result.MESSAGES_SELECTED_FILE_DONT_EXISTS := 'El archivo seleccionado no existe.';
  result.MESSAGES_CONVERT := 'Convertir';
  result.MESSAGES_CONVERT_TO := 'Convertir a %s';
  result.MESSAGES_CONVERTING_FILE := 'Convirtiendo archivo ...';
  result.MESSAGES_OVERWRITE_PROMPT := 'El archivo destino ya existe, si continua se sobreescribirá su contenido. ¿Aún así desea continuar?';
  result.MESSAGES_COULD_NOT_CREATE_STREAM := 'No fué posible crear el stream (%s)';
  result.MESSAGES_COULD_NOT_PLAY_FILE := 'No se le pudo dar play (%s)';
  result.CAPTION_NORMALIZE_BEFORE := 'Normalizar mp3 antes de convertirlo';
  result.CAPTION_NORMALIZE_AFTER := 'Normalizar mp3 resultante.';
  result.CAPTION_ENCRYPT := 'Encriptar (.mp3 -> .smp)';
  result.CAPTION_DECRYPT := 'Desencriptar (.smp -> .mp3)';
  result.CAPTION_NORMALIZING := 'Normalizando';
  result.CAPTION_PROCESSING := 'Procesando';
  result.CAPTION_SELECT_DIR := 'Seleccionar directorio';
  result.CAPTION_SAVE_TO := 'Guardar en';
  result.mnuConfig_caption := 'Configuración';
  result.mnuChangeKey_caption := 'Cambiar clave de encriptación';
  result.mnuChangelanguage_caption := 'Cambiar idioma';
  result.frmKey_caption := 'Cambiar llave';
  result.frmKey_btnOK_caption := 'Aceptar';
  result.frmKey_btnCancel_caption := 'Cancelar';
  result.frmKey_gbRotate_caption := 'Rotar bits';
  result.frmKey_gbXORkey_caption := 'Clave XOR';
  result.frmKey_lblTimes_caption := 'Veces';
  result.frmKey_lblTime_caption := 'Momento';
  result.frmKey_chkChangeExt_Caption := 'Cambiar extensión de archivo (smp <-> mp3)';
  result.frmKey_rgRotate_disabled := 'Deshabilitado';
  result.frmKey_rgRotate_right := 'Derecha';
  result.frmKey_rgRotate_left := 'Izquierda';
  result.frmKey_cboTime_beforeXOR := 'Antes de XOR';
  result.frmKey_cboTime_afterXOR := 'Después de XOR';
  result.frmKey_SaveToFile_caption := 'Guardar llave como';
  result.frmKey_LoadFromFile_caption := 'Cargar llave';
end;

procedure TfrmSmp2MP3.LoadLanguage(AFilename: string);
//Load language from file and apply values
begin
  Language := InitLanguage;
  with TIniFile.Create(AFilename) do
  try
    Language.frmSmp2Mp3_caption                      := ReadString('frmSmp2Mp3'                  ,'CAPTION'                      ,Language.frmSmp2Mp3_caption                      );
    Language.gbSingleFile_caption                    := ReadString('gbSingleFile'                ,'CAPTION'                      ,Language.gbSingleFile_caption                    );
    Language.btnConvertSingle_caption                := ReadString('btnConvertSingle'            ,'CAPTION'                      ,Language.btnConvertSingle_caption                );
    Language.lblSOrigen_caption                      := ReadString('lblSOrigen'                  ,'CAPTION'                      ,Language.lblSOrigen_caption                      );
    Language.gbConvertBatch_caption                  := ReadString('gbConvertBatch'              ,'CAPTION'                      ,Language.gbConvertBatch_caption                  );
    Language.lblBOrigen_caption                      := ReadString('lblBOrigen'                  ,'CAPTION'                      ,Language.lblBOrigen_caption                      );
    Language.btnBatchConvert_caption                 := ReadString('btnBatchConvert'             ,'CAPTION'                      ,Language.btnBatchConvert_caption                 );
    Language.chkNormalizar_caption                   := ReadString('chkNormalizar'               ,'CAPTION'                      ,Language.chkNormalizar_caption                   );
    Language.mnuConfig_caption                       := ReadString('mnuConfig'                   ,'CAPTION'                      ,Language.mnuConfig_caption                       );
    Language.mnuChangeKey_caption                    := ReadString('mnuChangeKey'                ,'CAPTION'                      ,Language.mnuChangeKey_caption                    );
    Language.mnuChangelanguage_caption               := ReadString('mnuChangelanguage'           ,'CAPTION'                      ,Language.mnuChangelanguage_caption               );
    Language.frmKey_caption                          := ReadString('frmKey'                      ,'CAPTION'                      ,Language.frmKey_caption                          );
    Language.frmKey_btnOK_caption                    := ReadString('frmKey_btnOK'                ,'CAPTION'                      ,Language.frmKey_btnOK_caption                    );
    Language.frmKey_btnCancel_caption                := ReadString('frmKey_btnCancel'            ,'CAPTION'                      ,Language.frmKey_btnCancel_caption                );
    Language.frmKey_gbRotate_caption                 := ReadString('frmKey_gbRotate'             ,'CAPTION'                      ,Language.frmKey_gbRotate_caption                 );
    Language.frmKey_gbXORkey_caption                 := ReadString('frmKey_gbXORkey'             ,'CAPTION'                      ,Language.frmKey_gbXORkey_caption                 );
    Language.frmKey_lblTimes_caption                 := ReadString('frmKey_lblTimes'             ,'CAPTION'                      ,Language.frmKey_lblTimes_caption                 );
    Language.frmKey_lblTime_caption                  := ReadString('frmKey_lblTime'              ,'CAPTION'                      ,Language.frmKey_lblTime_caption                  );
    Language.frmKey_chkChangeExt_Caption             := ReadString('frmKey_chkChangeExt'         ,'CAPTION'                      ,Language.frmKey_chkChangeExt_Caption             );
    Language.frmKey_rgRotate_disabled                := ReadString('frmKey_rgRotate_disabled'    ,'CAPTION'                      ,Language.frmKey_rgRotate_disabled                );
    Language.frmKey_rgRotate_right                   := ReadString('frmKey_rgRotate_right'       ,'CAPTION'                      ,Language.frmKey_rgRotate_right                   );
    Language.frmKey_rgRotate_left                    := ReadString('frmKey_rgRotate_left'        ,'CAPTION'                      ,Language.frmKey_rgRotate_left                    );
    Language.frmKey_cboTime_beforeXOR                := ReadString('frmKey_cboTime_beforeXOR'    ,'CAPTION'                      ,Language.frmKey_cboTime_beforeXOR                );
    Language.frmKey_cboTime_afterXOR                 := ReadString('frmKey_cboTime_afterXOR'     ,'CAPTION'                      ,Language.frmKey_cboTime_afterXOR                 );
    Language.frmKey_SaveToFile_caption               := ReadString('frmKey_SaveToFile'           ,'CAPTION'                      ,Language.frmKey_SaveToFile_caption               );
    Language.frmKey_LoadFromFile_caption             := ReadString('frmKey_LoadFromFile'         ,'CAPTION'                      ,Language.frmKey_LoadFromFile_caption             );
    Language.MESSAGES_FILE_NOT_FOUND                 := ReadString('MESSAGES'                    ,'FILE_NOT_FOUND'               ,Language.MESSAGES_FILE_NOT_FOUND                 );
    Language.MESSAGES_SOURCE_DIR_NOT_FOUND           := ReadString('MESSAGES'                    ,'SOURCE_DIR_NOT_FOUND'         ,Language.MESSAGES_SOURCE_DIR_NOT_FOUND           );
    Language.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   := ReadString('MESSAGES'                    ,'CONVERTION_TYPE_NOT_SELECTED' ,Language.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   );
    Language.MESSAGES_REPLACE_FILES_WARNING          := ReadString('MESSAGES'                    ,'REPLACE_FILES_WARNING'        ,Language.MESSAGES_REPLACE_FILES_WARNING          );
    Language.MESSAGES_FILES_OF_TYPE_NOT_FOUND        := ReadString('MESSAGES'                    ,'FILES_OF_TYPE_NOT_FOUND'      ,Language.MESSAGES_FILES_OF_TYPE_NOT_FOUND        );
    Language.MESSAGES_CONVERTING_FILES               := ReadString('MESSAGES'                    ,'CONVERTING_FILES'             ,Language.MESSAGES_CONVERTING_FILES               );
    Language.MESSAGES_PLEASE_WAIT                    := ReadString('MESSAGES'                    ,'PLEASE_WAIT'                  ,Language.MESSAGES_PLEASE_WAIT                    );
    Language.MESSAGES_CONVERTION_CANCELLED           := ReadString('MESSAGES'                    ,'CONVERTION_CANCELLED'         ,Language.MESSAGES_CONVERTION_CANCELLED           );
    Language.MESSAGES_CONVERSION_ENDED               := ReadString('MESSAGES'                    ,'CONVERSION_ENDED'             ,Language.MESSAGES_CONVERSION_ENDED               );
    Language.MESSAGES_SELECTED_FILE_DONT_EXISTS      := ReadString('MESSAGES'                    ,'SELECTED_FILE_DONT_EXISTS'    ,Language.MESSAGES_SELECTED_FILE_DONT_EXISTS      );
    Language.MESSAGES_CONVERT                        := ReadString('MESSAGES'                    ,'CONVERT'                      ,Language.MESSAGES_CONVERT                        );
    Language.MESSAGES_CONVERT_TO                     := ReadString('MESSAGES'                    ,'CONVERT_TO'                   ,Language.MESSAGES_CONVERT_TO                     );
    Language.MESSAGES_CONVERTING_FILE                := ReadString('MESSAGES'                    ,'CONVERTING_FILE'              ,Language.MESSAGES_CONVERTING_FILE                );
    Language.MESSAGES_OVERWRITE_PROMPT               := ReadString('MESSAGES'                    ,'OVERWRITE_PROMPT'             ,Language.MESSAGES_OVERWRITE_PROMPT               );
    Language.MESSAGES_COULD_NOT_CREATE_STREAM        := ReadString('MESSAGES'                    ,'COULD_NOT_CREATE_STREAM'      ,Language.MESSAGES_COULD_NOT_CREATE_STREAM        );
    Language.MESSAGES_COULD_NOT_PLAY_FILE            := ReadString('MESSAGES'                    ,'COULD_NOT_PLAY_FILE'          ,Language.MESSAGES_COULD_NOT_PLAY_FILE            );
    Language.CAPTION_NORMALIZE_BEFORE                := ReadString('CAPTION'                     ,'NORMALIZE_BEFORE'             ,Language.CAPTION_NORMALIZE_BEFORE                );
    Language.CAPTION_NORMALIZE_AFTER                 := ReadString('CAPTION'                     ,'NORMALIZE_AFTER'              ,Language.CAPTION_NORMALIZE_AFTER                 );
    Language.CAPTION_ENCRYPT                         := ReadString('CAPTION'                     ,'ENCRYPT'                      ,Language.CAPTION_ENCRYPT                         );
    Language.CAPTION_DECRYPT                         := ReadString('CAPTION'                     ,'DECRYPT'                      ,Language.CAPTION_DECRYPT                         );
    Language.CAPTION_NORMALIZING                     := ReadString('CAPTION'                     ,'NORMALIZING'                  ,Language.CAPTION_NORMALIZING                     );
    Language.CAPTION_PROCESSING                      := ReadString('CAPTION'                     ,'PROCESSING'                   ,Language.CAPTION_PROCESSING                      );
    Language.CAPTION_SELECT_DIR                      := ReadString('CAPTION'                     ,'SAVE_AS'                      ,Language.CAPTION_SELECT_DIR                      );
    Language.CAPTION_SAVE_TO                         := ReadString('CAPTION'                     ,'SAVE_TO'                      ,Language.CAPTION_SAVE_TO                         );
  finally
    Free;
  end;
  ChangeCaption;
  gbSingleFile.Caption := Language.gbSingleFile_caption;
  btnConvertSingle.Caption := Language.btnConvertSingle_caption;
  lblSOrigen.Caption := Language.lblSOrigen_caption;
  gbConvertBatch.Caption := Language.gbConvertBatch_caption;
  lblBOrigen.Caption := Language.lblBOrigen_caption;
  btnBatchConvert.Caption := Language.btnBatchConvert_caption;
  chkNormalizar.Caption := Language.chkNormalizar_caption;
  mnuConfig.Caption := Language.mnuConfig_caption;
  mnuChangeKey.Caption := Language.mnuChangeKey_caption;
  mnuChangelanguage.Caption := Language.mnuChangelanguage_caption;
  ChangeEncryptCaptions;
end;

procedure TfrmSmp2MP3.mnuChangeKeyClick(Sender: TObject);
//Show form to change encryption keys
begin
  with TfrmKey.Create(nil) do
  try
    Caption := Language.frmKey_caption;
    btnOK.Caption := Language.frmKey_btnOK_caption;
    btnCancel.Caption := Language.frmKey_btnCancel_caption;
    gbRotate.Caption := Language.frmKey_gbRotate_caption;
    gbXORkey.Caption := Language.frmKey_gbXORkey_caption;
    lblTimes.Caption := Language.frmKey_lblTimes_caption;
    lblTime.Caption := Language.frmKey_lblTime_caption;
    chkChangeExt.Caption := Language.frmKey_chkChangeExt_Caption;
    rgRotate.Items.Clear;
    rgRotate.Items.Add(Language.frmKey_rgRotate_disabled);
    rgRotate.Items.Add(Language.frmKey_rgRotate_right);
    rgRotate.Items.Add(Language.frmKey_rgRotate_left);
    cboTime.items.Clear;
    cboTime.items.Add(Language.frmKey_cboTime_beforeXOR);
    cboTime.items.Add(Language.frmKey_cboTime_afterXOR);
    LoadFromFileCaption := Language.frmKey_LoadFromFile_caption;
    SaveToFileCaption := Language.frmKey_SaveToFile_caption;
    if ShowModal = mrOk then
    begin
      LastSelectedKeyFile := SelectedFile;
      InitKey;
      ChangebtnConvertSingleCaption;
    end;
  finally
    Free;
  end;
end;

procedure TfrmSmp2MP3.mnuChangelanguageClick(Sender: TObject);
begin
  ChangeLanguageFile;
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
  PlayerKeyIndex := 0;
  Player := 0;
  //If file is encrypted use Callbacks to decrypt
  if UpperCase(ExtractFileExt(edFileName.Text)) = '.SMP' then
  begin
    GSourceFile := TFileStream.Create(edFileName.Text, fmOpenRead);
    lprocs.close := BassFileCloseProc;
    lprocs.length := BassFileLenProc;
    lprocs.read := BassFileReadProc;
    lprocs.seek := BassFileSeekProc;
    Player := BASS_StreamCreateFileUser(STREAMFILE_BUFFER,0,lprocs,pointer(lUser));
  end
  else //Play directly
    Player := BASS_StreamCreateFile(False,PChar(edFileName.Text),0,0,0);
    
  if Player = 0 then
    ShowMessage(format(Language.MESSAGES_COULD_NOT_CREATE_STREAM,[BassErrorToString(BASS_ErrorGetCode)]))
  else
  begin
    if not BASS_ChannelPlay(Player, true) then
      ShowMessage(format(Language.MESSAGES_COULD_NOT_PLAY_FILE,[BassErrorToString(BASS_ErrorGetCode)]))
  end;
end;

procedure TfrmSmp2MP3.btnStopClick(Sender: TObject);
//Stop playing file
begin
  BASS_ChannelStop(Player);
  Player := 0;
end;

procedure TfrmSmp2MP3.rbBatchMp32SmpClick(Sender: TObject);
begin
  ChangeBatchConvertCaption;
end;

procedure TfrmSmp2MP3.rbBatchSmp2Mp3Click(Sender: TObject);
begin
  ChangeBatchConvertCaption;
end;

procedure TfrmSmp2MP3.sbSelectFileClick(Sender: TObject);
begin
  OpenDialog.Filter := '*.smp;*.mp3|*.smp;*.mp3';
  OpenDialog.InitialDir := '';
  OpenDialog.FileName := '';
  if OpenDialog.Execute(Handle) then
  begin
    if FileExists(OpenDialog.FileName) then
      edFileName.Text := OpenDialog.FileName;
  end;
end;

procedure TfrmSmp2MP3.SetLastSelectedKeyFile(const Value: string);
var
  lKeyName : string;
begin
  FLastSelectedKeyFile := Value;
  lKeyName := ExtractFileName(Value);
  with TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) do
  try
    WriteString('KEY','NAME',lKeyName);
  finally
    Free;
  end;
  ChangeCaption;
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

procedure TfrmSmp2MP3.sbSelectDirectoryClick(Sender: TObject);
var
  lDirectory : string;
begin
  lDirectory := '';
  if SelectDirectory(Language.CAPTION_SELECT_DIR,'', lDirectory,[],nil) then
    edDirName.Text := lDirectory;
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
    pbAudioLevel.Position := lRightdB;
  except
  end;
end;

procedure TfrmSmp2MP3.WriteLanguage(AFilename: string; ALanguage: TLanguage);
//write language file
begin
  with TIniFile.Create(AFilename) do
  try
    WriteString('frmSmp2Mp3'                ,'CAPTION'                      ,ALanguage.frmSmp2Mp3_caption                      );
    WriteString('gbSingleFile'              ,'CAPTION'                      ,Alanguage.gbSingleFile_caption                    );
    WriteString('btnConvertSingle'          ,'CAPTION'                      ,Alanguage.btnConvertSingle_caption                );
    WriteString('lblSOrigen'                ,'CAPTION'                      ,Alanguage.lblSOrigen_caption                      );
    WriteString('gbConvertBatch'            ,'CAPTION'                      ,Alanguage.gbConvertBatch_caption                  );
    WriteString('lblBOrigen'                ,'CAPTION'                      ,Alanguage.lblBOrigen_caption                      );
    WriteString('btnBatchConvert'           ,'CAPTION'                      ,Alanguage.btnBatchConvert_caption                 );
    WriteString('chkNormalizar'             ,'CAPTION'                      ,Alanguage.chkNormalizar_caption                   );
    WriteString('mnuConfig'                 ,'CAPTION'                      ,ALanguage.mnuConfig_caption                       );
    WriteString('mnuChangeKey'              ,'CAPTION'                      ,ALanguage.mnuChangeKey_caption                    );
    WriteString('mnuChangelanguage'         ,'CAPTION'                      ,ALanguage.mnuChangelanguage_caption               );
    WriteString('frmKey'                    ,'CAPTION'                      ,ALanguage.frmKey_caption                          );
    WriteString('frmKey_btnOK'              ,'CAPTION'                      ,ALanguage.frmKey_btnOK_caption                    );
    WriteString('frmKey_btnCancel'          ,'CAPTION'                      ,ALanguage.frmKey_btnCancel_caption                );
    WriteString('frmKey_gbRotate'           ,'CAPTION'                      ,ALanguage.frmKey_gbRotate_caption                 );
    WriteString('frmKey_gbXORkey'           ,'CAPTION'                      ,ALanguage.frmKey_gbXORkey_caption                 );
    WriteString('frmKey_lblTimes'           ,'CAPTION'                      ,ALanguage.frmKey_lblTimes_caption                 );
    WriteString('frmKey_lblTime'            ,'CAPTION'                      ,ALanguage.frmKey_lblTime_caption                  );
    WriteString('frmKey_chkChangeExt'       ,'CAPTION'                      ,ALanguage.frmKey_chkChangeExt_Caption             );
    WriteString('frmKey_rgRotate_disabled'  ,'CAPTION'                      ,ALanguage.frmKey_rgRotate_disabled                );
    WriteString('frmKey_rgRotate_right'     ,'CAPTION'                      ,ALanguage.frmKey_rgRotate_right                   );
    WriteString('frmKey_rgRotate_left'      ,'CAPTION'                      ,ALanguage.frmKey_rgRotate_left                    );
    WriteString('frmKey_cboTime_beforeXOR'  ,'CAPTION'                      ,ALanguage.frmKey_cboTime_beforeXOR                );
    WriteString('frmKey_cboTime_afterXOR'   ,'CAPTION'                      ,ALanguage.frmKey_cboTime_afterXOR                 );
    WriteString('frmKey_SaveToFile'         ,'CAPTION'                      ,ALanguage.frmKey_SaveToFile_caption               );
    WriteString('frmKey_LoadFromFile'       ,'CAPTION'                      ,ALanguage.frmKey_LoadFromFile_caption             );
    WriteString('MESSAGES'                  ,'FILE_NOT_FOUND'               ,Alanguage.MESSAGES_FILE_NOT_FOUND                 );
    WriteString('MESSAGES'                  ,'SOURCE_DIR_NOT_FOUND'         ,Alanguage.MESSAGES_SOURCE_DIR_NOT_FOUND           );
    WriteString('MESSAGES'                  ,'CONVERTION_TYPE_NOT_SELECTED' ,Alanguage.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   );
    WriteString('MESSAGES'                  ,'REPLACE_FILES_WARNING'        ,Alanguage.MESSAGES_REPLACE_FILES_WARNING          );
    WriteString('MESSAGES'                  ,'FILES_OF_TYPE_NOT_FOUND'      ,Alanguage.MESSAGES_FILES_OF_TYPE_NOT_FOUND        );
    WriteString('MESSAGES'                  ,'CONVERTING_FILES'             ,Alanguage.MESSAGES_CONVERTING_FILES               );
    WriteString('MESSAGES'                  ,'PLEASE_WAIT'                  ,Alanguage.MESSAGES_PLEASE_WAIT                    );
    WriteString('MESSAGES'                  ,'CONVERTION_CANCELLED'         ,Alanguage.MESSAGES_CONVERTION_CANCELLED           );
    WriteString('MESSAGES'                  ,'CONVERSION_ENDED'             ,Alanguage.MESSAGES_CONVERSION_ENDED               );
    WriteString('MESSAGES'                  ,'SELECTED_FILE_DONT_EXISTS'    ,Alanguage.MESSAGES_SELECTED_FILE_DONT_EXISTS      );
    WriteString('MESSAGES'                  ,'CONVERT'                      ,Alanguage.MESSAGES_CONVERT                        );
    WriteString('MESSAGES'                  ,'CONVERT_TO'                   ,Alanguage.MESSAGES_CONVERT_TO                     );
    WriteString('MESSAGES'                  ,'CONVERTING_FILE'              ,Alanguage.MESSAGES_CONVERTING_FILE                );
    WriteString('MESSAGES'                  ,'OVERWRITE_PROMPT'             ,Alanguage.MESSAGES_OVERWRITE_PROMPT               );
    WriteString('MESSAGES'                  ,'COULD_NOT_CREATE_STREAM'      ,Alanguage.MESSAGES_COULD_NOT_CREATE_STREAM        );
    WriteString('MESSAGES'                  ,'COULD_NOT_PLAY_FILE'          ,Alanguage.MESSAGES_COULD_NOT_PLAY_FILE            );
    WriteString('CAPTION'                   ,'NORMALIZE_BEFORE'             ,ALanguage.CAPTION_NORMALIZE_BEFORE                );
    WriteString('CAPTION'                   ,'NORMALIZE_AFTER'              ,ALanguage.CAPTION_NORMALIZE_AFTER                 );
    WriteString('CAPTION'                   ,'ENCRYPT'                      ,ALanguage.CAPTION_ENCRYPT                         );
    WriteString('CAPTION'                   ,'DECRYPT'                      ,ALanguage.CAPTION_DECRYPT                         );
    WriteString('CAPTION'                   ,'NORMALIZING'                  ,ALanguage.CAPTION_NORMALIZING                     );
    WriteString('CAPTION'                   ,'PROCESSING'                   ,ALanguage.CAPTION_PROCESSING                      );
    WriteString('CAPTION'                   ,'SAVE_AS'                      ,ALanguage.CAPTION_SELECT_DIR                      );
    WriteString('CAPTION'                   ,'SAVE_TO'                      ,ALanguage.CAPTION_SAVE_TO                         );
  finally
    Free;
  end;
end;

end.
