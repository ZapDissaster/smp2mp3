object frmMCT: TfrmMCT
  Left = 0
  Top = 0
  Caption = 'Generar archivos .mct'
  ClientHeight = 238
  ClientWidth = 307
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnShow = FormShow
  DesignSize = (
    307
    238)
  PixelsPerInch = 96
  TextHeight = 13
  object lblTipo: TLabel
    Left = 8
    Top = 11
    Width = 24
    Height = 13
    Caption = 'Tipo:'
  end
  object lblDir: TLabel
    Left = 8
    Top = 38
    Width = 50
    Height = 13
    Caption = 'Directorio:'
  end
  object lblFile: TLabel
    Left = 8
    Top = 65
    Width = 40
    Height = 13
    Caption = 'Archivo:'
  end
  object lblToFile: TLabel
    Left = 147
    Top = 65
    Width = 8
    Height = 13
    Caption = 'al'
    Visible = False
  end
  object cboTipo: TComboBox
    Left = 80
    Top = 8
    Width = 161
    Height = 21
    Style = csDropDownList
    Enabled = False
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 0
    Text = 'Hachette (Salvat)'
    Items.Strings = (
      'Hachette (Salvat)')
  end
  object gbExample: TGroupBox
    Left = 8
    Top = 141
    Width = 291
    Height = 58
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Ejemplo de archivos que reproduce'
    TabOrder = 1
    ExplicitTop = 204
    ExplicitWidth = 792
    object memExample: TMemo
      Left = 2
      Top = 15
      Width = 287
      Height = 41
      Align = alClient
      BevelEdges = []
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clBtnFace
      ReadOnly = True
      TabOrder = 0
      ExplicitWidth = 443
      ExplicitHeight = 48
    end
  end
  object edDir: TEdit
    Left = 80
    Top = 35
    Width = 33
    Height = 21
    TabOrder = 2
    Text = '01'
    OnChange = edDirChange
    OnKeyUp = edDirKeyUp
  end
  object sbDir: TSpinButton
    Left = 113
    Top = 35
    Width = 20
    Height = 21
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 3
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    OnDownClick = sbDirDownClick
    OnUpClick = sbDirUpClick
  end
  object edFromFile: TEdit
    Left = 80
    Top = 62
    Width = 33
    Height = 21
    TabOrder = 4
    Text = '0001'
    OnChange = edFromFileChange
    OnKeyUp = edFromFileKeyUp
  end
  object sbFromFile: TSpinButton
    Left = 113
    Top = 62
    Width = 20
    Height = 21
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 5
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    OnDownClick = sbFromFileDownClick
    OnUpClick = sbFromFileUpClick
  end
  object chkMultiple: TCheckBox
    Left = 8
    Top = 89
    Width = 291
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Generar multiples archivos'
    TabOrder = 6
    OnClick = chkMultipleClick
    ExplicitWidth = 550
  end
  object edToFile: TEdit
    Left = 188
    Top = 62
    Width = 33
    Height = 21
    TabOrder = 7
    Text = '0001'
    Visible = False
    OnChange = edToFileChange
    OnKeyUp = edToFileKeyUp
  end
  object sbToFile: TSpinButton
    Left = 221
    Top = 62
    Width = 20
    Height = 21
    DownGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000008080000080800000808000000000000080800000808000008080000080
      8000008080000080800000808000000000000000000000000000008080000080
      8000008080000080800000808000000000000000000000000000000000000000
      0000008080000080800000808000000000000000000000000000000000000000
      0000000000000000000000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    TabOrder = 8
    UpGlyph.Data = {
      0E010000424D0E01000000000000360000002800000009000000060000000100
      200000000000D800000000000000000000000000000000000000008080000080
      8000008080000080800000808000008080000080800000808000008080000080
      8000000000000000000000000000000000000000000000000000000000000080
      8000008080000080800000000000000000000000000000000000000000000080
      8000008080000080800000808000008080000000000000000000000000000080
      8000008080000080800000808000008080000080800000808000000000000080
      8000008080000080800000808000008080000080800000808000008080000080
      800000808000008080000080800000808000}
    Visible = False
    OnDownClick = sbToFileDownClick
    OnUpClick = sbToFileUpClick
  end
  object chkUseHex: TCheckBox
    Left = 8
    Top = 112
    Width = 291
    Height = 17
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Usar Hexadecimales'
    TabOrder = 9
    Visible = False
    ExplicitWidth = 550
  end
  object btnGenerate: TButton
    Left = 143
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Generar'
    TabOrder = 10
    OnClick = btnGenerateClick
    ExplicitLeft = 644
    ExplicitTop = 268
  end
  object btnClose: TButton
    Left = 224
    Top = 205
    Width = 75
    Height = 25
    Anchors = [akRight, akBottom]
    Caption = '&Cerrar'
    TabOrder = 11
    OnClick = btnCloseClick
    ExplicitLeft = 725
    ExplicitTop = 268
  end
end
