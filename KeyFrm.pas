unit KeyFrm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, StdCtrls, Spin, ExtCtrls, Buttons;

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
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    chkChangeExt: TCheckBox;
    procedure btnOKClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure rgRotateClick(Sender: TObject);
    procedure seTimesChange(Sender: TObject);
    procedure cboTimeChange(Sender: TObject);
    procedure memKeyChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    FLoadFromFileCaption: string;
    FSaveToFileCaption: string;
    FSelectedFile: string;
    GLoadingKey : boolean;
    { Private declarations }
    procedure LoadFile(AFileName : string);
    procedure SaveFile(AFileName : string);
    procedure SetLoadFromFileCaption(const Value: string);
    procedure SetSaveToFileCaption(const Value: string);
    procedure SetSelectedFile(const Value: string);
  public
    { Public declarations }
    property SaveToFileCaption : string read FSaveToFileCaption write SetSaveToFileCaption;
    property LoadFromFileCaption : string read FLoadFromFileCaption write SetLoadFromFileCaption;
    property SelectedFile : string read FSelectedFile write SetSelectedFile;
  end;

var
  frmKey: TfrmKey;

implementation

uses
  IniFiles;

{$R *.dfm}

procedure TfrmKey.btnCancelClick(Sender: TObject);
begin
  Close;
  ModalResult := mrCancel;
end;

procedure TfrmKey.btnOKClick(Sender: TObject);
begin
  SaveFile(ChangeFileExt(Application.ExeName,'.ini'));
  close;
  ModalResult := mrOK;
end;

procedure TfrmKey.cboTimeChange(Sender: TObject);
begin
  SelectedFile := '';
end;

procedure TfrmKey.FormCreate(Sender: TObject);
begin
  GLoadingKey := false;
end;

procedure TfrmKey.FormShow(Sender: TObject);
begin
  LoadFile(ChangeFileExt(Application.ExeName,'.ini'));
end;

procedure TfrmKey.LoadFile(AFileName: string);
begin
  GLoadingKey := true;
  try
    with TIniFile.Create(AFileName) do
    try
      memKey.Lines.CommaText  := ReadString('KEY','XORKEY','0x51,0x23,0x98,0x56');
      rgRotate.ItemIndex      := ReadInteger('KEY','ROTATEDIRECTION',0);
      seTimes.Value           := ReadInteger('KEY','ROTATECOUNT',0);
      cboTime.ItemIndex       := ReadInteger('KEY','ROTATETIME',0);
      chkChangeExt.Checked    := ReadBool('KEY','CHANGEFILEEXT',True);
    finally
      Free;
    end;
  finally
    GLoadingKey := false;
  end;
end;

procedure TfrmKey.memKeyChange(Sender: TObject);
begin
  SelectedFile := '';
end;

procedure TfrmKey.rgRotateClick(Sender: TObject);
begin
  SelectedFile := '';
end;

procedure TfrmKey.SaveFile(AFileName: string);
begin
  with TIniFile.Create(AFileName) do
  try
    WriteString('KEY','XORKEY',memkey.Lines.CommaText);
    WriteInteger('KEY','ROTATEDIRECTION',rgRotate.ItemIndex);
    WriteInteger('KEY','ROTATECOUNT',seTimes.Value);
    WriteInteger('KEY','ROTATETIME',cboTime.ItemIndex);
    WriteBool('KEY','CHANGEFILEEXT',chkChangeExt.Checked);
  finally
    Free;
  end;
end;

procedure TfrmKey.seTimesChange(Sender: TObject);
begin
  SelectedFile := '';
end;

procedure TfrmKey.SetLoadFromFileCaption(const Value: string);
begin
  FLoadFromFileCaption := Value;
end;

procedure TfrmKey.SetSaveToFileCaption(const Value: string);
begin
  FSaveToFileCaption := Value;
end;

procedure TfrmKey.SetSelectedFile(const Value: string);
begin
  if GLoadingKey then
    exit;
  FSelectedFile := Value;
end;

procedure TfrmKey.SpeedButton1Click(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',SaveToFileCaption,ExtractFileDir(Application.ExeName),true) then
  begin
    SaveFile(lFileName);
    SelectedFile := lFileName;
  end;
end;

procedure TfrmKey.SpeedButton2Click(Sender: TObject);
var
  lFileName : string;
begin
  if PromptForFileName(lFileName,'*.key|*.key','.key',LoadFromFileCaption,ExtractFileDir(Application.ExeName)) then
  begin
    LoadFile(lFileName);
    SelectedFile := lFileName;
    btnOK.SetFocus;
  end;
end;

end.
