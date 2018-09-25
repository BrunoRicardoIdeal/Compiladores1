object frmPrincipal: TfrmPrincipal
  Left = 0
  Top = 0
  Caption = 'Principal'
  ClientHeight = 507
  ClientWidth = 819
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object memoFonte: TMemo
    Left = 8
    Top = 8
    Width = 337
    Height = 457
    Lines.Strings = (
      '')
    ReadOnly = True
    TabOrder = 0
  end
  object MemoReconhecido: TMemo
    Left = 424
    Top = 8
    Width = 337
    Height = 457
    Lines.Strings = (
      '')
    ScrollBars = ssVertical
    TabOrder = 1
  end
  object Button1: TButton
    Left = 347
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Button1'
    TabOrder = 2
    OnClick = Button1Click
  end
end
