unit OperationFra;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, 
  Dialogs, StdCtrls, ComCtrls, Spin, smp2mp3Utils, Buttons;

type
  TFraOperation = class;

  TFraOperationEvent = procedure (AFrame : TFraOperation) of object;

  TFraOperation = class(TFrame)
    gbOperation: TGroupBox;
    cboOperationType: TComboBox;
    pcOperation: TPageControl;
    tsXOR: TTabSheet;
    tsRotate: TTabSheet;
    lblXOR: TLabel;
    memXORKey: TMemo;
    lblRotateDirection: TLabel;
    rbRotateLeft: TRadioButton;
    rbRotateRight: TRadioButton;
    lblRotateTimes: TLabel;
    seRotateTimes: TSpinEdit;
    sbUp: TSpeedButton;
    sbDown: TSpeedButton;
    sbDelete: TSpeedButton;
    lblOrder: TLabel;
    procedure cboOperationTypeChange(Sender: TObject);
    procedure memXORKeyChange(Sender: TObject);
    procedure rbRotateLeftClick(Sender: TObject);
    procedure rbRotateRightClick(Sender: TObject);
    procedure seRotateTimesChange(Sender: TObject);
    procedure sbUpClick(Sender: TObject);
    procedure sbDownClick(Sender: TObject);
    procedure sbDeleteClick(Sender: TObject);
  private
    FOnChange: TNotifyEvent;
    FLoadingOperation : boolean;
    FOnDelete: TFraOperationEvent;
    FOnDown: TFraOperationEvent;
    FOnUp: TFraOperationEvent;
    FIndex: integer;
    FLanguage: TLanguage;
    function GetOperation: TAlgorithmOperation;
    procedure SetOperation(const Value: TAlgorithmOperation);
    procedure SetOnChange(const Value: TNotifyEvent);
    procedure DoOnChange(Sender: TObject);
    procedure SetOnDelete(const Value: TFraOperationEvent);
    procedure SetOnDown(const Value: TFraOperationEvent);
    procedure SetOnUp(const Value: TFraOperationEvent);
    procedure SetIndex(const Value: integer);
    procedure SetLanguage(const Value: TLanguage);
    { Private declarations }
  public
    { Public declarations }
    procedure Init;
    property Operation : TAlgorithmOperation read GetOperation write SetOperation;
    property OnChange : TNotifyEvent read FOnChange write SetOnChange;
    property OnUp : TFraOperationEvent read FOnUp write SetOnUp;
    property OnDown : TFraOperationEvent read FOnDown write SetOnDown;
    property OnDelete : TFraOperationEvent read FOnDelete write SetOnDelete;
    property Index : integer read FIndex write SetIndex;
    property Language : TLanguage read FLanguage write SetLanguage;
  end;

implementation

{$R *.dfm}

procedure TFraOperation.cboOperationTypeChange(Sender: TObject);
begin
  if TOperationType(cboOperationType.ItemIndex) = otXOR then
    pcOperation.ActivePage := tsXOR
  else if TOperationType(cboOperationType.ItemIndex) = otRotate then
    pcOperation.ActivePage := tsRotate
  else
    pcOperation.ActivePage := nil;
  DoOnChange(cboOperationType);
end;

procedure TFraOperation.DoOnChange(Sender: TObject);
begin
  if (not FLoadingOperation) and assigned(FOnChange) then
    FOnChange(Sender);
end;

function TFraOperation.GetOperation: TAlgorithmOperation;
begin
  result.OperationType := TOperationType(cboOperationType.ItemIndex);
  result.XorKey := CommaTextToXorKey(memXORKey.Lines.CommaText);
  if rbRotateLeft.Checked then
    result.RotateDirection := rdLeft
  else if rbRotateRight.Checked then
    result.RotateDirection := rdRight
  else
    result.RotateDirection := rdNone;
  result.RotateCount := seRotateTimes.Value;
end;

procedure TFraOperation.Init;
begin
  cboOperationType.ItemIndex := 0;
  memXORKey.Lines.Clear;
end;

procedure TFraOperation.memXORKeyChange(Sender: TObject);
begin
  DoOnChange(memXORKey);
end;

procedure TFraOperation.rbRotateLeftClick(Sender: TObject);
begin
  DoOnChange(rbRotateLeft);
end;

procedure TFraOperation.rbRotateRightClick(Sender: TObject);
begin
  DoOnChange(rbRotateRight);
end;

procedure TFraOperation.sbDeleteClick(Sender: TObject);
begin
  if assigned(FOnDelete) then
    FOnDelete(self);
end;

procedure TFraOperation.sbDownClick(Sender: TObject);
begin
  if assigned(FOnDown) then
    FOnDown(self);
end;

procedure TFraOperation.sbUpClick(Sender: TObject);
begin
  if assigned(FOnUp) then
    FOnUp(self);
end;

procedure TFraOperation.seRotateTimesChange(Sender: TObject);
begin
  DoOnChange(seRotateTimes);
end;

procedure TFraOperation.SetIndex(const Value: integer);
begin
  FIndex := Value;
  if Value = 0 then
    lblOrder.Caption := Language.CAPTION_FIRST
  else
    lblOrder.Caption := Language.CAPTION_THEN;
  lblOrder.Caption := lblOrder.Caption + ' (' + IntToStr(Value + 1) + ')';
end;

procedure TFraOperation.SetLanguage(const Value: TLanguage);
begin
  FLanguage := Value;
  lblXOR.Caption := FLanguage.fraOperation_lblXORkey_caption;
  lblRotateTimes.Caption := FLanguage.fraOperation_lblRotateTimes_caption;
  lblRotateDirection.Caption := FLanguage.fraOperation_lblRotateDirection_caption;
  rbRotateLeft.Caption := FLanguage.fraOperation_rbRotate_left;
  rbRotateRight.Caption := FLanguage.fraOperation_rbRotate_right;
  cboOperationType.Items[0] := FLanguage.fraOperation_XOR;
  cboOperationType.Items[1] := FLanguage.fraOperation_Rotate;
end;

procedure TFraOperation.SetOnChange(const Value: TNotifyEvent);
begin
  FOnChange := Value;
end;

procedure TFraOperation.SetOnDelete(const Value: TFraOperationEvent);
begin
  FOnDelete := Value;
end;

procedure TFraOperation.SetOnDown(const Value: TFraOperationEvent);
begin
  FOnDown := Value;
end;

procedure TFraOperation.SetOnUp(const Value: TFraOperationEvent);
begin
  FOnUp := Value;
end;

procedure TFraOperation.SetOperation(const Value: TAlgorithmOperation);
begin
  FLoadingOperation := true;
  try
    cboOperationType.ItemIndex := ord(Value.OperationType);
    memXORKey.Lines.CommaText := XorKeyToCommaText(Value.XorKey);
    rbRotateLeft.Checked := Value.RotateDirection = rdLeft;
    rbRotateRight.Checked := Value.RotateDirection = rdRight;
    seRotateTimes.Value := Value.RotateCount;
    cboOperationTypeChange(cboOperationType);
  finally
    FLoadingOperation := false;
  end;
end;

end.
