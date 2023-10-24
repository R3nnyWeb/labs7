object Form1: TForm1
  Left = 256
  Top = 135
  Width = 1039
  Height = 809
  Caption = 'Form1'
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
  object Label1: TLabel
    Left = 680
    Top = 664
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Label2: TLabel
    Left = 8
    Top = 648
    Width = 75
    Height = 13
    Caption = #8470' '#1055#1083#1072#1090#1092#1086#1088#1084#1099
  end
  object Image1: TImage
    Left = 0
    Top = 16
    Width = 450
    Height = 375
    AutoSize = True
  end
  object Label3: TLabel
    Left = 352
    Top = 656
    Width = 81
    Height = 13
    Caption = #1050#1086#1083#1074#1086' '#1080#1090#1077#1088#1072#1094#1080#1081
  end
  object Label4: TLabel
    Left = 8
    Top = 673
    Width = 74
    Height = 13
    Caption = #8470' '#1059#1089#1090#1088#1086#1081#1089#1090#1074#1072
  end
  object Image2: TImage
    Left = 450
    Top = 16
    Width = 450
    Height = 377
    AutoSize = True
  end
  object Label5: TLabel
    Left = 536
    Top = 664
    Width = 138
    Height = 13
    Caption = #1054#1073#1097#1077#1077' '#1074#1088#1077#1084#1103' '#1074#1099#1087#1086#1083#1085#1077#1085#1080#1103'-'
  end
  object Label6: TLabel
    Left = 176
    Top = 0
    Width = 71
    Height = 13
    Caption = #1044#1086' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
  end
  object Label7: TLabel
    Left = 624
    Top = 0
    Width = 88
    Height = 13
    Caption = #1055#1086#1089#1083#1077' '#1086#1073#1088#1072#1073#1086#1090#1082#1080
  end
  object Label8: TLabel
    Left = 536
    Top = 688
    Width = 166
    Height = 13
    Caption = #1042' '#1090#1086#1084' '#1095#1080#1089#1083#1077' '#1074#1088#1077#1084#1103' '#1074#1099#1095#1080#1089#1083#1077#1085#1080#1081' -'
  end
  object Label9: TLabel
    Left = 712
    Top = 688
    Width = 6
    Height = 13
    Caption = '0'
  end
  object Button1: TButton
    Left = 128
    Top = 671
    Width = 75
    Height = 25
    Caption = 'Init CL'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 832
    Top = 672
    Width = 75
    Height = 25
    Caption = 'Finit Cl'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 440
    Top = 672
    Width = 75
    Height = 25
    Caption = #1042#1099#1087#1086#1083#1085#1080#1090#1100
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 232
    Top = 672
    Width = 99
    Height = 25
    Caption = 'Load image'
    TabOrder = 3
    OnClick = Button4Click
  end
  object Edit1: TEdit
    Left = 376
    Top = 672
    Width = 41
    Height = 21
    TabOrder = 4
    Text = '1'
  end
  object Edit4: TEdit
    Left = 88
    Top = 648
    Width = 33
    Height = 21
    TabOrder = 5
    Text = '0'
  end
  object Edit2: TEdit
    Left = 88
    Top = 673
    Width = 33
    Height = 21
    TabOrder = 6
    Text = '0'
  end
  object OpenDialog1: TOpenDialog
    Left = 32
    Top = 40
  end
end
