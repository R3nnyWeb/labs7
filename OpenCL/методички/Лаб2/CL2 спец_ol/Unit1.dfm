object Form1: TForm1
  Left = 407
  Top = 203
  Width = 1039
  Height = 418
  Caption = 'OpenCL Image2D Processing'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label3: TLabel
    Left = 680
    Top = 8
    Width = 81
    Height = 13
    Caption = #1050#1086#1083#1074#1086' '#1080#1090#1077#1088#1072#1094#1080#1081
  end
  object Label2: TLabel
    Left = 224
    Top = 9
    Width = 59
    Height = 13
    Caption = 'Kernel name'
  end
  object Label4: TLabel
    Left = 8
    Top = 8
    Width = 59
    Height = 13
    Caption = #1055#1083#1072#1090#1092#1086#1088#1084#1072
  end
  object Label10: TLabel
    Left = 8
    Top = 50
    Width = 60
    Height = 13
    Caption = #1059#1089#1090#1088#1086#1081#1089#1090#1074#1086
  end
  object Label6: TLabel
    Left = 512
    Top = 10
    Width = 139
    Height = 13
    Caption = #1055#1086#1088#1103#1076#1086#1082' '#1087#1077#1088#1077#1076#1072#1095#1080' '#1082#1072#1085#1072#1083#1086#1074
  end
  object Label7: TLabel
    Left = 512
    Top = 50
    Width = 82
    Height = 13
    Caption = #1060#1086#1088#1084#1072#1090' '#1076#1072#1085#1085#1099#1093
  end
  object Button1: TButton
    Left = 224
    Top = 63
    Width = 121
    Height = 25
    Caption = #1048#1085#1080#1094#1080#1072#1083#1080#1079#1072#1094#1080#1103
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 808
    Top = 64
    Width = 129
    Height = 25
    Caption = #1060#1080#1085#1072#1083#1080#1079#1072#1094#1080#1103' OpenCL'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 680
    Top = 64
    Width = 83
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 360
    Top = 64
    Width = 145
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1103
    TabOrder = 3
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 704
    Top = 24
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object Button5: TButton
    Left = 96
    Top = 3
    Width = 65
    Height = 17
    Caption = 'Button5'
    TabOrder = 5
    Visible = False
    OnClick = Button5Click
  end
  object Memo1: TMemo
    Left = -1
    Top = 136
    Width = 1022
    Height = 241
    Lines.Strings = (
      'Memo1')
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object ComboBox1: TComboBox
    Left = 8
    Top = 24
    Width = 201
    Height = 21
    ItemHeight = 13
    TabOrder = 7
    Text = 'ComboBox1'
    OnChange = ComboBox1Change
  end
  object ComboBox2: TComboBox
    Left = 8
    Top = 66
    Width = 201
    Height = 21
    ItemHeight = 13
    TabOrder = 8
    Text = 'ComboBox2'
    OnChange = ComboBox2Change
  end
  object Button6: TButton
    Left = 360
    Top = 104
    Width = 145
    Height = 25
    Caption = #1048#1089#1093#1086#1076#1085#1086#1077' '#1080#1079#1086#1073#1088#1072#1078#1077#1085#1080#1077
    TabOrder = 9
    OnClick = Button6Click
  end
  object Button7: TButton
    Left = 512
    Top = 104
    Width = 145
    Height = 25
    Caption = #1056#1077#1079#1091#1083#1100#1090#1072#1090' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
    TabOrder = 10
    OnClick = Button7Click
  end
  object ComboBox3: TComboBox
    Left = 512
    Top = 26
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 5
    TabOrder = 11
    Text = 'CL_RGBA'
    Items.Strings = (
      '  CL_R'
      'CL_A'
      'CL_RG'
      'CL_RA'
      'CL_RGB'
      'CL_RGBA'
      'CL_BGRA'
      'CL_ARGB'
      'CL_INTENSITY'
      'CL_LUMINANCE'
      'CL_Rx'
      'CL_RGx'
      'CL_RGBx')
  end
  object ComboBox4: TComboBox
    Left = 512
    Top = 66
    Width = 145
    Height = 21
    ItemHeight = 13
    ItemIndex = 10
    TabOrder = 12
    Text = 'CL_UNSIGNED_INT8'
    Items.Strings = (
      'CL_SNORM_INT8'
      'CL_SNORM_INT16'
      'CL_UNORM_INT8'
      'CL_UNORM_INT16'
      'CL_UNORM_SHORT_565'
      'CL_UNORM_SHORT_555'
      'CL_UNORM_INT_101010'
      'CL_SIGNED_INT8'
      'CL_SIGNED_INT16'
      'CL_SIGNED_INT32'
      'CL_UNSIGNED_INT8'
      'CL_UNSIGNED_INT16'
      'CL_UNSIGNED_INT32'
      'CL_HALF_FLOAT'
      'CL_FLOAT')
  end
  object ComboBox5: TComboBox
    Left = 224
    Top = 24
    Width = 121
    Height = 21
    ItemHeight = 13
    ItemIndex = 0
    TabOrder = 13
    Text = 'main'
    Items.Strings = (
      'main')
  end
  object OpenDialog1: TOpenDialog
    Left = 88
    Top = 65528
  end
  object OpenDialog2: TOpenDialog
    Filter = '*.cl'
    Left = 56
    Top = 65528
  end
end
