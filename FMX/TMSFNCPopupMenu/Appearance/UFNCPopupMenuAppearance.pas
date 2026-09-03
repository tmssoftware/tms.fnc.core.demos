unit UFNCPopupMenuAppearance;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.TMSFNCPopupMenu, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Menus,
  FMX.TMSFNCCustomComponent, FMX.TMSFNCBitmapContainer;

type
  TForm1 = class(TForm)
    TMSFNCPopupMenu: TTMSFNCPopupMenu;
    Button1: TButton;
    TMSFNCBitmapContainer1: TTMSFNCBitmapContainer;
    Label1: TLabel;
    procedure TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
    procedure TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
    procedure TMSFNCPopupMenuMenuItemControlAdded(Sender: TObject;
      AMenuItemControl: TTMSFNCMenuItemControl);
    procedure TMSFNCPopupMenuMenuItemClick(Sender: TObject;
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
  Form1: TForm1;

implementation

uses
  FMX.TMSFNCGraphicsTypes, FMX.TMSFNCUtils;

{$R *.fmx}

procedure TForm1.ApplyDefaultAppearance;
  procedure ApplySubItemsAppearance(AItems: TTMSFNCMenuItems);
  var
    I: Integer;
  begin
    for I := 0 to AItems.Count - 1 do
    begin
      AItems[I].Appearance.Assign(TMSFNCPopupMenu.Appearance.DefaultItemAppearance);
      if AItems[I].Items.Count > 0 then
        ApplySubItemsAppearance(AItems[I].Items);
    end;
  end;

begin
  ApplySubItemsAppearance(TMSFNCPopupMenu.Items)
end;

procedure TForm1.SetDarkStyle;
begin
  Label1.FontColor := gcWhitesmoke;
  Fill.Color := gcBlack;
  TMSFNCPopupMenu.Appearance.Fill.Color := $FF2B2B2B;
  TMSFNCPopupMenu.Appearance.Stroke.Color := $FF3A3A3A;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.Font.Color := gcWhite;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.SelectedFontColor := gcWhite;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.SelectedFill.Color := $FF373737;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.DisabledFontColor := $FFD0D0D0;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.Separator.Color := $FF393939;

  TMSFNCPopupMenu.Appearance.CheckedIcon := TMSFNCBitmapContainer1.FindBitmap('CheckDark');
  TMSFNCPopupMenu.Appearance.SubMenuIcon := TMSFNCBitmapContainer1.FindBitmap('SubDark');

  ApplyDefaultAppearance;
end;

procedure TForm1.SetLightStyle;
begin
  Label1.FontColor := gcBlack;
  Fill.Color := gcWhite;
  TMSFNCPopupMenu.Appearance.Fill.Color := $FFFCFCFC;
  TMSFNCPopupMenu.Appearance.Stroke.Color := $FFEDEDED;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.Font.Color := $FF1B1B1B;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.SelectedFontColor := $FF1A1A1A;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.SelectedFill.Color := $FFF3F3F3;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.DisabledFontColor := $FF454545;
  TMSFNCPopupMenu.Appearance.DefaultItemAppearance.Separator.Color := $FFECECEC;

  TMSFNCPopupMenu.Appearance.CheckedIcon := TMSFNCBitmapContainer1.FindBitmap('CheckLight');
  TMSFNCPopupMenu.Appearance.SubMenuIcon := TMSFNCBitmapContainer1.FindBitmap('SubLight');

  ApplyDefaultAppearance;
end;

procedure TForm1.TMSFNCPopupMenu1Items3Items0Click(Sender: TObject);
begin
  SetLightStyle;
end;

procedure TForm1.TMSFNCPopupMenu1Items3Items1Click(Sender: TObject);
begin
  SetDarkStyle;
end;

procedure TForm1.TMSFNCPopupMenuMenuItemClick(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
begin
  TTMSFNCUtils.Log(AMenuItemControl.Text + ' Clicked');
end;

procedure TForm1.TMSFNCPopupMenuMenuItemControlAdded(Sender: TObject; AMenuItemControl: TTMSFNCMenuItemControl);
var
  dmi: TTMSFNCMenuItem;
begin
  if AMenuItemControl.Text.StartsWith('Sort') then
  begin
    dmi := TMSFNCPopupMenu.GetCheckedMenuItemByGroupName('GroupBy');

    if Assigned(dmi) then
      AMenuItemControl.Text := 'Sort by ' + dmi.Text;
  end;
end;

end.
