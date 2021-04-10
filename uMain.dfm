object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Basic CAM'
  ClientHeight = 522
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object paScreen: TPanel
    Left = 0
    Top = 0
    Width = 624
    Height = 480
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
  end
  object Button1: TButton
    Left = 8
    Top = 481
    Width = 49
    Height = 33
    Caption = 'Run'
    TabOrder = 1
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 63
    Top = 481
    Width = 49
    Height = 33
    Caption = 'Stop'
    TabOrder = 2
    OnClick = Button2Click
  end
end
