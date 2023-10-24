object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'OpenCL_Info'
  ClientHeight = 573
  ClientWidth = 392
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  DesignSize = (
    392
    573)
  PixelsPerInch = 96
  TextHeight = 13
  object LabelCommonPlatform: TLabel
    Left = 8
    Top = 35
    Width = 138
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'LabelCommonPlatform'
  end
  object LabelCommonVersion: TLabel
    Left = 8
    Top = 54
    Width = 133
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'LabelCommonVersion'
  end
  object LabelCommonVendor: TLabel
    Left = 8
    Top = 73
    Width = 132
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'LabelCommonVendor'
  end
  object LabelCommonType: TLabel
    Left = 8
    Top = 92
    Width = 122
    Height = 13
    Anchors = [akLeft, akTop, akRight]
    Caption = 'LabelCommonType'
  end
  object sTreeView1: TTreeView
    Left = 8
    Top = 138
    Width = 376
    Height = 311
    Anchors = [akLeft, akTop, akRight, akBottom]
    Indent = 19
    TabOrder = 0
  end
  object MemoCommonExt: TMemo
    Left = 8
    Top = 464
    Width = 376
    Height = 101
    Anchors = [akLeft, akRight, akBottom]
    Lines.Strings = (
      'MemoCommonExt')
    TabOrder = 1
  end
  object CB_Devices: TComboBox
    Left = 8
    Top = 111
    Width = 376
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    TabOrder = 2
    Text = 'Devices. OpenCL devices available for selected platform.'
    OnChange = CB_DevicesChange
  end
  object CB_Platforms: TComboBox
    Left = 8
    Top = 8
    Width = 376
    Height = 21
    Hint = 
      #1055#1083#1072#1090#1092#1086#1088#1084#1099'. '#1053#1072' '#1093#1086#1089#1090'-'#1089#1080#1089#1090#1077#1084#1077' '#1084#1086#1078#1077#1090' '#1089#1091#1097#1077#1089#1090#1074#1086#1074#1072#1090#1100' '#1085#1077#1089#1082#1086#1083#1100#1082#1086' '#1088#1072#1079#1083#1080#1095#1085#1099 +
      #1093' '#1088#1077#1072#1083#1080#1079#1072#1094#1080#1081' OpenCL '#1074' '#1074#1080#1076#1077' '#1076#1088#1072#1081#1074#1077#1088#1086#1074' ICD.'
    Anchors = [akLeft, akTop, akRight]
    ItemHeight = 13
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    Text = 'Platforms. OpenCL IDC drivers.'
    OnChange = CB_PlatformsChange
  end
  object ImageList1: TImageList
    Left = 320
    Top = 144
    Bitmap = {
      494C010102000400040010001000FFFFFFFFFF10FFFFFFFFFFFFFFFF424D3600
      0000000000003600000028000000400000001000000001002000000000000010
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FDFCFE00FAFAFA00FDFDFD00FFFFFF00FFFFFF00F9F9F900FDFDFD00FDFD
      FD00FFFFFF00FEFEFE00FEFEFE00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00F0F0F0005B5B5B004040
      400041414100494949004B4B4B00535353004A4A4A00515151004D4D4D003D3D
      3D003030300053535300EDEDED00FFFFFF00FFFFFF0017171D00ABADAD00A9AB
      AC001A162100FDFEFC00191B2300FCFCFC00FFFFFF0017162000FFFFFE001A19
      2300050708002020260005040800FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0046464600222222001B1B
      1B00171717001313130016161600121212001010100016161600151515001414
      1400141414002828280052525200FFFFFF00FFFFFF00FFFFFF0019191F00F6F8
      F80019182100FFFFFE0014161E0014131700121415001B1A2400FEFFFD001C1B
      2400FBFBFB00FDFDFD001A1B2500FCFCFC000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00444444000C0C0C000D0D
      0D000F0F0F00121212001010100011111100131313000F0F0F00101010000E0E
      0E000F0F0F000C0C0C0040404000FFFFFF00FFFFFF00FFFFFF0016151E000F11
      1200FDFFFF00FFFFFF001B1A23000B0B1100141519001B1A2300FEFFFD001A19
      2200FFFFFF00F6F6F60014131C00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00383838000D0D0D001010
      1000141414001616160010101000111111001212120015151500101010001515
      15000F0F0F000E0E0E0030303000FFFFFF00FFFFFF00FEFEFE00D1D0D2001518
      1D00FCFFFB00FEFEFE0015171F00FCFEFF00FCFEFE001A1A2000FEFEFE00181A
      22001719210013141800FCFCFC00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF002D2D2D0012121200B8B8
      B8001818180016161600BEBEBE00C1C1C100EBEBEB00C1C1C1008C8C8C005050
      500098989800121212002A2A2A00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF002525250015151500F6F6
      F600FAFAFA00FDFDFD002C2C2C00FFFFFF00FFFFFF009B9B9B0071717100FFFF
      FF001D1D1D001515150026262600FFFFFF00FFFFFF00FFFFFF00FFFFFF00DFEC
      D400DBF3C900D9F6C900D9F5CA00E0F7CB00FCFDF900FFFFFF00FFFFFF00FFFF
      FF00EFF1F100FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0022222200151515001B1B
      1B001C1C1C001D1D1D00231B1C000024140000221200001E0F00012213001D1D
      1D001C1C1C001919190020202000FFFFFF00FFFFFF00FFFFFF00FFFFFF005C96
      29003E9100004091000040910000409100003F930000FAFDF400FEFDFF00CCE6
      B100578E2B00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001D1D1D00191919001D1D
      1D001C1C1C0026604800358B6D001A4131001516140009986100029863001E1E
      1E001B1B1B001A1A1A0018181800FFFFFF00FFFFFF00FFFFFF00FFFFFF005896
      2500409100003D8E03004195010041950100419500003D980000A3CA86004192
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001B1B1B00191919001C1C
      1C001D95720015141800201B1C0019A570003FA58200050D0C00006139001F1F
      1F001E1E1E001A1A1A001A1A1A00FFFFFF00FFFFFF00FFFFFF00FFFFFF005696
      25004091000043930000FCFEFE00FDFFFF00FDFFFF00FFFEFF003C9000004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001C1C1C00191919001A1F
      1E004CE3AB003BD8A50000150B00071412003ED5A3000076450026DE9E001F1F
      1F001E1E1E001A1A1A001A1A1A00FFFFFF00FFFFFF00FFFFFF00FFFFFF005591
      2D004091000043900000FFFFFF00FFFFFF00FFFFFF00FFFEFF00409100004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF001F1F1F001B1B1B001E1E
      1E00202020008FC8B900005B40000F0D0C00B5FFF400A8FEE000A7FFE1002323
      2300242424001C1C1C001F1F1F00FFFFFF00FFFFFF00FFFFFF00FFFFFF00F9FA
      F8004293010043900000FFFFFF00FFFFFF00FFFFFF00FFFEFF00409100004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00262626001E1E1E002626
      26002C2C2C0035353500363636002E3635002F373600303837002E3635003030
      3000252525001B1B1B0025252500FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FEFFFA0044980300FFFEFA00FEFFFB00FFFFFB00FEFFFD00419000004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF0024242400242424003E3E
      3E004B4B4B0057575700606060005F5F5F005F5F5F005C5C5C00585858004E4E
      4E00393939002424240021212100FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FCFCFC0046840C003E9204003E9303003E93030040920400439203004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00262626003838
      3800404040005555550081818100A0A0A000A6A6A6008E8E8E00747474004C4C
      4C003C3C3C0028282800EEEEEE00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF003D9103004192000040910000409100004091000040910000409100004091
      00005B902900FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFF
      FF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FFFFFF00FDFD
      FD00FDFEFC00FBFEFC00FDFEFC00FBFEFC00FDFEFC00FBFEFC00FDFEFC00FBFE
      FC00FDFDFD00FFFFFF00FFFFFF00FFFFFF000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000000000000000000000000000424D3E000000000000003E000000
      2800000040000000100000000100010000000000800000000000000000000000
      000000000000000000000000FFFFFF0000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      0000000000000000000000000000000000000000000000000000000000000000
      000000000000}
  end
end
