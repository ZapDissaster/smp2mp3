unit KeyFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Spin, ExtCtrls, Buttons, smp2mp3Utils, OperationFra;

type
  TfrmKey = class(TForm)

    btnOK: TButton;
    btnCancel: TButton;
    sbSaveKey: TSpeedButton;
    sbLoadKey: TSpeedButton;
    PopupMenu: TPopupMenu;
    sbOperations: TScrollBox;
    lbloperations: TLabel;
    lblSourceExt: TLabel;
    edSourceExt: TEdit;
    lblDestExt: TLabel;
    edDestExt: TEdit;
    sbAddOperation: TSpeedButton;
    sbClearOperations: TSpeedButton;
    btnConvertAlgorithms: TButton;
    chkChangeID3v2: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure sbLoadKeyClick(Sender: TObject);
    procedure sbSaveKeyClick(Sender: TObject);
    procedure rgRotateClick(Sender: TObject);
    procedure seTimesChange(Sender: TObject);
    procedure cboTimeChange(Sender: TObject);
    procedure memKeyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniLoadKeyClick(Sender: TObject);
    procedure sbAddOperationClick(Sender: TObject);
    procedure sbClearOperationsClick(Sender: TObject);
    procedure btnConvertAlgorithmsClick(Sender: TObject);
  private
    FSelectedKeyName: string;
    GLoadingKey : boolean;
    FLanguage: TLanguage;
    FFrames : array of TFraOperation;
    { Private declarations }
    procedure ArrangeFrames;
    procedure LoadFile(AFileName : string);
    procedure SaveFile(AFileName : string; AKeyName : string);
    procedure SetSelectedAlgorithmName(const Value: string);
    procedure AddAlgorithmsToMenu;
    procedure SetLanguage(const Value: TLanguage);
    function getAlgorithm: TAlgorithm;
    procedure setAlgorithm(const Value: TAlgorithm);
    procedure OperationChanged(Sender: TObject);
    procedure MoveOperationFrameUp(AFrame : TFraOperation);
    procedure MoveOperationFrameDown(AFrame : TFraOperation);
    procedure DeleteOperationFrame(AFrame : TFraOperation);
    function GetOperations: TAlgorithmOperationArray;
    procedure SetOperations(const Value: TAlgorithmOperationArray);
    property Operations : TAlgorithmOperationArray read GetOperations write SetOperations;
    function AppendFrame : TFraOperation;
    procedure ChangeCaption;
  public
    { Public declarations }
    property SelectedKeyName : string read FSelectedKeyName write SetSelectedAlgorithmName;
    property Language : TLanguage read FLanguage write SetLanguage;
    property Algorithm : TAlgorithm read getAlgorithm write setAlgorithm;
  end;

var
  frmKey: TfrmKey;

implementation

uses
  StrUtils;

{$R *.dfm}

procedure TfrmKey.AddAlgorithmsToMenu;
var
  lDir : string;
begin
  lDir := ExtractFileDir(Application.ExeName);
  AddFilesToMenuItem(lDir,'.key',PopupMenu.Items,mniLoadKeyClick);
  lDir := lDir + '\Keys';
  if DirectoryExists(lDir) then
    AddFilesToMenuItem(lDir,'.key',PopupMenu.Items,mniLoadKeyClick);
end;

procedure TfrmKey.ArrangeFrames;
var
  i : integer;
  lFrame : TFraOperation;
  lNextTop : integer;
begin
  sbOperations.VertScrollBar.Position := 0;
  lNextTop := 0;
  for i := 0 to length(FFrames) - 1 do
  begin
    lFrame := FFrames[i];
    lFrame.OperationIndex := i;
    lFrame.OperationCount := length(FFrames);
    lFrame.Left := 0;
    lFrame.Top := lNextTop;
    lNextTop := lNextTop + lFrame.Height;
  end;
end;

procedure TfrmKey.btnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TfrmKey.btnOKClick(Sender: TObject);
begin
  close;
  ModalResult := mrOK;
end;

procedure TfrmKey.btnConvertAlgorithmsClick(Sender: TObject);
var
  lFilename1, lFilename2 : string;
  lAlgorithm1, lAlgorithm2 : TAlgorithm;
  lOperations : TAlgorithmOperationArray;
  i : integer;
begin
  if PromptForFileName(lFilename1,'*.key|*.key','.key',Language.frmKey_Convert_Source_caption,KeysPath) then
  begin
    lAlgorithm1 := LoadKeyFromFile(lFilename1);
    if PromptForFileName(lFilename2,'*.key|*.key','.key',Language.frmKey_Convert_Destination_caption,KeysPath) then
    begin
      lAlgorithm2 := LoadKeyFromFile(lFilename2);
      edSourceExt.Text := lAlgorithm1.DestExt;
      edDestExt.Text := lAlgorithm2.DestExt;
      chkChangeID3v2.Checked := false;
      lOperations := InvertOperations(lAlgorithm1.Operations);
      for i := 0 to Length(lAlgorithm2.Operations) - 1 do
        AddOperationToOperations(lOperations,lAlgorithm2.Operations[i]);
      Operations := SimplifyOperations(lOperations);
      SelectedKeyName := StripFileName(lFilename1) + ' -> ' + StripFileName(lFilename2);
    end;
  end;

end;

procedure TfrmKey.cboTimeChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.ChangeCaption;
begin
  caption := Language.frmKey_caption;
  if StripFileName(SelectedKeyName) <> '' then
    caption := Caption + '(' + StripFileName(SelectedKeyName) + ')';
end;

procedure TfrmKey.DeleteOperationFrame(AFrame: TFraOperation);
var
  i, lIndex : integer;
begin
  lIndex := AFrame.OperationIndex;
  AFrame.Free;
  for i := lIndex to Length(FFrames) - 2 do
    FFrames[i] := FFrames[i + 1];
  SetLength(FFrames, length(FFrames) - 1);
  ArrangeFrames;
end;

procedure TfrmKey.FormCreate(Sender: TObject);
begin
  GLoadingKey := false;
  SetLength(FFrames,0);
  AddAlgorithmsToMenu;
end;

function TfrmKey.getAlgorithm: TAlgorithm;
begin
  Result.Name := StripFileName(SelectedKeyName);
  Result.SourceExt := edSourceExt.Text;
  Result.DestExt := edDestExt.Text;
  result.ChangeID3 := chkChangeID3v2.Checked;
  result.Operations := Operations;
end;

function TfrmKey.GetOperations: TAlgorithmOperationArray;
var
  i: Integer;
begin
  SetLength(Result,length(FFrames));
  for i := 0 to Length(FFrames) - 1 do
    result[i] := FFrames[i].Operation;

end;

procedure TfrmKey.LoadFile(AFileName: string);
begin
  Algorithm := LoadKeyFromFile(AfileName);
end;

procedure TfrmKey.memKeyChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.mniLoadKeyClick(Sender: TObject);
begin
  Algorithm := FindAndLoadKey((Sender as TMenuItem).Caption);
end;

procedure TfrmKey.MoveOperationFrameDown(AFrame: TFraOperation);
var
  lIndex : Integer;
  lDestIndex : integer;
  ltmpFrame : TFraOperation;
begin
  lIndex := AFrame.OperationIndex;
  if lIndex = (length(FFrames) - 1) then
    exit;
  lDestIndex := lIndex + 1;
  ltmpFrame := FFrames[lIndex];
  FFrames[lIndex] := FFrames[lDestIndex];
  FFrames[lDestIndex] := ltmpFrame;
  ArrangeFrames;
end;

procedure TfrmKey.MoveOperationFrameUp(AFrame: TFraOperation);
var
  lIndex : Integer;
  lDestIndex : integer;
  ltmpFrame : TFraOperation;
begin
  lIndex := AFrame.OperationIndex;
  if lIndex = 0 then
    exit;
  lDestIndex := lIndex - 1;
  ltmpFrame := FFrames[lIndex];
  FFrames[lIndex] := FFrames[lDestIndex];
  FFrames[lDestIndex] := ltmpFrame;
  ArrangeFrames;
end;

function TfrmKey.AppendFrame : TFraOperation;
var
  lIndex : integer;
begin
  lIndex := length(FFrames);
  SetLength(FFrames,lIndex + 1);
  FFrames[lIndex] := TFraOperation.Create(sbOperations);
  FFrames[lIndex].Name := 'FraOperation' + IntToStr(lIndex);
  FFrames[lIndex].Parent := sbOperations;
  FFrames[lIndex].OnChange := OperationChanged;
  FFrames[lIndex].OnUp := MoveOperationFrameUp;
  FFrames[lIndex].OnDown := MoveOperationFrameDown;
  FFrames[lIndex].OnDelete := DeleteOperationFrame;
  FFrames[lIndex].Language := Language;
  result := FFrames[lIndex];
end;

procedure TfrmKey.OperationChanged(Sender: TObject);
begin
  if not GLoadingKey then
    FSelectedKeyName := '';
end;

procedure TfrmKey.rgRotateClick(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.SaveFile(AFileName: string; AKeyName : string);
var
  lKey : TAlgorithm;
begin
  lKey := Algorithm;
  lKey.Name := StripFileName(AKeyName);
  SaveKeyToFile(AFileName,lKey);
end;

procedure TfrmKey.seTimesChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.setAlgorithm(const Value: TAlgorithm);
begin
  GLoadingKey := true;
  try
    edSourceExt.Text := Value.SourceExt;
    edDestExt.Text := Value.DestExt;
    chkChangeID3v2.Checked := Value.ChangeID3;
    Operations := Value.Operations;
  finally
    GLoadingKey := false;
  end;
end;

procedure TfrmKey.SetLanguage(const Value: TLanguage);
begin
  FLanguage := Value;
  Caption := FLanguage.frmKey_caption;
  btnOK.Caption := FLanguage.frmKey_btnOK_caption;
  btnCancel.Caption := FLanguage.frmKey_btnCancel_caption;
  lbloperations.Caption := FLanguage.frmKey_lblOperations_caption;
  lblSourceExt.Caption := FLanguage.frmKey_lblSourceExt_caption;
  lblDestExt.Caption := FLanguage.frmKey_lblDestExt_caption;
  btnConvertAlgorithms.Caption := FLanguage.frmKey_btnConvertAlgorithms_caption;
  chkChangeID3v2.Caption :=  FLanguage.frmKey_chkChangeID3v2_caption;
  ChangeCaption;
end;

procedure TfrmKey.SetOperations(const Value: TAlgorithmOperationArray);
var
  i : integer;
begin
  for i := length(FFrames) - 1 downto 0 do
  begin
    FFrames[i].Free;
    SetLength(FFrames, length(FFrames) - 1);
  end;
  SetLength(FFrames, 0);
  for i := 0 to length(Value) - 1 do
    AppendFrame.Operation := Value[i];
  ArrangeFrames;
end;

procedure TfrmKey.SetSelectedAlgorithmName(const Value: string);
begin
  if GLoadingKey then
    exit;
  FSelectedKeyName := StripFileName(Value);
  ChangeCaption;
end;

procedure TfrmKey.sbSaveKeyClick(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',Language.frmKey_SaveToFile_caption,KeysPath,true) then
  begin
    SaveFile(lFileName, lFileName);
    SelectedKeyName := lFileName;
  end;
end;

procedure TfrmKey.sbAddOperationClick(Sender: TObject);
begin
  AppendFrame.Init;
  ArrangeFrames;
end;

procedure TfrmKey.sbClearOperationsClick(Sender: TObject);
var
  i : integer;
begin
  for i := length(FFrames) - 1 downto 0 do
    FFrames[i].Free;
  SetLength(FFrames, 0);
  AppendFrame.Init;
  ArrangeFrames;
end;

procedure TfrmKey.sbLoadKeyClick(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',Language.frmKey_LoadFromFile_caption,KeysPath) then
  begin
    LoadFile(lFileName);
    SelectedKeyName := lFileName;
    btnOK.SetFocus;
  end;
end;

end.
