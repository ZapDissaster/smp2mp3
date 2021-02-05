unit smp2mp3Utils;

interface

uses
  Menus, Classes;

type
  TFileFoundEvent = procedure(AFilename : string) of object;

  TRotateDirection = (rdNone, rdRight, rdLeft);
  TRotateTime = (rtBeforeXOR, rtAfterXOR);
  TByteArray = array of Byte;

  TAlgorithm = record
    Name : string;
    XorKey : TByteArray;
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
    mnuChangeKey_other_caption : string;
    mnuChangelanguage_caption : string;
    mniGenerateMCT_caption : string;
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
    frmMct_Caption : string;
    frmMct_lblTipo_Caption : string;
    frmMct_lblDir_Caption : string;
    frmMct_lblFile_Caption : string;
    frmMct_lblToFile_Caption : string;
    frmMct_chkMultiple_Caption : string;
    frmMct_chkUseHex_Caption : string;
    frmMct_gbExample_Caption : string;
    frmMct_btnGenerate_Caption : string;
    frmMct_btnClose_Caption : string;
    MESSAGES_FILES_GENERATED : string;
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


procedure FindFiles(ADirName : string; AFileExt: string; AOnFileFound : TFileFoundEvent);
function LoadKeyFromFile(AFileName : string) : TAlgorithm;
procedure SaveKeyToFile(AFileName : string; AKey : TAlgorithm);
function XorKeyToCommaText (AXORKey : TByteArray) : string;
function CommaTextToXorKey (ACommaText : string) : TByteArray;
function InitLanguageSpa: TLanguage;
function InitLanguageEng: TLanguage;
function LoadLanguageFromFile(AFilename: string) : TLanguage;
procedure WriteLanguageToFile(AFilename: string; ALanguage: TLanguage);
procedure AddFilesToMenuItem(ADirectory, AnExtension : string; AMenuItem : TMenuItem; AOnClick : TNotifyEvent);
function FindAndLoadKey(AKeyname : string) : TAlgorithm;
function IniFileName : string;
function StripFileName(AFileName : string) : string;
function VersionString : string;
function LanguagesPath : string;
function KeysPath : string;

implementation

uses
  SysUtils, Forms, IniFiles, Contnrs, StrUtils, Windows;

function KeysPath: string;
begin
  result := ExtractFilePath(Application.ExeName) + 'Keys\';
end;

function LanguagesPath: string;
begin
  result := ExtractFilePath(Application.ExeName) + 'Languages\';
end;

function VersionString : string;
var
  verblock:PVSFIXEDFILEINFO;
  versionMS,versionLS:cardinal;
  verlen:cardinal;
  rs:TResourceStream;
  m:TMemoryStream;
  p:pointer;
  s:cardinal;
begin
  result := '';
  m:=TMemoryStream.Create;
  try
    rs:=TResourceStream.CreateFromID(HInstance,1,RT_VERSION);
    try
      m.CopyFrom(rs,rs.Size);
    finally
      rs.Free;
    end;
    m.Position:=0;
    if VerQueryValue(m.Memory,'\',pointer(verblock),verlen) then
      begin
        VersionMS:=verblock.dwFileVersionMS;
        VersionLS:=verblock.dwFileVersionLS;
        Result:= IntToStr(versionMS shr 16)+'.'+
                 IntToStr(versionMS and $FFFF)+'.'+
                 IntToStr(VersionLS shr 16)+'.'+
                 IntToStr(VersionLS and $FFFF);
      end;
    if VerQueryValue(m.Memory,PChar('\\StringFileInfo\\'+
      IntToHex(GetThreadLocale,4)+IntToHex(GetACP,4)+'\\FileDescription'),p,s) or
        VerQueryValue(m.Memory,'\\StringFileInfo\\040904E4\\FileDescription',p,s) then //en-us
          Result:=PChar(p)+' '+Result;
  finally
    m.Free;
  end;
end;

function StripFileName(AFileName : string) : string;
begin
  Result := AFileName;
  if ExtractFileExt(Result) <> '' then
    Result := LeftStr(Result,length(Result) - length(ExtractFileExt(Result)));
  result := ExtractFileName(Result);
end;

function IniFileName : string;
begin
  result := ChangeFileExt(Application.ExeName,'.ini');
end;

function FindAndLoadKey(AKeyname : string) : TAlgorithm;
var
  lkeyFileName : string;
  lPath : string;
begin
  AKeyname := ReplaceStr(AKeyname,'&','');
  if ExtractFileExt(AKeyname) = '' then
    lkeyFileName := AKeyname + '.key'
  else
    lkeyFileName := AKeyname;
    
  lPath := ExtractFilePath(Application.ExeName);
  if FileExists(lPath + lkeyFileName) then
  begin
    result := LoadKeyFromFile(lPath + lkeyFileName);
//    result.Name := lPath + lkeyFileName;
  end
  else if FileExists(lPath + 'Keys\' + lkeyFileName) then
  begin
    result := LoadKeyFromFile(lPath + 'Keys\' + lkeyFileName);
//    result.Name := lPath + 'Keys\' + lkeyFileName;
  end;
end;

procedure AddFilesToMenuItem(ADirectory, AnExtension : string; AMenuItem : TMenuItem; AOnClick : TNotifyEvent);
//adds files to FFilesFound that are in ADirName and have the extension AFileExt
  //**************************************************************************//
  procedure lDoFile(AFilename : string);
  var
    lMenuItem : TMenuItem;
    lFileName : string;
  begin
    if (UpperCase(ExtractFileExt(AFilename)) = UpperCase(AnExtension)) then
    begin
      lFileName := ExtractFileName(AFilename);
      lFileName := LeftStr(lFileName, length(lFileName) - 4);
      lMenuItem := TMenuItem.Create(AMenuItem);
      lMenuItem.Caption := lFileName;
      lMenuItem.OnClick := AOnClick;
      AMenuItem.Add(lMenuItem);
    end;
  end;
  //**************************************************************************//
var
  SearchRec : TSearchRec;
begin
  if Application.Terminated then
    exit;
  if ADirectory[length(ADirectory)] <> '\' then
    ADirectory := ADirectory + '\';
  try
    if FindFirst(ADirectory + '*.*',faAnyFile,SearchRec) = 0 then
    begin
      if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
      begin
        if not (SearchRec.Attr and faDirectory > 0) then
          lDoFile(ADirectory + SearchRec.Name);
      end;
      while FindNext(SearchRec) = 0 do
      begin
        if Application.Terminated then
          exit;
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if not (SearchRec.Attr and faDirectory > 0) then
            lDoFile(ADirectory + SearchRec.Name);
        end;
      end;
    end;
  finally
    SysUtils.FindClose(SearchRec);
  end;
end;

procedure WriteLanguageToFile(AFilename: string; ALanguage: TLanguage);
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
    WriteString('mnuChangeKey_other'        ,'CAPTION'                      ,ALanguage.mnuChangeKey_other_caption              );
    WriteString('mnuChangelanguage'         ,'CAPTION'                      ,ALanguage.mnuChangelanguage_caption               );
    WriteString('mniGenerateMCT'            ,'CAPTION'                      ,ALanguage.mniGenerateMCT_caption                  );
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
    WriteString('frmMct_Caption'            ,'CAPTION'                      ,ALanguage.frmMct_Caption                          );
    WriteString('frmMct_lblTipo'            ,'CAPTION'                      ,ALanguage.frmMct_lblTipo_Caption                  );
    WriteString('frmMct_lblDir'             ,'CAPTION'                      ,ALanguage.frmMct_lblDir_Caption                   );
    WriteString('frmMct_lblFile'            ,'CAPTION'                      ,ALanguage.frmMct_lblFile_Caption                  );
    WriteString('frmMct_lblToFile'          ,'CAPTION'                      ,ALanguage.frmMct_lblToFile_Caption                );
    WriteString('frmMct_chkMultiple'        ,'CAPTION'                      ,ALanguage.frmMct_chkMultiple_Caption              );
    WriteString('frmMct_chkUseHex'          ,'CAPTION'                      ,ALanguage.frmMct_chkUseHex_Caption                );
    WriteString('frmMct_gbExample'          ,'CAPTION'                      ,ALanguage.frmMct_gbExample_Caption                );
    WriteString('frmMct_btnGenerate'        ,'CAPTION'                      ,ALanguage.frmMct_btnGenerate_Caption              );
    WriteString('frmMct_btnClose'           ,'CAPTION'                      ,ALanguage.frmMct_btnClose_Caption                 );
    WriteString('MESSAGES'                  ,'FILES_GENERATED'              ,ALanguage.MESSAGES_FILES_GENERATED                );
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

function LoadLanguageFromFile(AFilename: string) : TLanguage;
//Load language from file and apply values
begin
  result := InitLanguageEng;
  with TIniFile.Create(AFilename) do
  try
    result.frmSmp2Mp3_caption                      := ReadString('frmSmp2Mp3'                  ,'CAPTION'                      ,result.frmSmp2Mp3_caption                      );
    result.gbSingleFile_caption                    := ReadString('gbSingleFile'                ,'CAPTION'                      ,result.gbSingleFile_caption                    );
    result.btnConvertSingle_caption                := ReadString('btnConvertSingle'            ,'CAPTION'                      ,result.btnConvertSingle_caption                );
    result.lblSOrigen_caption                      := ReadString('lblSOrigen'                  ,'CAPTION'                      ,result.lblSOrigen_caption                      );
    result.gbConvertBatch_caption                  := ReadString('gbConvertBatch'              ,'CAPTION'                      ,result.gbConvertBatch_caption                  );
    result.lblBOrigen_caption                      := ReadString('lblBOrigen'                  ,'CAPTION'                      ,result.lblBOrigen_caption                      );
    result.btnBatchConvert_caption                 := ReadString('btnBatchConvert'             ,'CAPTION'                      ,result.btnBatchConvert_caption                 );
    result.chkNormalizar_caption                   := ReadString('chkNormalizar'               ,'CAPTION'                      ,result.chkNormalizar_caption                   );
    result.mnuConfig_caption                       := ReadString('mnuConfig'                   ,'CAPTION'                      ,result.mnuConfig_caption                       );
    result.mnuChangeKey_caption                    := ReadString('mnuChangeKey'                ,'CAPTION'                      ,result.mnuChangeKey_caption                    );
    result.mnuChangeKey_other_caption              := ReadString('mnuChangeKey_other'          ,'CAPTION'                      ,result.mnuChangeKey_other_caption              );
    result.mnuChangelanguage_caption               := ReadString('mnuChangelanguage'           ,'CAPTION'                      ,result.mnuChangelanguage_caption               );
    result.mniGenerateMCT_caption                  := ReadString('mniGenerateMCT'              ,'CAPTION'                      ,result.mniGenerateMCT_caption                  );
    result.frmKey_caption                          := ReadString('frmKey'                      ,'CAPTION'                      ,result.frmKey_caption                          );
    result.frmKey_btnOK_caption                    := ReadString('frmKey_btnOK'                ,'CAPTION'                      ,result.frmKey_btnOK_caption                    );
    result.frmKey_btnCancel_caption                := ReadString('frmKey_btnCancel'            ,'CAPTION'                      ,result.frmKey_btnCancel_caption                );
    result.frmKey_gbRotate_caption                 := ReadString('frmKey_gbRotate'             ,'CAPTION'                      ,result.frmKey_gbRotate_caption                 );
    result.frmKey_gbXORkey_caption                 := ReadString('frmKey_gbXORkey'             ,'CAPTION'                      ,result.frmKey_gbXORkey_caption                 );
    result.frmKey_lblTimes_caption                 := ReadString('frmKey_lblTimes'             ,'CAPTION'                      ,result.frmKey_lblTimes_caption                 );
    result.frmKey_lblTime_caption                  := ReadString('frmKey_lblTime'              ,'CAPTION'                      ,result.frmKey_lblTime_caption                  );
    result.frmKey_chkChangeExt_Caption             := ReadString('frmKey_chkChangeExt'         ,'CAPTION'                      ,result.frmKey_chkChangeExt_Caption             );
    result.frmKey_rgRotate_disabled                := ReadString('frmKey_rgRotate_disabled'    ,'CAPTION'                      ,result.frmKey_rgRotate_disabled                );
    result.frmKey_rgRotate_right                   := ReadString('frmKey_rgRotate_right'       ,'CAPTION'                      ,result.frmKey_rgRotate_right                   );
    result.frmKey_rgRotate_left                    := ReadString('frmKey_rgRotate_left'        ,'CAPTION'                      ,result.frmKey_rgRotate_left                    );
    result.frmKey_cboTime_beforeXOR                := ReadString('frmKey_cboTime_beforeXOR'    ,'CAPTION'                      ,result.frmKey_cboTime_beforeXOR                );
    result.frmKey_cboTime_afterXOR                 := ReadString('frmKey_cboTime_afterXOR'     ,'CAPTION'                      ,result.frmKey_cboTime_afterXOR                 );
    result.frmKey_SaveToFile_caption               := ReadString('frmKey_SaveToFile'           ,'CAPTION'                      ,result.frmKey_SaveToFile_caption               );
    result.frmKey_LoadFromFile_caption             := ReadString('frmKey_LoadFromFile'         ,'CAPTION'                      ,result.frmKey_LoadFromFile_caption             );
    result.frmMct_Caption                          := ReadString('frmMct_Caption'              ,'CAPTION'                      ,result.frmMct_Caption                          );
    result.frmMct_lblTipo_Caption                  := ReadString('frmMct_lblTipo'              ,'CAPTION'                      ,result.frmMct_lblTipo_Caption                  );
    result.frmMct_lblDir_Caption                   := ReadString('frmMct_lblDir'               ,'CAPTION'                      ,result.frmMct_lblDir_Caption                   );
    result.frmMct_lblFile_Caption                  := ReadString('frmMct_lblFile'              ,'CAPTION'                      ,result.frmMct_lblFile_Caption                  );
    result.frmMct_lblToFile_Caption                := ReadString('frmMct_lblToFile'            ,'CAPTION'                      ,result.frmMct_lblToFile_Caption                );
    result.frmMct_chkMultiple_Caption              := ReadString('frmMct_chkMultiple'          ,'CAPTION'                      ,result.frmMct_chkMultiple_Caption              );
    result.frmMct_chkUseHex_Caption                := ReadString('frmMct_chkUseHex'            ,'CAPTION'                      ,result.frmMct_chkUseHex_Caption                );
    result.frmMct_gbExample_Caption                := ReadString('frmMct_gbExample'            ,'CAPTION'                      ,result.frmMct_gbExample_Caption                );
    result.frmMct_btnGenerate_Caption              := ReadString('frmMct_btnGenerate'          ,'CAPTION'                      ,result.frmMct_btnGenerate_Caption              );
    result.frmMct_btnClose_Caption                 := ReadString('frmMct_btnClose'             ,'CAPTION'                      ,result.frmMct_btnClose_Caption                 );
    result.MESSAGES_FILES_GENERATED                := ReadString('MESSAGES'                    ,'FILES_GENERATED'              ,result.MESSAGES_FILES_GENERATED                );
    result.MESSAGES_FILE_NOT_FOUND                 := ReadString('MESSAGES'                    ,'FILE_NOT_FOUND'               ,result.MESSAGES_FILE_NOT_FOUND                 );
    result.MESSAGES_SOURCE_DIR_NOT_FOUND           := ReadString('MESSAGES'                    ,'SOURCE_DIR_NOT_FOUND'         ,result.MESSAGES_SOURCE_DIR_NOT_FOUND           );
    result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   := ReadString('MESSAGES'                    ,'CONVERTION_TYPE_NOT_SELECTED' ,result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   );
    result.MESSAGES_REPLACE_FILES_WARNING          := ReadString('MESSAGES'                    ,'REPLACE_FILES_WARNING'        ,result.MESSAGES_REPLACE_FILES_WARNING          );
    result.MESSAGES_FILES_OF_TYPE_NOT_FOUND        := ReadString('MESSAGES'                    ,'FILES_OF_TYPE_NOT_FOUND'      ,result.MESSAGES_FILES_OF_TYPE_NOT_FOUND        );
    result.MESSAGES_CONVERTING_FILES               := ReadString('MESSAGES'                    ,'CONVERTING_FILES'             ,result.MESSAGES_CONVERTING_FILES               );
    result.MESSAGES_PLEASE_WAIT                    := ReadString('MESSAGES'                    ,'PLEASE_WAIT'                  ,result.MESSAGES_PLEASE_WAIT                    );
    result.MESSAGES_CONVERTION_CANCELLED           := ReadString('MESSAGES'                    ,'CONVERTION_CANCELLED'         ,result.MESSAGES_CONVERTION_CANCELLED           );
    result.MESSAGES_CONVERSION_ENDED               := ReadString('MESSAGES'                    ,'CONVERSION_ENDED'             ,result.MESSAGES_CONVERSION_ENDED               );
    result.MESSAGES_SELECTED_FILE_DONT_EXISTS      := ReadString('MESSAGES'                    ,'SELECTED_FILE_DONT_EXISTS'    ,result.MESSAGES_SELECTED_FILE_DONT_EXISTS      );
    result.MESSAGES_CONVERT                        := ReadString('MESSAGES'                    ,'CONVERT'                      ,result.MESSAGES_CONVERT                        );
    result.MESSAGES_CONVERT_TO                     := ReadString('MESSAGES'                    ,'CONVERT_TO'                   ,result.MESSAGES_CONVERT_TO                     );
    result.MESSAGES_CONVERTING_FILE                := ReadString('MESSAGES'                    ,'CONVERTING_FILE'              ,result.MESSAGES_CONVERTING_FILE                );
    result.MESSAGES_OVERWRITE_PROMPT               := ReadString('MESSAGES'                    ,'OVERWRITE_PROMPT'             ,result.MESSAGES_OVERWRITE_PROMPT               );
    result.MESSAGES_COULD_NOT_CREATE_STREAM        := ReadString('MESSAGES'                    ,'COULD_NOT_CREATE_STREAM'      ,result.MESSAGES_COULD_NOT_CREATE_STREAM        );
    result.MESSAGES_COULD_NOT_PLAY_FILE            := ReadString('MESSAGES'                    ,'COULD_NOT_PLAY_FILE'          ,result.MESSAGES_COULD_NOT_PLAY_FILE            );
    result.CAPTION_NORMALIZE_BEFORE                := ReadString('CAPTION'                     ,'NORMALIZE_BEFORE'             ,result.CAPTION_NORMALIZE_BEFORE                );
    result.CAPTION_NORMALIZE_AFTER                 := ReadString('CAPTION'                     ,'NORMALIZE_AFTER'              ,result.CAPTION_NORMALIZE_AFTER                 );
    result.CAPTION_ENCRYPT                         := ReadString('CAPTION'                     ,'ENCRYPT'                      ,result.CAPTION_ENCRYPT                         );
    result.CAPTION_DECRYPT                         := ReadString('CAPTION'                     ,'DECRYPT'                      ,result.CAPTION_DECRYPT                         );
    result.CAPTION_NORMALIZING                     := ReadString('CAPTION'                     ,'NORMALIZING'                  ,result.CAPTION_NORMALIZING                     );
    result.CAPTION_PROCESSING                      := ReadString('CAPTION'                     ,'PROCESSING'                   ,result.CAPTION_PROCESSING                      );
    result.CAPTION_SELECT_DIR                      := ReadString('CAPTION'                     ,'SAVE_AS'                      ,result.CAPTION_SELECT_DIR                      );
    result.CAPTION_SAVE_TO                         := ReadString('CAPTION'                     ,'SAVE_TO'                      ,result.CAPTION_SAVE_TO                         );
  finally
    Free;
  end;
end;

function InitLanguageEng: TLanguage;
//Default language values (eng)
begin
  result.frmSmp2Mp3_caption := 'SMP <-> MP3 converter';
  result.gbSingleFile_caption := 'Convert a single file';
  result.btnConvertSingle_caption := 'Convert';
  result.lblSOrigen_caption := 'Source:';
  result.gbConvertBatch_caption := 'Convert all files in a directory';
  result.lblBOrigen_caption := 'Source:';
  result.btnBatchConvert_caption := 'Convert';
  result.chkNormalizar_caption := 'Normalize';
  result.mnuConfig_caption := 'Configuration';
  result.mnuChangeKey_caption := 'Change encryption key';
  result.mnuChangeKey_other_caption := 'Other...';
  result.mnuChangelanguage_caption := 'Change language';
  result.mniGenerateMCT_caption := 'TAG file generator';
  result.frmKey_caption := 'Change key';
  result.frmKey_btnOK_caption := 'OK';
  result.frmKey_btnCancel_caption := 'Cancel';
  result.frmKey_gbRotate_caption := 'Rotate bits';
  result.frmKey_gbXORkey_caption := 'XOR Key';
  result.frmKey_lblTimes_caption := 'Times';
  result.frmKey_lblTime_caption := 'Moment';
  result.frmKey_chkChangeExt_Caption := 'Change file extension (smp <-> mp3)';
  result.frmKey_rgRotate_disabled := 'Disabled';
  result.frmKey_rgRotate_right := 'Right';
  result.frmKey_rgRotate_left := 'Left';
  result.frmKey_cboTime_beforeXOR := 'Before XOR';
  result.frmKey_cboTime_afterXOR := 'After XOR';
  result.frmKey_SaveToFile_caption := 'Save key as';
  result.frmKey_LoadFromFile_caption := 'Load key';
  result.frmMct_Caption := 'TAG files generator';
  result.frmMct_lblTipo_Caption := 'Type';
  result.frmMct_lblDir_Caption := 'Directory';
  result.frmMct_lblFile_Caption := 'File';
  result.frmMct_lblToFile_Caption := 'to';
  result.frmMct_chkMultiple_Caption := 'Generate multiple files';
  result.frmMct_chkUseHex_Caption := 'Use hexadecimal values';
  result.frmMct_gbExample_Caption := 'Files to be played with the generated tags';
  result.frmMct_btnGenerate_Caption := 'Generate';
  result.frmMct_btnClose_Caption := 'Close';
  result.MESSAGES_FILES_GENERATED := 'Files generated successfully.';
  result.MESSAGES_FILE_NOT_FOUND := 'File not found: %s.';
  result.MESSAGES_SOURCE_DIR_NOT_FOUND := 'Source directory does not exists.';
  result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED := 'onvertion type not selected.';
  result.MESSAGES_REPLACE_FILES_WARNING := 'This will replace all %s files that could exists in the same directory as the source files. Do you want to continue?';
  result.MESSAGES_FILES_OF_TYPE_NOT_FOUND := 'No  %s files found to convert.';
  result.MESSAGES_CONVERTING_FILES := 'Processing files ...';
  result.MESSAGES_PLEASE_WAIT := 'Please wait ...';
  result.MESSAGES_CONVERTION_CANCELLED := 'Process cancelled, not all files were converted.';
  result.MESSAGES_CONVERSION_ENDED := 'Conversion ended successfully.';
  result.MESSAGES_SELECTED_FILE_DONT_EXISTS := 'The selected file does not exists.';
  result.MESSAGES_CONVERT := 'Convert';
  result.MESSAGES_CONVERT_TO := 'Convert to %s';
  result.MESSAGES_CONVERTING_FILE := 'Processing file ...';
  result.MESSAGES_OVERWRITE_PROMPT := 'File already exists, it will be overwritten. Do you want to continue?';
  result.MESSAGES_COULD_NOT_CREATE_STREAM := 'Could not create stream (%s)';
  result.MESSAGES_COULD_NOT_PLAY_FILE := 'Could not play stream (%s)';
  result.CAPTION_NORMALIZE_BEFORE := 'Normalize mp3 before conversion.';
  result.CAPTION_NORMALIZE_AFTER := 'Normalize resulting mp3.';
  result.CAPTION_ENCRYPT := 'Encrypt (.mp3 -> .smp)';
  result.CAPTION_DECRYPT := 'Decrypt (.smp -> .mp3)';
  result.CAPTION_NORMALIZING := 'Normalizing';
  result.CAPTION_PROCESSING := 'Processing';
  result.CAPTION_SELECT_DIR := 'Select directory';
  result.CAPTION_SAVE_TO := 'Save to';
end;

function InitLanguageSpa: TLanguage;
//Default language values (spa)
begin
  result.frmSmp2Mp3_caption := 'Convertidor SMP <-> MP3';
  result.gbSingleFile_caption := 'Convertir un solo archivo';
  result.btnConvertSingle_caption := 'Convertir';
  result.lblSOrigen_caption := 'Origen:';
  result.gbConvertBatch_caption := 'Convertir todos los archivos de un directorio';
  result.lblBOrigen_caption := 'Origen:';
  result.btnBatchConvert_caption := 'Convertir';
  result.chkNormalizar_caption := 'Normalizar';
  result.frmMct_Caption := 'Generador de archivos TAG';
  result.frmMct_lblTipo_Caption := 'Tipo';
  result.frmMct_lblDir_Caption := 'Directorio';
  result.frmMct_lblFile_Caption := 'Archivo';
  result.frmMct_lblToFile_Caption := 'al';
  result.frmMct_chkMultiple_Caption := 'Generar varios archivos';
  result.frmMct_chkUseHex_Caption := 'Usar hexadecimales';
  result.frmMct_gbExample_Caption := 'Ejemplo de archivos que se reproducen con estas etiquetas';
  result.frmMct_btnGenerate_Caption := 'Generar';
  result.frmMct_btnClose_Caption := 'Cerrar';
  result.MESSAGES_FILES_GENERATED := 'Los archivos fueron generados exitosamente';
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
  result.mnuChangeKey_other_caption := 'Otra...';
  result.mnuChangelanguage_caption := 'Cambiar idioma';
  result.mniGenerateMCT_caption := 'Generador archivos TAG';
  result.frmKey_caption := 'Cambiar clave';
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
  result.frmKey_SaveToFile_caption := 'Guardar Clave como';
  result.frmKey_LoadFromFile_caption := 'Cargar Clave';
end;

function CommaTextToXorKey (ACommaText : string) : TByteArray;
var
  lKeys : tstringlist;
  i : integer;
begin
  lKeys := TStringList.Create;
  try
    lKeys.CommaText := ACommaText;
    SetLength(Result,lKeys.Count);
    for i := 0 to lKeys.Count - 1 do
      Result[i] := StrToInt(lKeys[i]);
  finally
    lKeys.Free;
  end;
end;

function XorKeyToCommaText (AXORKey : TByteArray) : string;
var
  lKeys : tstringlist;
  i : integer;
begin
  lKeys := TStringList.Create;
  try
    for i := 0 to length(AXorKey) - 1 do
      lKeys.Add('0x' + IntToHex(AXorKey[i],2));
    result := lKeys.CommaText;
  finally
    lKeys.Free;
  end;
end;

procedure SaveKeyToFile(AFileName : string; AKey : TAlgorithm);
begin
  with TIniFile.Create(AFileName) do
  try
    WriteString('KEY','NAME',AKey.Name);
    WriteInteger('KEY','ROTATEDIRECTION',ord(AKey.RotateDirection));
    WriteInteger('KEY','ROTATETIME',ord(AKey.RotateTime));
    WriteInteger('KEY','ROTATECOUNT',AKey.RotateCount);
    WriteBool('KEY','CHANGEFILEEXT',AKey.ChangeFileExt);
    WriteString('KEY','XORKEY',XorKeyToCommaText(AKey.XorKey));
  finally
    Free;
  end;
end;

function LoadKeyFromFile(AFileName : string) : TAlgorithm;
begin
  with TIniFile.Create(AFileName) do
  try
    Result.Name := ReadString('KEY','NAME','');
    if result.Name = '' then
    begin
      result.Name := StripFileName(AFileName);
      WriteString('KEY','NAME',result.Name);
    end;
    Result.RotateDirection := TRotateDirection(ReadInteger('KEY','ROTATEDIRECTION',ord(rdNone)));
    Result.RotateTime := TRotateTime(ReadInteger('KEY','ROTATETIME',ord(rtBeforeXOR)));
    Result.RotateCount := ReadInteger('KEY','ROTATECOUNT',0);
    Result.ChangeFileExt := ReadBool('KEY','CHANGEFILEEXT',true);
    Result.XorKey := CommaTextToXorKey(ReadString('KEY','XORKEY','0x51,0x23,0x98,0x56'));
  finally
    Free;
  end;
end;

procedure FindFiles(ADirName : string; AFileExt: string; AOnFileFound : TFileFoundEvent);
//adds files to FFilesFound that are in ADirName and have the extension AFileExt
  //**************************************************************************//
  procedure lDoFile(AFilename : string);
  begin
    if (UpperCase(ExtractFileExt(AFilename)) = UpperCase(AFileExt)) then
    begin
      if assigned(AOnFileFound) then
        AOnFileFound(AFilename);
    end;
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
          lDoFile(ADirName + SearchRec.Name);
      end;
      while FindNext(SearchRec) = 0 do
      begin
        if Application.Terminated then
          exit;
        if (SearchRec.Name <> '.') and (SearchRec.Name <> '..') then
        begin
          if not (SearchRec.Attr and faDirectory > 0) then
            lDoFile(ADirName + SearchRec.Name);
        end;
      end;
    end;
  finally
    Sysutils.FindClose(SearchRec);
  end;
end;


end.
