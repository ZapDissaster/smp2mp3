unit KeyFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Spin, ExtCtrls, Buttons, smp2mp3Utils;

type
  TfrmKey = class(TForm)
    memKey: TMemo;
    seTimes: TSpinEdit;
    rgRotate: TRadioGroup;

    btnOK: TButton;
    btnCancel: TButton;
    gbRotate: TGroupBox;
    gbXORkey: TGroupBox;
    lblTimes: TLabel;
    lblTime: TLabel;
    cboTime: TComboBox;
    sbSaveKey: TSpeedButton;
    sbLoadKey: TSpeedButton;
    chkChangeExt: TCheckBox;
    PopupMenu: TPopupMenu;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sbLoadKeyClick(Sender: TObject);
    procedure sbSaveKeyClick(Sender: TObject);
    procedure rgRotateClick(Sender: TObject);
    procedure seTimesChange(Sender: TObject);
    procedure cboTimeChange(Sender: TObject);
    procedure memKeyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mniLoadKeyClick(Sender: TObject);
  private
    FSelectedKeyName: string;
    GLoadingKey : boolean;
    FLanguage: TLanguage;
    { Private declarations }
    procedure LoadFile(AFileName : string);
    procedure SaveFile(AFileName : string; AKeyName : string);
    procedure SetSelectedKeyName(const Value: string);
    procedure AddKeysToMenu;
    procedure SetLanguage(const Value: TLanguage);
    function getKey: TAlgorithm;
    procedure setKey(const Value: TAlgorithm);
  public
    { Public declarations }
    property SelectedKeyName : string read FSelectedKeyName write SetSelectedKeyName;
    property Language : TLanguage read FLanguage write SetLanguage;
    property Key : TAlgorithm read getKey write setKey;
  end;

var
  frmKey: TfrmKey;

implementation

uses
  StrUtils;

{$R *.dfm}

procedure TfrmKey.AddKeysToMenu;
var
  lDir : string;
begin
  lDir := ExtractFileDir(Application.ExeName);
  AddFilesToMenuItem(lDir,'.key',PopupMenu.Items,mniLoadKeyClick);
  lDir := lDir + '\Keys';
  if DirectoryExists(lDir) then
    AddFilesToMenuItem(lDir,'.key',PopupMenu.Items,mniLoadKeyClick);
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

procedure TfrmKey.cboTimeChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.FormCreate(Sender: TObject);
begin
  GLoadingKey := false;
  AddKeysToMenu;
end;

procedure TfrmKey.FormShow(Sender: TObject);
begin
  LoadFile(IniFileName);
end;

function TfrmKey.getKey: TAlgorithm;
begin
  Result.Name := StripFileName(SelectedKeyName);
  Result.XorKey := CommaTextToXorKey(memKey.Lines.CommaText);
  Result.RotateDirection := TRotateDirection(rgRotate.ItemIndex);
  Result.RotateCount := seTimes.Value;
  Result.RotateTime := TRotateTime(cboTime.ItemIndex);
  Result.ChangeFileExt := chkChangeExt.Checked;
end;

procedure TfrmKey.LoadFile(AFileName: string);
begin
  Key := LoadKeyFromFile(AfileName);
end;

procedure TfrmKey.memKeyChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.mniLoadKeyClick(Sender: TObject);
begin
  key := FindAndLoadKey((Sender as TMenuItem).Caption);
end;

procedure TfrmKey.rgRotateClick(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.SaveFile(AFileName: string; AKeyName : string);
var
  lKey : TAlgorithm;
begin
  lKey := Key;
  lKey.Name := StripFileName(AKeyName);
  SaveKeyToFile(AFileName,lKey);
end;

procedure TfrmKey.seTimesChange(Sender: TObject);
begin
  SelectedKeyName := '';
end;

procedure TfrmKey.setKey(const Value: TAlgorithm);
begin
  GLoadingKey := true;
  try
    SelectedKeyName := Key.Name;
    memKey.Lines.CommaText  := XorKeyToCommaText(Value.XorKey);
    rgRotate.ItemIndex      := ord(Value.RotateDirection);
    seTimes.Value           := Value.RotateCount;
    cboTime.ItemIndex       := ord(Value.RotateTime);
    chkChangeExt.Checked    := Value.ChangeFileExt;
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
  gbRotate.Caption := FLanguage.frmKey_gbRotate_caption;
  gbXORkey.Caption := FLanguage.frmKey_gbXORkey_caption;
  lblTimes.Caption := FLanguage.frmKey_lblTimes_caption;
  lblTime.Caption := FLanguage.frmKey_lblTime_caption;
  chkChangeExt.Caption := FLanguage.frmKey_chkChangeExt_Caption;
  rgRotate.Items.Clear;
  rgRotate.Items.Add(FLanguage.frmKey_rgRotate_disabled);
  rgRotate.Items.Add(FLanguage.frmKey_rgRotate_right);
  rgRotate.Items.Add(FLanguage.frmKey_rgRotate_left);
  cboTime.items.Clear;
  cboTime.items.Add(FLanguage.frmKey_cboTime_beforeXOR);
  cboTime.items.Add(FLanguage.frmKey_cboTime_afterXOR);
end;

procedure TfrmKey.SetSelectedKeyName(const Value: string);
begin
  if GLoadingKey then
    exit;
  FSelectedKeyName := StripFileName(Value);
end;

procedure TfrmKey.sbSaveKeyClick(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',Language.frmKey_SaveToFile_caption,ExtractFileDir(Application.ExeName),true) then
  begin
    SaveFile(lFileName, lFileName);
    SelectedKeyName := lFileName;
  end;
end;

procedure TfrmKey.sbLoadKeyClick(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',Language.frmKey_LoadFromFile_caption,ExtractFileDir(Application.ExeName)) then
  begin
    LoadFile(lFileName);
    SelectedKeyName := lFileName;
    btnOK.SetFocus;
  end;
end;

end.
