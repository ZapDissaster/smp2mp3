object frmSmp2MP3: TfrmSmp2MP3
  Left = 0
  Top = 0
  Caption = 'SMP <-> MP3'
  ClientHeight = 283
  ClientWidth = 496
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    496
    283)
  PixelsPerInch = 96
  TextHeight = 13
  object pnlprogress: TPanel
    Left = 8
    Top = 135
    Width = 476
    Height = 44
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 3
    Visible = False
  end
  object gbSingleFile: TGroupBox
    Left = 8
    Top = 8
    Width = 480
    Height = 121
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Convertir un solo archivo'
    TabOrder = 0
    DesignSize = (
      480
      121)
    object lblSOrigen: TLabel
      Left = 24
      Top = 27
      Width = 36
      Height = 13
      Caption = 'Origen:'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
    end
    object btnPlay: TSpeedButton
      Left = 370
      Top = 60
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D28098435EB5007BA20080A66FD2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        54A60080FF157CFB0059BC0080A211D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D247A70078FF0073EB007AE6006CCE0060
        A40080A84DD2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        44A10074F6006CE0006CD40071D20078DA005EBC0080A100D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2409D006DEF0066D80065CC0067C9006B
        CD0071D3006FD10053AA00809928D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        3E990068EB0060D2005FC60060C20063C50066C8006CCE0072D4005EC000659B
        00809973D2D2D2D2D2D2D2D2D2D2D2D23A960064E8005CCF005AC2005ABC005C
        BE005FC10062C40066C8006CCE0071D300619700D2D2D2D2D2D2D2D2D2D2D2D2
        37920061E80058CF0055C20054B60056B80059BB005BBD005EC00064C6006ACC
        005C9400D2D2D2D2D2D2D2D2D2D2D2D2338F005FEB0B55D10052C50050B9004F
        B10052B40057B9005DBF004FB100599300809171D2D2D2D2D2D2D2D2D2D2D2D2
        318D005FF01C54D70051CA004EBF004CB5004FB2004EB0003A9500808A25D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2318A0060FA2E55DE0751D20051CA0052
        C6003EA100748600D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        318C0064FF4458EC1F58E81449C7003B8500808247D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2378A0070FF6E60FF3E35A300807809D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        807335399B004E7B00807568D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      Transparent = False
      OnClick = btnPlayClick
    end
    object btnStop: TSpeedButton
      Left = 401
      Top = 60
      Width = 25
      Height = 25
      Anchors = [akTop, akRight]
      Glyph.Data = {
        36030000424D3603000000000000360000002800000010000000100000000100
        18000000000000030000120B0000120B00000000000000000000D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2FF4A9BE4652EE16C2DE16927E26922E3671EE4
        6719E56818E56718E96918E86A18EA6C18EE6A1EFF5D9DD2D2D2D2D2D2DB6029
        FFD389FABC61FBB145FCA92BFE9F11FF9B00FF9E00FF9E00FFA000FF9F00FF9F
        00FFA400EC691DD2D2D2D2D2D2D3602AF6C077F0A94EF09F35F0961CF28E02F4
        8E00F79100FA9400FC9600FF9900FE9800FFA000E26615D2D2D2D2D2D2CE5C29
        F2B96FEBA248EA972EEA8C14EB8600EE8800F18B00F38D00F69000F99300FD97
        00FFA000E06415D2D2D2D2D2D2CB5929EEB46DE69C45E5902BE4850FE57F00E8
        8200EA8400ED8700F08A00F38D00F69000FE9800DA5F15D2D2D2D2D2D2C95529
        EAB06DE19745DF8B2BDE7F11DF7900E17B00E47E00E78100EA8400ED8700EF89
        00F89200D65D15D2D2D2D2D2D2C45229E6AE71DD9448DB872ED97B15D87300DB
        7500DE7800E17B00E37D00E68000E98300F28C00D45815D2D2D2D2D2D2C1502A
        E4AD76DA944ED78635D57A1CD36E02D56F00D87200DA7400DD7700E07A00E37D
        00EC8600CE5415D2D2D2D2D2D2BE4D2AE3AF7FD89557D4873FD17B27CF7010CF
        6800D16B00D46E00D77100DA7400DC7600E57F00CB5215D2D2D2D2D2D2BC4A2C
        E2B38BD69862D28B4BCF7E35CC7320CB6A0BCB6600CE6800D16B00D36D00D670
        00DF7900C94C15D2D2D2D2D2D2BA4930E2BB98D69D70D2905ACE8445CB7931C9
        701FC86910C86301CA6400CD6700D06A00D87100C34815D2D2D2D2D2D2BC4D33
        E5C2A9D7A580D2976ACE8B57CB8145C97834C87126C86C1BC86A13CA6A0DCD6C
        0DD57713C14719D2D2D2D2D2D2BB402AEFD9CAE2BDA3DCAD8CD6A177D39565CF
        8B54CE8547CD803DCE7D34CF7D2FD3802FDA8935C2411DD2D2D2D2D2D2FF2A99
        BC402ABA4C31B7462BB74529B64427B74425B84122B64022B84021B74020B841
        21BD3F1FFF319BD2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2
        D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2D2}
      Layout = blGlyphTop
      ParentShowHint = False
      ShowHint = True
      Spacing = 1
      Transparent = False
      OnClick = btnStopClick
    end
    object sbSelectFile: TSpeedButton
      Left = 402
      Top = 24
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000000000000000000000
        00009CFFFF00A5FFFF0096F9FB0089F0F70094F7FF0079E4F0008CF3FF009CF3
        FF005BBCCE0084EBFF0084E7FF003FB8D7004FC1E2007BE3FF0020A0C9007BDF
        FF006BBFDA00189AC600199AC6001896C0001B9CC70018799C00197A9D0021A2
        CE0025A2CF002899BF006BD7FF0042B3E20042B2DE0052BEE7006FD5FD0042BA
        EF000C72A5005AC7FF0084D7FF00F7FBFF000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000FFFFFF00121212121212
        1212121212121212121212121212121212121212121212121212121218181818
        1818181818181212121212151515151515151515151518121212161602202020
        2020202020201B221212161607020F0F0F0F0F0F0F111E221212161A0D020B0B
        0B0B0B0B0B0C21221212161D1A0306060606060606061F0A2212162016050202
        0202020202022304221216241612FFFF25FFFFFFFFFF0CFF2212160B0E161616
        1616161616161616221216090808080808FFFFFFFFFF1618121216FF02020202
        FF161616161616121212121AFFFFFFFF1612121212121212121212121A1A1A1A
        1212121212121212121212121212121212121212121212121212}
      OnClick = sbSelectFileClick
    end
    object btnConvertSingle: TButton
      Left = 224
      Top = 60
      Width = 140
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Convertir'
      TabOrder = 3
      OnClick = btnConvertSingleClick
    end
    object rbSingleDecrypt: TRadioButton
      Left = 66
      Top = 74
      Width = 152
      Height = 17
      Caption = 'Decrypt'
      TabOrder = 2
      OnClick = rbBatchDecryptClick
    end
    object rbSingleEncrypt: TRadioButton
      Left = 66
      Top = 51
      Width = 152
      Height = 17
      Caption = 'Encrypt'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbBatchEncryptClick
    end
    object edFileName: TEdit
      Left = 66
      Top = 24
      Width = 330
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 0
      OnChange = edFileNameChange
    end
    object tbVol: TTrackBar
      Left = 445
      Top = 13
      Width = 30
      Height = 104
      Anchors = [akTop, akRight]
      Max = 100
      Orientation = trVertical
      Frequency = 10
      ShowSelRange = False
      TabOrder = 5
      TickMarks = tmTopLeft
      TickStyle = tsNone
      OnChange = tbVolChange
    end
    object pbAudioLevel: TProgressBar
      Left = 432
      Top = 24
      Width = 15
      Height = 84
      Anchors = [akTop, akRight]
      Max = 90
      Orientation = pbVertical
      TabOrder = 4
    end
  end
  object gbConvertBatch: TGroupBox
    Left = 8
    Top = 143
    Width = 480
    Height = 106
    Anchors = [akLeft, akTop, akRight]
    Caption = 'Convertir todos los archivos de un directorio'
    TabOrder = 1
    DesignSize = (
      480
      106)
    object lblBOrigen: TLabel
      Left = 24
      Top = 27
      Width = 36
      Height = 13
      Caption = 'Origen:'
    end
    object sbSelectDirectory: TSpeedButton
      Left = 432
      Top = 24
      Width = 23
      Height = 22
      Anchors = [akTop, akRight]
      Glyph.Data = {
        36050000424D3605000000000000360400002800000010000000100000000100
        0800000000000001000000000000000000000001000000000000000000000000
        00009CFFFF00A5FFFF0096F9FB0089F0F70094F7FF0079E4F0008CF3FF009CF3
        FF005BBCCE0084EBFF0084E7FF003FB8D7004FC1E2007BE3FF0020A0C9007BDF
        FF006BBFDA00189AC600199AC6001896C0001B9CC70018799C00197A9D0021A2
        CE0025A2CF002899BF006BD7FF0042B3E20042B2DE0052BEE7006FD5FD0042BA
        EF000C72A5005AC7FF0084D7FF00F7FBFF000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        0000000000000000000000000000000000000000000000000000000000000000
        00000000000000000000000000000000000000000000FFFFFF00121212121212
        1212121212121212121212121212121212121212121212121212121218181818
        1818181818181212121212151515151515151515151518121212161602202020
        2020202020201B221212161607020F0F0F0F0F0F0F111E221212161A0D020B0B
        0B0B0B0B0B0C21221212161D1A0306060606060606061F0A2212162016050202
        0202020202022304221216241612FFFF25FFFFFFFFFF0CFF2212160B0E161616
        1616161616161616221216090808080808FFFFFFFFFF1618121216FF02020202
        FF161616161616121212121AFFFFFFFF1612121212121212121212121A1A1A1A
        1212121212121212121212121212121212121212121212121212}
      OnClick = sbSelectDirectoryClick
      ExplicitLeft = 428
    end
    object btnBatchConvert: TButton
      Left = 224
      Top = 61
      Width = 235
      Height = 25
      Anchors = [akLeft, akTop, akRight]
      Caption = 'Convertir a .mp3'
      TabOrder = 0
      OnClick = btnBatchConvertClick
    end
    object rbBatchDecrypt: TRadioButton
      Left = 66
      Top = 75
      Width = 152
      Height = 17
      Caption = 'Decrypt'
      TabOrder = 2
      OnClick = rbBatchDecryptClick
    end
    object rbBatchEncrypt: TRadioButton
      Left = 66
      Top = 52
      Width = 152
      Height = 17
      Caption = 'Encrypt'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = rbBatchEncryptClick
    end
    object edDirName: TEdit
      Left = 66
      Top = 24
      Width = 358
      Height = 21
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 3
    end
  end
  object chkNormalizar: TCheckBox
    Left = 8
    Top = 263
    Width = 281
    Height = 17
    Caption = 'Normalizar'
    TabOrder = 2
  end
  object tmrAudioLevel: TTimer
    Interval = 100
    OnTimer = tmrAudioLevelTimer
    Left = 8
    Top = 96
  end
  object MainMenu: TMainMenu
    Left = 192
    object mnuConfig: TMenuItem
      Caption = 'Configuraci'#243'n'
      object mnuChangeKey: TMenuItem
        Caption = 'Cambiar clave de encriptaci'#243'n'
      end
      object mnuChangelanguage: TMenuItem
        Caption = 'Cambiar idioma'
        object mniLanguageEng: TMenuItem
          Caption = 'English'
          OnClick = mniLanguageEngClick
        end
        object mniLanguageSpa: TMenuItem
          Caption = 'Espa'#241'ol'
          OnClick = mniLanguageSpaClick
        end
        object N1: TMenuItem
          Caption = '-'
        end
        object mniLanguageOther: TMenuItem
          Caption = 'Otra'
          OnClick = mniLanguageOtherClick
        end
      end
    end
    object mniGenerateMCT: TMenuItem
      Caption = 'Generar mct'
      OnClick = mniGenerateMCTClick
    end
  end
  object OpenDialog: TOpenDialog
    Left = 256
    Top = 88
  end
end
