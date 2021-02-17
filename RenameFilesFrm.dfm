object FrmRenameFiles: TFrmRenameFiles
  Left = 0
  Top = 0
  Caption = 'Renombrar archivos en serie'
  ClientHeight = 241
  ClientWidth = 476
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    476
    241)
  PixelsPerInch = 96
  TextHeight = 13
  object lblFirstFileName: TLabel
    Left = 8
    Top = 11
    Width = 129
    Height = 13
    Caption = 'Nombre del primer archivo:'
  end
  object sbAddFile: TSpeedButton
    Left = 8
    Top = 35
    Width = 23
    Height = 22
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF3E9B462293311D
      74301C6D2E117F213D9646FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF259B3632DB5632D66034D35F20C4411F902EFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF398E4457ED7B41
      E27645E17643D56531813AFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF56A35F5DE37F32C1642EBA5C42C6614C9551FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFF4EB0562AA13841944945914A19912C4EE87153
      EC8550EB8034D158108921458E4A39894220912F459E4EFFFFFFFFFFFF289B34
      40E65D5DF07D5FDF7A40D86145E86F39CE6C39D76D2FD95B36D35A52D67142D4
      641EC23F0D7B1DFFFFFFFFFFFF3990466CFF9260F98C52DA7C50E37B5EF28E5A
      D78D53DB8941DF753ED96E3DC96B36D2673EDD691B6C2DFFFFFFFFFFFF38903C
      76FFA377FA936ED39F63EE7F5FF59150E07956D59046DA7C42D77541CB733AD5
      6C3DDF69126925FFFFFFFFFFFF3BAB475CF08C85FF9F89F0B769F88564FE9951
      E78350E48646E97650E6746EEF8E5EF08036DD581D912EFFFFFFFFFFFF4DB544
      2DA33C48A83D509A5A2AA52562F17E6EF98A5AEF8D3FD563188C2B4A92503D8D
      462094303F9D48FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF66B07084EBB26A
      CF9B49D37B5BDC7B5BA361FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF3C9C317BFF957EFF9A5DF88F53E57535853EFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF36AC455FF38F75
      FEA25FFF8B41E86332A642FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFF49B1403BAB474098443B924E279B3849A752FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = sbAddFileClick
  end
  object sbDeleteFile: TSpeedButton
    Left = 8
    Top = 63
    Width = 23
    Height = 22
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFFFFFFFF
      58634F3E404829371B324321211A47232936252830424D4A18291E1E332A2B3C
      391C282AFFFFFFFFFFFFFFFFFFFFFFFF626863D2DBD1D6CDFFA49ED3D4E9DAA2
      A7CEC7DFC1AFBBC7B2ADF2A89FF59CA2C52E412CFFFFFFFFFFFFFFFFFFFFFFFF
      52545CD8DFDACCBFFF412CA0BDCEE8CDE2FEC2D1F2A0A2E8322F85C6C8FFBAC2
      DF272F3CFFFFFFFFFFFFFFFFFFFFFFFF62656AEEEEFED5DCF09D9AEA362AB2A8
      C7E0B9E2DA3F3FAB351DC39C94F9BFCBE32A333DFFFFFFFFFFFFFFFFFFFFFFFF
      626863D4D5E3F4FFF5C2D9E13734AF3840B12D1FCB252894C3DCF6E8FFF9BCCD
      D0121432FFFFFFFFFFFFFFFFFFFFFFFF51564DC7CCC3F6FFFFDFF9EC94B2C330
      17E9352CC2B8CAFFC1D6F1C2C3FFDEDDFF324629FFFFFFFFFFFFFFFFFFFFFFFF
      656466FAFDEEECECFAEFF9FF293E5D3224CA3928CD27307ABAD0DBE6F1FFCBCF
      E7262D30FFFFFFFFFFFFFFFFFFFFFFFF676271CEC9CAF3F7F13B33743722B4BD
      D4FFBCD1F74039A81F0D82E4E5FFD8E0DF2A2846FFFFFFFFFFFFFFFFFFFFFFFF
      4D5653EEF1F5FBFAFFA2A0B4DBDDE8F6FDFFE5F0FECCD7E5B5C0CEC2CBD8EEF7
      FF313A44FFFFFFFFFFFFFFFFFFFFFFFF414B45DDE1E2F6F3FFFBF9FFFAFCFFEF
      F6F9F4FDFFF3FCFFEBF4FEF4FDFFC2C9D21D242DFFFFFFFFFFFFFFFFFFFFFFFF
      525954E3E5E5E9E8F2FDFAFFEEF0FAF1F9F9EBEFF4F8FCFFCACED3C6CACF7C80
      85202429FFFFFFFFFFFFFFFFFFFFFFFF5F6661E4E7E5F4F1FAF5F3FFF3F5FDFA
      FFFFFDFFFF9395967F818265686C25282C45484CFFFFFFFFFFFFFFFFFFFFFFFF
      4D544DDBDDD7F7F6FAFFFBFFFDFDFFEEF3F2FFFEFD696766C4C4C4FDFFFF9497
      9B34373BF7FBFFFFFFFFFFFFFFFFFFFF474B45F4F7EEFEFCFCFFFDFFFDFEFFFA
      FFFEE6E4E36E6C6BFFFFFF9C9E9F4B4E52FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      595E55D9DAD0CFCECAD7D3D8D0CFD3E8EAEAD7D5D43A3A3A9EA0A14C4F53FFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF656A616264585A575364616359585A46
      49474B4B4B6D6D6D515354FFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = sbDeleteFileClick
  end
  object sbShuffle: TSpeedButton
    Left = 445
    Top = 91
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36030000424D3603000000000000360000002800000010000000100000000100
      18000000000000030000120B0000120B00000000000000000000FFFFFF040400
      0A00060B0C0007002002000F00001F0006000013000000060B080A00000B0000
      1B000A00001600FFFFFF5F8187C4E6E6BEDFD8C1E7CBAABFDABCE6CF8DAAC5A0
      D2BA8591CBA0B3BB000E00000700A7AFCD0000117A878F000018476895D6F5FF
      C0E3FDB6DCE8A8CCE4ACE6C39AC5D68BBEBA241BED8299D7000E00011A0098AC
      B19EB3CE0000126E8F88708888BEDEC6D2E5F2DFF3FECDDEF1BFD2DFC3D4EFAB
      AEF90000E17E9BE0001104A4B3AF0008009AB3C38BA8C300100072749DEFFFE6
      DBE8FECDDDEEC0D3E0C8D4FEC0E6C2BDC6F8ADCAFF9FC8CA000600BFBCD50000
      07A4B4CBA7B3EDA8BDE3597F73C3DCFF6B55FF493EF8B8E5FFBAF3FC91C9D418
      05EE6388A4BDDDD800000EB8AFDAC3CADD0003018DA3B5A3AFD7658590D1F9FF
      ABD7F61613DB3031FF0E10EB343BFF1008FFB3C8E8C4CFEF0000129DA2C1C6DA
      F3000C008CB697ADBED3656D8AE4E8FFD2FFE53A27F23C30FF616FFF2F39E54B
      5BFBC9E0E8B0BED0000900ADCBC69DB8DDBCE6EB0008008B91D25C7488D7FCFF
      FEF4FF817CFF2729FFA6E4D60602F5CED9EFC0E0E6AAC5CF00081493B3C0A4CD
      D6C1E6EE000007ACB2B7669380CDEAFFDFE8EBCAF0FC0C00F46D7DFF2524DECF
      D5FFBED7E1B9CAD7011121A1B8C8A4C4D1C4E1EADBE8F0000006558688E2EBFF
      E1FFFFD9FFE34A4EE90700FB9398F3DDF6FFECFDFFBECBDB00000EA0AEC0C3DA
      EA00000BF6FCFF05000849827AD7DEF11600F0E2FEFFC8E0FF6899DDD4D2FFCB
      E2F8C1D9E5D6E5F500000EA8B6C8A5BCCCCAE0ECCDD7E103000A57818EF4FBFF
      1C00F5E2E3FFCAECDBCBFFE3F3F4FFCFE9F7C5E6EFD7F0FA00000D9EB1C0CDE7
      F55A757F72848BFFFFFF6A7DA0D0D6F9D0F5F1E9E8FFE1F9EDDEE5FFF3FFF9D8
      F6E9CFF2F5C3DBE100000860707C627981FFFFFFFFFFFFFFFFFFFFFFFF748998
      747F8369807B7179907C7A865871756E7D8D6E8686758185000008FFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF
      FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF}
    OnClick = sbShuffleClick
    ExplicitLeft = 416
  end
  object sbMoveUp: TSpeedButton
    Left = 445
    Top = 35
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      080000000000000100000000000000000000000100000000000000000000DC81
      1F00F3C18F00A0410B00C3906300FFE4C600EFA96100B5672B00E0914100BC5D
      0F00C9711E00F5B77900FFCF9C00EA9C5000A9540E00FEDAB400DD883000C297
      7400BB763300D5781300AB622200EEB06D00C2671B00A74C0500C5742900E9A2
      5A00D77D2800F0BA8100E0964900F8C79400E8A96700AC5A1400DF8D3900BD67
      2200D57C1F00AD4D0B00F4B37200DB8A3F00FFE1BF00B55B1100CE732300DB7D
      1900E7974A00D9812D00ECB27300CC752900A6470900E4954400C3976E00E89F
      5500F5BA7E00E89E4B00D97E2300ECA15100DC8A3500EFAB6600E59D51009F45
      0800AD571000C86E2200CD701C00EBA76100D9832900A64E0800C5681D00D981
      2600E18F3B00E4964700EFAE6B00EDA96500CB732700CE752100DD862E00ECA9
      6200CC711E00E69C4F00FDDAB6009F430900E79E5400A7480900C2681C00F5BA
      7D00000000000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000FFFFFF00111111111111
      111111111111111111111111111111111111111111111111111111111111114F
      232E394D03111111111111111111111633012913171111111111111111111140
      1E4134223F111111111111111111113B2C10483E0E1111111111111111111146
      1B4220363A111111111111111111112D02432F081F11111111111111123C2825
      15314B1C142709071111111111180F1D373D194E383521111111111111110A4C
      324445490650111111111111111111472651240B4A1111111111111111111111
      2B050C1A111111111111111111111111112A0D11111111111111111111111111
      1130041111111111111111111111111111111111111111111111}
    OnClick = sbMoveUpClick
    ExplicitLeft = 416
  end
  object sbMoveDown: TSpeedButton
    Left = 445
    Top = 63
    Width = 23
    Height = 22
    Anchors = [akTop, akRight]
    Glyph.Data = {
      36050000424D3605000000000000360400002800000010000000100000000100
      080000000000000100000000000000000000000100000000000000000000D97E
      2100FDC58A00A13E0600C0967600EBA05200B4692F00C58C5000ECAF7000B259
      1000E08E3C00C97F3800D3A77900C86E1E00FFD09B00C9986400F0BC7E00DD96
      5600AD4B0900E7A76000BC641B00DC843100E4964700CC762E00F2C18D00F7B7
      7600C2844000BA6B2400D57B1700C3722900C2906500F0AB6700D1752500AA54
      1000D6822900BB6E2C00A74A0300E69A4E00E08B3300FEC99100B6642400F0B5
      7900C27C3A00EAA35A00DD934800C46C2400F7BA7D00A9500A00A9450600F1BB
      8400C9712A00F8C48D00C1671A00D9883400EEA96200B2550C00F0AF6C00D37A
      1C00A74D0700C36E2000DC8F3E00FAC28900E89D5300EBA66000F4B57700C397
      7400C48F6200E49A4B00A7470800DB852E00C46B2000C9762F00E99F5500CE78
      2F00E08E3900E4944500AB4A0800EFB77A00DD863000C86E2000AA460500AA55
      1100D87D21000000000000000000000000000000000000000000000000000000
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
      00000000000000000000000000000000000000000000FFFFFF00040404040404
      0404040404040404040404040404040404421E04040404040404040404040404
      412A0B04040404040404040404040404150E0C3B040404040404040404040420
      272E190F340404040404040404044F3D40381F360714040404040404041D0233
      293F2B48051A280404040404230D4711183E252C1B0937060404040404040449
      31164B3C5104040404040404040404174D0A4A35210404040404040404040432
      084E45222F040404040404040404042D130152393A0404040404040404040446
      1043261C2404040404040404040404301250444C030404040404040404040404
      0404040404040404040404040404040404040404040404040404}
    OnClick = sbMoveDownClick
    ExplicitLeft = 416
  end
  object lbFiles: TListBox
    Left = 37
    Top = 35
    Width = 402
    Height = 144
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 0
  end
  object btnRename: TButton
    Left = 37
    Top = 208
    Width = 402
    Height = 25
    Anchors = [akLeft, akRight, akBottom]
    Caption = 'Renombrar'
    TabOrder = 1
    OnClick = btnRenameClick
    ExplicitTop = 204
    ExplicitWidth = 541
  end
  object edFirstFilename: TEdit
    Left = 264
    Top = 8
    Width = 175
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 2
    OnChange = edFirstFilenameChange
  end
  object chkShowPreview: TCheckBox
    Left = 37
    Top = 185
    Width = 402
    Height = 17
    Anchors = [akLeft, akBottom]
    Caption = 'Show preview'
    TabOrder = 3
    OnClick = chkShowPreviewClick
  end
end
