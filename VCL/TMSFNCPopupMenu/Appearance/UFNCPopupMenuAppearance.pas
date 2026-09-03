unit UFNCPopupMenuAppearance;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Menus,
  VCL.TMSFNCPopupMenu, VCL.TMSFNCCustomComponent, VCL.TMSFNCBitmapContainer;

type
  TForm4 = class(TForm)
    TMSFNCPopupMenu1: TTMSFNCPopupMenu;
    Button1: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Label1: TLabel;
    procedure TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
    procedure TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
    procedure TMSFNCPopupMenu1MenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
    procedure TMSFNCPopupMenu1MenuItemClick(Sender: TObject;
      AMenuItemControl: TTMSFNCMenuItemControl);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SetLightStyle;
    procedure SetDarkStyle;
    procedure ApplyDefaultAppearance;
  end;

var
  Form4: TForm4;

implementation
uses
  VCL.TMSFNCUtils;

{$R *.dfm}

procedure TForm4.ApplyDefaultAppearance;
  procedure ApplySubItemsAppearance(AItems: TTMSFNCMenuItems);
  var
    I: Integer;
  begin
    for I := 0 to AItems.Count - 1 do
    begin
      AItems[I].Appearance.Assign(TMSFNCPopupMenu1.Appearance.DefaultItemAppearance);
      if AItems[I].Items.Count > 0 then
        ApplySubItemsAppearance(AItems[I].Items);
    end;
  end;

begin
  ApplySubItemsAppearance(TMSFNCPopupMenu1.Items)
end;

procedure TForm4.SetDarkStyle;
begin
  Color := clBlack;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.AccessoryWidth := 18;
  TMSFNCPopupMenu1.Appearance.Fill.Color := $2B2B2B;
  TMSFNCPopupMenu1.Appearance.Stroke.Color := $3A3A3A;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.Font.Color := clWhite;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.SelectedFontColor := clWhite;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.SelectedFill.Color := $373737;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.DisabledFontColor := $D0D0D0;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.Separator.Color := $393939;

  TMSFNCPopupMenu1.Appearance.CheckedIcon := TMSFNCBitmapContainer1.FindBitmap('CheckDark');
  TMSFNCPopupMenu1.Appearance.SubMenuIcon := TMSFNCBitmapContainer1.FindBitmap('SubDark');

  ApplyDefaultAppearance;
end;

procedure TForm4.SetLightStyle;
begin
  Color := clWhite;
  TMSFNCPopupMenu1.Appearance.Fill.Color := $FCFCFC;
  TMSFNCPopupMenu1.Appearance.Stroke.Color := $EDEDED;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.AccessoryWidth := 18;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.Font.Color := $1B1B1B;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.SelectedFontColor := $1A1A1A;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.SelectedFill.Color := $F3F3F3;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.DisabledFontColor := $454545;
  TMSFNCPopupMenu1.Appearance.DefaultItemAppearance.Separator.Color := $ECECEC;

  TMSFNCPopupMenu1.Appearance.CheckedIcon := TMSFNCBitmapContainer1.FindBitmap('CheckLight');
  TMSFNCPopupMenu1.Appearance.SubMenuIcon := TMSFNCBitmapContainer1.FindBitmap('SubLight');

  ApplyDefaultAppearance;
end;

procedure TForm4.TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
begin
  SetLightStyle;
end;

procedure TForm4.TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
begin
  SetDarkStyle;
end;

procedure TForm4.TMSFNCPopupMenu1MenuItemClick(Sender: TObject;
  AMenuItemControl: TTMSFNCMenuItemControl);
begin
  TTMSFNCUtils.Log(AMenuItemControl.Text + ' Clicked');
end;

procedure TForm4.TMSFNCPopupMenu1MenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  mic: TTMSFNCMenuItem;
begin
  if AMenuItemControl.Text.StartsWith('Sort') then
  begin
    mic := TMSFNCPopupMenu1.GetCheckedMenuItemByGroupName('GroupBy');

    if Assigned(mic) then
      AMenuItemControl.Text := 'Sort by ' + mic.Text;
  end;
end;

end.
