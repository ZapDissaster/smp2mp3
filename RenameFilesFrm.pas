unit RenameFilesFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, StdCtrls, smp2mp3Utils;

type
  TFrmRenameFiles = class(TForm)
    lbFiles: TListBox;
    btnRename: TButton;
    lblFirstFileName: TLabel;
    edFirstFilename: TEdit;
    sbAddFile: TSpeedButton;
    sbDeleteFile: TSpeedButton;
    sbShuffle: TSpeedButton;
    sbMoveUp: TSpeedButton;
    sbMoveDown: TSpeedButton;
    chkShowPreview: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure sbDeleteFileClick(Sender: TObject);
    procedure sbAddFileClick(Sender: TObject);
    procedure sbMoveUpClick(Sender: TObject);
    procedure sbMoveDownClick(Sender: TObject);
    procedure sbShuffleClick(Sender: TObject);
    procedure btnRenameClick(Sender: TObject);
    procedure edFirstFilenameChange(Sender: TObject);
    procedure chkShowPreviewClick(Sender: TObject);
  private
    FLanguage: TLanguage;
    procedure SetLanguage(const Value: TLanguage);
    procedure AddFile(AFileName : string);
    procedure ExchangeItems(AFromIndex, AToIndex : integer);
    function NextSerial(AFromSerial: string; AnIncrement : integer = 1): string;
    function HasInteger(AString: string): boolean;
    procedure DecodeSerial(ASerial : string; out oPrefix : string; out oNumber : string; out oSufix : string);
    procedure ShowRenameResult;
    function FilenameWithoutResult(AFilename : string) : string;
    { Private declarations }
  protected
    procedure WMDropFiles(var Msg: TWMDropFiles); message wm_DropFiles;
  public
    { Public declarations }
    property Language : TLanguage read FLanguage write SetLanguage;
  end;

var
  FrmRenameFiles: TFrmRenameFiles;

implementation

uses
  ShellAPI, StrUtils, Math;

{$R *.dfm}

{ TFrmRenameFiles }

procedure TFrmRenameFiles.AddFile(AFileName: string);
begin
  if lbFiles.Items.IndexOf(AFileName) = -1 then
    lbFiles.Items.Add(AFileName);
  ShowRenameResult;
end;

procedure TFrmRenameFiles.btnRenameClick(Sender: TObject);
var
  i: Integer;
  lCurrentSerial : string;
  lFilePath : string;
  lFileExt : string;
  lFilename : string;
  lNewFileName : string;
begin

  if (edFirstFilename.Text = '') or (not HasInteger(edFirstFilename.Text)) then
  begin
    MessageDlg(Language.MESSAGES_frmRenameFiles_INVALID_SERIAL, mtError, [mbOK], 0);
    exit;
  end
  else
  begin
    if MessageDlg(Language.MESSAGES_frmRenameFiles_RENAME_WARNING, mtWarning, [mbYes, mbNo], 0) = mrNo then
    exit;
  end;
  lCurrentSerial := StripFileName(edFirstFilename.Text);
  for i := 0 to lbFiles.Count - 1 do
  begin
    lFilename := FilenameWithoutResult(lbFiles.Items.Strings[i]);
    lFilePath := ExtractFilePath(lFilename);
    lFileExt := ExtractFileExt(lFilename);
    lNewFileName := lFilePath + lCurrentSerial + lFileExt;
    RenameFile(lFilename,lNewFileName);
    lCurrentSerial := NextSerial(lCurrentSerial);
  end;
  MessageDlg(Language.MESSAGES_frmRenameFiles_RENAME_SUCCESS, mtInformation, [mbOK], 0);
  close;
end;

procedure TFrmRenameFiles.chkShowPreviewClick(Sender: TObject);
begin
  ShowRenameResult;
end;

procedure TFrmRenameFiles.DecodeSerial(ASerial : string; out oPrefix : string; out oNumber : string;
    out oSufix : string);
var
  i, lLastNumberStart, lLastNumberEnd : integer;
begin
  lLastNumberStart := 0;
  lLastNumberEnd := 0;
  ASerial := trim(ASerial);
  if HasInteger(ASerial) then
  begin
    for i := length(ASerial) downto 1 do
      if ASerial[i] in ['0'..'9'] then
      begin
        lLastNumberEnd := i;
        lLastNumberStart := i;
        break;
      end;
    i := lLastNumberStart - 1;
    while (i >= 1) and (ASerial[i] in ['0'..'9']) do
    begin
      lLastNumberStart := i;
      dec(i);
    end;

    oPrefix := LeftStr(ASerial,lLastNumberStart - 1);
    oSufix := RightStr(ASerial,length(ASerial) - lLastNumberEnd);
    oNumber := Copy(ASerial,lLastNumberStart,lLastNumberEnd - (lLastNumberStart - 1));
  end;
end;

procedure TFrmRenameFiles.edFirstFilenameChange(Sender: TObject);
begin
  ShowRenameResult;
end;

procedure TFrmRenameFiles.ExchangeItems(AFromIndex, AToIndex: integer);
var
  lTmp : string;
begin
  if (AFromIndex < 0) or (AToIndex < 0) or
     (AFromIndex >= lbFiles.Count) or (AToIndex >= lbFiles.Count) then
    exit;
  lTmp := lbFiles.Items.Strings[AFromIndex];
  lbFiles.Items.Strings[AFromIndex] := lbFiles.Items.Strings[AToIndex];
  lbFiles.Items.Strings[AToIndex] := lTmp;
  lbFiles.ItemIndex := AToIndex;
  ShowRenameResult;
end;

procedure TFrmRenameFiles.FormCreate(Sender: TObject);
begin
  DragAcceptFiles(Self.Handle,true);
end;

procedure TFrmRenameFiles.FormDestroy(Sender: TObject);
begin
  DragAcceptFiles(Self.Handle,false);
end;

function TFrmRenameFiles.HasInteger(AString: string): boolean;
var
  i : integer;
begin
  result := false;
  for i := 1 to length(AString) do
    if AString[i] in ['0'..'9'] then
    begin
      result := true;
      exit;
    end;
end;

function TFrmRenameFiles.FilenameWithoutResult(AFilename: string): string;
var
  lPos : integer;
begin
  lPos := pos(' --> ',AFilename);
  if lPos > 0 then
    Result := LeftStr(AFilename, lPos - 1)
  else
    Result := AFilename;
end;

function TFrmRenameFiles.NextSerial(AFromSerial: string;
    AnIncrement : integer = 1): string;
var
  lPrefix, lNumber ,lSufix : string;
  lIntNumber : integer;
begin
  AFromSerial := trim(AFromSerial);
  if HasInteger(AFromSerial) then
  begin
    DecodeSerial(AFromSerial,lPrefix,lNumber,lSufix);
    lIntNumber := StrToInt(lNumber);
    Inc(lIntNumber,AnIncrement);
    lNumber := RightStr(StringOfChar('0', length(lNumber)) + IntToStr(lIntNumber),Max(length(lNumber),length(IntToStr(lIntNumber))));
    result := lPrefix + lNumber + lSufix;
  end
  else
    result := AFromSerial;
end;

procedure TFrmRenameFiles.sbAddFileClick(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName) then
    AddFile(lFileName);
end;

procedure TFrmRenameFiles.sbDeleteFileClick(Sender: TObject);
begin
  lbFiles.DeleteSelected;
  ShowRenameResult;
end;

procedure TFrmRenameFiles.sbMoveDownClick(Sender: TObject);
begin
  ExchangeItems(lbFiles.ItemIndex, lbFiles.ItemIndex + 1);
end;

procedure TFrmRenameFiles.sbMoveUpClick(Sender: TObject);
begin
  ExchangeItems(lbFiles.ItemIndex, lbFiles.ItemIndex - 1);
end;

procedure TFrmRenameFiles.sbShuffleClick(Sender: TObject);
var
  lSource, lDest : array of string;
  i,j: Integer;
  lFileCount : integer;
  lSourceIndex, lNewIndex : integer;
begin
  lFileCount := lbFiles.Count;
  SetLength(lSource,lFileCount);
  for i := 0 to lFileCount - 1 do
    lSource[i] := lbFiles.Items.Strings[i];
  SetLength(lDest,0);
  for i := 0 to lFileCount - 1 do
  begin
    lSourceIndex := Random(length(lSource));
    lNewIndex := Length(lDest);
    setlength(lDest,lNewIndex + 1);
    lDest[lNewIndex] := lSource[lSourceIndex];
    for j := lSourceIndex + 1 to length(lSource) - 1 do
      lSource[j - 1 ] := lSource[j];
    SetLength(lSource,Length(lSource) - 1);
  end;
  lbFiles.Clear;
  for i := 0 to lFileCount - 1 do
    lbFiles.Items.Add(lDest[i]);
  ShowRenameResult;
end;

procedure TFrmRenameFiles.SetLanguage(const Value: TLanguage);
begin
  FLanguage := Value;
  Caption := Value.frmRenameFiles_caption;
  lblFirstFileName.Caption := Value.frmRenameFiles_lblFirstFileName_caption;
  btnRename.Caption := Value.frmRenameFiles_btnRename_caption;
  chkShowPreview.Caption := value.frmRenameFiles_chkShowPreview_caption;
end;

procedure TFrmRenameFiles.ShowRenameResult;
var
  i: Integer;
  lCurrentSerial : string;
  lFileName : string;
  lExt : string;
begin
  lCurrentSerial := edFirstFilename.Text;
  for i := 0 to lbFiles.Count - 1 do
  begin
    lFileName := FilenameWithoutResult(lbFiles.Items.Strings[i]);
    lExt := ExtractFileExt(lFileName);
    if chkShowPreview.Checked then
      lbFiles.Items.Strings[i] := lFileName + ' --> ' + lCurrentSerial + lExt
    else
      lbFiles.Items.Strings[i] := lFileName;
    lCurrentSerial := NextSerial(lCurrentSerial);
  end;
end;

procedure TFrmRenameFiles.WMDropFiles(var Msg: TWMDropFiles);
var
  lFilename: array [0 .. 256] of char;
  lNumberOfFiles: Integer;
  i : integer;
begin
//  AddHourGlassCursor;
  try
    try
      lNumberOfFiles := DragQueryFile(Msg.Drop, $FFFFFFFF, nil, 0);
      for i := 0 to lNumberOfFiles - 1 do
      begin
        DragQueryFile(Msg.Drop, i, lFilename, SizeOf(lFilename));
        if (FileExists(lFilename)) then
          AddFile(lFilename);
      end;
    finally
      DragFinish(Msg.Drop);
    end;
    inherited;
  finally
//    RemoveHourGlassCursor;
  end;
end;

end.
