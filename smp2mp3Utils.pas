unit smp2mp3Utils;

interface

uses
  Menus, Classes;

type
  TFileFoundEvent = procedure(AFilename : string) of object;

  TRotateDirection = (rdNone, rdRight, rdLeft);
  TRotateTime = (rtBeforeXOR, rtAfterXOR);
  TByteArray = array of Byte;

  TOperationType = (otNone = -1, otXOR = 0, otRotate = 1);

  TAlgorithmOperation = record
    OperationType : TOperationType;
    XorKey : TByteArray;
    RotateDirection : TRotateDirection;
    RotateCount : byte;
  end;

  TAlgorithmOperationArray = array of TAlgorithmOperation;

  TAlgorithm = record
    Name : string;
    Operations : TAlgorithmOperationArray;
    SourceExt : string;
    DestExt : string;
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
    frmKey_SaveToFile_caption : string;
    frmKey_LoadFromFile_caption : string;
    frmKey_lblOperations_caption : string;
    frmKey_lblSourceExt_caption : string;
    frmKey_lblDestExt_caption : string;
    fraOperation_lblXORkey_caption : string;
    fraOperation_lblRotateTimes_caption : string;
    fraOperation_lblRotateDirection_caption : string;
    fraOperation_rbRotate_right : string;
    fraOperation_rbRotate_left : string;
    fraOperation_XOR : string;
    fraOperation_Rotate : string;
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
    CAPTION_FIRST : string;
    CAPTION_THEN : string;
    CAPTION_DO : string;
    CAPTION_FINALLY : string;
  end;


procedure FindFiles(ADirName : string; AFileExt: string; AOnFileFound : TFileFoundEvent);
function AlgorithmHasRotation(AnAlgorithm : TAlgorithm) : boolean;
procedure AddOperationToAlgorithm(var vAlgorithm : TAlgorithm; AnOperationType : TOperationType;
    aXorKey : TByteArray; aRotateDirection : TRotateDirection; aRotateCount : integer); overload;
procedure AddOperationToAlgorithm(var vAlgorithm : TAlgorithm; AnOperation : TAlgorithmOperation); overload;
function LoadKeyFromFile(AFileName : string) : TAlgorithm;
procedure SaveKeyToFile(AFileName : string; AnAlgorithm : TAlgorithm);
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
  SysUtils, Forms, IniFiles, Contnrs, StrUtils, Windows, Dialogs;

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
    WriteString('frmSmp2Mp3'                      ,'CAPTION'                      ,ALanguage.frmSmp2Mp3_caption                       );
    WriteString('gbSingleFile'                    ,'CAPTION'                      ,Alanguage.gbSingleFile_caption                     );
    WriteString('btnConvertSingle'                ,'CAPTION'                      ,Alanguage.btnConvertSingle_caption                 );
    WriteString('lblSOrigen'                      ,'CAPTION'                      ,Alanguage.lblSOrigen_caption                       );
    WriteString('gbConvertBatch'                  ,'CAPTION'                      ,Alanguage.gbConvertBatch_caption                   );
    WriteString('lblBOrigen'                      ,'CAPTION'                      ,Alanguage.lblBOrigen_caption                       );
    WriteString('btnBatchConvert'                 ,'CAPTION'                      ,Alanguage.btnBatchConvert_caption                  );
    WriteString('chkNormalizar'                   ,'CAPTION'                      ,Alanguage.chkNormalizar_caption                    );
    WriteString('mnuConfig'                       ,'CAPTION'                      ,ALanguage.mnuConfig_caption                        );
    WriteString('mnuChangeKey'                    ,'CAPTION'                      ,ALanguage.mnuChangeKey_caption                     );
    WriteString('mnuChangeKey_other'              ,'CAPTION'                      ,ALanguage.mnuChangeKey_other_caption               );
    WriteString('mnuChangelanguage'               ,'CAPTION'                      ,ALanguage.mnuChangelanguage_caption                );
    WriteString('mniGenerateMCT'                  ,'CAPTION'                      ,ALanguage.mniGenerateMCT_caption                   );

    WriteString('frmKey'                          ,'CAPTION'                      ,ALanguage.frmKey_caption                           );
    WriteString('frmKey_btnOK'                    ,'CAPTION'                      ,ALanguage.frmKey_btnOK_caption                     );
    WriteString('frmKey_btnCancel'                ,'CAPTION'                      ,ALanguage.frmKey_btnCancel_caption                 );
    WriteString('frmKey_SaveToFile'               ,'CAPTION'                      ,ALanguage.frmKey_SaveToFile_caption                );
    WriteString('frmKey_LoadFromFile'             ,'CAPTION'                      ,ALanguage.frmKey_LoadFromFile_caption              );
    WriteString('frmKey_lblOperations'            ,'CAPTION'                      ,ALanguage.frmKey_lblOperations_caption             );
    WriteString('frmKey_lblSourceExt'             ,'CAPTION'                      ,ALanguage.frmKey_lblSourceExt_caption              );
    WriteString('frmKey_lblDestExt'               ,'CAPTION'                      ,ALanguage.frmKey_lblDestExt_caption                );
    WriteString('fraOperation_lblXORkey'          ,'CAPTION'                      ,ALanguage.fraOperation_lblXORkey_caption           );
    WriteString('fraOperation_lblRotateTimes'     ,'CAPTION'                      ,ALanguage.fraOperation_lblRotateTimes_caption      );
    WriteString('fraOperation_lblRotateDirection' ,'CAPTION'                      ,ALanguage.fraOperation_lblRotateDirection_caption  );
    WriteString('fraOperation_rbRotate_right'     ,'CAPTION'                      ,ALanguage.fraOperation_rbRotate_right              );
    WriteString('fraOperation_rbRotate_left'      ,'CAPTION'                      ,ALanguage.fraOperation_rbRotate_left               );
    WriteString('fraOperation_XOR'                ,'CAPTION'                      ,ALanguage.fraOperation_XOR                         );
    WriteString('fraOperation_Rotate'             ,'CAPTION'                      ,ALanguage.fraOperation_Rotate                      );

    WriteString('frmMct_Caption'                  ,'CAPTION'                      ,ALanguage.frmMct_Caption                           );
    WriteString('frmMct_lblTipo'                  ,'CAPTION'                      ,ALanguage.frmMct_lblTipo_Caption                   );
    WriteString('frmMct_lblDir'                   ,'CAPTION'                      ,ALanguage.frmMct_lblDir_Caption                    );
    WriteString('frmMct_lblFile'                  ,'CAPTION'                      ,ALanguage.frmMct_lblFile_Caption                   );
    WriteString('frmMct_lblToFile'                ,'CAPTION'                      ,ALanguage.frmMct_lblToFile_Caption                 );
    WriteString('frmMct_chkMultiple'              ,'CAPTION'                      ,ALanguage.frmMct_chkMultiple_Caption               );
    WriteString('frmMct_chkUseHex'                ,'CAPTION'                      ,ALanguage.frmMct_chkUseHex_Caption                 );
    WriteString('frmMct_gbExample'                ,'CAPTION'                      ,ALanguage.frmMct_gbExample_Caption                 );
    WriteString('frmMct_btnGenerate'              ,'CAPTION'                      ,ALanguage.frmMct_btnGenerate_Caption               );
    WriteString('frmMct_btnClose'                 ,'CAPTION'                      ,ALanguage.frmMct_btnClose_Caption                  );
    WriteString('MESSAGES'                        ,'FILES_GENERATED'              ,ALanguage.MESSAGES_FILES_GENERATED                 );
    WriteString('MESSAGES'                        ,'FILE_NOT_FOUND'               ,Alanguage.MESSAGES_FILE_NOT_FOUND                  );
    WriteString('MESSAGES'                        ,'SOURCE_DIR_NOT_FOUND'         ,Alanguage.MESSAGES_SOURCE_DIR_NOT_FOUND            );
    WriteString('MESSAGES'                        ,'CONVERTION_TYPE_NOT_SELECTED' ,Alanguage.MESSAGES_CONVERTION_TYPE_NOT_SELECTED    );
    WriteString('MESSAGES'                        ,'REPLACE_FILES_WARNING'        ,Alanguage.MESSAGES_REPLACE_FILES_WARNING           );
    WriteString('MESSAGES'                        ,'FILES_OF_TYPE_NOT_FOUND'      ,Alanguage.MESSAGES_FILES_OF_TYPE_NOT_FOUND         );
    WriteString('MESSAGES'                        ,'CONVERTING_FILES'             ,Alanguage.MESSAGES_CONVERTING_FILES                );
    WriteString('MESSAGES'                        ,'PLEASE_WAIT'                  ,Alanguage.MESSAGES_PLEASE_WAIT                     );
    WriteString('MESSAGES'                        ,'CONVERTION_CANCELLED'         ,Alanguage.MESSAGES_CONVERTION_CANCELLED            );
    WriteString('MESSAGES'                        ,'CONVERSION_ENDED'             ,Alanguage.MESSAGES_CONVERSION_ENDED                );
    WriteString('MESSAGES'                        ,'SELECTED_FILE_DONT_EXISTS'    ,Alanguage.MESSAGES_SELECTED_FILE_DONT_EXISTS       );
    WriteString('MESSAGES'                        ,'CONVERT'                      ,Alanguage.MESSAGES_CONVERT                         );
    WriteString('MESSAGES'                        ,'CONVERT_TO'                   ,Alanguage.MESSAGES_CONVERT_TO                      );
    WriteString('MESSAGES'                        ,'CONVERTING_FILE'              ,Alanguage.MESSAGES_CONVERTING_FILE                 );
    WriteString('MESSAGES'                        ,'OVERWRITE_PROMPT'             ,Alanguage.MESSAGES_OVERWRITE_PROMPT                );
    WriteString('MESSAGES'                        ,'COULD_NOT_CREATE_STREAM'      ,Alanguage.MESSAGES_COULD_NOT_CREATE_STREAM         );
    WriteString('MESSAGES'                        ,'COULD_NOT_PLAY_FILE'          ,Alanguage.MESSAGES_COULD_NOT_PLAY_FILE             );
    WriteString('CAPTION'                         ,'NORMALIZE_BEFORE'             ,ALanguage.CAPTION_NORMALIZE_BEFORE                 );
    WriteString('CAPTION'                         ,'NORMALIZE_AFTER'              ,ALanguage.CAPTION_NORMALIZE_AFTER                  );
    WriteString('CAPTION'                         ,'ENCRYPT'                      ,ALanguage.CAPTION_ENCRYPT                          );
    WriteString('CAPTION'                         ,'DECRYPT'                      ,ALanguage.CAPTION_DECRYPT                          );
    WriteString('CAPTION'                         ,'NORMALIZING'                  ,ALanguage.CAPTION_NORMALIZING                      );
    WriteString('CAPTION'                         ,'PROCESSING'                   ,ALanguage.CAPTION_PROCESSING                       );
    WriteString('CAPTION'                         ,'SAVE_AS'                      ,ALanguage.CAPTION_SELECT_DIR                       );
    WriteString('CAPTION'                         ,'SAVE_TO'                      ,ALanguage.CAPTION_SAVE_TO                          );
    WriteString('CAPTION'                         ,'FIRST'                        ,ALanguage.CAPTION_FIRST                            );
    WriteString('CAPTION'                         ,'THEN'                         ,ALanguage.CAPTION_THEN                             );
    WriteString('CAPTION'                         ,'DO'                           ,ALanguage.CAPTION_DO                               );
    WriteString('CAPTION'                         ,'FINALLY'                      ,ALanguage.CAPTION_FINALLY                          );
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

    Result.frmKey_caption                          := ReadString('frmKey'                          ,'CAPTION'                      ,Result.frmKey_caption                           );
    Result.frmKey_btnOK_caption                    := ReadString('frmKey_btnOK'                    ,'CAPTION'                      ,Result.frmKey_btnOK_caption                     );
    Result.frmKey_btnCancel_caption                := ReadString('frmKey_btnCancel'                ,'CAPTION'                      ,Result.frmKey_btnCancel_caption                 );
    Result.frmKey_SaveToFile_caption               := ReadString('frmKey_SaveToFile'               ,'CAPTION'                      ,Result.frmKey_SaveToFile_caption                );
    Result.frmKey_LoadFromFile_caption             := ReadString('frmKey_LoadFromFile'             ,'CAPTION'                      ,Result.frmKey_LoadFromFile_caption              );
    Result.frmKey_lblOperations_caption            := ReadString('frmKey_lblOperations'            ,'CAPTION'                      ,Result.frmKey_lblOperations_caption             );
    Result.frmKey_lblSourceExt_caption             := ReadString('frmKey_lblSourceExt'             ,'CAPTION'                      ,Result.frmKey_lblSourceExt_caption              );
    Result.frmKey_lblDestExt_caption               := ReadString('frmKey_lblDestExt'               ,'CAPTION'                      ,Result.frmKey_lblDestExt_caption                );
    Result.fraOperation_lblXORkey_caption          := ReadString('fraOperation_lblXORkey'          ,'CAPTION'                      ,Result.fraOperation_lblXORkey_caption           );
    Result.fraOperation_lblRotateTimes_caption     := ReadString('fraOperation_lblRotateTimes'     ,'CAPTION'                      ,Result.fraOperation_lblRotateTimes_caption      );
    Result.fraOperation_lblRotateDirection_caption := ReadString('fraOperation_lblRotateDirection' ,'CAPTION'                      ,Result.fraOperation_lblRotateDirection_caption  );
    Result.fraOperation_rbRotate_right             := ReadString('fraOperation_rbRotate_right'     ,'CAPTION'                      ,Result.fraOperation_rbRotate_right              );
    Result.fraOperation_rbRotate_left              := ReadString('fraOperation_rbRotate_left'      ,'CAPTION'                      ,Result.fraOperation_rbRotate_left               );
    Result.fraOperation_XOR                        := ReadString('fraOperation_XOR'                ,'CAPTION'                      ,Result.fraOperation_XOR                         );
    Result.fraOperation_Rotate                     := ReadString('fraOperation_Rotate'             ,'CAPTION'                      ,Result.fraOperation_Rotate                      );


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
    result.CAPTION_FIRST                           := ReadString('CAPTION'                     ,'FIRST'                        ,result.CAPTION_FIRST                           );
    result.CAPTION_THEN                            := ReadString('CAPTION'                     ,'THEN'                         ,result.CAPTION_THEN                            );
    result.CAPTION_DO                              := ReadString('CAPTION'                     ,'DO'                           ,result.CAPTION_DO                              );
    result.CAPTION_FINALLY                         := ReadString('CAPTION'                     ,'FINALLY'                      ,result.CAPTION_FINALLY                         );
  finally
    Free;
  end;
end;

function InitLanguageEng: TLanguage;
//Default language values (eng)
begin
  result.frmSmp2Mp3_caption                      := 'SMP <-> MP3 converter';
  result.gbSingleFile_caption                    := 'Convert a single file';
  result.btnConvertSingle_caption                := 'Convert';
  result.lblSOrigen_caption                      := 'Source:';
  result.gbConvertBatch_caption                  := 'Convert all files in a directory';
  result.lblBOrigen_caption                      := 'Source:';
  result.btnBatchConvert_caption                 := 'Convert';
  result.chkNormalizar_caption                   := 'Normalize';
  result.mnuConfig_caption                       := 'Configuration';
  result.mnuChangeKey_caption                    := 'Change encryption algorithm';
  result.mnuChangeKey_other_caption              := 'Other...';
  result.mnuChangelanguage_caption               := 'Change language';
  result.mniGenerateMCT_caption                  := 'TAG file generator';
  Result.frmKey_caption                          := 'Change encryption algorithm';
  Result.frmKey_btnOK_caption                    := 'OK';
  Result.frmKey_btnCancel_caption                := 'Cancel';
  Result.frmKey_SaveToFile_caption               := 'Save encryption algorithm as';
  Result.frmKey_LoadFromFile_caption             := 'Load encryption algorithm';
  Result.frmKey_lblOperations_caption            := 'Operations:';
  Result.frmKey_lblSourceExt_caption             := 'Source ext.:';
  Result.frmKey_lblDestExt_caption               := 'Dest. ext.:';
  Result.fraOperation_lblXORkey_caption          := 'XOR key';
  Result.fraOperation_lblRotateTimes_caption     := 'Times';
  Result.fraOperation_lblRotateDirection_caption := 'Direction';
  Result.fraOperation_rbRotate_right             := 'Right';
  Result.fraOperation_rbRotate_left              := 'Left';
  Result.fraOperation_XOR                        := 'XOR';
  Result.fraOperation_Rotate                     := 'Bit rotation';
  result.frmMct_Caption                          := 'TAG files generator';
  result.frmMct_lblTipo_Caption                  := 'Type';
  result.frmMct_lblDir_Caption                   := 'Directory';
  result.frmMct_lblFile_Caption                  := 'File';
  result.frmMct_lblToFile_Caption                := 'to';
  result.frmMct_chkMultiple_Caption              := 'Generate multiple files';
  result.frmMct_chkUseHex_Caption                := 'Use hexadecimal values';
  result.frmMct_gbExample_Caption                := 'Files to be played with the generated tags';
  result.frmMct_btnGenerate_Caption              := 'Generate';
  result.frmMct_btnClose_Caption                 := 'Close';
  result.MESSAGES_FILES_GENERATED                := 'Files generated successfully.';
  result.MESSAGES_FILE_NOT_FOUND                 := 'File not found: %s.';
  result.MESSAGES_SOURCE_DIR_NOT_FOUND           := 'Source directory does not exists.';
  result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   := 'onvertion type not selected.';
  result.MESSAGES_REPLACE_FILES_WARNING          := 'This will replace all %s files that could exists in the same directory as the source files. Do you want to continue?';
  result.MESSAGES_FILES_OF_TYPE_NOT_FOUND        := 'No  %s files found to convert.';
  result.MESSAGES_CONVERTING_FILES               := 'Processing files ...';
  result.MESSAGES_PLEASE_WAIT                    := 'Please wait ...';
  result.MESSAGES_CONVERTION_CANCELLED           := 'Process cancelled, not all files were converted.';
  result.MESSAGES_CONVERSION_ENDED               := 'Conversion ended successfully.';
  result.MESSAGES_SELECTED_FILE_DONT_EXISTS      := 'The selected file does not exists.';
  result.MESSAGES_CONVERT                        := 'Convert';
  result.MESSAGES_CONVERT_TO                     := 'Convert to %s';
  result.MESSAGES_CONVERTING_FILE                := 'Processing file ...';
  result.MESSAGES_OVERWRITE_PROMPT               := 'File already exists, it will be overwritten. Do you want to continue?';
  result.MESSAGES_COULD_NOT_CREATE_STREAM        := 'Could not create stream (%s)';
  result.MESSAGES_COULD_NOT_PLAY_FILE            := 'Could not play stream (%s)';
  result.CAPTION_NORMALIZE_BEFORE                := 'Normalize mp3 before conversion.';
  result.CAPTION_NORMALIZE_AFTER                 := 'Normalize resulting mp3.';
  result.CAPTION_ENCRYPT                         := 'Encrypt';
  result.CAPTION_DECRYPT                         := 'Decrypt';
  result.CAPTION_NORMALIZING                     := 'Normalizing';
  result.CAPTION_PROCESSING                      := 'Processing';
  result.CAPTION_SELECT_DIR                      := 'Select directory';
  result.CAPTION_SAVE_TO                         := 'Save to';
  result.CAPTION_FIRST                           := 'First';
  result.CAPTION_THEN                            := 'Then';
  result.CAPTION_DO                              := 'Do';
  result.CAPTION_FINALLY                         := 'Finally';
end;

function InitLanguageSpa: TLanguage;
//Default language values (spa)
begin
  result.frmSmp2Mp3_caption                      := 'Convertidor SMP <-> MP3';
  result.gbSingleFile_caption                    := 'Convertir un solo archivo';
  result.btnConvertSingle_caption                := 'Convertir';
  result.lblSOrigen_caption                      := 'Origen:';
  result.gbConvertBatch_caption                  := 'Convertir todos los archivos de un directorio';
  result.lblBOrigen_caption                      := 'Origen:';
  result.btnBatchConvert_caption                 := 'Convertir';
  result.chkNormalizar_caption                   := 'Normalizar';
  result.frmMct_Caption                          := 'Generador de archivos TAG';
  result.frmMct_lblTipo_Caption                  := 'Tipo';
  result.frmMct_lblDir_Caption                   := 'Directorio';
  result.frmMct_lblFile_Caption                  := 'Archivo';
  result.frmMct_lblToFile_Caption                := 'al';
  result.frmMct_chkMultiple_Caption              := 'Generar varios archivos';
  result.frmMct_chkUseHex_Caption                := 'Usar hexadecimales';
  result.frmMct_gbExample_Caption                := 'Ejemplo de archivos que se reproducen con estas etiquetas';
  result.frmMct_btnGenerate_Caption              := 'Generar';
  result.frmMct_btnClose_Caption                 := 'Cerrar';
  result.MESSAGES_FILES_GENERATED                := 'Los archivos fueron generados exitosamente';
  result.MESSAGES_FILE_NOT_FOUND                 := 'No se encuentra el archivo: %s.';
  result.MESSAGES_SOURCE_DIR_NOT_FOUND           := 'No existe el directorio origen.';
  result.MESSAGES_CONVERTION_TYPE_NOT_SELECTED   := 'No se ha seleccionado el tipo de conversión.';
  result.MESSAGES_REPLACE_FILES_WARNING          := 'Este proceso reemplazará los archivos %s que puedan existir en el mismo directorio en que se encuentran los archivos origen. ¿Aún así desea continuar?';
  result.MESSAGES_FILES_OF_TYPE_NOT_FOUND        := 'No se encontraron archivos %s a convertir.';
  result.MESSAGES_CONVERTING_FILES               := 'Convirtiendo archivos ...';
  result.MESSAGES_PLEASE_WAIT                    := 'Por favor espere ...';
  result.MESSAGES_CONVERTION_CANCELLED           := 'Se cancelo el proceso, no todos los archivos fueron convertidos.';
  result.MESSAGES_CONVERSION_ENDED               := 'La conversión ha terminado.';
  result.MESSAGES_SELECTED_FILE_DONT_EXISTS      := 'El archivo seleccionado no existe.';
  result.MESSAGES_CONVERT                        := 'Convertir';
  result.MESSAGES_CONVERT_TO                     := 'Convertir a %s';
  result.MESSAGES_CONVERTING_FILE                := 'Convirtiendo archivo ...';
  result.MESSAGES_OVERWRITE_PROMPT               := 'El archivo destino ya existe, si continua se sobreescribirá su contenido. ¿Aún así desea continuar?';
  result.MESSAGES_COULD_NOT_CREATE_STREAM        := 'No fué posible crear el stream (%s)';
  result.MESSAGES_COULD_NOT_PLAY_FILE            := 'No se le pudo dar play (%s)';
  result.CAPTION_NORMALIZE_BEFORE                := 'Normalizar mp3 antes de convertirlo';
  result.CAPTION_NORMALIZE_AFTER                 := 'Normalizar mp3 resultante.';
  result.CAPTION_ENCRYPT                         := 'Encriptar';
  result.CAPTION_DECRYPT                         := 'Desencriptar';
  result.CAPTION_NORMALIZING                     := 'Normalizando';
  result.CAPTION_PROCESSING                      := 'Procesando';
  result.CAPTION_SELECT_DIR                      := 'Seleccionar directorio';
  result.CAPTION_SAVE_TO                         := 'Guardar en';
  result.CAPTION_FIRST                           := 'Primero';
  result.CAPTION_THEN                            := 'Después';
  result.CAPTION_DO                              := 'Hacer';
  result.CAPTION_FINALLY                         := 'Finalmente';
  result.mnuConfig_caption                       := 'Configuración';
  result.mnuChangeKey_caption                    := 'Cambiar algoritmo de encriptación';
  result.mnuChangeKey_other_caption              := 'Otra...';
  result.mnuChangelanguage_caption               := 'Cambiar idioma';
  result.mniGenerateMCT_caption                  := 'Generador archivos TAG';
  Result.frmKey_caption                          := 'Cambiar algoritmo de encriptación';
  Result.frmKey_btnOK_caption                    := 'Aceptar';
  Result.frmKey_btnCancel_caption                := 'Cancelar';
  Result.frmKey_SaveToFile_caption               := 'Guardar algoritmo de encriptación como';
  Result.frmKey_LoadFromFile_caption             := 'Cargar algoritmo de encriptación';
  Result.frmKey_lblOperations_caption            := 'Operaciones:';
  Result.frmKey_lblSourceExt_caption             := 'Ext. origen:';
  Result.frmKey_lblDestExt_caption               := 'Ext. destino:';
  Result.fraOperation_lblXORkey_caption          := 'Llave XOR';
  Result.fraOperation_lblRotateTimes_caption     := 'Veces';
  Result.fraOperation_lblRotateDirection_caption := 'Dirección';
  Result.fraOperation_rbRotate_right             := 'Derecha';
  Result.fraOperation_rbRotate_left              := 'Izquierda';
  Result.fraOperation_XOR                        := 'XOR';
  Result.fraOperation_Rotate                     := 'Rotar bits';
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

function AlgorithmHasRotation(AnAlgorithm : TAlgorithm) : boolean;
var
  i : integer;
begin
  result := false;
  for i := 0 to Length(AnAlgorithm.Operations) - 1 do
  begin
    if AnAlgorithm.Operations[i].OperationType = otRotate then
    begin
      Result := true;
      exit;
    end;
  end;
end;

procedure SaveKeyToFile(AFileName : string; AnAlgorithm : TAlgorithm);
var
  i : integer;
  lSectionname : string;
  lSections : TStringList;
begin
  with TIniFile.Create(AFileName) do
  try
    WriteString('ALGORITHM','NAME',AnAlgorithm.Name);
    WriteString('ALGORITHM','SOURCEEXT',AnAlgorithm.SourceExt);
    WriteString('ALGORITHM','DESTEXT',AnAlgorithm.DestExt);
    WriteInteger('ALGORITHM','OPERATIONSCOUNT',length(AnAlgorithm.Operations));
    lSections := TStringList.Create;
    try
      ReadSections(lSections);
      for i := 0 to lSections.Count - 1 do
      begin
        if UpperCase(LeftStr(lSections[i],9)) = 'OPERATION' then
          EraseSection(lSections[i]);
      end;
    finally
      lSections.Free;
    end;
    for i := 0 to length(AnAlgorithm.Operations) - 1 do
    begin
      lSectionname := 'OPERATION' + IntToStr(i);
      WriteInteger(lSectionname,'TYPE',ord(AnAlgorithm.Operations[i].OperationType));
      WriteInteger(lSectionname,'ROTATEDIRECTION',ord(AnAlgorithm.Operations[i].RotateDirection));
      WriteInteger(lSectionname,'ROTATECOUNT',AnAlgorithm.Operations[i].RotateCount);
      WriteString(lSectionname,'XORKEY',XorKeyToCommaText(AnAlgorithm.Operations[i].XorKey));
    end;
  finally
    Free;
  end;
end;

procedure AddOperationToAlgorithm(var vAlgorithm : TAlgorithm; AnOperationType : TOperationType;
    aXorKey : TByteArray; aRotateDirection : TRotateDirection; aRotateCount : integer); overload;
var
  lOperation : TAlgorithmOperation;
begin
  lOperation.OperationType := AnOperationType;
  lOperation.XorKey := aXorKey;
  lOperation.RotateDirection := aRotateDirection;
  lOperation.RotateCount := aRotateCount;
  AddOperationToAlgorithm(vAlgorithm,lOperation);
end;

procedure AddOperationToAlgorithm(var vAlgorithm : TAlgorithm; AnOperation : TAlgorithmOperation); overload;
var
  lIndex : integer;
begin
  lIndex := Length(vAlgorithm.Operations);
  SetLength(vAlgorithm.Operations,lIndex + 1);
  vAlgorithm.Operations[lIndex] := AnOperation;
end;

function LoadKeyFromFile(AFileName : string) : TAlgorithm;
var
  lOperationType : TOperationType;
  lRotateDirection : TRotateDirection;
  lRotateCount : integer;
  lXORKey : TByteArray;
  lOperationsCount : integer;
  i: integer;
  lSectionname : string;
begin
  setlength(result.Operations,0);
  with TIniFile.Create(AFileName) do
  try
    if SectionExists('KEY') then
    //read old algorithm format ant convert to new format
    begin
      Result.Name := ReadString('KEY','NAME',StripFileName(AFileName));
      result.DestExt := '.smp';
      if ReadBool('KEY','CHANGEFILEEXT',true) then
        result.SourceExt := '.mp3'
      else
        result.SourceExt := '.smp';
      lRotateDirection := TRotateDirection(ReadInteger('KEY','ROTATEDIRECTION',ord(rdNone)));
      if (lRotateDirection <> rdNone) and
        ((TRotateTime(ReadInteger('KEY','ROTATETIME',ord(rtBeforeXOR))) = rtBeforeXOR)) then
        AddOperationToAlgorithm(result,otRotate,CommaTextToXorKey(''),lRotateDirection,ReadInteger('KEY','ROTATECOUNT',0));
      AddOperationToAlgorithm(result,otXOR,CommaTextToXorKey(ReadString('KEY','XORKEY','')),rdNone,0);
      if (lRotateDirection <> rdNone) and
        ((TRotateTime(ReadInteger('KEY','ROTATETIME',ord(rtBeforeXOR))) = rtAfterXOR)) then
        AddOperationToAlgorithm(result,otRotate,CommaTextToXorKey(''),lRotateDirection,ReadInteger('KEY','ROTATECOUNT',0));
      EraseSection('KEY');
      SaveKeyToFile(FileName,Result);
      exit;
    end;

    result.Name := ReadString('ALGORITHM','NAME','');
    if result.Name = '' then
    begin
      result.Name := StripFileName(AFileName);
      WriteString('ALGORITHM','NAME',result.Name);
    end;
    lOperationsCount := ReadInteger('ALGORITHM','OPERATIONSCOUNT',0);
    result.SourceExt := ReadString('ALGORITHM','SOURCEEXT','.mp3');
    result.DestExt := ReadString('ALGORITHM','DESTEXT','.smp');
    for i := 0 to lOperationsCount - 1 do
    begin
      lSectionname := 'OPERATION' + IntToStr(i);
      if SectionExists(lSectionname) then
      begin
        lOperationType := TOperationType(ReadInteger(lSectionname,'TYPE',-1));
        lRotateDirection := TRotateDirection(ReadInteger(lSectionname,'ROTATEDIRECTION',ord(rdNone)));
        lRotateCount := ReadInteger(lSectionname,'ROTATECOUNT',0);
        lXorKey := CommaTextToXorKey(ReadString(lSectionname,'XORKEY',''));
        AddOperationToAlgorithm(result,lOperationType,lXORKey,lRotateDirection,lRotateCount);
      end
      else
      begin
        setlength(result.Operations,0);
        MessageDlg('Algorithm file is not valid.', mtError, [mbOK], 0);
        exit;
      end;
    end;
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
